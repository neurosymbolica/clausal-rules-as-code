#!/usr/bin/env python3
"""propose_provisions.py -- bracket a model that drafts unit<->clause bindings.

THIS TOOL DOES NOT CALL A MODEL; IT BRACKETS ONE. `--pack` (this file, Task 1)
emits the evidence a drafter needs. An operator runs a brief against the pack
outside this process. `--validate` (Task 2) rejects a returned proposal that
does not resolve. A human accepts a validated proposal into `citations.clausal`
and `manifest.yaml` by hand. See
docs/superpowers/plans/2026-08-19-propose-step.md and spec §8.

THE SAFETY PROPERTY THIS FILE MUST NEVER BREAK: this tool never writes the
citations registry -- in any syntax: `citations.seam`, `citations.clausal` (Clausal
Prolog since the extension flip) or `citations.pl` -- or `manifest.yaml`, not with a
flag, not with `--force`.
If it could write the artifact the gate enforces, the gate would be scoring
output this tool produced -- a checker validating its own draft. `--pack`
below has exactly one write call (`open(out_path, "w")`), and nothing about
the flow otherwise constrains where OUT_PATH points -- so that one call is
where the property actually has to be enforced, not merely stated in a
docstring. `_refused_out_path` runs BEFORE `build_pack` even reads the
domain, and refuses any `--out` whose BASENAME is one of the artifacts this
layer enforces (`citations.clausal`, `parameters.clausal`, `manifest.yaml`,
`provisions.yaml`) or whose path has a `sources` DIRECTORY COMPONENT, where a
pinned statute document lives. Matched on the path's own shape, never on
resolving it against a real domain's actual files: a basename check already
catches the realistic failure this exists for -- `--out
eu/vat/pro_rata_deduction/citations.clausal`, or `--out
../../some-domain/manifest.yaml` (`os.path.basename` does not care about the
`..` prefix either) -- and it needs no knowledge of which domains exist, so
it refuses correctly even for a `--pack` target outside the corpus or one
reached through a relative path built some other way. A resolved-identity
check (stat the target, compare it to every domain's own `manifest.yaml`)
would only additionally catch a file that IS one of these artifacts under
some OTHER name, which is not what "the enforced artifact" means here --
throughout this layer the artifact is identified by its own canonical
filename, never by content-sniffing a target this tool has not written yet.

NO MODEL CALL ANYWHERE IN THIS FILE. That is what makes `--pack` and
`--validate` each testable without one in the loop.

WHAT `--pack` EMITS, AND WHY IT IS BUILT FROM ONE `ledger.build()` CALL. A
pack that re-walked the domain with its own reader could disagree with the
ledger the checker actually scores -- two assemblies of the same facts that
can drift apart is this layer's recurring defect (see ledger.py's own
docstring). So `build_pack` calls `ledger.build` exactly once and reshapes
its fields; it does not call `clauses.scan_domain`, `registry.read_citations`
or `units.load_sources` a second time.

TWO RULES GOVERN THE SHAPE:

  * EMIT WHAT IS, NEVER WHAT SHOULD BE. A pack that orders units by "likely
    match" or hints that a clause probably implements some Article has
    already made the judgement the human is there to make. Units keep the
    ledger's own DOCUMENT order; clauses, records and deferral labels are
    exactly what the ledger and the registry already computed, carried
    through unchanged.
  * DETERMINISTIC AND DIFFABLE. Same domain, same bytes. Every list this
    module itself orders is sorted on a TUPLE, never a formatted string (see
    `_pack_clauses`, `_pack_records`), and every dict handed to
    `yaml.safe_dump` is a FRESH dict built for that one entry -- a shared
    dict reused across entries is exactly what makes `yaml.safe_dump` emit an
    `&id001`/`*id001` anchor pair into a supposedly plain document.

A UNIT'S TEXT IS RUNS, NEVER A JOINED STRING -- carried through from
`ledger.build`'s `doc_units` unchanged; see units.py's module docstring for
why joining them fabricates an adjacency the statute does not have. A unit's
`state` is a list, not a single word, because the ledger deliberately refuses
to resolve a unit that is BOTH covered and deferred (see spec §13.18 item 1,
live in the pilot's own `parag_174.001` today) -- collapsing that to one
label here would be this file re-introducing the resolution the ledger
declines to make.
"""
from _tools.source_files import source_stem, is_prolog
import os
import re
import sys

