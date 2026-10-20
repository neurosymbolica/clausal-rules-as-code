"""Hong Kong e-Legislation (HKLM XML, the DoJ bulk data on data.gov.hk) -> an Akoma Ntoso
extract the units reader already reads.

WHY A CONVERTER AND NOT A PROFILE. HKLM is XML, so a `units.py` profile could read it,
but its id attribute is not unique on its own (below), and the SG pins already set the
shape of a converted pin: an `.akn.xml` extract plus a meta recording the source sha. One
pin shape for both jurisdictions keeps `load_sources`, the ledger and the binder unchanged.

THE IDS ARE THE DOCUMENT'S OWN. HKLM prints a `temporalId` on nearly every provision
element (`s15K_2_a` is Cap. 112 s 15K(2)(a); `sch17FC_P2_s3` is Sch 17FC Part 2 s 3;
`P4_D3A` is Part 4 Division 3A). It survives amendment, unlike `@id` (regenerated per
version), so it is the id written here as the Akoma Ntoso `eId`, unchanged.

ONE LEVEL IS DERIVED: a definition. A `<def>` carries no temporalId, only its own
`@name` (`ActivePartner`), and the paragraphs INSIDE a definition reuse the temporalId
of the subsection they sit in: in Cap. 112 s 2(1) nineteen definitions each have a
paragraph `s2_1_a`. So a definition's id is its parent's id + `_def` + `@name`
(`s2_1_defAgent`), and an element inside it takes that id + the rest of its own
temporalId beyond the parent's (`s2_1_defAgent_a`). The `@name` is the document's
own attribute, not a slug of the term's words. Every derivation is CHECKED: an element's
temporalId must extend the temporalId its enclosing unit stands for, or it is a problem.

DUPLICATES ARE REFUSED (decision D7, 2026-10-03). Some temporalIds repeat even outside
definitions (Cap. 112 2026-05-22: s16H(1)(a)/(b) seven times, s37(2)(a)/(b), the whole
of Sch 61, whose sections print no number). `convert` reports every duplicate in the
document under `document_problems`, and REFUSES (ValueError) to write an extract whose
own subtree contains one. So a pin is possible exactly where the document's ids are
unambiguous.

NOT OPERATIVE TEXT, LEFT OUT (as SSO amendment notes and Formex NOTEs are):
`sourceNote` / `editorialNote` / `statutoryNote` (amendment history), `note` / `notes`
("Note-- See subsection (2I) ..."), `crossHeading` (includes "Note without legislative
effect ..."), `commencementNote`, and `meta`. Elements inside them never open a unit.
`continued` (the text after a list, "but does not include ...") is its parent's text, not
a unit of its own, even where it carries a temporalId. `quotedStructure` /
`quotedText` stay text (no unit opens inside quoted text).

`convert(xml, cut=...)` returns (akn_xml, report). The report's `missing` lists the
temporalIds the extract does not carry (must be empty), `derived` lists the derived
ids, `problems` the defects inside the emitted subtree (must be empty; a duplicate there
raises), and `document_problems` the defects anywhere in the document.
`check_verbatim` asserts that every unit run is a substring of the document's own text.
"""
import re
import xml.etree.ElementTree as ET
from html import escape

AKN_NS = "http://docs.oasis-open.org/legaldocml/ns/akn/3.0"
HKLM_NS = "http://www.xml.gov.hk/schemas/hklm/1.0"

_EXCLUDED = frozenset({"sourceNote", "editorialNote", "statutoryNote", "note", "notes",
                       "crossHeading", "commencementNote", "meta"})
_SUFFIX = re.compile(r"-[0-9]+$")
_TEXT_ONLY = frozenset({"continued", "quotedStructure", "quotedText"})
# HKLM's inline elements: their text joins the surrounding sentence with no separator.
# Every other element is a block, and a space separates it from its neighbours.
_INLINE = frozenset({"ref", "term", "b", "i", "u", "sub", "sup", "span", "inline",
                     "shortTitle", "marker", "abbr", "date", "a"})


def _local(tag):
    return tag.rsplit("}", 1)[-1] if isinstance(tag, str) else ""


def _ws(s):
    return re.sub(r"\s+", " ", s.replace("\xa0", " ")).strip()


