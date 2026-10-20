#!/usr/bin/env python3
"""check_provisions.py -- statute<->rulebase coverage (T1, T2, T3, T5),
deferral discipline (spec §6), the enforcement ratchet (spec §5) and `--emit`.

Follows `check_citations.py`'s contract exactly -- `check_domain(domain_dir) ->
list[str]`, `main(argv)` printing `PROBLEM: ...` per problem then `OK` or
`N problem(s)` -- so `check_corpus_tool` and the pre-commit hook pick it up with
no new wiring.

WHAT THIS CLAIMS, AND WHAT IT DELIBERATELY DOES NOT. The gate guarantees
TOTALITY (nothing in the statute unaccounted for, no rule without a provision),
REFERENTIAL INTEGRITY (every account resolves to something real) and VERBATIM
FIDELITY (a quoted provision is quoted, not paraphrased or abridged). It does
NOT check that a cite names the RIGHT provision, nor that a deferral is SOUND.
Both are judgment, and a gate claiming them would manufacture false greens --
which is the failure class this whole layer exists to catch. Those belong to the
report and the attestation. Do not add checks that imply otherwise.

T5 is the narrow, mechanical part of "the right provision" that a machine CAN
settle: whether the words a record quotes are in the units it names. The one
existing draft vat citation manifest dropped "transactions included in the
numerator and" from Art 174(1)(b) -- an inversion of the fraction that reads
perfectly well in isolation and satisfies every other check here.

T4 (pin integrity) is NOT here. It lives in `units.load_sources`, where a
sha256 mismatch withholds that document's units, and it reaches the output
through the ledger's `problems`. Re-implementing it here would double-report it
and could disagree with the ledger about which documents were read.

IT READS THE LEDGER AND NOTHING ELSE. `ledger.build` composes every reader, so a
check that re-read a source or re-scanned a file could see different text from
the artifact the renderer displays -- this layer reproducing its own failure
mode in miniature. If a check needs something the ledger does not carry, the
ledger gains it.

THE THREE STATES. Failed, clean, and NOT TRACED are distinct, and the third is
60 of 60 domains on day one:

  * a domain with no pinned unit store has nothing to check -- T1, T2, T3 and
    T5 are all meaningless without one -- so the checks early-return. Nothing
    there is "satisfied"; it is unasked. For T3 and T5 the early return is not
    merely a nicety: with no document EVERY unit id resolves to nothing and
    every quote is unfindable, so 60 of 60 domains would redden wholesale on
    the day this landed.
  * `main` says so IN THOSE WORDS and prints no `OK` at all, because `OK` reads
    as "audited and clean" and would make the campaign's own progress
    unreadable. The untraced run therefore ends on `UNTRACED_NOTE` -- the exit
    code is still 0, but nothing in the output claims a verdict.
  * UNTRACED IS ITSELF A PROBLEM ON AN ENFORCED DOMAIN, and that is the one
    place the third state is not merely quiet. "No sources/" as a green was
    written for the UNDECLARED population; a domain carrying
    `provision_tracking: enforced` has committed to being traced, so a single
    `git rm -r sources/` would otherwise un-arm T1, T2, T3, T5 and §6 together
    and still exit 0. See `_check_enforced_is_traced`.
  * reader PROBLEMS still propagate in every state. The ratchet governs
    `problems` and nothing else, so swallowing them here restores the bypass the
    readers' error channel exists to close.
  * spec §6's ORDER-HONOURED check does NOT. It needs no document -- it compares
    the order's `deferred_set` to the manifest register -- but an untraced
    domain has not entered the campaign and is not yet expected to carry a
    register, so it runs only on the traced path. See `check_domain`, which
    records what that costs. The two other §6 duties are not problems at all:
    `deferral_labels` (authorized vs expansion) and `deferral_smells` (the
    boilerplate advisory) live in the ledger, and a check that turned either
    into a failure would claim the soundness judgment this gate does not have.

THE RATCHET (spec §5) IS THE PROPERTY THE CAMPAIGN DEPENDS ON, and it governs
the EXIT CODE only -- never which checks run, never what is printed:

  * `provision_tracking: enforced` in the manifest -> COVERAGE problems are
    blocking, exit 1; annotation debt (`DEBT_TAGS`, i.e. T1) prints exactly as
    it always did and never reaches the exit code -- see `blocking_problems`;
  * anything else, including absent -> the same problems print, exit 0, and the
    output SAYS why it did not block (`NOT_ENFORCED_NOTE`);
  * a manifest that is PRESENT AND UNREADABLE is neither: the declaration is
    unknown, not absent, so a domain that has problems blocks. See
    `enforcement_unknown`, which argues the choice.
  * advisories print in every state and are never problems, so they can never
    reach the exit code.

An undeclared domain therefore sees no behaviour change beyond extra printed
lines, which is what lets this land mid-campaign without disturbing baselines --
0 of the 60 tracked manifests declare `provision_tracking:` today. The ratchet reads
the LEDGER's `provision_tracking`, not a second manifest read: two reads could
disagree about the very field that decides whether a domain blocks.

`--emit` writes `provisions.yaml`, and `emit` takes the SAME built ledger the
run scored, so the artifact a renderer displays is by construction the artifact
the gate scored. Spec §8 says renderers read only that file, so it must be
sufficient on its own -- unit TEXT, per-unit state, the deferral entries with
reason and consequence, the exemption table and the headline. It is committed,
so it is written deterministically: sorted keys, sorted lists, no set iteration
order and no environment-dependent text (see `build_document`, which records why
the problem STRINGS are the one thing it does not carry).

THAT GUARANTEE IS EMIT-TIME ONLY, so a COMMITTED `provisions.yaml` is checked
against a fresh in-memory emit on every run (`_check_artifact_drift`). Spec §4
commits the file so coverage changes are reviewable and §8 makes it a renderer's
only input; both die at the first post-emit edit -- one clause edit later, the
gate rescores from the live ledger and the committed artifact silently says
something else. The drift is a PROBLEM and the file is never regenerated behind
the operator's back: a gate that quietly rewrote it would hide the very diff
§4 commits it for.
"""
import os
import re
import sys

from _tools.provisions import clauses as _clauses
from _tools.provisions import ledger as _ledger
from _tools.provisions import resolve as _resolve
from _tools.provisions import units as _units

try:
    import yaml
except ImportError:                                     # pragma: no cover
    yaml = None

#: Said in `main`'s output whenever the domain carries no unit store. Spec 5's
#: "checks still run and print" governs an UNENFORCED domain (one with sources
#: that has not opted into blocking); this is the different, earlier state of
#: having nothing to check at all.
UNTRACED_NOTE = (
    "not traced — no pinned statute under sources/, so T1, T2, T3 and T5 have "
    "nothing to check. This is NOT an audited-clean result.")

#: Printed under every non-blocking failure. Spec §5's "checks still run and
#: print, exit 0" is only half a contract: a reader who sees PROBLEM lines and a
#: zero exit must be told which of the two is the mistake, or the next author
#: reads the green build as "these were waived".
NOT_ENFORCED_NOTE = (
    "not enforced — reporting only, so this exits 0 and blocks nothing. The "
    "problems above are real; set `provision_tracking: enforced` in manifest.yaml to "
    "make the coverage ones blocking (annotation debt is reported either way).")

#: The manifest value that says this domain has NO STATUTE TO PIN — not that it
#: has one nobody got round to. Distinct from an absent `provision_tracking`,
#: which means "traceable, untraced", and from `enforced`, which arms the gate.
#:
#: WHY THE STATE HAS TO EXIST. `UNTRACED_NOTE` tells a reader that T1/T2/T3/T5
#: had nothing to check and that this is "NOT an audited-clean result" — correct
#: for a domain awaiting a pin, and WRONG for one whose sources are not
#: legislation at all. eu/peppol_einvoicing formalizes EN 16931-1 (a CEN standard
#: that is sold) and PEPPOL BIS Billing 3.0 (an OpenPEPPOL specification): there
#: is no statute to pin, so counting it as untraced debt asks for work that
#: cannot be done and hides it among work that can.
EXEMPT = "exempt"

#: An exemption WITHOUT stated prose is not an exemption. Same rule as ENFORCED:
#: only a complete declaration counts, because the failure this layer exists to
#: remove is a domain that believes it declared something and did not. An
#: unexplained `provision_tracking: exempt` would be a one-word way to delete a
#: domain from the accounting, which is precisely what must not be easy.
EXEMPTION_REASON_KEY = "provision_tracking_exemption"

#: Printed instead of `UNTRACED_NOTE` for a declared, explained exemption.
EXEMPT_NOTE = (
    "exempt — this domain declares `provision_tracking: {EXEMPT}` because it has no "
    "pinnable statute, and states why. T1, T2, T3 and T5 have nothing to check and "
    "that is the DESIGNED state here, not debt: it is not waiting for a pin. Reason "
    "given: {reason}").replace("{EXEMPT}", EXEMPT)

#: Printed when a domain claims exemption without saying why. It does NOT become
#: exempt: an unexplained exemption is a silent deletion from the accounting.
INCOMPLETE_EXEMPTION_NOTE = (
    "declares `provision_tracking: {EXEMPT}` but gives no `{KEY}:` prose, so the "
    "exemption DOES NOT HOLD and this domain is still counted as untraced. State why "
    "the domain has no pinnable statute — an exemption nobody can read is a way to "
    "delete a domain from the accounting.").replace("{EXEMPT}", EXEMPT).replace("{KEY}", EXEMPTION_REASON_KEY)

#: Printed instead of `NOT_ENFORCED_NOTE` when the manifest could not be read.
#: The domain blocks and the reader is told it is blocking on an UNKNOWN
#: declaration rather than on a declared one, because the two are fixed
#: differently: this one is fixed by repairing the YAML.
UNKNOWN_ENFORCEMENT_NOTE = (
    "manifest.yaml could not be read, so whether this domain declares "
    "`provision_tracking: enforced` is UNKNOWN — and an unreadable manifest may not "
    "be the thing that decides a domain does not block. Repair the manifest "
    "(the parse error is among the problems above); if the domain is not "
    "enforced, this exits 0 again once it parses.")

#: The committed artifact, by name. Spec §4 puts it in the domain directory;
#: `--emit` will write to any path, but only this one is the committed file a
#: renderer reads, so only this one is checked for drift.
ARTIFACT_NAME = "provisions.yaml"

#: The manifest value that arms the ratchet. Any OTHER value is not enforcement
#: -- `provision_tracking: yes` is a domain that thinks it opted in and did not.
#: `main` says so rather than passing silently, because a mistyped ratchet is
#: itself the false-green class this layer exists to remove.
ENFORCED = "enforced"


#: How much of a quote a T5 message shows on either side of the divergence.
#: Enough to find the place in the document, short enough to read in a gate log.
QUOTE_WINDOW = 60

#: The emitted per-unit states. The first four are spec §8's four-colour
#: taxonomy. CONTRADICTED is the fifth, and it exists because the ledger
#: deliberately does not resolve a unit that is both covered and deferred: the
#: emitter may not pick a winner either, so it names the contradiction and lets
#: a four-colour renderer paint it as the T2 failure it is.
GREEN, AMBER, GREY, RED, CONTRADICTED = (
    "GREEN", "AMBER", "GREY", "RED", "CONTRADICTED")


def _normalise_whitespace(text):
    """Line wrapping is not semantic, in the document or in a quote.

    Deliberately a local two-liner rather than an import of `units._normalise`.
    Unit text arrives ALREADY normalised by that function, so this is a no-op on
    it; the text it actually has to normalise is the VERBATIM, which no reader
    touches. If the two ever had to agree on something subtler than `\\s+`, the
    normalisation belongs in the ledger -- not in a private import that couples
    the checker to a reader's internals.
    """
    return re.sub(r"\s+", " ", text or "").strip()


def is_traced(built):
    """A domain is traced when it has a UNIT STORE, which is the input both
    directions are stated over: T1's remedy is a cite resolving to a unit, and
    T2 partitions the units themselves.

    Keyed on the ledger's `doc_units` rather than on a `sources/` directory
    existing, for two reasons. The checker reads the ledger and nothing else.
    And a `sources/` whose only document fails its pin yields no units and a
    LOUD problem (T4, in `units.load_sources`) -- checking that domain's
    coverage against an empty store would bury the real defect under a full
    statute's worth of derived noise.
    """
    return bool(built["doc_units"])


# ── T1: rule → sentence ──────────────────────────────────────────────────────

def _check_t1_clauses(built):
    """Every operative clause carries a cite, cites indirectly, or belongs to a
    predicate declared to have no statutory basis.

    THE INDIRECT CASE IS NOT A LOOPHOLE, AND FLAGGING IT IS ACTIVELY HARMFUL.
    `findall(cite(C), norm(...), CITES)` is a clause that IS cited; the atom
    lives in a fact table and binds at run time, which is how 11 corpus domains
    (uk/traffic_highway_code cites 116 clauses this way) carry their citations.
    The remedy this check prescribes for a failure is a `no_statute`
    declaration, so a checker that flagged an indirect cite would teach authors
    to record thoroughly-cited law as having no statutory basis -- inverting the
    exact fact the layer exists to establish. `cite(_)` is the other direction
    and `clauses.py` already settles it: an anonymous variable binds to nothing,
    so it lands in neither `cites` nor `indirect_cite` and fails here.

    FACTS ARE OUT OF SCOPE, AND THIS NARROWS THE SPEC. `scan_domain` returns
    RULES only, so an uncited operative FACT is invisible to T1 forever; only
    T2's unit residue can catch it, and only on a traced domain. Spec T1 says
    "an operative clause OR PARAMETER FACT", so the wording is wider than what
    runs, and no ruling records the difference -- it is recorded HERE.

    It is defensible rather than accidental. A fact is data, and the corpus
    routinely carries its citations IN that data (`au/merger_clearance` has 7
    cite-bearing facts; uk/traffic_highway_code cites 116 clauses this way), so
    a per-fact cite obligation would misread a fact TABLE as 200 uncited
    clauses. The parameter leg below covers the one class of fact where an
    uncited value is unambiguously a defect. It is also why T3 treats a
    `no_statute` for a fact-only predicate as naming nothing: a fact cannot
    fail T1, so exempting one was never doing any work.
    """
    problems = []
    for clause in built["clauses"]:
        if clause.functor in _clauses.EXEMPT_FUNCTORS:
            # Not law wherever it appears (Test/1). Structural, like the
            # EXEMPT_BASENAMES file rule -- no declaration, no judgment.
            continue
        exempt = (clause.functor, clause.arity) in built["no_statute"]
        if clause.cites or clause.indirect_cite or exempt:
            # An exemption is per PREDICATE -- `functor/arity`, matched on both.
            # On the functor alone, one declaration would silently exempt every
            # overload, and a rename that changed a head's arity would keep an
            # exemption nobody re-justified.
            continue
        problems.append(
            f"T1 {clause.file}:{clause.line}: operative clause "
            f"{clause.functor}/{clause.arity} carries no cite(...). Add a cite "
            f"whose citation/2 record names the statutory unit it implements, "
            f"or, if it has no statutory basis, declare the predicate with the "
            f'fact no_statute("{clause.functor}", {clause.arity}, "<reason>") '
            f"in an operative file.")
    return problems


def _check_t1_parameters(built):
    """Every parameter record binds its value to statutory text.

    Spec T1 covers "an operative clause OR PARAMETER FACT", and an uncited
    parameter is the clearest defect available here: a number in a rule with no
    provision behind it. Checking clauses alone would pass a domain whose every
    threshold was unprovenanced.

    THE DIVISION OF LABOUR WITH check_parameters IS DELIBERATE. That tool owns
    record<->fact correspondence -- that each `parameter_source` key names a real
    fact functor, that records and `parameters-sources.yaml` cover each other,
    and that a verbatim states the value it claims. This check owns ONE thing it
    knows nothing about: the `units:` binding to the pinned document. Duplicating
    its half here would double-report a defect it already names better.
    """
    problems = []
    for record in built["records"]:
        if record.kind != "parameter" or record.units:
            continue
        problems.append(
            f"T1 parameters.clausal: parameter_source(\"{record.atom}\", ...) "
            f"binds no statutory unit — a number in a rule with no provision "
            f"behind it. Add units: [\"<doc_id>#<eid>\"] naming the "
            f"provision(s) that fix this value.")
    return problems


