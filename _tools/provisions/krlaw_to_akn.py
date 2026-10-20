"""Korean National Law Information Centre (law.go.kr DRF `lawService`, target=eflaw,
type=XML) -> an Akoma Ntoso extract the units reader already reads.

Same shape and rigor as `hklm_to_akn` (one pin shape for every jurisdiction: an `.akn.xml`
extract plus a meta recording the source sha). Korean is the authoritative language; nothing
is translated, normalised or reflowed beyond collapsing whitespace runs (as the HK
converter does).

WHAT THE SOURCE LOOKS LIKE (measured over the 15 local files, 2965 `조문단위`):
  <법령> <기본정보/> <조문> <조문단위 조문키=..> ... </조문> <부칙/> <별표/> <개정문/> <제개정이유/>
  * `조문단위` is flat (never nested). `조문여부` is `조문` (an article: 2621) or `전문` (a
    structural heading such as `제1장 총칙`, `제2절 ...`: 344). A heading has NO usable
    number: its `조문번호` is the chapter/section number and REPEATS (chapter 1 and
    section 1; `제3장의2`), so headings are never units (reported as `headings`).
  * An article: `조문번호` (N), optional `조문가지번호` (M, for 제N조의M), `조문제목`,
    `조문내용` (the header `제N조(제목)` + any text of an article with no 항), then `항`
    children, `조문참고자료` (amendment / future-effective notes).
  * `항` -> optional `항번호` + `항내용` (circled ①..㊿, or `<16>` from paragraph 16 on in
    decrees) and `호` children; `호` -> `호번호` (`1.`, `1의2.`) + `호내용` + `목` children;
    `목` -> `목번호` (`가.` `나.` ...) + `목내용`. Every content string begins with its own
    printed label, and that is cross-checked against the number tag.
  * A `항` WITHOUT `항번호` (198) carries no text of its own, only `호` children (the
    lead-in sits in `조문내용`): the paragraph level is simply not printed there.
  * Nothing is nested below 목 as markup. `1) 2)` sub-sub-items live as lines INSIDE a
    목's text (78 목) and stay part of that 목's text (below).

IDS ARE THE DOCUMENT'S OWN PRINTED NUMBERS (decision D7); never a slug of words:
    art{N}                    제N조            art15
    art{N}-{M}                제N조의M         art28-2   (제28조의2); art64-2; art28-12
    ...-p{K}                  항 K             art15-p1  (① -> 1, ⑳ -> 20, ㉑ -> 21, <16> -> 16)
    ...-i{K}  / ...-i{K}-{L}  호 K / K의L      art2-i1-2 (제2조 제1의2호) -- directly under
                                               the article when the 항 prints no number
    ...-pa{letter}            목 (가 나 다 ..) art15-p1-i2-pa가 ; 가의2 -> pa가-2
REVERSIBLE: tokens after `art` are `digits[-digits]` then levels, each level starting with a
letter (`p<digits>`, `i<digits>[-digits]`, `pa<hangul>[-digits]`); a `-digits` directly after
`art<N>` is always the 가지번호, after `i<K>` always the 의L. Levels are never skipped
except the unprinted 항 above.

DELETED UNITS (`삭제`): a deleted article/항/호/목 that the document still NUMBERS stays a
unit with its text `제4조 삭제` / `② 삭제` (annotation stripped). The number is the
document's, citations to it resolve, and numbering stays contiguous. They are listed in
`report["deleted"]`.

NOT OPERATIVE, LEFT OUT -- and RECORDED so nothing is silently lost:
  * inline amendment annotations inside the content strings: an angle group that is
    an optional Korean keyword + one or more dates, `<개정 2023. 3. 14.>`, `<신설 2020.2.4>`,
    `<2020.8.4>`, `<2002ㆍ12ㆍ30>`, `<개정 2020.7.14, 2025.9.23>` (the comma between dates is optional: the
    source has one `2018.2.13 2021.2.17`). The group and the whitespace
    before it are removed; each removal is listed in `report["annotations"]`. Other angle
    text stays verbatim: `<16>` (a paragraph label), `<img src=..>` / `</img>` wrappers of
    pictured tables, `<납입연수>`.
  * `조문참고자료` (`[본조신설 ...]`, `[전문개정 ...]`, `[제목개정 ...]`, `[제N조에서 이동]`,
    `[시행일: 2027.1.1] 제14조제3항...` future-effective markers) -> `report["notes"]`; the
    `시행일` ones also in `report["future_effective"]`. If such a marker is found INSIDE
    operative text instead it is NOT stripped (no rule is documented for it): it is
    kept verbatim and reported as a problem.
  * `부칙` (addenda), `별표` (annexes), `개정문`, `제개정이유`, `기본정보`: not converted;
    counted in `report["not_converted"]`. 부칙 has no printed unit numbers of its own that
    are unique within the file (every addendum restarts at 제1조), and 별표 bodies are
    fixed-width ASCII drawings plus image links.

DUPLICATES ARE REFUSED. `convert` reports every duplicate eId in the document under
`document_problems` and REFUSES (ValueError) to write an extract whose own subtree
contains one.

`convert(xml, cut=...)` returns (akn_xml, report). `cut` is one eId or a list of eIds
(`["art15", "art28-2"]`); each cut unit's whole subtree is written, in document order. The
report's `missing` lists printed numbers the extract does not carry (must be empty),
`problems` defects inside the emitted subtree (must be empty), `document_problems` defects
anywhere. `check_verbatim` asserts every unit run is a substring of the document's own
text (annotations removed by the rule above, whitespace-insensitive).
"""
import re
import xml.etree.ElementTree as ET
from html import escape

