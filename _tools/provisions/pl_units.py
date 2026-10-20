#!/usr/bin/env python3
"""pl_units.py -- write `units-[...]` bindings into a Prolog citation registry.

The Prolog spelling of a seam record's `units:` key is an optional LAST pair,

    citation(Key, [label-'...', ref-'...', verbatim-'...', units-['<doc>#<eid>', ...]]).

which `check_citations._pl_record` accepts and `registry.py` reads. The CORPUS owns that
format, so a caller that must carry unit bindings into a `citations.pl` (auto/promote.py,
when a Prolog registry supersedes a seam one that had units) calls this rather than
writing Prolog itself:

    add_units(pl_text, {"key": ["<doc>#<eid>", ...]}) -> new pl_text

The edit is TEXTUAL and minimal -- comments, layout and every other record are kept
byte for byte -- and it is VERIFIED: the result is re-read through the engine's reader
and `_pl_record`, and every mapped key must come back with exactly the units given.
Anything else raises `UnitsError` and nothing is returned. A mapped key with no record
is an error too (a binding with nowhere to go is a lost binding, not a no-op).

CLI (for a child process): `python -m _tools.provisions.pl_units <citations.pl> <map.json>`
prints the new text on stdout; exit 1 with the reason on stderr.
"""
import json
import re
import sys


class UnitsError(ValueError):
    pass


def _quote(atom):
    return "'" + atom.replace("\\", "\\\\").replace("'", "''") + "'"


def _skip_quoted(text, i):
    """Index just past the quoted item starting at text[i] (`'..'` or `".."`, a doubled
    quote is an escaped one)."""
    q = text[i]
    i += 1
    while i < len(text):
        if text[i] == "\\":
            i += 2
            continue
        if text[i] == q:
            if i + 1 < len(text) and text[i + 1] == q:
                i += 2
                continue
            return i + 1
        i += 1
    raise UnitsError("unterminated quoted item")


def _list_span(text, start):
    """(open, close) indices of the `[` ... `]` list beginning at or after START, quote-
    and comment-aware (`%` to end of line)."""
    i = text.index("[", start)
    depth, j = 0, i
    while j < len(text):
        c = text[j]
        if c in "'\"":
            j = _skip_quoted(text, j)
            continue
        if c == "%":
            j = text.find("\n", j)
            j = len(text) if j < 0 else j
            continue
        if c == "0" and text[j + 1:j + 2] == "'":       # 0'c character code
            j += 3
            continue
        if c == "[":
            depth += 1
        elif c == "]":
            depth -= 1
            if depth == 0:
                return i, j
        j += 1
    raise UnitsError("unbalanced list")


def _scan_list_body(text, lo, hi):
    """Walk the list body text[lo:hi] (inside the brackets), quote-, comment- and nesting-
    aware. Returns (pairs, last_end): the start index of every TOP-LEVEL `,` and the index just
    past the last significant (non-blank, non-comment) character. A quoted atom such as
    `verbatim-'see a, units-[x] there'` contributes no comma and no `units` (review MED,
    2026-10-03: the old regex matched inside it and cut the verbatim)."""
    commas, last_end, depth, j = [], lo, 0, lo
    while j < hi:
        c = text[j]
        if c in "'\"":
            j = _skip_quoted(text, j)
            last_end = j
            continue
        if c == "%":
            nl = text.find("\n", j, hi)
            j = hi if nl < 0 else nl
            continue
        if c == "/" and text[j + 1:j + 2] == "*":
            end = text.find("*/", j + 2, hi)
            if end < 0:
                raise UnitsError("unterminated block comment inside a record")
            j = end + 2
            continue
        if c == "0" and text[j + 1:j + 2] == "'":         # 0'c character code
            j += 3
            last_end = j
            continue
        if c in "[(":
            depth += 1
        elif c in "])":
            depth -= 1
        elif c == "," and depth == 0:
            commas.append(j)
        if not c.isspace():
            last_end = j + 1
        j += 1
    return commas, last_end


_UNITS_HEAD = re.compile(r",\s*units\s*-\s*\[")