# ── T2: sentence → rule ──────────────────────────────────────────────────────

def _check_t2(built):
    """The partition over the pinned document is TOTAL and EXCLUSIVE.

    Total: a unit neither formalized nor deferred is unaccounted, and silence
    about it is the false green this layer exists to remove.

    Exclusive: a unit claimed as BOTH covered and deferred, on the SAME run
    (spec 13.20), is a contradiction, not a rounding error. The ledger's
    `"contradicted"` is a run-level intersection, not the coarser
    `covered & deferred` unit membership -- a unit like Art 174(1), covered
    on run 1 and deferred on a DIFFERENT run 2, is two true statements about
    the law and must not land here. Fails on `"contradicted"` because either
    resolution -- reading the OVERLAPPING claim as formalized, or as deferred
    -- would be a claim nobody made, asserted by a tool.
    """
    problems = [
        f"T2 {unit_id}: unaccounted — neither formalized nor deferred. Cite it "
        f"from an operative clause whose citation/2 record names it, or add it "
        f"to manifest.yaml deferred_set with a reason and a consequence."
        for unit_id in built["unaccounted"]
    ]
    problems += [
        f"T2 {unit_id}: both covered and deferred — a contradiction, not a "
        f"rounding error. Either the deferral is stale or the cite is wrong; "
        f"remove whichever no longer holds."
        for unit_id in built["contradicted"]
    ]
    return problems


# ── T3: referential integrity ────────────────────────────────────────────────

def _record_site(record):
    """`(file, how to name it)` for a provenance record.

    The reader does not carry a file per record because each functor lives in
    exactly one file by construction -- `read_citations` reads only
    citations.clausal and `read_parameters` only parameters.clausal.
    """
    if record.kind == "parameter":
        return "parameters.clausal", f'parameter_source("{record.atom}", ...)'
    return "citations.clausal", f"citation({record.atom}, ...)"


#: The FRAGMENT naming why a selector did not resolve, shared by every T3
#: check below so the two registers (`citations.clausal`'s `units:`,
#: `manifest.yaml`'s `deferred_set[].units`) describe an unresolvable or
#: out-of-range selector in the SAME words -- see spec 13.20 rule 4. Each
#: caller supplies its own lead-in ("names unit …" / "defers unit …") and
#: its own consequence ("covers nothing" / "defers nothing").
def _selector_defect(selector, unit_id, problem, run_counts):
    if problem == _units.UNKNOWN_UNIT:
        return (
            f"{selector!r}, which is in no pinned document under sources/ "
            f"(check the eId against the pinned text -- a re-consolidation "
            f"renumbers them -- or fix the doc_id prefix)")
    total = run_counts[unit_id]
    return (
        f"{selector!r}, whose run selector is out of range — {unit_id} has "
        f"{total} run{'s' if total != 1 else ''} (a run selector out of "
        f"range claims to cover text the unit does not have; check the run "
        f"number against the unit's own pinned text)")


def _check_t3_record_units(built, run_counts):
    """A record's `units:` name provisions that are in the pinned document,
    and a `/n` run selector's `n` is within the unit's own run count.

    An id naming nothing is not caught anywhere else: the ledger intersects
    both `covered` and `deferred` with the document, so the id simply drops out
    of the partition -- the record still reads as provenance, and the provision
    it was supposed to cover reads as unaccounted somewhere else entirely, or
    (if the intended unit is covered by another record) not at all. A statute
    re-consolidated under new eIds produces exactly this, in bulk.

    AN OUT-OF-RANGE RUN SELECTOR (spec 13.20 rule 1) is the same defect
    wearing a new hat: `…/3` on a two-run unit claims to cover text the unit
    does not have, so it drops out of the partition -- silently ignoring it
    would let the binding stand uncontested.

    THIS IS NOT `check_citations`' JOB AND THE TWO DO NOT ALIGN. That tool owns
    cite-atom<->record correspondence -- whether a cited atom has a record and
    whether a record is cited -- and its notion of "cited" is genuinely
    different from this layer's: it scans a top-level, non-recursive
    `os.listdir` and INCLUDES `queries.clausal` and `fixtures.clausal`, where
    `clauses._clausal_files` recurses and exempts both. Do not assume the two
    agree, and do not try to reconcile them here; a unit binding is the one
    thing `check_citations` knows nothing about.
    """
    problems = []
    for record in built["records"]:
        where, subject = _record_site(record)
        for selector in record.units:
            unit_id, _, problem = _units.resolve_selector(selector, run_counts)
            if problem is None:
                continue
            problems.append(
                f"T3 {where}: {subject} names unit "
                f"{_selector_defect(selector, unit_id, problem, run_counts)}. "
                f"This record covers nothing.")
    return problems


def _check_t3_deferrals(built, run_counts):
    """A deferral is a claim with three parts, and all three must be there.

    WHAT IT LEAVES OUT: whether the deferral is SOUND. That is judgment, the
    gate cannot have it, and a check pretending to would manufacture the false
    green this layer exists to remove (the ledger's `deferral_smells` makes the
    degenerate pattern conspicuous instead). What the gate CAN settle is
    whether the claim was actually made:

      * units -- a deferral naming nothing defers nothing. T2 goes on reporting
        the provisions it was meant to account for, so the entry reads as an
        answer while changing no outcome. A `/n` run selector out of range
        (spec 13.20 rule 1) is the same defect: it claims to defer text the
        unit does not have, so the ledger drops it and this entry defers
        nothing for that selector while reading as though it did;
      * reason -- an unjustified hole is not a decision, it is an omission with
        a heading;
      * consequence -- what a caller must do for itself. Without it the
        register records that something is missing but not what breaks, which
        is precisely the information a downstream user needs and the reason
        spec 6 puts a consequence in the shape at all.
    """
    problems = []
    for index, entry in enumerate(built["deferrals"]):
        where = f"manifest.yaml deferred_set[{index}]"
        what = entry.get("what")
        if isinstance(what, str) and what.strip():
            where += f" ({what.strip()})"

        listed = entry.get("units")
        # A malformed `units:` (not a list, or holding non-strings) is already
        # reported by `ledger._deferred_units` in the author's words. Saying
        # "defers no units" on top of it would name a second, wrong defect.
        malformed = listed is not None and (
            not isinstance(listed, list)
            or not all(isinstance(u, str) for u in listed))
        # AN EXCLUSION MAY LIE OUTSIDE THE PINNED INSTRUMENT (spec 13.22).
        # An order can authorize "Directive 2014/25/EU Art 28 out of scope" for
        # a domain that pins only 2014/24/EU. There is no unit to name -- not
        # because the author omitted one, but because the excluded provision
        # belongs to a document this domain has no relationship with, which is
        # exactly why T6 refuses it in `excluded_set` too. `instrument:` says
        # so in the author's words and is the ONLY thing that makes an empty
        # `units:` legitimate here; without it the entry is the degenerate
        # deferral T3 was written for and still fails.
        # `partial: true` narrows T6 (spec 13.23) and MUST be a real boolean.
        # YAML reads `partial: "yes"` as a truthy STRING, and a flag that buys a
        # gate exemption by truthiness lets a typo silence CONTRADICTED -- the
        # check it exists to narrow, not to disable.
        partial = entry.get("partial")
        if partial is not None and not isinstance(partial, bool):
            problems.append(
                f"T3 {where}: `partial:` must be a boolean, got "
                f"{type(partial).__name__} {partial!r}. It narrows the "
                f"CONTRADICTED check for a deferral finer than a run; a truthy "
                f"string would switch that check off by accident.")

        instrument = entry.get("instrument")
        named_instrument = isinstance(instrument, str) and instrument.strip()
        if instrument is not None and not named_instrument:
            problems.append(
                f"T3 {where}: `instrument:` is blank — it must name the "
                f"instrument whose provision is excluded (\"Directive "
                f"2014/25/EU Art 28\"), because naming it is the whole of "
                f"what this key buys: an entry with no units and no named "
                f"instrument accounts for nothing at all.")
        if not malformed:
            listed = listed or []
            if not listed and not named_instrument:
                problems.append(
                    f"T3 {where}: defers no units — an entry that names nothing "
                    f"accounts for nothing, and T2 still reports every "
                    f"provision it was meant to cover. Add units: [\"<doc_id>#"
                    f"<eid>\", ...], or `instrument:` if what is excluded "
                    f"belongs to an instrument this domain does not pin.")
            for selector in listed:
                unit_id, _, problem = _units.resolve_selector(
                    selector, run_counts)
                if problem is None:
                    continue
                problems.append(
                    f"T3 {where}: defers unit "
                    f"{_selector_defect(selector, unit_id, problem, run_counts)}. "
                    f"This defers nothing while reading as a deferral.")

        for field, why in (
                ("reason", "an unjustified hole is an omission with a heading, "
                           "not a decision"),
                ("consequence", "the register exists to say what a caller must "
                                "do for itself, not merely that something is "
                                "missing")):
            value = entry.get(field)
            if not isinstance(value, str) or not value.strip():
                problems.append(
                    f"T3 {where}: empty {field} — {why}. Add a non-empty "
                    f"{field}:.")
    return problems


def _check_t6_exclusions(built, run_counts):
    """An exclusion is a claim about this domain's BOUNDARY, and the gate can
    settle its form and its honesty but never its soundness (spec 13.21).

    The relation exists because a deferral of a NEIGHBOURING article is
    unwritable once a domain pins: T3 rejects an entry naming no units, and
    `resolve_selector` resolves against the extract, so `#art_068` from an Art
    67 domain is UNKNOWN_UNIT. Every door being shut, four independent authors
    moved their boundaries into prose that nothing checks. This is what checks
    them.

    THE NEGATIVE CHECK IS THE LOAD-BEARING ONE. An exclusion whose `cites:`
    name a unit of this domain's OWN extract is a deferral wearing the wrong
    hat, and it is the one authoring error that would do real damage: it would
    remove a provision from the RED backlog while no `deferred_set` entry
    accounts for it. Everything else here is shape.

    Resolution is deliberately WEAK -- well-formedness, a `doc_id` this domain
    pins, and the negative check -- because the strong version needs an
    instrument-wide unit map that does not exist (spec 13.22: `parse_units`
    refuses the full 2014/24 over a bilingual ANNEX I table). These checks stay
    valid under the strong version, so this is not throwaway.
    """
    problems = []
    pinned = {source.get("doc_id") for source in built.get("sources", [])
              if isinstance(source.get("doc_id"), str)}
    deferred_whats = _registered_whats(built, "deferrals")

    for index, entry in enumerate(built["exclusions"]):
        where = f"manifest.yaml excluded_set[{index}]"
        what = entry.get("what")
        if isinstance(what, str) and what.strip():
            where += f" ({what.strip()})"
            if what in deferred_whats:
                problems.append(
                    f"T6 {where}: {what!r} is also in deferred_set — a `what` "
                    f"in both relations is a contradiction, not a completion. "
                    f"Deferring part of a determination and excluding another "
                    f"part is legitimate; name the two parts differently so "
                    f"the register says which is which.")

        # A CROSS-INSTRUMENT boundary is a real scope statement, and often the
        # most useful one a register carries: utilities_negotiated_without_
        # prior_call pins Directive 2014/25 and its first exclusion says that
        # Art 32 of 2014/24 -- the public-sector equivalent gateway, already a
        # domain of its own -- is somebody else's question. Refusing that left
        # the author with no way to state the boundary at all. `instrument:`
        # names the foreign document in the author's words, exactly as
        # `deferred_set` has allowed since spec 13.22, and is what makes a cite
        # into an unpinned document legitimate here. Ruling
        # 2026-09-05. Blank is refused for the same reason it is there: an
        # entry that buys the exemption while naming nothing is the unchecked
        # claim this whole check exists to stop.
        instrument = entry.get("instrument")
        named_instrument = isinstance(instrument, str) and bool(instrument.strip())
        if instrument is not None and not named_instrument:
            problems.append(
                f"T6 {where}: `instrument:` is blank — it must name the "
                f"instrument whose provision is excluded (\"Directive "
                f"2014/24/EU\"), because that name is the only account of a "
                f"provision this domain cannot check. An unnamed instrument "
                f"accounts for nothing at all.")
        listed = entry.get("cites")
        # A malformed `cites:` is already reported by `ledger._listed_ids` in
        # the author's words; saying "excludes nothing" on top would name a
        # second, wrong defect. Same rule as T3's `units:`.
        malformed = listed is not None and (
            not isinstance(listed, list)
            or not all(isinstance(u, str) for u in listed))
        if not malformed:
            listed = listed or []
            if not listed:
                problems.append(
                    f"T6 {where}: excludes nothing — an entry that names no "
                    f"provision states no boundary. Add cites: "
                    f"[\"<doc_id>#<eid>\", ...] naming what is outside scope.")
            for selector in listed:
                unit_id, _run = _units.parse_selector(selector)
                doc_id = unit_id.split("#")[0] if "#" in unit_id else None
                if doc_id is None:
                    problems.append(
                        f"T6 {where}: {selector!r} is not a provision id — "
                        f"an exclusion cites <doc_id>#<eid>, the same shape a "
                        f"deferral's units: uses.")
                    continue
                if doc_id not in pinned:
                    if named_instrument:
                        # Stated, not silent: the author has named the
                        # instrument, so the boundary is on the record even
                        # though no unit of it can be resolved here.
                        continue
                    problems.append(
                        f"T6 {where}: {selector!r} names document {doc_id!r}, "
                        f"which this domain does not pin"
                        + (f" (it pins {', '.join(sorted(pinned))})" if pinned
                           else "")
                        + ". A provision of an instrument this domain has no "
                        f"relationship with cannot be checked here, so say "
                        f"which instrument it is: add `instrument: \"<name>\"` "
                        f"to this entry, the same way deferred_set states a "
                        f"boundary outside the pin.")
                    continue
                resolved, _runs_, problem = _units.resolve_selector(
                    selector, run_counts)
                if problem is None:
                    problems.append(
                        f"T6 {where}: {selector!r} is a unit of this domain's "
                        f"OWN extract — an exclusion states what is outside "
                        f"scope, so this removes a provision from the backlog "
                        f"that nothing then accounts for. Move it to "
                        f"deferred_set with units:.")

        for field, why in (
                ("reason", "an unjustified boundary is an omission with a "
                           "heading, not a decision"),
                ("consequence", "the register exists to say what a caller must "
                                "do for itself, not merely that something is "
                                "out of scope")):
            value = entry.get(field)
            if not isinstance(value, str) or not value.strip():
                problems.append(
                    f"T6 {where}: empty {field} — {why}. Add a non-empty "
                    f"{field}:.")
    return problems


#: An operative reading's `chosen` may name a reading id, or SPLIT. Forcing one
#: answer is what produced the 430-refutation disagreement in
#: `eu/procurement/award_criteria_meat` (spec 13.23): the two readings of Art
#: 67(5) answered DIFFERENT questions, and the correct disposition took one for
#: compliance and the other for rankability. A schema that cannot say that
#: pushes an author toward whichever reading is easier to write down, which is
#: the last property this particular register should have.
SPLIT = "split"


