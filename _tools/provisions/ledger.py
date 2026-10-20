#!/usr/bin/env python3
"""ledger.py -- compose the readers into the generated provision tracking ledger.

COVERAGE IS COMPUTED HERE AND ASSERTED NOWHERE. A unit is covered because some
cite atom appearing in an OPERATIVE rule or fact resolves to a citation record
naming it, or because a parameter record names it. That composition is what
makes the rule->sentence direction true by construction. A separate authored
`coverage.yaml` would merely be a document making claims about code -- which is
the failure class (a doc describing a clamp the implementation does not have)
this whole layer exists to catch.

The ledger is the ONLY thing the checker scores and the renderers display, so
what it omits cannot be checked or shown. Two omissions the whole-branch review
found, both now contractual:

  * `doc_units` carries each unit's TEXT, not just its id. Without it the
    four-colour report and spec 6's mitigation -- placing a unit's verbatim
    text next to the deferral reason so a reviewer compares text to claim --
    cannot be built from the emitted file, and T5 would have to re-read the
    pinned document behind the checker's back. It carries that text as RUNS
    (`units.as_doc_unit`), never as one string: a unit's own text can be
    discontiguous, and joining the pieces invents an adjacency the statute
    does not have -- see `units.py`'s module docstring.
  * `no_statute` is carried. Without it T1 cannot honour an exemption and the
    headline cannot count one, so the one bare assertion in the enforced path
    would be invisible in the artifact that is supposed to make it visible.
  * `manifest_unreadable` is carried alongside `provision_tracking`. The field alone
    cannot say whether an absent value means "did not opt in" or "could not be
    read", and the ratchet must not read the second as the first.

THE ERROR CHANNEL. Every reader returns `(value, problems)` and so does every
read this module does itself (manifest, orders). Their problems are AGGREGATED
into `problems`; dropping any one restores the ratchet bypass, because
`check_provisions` ratchets over problems and nothing else. An exception
escaping instead would be a traceback and a non-zero exit for a domain that
never opted in -- which breaks the promise that an unenforced domain cannot be
disturbed by this layer landing mid-campaign.

WHAT THIS MODULE DOES NOT DECIDE. It reports memberships faithfully and
resolves no contradiction:

  * a unit both covered and deferred appears in BOTH lists; T2 fails it --
    UNLESS the two claim different RUNS of a discontiguous unit (spec 13.20),
    in which case `"contradicted"` (a run-level intersection, not the
    unit-level `covered`/`deferred` membership) correctly leaves it out. A
    ledger that silently picked a winner between two OVERLAPPING claims would
    hide the contradiction it exists to surface; one that flagged two
    NON-overlapping claims would invent a contradiction the law does not have.
  * a `units:` id that resolves to no element in the store -- including a
    `/n` run selector whose `n` is out of range -- is left out of the
    partition (the partition is over the DOCUMENT) and reported by T3.
  * duplicate atoms across records are `check_citations`' business (see
    `_by_atom`).
"""
import re
import os

try:
    import yaml
except ImportError:                                     # pragma: no cover
    yaml = None

from _tools.provisions import clauses as _clauses
from _tools.provisions import labels as _labels
from _tools.provisions import registry as _registry
from _tools.provisions import units as _units

#: A deferral reason repeated across at least this many entries reads as
#: boilerplate. Advisory only (spec 6 item 3): the gate cannot judge whether a
#: deferral is sound, only make an unsound PATTERN conspicuous.
BOILERPLATE_THRESHOLD = 3


# ── the emitted form of the no_statute map ───────────────────────────────────

def no_statute_key(functor, arity):
    """The emitted key for a `no_statute/3` declaration.

    `(functor, arity)` tuples do not YAML-serialise, and `provisions.yaml` is
    a committed artifact, so the representation is decided HERE rather than at
    emit time -- one spelling, or the checker and the renderer would each pick
    their own. The chosen form is the predicate indicator the corpus already
    writes as a YAML key: `_orders/*.yaml` spells `verdict_vocabulary` entries
    `"ubo_status/4"`. It stays a plain string in YAML (the `Div(Atom, int)`
    reification trap that ruled `pred/2` out in CLAUSAL source does not apply
    to a YAML string), and it round-trips through `parse_no_statute_key`.
    """
    return f"{functor}/{arity}"


def parse_no_statute_key(key):
    """`(functor, arity)` back out of an emitted key. A functor never contains
    `/` -- `bare_name` has already reduced it to a single dotted segment."""
    functor, _, arity = key.rpartition("/")
    return functor, int(arity)


def serialise_no_statute(declarations):
    """The `no_statute` map in emitted form, key-sorted for a stable diff."""
    return {no_statute_key(*key): declarations[key]
            for key in sorted(declarations)}


# ── manifest and order reading (problems, never exceptions) ──────────────────

def _load_yaml(path, label, problems):
    """A YAML mapping, or `None` with a problem recorded. Absent is not an
    error; unreadable is."""
    if not os.path.exists(path):
        return None
    if yaml is None:                                    # pragma: no cover
        problems.append(f"{label}: present but PyYAML is not installed")
        return None
    try:
        with open(path, encoding="utf-8") as handle:
            loaded = yaml.safe_load(handle)
    except (yaml.YAMLError, OSError, UnicodeDecodeError) as exc:
        problems.append(f"{label}: cannot be read as YAML — {exc}")
        return None
    if loaded is None:
        return {}
    if not isinstance(loaded, dict):
        problems.append(
            f"{label}: expected a YAML mapping, got {type(loaded).__name__}")
        return None
    return loaded


