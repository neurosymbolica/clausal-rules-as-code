"""Contract tests for `propose_provisions.py --pack`.

The properties under test are Task 1's contract, not its tokens:

  * an UNTRACED domain (no `sources/`) packs with no units and never raises;
  * the pilot, `eu/vat/pro_rata_deduction` -- the corpus's ONE real, committed,
    hand-authored registry -- packs 22 units (with runs), 4 clauses, 5 citation
    records and 8 deferrals, matching the counts already corroborated by
    `test_provisions_units.py` and `test_check_provisions.py`;
  * a domain with a pinned document but no `citations.clausal` packs cleanly,
    with an empty `citation_records` list rather than a crash;
  * two packs of the same, unchanged domain are byte-identical -- the whole
    point of a diffable evidence file;
  * the tool never touches a domain directory: every fixture's file set is
    read back unchanged after packing it.

The `_domain` helper is repeated in full rather than imported from a sibling
test file's copy, matching the convention `test_check_provisions.py` states
for the same reason: a shared helper across test files is a hidden
dependency, and these tests must keep failing for their own reasons.
"""
import hashlib
import os
import shutil
import subprocess
import sys

from _tools import propose_provisions as pp
from _tools.provisions import units

FIXTURE_DIR = os.path.join(os.path.dirname(units.__file__), "fixtures")

# The real pilot domain, committed inside this repository -- not a path that
# only exists on the machine that fetched it. `test_provisions_units.py`
# already corroborates 22 units for this document three ways; this file adds
# a fourth: the pack built from `ledger.build`, not from a second XML read.
REPO_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
PILOT_DIR = os.path.join(REPO_ROOT, "eu", "vat", "pro_rata_deduction")

# Every unit id the fixture document defines, in document order (see
# `test_check_provisions.py`, which corroborates this list against the same
# fixture).
P1 = "FIXTURE#art_1__para_1"
P2 = "FIXTURE#art_1__para_2"
POINT_A = "FIXTURE#art_2__para_1__list_1__point_a"

CITATIONS = f'''-module(citations, [cite(C), implements(C), citation(ATOM, META)])

citation(art_1, {{
  label:    "Article 1",
  units:    ["{P1}", "{P2}"],
  verbatim: "The rate shall be ten per cent."
}})
'''

MANIFEST = f'''id: fixture/domain
deferred_set:
  - what: derogation
    units: ["{POINT_A}"]
    reason: "Out of scope."
    consequence: "Callers must apply national law."
'''

KERNEL = (
    "rate(P, R) <- (\n    implements(art_1),\n    prof_get(P, r, R)\n)\n"
)


def _domain(tmp_path, kernel=KERNEL, manifest=MANIFEST, citations=CITATIONS,
            sources=True, extra=None):
    """A domain NESTED two levels below the corpus root, as real ones are
    (`eu/vat/pro_rata_deduction`) -- so nothing here can pass by assuming a
    flat layout `_find_orders_dir` would not find in the real corpus."""
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


def _tree(base):
    """Every file under BASE, relative path -> content, so a test can assert
    the tool touched none of them. Reading content (not just names) catches a
    write that reuses an existing filename."""
    out = {}
    for root, _dirs, files in os.walk(base):
        for name in files:
            path = os.path.join(root, name)
            with open(path, "rb") as handle:
                out[os.path.relpath(path, base)] = handle.read()
    return out


# ── an untraced domain: no crash, no units ───────────────────────────────────

def test_an_untraced_domain_packs_with_no_units_and_does_not_crash(tmp_path):
    domain = _domain(tmp_path, sources=False, citations=None,
                      manifest="id: fixture/domain\n")
    pack = pp.build_pack(domain)
    assert pack["units"] == []
    # The domain still has an operative clause and cites it directly; the
    # ABSENCE of a pinned document does not hide clauses or their cites --
    # only units, because only units come from `sources/`.
    assert len(pack["clauses"]) == 1
    assert pack["clauses"][0]["cites"] == ["art_1"]
    assert pack["citation_records"] == []
    assert pack["problems"] == []


def test_an_untraced_domain_is_untouched_by_packing(tmp_path):
    domain = _domain(tmp_path, sources=False, citations=None,
                      manifest="id: fixture/domain\n")
    before = _tree(domain)
    pp.build_pack(domain)
    assert _tree(domain) == before


# ── the pilot: the corpus's one real, hand-authored registry ────────────────

def test_the_pilot_packs_22_units_with_runs(tmp_path):
    pack = pp.build_pack(PILOT_DIR)
    assert len(pack["units"]) == 22
    for unit in pack["units"]:
        assert unit["runs"], f"{unit['id']} has no runs"
        for run in unit["runs"]:
            assert set(run) == {"pos", "text"}