def _check_t7_readings(built, run_counts):
    """An operative reading is a CONTESTED INTERPRETATION, declared (spec 13.23).

    THE GATE CANNOT JUDGE WHICH READING IS RIGHT -- that is the whole reason the
    register exists. What it settles is that the choice was actually MADE and is
    reviewable: the question is stated, at least two readings are set out with
    their consequences, one of them (or `split`) is chosen, a rationale is given,
    and an authority is named or explicitly disclaimed.

    THE OPPOSITE POLARITY TO T6, and the reason this is not the scope machinery:
    a reading's `units:` must RESOLVE INSIDE this domain's own extract. An
    exclusion names what the domain does not do; a reading names a provision the
    domain DOES formalize, contestably. A unit that is covered by a rule AND
    carries a reading is the normal case.

    `authority` IS REQUIRED RATHER THAN DEFAULTED, and the asymmetry is
    deliberate: an absent field would read as the safe case and it is the unsafe
    one. `authority: none` is a real, sayable value -- an operator's judgement
    standing alone -- and filtering the corpus on it is what produces a review
    queue for a qualified professional.

    WHAT T7 DOES NOT CHECK is whether the reading has been reviewed. That is
    `review_obligations`, deliberately not a problem, and its docstring says
    why. T7 asks whether the choice is REVIEWABLE; only a human can ask whether
    it is right.
    """
    problems = []
    for index, entry in enumerate(built["operative_readings"]):
        where = f"manifest.yaml operative_readings[{index}]"
        what = entry.get("what")
        if isinstance(what, str) and what.strip():
            where += f" ({what.strip()})"

        listed = entry.get("units")
        malformed = listed is not None and (
            not isinstance(listed, list)
            or not all(isinstance(u, str) for u in listed))
        if not malformed:
            listed = listed or []
            if not listed:
                problems.append(
                    f"T7 {where}: names no units — a reading interprets a "
                    f"PROVISION, so it must say which. Add units: "
                    f"[\"<doc_id>#<eid>\", ...] naming the text it reads.")
            for selector in listed:
                unit_id, _, problem = _units.resolve_selector(
                    selector, run_counts)
                if problem is not None:
                    problems.append(
                        f"T7 {where}: reads unit "
                        f"{_selector_defect(selector, unit_id, problem, run_counts)}. "
                        f"A reading interprets text this domain PINNED — unlike "
                        f"an exclusion, its units must be in the extract.")

        readings = entry.get("readings")
        ids = []
        if not isinstance(readings, list) or len(readings) < 2:
            problems.append(
                f"T7 {where}: fewer than two readings — a register of "
                f"interpretive choices records the choice, and a choice needs "
                f"an alternative. State the reading NOT taken and what would "
                f"follow from it; that is what a reviewer overturns.")
        else:
            for position, reading in enumerate(readings):
                at = f"{where} readings[{position}]"
                if not isinstance(reading, dict):
                    problems.append(
                        f"T7 {at}: expected a mapping, got "
                        f"{type(reading).__name__}")
                    continue
                rid = reading.get("id")
                if not isinstance(rid, str) or not rid.strip():
                    problems.append(f"T7 {at}: no `id` — it is what `chosen` "
                                    f"names.")
                else:
                    ids.append(rid)
                if not _nonempty(reading.get("consequence")):
                    problems.append(
                        f"T7 {at}: empty consequence — a reading with no stated "
                        f"effect cannot be compared with the one beside it, "
                        f"which is the comparison a reviewer is here to make.")
            duplicates = sorted({i for i in ids if ids.count(i) > 1})
            if duplicates:
                problems.append(
                    f"T7 {where}: reading id(s) {', '.join(duplicates)} used "
                    f"twice — `chosen` would name two things.")
            marked = [r for r in readings if isinstance(r, dict)
                      and r.get("conservative") is True]
            if len(marked) > 1:
                problems.append(
                    f"T7 {where}: {len(marked)} readings marked conservative — "
                    f"at most one can be the safer side. Mark none if neither "
                    f"clearly is.")

        chosen = entry.get("chosen")
        if not _nonempty(chosen):
            problems.append(
                f"T7 {where}: no `chosen` — the register records which reading "
                f"this domain IMPLEMENTS. Name a reading id, or {SPLIT!r} where "
                f"the readings answer different questions and the domain takes "
                f"both.")
        elif ids and chosen != SPLIT and chosen not in ids:
            problems.append(
                f"T7 {where}: chosen {chosen!r} is not one of the readings "
                f"({', '.join(ids)}) and is not {SPLIT!r}.")

        for field, why in (
                ("question", "a register of interpretive choices is unreadable "
                             "without the question each one answers"),
                ("rationale", "why this reading and not the other is what a "
                              "reviewer agrees or disagrees with"),
                ("authority", "name the case or source relied on, or say "
                              "`none` — an absent authority reads as the safe "
                              "case and is the unsafe one")):
            if not _nonempty(entry.get(field)):
                problems.append(
                    f"T7 {where}: empty {field} — {why}. Add a non-empty "
                    f"{field}:.")

    return problems


def review_obligations(built):
    """Operative readings awaiting a qualified person -- NOT problems.

    THIS IS THE BAR IT BELONGS TO, and it took a ruling to put it on
    the right one. An unreviewed reading was a `problems` entry, which made it
    block `provision_tracking: enforced` -- the ENGINEERING gate, the one that
    says this domain's provision tracking is maintained and drift fails CI.
    That stopped engineering on a question only a lawyer can answer, which is
    the wrong trade: a defensible reading, chosen by weighing the evidence and
    RECORDED AS CONTESTED, is what lets the work proceed.

    What it must never stop being is visible. The obligation is printed on
    every run, carried in the artifact, counted in the headline and listed by
    `review_queue.py`. The bargain is that the question was recorded, not that
    it was answered.

    The bar it DOES block is acceptance into service: `docs/COMMISSIONING.md`
    H1, "the judgment half machines cannot claim". A domain that declares
    `commissioned:` while resting on unsigned readings is claiming exactly what
    H1 says only a human signature can give, so THAT is a problem -- see
    `_check_commissioned_readings`. Engineering proceeds; service does not.
    """
    out = []
    for index, entry in enumerate(built["operative_readings"]):
        if _attested(entry):
            continue
        what = entry.get("what")
        where = (f"operative_readings[{index}]"
                 + (f" ({what.strip()})" if isinstance(what, str)
                    and what.strip() else ""))
        out.append(
            f"{where}: awaiting review — an interpretation of the law that no "
            f"qualified person has signed off. Recorded and defensible is "
            f"enough to build on; it is NOT enough to put in service "
            f"(COMMISSIONING.md H1). `_tools/review_queue.py` lists it; record "
            f"the review as attested: {{by, role, date}}.")
    return out


def _check_commissioned_readings(built):
    """H1, mechanically: a domain accepted INTO SERVICE may not rest on an
    interpretation nobody signed.

    `commissioned:` in the manifest is the corpus's own declaration that a
    domain is in service (COMMISSIONING.md §3). It is the first thing in this
    layer to read that block, and it reads it for one purpose: the attestation
    tier H1 already promises. Nothing here judges the other tiers.

    Read off the LEDGER, never by re-opening manifest.yaml -- `is_enforced`
    documents why: two reads of one file can disagree, and a manifest the
    ledger could not parse must not acquire a `commissioned:` block from a
    laxer re-read here.

    A domain that has NOT declared `commissioned:` is not failing this check --
    it has not made the claim. That asymmetry is the same one the enforcement
    ratchet keeps, and for the same reason.
    """
    if not isinstance(built.get("commissioned"), dict):
        return []
    return [
        f"H1 {obligation.split(':')[0]}: this domain declares `commissioned:` "
        f"— in service — while resting on an interpretation no qualified "
        f"person has signed. COMMISSIONING.md H1 is a human signature, not a "
        f"machine verdict, so it cannot be inferred from the rest being green. "
        f"Attest it, or withdraw the `commissioned:` block."
        for obligation in review_obligations(built)]


def _nonempty(value):
    return isinstance(value, str) and bool(value.strip())


def _attested(entry):
    """Whether an operative reading carries a REVIEW RECORD.

    A mapping with a non-empty `by` -- who reviewed it. `attested: ~`, absent,
    `true`, or a mapping naming nobody are all NOT attested: "someone checked
    this" with no one named is the claim this field exists to stop being
    makeable. Nothing here judges whether the named person was qualified; that
    is a human's problem and the field exists so a human can see it at all.
    """
    record = entry.get("attested")
    return isinstance(record, dict) and _nonempty(record.get("by"))


def _reading_advisories(built):
    """Advisory, never a problem: the domain took the reading it did NOT mark as
    the safer one.

    That is a legitimate choice -- the conservative reading is sometimes simply
    wrong -- so it cannot block. But it is the single most useful sort key a
    review queue has, because a departure from the safe side is where a
    professional's time is worth most, and today nothing anywhere says it
    happened.
    """
    out = []
    for entry in built["operative_readings"]:
        readings = entry.get("readings")
        if not isinstance(readings, list):
            continue
        safer = [r.get("id") for r in readings if isinstance(r, dict)
                 and r.get("conservative") is True]
        chosen = entry.get("chosen")
        if safer and _nonempty(chosen) and chosen != safer[0]:
            out.append(
                f"operative_readings {entry.get('what')!r}: chose {chosen!r} "
                f"over {safer[0]!r}, which is marked the more conservative "
                f"reading. Legitimate, and worth a reviewer's attention first.")
    return out


#: The closed set of reasons a predicate may be declared to have no statutory
#: basis. Decided 2026-08-28 after measuring the corpus's 460 T1 flags: 351 are
#: candidate law, 83 are projections/accessors, 26 were Test/1 (now exempt by
#: functor). A `*_status`/`*_checklist` SUFFIX RULE was considered for the 83 and
#: rejected -- `exclusion_ground_status` is plausibly the substantive
#: determination, and a regex would have silently exempted real law, which is
#: the false-green this whole layer exists to catch. So the judgment stays
#: per-predicate; the vocabulary only makes the judgment countable.
NO_STATUTE_REASONS = frozenset({
    "projection_of_verdict",   # reshapes a decision already made
    "solvability_probe",       # asks whether the decision resolves
    "interface_shape",         # exists to satisfy the oracle's call surface
    "computation_helper",      # arithmetic/structural, no legal content
    "statute_owned_elsewhere", # implements law whose UNIT another domain pins
})

#: The one value that cannot stand alone. A predicate CAN implement law whose
#: unit is not in this domain's pinned extract -- thresholds'
#: applicable_threshold/2 carries Art 4 while calling art4_threshold/4 from
#: eu.procurement.directive_2014_24.art4_thresholds. The other four force that into `computation_helper`
#: ("no legal content"), which is FALSE and reopens the laundering hole one
#: layer down: computation_helper is the widest value and the least checkable,
#: so it absorbs whatever is pushed at it. Requiring the OWNER makes the claim
#: falsifiable -- does that domain exist, does it pin the provision -- where a
#: bare value can only be taken on trust. Spelled `statute_owned_elsewhere:<domain>`
#: so the reader's 3-arg fact shape is untouched.
#:
#: THE TEST IS "IS THE UNIT IN THIS DOMAIN'S PINNED EXTRACT", NOT "does this
#: predicate import something". The two come apart, and the import heuristic gets
#: it backwards: thresholds' applicable_threshold/2 imports its lookup TABLE from
#: eu.procurement.directive_2014_24.art4_thresholds while Art 4 is pinned right there under its own
#: sources/, so it cites locally and this value does not apply. Data living
#: elsewhere is not statute living elsewhere. The real first user is
#: abnormally_low_tender, which pins art069 only and whose own manifest says in
#: prose that "Article 4 is OUTSIDE this domain's pinned extract".
#:
#: A machine cannot settle which unit a predicate implements, but it CAN settle
#: the other half -- that the named owner exists and actually pins something --
#: which is what turns the value from a shrug into a reference.
OWNER_REQUIRED = "statute_owned_elsewhere"


def _corpus_root(domain_dir):
    """The corpus top-level a domain sits under. Domains nest two deep
    (eu/procurement/thresholds), which the tests' `_domain` mirrors, so the root
    is the domain dir's grandparent."""
    return os.path.dirname(os.path.dirname(
        os.path.dirname(os.path.abspath(domain_dir))))


def _check_t3_no_statute(built, domain_dir="."):
    """A `no_statute` declaration justifies itself and exempts a real predicate.

    "EXISTS" MEANS: `(functor, arity)` is the head of some operative RULE in
    this domain -- the head keys of `clauses.scan_domain`'s output, which is
    the only predicate inventory the ledger carries.

    WHY, AND WHAT IT COSTS. `scan_domain` returns rules only, so a predicate
    that exists solely as FACTS reads as nonexistent here and its exemption is
    reported. That is the intended reading, not a gap: facts are out of scope
    for T1 (see `_check_t1_clauses`), so a fact can never fail the check a
    `no_statute` exempts it from -- the declaration was dead text the day it
    was written. Dead text left behind by a rename is exactly what this check
    is for: the exemption survives, the predicate it named does not, and the
    next predicate to take that name inherits an exemption nobody argued for.
    The cost is a false positive for an author who exempts a fact table
    defensively, and the remedy is one line: delete the declaration, because it
    was doing nothing. That asymmetry -- a spurious report costs a deletion, a
    missed one costs a silent unargued exemption -- is why existence is keyed
    this way.

    Keyed on `(functor, arity)`, both. On the functor alone a declaration would
    survive the arity change that invalidated it, which is the same reasoning
    that makes T1 match exemptions on arity.
    """
    defined = {(clause.functor, clause.arity) for clause in built["clauses"]}
    problems = []
    for (functor, arity), reason in sorted(built["no_statute"].items()):
        head = reason.strip().split(":", 1)[0] if isinstance(reason, str) else ""
        owner = (reason.strip().split(":", 1)[1].strip()
                 if isinstance(reason, str) and ":" in reason else "")
        if head == OWNER_REQUIRED and owner:
            owned = os.path.join(_corpus_root(domain_dir), *owner.split("/"))
            if not os.path.isdir(os.path.join(owned, "sources")):
                problems.append(
                    f'T3 no_statute("{functor}", {arity}, '
                    f'"{OWNER_REQUIRED}:{owner}"): {owner} pins no sources/, so '
                    f'it cannot own the provision this predicate implements. '
                    f'Name the domain whose pinned extract carries the unit, or '
                    f'use a different reason.')
        if head == OWNER_REQUIRED and not owner:
            problems.append(
                f'T3 no_statute("{functor}", {arity}, "{OWNER_REQUIRED}"): must '
                f'name the owning domain, as "{OWNER_REQUIRED}:<domain>". The '
                f'value exists for law this domain does not PIN, and naming the '
                f'owner is what makes that checkable rather than a shrug.')
        elif (isinstance(reason, str) and reason.strip()
                and head not in NO_STATUTE_REASONS):
            problems.append(
                f'T3 no_statute("{functor}", {arity}, "{reason.strip()[:40]}"): '
                f'reason is outside the vocabulary. Use one of '
                f'{", ".join(sorted(NO_STATUTE_REASONS))}. `no_statute` is the '
                f'escape hatch from citing a provision, and the honest path can '
                f'fail while the hatch never does -- a closed vocabulary makes '
                f'how often it is taken COUNTABLE, which free text does not.')
        if not isinstance(reason, str) or not reason.strip():
            problems.append(
                f'T3 no_statute("{functor}", {arity}, ""): empty reason — this '
                f"is the one bare assertion the enforced path allows, so it may "
                f"not be silent. State why {functor}/{arity} has no statutory "
                f"basis.")
        if (functor, arity) not in defined:
            problems.append(
                f'T3 no_statute("{functor}", {arity}, ...): no operative rule '
                f"defines {functor}/{arity}, so this exempts nothing. A rename "
                f"leaves exactly this — delete the declaration, or correct it "
                f"to the predicate it was meant to cover. (A predicate that "
                f"exists only as FACTS also reads as nonexistent here: facts "
                f"are out of scope for T1, so exempting one is dead text.)")
    return problems


def _run_counts(built):
    """`{unit id: number of runs}` -- what a `/n` run selector is checked
    against (spec 13.20 rule 1). A bare id's membership test is `unit_id in
    run_counts`, the same question `unit_id in known` asked before run
    addressing; `resolve_selector` is the one place both questions are
    answered, so this dict is the only unit inventory T3 needs now.
    """
    return {unit["id"]: len(unit["runs"]) for unit in built["doc_units"]}


def _check_t3(built, domain_dir="."):
    run_counts = _run_counts(built)
    return (_check_t3_record_units(built, run_counts)
            + _check_t3_deferrals(built, run_counts)
            + _check_t3_no_statute(built, domain_dir)
            + _check_t6_exclusions(built, run_counts)
            + _check_t7_readings(built, run_counts))