#: The manifest's two scope relations, and the field each addresses provisions
#: with. THE SPLIT IS THE POINT (spec 13.21): a deferral is "in my scope, not
#: done yet" and resolves against my own EXTRACT, so it belongs in the RED
#: backlog and should nag; an exclusion is "not my scope, by design" and
#: addresses the INSTRUMENT, so it never enters the backlog at all. One
#: relation could not hold both -- once a domain pins, T3's "an entry that
#: names nothing accounts for nothing" and the extract-scoped resolver between
#: them made a deferral of a NEIGHBOURING article unwritable, and four
#: independent authors moved their scope boundaries into prose that nothing
#: checks rather than write a `units:` claim they knew to be false.
#:
#: `cites:` is deliberately NOT `units:`. A copy-pasted deferral then fails
#: loudly instead of resolving into the wrong relation; it is honest about
#: strength (`units:` addresses units this ledger owns and can quote verbatim,
#: `cites:` addresses provisions this domain never read); and it leaves
#: `units:` meaning exactly one thing, which spec 13.20 just finished pinning
#: down.
DEFERRED, EXCLUDED = "deferred_set", "excluded_set"
_ADDRESSES = {DEFERRED: "units", EXCLUDED: "cites"}

#: THERE IS A THIRD REGISTER AND IT IS DELIBERATELY NOT IN THE TABLE ABOVE.
#: `operative_readings` (spec 13.23) records a contested INTERPRETATION of a
#: provision this domain formalizes. The two entries above both say "this
#: domain does not do X", which is why they generalise over one field and both
#: interact with coverage; an operative reading says the opposite -- "this
#: domain DOES do X, and here is the contested way it does it" -- and its
#: `units:` are normally ALSO covered by a rule. A unit that is formalized and
#: carries a reading is the NORMAL case, not spec 13.18 item 1's `both covered
#: and deferred` contradiction, so a check reusing the scope machinery would
#: flag every correct entry. It has its own check (T7) and shares only this
#: module's order read and the register parser.
READINGS = "operative_readings"


def _readings(manifest, problems):
    """The manifest's operative-readings register, entry by entry.

    Shape-checked exactly as far as `_register` checks the other two -- an
    entry that is not a mapping, or carries no `what`, is reported and the
    rest is left to T7. Everything interpretive about it (are there two
    readings, does `chosen` name one, is there an authority) belongs to the
    checker, not here: this module reads, it does not judge.
    """
    return _register(manifest, READINGS, problems)


def _register(manifest, key, problems):
    """The manifest's KEY register (`deferred_set` or `excluded_set`), entry by
    entry.

    An entry that is not a mapping, or that carries no `what`, is REPORTED and
    dropped from the register: `what` is the join key to the order, so without
    it spec 6's order-honoured check silently does not apply to that entry --
    exactly the kind of quiet inapplicability this layer exists to remove.
    Its units are still read, because a unit somebody meant to defer must not
    read as unaccounted-because-malformed... which would be reported as the
    wrong defect.
    """
    out = []
    for index, entry in enumerate(manifest.get(key) or []):
        where = f"manifest.yaml {key}[{index}]"
        if not isinstance(entry, dict):
            problems.append(
                f"{where}: expected a mapping, got {type(entry).__name__}")
            continue
        what = entry.get("what")
        if not isinstance(what, str) or not what.strip():
            problems.append(
                f"{where}: no `what` — it is the key an order's {key} is "
                f"matched on, so this entry cannot be labelled authorized or "
                f"expansion.")
        out.append(entry)
    return out


def _listed_ids(entries, key, problems):
    """STRUCTURAL validation of every entry's provision list, in the author's
    words. KEY selects both the register and the field it addresses with
    (`_ADDRESSES`), so the two relations cannot drift into validating their
    lists differently."""
    field = _ADDRESSES[key]
    out = set()
    for index, entry in enumerate(entries):
        where = f"manifest.yaml {key}[{index}]"
        listed = entry.get(field)
        if listed is None:
            continue
        if not isinstance(listed, list) or not all(
                isinstance(u, str) for u in listed):
            problems.append(
                f"{where}: {field} must be a list of unit ids, got {listed!r}")
            continue
        out |= set(listed)
    return out


def _normalise_domain_id(domain_id):
    """Orders name their domain with hyphens (`eu/vat/pro-rata-deduction`),
    manifests with underscores (`eu/vat/pro_rata_deduction`). Same domain."""
    return (domain_id or "").strip().replace("_", "-")


def _find_orders_dir(domain_dir):
    """Walk UP to the corpus root -- the directory holding `_orders/`.

    NOT the domain's parent: real domains nest (`eu/vat/pro_rata_deduction`),
    so the parent is `eu/vat` and `_orders/` is three levels up.
    """
    current = os.path.abspath(domain_dir)
    while True:
        candidate = os.path.join(current, "_orders")
        if os.path.isdir(candidate):
            return candidate
        parent = os.path.dirname(current)
        if parent == current:
            return None
        current = parent