try:
    import yaml
except ImportError:                                     # pragma: no cover
    yaml = None

from _tools.provisions import ledger as _ledger
from _tools.provisions import units as _units


def _unit_state(unit_id, covered, deferred, unaccounted):
    """The memberships this unit id has in the ledger's own
    `covered`/`deferred`/`unaccounted` partition, tested independently. Not
    mutually exclusive: `covered` and `deferred` can both hold for one unit
    (the ledger's fifth, unresolved state -- spec §13.18 item 1, live in the
    pilot's own `parag_174.001` today) and the pack must show that rather
    than pick a winner. `unaccounted` never appears alongside either of the
    other two, because the ledger defines it as their complement."""
    return [key for key, members in
            (("covered", covered), ("deferred", deferred),
             ("unaccounted", unaccounted))
            if unit_id in members]


def _pack_units(built):
    """Units in the ledger's own DOCUMENT order -- never re-sorted here, for
    the same reason `ledger.build` itself keeps it: a reviewer reads down the
    statute, and a sorted list interleaves Article 10 with Article 1."""
    covered = set(built["covered"])
    deferred = set(built["deferred"])
    unaccounted = set(built["unaccounted"])
    return [
        {
            "id": unit["id"],
            "runs": [{"pos": run["pos"], "text": run["text"]}
                     for run in unit["runs"]],
            "state": _unit_state(unit["id"], covered, deferred, unaccounted),
        }
        for unit in built["doc_units"]
    ]


def _pack_clauses(built):
    """Operative clauses from `ledger.build`'s own `clauses` key -- itself
    `clauses.scan_domain`'s return, UNCHANGED. Sorted on `(file, line)`, the
    TUPLE, never on the formatted `"file:line"` string: `"k.clausal:10"` sorts
    before `"k.clausal:9"` as text (see `ledger._sites`, the same rule)."""
    return [
        {
            "file": clause.file,
            "line": clause.line,
            "functor": clause.functor,
            "arity": clause.arity,
            "cites": list(clause.cites),
            "indirect_cite": clause.indirect_cite,
        }
        for clause in sorted(built["clauses"], key=lambda c: (c.file, c.line))
    ]


def _pack_records(built, kind):
    """Existing registry records of one KIND ("citation" or "parameter"),
    sorted on `(atom,)` -- a citation and a parameter atom live in separate
    namespaces (`ledger._by_atom`'s own reason), so this file keeps them
    separate too rather than presenting one merged, ambiguous list."""
    return [
        {
            "atom": record.atom,
            "units": list(record.units),
            "verbatim": record.verbatim,
        }
        for record in sorted(
            (r for r in built["records"] if r.kind == kind),
            key=lambda r: (r.atom,))
    ]


def _pack_deferrals(built):
    """The manifest's `deferred_set`, AUTHORED order (never sorted) -- the
    order the register lists them in and a reviewer reads them in, the same
    rule `ledger._finish_attribution` states for the same field. Every entry
    here already survived `ledger._deferrals`' own shape check (a non-dict
    entry is reported to `problems` and dropped before it reaches
    `built["deferrals"]`), so `entry.get(...)` needs no further guarding.

    `label` is `built["deferral_labels"]`'s own verdict -- authorized (the
    order's own `deferred_set` names this `what`) or expansion (the domain
    narrowed its own scope without the order's sanction) -- carried, never
    recomputed: a second computation here could disagree with the one T5's
    order-honoured check actually runs against.
    """
    labels = built["deferral_labels"]
    out = []
    for entry in built["deferrals"]:
        what = entry.get("what")
        out.append({
            "what": what,
            "reason": entry.get("reason"),
            "consequence": entry.get("consequence"),
            "units": list(entry.get("units") or []),
            "label": labels.get(what) if isinstance(what, str) else None,
        })
    return out


