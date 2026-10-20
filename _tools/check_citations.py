#!/usr/bin/env python3
"""check_citations.py -- validate a domain's citation registry (Part A).

Completeness: every cited atom has exactly one citation/2 record and vice versa.
Well-formedness: non-empty label; ref/verbatim present iff the sources manifest
marks the atom verified. Manifest coverage: every atom has a status.
"""
from _tools.source_files import (is_source, source_stem, resolve_source, is_prolog,
                                 seam_rulebase_suffixes, prolog_registry_path)
import os, re, sys
try:
    import yaml
except ImportError:
    yaml = None
from _tools.scaffold_citations import distinct_cite_atoms, _LIST_ATOM_RE

_REC_RE = re.compile(r"citation\((?P<atom>[a-z][a-z0-9_]*)\s*,\s*\{(?P<body>.*?)\}\)", re.DOTALL)

def _records(citations_src):
    recs = {}
    seen = {}
    for m in _REC_RE.finditer(citations_src):
        atom = m.group("atom")
        seen[atom] = seen.get(atom, 0) + 1
        body = m.group("body")
        # keys may be bare atoms (label:) or string keys ("label":) under -strict_atoms.
        label = re.search(r'"?label"?:\s*"(.*?)"', body, re.DOTALL)
        ref = re.search(r'"?ref"?:\s*"(.*?)"', body, re.DOTALL)
        verb = re.search(r'"?verbatim"?:\s*(?:"""(.*?)"""|"(.*?)")', body, re.DOTALL)
        recs[atom] = {
            "label": (label.group(1) if label else ""),
            "ref": (ref.group(1) if ref else ""),
            "verbatim": ((verb.group(1) or verb.group(2)) if verb else ""),
        }
    duplicates = {a for a, count in seen.items() if count > 1}
    return recs, duplicates

#: A DECLARED SECOND CITATION ROUTE, in the domain's `manifest.yaml`:
#:
#:     cited_via_lists: [en16931_rules, peppol_rules]
#:
#: Some domains cite with a VARIABLE -- eu/peppol_einvoicing returns `cite(RULE_ID)` from
#: `peppol_rule_status/4` -- so no literal `cite(atom)` exists for `_cited_atoms` to find,
#: while the atoms are listed once, as the members of a fact `en16931_rules([br_01, ...])`.
#: The field names those list predicates; every atom in a named list's argument counts as
#: cited. Explicit and narrow: nothing is inferred from a name or a shape, and a name that
#: matches no list fact is a problem rather than a silent empty route (a typo'd name
#: would otherwise leave the registry looking dead, or worse, looking covered).
_LISTS_FIELD = "cited_via_lists"


def _declared_list_names(domain_dir):
    """(names, problems) from manifest.yaml's `cited_via_lists`; ([], []) when absent."""
    mpath = os.path.join(domain_dir, "manifest.yaml")
    if not (yaml and os.path.exists(mpath)):
        return [], []
    manifest = yaml.safe_load(open(mpath, encoding="utf-8")) or {}
    if not isinstance(manifest, dict) or _LISTS_FIELD not in manifest:
        return [], []
    names = manifest[_LISTS_FIELD]
    if (not isinstance(names, list) or not names
            or not all(isinstance(n, str) and re.fullmatch(r"[a-z][a-z0-9_]*", n) for n in names)):
        return [], [f"{_LISTS_FIELD} in manifest.yaml must be a non-empty list of predicate names"]
    return names, []


def listed_atoms(domain_dir):
    """(atoms, problems): every atom in the argument list of a fact named by the
    manifest's `cited_via_lists`, read from the domain's source files other than
    citations. A declared name with no `name([...])` anywhere is a problem."""
    names, problems = _declared_list_names(domain_dir)
    atoms, found = set(), set()
    for f in os.listdir(domain_dir) if names else ():
        if is_source(f) and source_stem(f) != "citations":
            src = open(os.path.join(domain_dir, f), encoding="utf-8").read()
            for n in names:
                for m in re.finditer(r"(?<![A-Za-z0-9_])" + n + r"\(\s*\[(.*?)\]\s*\)", src, re.DOTALL):
                    found.add(n)
                    atoms.update(_LIST_ATOM_RE.findall(m.group(1)))
    problems += [f"{n}: named in {_LISTS_FIELD} of manifest.yaml but no `{n}([...])` fact "
                 f"in the domain's sources" for n in names if n not in found]
    return atoms, problems


