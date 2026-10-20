#!/usr/bin/env python3
"""check_provenance.py -- the unified provenance checker (formalization standard).

STRUCTURAL plane (gate-blocking): a cite-using domain has a complete citation/2
registry; a parameter-signalled domain has parameter_source/2 or a manifest
opt-out; a present translation/<lang> layer is complete. Composes
check_citations / check_parameters / check_translation.

SOURCING/COVERAGE plane (report-only): verified ratios + translation coverage,
written to _index/provenance-report.yaml (the catalog-only conformance checker
cannot read sourcing status; this is its home).
"""
from _tools.source_files import is_source, source_stem, resolve_source, prolog_registry_path, PRIVATE_OVERLAY_ROOT
import argparse, os, re, sys
try:
    import yaml
except ImportError:
    yaml = None
from _tools.scaffold_parameters import candidate_facts
from _tools.scaffold_citations import distinct_cite_atoms
from _tools import check_citations, check_parameters, check_translation
# ONE definition of the parameter signal / opt-out, owned by check_parameters
# (see its comment): defining them here made the two entry points disagree.
from _tools.check_parameters import parameter_signal, parameters_opted_out

# a citation/2 ref pointing at an EU instrument (EUR-Lex CELEX id).
_CELEX = re.compile(r"CELEX:\s*\d")
# a trailing comment carrying a statute reference (same markers as the corpus uses).
_STATUTE = re.compile(r"§|\bCFR\b|\bU\.?S\.?C\b|USC|\bArt\b|\bArticle\b|\bReg(?:ulation)?\s*(?:\(EU\)\s*)?(?:No\.?\s*)?[0-9/]|"
                      r"\bReglement\b|\bs\.?\s?\d|\bSch\b|\bAnnex\b|\bDirective\b", re.I)
# a value-unit suffix on a ground-fact functor (the corpus parameter-naming
# convention) — a decomposition-robust legally-sourced-value signal.
_VALUE_UNIT = re.compile(
    r"_(?:usd_cents|cents|bps|percent|pct|eur|gbp|kg|tonnes?|days|months|weeks|minutes|mph)$")

def logic_files(domain_dir):
    """The domain's decision/data .clausal files — everything EXCEPT the
    provenance submodules (citations.clausal, parameters.clausal) and the
    translation/ subpackage."""
    out = []
    for f in sorted(os.listdir(domain_dir)):
        if is_source(f) and source_stem(f) not in ("citations", "parameters"):
            out.append(os.path.join(domain_dir, f))
    return out


def translation_signal(domain_dir):
    """True iff any citation/2 ref points at an EU-CELEX instrument (translatable)."""
    cpath = str(resolve_source(os.path.join(domain_dir, "citations.clausal")))
    if not os.path.exists(cpath):
        return False
    return bool(_CELEX.search(open(cpath, encoding="utf-8").read()))


def translation_langs(domain_dir):
    """Language codes with a translation/<lang>.clausal layer present (sorted)."""
    tdir = os.path.join(domain_dir, "translation")
    if not os.path.isdir(tdir):
        return []
    return sorted(source_stem(f) for f in os.listdir(tdir) if is_source(f))

def _cited_atoms(domain_dir):
    atoms = set()
    for f in logic_files(domain_dir):
        atoms.update(distinct_cite_atoms(open(f, encoding="utf-8").read()))
    atoms.update(check_citations.listed_atoms(domain_dir)[0])   # the declared list route
    return atoms

def structural_problems(domain_dir):
    """The gate-blocking provenance verdict for a domain: a flat list of problem
    strings (empty == provenance-structural-clean). Composes the layer checkers
    per the enforcement matrix."""
    problems = []
    # --- Citations: auto-signal (cite atoms present) => complete citation/2 registry.
    # A .pl domain's cites are invisible to the Clausal regex above, so it has its own
    # signal (cite(K) / implements(K) read through the engine; unreadable => signal).
    if _cited_atoms(domain_dir) or (check_citations._prolog_sources(domain_dir)
                                    and check_citations.pl_citation_signal(domain_dir)):
        problems += ["citation: " + p for p in check_citations.check_domain(domain_dir)]
    # --- Parameters: present => structural; signalled+absent => opt-out required
    # A .pl domain first: `resolve_source` only tries the Clausal aliases, so on a .pl
    # tree the branch below fell through to a Clausal-only signal that saw nothing, and
    # an untraced statutory value passed SILENTLY (vacuous gate, fixed 2026-09-30).
    if check_parameters._prolog_sources(domain_dir):
        refusal = check_parameters.pl_refusal(domain_dir)
        if refusal or os.path.exists(prolog_registry_path(domain_dir,
                                                          check_parameters._PL_REGISTRY_STEM)):
            problems += ["parameter: " + p for p in check_parameters.check_domain(domain_dir)[0]]
        elif parameter_signal(domain_dir) and not parameters_opted_out(domain_dir):
            problems.append(
                "parameter signal present (a numeric ground fact with a value-unit-suffixed "
                "functor, or a declared constant) but no parameters.pl and no "
                "`parameters: none # <reason>` opt-out in manifest.yaml")
    elif os.path.exists(resolve_source(os.path.join(domain_dir, "parameters.clausal"))):
        problems += ["parameter: " + p for p in check_parameters.check_domain(domain_dir)[0]]
    elif parameter_signal(domain_dir) and not parameters_opted_out(domain_dir):
        problems.append(
            "parameter signal present (a numeric ground fact with a statute-ref comment or a value-unit-suffixed functor) but no parameters.clausal and no `parameters: none # <reason>` "
            "opt-out in manifest.yaml")
    # --- Translations: any present layer must be structurally complete
    for lang in translation_langs(domain_dir):
        problems += [f"translation[{lang}]: " + p
                     for p in check_translation.check_domain_lang(domain_dir, lang)]
    return problems

