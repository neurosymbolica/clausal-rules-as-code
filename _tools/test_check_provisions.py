"""Contract tests for check_provisions — T1, T2, T3, T5 and the parameter leg.

The properties under test are the CHECKS' contract, not their wording:

  * T1 is satisfied by a direct cite, by an INDIRECT one, or by a `no_statute/3`
    declaration of the clause's own predicate — and by nothing else;
  * T1 also covers parameter facts: on a traced domain a `parameter_source`
    record with no `units:` is a number with no provision behind it;
  * T2's partition is total AND exclusive — an unaccounted unit fails, and so
    does a unit claimed by both sides;
  * T3 fails anything that names something unreal — a `units:` id in no pinned
    document, a deferral with no units/reason/consequence, a `no_statute`
    exempting a predicate that is not there;
  * T5 fails a `verbatim` the pinned text does not contain — the Art 174(1)(b)
    shape, where a clause is dropped from the MIDDLE and the remainder reads
    perfectly well;
  * an UNTRACED domain is a third state, neither failed nor audited-clean.

`indirect_cite` deserves its own paragraph because getting it wrong is the worst
failure available here. `findall(implements(C), norm(...), CITES)` IS a cite — it
resolves at run time off a fact table. The prescribed remedy for a T1 failure is
to declare `no_statute`, so a checker that flags an indirect cite teaches the
author to record correctly-cited law as having no statutory basis. That
inversion has been shipped once already; `test_t1_indirect_cite_*` pins it.

The `_domain` helper is repeated in full rather than imported from the ledger's
tests: a shared helper across test files is a hidden dependency, and these
tests must keep failing for their own reasons.
"""
import hashlib
import os
import re
import shutil

from _tools import check_provisions as ct
from _tools.provisions import ledger as _ledger
from _tools.provisions import units

FIXTURE_DIR = os.path.join(os.path.dirname(units.__file__), "fixtures")

# Every unit id in the fixture document, in document order. The document carries
# EIGHT units, the last three being the Art 4 chapeau and its two points — read
# `fixtures/fixture_statute.xml` rather than trusting a count here.
P1 = "FIXTURE#art_1__para_1"
P2 = "FIXTURE#art_1__para_2"
POINT_A = "FIXTURE#art_2__para_1__list_1__point_a"
POINT_B = "FIXTURE#art_2__para_1__list_1__point_b"
DEROGATION = "FIXTURE#art_3__para_1"
CHAPEAU = "FIXTURE#art_4__para_1"
CHAPEAU_A = "FIXTURE#art_4__para_1__point_a"
CHAPEAU_B = "FIXTURE#art_4__para_1__point_b"

# The fixture document's own words. T5 compares a record's `verbatim` against
# these, so the fixture's citations must now quote the statute rather than carry
# a placeholder: under T5 a clean domain is one whose quotes are real.
P1_TEXT = "The rate shall be ten per cent."
P2_TEXT = "The rate is rounded up to the next whole number."
POINT_A_TEXT = "goods supplied for consideration;"
POINT_B_TEXT = "services supplied for consideration."
CHAPEAU_TEXT = "The following transactions shall be subject to VAT:"
CHAPEAU_A_TEXT = "the supply of goods for consideration;"
CHAPEAU_B_TEXT = "the supply of services for consideration."

# Every unit except the derogation, which the manifest defers. A clean domain is
# one where the two directions meet: every clause cited, every unit accounted.
# art_4 quotes ACROSS its three units on purpose — a chapeau and its points are
# one sentence in the document, and a check that compared unit by unit would
# fail the most ordinary citation in real Akoma Ntoso.
CITATIONS = f'''-module(citations, [cite(C), implements(C), citation(ATOM, META)])

citation(art_1, {{
  label:    "Article 1",
  units:    ["{P1}", "{P2}"],
  verbatim: "{P1_TEXT}"
}}),

citation(art_2a, {{
  label:    "Article 2(a)",
  units:    ["{POINT_A}"],
  verbatim: "{POINT_A_TEXT}"
}}),

citation(art_2b, {{
  label:    "Article 2(b)",
  units:    ["{POINT_B}"],
  verbatim: "{POINT_B_TEXT}"
}}),

citation(art_4, {{
  label:    "Article 4",
  units:    ["{CHAPEAU}", "{CHAPEAU_A}", "{CHAPEAU_B}"],
  verbatim: "{CHAPEAU_TEXT} {CHAPEAU_A_TEXT} {CHAPEAU_B_TEXT}"
}})
'''

MANIFEST = f'''id: fixture/domain
deferred_set:
  - what: derogation
    units: ["{DEROGATION}"]
    reason: "Art 3 derogation out of scope."
    consequence: "Callers in derogating Member States must apply national law."
'''

#: The same domain, opted in. Every ratchet test differs from its unenforced
#: twin by THIS LINE ONLY, so a test cannot pass because two domains differed in
#: some other way.
MANIFEST_ENFORCED = MANIFEST + "provision_tracking: enforced\n"

KERNEL = (
    "rate(P, R) <- (\n    implements(art_1),\n    prof_get(P, r, R)\n)\n"
    "\nsupply_a(P) <- (\n    implements(art_2a),\n    prof_get(P, s, S)\n)\n"
    "\nsupply_b(P) <- (\n    implements(art_2b),\n    prof_get(P, t, T)\n)\n"
    "\nvat_scope(P) <- (\n    implements(art_4),\n    prof_get(P, v, V)\n)\n"
)

# A parameter is provenanced by its OWN record; `units:` is the binding this
# checker owns. P1 is already covered by art_1, so a clean domain stays clean.
PARAMETERS = ('-module(parameters, [parameter_source(KEY, META)])\n\n'
              'parameter_source("rate_percent", {\n'
              '  label:    "Rate",\n'
              f'  units:    ["{P1}"],\n'
              '  verbatim: "ten per cent"\n'
              '})\n')


def _domain(tmp_path, kernel=KERNEL, manifest=MANIFEST, citations=CITATIONS,
            parameters=None, sources=True, extra=None):
    """A domain NESTED two levels below the corpus root, as real ones are
    (`eu/vat/pro_rata_deduction`), so nothing here can pass by assuming a flat
    layout."""
    base = os.path.join(str(tmp_path), "fixture", "domain")
    os.makedirs(base, exist_ok=True)
    if sources:
        src = os.path.join(base, "sources")
        os.makedirs(src, exist_ok=True)
        shutil.copy(os.path.join(FIXTURE_DIR, "fixture_statute.xml"), src)
        with open(os.path.join(src, "fixture_statute.xml"), "rb") as handle:
            body = handle.read()
        _write(src, "fixture_statute.meta.yaml",
               'doc_id: FIXTURE\ncelex: FIXTURE\nconsolidated: "2026-01-01"\n'
               'url: "https://example.invalid/f"\nfile: fixture_statute.xml\n'
               f'sha256: "{hashlib.sha256(body).hexdigest()}"\n')
    for name, text in (("kernel.seam", kernel),
                       ("citations.seam", citations),
                       ("parameters.seam", parameters),
                       ("manifest.yaml", manifest)):
        if text is not None:
            _write(base, name, text)
    for rel, text in (extra or {}).items():
        _write(base, rel, text)
    return base


def _write(base, rel, text):
    path = os.path.join(base, rel)
    os.makedirs(os.path.dirname(path) or base, exist_ok=True)
    with open(path, "w", encoding="utf-8") as handle:
        handle.write(text)
    return path


def _line_of(text, needle):
    """The 1-based line NEEDLE starts on — derived from the source, never
    hardcoded, so an off-by-one in the checker cannot be absorbed by an
    off-by-one in the expectation."""
    return text[:text.index(needle)].count("\n") + 1


def _t1(problems):
    return [p for p in problems if p.startswith("T1 ")]


def _t2(problems):
    return [p for p in problems if p.startswith("T2 ")]


def _t3(problems):
    return [p for p in problems if p.startswith("T3 ")]


def _t5(problems):
    return [p for p in problems if p.startswith("T5 ")]


def _plus_citation(atom, units, verbatim):
    """The clean domain's citations with ONE more record appended, so a test
    changes exactly one thing and the rest of the domain stays green."""
    listed = ", ".join(f'"{u}"' for u in units)
    return CITATIONS.rstrip() + (
        f',\n\ncitation({atom}, {{label: "L", units: [{listed}], '
        f'verbatim: "{verbatim}"}})\n')


# ── the clean domain ─────────────────────────────────────────────────────────

def test_a_clean_traced_domain_has_no_problems(tmp_path):
    assert ct.check_domain(_domain(tmp_path, parameters=PARAMETERS)) == []


# ── T1: rule → sentence ──────────────────────────────────────────────────────

def test_t1_flags_an_uncited_operative_clause_at_its_own_file_and_line(tmp_path):
    kernel = KERNEL + "\nbare(P) <- (\n    prof_get(P, z, Z)\n)\n"
    problems = _t1(ct.check_domain(_domain(tmp_path, kernel=kernel)))
    assert len(problems) == 1
    assert f"kernel.seam:{_line_of(kernel, 'bare(P)')}:" in problems[0]


def test_t1_reports_the_line_the_clause_head_is_actually_on(tmp_path):
    """Off by one and the author is sent to a blank line or to the clause above.
    The expected number is derived from the kernel text, and the line it names
    is asserted to be the head."""
    kernel = KERNEL + "\nbare(P) <- (\n    prof_get(P, z, Z)\n)\n"
    problem = _t1(ct.check_domain(_domain(tmp_path, kernel=kernel)))[0]
    reported = int(problem.split("kernel.seam:")[1].split(":")[0])
    assert kernel.split("\n")[reported - 1].startswith("bare(P)")


def test_t1_is_satisfied_by_a_direct_cite(tmp_path):
    assert _t1(ct.check_domain(_domain(tmp_path))) == []


def test_t1_indirect_cite_satisfies_it(tmp_path):
    """THE INVERSION. `findall(implements(C), norm(...), CITES)` is a clause that IS
    cited, resolved at run time from a fact table. Flagging it prescribes
    `no_statute` for thoroughly-cited law — the worst failure this layer has."""
    kernel = KERNEL + ("\nnorm(travel, art_2a),\n"
                       "\nobligations(P, CITES) <- (\n"
                       "    findall(implements(C), norm(P, C), CITES)\n)\n")
    assert _t1(ct.check_domain(_domain(tmp_path, kernel=kernel))) == []


def test_t1_never_prescribes_no_statute_for_an_indirectly_cited_clause(tmp_path):
    """The same inversion stated as the harm rather than the mechanism: no
    output anywhere may name the indirectly-cited predicate."""
    kernel = KERNEL + ("\nnorm(travel, art_2a),\n"
                       "\nobligations(P, CITES) <- (\n"
                       "    findall(implements(C), norm(P, C), CITES)\n)\n")
    problems = ct.check_domain(_domain(tmp_path, kernel=kernel))
    assert not any("obligations" in p for p in problems)


def test_t1_is_not_satisfied_by_an_anonymous_cite(tmp_path):
    """`implements(_)` binds to nothing and resolves to no provision. Settled in
    clauses.py; this pins that the checker does not undo it."""
    kernel = KERNEL + "\nflag(P) <- (\n    implements(_),\n    prof_get(P, z, Z)\n)\n"
    problems = _t1(ct.check_domain(_domain(tmp_path, kernel=kernel)))
    assert len(problems) == 1 and "flag" in problems[0]


def test_t1_is_satisfied_by_a_no_statute_declaration(tmp_path):
    kernel = KERNEL + ('\nno_statute("build_profile", 2, "computation_helper"),\n'
                       "\nbuild_profile(P, Q) <- (\n    prof_get(P, z, Q)\n)\n")
    assert _t1(ct.check_domain(_domain(tmp_path, kernel=kernel))) == []


def test_t1_matches_an_exemption_on_arity_as_well_as_functor(tmp_path):
    """Exemption is per PREDICATE, and a predicate is `functor/arity`. Matching
    on the name alone would exempt every overload of a renamed head."""
    kernel = KERNEL + ('\nno_statute("build_profile", 3, "computation_helper"),\n'
                       "\nbuild_profile(P, Q) <- (\n    prof_get(P, z, Q)\n)\n")
    problems = _t1(ct.check_domain(_domain(tmp_path, kernel=kernel)))
    assert len(problems) == 1 and "build_profile" in problems[0]


def test_t1_remedy_names_the_no_statute_fact_and_not_the_dead_pragma(tmp_path):
    """Authors copy whatever the message says. `# no-statute:` was abandoned —
    a file carrying the directive form does not even parse."""
    kernel = KERNEL + "\nbare(P) <- (\n    prof_get(P, z, Z)\n)\n"
    problem = _t1(ct.check_domain(_domain(tmp_path, kernel=kernel)))[0]
    assert 'no_statute("bare", 1,' in problem
    assert "# no-statute" not in problem


def test_t1_says_nothing_about_a_fact(tmp_path):
    """`scan_domain` returns RULES only, so an uncited operative FACT is
    invisible to T1 and only T2's unit residue can catch it. Pinned so the
    narrowing is a decision, not a drift."""
    kernel = KERNEL + '\nthreshold(rate_percent, 10),\n'
    assert _t1(ct.check_domain(_domain(tmp_path, kernel=kernel))) == []


# ── T1's parameter leg ───────────────────────────────────────────────────────

def test_t1_flags_a_parameter_record_with_no_units(tmp_path):
    """"A number in a rule with no provision behind it" — the clearest defect
    this layer has, and the old plan checked only clauses, so a domain whose
    every threshold was unprovenanced went green."""
    parameters = ('-module(parameters, [parameter_source(KEY, META)])\n\n'
                  'parameter_source("rate_percent", {\n'
                  '  label:    "Rate",\n'
                  '  verbatim: "ten per cent"\n'
                  '})\n')
    problems = _t1(ct.check_domain(_domain(tmp_path, parameters=parameters)))
    assert len(problems) == 1 and "rate_percent" in problems[0]


def test_t1_flags_a_parameter_record_whose_units_list_is_empty(tmp_path):
    """An empty list is a present-but-unbound key, not a binding."""
    parameters = ('-module(parameters, [parameter_source(KEY, META)])\n\n'
                  'parameter_source("rate_percent", {units: [], '
                  'verbatim: "x"})\n')
    problems = _t1(ct.check_domain(_domain(tmp_path, parameters=parameters)))
    assert len(problems) == 1 and "rate_percent" in problems[0]


def test_t1_accepts_a_parameter_record_that_carries_units(tmp_path):
    assert _t1(ct.check_domain(_domain(tmp_path, parameters=PARAMETERS))) == []


def test_the_parameter_leg_does_not_fire_on_an_untraced_domain(tmp_path):
    """Untraced domains carry unit-less parameter records corpus-wide; the leg
    is a TRACED-domain check, exactly as T1 and T2 are."""
    parameters = ('-module(parameters, [parameter_source(KEY, META)])\n\n'
                  'parameter_source("rate_percent", {verbatim: "x"})\n')
    assert ct.check_domain(
        _domain(tmp_path, parameters=parameters, sources=False)) == []


# ── T2: sentence → rule ──────────────────────────────────────────────────────

def test_t2_flags_an_unaccounted_unit(tmp_path):
    """Drop the art_2b clause and point_b is neither formalized nor deferred."""
    kernel = KERNEL.replace(
        "\nsupply_b(P) <- (\n    implements(art_2b),\n    prof_get(P, t, T)\n)\n", "")
    problems = _t2(ct.check_domain(_domain(tmp_path, kernel=kernel)))
    assert len(problems) == 1 and POINT_B in problems[0]


def test_t2_flags_every_unaccounted_unit_not_merely_the_first(tmp_path):
    kernel = "rate(P, R) <- (\n    implements(art_1),\n    prof_get(P, r, R)\n)\n"
    problems = _t2(ct.check_domain(_domain(tmp_path, kernel=kernel)))
    unaccounted = [p for p in problems if "unaccounted" in p]
    assert len(unaccounted) == 5      # both points, the chapeau and its two points


def test_t2_flags_a_unit_that_is_both_covered_and_deferred(tmp_path):
    """A contradiction, not a rounding error: neither the ledger nor the checker
    may pick a winner, because whichever it picked would be a claim nobody
    made."""
    manifest = MANIFEST + ("  - what: overlap\n"
                           f'    units: ["{P1}"]\n'
                           '    reason: "also deferred"\n'
                           '    consequence: "contradictory on purpose"\n')
    problems = _t2(ct.check_domain(_domain(tmp_path, manifest=manifest)))
    assert len(problems) == 1
    assert P1 in problems[0] and "both covered and deferred" in problems[0]


def test_t2_accepts_a_domain_whose_units_are_all_covered_or_deferred(tmp_path):
    assert _t2(ct.check_domain(_domain(tmp_path))) == []


def test_t2_counts_a_deferred_unit_as_accounted(tmp_path):
    """Computing `units - covered` alone would report every deferred unit as
    unaccounted, which is the whole point of the register."""
    problems = ct.check_domain(_domain(tmp_path))
    assert not any(DEROGATION in p for p in problems)


# ── T3: referential integrity ────────────────────────────────────────────────

#: A unit id of the right SHAPE that the pinned document does not define — what
#: a re-consolidation or a hand-typed eId leaves behind.
MISSING = "FIXTURE#art_9__para_1"


def test_t3_flags_a_citation_unit_that_is_in_no_pinned_document(tmp_path):
    citations = _plus_citation("art_9", [MISSING], "")
    problems = _t3(ct.check_domain(_domain(tmp_path, citations=citations)))
    assert len(problems) == 1
    assert MISSING in problems[0] and "art_9" in problems[0]


def test_t3_flags_a_parameter_unit_that_is_in_no_pinned_document(tmp_path):
    """Parameters carry `units:` too, and a parameter bound to a provision that
    does not exist is a number with a footnote to nowhere."""
    parameters = PARAMETERS.replace(f'"{P1}"', f'"{MISSING}"')
    problems = _t3(ct.check_domain(_domain(tmp_path, parameters=parameters)))
    assert len(problems) == 1 and MISSING in problems[0]


def test_t3_accepts_records_whose_units_all_resolve(tmp_path):
    assert _t3(ct.check_domain(_domain(tmp_path, parameters=PARAMETERS))) == []


def test_t3_flags_a_deferral_unit_that_is_in_no_pinned_document(tmp_path):
    """The ledger intersects `deferred` with the document, so an unresolvable
    deferral id vanishes from the partition silently — it defers nothing while
    reading as a deferral."""
    manifest = MANIFEST.replace(f'"{DEROGATION}"', f'"{MISSING}"')
    problems = _t3(ct.check_domain(_domain(tmp_path, manifest=manifest)))
    assert len(problems) == 1 and MISSING in problems[0]


def test_t3_flags_a_deferral_that_names_no_units(tmp_path):
    manifest = MANIFEST.replace(f'    units: ["{DEROGATION}"]\n', "")
    problems = _t3(ct.check_domain(_domain(tmp_path, manifest=manifest)))
    assert len(problems) == 1 and "derogation" in problems[0]


def test_t3_flags_a_deferral_that_names_an_empty_unit_list(tmp_path):
    manifest = MANIFEST.replace(f'units: ["{DEROGATION}"]', "units: []")
    problems = _t3(ct.check_domain(_domain(tmp_path, manifest=manifest)))
    assert len(problems) == 1 and "derogation" in problems[0]


def test_t3_flags_a_deferral_with_an_empty_reason(tmp_path):
    manifest = MANIFEST.replace('reason: "Art 3 derogation out of scope."',
                                'reason: "   "')
    problems = _t3(ct.check_domain(_domain(tmp_path, manifest=manifest)))
    assert len(problems) == 1 and "reason" in problems[0]


def test_t3_flags_a_deferral_with_a_missing_consequence(tmp_path):
    """The consequence is what makes a hole USABLE — it tells a caller what it
    must do for itself. Accepting an empty one turns the register into a list of
    excuses, which is the exact shape of the false green this layer removes."""
    manifest = "\n".join(
        line for line in MANIFEST.splitlines()
        if not line.strip().startswith("consequence:")) + "\n"
    problems = _t3(ct.check_domain(_domain(tmp_path, manifest=manifest)))
    assert len(problems) == 1 and "consequence" in problems[0]


def test_t3_flags_a_deferral_with_an_empty_consequence(tmp_path):
    manifest = MANIFEST.replace(
        'consequence: "Callers in derogating Member States must apply '
        'national law."', 'consequence: ""')
    problems = _t3(ct.check_domain(_domain(tmp_path, manifest=manifest)))
    assert len(problems) == 1 and "consequence" in problems[0]


def test_t3_flags_a_no_statute_with_an_empty_reason(tmp_path):
    """`read_no_statute` preserves an empty reason rather than judging it —
    judging is this gate's job. A bare assertion with no justification is the
    one unargued claim the enforced path allows, so it may not be silent."""
    kernel = KERNEL + ('\nno_statute("build_profile", 2, ""),\n'
                       "\nbuild_profile(P, Q) <- (\n    prof_get(P, z, Q)\n)\n")
    problems = _t3(ct.check_domain(_domain(tmp_path, kernel=kernel)))
    assert len(problems) == 1 and "build_profile" in problems[0]


def test_t3_flags_a_no_statute_naming_a_predicate_that_does_not_exist(tmp_path):
    """Dead text left by a rename: the exemption survives, the predicate it
    exempted does not, and nothing re-justifies the next predicate to take the
    name."""
    kernel = KERNEL + '\nno_statute("renamed_away", 2, "computation_helper"),\n'
    problems = _t3(ct.check_domain(_domain(tmp_path, kernel=kernel)))
    assert len(problems) == 1 and "renamed_away" in problems[0]


def test_t3_matches_predicate_existence_on_arity_as_well_as_functor(tmp_path):
    """Existence is per PREDICATE, and a predicate is `functor/arity`. On the
    functor alone an exemption survives the arity change that invalidated it."""
    kernel = KERNEL + ('\nno_statute("build_profile", 3, "computation_helper"),\n'
                       "\nbuild_profile(P, Q) <- (\n    prof_get(P, z, Q)\n)\n")
    problems = _t3(ct.check_domain(_domain(tmp_path, kernel=kernel)))
    assert len(problems) == 1 and "build_profile/3" in problems[0]


def test_t3_accepts_a_no_statute_for_a_rule_that_exists(tmp_path):
    kernel = KERNEL + ('\nno_statute("build_profile", 2, "computation_helper"),\n'
                       "\nbuild_profile(P, Q) <- (\n    prof_get(P, z, Q)\n)\n")
    assert _t3(ct.check_domain(_domain(tmp_path, kernel=kernel))) == []


def test_t3_treats_a_fact_only_predicate_as_nonexistent(tmp_path):
    """THE CHOSEN CONSEQUENCE, pinned so it stays a decision. `scan_domain`
    returns RULES only, so a `no_statute` for a predicate that exists only as
    facts reads as naming nothing. That is deliberate: facts never fail T1, so
    exempting one was always dead text."""
    kernel = KERNEL + ('\nthreshold(rate_percent, 10),\n'
                       '\nno_statute("threshold", 2, "computation_helper"),\n')
    problems = _t3(ct.check_domain(_domain(tmp_path, kernel=kernel)))
    assert len(problems) == 1 and "threshold" in problems[0]


def test_t3_does_not_fire_on_an_untraced_domain(tmp_path):
    """Every id names nothing when there is no document, so an untraced domain
    would redden wholesale — 60 of 60 on day one."""
    citations = _plus_citation("art_9", [MISSING], "")
    manifest = MANIFEST.replace(f'units: ["{DEROGATION}"]', "units: []")
    kernel = KERNEL + '\nno_statute("renamed_away", 2, ""),\n'
    assert ct.check_domain(_domain(tmp_path, kernel=kernel, manifest=manifest,
                                   citations=citations, sources=False)) == []


# ── T5: verbatim fidelity ────────────────────────────────────────────────────

def test_t5_catches_a_clause_dropped_from_the_middle(tmp_path):
    """THE ART 174(1)(b) SHAPE, and the reason this check exists. The draft vat
    manifest dropped "transactions included in the numerator and" from the
    middle of the provision: an inversion of the fraction that reads perfectly
    well in isolation and passes every other check in this layer."""
    dropped = P1_TEXT.replace("ten per ", "")     # "The rate shall be cent."
    citations = CITATIONS.replace(f'verbatim: "{P1_TEXT}"',
                                  f'verbatim: "{dropped}"')
    problems = _t5(ct.check_domain(_domain(tmp_path, citations=citations)))
    assert len(problems) == 1 and "art_1" in problems[0]


def test_t5_catches_a_middle_unit_dropped_from_a_multi_unit_quote(tmp_path):
    """The same shape one level up: the chapeau and its second point quoted as
    if the first point were not there."""
    quote = f"{CHAPEAU_TEXT} {CHAPEAU_B_TEXT}"
    citations = CITATIONS.replace(
        f'verbatim: "{CHAPEAU_TEXT} {CHAPEAU_A_TEXT} {CHAPEAU_B_TEXT}"',
        f'verbatim: "{quote}"')
    problems = _t5(ct.check_domain(_domain(tmp_path, citations=citations)))
    assert len(problems) == 1 and "art_4" in problems[0]