def _pack_exclusions(built):
    """The manifest's `excluded_set`, same rules as `_pack_deferrals` over the
    other relation (spec 13.21).

    `cites`, not `units` -- and the different key name is the point: a drafter
    reading this pack must not be able to copy an exclusion into a deferral, or
    the other way, without the shape complaining. An exclusion addresses
    provisions this domain never pinned, so there is no unit text to carry
    beside it and none is carried.
    """
    labels = built["exclusion_labels"]
    out = []
    for entry in built["exclusions"]:
        what = entry.get("what")
        out.append({
            "what": what,
            "reason": entry.get("reason"),
            "consequence": entry.get("consequence"),
            "cites": list(entry.get("cites") or []),
            "label": labels.get(what) if isinstance(what, str) else None,
        })
    return out


def build_pack(domain_dir):
    """The `--pack` evidence bundle for one domain. Never raises on domain
    content -- `ledger.build` already returns `(value, problems)`-shaped
    reads throughout and this function adds no read of its own, so an
    unreadable domain surfaces as `pack["problems"]`, not a traceback.
    """
    built = _ledger.build(domain_dir)
    return {
        "domain_id": built["domain_id"],
        "provision_tracking": built["provision_tracking"],
        "manifest_unreadable": built["manifest_unreadable"],
        "has_order": built["has_order"],
        "order_deferrals": list(built["order_deferrals"]),
        "order_exclusions": list(built["order_exclusions"]),
        "units": _pack_units(built),
        "clauses": _pack_clauses(built),
        "citation_records": _pack_records(built, "citation"),
        "parameter_records": _pack_records(built, "parameter"),
        "deferrals": _pack_deferrals(built),
        "exclusions": _pack_exclusions(built),
        # Carried whole, unlike the two scope registers, which are projected
        # onto a fixed field list. A reading's shape is the evidence -- the
        # question, BOTH readings and their consequences, the authority, the
        # review record -- and a drafter handed a projection of it would be
        # deciding an interpretive question from a summary of one.
        "operative_readings": [dict(entry)
                               for entry in built["operative_readings"]],
        "order_readings": list(built["order_readings"]),
        # Real facts about this read -- an unparseable citations.clausal, a
        # unit id that resolves to nothing -- are evidence a drafter needs
        # too, not noise to strip. Order preserved (`ledger._dedupe`'s own
        # first-seen order), never re-sorted into a formatted-string order.
        "problems": list(built["problems"]),
    }


#: Prepended to every emitted pack, in the pack itself, so the safety
#: property is visible to anyone who opens the file, not only to a reader of
#: this module's docstring.
_HEADER = (
    "# GENERATED by `propose_provisions.py --pack`. Read-only evidence for a\n"
    "# drafter -- this tool never writes a citations registry (citations.seam,\n"
    "# citations.clausal or citations.pl) or manifest.yaml, and calls no model.\n"
    "# See docs/superpowers/plans/2026-08-19-propose-step.md.\n"
)


def dump_pack(pack):
    """The pack as YAML text, deterministic byte-for-byte across two calls on
    an unchanged domain.

    `sort_keys=True` orders each dict's OWN keys (harmless -- it never
    reorders a list, so unit/clause/record ORDER, which is what carries the
    document-order and tuple-sort invariants above, is untouched). Every dict
    reaching `yaml.safe_dump` here was built fresh by `build_pack` -- a
    comprehension constructing one dict literal per entry -- so no object
    reachable from `pack` is shared between two positions, and `safe_dump`
    therefore emits no `&id001`/`*id001` anchor pair.
    """
    if yaml is None:                                    # pragma: no cover
        raise RuntimeError(
            "--pack needs PyYAML and it is not installed. This is loud on "
            "purpose: a silently skipped pack is indistinguishable from an "
            "empty domain.")
    return _HEADER + yaml.safe_dump(
        pack, sort_keys=True, default_flow_style=False, allow_unicode=True)