def test_the_pilot_s_parag_174_001_carries_two_runs_and_both_states(tmp_path):
    """THE CRITICAL CASE (spec §13.18 item 1). Art 174(1) is bound BOTH by
    `eu_vat_art_174_1` (its first-subparagraph run) and by the
    `subsidies_in_denominator` deferral (its second-subparagraph run) -- one
    unit, two dispositions. The ledger refuses to resolve the contradiction,
    so the pack must show both memberships rather than pick a winner."""
    pack = pp.build_pack(PILOT_DIR)
    by_id = {u["id"]: u for u in pack["units"]}
    unit = by_id["02006L0112-20250101#parag_174.001"]
    assert len(unit["runs"]) == 2
    assert unit["runs"][0]["text"].endswith("comprising the following amounts:")
    assert unit["runs"][1]["text"].startswith("Member States may include")
    assert set(unit["state"]) == {"covered", "deferred"}


def test_the_pilot_packs_4_operative_clauses_with_site_and_cites(tmp_path):
    pack = pp.build_pack(PILOT_DIR)
    assert len(pack["clauses"]) == 4
    for clause in pack["clauses"]:
        assert set(clause) == {
            "file", "line", "functor", "arity", "cites", "indirect_cite"}
        assert clause["cites"], f"{clause['functor']} has no cites"
    functors = {c["functor"] for c in pack["clauses"]}
    assert functors == {
        "rounded_up_to_next_whole_percent", "deductible_proportion_percent",
        "deductible_vat", "pro_rata_threshold"}


def test_the_pilot_packs_5_citation_records_and_what_they_bind(tmp_path):
    pack = pp.build_pack(PILOT_DIR)
    assert len(pack["citation_records"]) == 5
    by_atom = {r["atom"]: r for r in pack["citation_records"]}
    assert by_atom["eu_vat_art_174_1"]["units"] == [
        "02006L0112-20250101#parag_174.001/1"]
    assert by_atom["eu_vat_art_174_1"]["verbatim"].startswith(
        "The deductible proportion shall be made up of a fraction")
    assert pack["parameter_records"] == []


def test_the_pilot_packs_7_deferrals_and_1_exclusion_all_authorized(tmp_path):
    """The order names every one of them, so the pilot has NO expansion left --
    it named 2 while the manifest deferred 8, and the 6 unnamed ones were scope
    the domain had taken for itself (spec §13.18 item 2). The 8th, Arts 184-192,
    was never a deferral at all: it is outside the pinned extract, so it moved
    to `excluded_set` (§13.21). The expansion label is exercised on synthetic
    domains in test_check_provisions.py; this asserts the PILOT's state."""
    pack = pp.build_pack(PILOT_DIR)
    assert len(pack["deferrals"]) == 7
    assert len(pack["exclusions"]) == 1
    assert {d["label"] for d in pack["deferrals"]} == {"authorized"}
    assert {e["label"] for e in pack["exclusions"]} == {"authorized"}
    assert pack["has_order"] is True
    assert set(pack["order_deferrals"]) == {
        d["what"] for d in pack["deferrals"]}
    assert set(pack["order_exclusions"]) == {
        e["what"] for e in pack["exclusions"]}
    # `cites`, never `units` -- the shape a drafter must not be able to
    # copy-paste between the two relations.
    exclusion = pack["exclusions"][0]
    assert exclusion["what"] == "capital_goods_adjustment"
    assert "units" not in exclusion
    assert exclusion["cites"][0] == "02006L0112-20250101#art_184"


def test_packing_the_pilot_leaves_it_untouched(tmp_path):
    before = _tree(PILOT_DIR)
    pp.build_pack(PILOT_DIR)
    assert _tree(PILOT_DIR) == before


# ── a pinned domain with no citations.clausal yet ────────────────────────────

def test_a_domain_with_no_citations_file_packs_cleanly(tmp_path):
    domain = _domain(tmp_path, citations=None)
    pack = pp.build_pack(domain)
    assert pack["citation_records"] == []
    assert pack["parameter_records"] == []
    # The pinned document is still read: absence of a REGISTRY is not
    # absence of a STATUTE, and a drafter's first pack for a newly-pinned
    # domain is exactly this shape.
    assert len(pack["units"]) == 8
    # No cite in the kernel resolves to anything (there is no record), so
    # the clause's own cites are unaccounted -- reported, not hidden.
    assert pack["clauses"][0]["cites"] == ["art_1"]


def test_a_domain_with_no_citations_file_is_untouched_by_packing(tmp_path):
    domain = _domain(tmp_path, citations=None)
    before = _tree(domain)
    pp.build_pack(domain)
    assert _tree(domain) == before


# ── determinism: same domain, same bytes ─────────────────────────────────────

def test_two_packs_of_the_pilot_are_byte_identical(tmp_path):
    first = pp.dump_pack(pp.build_pack(PILOT_DIR))
    second = pp.dump_pack(pp.build_pack(PILOT_DIR))
    assert first == second