def _cited_atoms(domain_dir):
    atoms = set()
    for f in os.listdir(domain_dir):
        if is_source(f) and source_stem(f) != "citations":
            src = open(os.path.join(domain_dir, f), encoding="utf-8").read()
            atoms.update(distinct_cite_atoms(src))
    atoms.update(listed_atoms(domain_dir)[0])
    return atoms

#: `auto/scaffold.py` seeds `<jurisdiction>_todo_primary_source` into the citations
#: import list and into manifest.public_interface, and the P3 prompt tells the producer
#: to replace it. It is a forcing function, and it should nag rather than block: an
#: uncited placeholder is a to-do, not a broken citation registry. Measured on
#: procurement wave 3 -- 13 of the 13 runs that hit this gate carried it, and it cost a
#: repair cycle every time while never being the terminal cause of a failure.
#: Suffix-matched, not exact: the jurisdiction prefix varies per domain.
_PLACEHOLDER_SUFFIX = "_todo_primary_source"


def _is_scaffold_placeholder(atom):
    return atom.endswith(_PLACEHOLDER_SUFFIX)


def advisories(domain_dir):
    """Non-blocking nags: an uncited scaffold placeholder the producer left behind.

    Kept OUT of `check_domain` deliberately -- `check_provenance` folds that
    function's output into its own blocking problem list, and `auto/gates.py`
    keys the assure gate on the literal `PROBLEM:` prefix, so anything returned
    there blocks by construction.
    """
    if _prolog_sources(domain_dir):
        # A .pl domain: nag only when the registry reads; `check_domain` owns every
        # refusal (mixed, unreadable, missing), and an advisory is no place to raise.
        try:
            pl = _read_pl_domain(domain_dir)
        except (MixedDomain, UnreadableDomain):
            return []
        if not pl["registry"]:
            return []
        recs, cited = pl["recs"], pl["cited"]
    else:
        cpath = str(resolve_source(os.path.join(domain_dir, "citations.clausal")))
        if not os.path.exists(cpath):
            return []
        recs, _ = _records(open(cpath, encoding="utf-8").read())
        cited = _cited_atoms(domain_dir)
    return [f"{a}: scaffold placeholder still present and never cited — replace it "
            f"with the domain's real primary-source citation"
            for a in sorted(recs) if a not in cited and _is_scaffold_placeholder(a)]


#: A COMMISSIONING-DECLARED CHOICE OF CITATION SPELLING, per record, in
#: `citations-sources.yaml` (the register this gate already reads):
#:
#:     eu_dir_89_665_art_2d_1:
#:       alternative_of: [eu_dir_89_665_art_2d_1_a, eu_dir_89_665_art_2d_1_b]
#:
#: Some orders accept EITHER of two atoms for the same finding -- the
#: eu/procurement/remedies_ineffectiveness order's CITATION SPECIFICITY line accepts
#: the paragraph `eu_dir_89_665_art_2d_1` OR the pleaded ground's own point where a
#: ground is not made out -- while the manifest lists both, so `_resource_citations`
#: keeps a record for both and whichever spelling the rulebase did not choose was
#: reported as dead weight. A rulebase that did exactly what the order permits failed
#: the gate, and the last four remedies commits were pushed with `--no-verify` for it.
#:
#: The exemption is EXPLICIT and one-directional: a record is spared "never cited"
#: only while an atom it NAMES here is cited. Nothing is inferred from a shared atom
#: prefix, and a pair cited in NEITHER spelling is still a problem -- the declaration
#: expresses a choice between spellings, not an amnesty.
_ALTERNATIVES_FIELD = "alternative_of"