# ── labels: quote resolution and the SUBSET cross-check ─────────────────────

#: Internal reason codes for `_label_check_reasons` -- never emitted text,
#: just the keys that let `_check_label_units`/`_check_label_subset` (problem
#: STRINGS) and `_label_entry` (the `cross_checked` flag and its note) read
#: the SAME verdict about the SAME label without either one re-deriving it.
#: `_NOT_TRACED` and `_NO_QUOTE` are the two reasons that are NOT failures --
#: see below. The other four are `resolve.resolve`'s own reason constants,
#: renamed here only so this module's internal vocabulary does not leak
#: `resolve`'s import alias into every call site.
_NOT_TRACED = "not_traced"
_NO_QUOTE = "no_quote"
_NO_MATCH = "no_match"
_AMBIGUOUS = "ambiguous"
_UNKNOWN_SOURCE = "unknown_source"
_CITES_NOTHING = "cites_nothing"
_MISATTRIBUTED = "misattributed"

#: `resolve.resolve`'s reason constant -> this module's internal one. The only
#: place the two vocabularies meet, so a reason added to `resolve.py` and
#: forgotten here is a `KeyError` at the call site below, not a silent miss.
_RESOLVE_REASONS = {
    _resolve.NO_QUOTE: _NO_QUOTE,
    _resolve.NO_MATCH: _NO_MATCH,
    _resolve.AMBIGUOUS: _AMBIGUOUS,
    _resolve.UNKNOWN_SOURCE: _UNKNOWN_SOURCE,
}


def _label_check_reasons(built):
    """`{(file, line): (unit_id, reason)}` for every NON-EXEMPT label -- one
    entry whether the label PASSED or FAILED.

    THE SINGLE SOURCE OF TRUTH for three consumers that must never compute
    this differently. `_check_label_units` and `_check_label_subset` turn a
    FAILED reason here into a problem string; `_label_entry` turns the same
    reason into `cross_checked: false` plus a note, or -- on a PASS -- into
    the emitted `resolved_unit`. Before this function existed, `_label_entry`
    carried its OWN, wrong idea of "did this pass" -- first "every label but a
    fact/indirect_cite passed" (missed an unresolvable unit), then "a
    resolving unit passed unless a problem exists somewhere" (missed a
    misattribution, because `problems` never reaches the artifact -- see
    `build_document`). Two independent derivations that could disagree IS the
    failure mode that produced both: one computation, read by every consumer
    that needs the verdict, closes it structurally rather than by remembering
    to keep two copies in sync.

    THE VALUE CARRIES THE RESOLVED UNIT ID TOO, not just the reason, and this
    is the SAME structural argument applied a second time: `_check_label_
    subset`'s misattribution message and `_label_entry`'s `resolved_unit`
    both need to name the unit `resolve.resolve` bound, and a second call to
    `resolve.resolve` from either of them -- pure function of `(label,
    doc_units)` though it is -- is still a second call site that could, after
    some future edit, stop being pure, or simply be forgotten when this
    function's own call site changes. Reading the id out of the ONE call
    already made here removes that risk rather than merely trusting it away.
    `unit_id` is `None` whenever resolution itself failed (`NO_QUOTE`,
    `NO_MATCH`, `AMBIGUOUS`, `UNKNOWN_SOURCE`) and the bound id otherwise --
    including when the SUBSET check then fails it (`_CITES_NOTHING`,
    `_MISATTRIBUTED`): the quote resolved; what failed is what it is used for.

    IT ALSO OWNS THE THREE CONSUMERS' DIFFERENT REACHABILITY, which
    consolidating the COMPUTATION alone did not close. `_scored_problems`
    calls the two check functions only on the TRACED path (behind an early
    return); `build_document` calls this unconditionally. So on an untraced
    domain -- all 59 corpus domains today -- a quote-bearing label used to
    score as unresolvable against an empty unit store, and the artifact said
    `cross_checked: false`, "does not resolve ... see the corresponding
    problem", beside `problem_count: 0`. Self-contradictory, and the wrong
    KIND: nothing was checked, because there is no document to check against,
    so it belongs with the fact/indirect-cite "never checked" family.
    `_NOT_TRACED` is recorded FIRST, before `resolve.resolve` is ever called,
    so this function -- not each caller's guard -- decides what an unchecked
    label says. It carries a `_NEVER_CHECKED_NOTES` note rather than a
    `_FAILURE_NOTES` one, and the check functions match only the FAILURE
    reasons by name, so they emit nothing for it: the untraced path stays
    inert even if a future caller reaches them without the early return.

    THE SAME GUARD APPLIES TO THE FACT/`INDIRECT_CITE` SKIP, and an earlier
    round of THIS fix left it half-closed: `_check_label_subset` reads this
    map (so the skip protects it), but `_check_label_units` was written to
    read it too -- and does -- yet carried no test that ever handed it a
    fact or an `indirect_cite` label with an UNRESOLVABLE quote. A mutant
    that resolved such a label's quote inline, bypassing this skip entirely,
    survived the whole suite: `_check_label_units` would start reporting
    "resolves to no unit" against a fact or a `findall` rule the day someone
    wrote one with a bad quote, on 462 green tests. The fix is not code (the
    skip below was always correct) but tests that actually walk a fact and an
    `indirect_cite` label THROUGH `_check_label_units`, not only through
    `_check_label_subset` -- see `test_a_labelled_FACT_with_an_unresolvable_
    quote_never_reaches_check_label_units` and its indirect-cite sibling.

    RESOLUTION FAILURES ROUTE THROUGH HERE TOO, for the identical reason:
    `resolve.resolve` is called EXACTLY ONCE per label, here, and its result
    is what every consumer reads back. A second, independent call from inside
    `_label_entry` or `_check_label_subset` would reintroduce the exact defect
    class the paragraph above describes, wearing a new hat: two computations
    that happen to agree today and are free to drift apart tomorrow. `NO_QUOTE`
    sits in the SAME reasons map as the three genuine failures despite not
    being one (`resolve.py`'s own docstring: "not a failure, a state")
    precisely so that rule holds without exception -- `_check_label_units`
    simply never matches its code, exactly as it never matches `_NOT_TRACED`.

    Keyed by `(file, line)` -- the label's own site -- not by label id: a
    label id collision is ITSELF a separate, already-reported defect
    (`_check_labels_unique`), and a site is unique per clause by
    construction, so nothing can collide underneath this map.

    EXCLUDES ENTIRELY what is exempt by KIND, independent of tracedness or
    resolution: a FACT and an `indirect_cite` rule. Both are read directly off
    `LabelledClause` (`lc.is_fact`, `lc.indirect_cite`), never off anything
    this function computes, so `_label_entry` may safely re-read the same two
    fields itself without risking the two-derivations defect above -- there is
    nothing to derive, only a field to read, and both readers read the same
    one.

    PRIORITY mirrors `_check_label_units` running before `_check_label_
    subset`: a label whose quote does not resolve is recorded and NOTHING
    ELSE is computed for it, so a provision that does not exist is reported
    ONCE, as unresolvable, never a second time as "no cite reaches it". That
    single reason per site is the invariant, and it lives HERE -- not in the
    order the two checks happen to be wired.
    """
    traced = is_traced(built)
    by_atom = _ledger._by_atom(built["records"])
    reasons = {}
    for lc in built["labels"]:
        if lc.is_fact or lc.indirect_cite:
            continue
        site = (lc.file, lc.line)
        if not traced:
            reasons[site] = (None, _NOT_TRACED)
            continue
        unit_id, resolve_reason = _resolve.resolve(lc.label, built["doc_units"])
        if resolve_reason is not None:
            reasons[site] = (None, _RESOLVE_REASONS[resolve_reason])
            continue
        if not lc.cites:
            reasons[site] = (unit_id, _CITES_NOTHING)
            continue
        # BASE UNIT IDS, never raw selectors: `resolve.resolve` (above) only
        # ever resolves a label's quote to a WHOLE unit -- labels are not
        # run-aware -- so a record whose `units:` binds a single run
        # (`…#parag_174.001/1`, spec 13.20) must still be considered to reach
        # the unit that run belongs to, or every labelled clause behind a
        # run-qualified citation would misreport MISATTRIBUTED the day the
        # domain adopts one.
        reachable = set()
        for atom in lc.cites:
            record = by_atom.get(atom)
            if record is not None:
                reachable |= {_units.parse_selector(u)[0] for u in record.units}
        if unit_id not in reachable:
            reasons[site] = (unit_id, _MISATTRIBUTED)
        else:
            reasons[site] = (unit_id, None)
    return reasons


def _check_label_units(built):
    """A label's quote must resolve to exactly one unit, exactly as a
    record's `units:` must resolve (T3).

    Reported separately from the SUBSET check so an author is sent to fix the
    right thing: a quote that names nothing, several things, or an unpinned
    document is a typo or a mis-scoped quote, not a misattribution. Reads
    `_label_check_reasons` -- see there for why this and `_label_entry` must
    never call `resolve.resolve` independently, and for the reachability gap
    (a fact or `indirect_cite` label with a bad quote reaching this function
    at all) an earlier round left untested even though this code already
    guarded against it.

    THREE DISTINCT REASONS, THREE DISTINCT MESSAGES: `resolve.resolve` fails a
    quote for one of three reasons and each sends an author to a different
    fix, so each gets its own wording rather than one generic "does not
    resolve" -- exactly as `_check_label_subset` already gives `_CITES_
    NOTHING` and `_MISATTRIBUTED` their own.

    THE MATCH DETAIL (which units a quote came close to or collided with) is
    RECOMPUTED here via `resolve._candidates`/`resolve._matches` -- IMPORTED,
    not re-typed, so the scoping and the containment test a message describes
    can never silently drift from the ones `resolve.resolve` itself just ran
    -- never stored in `_label_check_reasons`: `resolve.resolve`'s contract
    (task 2) is to return a reason CODE, not a sentence, so building a
    message is every caller's own job. Recomputing it changes no verdict --
    the verdict is `reasons[site]`, read once, above.

    THE NO_MATCH PREFIX IS PER CANDIDATE UNIT, NEVER A JOIN. `_check_t5`
    joins the units a CITATION already named, in document order, because a
    chapeau and its points are one sentence in the source and T5 is checking
    fidelity to a claim the author already made about which units apply.
    This function has no such claim to join over -- it is SEARCHING -- and
    the resolver's own ruling (`resolve.py`'s module docstring, and the
    operator decision in this task's brief) is that a quote resolves within
    ONE unit or not at all. Joining candidates here to compute the prefix
    would answer a question about a DIFFERENT, wider text than the one that
    actually failed to match, and for exactly the shape that ruling exists
    for -- a quote spanning a chapeau and a point -- it would report the
    quote as matching "in full" with nothing left to diverge on, which is
    the opposite of the truth: it matched nothing, in either single unit, and
    only appeared to succeed by reading across a boundary resolution refuses
    to cross. So the prefix is taken against each candidate RUN separately --
    per run, not merely per unit, because a unit's own text can itself be
    discontiguous and the same argument applies word for word to its internal
    seam (Art 174(1)) -- and the BEST (longest) one is reported; separately, a join
    IS computed, ONLY to detect whether the quote continues past that best
    single-unit match into the next unit in document order -- if it does,
    the message says so explicitly, because "matches up to X" alone would
    otherwise look identical to an ordinary interior drop.
    """
    reasons = _label_check_reasons(built)
    problems = []
    for lc in built["labels"]:
        entry = reasons.get((lc.file, lc.line))
        if entry is None:
            continue
        _, reason = entry
        if reason not in (_NO_MATCH, _AMBIGUOUS, _UNKNOWN_SOURCE):
            continue
        if reason == _UNKNOWN_SOURCE:
            problems.append(
                f"{lc.file}:{lc.line}: label @{lc.label.id} names source "
                f"{lc.label.source!r}, which is not among the pinned "
                f"document(s) under sources/. Check the mnemonic against "
                f"each sidecar meta.yaml's doc_id.")
            continue
        quote = _units._normalise(lc.label.verbatim)
        candidates = _resolve._candidates(lc.label, built["doc_units"])
        if reason == _AMBIGUOUS:
            matches = sorted(_resolve._matches(quote, candidates))
            problems.append(
                f"{lc.file}:{lc.line}: label @{lc.label.id} quotes text "
                f"that matches {len(matches)} units in the pinned "
                f"document(s) ({', '.join(matches)}): an ambiguous quote is "
                f"never resolved by picking one -- an author cannot fix an "
                f"ambiguity they cannot see. Narrow the quote, or scope it "
                f"to one document with a `mnemonic:` prefix.")
        else:                                              # _NO_MATCH
            best_id, best_matched = None, -1
            for unit in candidates:
                for run in unit["runs"]:
                    m = _units._matched_prefix(
                        quote, _units._normalise(run["text"]))
                    if m > best_matched:
                        best_matched, best_id = m, unit["id"]
            joined = _normalise_whitespace(
                " ".join(run["text"] for unit in candidates
                         for run in unit["runs"]))
            spans_boundary = _units._matched_prefix(quote, joined) > best_matched
            boundary_note = (
                " The quote continues past the end of that unit into "
                "another one -- a quote must resolve within a SINGLE unit "
                "(a chapeau and its points do not join here the way a "
                "citation's own `verbatim` may)." if spans_boundary else "")
            problems.append(
                f"{lc.file}:{lc.line}: label @{lc.label.id} quotes text "
                f"that resolves to no unit in the pinned document(s). "
                f"Against {best_id} the quote matches up to "
                f"…{quote[max(0, best_matched - QUOTE_WINDOW):best_matched]!r} "
                f"and then reads "
                f"{quote[best_matched:best_matched + QUOTE_WINDOW]!r}…, which "
                f"that unit's own text does not continue.{boundary_note} "
                f"Re-copy the words from the pinned document, or check the "
                f"label's source mnemonic.")
    return problems


def _check_label_subset(built):
    """A label's resolved unit must be reachable from THAT CLAUSE's own cites.

    SUBSET, NOT EQUALITY, and the asymmetry is load-bearing: a cite atom
    resolves to a record whose `units:` may name several provisions, and a
    clause legitimately implements one while sibling clauses implement the
    rest. Equality would fail correct code.

    What subset catches is MISATTRIBUTION -- a label naming a provision no cite
    of that clause reaches. That is spec §7's M4 `misattribute_cite` class, one
    of the two that die only if a reviewer compared statute text to the claim.

    TWO CARVE-OUTS, both deliberate:

      * `indirect_cite` rules bind their cite at run time via `findall`, so
        what the clause actually cites is not knowable from the source. The
        carve-out is NOT that `cites` is empty -- a clause can be both, e.g.
        `obligations(P, CITES) <- (cite(art_1), findall(cite(C), norm(P, C),
        CITES))`, which carries a static cite AND binds more at run time. It
        is that the run-time half could reach any provision at all, so a
        subset claim over the static half alone would reject exactly the
        clauses this exists to attribute. The whole clause is therefore left
        unchecked, and the artifact SAYS so (`cross_checked: false` with the
        indirect-cite note) rather than claiming a pass it did not verify.
      * FACTS are not cross-checked at all. `scan_file_cites` is deliberately
        an unattributed superset -- which fact carried an atom is not recorded
        -- and `ledger.py` states that reader may not be changed here. Closing
        this needs a new per-fact attributed scan (spec §13.8), which is out of
        this plan's scope. It is made VISIBLE in the artifact rather than left
        silent; see `build_document`.

    A LABEL WHOSE QUOTE DOES NOT RESOLVE IS SKIPPED HERE TOO, mirroring T5's
    own guard against re-explaining a T3-class defect (see `_check_t5`):
    `_check_label_units` already names a quote that resolves to no unit, to
    two or more, or to no pinned document, and a clause whose only cite is
    real would otherwise ALSO be told the (nonexistent) unit is unreached --
    the same defect, reported twice, "fixed" by editing the cite against a
    provision the quote never actually named. `_label_check_reasons` is what
    enforces this: a resolution failure's reason is `_NO_MATCH`, `_AMBIGUOUS`
    or `_UNKNOWN_SOURCE` there, never `_CITES_NOTHING` or `_MISATTRIBUTED`, so
    it cannot also match either branch below.

    THE NAMED UNIT COMES STRAIGHT OUT OF `_label_check_reasons`'s map --
    `(unit_id, reason)`, not a second `resolve.resolve` call. An earlier
    version of this function re-resolved the label to recover the id for the
    sentence; that was a second call site for a pure function that could not
    disagree with the first TODAY, but was still a second place a future edit
    (memoising `doc_units`, say, or widening `resolve`'s signature) could make
    it disagree. `_label_check_reasons` already has `unit_id` in hand at the
    moment it records `_MISATTRIBUTED` -- reading it back here is net ONE
    FEWER derivation, not a second one.
    """
    reasons = _label_check_reasons(built)
    problems = []
    for lc in built["labels"]:
        entry = reasons.get((lc.file, lc.line))
        if entry is None:
            continue
        unit_id, reason = entry
        if reason == _CITES_NOTHING:
            problems.append(
                f"{lc.file}:{lc.line}: label @{lc.label.id} quotes a "
                f"provision, but the clause cites nothing. Coverage is "
                f"computed from cites, so that unit reads unaccounted while "
                f"this comment says it is implemented. Add the cite, or drop "
                f"the quote from the label.")
        elif reason == _MISATTRIBUTED:
            named = ", ".join(sorted(lc.cites)) or "nothing"
            problems.append(
                f"{lc.file}:{lc.line}: label @{lc.label.id} names "
                f"{unit_id}, which no cite of this clause reaches "
                f"(it cites {named}). Either the label names the wrong "
                f"provision, or the clause cites the wrong atom.")
    return problems