def _order_scope(domain_id, domain_dir, problems):
    """`({deferred}, {excluded}, {readings}, has_order)` -- the operator-authored
    contract, ALL THREE relations from ONE read of the order.

    One read, not two calls, for a reason beyond tidiness: `_load_yaml` reports
    an unreadable order as a problem, so reading the file twice would report a
    broken order twice and send the author looking for two faults.

    An order is matched on its own `domain:` FIELD, never on its filename:
    `_orders/vat-pro-rata-deduction.yaml` carries
    `domain: eu/vat/pro-rata-deduction` against manifest
    `id: eu/vat/pro_rata_deduction`, and no rule derives one from the other.

    `(set(), True)` -- an order that defers nothing -- is a DIFFERENT state
    from `(set(), False)` -- no order at all. Labelling depends on telling them
    apart: with no order every deferral is an expansion, and the blocking
    order-honoured check has nothing to run against.
    """
    def _whats(order, key):
        return {entry.get("what") for entry in (order.get(key) or [])
                if isinstance(entry, dict) and isinstance(entry.get("what"), str)
                and entry.get("what").strip()}

    wanted = _normalise_domain_id(domain_id)
    orders_dir = _find_orders_dir(domain_dir)
    if wanted and not orders_dir:
        # A PUBLIC clone: the commissioning orders are private, so `_orders/` is
        # absent everywhere above the domain. The committed ledger carries the
        # order's scope in its own `order:` block (the part of the order that
        # labelling reads, and nothing else), so the labels are recomputed from it
        # rather than every deferral silently becoming an expansion and every
        # ledger reading as stale (ruled 2026-10-20). With `_orders/` present,
        # the order itself is always the source, as before.
        return _order_scope_from_ledger(domain_dir, problems)
    if not wanted or not orders_dir:
        return set(), set(), set(), False
    for name in sorted(os.listdir(orders_dir)):
        if not name.endswith((".yaml", ".yml")):
            continue
        label = os.path.join("_orders", name)
        order = _load_yaml(os.path.join(orders_dir, name), label, problems)
        if order is None:
            continue
        if _normalise_domain_id(order.get("domain")) != wanted:
            continue
        return (_whats(order, DEFERRED), _whats(order, EXCLUDED),
                _whats(order, READINGS), True)
    return set(), set(), set(), False



def order_is_public_ledger(domain_dir):
    """True when no `_orders/` directory exists above DOMAIN_DIR, so labels are read
    from the committed ledger's `order:` block (see `_order_scope`)."""
    return _find_orders_dir(domain_dir) is None


def _order_scope_from_ledger(domain_dir, problems):
    """`_order_scope`'s result read from the committed provisions.yaml `order:` block."""
    path = os.path.join(domain_dir, "provisions.yaml")
    if not os.path.isfile(path):
        return set(), set(), set(), False
    # Read QUIETLY: an unreadable or malformed artifact is reported once, by the
    # artifact check itself; here it simply yields no order.
    ledger = _load_yaml(path, "provisions.yaml", [])
    order = (ledger.get("order") if isinstance(ledger, dict) else None) or {}
    if not isinstance(order, dict) or not order.get("has_order"):
        return set(), set(), set(), False

    def _names(key):
        return {w for w in (order.get(key) or []) if isinstance(w, str) and w.strip()}

    return _names(DEFERRED), _names(EXCLUDED), _names(READINGS), True

# ── composition ──────────────────────────────────────────────────────────────

def _by_atom(records):
    """Citation records keyed by atom, FIRST occurrence winning.

    ONLY `kind == "citation"`. The predecessor merged citation atoms and
    parameter string keys into one namespace, so `cite(rate_percent)` could
    resolve against a `parameter_source("rate_percent", ...)` record -- and,
    since the parameter records were read second, that record SHADOWED the
    citation record of the same name and its units silently left coverage. A
    parameter is provenanced by its own record, not by being cited, so
    parameter units are contributed directly and never joined to.

    A DUPLICATE atom keeps the first record and merges nothing. Detecting
    duplicates is `check_citations`' job -- doing it here too would double-
    report a defect the corpus gate already names better. First-wins is the
    direction that fails safe: merging both records' units would let a unit read
    covered on the strength of whichever record is not the one a reader would
    resolve, i.e. manufacture coverage, whereas dropping one leaves its units
    unaccounted and therefore REPORTED.
    """
    out = {}
    for record in records:
        if record.kind == "citation" and record.atom not in out:
            out[record.atom] = record
    return out


# ── per-unit attribution (spec §8) ───────────────────────────────────────────
#
# STATE COLOURS A UNIT; ATTRIBUTION SAYS WHY. As first emitted a unit was
# `{id, state, text}`, which is enough to paint it and not enough to state the
# chain spec §8 promises -- statute sentence -> extracted knowledge -> formal
# rule. Two things break on that, and both are the same defect: §8's report
# cannot draw a chain it cannot read, and §7's attestation cannot plant a
# `misattribute_cite` or `swap_verbatim` mutant in a report whose source never
# states the attribution -- the two mutant classes that die only if a reviewer
# compared the statute's words against the claim.
#
# IT IS COMPUTED IN THE SAME PASS AS COVERAGE, deliberately. A second pass could
# attribute a unit to an atom that did not cover it, or miss the atom that did,
# and the artifact would then disagree with the gate that scored it -- this
# layer's own failure mode, reproduced inside the file it emits. Coverage and
# attribution come off one loop, so a GREEN unit HAS a covering entry by
# construction and every covering entry contributed the coverage it names.