def _alternatives(sources, recs, registry="citations.clausal"):
    """({atom -> declared alternative atoms}, problems) read off citations-sources.yaml.

    Only records present in `recs` are consulted, and a declaration that is not a
    non-empty list of atoms that themselves carry citation records is a problem naming
    the field rather than a silent exemption: a typo'd alternative would otherwise
    excuse its record forever while pointing at nothing.
    """
    alternatives, problems = {}, []
    for a in sorted(recs):
        row = sources.get(a)
        if not isinstance(row, dict) or _ALTERNATIVES_FIELD not in row:
            continue
        declared = row[_ALTERNATIVES_FIELD]
        if (not isinstance(declared, list) or not declared
                or not all(isinstance(x, str) for x in declared)):
            problems.append(
                f"{a}: {_ALTERNATIVES_FIELD} in citations-sources.yaml must be a "
                f"non-empty list of citation atoms")
            continue
        unknown = [x for x in declared if x not in recs]
        if unknown:
            problems.append(
                f"{a}: {_ALTERNATIVES_FIELD} in citations-sources.yaml names "
                f"{', '.join(unknown)} -- no such citation record in {registry}")
            continue
        alternatives[a] = declared
    return alternatives, problems


def check_domain(domain_dir):
    if _prolog_sources(domain_dir):
        return _check_domain_pl(domain_dir)
    cpath = str(resolve_source(os.path.join(domain_dir, "citations.clausal")))
    if not os.path.exists(cpath):
        return [f"{domain_dir}: no {os.path.basename(cpath)}"]
    recs, duplicates = _records(open(cpath, encoding="utf-8").read())
    return (listed_atoms(domain_dir)[1]
            + _registry_problems(domain_dir, recs, duplicates, _cited_atoms(domain_dir)))


def _load_sources(domain_dir):
    spath = os.path.join(domain_dir, "citations-sources.yaml")
    sources = {}
    if os.path.exists(spath) and yaml:
        sources = yaml.safe_load(open(spath, encoding="utf-8")) or {}
    if not isinstance(sources, dict):
        sources = {}
    return sources


def _registry_problems(domain_dir, recs, duplicates, cited, registry="citations.clausal"):
    """The language-neutral half of the gate: completeness, labels, manifest status.
    `recs` is {atom: {"label", "ref", "verbatim"}}; the Clausal and .pl readers both
    feed it, so every symptom string below is shared byte for byte."""
    problems = []
    for a in sorted(duplicates):
        problems.append(f"{a}: duplicate citation record")
    sources = _load_sources(domain_dir)
    alternatives, alt_problems = _alternatives(sources, recs, registry)
    problems.extend(alt_problems)
    for a in sorted(cited):
        if a not in recs:
            problems.append(f"{a}: cited but no citation record")
    for a in sorted(recs):
        if a not in cited and not _is_scaffold_placeholder(a):
            alt = alternatives.get(a)
            if not alt:
                problems.append(f"{a}: citation record but atom never cited")
            elif not any(x in cited for x in alt):
                problems.append(
                    f"{a}: citation record but atom never cited, and no declared "
                    f"alternative is cited either ({_ALTERNATIVES_FIELD}: "
                    f"{', '.join(alt)})")
        if not recs[a]["label"].strip():
            problems.append(f"{a}: empty label")
    for a in sorted(recs):
        st = (sources.get(a) or {}).get("status")
        if st not in ("verified", "unverified"):
            problems.append(f"{a}: missing/invalid status in citations-sources.yaml")
        elif st == "verified" and not (recs[a]["ref"].strip() and recs[a]["verbatim"].strip()):
            problems.append(f"{a}: marked verified but ref/verbatim empty")
        elif st == "unverified" and recs[a]["verbatim"].strip():
            problems.append(f"{a}: marked unverified but has verbatim text")
    return problems