# ── labels: emission, and saying so when one is NOT cross-checked ───────────

#: `cross_checked_note` text, one per `_label_check_reasons` reason plus the
#: two exemptions that never reach that map at all. Module-level so the
#: note's wording is the SAME string a reader sees whichever domain emits it,
#: and so a test can pin the reason rather than the sentence around it. Each
#: is deliberately its OWN wording, never shared: "not checked" (the never-
#: checked notes) and "checked and failed" (the failure notes) are different
#: statements, and conflating any of their wording would blur the one
#: distinction this field exists to draw. A note that says "see the
#: corresponding problem" belongs to the SECOND family only -- a domain with no
#: problem to see must never be sent looking for one.
_FACT_NOT_CROSS_CHECKED = (
    "fact — which fact carries a cite atom is not recorded (see spec §13.8); "
    "neither the unit reference nor the quote was checked")
_INDIRECT_NOT_CROSS_CHECKED = (
    "indirect cite — bound at run time by findall, so what the clause cites "
    "is not knowable from the source; neither the unit reference nor the "
    "quote was checked")
_NOT_TRACED_NOT_CROSS_CHECKED = (
    "not traced — no pinned document to resolve the quote against, so the "
    "claim was never checked")
_NO_QUOTE_NOT_CROSS_CHECKED = (
    "no quote — a locator alone cannot be resolved to a unit (see labels.py's "
    "module docstring for why), so the claim was never checked")
_NO_MATCH_NOT_CROSS_CHECKED = (
    "the quote does not resolve to a unit in the pinned document(s) — see "
    "the corresponding problem")
_AMBIGUOUS_NOT_CROSS_CHECKED = (
    "the quote matches more than one unit in the pinned document(s) — see "
    "the corresponding problem")
_UNKNOWN_SOURCE_NOT_CROSS_CHECKED = (
    "the label names a source document that is not among the pinned "
    "document(s) — see the corresponding problem")
_CITES_NOTHING_NOT_CROSS_CHECKED = (
    "the clause cites nothing while the label claims a unit — see the "
    "corresponding problem")
_MISATTRIBUTED_NOT_CROSS_CHECKED = (
    "no cite of this clause reaches the claimed unit — see the "
    "corresponding problem")

#: `_label_check_reasons` reason -> the note that explains it, split by KIND
#: so the two families cannot drift into each other's wording. `_FAILURE_NOTES`
#: holds the reasons a check RAN and failed -- the exact five `_check_label_
#: units`/`_check_label_subset` turn into problem strings -- and `_NEVER_
#: CHECKED_NOTES` the reasons a check never ran at all. The map is the second
#: consumer's read of the first consumer's verdict -- see `_label_check_
#: reasons` for why there is exactly one derivation.
_FAILURE_NOTES = {
    _NO_MATCH: _NO_MATCH_NOT_CROSS_CHECKED,
    _AMBIGUOUS: _AMBIGUOUS_NOT_CROSS_CHECKED,
    _UNKNOWN_SOURCE: _UNKNOWN_SOURCE_NOT_CROSS_CHECKED,
    _CITES_NOTHING: _CITES_NOTHING_NOT_CROSS_CHECKED,
    _MISATTRIBUTED: _MISATTRIBUTED_NOT_CROSS_CHECKED,
}
_NEVER_CHECKED_NOTES = {
    _NOT_TRACED: _NOT_TRACED_NOT_CROSS_CHECKED,
    _NO_QUOTE: _NO_QUOTE_NOT_CROSS_CHECKED,
}
#: What `_label_entry` actually indexes. A reason with no note here is a
#: `KeyError` at emit time, which is the loud failure a silently missing note
#: would not be.
_REASON_NOTES = dict(_FAILURE_NOTES, **_NEVER_CHECKED_NOTES)


def _label_entry(labelled, reasons):
    """One `labels:` row, A FRESH DICT EVERY CALL.

    The freshness is not style, exactly as `_covering`'s docstring argues for
    coverage entries: `yaml.safe_dump` emits an `&id001`/`*id001` anchor/alias
    pair for any object it meets twice, and a shared or mutated-and-reused
    dict would put one into a committed artifact spec §8 promises a renderer
    can read standalone.

    THE ROW CARRIES THE LABEL'S OWN FIELDS -- `source`, `locator`, `verbatim`
    -- never an authored `unit` (there is none any more) and never a
    `summary` (the grammar dropped it in task 1). It ALSO carries
    `resolved_unit`, present iff `cross_checked` is true: a renderer holding
    only `provisions.yaml` needs to answer "which provision" without
    re-implementing `resolve.resolve` itself -- its normalisation, its case
    sensitivity, its exactly-one-match rule, its `<source>#` scoping -- in a
    second file, quite possibly a second language, which is precisely the
    second derivation `resolve.py`'s own docstring forbids, now exported
    across a boundary no test here can reach. `unit_id` is read straight out
    of `_label_check_reasons`'s map, which already computed it deciding
    whether the label passed -- NOT a second `resolve.resolve` call, which
    would have been the derivation this whole layer exists to prevent, one
    hop removed.

    `cross_checked` answers ONE question: did this label's claim PASS? Not
    "was it eligible for checking" -- that was the wrong question two earlier
    rounds kept asking, and each answer of it left a checked, FAILED claim
    marked `True`. `provisions.yaml` carries no `problems`, only
    `problem_count` (see `build_document`), so `True` here is the only place
    a renderer reading this file standalone would ever see the verdict --
    marking a checked failure `True` is exactly the defect this field exists
    to prevent.

    False in two KINDS of case, each with its own `cross_checked_note`. The
    KINDS are counted here, never the individual reasons: this docstring has
    stated a false count once already, because an earlier round added
    reasons and updated the number by one. Adding a reason to `_label_check_
    reasons` must not oblige anyone to find and correct a number over here.

      * NEVER CHECKED AT ALL -- a FACT, an `indirect_cite` rule
        (`scan_file_cites` is an unattributed superset; a `findall` rule
        binds its cite at run time), and any reason in `_NEVER_CHECKED_
        NOTES`: an UNTRACED domain (no pinned document to resolve against)
        and a label with `verbatim is None` (a locator, or nothing, is not a
        checkable claim -- see `resolve.py`'s own docstring for `NO_QUOTE`);
      * CHECKED, AND FAILED -- any reason in `_FAILURE_NOTES`. Read from that
        one shared computation, never re-derived here, so this and the check
        functions cannot disagree about which labels failed.

    Note that the FACT/`indirect_cite` branches below read `labelled.is_fact`/
    `labelled.indirect_cite` directly rather than consulting `reasons`, and
    that is safe (unlike a second call to `resolve.resolve` would be) only
    because those two are bare fields on `LabelledClause`, not a derived
    verdict -- there is nothing for this branch and `_label_check_reasons`'s
    matching skip-condition to disagree about, both being one read of the
    same field. `_NOT_TRACED` and the four resolution reasons are NOT read
    this way, precisely because they ARE derived (`is_traced(built)`,
    `resolve.resolve(...)`) -- see `_label_check_reasons` for the defect that
    produced this split.

    A RESOLVED, SUBSET-CLEAN LABEL CARRIES NO NOTE AT ALL. Under quote-as-key
    this is stronger than it looks: resolution IS the fidelity check now --
    the quote had to occur, verbatim, in the pinned text for `resolve.resolve`
    to bind a unit at all -- so there is nothing left to disclose about the
    quote the way the retired `<doc_id>#<eid>` grammar's separately-authored
    `unit` field once required (a quote could name the right id and still be
    fiction; it no longer can). A labelled FACT or `indirect_cite` rule is the
    one place that guarantee does NOT hold -- neither is cross-checked at
    all, so neither's quote is compared to pinned text either, and a swapped
    verbatim on one of those two rows is the one shape of that mutant this
    layer still cannot see. `_FACT_NOT_CROSS_CHECKED`/`_INDIRECT_NOT_CROSS_
    CHECKED` say only that the unit reference went unchecked; they must not
    be read as also vouching for the quote.
    """
    label = labelled.label
    entry = {
        "id": label.id,
        "file": labelled.file,
        "line": labelled.line,
        "source": label.source,
        "locator": label.locator,
        "verbatim": label.verbatim,
    }
    if labelled.is_fact:
        entry["cross_checked"] = False
        entry["cross_checked_note"] = _FACT_NOT_CROSS_CHECKED
    elif labelled.indirect_cite:
        entry["cross_checked"] = False
        entry["cross_checked_note"] = _INDIRECT_NOT_CROSS_CHECKED
    else:
        unit_id, reason = reasons[(labelled.file, labelled.line)]
        if reason is None:
            entry["cross_checked"] = True
            entry["resolved_unit"] = unit_id
        else:
            entry["cross_checked"] = False
            entry["cross_checked_note"] = _REASON_NOTES[reason]
    return entry


def _label_rows(labelled_clauses, reasons):
    """The `labels:` list, or `None` for a domain that carries none.

    `None` rather than `[]`, mirroring `_finish_attribution`: a domain with no
    labels must carry NO `labels:` key at all, or an empty list reads as
    "looked for and found none" -- indistinguishable from a domain that has
    not adopted labels. `build_document` is what turns `None` into an absent
    key; this function only decides whether there is anything to show.

    Sorted on `(file, line)` AS A TUPLE, never on a formatted string --
    `_sites` documents the exact trap: `"k.clausal:10"` sorts before
    `"k.clausal:9"` as text. The artifact is committed, so a non-deterministic
    or wrong order churns its diff for no change.

    `reasons` is `_label_check_reasons(built)`, threaded through to
    `_label_entry` unchanged -- see there for why a label's own
    `cross_checked` must read it rather than recompute it.
    """
    if not labelled_clauses:
        return None
    return [_label_entry(lc, reasons) for lc in
            sorted(labelled_clauses, key=lambda lc: (lc.file, lc.line))]


def _source_rows(sources):
    """The `sources:` list, or `None` for a domain pinning nothing.

    `None` rather than `[]`, the same rule `_label_rows` follows: a domain
    with no pinned document under `sources/` must carry no `sources:` key at
    all, or an empty list reads as "looked, found no pin" -- indistinguishable
    from a domain that has never been traced.

    Sorted on `(doc_id, file)` AS A TUPLE, never on a formatted string --
    `_label_rows` documents the exact trap this avoids. Both fields are safe
    to sort on unconditionally: `units.load_sources_with_provenance` requires
    each to be a non-empty string before a document contributes an entry to
    `sources` at all (see its docstring), so neither is ever absent here.
    """
    if not sources:
        return None
    return [_source_row(source) for source in
            sorted(sources, key=lambda s: (s["doc_id"], s["file"]))]


def _source_row(source):
    """One `sources:` entry -- a FRESH dict, copied field for field from what
    Task 1 (`units.load_sources_with_provenance`) carried.

    `dict(source)` rather than an allowlist of named fields: Task 1's own
    contract is AS-RECORDED / ABSENT-STAYS-ABSENT / UNKNOWN-KEYS-PASS-THROUGH,
    and an allowlist here would silently drop a sidecar field this emitter has
    no opinion about -- the exact defect Task 1 exists to prevent, reappearing
    one layer up.

    A FRESH dict, not the ledger's own object, and a fresh `extract` too if
    the source has one. `source` here already IS its own object -- each
    sidecar is parsed separately by `load_sources_with_provenance`, so no two
    entries share one -- but this function does not rely on that being true
    for every caller, present or future: `yaml.safe_dump` emits `&id001` /
    `*id001` anchor-alias pairs for any object it meets twice in the same
    document, and this artifact is committed and must be readable standalone,
    with no anchor for a reader to resolve.
    """
    row = dict(source)
    extract = row.get("extract")
    if isinstance(extract, dict):
        row["extract"] = dict(extract)
    return row


# ── T5: verbatim fidelity ────────────────────────────────────────────────────

def _segments(runs_by_id, named):
    """The text of NAMED, cut into maximal stretches the DOCUMENT reads
    straight through.

    Every run of every named unit, ordered by its document position, and cut
    wherever two consecutive runs are not neighbours in the document (their
    positions differ by more than one). Between two such runs sits text this
    record did not name -- its own points, or another provision entirely -- so
    the two are not one sentence and must never be searched as one string.

    This is the ONE place T5 is allowed to join two texts, and it may only do
    it where `units.Run.pos` says the document already had. Anything that
    re-joins these segments afterwards (`" ".join(segments)`,
    `units.joined_text`, `Unit.text`) puts the fabrication straight back.

    NAMED carries raw selectors, not bare unit ids: a record's `units:` may
    address a single RUN (`…#parag_174.001/1`, spec 13.20), and a citation
    naming only run 1 must be checked against run 1's own text, never against
    a run it did not name. `resolve_selector` -- the one function every
    `units:` consumer goes through -- turns each selector into the runs it
    actually addresses (every run for a bare id, rule 3; the one run for a
    `/n` selector); an unresolvable selector contributes no text here, since
    T3 already names why and `_check_t5`'s own guard skips the whole record
    before this function is ever called with one.
    """
    run_counts = {unit_id: len(runs) for unit_id, runs in runs_by_id.items()}
    named_runs = []
    for selector in set(named):
        unit_id, positions, problem = _units.resolve_selector(
            selector, run_counts)
        if problem is not None:
            continue
        runs = runs_by_id[unit_id]
        named_runs.extend((runs[position - 1]["pos"], runs[position - 1]["text"])
                          for position in positions)
    segments, previous = [], None
    for pos, text in sorted(named_runs):
        text = _normalise_whitespace(text)
        if previous is not None and pos == previous + 1:
            segments[-1] = f"{segments[-1]} {text}"
        else:
            segments.append(text)
        previous = pos
    return segments