def test_two_packs_of_a_fixture_domain_are_byte_identical(tmp_path):
    domain = _domain(tmp_path)
    first = pp.dump_pack(pp.build_pack(domain))
    second = pp.dump_pack(pp.build_pack(domain))
    assert first == second


def test_the_dumped_pack_carries_the_safety_property_in_its_own_header():
    text = pp.dump_pack(pp.build_pack(PILOT_DIR))
    assert ("never writes a citations registry (citations.seam,\n"
            "# citations.clausal or citations.pl) or manifest.yaml") in text
    assert "calls no model" in text


# ── the CLI ───────────────────────────────────────────────────────────────

def test_cli_pack_to_stdout(tmp_path, capsys):
    domain = _domain(tmp_path)
    rc = pp.main(["--pack", domain])
    assert rc == 0
    out = capsys.readouterr().out
    assert out == pp.dump_pack(pp.build_pack(domain))


def test_cli_pack_to_out_path_writes_nothing_to_stdout(tmp_path, capsys):
    domain = _domain(tmp_path)
    out_path = os.path.join(str(tmp_path), "pack.yaml")
    rc = pp.main(["--pack", domain, "--out", out_path])
    assert rc == 0
    assert capsys.readouterr().out == ""
    with open(out_path, encoding="utf-8") as handle:
        written = handle.read()
    assert written == pp.dump_pack(pp.build_pack(domain))


# ── the safety property: --out may never write an enforced artifact ─────────

def test_out_refuses_citations_clausal_by_basename(tmp_path, capsys):
    domain = _domain(tmp_path)
    target = os.path.join(domain, "citations.seam")
    before = _tree(domain)
    rc = pp.main(["--pack", domain, "--out", target])
    assert rc == 1
    assert not os.path.exists(target) or _tree(domain) == before
    err = capsys.readouterr().err
    assert "citations.seam" in err
    assert "refusing to write" in err


def test_out_refuses_parameters_clausal_by_basename(tmp_path, capsys):
    domain = _domain(tmp_path)
    target = os.path.join(domain, "parameters.seam")
    rc = pp.main(["--pack", domain, "--out", target])
    assert rc == 1
    assert not os.path.exists(target)
    assert "parameters.seam" in capsys.readouterr().err


def test_out_refuses_manifest_yaml_by_basename(tmp_path, capsys):
    domain = _domain(tmp_path)
    before = _tree(domain)
    target = os.path.join(domain, "manifest.yaml")
    rc = pp.main(["--pack", domain, "--out", target])
    assert rc == 1
    # manifest.yaml already existed (the fixture wrote one) -- the refusal
    # must leave its CONTENT untouched, not merely fail to create a new file.
    assert _tree(domain) == before
    assert "manifest.yaml" in capsys.readouterr().err


def test_out_refuses_provisions_yaml_by_basename(tmp_path, capsys):
    domain = _domain(tmp_path)
    target = os.path.join(domain, "provisions.yaml")
    rc = pp.main(["--pack", domain, "--out", target])
    assert rc == 1
    assert not os.path.exists(target)
    assert "provisions.yaml" in capsys.readouterr().err


def test_out_refuses_a_relative_traversal_onto_another_domain_s_manifest(
        tmp_path, capsys):
    """`os.path.basename` does not care about a `..` prefix, so the same
    refusal fires for a path reached through a DIFFERENT domain's
    directory -- the realistic shape of a copy-pasted --out mistake."""
    domain = _domain(tmp_path)
    target = os.path.join(domain, "..", "..", "some-other-domain",
                           "manifest.yaml")
    rc = pp.main(["--pack", domain, "--out", target])
    assert rc == 1
    assert "manifest.yaml" in capsys.readouterr().err


def test_out_refuses_any_path_under_a_sources_directory(tmp_path, capsys):
    domain = _domain(tmp_path)
    target = os.path.join(domain, "sources", "extra_notes.yaml")
    before = _tree(domain)
    rc = pp.main(["--pack", domain, "--out", target])
    assert rc == 1
    assert _tree(domain) == before
    err = capsys.readouterr().err
    assert "sources" in err
    assert "refusing to write" in err


def test_out_still_accepts_an_ordinary_path(tmp_path, capsys):
    """The refusal is narrow: an --out path that is neither a protected
    basename nor under `sources/` writes exactly as before."""
    domain = _domain(tmp_path)
    out_path = os.path.join(str(tmp_path), "eu_vat_pro_rata.pack.yaml")
    rc = pp.main(["--pack", domain, "--out", out_path])
    assert rc == 0
    assert capsys.readouterr().err == ""
    with open(out_path, encoding="utf-8") as handle:
        assert handle.read() == pp.dump_pack(pp.build_pack(domain))




def test_cli_rejects_a_malformed_command_line(capsys):
    assert pp.main([]) == 2
    assert pp.main(["--pack"]) == 2
    assert pp.main(["--pack", "a", "b"]) == 2
    assert pp.main(["--pack", "a", "--out"]) == 2
    assert pp.main(["--validate", "a"]) == 2


