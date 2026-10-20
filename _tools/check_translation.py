#!/usr/bin/env python3
"""check_translation.py -- validate a domain's per-language translation submodule
(Part C). Completeness (translation records <-> citation atoms), key-is-a-real-
citation-atom, string-key well-formedness, and status consistency against the
per-lang translation/<lang>-sources.yaml audit manifest."""
from _tools.source_files import resolve_source
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

def check_domain_lang(domain_dir, lang):
    problems = []
    tpath = resolve_source(os.path.join(domain_dir, "translation", lang + ".clausal"))
    if not os.path.exists(tpath):
        return [f"{domain_dir}: no translation/{os.path.basename(tpath)}"]
    recs, dups = _records(open(tpath, encoding="utf-8").read())
    for a in sorted(dups):
        problems.append(f"{a}: duplicate translation record")
    cit = set(citation_atoms(
        open(resolve_source(os.path.join(domain_dir, "citations.clausal")),
             encoding="utf-8").read()))
    for a in sorted(cit - set(recs)):
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