#: How a covering atom reached the unit. Three values, and the third is not a
#: refinement of the first two: a parameter is provenanced by ITS OWN RECORD and
#: never by a rule citing it, so attributing one to a rule would state a chain
#: the domain does not have (`_by_atom` records why the two namespaces are
#: separate). `FACT_BORNE` is the atom carried in a fact row rather than named by
#: a rule -- 11 corpus domains cite that way.
RULE_BORNE, FACT_BORNE, PARAMETER_BORNE = "rule", "fact", "parameter"

#: `covered_by` on a fact-borne entry no rule and no run-time resolver can be
#: named for -- see `_covering`. A constant so the contract test and any reader
#: match ONE spelling.
FACT_TABLE_NO_CLAUSE = "fact-table, no clause nameable"


def _site(clause):
    """`file:line` for a clause, the spelling T1's own messages use."""
    return f"{clause.file}:{clause.line}"


def _sites(clauses):
    """`file:line` per clause, ordered by (file, line).

    Sorted on the TUPLE, never on the formatted string: `"k.clausal:10"` sorts
    before `"k.clausal:9"` as text. The scan order already is this order, so the
    sort states the invariant rather than changing it -- and it is what stops a
    set or a dict-values iteration from reaching a committed artifact.
    """
    return [_site(clause)
            for clause in sorted(clauses, key=lambda c: (c.file, c.line))]


def _rules_by_atom(rules):
    """`{atom: [clause, ...]}` -- which operative RULES name each cite atom."""
    out = {}
    for clause in rules:
        for atom in clause.cites:
            out.setdefault(atom, []).append(clause)
    return out


def _covering(atom, via, verbatim, sites, indirect_sites):
    """One covering entry, A FRESH DICT EVERY CALL.

    The freshness is not style. `yaml.safe_dump` emits an anchor/alias pair for
    any object it meets twice, so one shared entry dict reused across the units
    a record covers would put `&id001`/`*id001` into a committed artifact that
    spec §8 promises a renderer can read on its own.

    `indirect_rules` APPEARS ONLY WHERE IT IS LOAD-BEARING -- an atom no rule
    names. `findall(cite(C), norm(...), CITES)` binds its cite at run time, so
    such an atom's chain ends in a fact table and no rule can be named for it:
    `clauses.scan_file_cites` is deliberately a superset with no attribution
    (which fact carried the atom is not recorded, and this module may not change
    that reader). What CAN be named is the set of rules that resolve a cite at
    run time, and they are named as the SUPERSET they are -- the alternative,
    an empty `rules` and nothing else, reads as covered-by-nothing for law that
    is thoroughly cited, which is the exact inversion `_check_t1_clauses` refuses
    to teach.

    `covered_by` IS THE ADMISSION FOR THE ONE CASE LEFT: a fact-borne atom in a
    domain with NO rule that resolves a cite at run time. There is then neither
    a rule nor a resolver to name, and the entry says so in words rather than
    shipping `rules: []` alone, which is the covered-by-nothing reading the
    paragraph above refuses. It is NOT an empty `indirect_rules: []` -- that
    would state "these rules resolve it at run time" about an empty set, a
    different false claim. A parameter entry needs neither: `via: parameter`
    already says its provenance is its own record (see `PARAMETER_BORNE`).
    """
    entry = {"atom": atom, "via": via, "verbatim": verbatim,
             "rules": list(sites)}
    if not sites and indirect_sites:
        entry["indirect_rules"] = list(indirect_sites)
    elif not sites and via == FACT_BORNE:
        entry["covered_by"] = FACT_TABLE_NO_CLAUSE
    return entry


def _deferring(entry, labels):
    """One deferring entry: the register's own claim, per unit.

    `what`, `reason` and `consequence` are carried RAW, exactly as the emitted
    register carries them, so the two cannot disagree about a malformed field.
    The LABEL is the part a unit block cannot be read without: authorized means
    the operator excluded this provision, expansion means the domain did -- and
    a report that showed the reason without the label leaves a reviewer unable
    to tell an honoured scope contract from scope drift.

    `labels` is keyed by string `what` only, so an unhashable one (`what: [a]`,
    already a ledger problem) is looked up as no label rather than raising out
    of a builder whose contract is that it never raises on domain content.
    """
    what = entry.get("what")
    return {"what": what,
            "reason": entry.get("reason"),
            "consequence": entry.get("consequence"),
            "label": labels.get(what) if isinstance(what, str) else None}


def _attribute(attribution, unit_id, key, row):
    attribution.setdefault(unit_id, {}).setdefault(key, []).append(row)


def _finish_attribution(attribution):
    """The attribution map, deterministic and never empty-but-present.

    AN EMPTY BLOCK IS NOT A NEUTRAL DEFAULT. A unit with nothing to attribute is
    RED -- unaccounted -- and a `{}` beside it reads as a chain that was looked
    for and found bare, i.e. as "checked". Absence is the honest spelling, so a
    unit appears in this map only when something actually attributes it.

    Coverage is ordered by `(atom, via)`; the sort is stable, so entries that
    tie keep the pass's own order. Deferrals keep AUTHORED order, which is the
    order the emitted register lists them in and the order a reviewer reads.
    """
    out = {}
    for unit_id in sorted(attribution):
        rows = {}
        coverage = attribution[unit_id].get("coverage")
        if coverage:
            rows["coverage"] = sorted(
                coverage, key=lambda row: (row["atom"], row["via"]))
        deferrals = attribution[unit_id].get("deferrals")
        if deferrals:
            rows["deferrals"] = deferrals
        if rows:
            out[unit_id] = rows
    return out