#: ═══════════════════════════════════════════════════════════════════════════
#: Task 2/3 -- the proposal schema and `--validate`.
#: ═══════════════════════════════════════════════════════════════════════════
#:
#: A PROPOSAL IS DATA, NEVER CODE -- a plain mapping a drafter (a model, a
#: person) hands back after reading a `--pack`, shaped:
#:
#:   citation_records:
#:     - atom: eu_vat_art_174_1        # str, required
#:       units: [DOC#parag_174.001]    # list of str, required
#:       verbatim: "The deductible..." # str, required
#:       label: "Directive .../174(1)" # str, optional
#:       ref: "https://eur-lex..."     # str, optional
#:   clauses:
#:     - predicate: deductible_vat/2   # str, required -- functor/arity, the
#:                                     #   same spelling `ledger.no_statute_key`
#:                                     #   already uses for a predicate ref
#:       cites: [eu_vat_art_174_1]     # list of str, required
#:   deferrals:
#:     - what: capital_goods_adjustment  # str, required -- the register's key
#:       units: [DOC#parag_187.001]      # list of str, required
#:
#: All three top-level keys are optional (a proposal may address only some of
#: what a pack offers); if present each must be a list.
#:
#: `validate_proposal(pack, proposal)` NEVER RAISES on a malformed proposal --
#: the whole point is that a drafter's mistake is a REPORTED rejection, not a
#: traceback, so a human sees every problem in one pass rather than the first
#: one a crash happened to hit. It returns a list of problem strings, `[]`
#: meaning accept; `--validate` prints every one of them (never just the
#: first) and exits non-zero if the list is non-empty.
#:
#: FOUR REJECTION CLASSES, each stated in the pack's own terms so a drafter
#: never has to re-derive them from the domain a second time:
#:   * a unit id resolving to no unit in the pack's `units` (the pinned
#:     document(s)) -- the T3-class defect, checked for both citation-record
#:     units and deferral units, since both are "a unit id claimed against the
#:     document" the same way;
#:   * a predicate ref (`functor/arity`) naming no clause in the pack's
#:     `clauses`;
#:   * a duplicate atom within the proposal, or an atom the pack's own
#:     `citation_records` already binds to different units/verbatim;
#:   * a malformed proposal -- wrong shape, a missing key, a wrong type.
#: PLUS Task 3's verbatim check, below.


def _bad_type(where, expected, value):
    return f"{where}: expected {expected}, got {type(value).__name__} ({value!r})"


def _is_list_of_str(value):
    return isinstance(value, list) and all(isinstance(v, str) for v in value)


def _selector_problem(where, selector, run_counts):
    """`None` if SELECTOR resolves against RUN_COUNTS, else a message naming
    why -- shared by the citation-record and deferral checks so an unknown
    unit and an out-of-range run selector (spec 13.20 rule 1) are worded the
    same way in both places.
    """
    unit_id, _, problem = _units.resolve_selector(selector, run_counts)
    if problem is None:
        return None
    if problem == _units.UNKNOWN_UNIT:
        return (f"{where}: unit id {selector!r} resolves to no unit in the "
                f"pinned document(s)")
    total = run_counts[unit_id]
    return (f"{where}: unit id {selector!r} names a run selector out of "
            f"range -- {unit_id} has {total} run{'s' if total != 1 else ''}")


