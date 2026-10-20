#!/usr/bin/env python3
"""gen_citation_index.py -- group cite atoms by legal instrument for batching."""
from _tools.source_files import is_private_overlay, is_source
import os, sys

_REPO_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
if _REPO_ROOT not in sys.path:
    sys.path.insert(0, _REPO_ROOT)

try:
    import yaml
except ImportError:
    yaml = None
from _tools.scaffold_citations import distinct_cite_atoms

_KEYWORDS = ("cfr", "usc", "act", "reg", "directive", "gdpr", "emir", "mifid",
             "mar", "crr", "mica", "reach", "clp", "fata", "cca", "corps",
             "gber", "amlr", "irc", "fata")

def instrument_prefix(atom):
    parts = atom.split("_")
    for i, p in enumerate(parts):
        if p in _KEYWORDS:
            return "_".join(parts[:i + 1])
    return "_".join(parts[:2])

def build_index(repo_root=_REPO_ROOT):
    index = {}
    for dirpath, _dirs, files in os.walk(repo_root):
        if os.sep + "tests" in dirpath or os.sep + "." in dirpath:
            continue
        rel_parts = tuple(os.path.relpath(dirpath, repo_root).split(os.sep))
        if any(part.startswith("_") for part in rel_parts) or is_private_overlay(rel_parts):
            continue
        atoms = set()
        for f in files:
            if is_source(f):
                src = open(os.path.join(dirpath, f), encoding="utf-8").read()
                atoms.update(distinct_cite_atoms(src))
        if not atoms:
            continue
        rel = os.path.relpath(dirpath, repo_root)
        groups = {}
        for a in sorted(atoms):
            groups.setdefault(instrument_prefix(a), []).append(a)
        index[rel] = groups
    return index

def main(argv=None):
    idx = build_index()
    out = os.path.join(_REPO_ROOT, "_index", "citation-instruments.yaml")
    with open(out, "w", encoding="utf-8") as fh:
        yaml.safe_dump(idx, fh, sort_keys=True, allow_unicode=True, default_flow_style=False)
    print("wrote", out, "-", len(idx), "domains")
    return 0

if __name__ == "__main__":
    sys.exit(main())