def _dedupe(problems):
    """Identical problem strings collapse, first-seen order preserved.

    `scan_domain`, `scan_file_cites` and `read_no_statute` each walk and reify
    the same operative files, so one unreadable file yields the same sentence
    three times. Identical strings carry identical information, so collapsing
    them loses nothing and keeps the checker's output readable; anything that
    differs -- a different file, line or reason -- survives.
    """
    seen, out = set(), []
    for problem in problems:
        if problem not in seen:
            seen.add(problem)
            out.append(problem)
    return out


_LEAD_IN_END = (":", "\u2014", "\u2013", "--")   # ':' / em dash / en dash / ASCII double dash.
# NOT a single ASCII '-': "an anti-" ends a word, not a sentence (internal review, 2026-10-05).
# SSO lead-ins end in U+2014 and in-word hyphens are U+2011, so no real unit relied on it.

_VERSION_SUFFIX = re.compile(r"-[0-9]+$")


def _stem(uid):
    """UID without an HKLM version suffix: `s39E_5_a-3` -> `s39E_5_a`. HKLM appends `-N` to
    a temporalId its children do not repeat (`s39E_5_a_i-1` sits under `s39E_5_a-3`), and
    `s16H_1_a-2` is a VERSION SIBLING of `s16H_1_a`, never its limb."""
    return _VERSION_SUFFIX.sub("", uid)


def _covered_via_limbs(doc_units, covered, deferred):
    """`(all_limbs, except_deferred)`: lead-in units whose limbs are all accounted for,
    REPORTED SEPARATELY and never folded into `covered` (2026-10-04, after an internal
    review; merging either list into the headline measure is the operator's call).

    A LEAD-IN is a unit whose own text ends in ':' or a dash ("The types of licences ...
    are as follows:", "... if --") and that has limbs. Its limbs are its DIRECT children:
    the units whose nearest pinned ancestor it is, by id STEM prefix plus a '_' or '-'
    separator, so AKN `__`, SSO `-` and HKLM `_` ids all work, and HKLM `-N` version
    suffixes are stripped first. When two units tie as nearest ancestor (two versions of
    one provision) the unit has NO parent: a lost credit, never an invented one.

    It qualifies when every non-deferred limb is covered, directly or (recursively) via its
    own limbs, and at least one limb is. A lead-in whose limbs are all deferred is
    deferred-in-effect, not implemented. `all_limbs` lists those with no deferred limb
    anywhere beneath them; `except_deferred` lists those that qualify only because some
    limbs are deferred, which is a weaker statement (internal review, 2026-10-05).
    Such a unit can carry operative words of its own (s 6(5)'s "Despite subsection (4),
    ... must have in force"), which is why this says "its limbs are implemented", not
    "its words are", and why neither list joins `covered`."""
    def _get(obj, name):          # `units.Unit` / `Run` objects here; dicts once emitted
        return obj[name] if isinstance(obj, dict) else getattr(obj, name)
    ids = [_get(u, "id") for u in doc_units]
    text = {_get(u, "id"): " ".join(_get(r, "text") for r in (_get(u, "runs") or ())).strip()
            for u in doc_units}
    stems = {uid: _stem(uid) for uid in ids}

    def parent_of(uid):
        s = stems[uid]
        best, best_len, tie = None, -1, False
        for other in ids:
            o = stems[other]
            if other == uid or len(o) >= len(s) or not s.startswith(o) or s[len(o)] not in "_-":
                continue
            if len(o) > best_len:
                best, best_len, tie = other, len(o), False
            elif len(o) == best_len:
                tie = True
        return None if tie else best

    children = {}
    for uid in ids:
        par = parent_of(uid)
        if par is not None:
            children.setdefault(par, []).append(uid)
    memo = {}

    def state(uid):
        """'covered' | 'full' (via limbs, none deferred) | 'partial' (via limbs, some
        deferred) | None."""
        if uid in covered:
            return "covered"
        if uid in memo:
            return memo[uid]
        memo[uid] = None                        # cycle guard
        kids = children.get(uid, [])
        live = [k for k in kids if k not in deferred]
        result = None
        if kids and live and text.get(uid, "").endswith(_LEAD_IN_END):
            states = [state(k) for k in live]
            if all(states):
                result = "partial" if (len(live) < len(kids) or "partial" in states) else "full"
        memo[uid] = result
        return result

    eligible = [uid for uid in ids if uid not in covered and uid not in deferred]
    return (sorted(u for u in eligible if state(u) == "full"),
            sorted(u for u in eligible if state(u) == "partial"))