class _Unit:
    def __init__(self, eid, basis, num=None, heading=None, derived=False):
        self.eid, self.basis, self.num, self.heading = eid, basis, num, heading
        self.derived, self.items = derived, []

    def add_text(self, s):
        if self.items and isinstance(self.items[-1], str):
            self.items[-1] += s
        else:
            self.items.append(s)


class _Walker:
    """Builds the unit tree. `basis` is the temporalId a unit's id stands for: equal to
    the id outside definitions, and the enclosing temporalId inside one, so a child's id
    inside a definition is its parent's id + the part of its own temporalId beyond the
    parent's basis."""

    def __init__(self):
        self.top = []
        self.problems = []      # (unit eid or None, message)
        self.printed = []       # every temporalId that should open a unit

    def _child_id(self, parent, tid):
        # temporalIds are NOT hierarchical across levels (section `s2` sits in part `P1`),
        # so outside a definition the id is the temporalId as printed; only inside one is
        # it composed, and only there is the prefix checked
        if parent is None or not parent.derived:
            return tid
        # a temporalId may carry a `-N` suffix (`s39E_5_a-3`) that its children do not
        # repeat (`s39E_5_a_i-1`): the prefix is checked against the basis without it
        stem = _SUFFIX.sub("", parent.basis)
        if not tid.startswith(stem + "_"):
            self.problems.append((parent.eid, f"temporalId {tid} sits inside "
                                              f"{parent.eid} but does not extend "
                                              f"{stem}"))
            return None
        return parent.eid + tid[len(stem):]

    def walk(self, el, unit):
        for k in el:
            tag = _local(k.tag)
            if tag in _EXCLUDED:
                self._tail(k, unit)
                continue
            if tag in ("num", "heading") and unit is not None and _local(el.tag) != "def" \
                    and getattr(unit, "_el", None) is el:
                text = _ws("".join(k.itertext()))
                if tag == "num":
                    unit.num = text
                else:
                    unit.heading = text
                self._tail(k, unit)
                continue
            tid = k.get("temporalId")
            if tag == "def":
                if unit is None:
                    self.problems.append((None, f"definition {k.get('name')!r} outside any unit"))
                    self.walk(k, unit)
                elif not k.get("name"):
                    self.problems.append((unit.eid, "definition with no @name"))
                    self.walk(k, unit)
                else:
                    d = _Unit(f"{unit.eid}_def{k.get('name')}", unit.basis, derived=True)
                    d._el = k
                    unit.items.append(d)
                    self.walk(k, d)
                self._tail(k, unit)
                continue
            if tid and tag not in _TEXT_ONLY:
                self.printed.append(tid)
                eid = self._child_id(unit, tid)
                if eid is None:
                    self.walk(k, unit)
                    self._tail(k, unit)
                    continue
                u = _Unit(eid, tid, derived=(eid != tid))
                u._el = k
                (unit.items if unit is not None else self.top).append(u)
                self.walk(k, u)
                self._tail(k, unit)
                continue
            if tag in _TEXT_ONLY:
                self._text_only(k, unit)
                self._tail(k, unit)
                continue
            block = tag not in _INLINE
            if block:
                self._text(unit, " ")
            self._text(unit, k.text)
            self.walk(k, unit)
            if block:
                self._text(unit, " ")
            self._tail(k, unit)

    def _text_only(self, el, unit):
        """Text of EL and its descendants, minus excluded subtrees; no unit opens here."""
        self._text(unit, " ")
        self._text(unit, el.text)
        for k in el:
            if _local(k.tag) not in _EXCLUDED:
                self._text_only(k, unit)
            self._tail(k, unit)
        self._text(unit, " ")

    def _tail(self, el, unit):
        self._text(unit, el.tail)

    def _text(self, unit, s):
        if unit is not None and s:
            unit.add_text(s)

    def run(self, main):
        self.walk(main, None)


def _iter_units(units):
    for u in units:
        yield u
        yield from _iter_units([i for i in u.items if isinstance(i, _Unit)])


def _emit(unit, out, indent):
    pad = "  " * indent
    out.append(f'{pad}<hcontainer eId="{escape(unit.eid)}">')
    if unit.num:
        out.append(f"{pad}  <num>{escape(unit.num)}</num>")
    if unit.heading:
        out.append(f"{pad}  <heading>{escape(unit.heading)}</heading>")
    for item in unit.items:
        if isinstance(item, str):
            t = _ws(item)
            if t:
                out.append(f"{pad}  <p>{escape(t)}</p>")
        else:
            _emit(item, out, indent + 1)
    out.append(f"{pad}</hcontainer>")