def test_cli_subprocess_smoke(tmp_path):
    """One real subprocess invocation, using the exact PYTHONPATH the task
    prescribes, so a wiring mistake `main()`-in-process could not see (a
    module resolvable only because the test process already imported it)
    fails here."""
    domain = _domain(tmp_path)
    env = dict(os.environ)
    workspace_root = os.path.dirname(REPO_ROOT)
    env["PYTHONPATH"] = os.pathsep.join([
        os.path.join(workspace_root, "clausify", "kit"),
        os.path.join(workspace_root, "clausify"),
        os.path.join(workspace_root, "clausal"),
        REPO_ROOT,
    ])
    result = subprocess.run(
        [sys.executable, "-m", "_tools.propose_provisions", "--pack", domain],
        cwd=REPO_ROOT, env=env, capture_output=True, text=True, timeout=60)
    assert result.returncode == 0, result.stderr
    assert result.stdout == pp.dump_pack(pp.build_pack(domain))


# ═════════════════════════════════════════════════════════════════════════
# Task 2/3 -- the proposal schema, `--validate`, and verbatim validation.
# ═════════════════════════════════════════════════════════════════════════
#
# The FIXTURE domain's pinned document (`fixture_statute.xml`, via `_domain`)
# defines 8 units; the ones these tests bind against:
#
#   FIXTURE#art_1__para_1                 "The rate shall be ten per cent."
#   FIXTURE#art_1__para_2                 "The rate is rounded up to the next
#                                          whole number."
#   FIXTURE#art_2__para_1__list_1__point_a  "goods supplied for consideration;"
#
# and the default `CITATIONS`/`MANIFEST`/`KERNEL` fixtures already bind
# `art_1` (units P1, P2) and cite it from the one operative clause
# `rate/2` -- see the module docstring above.
#
# The pilot (`eu/vat/pro_rata_deduction`) supplies the one case the small
# fixture cannot: a unit with TWO runs
# (`02006L0112-20250101#parag_174.001`), the Art 174(1) shape the whole
# `units.Run` design exists for. Reusing the real, already-corroborated
# pilot data here (rather than hand-building a second two-run fixture) means
# this test exercises the exact adjacency the module docstrings warn about,
# not a synthetic stand-in for it.

PARAG_174_1 = "02006L0112-20250101#parag_174.001"


def _pilot_pack():
    return pp.build_pack(PILOT_DIR)


def _fixture_pack(tmp_path, **kwargs):
    domain = _domain(tmp_path, **kwargs)
    return domain, pp.build_pack(domain)


# ── Task 2: shape and resolution rejections ──────────────────────────────

def test_a_citation_record_unit_id_that_resolves_to_nothing_is_rejected(
        tmp_path):
    _domain_dir, pack = _fixture_pack(tmp_path)
    proposal = {"citation_records": [
        {"atom": "new_atom", "units": ["FIXTURE#no_such_unit"],
         "verbatim": "anything"},
    ]}
    problems = pp.validate_proposal(pack, proposal)
    assert problems
    assert any("no_such_unit" in p and "resolves to no unit" in p
               for p in problems), problems


def test_a_deferral_unit_id_that_resolves_to_nothing_is_rejected(tmp_path):
    _domain_dir, pack = _fixture_pack(tmp_path)
    proposal = {"deferrals": [
        {"what": "derogation", "units": ["FIXTURE#no_such_unit"]},
    ]}
    problems = pp.validate_proposal(pack, proposal)
    assert problems
    assert any("no_such_unit" in p and "resolves to no unit" in p
               for p in problems), problems


def test_a_predicate_ref_naming_no_operative_clause_is_rejected(tmp_path):
    _domain_dir, pack = _fixture_pack(tmp_path)
    proposal = {"clauses": [
        {"predicate": "does_not_exist/9", "cites": ["art_1"]},
    ]}
    problems = pp.validate_proposal(pack, proposal)
    assert problems
    assert any("does_not_exist/9" in p and "names no operative clause" in p
               for p in problems), problems


def test_a_duplicate_atom_within_the_proposal_is_rejected(tmp_path):
    _domain_dir, pack = _fixture_pack(tmp_path)
    proposal = {"citation_records": [
        {"atom": "dup_atom", "units": [P1],
         "verbatim": "The rate shall be ten per cent."},
        {"atom": "dup_atom", "units": [P2],
         "verbatim": "The rate is rounded up to the next whole number."},
    ]}
    problems = pp.validate_proposal(pack, proposal)
    assert problems
    assert any("dup_atom" in p and "duplicate" in p for p in problems), problems