def test_t5_names_where_the_quote_stops_matching(tmp_path):
    """The message must point AT the divergence. "Does not match" sends the
    author to re-read a paragraph; naming the last words that did match sends
    them to the dropped clause.

    THE FIRST ASSERTION ALONE DOES NOT PIN THIS: "The rate shall be" is a
    substring of `dropped` ITSELF (the quote opens on those words), so a
    `_matched_prefix` mutant that always returned 0 -- reporting NOTHING
    matched -- would still put "The rate shall be" in the message's UNMATCHED
    half and pass. The second assertion pins the exact matched length
    (hardcoded here, not recomputed by calling `_matched_prefix` again --
    calling the very function under test would make the expectation wrong in
    exactly the same way the mutant is)."""
    dropped = P1_TEXT.replace("ten per ", "")
    citations = CITATIONS.replace(f'verbatim: "{P1_TEXT}"',
                                  f'verbatim: "{dropped}"')
    problem = _t5(ct.check_domain(_domain(tmp_path, citations=citations)))[0]
    assert "The rate shall be" in problem
    assert "…'The rate shall be '" in problem


def test_t5_accepts_a_verbatim_the_pinned_text_contains(tmp_path):
    assert _t5(ct.check_domain(_domain(tmp_path, parameters=PARAMETERS))) == []


def test_t5_accepts_a_quote_spanning_the_units_a_record_names(tmp_path):
    """art_4 quotes a chapeau and both its points as one sentence — the most
    ordinary citation in real Akoma Ntoso."""
    problems = ct.check_domain(_domain(tmp_path))
    assert not any("art_4" in p for p in _t5(problems))


def test_t5_compares_against_the_units_the_record_names(tmp_path):
    """Not against the document at large. A quote of Article 2(b) filed under a
    record naming point (a) is a mis-citation, and it is the failure mode a
    document-wide search would wave through."""
    citations = CITATIONS.replace(f'verbatim: "{POINT_A_TEXT}"',
                                  f'verbatim: "{POINT_B_TEXT}"')
    problems = _t5(ct.check_domain(_domain(tmp_path, citations=citations)))
    assert len(problems) == 1 and "art_2a" in problems[0]


def _discontiguous_chapeau(built, tail):
    """BUILT with the chapeau's own text made DISCONTIGUOUS, Art 174(1)'s shape.

    The chapeau keeps its opening sentence and gains a second run AFTER its two
    points -- the position after point (b) -- exactly as VAT Directive Art
    174(1) carries a lead-in, its two lettered points, and then a further
    subparagraph. The fixture document is contiguous throughout, so the shape
    has to be constructed; the positions are the real ones the reader assigned,
    which is what makes the adjacency question meaningful.
    """
    by_id = {u["id"]: u for u in built["doc_units"]}
    opening = by_id[CHAPEAU]["runs"][0]
    assert [by_id[CHAPEAU_A]["runs"][0]["pos"],
            by_id[CHAPEAU_B]["runs"][0]["pos"]] == [
        opening["pos"] + 1, opening["pos"] + 2], "fixture is not chapeau-shaped"
    by_id[CHAPEAU]["runs"] = [opening,
                              {"pos": opening["pos"] + 3, "text": tail}]
    return built


TAIL = "This Article applies from 1 January 2026."


def test_t5_refuses_a_quote_spanning_a_units_OWN_discontiguity(tmp_path):
    """THE CRITICAL CASE, at the check it would have fooled. A unit's own text
    can be discontiguous, and joining the pieces produces a sentence the
    statute does not contain -- in the real pin,

        "…comprising the following amounts: Member States may include in the
         denominator…"

    Against a joined string T5 CERTIFIES that phrase as the statute's words, in
    that order and uninterrupted: a false green in the exact check this layer
    exists to provide. The quote below is built the same way, from the two runs
    either side of the seam, and must FAIL."""
    domain = _domain(tmp_path)
    built = _discontiguous_chapeau(_ledger.build(domain), TAIL)
    fabricated = f"{CHAPEAU_TEXT} {TAIL}"
    citations = CITATIONS.replace(
        f'verbatim: "{CHAPEAU_TEXT} {CHAPEAU_A_TEXT} {CHAPEAU_B_TEXT}"',
        f'verbatim: "{fabricated}"')
    built["records"] = _ledger.build(
        _domain(tmp_path / "twin", citations=citations))["records"]

    problems = _t5(ct.check_domain(domain, built))
    assert len(problems) == 1 and "art_4" in problems[0]


def test_t5_still_joins_a_chapeau_to_its_points_across_the_same_seam(tmp_path):
    """THE OTHER HALF, without which the fix above is just a stricter check.
    The chapeau and its first point ARE adjacent in the document, so the most
    ordinary citation in real Akoma Ntoso must still pass -- on the very same
    discontiguous unit. What T5 refuses is the pieces the document does not
    read straight through, not every join."""
    domain = _domain(tmp_path)
    built = _discontiguous_chapeau(_ledger.build(domain), TAIL)
    assert _t5(ct.check_domain(domain, built)) == []


def test_t5_does_not_splice_two_named_units_the_document_separates(tmp_path):
    """The same fabrication one level up, and a deliberate TIGHTENING. P1 and
    POINT_A are both real units, but P2 stands between them in the document, so
    a quote running out of one and into the other reads words that are nowhere
    adjacent. An earlier version joined every named unit and called this "the
    permissive direction"; it is the same invented adjacency the Art 174(1) fix
    removes, and naming two units is not evidence the statute joins them.

    P1 and P2 themselves ARE adjacent -- the second assertion -- so what is
    refused is the pair the document separates, not joining as such."""
    citations = _plus_citation("art_9", [P1, POINT_A],
                               f"{P1_TEXT} {POINT_A_TEXT}")
    problems = _t5(ct.check_domain(_domain(tmp_path, citations=citations)))
    assert len(problems) == 1 and "art_9" in problems[0]

    citations = _plus_citation("art_9", [P1, P2], f"{P1_TEXT} {P2_TEXT}")
    assert _t5(ct.check_domain(_domain(tmp_path, citations=citations))) == []


def test_segments_cut_where_the_document_does_not_read_straight_through():
    """`_segments` in isolation: consecutive positions join, a gap cuts. This
    is the ONE place T5 may join two texts, so its rule is pinned directly
    rather than only through the checks above."""
    runs_by_id = {
        "D#chapeau": [{"pos": 4, "text": "Subject to:"},
                      {"pos": 7, "text": "and no other case."}],
        "D#point_a": [{"pos": 5, "text": "first;"}],
        "D#far_away": [{"pos": 90, "text": "Unrelated."}],
    }
    assert ct._segments(runs_by_id, ["D#chapeau", "D#point_a"]) == [
        "Subject to: first;", "and no other case."]
    assert ct._segments(runs_by_id, ["D#chapeau"]) == [
        "Subject to:", "and no other case."]
    assert ct._segments(runs_by_id, ["D#point_a", "D#far_away"]) == [
        "first;", "Unrelated."]


def test_t5_says_nothing_about_an_empty_verbatim(tmp_path):
    """An unsourced record is `check_citations`' business, and the six
    all-`unverified` eu/procurement domains REQUIRE an empty verbatim. Firing
    here would redden a domain for doing what its own convention demands."""
    citations = CITATIONS.replace(f'verbatim: "{P1_TEXT}"', 'verbatim: ""')
    assert _t5(ct.check_domain(_domain(tmp_path, citations=citations))) == []


def test_t5_says_nothing_about_a_whitespace_only_verbatim(tmp_path):
    citations = CITATIONS.replace(f'verbatim: "{P1_TEXT}"',
                                  'verbatim: "   "')
    assert _t5(ct.check_domain(_domain(tmp_path, citations=citations))) == []


def test_t5_normalises_whitespace_on_both_sides(tmp_path):
    """The document's line wrapping is not semantic, and neither is a quote's.
    Without normalisation every multi-line verbatim in the corpus reddens."""
    wrapped = P1_TEXT.replace(" ten ", "\\n   ten\\t")
    citations = CITATIONS.replace(f'verbatim: "{P1_TEXT}"',
                                  f'verbatim: "{wrapped}"')
    assert _t5(ct.check_domain(_domain(tmp_path, citations=citations))) == []


def test_t5_does_not_double_report_a_unit_t3_already_caught(tmp_path):
    """An unresolvable id is ONE defect. Reported twice, the author fixes the
    fidelity complaint by editing the quote — against a provision that does not
    exist."""
    citations = _plus_citation("art_9", [MISSING], "words from nowhere")
    problems = ct.check_domain(_domain(tmp_path, citations=citations))
    assert len(_t3(problems)) == 1
    assert _t5(problems) == []


def test_t5_says_nothing_about_a_record_binding_no_units(tmp_path):
    """Nothing to compare against. An unbound parameter is T1's complaint and
    an unbound citation is `check_citations`', and neither is improved by a
    fidelity failure against an empty text."""
    parameters = PARAMETERS.replace(f'units:    ["{P1}"],\n', "")
    assert _t5(ct.check_domain(_domain(tmp_path, parameters=parameters))) == []


def test_t5_reads_the_unit_text_from_the_ledger_not_from_the_source(tmp_path):
    """THE INVARIANT: the checker reads the ledger and nothing else. A T5 that
    re-opened the pinned document could score a quote against text the ledger
    and the rendered report never saw — this layer reproducing its own failure
    mode in miniature.

    So the ledger is handed a unit text that the file on disk does not carry. A
    checker reading the ledger fails the quote; one re-reading the source
    passes it, and passing is the wrong answer here.
    """
    domain = _domain(tmp_path)
    built = _ledger.build(domain)
    built["doc_units"] = [
        {"id": u["id"],
         "runs": ([{"pos": u["runs"][0]["pos"], "text": "Wholly different text."}]
                  if u["id"] == P1 else u["runs"])}
        for u in built["doc_units"]
    ]
    problems = _t5(ct.check_domain(domain, built))
    assert len(problems) == 1 and "art_1" in problems[0]


def test_t5_does_not_fire_on_an_untraced_domain(tmp_path):
    citations = CITATIONS.replace(f'verbatim: "{P1_TEXT}"',
                                  'verbatim: "words from nowhere"')
    assert ct.check_domain(
        _domain(tmp_path, citations=citations, sources=False)) == []


# ── the untraced state: 60 of 60 domains on day one ──────────────────────────

def test_an_untraced_domain_yields_no_problems(tmp_path):
    """No unit store: T1 and T2 are meaningless, not satisfied. A domain that
    never opted in must not be disturbed by this layer landing."""
    kernel = ("bare(P) <- (\n    prof_get(P, z, Z)\n)\n"
              "\nalso_bare(P) <- (\n    implements(_),\n    prof_get(P, y, Y)\n)\n")
    assert ct.check_domain(
        _domain(tmp_path, kernel=kernel, citations=None, sources=False)) == []


def test_an_untraced_domain_is_reported_as_untraced_not_as_ok(tmp_path, capsys):
    """"Not traced" and "audited and clean" are different states and a bare `OK`
    conflates them — for 60 of 60 domains on day one."""
    ct.main([_domain(tmp_path, sources=False)])
    out = capsys.readouterr().out
    assert "not traced" in out.lower()


def test_a_traced_domain_does_not_claim_to_be_untraced(tmp_path, capsys):
    ct.main([_domain(tmp_path, parameters=PARAMETERS)])
    out = capsys.readouterr().out
    assert "not traced" not in out.lower()
    assert "OK" in out


def test_an_untraced_domain_exits_zero(tmp_path, capsys):
    assert ct.main([_domain(tmp_path, sources=False)]) == 0


def test_an_untraced_domain_prints_no_bare_ok(tmp_path, capsys):
    """"Not traced" and "OK" one line apart are the two states this file exists
    to keep apart, and the second overrides the first for any reader skimming a
    60-domain sweep for greens. The exit code is still 0; what the run may not
    do is claim a verdict it did not reach."""
    rc = ct.main([_domain(tmp_path, sources=False)])
    out = capsys.readouterr().out
    assert rc == 0
    assert "not traced" in out
    assert "OK" not in out


# ── enforced + untraced: the gate un-armed by a deletion (spec §5) ───────────
#
# `git rm -r sources/` on an enforced domain turns T1, T2, T3, T5 and §6 off at
# once. Under the plain three-state rule that run prints the untraced note and
# exits 0 — every check in this file disarmed, no problem raised. The tests come
# in PAIRS: the same deletion on an undeclared domain must stay silent, so a
# checker that reddens the untraced state generally fails just as loudly as one
# that stays silent when enforced.

def _untrace(domain):
    """Delete `sources/` — literally `git rm -r sources/` — rather than build a
    domain that never had one. The regression is a domain that WAS traced."""
    shutil.rmtree(os.path.join(domain, "sources"))
    return domain


def test_an_enforced_domain_that_is_not_traced_is_a_problem(tmp_path):
    problems = ct.check_domain(
        _untrace(_domain(tmp_path, parameters=PARAMETERS,
                         manifest=MANIFEST_ENFORCED)))
    assert [p for p in problems if p.startswith("§5 ")]
    assert any("not traced" in p and "sources/" in p for p in problems)


def test_an_enforced_domain_that_is_not_traced_blocks(tmp_path, capsys):
    """The whole point: the deletion must cost an exit code, not a note."""
    rc = ct.main([_untrace(_domain(tmp_path, parameters=PARAMETERS,
                                   manifest=MANIFEST_ENFORCED))])
    assert rc == 1
    assert "PROBLEM:" in capsys.readouterr().out


def test_an_undeclared_domain_that_is_not_traced_is_still_silent(tmp_path):
    """The pair. 60 of 60 domains are untraced and undeclared today, and not one
    of them may gain a problem from this."""
    assert ct.check_domain(
        _untrace(_domain(tmp_path, parameters=PARAMETERS))) == []


def test_a_domain_declaring_the_wrong_word_is_not_treated_as_enforced_here(
        tmp_path):
    """`provision_tracking: yes` has not opted in — the same reading the ratchet
    gives it. A check that fired on any truthy value would redden a domain the
    exit code deliberately does not block."""
    manifest = MANIFEST + "provision_tracking: yes\n"
    assert ct.check_domain(
        _untrace(_domain(tmp_path, parameters=PARAMETERS,
                         manifest=manifest))) == []


# ── a pinned document that yields nothing is not "untraced" ─────────────────

#: Well-formed Akoma Ntoso, sha-valid, and carrying no eId anywhere — so it
#: parses to zero units and the domain reads exactly like one with no sources/.
EID_LESS_XML = (
    '<akomaNtoso xmlns="http://docs.oasis-open.org/legaldocml/ns/akn/3.0">'
    "<act><body><article><content><p>Operative text, and not one eId.</p>"
    "</content></article></body></act></akomaNtoso>")


def _repin(domain, xml, stem="fixture_statute"):
    """Replace the pinned document, sha and all: `sources/` present, the pin
    intact, and the document useless."""
    src = os.path.join(domain, "sources")
    _write(src, f"{stem}.xml", xml)
    _write(src, f"{stem}.meta.yaml",
           f'doc_id: FIXTURE\ncelex: FIXTURE\nconsolidated: "2026-01-01"\n'
           f'url: "https://example.invalid/f"\nfile: {stem}.xml\n'
           f'sha256: "{hashlib.sha256(xml.encode("utf-8")).hexdigest()}"\n')
    return domain


def test_a_pinned_document_yielding_no_units_is_a_problem(tmp_path):
    """Otherwise the run says "not traced — no pinned statute under sources/"
    of a domain that HAS one, sha-valid, and exits 0 with every check unasked.
    The message is not merely unhelpful, it is false."""
    problems = ct.check_domain(
        _repin(_domain(tmp_path, manifest=MANIFEST_ENFORCED), EID_LESS_XML))
    assert any("fixture_statute.xml" in p and "no units" in p for p in problems)


def test_a_pinned_document_yielding_no_units_blocks_an_enforced_domain(
        tmp_path, capsys):
    rc = ct.main([_repin(_domain(tmp_path, manifest=MANIFEST_ENFORCED),
                         EID_LESS_XML)])
    assert rc == 1
    assert "PROBLEM:" in capsys.readouterr().out


# ── the error channel: ledger problems propagate ─────────────────────────────

def test_a_reader_problem_reaches_the_output(tmp_path):
    """The ratchet governs problems and nothing else, so a reader's problem must
    arrive as a problem — not as a traceback, and not swallowed."""
    problems = ct.check_domain(
        _domain(tmp_path, kernel="this is not ) clausal ( at all\n"))
    assert any("kernel.seam" in p for p in problems)


def test_a_reader_problem_reaches_the_output_on_an_untraced_domain_too(tmp_path):
    """The untraced early return skips the CHECKS, not the error channel."""
    problems = ct.check_domain(
        _domain(tmp_path, kernel="this is not ) clausal ( at all\n",
                citations=None, sources=False))
    assert any("kernel.seam" in p for p in problems)


def test_a_pin_mismatch_reaches_the_output(tmp_path):
    """T4 lives in `units.load_sources`; it must not be re-implemented here, but
    it must still surface."""
    domain = _domain(tmp_path)
    _write(os.path.join(domain, "sources"), "fixture_statute.xml", "<altered/>")
    assert any("sha256" in p for p in ct.check_domain(domain))


def test_a_broken_domain_raises_nothing(tmp_path):
    """Every failure mode arrives as a problem string."""
    domain = _domain(tmp_path, kernel="this is not ) clausal ( at all\n",
                     manifest="id: [unclosed\n",
                     citations="citation(art_1, 7)\n")
    assert isinstance(ct.check_domain(domain), list)


# ── §6: deferral discipline ──────────────────────────────────────────────────
#
# Three duties, and only ONE of them is a problem. An order-authorized
# exclusion missing from the register blocks; a register entry beyond the order
# is an `expansion` and must NOT block (fail it and the label becomes a
# fail-flag, so the only way to green a completed domain is to stop recording
# the completions); the boilerplate smell is advisory and may never reach the
# exit code. The tests below are written so that a checker which confuses any
# two of those fails.

# The order deliberately does NOT name the domain in its filename: the corpus's
# `_orders/vat-pro-rata-deduction.yaml` carries `domain: eu/vat/pro-rata-
# deduction` against manifest `id: eu/vat/pro_rata_deduction`, and no rule
# derives either spelling from the other.
ORDER = '''domain: fixture/domain
deferred_set:
  - { what: derogation, reason: "Art 3 derogation out of scope" }
'''

#: An order entry the clean manifest does NOT register — the scope-drift shape.
UNREGISTERED = ('  - { what: capital_goods_adjustment, '
                'reason: "Arts 184-192 out of scope" }\n')

# The clean kernel minus its Art 2(b) clause, so POINT_B is left uncovered and
# a deferral of it is a real completion rather than a contradiction.
KERNEL_WITHOUT_ART_2B = KERNEL.replace(
    "\nsupply_b(P) <- (\n    implements(art_2b),\n    prof_get(P, t, T)\n)\n", "")

# Only Art 1 and Art 4, leaving both Art 2 points and the derogation to be
# deferred — the three entries the boilerplate advisory needs.
KERNEL_ART_1_AND_4 = (
    "rate(P, R) <- (\n    implements(art_1),\n    prof_get(P, r, R)\n)\n"
    "\nvat_scope(P) <- (\n    implements(art_4),\n    prof_get(P, v, V)\n)\n")


def _with_order(domain, order=ORDER, name="some-unrelated-filename.yaml"):
    """Write an order at the CORPUS ROOT — two levels above the domain, which
    is where `_orders/` sits for a real domain like `eu/vat/pro_rata_deduction`
    (three levels down). A lookup that reads the domain's parent finds
    nothing."""
    root = os.path.dirname(os.path.dirname(domain))
    _write(os.path.join(root, "_orders"), name, order)
    return domain


def _order(problems):
    return [p for p in problems if p.startswith("§6 ")]


def test_an_order_authorized_exclusion_present_in_the_register_passes(tmp_path):
    domain = _with_order(_domain(tmp_path, parameters=PARAMETERS))
    assert ct.check_domain(domain) == []


def test_an_order_authorized_exclusion_missing_from_the_register_is_flagged(
        tmp_path):
    """The operator declared the exclusion; silently formalizing it — or
    silently dropping it — is scope drift, and nothing else in this layer
    notices."""
    domain = _with_order(_domain(tmp_path, parameters=PARAMETERS),
                         order=ORDER + UNREGISTERED)
    problems = ct.check_domain(domain)
    assert len(problems) == 1
    assert _order(problems) == problems
    assert "capital_goods_adjustment" in problems[0]


def test_an_order_backed_domain_with_no_register_at_all_is_flagged(tmp_path):
    """The corpus shape this check exists for: 15 of the 16 order-backed
    domains carry NO `deferred_set` in their manifest, so every exclusion the
    operator declared is unrecorded. An implementation that skips a domain with
    an empty register is silent on all 15 while still passing every other test
    here — the drift would be invisible in exactly the population that has it.
    No register is "every exclusion missing", not "nothing to compare"."""
    domain = _with_order(_domain(tmp_path, parameters=PARAMETERS,
                                 manifest="id: fixture/domain\n"),
                         order=ORDER + UNREGISTERED)
    problems = _order(ct.check_domain(domain))
    assert len(problems) == 2
    assert any("derogation" in p for p in problems)
    assert any("capital_goods_adjustment" in p for p in problems)


def test_the_order_lookup_walks_up_to_the_corpus_root(tmp_path):
    """`_orders/` is at the root, not in the domain's parent — asserted here so
    a parent-directory implementation cannot pass by accident."""
    domain = _with_order(_domain(tmp_path, parameters=PARAMETERS),
                         order=ORDER + UNREGISTERED)
    assert not os.path.isdir(os.path.join(os.path.dirname(domain), "_orders"))
    assert len(_order(ct.check_domain(domain))) == 1


def test_an_order_for_another_domain_is_not_applied_however_it_is_named(
        tmp_path):
    """Matching is on the order's `domain:` FIELD. Here the filename is the
    domain's own and the field is somebody else's: a filename-matching lookup
    would apply this order and flag an exclusion nobody ordered."""
    order = ORDER.replace("domain: fixture/domain",
                          "domain: some/other/domain") + UNREGISTERED
    domain = _with_order(_domain(tmp_path, parameters=PARAMETERS),
                         order=order, name="fixture-domain.yaml")
    assert ct.check_domain(domain) == []


def test_hyphens_and_underscores_name_the_same_domain(tmp_path):
    """Orders spell the id with hyphens, manifests with underscores. Without
    the normalisation the order silently stops applying — the check goes quiet
    rather than loud, which is the direction that hides drift."""
    domain = _with_order(
        _domain(tmp_path, parameters=PARAMETERS,
                manifest=MANIFEST.replace("id: fixture/domain",
                                          "id: fixture/domain_x")),
        order=ORDER.replace("domain: fixture/domain",
                            "domain: fixture/domain-x") + UNREGISTERED)
    problems = _order(ct.check_domain(domain))
    assert len(problems) == 1 and "capital_goods_adjustment" in problems[0]


def test_a_deferral_beyond_the_order_is_labelled_not_failed(tmp_path):
    """The register COMPLETES the order — vat carries 7 entries against its
    order's 2 — so an expansion cannot be a hard fail. The label is asserted
    too: without it this test would pass on a domain whose extra entry was
    quietly counted as authorized."""
    manifest = MANIFEST + ("  - what: art_2b_supply\n"
                           f'    units: ["{POINT_B}"]\n'
                           '    reason: "Art 2(b) services deferred."\n'
                           '    consequence: "Callers must model the supply of '
                           'services themselves."\n')
    domain = _with_order(_domain(tmp_path, kernel=KERNEL_WITHOUT_ART_2B,
                                 manifest=manifest, parameters=PARAMETERS))
    assert _ledger.build(domain)["deferral_labels"] == {
        "derogation": "authorized", "art_2b_supply": "expansion"}
    assert ct.check_domain(domain) == []


def test_an_order_that_defers_nothing_authorizes_nothing_and_flags_nothing(
        tmp_path):
    """`has_order` true with an empty `deferred_set` is a real state: a
    contract that authorizes no exclusion. It must not be read as "no order"
    and must not make the register's own entries into problems."""
    domain = _with_order(_domain(tmp_path, parameters=PARAMETERS),
                         order="domain: fixture/domain\n")
    built = _ledger.build(domain)
    assert built["has_order"] is True
    assert built["deferral_labels"] == {"derogation": "expansion"}
    assert ct.check_domain(domain) == []


def test_an_untraced_domain_is_not_reddened_by_the_order_check(tmp_path):
    """THE RATCHET'S BOUNDARY, and the reason §6 sits behind the untraced early
    return even though it needs no document. 15 of the 16 order-backed corpus
    domains have an order, no register and no `sources/`; running this check on
    them would redden 15 unenforced domains the day the layer lands, which is
    the disturbance the three states exist to prevent. A domain with no pinned
    statute has not entered the campaign and is not yet expected to register
    anything. The cost — the check is latent on today's corpus, including
    `eu/vat/pro_rata_deduction` — is recorded in `check_domain`."""
    domain = _with_order(_domain(tmp_path, sources=False),
                         order=ORDER + UNREGISTERED)
    assert not ct.is_traced(_ledger.build(domain))
    assert ct.check_domain(domain) == []