def _verified_counts(recs, sources):
    """(total, verified, unverified) from a {key: rec} + a sources.yaml dict."""
    total = len(recs); ver = 0
    for k in recs:
        if (sources.get(k) or {}).get("status") == "verified":
            ver += 1
    return {"total": total, "verified": ver, "unverified": total - ver}

def _load_yaml(path):
    if not (os.path.exists(path) and yaml):
        return {}
    with open(path, encoding="utf-8") as fh:
        return yaml.safe_load(fh) or {}

def domain_metrics(domain_dir):
    """Sourcing/coverage metrics for one domain (report-only, never gating)."""
    m = {"citations": {"total": 0, "verified": 0, "unverified": 0},
         "parameters": {"total": 0, "verified": 0, "unverified": 0},
         "parameters_opted_out": parameters_opted_out(domain_dir),
         "translations": {}}
    if check_citations._prolog_sources(domain_dir):
        # A .pl registry, through the engine's reader. Report-only, so a domain the
        # gate would refuse (mixed, unreadable) is NAMED here, never counted as empty.
        try:
            got = check_citations.records(domain_dir)
        except (check_citations.MixedDomain, check_citations.UnreadableDomain) as e:
            m["citations"] = {**m["citations"], "unreadable": str(e)}
            got = None
        if got is not None:
            m["citations"] = _verified_counts(
                got[0], _load_yaml(os.path.join(domain_dir, "citations-sources.yaml")))
    else:
        cpath = str(resolve_source(os.path.join(domain_dir, "citations.clausal")))
        if os.path.exists(cpath):
            recs, _ = check_citations._records(open(cpath, encoding="utf-8").read())
            m["citations"] = _verified_counts(recs, _load_yaml(os.path.join(domain_dir, "citations-sources.yaml")))
    if check_parameters._prolog_sources(domain_dir):
        # parameters.pl through the engine's reader; a refused domain is NAMED, never
        # counted as empty (as for citations above).
        try:
            got = check_parameters.records(domain_dir)
        except (check_citations.MixedDomain, check_citations.UnreadableDomain) as e:
            m["parameters"] = {**m["parameters"], "unreadable": str(e)}
            got = None
        if got is not None:
            m["parameters"] = _verified_counts(
                got[0], _load_yaml(os.path.join(domain_dir, "parameters-sources.yaml")))
    else:
        ppath = str(resolve_source(os.path.join(domain_dir, "parameters.clausal")))
        if os.path.exists(ppath):
            recs, _ = check_parameters._records(open(ppath, encoding="utf-8").read())
            m["parameters"] = _verified_counts(recs, _load_yaml(os.path.join(domain_dir, "parameters-sources.yaml")))
    for lang in translation_langs(domain_dir):
        recs, _ = check_translation._records(
            open(resolve_source(os.path.join(domain_dir, "translation", lang + ".clausal")),
                 encoding="utf-8").read())
        m["translations"][lang] = _verified_counts(
            recs, _load_yaml(os.path.join(domain_dir, "translation", lang + "-sources.yaml")))
    return m

def _domains(root):
    for dp, dirs, files in os.walk(root):
        dirs[:] = [d for d in dirs if d not in (".git", "_index", "translation", "__pycache__")
                   and not (dp == root and d == PRIVATE_OVERLAY_ROOT)]
        if os.sep + ".git" in dp or os.sep + "_index" in dp:
            continue
        if "manifest.yaml" in files or any(is_source(f) for f in files):
            yield dp

def build_report(root):
    rows = []
    for dp in sorted(set(_domains(root))):
        rel = os.path.relpath(dp, root)
        m = domain_metrics(dp)
        if m["citations"]["total"] or m["parameters"]["total"] or m["translations"]:
            rows.append({"domain": rel.replace(os.sep, "/"), **m})
    return {"schema_version": 0, "domains": rows}

def main(argv=None):
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("domain_dir", nargs="?")
    ap.add_argument("--report", action="store_true", help="write _index/provenance-report.yaml")
    ap.add_argument("--root", default=os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
    a = ap.parse_args(argv)
    if a.report:
        rep = build_report(a.root)
        out = os.path.join(a.root, "_index", "provenance-report.yaml")
        os.makedirs(os.path.dirname(out), exist_ok=True)
        with open(out, "w", encoding="utf-8") as fh:
            yaml.safe_dump(rep, fh, sort_keys=False, allow_unicode=True)
        print("wrote", out, "-", len(rep["domains"]), "domains")
        return 0
    if not a.domain_dir:
        print("usage: check_provenance.py <domain_dir> | --report", file=sys.stderr)
        return 2
    probs = structural_problems(a.domain_dir)
    for p in probs:
        print("PROBLEM:", p)
    print("OK" if not probs else f"{len(probs)} problem(s)")
    return 0 if not probs else 1

if __name__ == "__main__":
    sys.exit(main())