AKN_NS = "http://docs.oasis-open.org/legaldocml/ns/akn/3.0"

_DATE = r"\d{4}\s*[.ㆍ]\s*\d{1,2}\s*[.ㆍ]\s*\d{1,2}\.?"
_ANNOTATION = re.compile(r"\s*<\s*(?:[가-힣]+\s*)?" + _DATE + r"(?:\s*,?\s*" + _DATE + r")*\s*>")
# anything that still LOOKS like an amendment annotation after the rule ran
_LEFTOVER = re.compile(r"<\s*[가-힣]+\s*[^<>]*\d{4}[^<>]*>")
_FUTURE = re.compile(r"\[\s*시행일\s*:")
_NOTE_IN_TEXT = re.compile(r"\[\s*(?:시행일\s*:|본조신설|전문개정|제목개정|본조삭제|종전[^\]]{0,40}이동)")

_ARTICLE_TAGS = frozenset({"조문번호", "조문가지번호", "조문여부", "조문제목", "조문시행일자",
                           "조문제개정유형", "조문이동이전", "조문이동이후", "조문변경여부",
                           "조문내용", "항", "조문참고자료"})
_HANG_TAGS = frozenset({"항번호", "항내용", "호"})
_HO_TAGS = frozenset({"호번호", "호내용", "목"})
_MOK_TAGS = frozenset({"목번호", "목내용"})

_CIRCLED = {}
for _i in range(20):
    _CIRCLED[chr(0x2460 + _i)] = _i + 1          # ① .. ⑳
for _i in range(15):
    _CIRCLED[chr(0x3251 + _i)] = 21 + _i         # ㉑ .. ㉟
for _i in range(15):
    _CIRCLED[chr(0x32B1 + _i)] = 36 + _i         # ㊱ .. ㊿


def _ws(s):
    return re.sub(r"\s+", " ", s.replace("\xa0", " ")).strip()


def _strip_annotations(s):
    """(text with annotation groups removed, [removed groups])."""
    found = [m.group(0).strip() for m in _ANNOTATION.finditer(s)]
    return _ANNOTATION.sub("", s), found


