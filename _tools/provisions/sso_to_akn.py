"""Singapore Statutes Online (SSO) provision pages -> an Akoma Ntoso extract the units
reader already reads.

WHY A CONVERTER AND NOT A PROFILE. `units.py` reads XML, and an SSO page is HTML5 (void
`<br>`/`<input>`, bare entities), so no parse-as-XML profile can read the page itself.
SSO does, however, print a document-native id on almost every provision element
(`pr6-ps5-p1a-p2ii-p3B-` is PSA 2019 s 6(5)(a)(ii)(B)). This module walks the page's
structure and writes those ids, unchanged except for the trailing `-`, as Akoma Ntoso
`eId`s. Nothing is slugged out of free text.

THE STRUCTURE IS THE PAGE'S OWN. SSO nests each level inside its parent's text cell:
  * a section starts at `<td class="prov1Hdr" id="prN-">` (its heading); a schedule at
    `<td class="sHdr" id="ScN-">`;
  * a subsection starts at an `<a name="prN-psK-">` anchor and runs to the next one;
  * every lower level is a table ROW whose first cell's class ends in `No` (`p1No`,
    `p2No`, `p3No`, `sProvP1No`, ...) holding the printed label; the next cell holds the
    level's own text, with any deeper rows nested inside it;
  * a schedule paragraph is a `tailSTxt` cell that opens with its printed number (`2.`).
TWO LEVELS PRINT NO ID OF THEIR OWN: a lettered paragraph row (`(a)`) and a schedule
paragraph. Their ids are DERIVED the way SSO derives its children's ids -- parent +
`-p1` + label, and schedule + `-s1` + number -- and every derivation is CHECKED: a
derived id must be the prefix of every printed id beneath it (`convert` refuses
otherwise). Amendment notes (`amendNote`) are not operative text and are left out, as
footnote bodies are in the other formats.

`convert(html)` returns (akn_xml, report). `report["missing"]` lists printed SSO ids the
extract does not carry (must be empty); `check_verbatim` asserts every unit run is a
substring of the page's own text.
"""
import re
from html import escape
from html.parser import HTMLParser

AKN_NS = "http://docs.oasis-open.org/legaldocml/ns/akn/3.0"
_VOID = {"br", "img", "hr", "input", "meta", "link", "col", "area", "base", "wbr",
         "source", "param", "embed", "track"}
_SSO_ID = re.compile(r"^(?:pr|Sc)[0-9A-Za-z_]+(?:-[0-9A-Za-z_]+)*-$")
_SKIP_TAGS = {"script", "style", "noscript", "button", "select", "option", "textarea"}


class _Node:
    __slots__ = ("tag", "attrs", "kids")

    def __init__(self, tag, attrs):
        self.tag, self.attrs, self.kids = tag, attrs, []

    def cls(self):
        return (self.attrs.get("class") or "").split()

    def text(self):
        out = []
        for k in self.kids:
            out.append(k if isinstance(k, str) else k.text())
        return "".join(out)


class _Builder(HTMLParser):
    def __init__(self):
        super().__init__(convert_charrefs=True)
        self.root = _Node("#root", {})
        self.stack = [self.root]

    def handle_starttag(self, tag, attrs):
        node = _Node(tag, {k: (v or "") for k, v in attrs})
        self.stack[-1].kids.append(node)
        if tag not in _VOID:
            self.stack.append(node)

    def handle_startendtag(self, tag, attrs):
        self.stack[-1].kids.append(_Node(tag, {k: (v or "") for k, v in attrs}))

    def handle_endtag(self, tag):
        for i in range(len(self.stack) - 1, 0, -1):
            if self.stack[i].tag == tag:
                del self.stack[i:]
                return

    def handle_data(self, data):
        self.stack[-1].kids.append(data)


def _parse_html(html):
    b = _Builder()
    b.feed(html)
    b.close()
    return b.root


def _ws(s):
    return re.sub(r"\s+", " ", s.replace("\xa0", " ")).strip()


class _Unit:
    def __init__(self, eid, num=None, heading=None):
        self.eid, self.num, self.heading, self.items = eid, num, heading, []

    def add_text(self, s):
        if self.items and isinstance(self.items[-1], str):
            self.items[-1] += s
        else:
            self.items.append(s)


def _label(text):
    """`(a)` / `( a )` / `(ii)` / `2.` -> `a` / `ii` / `2`."""
    t = _ws(text)
    m = re.match(r"^\(?\s*([0-9A-Za-z]+)\s*[).]?$", t)
    return m.group(1) if m else None


_CONTAINER = re.compile(r"^Sc[0-9A-Za-z]+(?:-S[0-9_]+)?$")   # a schedule, or one of its Parts


def _printed(node):
    """NODE's own printed SSO id, minus the trailing `-`, or None (the schedule's
    reference line and subtitle carry ids too, `-rf-` / `-he-`, but name no provision)."""
    ident = node.attrs.get("id") or (node.attrs.get("name") if node.tag == "a" else "")
    if ident and _SSO_ID.match(ident) and not re.search(r"-(?:rf|he)-$", ident):
        return ident[:-1]
    return None