def test_an_atom_already_bound_differently_is_rejected(tmp_path):
    """`art_1` is already bound (by the fixture's own `CITATIONS`) to units
    [P1, P2]. Proposing it again with only P1 is a different binding, not a
    repeat of the same one, and must be named as such."""
    _domain_dir, pack = _fixture_pack(tmp_path)
    proposal = {"citation_records": [
        {"atom": "art_1", "units": [P1],
         "verbatim": "The rate shall be ten per cent."},
    ]}
    problems = pp.validate_proposal(pack, proposal)
    assert problems
    assert any("art_1" in p and "already bound" in p for p in problems), problems


def test_reproposing_an_existing_atom_identically_is_not_a_new_rejection(
        tmp_path):
    """The inverse of the above: the SAME binding the registry already has
    is not itself a defect -- only a DIFFERENT one is."""
    _domain_dir, pack = _fixture_pack(tmp_path)
    proposal = {"citation_records": [
        {"atom": "art_1", "units": [P1, P2],
         "verbatim": "The rate shall be ten per cent."},
    ]}
    problems = pp.validate_proposal(pack, proposal)
    assert not any("already bound" in p for p in problems), problems


def test_an_existing_record_with_no_units_is_unbound_and_may_be_bound(
        tmp_path):
    """`units: []` is the NOT-YET-BOUND state (`registry._units`), and every
    usable atom already carries a `citation/2` record -- so a record with no
    units must NOT read as "already bound differently", or the loop could
    never bind the only atoms it exists to bind."""
    unbound = CITATIONS.replace(f'units:    ["{P1}", "{P2}"],',
                                'units:    [],')
    assert 'units:    []' in unbound, unbound
    _domain_dir, pack = _fixture_pack(tmp_path, citations=unbound)
    proposal = {"citation_records": [
        {"atom": "art_1", "units": [P1, P2],
         "verbatim": "The rate shall be ten per cent."},
    ]}
    problems = pp.validate_proposal(pack, proposal)
    assert not any("already bound" in p for p in problems), problems


def test_a_malformed_proposal_that_is_not_a_mapping_is_rejected(tmp_path):
    _domain_dir, pack = _fixture_pack(tmp_path)
    problems = pp.validate_proposal(pack, ["not", "a", "mapping"])
    assert problems
    assert any("mapping" in p for p in problems), problems


def test_a_citation_record_missing_a_required_key_is_rejected(tmp_path):
    _domain_dir, pack = _fixture_pack(tmp_path)
    proposal = {"citation_records": [{"atom": "no_verbatim", "units": [P1]}]}
    problems = pp.validate_proposal(pack, proposal)
    assert problems
    assert any("verbatim" in p and "missing" in p for p in problems), problems


def test_a_citation_record_with_the_wrong_type_for_units_is_rejected(
        tmp_path):
    _domain_dir, pack = _fixture_pack(tmp_path)
    proposal = {"citation_records": [
        {"atom": "bad_units", "units": "not-a-list", "verbatim": "x"}]}
    problems = pp.validate_proposal(pack, proposal)
    assert problems
    assert any("units" in p and "list of strings" in p for p in problems), \
        problems


def test_clauses_of_the_wrong_top_level_type_is_rejected(tmp_path):
    _domain_dir, pack = _fixture_pack(tmp_path)
    problems = pp.validate_proposal(pack, {"clauses": "not-a-list"})
    assert problems
    assert any("clauses" in p and "a list" in p for p in problems), problems


def test_every_rejection_is_printed_not_just_the_first(tmp_path):
    """Two INDEPENDENT defects in one proposal must both surface -- the
    whole reason `--validate` collects rather than short-circuits (spec: 'a
    drafter fixing one at a time round-trips N times')."""
    _domain_dir, pack = _fixture_pack(tmp_path)
    proposal = {
        "citation_records": [
            {"atom": "new_atom", "units": ["FIXTURE#no_such_unit"],
             "verbatim": "x"},
        ],
        "clauses": [{"predicate": "does_not_exist/9", "cites": ["art_1"]}],
    }
    problems = pp.validate_proposal(pack, proposal)
    assert any("no_such_unit" in p for p in problems), problems
    assert any("does_not_exist/9" in p for p in problems), problems
    assert len(problems) >= 2


# ── Task 2: an accepting case ────────────────────────────────────────────

def test_a_well_formed_new_proposal_is_accepted_cleanly(tmp_path):
    _domain_dir, pack = _fixture_pack(tmp_path)
    proposal = {
        "citation_records": [
            {"atom": "art_2_point_a", "units": [POINT_A],
             "verbatim": "goods supplied for consideration;",
             "label": "Article 2(1)(a)",
             "ref": "https://example.invalid/2a"},
        ],
        "clauses": [{"predicate": "rate/2", "cites": ["art_1"]}],
        "deferrals": [{"what": "derogation", "units": [POINT_A]}],
    }
    problems = pp.validate_proposal(pack, proposal)
    assert problems == []


# ── Task 3: verbatim validation against the pinned text ─────────────────