# --- Prolog (.pl) domains ---------------------------------------------------------------
#
# The record form (signed off): one FACT per key,
#
#     citation(eu_key, [label-'...', ref-'...', verbatim-'...']).
#
# keys exactly label, ref, verbatim IN THAT ORDER, values quoted atoms; the verbatim pair
# is OMITTED (not empty) when citations-sources.yaml says `status: unverified`. Clauses
# cite with the DATA term `cite(Key)` (any position), and operative clauses open with
# the GOAL `implements(Key)`, defined in citations.pl as `implements(K) :- citation(K, _).`
# Under non-strict atoms a misspelt key there is not a load error: the clause it guards
# silently never succeeds. So implements/1 keys are checked against the registry.
#
# LIVENESS PARITY with the Clausal path: `distinct_cite_atoms` counts BOTH the
# `implements` marker and the `cite` constructor as a use, so here too an atom is "cited"
# when it appears as `cite(K)` anywhere in a clause OR as `implements(K)` in goal
# position. An `implements(K)` held as DATA is neither a guard nor a returned citation
# and counts as nothing.
#
# A provenance marker must name its key LITERALLY. Every implements/1 use the checker
# cannot resolve to an atom is a NAMED problem, never silence: `implements(Var)` in goal
# position, `implements` given as a closure (`call(implements, K)`, `maplist(implements,
# Keys)`), and a term `implements(...)` (or the bare name) held as DATA anywhere in a
# non-registry clause (`G = implements(k), call(G)`). `Module:implements(K)` IS a goal
# (the engine runs qualified calls) and is checked like the unqualified one. Likewise a
# `cite(K)` whose K is neither an atom nor a variable (`cite("eu_b")` reads as chars).
#
# Blind spots (see `_tools.pl_source.goals`): directives and DCG bodies are not walked for
# implements/1; `cite(Var)` is not checked (the key is bound elsewhere).

_PL_REGISTRY_STEM = "citations"   # citations.clausal after the flip, citations.pl before
_PL_KEYS = ("label", "ref", "verbatim")
_IMPLEMENTS = "implements"


class MixedDomain(Exception):
    """A domain with both Clausal and Prolog sources: not supported, never guessed."""


class UnreadableDomain(Exception):
    """A domain .pl file the engine's reader cannot read."""


def _walk_sources(domain_dir, keep):
    out = []
    for root, dirs, files in os.walk(domain_dir):
        dirs[:] = [d for d in dirs if d not in ("eval", "tests", "__pycache__")]
        out += [os.path.join(root, f) for f in files if keep(f)]
    return sorted(out)


def _prolog_sources(domain_dir):
    """Prolog-syntax source files in the domain (`source_files.is_prolog`: `.pl`, and
    `.clausal` after the extension flip), eval/ and tests/ excluded (the same walk as
    `check_parameters._prolog_sources`)."""
    return _walk_sources(domain_dir, is_prolog)


def _clausal_sources(domain_dir):
    """Seam RULEBASE sources for the mixed check (`source_files.seam_rulebase_suffixes`:
    `.clausal` before the extension flip; every `.seam` after it, since the rename made
    every seam rulebase `.seam`), walked exactly like `_prolog_sources`. The Prolog path
    scans no seam file for cites, so a seam file beside Prolog must refuse the domain,
    never pass it on half a reading."""
    suffixes = seam_rulebase_suffixes()
    return _walk_sources(domain_dir, lambda f: os.path.splitext(f)[1] in suffixes)


def _pl_walk(cell):
    yield cell
    if isinstance(cell, list):
        for c in cell:
            yield from _pl_walk(c)
    elif isinstance(cell, tuple) and cell and isinstance(cell[0], str) and cell[0] != "$chars":
        for c in cell[1:]:
            yield from _pl_walk(c)