def _validate_citation_records(entries, run_counts, existing_by_atom):
    """`(problems, resolved)` for the proposal's `citation_records` list.

    `resolved` carries only the STRUCTURALLY SOUND entries -- `(index, atom,
    units, verbatim)` -- because a malformed entry (no usable atom, or a
    `units`/`verbatim` of the wrong shape) cannot be fed to the duplicate,
    already-bound or Task 3 verbatim checks without inventing a value it never
    had; those checks run only over what the proposal actually gave.

    A `units:` entry may address a single RUN (`<doc_id>#<eid>/<n>`, spec
    13.20) -- `run_counts` (`{unit id: number of runs}`) is what
    `units.resolve_selector` checks it against, the same function every other
    `units:` consumer (the ledger, T3, T5) goes through, so an unknown unit
    and an out-of-range run selector are reported the same way everywhere.
    """
    problems, resolved = [], []
    for index, entry in enumerate(entries):
        where = f"citation_records[{index}]"
        if not isinstance(entry, dict):
            problems.append(_bad_type(where, "a mapping", entry))
            continue
        ok = True
        if "atom" not in entry:
            problems.append(f"{where}: missing required key 'atom'")
            ok = False
        elif not isinstance(entry["atom"], str) or not entry["atom"].strip():
            problems.append(
                f"{where}.atom: expected a non-empty string, got "
                f"{entry['atom']!r}")
            ok = False
        if "units" not in entry:
            problems.append(f"{where}: missing required key 'units'")
            ok = False
        elif not _is_list_of_str(entry["units"]):
            problems.append(
                f"{where}.units: expected a list of strings, got "
                f"{entry['units']!r}")
            ok = False
        if "verbatim" not in entry:
            problems.append(f"{where}: missing required key 'verbatim'")
            ok = False
        elif not isinstance(entry["verbatim"], str):
            problems.append(
                f"{where}.verbatim: expected a string, got "
                f"{entry['verbatim']!r}")
            ok = False
        for key in ("label", "ref"):
            if key in entry and not isinstance(entry[key], str):
                problems.append(
                    f"{where}.{key}: expected a string, got {entry[key]!r}")
        if not ok:
            continue
        atom, units, verbatim = entry["atom"], entry["units"], entry["verbatim"]
        for selector in units:
            message = _selector_problem(
                f"{where} (atom {atom!r})", selector, run_counts)
            if message is not None:
                problems.append(message)
        resolved.append((index, atom, units, verbatim))

    seen_at = {}
    for index, atom, units, verbatim in resolved:
        where = f"citation_records[{index}]"
        if atom in seen_at:
            problems.append(
                f"{where}: atom {atom!r} is a duplicate -- already proposed "
                f"by citation_records[{seen_at[atom]}]")
            continue
        seen_at[atom] = index
        existing = existing_by_atom.get(atom)
        # An existing record with NO units is the not-yet-bound state
        # (`registry._units`), not a competing binding -- and since every
        # usable atom already has a `citation/2` record, reading it as one
        # would refuse every atom this loop exists to bind. Its verbatim is
        # equally unbound: a proposal may replace it, and Task 3 below still
        # checks the proposed text against the pinned statute run. Only a
        # record that ALREADY carries units can conflict.
        if existing is not None and list(existing["units"]) and (
                list(existing["units"]) != list(units)
                or existing["verbatim"] != verbatim):
            problems.append(
                f"{where}: atom {atom!r} is already bound by an existing "
                f"citation record with different units/verbatim -- existing "
                f"units={list(existing['units'])!r} "
                f"verbatim={existing['verbatim']!r}, proposed "
                f"units={list(units)!r} verbatim={verbatim!r}")
    return problems, resolved


def _validate_clauses(entries, known_predicates):
    problems = []
    for index, entry in enumerate(entries):
        where = f"clauses[{index}]"
        if not isinstance(entry, dict):
            problems.append(_bad_type(where, "a mapping", entry))
            continue
        predicate = entry.get("predicate")
        if "predicate" not in entry:
            problems.append(f"{where}: missing required key 'predicate'")
        elif not isinstance(predicate, str) or not predicate.strip():
            problems.append(
                f"{where}.predicate: expected a non-empty string, got "
                f"{predicate!r}")
        elif predicate not in known_predicates:
            problems.append(
                f"{where}: predicate ref {predicate!r} names no operative "
                f"clause in the domain (known: {sorted(known_predicates)!r})")
        if "cites" not in entry:
            problems.append(f"{where}: missing required key 'cites'")
        elif not _is_list_of_str(entry["cites"]):
            problems.append(
                f"{where}.cites: expected a list of strings, got "
                f"{entry['cites']!r}")
    return problems


def _validate_deferrals(entries, run_counts):
    problems = []
    for index, entry in enumerate(entries):
        where = f"deferrals[{index}]"
        if not isinstance(entry, dict):
            problems.append(_bad_type(where, "a mapping", entry))
            continue
        what = entry.get("what")
        if "what" not in entry:
            problems.append(f"{where}: missing required key 'what'")
        elif not isinstance(what, str) or not what.strip():
            problems.append(
                f"{where}.what: expected a non-empty string, got {what!r}")
        if "units" not in entry:
            problems.append(f"{where}: missing required key 'units'")
        elif not _is_list_of_str(entry["units"]):
            problems.append(
                f"{where}.units: expected a list of strings, got "
                f"{entry['units']!r}")
        else:
            for selector in entry["units"]:
                message = _selector_problem(
                    f"{where} (what {what!r})", selector, run_counts)
                if message is not None:
                    problems.append(message)
    return problems