# ── never raises on domain content: the unhashable `what` ────────────────────
#
# `check_domain` promises problem STRINGS, never an exception, and the promise
# is what keeps an undeclared domain undisturbed by this layer: a traceback is
# a non-zero exit for a domain that never opted in, i.e. a ratchet bypass in
# the fail-closed direction. `what: [a, b]` is already a ledger problem and
# `ledger._deferrals` KEEPS the entry so the defect stays visible in the
# register — which is precisely why every consumer downstream meets the list.

#: A register entry whose `what` is a LIST. Appended to the clean manifest so
#: the domain differs from a green one in this entry alone.
UNHASHABLE_WHAT = ("  - what: [a, b]\n"
                   f'    units: ["{POINT_A}"]\n'
                   '    reason: "a what that is not a string"\n'
                   '    consequence: "the caller handles it"\n')


def test_an_unhashable_what_does_not_raise_out_of_build_document(tmp_path):
    """`labels.get(entry.get("what"))` on a list is `TypeError`, out of the
    emitter, for a domain the register deliberately keeps the entry of."""
    domain = _domain(tmp_path, manifest=MANIFEST + UNHASHABLE_WHAT,
                     parameters=PARAMETERS)
    document = ct.build_document(domain)
    labels = [entry["label"] for entry in document["deferrals"]]
    # No label, because a `what` that is not a string cannot equal any entry of
    # an order's `deferred_set` — nothing authorized it.
    assert None in labels


def test_an_unhashable_what_does_not_raise_out_of_check_domain(tmp_path):
    """The order check builds a SET of the registered `what`s, which is the
    second site. It needs an order, so this domain carries one."""
    domain = _with_order(_domain(tmp_path, manifest=MANIFEST + UNHASHABLE_WHAT,
                                 parameters=PARAMETERS))
    problems = ct.check_domain(domain)
    # The malformed entry is REPORTED, in the ledger's own words — the fix is
    # not to fall silent about it.
    assert any("what" in problem for problem in problems)


def test_an_unhashable_what_registers_nothing_for_the_order_check(tmp_path):
    """Dropping it must not accidentally SATISFY an order entry. A list
    registers no exclusion, so an order that declares one still reports it as
    absent from the register."""
    domain = _with_order(
        _domain(tmp_path, manifest=MANIFEST + UNHASHABLE_WHAT,
                parameters=PARAMETERS),
        order=ORDER + UNREGISTERED)
    assert len(_order(ct.check_domain(domain))) == 1


def test_an_unhashable_what_does_not_raise_out_of_main(tmp_path):
    """The hook's own entry point: a traceback here is a non-zero exit for a
    domain that never opted in."""
    assert ct.main([_domain(tmp_path, manifest=MANIFEST + UNHASHABLE_WHAT,
                            parameters=PARAMETERS)]) == 0


def test_the_boilerplate_advisory_is_never_a_problem(tmp_path, capsys):
    """"Defer everything" looks like one reason repeated. It is advisory: the
    gate cannot judge whether a deferral is sound, and a check that claimed to
    would manufacture the false green this layer exists to remove. The smell is
    asserted present so the test cannot pass by producing no advisory at all."""
    manifest = "id: fixture/domain\ndeferred_set:\n"
    for index, unit_id in enumerate([POINT_A, POINT_B, DEROGATION]):
        manifest += (f"  - what: d{index}\n"
                     f'    units: ["{unit_id}"]\n'
                     '    reason: "out of scope"\n'
                     '    consequence: "the caller handles it"\n')
    domain = _domain(tmp_path, kernel=KERNEL_ART_1_AND_4, manifest=manifest,
                     parameters=PARAMETERS)
    assert _ledger.build(domain)["deferral_smells"]
    assert ct.check_domain(domain) == []
    assert ct.main([domain]) == 0
    assert "PROBLEM:" not in capsys.readouterr().out


# ── the check_citations contract ─────────────────────────────────────────────

def test_main_prints_problems_and_returns_1_on_an_enforced_domain(
        tmp_path, capsys):
    """The exit code is the RATCHET's, so the domain has to declare itself:
    `check_citations`' shape (problems printed, non-zero exit) is what an
    enforced domain gets, and only an enforced domain.

    The gap here is a COVERAGE gap. It was an annotation one until 2026-09-05,
    when the ruling took T1 out of the exit code; the shape this test is about
    -- printed problems, non-zero exit, enforced domains only -- is unchanged,
    and `test_an_enforced_domain_does_not_block_on_annotation_debt_alone`
    holds the other half."""
    rc = ct.main([_domain(tmp_path, kernel=KERNEL_COVERAGE_GAP,
                          manifest=MANIFEST_ENFORCED)])
    out = capsys.readouterr().out
    assert rc == 1
    assert "PROBLEM:" in out and "1 problem(s)" in out


def test_main_prints_ok_and_returns_0(tmp_path, capsys):
    rc = ct.main([_domain(tmp_path, parameters=PARAMETERS)])
    out = capsys.readouterr().out
    assert rc == 0
    assert "OK" in out and "PROBLEM:" not in out


def test_main_prints_one_line_per_problem(tmp_path, capsys):
    kernel = KERNEL + ("\nbare(P) <- (\n    prof_get(P, z, Z)\n)\n"
                       "\nalso_bare(P) <- (\n    prof_get(P, y, Y)\n)\n")
    ct.main([_domain(tmp_path, kernel=kernel)])
    out = capsys.readouterr().out
    assert len([ln for ln in out.splitlines() if ln.startswith("PROBLEM:")]) == 2
    assert "2 problem(s)" in out


# ── the ratchet (spec §5) ────────────────────────────────────────────────────
#
# The property, stated once: THE RATCHET GOVERNS THE EXIT CODE AND NOTHING
# ELSE. The same domain, with and without one manifest line, must run the same
# checks and print the same problems; only whether it blocks may differ. That is
# what lets this land mid-campaign without disturbing a single baseline — 0 of
# the 60 tracked manifests declare `provision_tracking:` today, so every one of them
# must be untouched by everything below.

#: A clean traced domain with ONE T1 failure added. Used on both sides of every
#: ratchet test so the two runs differ only in the manifest.
KERNEL_ONE_GAP = KERNEL + "\nbare(P) <- (\n    prof_get(P, z, Z)\n)\n"

#: The same domain with a COVERAGE gap rather than an annotation one: drop the
#: art_2b clause and `point_b` is neither formalized nor deferred. That is what
#: the ratchet is for, and it is a different fixture from KERNEL_ONE_GAP on
#: purpose -- the two families now reach different exit codes.
KERNEL_COVERAGE_GAP = KERNEL.replace(
    "\nsupply_b(P) <- (\n    implements(art_2b),\n    prof_get(P, t, T)\n)\n", "")


def test_an_undeclared_domain_with_problems_exits_zero(tmp_path, capsys):
    """THE PROPERTY THE CAMPAIGN DEPENDS ON. A domain that never opted in may
    not be reddened by this layer landing, whatever it is doing wrong."""
    rc = ct.main([_domain(tmp_path, kernel=KERNEL_ONE_GAP)])
    assert rc == 0
    assert "PROBLEM:" in capsys.readouterr().out


def test_an_undeclared_domain_still_prints_every_problem(tmp_path, capsys):
    """Exit 0 is NOT silence. Spec §5 is "checks still run and print"; a
    ratchet implemented by skipping the checks would make the campaign's own
    progress unmeasurable — nobody could see what is left to fix."""
    ct.main([_domain(tmp_path, kernel=KERNEL_ONE_GAP)])
    unenforced = capsys.readouterr().out
    ct.main([_domain(tmp_path, kernel=KERNEL_ONE_GAP,
                     manifest=MANIFEST_ENFORCED)])
    enforced = capsys.readouterr().out
    problems = [ln for ln in unenforced.splitlines()
                if ln.startswith("PROBLEM:")]
    assert problems == [ln for ln in enforced.splitlines()
                        if ln.startswith("PROBLEM:")]
    assert len(problems) == 1


def test_the_undeclared_path_says_why_it_did_not_block(tmp_path, capsys):
    """A reader seeing PROBLEM lines and a zero exit must be told which of the
    two is the mistake, or the next author reads it as "these were waived"."""
    ct.main([_domain(tmp_path, kernel=KERNEL_ONE_GAP)])
    out = capsys.readouterr().out
    assert "not enforced" in out
    assert "provision_tracking: enforced" in out      # and how to arm it


def test_an_enforced_domain_with_a_coverage_problem_exits_one(tmp_path):
    assert ct.main([_domain(tmp_path, kernel=KERNEL_COVERAGE_GAP,
                            manifest=MANIFEST_ENFORCED)]) == 1


def test_an_enforced_domain_does_not_block_on_annotation_debt_alone(
        tmp_path, capsys):
    """T1 IS DEBT, REPORTED NOT GATED (ruling, 2026-09-05).

    The campaign's bar is coverage -- every unit formalized or deferred -- and
    it counts an unannotated clause as a backlog item beside the verdict, not
    inside it. Blocking on T1 made the bar unreachable: a domain could be
    fully accounted (T2/T3/T5/T6/§6 all zero) and still be unable to arm,
    which is why 0 of 76 manifests carried `enforced` the day this changed."""
    rc = ct.main([_domain(tmp_path, kernel=KERNEL_ONE_GAP,
                          manifest=MANIFEST_ENFORCED)])
    out = capsys.readouterr().out
    assert rc == 0
    assert "PROBLEM: T1" in out          # still printed in full, never swallowed
    assert "annotation debt" in out      # and the zero exit is explained


def test_annotation_debt_does_not_hide_a_coverage_problem_beside_it(tmp_path):
    """The filter may not swallow its neighbours: a domain with both still
    blocks, on the coverage half."""
    kernel = KERNEL_COVERAGE_GAP + "\nbare(P) <- (\n    prof_get(P, z, Z)\n)\n"
    assert ct.main([_domain(tmp_path, kernel=kernel,
                            manifest=MANIFEST_ENFORCED)]) == 1


def test_blocking_problems_keeps_reader_problems(tmp_path):
    """A reader problem (an unreadable file, a pin mismatch) blocks whatever
    else is in the list -- it is positional, not tagged, and a tag-based
    filter that lost it would let a broken pin score as clean."""
    built = {"problems": ["sources/x.xml: sha mismatch"]}
    scored = built["problems"] + ["T1 k.seam:1: no cite", "T2 unit: unaccounted"]
    assert ct.blocking_problems(scored, built) == [
        "sources/x.xml: sha mismatch", "T2 unit: unaccounted"]


def test_an_enforced_clean_domain_exits_zero(tmp_path, capsys):
    """Enforcement is not a hazard for a domain that is actually clean."""
    rc = ct.main([_domain(tmp_path, parameters=PARAMETERS,
                          manifest=MANIFEST_ENFORCED)])
    assert rc == 0 and "OK" in capsys.readouterr().out


def test_only_the_word_enforced_arms_the_ratchet(tmp_path, capsys):
    """`provision_tracking: yes` is a domain that believes it blocks and does not.
    Treating any truthy value as enforcement would let a typo turn a reporting
    domain into a blocking one; treating it SILENTLY as unenforced is the
    opposite mistake. It exits 0 and says the value is not the word."""
    manifest = MANIFEST + "provision_tracking: yes\n"
    rc = ct.main([_domain(tmp_path, kernel=KERNEL_ONE_GAP, manifest=manifest)])
    out = capsys.readouterr().out
    assert rc == 0
    assert "not enforced" in out and "enforced" in out


def test_an_untraced_domain_with_problems_exits_zero_and_says_not_traced(
        tmp_path, capsys):
    """The third state. 60 of 60 domains on day one, several of them with
    unreadable-to-this-layer content, and not one may block."""
    rc = ct.main([_domain(tmp_path, kernel="this is not ) clausal ( at all\n",
                          citations=None, sources=False)])
    out = capsys.readouterr().out
    assert rc == 0
    assert "not traced" in out and "PROBLEM:" in out


def test_an_untraced_enforced_domain_blocks_on_a_reader_problem(tmp_path):
    """"Not traced" is not a blanket exemption from the exit code: it means the
    coverage checks have nothing to score, not that a domain which explicitly
    opted in may ship an unparseable file. The ratchet governs PROBLEMS, and a
    reader problem is a problem in every state."""
    domain = _domain(tmp_path, kernel="this is not ) clausal ( at all\n",
                     citations=None, sources=False,
                     manifest="id: fixture/domain\nprovision_tracking: enforced\n")
    assert ct.main([domain]) == 1


def test_an_advisory_never_changes_the_exit_code_even_when_enforced(
        tmp_path, capsys):
    """The gate cannot judge whether a deferral is sound, so the boilerplate
    smell is printed and never scored. The advisory is asserted PRESENT so the
    test cannot pass by producing none."""
    manifest = "id: fixture/domain\nprovision_tracking: enforced\ndeferred_set:\n"
    for index, unit_id in enumerate([POINT_A, POINT_B, DEROGATION]):
        manifest += (f"  - what: d{index}\n"
                     f'    units: ["{unit_id}"]\n'
                     '    reason: "out of scope"\n'
                     '    consequence: "the caller handles it"\n')
    domain = _domain(tmp_path, kernel=KERNEL_ART_1_AND_4, manifest=manifest,
                     parameters=PARAMETERS)
    rc = ct.main([domain])
    out = capsys.readouterr().out
    # The SMELL, not any advisory: the deferral-rate line also prints here, so
    # a bare "ADVISORY:" would pass with the smell gone.
    assert "share one reason" in out
    assert "PROBLEM:" not in out
    assert rc == 0


def test_the_deferral_rate_is_printed_and_never_changes_the_exit_code(
        tmp_path, capsys):
    """The deferral-rate monitor (todo `defer-unit-is-the-cheapest-path-to-a-
    false-green`): deferred over accounted units, printed on an ENFORCED
    domain whose three deferrals are all it has beyond its formalized units,
    and the exit code is the one the problems alone decide."""
    manifest = "id: fixture/domain\nprovision_tracking: enforced\ndeferred_set:\n"
    for index, unit_id in enumerate([POINT_A, POINT_B, DEROGATION]):
        manifest += (f"  - what: d{index}\n"
                     f'    units: ["{unit_id}"]\n'
                     f'    reason: "reason {index}"\n'
                     '    consequence: "the caller handles it"\n')
    domain = _domain(tmp_path, kernel=KERNEL_ART_1_AND_4, manifest=manifest,
                     parameters=PARAMETERS)
    built = _ledger.build(domain)
    states = list(ct.unit_states(built).values())
    deferred = sum(s in (ct.AMBER, ct.GREY) for s in states)
    accounted = deferred + states.count(ct.GREEN)
    assert deferred == 3 and accounted > deferred
    problems = ct.check_domain(domain)
    rc = ct.main([domain])
    out = capsys.readouterr().out
    line = next(l for l in out.splitlines() if "deferral rate" in l)
    assert line.startswith("ADVISORY: ")
    assert f"{deferred}/{accounted} accounted units deferred" in line
    assert not any("deferral rate" in p for p in problems)
    assert rc == (1 if ct.blocking_problems(problems, built) else 0)
    assert "deferral rate" not in str(ct.build_document(domain, built))


def test_the_deferral_rate_is_silent_where_it_would_be_0_over_0(tmp_path):
    """Untraced: no units, no rate -- a "0/0 (0%)" would read as audited."""
    domain = _domain(tmp_path, sources=False)
    assert ct.deferral_rate(_ledger.build(domain)) is None


# ── the ratchet's own input: an unreadable manifest ─────────────────────────
#
# `provision_tracking` reads None both for a manifest that never declared the field
# and for one that will not parse, so the ratchet used to fail OPEN: an enforced
# domain whose manifest gained a syntax error printed its real problems and
# exited 0, and one commit that both broke the manifest and dropped a deferral
# sailed through. Unknown is not "not enforced".

#: The enforced domain's manifest, broken. `provision_tracking: enforced` is in there
#: — and unreachable, which is the whole hazard.
MANIFEST_BROKEN = MANIFEST_ENFORCED + "deferred_set: [unclosed\n"


def test_an_enforced_domain_whose_manifest_broke_still_blocks(tmp_path):
    """THE FAIL-OPEN. The domain has real problems and a manifest nobody can
    read; exiting 0 there is the ratchet disarmed by the file that arms it."""
    domain = _domain(tmp_path, kernel=KERNEL_ONE_GAP,
                     manifest=MANIFEST_BROKEN, parameters=PARAMETERS)
    assert ct.main([domain]) == 1


def test_an_undeclared_domain_whose_manifest_broke_also_blocks(tmp_path):
    """Because it cannot be known to be undeclared. The manifest that would say
    so is the unreadable one, so "did not opt in" is an assumption here rather
    than a fact — and the safe reading of an unknown declaration on a domain
    that already has problems is to block."""
    domain = _domain(tmp_path, kernel=KERNEL_ONE_GAP,
                     manifest="id: [unclosed\n", parameters=PARAMETERS)
    assert ct.main([domain]) == 1


def test_the_unreadable_manifest_path_says_the_declaration_is_unknown(
        tmp_path, capsys):
    """It must NOT print the not-enforced note: that note tells a reader the
    problems were reported and waived, which is the opposite of what happened,
    and it names a remedy (add `provision_tracking: enforced`) that is not the fix."""
    ct.main([_domain(tmp_path, kernel=KERNEL_ONE_GAP,
                     manifest=MANIFEST_BROKEN, parameters=PARAMETERS)])
    out = capsys.readouterr().out
    assert "UNKNOWN" in out and "manifest.yaml could not be read" in out
    assert ct.NOT_ENFORCED_NOTE not in out


def test_a_readable_manifest_never_takes_the_unknown_path(tmp_path, capsys):
    """The pair, and the campaign-safety half: 60 of 60 tracked manifests parse
    and declare nothing, so a checker that blocked on all of them would redden
    the corpus wholesale."""
    rc = ct.main([_domain(tmp_path, kernel=KERNEL_ONE_GAP)])
    out = capsys.readouterr().out
    assert rc == 0
    assert ct.NOT_ENFORCED_NOTE in out


def test_enforcement_unknown_is_the_ledger_bit_not_a_second_read(tmp_path):
    """Read off the same ledger the run scored, like `is_enforced` — two reads
    of one file can disagree about the very thing that decides blocking."""
    built = _ledger.build(_domain(tmp_path))
    assert ct.enforcement_unknown(built) is False
    built["manifest_unreadable"] = True
    assert ct.enforcement_unknown(built) is True


def test_is_enforced_reads_the_ledger_it_was_given(tmp_path):
    """One manifest read per run. Two reads can disagree — and the laxer of
    them must not be the one that decides whether a domain blocks."""
    domain = _domain(tmp_path, manifest=MANIFEST_ENFORCED)
    built = _ledger.build(domain)
    assert ct.is_enforced(domain, built) is True
    built["provision_tracking"] = None
    assert ct.is_enforced(domain, built) is False


def test_is_enforced_is_callable_with_the_domain_alone(tmp_path):
    assert ct.is_enforced(_domain(tmp_path)) is False
    assert ct.is_enforced(_domain(tmp_path, manifest=MANIFEST_ENFORCED)) is True


# ── the headline ─────────────────────────────────────────────────────────────

def test_the_headline_is_printed_on_every_run(tmp_path, capsys):
    """Including a clean one. A bare `OK` tells a reviewer nothing about how
    the domain got there."""
    ct.main([_domain(tmp_path, parameters=PARAMETERS)])
    assert "8 units:" in capsys.readouterr().out


def test_the_headline_states_the_whole_split(tmp_path):
    """The fixture: 8 units, 7 cited, 1 deferred with no order behind it."""
    line = ct.headline(_ledger.build(_domain(tmp_path, parameters=PARAMETERS)))
    assert line == ("8 units: 7 formalized, 1 deferred (0 authorized, "
                    "1 expansion), 0 unaccounted; 0 predicate(s) no_statute")


def test_the_headline_numbers_partition_the_document(tmp_path):
    """Read as one denomination or it cannot be read at a glance: every number
    before the semicolon counts units, and together they are the document."""
    domain = _with_order(_four_colour_domain(tmp_path))
    built = _ledger.build(domain)
    line = ct.headline(built)
    counts = [int(n) for n in re.findall(r"(\d+) (?:units|formalized|deferred|"
                                         r"unaccounted)", line)]
    total, formalized, deferred, unaccounted = counts
    assert total == len(built["doc_units"]) == 8
    assert formalized + deferred + unaccounted == total


def test_the_headline_labels_a_deferred_unit_by_its_order_authorization(
        tmp_path):
    """AMBER vs GREY is the whole of §6 item 2 in the headline: a reviewer must
    see how much of the statute was excluded BEYOND what was ordered."""
    domain = _with_order(_domain(tmp_path, parameters=PARAMETERS))
    assert "(1 authorized, 0 expansion)" in ct.headline(_ledger.build(domain))


def test_the_headline_counts_exemptions_per_predicate_not_per_clause(tmp_path):
    """ONE `no_statute/3` fact exempts a PREDICATE, however many clauses that
    predicate has. Counting clauses reports a number nobody declared, and it
    grows when a predicate is merely split across more rules."""
    kernel = KERNEL + (
        '\nno_statute("build_profile", 2, "computation_helper"),\n'
        "\nbuild_profile(P, Q) <- (\n    prof_get(P, z, Q)\n)\n"
        "\nbuild_profile(P, Q) <- (\n    prof_get(P, y, Q)\n)\n")
    built = _ledger.build(_domain(tmp_path, kernel=kernel))
    assert len([c for c in built["clauses"]
                if c.functor == "build_profile"]) == 2
    assert "1 predicate(s) no_statute" in ct.headline(built)


def test_an_untraced_domain_headline_says_so_plainly(tmp_path):
    line = ct.headline(_ledger.build(_domain(tmp_path, sources=False)))
    assert "not traced" in line
    assert "units:" not in line


def test_the_headline_names_a_contradiction_rather_than_absorbing_it(tmp_path):
    """A unit both covered and deferred is a T2 failure. Counting it as
    formalized would let a contradicted domain read as fully covered — the
    ledger refuses to pick a winner, and so does the headline."""
    manifest = MANIFEST + ("  - what: overlap\n"
                           f'    units: ["{P1}"]\n'
                           '    reason: "also deferred"\n'
                           '    consequence: "contradictory on purpose"\n')
    line = ct.headline(_ledger.build(_domain(tmp_path, manifest=manifest)))
    assert "6 formalized" in line and "both covered and deferred" in line


# ── `--emit`: the artifact a renderer reads (spec §8) ────────────────────────
#
# The bar is SUFFICIENCY, not presence: spec §8 makes provisions.yaml the only
# input a renderer reads, so the four-colour report and §6's "verbatim adjacent
# to the deferral reason" mitigation must be buildable from this file and
# nothing else. The reconstruction below is the demonstration — it reads the
# emitted document and never touches the domain.

#: The `what` of the expansion entry the four-colour domain adds.
EXPANSION_WHAT = "art_2a_supply"


def _four_colour_domain(tmp_path):
    """A domain carrying all four states at once: Art 1 and Art 4 formalized,
    the derogation deferred (order-authorized, once an order is written),
    Art 2(a) deferred as an expansion, Art 2(b) left unaccounted."""
    manifest = MANIFEST + (f"  - what: {EXPANSION_WHAT}\n"
                           f'    units: ["{POINT_A}"]\n'
                           '    reason: "Art 2(a) goods deferred."\n'
                           '    consequence: "Callers must model the supply of '
                           'goods themselves."\n')
    return _domain(tmp_path, kernel=KERNEL_ART_1_AND_4, manifest=manifest,
                   parameters=PARAMETERS)


def _emit(domain, tmp_path, name="provisions.yaml"):
    import yaml as _yaml
    out_path = os.path.join(str(tmp_path), name)
    ct.emit(domain, out_path)
    with open(out_path, encoding="utf-8") as handle:
        return _yaml.safe_load(handle), out_path


def _four_colour_from_the_file_alone(document):
    """A renderer with no other input. Reads ONLY the emitted document — no
    manifest, no order, no pinned XML, no ledger."""
    labels = {entry["what"]: entry["label"] for entry in document["deferrals"]}
    covered, deferred = set(document["covered"]), set(document["deferred"])
    colours = {}
    for unit in document["units"]:
        unit_id = unit["id"]
        if unit_id in covered and unit_id in deferred:
            colours[unit_id] = "CONTRADICTED"
        elif unit_id in covered:
            colours[unit_id] = "GREEN"
        elif unit_id in deferred:
            colours[unit_id] = ("AMBER" if any(
                labels.get(what) == "authorized"
                for what in unit.get("deferred_by", [])) else "GREY")
        else:
            colours[unit_id] = "RED"
    return colours