def _check_t5(built):
    """A record's `verbatim` occurs in the text of the units it names.

    CONTAINMENT, NOT EQUALITY. A unit is a whole paragraph and a record quotes
    the operative words it implements, so equality would force an author to
    transcribe the entire provision -- text the ledger already carries in
    `doc_units`, so the transcription adds no information and every wrapped
    line becomes a defect. Containment states the property that actually
    matters: the words attributed to the statute are the statute's words, in
    that order, uninterrupted.

    WHAT THIS CATCHES AND WHAT IT MISSES, stated plainly because a fidelity
    check that overclaims is worse than none. It catches an interior drop (the
    Art 174(1)(b) shape: "transactions included in the numerator and" removed
    from the middle, the remainder reading perfectly well), a paraphrase, a
    substitution, and a quote taken from the wrong provision. It does NOT catch
    a truncation at either END -- a prefix of the text is a substring of it --
    nor an ellipsis-elided quote, which reads as an interior drop and is
    reported. Both are the permissive direction on purpose: the check owes no
    false positives to a domain that has done nothing wrong, and the class it
    was built for is the one it catches.

    The comparison is against the units THIS RECORD names, joined in DOCUMENT
    order, never against the document at large -- a quote of Art 2(b) filed
    under a record naming Art 2(a) is a mis-citation, and a document-wide
    search would wave it through. Joining is what lets a chapeau and its points
    be quoted as the one sentence they are in the document; a check that
    compared unit by unit would fail the most ordinary citation in real Akoma
    Ntoso.

    BUT ONLY WHERE THE DOCUMENT ITSELF JOINS THEM, which is what `_segments`
    below is for. A unit's own text can be discontiguous (VAT Directive Art
    174(1): a lead-in, then its two lettered points, then a further
    subparagraph), and concatenating the surviving pieces produces a sentence
    that appears nowhere in the Directive -- against which containment would
    certify as the statute's uninterrupted words a phrase no statute contains.
    So the record's named text is cut into MAXIMAL CONTIGUOUS SEGMENTS, using
    the document-wide run positions the reader recorded (`units.Run.pos`), and
    the quote must fall inside ONE of them. A chapeau and its points are
    adjacent runs, so they still join; the chapeau and the subparagraph BELOW
    those points are not, so they no longer do. Two named units that are not
    neighbours in the document are likewise no longer spliced -- an earlier
    version called that "the permissive direction", but it is the same
    fabrication one level up, and nothing needs it.

    UNIT TEXT COMES FROM THE LEDGER. Re-reading the pinned document here would
    re-parse every source on every run AND break the invariant that the checker
    reads the ledger and nothing else -- if the ledger and the checker can see
    different text, this layer reproduces its own failure mode in miniature.
    """
    runs_by_id = {unit["id"]: unit["runs"] for unit in built["doc_units"]}
    run_counts = {unit_id: len(runs) for unit_id, runs in runs_by_id.items()}
    problems = []
    for record in built["records"]:
        quote = _normalise_whitespace(record.verbatim)
        # An EMPTY verbatim is not a fidelity failure. An unsourced record is
        # `check_citations`' business, and the six all-`unverified`
        # eu/procurement domains REQUIRE an empty verbatim -- firing here would
        # redden a domain for obeying its own convention.
        if not quote or not record.units:
            continue
        # An unresolvable selector -- unknown unit, or a `/n` run out of
        # range -- is ONE defect and T3 already names it. Reported twice, the
        # author "fixes" the fidelity complaint by editing the quote to match
        # a provision that does not exist.
        if any(_units.resolve_selector(selector, run_counts)[2] is not None
               for selector in record.units):
            continue
        segments = _segments(runs_by_id, record.units)
        if any(quote in segment for segment in segments):
            continue
        matched = max((_units._matched_prefix(quote, segment)
                       for segment in segments), default=0)
        where, subject = _record_site(record)
        problems.append(
            f"T5 {where}: {subject} quotes words the pinned text does not "
            f"contain. The quote matches up to "
            f"…{quote[max(0, matched - QUOTE_WINDOW):matched]!r} and then reads "
            f"{quote[matched:matched + QUOTE_WINDOW]!r}…, which is not how the "
            f"pinned text of {', '.join(record.units)} continues. A quote that "
            f"reads perfectly well but drops a clause from the middle is the "
            f"defect this check exists for — re-copy the words from the pinned "
            f"document.")
    return problems


# ── §6: deferral discipline ──────────────────────────────────────────────────

def _check_order_honoured(built):
    """An operator-declared exclusion missing from the register is scope drift.

    ONE DIRECTION ONLY, and the asymmetry is the whole point. The order is the
    operator's scope contract, so an entry of ITS `deferred_set` that the
    manifest does not register has been silently formalized or silently
    dropped -- either way the domain no longer means what was ordered, and
    nothing else in this layer notices. The REVERSE is not an error: the
    register COMPLETES the order (the vat manifest carries 7 entries against
    its order's 2, and the extra 5 are legitimate completions). Those are
    `expansion` in `deferral_labels`, which is what bounds a review to the
    expansions instead of the whole statute -- fail them here and the label
    becomes a fail-flag, so an author's only way to green a completed domain is
    to stop recording the completions.

    `has_order` is checked, not `order_deferrals`: a domain with no order has
    no scope contract to honour, whereas an order that defers NOTHING is a
    contract that authorizes no exclusions. The two happen to produce the same
    empty problem list here -- the distinction is load-bearing in the labels --
    but keying on the emptiness of the list would state the wrong reason.

    NO REGISTER AT ALL IS "EVERY EXCLUSION MISSING", never "nothing to
    compare". It is the corpus's own shape -- 15 of the 16 order-backed domains
    carry no `deferred_set` whatsoever -- so a guard on `built["deferrals"]`
    being non-empty would silence this check on precisely the population it was
    written for, while passing every test that uses a domain with a register.
    A domain whose operator declared exclusions and which records none of them
    is scope drift by definition.
    """
    if not built["has_order"]:
        return []
    problems = []
    # BOTH relations, through one parameterised body rather than a copy. The
    # asymmetry, the reasoning and the message are identical for an exclusion
    # (spec 13.21); two near-identical functions would drift, and the one that
    # drifted would be the one nobody was reading.
    for key, ordered, registered_key, addresses in (
            ("deferred_set", "order_deferrals", "deferrals", "units"),
            ("excluded_set", "order_exclusions", "exclusions", "cites")):
        # `_registered_whats`, not a set comprehension over `entry.get("what")`:
        # an unhashable one raises out of `check_domain`, which promises not to.
        registered = _registered_whats(built, registered_key)
        problems += [
            f"§6 manifest.yaml {key}: {what!r} is declared in the order's "
            f"{key} but is absent from the register. Formalizing or dropping "
            f"an operator-authorized exclusion is scope drift — add an entry "
            f"with `what: {what}`, its {addresses}, a reason and a "
            f"consequence, or amend the order if the exclusion no longer "
            f"holds."
            for what in built[ordered] if what not in registered
        ]
    return problems


def _label_of(labels, what):
    """A register entry's authorized/expansion label, or `None`.

    `what` COMES OUT OF A YAML FILE and is not necessarily a string. `what: [a,
    b]` is already a ledger problem, and `ledger._deferrals` deliberately KEEPS
    such an entry so the defect stays visible in the register rather than
    vanishing from it -- which means every consumer downstream meets the list.
    A bare `labels.get(what)` then raises `TypeError: unhashable type: 'list'`
    out of `build_document`, and through it out of `check_domain`, whose
    contract is that it never raises on domain content. In the hook that turns a
    would-be problem into a traceback and a non-zero exit for a domain that
    never opted in: a ratchet bypass in the fail-closed direction, the same
    class `_drifted_keys` documents arriving from a second angle.

    `ledger._deferring` already guards its own copy this way, so the emitted
    unit-level chain and this register-level label agree on the answer: no
    label. Which is TRUE -- a `what` that is not a string cannot equal any entry
    of an order's `deferred_set`, so nothing authorized it.
    """
    return labels.get(what) if isinstance(what, str) else None


def _registered_whats(built, key="deferrals"):
    """The `what`s the manifest KEY register actually registers, as a SET.

    Non-string `what`s are dropped rather than collected, for the reason
    `_label_of` gives: they are unhashable, they are already a reported ledger
    problem, and an order's `deferred_set` entry is a string, so a list can
    honour no exclusion. Dropping it means the order entry it was supposed to
    register reads as absent -- which is what it is.
    """
    return {entry.get("what") for entry in built[key]
            if isinstance(entry.get("what"), str)}


# ── the ratchet (spec §5) ────────────────────────────────────────────────────

def exemption(built):
    """The stated exemption prose, or None when this domain is not exempt.

    Read off the LEDGER for the same reason `is_enforced` is: a second read of
    manifest.yaml could disagree with the one the ledger recorded, and the read
    that decides must be the recorded one. An exemption declared without prose
    returns None — it does not hold.
    """
    if (built or {}).get("provision_tracking") != EXEMPT:
        return None
    reason = (built or {}).get(EXEMPTION_REASON_KEY)
    if isinstance(reason, str) and reason.strip():
        return reason.strip()
    return None


def is_enforced(domain_dir, built=None):
    """Whether this domain's problems BLOCK. Nothing else changes with it.

    Read off the LEDGER's `provision_tracking`, not a second read of manifest.yaml.
    Two reads of the same file can disagree -- one of them can also fail, and a
    manifest that the ledger could not parse must not become "enforced" by a
    laxer re-read here. `built` is the ledger `main` already has, so a run makes
    exactly one manifest read; the one-argument form is the public contract.

    ONLY the exact word arms it. A domain that says `provision_tracking: yes` has not
    opted in, and `main` tells it so instead of treating the value as truthy --
    "a manifest that thinks it is enforced and is not" is precisely the silent
    green this layer exists to remove.
    """
    built = _ledger.build(domain_dir) if built is None else built
    return built["provision_tracking"] == ENFORCED


def enforcement_unknown(built):
    """Whether the ratchet's own input could not be read.

    THE FAIL-OPEN THIS CLOSES. `ledger._load_yaml` maps an unparseable
    manifest.yaml to a problem plus `None`, and `build` then reads `{}`, so
    `provision_tracking` is `None` -- byte-identical to a manifest that never
    declared the field. `is_enforced` therefore returned False and an ENFORCED
    domain whose manifest gained a YAML syntax error printed its real problems
    and exited 0. One commit that both broke the manifest and dropped a
    deferral sailed through, and the ratchet was disarmed by the very file that
    arms it.

    THE CHOICE: it blocks WHEN THERE ARE PROBLEMS, not unconditionally, and the
    two differ only in principle. An unreadable manifest is ALWAYS itself a
    problem (`_load_yaml` records "cannot be read as YAML"), so in practice such
    a domain blocks every time; what "when problems exist" buys is that the exit
    code stays a function of the PROBLEMS and of nothing else. A domain blocks
    because something is wrong with it, never because a tool could not tell what
    it declared -- that rule is what makes the ratchet legible, it is the same
    rule `is_enforced` and the advisories already obey, and giving it up for a
    case that cannot arise (no problems, unreadable manifest) would buy nothing.

    `is_enforced` is deliberately NOT widened to cover this. Enforcement is a
    DECLARED fact, and a domain whose manifest does not parse has declared
    nothing; saying "enforced" of it would put a claim in the ledger, the
    emitted artifact and the renderer that the manifest does not make. Unknown
    is its own state and this is where it is named.
    """
    return bool(built["manifest_unreadable"])


def _check_enforced_is_traced(domain_dir, built):
    """An ENFORCED domain that is not traced is un-armed, not clean.

    The third state's "no unit store, nothing to check, exit 0" was written for
    the UNDECLARED population -- 60 of 60 domains on day one, none of which
    asked for any of this. An enforced domain is the opposite case: it declared
    that its statute is traced, so having no pinned statute is not "unasked",
    it is the commitment unmet. Without this, `git rm -r sources/` turns every
    check in this file off at once and the run still prints the untraced note
    and exits 0 -- the whole gate disarmed by a deletion nobody had to argue
    for, which is the exact false-green class the layer exists to remove.

    It fires ONLY when enforced, so the undeclared population is untouched:
    every one of them stays in the quiet third state, and this problem cannot
    appear on a domain that did not opt in.
    """
    if not is_enforced(domain_dir, built):
        return []
    return [
        f"§5 sources/: `provision_tracking: {ENFORCED}` is declared, but this domain "
        f"is not traced — no pinned statute under sources/, so T1, T2, T3, T5 "
        f"and §6 have nothing to check and the enforcement is armed over "
        f"nothing. A domain that committed to being traced and carries no "
        f"pinned document is un-armed, not clean. Pin the statute (an .xml plus "
        f"its .meta.yaml sidecar under sources/), or drop `provision_tracking: "
        f"{ENFORCED}` from manifest.yaml until it is pinned. (If sources/ IS "
        f"present, a reader problem above says why its units were withheld.)"]


# ── the headline and the emitted artifact (spec §6 item 3, §8) ───────────────

def _deferred_by(built):
    """`{unit id: [what, ...]}` -- which register entries defer each unit.

    READ OFF THE LEDGER'S ATTRIBUTION, not re-walked from the register. Both
    reach the same emitted file -- this as `deferred_by`, the attribution as the
    unit's deferral chain -- and a second walk here could name a different set of
    entries from the one the chain shows, which is a report contradicting itself
    on the very join spec §6's mitigation depends on. One walk, in
    `ledger.build`, and this projects it.

    Sorted, because it reaches a COMMITTED file and a set's iteration order is
    not stable across interpreters. An entry with no `what` (already a ledger
    problem) contributes `""`: it is labelled by nothing, so `unit_states` reads
    its units as GREY -- not order-authorized, which is true.
    """
    out = {}
    for unit_id, rows in built.get("attribution", {}).items():
        whats = {entry["what"] if isinstance(entry["what"], str) else ""
                 for entry in rows.get("deferrals", ())}
        if whats:
            out[unit_id] = sorted(whats)
    return out


def unit_states(built):
    """`{unit id: state}` over the pinned document -- the four-colour partition.

    ONE function so the headline's counts and the emitted file's per-unit states
    cannot disagree: a report whose colours contradicted its own totals would be
    this layer reproducing its own failure mode in miniature.

    Derived from the ledger's `covered`/`deferred`/`unaccounted` -- the same
    three lists T2 is scored on -- so a unit's colour IS its gate state.

      * CONTRADICTED reads the ledger's `"contradicted"`, a RUN-LEVEL
        intersection (spec 13.20), not the coarser `is_covered and
        is_deferred`: a unit covered on one run and deferred on a DIFFERENT
        run (Art 174(1)'s shape) is unit-level-both without being a
        contradiction, and testing membership alone here would resurrect the
        false positive run addressing exists to remove. Such a unit falls
        through to GREEN below -- some entry does cover it, and no run this
        function can see was claimed twice.
      * AMBER vs GREY is the DEFERRAL's label, per unit: a unit is AMBER when
        some entry deferring it is order-authorized. A unit deferred by both an
        authorized and an expansion entry is authorized -- the operator did
        exclude it -- which also keeps AMBER + GREY equal to the deferred total,
        so the headline's numbers add up rather than double-counting.
      * an entry with no `what` (already a ledger problem) is labelled by
        nothing, so its units read GREY: not order-authorized, which is true.
    """
    covered = set(built["covered"])
    deferred = set(built["deferred"])
    contradicted = set(built["contradicted"])
    labels = built["deferral_labels"]
    deferred_by = _deferred_by(built)
    states = {}
    for unit in built["doc_units"]:
        unit_id = unit["id"]
        if unit_id in contradicted:
            states[unit_id] = CONTRADICTED
        elif unit_id in covered:
            states[unit_id] = GREEN
        elif unit_id in deferred:
            authorized = any(labels.get(what) == "authorized"
                             for what in deferred_by.get(unit_id, []))
            states[unit_id] = AMBER if authorized else GREY
        else:
            states[unit_id] = RED
    return states