#: How much of a quote a divergence message shows on either side of the
#: point it stopped matching -- enough to find the place, short enough to
#: read. Independent of `check_provisions.QUOTE_WINDOW`: a shared import
#: across the enforced gate and this pre-gate tool would couple two things
#: that are allowed to disagree about a display width.
QUOTE_WINDOW = 60


def _normalise_whitespace(text):
    """Line wrapping is not semantic, in the document or in a quote.

    Deliberately a LOCAL two-liner, not an import of `units._normalise`, for
    the same reason `check_provisions._normalise_whitespace` gives for its own
    copy: unit text arrives from the pack already normalised (this is a no-op
    on it), the text that actually needs normalising is the proposal's
    `verbatim`, and if the two ever needed to agree on something subtler than
    `\\s+` that belongs in the reader, not in a private cross-file coupling.
    """
    return re.sub(r"\s+", " ", text or "").strip()


def _validate_verbatims(resolved, units_by_id):
    """Task 3 -- each resolved record's `verbatim` must be containment-
    matchable inside a SINGLE RUN of one of the unit ids it binds.

    NOT `check_provisions._check_t5`'s `_segments`: T5 joins a record's named
    units' ADJACENT runs (by document `pos`) into maximal segments, because a
    chapeau-and-its-points citation is legitimately one sentence read across
    an anchor boundary. This check does not join anything, even two runs that
    ARE adjacent -- a proposal is checked before a human has looked at it, and
    the point of the check is that a quote spanning a run boundary is
    EXACTLY the fabricated-adjacency hazard `Unit.runs` exists to name (see
    `units.py`'s module docstring): certifying it here would wave through the
    very defect the pinned document makes mechanically checkable. A proposal
    whose true citation legitimately spans two runs is not blocked forever by
    this -- it is bound as two records, or as one record listing both units,
    each with its own single-run quote; only a JOINED quote is refused.

    REUSES `units._matched_prefix`, never a second matcher: two containment
    checks that could disagree about where a quote diverges is this layer's
    own recurring defect (T5's docstring and this module's both name it).

    A `units:` entry may address a single RUN (`<doc_id>#<eid>/<n>`, spec
    13.20). Resolved through `units.resolve_selector` -- the one function
    every `units:` consumer goes through -- so a record binding `…/1` is
    checked ONLY against run 1's text, never against the whole unit's runs:
    a selector that named one run must not be defended by a match the
    author never claimed.
    """
    run_counts = {unit_id: len(runs) for unit_id, runs in units_by_id.items()}
    problems = []
    for index, atom, units, verbatim in resolved:
        where = f"citation_records[{index}] (atom {atom!r})"
        quote = _normalise_whitespace(verbatim)
        # (unit_id, run text) for every run each selector actually addresses
        # -- every run for a bare id, the ONE run for a `/n` selector. A
        # selector that failed T3-class resolution (unknown unit, or a run
        # out of range) contributes nothing: that is the one defect to
        # report, not a second one layered on a quote with no run left to
        # check against.
        candidates = []
        for selector in units:
            unit_id, positions, problem = _units.resolve_selector(
                selector, run_counts)
            if problem is not None:
                continue
            for position in positions:
                candidates.append(
                    (unit_id, units_by_id[unit_id][position - 1]["text"]))
        if not candidates:
            continue
        found = False
        best_matched, best_unit = -1, None
        for unit_id, text in candidates:
            run_text = _normalise_whitespace(text)
            if quote in run_text:
                found = True
                break
            matched = _units._matched_prefix(quote, run_text)
            if matched > best_matched:
                best_matched, best_unit = matched, unit_id
        if found:
            continue
        bound_units = sorted({unit_id for unit_id, _ in candidates})
        problems.append(
            f"{where}: verbatim is not containment-matchable within a "
            f"SINGLE RUN of any bound unit ({', '.join(bound_units)}). "
            f"Closest match is in {best_unit!r}: matched up to "
            f"…{quote[max(0, best_matched - QUOTE_WINDOW):best_matched]!r} "
            f"and then reads "
            f"{quote[best_matched:best_matched + QUOTE_WINDOW]!r}…, which is "
            f"not how that unit's own run continues. If the quote spans two "
            f"runs of one unit, that is a fabricated adjacency, not a typo -- "
            f"see units.py's module docstring.")
    return problems