def test_the_emitted_file_alone_reconstructs_the_four_colour_partition(
        tmp_path):
    """THE SUFFICIENCY DEMONSTRATION. The expectation is written out by hand
    from the fixture rather than read back from the ledger, so this cannot pass
    by comparing the file to itself."""
    document, _ = _emit(_with_order(_four_colour_domain(tmp_path)), tmp_path)
    assert _four_colour_from_the_file_alone(document) == {
        P1: "GREEN", P2: "GREEN",
        POINT_A: "GREY",            # deferred beyond the order
        POINT_B: "RED",             # unaccounted
        DEROGATION: "AMBER",        # deferred, and the order authorized it
        CHAPEAU: "GREEN", CHAPEAU_A: "GREEN", CHAPEAU_B: "GREEN"}


def test_the_emitted_per_unit_state_agrees_with_the_reconstruction(tmp_path):
    """The file states each unit's colour AND carries the lists it was derived
    from; if those two could disagree the artifact would contradict itself."""
    document, _ = _emit(_with_order(_four_colour_domain(tmp_path)), tmp_path)
    assert {unit["id"]: unit["state"] for unit in document["units"]} == \
        _four_colour_from_the_file_alone(document)


def test_the_emitted_units_carry_their_text(tmp_path):
    """§6's mitigation against the narrowly-plausible deferral: the report
    places the provision's own words next to the claim made about them. Without
    the text in this file that report cannot be built, and a reviewer is left
    comparing a summary to a summary."""
    document, _ = _emit(_four_colour_domain(tmp_path), tmp_path)
    texts = {unit["id"]: unit["text"] for unit in document["units"]}
    assert texts[P1] == P1_TEXT
    assert texts[POINT_A] == POINT_A_TEXT
    assert all(unit["text"].strip() for unit in document["units"])


def test_the_emitted_units_keep_document_order(tmp_path):
    """A report reads down the statute. Sorted ids interleave Article 10 with
    Article 1."""
    domain = _four_colour_domain(tmp_path)
    document, _ = _emit(domain, tmp_path)
    assert [unit["id"] for unit in document["units"]] == \
        [unit["id"] for unit in _ledger.build(domain)["doc_units"]]


def test_the_emitted_deferrals_carry_reason_consequence_and_label(tmp_path):
    """The register is what a reviewer reads, and the three fields answer
    different questions: what was excluded, why, and what breaks for a caller
    who relies on the domain anyway. The label is what bounds the review to the
    expansions."""
    document, _ = _emit(_with_order(_four_colour_domain(tmp_path)), tmp_path)
    by_what = {entry["what"]: entry for entry in document["deferrals"]}
    assert by_what["derogation"]["label"] == "authorized"
    assert by_what[EXPANSION_WHAT]["label"] == "expansion"
    assert by_what[EXPANSION_WHAT]["units"] == [POINT_A]
    assert "Art 2(a) goods deferred." in by_what[EXPANSION_WHAT]["reason"]
    assert "model the supply of goods" in by_what[EXPANSION_WHAT]["consequence"]


def test_the_emitted_document_links_a_unit_to_the_entry_deferring_it(tmp_path):
    """The join §6's mitigation needs: without it a renderer can print the unit
    text and the deferral reasons but cannot put the right ones side by side."""
    document, _ = _emit(_four_colour_domain(tmp_path), tmp_path)
    by_id = {unit["id"]: unit for unit in document["units"]}
    assert by_id[POINT_A]["deferred_by"] == [EXPANSION_WHAT]
    assert "deferred_by" not in by_id[P1]


def test_the_emitted_exemption_table_is_keyed_by_predicate(tmp_path):
    """`no_statute` is the one bare assertion the enforced path allows, so an
    artifact that omitted it would hide exactly what it exists to show.
    `(functor, arity)` does not YAML-serialise; the key is the predicate
    indicator the corpus already writes, `functor/arity`, and it round-trips."""
    kernel = KERNEL + ('\nno_statute("build_profile", 2, "computation_helper"),\n'
                       "\nbuild_profile(P, Q) <- (\n    prof_get(P, z, Q)\n)\n")
    document, _ = _emit(_domain(tmp_path, kernel=kernel), tmp_path)
    assert document["no_statute"] == {"build_profile/2": "computation_helper"}
    assert _ledger.parse_no_statute_key("build_profile/2") == ("build_profile", 2)


def test_the_emitted_document_carries_the_headline(tmp_path):
    domain = _four_colour_domain(tmp_path)
    document, _ = _emit(domain, tmp_path)
    assert document["headline"] == ct.headline(_ledger.build(domain))


def test_the_emitted_document_states_the_three_states(tmp_path):
    """A renderer must not have to infer "not traced" from an empty unit
    list — the difference between untraced and audited-clean is the whole
    point of the third state."""
    traced, _ = _emit(_domain(tmp_path, manifest=MANIFEST_ENFORCED), tmp_path)
    assert traced["traced"] is True and traced["enforced"] is True
    # A SEPARATE root: `_domain` never removes a `sources/` an earlier call
    # copied, so re-using this one would silently hand back a traced domain.
    elsewhere = os.path.join(str(tmp_path), "untraced-root")
    untraced, _ = _emit(_domain(elsewhere, sources=False), tmp_path,
                        name="untraced.yaml")
    assert untraced["traced"] is False and untraced["enforced"] is False
    assert untraced["units"] == []
    assert "not traced" in untraced["headline"]


def test_emit_scores_the_ledger_it_was_given(tmp_path):
    """EMIT AND CHECK MAY NOT DIVERGE. An emit that rebuilt the ledger for
    itself could describe a domain the gate never scored — this layer
    reproducing its own failure mode in miniature. The ledger handed in carries
    a unit the document does not, and the emitted file must show it."""
    import yaml as _yaml
    domain = _domain(tmp_path, parameters=PARAMETERS)
    built = _ledger.build(domain)
    built["doc_units"] = built["doc_units"] + [
        units.as_doc_unit(units.Unit(
            id="FIXTURE#art_9__para_1", eid="art_9__para_1",
            runs=(units.Run(pos=99, text="Invented for this test."),)))]
    built["unaccounted"] = ["FIXTURE#art_9__para_1"]
    out_path = os.path.join(str(tmp_path), "handed-in.yaml")
    ct.emit(domain, out_path, built)
    with open(out_path, encoding="utf-8") as handle:
        document = _yaml.safe_load(handle)
    assert "FIXTURE#art_9__para_1" in [u["id"] for u in document["units"]]
    assert document["problem_count"] == len(ct.check_domain(domain, built))
    assert document["problem_count"] == 1       # the T2 the same ledger scores


def test_the_emitted_problem_count_is_the_scored_one(tmp_path):
    """The file carries the VERDICT, so it cannot claim a cleanliness the gate
    did not score. It carries no problem STRINGS: a YAML parse failure quotes
    the stream by absolute path, and this artifact is committed."""
    domain = _domain(tmp_path, kernel=KERNEL_ONE_GAP)
    document, _ = _emit(domain, tmp_path)
    assert document["problem_count"] == len(ct.check_domain(domain)) == 1


def test_emit_is_byte_identical_across_runs(tmp_path):
    """Committed artifact: a re-emit that reordered a mapping or a list would
    put a spurious diff in every commit and make the file unreviewable."""
    domain = _with_order(_four_colour_domain(tmp_path))
    first = os.path.join(str(tmp_path), "first.yaml")
    second = os.path.join(str(tmp_path), "second.yaml")
    ct.emit(domain, first)
    ct.emit(domain, second)
    with open(first, "rb") as a, open(second, "rb") as b:
        assert a.read() == b.read()


def test_a_unit_deferred_by_several_entries_lists_them_sorted(tmp_path):
    """The one place a SET reaches the emitted file. A set of strings iterates
    differently under a different hash seed, so an unsorted list here makes the
    committed artifact depend on which machine ran the tool — and the
    byte-identity tests cannot see it unless some unit is deferred more than
    once, which is why this case is built explicitly. Six entries, so a mutant
    cannot pass on a two-element coincidence."""
    whats = ["d_zulu", "d_papa", "d_mike", "d_kilo", "d_bravo", "d_alfa"]
    manifest = "id: fixture/domain\ndeferred_set:\n"
    for what in whats:
        manifest += (f"  - what: {what}\n"
                     f'    units: ["{DEROGATION}"]\n'
                     f'    reason: "{what} defers Art 3."\n'
                     f'    consequence: "callers handle Art 3 for {what}."\n')
    document, _ = _emit(_domain(tmp_path, manifest=manifest), tmp_path)
    by_id = {unit["id"]: unit for unit in document["units"]}
    assert by_id[DEROGATION]["deferred_by"] == sorted(whats)


def test_emit_is_byte_identical_under_a_different_hash_seed(tmp_path):
    """ACROSS PROCESSES, because that is the only place a set's iteration order
    can be seen to move. Two emits inside one interpreter share a hash seed and
    would agree even if the emitter iterated sets, so the in-process test above
    cannot catch this class at all — and the file is committed, so a set order
    leaking into it means a diff that depends on which machine ran the tool."""
    import subprocess
    import sys
    domain = _with_order(_four_colour_domain(tmp_path))
    written = []
    for seed in ("0", "1"):
        out_path = os.path.join(str(tmp_path), f"seed-{seed}.yaml")
        env = dict(os.environ,
                   PYTHONHASHSEED=seed,
                   PYTHONDONTWRITEBYTECODE="1",
                   PYTHONPATH=os.pathsep.join(p for p in sys.path if p))
        result = subprocess.run(
            [sys.executable, ct.__file__, domain, "--emit", out_path],
            env=env, capture_output=True, text=True)
        assert result.returncode == 0, result.stderr
        with open(out_path, "rb") as handle:
            written.append(handle.read())
    assert written[0] == written[1]


def test_the_emitted_file_sorts_its_keys(tmp_path):
    """Sorted keys are what makes a diff of this file readable — and what stops
    a dict's insertion order from reaching a committed artifact."""
    domain = _four_colour_domain(tmp_path)
    _, out_path = _emit(domain, tmp_path)
    with open(out_path, encoding="utf-8") as handle:
        keys = [match.group(1) for match in
                (re.match(r"^([a-z_]+):", line) for line in handle) if match]
    assert keys and keys == sorted(keys)


def test_emit_writes_no_timestamp_or_local_path(tmp_path):
    """Two machines emitting the same domain must produce the same bytes. A
    generation time or an absolute path would break that on the first commit."""
    domain = _four_colour_domain(tmp_path)
    _, out_path = _emit(domain, tmp_path)
    with open(out_path, encoding="utf-8") as handle:
        text = handle.read()
    assert str(tmp_path) not in text
    assert not re.search(r"\d{4}-\d{2}-\d{2}T|generated_at|timestamp", text)


# ── `--emit` on the command line ─────────────────────────────────────────────

def test_main_emit_writes_the_file_and_keeps_the_exit_code(tmp_path, capsys):
    """The artifact is written whether or not the domain is clean: one that
    appeared only on green runs would show a renderer nothing but successes."""
    import yaml as _yaml
    domain = _domain(tmp_path, kernel=KERNEL_COVERAGE_GAP,
                     manifest=MANIFEST_ENFORCED)
    out_path = os.path.join(str(tmp_path), "out.yaml")
    rc = ct.main([domain, "--emit", out_path])
    assert rc == 1
    assert "PROBLEM:" in capsys.readouterr().out
    with open(out_path, encoding="utf-8") as handle:
        assert _yaml.safe_load(handle)["problem_count"] == 1


def test_main_emits_the_ledger_of_the_run_that_printed(tmp_path, capsys):
    """One build per run: what the file says and what the run printed are the
    same scoring, not two scorings that happen to agree."""
    import yaml as _yaml
    domain = _four_colour_domain(tmp_path)
    out_path = os.path.join(str(tmp_path), "out.yaml")
    ct.main([domain, "--emit", out_path])
    printed = capsys.readouterr().out.splitlines()[0]
    with open(out_path, encoding="utf-8") as handle:
        assert _yaml.safe_load(handle)["headline"] == printed


def test_main_without_emit_writes_nothing(tmp_path):
    domain = _domain(tmp_path)
    ct.main([domain])
    assert not os.path.exists(os.path.join(domain, "provisions.yaml"))


def test_main_rejects_emit_with_no_path(tmp_path, capsys):
    """A misuse fails LOUD. `--emit` that quietly wrote nothing is how a stale
    artifact outlives the ledger it claims to be."""
    rc = ct.main([_domain(tmp_path), "--emit"])
    assert rc == 2
    assert "usage" in capsys.readouterr().err


# ── §4: the committed artifact may not drift from the ledger ────────────────
#
# `--emit`'s guarantee — the artifact IS the ledger the gate scored — holds at
# the moment of writing and never again. Spec §4 commits the file so coverage
# changes are reviewable in the diff and §8 makes it a renderer's ONLY input, so
# the first post-emit edit on either side (the file, or the domain under it)
# leaves the renderer displaying a coverage claim nobody scored. Nothing read
# the committed file at all before these tests.

def _commit_artifact(domain):
    """Emit into the domain directory, which is where spec §4 commits it."""
    path = os.path.join(domain, ct.ARTIFACT_NAME)
    ct.emit(domain, path)
    return path


def test_a_domain_with_no_committed_artifact_is_untouched(tmp_path):
    """INERT on today's corpus: no domain carries this file, so the check costs
    the 60-domain sweep an `os.path.exists` and nothing else."""
    domain = _domain(tmp_path, parameters=PARAMETERS)
    assert not os.path.exists(os.path.join(domain, ct.ARTIFACT_NAME))
    assert ct.check_domain(domain) == []


def test_a_freshly_emitted_artifact_is_not_stale(tmp_path):
    """Emit then check must be quiet, or the gate would redden every domain the
    moment it started committing the artifact at all."""
    domain = _domain(tmp_path, parameters=PARAMETERS)
    _commit_artifact(domain)
    assert ct.check_domain(domain) == []


def test_an_edited_artifact_is_reported_as_stale(tmp_path):
    """THE POST-EMIT EDIT. The statute's words are the renderer's only source
    for them, so an edited `text` shows a reader a provision the pinned document
    does not contain — and the gate, which reads the live ledger, sees nothing
    wrong."""
    import yaml as _yaml
    domain = _domain(tmp_path, parameters=PARAMETERS)
    path = _commit_artifact(domain)
    with open(path, encoding="utf-8") as handle:
        document = _yaml.safe_load(handle)
    document["units"][0]["text"] = "The rate shall be twenty per cent."
    with open(path, "w", encoding="utf-8") as handle:
        _yaml.safe_dump(document, handle, sort_keys=True, allow_unicode=True)
    problems = ct.check_domain(domain)
    assert len(problems) == 1
    assert problems[0].startswith("§4 ") and "STALE" in problems[0]
    assert "units" in problems[0]           # and it names the key that moved


def test_a_domain_edit_after_the_emit_is_reported_as_stale(tmp_path):
    """The direction that actually happens: nobody edits the artifact, the
    DOMAIN moves under it. One clause edit later the gate rescores from the live
    ledger and the committed file silently keeps the old coverage."""
    domain = _domain(tmp_path, parameters=PARAMETERS)
    _commit_artifact(domain)
    _write(domain, "kernel.seam", KERNEL_ART_1_AND_4)
    problems = ct.check_domain(domain)
    assert any(p.startswith("§4 ") and "STALE" in p for p in problems)


def test_the_gate_does_not_regenerate_the_committed_artifact(tmp_path, capsys):
    """A gate that silently re-emitted would erase the diff §4 commits the file
    for, and land a coverage change unreviewed as a side effect of a check."""
    domain = _domain(tmp_path, parameters=PARAMETERS)
    path = _commit_artifact(domain)
    _write(domain, "kernel.seam", KERNEL_ART_1_AND_4)
    with open(path, "rb") as handle:
        before = handle.read()
    ct.check_domain(domain)
    ct.main([domain])
    with open(path, "rb") as handle:
        assert handle.read() == before


def test_a_stale_artifact_blocks_an_enforced_domain(tmp_path, capsys):
    """It is a PROBLEM, so the ratchet governs it exactly like every other."""
    domain = _domain(tmp_path, parameters=PARAMETERS,
                     manifest=MANIFEST_ENFORCED)
    _commit_artifact(domain)
    _write(domain, ct.ARTIFACT_NAME, "domain_id: something else entirely\n")
    assert ct.main([domain]) == 1
    assert "PROBLEM:" in capsys.readouterr().out


def test_a_stale_artifact_does_not_block_an_undeclared_domain(tmp_path, capsys):
    """The ratchet governs the exit code and nothing else, here too."""
    domain = _domain(tmp_path, parameters=PARAMETERS)
    _commit_artifact(domain)
    _write(domain, ct.ARTIFACT_NAME, "domain_id: something else entirely\n")
    rc = ct.main([domain])
    assert rc == 0
    assert "PROBLEM:" in capsys.readouterr().out


def test_an_unreadable_committed_artifact_is_reported(tmp_path):
    """It cannot be compared and it cannot be rendered; silence would leave a
    renderer's only input broken with nothing said."""
    domain = _domain(tmp_path, parameters=PARAMETERS)
    _write(domain, ct.ARTIFACT_NAME, "units: [unclosed\n")
    problems = ct.check_domain(domain)
    assert len(problems) == 1
    assert problems[0].startswith("§4 ") and "YAML" in problems[0]


def test_an_artifact_that_is_not_a_mapping_is_reported(tmp_path):
    domain = _domain(tmp_path, parameters=PARAMETERS)
    _write(domain, ct.ARTIFACT_NAME, "- just\n- a list\n")
    problems = ct.check_domain(domain)
    assert len(problems) == 1 and problems[0].startswith("§4 ")


def test_the_emitted_problem_count_ignores_the_files_own_drift(tmp_path):
    """`problem_count` counts the SCORED problems, and drift is a statement
    about the file being written — counting it would make the number wrong the
    instant it is written, because a fresh artifact has no drift."""
    domain = _domain(tmp_path, parameters=PARAMETERS)
    path = _commit_artifact(domain)
    _write(domain, ct.ARTIFACT_NAME, "domain_id: stale\n")
    document = ct.emit(domain, path)
    assert document["problem_count"] == 0
    assert ct.check_domain(domain) == []


def test_the_drift_check_runs_on_an_untraced_domain_too(tmp_path):
    """The artifact left behind when a domain's `sources/` goes is the one that
    would lie loudest — it still describes a statute the domain no longer
    pins."""
    domain = _domain(tmp_path, parameters=PARAMETERS)
    _commit_artifact(domain)
    _untrace(domain)
    problems = ct.check_domain(domain)
    assert any(p.startswith("§4 ") and "STALE" in p for p in problems)


def test_an_artifact_with_a_non_string_key_is_reported_not_raised(tmp_path):
    """`check_domain` never raises on domain content, and a committed file is
    domain content — anything may have put anything into it. YAML gives `1: x`
    an int key, and sorting a mixed key set raises TypeError; uncaught, the hook
    turns a would-be problem into a traceback plus a non-zero exit on an
    UNDECLARED domain, which is a ratchet bypass in the fail-closed direction."""
    domain = _domain(tmp_path, parameters=PARAMETERS)
    _write(domain, ct.ARTIFACT_NAME, "1: x\nfoo: bar\n")
    problems = ct.check_domain(domain)
    assert len(problems) == 1
    assert problems[0].startswith("§4 ") and "STALE" in problems[0]
    assert "1" in problems[0] and "foo" in problems[0]   # both keys named


def test_a_mixed_key_artifact_does_not_break_main_on_an_undeclared_domain(
        tmp_path, capsys):
    """The consequence stated as the hook sees it: a printed problem and exit
    0, not a traceback."""
    domain = _domain(tmp_path, parameters=PARAMETERS)
    _write(domain, ct.ARTIFACT_NAME, "1: x\nfoo: bar\n")
    rc = ct.main([domain])
    assert rc == 0
    assert "PROBLEM:" in capsys.readouterr().out


# ── per-unit attribution in the emitted artifact (spec §8) ───────────────────
#
# The bar is the same as for the four-colour partition — SUFFICIENCY — but for
# the chain rather than the colour: statute sentence -> extracted knowledge ->
# formal rule must be reconstructible from `provisions.yaml` and nothing else.
# `{id, state, text}` colours a unit and cannot say WHY, and §7's attestation
# cannot plant a `misattribute_cite` or `swap_verbatim` mutant in a report whose
# source never states the attribution — those are the two mutant classes that
# die only if the reviewer compared the statute's words against the claim.
#
# `_chain_from_the_file_alone` below is the demonstration. It reads the emitted
# document and never touches the domain, the ledger or the manifest.

#: Text with every shape YAML has to escape: an embedded newline, a tab, a
#: trailing space, quotes of both kinds, and non-ASCII. The artifact is
#: COMMITTED and the gate compares it against a fresh emit, so a value that
#: does not survive dump/load is permanent, unfixable drift.
AWKWARD = ('Ligne un\navec\tune tabulation, «guillemets», "quotes",\n'
           "  des espaces   \net une fin. ")
#: The same text as a CLAUSAL string literal (the reader unescapes it).
AWKWARD_CLAUSAL = (r'Ligne un\navec\tune tabulation, «guillemets», \"quotes\",\n'
                   r'  des espaces   \net une fin. ')
#: And as a YAML double-quoted scalar.
AWKWARD_YAML = AWKWARD_CLAUSAL


def _chain_from_the_file_alone(document):
    """A renderer with no other input: `{unit id: [(atom, via, verbatim,
    rules)]}`. Reads ONLY the emitted document."""
    out = {}
    for unit in document["units"]:
        for row in unit.get("attribution", {}).get("coverage", []):
            out.setdefault(unit["id"], []).append(
                (row["atom"], row["via"], row["verbatim"], tuple(row["rules"])))
    return out


def _deferral_chain_from_the_file_alone(document):
    """`{unit id: [(what, reason, consequence, label)]}`, from the file alone."""
    out = {}
    for unit in document["units"]:
        for row in unit.get("attribution", {}).get("deferrals", []):
            out.setdefault(unit["id"], []).append(
                (row["what"], row["reason"], row["consequence"], row["label"]))
    return out


def test_the_emitted_file_alone_reconstructs_every_coverage_chain(tmp_path):
    """THE SUFFICIENCY DEMONSTRATION for the chain. The expectation is written
    out by hand from the fixture rather than read back from the ledger, so this
    cannot pass by comparing the file to itself. `rate` is on kernel line 1 and
    `vat_scope` on line 6 of `KERNEL_ART_1_AND_4`; the lines are derived from
    the source so an off-by-one cannot be absorbed by the expectation."""
    domain = _four_colour_domain(tmp_path)
    document, _ = _emit(_with_order(domain), tmp_path)
    rate = f"kernel.seam:{_line_of(KERNEL_ART_1_AND_4, 'rate(P, R)')}"
    scope = f"kernel.seam:{_line_of(KERNEL_ART_1_AND_4, 'vat_scope(P)')}"
    art_4_words = f"{CHAPEAU_TEXT} {CHAPEAU_A_TEXT} {CHAPEAU_B_TEXT}"
    assert _chain_from_the_file_alone(document) == {
        P1: [("art_1", "rule", P1_TEXT, (rate,)),
             ("rate_percent", "parameter", "ten per cent", ())],
        P2: [("art_1", "rule", P1_TEXT, (rate,))],
        CHAPEAU: [("art_4", "rule", art_4_words, (scope,))],
        CHAPEAU_A: [("art_4", "rule", art_4_words, (scope,))],
        CHAPEAU_B: [("art_4", "rule", art_4_words, (scope,))]}


def test_the_emitted_chain_covers_exactly_the_green_and_contradicted_units(
        tmp_path):
    """A coverage chain on a unit the gate did not score as covered — or a
    covered unit with no chain — is the artifact disagreeing with the gate that
    wrote it."""
    document, _ = _emit(_with_order(_four_colour_domain(tmp_path)), tmp_path)
    assert set(_chain_from_the_file_alone(document)) == set(document["covered"])


def test_the_emitted_red_unit_carries_no_attribution_block(tmp_path):
    """RED has nothing to attribute. An empty block beside it reads as a chain
    that was looked for and found bare — i.e. as checked — which is the false
    green this whole layer exists to remove."""
    document, _ = _emit(_four_colour_domain(tmp_path), tmp_path)
    by_id = {unit["id"]: unit for unit in document["units"]}
    assert by_id[POINT_B]["state"] == "RED"
    assert "attribution" not in by_id[POINT_B]
    assert set(by_id[POINT_B]) == {"id", "state", "text"}


def test_the_emitted_deferred_unit_carries_the_entry_with_its_label(tmp_path):
    """§6's mitigation needs the unit's own words next to the claim made about
    them, AND the label — a reason without it leaves a reviewer unable to tell
    an honoured scope contract from scope drift."""
    document, _ = _emit(_with_order(_four_colour_domain(tmp_path)), tmp_path)
    chains = _deferral_chain_from_the_file_alone(document)
    assert chains[DEROGATION] == [
        ("derogation", "Art 3 derogation out of scope.",
         "Callers in derogating Member States must apply national law.",
         "authorized")]
    assert chains[POINT_A] == [
        (EXPANSION_WHAT, "Art 2(a) goods deferred.",
         "Callers must model the supply of goods themselves.", "expansion")]