def headline(built):
    """The one line printed on every run, traced or not.

    ALWAYS THE SPLIT, never a bare verdict. A domain greened by deferring or
    exempting its way there must read as wrong at a glance; a reader who has to
    total the register up to notice is a reader who does not notice.

    Every number before the semicolon counts UNITS of the pinned document, and
    they partition it exactly, so the line cannot be read in two denominations.
    The one count that is not units says which denomination it is: exemptions
    are per PREDICATE (`no_statute/3` declares `functor/arity`, and one
    declaration exempts however many clauses that predicate has), so counting
    clauses would report a number nobody declared and would grow when a
    predicate is merely split across more rules.
    """
    if not is_traced(built):
        reason = exemption(built)
        return EXEMPT_NOTE.format(reason=reason) if reason else UNTRACED_NOTE
    states = unit_states(built)
    tally = {state: 0 for state in
             (GREEN, AMBER, GREY, RED, CONTRADICTED)}
    for state in states.values():
        tally[state] += 1
    contradicted = (f", {tally[CONTRADICTED]} both covered and deferred"
                    if tally[CONTRADICTED] else "")
    # AFTER the semicolon, beside `no_statute`, and never inside the `N units:`
    # breakdown. Exclusions name provisions OUTSIDE the unit total by
    # construction (T6), so folding the count in would make the parts stop
    # summing to the whole -- the one property the headline has that stops it
    # being read in two denominations at once.
    excluded = (f"; {len(built['exclusions'])} excluded"
                if built["exclusions"] else "")
    # SAID ON EVERY RUN, like the split itself. A domain resting on
    # interpretations nobody has reviewed must read as such at a glance -- that
    # is the whole ask this register was built for, and a count a reader has to
    # go and look for is a count nobody looks for.
    readings = built["operative_readings"]
    unreviewed = [entry for entry in readings if not _attested(entry)]
    reading_note = ""
    if readings:
        reading_note = (f"; {len(readings)} operative reading(s), "
                        f"{len(unreviewed)} UNREVIEWED" if unreviewed
                        else f"; {len(readings)} operative reading(s), all "
                             f"reviewed")
    return (f"{len(states)} units: {tally[GREEN]} formalized, "
            f"{tally[AMBER] + tally[GREY]} deferred ({tally[AMBER]} "
            f"authorized, {tally[GREY]} expansion), {tally[RED]} unaccounted"
            f"{contradicted}; {len(built['no_statute'])} predicate(s) "
            f"no_statute{excluded}{reading_note}")


def deferral_rate(built):
    """The deferral-rate monitor, as ONE advisory line -- or `None`.

    Deferred units over ACCOUNTED units (formalized + deferred, the headline's
    own partition via `unit_states`). Deferring is the cheapest discharge of a
    unit -- picking a reason always succeeds, finding supporting text sometimes
    does not -- so a clean ledger reached by deferral is the laundering path
    (todo `defer-unit-is-the-cheapest-path-to-a-false-green`). The rate makes
    it visible and comparable across domains. It is ADVISORY and printed only:
    never a problem, never an exit code, and not in the emitted artifact (so
    it cannot stale a committed `provisions.yaml`). A CONTRADICTED unit is in
    neither count -- it is a T2 problem, not an accounting. `None` for an
    untraced domain or one with nothing accounted, where a rate is 0/0.
    """
    if not is_traced(built):
        return None
    states = list(unit_states(built).values())
    deferred = sum(state in (AMBER, GREY) for state in states)
    accounted = deferred + sum(state == GREEN for state in states)
    if not accounted:
        return None
    return (f"deferral rate {deferred}/{accounted} accounted units deferred "
            f"({100 * deferred / accounted:.0f}%) — deferring is the cheapest "
            f"way to a clean ledger, so this is monitored, never scored.")


_CHECK_TAGS = ("T1", "T2", "T3", "T5", "T6", "T7", "H1", "§6")

#: Check families that are ANNOTATION DEBT: reported in full, never blocking.
#: T1 is "this operative clause names no provision" -- a backlog item about the
#: rulebase's own annotation, not a claim that the statute is unaccounted for.
#: The campaign's bar is COVERAGE (every unit formalized or deferred), and it
#: has counted T1 beside the verdict rather than inside it since the ledger
#: landed. The ratchet did not: it blocked on every problem, so a domain could
#: be fully accounted and still unable to arm -- procedure_choice, measured
#: 2026-09-05, was coverage-clean and exited 1 on 40 T1 clauses. That is the
#: reason 0 of 76 manifests carried `enforced`. Ruling the same day:
#: gate on coverage, report the debt.
DEBT_TAGS = ("T1",)


def blocking_problems(scored, built):
    """The subset of SCORED that decides the exit code of an enforced domain.

    Everything except the debt families, and READER problems whatever they are
    tagged. Reader problems are `built["problems"]` and sit first in the scored
    list by the contract `_scored_problems` states; they are untagged strings,
    so they survive a tag filter anyway, but they are taken positionally here
    for the same reason `_problems_by_check` does -- a sha mismatch withholds a
    document's units and DEFLATES the T2 denominator, so a broken pin must
    never be able to score as clean.

    Printing is untouched: every problem prints, in order, in every state. This
    governs the exit code and nothing else.
    """
    reader = list(built["problems"])
    rest = scored[len(reader):] if scored[:len(reader)] == reader else scored
    return reader + [p for p in rest
                     if p.split(" ", 1)[0] not in DEBT_TAGS]


def _problems_by_check(scored, built):
    """Per-check-family COUNTS over the same list `problem_count` measures.

    Counts, never strings: problem text is machine-dependent (it carries
    absolute paths) and this artifact is committed byte-deterministic; counts
    are not. The sum equals `problem_count` by construction, because both are
    taken over ONE list -- so the file cannot carry two verdicts about itself.

    Reader problems are `built["problems"]` and sit FIRST in the scored list (a
    stated contract in `_scored_problems`, in every tracking state). They get
    their own key rather than falling under `other` because a downstream
    verdict must be REFUSABLE on reader failure alone: a sha mismatch withholds
    that document's units (`units.load_sources`), which DEFLATES the T2
    denominator, so a broken pin would otherwise score CLEANER than a working
    one. Consumer: the harness scoreboard, which treats a non-zero `reader` as
    a state from which `clean` is unreachable.

    Everything a check tags is counted under its tag; untagged strings (the
    label checks, enforced-is-traced) count as `other`.
    """
    reader = list(built["problems"])
    # LOUD, because the coupling is positional. `_scored_problems` promises this
    # prefix in every tracking state, and both its exits build on it -- but a
    # future reordering would otherwise reattribute reader problems to whichever
    # family sorts first, and a broken pin would quietly start scoring as
    # annotation debt instead of withholding the verdict. RuntimeError matches
    # `emit`'s own convention for a defect the caller cannot sensibly continue past.
    if scored[:len(reader)] != reader:
        raise RuntimeError(
            "scored problems no longer open with the reader prefix -- "
            "`_problems_by_check` partitions by POSITION on that contract. "
            "Either restore the ordering in `_scored_problems` or change this "
            "partition deliberately; do not let it slice silently.")
    counts = {tag: 0 for tag in _CHECK_TAGS}
    counts["reader"] = len(reader)
    counts["other"] = 0
    for problem in scored[len(reader):]:
        tag = problem.split(" ", 1)[0]
        counts[tag if tag in counts else "other"] += 1
    return counts


def build_document(domain_dir, built=None):
    """The emitted document, IN MEMORY. `emit` writes exactly this.

    Separate from `emit` because two callers need it and only one of them
    writes: the drift check (`_check_artifact_drift`) compares the COMMITTED
    file against a fresh one, and it must compare against the same construction
    `--emit` would produce or it would report drift that re-emitting does not
    fix, or miss drift that it does.

    `built` is the ledger the RUN scored. Emitting and checking share
    `ledger.build` so that the artifact a renderer displays is by construction
    the artifact the gate scored -- if the two could diverge, this layer would
    reproduce in miniature the failure it exists to catch.

    SUFFICIENT ON ITS OWN. Spec §8 makes this the only input a renderer reads,
    so it carries what the four-colour report and §6's mitigation need and not
    merely what the gate happened to have in hand: unit ids WITH THEIR TEXT in
    document order, each unit's state, which register entries defer it, and the
    register itself with reason, consequence and label -- that last pairing is
    what puts the provision's own words next to the claim made about them, which
    is the only defence against a deferral that is narrowly and plausibly wrong.
    The exemption table is here for the same reason: `no_statute` is the one
    bare assertion the enforced path allows, and an artifact that omitted it
    would hide exactly what it exists to show.

    STATE IS NOT ENOUGH: EACH UNIT CARRIES ITS ATTRIBUTION. `{id, state, text}`
    colours a unit and cannot say WHY -- which atom covered it, which record's
    verbatim quotes it, which rule carries that cite. Spec §8's report promises
    a chain (statute sentence -> extracted knowledge -> formal rule) and §7's
    attestation plants `misattribute_cite` and `swap_verbatim` mutants, the two
    classes that die only if a reviewer compared the statute's words against the
    claim; neither is possible in a report whose source never states the
    attribution. `ledger.build` computes it in the same pass as coverage, so the
    chain a renderer draws is the coverage the gate scored.

    LABELS CARRY THEIR OWN CROSS-CHECK STATUS, ABSENT WHEN THERE ARE NONE. A
    domain that has adopted labels gets a `labels:` list (`_label_rows`); one
    that has not gets no key at all, the same "absent, not empty" rule
    `_finish_attribution` follows for a unit with nothing to attribute. Each
    row's `cross_checked` answers whether the label's claim PASSED, not
    whether it was eligible for checking -- a distinction two earlier
    versions of this file got wrong in two different ways, because `problems`
    never reaches this file (only `problem_count` does, see below): a bare
    `True` is the only place a renderer reading this file standalone would
    ever see the verdict, so marking a checked, FAILED claim `True` shows a
    label naming a nonexistent or unreached provision as VERIFIED -- this
    whole layer's failure class, reproduced in the artifact meant to guard
    against it. `False` covers two KINDS of case (never counted reason by
    reason, so a new reason cannot leave a stale number here) and each carries a
    `cross_checked_note` saying why: NEVER CHECKED (a labelled FACT, an
    `indirect_cite` rule, and an UNTRACED domain, which has no pinned document
    to resolve anything against), or CHECKED AND FAILED (an unresolvable unit,
    a clause that cites nothing, a misattribution). `_label_check_reasons` is
    the SOLE source both the checks and this emitter read, and it -- not the
    caller's guard -- is also what keeps the two kinds apart when this emitter
    runs in a state the check functions never reach; see `_label_entry`.

    A `True` ROW CARRIES NO NOTE, and under quote-as-key that is no longer a
    gap: resolution IS the quote check now -- `resolve.resolve` only binds a
    unit when the quote occurs, verbatim, in that unit's own pinned text, so
    a `swap_verbatim` mutant (spec §7) cannot reach `cross_checked: true` at
    all; it fails resolution instead (`NO_MATCH`, its own failure note). A
    `True` row DOES carry `resolved_unit`, so a renderer can say which
    provision without re-implementing `resolve.resolve` itself -- see
    `_label_entry`. The one place a swapped quote still survives with nothing
    saying so is a labelled FACT or `indirect_cite` rule, neither of which is
    cross-checked at all; their notes say only that the unit reference went
    unchecked, not that the quote did too -- see `_label_entry`.

    DETERMINISTIC, because this file is COMMITTED. Sorted keys, sorted lists,
    no set iteration order, no timestamp, no path from this machine, no run
    identity -- two machines emitting the same domain must produce the same
    bytes or every commit carries a spurious diff and the artifact stops being
    reviewable.

    WHAT IT DELIBERATELY DOES NOT CARRY: the problem STRINGS. A YAML parse
    failure quotes the stream by its absolute path, so problem text is
    machine-dependent and committing it would break the property above. The
    VERDICT is carried instead -- `problem_count`, the SCORED problems of this
    same ledger, so the file cannot claim a cleanliness the gate did not score
    -- and the problems themselves belong to the run's output, which is where a
    gate reads them.

    `problem_count` counts `_scored_problems`, i.e. every check EXCEPT the drift
    check, and the exclusion is what makes the count well-defined rather than
    self-referential. Drift is a statement ABOUT this file; counting it would
    make the number depend on the file being written and it would be wrong the
    instant it is -- a fresh artifact has no drift by construction, so once the
    file is current the two counts are the same number.
    """
    built = _ledger.build(domain_dir) if built is None else built
    states = unit_states(built)
    deferred_by = _deferred_by(built)
    labels = built["deferral_labels"]

    attribution = built.get("attribution", {})
    units = []
    for unit in built["doc_units"]:
        # THE ARTIFACT IS A RENDERING, so a unit whose own text is
        # discontiguous is written with the visible gap marker between its runs
        # (`units.joined_text`). A reader must SEE that words were withheld
        # there -- the alternative is a report printing, as one sentence of the
        # statute, a sentence the statute does not contain. Nothing reads this
        # string back for a containment check; T5 and the resolver work from
        # `doc_units`' runs.
        row = {"id": unit["id"], "text": _units.joined_text(unit),
               "state": states[unit["id"]]}
        if unit["id"] in deferred_by:
            row["deferred_by"] = deferred_by[unit["id"]]
        # ATTRIBUTION, and only where there is some. A GREEN unit names the
        # atom(s) that covered it, each atom's record verbatim and the rules
        # citing it with file:line; a deferred one names the register entry
        # with its label; a CONTRADICTED one carries both, which is what makes
        # the contradiction legible rather than merely counted. A RED unit gets
        # NO key at all -- an empty block beside it would read as a chain that
        # was looked for and found bare, i.e. as checked.
        if unit["id"] in attribution:
            row["attribution"] = attribution[unit["id"]]
        units.append(row)

    # ONE list, read twice: `problem_count` is its length and `problems_by_check`
    # is its partition, so the artifact cannot carry two disagreeing verdicts
    # about itself. Bound here rather than inline in the literal because the
    # partition needs the same list the count measures, not a second call.
    scored = _scored_problems(domain_dir, built)
    document = {
        "domain_id": built["domain_id"],
        # The three states, said as data so a renderer does not have to infer
        # "not traced" from an empty unit list.
        "traced": is_traced(built),
        "enforced": is_enforced(domain_dir, built),
        "headline": headline(built),
        # Document order, never sorted: a report reads down the statute, and
        # sorting interleaves Article 10 with Article 1.
        "units": units,
        # The gate's own three lists, carried verbatim so a renderer that wants
        # the partition without walking `units` reads the SCORED one.
        "covered": built["covered"],
        "deferred": built["deferred"],
        "unaccounted": built["unaccounted"],
        # Authored order -- it is the order a reviewer reads the register in.
        "deferrals": [
            {"what": entry.get("what"),
             "units": entry.get("units"),
             "reason": entry.get("reason"),
             "consequence": entry.get("consequence"),
             # `_label_of`, not `labels.get(...)`: an unhashable `what` is a
             # register entry the ledger keeps on purpose, and it may not raise
             # out of the emitter.
             "label": _label_of(labels, entry.get("what"))}
            for entry in built["deferrals"]],
        # The second relation, in authored order like the first. NO `units`
        # key and no verbatim text: this domain did not pin these provisions,
        # so an artifact that quoted them would be quoting text it never read.
        "exclusions": [
            {"what": entry.get("what"),
             "cites": entry.get("cites"),
             "reason": entry.get("reason"),
             "consequence": entry.get("consequence"),
             "label": _label_of(built["exclusion_labels"], entry.get("what"))}
            for entry in built["exclusions"]],
        "no_statute": _ledger.serialise_no_statute(built["no_statute"]),
        "order": {"has_order": built["has_order"],
                  "deferred_set": built["order_deferrals"],
                  "excluded_set": built["order_exclusions"],
                  "operative_readings": built["order_readings"]},
        # The two advisory sources, in one list: the deferral smell (spec §6
        # item 3) and the conservative-departure note (§13.23). Both are
        # "worth a reviewer's attention", neither ever touches an exit code.
        "advisories": built["deferral_smells"] + _reading_advisories(built),
        # Not problems, not advisories: the outstanding human obligations. Kept
        # as their own key so a reader cannot mistake "nobody has checked this
        # interpretation" for either a defect or a note.
        "review_obligations": review_obligations(built),
        # The interpretive register, with its review state made explicit rather
        # than left to be inferred from an absent key: `reviewed` is the whole
        # point of the relation, so an artifact that merely omitted `attested`
        # would put the unsafe case and the not-yet-authored case in one shape.
        "operative_readings": [
            {"what": entry.get("what"),
             "units": entry.get("units"),
             "question": entry.get("question"),
             "readings": entry.get("readings"),
             "chosen": entry.get("chosen"),
             "rationale": entry.get("rationale"),
             "authority": entry.get("authority"),
             "attested": entry.get("attested"),
             "reviewed": _attested(entry),
             # The obligation, per entry, in the artifact -- a portal showing
             # this file must be able to say "awaiting review" without
             # re-deriving what that means from `attested`'s shape.
             "awaiting_review": not _attested(entry),
             "label": _label_of(built["reading_labels"], entry.get("what"))}
            for entry in built["operative_readings"]],
        "problem_count": len(scored),
        "problems_by_check": _problems_by_check(scored, built),
    }
    # ABSENT, NOT EMPTY -- the same reasoning as `_finish_attribution`. A
    # domain with no labels must carry no `labels:` key at all, or an empty
    # list reads as "looked for and found none", indistinguishable from a
    # domain that has not adopted labels yet.
    label_rows = _label_rows(built["labels"], _label_check_reasons(built))
    if label_rows is not None:
        document["labels"] = label_rows
    # SAME RULE, one layer up: a domain pinning nothing carries no `sources:`
    # key at all -- see `_source_rows`. Carried so a reviewer can answer the
    # PIN's own questions (is this the right document, the right consolidated
    # version, cut where the document itself draws the boundary) from
    # `provisions.yaml` alone; see
    # docs/superpowers/plans/2026-08-19-pin-provenance.md.
    source_rows = _source_rows(built.get("sources", []))
    if source_rows is not None:
        document["sources"] = source_rows
    return document