def _term_slug(term):
    """SSO's own spelling of a defined term inside an id: ASCII letters and digits kept
    (lowercased), any other ASCII dropped, and a NON-ASCII character written as its
    decimal code point -- `limited purpose e\u2011money` is `limitedpurposee8209money`
    (PSA 2019 First Schedule), the non-breaking hyphen surviving as 8209."""
    out = []
    for ch in term.lower():
        if ch.isascii():
            if ch.isalnum():
                out.append(ch)
        else:
            out.append(str(ord(ch)))
    return "".join(out)


def _first_printed_below(node):
    todo = list(reversed(node.kids))
    while todo:
        n = todo.pop()
        if isinstance(n, _Node):
            e = _printed(n)
            if e:
                return e
            todo.extend(reversed(n.kids))
    return None


class _Walker:
    """Builds the unit tree. NESTING IS BY ID PREFIX: a unit opens under the deepest open
    unit whose id its own extends, which is how SSO composes ids at every level -- so no
    per-class nesting rule is needed for printed ids."""

    def __init__(self):
        self.top = []
        self.stack = []
        self.problems = []

    def _open(self, eid, num=None, heading=None):
        while self.stack and not eid.startswith(self.stack[-1].eid + "-"):
            self.stack.pop()
        unit = _Unit(eid, num=num, heading=heading)
        (self.stack[-1].items if self.stack else self.top).append(unit)
        self.stack.append(unit)
        return len(self.stack)

    def _close_to(self, depth):
        del self.stack[depth:]

    def _text(self, s):
        if self.stack and s:
            self.stack[-1].add_text(s)

    def _row_id(self, row, label):
        """A lettered row prints no id: take it from a printed id beneath it (the
        segment `p<level><label>`), else compose parent + `-p<level>` + label."""
        below = _first_printed_below(row)
        if below:
            segs = below.split("-")
            for i, seg in enumerate(segs):
                if re.fullmatch(rf"p[0-9]+{re.escape(label)}", seg) and "-".join(segs[:i]) \
                        and (not self.stack or below.startswith(self.stack[-1].eid)):
                    cand = "-".join(segs[:i + 1])
                    if not self.stack or cand.startswith(self.stack[-1].eid + "-"):
                        return cand
        parent = self.stack[-1].eid
        m = re.search(r"-p([0-9]+)[0-9A-Za-z]+$", parent)
        level = int(m.group(1)) + 1 if m else 1
        return f"{parent}-p{level}{label}"

    def walk(self, node):
        for k in node.kids:
            if isinstance(k, str):
                self._text(k)
                continue
            if k.tag in _SKIP_TAGS or "amendNote" in k.cls():
                continue
            cls = set(k.cls())
            eid = _printed(k)
            if eid and k.tag == "td" and cls & {"prov1Hdr", "sHdr"}:
                self._open(eid, heading=_ws(k.text()))
                continue
            if eid and k.tag == "a":
                if self.stack and not eid.startswith(self.stack[0].eid + "-"):
                    self.problems.append(f"anchor {eid} is outside provision "
                                         f"{self.stack[0].eid}")
                self._open(eid)
                continue
            if k.tag == "tr" and self.stack:
                cells = [c for c in k.kids if not isinstance(c, str) and c.tag == "td"]
                if len(cells) >= 2 and any(c.endswith("No") for c in cells[0].cls()):
                    num = _ws(cells[0].text())
                    label = _label(num)
                    if eid and not eid.startswith(self.stack[-1].eid + "-"):
                        # the row sits INSIDE its parent's cell, so its printed id must
                        # extend the parent's; anything else is a structure this reader
                        # has misread (or the page mis-numbered), never a guess to keep
                        self.problems.append(f"printed id {eid} sits inside "
                                             f"{self.stack[-1].eid} but does not extend it")
                    rid = eid or (self._row_id(k, label) if label else None)
                    if rid is None:
                        self.problems.append(f"row with unreadable label {num!r} under "
                                             f"{self.stack[-1].eid}")
                        self.walk(k)
                        continue
                    depth = self._open(rid, num=num)
                    for c in cells[1:]:
                        self.walk(c)
                    self._close_to(depth - 1)
                    continue
            if k.tag == "td" and "def" in cls and self.stack:
                m = re.match(r"^\s*[\u201c\"]([^\u201d\"]+)[\u201d\"]", k.text())
                if m:
                    while self.stack and "-pd" in self.stack[-1].eid.rsplit("-", 1)[-1][:3] \
                            or (self.stack and re.search(r"-pd[a-z0-9]+(-|$)", self.stack[-1].eid)):
                        self.stack.pop()
                    if self.stack:
                        slug = _term_slug(m.group(1))
                        depth = self._open(f"{self.stack[-1].eid}-pd{slug}")
                        self.walk(k)
                        self._close_to(depth - 1)
                        continue
            if k.tag == "td" and cls & {"tailSTxt", "tailSTxt0"} and self.stack \
                    and self.stack[0].eid.startswith("Sc"):
                head = k.text().replace("\xa0", " ")
                para = re.match(r"^\s*([0-9]+[A-Z]*)\.", head)
                sub = re.match(r"^\s*\(([0-9]+[A-Z]*)\)", head)
                rid = None
                if para:
                    cont = next((u for u in reversed(self.stack) if _CONTAINER.match(u.eid)), None)
                    rid = f"{cont.eid}-s1{para.group(1)}" if cont else None
                elif sub:
                    s1 = next((u for u in reversed(self.stack)
                               if re.search(r"-s1[0-9]+[A-Z]*$", u.eid)), None)
                    rid = f"{s1.eid}-s2{sub.group(1)}" if s1 else None
                if rid:
                    # a paragraph stays open until the next unit its id does not prefix
                    # (its sub-paragraphs may follow as SIBLING cells); a sub-paragraph's
                    # text is its own cell
                    depth = self._open(rid)
                    self.walk(k)
                    if sub:
                        self._close_to(depth - 1)
                    continue
            if eid and k.tag in ("td", "tr", "div"):
                depth = self._open(eid)            # e.g. a Part container (sGrpTail)
                self.walk(k)
                self._close_to(depth - 1)
                continue
            self.walk(k)