def _hang_number(label):
    label = (label or "").strip()
    if label in _CIRCLED:
        return _CIRCLED[label]
    m = re.fullmatch(r"<\s*(\d+)\s*>", label)
    return int(m.group(1)) if m else None


def _ho_number(label):
    m = re.fullmatch(r"(\d+)(?:의(\d+))?\.?", (label or "").strip())
    if not m:
        return None
    return m.group(1) + (f"-{m.group(2)}" if m.group(2) else "")


def _mok_number(label):
    m = re.fullmatch(r"([가-힣])(?:의(\d+))?\.", (label or "").strip())
    if not m:
        return None
    return m.group(1) + (f"-{m.group(2)}" if m.group(2) else "")


class _Unit:
    def __init__(self, eid, text, derived=False):
        self.eid, self.text, self.derived, self.kids = eid, text, derived, []


class _Walker:
    def __init__(self):
        self.top = []
        self.problems = []        # (owning unit eid or None, message)
        self.printed = []         # (descriptor, eid-or-None): every number the doc prints
        self.annotations = []     # (eid, removed group)
        self.notes = []           # (eid, 조문참고자료 text)
        self.future = []          # (eid, line)
        self.deleted = []
        self.headings = 0
        self.articles = 0
        self.jeonmun_numbers = []

    def problem(self, owner, msg):
        self.problems.append((owner, msg))

    def _text(self, el, owner):
        """The element's own text (annotations removed, whitespace collapsed). A
        content element must hold only text."""
        raw = el.text or ""
        for k in el:
            self.problem(owner, f"unexpected element <{k.tag}> inside <{el.tag}>")
        s, found = _strip_annotations(raw)
        for g in found:
            self.annotations.append((owner, g))
        s = _ws(s)
        if _LEFTOVER.search(s):
            self.problem(owner, f"text still holds an annotation-looking group: "
                                f"{_LEFTOVER.search(s).group(0)!r}")
        if _NOTE_IN_TEXT.search(s):
            self.problem(owner, f"note / future-effective marker inside operative text "
                                f"(kept verbatim): {_NOTE_IN_TEXT.search(s).group(0)!r}")
        return s

    def _make(self, owner_list, eid, text):
        u = _Unit(eid, text)
        owner_list.append(u)
        if re.fullmatch(r"(?:\S+ )?삭제", text) and text.endswith("삭제") and len(text) < 20:
            self.deleted.append(eid)
        return u

    def article(self, el):
        status = (el.findtext("조문여부") or "").strip()
        if status == "전문":
            self.headings += 1
            return
        if status != "조문":
            self.problem(None, f"조문단위 {el.get('조문키')!r} has 조문여부 {status!r}")
            return
        self.articles += 1
        n = (el.findtext("조문번호") or "").strip()
        b = (el.findtext("조문가지번호") or "").strip()
        desc = f"제{n}조" + (f"의{b}" if b else "")
        if not n.isdigit() or (b and not b.isdigit()):
            self.problem(None, f"{desc}: 조문번호/조문가지번호 is not a number")
            self.printed.append((desc, None))
            return
        eid = f"art{int(n)}" + (f"-{int(b)}" if b else "")
        self.printed.append((desc, eid))
        for k in el:
            if k.tag not in _ARTICLE_TAGS:
                self.problem(eid, f"unexpected element <{k.tag}> inside 조문단위")
        c = el.find("조문내용")
        if c is None:
            self.problem(eid, "article has no 조문내용")
            text = ""
        else:
            text = self._text(c, eid)
            if not re.match(rf"제{int(n)}조{'의' + str(int(b)) if b else ''}(?!\d|의)", text):
                self.problem(eid, f"조문내용 begins {text[:12]!r}, not the printed number {desc}")
        u = self._make(self.top, eid, text)
        for ref in el.findall("조문참고자료"):
            t = (ref.text or "").strip()
            self.notes.append((eid, t))
            self.future.extend((eid, ln.strip()) for ln in t.splitlines() if _FUTURE.search(ln))
        for h in el.findall("항"):
            self.hang(h, u, eid)

    def hang(self, el, art, art_eid):
        for k in el:
            if k.tag not in _HANG_TAGS:
                self.problem(art_eid, f"unexpected element <{k.tag}> inside 항")
        label_el, content_el = el.find("항번호"), el.find("항내용")
        if label_el is None:
            if content_el is not None and (content_el.text or "").strip():
                self.problem(art_eid, "항 with text but no 항번호")
                self.printed.append((f"{art_eid} unnumbered 항", None))
            parent, pid, derived = art, art_eid, True
        else:
            label = (label_el.text or "").strip()
            k = _hang_number(label)
            if k is None:
                self.problem(art_eid, f"항번호 {label!r} is not a circled digit or <N>")
                self.printed.append((f"{art_eid} 항 {label}", None))
                return
            eid = f"{art_eid}-p{k}"
            self.printed.append((f"{art_eid} 항 {label}", eid))
            text = self._text(content_el, eid) if content_el is not None else ""
            if content_el is None:
                self.problem(eid, "항 has no 항내용")
            elif not text.startswith(label) and not text.startswith(f"<{k}>"):
                self.problem(eid, f"항내용 begins {text[:6]!r}, not its 항번호 {label!r}")
            parent, pid, derived = self._make(art.kids, eid, text), eid, False
        for o in el.findall("호"):
            self.ho(o, parent, pid, derived)

    def ho(self, el, parent, pid, derived):
        for k in el:
            if k.tag not in _HO_TAGS:
                self.problem(pid, f"unexpected element <{k.tag}> inside 호")
        label_el, content_el = el.find("호번호"), el.find("호내용")
        label = (label_el.text or "").strip() if label_el is not None else ""
        k = _ho_number(label)
        if k is None:
            self.problem(pid, f"호번호 {label!r} is not N. or N의M.")
            self.printed.append((f"{pid} 호 {label}", None))
            return
        eid = f"{pid}-i{k}"
        self.printed.append((f"{pid} 호 {label}", eid))
        text = self._text(content_el, eid) if content_el is not None else ""
        if content_el is None:
            self.problem(eid, "호 has no 호내용")
        elif not text.startswith(label.rstrip(".")):
            self.problem(eid, f"호내용 begins {text[:6]!r}, not its 호번호 {label!r}")
        u = self._make(parent.kids, eid, text)
        u.derived = derived          # id elides the unprinted 항 level
        for m in el.findall("목"):
            self.mok(m, u, eid)

    def mok(self, el, parent, pid):
        for k in el:
            if k.tag not in _MOK_TAGS:
                self.problem(pid, f"unexpected element <{k.tag}> inside 목")
        label_el, content_el = el.find("목번호"), el.find("목내용")
        label = (label_el.text or "").strip() if label_el is not None else ""
        k = _mok_number(label)
        if k is None:
            self.problem(pid, f"목번호 {label!r} is not a Korean letter + '.'")
            self.printed.append((f"{pid} 목 {label}", None))
            return
        eid = f"{pid}-pa{k}"
        self.printed.append((f"{pid} 목 {label}", eid))
        text = self._text(content_el, eid) if content_el is not None else ""
        if content_el is None:
            self.problem(eid, "목 has no 목내용")
        elif not text.startswith(label.rstrip(".")):
            self.problem(eid, f"목내용 begins {text[:6]!r}, not its 목번호 {label!r}")
        self._make(parent.kids, eid, text)