def _main(root):
    if not isinstance(root.tag, str) or not root.tag.startswith("{" + HKLM_NS + "}"):
        raise ValueError(f"not an HKLM document: root is {root.tag}")
    main = root.find(f"{{{HKLM_NS}}}main")
    if main is None:
        raise ValueError("HKLM document has no <main>")
    return main


def _meta(root):
    def get(path):
        el = root.find(path)
        return el.text.strip() if el is not None and el.text else None
    return {"doc_name": get(f"{{{HKLM_NS}}}meta/{{{HKLM_NS}}}docName"),
            "identifier": get(f"{{{HKLM_NS}}}meta/{{http://purl.org/dc/elements/1.1/}}identifier"),
            "version_date": get(f"{{{HKLM_NS}}}meta/{{http://purl.org/dc/elements/1.1/}}date")}


def convert(xml, name="hklm", cut=None):
    """`cut`: the eId of ONE unit; the extract then holds only that unit's subtree (the
    smallest document-native element covering a domain's scope). The document-level
    checks run over the WHOLE document either way and land in `document_problems`."""
    root = ET.fromstring(xml.encode("utf-8") if isinstance(xml, str) else xml)
    main = _main(root)
    w = _Walker()
    w.run(main)
    units = list(_iter_units(w.top))
    eids = [u.eid for u in units]
    counts = {}
    for e in eids:
        counts[e] = counts.get(e, 0) + 1
    dup = sorted(e for e, n in counts.items() if n > 1)
    missing = sorted(set(w.printed) - {u.basis for u in units})
    document_problems = [m for _, m in w.problems] + [f"duplicate eId {e!r} ({counts[e]}x)"
                                                       for e in dup]
    emit, scope = w.top, units
    if cut is not None:
        found = [u for u in units if u.eid == cut]
        if not found:
            raise ValueError(f"cut {cut!r}: no such unit in this document")
        if len(found) > 1:
            raise ValueError(f"cut {cut!r}: the document has {len(found)} units with this id")
        emit = found
        scope = list(_iter_units(found))
    scope_ids = {u.eid for u in scope}
    problems = [m for owner, m in w.problems
                if owner is not None and (owner in scope_ids or cut is None)]
    scope_dup = sorted({u.eid for u in scope if counts[u.eid] > 1})
    if scope_dup:
        raise ValueError(f"duplicate eIds inside the extract (refused, decision D7): "
                         f"{scope_dup[:10]}")
    out = ['<?xml version="1.0" encoding="UTF-8"?>',
           f'<akomaNtoso xmlns="{AKN_NS}">', f'  <act name="{escape(name)}">', "    <body>"]
    for u in emit:
        _emit(u, out, 3)
    out += ["    </body>", "  </act>", "</akomaNtoso>", ""]
    report = {"units": len(units), "printed": len(w.printed), "missing": missing,
              "derived": [u.eid for u in scope if u.derived], "derived_levels": ["def"],
              "problems": problems, "document_problems": document_problems,
              "extract_units": len(scope), **_meta(root)}
    return "\n".join(out), report


def _operative_text(el, out):
    out.append(el.text or "")
    for k in el:
        if _local(k.tag) not in _EXCLUDED:
            _operative_text(k, out)
        out.append(k.tail or "")


def document_text(xml):
    """The document's operative text (<main> minus the excluded notes, whose tails are
    kept), whitespace-normalised, for the verbatim check. A note sitting mid-sentence (an
    amendment `sourceNote` inside a `content`) is not part of the sentence, so a run that
    spans it is compared against the text with the note removed."""
    root = ET.fromstring(xml.encode("utf-8") if isinstance(xml, str) else xml)
    out = []
    _operative_text(_main(root), out)
    return _ws(" ".join(out))


def check_verbatim(xml, units):
    """Runs of `units` (units.parse_units output) that are NOT substrings of the document
    (whitespace-insensitive)."""
    squashed = re.sub(r"\s+", "", document_text(xml))
    bad = []
    for u in units:
        for run in u.runs:
            if re.sub(r"\s+", "", run.text) not in squashed:
                bad.append((u.id, run.text[:80]))
    return bad