def validate_proposal(pack, proposal):
    """Every rejection a PROPOSAL earns against a PACK, `[]` meaning accept.

    Never raises: a proposal is drafted output, and this function's whole
    purpose is to turn a drafter's mistake into a reported list rather than a
    traceback. Reads `pack` only (never touches a domain directory itself,
    never calls `build_pack` -- the caller decides how fresh the pack is), so
    it is testable against a hand-built pack with no filesystem at all.
    """
    if not isinstance(proposal, dict):
        return [_bad_type("proposal", "a mapping", proposal)]

    run_counts = {u["id"]: len(u["runs"]) for u in pack["units"]}
    known_predicates = {_ledger.no_statute_key(c["functor"], c["arity"])
                         for c in pack["clauses"]}
    existing_by_atom = {r["atom"]: r for r in pack["citation_records"]}
    units_by_id = {u["id"]: u["runs"] for u in pack["units"]}

    problems = []
    sections = {}
    for key in ("citation_records", "clauses", "deferrals"):
        value = proposal.get(key, [])
        if not isinstance(value, list):
            problems.append(_bad_type(key, "a list", value))
            value = []
        sections[key] = value

    record_problems, resolved = _validate_citation_records(
        sections["citation_records"], run_counts, existing_by_atom)
    problems += record_problems
    problems += _validate_clauses(sections["clauses"], known_predicates)
    problems += _validate_deferrals(sections["deferrals"], run_counts)
    # Task 3, over the citation records that survived Task 2's shape/id
    # checks -- an entry too malformed to have a trustworthy `units`/
    # `verbatim` has nothing here to check.
    problems += _validate_verbatims(resolved, units_by_id)
    return problems


def _load_proposal(path):
    """`(proposal, problems)` -- a proposal file read as YAML, never raising.
    Mirrors `ledger._load_yaml`'s own contract for the same reason: an
    unreadable proposal is a reported rejection, not a crash."""
    if not os.path.exists(path):
        return None, [f"{path}: no such file"]
    if yaml is None:                                    # pragma: no cover
        return None, [f"{path}: present but PyYAML is not installed"]
    try:
        with open(path, encoding="utf-8") as handle:
            loaded = yaml.safe_load(handle)
    except (yaml.YAMLError, OSError, UnicodeDecodeError) as exc:
        return None, [f"{path}: cannot be read as YAML -- {exc}"]
    return loaded, []


def _run_validate(domain_dir, proposal_path):
    """`--validate`'s body: read-only both ways -- `build_pack` never writes
    (Task 1's own contract) and this function itself has no `open(..., "w")`
    anywhere. Prints EVERY rejection, never just the first, then a count; the
    exit code is the only thing a caller needs to script against."""
    pack = build_pack(domain_dir)
    proposal, load_problems = _load_proposal(proposal_path)
    problems = list(load_problems)
    if proposal is not None:
        problems += validate_proposal(pack, proposal)
    for problem in problems:
        print("REJECTED:", problem)
    if not problems:
        print("OK")
        return 0
    print(f"{len(problems)} rejection(s)")
    return 1


#: Filenames this tool refuses to write to via `--out`, regardless of which
#: directory they are spelled under. `citations.clausal` and `manifest.yaml`
#: are the two the plan names by name; `parameters.clausal` is
#: citations.clausal's sibling registry (`registry.py` reads both the same
#: way, under the same enforcement); `provisions.yaml` is the ledger's own
#: COMMITTED artifact (`check_provisions.py --emit`), which a stray pack must
#: not silently replace either -- a renderer trusts it to be what the gate
#: actually scored, not a pack this tool produced.
_PROTECTED_BASENAMES = frozenset({
    "citations.clausal", "parameters.clausal", "manifest.yaml",
    "provisions.yaml",
})