def _pl_record(key, pairs, what="citation"):
    """({"label","ref","verbatim"}, has_verbatim_pair) from a citation/2 fact's 2nd
    argument, or (None, problem) when it is not the signed-off form. `what` names the
    record in the problem ("citation"; check_parameters passes "parameter_source" --
    its parameter_source/2 facts are the same label/ref[/verbatim] pair list)."""
    shape = (f"{key}: {what} record's second argument must be a proper list of "
             f"Key-'Value' pairs")
    if not isinstance(pairs, list):
        return None, shape
    keys, values = [], []
    for p in pairs:
        if not (isinstance(p, tuple) and len(p) == 3 and p[0] == "-"):
            return None, shape
        keys.append(p[1])
        values.append(p[2])
    # An optional LAST `units-['<doc_id>#<eid>', ...]` pair binds the record to pinned
    # statute units (the Prolog spelling of a seam record's `units:` key, read by
    # _tools/provisions/registry.py); the corpus adds it, never the producer.
    units = None
    if keys and keys[-1] == "units":
        units = values[-1]
        keys, values = keys[:-1], values[:-1]
        if not (isinstance(units, list) and all(isinstance(u, str) for u in units)):
            return None, (f"{key}: {what} record's units must be a list of quoted "
                          f"'<doc_id>#<eid>' atoms")
    if tuple(keys) not in (_PL_KEYS, _PL_KEYS[:2]):
        return None, (f"{key}: {what} record keys must be exactly label, ref, "
                      f"verbatim in that order (then optionally units)")
    for k, v in zip(keys, values):
        if not isinstance(v, str):
            return None, f"{key}: {what} record value for {k} must be a quoted atom"
    rec = {"label": values[0], "ref": values[1],
           "verbatim": values[2] if len(values) == 3 else ""}
    if units is not None:
        rec["units"] = list(units)
    return rec, len(values) == 3


def _unreadable_key(rel, line, form):
    return (f"{rel}:{line}: implements/1 used with a key the checker cannot read ({form}) "
            f"-- write each provenance marker as a literal `implements(<key>)` goal so a "
            f"misspelt key is caught")


def _unqualified(cell):
    """`M:X` -> X (repeatedly); anything else unchanged."""
    while isinstance(cell, tuple) and len(cell) == 3 and cell[0] == ":":
        cell = cell[2]
    return cell


def _implements_indirect(term, goal_list):
    """The forms of every implements/1 use in a clause that is NOT a literal goal
    `implements(Key)` -- each one a marker whose key the checker cannot read:

      * the bare name `implements` given as a closure to call/N, maplist, foldl, include,
        exclude, partition (`call(implements, K)`, `maplist(implements, L)`, also
        module-qualified);
      * a term `implements(...)` held as DATA (`G = implements(k), call(G)`) -- anywhere
        in the clause outside goal position, head arguments and facts included;
      * the bare atom `implements` held as data anywhere else (`G =.. [implements, K]`).

    Occurrences are counted, not deduplicated by value: `_pl_walk` visits every subterm
    of the clause, the goal walk every goal-position one, and a data use is a walk
    occurrence the goal walk does not account for."""
    from _tools import pl_source
    forms = []
    closure_ids = set()                       # each closure use holds ONE bare atom
    for g in goal_list:
        if (isinstance(g, tuple) and len(g) >= 3 and g[0] in pl_source._CLOSURE_META
                and _unqualified(g[1]) == _IMPLEMENTS and id(g) not in closure_ids):
            forms.append(f"passed as a closure to {pl_source.indicator(g)}")
            closure_ids.add(id(g))
    goal_ids = {}
    for g in goal_list:
        goal_ids[id(g)] = goal_ids.get(id(g), 0) + 1
    head, _ = pl_source.rule(term)
    walk_ids, bare = {}, 0
    for c in _pl_walk(term):
        if c is term or (c is head and head is not term):
            continue                          # the clause itself; the head's own functor
        if isinstance(c, tuple) and len(c) == 2 and c[0] == _IMPLEMENTS:
            walk_ids[id(c)] = walk_ids.get(id(c), 0) + 1
        elif c == _IMPLEMENTS:
            bare += 1
    held = sum(max(0, n - goal_ids.get(i, 0)) for i, n in walk_ids.items())
    forms += ["implements(...) held as data, not called in place"] * held
    # the bare atom: its goal-position uses (a closure argument counted above, or the
    # atom `implements` as a goal, which is implements/0) are not data uses
    bare_goal = sum(1 for g in goal_list if g == _IMPLEMENTS)
    bare_closure = len(closure_ids)
    forms += ["the name implements held as data"] * max(0, bare - bare_goal - bare_closure)
    return forms