def test_the_emitted_deferral_chain_covers_exactly_the_deferred_units(tmp_path):
    document, _ = _emit(_with_order(_four_colour_domain(tmp_path)), tmp_path)
    assert set(_deferral_chain_from_the_file_alone(document)) == set(
        document["deferred"])


def test_the_emitted_contradicted_unit_carries_both_halves(tmp_path):
    """The ledger refuses to resolve `covered ∩ deferred` and the emitter may
    not either. Both chains side by side is what makes the contradiction
    legible; one of them alone would be the tool picking a winner."""
    manifest = MANIFEST.replace(DEROGATION, P1)
    document, _ = _emit(_domain(tmp_path, manifest=manifest), tmp_path)
    by_id = {unit["id"]: unit for unit in document["units"]}
    assert by_id[P1]["state"] == "CONTRADICTED"
    assert [row["atom"] for row in by_id[P1]["attribution"]["coverage"]] == \
        ["art_1"]
    assert [row["what"] for row in by_id[P1]["attribution"]["deferrals"]] == \
        ["derogation"]


def test_the_emitted_parameter_chain_names_the_record_not_a_rule(tmp_path):
    """A parameter is provenanced by its OWN record. The kernel here cites an
    atom of the same name, so an emitter that looked rules up by the record's
    key would state a chain the domain does not have."""
    kernel = KERNEL + ("\nthreshold(P) <- (\n    implements(rate_percent),\n"
                       "    prof_get(P, t, T)\n)\n")
    parameters = PARAMETERS.replace(P1, POINT_B)
    document, _ = _emit(_domain(tmp_path, kernel=kernel, parameters=parameters),
                        tmp_path)
    by_id = {unit["id"]: unit for unit in document["units"]}
    rows = by_id[POINT_B]["attribution"]["coverage"]
    assert [(row["atom"], row["via"], row["rules"]) for row in rows] == [
        ("art_2b", "rule", [f"kernel.seam:{_line_of(kernel, 'supply_b(P)')}"]),
        ("rate_percent", "parameter", [])]


def test_the_emitted_fact_borne_chain_is_not_read_as_covered_by_nothing(
        tmp_path):
    """A cite atom carried in a fact row is attributed `via: fact`, and the
    rules that bind a cite at run time are named as the superset they are. An
    empty `rules` with nothing beside it would read as covered-by-nothing for
    law that is thoroughly cited — the inversion T1 refuses to teach."""
    kernel = (KERNEL.replace(
        "\nsupply_a(P) <- (\n    implements(art_2a),\n    prof_get(P, s, S)\n)\n", "")
        + "\nnorm(r1, drive, must, implements(art_2a)),\n"
        + "\napplies(P) <- (\n    implements(C),\n    norm(_, _, _, C),\n"
          "    prof_get(P, s, S)\n)\n")
    document, _ = _emit(_domain(tmp_path, kernel=kernel), tmp_path)
    by_id = {unit["id"]: unit for unit in document["units"]}
    assert by_id[POINT_A]["state"] == "GREEN"
    row, = by_id[POINT_A]["attribution"]["coverage"]
    assert (row["atom"], row["via"], row["rules"]) == ("art_2a", "fact", [])
    assert row["indirect_rules"] == [
        f"kernel.seam:{_line_of(kernel, 'applies(P)')}"]


def test_the_emitted_deferred_by_and_the_deferral_chain_name_the_same_entries(
        tmp_path):
    """One walk of the register, projected two ways. Two walks could name
    different entries — the report contradicting itself on the very join §6's
    mitigation depends on."""
    whats = ["d_zulu", "d_papa", "d_alfa"]
    manifest = "id: fixture/domain\ndeferred_set:\n"
    for what in whats:
        manifest += (f"  - what: {what}\n"
                     f'    units: ["{DEROGATION}"]\n'
                     f'    reason: "{what} defers Art 3."\n'
                     f'    consequence: "callers handle Art 3 for {what}."\n')
    document, _ = _emit(_domain(tmp_path, manifest=manifest), tmp_path)
    for unit in document["units"]:
        chain = unit.get("attribution", {}).get("deferrals", [])
        assert sorted({row["what"] for row in chain}) == unit.get(
            "deferred_by", [])


def test_the_emitted_file_carries_no_yaml_aliases(tmp_path):
    """`yaml.safe_dump` emits an anchor/alias pair for any object it meets
    twice, so one attribution entry shared across the units a record covers
    would put `&id001`/`*id001` into the file spec §8 promises a renderer can
    read on its own."""
    _, out_path = _emit(_with_order(_four_colour_domain(tmp_path)), tmp_path)
    with open(out_path, encoding="utf-8") as handle:
        text = handle.read()
    assert "&id" not in text and "*id" not in text


# ── §4 round-trip: attribution text that YAML has to escape ─────────────────

def _awkward_domain(tmp_path):
    """A domain whose verbatim, reason and consequence all carry text YAML must
    escape. The quotes are real statute-mismatching text, so T5 reports them —
    that is beside the point here, which is that the ARTIFACT round-trips."""
    citations = CITATIONS.rstrip() + (
        f',\n\ncitation(art_awkward, {{label: "L", units: ["{POINT_B}"], '
        f'verbatim: "{AWKWARD_CLAUSAL}"}})\n')
    manifest = (f'id: fixture/domain\ndeferred_set:\n'
                f'  - what: "awkward"\n'
                f'    units: ["{DEROGATION}"]\n'
                f'    reason: "{AWKWARD_YAML}"\n'
                f'    consequence: "{AWKWARD_YAML}"\n')
    kernel = KERNEL + ("\nawkward(P) <- (\n    implements(art_awkward),\n"
                       "    prof_get(P, a, A)\n)\n")
    return _domain(tmp_path, kernel=kernel, citations=citations,
                   manifest=manifest)


def test_the_awkward_text_reaches_the_artifact_unchanged(tmp_path):
    """First: the text really is awkward and really is carried. A test that
    round-trips a value the emitter silently normalised would prove nothing."""
    document, _ = _emit(_awkward_domain(tmp_path), tmp_path)
    by_id = {unit["id"]: unit for unit in document["units"]}
    verbatims = {row["atom"]: row["verbatim"]
                 for row in by_id[POINT_B]["attribution"]["coverage"]}
    assert verbatims["art_awkward"] == AWKWARD
    entry = by_id[DEROGATION]["attribution"]["deferrals"][0]
    assert entry["reason"] == AWKWARD and entry["consequence"] == AWKWARD


def test_awkward_attribution_text_does_not_drift_against_a_fresh_emit(tmp_path):
    """THE PERMANENT-DRIFT CLASS. The gate compares a COMMITTED artifact against
    a fresh in-memory emit, so a value that does not survive dump/load reports
    drift that re-emitting cannot fix — the committed file would be unfixably
    stale from the moment it was written."""
    domain = _awkward_domain(tmp_path)
    _commit_artifact(domain)
    assert [p for p in ct.check_domain(domain) if p.startswith("§4 ")] == []


def test_a_second_emit_of_awkward_text_is_byte_identical(tmp_path):
    domain = _awkward_domain(tmp_path)
    first = os.path.join(str(tmp_path), "awkward-first.yaml")
    second = os.path.join(str(tmp_path), "awkward-second.yaml")
    ct.emit(domain, first)
    ct.emit(domain, second)
    with open(first, "rb") as a, open(second, "rb") as b:
        assert a.read() == b.read()


def test_an_edited_attribution_is_reported_as_stale(tmp_path):
    """§7's `misattribute_cite` shape, arriving as a post-emit edit: the chain
    is the part a reviewer checks, so a renderer must not be able to show one
    the gate never scored."""
    import yaml as _yaml
    domain = _four_colour_domain(tmp_path)
    path = _commit_artifact(domain)
    with open(path, encoding="utf-8") as handle:
        document = _yaml.safe_load(handle)
    for unit in document["units"]:
        if unit["id"] == P1:
            unit["attribution"]["coverage"][0]["atom"] = "art_2a"
    with open(path, "w", encoding="utf-8") as handle:
        _yaml.safe_dump(document, handle, sort_keys=True, allow_unicode=True)
    problems = [p for p in ct.check_domain(domain) if p.startswith("§4 ")]
    assert len(problems) == 1 and "STALE" in problems[0]


# ── determinism with attribution in the file ────────────────────────────────

def _multi_atom_domain(tmp_path):
    """A domain where ONE unit is covered by three citation atoms and a
    parameter. Nothing else in this file exercises that: the four-colour domain
    covers each unit from a single record, so a coverage list ordered by a set's
    iteration would emit identically under every hash seed there and the whole
    class would be invisible. The parameter's key sorts FIRST and is contributed
    LAST, so contribution order is wrong here too."""
    citations = CITATIONS.rstrip() + (
        f',\n\ncitation(zulu_extra, {{label: "Z", units: ["{P1}"], '
        f'verbatim: "The rate"}}),'
        f'\n\ncitation(mike_extra, {{label: "M", units: ["{P1}"], '
        f'verbatim: "shall be ten"}})\n')
    kernel = KERNEL + ("\nzulu(P) <- (\n    implements(zulu_extra),\n"
                       "    prof_get(P, z, Z)\n)\n"
                       "\nmike(P) <- (\n    implements(mike_extra),\n"
                       "    prof_get(P, m, M)\n)\n")
    parameters = PARAMETERS.replace('"rate_percent"', '"a_rate"')
    return _domain(tmp_path, kernel=kernel, citations=citations,
                   parameters=parameters)


def test_a_unit_covered_by_several_atoms_emits_them_sorted(tmp_path):
    document, _ = _emit(_multi_atom_domain(tmp_path), tmp_path)
    by_id = {unit["id"]: unit for unit in document["units"]}
    assert [row["atom"] for row in by_id[P1]["attribution"]["coverage"]] == [
        "a_rate", "art_1", "mike_extra", "zulu_extra"]


def test_multi_atom_attribution_is_byte_identical_under_a_different_hash_seed(
        tmp_path):
    """ACROSS PROCESSES, the only place a set's iteration order can be seen to
    move — and over a domain where it CAN move, which the four-colour domain is
    not. The file is committed, so a set order leaking into the attribution
    means a diff that depends on which machine ran the tool."""
    import subprocess
    import sys
    domain = _multi_atom_domain(tmp_path)
    written = []
    for seed in ("0", "1", "2", "12345"):
        out_path = os.path.join(str(tmp_path), f"multi-seed-{seed}.yaml")
        env = dict(os.environ,
                   PYTHONHASHSEED=seed,
                   PYTHONDONTWRITEBYTECODE="1",
                   PYTHONPATH=os.pathsep.join(p for p in sys.path if p))
        result = subprocess.run(
            [sys.executable, ct.__file__, domain, "--emit", out_path],
            env=env, capture_output=True, text=True)
        assert result.returncode == 0, result.stderr
        with open(out_path, "rb") as handle:
            written.append(handle.read())
    assert len(set(written)) == 1


# ── labels: per-domain identity uniqueness ──────────────────────────────────
#
# These need no pinned statute, so they run BEFORE the traced/untraced split
# and are checked in both states -- but the per-domain namespace decision
# (spec §13.6) means two DIFFERENT domains sharing an id is never a defect.

#: Factored out (rather than inlined in the fixture below) so a test can
#: compute the two clauses' exact, KNOWN, DIFFERENT line numbers with
#: `_line_of` and assert on them -- see `test_duplicate_labels_within_a_
#: domain_fail`, which needs the real sites, not just the message shape.
TWO_CLAUSES_SHARING_A_LABEL_KERNEL = KERNEL + (
    "\n# @1b56d3f4\nfirst(P) <- (\n    implements(art_1),\n"
    "    prof_get(P, z1, Z)\n)\n"
    "\n# @1b56d3f4\nsecond(P) <- (\n    implements(art_1),\n"
    "    prof_get(P, z2, Z)\n)\n")


def _domain_with_two_clauses_sharing_a_label(tmp_path):
    """A clean, TRACED domain plus two extra clauses that both cite art_1 (so
    T1/T2/T3/T5 stay silent) but carry the same label -- isolating the one
    new problem this task adds."""
    return _domain(tmp_path, kernel=TWO_CLAUSES_SHARING_A_LABEL_KERNEL)


def _domain_with_a_label_duplicated_across_two_files(tmp_path):
    """The same collision, but the two labelled clauses live in DIFFERENT
    files (`kernel.clausal` and `extra.clausal`) -- proving the check is
    domain-wide, not per-file. `_domain_with_two_clauses_sharing_a_label`
    alone would pass a within-file-only implementation just as well as this
    one; nothing else in this suite puts the second clause in a second file."""
    kernel = KERNEL + (
        "\n# @deadbeef\nthird(P) <- (\n    implements(art_1),\n"
        "    prof_get(P, z3, Z)\n)\n")
    extra = ("# @deadbeef\nfourth(P) <- (\n    implements(art_1),\n"
             "    prof_get(P, z4, Z)\n)\n")
    return _domain(tmp_path, kernel=kernel, extra={"extra.seam": extra})


def _untraced_domain_with_two_clauses_sharing_a_label(tmp_path):
    """The same collision, with `sources/` removed -- copy-paste happens
    whether or not a statute has been pinned yet."""
    return _untrace(_domain_with_two_clauses_sharing_a_label(tmp_path))


def _domain_with_label(base, label_id):
    """A minimal domain AT `base` (not nested under it, unlike `_domain`) with
    a single labelled fact and nothing else that could raise a problem of its
    own -- no manifest, no sources, no citations. Used to test that the SAME
    label in two different domain directories is not a collision."""
    base = str(base)
    os.makedirs(base, exist_ok=True)
    _write(base, "kernel.seam", f"# @{label_id}\nfoo(a),\n")
    return base


def _plain_untraced_domain(tmp_path):
    """The undeclared population's baseline: no labels, no problems -- the
    same construction `test_an_undeclared_domain_that_is_not_traced_is_still_
    silent` already relies on, named here so the label tests can share it."""
    return _untrace(_domain(tmp_path, parameters=PARAMETERS))


def test_duplicate_labels_within_a_domain_fail(tmp_path):
    """Message SHAPE (`@1b56d3f4` + `twice`) is not enough: a mutant that
    reports on the FIRST sighting instead of the actual duplicate can produce
    the same shape. Pin the real sites -- both clauses' exact, DIFFERENT
    `file:line`, in first-then-duplicate order -- so that mutant, or one that
    names only one site, fails here."""
    first_line = _line_of(TWO_CLAUSES_SHARING_A_LABEL_KERNEL, "first(P)")
    second_line = _line_of(TWO_CLAUSES_SHARING_A_LABEL_KERNEL, "second(P)")
    assert first_line != second_line
    d = _domain_with_two_clauses_sharing_a_label(tmp_path)
    problems = ct.check_domain(d)
    matches = [p for p in problems if "@1b56d3f4" in p and "twice" in p]
    assert len(matches) == 1
    problem = matches[0]
    first_site = f"kernel.seam:{first_line}"
    second_site = f"kernel.seam:{second_line}"
    assert first_site in problem
    assert second_site in problem
    # The earlier-seen clause is named as the first site, the later (repeat)
    # clause as the duplicate's own site -- in that order in the sentence.
    assert problem.index(first_site) < problem.index(second_site)


def test_duplicate_labels_across_two_files_in_one_domain_fail(tmp_path):
    """The namespace is domain-wide, not per-file: a label duplicated between
    `kernel.clausal` and `extra.clausal` must be caught exactly as a
    within-file duplicate is."""
    d = _domain_with_a_label_duplicated_across_two_files(tmp_path)
    problems = ct.check_domain(d)
    matches = [p for p in problems if "@deadbeef" in p and "twice" in p]
    assert len(matches) == 1
    problem = matches[0]
    assert "kernel.seam:" in problem
    assert "extra.seam:" in problem


def test_duplicate_check_runs_on_an_UNTRACED_domain(tmp_path):
    """A collision is a defect before any statute is pinned -- and copy-paste,
    not randomness, is the dominant source, so it arrives on day one."""
    d = _untraced_domain_with_two_clauses_sharing_a_label(tmp_path)
    assert not ct.is_traced(_ledger.build(d))
    assert any("twice" in p for p in ct.check_domain(d))


def test_the_same_label_in_two_DIFFERENT_domains_is_fine(tmp_path):
    """The namespace is per-domain: an EU clause is never considered alongside
    a Japanese one. A corpus-wide check would be the only corpus-wide thing in
    a layer that is per-domain everywhere else."""
    a = _domain_with_label(tmp_path / "a", "1b56d3f4")
    b = _domain_with_label(tmp_path / "b", "1b56d3f4")
    assert ct.check_domain(a) == []
    assert ct.check_domain(b) == []


def test_a_domain_with_no_labels_is_undisturbed(tmp_path):
    d = _plain_untraced_domain(tmp_path)
    assert ct.check_domain(d) == []


# ── labels: quote resolution + the SUBSET cross-check ───────────────────────
#
# These need a pinned statute (the base `_domain`'s own kernel/citations/
# manifest, already fully accounted for -- see `test_a_clean_traced_domain_
# has_no_problems`), so a label's claim has something real to resolve against
# and to be checked against that same clause's own cites.

#: A fixed, valid label id reused across this section. The namespace is
#: per-domain (spec §13.6) and every test here builds its OWN domain in its
#: own `tmp_path`, so reuse across tests is never a collision.
WITNESS_LABEL = "5c001abe"

#: Text that occurs in NO unit of the fixture document -- the quote-search
#: analogue of `MISSING` (a unit id of the right shape the document does not
#: define), used everywhere a label's quote must fail to resolve for real.
NO_SUCH_TEXT = "this exact sentence occurs nowhere in the pinned statute"

#: Reused so a reader sees the SAME shared text on both sides of the
#: ambiguity test below, rather than a second string that merely happens to
#: also be real.
SHARED_TEXT = POINT_A_TEXT


def _traced_domain(tmp_path, quote, cites, locator=None, label_id=WITNESS_LABEL):
    """The base `_domain` (clean, traced, every unit covered or deferred)
    plus ONE extra labelled RULE, `witness/1` -- isolating exactly what the
    label quote-resolution and SUBSET checks add on top of a domain that is
    otherwise silent.

    `cites` -- atoms the extra clause's `implements(...)` goals list. Reusing the
    BASE domain's own citation records (`art_1` covers `{P1, P2}`, `art_2a`
    covers `{POINT_A}`, `art_2b` covers `{POINT_B}`, `art_4` covers the three
    CHAPEAU units) means citing any of them adds no coverage defect of its
    own -- T1/T2/T3/T5 all stay silent about `witness/1`, so any problem a
    test observes comes from the label checks alone.

    `quote` -- the verbatim text quoted in the label comment, matched against
    the pinned document by `resolve.resolve`, or `None` for a label with no
    quote at all -- under quote-as-key that is the ONLY way to make a claim
    with nothing to check (see `resolve.py`'s `NO_QUOTE`).

    `locator` -- optional free-text locator prose (with an optional
    `mnemonic:` prefix naming a source document), written before the quote
    exactly as `labels.py`'s grammar expects. Human-facing only; the
    resolver never reads it except to find a `mnemonic:` prefix.
    """
    tail = f" {locator}" if locator else ""
    if quote is not None:
        tail += f' "{quote}"'
    cite_goals = "".join(f"    implements({atom}),\n" for atom in cites)
    kernel = KERNEL + (
        f"\n# @{label_id}{tail}\nwitness(P) <- (\n"
        f"{cite_goals}    prof_get(P, w, W)\n)\n")
    return _domain(tmp_path, kernel=kernel)


def _traced_domain_with_findall(tmp_path, quote, label_id=WITNESS_LABEL):
    """The same base domain, but the extra labelled clause is an INDIRECT
    cite (`findall(implements(C), norm(P, C), CITES)`, `test_t1_indirect_cite_
    satisfies_it`'s own shape) -- `cites == []` and `indirect_cite == True` by
    construction, which is exactly the carve-out `_check_label_subset` exists
    for."""
    tail = f' "{quote}"' if quote is not None else ""
    kernel = KERNEL + (
        "\nnorm(travel, art_2a),\n"
        f"\n# @{label_id}{tail}\nobligations(P, CITES) <- (\n"
        "    findall(implements(C), norm(P, C), CITES)\n)\n")
    return _domain(tmp_path, kernel=kernel)


def _traced_domain_two_documents(tmp_path, quote, label_id=WITNESS_LABEL):
    """`_traced_domain`'s base, plus a SECOND pinned document that is a byte
    copy of the fixture statute under a different doc_id -- so any quote
    real in the fixture is real, identically, in both, and an unscoped label
    can never tell which one it means. Not a hypothetical: `resolve.py`'s own
    module docstring records that two domains in this corpus already pin the
    same act in base and consolidated form."""
    d = _traced_domain(tmp_path, quote=quote, cites=["art_2a"],
                        label_id=label_id)
    src = os.path.join(d, "sources")
    body = open(os.path.join(FIXTURE_DIR, "fixture_statute.xml"), "rb").read()
    dup_name = "fixture_statute_2.xml"
    with open(os.path.join(src, dup_name), "wb") as handle:
        handle.write(body)
    _write(src, "fixture_statute_2.meta.yaml",
           'doc_id: FIXTURE2\ncelex: FIXTURE2\nconsolidated: "2026-01-01"\n'
           'url: "https://example.invalid/f2"\n'
           f'file: {dup_name}\nsha256: "{hashlib.sha256(body).hexdigest()}"\n')
    return d


def test_a_label_whose_quote_resolves_and_is_reachable_PASSES(tmp_path):
    """The brief's own step-1 fixture, asserted directly rather than only
    implied by the more specific tests below -- the brief's passing case is
    never itself exercised otherwise."""
    d = _traced_domain(tmp_path, quote=POINT_A_TEXT, cites=["art_2a"])
    assert ct.check_domain(d) == []


def test_a_label_naming_a_unit_no_cite_of_that_clause_reaches_FAILS(tmp_path):
    """M4 misattribute_cite: the class spec §7's attestation depends on.
    `witness/1` cites `art_1` (covers `{P1, P2}`), but the label quotes
    `POINT_A_TEXT`, which resolves to `POINT_A` -- a unit `art_1`'s record
    never names."""
    d = _traced_domain(tmp_path, quote=POINT_A_TEXT, cites=["art_1"])
    problems = ct.check_domain(d)
    assert any("names" in p and POINT_A in p for p in problems)


def test_a_label_whose_quote_resolves_to_an_UNREACHED_unit_FAILS(tmp_path):
    """Misattribution -- the M4 class spec §7 depends on -- now detected
    through the quote rather than through an authored unit id. Same scenario
    as the test above, phrased against the SUBSET message's own words rather
    than the resolved id, so the two together pin both halves of the
    sentence."""
    d = _traced_domain(tmp_path, quote=POINT_A_TEXT, cites=["art_1"])
    assert any("no cite of this clause reaches" in p
               for p in ct.check_domain(d))


def test_a_label_naming_ONE_of_a_records_several_units_passes(tmp_path):
    """SUBSET, not equality. `art_1`'s record covers two units (`P1`, `P2`);
    this clause legitimately quotes just one of them."""
    d = _traced_domain(tmp_path, quote=P1_TEXT, cites=["art_1"])
    assert ct.check_domain(d) == []


def test_a_label_with_no_cite_at_all_FAILS(tmp_path):
    """Otherwise the unit reads unaccounted while a comment beside the code
    claims it is implemented -- contradicted one level down.

    Deliberately NOT `"cites nothing" in p`: the SUBSET check's OTHER message
    ("no cite of this clause reaches ... it cites nothing") also contains that
    substring for an empty `reachable` set, so a mutant that dropped the
    dedicated no-cite branch and fell through to the misattribution one would
    still satisfy a looser assertion. `"the clause cites nothing"` (with the
    leading article) is the no-cite message's own words and no other."""
    d = _traced_domain(tmp_path, quote=P1_TEXT, cites=[])
    problems = ct.check_domain(d)
    assert any("the clause cites nothing" in p for p in problems)


def test_an_indirect_cite_rule_is_ADVISORY_not_a_failure(tmp_path):
    """A findall rule has `cites == []`, so the blocking rule would reject
    exactly the clauses labels exist to attribute."""
    d = _traced_domain_with_findall(tmp_path, quote=P1_TEXT)
    assert ct.check_domain(d) == []


def _traced_domain_with_findall_AND_a_static_cite(tmp_path, quote):
    """A clause that is BOTH: it names `implements(art_1)` outright AND binds more
    cites at run time through `findall`. `cites == ["art_1"]` and
    `indirect_cite == True` together -- the shape `_check_label_subset`'s
    docstring used to declare impossible ("`cites` is empty by
    construction")."""
    kernel = KERNEL + (
        "\nnorm(travel, art_2a),\n"
        f'\n# @{WITNESS_LABEL} "{quote}"\nobligations(P, CITES) <- (\n'
        "    implements(art_1),\n"
        "    findall(implements(C), norm(P, C), CITES)\n)\n")
    return _domain(tmp_path, kernel=kernel)