def _units_pair_span(text, lo, hi):
    """(start, end) of an existing TOP-LEVEL `, units-[...]` pair inside the list
    text[lo:hi], or None. Only a real top-level comma can start it."""
    found = None
    for c in _scan_list_body(text, lo, hi)[0]:
        m = _UNITS_HEAD.match(text, c)
        if m and m.end() <= hi:
            found = m
    if found is None:
        return None
    _, close = _list_span(text, found.end() - 1)
    return found.start(), close + 1


def _records(pl_text):
    """{key: record dict} for every valid citation/2 fact, through the gate's own reader."""
    from _tools import pl_source
    from _tools.check_citations import _pl_record
    clauses, issues = pl_source.read_pl_text(pl_text)
    if issues:
        raise UnitsError(f"does not read as Prolog: line {issues[0][0]}: {issues[0][1]}")
    out, invalid = {}, {}
    for term, _line in clauses:
        head, body = pl_source.rule(term)
        if body is None and isinstance(head, tuple) and len(head) == 3 and head[0] == "citation":
            rec, problem = _pl_record(head[1], head[2])
            if rec is None:
                invalid[head[1]] = problem
            else:
                out[head[1]] = rec
    return out, invalid


def add_units(pl_text, mapping):
    before, _ = _records(pl_text)
    out = pl_text
    for key in sorted(mapping):
        units = list(mapping[key])
        if not units:
            raise UnitsError(f"{key}: an empty units list binds nothing (a lost binding)")
        if not all(isinstance(u, str) and u for u in units):
            raise UnitsError(f"{key}: units must be non-empty strings")
        heads = [m for m in re.finditer(r"(?m)^\s*citation\(\s*" + re.escape(key) + r"\s*,", out)]
        if len(heads) != 1:
            raise UnitsError(f"{key}: expected exactly one citation/2 record, found {len(heads)}")
        lo, hi = _list_span(out, heads[0].end())
        existing = _units_pair_span(out, lo + 1, hi)
        if existing:
            out = out[:existing[0]] + out[existing[1]:]
            lo, hi = _list_span(out, heads[0].end())
        pair = ",\n    units-[" + ", ".join(_quote(u) for u in units) + "]"
        # after the LAST ITEM, not before `]`: a trailing `% comment` would swallow the pair
        _, body_end = _scan_list_body(out, lo + 1, hi)
        out = out[:body_end] + pair + out[body_end:]
    # VERIFY through the same reader + record check the gate uses: the mapped keys carry
    # exactly the units given, and NOTHING ELSE changed -- every other record identical, and
    # the mapped records' label/ref/verbatim byte-identical (a mis-edit is refused).
    after, invalid = _records(out)
    for key in mapping:
        if key in invalid:
            raise UnitsError(f"{key}: record no longer valid: {invalid[key]}")
    if set(after) != set(before) | (set(mapping) & set(after)):
        raise UnitsError(f"the set of records changed: {sorted(set(before) ^ set(after))}")
    for key, rec in after.items():
        old = before.get(key)
        if key in mapping:
            if rec.get("units") != list(mapping[key]):
                raise UnitsError(f"{key}: read back {rec.get('units')!r}, wanted {list(mapping[key])!r}")
            if old is not None and {k: v for k, v in rec.items() if k != "units"} != \
                    {k: v for k, v in old.items() if k != "units"}:
                raise UnitsError(f"{key}: label/ref/verbatim changed by the units edit")
        elif rec != old:
            raise UnitsError(f"{key}: a record that was not mapped changed")
    return out


def main(argv=None):
    argv = sys.argv[1:] if argv is None else argv
    if len(argv) != 2:
        print("usage: python -m _tools.provisions.pl_units <citations.pl> <map.json>",
              file=sys.stderr)
        return 2
    try:
        text = open(argv[0], encoding="utf-8").read()
        mapping = json.load(open(argv[1], encoding="utf-8"))
        sys.stdout.write(add_units(text, mapping))
    except (OSError, ValueError) as exc:
        print(f"pl_units: {exc}", file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main())