def _read_pl_domain(domain_dir):
    """Everything the .pl gate needs: {"registry" (False when there is no
    citations.pl), "recs", "duplicates", "cited", "implemented", "verbatim_pair",
    "problems"}. Raises MixedDomain / UnreadableDomain (named, never an empty set).
    """
    from _tools import pl_source
    pl = _prolog_sources(domain_dir)
    clausal = _clausal_sources(domain_dir)
    if pl and clausal:
        raise MixedDomain(
            f"{domain_dir}: mixed domain -- {len(clausal)} Clausal source(s) and "
            f"{len(pl)} Prolog source(s); check_citations does not support a domain "
            f"in both languages and refuses rather than guessing which one is live")
    registry = prolog_registry_path(domain_dir, _PL_REGISTRY_STEM)
    regname = os.path.basename(registry)
    read = {}
    for f in pl:
        try:
            read[f] = pl_source.read_pl_checked(f)
        except pl_source.UnreadablePl as e:
            raise UnreadableDomain(
                f"{os.path.relpath(f, domain_dir)}: Prolog source does not read ({e}) "
                f"-- check_citations cannot vouch for a file it cannot parse") from e
    recs, seen, verbatim_pair, problems = {}, {}, set(), []
    impl_defs = []
    for term, line in read.get(registry, ()):
        head, body = pl_source.rule(term)
        if isinstance(head, tuple) and len(head) == 2 and head[0] == _IMPLEMENTS:
            impl_defs.append((head, body))
            continue
        if not (isinstance(head, tuple) and len(head) == 3 and head[0] == "citation"):
            continue
        if body is not None:
            problems.append(f"citation/2 at {regname}:{line}: defined by a rule -- "
                            f"a citation record must be a fact")
            continue
        key = head[1]
        if not isinstance(key, str):
            problems.append(f"citation/2 at {regname}:{line}: the key is not an atom")
            continue
        seen[key] = seen.get(key, 0) + 1
        rec, extra = _pl_record(key, head[2])
        if rec is None:
            problems.append(extra)
            continue
        recs[key] = rec
        if extra:
            verbatim_pair.add(key)
    cited, implemented, use_problems = set(), {}, []
    for f, clauses in read.items():
        if f == registry:
            continue
        rel = os.path.relpath(f, domain_dir)
        for term, line in clauses:
            for c in _pl_walk(term):
                if isinstance(c, tuple) and len(c) == 2 and c[0] == "cite":
                    if isinstance(c[1], str):
                        cited.add(c[1])
                    elif not pl_source.is_var(c[1]):
                        use_problems.append(
                            f"{rel}:{line}: cite/1 argument is not an atom key -- a "
                            f"cite(Key) term names its citation/2 record by the atom Key "
                            f"and can never match one on it")
            goal_list = list(pl_source.clause_goals(term))
            for g in goal_list:
                if isinstance(g, tuple) and len(g) == 2 and g[0] == _IMPLEMENTS:
                    k = g[1]
                    if isinstance(k, str):
                        cited.add(k)
                        implemented.setdefault(k, (rel, line))
                    elif pl_source.is_var(k):
                        use_problems.append(_unreadable_key(
                            rel, line, "implements(Var) in goal position -- the key is "
                            "bound at run time"))
                    else:
                        use_problems.append(
                            f"{rel}:{line}: implements/1 argument is not an atom key -- "
                            f"implements/1 is citation(Key, _) and can never succeed on it")
            use_problems += [_unreadable_key(rel, line, form)
                             for form in _implements_indirect(term, goal_list)]
    problems += use_problems
    implements_ok = (len(impl_defs) == 1 and pl_source.is_var(impl_defs[0][0][1])
                     and isinstance(impl_defs[0][1], tuple) and len(impl_defs[0][1]) == 3
                     and impl_defs[0][1][0] == "citation"
                     and impl_defs[0][1][1] == impl_defs[0][0][1]
                     and impl_defs[0][1][2] != impl_defs[0][0][1]
                     and pl_source.is_var(impl_defs[0][1][2]))
    return {"registry": registry in read, "registry_name": regname, "implements_ok": implements_ok, "recs": recs, "duplicates": {a for a, n in seen.items() if n > 1},
            "cited": cited, "implemented": implemented,
            "verbatim_pair": verbatim_pair, "problems": problems,
            "use_problems": use_problems}