def test_an_indirect_cite_rule_that_ALSO_cites_statically_is_still_advisory(
        tmp_path):
    """The carve-out is about the run-time half, not about `cites` being
    empty. `art_1` reaches `{P1, P2}` and the label quotes `POINT_A_TEXT`
    (resolving to `POINT_A`), so a subset check over the static cites alone
    would call this a misattribution -- while the `findall` half can bind
    `art_2a`, which reaches `POINT_A` exactly. The clause is therefore left
    unchecked, and the artifact says so rather than reporting a defect that
    may not exist.

    This pins the BEHAVIOUR the false premise happened to describe correctly,
    so a later reader who notices the premise is wrong cannot 'fix' the
    carve-out into `indirect_cite and not cites` without a test failing."""
    d = _traced_domain_with_findall_AND_a_static_cite(
        tmp_path, quote=POINT_A_TEXT)
    labelled = next(lc for lc in _ledger.build(d)["labels"]
                    if lc.label.id == WITNESS_LABEL)
    # The premise under test: this clause really is both at once.
    assert labelled.cites == ["art_1"] and labelled.indirect_cite is True
    assert ct.check_domain(d) == []
    entry = next(e for e in ct.build_document(d)["labels"]
                 if e["id"] == WITNESS_LABEL)
    assert entry["cross_checked"] is False
    assert "indirect" in entry["cross_checked_note"]


def test_an_unresolvable_unit_reference_FAILS(tmp_path):
    """The quote-search analogue of the old T3-class defect: a quote that
    occurs in no unit of the pinned document (`resolve.NO_MATCH`)."""
    d = _traced_domain(tmp_path, quote=NO_SUCH_TEXT, cites=["art_1"])
    problems = ct.check_domain(d)
    assert any("resolves to no unit" in p for p in problems)


def test_a_quote_matching_no_pinned_text_FAILS_with_the_matched_prefix(
        tmp_path):
    """The NO_MATCH message names how FAR the quote matched, not merely that
    it failed -- `_matched_prefix`'s own reasoning (`check_provisions.py`,
    relocated from here into `_tools/provisions/units.py`): the last words
    that did match send an author to the dropped clause.

    THE FIRST ASSERTION ALONE DOES NOT PIN THIS: "goods supplied for" is a
    substring of the QUOTE itself, so a `_matched_prefix` mutant that always
    returned 0 would still put it in the message's UNMATCHED half and pass.
    The second assertion pins the exact matched length against the specific
    unit it matched (hardcoded, not recomputed by calling `_matched_prefix`
    again -- see `test_t5_names_where_the_quote_stops_matching` for why)."""
    d = _traced_domain(tmp_path, quote="goods supplied for NO SUCH WORDS",
                        cites=["art_2a"])
    problems = ct.check_domain(d)
    assert any("goods supplied for" in p for p in problems)
    assert any(f"Against {POINT_A} the quote matches up to "
               "…'goods supplied for '" in p for p in problems)


def test_a_quote_spanning_a_unit_boundary_SAYS_SO(tmp_path):
    """The canonical case the operator decision recorded in the brief exists
    for: a chapeau and its first point, quoted as the one sentence they read
    as in the source, but two SEPARATE units. `resolve.resolve` correctly
    refuses (NO_MATCH -- a quote resolves within ONE unit or not at all, the
    deliberate asymmetry with `_check_t5`'s own join), but a message that
    joined the candidates to compute its "matched up to" prefix (importing
    T5's semantics into the resolver's) would report the quote as matching
    "in full" with nothing left to diverge on -- the opposite of the truth:
    it matched NEITHER single unit, and only looks whole when read across a
    boundary resolution refuses to cross. The message must say so."""
    quote = CHAPEAU_TEXT + " " + CHAPEAU_A_TEXT
    d = _traced_domain(tmp_path, quote=quote, cites=["art_4"])
    problems = ct.check_domain(d)
    matches = [p for p in problems if f"@{WITNESS_LABEL}" in p]
    assert len(matches) == 1
    problem = matches[0]
    assert "resolves to no unit" in problem
    assert f"Against {CHAPEAU} the quote matches up to" in problem
    assert "continues past the end of that unit into another" in problem
    # The false "matched in full" shape a join would have produced instead:
    assert "then reads ''" not in problem


def test_an_AMBIGUOUS_quote_FAILS_and_names_the_candidates(tmp_path):
    """An author cannot fix an ambiguity they cannot see."""
    d = _traced_domain_two_documents(tmp_path, quote=SHARED_TEXT)
    problems = ct.check_domain(d)
    assert any("matches 2 units" in p for p in problems)
    # Names the ACTUAL two candidates, not merely a correct count -- pins
    # that the message's matching predicate (imported from `resolve.py`,
    # not re-typed) agrees with what `resolve.resolve` itself found.
    fixture2_point_a = "FIXTURE2#" + POINT_A.split("#", 1)[1]
    assert any(POINT_A in p and fixture2_point_a in p for p in problems)


def test_a_labelled_FACT_with_an_unresolvable_quote_never_reaches_check_label_units(
        tmp_path):
    """`_check_label_units`'s fact carve-out, reached the same way `_check_
    label_subset`'s already is (`test_the_subset_check_says_nothing_about_a_
    labelled_FACT`) -- but nothing previously walked a FACT carrying a quote
    that could not resolve THROUGH `_check_label_units` specifically. A
    mutant that resolved this label's quote inline, bypassing `lc.is_fact`,
    would report "resolves to no unit" here where today it reports nothing;
    every other test reaching this function uses a plain traced rule, so
    that mutant survived the whole suite until this test existed."""
    kernel = KERNEL + f'\n# @{WITNESS_LABEL} "{NO_SUCH_TEXT}"\nthreshold(rate_percent, 10),\n'
    d = _domain(tmp_path, kernel=kernel)
    assert ct.check_domain(d) == []


def test_an_indirect_cite_rule_with_an_unresolvable_quote_never_reaches_check_label_units(
        tmp_path):
    """`_check_label_units`'s `indirect_cite` carve-out, exercised through
    the function it actually guards -- the sibling gap to the FACT test
    above."""
    d = _traced_domain_with_findall(tmp_path, quote=NO_SUCH_TEXT)
    assert ct.check_domain(d) == []


def test_a_label_naming_an_unknown_source_FAILS(tmp_path):
    """`UNKNOWN_SOURCE`: a `mnemonic:` prefix naming no pinned document is a
    typo, not an ambiguity or a dropped clause -- its own reason, its own
    message, never a silent unscoped search (`resolve.py`'s own ruling)."""
    d = _traced_domain(tmp_path, quote=P1_TEXT, cites=["art_1"],
                        locator="zz:art 1")
    problems = ct.check_domain(d)
    assert any("names source" in p and "zz" in p for p in problems)


def test_a_label_with_no_quote_is_not_flagged_as_a_problem(tmp_path):
    """`# @5c001abe` alone is legal -- identity without a checkable claim.
    Renamed from `test_a_label_with_no_unit_reference_is_not_cross_checked`:
    the old name described a field (`unit`) the grammar no longer has: under
    quote-as-key, the checkable material is the QUOTE, and this fixture now
    supplies none at all."""
    d = _traced_domain(tmp_path, quote=None, cites=["art_1"])
    assert ct.check_domain(d) == []


def test_the_subset_check_says_nothing_about_a_labelled_FACT(tmp_path):
    """FACTS are not cross-checked at all (spec §13.8 is out of this plan's
    scope): `scan_file_cites` is an unattributed superset, so which fact
    carries a cite atom is not recorded. A labelled fact whose quote resolves
    to a unit no record here reaches must not be reported as a
    misattribution."""
    kernel = KERNEL + f'\n# @{WITNESS_LABEL} "{POINT_A_TEXT}"\nthreshold(rate_percent, 10),\n'
    d = _domain(tmp_path, kernel=kernel)
    assert ct.check_domain(d) == []


def test_the_subset_check_does_not_double_report_an_unresolvable_label_unit(
        tmp_path):
    """An unresolvable quote is ONE defect, T3's own reason (see `_check_
    label_subset`'s docstring): `witness/1` cites `art_1` for real, so
    `NO_SUCH_TEXT` never even reaches the "not reached" branch -- reported a
    second time, the author "fixes" the misattribution by editing the cite
    against a provision the quote never actually named."""
    d = _traced_domain(tmp_path, quote=NO_SUCH_TEXT, cites=["art_1"])
    problems = [p for p in ct.check_domain(d) if f"@{WITNESS_LABEL}" in p]
    assert len(problems) == 1
    assert "resolves to no unit" in problems[0]


def test_the_new_checks_are_wired_after_t3_not_before(tmp_path):
    """`_check_label_units`/`_check_label_subset` sit AFTER `_check_t3` in
    `_scored_problems` (see the wiring comment there). `problems` is built by
    plain list concatenation, so when one `check_domain` call yields both a
    genuine T3 defect and a genuine label defect, their RELATIVE ORDER in the
    returned list tracks call order exactly -- pinned here so a wiring
    regression that moved the label checks earlier is caught, not merely a
    difference in which problems appear."""
    citations = _plus_citation("art_9", [MISSING], "")
    kernel = KERNEL + (
        f'\n# @{WITNESS_LABEL} "{NO_SUCH_TEXT}"\nwitness(P) <- (\n'
        "    implements(art_1),\n    prof_get(P, w, W)\n)\n")
    d = _domain(tmp_path, kernel=kernel, citations=citations)
    problems = ct.check_domain(d)
    t3_index = next(i for i, p in enumerate(problems) if p.startswith("T3 "))
    label_index = next(i for i, p in enumerate(problems)
                       if f"@{WITNESS_LABEL}" in p)
    assert t3_index < label_index


# ── labels: emission, and saying so when one is NOT cross-checked ──────────
#
# `build_document`'s `labels:` list, distinct from the PROBLEM-reporting tests
# above: a label can be perfectly clean (no problem at all) and still be
# something `_check_label_subset` never verified -- the fact and indirect-cite
# carve-outs -- and the artifact has to say so. `_traced_domain_with_labels`
# and `_plain_traced_domain` are the two fixtures this section's tests share.

def _plain_traced_domain(tmp_path):
    """A clean, TRACED domain with no labels at all. Pairs with `_plain_
    untraced_domain` above; unlike that one, `sources/` stays in place, so
    this is the "adopted provision tracking, has not adopted labels" case the
    absent-`labels:`-key test needs."""
    return _domain(tmp_path, parameters=PARAMETERS)


def _traced_domain_with_labels(tmp_path):
    """A clean, TRACED domain carrying two labels: a normal rule
    (`witness/1`, `@1b56d3f4`, quoting `P1_TEXT`, which resolves to `P1` and
    is reached through its own `implements(art_1)` -- `_check_label_subset`
    verifies this one, so it is `cross_checked`) and a labelled FACT
    (`threshold/2`, `@0a0a0a0a`, quoting `POINT_A_TEXT`) -- the FACT carve-out
    `test_the_subset_check_says_nothing_about_a_labelled_FACT` already
    exercises for the problem-reporting side; here it is the fixture for the
    emitted field this task adds instead.
    """
    kernel = KERNEL + (
        f'\n# @1b56d3f4 "{P1_TEXT}"\nwitness(P) <- (\n'
        "    implements(art_1),\n    prof_get(P, w, W)\n)\n"
        f'\n# @0a0a0a0a "{POINT_A_TEXT}"\nthreshold(rate_percent, 10),\n')
    return _domain(tmp_path, kernel=kernel)


def test_labels_are_emitted_with_their_cross_check_status(tmp_path):
    doc = ct.build_document(_traced_domain_with_labels(tmp_path))
    by_id = {entry["id"]: entry for entry in doc["labels"]}
    assert by_id["1b56d3f4"]["cross_checked"] is True
    assert by_id["0a0a0a0a"]["cross_checked"] is False    # a fact


def test_an_uncrosschecked_label_says_WHY(tmp_path):
    """A bare False reads as 'checked and failed'. The reason is what stops a
    reader treating an unverified claim as a verified one."""
    doc = ct.build_document(_traced_domain_with_labels(tmp_path))
    fact = next(e for e in doc["labels"] if e["id"] == "0a0a0a0a")
    assert "fact" in fact["cross_checked_note"]


def test_a_cross_checked_label_carries_no_note(tmp_path):
    """The note explains an ABSENCE of verification; a label that WAS
    verified gets none -- a note beside a clean cross-check would read as a
    reason that was looked for and not found, which is not what this is."""
    doc = ct.build_document(_traced_domain_with_labels(tmp_path))
    witness = next(e for e in doc["labels"] if e["id"] == "1b56d3f4")
    assert "cross_checked_note" not in witness


def test_a_cross_checked_label_carries_its_resolved_unit(tmp_path):
    """A renderer holding only `provisions.yaml` must be able to say WHICH
    provision a passing label names without re-implementing `resolve.
    resolve` itself (normalisation, case sensitivity, exactly-one-match,
    `<source>#` scoping) in a second file. `resolved_unit` is that answer,
    read out of the SAME `_label_check_reasons` map that decided the label
    passed -- not a second `resolve.resolve` call."""
    doc = ct.build_document(_traced_domain_with_labels(tmp_path))
    witness = next(e for e in doc["labels"] if e["id"] == "1b56d3f4")
    assert witness["resolved_unit"] == P1


def test_an_uncrosschecked_label_carries_no_resolved_unit(tmp_path):
    """`resolved_unit` is present IFF `cross_checked` is true -- a failed or
    never-checked row must not carry a unit id that reads as verified when
    it is not, the same reasoning `cross_checked_note`'s own absence-on-pass
    rule already follows in the other direction."""
    doc = ct.build_document(_traced_domain_with_labels(tmp_path))
    fact = next(e for e in doc["labels"] if e["id"] == "0a0a0a0a")
    assert "resolved_unit" not in fact


def test_an_indirect_cite_label_is_not_cross_checked_either(tmp_path):
    """The SECOND carve-out `_check_label_subset` names: a `findall` rule
    binds its cite at run time, so the clause names no atom to verify
    against. `_traced_domain_with_findall` is Task 5's own fixture for this
    shape (`cites == []`, `indirect_cite == True` by construction)."""
    d = _traced_domain_with_findall(tmp_path, quote=P1_TEXT)
    doc = ct.build_document(d)
    entry = next(e for e in doc["labels"] if e["id"] == WITNESS_LABEL)
    assert entry["cross_checked"] is False
    assert "indirect" in entry["cross_checked_note"]


def test_an_unresolvable_label_unit_is_not_cross_checked(tmp_path):
    """T3-class FAILURE, not an exemption: `_check_label_units` DOES check a
    label's quote against the pinned document, and this one fails it (`test_
    an_unresolvable_unit_reference_FAILS` pins the problem string). A bare
    `cross_checked: true` here would show a renderer a label naming a
    provision that does not exist as a VERIFIED claim -- `problems` never
    reaches this file, only `problem_count` does (see `build_document`), so
    this field is the ONLY place that claim could be caught from the artifact
    alone. The note is its OWN wording, not a reuse of the fact/indirect-cite
    ones: 'not checked' and 'checked and failed' are different statements."""
    d = _traced_domain(tmp_path, quote=NO_SUCH_TEXT, cites=["art_1"])
    doc = ct.build_document(d)
    entry = next(e for e in doc["labels"] if e["id"] == WITNESS_LABEL)
    assert entry["cross_checked"] is False
    assert "fact" not in entry["cross_checked_note"]
    assert "indirect" not in entry["cross_checked_note"]
    assert "resolve" in entry["cross_checked_note"]


def test_a_bare_identity_label_with_no_quote_is_never_checked(tmp_path):
    """Replaces `test_a_label_with_no_unit_reference_is_cross_checked_true`,
    whose old answer (`True`, no note) was `label.unit is None`'s exemption
    from the retired grammar: a claim-free label passed vacuously because
    "no claim" and "nothing to fail" were the same state. Under quote-as-key
    they are not: the QUOTE is the only checkable material, so its absence is
    always `NO_QUOTE` -- 'never checked', not 'nothing to check' -- whether or
    not a locator sits beside it (see `test_an_unquoted_label_is_never_
    checked_not_checked_and_failed` for the locator-present half of this
    pair; this fixture carries neither)."""
    d = _traced_domain(tmp_path, quote=None, cites=["art_1"])
    doc = ct.build_document(d)
    entry = next(e for e in doc["labels"] if e["id"] == WITNESS_LABEL)
    assert entry["cross_checked"] is False
    assert "no quote" in entry["cross_checked_note"]


def test_an_unquoted_label_is_never_checked_not_checked_and_failed(tmp_path):
    """A locator alone -- 'art 30(2)', legible to a human -- still cannot be
    resolved to a unit (no locator-to-eId transformation survives even one
    document format, let alone the many this corpus pins; see `labels.py`'s
    module docstring), so it is `NO_QUOTE` exactly like the fully bare label
    above. Replaces `test_a_cross_checked_label_with_NO_verbatim_still_
    carries_no_note`, whose premise -- a unit-identified, quote-less label
    passing CLEANLY -- described the retired grammar's separate `unit` field,
    which no longer exists: there is no way left to identify a unit without
    the quote that finds it."""
    d = _traced_domain(tmp_path, quote=None, locator="art 30(2)",
                        cites=["art_2a"])
    assert ct.check_domain(d) == []
    row = ct.build_document(d)["labels"][0]
    assert row["cross_checked"] is False
    assert "no quote" in row["cross_checked_note"]


def _traced_domain_with_a_swapped_verbatim(tmp_path):
    """A label whose quote is FICTION -- no unit in the pinned document reads
    "The rate shall be TWENTY per cent...". Under the retired, unit-id-keyed
    grammar this was spec §7's `swap_verbatim` mutant sitting undetected in a
    clean domain (`cross_checked: true` beside a contradicting quote) --
    `_check_label_subset` never compared the two. Under quote-as-key
    resolution IS the comparison, so this fixture now demonstrates the
    opposite: the swapped quote cannot resolve at all."""
    kernel = KERNEL + (
        f'\n# @{WITNESS_LABEL} "The rate shall be TWENTY per cent, and '
        'shall apply only on Tuesdays."\nwitness(P) <- (\n'
        "    implements(art_1),\n    prof_get(P, w, W)\n)\n")
    return _domain(tmp_path, kernel=kernel)


def test_a_swapped_verbatim_now_FAILS_to_resolve_rather_than_passing_silently(
        tmp_path):
    """Replaces `test_a_cross_checked_label_says_its_VERBATIM_was_not_
    checked`, which pinned the OLD design's acknowledged gap: a `swap_
    verbatim` mutant (spec §7) passed with `cross_checked: true` and a note
    admitting the quote was never compared to the unit. That gap is closed by
    construction now, not merely disclosed -- a swapped quote is `NO_MATCH`,
    `cross_checked: false`, with its own failure note, exactly like any other
    quote that names no real provision."""
    d = _traced_domain_with_a_swapped_verbatim(tmp_path)
    problems = ct.check_domain(d)
    assert any("resolves to no unit" in p for p in problems)
    entry = next(e for e in ct.build_document(d)["labels"]
                 if e["id"] == WITNESS_LABEL)
    assert entry["cross_checked"] is False
    assert "TWENTY per cent" in entry["verbatim"]
    assert "resolve" in entry["cross_checked_note"]


def test_an_ambiguous_label_is_not_cross_checked(tmp_path):
    """AMBIGUOUS: `_traced_domain_two_documents` pins the same act twice
    (`resolve.py`'s own base+consolidated scenario, `test_an_AMBIGUOUS_quote_
    FAILS_and_names_the_candidates` pins the problem string), so `SHARED_TEXT`
    resolves identically in both pinned documents and the resolver refuses to
    pick a winner. Checked, and failed, with its OWN note -- not the NO_MATCH
    wording next to it, and not the UNKNOWN_SOURCE wording either side of
    it."""
    d = _traced_domain_two_documents(tmp_path, quote=SHARED_TEXT)
    entry = next(e for e in ct.build_document(d)["labels"]
                 if e["id"] == WITNESS_LABEL)
    assert entry["cross_checked"] is False
    assert "matches more than one unit" in entry["cross_checked_note"]
    assert "does not resolve" not in entry["cross_checked_note"]
    assert "not among the pinned" not in entry["cross_checked_note"]


def test_an_unknown_source_label_is_not_cross_checked(tmp_path):
    """UNKNOWN_SOURCE: the label's `mnemonic:` prefix (`locator="zz:art 1"`,
    `test_a_label_naming_an_unknown_source_FAILS`'s own fixture) names a
    document this domain has not pinned. Checked, and failed, with its OWN
    note -- not the ambiguity or no-match wording either side of it."""
    d = _traced_domain(tmp_path, quote=P1_TEXT, cites=["art_1"],
                        locator="zz:art 1")
    entry = next(e for e in ct.build_document(d)["labels"]
                 if e["id"] == WITNESS_LABEL)
    assert entry["cross_checked"] is False
    assert "not among the pinned" in entry["cross_checked_note"]
    assert "matches more than one unit" not in entry["cross_checked_note"]
    assert "does not resolve" not in entry["cross_checked_note"]


def test_a_misattributed_label_is_not_cross_checked(tmp_path):
    """M4 misattribute_cite: the quote RESOLVES but no cite of this clause
    reaches the unit it names -- `_check_label_subset` reports exactly this
    as a problem (`test_a_label_naming_a_unit_no_cite_of_that_clause_reaches_
    FAILS` pins the message). This is THE defect the whole mechanism exists
    to catch, so the artifact marking it verified is the most serious
    instance of the 'checked and failed' class -- `cross_checked` must be
    False here, with its own note, not the fact/indirect-cite wording and not
    the unresolvable-quote wording."""
    d = _traced_domain(tmp_path, quote=POINT_A_TEXT, cites=["art_1"])
    doc = ct.build_document(d)
    entry = next(e for e in doc["labels"] if e["id"] == WITNESS_LABEL)
    assert entry["cross_checked"] is False
    assert "fact" not in entry["cross_checked_note"]
    assert "indirect" not in entry["cross_checked_note"]
    assert "resolve" not in entry["cross_checked_note"]
    assert "reach" in entry["cross_checked_note"]


def test_a_cites_nothing_label_is_not_cross_checked(tmp_path):
    """`_check_label_subset`'s OTHER failure branch: the clause cites
    NOTHING at all while the label's quote resolves to a unit. Checked, and
    failed, same as the misattribution case, with ITS OWN distinct note --
    not a reuse of any of the others."""
    d = _traced_domain(tmp_path, quote=P1_TEXT, cites=[])
    doc = ct.build_document(d)
    entry = next(e for e in doc["labels"] if e["id"] == WITNESS_LABEL)
    assert entry["cross_checked"] is False
    assert "fact" not in entry["cross_checked_note"]
    assert "indirect" not in entry["cross_checked_note"]
    assert "reaches the claimed unit" not in entry["cross_checked_note"]
    assert "cites nothing" in entry["cross_checked_note"]


def test_an_UNTRACED_domains_label_is_never_checked_not_checked_and_failed(
        tmp_path):
    """The state EVERY corpus domain is in today, and the one the emitter
    reached through a guard the checks do not share: `_scored_problems` runs
    the label checks behind `is_traced`, `build_document` calls the shared
    computation unconditionally. With no pinned document EVERY quote-bearing
    label used to score as unresolvable against an empty unit store, and the
    committed artifact read `problem_count: 0` beside "see the corresponding
    problem" -- self-contradictory, and the wrong KIND: nothing was checked,
    because there is nothing to check against. The 'see the problem' wording
    belongs to checked-and-failed alone, and an untraced domain has no problem
    to see -- following that note sends an author hunting a typo in a
    perfectly correct quote."""
    d = _untrace(_traced_domain(tmp_path, quote=P1_TEXT, cites=["art_1"]))
    assert not ct.is_traced(_ledger.build(d))
    assert ct.check_domain(d) == []
    doc = ct.build_document(d)
    assert doc["problem_count"] == 0
    entry = next(e for e in doc["labels"] if e["id"] == WITNESS_LABEL)
    assert entry["cross_checked"] is False
    note = entry["cross_checked_note"]
    assert "not traced" in note
    # The discriminator against the unresolvable-quote note, whose wording
    # this case wore before the fix: no problem exists for a reader to see.
    assert "corresponding problem" not in note


def test_labels_key_is_absent_when_a_domain_has_none(tmp_path):
    """Absence, not an empty list. An empty `labels: []` reads as 'looked for
    and found none', which is indistinguishable from a domain that has not
    adopted labels at all -- the same reasoning as `_finish_attribution`."""
    doc = ct.build_document(_plain_traced_domain(tmp_path))
    assert "labels" not in doc