def test_an_exact_quote_is_accepted(tmp_path):
    _domain_dir, pack = _fixture_pack(tmp_path)
    proposal = {"citation_records": [
        {"atom": "art_2_point_a", "units": [POINT_A],
         "verbatim": "goods supplied for consideration;"},
    ]}
    assert pp.validate_proposal(pack, proposal) == []


def test_a_quote_with_a_word_changed_is_rejected_naming_the_divergence(
        tmp_path):
    _domain_dir, pack = _fixture_pack(tmp_path)
    proposal = {"citation_records": [
        {"atom": "art_2_point_a", "units": [POINT_A],
         "verbatim": "goods delivered for consideration;"},
    ]}
    problems = pp.validate_proposal(pack, proposal)
    assert problems
    message = next(p for p in problems if "art_2_point_a" in p)
    assert "not containment-matchable" in message
    # The matched prefix is "goods " (the word actually differs at
    # "delivered" vs "supplied"), so the message must show the point of
    # divergence, not just say "no match".
    assert "goods" in message
    assert "matched up to" in message


def test_the_verbatim_check_calls_units_matched_prefix_not_a_second_matcher(
        tmp_path, monkeypatch):
    """Task 3's own instruction: reuse `units._matched_prefix`, do not write
    a second one -- 'two matchers that disagree is this layer's recurring
    defect'. Behavioural output alone cannot distinguish a faithful reuse
    from an independent reimplementation that happens to agree on every
    fixture; this test patches the shared function itself and asserts the
    checker actually calls THROUGH it, which only a real reuse can pass."""
    _domain_dir, pack = _fixture_pack(tmp_path)
    calls = []

    def _spy(quote, text):
        calls.append((quote, text))
        return 0

    monkeypatch.setattr(pp._units, "_matched_prefix", _spy)
    proposal = {"citation_records": [
        {"atom": "art_2_point_a", "units": [POINT_A],
         "verbatim": "goods delivered for consideration;"},
    ]}
    problems = pp.validate_proposal(pack, proposal)
    assert problems
    assert calls, ("validate_proposal's verbatim check must call "
                    "units._matched_prefix rather than a matcher of its own")


def test_a_quote_spanning_two_runs_is_rejected(tmp_path):
    """`parag_174.001` in the real pilot document is the Art 174(1) shape:
    a lead-in run, then its lettered points (separate units), then a second
    run. Joining the two runs fabricates a sentence the Directive does not
    contain (see units.py's module docstring) -- a quote built exactly that
    way must be rejected even though EACH half, alone, is real text."""
    pack = _pilot_pack()
    by_id = {u["id"]: u for u in pack["units"]}
    unit = by_id[PARAG_174_1]
    assert len(unit["runs"]) == 2, "pilot fixture shape changed"
    fabricated = (unit["runs"][0]["text"].strip() + " "
                  + unit["runs"][1]["text"].strip())
    assert "comprising the following amounts:" in fabricated
    assert "Member States may include" in fabricated
    proposal = {"citation_records": [
        {"atom": "new_art_174_1", "units": [PARAG_174_1],
         "verbatim": fabricated},
    ]}
    problems = pp.validate_proposal(pack, proposal)
    assert problems
    assert any("new_art_174_1" in p and "not containment-matchable" in p
               for p in problems), problems


def test_a_quote_from_a_different_unit_is_rejected(tmp_path):
    """The quote is real text of the document -- P2's own sentence -- but
    the record binds only P1, whose run does not contain it."""
    _domain_dir, pack = _fixture_pack(tmp_path)
    proposal = {"citation_records": [
        {"atom": "mismatched", "units": [P1],
         "verbatim": "The rate is rounded up to the next whole number."},
    ]}
    problems = pp.validate_proposal(pack, proposal)
    assert problems
    assert any("mismatched" in p and "not containment-matchable" in p
               for p in problems), problems


def test_a_quote_whose_unit_id_the_record_does_not_bind_is_rejected(
        tmp_path):
    """Same mechanism as the previous case from the other angle: the record
    binds P2 only, and quotes POINT_A's real text -- correct words, wrong
    (unbound) unit."""
    _domain_dir, pack = _fixture_pack(tmp_path)
    proposal = {"citation_records": [
        {"atom": "unbound_home", "units": [P2],
         "verbatim": "goods supplied for consideration;"},
    ]}
    problems = pp.validate_proposal(pack, proposal)
    assert problems
    assert any("unbound_home" in p and "not containment-matchable" in p
               for p in problems), problems


def test_a_verbatim_check_is_skipped_when_the_only_bound_unit_id_is_already_unresolved(
        tmp_path):
    """No double-reporting: T3-class (unresolved unit id) is ONE defect, and
    a quote left with no real unit to check against must not add a second,
    misleading 'does not match' complaint on top of it."""
    _domain_dir, pack = _fixture_pack(tmp_path)
    proposal = {"citation_records": [
        {"atom": "only_bad_unit", "units": ["FIXTURE#no_such_unit"],
         "verbatim": "anything at all"},
    ]}
    problems = pp.validate_proposal(pack, proposal)
    assert not any("not containment-matchable" in p for p in problems), \
        problems
    assert any("resolves to no unit" in p for p in problems), problems


