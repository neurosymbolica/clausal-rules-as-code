#!/usr/bin/env python3
"""check_translation.py -- validate a domain's per-language translation submodule
(Part C). Completeness (translation records <-> citation atoms), key-is-a-real-
citation-atom, string-key well-formedness, and status consistency against the
per-lang translation/<lang>-sources.yaml audit manifest."""
from _tools.source_files import resolve_source, prolog_registry_path
import os, re, sys
try:
    import yaml
except ImportError:
    yaml = None
from _tools.scaffold_translation import citation_atoms

_NAME = r"[a-z][a-z0-9_]*"
_REC_RE = re.compile(
    r"translation\(\s*(?P<atom>" + _NAME + r")\s*,\s*\{(?P<body>.*?)\}\)", re.DOTALL)

def _records(translation_src):
    recs, seen = {}, {}
    for m in _REC_RE.finditer(translation_src):
        atom, body = m.group("atom"), m.group("body")
        seen[atom] = seen.get(atom, 0) + 1
        ref = re.search(r'"?ref"?:\s*(?:"""(.*?)"""|"(.*?)")', body, re.DOTALL)
        verb = re.search(r'"?verbatim"?:\s*(?:"""(.*?)"""|"(.*?)")', body, re.DOTALL)
        recs[atom] = {
            "ref": (ref.group(1) or ref.group(2) or "") if ref else "",
            "verbatim": (verb.group(1) or verb.group(2) or "") if verb else "",
        }
    dups = {a for a, c in seen.items() if c > 1}
    return recs, dups

# The Clausal Prolog record (mirrors citation/2): translation(Key, [ref-'...', verbatim-'...']).
_PL_KEYS = ("ref", "verbatim")


class LayerProblem(Exception):
    """A layer the checker cannot vouch for (mixed, unreadable): named, never read as empty."""


def _pl_layer(domain_dir, lang):
    return prolog_registry_path(os.path.join(domain_dir, "translation"), lang)


def _pl_records(domain_dir, lang):
    """(recs, dups, shape_problems) from a Prolog translation layer. A record in any other
    shape is a problem with its key, and is not counted as a record."""
    from _tools import pl_source
    path = _pl_layer(domain_dir, lang)
    try:
        clauses = pl_source.read_pl_checked(path)
    except pl_source.UnreadablePl as e:
        raise LayerProblem(f"translation/{os.path.basename(path)}: Prolog source does not "
                           f"read ({e}) -- check_translation cannot vouch for it") from e
    recs, seen, problems = {}, {}, []
    shape = "translation record's second argument must be [ref-'...', verbatim-'...'] " \
            "(keys ref, verbatim in that order, every value a quoted atom)"
    for term, line in clauses:
        head, body = pl_source.rule(term)
        if not (isinstance(head, tuple) and len(head) == 3 and head[0] == "translation"):
            continue
        key, pairs = head[1], head[2]
        if body is not None or not isinstance(key, str):
            problems.append(f"translation/2 at translation/{os.path.basename(path)}:{line}: "
                            f"a translation record must be a fact keyed by an atom")
            continue
        seen[key] = seen.get(key, 0) + 1
        ok = (isinstance(pairs, list) and len(pairs) == len(_PL_KEYS)
              and all(isinstance(p, tuple) and len(p) == 3 and p[0] == "-" and p[1] == k
                      and isinstance(p[2], str) for p, k in zip(pairs, _PL_KEYS)))
        if not ok:
            problems.append(f"{key}: {shape}")
            continue
        recs[key] = {"ref": pairs[0][2], "verbatim": pairs[1][2]}
    return recs, {a for a, n in seen.items() if n > 1}, problems


def _layer_is_prolog(domain_dir, lang):
    from _tools import check_citations
    if os.path.exists(_pl_layer(domain_dir, lang)):
        return True
    seam = resolve_source(os.path.join(domain_dir, "translation", lang + ".clausal"))
    return not os.path.exists(seam) and bool(check_citations._prolog_sources(domain_dir))


def records(domain_dir, lang):
    """(recs, dups) for a domain's <lang> layer in EITHER language. A Prolog layer whose
    domain is mixed or unreadable raises LayerProblem rather than returning an empty set."""
    if _layer_is_prolog(domain_dir, lang):
        recs, dups, _ = _pl_records(domain_dir, lang)
        return recs, dups
    tpath = resolve_source(os.path.join(domain_dir, "translation", lang + ".clausal"))
    return _records(open(tpath, encoding="utf-8").read())


def _pl_citation_atoms(domain_dir):
    from _tools import check_citations
    try:
        got = check_citations.records(domain_dir)
    except (check_citations.MixedDomain, check_citations.UnreadableDomain) as e:
        raise LayerProblem(str(e)) from e
    return set(got[0]) if got else set()


def check_domain_lang(domain_dir, lang):
    problems = []
    if _layer_is_prolog(domain_dir, lang):
        tpath = _pl_layer(domain_dir, lang)
        if not os.path.exists(tpath):
            return [f"{domain_dir}: no translation/{os.path.basename(tpath)}"]
        try:
            recs, dups, problems = _pl_records(domain_dir, lang)
            cit = _pl_citation_atoms(domain_dir)
        except LayerProblem as e:
            return [str(e)]
        shaped = {p.split(":", 1)[0] for p in problems}
        return problems + _layer_problems(domain_dir, lang, recs, dups, cit, shaped)
    tpath = resolve_source(os.path.join(domain_dir, "translation", lang + ".clausal"))
    if not os.path.exists(tpath):
        return [f"{domain_dir}: no translation/{os.path.basename(tpath)}"]
    recs, dups = _records(open(tpath, encoding="utf-8").read())
    cit = set(citation_atoms(
        open(resolve_source(os.path.join(domain_dir, "citations.clausal")),
             encoding="utf-8").read()))
    return problems + _layer_problems(domain_dir, lang, recs, dups, cit, set())


def _layer_problems(domain_dir, lang, recs, dups, cit, shaped):
    """The checks shared by both languages. `shaped`: keys already reported for their
    shape, so a malformed record is not reported a second time as missing."""
    problems = []
    for a in sorted(dups):
        problems.append(f"{a}: duplicate translation record")
    for a in sorted(cit - set(recs) - shaped):
        problems.append(f"{a}: citation atom has no translation record")
    for a in sorted(set(recs) - cit):
        problems.append(f"{a}: translation record but not a citation atom")
    spath = os.path.join(domain_dir, "translation", lang + "-sources.yaml")
    sources = {}
    if os.path.exists(spath) and yaml:
        sources = yaml.safe_load(open(spath, encoding="utf-8")) or {}
    for a in sorted(recs):
        st = (sources.get(a) or {}).get("status")
        if st not in ("verified", "unverified", "n_a"):
            problems.append(f"{a}: missing/invalid status in translation/{lang}-sources.yaml")
        elif st == "verified" and not (recs[a]["ref"].strip() and recs[a]["verbatim"].strip()):
            problems.append(f"{a}: marked verified but ref/verbatim empty")
        elif st in ("unverified", "n_a") and recs[a]["verbatim"].strip():
            problems.append(f"{a}: marked {st} but has verbatim text")
    return problems

def main(argv=None):
    argv = argv or sys.argv[1:]
    if len(argv) < 2:
        print("usage: check_translation.py <domain_dir> <lang>", file=sys.stderr)
        return 2
    problems = check_domain_lang(argv[0], argv[1])
    for p in problems:
        print("PROBLEM:", p)
    print("OK" if not problems else f"{len(problems)} problem(s)")
    return 0 if not problems else 1

if __name__ == "__main__":
    sys.exit(main())