def test_the_emitted_label_carries_every_field(tmp_path):
    """`{id, file, line, source, locator, verbatim, cross_checked,
    resolved_unit}` -- the new interface, replacing `unit`/`summary` (both
    retired with the `<doc_id>#<eid>` grammar in task 1) -- round-tripped
    through the real emitter and a real YAML load, not just the in-memory
    document."""
    d = _traced_domain_with_labels(tmp_path)
    line = _line_of(
        KERNEL + f'\n# @1b56d3f4 "{P1_TEXT}"\nwitness(P) <- (\n',
        "witness(P)")
    document, _ = _emit(d, tmp_path)
    by_id = {entry["id"]: entry for entry in document["labels"]}
    witness = by_id["1b56d3f4"]
    assert witness["file"] == "kernel.seam"
    assert witness["line"] == line
    assert witness["source"] is None
    assert witness["locator"] is None
    assert witness["verbatim"] == P1_TEXT
    assert witness["cross_checked"] is True
    assert witness["resolved_unit"] == P1
    assert "cross_checked_note" not in witness


def _domain_with_numeric_sort_labels(tmp_path):
    """Two labelled facts whose clause lines straddle a digit-count boundary:
    `"kernel.clausal:12"` sorts BEFORE `"kernel.clausal:9"` as text, exactly
    the trap `_sites` documents for coverage sites. A minimal domain --
    manifest, citations and sources are all irrelevant to this ordering, and
    the same minimal-domain construction `_domain_with_label` already uses
    above."""
    base = str(tmp_path)
    os.makedirs(base, exist_ok=True)
    kernel = "\n" * 7 + "# @1b56d3f4\nninth(a),\n" + "\n# @2b56d3f4\ntenth(a),\n"
    _write(base, "kernel.seam", kernel)
    return base, kernel


def test_labels_are_sorted_by_file_and_line_as_a_tuple_not_a_string(tmp_path):
    d, kernel = _domain_with_numeric_sort_labels(tmp_path)
    ninth_line = _line_of(kernel, "ninth(a)")
    tenth_line = _line_of(kernel, "tenth(a)")
    # The whole point of the fixture: a single-digit line followed by a
    # double-digit one, so a formatted-string sort disagrees with a tuple sort.
    assert ninth_line < 10 <= tenth_line
    doc = ct.build_document(d)
    assert [entry["line"] for entry in doc["labels"]] == [ninth_line, tenth_line]


def test_the_emitted_labels_carry_no_yaml_anchors(tmp_path):
    """`_covering`'s trap, transposed to labels: a dict object shared or
    reused across two entries would put an `&id001`/`*id001` anchor/alias
    pair into a committed artifact that spec §8 promises a renderer can read
    standalone."""
    _, out_path = _emit(_traced_domain_with_labels(tmp_path), tmp_path)
    with open(out_path, encoding="utf-8") as handle:
        text = handle.read()
    assert "&id" not in text and "*id" not in text


def test_labels_emit_is_byte_identical_across_runs(tmp_path):
    """Committed artifact: a re-emit that reordered the `labels:` list would
    put a spurious diff in every commit."""
    domain = _traced_domain_with_labels(tmp_path)
    first = os.path.join(str(tmp_path), "first.yaml")
    second = os.path.join(str(tmp_path), "second.yaml")
    ct.emit(domain, first)
    ct.emit(domain, second)
    with open(first, "rb") as a, open(second, "rb") as b:
        assert a.read() == b.read()


# ── sources: what each pinned document's OWN sidecar claims to be ───────────
#
# `build_document` gains a `sources:` block -- one entry per pinned document,
# carrying what Task 1 (`units.load_sources_with_provenance`) already reads
# out of the sidecar. This is the artifact-side half of pin-provenance
# (docs/superpowers/plans/2026-08-19-pin-provenance.md Task 2); the render
# side is covered in test_render_provisions.py. Same conventions as `labels:`
# above: absent key stays absent, a fresh dict per entry, sorted on a tuple.

#: A sidecar carrying every field Task 1 reads, including `format` and a full
#: `extract` block -- the "full sidecar" case acceptance (a) asks for.
FULL_SOURCE_META = (
    "doc_id: FIXTURE\n"
    "celex: 32006L0112\n"
    'consolidated: "2025-01-01"\n'
    "format: fmx4\n"
    'url: "https://example.invalid/fixture"\n'
    "file: fixture_extract.xml\n"
    'sha256: "{sha}"\n'
    "extract:\n"
    '  root: "chp_2"\n'
    '  from: "173"\n'
    '  to: "175"\n'
    '  method: "cut at the chapter boundary"\n'
    '  source_sha256: "deadbeef"\n'
    '  verified: "checked 2026-01-01"\n'
)

#: Only the three fields `units.load_sources_with_provenance` requires before
#: a document contributes an entry at all -- the "required three" case.
REQUIRED_ONLY_SOURCE_META = (
    "doc_id: FIXTURE\n"
    "file: fixture_extract.xml\n"
    'sha256: "{sha}"\n'
)

#: A second, independently-pinned document -- for the two-entry tests, where
#: `format` and half of `extract` are absent so the two entries also differ
#: in WHICH keys they carry, not merely in value.
SECOND_SOURCE_META = (
    "doc_id: SECOND\n"
    "celex: 99999L9999\n"
    "file: second_statute.xml\n"
    'sha256: "{sha}"\n'
    "extract:\n"
    '  root: "chp_2"\n'
    '  method: "cut at the chapter boundary"\n'
)


def _domain_with_meta(tmp_path, template, xml="fixture_extract.xml",
                      **domain_kwargs):
    """Like `_domain`, but the sidecar is exactly TEMPLATE rather than the
    fixed doc_id/celex/consolidated/url/file/sha256 lines `_domain` itself
    writes. Used where a test needs a field `_domain`'s own sidecar never
    sets (`format`, `extract`) or needs to withhold everything but the three
    required ones.

    XML is a parameter because a template carrying an `extract:` block must
    point at `fixture_extract.xml` -- the one fixture that IS a single
    document-native subtree. `fixture_statute.xml`'s four top-level articles
    are four cuts, not one, and `units._extract_problems` says so."""
    domain_kwargs.setdefault("sources", False)
    base = _domain(tmp_path, **domain_kwargs)
    src = os.path.join(base, "sources")
    os.makedirs(src, exist_ok=True)
    shutil.copy(os.path.join(FIXTURE_DIR, xml), src)
    with open(os.path.join(src, xml), "rb") as handle:
        body = handle.read()
    _write(src, os.path.splitext(xml)[0] + ".meta.yaml",
          template.format(sha=hashlib.sha256(body).hexdigest()))
    return base


def _add_second_source(domain, template):
    """A second pinned document beside `_domain_with_meta`'s first, reusing
    the single-subtree fixture body under a new filename -- the content does
    not matter to this module, only that two independent sidecars exist, and
    `SECOND_SOURCE_META` declares an `extract:` block so the body has to be
    one this reader accepts as a cut."""
    src = os.path.join(domain, "sources")
    shutil.copy(os.path.join(FIXTURE_DIR, "fixture_extract.xml"),
               os.path.join(src, "second_statute.xml"))
    with open(os.path.join(src, "second_statute.xml"), "rb") as handle:
        body = handle.read()
    _write(src, "second_statute.meta.yaml",
          template.format(sha=hashlib.sha256(body).hexdigest()))
    return domain


def test_a_full_sidecar_is_emitted_as_one_sources_entry(tmp_path):
    domain = _domain_with_meta(tmp_path, FULL_SOURCE_META)
    document = ct.build_document(domain)
    assert len(document["sources"]) == 1
    src = document["sources"][0]
    assert src["doc_id"] == "FIXTURE"
    assert src["celex"] == "32006L0112"
    assert src["consolidated"] == "2025-01-01"
    assert src["format"] == "fmx4"
    assert src["url"] == "https://example.invalid/fixture"
    assert src["file"] == "fixture_extract.xml"
    assert src["extract"] == {
        "root": "chp_2", "from": "173", "to": "175",
        "method": "cut at the chapter boundary",
        "source_sha256": "deadbeef", "verified": "checked 2026-01-01",
    }


def test_only_the_required_three_fields_are_emitted_nothing_else_is(tmp_path):
    """ABSENT STAYS ABSENT, carried all the way to the artifact: a sidecar
    naming only doc_id/file/sha256 must produce an entry with ONLY those
    three keys -- no `celex: ""`, no `extract: null`. A mutation that
    defaulted an absent field to `""` would add a fourth key here and this
    assertion would catch it."""
    domain = _domain_with_meta(tmp_path, REQUIRED_ONLY_SOURCE_META)
    document = ct.build_document(domain)
    assert len(document["sources"]) == 1
    assert set(document["sources"][0]) == {"doc_id", "file", "sha256"}


def test_a_domain_with_no_pinned_statute_has_no_sources_key_at_all(tmp_path):
    """Mirrors `_label_rows`: an untraced domain reads as "not asked", never
    as "asked and found nothing pinned" -- so `sources:` must be ABSENT, not
    `[]`."""
    domain = _domain(tmp_path, sources=False)
    document = ct.build_document(domain)
    assert "sources" not in document


def test_two_pinned_documents_get_two_independent_source_entries(tmp_path):
    domain = _add_second_source(
        _domain_with_meta(tmp_path, FULL_SOURCE_META), SECOND_SOURCE_META)
    document = ct.build_document(domain)
    sources = document["sources"]
    assert [s["doc_id"] for s in sources] == ["FIXTURE", "SECOND"]  # (doc_id, file) tuple order
    # A FRESH dict per entry: a mutation that built one row and returned it
    # twice, or shared the ledger's own `extract` object between rows, would
    # make one or both of these identity checks fail even though the VALUES
    # still looked right.
    assert sources[0] is not sources[1]
    assert sources[0]["extract"] is not sources[1]["extract"]
    assert sources[0]["doc_id"] == "FIXTURE" and sources[1]["doc_id"] == "SECOND"


def test_two_pinned_documents_emit_no_yaml_anchors(tmp_path):
    """The same trap `test_the_emitted_labels_carry_no_yaml_anchors` proves
    for `labels:`: a shared dict object anywhere under `sources:` would put
    an `&id001`/`*id001` pair into a committed artifact that spec §8 promises
    a renderer can read standalone."""
    domain = _add_second_source(
        _domain_with_meta(tmp_path, FULL_SOURCE_META), SECOND_SOURCE_META)
    _, out_path = _emit(domain, tmp_path)
    with open(out_path, encoding="utf-8") as handle:
        text = handle.read()
    assert "&id" not in text and "*id" not in text


def test_sources_emit_is_byte_identical_across_runs(tmp_path):
    domain = _domain_with_meta(tmp_path, FULL_SOURCE_META)
    first = os.path.join(str(tmp_path), "first.yaml")
    second = os.path.join(str(tmp_path), "second.yaml")
    ct.emit(domain, first)
    ct.emit(domain, second)
    with open(first, "rb") as a, open(second, "rb") as b:
        assert a.read() == b.read()


# ── T6: exclusions, the second scope relation (spec §13.21) ─────────────────
#
# An exclusion says "not my scope, by design"; a deferral says "in my scope,
# not done yet". The split exists because once a domain PINS, a deferral of a
# NEIGHBOURING article is unwritable — T3 rejects an entry naming no units and
# the resolver resolves against the extract, so every door is shut and four
# independent authors moved their boundaries into prose nothing checks.

#: An exclusion naming a provision of the pinned document's INSTRUMENT that is
#: not in this extract. `FIXTURE#art_9` is well-formed, names the document this
#: domain pins, and resolves to no unit of it — the shape a real exclusion has.
EXCLUSION = '''excluded_set:
  - what: life_cycle_costing
    cites: ["FIXTURE#art_9"]
    reason: "Art 9 prescribes a separate determination."
    consequence: "A caller relying on this verdict must run Art 9 itself."
'''

ORDER_WITH_EXCLUSION = ORDER + '''excluded_set:
  - { what: life_cycle_costing, reason: "Art 9 is a separate determination" }
'''


def _excl(problems):
    return [p for p in problems if p.startswith("T6 ")]


def _with_exclusion(tmp_path, block=EXCLUSION, order=ORDER_WITH_EXCLUSION):
    return _with_order(_domain(tmp_path, manifest=MANIFEST + block,
                              parameters=PARAMETERS), order=order)


def test_a_well_formed_exclusion_passes(tmp_path):
    built = _ledger.build(_with_exclusion(tmp_path))
    assert _excl(ct.check_domain(_with_exclusion(tmp_path))) == []
    assert [e["what"] for e in built["exclusions"]] == ["life_cycle_costing"]
    assert built["exclusion_labels"] == {"life_cycle_costing": "authorized"}


def test_an_exclusion_citing_nothing_states_no_boundary(tmp_path):
    block = EXCLUSION.replace('cites: ["FIXTURE#art_9"]', "cites: []")
    problems = _excl(ct.check_domain(_with_exclusion(tmp_path, block=block)))
    assert len(problems) == 1
    assert "excludes nothing" in problems[0]


def test_an_exclusion_citing_a_unit_of_its_OWN_extract_is_refused(tmp_path):
    """The load-bearing check. `FIXTURE#art_3__para_1` IS a unit of this
    domain's pin, so excluding it would remove a provision from the RED backlog
    with no deferral accounting for it — a deferral wearing the wrong hat."""
    block = EXCLUSION.replace('"FIXTURE#art_9"', f'"{DEROGATION}"')
    problems = _excl(ct.check_domain(_with_exclusion(tmp_path, block=block)))
    assert len(problems) == 1
    assert "OWN extract" in problems[0]
    assert "Move it to deferred_set" in problems[0]


def test_an_exclusion_naming_an_unpinned_document_is_refused(tmp_path):
    block = EXCLUSION.replace('"FIXTURE#art_9"', '"32014L0065#art_9"')
    problems = _excl(ct.check_domain(_with_exclusion(tmp_path, block=block)))
    assert len(problems) == 1
    assert "does not pin" in problems[0]
    assert "it pins FIXTURE" in problems[0]


def test_an_exclusion_naming_an_unpinned_document_is_ACCEPTED_with_instrument(
        tmp_path):
    """A CROSS-INSTRUMENT boundary is a real scope statement and often the most
    useful thing a register can say -- eu/procurement/utilities_negotiated_
    without_prior_call pins Directive 2014/25 and its first exclusion is
    precisely that Art 32 of Directive 2014/24, the public-sector equivalent
    gateway, is somebody else's question. `instrument:` is how the author says
    so, exactly as `deferred_set` already allows it (spec 13.22). Operator
    ruling 2026-09-05."""
    block = EXCLUSION.replace('"FIXTURE#art_9"', '"32014L0065#art_9"').replace(
        "    reason:", "    instrument: \"Directive 2014/65/EU\"\n    reason:")
    problems = _excl(ct.check_domain(_with_exclusion(tmp_path, block=block)))
    assert problems == [], problems


def test_an_unpinned_exclusion_without_instrument_is_still_refused(tmp_path):
    """The escape hatch is the NAMING, not the foreignness: an entry that just
    cites a document nobody pinned is still an unchecked claim, and the message
    has to say what would make it checkable."""
    block = EXCLUSION.replace('"FIXTURE#art_9"', '"32014L0065#art_9"')
    problems = _excl(ct.check_domain(_with_exclusion(tmp_path, block=block)))
    assert len(problems) == 1
    assert "does not pin" in problems[0]
    assert "instrument:" in problems[0]


def test_an_exclusion_with_a_blank_instrument_is_refused(tmp_path):
    """`instrument:` present but empty buys the exemption while naming nothing
    -- the same trap `deferred_set` closes."""
    block = EXCLUSION.replace('"FIXTURE#art_9"', '"32014L0065#art_9"').replace(
        "    reason:", "    instrument: \"   \"\n    reason:")
    problems = _excl(ct.check_domain(_with_exclusion(tmp_path, block=block)))
    assert any("instrument:" in p and "blank" in p for p in problems), problems


def test_an_exclusion_selector_with_no_doc_id_is_refused(tmp_path):
    block = EXCLUSION.replace('"FIXTURE#art_9"', '"art_9"')
    problems = _excl(ct.check_domain(_with_exclusion(tmp_path, block=block)))
    assert len(problems) == 1
    assert "not a provision id" in problems[0]


def test_an_exclusion_with_an_empty_consequence_is_refused(tmp_path):
    block = EXCLUSION.replace(
        '    consequence: "A caller relying on this verdict must run Art 9 itself."\n',
        '    consequence: ""\n')
    problems = _excl(ct.check_domain(_with_exclusion(tmp_path, block=block)))
    assert len(problems) == 1
    assert "empty consequence" in problems[0]


def test_a_what_in_BOTH_relations_is_a_contradiction(tmp_path):
    """Deferring part of a determination and excluding another part is
    legitimate — but then the two parts have different names. One name in both
    says the entry is two things at once."""
    block = EXCLUSION.replace("what: life_cycle_costing", "what: derogation")
    problems = _excl(ct.check_domain(_with_exclusion(tmp_path, block=block)))
    assert any("is also in deferred_set" in p for p in problems)
    assert any("name the two parts differently" in p for p in problems)


def test_an_order_exclusion_absent_from_the_register_is_scope_drift(tmp_path):
    domain = _with_order(_domain(tmp_path, parameters=PARAMETERS),
                        order=ORDER_WITH_EXCLUSION)
    problems = _order(ct.check_domain(domain))
    assert len(problems) == 1
    assert "excluded_set" in problems[0] and "life_cycle_costing" in problems[0]
    assert "its cites" in problems[0]


def test_a_register_exclusion_beyond_the_order_is_an_expansion_not_a_problem(tmp_path):
    """The same asymmetry §6 keeps for deferrals: the register COMPLETES the
    order, so an unordered exclusion is labelled, never failed."""
    domain = _with_exclusion(tmp_path, order=ORDER)
    assert _order(ct.check_domain(domain)) == []
    built = _ledger.build(domain)
    assert built["exclusion_labels"] == {"life_cycle_costing": "expansion"}


def test_exclusions_CANNOT_reduce_the_unaccounted_count(tmp_path):
    """The property that makes the relation safe (spec §13.21). §6's
    escape-hatch worry does not transfer: everything an exclusion may legally
    name is outside the extract, so excluding a great deal still leaves every
    one of this domain's own units RED. Asserted, not assumed."""
    many = "excluded_set:\n" + "".join(
        f'  - what: boundary_{n}\n    cites: ["FIXTURE#art_9{n}"]\n'
        f'    reason: "r{n}"\n    consequence: "c{n}"\n' for n in range(6))
    bare = _domain(tmp_path, parameters=PARAMETERS)
    with_many = _domain(tmp_path, manifest=MANIFEST + many,
                       parameters=PARAMETERS)
    before, after = _ledger.build(bare), _ledger.build(with_many)
    assert after["unaccounted"] == before["unaccounted"]
    assert after["covered"] == before["covered"]
    assert after["deferred"] == before["deferred"]
    assert len(after["exclusions"]) == 6


def test_the_headline_counts_exclusions_after_the_semicolon(tmp_path):
    """Outside the `N units:` breakdown, because an exclusion names provisions
    outside the unit total — folding it in would stop the parts summing to the
    whole."""
    built = _ledger.build(_with_exclusion(tmp_path))
    line = ct.headline(built)
    units_part, _, tail = line.partition(";")
    assert "excluded" not in units_part
    assert tail.strip().endswith("1 excluded")


def test_a_domain_with_no_excluded_set_says_nothing_about_exclusions(tmp_path):
    built = _ledger.build(_domain(tmp_path, parameters=PARAMETERS))
    assert built["exclusions"] == []
    assert "excluded" not in ct.headline(built)
    assert _excl(ct.check_domain(_domain(tmp_path, parameters=PARAMETERS))) == []


def test_the_emitted_artifact_carries_exclusions_without_verbatim_text(tmp_path):
    document = ct.build_document(_with_exclusion(tmp_path))
    assert document["exclusions"] == [{
        "what": "life_cycle_costing",
        "cites": ["FIXTURE#art_9"],
        "reason": "Art 9 prescribes a separate determination.",
        "consequence": "A caller relying on this verdict must run Art 9 itself.",
        "label": "authorized"}]
    assert document["order"]["excluded_set"] == ["life_cycle_costing"]


def test_T6_is_silent_on_an_UNTRACED_domain(tmp_path):
    """The ratchet's boundary, not the check's — the same placement §6 and T3
    have. An unpinned domain pins no document, so every `cites:` would name an
    unpinned doc_id and the check would redden domains that never entered the
    campaign. That is the disturbance the three states exist to prevent."""
    domain = _domain(tmp_path, manifest=MANIFEST + EXCLUSION,
                    parameters=PARAMETERS, sources=False)
    problems = ct.check_domain(domain)
    assert _excl(problems) == []
    assert not ct.is_traced(_ledger.build(domain))


# ── T7: operative readings, the interpretive register (spec §13.23) ─────────
#
# NOT a scope relation. A reading's units are normally ALSO covered by a rule:
# it says "this domain DOES formalize this provision, and here is the contested
# way it reads it". So its units must resolve INSIDE the extract — the opposite
# polarity to an exclusion — and a unit both covered and read is normal.

READING = '''operative_readings:
  - what: derogation_is_narrow
    units: ["%s"]
    question: "Does Art 3 permit derogation from the rate, or from the whole rule?"
    readings:
      - id: narrow
        conservative: true
        consequence: "Only the rate may be derogated from; the rule still binds."
      - id: broad
        consequence: "The whole rule may be disapplied."
    chosen: narrow
    rationale: "The narrower reading; a wrong narrow answer under-claims."
    authority: none
    attested: ~
''' % DEROGATION

ORDER_WITH_READING = ORDER + '''operative_readings:
  - { what: derogation_is_narrow, reason: "Art 3's scope is contested" }
'''

REVIEWED = '''    attested:
      by: "A. Lawyer"
      role: "VAT counsel"
      date: "2026-08-20"
'''


def _t7(problems):
    return [p for p in problems if p.startswith("T7 ")]


def _with_reading(tmp_path, block=READING, order=ORDER_WITH_READING):
    return _with_order(_domain(tmp_path, manifest=MANIFEST + block,
                              parameters=PARAMETERS), order=order)


COMMISSIONED = """commissioned:
  date: 2026-08-20
  engine: deadbeef
  greens: [run-1]
  attested_by: operator
"""


def test_an_unreviewed_reading_does_NOT_block_the_engineering_gate(tmp_path):
    """THE RULING (spec §13.23, 2026-08-20). A defensible reading,
    chosen by weighing the evidence and RECORDED AS CONTESTED, is enough to
    build on. `provision_tracking: enforced` is the engineering gate — that
    provision tracking is maintained and drift fails CI — and stopping it on a
    question only a lawyer can answer is the wrong trade.

    This was a `problems` entry until today, which is exactly what it must not
    be."""
    domain = _with_reading(tmp_path)
    assert _t7(ct.check_domain(domain)) == []
    assert not any("review" in p.lower() for p in ct.check_domain(domain))


def test_but_the_obligation_is_recorded_and_printed_on_every_run(tmp_path):
    """The bargain: the question was RECORDED, not answered. If the record
    were silent the ruling would be a licence rather than a trade."""
    built = _ledger.build(_with_reading(tmp_path))
    obligations = ct.review_obligations(built)
    assert len(obligations) == 1
    assert "awaiting review" in obligations[0]
    assert "COMMISSIONING.md H1" in obligations[0]
    assert "1 operative reading(s), 1 UNREVIEWED" in ct.headline(built)


def test_an_attested_reading_leaves_the_queue(tmp_path):
    block = READING.replace("    attested: ~\n", REVIEWED)
    built = _ledger.build(_with_reading(tmp_path, block=block))
    assert ct.review_obligations(built) == []
    assert _t7(ct.check_domain(_with_reading(tmp_path, block=block))) == []


def test_attested_with_nobody_named_is_NOT_attested(tmp_path):
    """'Someone checked this' with no one named is the claim the field exists
    to stop being makeable. `attested: true` must not clear it."""
    for forged in ("    attested: true\n",
                   "    attested:\n      role: \"VAT counsel\"\n"):
        block = READING.replace("    attested: ~\n", forged)
        built = _ledger.build(_with_reading(tmp_path, block=block))
        assert ct.review_obligations(built), forged


def test_declaring_COMMISSIONED_on_an_unsigned_reading_IS_a_problem(tmp_path):
    """H1 is the bar an unsigned reading does block. `commissioned:` is the
    corpus's own declaration that a domain is in service, and COMMISSIONING.md
    H1 says the attestation is a human signature, not a machine verdict — so it
    cannot be inferred from everything else being green."""
    block = READING + "\n" + COMMISSIONED
    problems = ct.check_domain(_with_reading(tmp_path, block=block))
    h1 = [p for p in problems if p.startswith("H1 ")]
    assert len(h1) == 1
    assert "in service" in h1[0]
    assert "withdraw the `commissioned:` block" in h1[0]


def test_a_commissioned_domain_whose_readings_ARE_signed_passes_H1(tmp_path):
    block = READING.replace("    attested: ~\n", REVIEWED) + "\n" + COMMISSIONED
    problems = ct.check_domain(_with_reading(tmp_path, block=block))
    assert [p for p in problems if p.startswith("H1 ")] == []