def emit(domain_dir, out_path, built=None):
    """Write `build_document`'s document to OUT_PATH and return it."""
    if yaml is None:                                    # pragma: no cover
        raise RuntimeError(
            "--emit needs PyYAML to write provisions.yaml, and it is not "
            "installed. This is loud on purpose: a silently skipped emit "
            "leaves a stale committed artifact that disagrees with the gate.")
    document = build_document(domain_dir, built)
    with open(out_path, "w", encoding="utf-8") as handle:
        handle.write(
            "# GENERATED by `check_provisions.py --emit`. Do not edit.\n"
            "# Emitting and checking share ledger.build, so this IS the ledger\n"
            "# the gate scored — editing it makes the report lie, not the gate.\n")
        yaml.safe_dump(document, handle, sort_keys=True,
                       default_flow_style=False, allow_unicode=True)
    return document


# ── §4: the committed artifact may not drift from the ledger ─────────────────

def _drifted_keys(committed, fresh):
    """The top-level keys on which the two documents disagree.

    Named rather than diffed in full: a unit's text can be a paragraph, and a
    gate log that printed the whole document twice would bury the one line that
    moved. The KEYS are enough to send an author to the right place, and the
    remedy is a re-emit and a read of the diff either way.

    SORTED BY `repr`, NOT BY THE KEYS THEMSELVES. `fresh` is generated and its
    keys are all strings, but `committed` is a file on disk that anything may
    have put anything into -- and YAML happily gives `1: x` an int key, so a
    plain `sorted()` raises `TypeError: '<' not supported between instances of
    'str' and 'int'`. That would be an uncaught exception out of `check_domain`,
    whose contract is that it never raises on domain content: in the hook it
    turns a would-be problem into a traceback and a non-zero exit for an
    UNDECLARED domain, i.e. a ratchet bypass in the fail-closed direction --
    the same class this file exists to remove, arriving from the other side.
    `repr` totally orders anything hashable enough to be a YAML key, and the
    order only has to be stable and readable, never semantic.
    """
    missing = object()
    return [key for key in sorted(set(committed) | set(fresh), key=repr)
            if committed.get(key, missing) != fresh.get(key, missing)]


def _check_artifact_drift(domain_dir, built):
    """A committed `provisions.yaml` still says what the ledger says.

    THE GUARANTEE `--emit` GIVES IS EMIT-TIME ONLY. Emitting and checking share
    `ledger.build`, so the file is the scored ledger AT THE MOMENT IT IS
    WRITTEN -- and never again. Spec §4 commits it so coverage changes are
    reviewable in the diff and §8 makes it the ONLY input a renderer reads, so
    one later clause edit is enough: the gate rescores from the live ledger, the
    committed artifact does not move, and the renderer shows a coverage claim
    nobody scored. That is this layer's own failure mode -- an artifact
    asserting something about code that the code does not say -- reproduced in
    the artifact the layer emits.

    IT DOES NOT REGENERATE THE FILE. A gate that silently re-emitted would erase
    the diff §4 commits the file for, and would make a coverage change land
    unreviewed as a side effect of running a check. The operator re-emits and
    reads what moved.

    RUNS IN EVERY STATE, including untraced: a file left behind by a domain
    whose `sources/` has since gone is exactly the artifact that would lie
    loudest, and it is only reachable here because the check does not sit behind
    the traced early return. It is INERT until someone emits -- no domain in the
    corpus carries this file today, and `os.path.exists` is the whole guard.
    """
    path = os.path.join(domain_dir, ARTIFACT_NAME)
    if not os.path.exists(path):
        return []
    remedy = (f"Re-emit it (`check_provisions.py <domain> --emit "
              f"<domain>/{ARTIFACT_NAME}`) and review the diff — this gate "
              f"deliberately does not regenerate it for you, because that diff "
              f"is what spec §4 commits the file for.")
    if yaml is None:                                    # pragma: no cover
        return [f"§4 {ARTIFACT_NAME}: present but PyYAML is not installed, so "
                f"it cannot be compared with the ledger this run scored. An "
                f"unchecked committed artifact is a report that may already "
                f"disagree with the gate."]
    try:
        with open(path, encoding="utf-8") as handle:
            committed = yaml.safe_load(handle)
    except (yaml.YAMLError, OSError, UnicodeDecodeError) as exc:
        return [f"§4 {ARTIFACT_NAME}: cannot be read as YAML — {exc}. It is a "
                f"GENERATED artifact, so it cannot be checked against the "
                f"ledger and cannot be rendered. {remedy}"]
    fresh = build_document(domain_dir, built)
    if committed == fresh:
        return []
    if not isinstance(committed, dict):
        what = (f"it is not a YAML mapping at all (got "
                f"{type(committed).__name__})")
    else:
        # `str` per key for the same reason `_drifted_keys` sorts by `repr`: a
        # committed file may carry a non-string key, and `join` would raise on
        # it -- out of a function whose callers are promised no exception.
        what = "it differs in: " + ", ".join(
            str(key) for key in _drifted_keys(committed, fresh))
    return [f"§4 {ARTIFACT_NAME}: STALE — the committed artifact is not the "
            f"ledger this run scored ({what}). Spec §8 makes this file a "
            f"renderer's only input, so a stale copy shows a coverage claim the "
            f"gate never scored. {remedy}"]


# ── labels: per-domain identity uniqueness ───────────────────────────────────

def _check_labels_unique(built):
    """One label, one clause, WITHIN a domain.

    The namespace is per-domain by decision (spec §13.6): scope follows the
    layer, which is per-domain everywhere else. So this check is the whole
    guarantee, and it is why the label stays 8 digits rather than growing --
    at domain scale the largest corpus domain is 137 clauses, where random
    collision is 2e-6, and the DOMINANT collision source is not randomness at
    all but COPY-PASTE: duplicate a clause to write a similar one and the label
    rides along, at probability 1. No number of hex digits helps with that; a
    uniqueness check does.

    SPLIT AND MERGE are the one operation that moves a clause across the
    namespace boundary, and this check is what catches the collision when it
    does.
    """
    seen, problems = {}, []
    for labelled in built["labels"]:
        site = f"{labelled.file}:{labelled.line}"
        first = seen.get(labelled.label.id)
        if first is None:
            seen[labelled.label.id] = site
            continue
        problems.append(
            f"label @{labelled.label.id} is used twice in this domain — "
            f"{first} and {site}. A label is one clause's identity; give the "
            f"second a fresh one (`_tools/gen_label.py <domain>`). Copying a "
            f"clause copies its label, which is the usual cause.")
    return problems


# ── the contract ─────────────────────────────────────────────────────────────

def check_domain(domain_dir, built=None):
    """Problem strings for one domain. Never raises on domain content.

    `built` lets a caller that already has the ledger -- `main`, which needs it
    to tell traced from untraced -- avoid building it twice. Every reader walks
    and reifies the domain, so a second build is a second parse of every file,
    and two builds could in principle disagree. The one-argument form is the
    contract `check_corpus_tool` and the hook call.

    The drift check is separated out so that `build_document`'s `problem_count`
    can be the SCORED problems without asking whether the file it is about is
    stale -- see `build_document`. Every other caller wants both, so this is
    the whole list.
    """
    built = _ledger.build(domain_dir) if built is None else built
    return (_scored_problems(domain_dir, built)
            + _check_artifact_drift(domain_dir, built))


def _scored_problems(domain_dir, built):
    """Everything `check_domain` reports EXCEPT the committed artifact's drift.

    The split exists for `build_document` alone, and the boundary is stated
    there: drift is a claim about the emitted file, so counting it inside that
    file would be self-referential.
    """
    # Reader problems FIRST and in every state: an unreadable file, a pin
    # mismatch or a malformed record is a defect whatever the domain's
    # provision tracking status, and the ratchet governs problems and nothing else.
    problems = list(built["problems"])
    # Labels need no pinned document, so they are checked in BOTH states. This
    # cannot disturb an untraced domain, because labels are opt-in: a domain
    # with none produces nothing here. Malformed labels are already in
    # `built["problems"]` from the reader.
    problems += _check_labels_unique(built)
    if not is_traced(built):
        # The one check that belongs to the UNTRACED path: being untraced is
        # itself the defect when the domain declared enforcement.
        return problems + _check_enforced_is_traced(domain_dir, built)
    problems += _check_t1_clauses(built)
    problems += _check_t1_parameters(built)
    problems += _check_t2(built)
    # T3 before T5: T5 stays silent about a record whose units do not resolve,
    # because that is T3's defect and reporting it twice would send the author
    # to edit a quote against a provision that does not exist.
    problems += _check_t3(built, domain_dir)
    # H1: the bar an unsigned reading DOES block. Reads the manifest directly --
    # `commissioned:` is the commissioning record's own block and no part of
    # the ledger's own state, so putting it in `built` would imply this layer
    # owns it.
    problems += _check_commissioned_readings(built)
    # The label checks' position here is READING ORDER, not a dependency, and
    # the difference is worth stating because this comment used to claim the
    # latter -- that they sit after T3 "for T3's own reason: a label whose unit
    # does not resolve is reported once". They do report it once, but no
    # ordering achieves that: `_label_check_reasons` assigns exactly ONE reason
    # per label site, so `_check_label_units` and `_check_label_subset` select
    # disjoint sets of labels and cannot double-report whichever order they run
    # in. The single-reason invariant lives THERE; move these two lines and
    # only the sequence of an author's console output changes.
    problems += _check_label_units(built)
    problems += _check_label_subset(built)
    problems += _check_t5(built)
    # §6 sits INSIDE the traced path, behind the early return, and the placement
    # is a ruling rather than a convenience. The check itself needs no document
    # -- it compares the order's `deferred_set` to the manifest register, two
    # YAML files -- so running it on an untraced domain would be perfectly
    # meaningful, and it would fire on 15 of the 16 order-backed domains today,
    # every one of which registers nothing. That is the ratchet's boundary, not
    # the check's: a domain with no pinned statute has not entered the campaign,
    # its register is not yet expected to exist, and reddening 15 unenforced
    # domains the day this lands is exactly the disturbance the three states
    # exist to prevent. The consequence is stated rather than hidden: until a
    # domain pins a statute this check does not run, so it is LATENT on today's
    # corpus (including eu/vat/pro_rata_deduction, which has an order, a
    # register and no sources/) and becomes live domain by domain as wave 1
    # pins documents. It is the deferral register's own discipline; the order
    # itself is separately owned by the corpus gate.
    problems += _check_order_honoured(built)
    return problems


USAGE = "usage: check_provisions.py <domain_dir> [--emit <path>]"


def _parse(argv):
    """`(domain_dir, out_path)`, or `(None, None)` for a malformed command line.

    A misuse fails LOUD -- `--emit` with no path silently checking and writing
    nothing is how a stale artifact outlives the ledger it claims to be.
    """
    argv = list(argv)
    out_path = None
    if "--emit" in argv:
        index = argv.index("--emit")
        if index + 1 >= len(argv):
            return None, None
        out_path = argv[index + 1]
        del argv[index:index + 2]
    if len(argv) != 1:
        return None, None
    return argv[0], out_path


def main(argv=None):
    argv = sys.argv[1:] if argv is None else argv
    domain_dir, out_path = _parse(argv)
    if domain_dir is None:
        print(USAGE, file=sys.stderr)
        return 2

    built = _ledger.build(domain_dir)
    problems = check_domain(domain_dir, built)
    # The headline FIRST and always, traced or not, clean or not. It is the one
    # line a reader of a 60-domain sweep actually reads, and a domain greened by
    # deferring most of its statute has to be visible there or nowhere.
    print(headline(built))
    if _ledger.order_is_public_ledger(domain_dir):
        print("ADVISORY: no commissioning order here (the orders are private), so the "
              "authorized/expansion labels are read from the committed ledger's order block")
    for advisory in built["deferral_smells"] + _reading_advisories(built):
        # Advisory, never a problem: it is below the exit-code decision on
        # purpose, and it prints in every state including `enforced`.
        print("ADVISORY:", advisory)
    rate = deferral_rate(built)
    if rate is not None:
        # Same standing as the advisories above: printed, never scored.
        print("ADVISORY:", rate)
    # ABOVE the problems and in its own voice, because it is neither a defect
    # nor a nicety: it is the outstanding half of a bargain. The operator's
    # ruling lets engineering proceed on a recorded, defensible reading; what
    # the ruling is worth depends entirely on this line existing.
    for obligation in review_obligations(built):
        print("AWAITING REVIEW:", obligation)
    for problem in problems:
        print("PROBLEM:", problem)
    if out_path:
        # Emitted from the ledger THIS run scored, and emitted whether or not
        # the domain is clean: an artifact that appeared only on green runs
        # would show a renderer nothing but successes.
        emit(domain_dir, out_path, built)

    if not problems:
        # NO BARE `OK` ON THE UNTRACED PATH. The headline already said "not
        # traced", and `OK` after it reads as "audited and clean" -- the two
        # states this file exists to keep apart, printed one line apart. The
        # exit code is 0 either way; what changes is that nothing in the output
        # claims a verdict the run did not reach.
        if is_traced(built):
            print("OK")
        return 0
    print(f"{len(problems)} problem(s)")
    blocking = blocking_problems(problems, built)
    debt = len(problems) - len(blocking)
    if debt:
        # Never silently: a reader who sees PROBLEM lines and a zero exit has
        # to be told which of the two is the mistake.
        print(f"  of which {debt} annotation debt (T1) — reported, never "
              f"blocking; {len(blocking)} coverage problem(s) decide the "
              f"exit code")
    declared = built["provision_tracking"]
    if not is_enforced(domain_dir, built):
        if enforcement_unknown(built):
            # Unknown is not "not enforced" -- see `enforcement_unknown`.
            print(UNKNOWN_ENFORCEMENT_NOTE)
            return 1
        if declared == EXEMPT:
            # An exemption is a DECLARED state, not a typo for `enforced`, so it
            # must not fall into the wrong-word note below.
            reason = exemption(built)
            print(EXEMPT_NOTE.format(reason=reason) if reason
                  else INCOMPLETE_EXEMPTION_NOTE)
            return 0
        if declared is not None:
            # Opted in with the wrong word. Said out loud, because the author
            # believes this domain blocks and it does not.
            print(f"note: provision_tracking: {declared!r} is not {ENFORCED!r}, so "
                  f"nothing here blocks.")
        print(NOT_ENFORCED_NOTE)
        return 0
    if not blocking:
        # Enforced, and every problem left is debt. Said out loud, because
        # "enforced" plus PROBLEM lines plus exit 0 is exactly the combination
        # a reader would otherwise take for a broken gate.
        print("enforced: no coverage problem blocks; the annotation debt above "
              "is reported and does not.")
        return 0
    return 1


if __name__ == "__main__":
    sys.exit(main())