def build(domain_dir):
    """The ledger for one domain. Never raises on domain content."""
    problems = []

    doc_units, unit_problems = _units.load_sources(domain_dir)
    problems += unit_problems
    # `sources` -- what each pinned document's OWN sidecar claims to be --
    # comes from a SECOND call, to `load_sources_with_provenance`, rather than
    # from replacing the call above with it. `load_sources` above must stay
    # the literal name `ledger.build` calls: a ledger test monkeypatches
    # `units.load_sources` to hand `ledger.build` a malformed `doc_units` list
    # without touching a real `sources/` dir at all
    # (`test_the_ledger_reports_malformed_positions_rather_than_raising`), so
    # this function's units/problems must keep coming from that exact
    # attribute. This does not duplicate any VALIDATION RULE -- `load_sources`
    # is itself a thin wrapper around `load_sources_with_provenance` (see
    # units.py), so both calls run the identical code and, for a real
    # `domain_dir`, produce byte-identical `problems`; `_dedupe` below
    # collapses the repeat, and only `sources` is taken from this second call.
    # For the one domain currently under sources/ this is one extra small
    # YAML read and one extra small XML parse -- not a real cost.
    _, source_problems, sources = _units.load_sources_with_provenance(domain_dir)
    problems += source_problems
    # THE LAST GATE BEFORE THE CONSUMERS. Everything below -- `_segments`'s
    # pos + 1 join, `resolve`'s per-run containment, the emitter's ordering --
    # trusts `Run.pos` completely, and this is the one place every `doc_units`
    # list passes through on its way to them. `load_sources` already checks
    # what IT built (identical sentences collapse in `_dedupe`), but this
    # function's contract is with the consumers, not with one reader: a future
    # source of units, or a hand-built list in a tool, must be checked by the
    # same rule rather than trusted because of where it came from.
    problems += _units.validate_doc_units(
        [_units.as_doc_unit(unit) for unit in doc_units])
    known = {u.id for u in doc_units}
    # What a `/n` run selector is checked against (spec 13.20 rule 1): the
    # unit's OWN run count, read off the same `doc_units` every other check
    # trusts. `resolve_selector` is the ONE function every consumer below --
    # coverage, deferral, T3, T5, the label cross-check -- resolves a
    # `units:` entry through, so `run_counts` is built here once rather than
    # re-derived per caller.
    run_counts = {u.id: len(u.runs) for u in doc_units}

    rules, clause_problems = _clauses.scan_domain(domain_dir)
    problems += clause_problems
    file_cites, cite_problems = _clauses.scan_file_cites(domain_dir)
    problems += cite_problems
    no_statute, no_statute_problems = _clauses.read_no_statute(domain_dir)
    problems += no_statute_problems

    # LABELS ARE CARRIED, NEVER CONSULTED BY COVERAGE. See the return dict's
    # `"labels"` comment below and this module's opening docstring: a label is
    # a redundant, cross-checked assertion (checked in T5), so it must not
    # feed the coverage loop that follows.
    domain_labels, label_problems = _labels.scan_domain(domain_dir)
    problems += label_problems

    citations, citation_problems = _registry.read_citations(domain_dir)
    problems += citation_problems
    parameters, parameter_problems = _registry.read_parameters(domain_dir)
    problems += parameter_problems
    records = citations + parameters

    # Clause-borne cites AND fact-borne ones: 11 domains keep their cite atoms
    # in fact rows (`norm(r12, drive, must, uk_hc_r126)`) and carry only a
    # variable in the clause, so a clause-only scan reports correctly-cited law
    # as uncovered and prescribes `no_statute` for law that is thoroughly cited.
    cited_atoms = {atom for rule in rules for atom in rule.cites}
    cited_atoms |= set(file_cites)

    by_atom = _by_atom(records)
    rules_by_atom = _rules_by_atom(rules)
    indirect_sites = _sites([rule for rule in rules if rule.indirect_cite])
    covered = set()
    # `covered_runs[unit_id]` -- the RUN POSITIONS (1-based, in the unit's own
    # run order) some covering record claims, as opposed to `covered` which
    # only says the unit id was named at all. The unit-level set is what
    # every consumer before spec 13.20 already reads (T2's unaccounted check,
    # the emitted `covered:` list); the run-level map is what CONTRADICTED
    # needs -- see below, where it is intersected against `deferred_runs`.
    covered_runs = {}
    # COVERAGE AND ITS ATTRIBUTION COME OFF ONE LOOP -- see the section comment
    # above `_covering`. A selector that does not resolve -- an unknown unit,
    # OR a `/n` run selector out of range -- contributes to NEITHER `covered`
    # nor the attribution: it covers nothing (rule 1), and T3 reports why.
    attribution = {}
    for atom in sorted(cited_atoms):
        record = by_atom.get(atom)
        if record is None:
            continue
        sites = _sites(rules_by_atom.get(atom, []))
        via = RULE_BORNE if sites else FACT_BORNE
        for selector in record.units:
            unit_id, positions, problem = _units.resolve_selector(
                selector, run_counts)
            if problem is not None:
                continue
            covered.add(unit_id)
            covered_runs.setdefault(unit_id, set()).update(positions)
            _attribute(attribution, unit_id, "coverage",
                       _covering(atom, via, record.verbatim, sites,
                                 indirect_sites))
    for record in records:
        if record.kind == "parameter":
            for selector in record.units:
                unit_id, positions, problem = _units.resolve_selector(
                    selector, run_counts)
                if problem is not None:
                    continue
                covered.add(unit_id)
                covered_runs.setdefault(unit_id, set()).update(positions)
                _attribute(attribution, unit_id, "coverage",
                           _covering(record.atom, PARAMETER_BORNE,
                                     record.verbatim, [], None))

    manifest_path = os.path.join(domain_dir, "manifest.yaml")
    loaded = _load_yaml(manifest_path, "manifest.yaml", problems)
    # PRESENT-BUT-UNREADABLE IS A THIRD STATE and the checker's ratchet needs
    # it named. `provision_tracking` comes out `None` here for a manifest that never
    # declared the field AND for one whose YAML would not parse, so a reader
    # that could not tell the two apart lets a syntax error silently UN-ARM an
    # enforced domain -- one commit that both breaks the manifest and drops a
    # deferral would sail through. `os.path.exists` is what separates them:
    # `_load_yaml` returns `None` with no problem for an absent file and `None`
    # with a problem for a broken one.
    manifest_unreadable = loaded is None and os.path.exists(manifest_path)
    manifest = loaded if loaded is not None else {}
    deferrals = _register(manifest, DEFERRED, problems)
    # Called for its STRUCTURAL validation only (a `units:` that is not a
    # list of strings is reported here, in the author's words) -- the
    # resolved `deferred`/`deferred_runs` sets below are built by walking
    # `deferrals` a second time, through `resolve_selector`, the one
    # function every consumer of a `units:` entry goes through.
    _listed_ids(deferrals, DEFERRED, problems)

    # EXCLUSIONS ARE PARSED AND CARRIED, AND THAT IS ALL THE LEDGER DOES WITH
    # THEM (spec 13.21). They are absent from `covered`, `deferred`,
    # `unaccounted`, `attribution` and every run map below -- not by a guard,
    # but because nothing here adds them, which is the property that makes the
    # relation safe. An exclusion cannot reduce the in-extract unaccounted
    # count, so spec 6's escape-hatch worry ("a model that can write 'out of
    # scope' for anything can green a domain by deferring all of it") does not
    # transfer to it: everything an exclusion may legally name is OUTSIDE the
    # extract (T6 enforces that), so excluding the whole instrument still
    # leaves every one of this domain's own units RED.
    exclusions = _register(manifest, EXCLUDED, problems)
    _listed_ids(exclusions, EXCLUDED, problems)

    # A reading is NEITHER covered nor deferred by being declared: its units
    # are formalized by rules, and the rule's own cite is what covers them.
    # This register is carried and checked (T7), and touches no coverage set --
    # asserted by a test, like the exclusions above.
    readings = _readings(manifest, problems)

    order_whats, order_excluded, order_readings, has_order = _order_scope(
        manifest.get("id"), domain_dir, problems)

    def _labelled(entries, authorized_whats):
        out = {}
        for entry in entries:
            what = entry.get("what")
            if isinstance(what, str) and what.strip():
                out[what] = ("authorized"
                             if has_order and what in authorized_whats
                             else "expansion")
        return out

    labels = _labelled(deferrals, order_whats)
    exclusion_labels = _labelled(exclusions, order_excluded)
    reading_labels = _labelled(readings, order_readings)

    # Membership matches `check_provisions._deferred_by` BY CONSTRUCTION --
    # that function now reads this map rather than re-walking the register, so
    # the artifact's `deferred_by` join and its per-unit deferral chain cannot
    # name different entries. The guard is the register's, not a new one: a
    # `units:` that is not a list is already reported by `_deferred_units` in
    # the author's words, and complaining again here would name a second, wrong
    # defect.
    #
    # `deferred_runs` is `covered_runs`'s twin: the RUN POSITIONS a deferral
    # entry claims for the unit, out of which CONTRADICTED is computed below.
    # An unresolvable selector -- unknown unit, or a `/n` out of range --
    # defers nothing (rule 1), same as it covers nothing above; T3 reports it.
    deferred = set()
    deferred_runs = {}
    # RUN POSITIONS DEFERRED ONLY IN PART (spec 13.23). A deferral can be finer
    # than a run: `parag_050.001` is ONE run carrying both
    # award-notice-deadline's core 30-day determination and the Annex V / Art 51
    # material three deferrals point at. Naming the run over-claims, and the
    # moment such a domain is formalized the unit is both covered and deferred
    # and CONTRADICTED fires -- correctly about the run, wrongly about the
    # intent, with the tempting fix being to drop a real scope statement.
    # `partial: true` says "part of this run", and those positions are excluded
    # from the contradiction test below. They still DEFER: T2 accounting is
    # untouched, and so is T3's demand that a deferral name something.
    partial_runs = {}
    for entry in deferrals:
        listed = entry.get("units")
        if not isinstance(listed, list):
            continue
        for selector in listed:
            if not isinstance(selector, str):
                continue
            unit_id, positions, problem = _units.resolve_selector(
                selector, run_counts)
            if problem is not None:
                continue
            deferred.add(unit_id)
            deferred_runs.setdefault(unit_id, set()).update(positions)
            if entry.get("partial") is True:
                partial_runs.setdefault(unit_id, set()).update(positions)
            _attribute(attribution, unit_id, "deferrals",
                       _deferring(entry, labels))

    # CONTRADICTED IS A RUN-LEVEL QUESTION (spec 13.20's wrinkle): a unit is
    # both covered and deferred as a CONTRADICTION only when the SAME run is
    # claimed by both sides. Art 174(1)'s two subparagraphs are opposite
    # dispositions of DIFFERENT runs of one unit -- not a contradiction, and
    # `unit_states`/T2 read this set instead of the naive
    # `covered & deferred` intersection so they cannot rediscover the false
    # positive `units:` addressing at unit granularity used to produce.
    # A run position deferred only IN PART is not a contradiction when the same
    # run is covered -- that is the declared position, not an accident.
    contradicted = {
        unit_id for unit_id in covered_runs.keys() & deferred_runs.keys()
        if (covered_runs[unit_id] & deferred_runs[unit_id])
        - partial_runs.get(unit_id, set())}

    return {
        "domain_id": manifest.get("id"),
        "provision_tracking": manifest.get("provision_tracking"),
        # The prose an EXEMPT domain must state. Carried here rather than
        # re-opened from the manifest in check_provisions for the reason given
        # above for `provision_tracking` itself: two reads could disagree, and
        # the one that decides must be the one the ledger recorded.
        "provision_tracking_exemption": manifest.get("provision_tracking_exemption"),
        # Whether `provision_tracking` above is a FACT or merely unknown. See the
        # comment where it is computed; `check_provisions`'s ratchet reads it
        # so that "could not tell" never reads as "did not opt in".
        "manifest_unreadable": manifest_unreadable,
        # Units keep DOCUMENT order (never sorted): the report reads down the
        # statute, and a sorted list interleaves Article 10 with Article 1.
        "doc_units": [_units.as_doc_unit(u) for u in doc_units],
        # What each pinned document's OWN sidecar claims to be -- doc_id,
        # celex, consolidated, url, format, file, sha256, extract, and
        # anything else the sidecar recorded, verbatim and in the order
        # `load_sources_with_provenance` read the sidecars (sorted by meta
        # filename, so this is deterministic without a second sort here).
        # Carried so a reviewer can answer the pin's OWN questions -- is this
        # the right document, the right consolidated version, cut where the
        # document itself draws the boundary -- from `provisions.yaml` alone;
        # see docs/superpowers/plans/2026-08-19-pin-provenance.md. Not yet
        # emitted or rendered (Task 2); `check_provisions.build_document`
        # does not read this key today.
        "sources": sources,
        # The partition is over the DOCUMENT. An id naming nothing in the store
        # is left out of all three lists and reported by T3 -- counting it as
        # covered would make the partition wider than the statute it partitions.
        # WHY each unit is the state it is: `{unit id: {coverage: [...],
        # deferrals: [...]}}`, over units the document defines. A unit with
        # nothing to attribute is ABSENT, never present-and-empty; see
        # `_finish_attribution`.
        "attribution": _finish_attribution(attribution),
        "covered": sorted(covered & known),
        "deferred": sorted(deferred & known),
        "unaccounted": sorted(known - covered - deferred),
        # A unit whose covered runs and deferred runs OVERLAP -- spec 13.20's
        # rule: same run claimed both ways is a genuine contradiction,
        # different runs are two true statements about the law. Subset of
        # `covered & deferred` by construction (overlapping runs implies both
        # unit-level memberships); `unit_states`/T2 read THIS, not the
        # coarser intersection, so a unit like Art 174(1) -- covered on run 1,
        # deferred on run 2 -- does not read as contradicted.
        "contradicted": sorted(contradicted),
        # Lead-ins whose limbs are all covered (`covered_via_limbs`), and those that
        # qualify only because some limbs are deferred (`..._except_deferred`); see
        # `_covered_via_limbs`. Both are SUBSETS of `unaccounted`, reported beside it.
        # Nothing reads them as coverage; the partition above is unchanged.
        **dict(zip(("covered_via_limbs", "covered_via_limbs_except_deferred"),
                   _covered_via_limbs(doc_units, covered & known, deferred & known))),
        "clauses": rules,
        "records": records,
        # Labels are CARRIED, never consulted by the coverage loop above. A
        # label is a redundant cross-checked assertion (spec §13.8); if one
        # could contribute to `covered`, coverage would stop being computed and
        # start being partly authored, which is the property this module's
        # opening docstring exists to protect.
        "labels": domain_labels,
        "deferrals": deferrals,
        # Carried beside the deferrals and read by nothing that computes a
        # unit state -- see the note where they are parsed.
        "exclusions": exclusions,
        "operative_readings": readings,
        # The COMMISSIONING record's own block (docs/COMMISSIONING.md 3),
        # carried verbatim and owned by nothing here. This layer reads it for
        # exactly one purpose -- H1 attestation, `check_provisions.
        # _check_commissioned_readings` -- and a second read of manifest.yaml
        # to get it would be the defect `is_enforced` documents: two reads of
        # one file can disagree, and the laxer one wins by accident.
        "commissioned": manifest.get("commissioned"),
        "deferral_labels": labels,
        "exclusion_labels": exclusion_labels,
        "reading_labels": reading_labels,
        "deferral_smells": _smells(deferrals),
        "no_statute": no_statute,
        "order_deferrals": sorted(order_whats),
        "order_exclusions": sorted(order_excluded),
        "order_readings": sorted(order_readings),
        "has_order": has_order,
        "problems": _dedupe(problems),
    }


def _smells(deferrals):
    """Advisory strings for spec 6 item 3.

    "Defer everything" looks like ONE reason repeated across many entries. This
    never affects an exit code -- the gate cannot judge whether a deferral is
    sound, and a check that claimed to would manufacture false greens. It makes
    the degenerate case conspicuous and bounds what a reviewer must read.
    """
    by_reason = {}
    for entry in deferrals:
        reason = entry.get("reason")
        reason = reason.strip() if isinstance(reason, str) else ""
        by_reason.setdefault(reason, []).append(entry)
    return [
        f"{len(group)} deferrals share one reason ({reason!r}) — boilerplate "
        f"deferral is what 'defer everything' looks like; review them "
        f"individually."
        for reason, group in sorted(by_reason.items())
        if reason and len(group) >= BOILERPLATE_THRESHOLD
    ]