def _iter_units(units):
    for u in units:
        yield u
        yield from _iter_units(u.kids)


def _emit(unit, out, indent):
    pad = "  " * indent
    out.append(f'{pad}<hcontainer eId="{escape(unit.eid)}">')
    if unit.text:
        out.append(f"{pad}  <p>{escape(unit.text)}</p>")
    for k in unit.kids:
        _emit(k, out, indent + 1)
    out.append(f"{pad}</hcontainer>")


def _parse(xml):
    data = xml.encode("utf-8") if isinstance(xml, str) else xml
    head = data[:4096].lower()
    if b"<!doctype" in head or b"<!entity" in data[:65536].lower():
        raise ValueError("DOCTYPE / ENTITY declarations are refused (untrusted input)")
    root = ET.fromstring(data)
    if root.tag != "법령":
        raise ValueError(f"not a law.go.kr eflaw document: root is {root.tag}")
    if root.find("조문") is None:
        raise ValueError("law.go.kr document has no <조문>")
    return root


def _meta(root):
    g = lambda p: (root.findtext(p) or "").strip() or None
    return {"doc_name": g("기본정보/법령명_한글"), "identifier": g("기본정보/법령ID"),
            "version_date": g("기본정보/시행일자"), "promulgation_date": g("기본정보/공포일자"),
            "promulgation_no": g("기본정보/공포번호"), "kind": g("기본정보/법종구분")}