# ── the CLI: `--validate` ────────────────────────────────────────────────

def test_cli_validate_accepts_a_clean_proposal(tmp_path, capsys):
    import yaml as _yaml
    domain = _domain(tmp_path)
    proposal_path = os.path.join(str(tmp_path), "proposal.yaml")
    with open(proposal_path, "w", encoding="utf-8") as handle:
        _yaml.safe_dump({
            "citation_records": [
                {"atom": "art_2_point_a", "units": [POINT_A],
                 "verbatim": "goods supplied for consideration;"},
            ],
        }, handle)
    rc = pp.main(["--validate", domain, proposal_path])
    out = capsys.readouterr().out
    assert rc == 0
    assert "OK" in out
    assert "REJECTED" not in out


def test_cli_validate_rejects_and_prints_every_problem(tmp_path, capsys):
    import yaml as _yaml
    domain = _domain(tmp_path)
    proposal_path = os.path.join(str(tmp_path), "proposal.yaml")
    with open(proposal_path, "w", encoding="utf-8") as handle:
        _yaml.safe_dump({
            "citation_records": [
                {"atom": "bad1", "units": ["FIXTURE#nope"], "verbatim": "x"},
            ],
            "clauses": [
                {"predicate": "nope/9", "cites": ["art_1"]},
            ],
        }, handle)
    rc = pp.main(["--validate", domain, proposal_path])
    out = capsys.readouterr().out
    assert rc == 1
    assert out.count("REJECTED:") >= 2
    assert "nope" in out
    assert "nope/9" in out


def test_cli_validate_never_writes_to_the_domain(tmp_path):
    import yaml as _yaml
    domain = _domain(tmp_path)
    proposal_path = os.path.join(str(tmp_path), "proposal.yaml")
    with open(proposal_path, "w", encoding="utf-8") as handle:
        _yaml.safe_dump({"citation_records": [
            {"atom": "art_2_point_a", "units": [POINT_A],
             "verbatim": "goods supplied for consideration;"},
        ]}, handle)
    before = _tree(domain)
    pp.main(["--validate", domain, proposal_path])
    assert _tree(domain) == before


def test_cli_validate_on_a_malformed_proposal_file_reports_rather_than_raises(
        tmp_path, capsys):
    domain = _domain(tmp_path)
    proposal_path = os.path.join(str(tmp_path), "proposal.yaml")
    with open(proposal_path, "w", encoding="utf-8") as handle:
        handle.write("this: [is, not, closed\n")
    rc = pp.main(["--validate", domain, proposal_path])
    out = capsys.readouterr().out
    assert rc == 1
    assert "REJECTED:" in out


# ═════════════════════════════════════════════════════════════════════════
# Task 4 -- the ground-truth round trip: the acceptance test that matters.
# ═════════════════════════════════════════════════════════════════════════
#
# `eu/vat/pro_rata_deduction` is a hand-made correct answer: a person
# authored `citations.clausal` (5 citation records with `units` and
# `verbatim`), cited 4 operative clauses from it, and wrote 8 deferral
# entries into `manifest.yaml`. That is committed, real, and already scored
# by the gate -- see spec §13.15/§13.18.
#
# `_reconstruct_proposal_from_pack` builds a proposal by READING the pack
# (itself built by `ledger.build` from the committed files -- the citations
# registry, the clauses' own cites, the manifest's `deferred_set`), never by
# retyping a value into this file. That keeps the test honest: a hand-copied
# fixture would test this file's typing, not the validator, and the checks
# below are not vacuous because of it -- `pack["units"]` comes from an
# independent read of the pinned XML (`units.load_sources`) while
# `pack["citation_records"][*]["units"]` and `["verbatim"]` come from a
# separate read of `citations.clausal` (the registry), so cross-checking one
# against the other is exactly the resolution and containment work
# `validate_proposal` exists to do -- it is not checking data against
# itself.
#
# A validator that rejected this known-good, human-authored, gate-scored
# state would be worse than no validator: it would train a drafter toward
# whatever shape the validator prefers instead of what the corpus actually
# wants (see the plan's Task 4 and the module's own Task 2/3 commentary).

def _reconstruct_proposal_from_pack(pack):
    """The pilot's committed state, reconstructed as a PROPOSAL from what
    the pack already read off the real files -- see the section docstring
    above for why this is reading, not retyping."""
    citation_records = [
        {"atom": record["atom"], "units": list(record["units"]),
         "verbatim": record["verbatim"]}
        for record in pack["citation_records"]
    ]
    clauses = [
        {"predicate": pp._ledger.no_statute_key(clause["functor"],
                                                 clause["arity"]),
         "cites": list(clause["cites"])}
        for clause in pack["clauses"]
    ]
    deferrals = [
        {"what": deferral["what"], "units": list(deferral["units"])}
        for deferral in pack["deferrals"]
    ]
    return {"citation_records": citation_records, "clauses": clauses,
            "deferrals": deferrals}