def _check_domain_pl(domain_dir):
    try:
        pl = _read_pl_domain(domain_dir)
    except (MixedDomain, UnreadableDomain) as e:
        return [str(e)]
    if not pl["registry"]:
        return [f"{domain_dir}: no {pl['registry_name']}"]
    recs = pl["recs"]
    problems = list(pl["problems"])
    if pl["implemented"] and not pl["implements_ok"]:
        # The typo check below is only sound if implements/1 IS citation(Key, _): a
        # weakened definition (a bare `implements(_).`, or none) makes every marker
        # succeed or fail regardless of the registry, silently.
        problems.append(
            f"{pl['registry_name']}: implements/1 is used but not defined exactly as "
            f"`implements(Key) :- citation(Key, _).` -- the provenance markers check "
            f"nothing without that definition")
    unrecorded = sorted(k for k in pl["implemented"] if k not in recs)
    for k in unrecorded:
        problems.append(
            f"{k}: implements({k}) but no citation record -- the clause it guards can "
            f"never succeed (implements/1 is citation(Key, _); under non-strict atoms "
            f"a misspelt key is a silent failure, not a load error)")
    # ONE finding per defect: an unrecorded implements key is reported above, with the
    # consequence spelt out, and not a second time as "cited but no citation record".
    # (Removing an atom with no record cannot change any record-side check below.)
    cited = pl["cited"] - set(unrecorded)
    problems += _registry_problems(domain_dir, recs, pl["duplicates"], cited,
                                   pl["registry_name"])
    sources = _load_sources(domain_dir)
    for a in sorted(pl["verbatim_pair"]):
        if ((sources.get(a) or {}).get("status") == "unverified"
                and not recs[a]["verbatim"].strip()):
            problems.append(f"{a}: marked unverified but carries an empty verbatim pair "
                            f"-- omit the pair (the unverified form has no verbatim key)")
    return problems


def records(domain_dir):
    """(recs, duplicates) for a domain's registry in EITHER language, or None when it
    has no registry file. For a .pl domain raises MixedDomain / UnreadableDomain rather
    than returning an empty set. `_records(text)` stays the Clausal text reader."""
    if _prolog_sources(domain_dir):
        pl = _read_pl_domain(domain_dir)
        return (pl["recs"], pl["duplicates"]) if pl["registry"] else None
    cpath = str(resolve_source(os.path.join(domain_dir, "citations.clausal")))
    if not os.path.exists(cpath):
        return None
    return _records(open(cpath, encoding="utf-8").read())


def pl_citation_signal(domain_dir):
    """For a .pl domain: True iff any other .pl source cites (`cite(K)` anywhere, or
    `implements(K)` in goal position, `Module:implements(K)` included) -- the .pl twin
    of check_provenance's Clausal `_cited_atoms` signal. A mixed or unreadable domain
    counts as a signal, and so does a cite/implements use whose key the checker cannot
    read (fail closed: check_domain then names the problem -- a domain whose ONLY
    markers are `maplist(implements, Keys)` must not skip the gate)."""
    try:
        pl = _read_pl_domain(domain_dir)
        return bool(pl["cited"] or pl["use_problems"])
    except (MixedDomain, UnreadableDomain):
        return True


def main(argv=None):
    argv = argv or sys.argv[1:]
    from _tools.source_files import has_rulebase, no_rulebase_note, missing_domain_problem
    missing = missing_domain_problem(argv[0])
    if missing:
        print(missing)
        return 1
    if not has_rulebase(argv[0]):
        print(no_rulebase_note(argv[0], "check_citations"))
        return 0
    problems = check_domain(argv[0])
    for p in problems:
        print("PROBLEM:", p)
    for a in advisories(argv[0]):
        print("ADVISORY:", a)
    print("OK" if not problems else f"{len(problems)} problem(s)")
    return 0 if not problems else 1

if __name__ == "__main__":
    sys.exit(main())