def _all_printed(node):
    """Every printed provision id inside NODE (the legislation body only)."""
    out, todo = [], [node]
    while todo:
        n = todo.pop()
        if isinstance(n, _Node):
            if n.tag in _SKIP_TAGS or "amendNote" in n.cls():
                continue
            e = _printed(n)
            if e:
                out.append(e)
            todo.extend(n.kids)
    return out


def _iter_units(units):
    for u in units:
        yield u
        yield from _iter_units([i for i in u.items if isinstance(i, _Unit)])


def _content_root(tree):
    """The page's legislation body: the `legisContent` div (navigation, print dialogs
    and timelines sit outside it)."""
    todo = [tree]
    while todo:
        n = todo.pop()
        if isinstance(n, _Node):
            if n.tag == "div" and (n.attrs.get("id") == "legisContent" or "legisContent" in n.cls()):
                return n
            todo.extend(reversed(n.kids))
    raise ValueError("no <div id=\"legisContent\"> -- not an SSO provision page")


def _emit(unit, out, indent):
    pad = "  " * indent
    attrs = f' eId="{escape(unit.eid)}"'
    out.append(f"{pad}<hcontainer{attrs}>")
    if unit.num:
        out.append(f"{pad}  <num>{escape(_ws(unit.num))}</num>")
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


def convert(html, name="sso", cut=None):
    """`cut`: the eId of ONE unit; the extract then holds only that unit's subtree (the
    smallest document-native element covering a domain's scope, so the pin does not carry
    provisions the domain never formalizes). The page-level checks -- every printed id
    found, no prefix conflict -- run over the WHOLE page either way."""
    tree = _parse_html(html)
    content = _content_root(tree)
    w = _Walker()
    w.walk(content)
    units = list(_iter_units(w.top))
    eids = [u.eid for u in units]
    printed = sorted({e + "-" for e in _all_printed(content)})
    missing = [p for p in printed if p[:-1] not in eids]
    dup = sorted({e for e in eids if eids.count(e) > 1})
    problems = list(w.problems)
    if dup:
        problems.append(f"duplicate eIds: {dup[:5]}")
    # every DERIVED id must prefix the printed ids beneath it
    printed_set = {p[:-1] for p in printed}
    for u in units:
        kids = [k.eid for k in _iter_units([i for i in u.items if isinstance(i, _Unit)])]
        for k in kids:
            if not k.startswith(u.eid + "-"):
                problems.append(f"{k} is nested under {u.eid} but does not extend its id")
    derived = [e for e in eids if e not in printed_set]
    emit = w.top
    if cut is not None:
        found = [u for u in units if u.eid == cut]
        if not found:
            raise ValueError(f"cut {cut!r}: no such unit on this page")
        emit = found
    out = ['<?xml version="1.0" encoding="UTF-8"?>',
           f'<akomaNtoso xmlns="{AKN_NS}">', f'  <act name="{escape(name)}">', "    <body>"]
    for u in emit:
        _emit(u, out, 3)
    out += ["    </body>", "  </act>", "</akomaNtoso>", ""]
    return "\n".join(out), {"units": len(units), "printed": len(printed),
                            "missing": missing, "derived": derived, "problems": problems}


def page_text(html):
    """The page's legislation text, whitespace-normalised, for the verbatim check."""
    return _ws(_content_root(_parse_html(html)).text())


def check_verbatim(html, units):
    """Runs of `units` (units.parse_units output) that are NOT substrings of the page."""
    text = page_text(html)
    squashed = re.sub(r"\s+", "", text)
    bad = []
    for u in units:
        for run in u.runs:
            if re.sub(r"\s+", "", run.text) not in squashed:
                bad.append((u.id, run.text[:80]))
    return bad