def test_the_pilot_s_committed_state_round_trips_through_validate_whole():
    """THE ACCEPTANCE TEST THAT MATTERS. The pilot's real, hand-authored, 5
    citation record / 4 clause / 7 deferral registry, reconstructed as a
    proposal and validated whole -- `--validate` must ACCEPT it, with zero
    rejections."""
    pack = _pilot_pack()
    proposal = _reconstruct_proposal_from_pack(pack)
    assert len(proposal["citation_records"]) == 5
    assert len(proposal["clauses"]) == 4
    assert len(proposal["deferrals"]) == 7
    problems = pp.validate_proposal(pack, proposal)
    assert problems == [], problems


def test_the_pilot_s_reconstructed_clauses_carry_the_domain_s_real_cites():
    """Not a vacuous reconstruction: each clause's `cites` is the domain's
    own existing citation list (`computation.clausal`, `threshold.clausal`),
    carried through unchanged rather than invented here."""
    pack = _pilot_pack()
    proposal = _reconstruct_proposal_from_pack(pack)
    cites_by_predicate = {c["predicate"]: set(c["cites"])
                          for c in proposal["clauses"]}
    assert cites_by_predicate["deductible_proportion_percent/3"] == {
        "eu_vat_art_174_1", "eu_vat_art_174_1_a", "eu_vat_art_174_1_b"}
    assert cites_by_predicate["deductible_vat/4"] == {"eu_vat_art_173_1"}


# ── mutate the known-good proposal one field at a time ──────────────────
#
# Each test starts from a fresh, independent reconstruction (never a shared
# mutable proposal two tests could accidentally leak state through), breaks
# exactly ONE field, and asserts `--validate` rejects it with a message that
# names the offending field/value -- never merely "rejected".

def test_mutation_a_broken_unit_id_is_rejected_naming_the_unit(tmp_path):
    pack = _pilot_pack()
    proposal = _reconstruct_proposal_from_pack(pack)
    proposal["citation_records"][0]["units"] = ["02006L0112-20250101#no_such_unit"]
    problems = pp.validate_proposal(pack, proposal)
    assert problems
    assert any("no_such_unit" in p and "resolves to no unit" in p
               for p in problems), problems


def test_mutation_a_broken_predicate_ref_is_rejected_naming_the_predicate(
        tmp_path):
    pack = _pilot_pack()
    proposal = _reconstruct_proposal_from_pack(pack)
    proposal["clauses"][0]["predicate"] = "no_such_predicate/9"
    problems = pp.validate_proposal(pack, proposal)
    assert problems
    assert any("no_such_predicate/9" in p and "names no operative clause" in p
               for p in problems), problems


def test_mutation_a_changed_verbatim_word_is_rejected_naming_the_atom(
        tmp_path):
    pack = _pilot_pack()
    proposal = _reconstruct_proposal_from_pack(pack)
    record = proposal["citation_records"][0]
    assert record["atom"] == "eu_vat_art_173_1"
    assert "attributable" in record["verbatim"]
    record["verbatim"] = record["verbatim"].replace(
        "attributable", "attributed", 1)
    problems = pp.validate_proposal(pack, proposal)
    assert problems
    assert any("eu_vat_art_173_1" in p and "not containment-matchable" in p
               for p in problems), problems


def test_mutation_a_duplicate_atom_is_rejected_naming_the_atom(tmp_path):
    pack = _pilot_pack()
    proposal = _reconstruct_proposal_from_pack(pack)
    duplicate = dict(proposal["citation_records"][0])
    proposal["citation_records"].append(duplicate)
    problems = pp.validate_proposal(pack, proposal)
    assert problems
    assert any(duplicate["atom"] in p and "duplicate" in p for p in problems), \
        problems


def test_mutation_a_deferral_bound_to_a_nonexistent_unit_is_rejected_naming_it(
        tmp_path):
    pack = _pilot_pack()
    proposal = _reconstruct_proposal_from_pack(pack)
    deferral = proposal["deferrals"][0]
    deferral["units"] = ["02006L0112-20250101#no_such_unit"]
    problems = pp.validate_proposal(pack, proposal)
    assert problems
    assert any(deferral["what"] in p and "no_such_unit" in p
               and "resolves to no unit" in p for p in problems), problems


def test_a_prolog_registry_is_protected_like_a_seam_one():
    """`citations.pl` / `parameters.pl` are the Prolog spelling of the enforced registries:
    a stray --pack must not overwrite them either."""
    from _tools.propose_provisions import _refused_out_path
    for name in ("citations.pl", "parameters.pl", "dom/citations.pl"):
        assert _refused_out_path(name), name
    assert _refused_out_path("dom/pack.pl") is None