#: The seam-suffixed members of the above, by stem, so protection does not
#: lapse the moment a registry is renamed: `citations.seam` matches no literal
#: here and a stray pack would have been free to overwrite it.
_PROTECTED_STEMS = frozenset({"citations", "parameters"})

#: A path with a `sources` DIRECTORY COMPONENT anywhere in it is refused
#: wholesale, rather than naming only the two filenames that live there
#: today (`*.meta.yaml`, the fetched document body) -- the pinned statute
#: lives in that directory, and a filename this tool does not yet know about
#: is exactly the case a fixed list of basenames would miss.
_PROTECTED_DIR_COMPONENT = "sources"


def _refused_out_path(out_path):
    """Why `--out OUT_PATH` must be refused, or `None` if it is fine.

    See the module docstring's safety-property paragraph for why this is a
    BASENAME/path-shape check, not a resolved-identity check against a real
    domain's actual files.
    """
    name = os.path.basename(out_path)
    # Either syntax's registry: `source_stem` strips only seam suffixes, so a Prolog
    # `citations.pl` (or post-flip `citations.clausal`) is stemmed here too.
    stem = os.path.splitext(name)[0] if is_prolog(name) else source_stem(name)
    if name in _PROTECTED_BASENAMES or stem in _PROTECTED_STEMS:
        return (f"{name!r} is a name this layer enforces -- "
                f"citations.clausal, parameters.clausal, manifest.yaml and "
                f"provisions.yaml never come from --pack, under any "
                f"directory")
    parts = os.path.normpath(out_path).split(os.sep)
    if _PROTECTED_DIR_COMPONENT in parts:
        return (f"it has a '{_PROTECTED_DIR_COMPONENT}/' path component, "
                f"where a pinned statute document lives")
    return None


USAGE = ("usage: propose_provisions.py --pack <domain_dir> [--out <path>]\n"
         "       propose_provisions.py --validate <domain_dir> <proposal_path>")


def _parse_pack(argv):
    """`(domain_dir, out_path)`, or `(None, None)` for a malformed command
    line. A misuse fails LOUD -- `--out` with no path silently packing to
    stdout is how a stale file outlives the pack it claims to hold."""
    argv = list(argv)
    out_path = None
    if "--out" in argv:
        index = argv.index("--out")
        if index + 1 >= len(argv):
            return None, None
        out_path = argv[index + 1]
        del argv[index:index + 2]
    if len(argv) != 1:
        return None, None
    return argv[0], out_path


def _parse_validate(argv):
    """`(domain_dir, proposal_path)`, or `(None, None)` for a malformed
    command line -- exactly two positional arguments, no flags of its own."""
    argv = list(argv)
    if len(argv) != 2:
        return None, None
    return argv[0], argv[1]


def main(argv=None):
    argv = sys.argv[1:] if argv is None else argv
    if not argv or argv[0] not in ("--pack", "--validate"):
        print(USAGE, file=sys.stderr)
        return 2

    if argv[0] == "--validate":
        domain_dir, proposal_path = _parse_validate(argv[1:])
        if domain_dir is None:
            print(USAGE, file=sys.stderr)
            return 2
        return _run_validate(domain_dir, proposal_path)

    domain_dir, out_path = _parse_pack(argv[1:])
    if domain_dir is None:
        print(USAGE, file=sys.stderr)
        return 2

    # Checked BEFORE the domain is even read: a refusal writes nothing and
    # costs nothing, rather than building a pack it then declines to save.
    if out_path:
        refusal = _refused_out_path(out_path)
        if refusal is not None:
            print(f"propose_provisions: refusing to write {out_path!r}: "
                  f"{refusal}", file=sys.stderr)
            return 1

    pack = build_pack(domain_dir)
    text = dump_pack(pack)
    if out_path:
        with open(out_path, "w", encoding="utf-8") as handle:
            handle.write(text)
    else:
        sys.stdout.write(text)
    return 0


if __name__ == "__main__":
    sys.exit(main())