def test_a_domain_that_never_claimed_COMMISSIONED_is_not_failing_H1(tmp_path):
    """The same asymmetry the enforcement ratchet keeps: a domain that has not
    made the claim is not failing it."""
    problems = ct.check_domain(_with_reading(tmp_path))
    assert [p for p in problems if p.startswith("H1 ")] == []
    assert _ledger.build(_with_reading(tmp_path))["commissioned"] is None


def test_a_reading_whose_units_are_OUTSIDE_the_extract_is_refused(tmp_path):
    """The opposite polarity to T6. A reading interprets text this domain
    pinned; one naming an unpinned provision is interpreting from a distance."""
    block = READING.replace(DEROGATION, "FIXTURE#art_99")
    problems = _t7(ct.check_domain(_with_reading(tmp_path, block=block)))
    assert any("must be in the extract" in p for p in problems)


def test_a_unit_both_COVERED_and_READ_is_normal_not_a_contradiction(tmp_path):
    """The case §13.18 item 1 refuses for deferrals is the NORMAL case here.
    A check reusing the scope machinery would flag every correct entry."""
    covered = "FIXTURE#art_1__para_1"
    block = READING.replace(DEROGATION, covered)
    domain = _with_reading(tmp_path, block=block)
    built = _ledger.build(domain)
    assert covered in built["covered"]
    assert covered not in built["contradicted"]
    # NOTHING complained that a unit is both covered and read.
    assert _t7(ct.check_domain(domain)) == []


def test_one_reading_is_not_a_choice(tmp_path):
    block = READING.replace('''      - id: broad
        consequence: "The whole rule may be disapplied."
''', "")
    problems = _t7(ct.check_domain(_with_reading(tmp_path, block=block)))
    assert any("fewer than two readings" in p for p in problems)


def test_chosen_must_name_a_reading_or_split(tmp_path):
    bad = _t7(ct.check_domain(_with_reading(
        tmp_path, block=READING.replace("chosen: narrow", "chosen: sideways"))))
    assert any("is not one of the readings" in p for p in bad)
    ok = _t7(ct.check_domain(_with_reading(
        tmp_path, block=READING.replace("chosen: narrow", "chosen: split"))))
    assert not any("is not one of the readings" in p for p in ok)


def test_an_absent_authority_is_refused_rather_than_defaulted(tmp_path):
    """An absent authority reads as the safe case and is the unsafe one."""
    block = READING.replace("    authority: none\n", "")
    problems = _t7(ct.check_domain(_with_reading(tmp_path, block=block)))
    assert any("empty authority" in p for p in problems)


def test_two_readings_marked_conservative_is_refused(tmp_path):
    block = READING.replace('''      - id: broad
        consequence:''', '''      - id: broad
        conservative: true
        consequence:''')
    problems = _t7(ct.check_domain(_with_reading(tmp_path, block=block)))
    assert any("at most one can be the safer side" in p for p in problems)


def test_leaving_the_conservative_reading_is_an_ADVISORY_never_a_problem(tmp_path):
    """A legitimate choice — the conservative reading is sometimes simply
    wrong — so it cannot block. It is the review queue's sharpest sort key."""
    block = READING.replace("chosen: narrow", "chosen: broad")
    domain = _with_reading(tmp_path, block=block)
    document = ct.build_document(domain)
    assert any("more conservative" in a for a in document["advisories"])
    # Against EVERY problem, not just the T7-prefixed ones: an advisory
    # promoted into the problem list would not carry a T7 prefix, so a filtered
    # assertion here would pass while the check had started blocking.
    assert not any("conservative" in p for p in ct.check_domain(domain))


def test_readings_CANNOT_change_coverage(tmp_path):
    """Same property the exclusions have, for a different reason and so
    asserted separately: a reading is neither covered nor deferred BY BEING
    DECLARED. Its units are covered by the rule that cites them, or not."""
    bare = _ledger.build(_domain(tmp_path, parameters=PARAMETERS))
    with_reading = _ledger.build(_with_reading(tmp_path))
    for key in ("covered", "deferred", "unaccounted", "contradicted"):
        assert with_reading[key] == bare[key], key


def test_the_headline_says_how_many_readings_are_unreviewed(tmp_path):
    line = ct.headline(_ledger.build(_with_reading(tmp_path)))
    assert "1 operative reading(s), 1 UNREVIEWED" in line
    block = READING.replace("    attested: ~\n", REVIEWED)
    reviewed = ct.headline(_ledger.build(_with_reading(tmp_path, block=block)))
    assert "1 operative reading(s), all reviewed" in reviewed


def test_a_domain_with_no_readings_says_nothing_about_them(tmp_path):
    built = _ledger.build(_domain(tmp_path, parameters=PARAMETERS))
    assert built["operative_readings"] == []
    assert "operative reading" not in ct.headline(built)


def test_the_emitted_artifact_carries_the_review_state_explicitly(tmp_path):
    document = ct.build_document(_with_reading(tmp_path))
    entry = document["operative_readings"][0]
    assert entry["reviewed"] is False
    assert entry["authority"] == "none"
    assert entry["chosen"] == "narrow"
    assert [r["id"] for r in entry["readings"]] == ["narrow", "broad"]
    assert document["order"]["operative_readings"] == ["derogation_is_narrow"]


def test_the_obligation_is_PRINTED_beside_a_clean_verdict(tmp_path, capsys):
    """The load-bearing half of the ruling. Engineering proceeds on
    a recorded, defensible reading — so the run says OK — and the record has to
    be on the same screen, or the ruling is a licence rather than a trade.

    A reader must see both: the gate is clean AND four interpretations of the
    law are unsigned."""
    ct.main([_with_reading(tmp_path)])
    out = capsys.readouterr().out
    assert "AWAITING REVIEW:" in out
    assert "1 operative reading(s), 1 UNREVIEWED" in out
    assert "OK" in out
    assert "PROBLEM:" not in out


def test_the_artifact_carries_the_obligation_as_its_own_key(tmp_path):
    """Not a problem, not an advisory. A reader of `provisions.yaml` must not
    have to infer 'nobody has checked this interpretation' from the shape of
    an `attested` field, nor mistake it for a defect."""
    document = ct.build_document(_with_reading(tmp_path))
    assert len(document["review_obligations"]) == 1
    assert document["problem_count"] == 0
    assert document["operative_readings"][0]["awaiting_review"] is True


# ── problems_by_check: per-family counts for the S5 scoreboard ───────────────
# (harness plan docs/superpowers/plans/2026-08-27-s5-scoreboard-ledger-verdicts.md,
#  Task 1. Counts, never strings: strings are machine-dependent and the artifact
#  is committed byte-deterministic; counts are not.)

def test_problems_by_check_partitions_the_scored_count(tmp_path):
    """KERNEL_ONE_GAP adds a clause carrying no implements(...), which is a T1 -- a
    RULE WITH NO PROVISION. It is not a T2; the harness plan's draft of this
    test asserted T2 and was wrong about the fixture."""
    domain = _domain(tmp_path, kernel=KERNEL_ONE_GAP)
    document, _ = _emit(domain, tmp_path)
    by = document["problems_by_check"]
    assert by["T1"] == 1
    assert sum(by.values()) == document["problem_count"]
    assert set(by) == {"T1", "T2", "T3", "T5", "T6", "T7", "H1", "§6",
                       "reader", "other"}


def test_problems_by_check_tells_the_two_coverage_directions_apart(tmp_path):
    """T1 is a rule with no provision; T2 is a provision with no rule. The
    consumer treats them DIFFERENTLY -- T2 gates `clean`, T1 is reported beside
    it as annotation debt -- so a partition that lumped them would silently let
    annotation debt withhold a green. Same fixture as
    `test_t2_flags_an_unaccounted_unit`: drop the art_2b clause and point_b is
    neither formalized nor deferred."""
    kernel = KERNEL.replace(
        "\nsupply_b(P) <- (\n    implements(art_2b),\n    prof_get(P, t, T)\n)\n", "")
    document, _ = _emit(_domain(tmp_path, kernel=kernel), tmp_path)
    by = document["problems_by_check"]
    assert by["T2"] == 1
    assert by["T1"] == 0
    assert sum(by.values()) == document["problem_count"]


def test_a_clean_domain_reports_all_zero(tmp_path):
    domain = _domain(tmp_path)
    document, _ = _emit(domain, tmp_path)
    assert set(document["problems_by_check"].values()) == {0}
    assert document["problem_count"] == 0


def test_reader_problems_get_their_own_key_not_other(tmp_path):
    """The scoreboard refuses a verdict when the readers failed (a withheld
    document DEFLATES the T2 denominator, so a broken pin scores cleaner than
    a working one). Burying reader failures under `other` would hide exactly
    the state that may never read clean."""
    domain = _domain(tmp_path)
    meta = os.path.join(domain, "sources", "fixture_statute.meta.yaml")
    with open(meta, encoding="utf-8") as handle:
        text = handle.read()
    with open(meta, "w", encoding="utf-8") as handle:
        handle.write(re.sub(r'sha256: "[0-9a-f]{64}"',
                            'sha256: "' + "0" * 64 + '"', text))
    document = ct.build_document(domain)
    assert document["problems_by_check"]["reader"] >= 1
    assert sum(document["problems_by_check"].values()) == document["problem_count"]


def test_a_reordered_scored_list_fails_loudly_rather_than_miscounting(tmp_path):
    """`_problems_by_check` slices the reader prefix off by POSITION, on
    `_scored_problems`'s stated contract that `built["problems"]` comes first in
    every tracking state. Position is right -- two checks can legitimately emit
    equal text for different units, so partitioning by identity would make
    duplicates ambiguous in a way position never is. But the coupling must be
    LOUD: if that ordering ever changes, reader problems would silently be
    reattributed to whichever family sorts first, and a broken pin would start
    scoring as annotation debt."""
    built = {"problems": ["reader: a pin moved"]}
    try:
        ct._problems_by_check(["T1 something", "reader: a pin moved"], built)
    except RuntimeError as exc:
        assert "no longer open with the reader prefix" in str(exc)
    else:
        assert False, "a reordered scored list must raise, not miscount"


def test_every_tag_a_check_emits_is_registered(tmp_path):
    """The `other` fallback keeps the sum invariant (the artifact's
    self-consistency rests on it), but it means a NEW check family is invisible
    as a category until someone adds its tag. This fails the day that happens,
    which is when you want to hear about it -- not months later reading a
    scoreboard where a whole family silently counted as `other`."""
    domain = _domain(tmp_path, kernel=KERNEL_ONE_GAP)
    built = _ledger.build(domain)
    emitted = {p.split(" ", 1)[0] for p in ct._scored_problems(domain, built)}
    tag_shaped = {t for t in emitted if re.fullmatch(r"(T\d+|§[\d.]+)", t)}
    assert tag_shaped <= set(ct._CHECK_TAGS), (
        f"unregistered check tag(s) {tag_shaped - set(ct._CHECK_TAGS)} — add them "
        f"to _CHECK_TAGS or they count as `other`")


def test_an_output_list_cite_is_not_a_provenance_marker(tmp_path):
    """The rename's whole point (2026-08-28). `cite` is the DATA CONSTRUCTOR a
    verdict uses to return its citation list; `implements` is the provenance
    marker. Before the rename this scanner could not tell them apart, so a
    clause that merely BUILT its output list passed T1 without ever declaring
    what it implements -- eu/procurement/thresholds' `decide_threshold` was
    exactly that, passing on `CITATIONS is [cite(eu_dir_2014_24_art_4)]`.

    This test fails if CITE_FUNCTOR is ever pointed back at `cite`."""
    kernel = KERNEL + (
        "\nverdict_of(P, out(CITES)) <- (\n"
        "    prof_get(P, r, _),\n"
        "    CITES is [cite(art_1)]\n"
        ")\n")
    problems = ct.check_domain(_domain(tmp_path, kernel=kernel))
    assert any("verdict_of" in p and p.startswith("T1 ") for p in problems), (
        "a clause whose only cite(...) is an output-list TERM must still be "
        "T1-flagged: building a citation list is not declaring provenance")


# ── Test/1 is a test-harness predicate, not law ──────────────────────────────
# Measured 2026-08-28: 26 of the corpus's 460 T1 flags are `Test(...)` clauses
# inline in eu/procurement/espd/espd.clausal. Asking a test predicate to cite
# statute is a category error, and it is the same exemption EXEMPT_BASENAMES
# already makes by FILE (queries.clausal -- "call surface, not law"), applied
# by FUNCTOR instead. Structural, so no domain has to declare anything.

def test_a_test_clause_in_an_operative_file_is_not_law(tmp_path):
    kernel = KERNEL + (
        '\nTest("rate: a smoke case") <- (\n'
        '    rate(fixture_profile, _)\n'
        ')\n')
    problems = ct.check_domain(_domain(tmp_path, kernel=kernel))
    assert not any("Test" in p and p.startswith("T1 ") for p in problems), (
        "Test/1 is a test-harness predicate; requiring a citation from it asks "
        "a test to implement law")


# ── no_statute reasons come from a closed vocabulary ─────────────────────────
# `no_statute` is the T1-side twin of defer_unit's laundering hole: the honest
# path (find the provision, quote it, cite it) can FAIL and the escape hatch
# ALWAYS succeeds. Free text hides how often it is taken; a closed vocabulary
# makes it countable, so a domain exempting most of its predicates as
# `interface_shape` is visible in a way "no statutory basis" never is.

def test_a_no_statute_reason_outside_the_vocabulary_is_a_problem(tmp_path):
    domain = _domain(tmp_path, kernel=KERNEL + (
        '\nhelper(P) <- (\n    prof_get(P, r, _)\n)\n'
        '\nno_statute("helper", 1, "it just does not have one"),\n'))
    problems = ct.check_domain(domain)
    assert any("helper" in p and "vocabulary" in p for p in problems), problems


def test_each_vocabulary_value_is_accepted(tmp_path):
    for reason in ct.NO_STATUTE_REASONS:
        domain = _domain(tmp_path / reason, kernel=KERNEL + (
            '\nhelper(P) <- (\n    prof_get(P, r, _)\n)\n'
            f'\nno_statute("helper", 1, "{reason}"),\n'))
        problems = ct.check_domain(domain)
        assert not any("helper" in p and "vocabulary" in p for p in problems), (
            reason, problems)


def test_statute_owned_elsewhere_must_name_the_owning_domain(tmp_path):
    """The fifth value, added on the sibling session's evidence (2026-08-28).

    A predicate can implement law whose UNIT is not in this domain's pinned
    extract -- thresholds' applicable_threshold/2 carries Art 4 while calling
    art4_threshold/4 from eu.procurement.directive_2014_24.art4_thresholds. The other four values force
    that into `computation_helper` ("carries no legal content"), which is FALSE
    and reopens the laundering hole one layer down: computation_helper is the
    widest value and the least checkable, so it absorbs anything pushed at it.

    Naming the owner is what makes the claim falsifiable rather than a shrug."""
    domain = _domain(tmp_path, kernel=KERNEL + (
        '\nhelper(P) <- (\n    prof_get(P, r, _)\n)\n'
        '\nno_statute("helper", 1, "statute_owned_elsewhere"),\n'))
    problems = ct.check_domain(domain)
    assert any("helper" in p and "name the owning domain" in p for p in problems), problems


def test_statute_owned_elsewhere_with_an_owner_is_accepted(tmp_path):
    domain = _domain(tmp_path, kernel=KERNEL + (
        '\nhelper(P) <- (\n    prof_get(P, r, _)\n)\n'
        '\nno_statute("helper", 1, "statute_owned_elsewhere:eu/procurement/thresholds"),\n'))
    problems = ct.check_domain(domain)
    assert not any("helper" in p and ("vocabulary" in p or "owning domain" in p)
                   for p in problems), problems


def test_statute_owned_elsewhere_owner_must_be_a_domain_that_pins_sources(tmp_path):
    """The sibling session's sharpening (2026-08-28), and it converts a judgment
    into a check. The question is NOT "does this predicate import something" --
    by that heuristic they would have mislabelled thresholds, whose
    applicable_threshold/2 imports its lookup TABLE from eu.procurement.directive_2014_24.art4_thresholds
    while Art 4 is pinned right there in its own sources/. Data living elsewhere
    is not statute living elsewhere.

    The question is whether the UNIT is in THIS domain's pinned extract, and the
    part of that a machine can settle is the other half: the named owner has to
    exist and actually pin something. A name that resolves to nothing is the
    shrug this value exists to prevent."""
    domain = _domain(tmp_path, kernel=KERNEL + (
        '\nhelper(P) <- (\n    prof_get(P, r, _)\n)\n'
        '\nno_statute("helper", 1, "statute_owned_elsewhere:eu/nowhere/at_all"),\n'))
    problems = ct.check_domain(domain)
    assert any("helper" in p and "eu/nowhere/at_all" in p and "pins no" in p
               for p in problems), problems


# ── out-of-instrument exclusions (spec 13.22, decided 2026-08-28) ────────────
# An order may authorize excluding a provision of an instrument the domain does
# not pin ("Directive 2014/25/EU Art 28 out of scope"). Before this, the
# register had no shape for it: `deferred_set` demanded units from the pin
# (T3), `excluded_set` demanded cites T6 requires to be pinned, and omitting it
# tripped §6. `instrument:` names what was excluded and makes an empty `units:`
# legitimate for that entry ALONE.

def _instrument_manifest(instrument_line, units='units: []'):
    return ("id: fixture/domain\ndeferred_set:\n"
            "  - what: sibling_instrument\n"
            f"    {units}\n"
            f"{instrument_line}"
            '    reason: "the parallel provision of another instrument"\n'
            '    consequence: "the caller establishes which instrument governs"\n')


def test_instrument_deferral_may_name_no_units(tmp_path):
    """The whole point: T3 stops demanding units it cannot honestly have."""
    domain = _domain(tmp_path, manifest=_instrument_manifest(
        '    instrument: "Directive 2014/25/EU Art 28"\n'),
        parameters=PARAMETERS)
    assert [p for p in ct.check_domain(domain) if "defers no units" in p] == []


def test_a_unitless_deferral_without_instrument_still_fails_t3(tmp_path):
    """The rule is narrowed, not removed -- this is the case T3 was written
    for, and it must keep failing or the exemption has swallowed the check."""
    domain = _domain(tmp_path, manifest=_instrument_manifest(""),
                     parameters=PARAMETERS)
    assert [p for p in ct.check_domain(domain) if "defers no units" in p]


def test_instrument_must_not_be_blank(tmp_path):
    """An empty `instrument:` would buy the T3 exemption while naming nothing,
    which is the defect T3 exists to catch wearing a new key."""
    domain = _domain(tmp_path, manifest=_instrument_manifest(
        '    instrument: "   "\n'), parameters=PARAMETERS)
    problems = ct.check_domain(domain)
    # NOT "names nothing" -- T3's own empty-units message already contains that
    # phrase and the entry's `what` contains "instrument", so a loose assertion
    # here passes with no implementation at all. Asserted on the exact wording
    # the blank check emits.
    assert [p for p in problems if "`instrument:` is blank" in p]


def test_instrument_deferral_may_still_carry_units(tmp_path):
    """An exclusion can straddle: some pinned provisions AND an outside
    instrument. `instrument:` permits an empty list, it does not forbid a
    populated one, and the units it does name are resolved as usual."""
    domain = _domain(tmp_path, manifest=_instrument_manifest(
        '    instrument: "Directive 2014/25/EU Art 28"\n',
        units=f'units: ["{DEROGATION}"]'), parameters=PARAMETERS)
    assert [p for p in ct.check_domain(domain) if "defers no units" in p] == []
    assert [p for p in ct.check_domain(domain)
            if "defers unit" in p] == []


# ── partial deferrals (spec 13.23, decided 2026-08-29) ──────────────────────
# A deferral can be FINER THAN A RUN. `parag_050.001` is one run carrying both
# award-notice-deadline's core 30-day determination and the Annex V / Art 51
# material three deferrals point at; `parag_072.002/2` carries both the
# overall-nature bar contract_modifications determines and the net-cumulative
# aggregation its order defers. The register's finest grain is the run, so
# naming it over-claims -- and the moment such a domain is FORMALIZED the unit
# is both covered and deferred and T6 reports CONTRADICTED, correctly about the
# run and wrongly about the intent. The tempting fix is to drop a real deferral
# to silence it, which loses a scope statement and re-introduces §6 drift.
#
# `partial: true` says "part of the named run"; coverage of the same run is then
# not a contradiction. Same shape as `instrument:` (13.22): the check is right
# and the register had no way to state the case.

def _partial_manifest(flag_line, unit):
    return ("id: fixture/domain\ndeferred_set:\n"
            "  - what: an_aspect_of_the_run\n"
            f'    units: ["{unit}"]\n'
            f"{flag_line}"
            '    reason: "one sentence of a run whose other sentence is determined here"\n'
            '    consequence: "the caller establishes that aspect itself"\n')


def test_a_partial_deferral_does_not_contradict_coverage(tmp_path):
    """THE POINT. The same unit covered by a clause and partially deferred is a
    legitimate, statable position -- not a contradiction."""
    domain = _domain(tmp_path, kernel=KERNEL,
                     manifest=_partial_manifest("    partial: true\n", POINT_A),
                     parameters=PARAMETERS)
    assert [p for p in ct.check_domain(domain) if "CONTRADICT" in p.upper()] == []


def test_WITHOUT_the_flag_the_same_shape_still_contradicts(tmp_path):
    """The rule is narrowed, not removed. A whole-unit deferral of something the
    domain also covers remains the defect T6 exists to report."""
    domain = _domain(tmp_path, kernel=KERNEL,
                     manifest=_partial_manifest("", POINT_A),
                     parameters=PARAMETERS)
    assert [p for p in ct.check_domain(domain) if "CONTRADICT" in p.upper()]


def test_partial_must_be_a_real_boolean(tmp_path):
    """`partial: "yes"` buying the exemption by truthiness would let a typo
    silence T6."""
    domain = _domain(tmp_path, kernel=KERNEL,
                     manifest=_partial_manifest('    partial: "yes"\n', POINT_A),
                     parameters=PARAMETERS)
    assert [p for p in ct.check_domain(domain) if "partial" in p and "boolean" in p]


def test_partial_still_requires_units(tmp_path):
    """It narrows T6 only. A partial deferral naming nothing still accounts for
    nothing, so T3 is untouched."""
    domain = _domain(tmp_path, kernel=KERNEL,
                     manifest=("id: fixture/domain\ndeferred_set:\n"
                               "  - what: nothing_named\n    units: []\n"
                               "    partial: true\n"
                               '    reason: "r"\n    consequence: "c"\n'),
                     parameters=PARAMETERS)
    assert [p for p in ct.check_domain(domain) if "defers no units" in p]


# ── provision_tracking: exempt ────────────────────────────────────────────────
# A domain with no PINNABLE STATUTE is not a domain awaiting a pin, and
# UNTRACED_NOTE ("NOT an audited-clean result") reads as debt for both.
# eu/peppol_einvoicing formalizes EN 16931-1 and PEPPOL BIS, neither of which is
# legislation, so the work UNTRACED_NOTE asks for cannot be done at all.

def _built(**over):
    b = {"provision_tracking": None, "manifest_unreadable": False,
         "provision_tracking_exemption": None, "doc_units": []}
    b.update(over)
    return b


def test_exemption_needs_prose_or_it_does_not_hold():
    """An unexplained exemption would be a one-word deletion from the accounting."""
    assert ct.exemption(_built(provision_tracking="exempt")) is None
    assert ct.exemption(_built(provision_tracking="exempt",
                               provision_tracking_exemption="   ")) is None


def test_exemption_with_prose_holds_and_carries_the_reason():
    got = ct.exemption(_built(provision_tracking="exempt",
                              provision_tracking_exemption="EN 16931-1 is a CEN standard"))
    assert got == "EN 16931-1 is a CEN standard"


def test_a_normal_domain_is_never_exempt():
    assert ct.exemption(_built()) is None
    assert ct.exemption(_built(provision_tracking="enforced")) is None
    # ...including one that merely mentions the word in the wrong field
    assert ct.exemption(_built(provision_tracking_exemption="exempt please")) is None


def test_exempt_does_not_arm_the_ratchet(tmp_path):
    """Exempt is not a synonym for enforced; nothing about it blocks."""
    assert ct.is_enforced(str(tmp_path), _built(provision_tracking="exempt",
                                                provision_tracking_exemption="no statute")) is False


def test_the_exempt_note_actually_carries_the_reason():
    """The first version of this note printed a literal "{reason}" — the
    placeholder was double-escaped — so it claimed a stated reason while stating
    none. The test that was here originally could NOT have caught that: it
    skipped unless a helper existed under a guessed name, so it passed
    vacuously. A check that cannot fail is not a check."""
    note = ct.EXEMPT_NOTE.format(reason="EN 16931-1 is sold, not legislation")
    assert "{reason}" not in note
    assert "EN 16931-1 is sold, not legislation" in note
    assert "exempt" in note and "not debt" in note