def convert(xml, name="krlaw", cut=None):
    """`cut`: one eId or a list of eIds; the extract then holds only those units'
    subtrees (document order). Document-level checks run over the WHOLE document either
    way and land in `document_problems`."""
    root = _parse(xml)
    w = _Walker()
    for el in root.find("조문").findall("조문단위"):
        w.article(el)
    units = list(_iter_units(w.top))
    counts = {}
    for u in units:
        counts[u.eid] = counts.get(u.eid, 0) + 1
    dup = sorted(e for e, n in counts.items() if n > 1)
    emitted = {u.eid for u in units}
    missing = sorted({d for d, e in w.printed if e is None or e not in emitted})
    document_problems = [m for _, m in w.problems] + [
        f"duplicate eId {e!r} ({counts[e]}x)" for e in dup]
    emit, scope = w.top, units
    if cut is not None:
        wanted = [cut] if isinstance(cut, str) else list(cut)
        emit, seen = [], set()
        for c in wanted:
            found = [u for u in units if u.eid == c]
            if not found:
                raise ValueError(f"cut {c!r}: no such unit in this document")
            if len(found) > 1:
                raise ValueError(f"cut {c!r}: the document has {len(found)} units with this id")
            seen.add(c)
        # document order; a unit already inside a cut ancestor is not written twice
        inside = set()
        for u in units:
            if u.eid in seen and u.eid not in inside:
                emit.append(u)
                inside.update(x.eid for x in _iter_units(u.kids))
        scope = [x for u in emit for x in _iter_units([u])]
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
    report = {"units": len(units), "printed": len(w.printed), "articles": w.articles,
              "headings": w.headings, "missing": missing,
              "derived": [u.eid for u in scope if u.derived],
              "derived_levels": ["항 (unnumbered, elided from the id)"],
              "problems": problems, "document_problems": document_problems,
              "extract_units": len(scope),
              "deleted": [e for e in w.deleted if e in scope_ids],
              "annotations": [(o, g) for o, g in w.annotations if o in scope_ids],
              "notes": [(o, t) for o, t in w.notes if o in scope_ids],
              "future_effective": [(o, t) for o, t in w.future if o in scope_ids],
              "not_converted": {"부칙": len(root.findall("부칙/부칙단위")),
                                "별표": len(root.findall("별표/별표단위"))},
              **_meta(root)}
    return "\n".join(out), report


def document_text(xml):
    """The document's operative text: every article's text nodes in document order
    (`조문참고자료` excluded, headings excluded), annotations removed by the documented
    rule, whitespace-normalised. Read by a traversal independent of the walker's."""
    root = _parse(xml)
    parts = []
    for el in root.find("조문").findall("조문단위"):
        if (el.findtext("조문여부") or "").strip() != "조문":
            continue

        def walk(e):
            parts.append(e.text or "")
            for k in e:
                if k.tag != "조문참고자료":
                    walk(k)
                parts.append(k.tail or "")
        walk(el)
    text, _ = _strip_annotations(" ".join(parts))
    return _ws(text)


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
