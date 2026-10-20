"""
_tools/test_check_interface_conformance.py — unit + integration tests for
check_interface_conformance.py (conformance audit vs the DRAFT v0.2 standard,
docs/interfaces/2026-07-06-interface-conformance-standard.md @ bd2a1eb).

Run (from the repository root):  python3 -m pytest _tools/test_check_interface_conformance.py -q
"""
import sys
from pathlib import Path

import pytest
import yaml

sys.path.insert(0, str(Path(__file__).resolve().parent))

CATALOG_DIR = Path(__file__).resolve().parent.parent / "_index" / "interface-catalog"


def imp():
    import check_interface_conformance as m
    return m


# --- fixture builders (mirror the per-domain catalog schema) ---------------------

def P(name, arity, args, doc=None):
    d = {"name": name, "arity": arity, "args": list(args)}
    if doc:
        d["doc"] = doc
    return d


def C(name, arity, args=None):
    return {"name": name, "arity": arity, "args": list(args or [])}


def A(name, kind="enum"):
    return {"name": name, "kind": kind, "arity": 0}


def RB(module="test_mod", preds=(), ctors=(), atoms=(), fl_imports=("profile_get", "profile_has", "attribute"),
       other_imports=(), date_rep=("unknown",), kit=("formalize_lib",), profile_keys=("k1",),
       warnings=None, file="test_mod.seam"):
    rb = {
        "file": file,
        "module": module,
        "exports": {"predicates": list(preds), "constructors": list(ctors), "atoms": list(atoms)},
        "imports": ([{"kind": "import_from", "module": "formalize_lib", "names": list(fl_imports)}]
                    if fl_imports is not None else []) + [dict(i) for i in other_imports],
        "observations": {"date_rep": list(date_rep), "uses_kit_modules": sorted(kit)},
        "profile": ({"keys": {k: {"required": True} for k in profile_keys}}
                    if profile_keys is not None else None),
    }
    if warnings is not None:
        rb["warnings"] = list(warnings)
    return rb


def DOM(family="eligibility", domain="xx/test", drift=False, rulebases=None, **rb_kwargs):
    return {
        "domain": domain,
        "generated_by": "_tools/gen_interface_catalog.py",
        "manifest": {"drift": drift, "in_code_not_manifest": [], "in_manifest_not_code": [],
                     "shape_family": family},
        "rulebases": list(rulebases) if rulebases is not None else [RB(**rb_kwargs)],
        "schema_version": 0,
    }


def GOOD_ELIG(**over):
    """A fully L1-conformant eligibility domain (gber-shaped)."""
    kw = dict(
        family="eligibility", domain="xx/good-elig",
        preds=[
            P("assess_good", 3, ["SUBJECT", "PROFILE", "RESULT"], doc="PUBLIC: entry"),
            P("good_decision", 2, ["PROFILE", "DECISION"], doc="PUBLIC: headline"),
            P("requirement", 4, ["ID", "PROFILE", "STATUS", "CIT"], doc="PUBLIC: per-item"),
            P("good_checklist", 2, ["PROFILE", "CHECKLIST"], doc="checklist"),
            P("good_requirement_ids", 1, ["IDS"], doc="ids"),
            P("good_assess", 2, ["SUBJECT", "RESULT"], doc="wrapper"),
            P("good_subject", 1, ["S"], doc="fixture"),
            P("good_profile_for", 2, ["S", "P"], doc="fixture"),
        ],
        ctors=[C("cite", 1, ["P"]), C("item", 3, ["ID", "ST", "C"]), C("assessment", 3, ["S", "D", "C"])],
        atoms=[A("eligible"), A("ineligible"), A("indeterminate"),
               A("req_one"), A("k1", "profile_key"), A("cit_a", "citation")],
    )
    kw.update(over)
    return DOM(**kw)


def results_for(raw):
    m = imp()
    return m.check_domain(m.build_view(raw))


def status(raw, rule):
    return results_for(raw)[rule]["status"]


# =============================================================================
# IC-01 / IC-02 — L0
# =============================================================================

class TestIC01:
    def test_pass(self):
        assert status(GOOD_ELIG(), "IC-01") == "pass"

    def test_no_module_fails(self):
        raw = DOM(rulebases=[{"file": "x.seam", "module": None,
                              "warnings": ["No -module directive found"]}])
        assert status(raw, "IC-01") == "fail"

    def test_warning_fails(self):
        raw = GOOD_ELIG()
        raw["rulebases"][0]["warnings"] = ["something"]
        assert status(raw, "IC-01") == "fail"


class TestIC02:
    def test_pass(self):
        assert status(GOOD_ELIG(), "IC-02") == "pass"

    def test_bad_family_fails(self):
        assert status(GOOD_ELIG(family="fiscal"), "IC-02") == "fail"

    def test_null_family_fails(self):
        assert status(GOOD_ELIG(family=None), "IC-02") == "fail"


# =============================================================================
# IC-03 — family entry point
# =============================================================================

class TestIC03:
    def test_eligibility_assess3_passes(self):
        assert status(GOOD_ELIG(), "IC-03") == "pass"

    def test_eligibility_wrong_entry_fails(self):
        raw = GOOD_ELIG(preds=[P("visa_eligibility", 3, ["VISA_TYPE", "PROFILE", "RESULT"])])
        assert status(raw, "IC-03") == "fail"

    def test_deontic_decide2_passes(self):
        raw = DOM(family="deontic", preds=[P("decide_thing", 2, ["PROFILE", "VERDICT"])])
        assert status(raw, "IC-03") == "pass"

    def test_deontic_determine_fails(self):
        raw = DOM(family="deontic", preds=[P("determine_thing", 2, ["PROFILE", "VERDICT"])])
        assert status(raw, "IC-03") == "fail"

    def test_classification_classify3_passes(self):
        raw = DOM(family="classification", preds=[P("classify_thing", 3, ["PROFILE", "CATEGORY", "CIT"])])
        assert status(raw, "IC-03") == "pass"

    def test_classification_binary_assess_is_manual(self):
        raw = DOM(family="classification",
                  preds=[P("assess_thing", 3, ["SUBJECT", "PROFILE", "RESULT"])])
        assert status(raw, "IC-03") == "manual_pending"

    def test_classification_no_entry_fails(self):
        raw = DOM(family="classification", preds=[P("thing_of", 2, ["PROFILE", "X"])])
        assert status(raw, "IC-03") == "fail"

    def test_numeric_pure_quantity_na(self):
        raw = DOM(family="numeric", preds=[P("ratio_bps", 2, ["PROFILE", "RATIO_BPS"])], atoms=[])
        assert status(raw, "IC-03") == "n_a"

    def test_numeric_flavored_without_entry_fails(self):
        raw = DOM(family="numeric",
                  preds=[P("thing_status", 2, ["PROFILE", "STATUS"])],
                  atoms=[A("compliant"), A("non_compliant")])
        assert status(raw, "IC-03") == "fail"

    def test_temporal_decide2_passes(self):
        raw = DOM(family="temporal", preds=[P("decide_win", 2, ["SCENARIO", "RESULT"])])
        assert status(raw, "IC-03") == "pass"


# =============================================================================
# IC-04 — argument-position convention
# =============================================================================

class TestIC04:
    def test_pass(self):
        assert status(GOOD_ELIG(), "IC-04") == "pass"

    def test_result_not_last_fails(self):
        raw = DOM(preds=[P("assess_x", 3, ["SUBJECT", "RESULT", "PROFILE"])])
        assert status(raw, "IC-04") == "fail"

    def test_profile_last_fails(self):
        raw = DOM(preds=[P("finding", 2, ["SUBSTANCE", "PROFILE"])])
        assert status(raw, "IC-04") == "fail"

    def test_profile_for_fixture_exempt(self):
        raw = DOM(preds=[P("x_profile_for", 2, ["SUBJECT", "PROFILE"]),
                         P("assess_x", 3, ["SUBJECT", "PROFILE", "RESULT"])])
        assert status(raw, "IC-04") == "pass"

    def test_verdict_followed_by_citation_ok(self):
        raw = DOM(preds=[P("x_verdict", 4, ["RISK", "HOURS", "VERDICT", "CITATION"])])
        assert status(raw, "IC-04") == "pass"

    def test_no_conventional_args_is_manual(self):
        raw = DOM(preds=[P("asset_classification", 3, ["EXCLUDED", "REFERENCE", "TYPE"])])
        assert status(raw, "IC-04") == "manual_pending"

    def test_arity1_profile_guard_is_input(self):
        # consent_is_valid/1(PROFILE) — sole arg is an input, not an output slot
        raw = DOM(preds=[P("consent_is_valid", 1, ["PROFILE"]),
                         P("decide_x", 2, ["PROFILE", "VERDICT"])])
        assert status(raw, "IC-04") == "pass"

    def test_status_first_position_is_input_homonym(self):
        # irc-s1 total_tax/3(STATUS, INCOME, TAX): filing STATUS is an input
        raw = DOM(preds=[P("total_tax", 3, ["STATUS", "INCOME", "TAX"]),
                         P("income_tax", 2, ["PROFILE", "RESULT"])])
        assert status(raw, "IC-04") == "pass"


# =============================================================================
# IC-05 / IC-06 / IC-07 — per-item predicate, checklist, enumerator
# =============================================================================

class TestIC05:
    def test_requirement4_passes(self):
        assert status(GOOD_ELIG(), "IC-05") == "pass"

    def test_variant_name_passes(self):
        raw = DOM(family="classification",
                  preds=[P("classify_x", 3, ["PROFILE", "CATEGORY", "CIT"]),
                         P("art2_condition", 4, ["ID", "PROFILE", "STATUS", "CIT"])])
        assert status(raw, "IC-05") == "pass"

    def test_missing_fails(self):
        raw = DOM(preds=[P("assess_x", 3, ["SUBJECT", "PROFILE", "RESULT"])])
        assert status(raw, "IC-05") == "fail"

    def test_no_cit_arg_fails(self):
        # peppol's rule_satisfied/3 shape: no CIT arg → not a conformant per-item /4
        raw = DOM(family="constraint-satisfaction",
                  preds=[P("rule_satisfied", 3, ["RULE_ID", "INVOICE", "STATUS"])])
        assert status(raw, "IC-05") == "fail"

    def test_pure_numeric_na(self):
        raw = DOM(family="numeric", preds=[P("x_bps", 2, ["PROFILE", "BPS"])], atoms=[])
        assert status(raw, "IC-05") == "n_a"

    def test_pure_computation_numeric_na(self):
        # gb-income-tax/irc-s1: decision-flavored numeric but a scalar-quantity
        # result, no per-item checklist axis → n_a (v0.4, same basis as IC-11).
        raw = DOM(family="numeric",
                  preds=[P("assess_income_tax", 3, ["SUBJECT", "PROFILE", "RESULT"]),
                         P("income_tax_due", 2, ["PROFILE", "TAX_DUE_PENCE"])],
                  ctors=[C("tax_due", 1, ["P"]), C("assessment", 3, ["S", "D", "C"])],
                  atoms=[A("basic_rate"), A("higher_rate"), A("indeterminate")])
        assert status(raw, "IC-05") == "n_a"

    def test_deontic_obligation_catalog_is_manual(self):
        # v0.2 §2.3: cdd/gpsr shape — *_obligation/3 without a /4 limb surface
        # → n/a iff obligation-flavored; flavor stays manual (IC-28's source)
        raw = DOM(family="deontic",
                  preds=[P("determine_cdd", 2, ["PROFILE", "VERDICT"]),
                         P("cdd_obligation", 3, ["PROFILE", "OBLIGATION", "CITATION"])])
        assert status(raw, "IC-05") == "manual_pending"

    def test_deontic_without_obligation_still_fails(self):
        raw = DOM(family="deontic", preds=[P("decide_x", 2, ["PROFILE", "VERDICT"])])
        assert status(raw, "IC-05") == "fail"

    def test_deontic_with_limb4_passes_regardless(self):
        raw = DOM(family="deontic",
                  preds=[P("limb_status", 4, ["LIMB", "PROFILE", "STATUS", "CITE"]),
                         P("x_obligation", 3, ["PROFILE", "OBLIGATION", "CITATION"])])
        assert status(raw, "IC-05") == "pass"


class TestIC06:
    def test_checklist2_passes(self):
        assert status(GOOD_ELIG(), "IC-06") == "pass"

    def test_checklist_arity3_fails(self):
        raw = DOM(family="classification",
                  preds=[P("classification_checklist", 3, ["A", "B", "CHECKLIST"])])
        assert status(raw, "IC-06") == "fail"

    def test_deontic_limb_surface_passes(self):
        raw = DOM(family="deontic",
                  preds=[P("decide_x", 2, ["PROFILE", "VERDICT"]),
                         P("limb_status", 4, ["LIMB", "PROFILE", "STATUS", "CITE"])])
        assert status(raw, "IC-06") == "pass"

    def test_deontic_conditions_surface_passes(self):
        raw = DOM(family="deontic",
                  preds=[P("decide_x", 2, ["PROFILE", "VERDICT"]),
                         P("basis_conditions", 2, ["BASIS", "CONDITIONS"])])
        assert status(raw, "IC-06") == "pass"

    def test_missing_fails(self):
        raw = DOM(preds=[P("assess_x", 3, ["SUBJECT", "PROFILE", "RESULT"])])
        assert status(raw, "IC-06") == "fail"

    def test_pure_computation_numeric_na(self):
        raw = DOM(family="numeric",
                  preds=[P("assess_income_tax", 3, ["SUBJECT", "PROFILE", "RESULT"]),
                         P("income_tax_due", 2, ["PROFILE", "TAX_DUE_PENCE"])],
                  ctors=[C("tax_due", 1, ["P"]), C("assessment", 3, ["S", "D", "C"])],
                  atoms=[A("basic_rate"), A("higher_rate"), A("indeterminate")])
        assert status(raw, "IC-06") == "n_a"

    def test_obligation_flavored_deontic_na(self):
        # amlr-cdd/gpsr: the obligation set is the checklist-equivalent (same
        # discriminator + basis as IC-11's obligation-flavored n_a).
        raw = DOM(family="deontic",
                  preds=[P("decide_x", 2, ["PROFILE", "VERDICT"]),
                         P("x_obligation", 3, ["PROFILE", "OBLIGATION", "CITATION"])],
                  ctors=[C("x_verdict", 4), C("obligation", 2), C("cite", 1, ["P"])],
                  atoms=[A("required"), A("indeterminate")])
        assert status(raw, "IC-06") == "n_a"


class TestIC07:
    def test_ids1_passes(self):
        assert status(GOOD_ELIG(), "IC-07") == "pass"

    def test_ids2_fails(self):
        raw = GOOD_ELIG()
        rb = raw["rulebases"][0]["exports"]["predicates"]
        rb[:] = [p for p in rb if p["name"] != "good_requirement_ids"] + \
                [P("good_requirement_ids", 2, ["VISA_TYPE", "IDS"])]
        assert status(raw, "IC-07") == "fail"

    def test_rules1_accepted(self):
        raw = DOM(family="constraint-satisfaction",
                  preds=[P("rule_ok", 4, ["ID", "PROFILE", "STATUS", "CIT"]),
                         P("in_scope_rules", 1, ["LIST"])])
        assert status(raw, "IC-07") == "pass"

    def test_no_per_item_na(self):
        raw = DOM(preds=[P("assess_x", 3, ["SUBJECT", "PROFILE", "RESULT"])])
        assert status(raw, "IC-07") == "n_a"


# =============================================================================
# IC-08 — wrapper + fixtures (SHOULD)
# =============================================================================

class TestIC08:
    def test_all_three_pass(self):
        assert status(GOOD_ELIG(), "IC-08") == "pass"

    def test_missing_subject_fails(self):
        raw = GOOD_ELIG()
        preds = raw["rulebases"][0]["exports"]["predicates"]
        preds[:] = [p for p in preds if p["name"] != "good_subject"]
        assert status(raw, "IC-08") == "fail"

    def test_classification_classify2_variant_accepted(self):
        raw = DOM(family="classification",
                  preds=[P("classify_x", 3, ["PROFILE", "CATEGORY", "CIT"]),
                         P("x_classify", 2, ["SUBJECT", "RESULT"]),
                         P("x_subject", 1, ["S"]),
                         P("x_profile_for", 2, ["S", "P"])])
        assert status(raw, "IC-08") == "pass"


# =============================================================================
# IC-09 / IC-10 — citations
# =============================================================================

class TestIC09:
    def test_pass(self):
        assert status(GOOD_ELIG(), "IC-09") == "pass"

    def test_cite_as_predicate_fails(self):
        raw = DOM(preds=[P("cite", 1, ["CITATION_KEY"])], ctors=[])
        assert status(raw, "IC-09") == "fail"

    def test_absent_fails(self):
        raw = DOM(preds=[P("assess_x", 3, ["SUBJECT", "PROFILE", "RESULT"])], ctors=[])
        assert status(raw, "IC-09") == "fail"


class TestIC10:
    def test_citation_atoms_manual(self):
        # lexicon cross-check is cross-repo → manual per the standard
        assert status(GOOD_ELIG(), "IC-10") == "manual_pending"

    def test_no_citation_atoms_fails(self):
        raw = GOOD_ELIG(atoms=[A("eligible"), A("ineligible"), A("indeterminate")])
        assert status(raw, "IC-10") == "fail"


# =============================================================================
# IC-11 / IC-12 — decision enums
# =============================================================================

class TestIC11:
    def test_pass(self):
        assert status(GOOD_ELIG(), "IC-11") == "pass"

    def test_missing_indeterminate_fails(self):
        raw = GOOD_ELIG(atoms=[A("eligible"), A("ineligible")])
        assert status(raw, "IC-11") == "fail"

    def test_generic_not_pair_passes(self):
        raw = DOM(atoms=[A("block_exempt"), A("not_block_exempt"), A("indeterminate")])
        assert status(raw, "IC-11") == "pass"

    def test_suffix_antonym_pair_passes(self):
        # emir: clearing_required / not_required
        raw = DOM(family="deontic",
                  preds=[P("decide_x", 2, ["PROFILE", "VERDICT"])],
                  atoms=[A("clearing_required"), A("not_required"), A("indeterminate")])
        assert status(raw, "IC-11") == "pass"

    def test_no_neg_fails(self):
        raw = DOM(atoms=[A("required"), A("indeterminate")])
        assert status(raw, "IC-11") == "fail"

    def test_classification_categories_plus_indeterminate_pass(self):
        raw = DOM(family="classification",
                  atoms=[A("cat_a"), A("cat_b"), A("indeterminate")])
        assert status(raw, "IC-11") == "pass"

    def test_pure_numeric_na(self):
        raw = DOM(family="numeric", preds=[P("x_bps", 2, ["PROFILE", "BPS"])], atoms=[])
        assert status(raw, "IC-11") == "n_a"

    # --- v0.4 morphology generalization (Part A) -----------------------------

    def test_is_un_pair_passes(self):
        # eu/gdpr: is_lawful / is_unlawful (no dead not_lawful needed)
        raw = DOM(family="deontic", preds=[P("decide_x", 2, ["PROFILE", "VERDICT"])],
                  ctors=[C("gdpr_verdict", 4), C("cite", 1, ["P"])],
                  atoms=[A("is_lawful"), A("is_unlawful"), A("indeterminate")])
        assert status(raw, "IC-11") == "pass"

    def test_is_prefixed_antonym_pair_passes(self):
        # gdpr-chapter-v: is_permitted / is_prohibited (domain-natural antonym)
        raw = DOM(family="deontic", preds=[P("decide_x", 2, ["PROFILE", "VERDICT"])],
                  ctors=[C("transfer_verdict", 3), C("cite", 1, ["P"])],
                  atoms=[A("is_permitted"), A("is_prohibited"), A("indeterminate")])
        assert status(raw, "IC-11") == "pass"

    def test_infix_not_pair_passes(self):
        # reach: registration_required / registration_not_required (mid-word not_)
        raw = DOM(family="numeric", preds=[P("assess_x", 3, ["S", "PROFILE", "RESULT"])],
                  atoms=[A("registration_required"), A("registration_not_required"),
                         A("csr_required"), A("csr_not_required"), A("indeterminate")])
        assert status(raw, "IC-11") == "pass"

    # --- v0.4: obligation-flavored deontic is n_a (verdict is an obligation SET)

    def test_obligation_flavored_deontic_na(self):
        # gpsr / amlr-cdd: obligation/2 ctor + *_obligation/3 surface, coarse
        # required|indeterminate modality — NOT a binary POS/NEG axis.
        raw = DOM(family="deontic",
                  preds=[P("decide_x", 2, ["PROFILE", "VERDICT"]),
                         P("x_obligation", 3, ["PROFILE", "OBLIGATION", "CITATION"])],
                  ctors=[C("x_verdict", 4), C("obligation", 2), C("cite", 1, ["P"])],
                  atoms=[A("required"), A("indeterminate")])
        assert status(raw, "IC-11") == "n_a"

    def test_binary_deontic_without_obligation_surface_uses_pair(self):
        # a verdict-only deontic (no obligation/2 ctor) is still pair-checked, not n_a
        raw = DOM(family="deontic", preds=[P("decide_x", 2, ["PROFILE", "VERDICT"])],
                  ctors=[C("x_verdict", 4), C("cite", 1, ["P"])],
                  atoms=[A("required"), A("indeterminate")])
        assert status(raw, "IC-11") == "fail"

    # --- v0.4: pure-computation numeric is n_a (scalar quantity, no verdict axis)

    def test_pure_computation_numeric_with_rate_atoms_na(self):
        # gb-income-tax: rate atoms + indeterminate, tax_due quantity, no verdict
        raw = DOM(family="numeric",
                  preds=[P("assess_income_tax", 3, ["SUBJECT", "PROFILE", "RESULT"]),
                         P("income_tax_due", 2, ["PROFILE", "TAX_DUE_PENCE"])],
                  ctors=[C("tax_due", 1, ["P"]), C("assessment", 3, ["S", "D", "C"])],
                  atoms=[A("basic_rate"), A("higher_rate"), A("indeterminate")])
        assert status(raw, "IC-11") == "n_a"

    def test_pure_computation_numeric_no_enums_na(self):
        # irc-s1: no enums at all, only computes amounts (must precede the
        # `indeterminate`-required check)
        raw = DOM(family="numeric",
                  preds=[P("income_tax", 2, ["PROFILE", "RESULT"]),
                         P("marginal_rate_bps", 3, ["PROFILE", "RATE_BPS", "CITES"])],
                  ctors=[C("s1_tax", 5), C("cite", 1, ["P"])],
                  atoms=[])
        assert status(raw, "IC-11") == "n_a"

    def test_compliance_numeric_with_status_pred_still_fails(self):
        # emir-nfc / working-time: *_status|*_compliance verdict axis but no enums
        # exported yet — a genuine defect, NOT excused as pure computation.
        raw = DOM(family="numeric",
                  preds=[P("nfc_clearing_status", 3, ["POSITIONS", "ASSET_CLASS", "STATUS"])],
                  atoms=[])
        assert status(raw, "IC-11") == "fail"


class TestIC12:
    def test_numeric_compliant_pair_passes(self):
        raw = DOM(family="numeric",
                  preds=[P("assess_x", 3, ["SUBJECT", "PROFILE", "RESULT"])],
                  atoms=[A("compliant"), A("non_compliant"), A("indeterminate")])
        assert status(raw, "IC-12") == "pass"

    def test_pure_computation_numeric_na(self):
        raw = DOM(family="numeric",
                  preds=[P("assess_income_tax", 3, ["SUBJECT", "PROFILE", "RESULT"]),
                         P("income_tax_due", 2, ["PROFILE", "TAX_DUE_PENCE"])],
                  ctors=[C("tax_due", 1, ["P"]), C("assessment", 3, ["S", "D", "C"])],
                  atoms=[A("basic_rate"), A("higher_rate"), A("indeterminate")])
        assert status(raw, "IC-12") == "n_a"

    def test_numeric_domain_precise_pair_passes(self):
        # v0.4: numeric IC-12 accepts a domain-precise POS/NEG pair (as IC-11
        # does), not only compliant/non_compliant (crr-large-exposures, de-minimis).
        raw = DOM(family="numeric",
                  preds=[P("assess_x", 3, ["SUBJECT", "PROFILE", "RESULT"])],
                  atoms=[A("within_limit"), A("breach"), A("indeterminate")])
        assert status(raw, "IC-12") == "pass"

    def test_eligibility_not_eligible_fails(self):
        # §2.1 adjudication: `ineligible` beats `not_eligible`
        raw = GOOD_ELIG(atoms=[A("eligible"), A("not_eligible"), A("indeterminate")])
        assert status(raw, "IC-12") == "fail"

    def test_eligibility_domain_precise_pair_passes(self):
        raw = GOOD_ELIG(atoms=[A("block_exempt"), A("not_block_exempt"), A("indeterminate")])
        assert status(raw, "IC-12") == "pass"

    def test_deontic_is_pair_passes(self):
        raw = DOM(family="deontic", preds=[P("decide_x", 2, ["PROFILE", "VERDICT"])],
                  atoms=[A("is_permitted"), A("is_prohibited"), A("indeterminate")])
        assert status(raw, "IC-12") == "pass"

    def test_classification_na(self):
        raw = DOM(family="classification", atoms=[A("cat_a"), A("indeterminate")])
        assert status(raw, "IC-12") == "n_a"


# =============================================================================
# IC-13 / IC-14 / IC-15 — profile machinery
# =============================================================================

class TestIC13:
    def test_pass(self):
        assert status(GOOD_ELIG(), "IC-13") == "pass"

    def test_null_profile_fails(self):
        assert status(GOOD_ELIG(profile_keys=None), "IC-13") == "fail"


class TestIC14:
    def test_profile_get_passes(self):
        assert status(GOOD_ELIG(), "IC-14") == "pass"

    def test_legacy_prof_get_passes(self):
        assert status(GOOD_ELIG(fl_imports=("profile_get", "profile_has", "attribute")), "IC-14") == "pass"

    def test_hand_rolled_accessor_export_fails(self):
        raw = DOM(preds=[P("profile_get", 3, ["PROFILE", "KEY", "VALUE"])], fl_imports=("attribute",))
        assert status(raw, "IC-14") == "fail"

    def test_no_profile_args_na(self):
        raw = DOM(preds=[P("x_of", 2, ["A", "B"])], fl_imports=("attribute",), profile_keys=None)
        assert status(raw, "IC-14") == "n_a"


class TestIC15:
    def test_spelled_out_passes(self):
        assert status(GOOD_ELIG(), "IC-15") == "pass"

    def test_prof_get_fails(self):
        assert status(GOOD_ELIG(fl_imports=("profile_get", "profile_has", "attribute")), "IC-15") == "fail"

    def test_no_accessors_na(self):
        raw = DOM(preds=[P("x_of", 2, ["A", "B"])], fl_imports=("attribute",))
        assert status(raw, "IC-15") == "n_a"


# =============================================================================
# IC-16 / IC-17 — shared functor identity, payload statuses
# =============================================================================

class TestIC16:
    def test_local_item_assessment_fail(self):
        # the crr cohort shape: item/3+assessment/3 in constructors, not imported
        assert status(GOOD_ELIG(), "IC-16") == "fail"

    def test_imported_functors_pass(self):
        raw = GOOD_ELIG(ctors=[C("cite", 1)],
                        fl_imports=("profile_get", "profile_has", "attribute", "item",
                                    "unmet", "unknown", "assessment"))
        assert status(raw, "IC-16") == "pass"

    def test_exported_but_also_imported_passes(self):
        raw = GOOD_ELIG(fl_imports=("profile_get", "profile_has", "attribute", "item", "assessment"))
        assert status(raw, "IC-16") == "pass"


class TestIC17:
    def test_arity0_status_atoms_manual(self):
        raw = GOOD_ELIG(atoms=[A("eligible"), A("ineligible"), A("indeterminate"),
                               A("met"), A("unmet"), A("unknown"), A("cit_a", "citation")])
        assert status(raw, "IC-17") == "manual_pending"

    def test_no_status_atoms_pass(self):
        assert status(GOOD_ELIG(), "IC-17") == "pass"


# =============================================================================
# IC-18 — canonical dates
# =============================================================================

class TestIC18:
    def test_pass(self):
        assert status(GOOD_ELIG(), "IC-18") == "pass"

    def test_iso_string_fails(self):
        assert status(GOOD_ELIG(date_rep=("date4_native", "iso_string")), "IC-18") == "fail"


# =============================================================================
# IC-19 / IC-29 — numeric quantities
# =============================================================================

class TestIC19:
    def test_unit_named_quantities_pass(self):
        raw = DOM(family="numeric",
                  preds=[P("capital_ratio_bps", 3, ["ID", "PROFILE", "RATIO_BPS"]),
                         P("minimum_ratio_bps", 2, ["ID", "MINIMUM_BPS"])])
        assert status(raw, "IC-19") == "pass"

    def test_unit_in_arg_only_manual(self):
        # §2.4's own examples (income_tax_due/2, basic_rate_limit/1) carry no
        # unit suffix → rule ambiguous → manual
        raw = DOM(family="numeric",
                  preds=[P("income_tax_due", 2, ["PROFILE", "TAX_DUE_PENCE"])])
        assert status(raw, "IC-19") == "manual_pending"

    def test_major_unit_fails(self):
        raw = DOM(family="numeric", preds=[P("income_tax", 3, ["CASE", "DOLLARS", "CITE"])])
        assert status(raw, "IC-19") == "fail"

    def test_no_quantities_na(self):
        assert status(GOOD_ELIG(), "IC-19") == "n_a"

    def test_eur_usd_are_not_unit_evidence(self):
        # major currency tokens were dropped from UNIT_TOKENS (v0.2 sync):
        # a bare *_eur surface is not minor-unit evidence
        raw = DOM(family="numeric", preds=[P("budget_eur", 2, ["PROFILE", "EUR"])], atoms=[])
        assert status(raw, "IC-19") == "n_a"


class TestIC29:
    def test_quantity_and_parameter_pass(self):
        raw = DOM(family="numeric",
                  preds=[P("leverage_ratio_bps", 2, ["PROFILE", "RATIO_BPS"]),
                         P("minimum_leverage_bps", 1, ["MINIMUM_BPS"])])
        assert status(raw, "IC-29") == "pass"

    def test_single_pred_cannot_double_count(self):
        raw = DOM(family="numeric",
                  preds=[P("rate_percent", 2, ["BAND_ID", "RATE"])])
        assert status(raw, "IC-29") in ("fail", "manual_pending")

    def test_unit_in_args_only_manual(self):
        raw = DOM(family="numeric",
                  preds=[P("nfc_clearing_threshold", 2, ["ASSET_CLASS", "THRESHOLD_CENTS"]),
                         P("nfc_aggregate_notional", 3, ["G_CENTS", "H_CENTS", "AGG_CENTS"])])
        assert status(raw, "IC-29") == "manual_pending"

    def test_nothing_unitlike_fails(self):
        raw = DOM(family="numeric", preds=[P("eu_dimension", 2, ["PARTIES", "VERDICT"])])
        assert status(raw, "IC-29") == "fail"

    def test_non_numeric_na(self):
        assert status(GOOD_ELIG(), "IC-29") == "n_a"


# =============================================================================
# IC-20 / IC-21 / IC-22 — kit deps, naming mechanics, prefix discipline
# =============================================================================

class TestIC20:
    def test_known_kit_modules_pass(self):
        assert status(GOOD_ELIG(), "IC-20") == "pass"

    def test_own_module_dependency_passes(self):
        raw = DOM(rulebases=[
            RB(module="main_mod", preds=[P("assess_x", 3, ["SUBJECT", "PROFILE", "RESULT"])],
               kit=("formalize_lib", "helper_mod")),
            RB(module="helper_mod", file="helper.seam"),
        ])
        assert status(raw, "IC-20") == "pass"

    def test_unknown_module_fails(self):
        assert status(GOOD_ELIG(kit=("formalize_lib", "mystery_lib")), "IC-20") == "fail"


class TestIC21:
    def test_pass(self):
        assert status(GOOD_ELIG(), "IC-21") == "pass"

    def test_reserved_redefinition_fails(self):
        raw = DOM(preds=[P("profile_get", 3, ["PROFILE", "KEY", "VALUE"])])
        assert status(raw, "IC-21") == "fail"

    def test_h_prefix_fails(self):
        raw = DOM(preds=[P("h_helper", 2, ["A", "B"])])
        assert status(raw, "IC-21") == "fail"

    def test_check_prefix_fails(self):
        raw = DOM(preds=[P("check_gte", 5, ["A", "B", "C", "D", "E"])])
        assert status(raw, "IC-21") == "fail"


class TestIC22:
    def test_prefixed_and_verbed_pass(self):
        assert status(GOOD_ELIG(), "IC-22") == "pass"

    def test_generic_unprefixed_fails(self):
        raw = GOOD_ELIG(preds=[P("assess_good", 3, ["SUBJECT", "PROFILE", "RESULT"]),
                               P("sequential_evaluation", 2, ["PROFILE", "STEPS"])])
        assert status(raw, "IC-22") == "fail"

    def test_unit_suffixed_quantity_allowed(self):
        raw = DOM(family="numeric", domain="eu/banking/crr-own-funds-min-ratios",
                  module="crr_own_funds_min_ratios",
                  preds=[P("assess_crr_own_funds", 3, ["SUBJECT", "PROFILE", "RESULT"]),
                         P("capital_ratio_bps", 3, ["ID", "PROFILE", "RATIO_BPS"])])
        assert status(raw, "IC-22") == "pass"

    def test_deontic_limb_surface_allowed(self):
        # v0.4: the §2.3 deontic per-item/limb surface is the family-shape
        # analogue of requirement/4 — exempt from prefix discipline (the deontic
        # exemplar itself exports these unprefixed).
        raw = DOM(family="deontic", domain="eu/x/y", module="x_y",
                  preds=[P("decide_x", 2, ["PROFILE", "VERDICT"]),
                         P("limb_status", 4, ["LIMB", "PROFILE", "STATUS", "CITE"]),
                         P("limb_ids", 1, ["IDS"]),
                         P("limb_citations", 2, ["LIMB", "CITES"])])
        assert status(raw, "IC-22") == "pass"


# =============================================================================
# IC-23 / IC-24 / IC-25 — manifest drift, docs, multi-rulebase
# =============================================================================

class TestIC23:
    def test_no_drift_passes(self):
        assert status(GOOD_ELIG(), "IC-23") == "pass"

    def test_drift_fails(self):
        assert status(GOOD_ELIG(drift=True), "IC-23") == "fail"


class TestIC24:
    def test_all_docs_pass(self):
        assert status(GOOD_ELIG(), "IC-24") == "pass"

    def test_missing_doc_fails(self):
        raw = GOOD_ELIG()
        raw["rulebases"][0]["exports"]["predicates"][0].pop("doc")
        assert status(raw, "IC-24") == "fail"


class TestIC25:
    def test_single_rulebase_na(self):
        assert status(GOOD_ELIG(), "IC-25") == "n_a"

    def test_multi_ok_passes(self):
        raw = DOM(family="deontic", rulebases=[
            RB(module="main_mod", preds=[P("decide_x", 2, ["PROFILE", "VERDICT"])]),
            RB(module="helper_mod", file="h.seam",
               preds=[P("helper_of", 2, ["A", "B"])]),
        ])
        assert status(raw, "IC-25") == "pass"

    def test_multi_missing_module_fails(self):
        raw = DOM(family="deontic", rulebases=[
            RB(module="main_mod", preds=[P("decide_x", 2, ["PROFILE", "VERDICT"])]),
            {"file": "h.seam", "module": None, "warnings": ["No -module directive found"]},
        ])
        assert status(raw, "IC-25") == "fail"

    def test_multi_ambiguous_entry_fails(self):
        raw = DOM(family="deontic", rulebases=[
            RB(module="m1", preds=[P("decide_x", 2, ["PROFILE", "VERDICT"])]),
            RB(module="m2", file="m2.seam", preds=[P("decide_y", 2, ["PROFILE", "VERDICT"])]),
        ])
        assert status(raw, "IC-25") == "fail"


# =============================================================================
# IC-26 / IC-27 / IC-28 — result ctor, headline decision, obligations
# =============================================================================

class TestIC26:
    def test_eligibility_assessment3_passes(self):
        assert status(GOOD_ELIG(), "IC-26") == "pass"

    def test_kit_imported_assessment_passes(self):
        raw = GOOD_ELIG(ctors=[C("cite", 1)],
                        fl_imports=("profile_get", "profile_has", "attribute", "assessment", "item"))
        assert status(raw, "IC-26") == "pass"

    def test_deontic_prefixed_verdict_passes(self):
        raw = DOM(family="deontic", preds=[P("decide_x", 2, ["PROFILE", "VERDICT"])],
                  ctors=[C("x_verdict", 4), C("cite", 1)])
        assert status(raw, "IC-26") == "pass"

    def test_deontic_bare_verdict_fails(self):
        raw = DOM(family="deontic", preds=[P("decide_x", 2, ["PROFILE", "VERDICT"])],
                  ctors=[C("verdict", 4), C("cite", 1)])
        assert status(raw, "IC-26") == "fail"

    def test_classification_verdict3_fails(self):
        raw = DOM(family="classification", ctors=[C("verdict", 3), C("cite", 1)])
        assert status(raw, "IC-26") == "fail"

    def test_schengen_legacy_tolerated(self):
        raw = DOM(family="temporal", domain="eu/schengen-90-180",
                  ctors=[C("schengen_result", 4), C("stay", 2), C("cite", 1)])
        assert status(raw, "IC-26") == "pass"

    def test_constraint_na(self):
        raw = DOM(family="constraint-satisfaction", ctors=[C("cite", 1)])
        assert status(raw, "IC-26") == "n_a"


class TestIC27:
    def test_eligibility_decision2_passes(self):
        assert status(GOOD_ELIG(), "IC-27") == "pass"

    def test_missing_fails(self):
        raw = GOOD_ELIG()
        preds = raw["rulebases"][0]["exports"]["predicates"]
        preds[:] = [p for p in preds if p["name"] != "good_decision"]
        assert status(raw, "IC-27") == "fail"

    def test_non_eligibility_na(self):
        raw = DOM(family="numeric", preds=[P("x_bps", 2, ["PROFILE", "BPS"])])
        assert status(raw, "IC-27") == "n_a"


class TestIC28:
    def test_deontic_obligation3_passes(self):
        raw = DOM(family="deontic",
                  preds=[P("decide_x", 2, ["PROFILE", "VERDICT"]),
                         P("operator_obligation", 3, ["PROFILE", "OBLIGATION", "CITATION"])])
        assert status(raw, "IC-28") == "pass"

    def test_deontic_without_is_manual(self):
        raw = DOM(family="deontic", preds=[P("decide_x", 2, ["PROFILE", "VERDICT"])])
        assert status(raw, "IC-28") == "manual_pending"

    def test_non_deontic_na(self):
        assert status(GOOD_ELIG(), "IC-28") == "n_a"


# =============================================================================
# IC-30 / IC-31 — constraint + temporal surfaces
# =============================================================================

class TestIC30:
    def test_violations_and_rules_pass(self):
        raw = DOM(family="constraint-satisfaction",
                  preds=[P("invoice_violations", 2, ["INVOICE", "VIOLATIONS"]),
                         P("in_scope_rules", 1, ["LIST"])])
        assert status(raw, "IC-30") == "pass"

    def test_ids_enumerator_accepted(self):
        raw = DOM(family="constraint-satisfaction",
                  preds=[P("x_violations", 2, ["PROFILE", "VIOLATIONS"]),
                         P("art70_condition_ids", 1, ["CIDS"])])
        assert status(raw, "IC-30") == "pass"

    def test_missing_violations_fails(self):
        raw = DOM(family="constraint-satisfaction",
                  preds=[P("art70_condition_ids", 1, ["CIDS"])])
        assert status(raw, "IC-30") == "fail"

    def test_non_constraint_na(self):
        assert status(GOOD_ELIG(), "IC-30") == "n_a"


class TestIC31:
    def test_days_used_passes(self):
        raw = DOM(family="temporal",
                  preds=[P("days_used", 2, ["SCENARIO", "DAYS"]),
                         P("decide_x", 2, ["SCENARIO", "RESULT"])])
        assert status(raw, "IC-31") == "pass"

    def test_deadline3_passes(self):
        raw = DOM(family="temporal",
                  preds=[P("authority_notification_deadline", 3, ["A", "B", "C"])])
        assert status(raw, "IC-31") == "pass"

    def test_none_fails(self):
        raw = DOM(family="temporal", preds=[P("decide_x", 2, ["SCENARIO", "RESULT"])])
        assert status(raw, "IC-31") == "fail"

    def test_non_temporal_na(self):
        assert status(GOOD_ELIG(), "IC-31") == "n_a"


# =============================================================================
# Tier computation (§6) + micro cap (§1.2)
# =============================================================================

class TestTier:
    def test_good_elig_is_l1_not_l2(self):
        m = imp()
        v = m.build_view(GOOD_ELIG())
        res = m.check_domain(v)
        # IC-16 fails (local item/assessment), IC-10 manual → not L2
        assert m.compute_tier(res, micro=False) == "L1"

    def test_ic01_fail_is_none(self):
        m = imp()
        raw = DOM(rulebases=[{"file": "x.seam", "module": None, "warnings": ["w"]}])
        res = m.check_domain(m.build_view(raw))
        assert m.compute_tier(res, micro=False) == "none"

    def test_l1_must_fail_caps_l0(self):
        m = imp()
        raw = GOOD_ELIG(profile_keys=None)  # IC-13 fail
        res = m.check_domain(m.build_view(raw))
        assert m.compute_tier(res, micro=False) == "L0"

    def test_micro_capped_at_l0(self):
        m = imp()
        res = m.check_domain(m.build_view(GOOD_ELIG()))
        assert m.compute_tier(res, micro=True) == "L0"

    def test_manual_pending_blocks_l1(self):
        m = imp()
        raw = DOM(family="deontic",
                  rulebases=[RB(module="d", preds=[
                      P("decide_x", 2, ["PROFILE", "VERDICT"], doc="d"),
                      P("limb_status", 4, ["LIMB", "PROFILE", "STATUS", "CITE"], doc="d"),
                      P("limb_ids", 1, ["IDS"], doc="d")],
                      ctors=[C("x_verdict", 4), C("cite", 1)],
                      atoms=[A("is_x"), A("not_x"), A("indeterminate"), A("c", "citation")])])
        res = m.check_domain(m.build_view(raw))
        assert res["IC-28"]["status"] == "manual_pending"
        assert m.compute_tier(res, micro=False) == "L0"


# =============================================================================
# Integration — real catalog files, known expected outcomes
# =============================================================================

@pytest.mark.skipif(not CATALOG_DIR.exists(), reason="real catalog not present")
class TestIntegration:
    def check(self, rel):
        m = imp()
        raw = yaml.safe_load((CATALOG_DIR / rel).read_text())
        v = m.build_view(raw)
        return m.check_domain(v), v, m

    def test_crr_own_funds_passes_all_l1_musts(self):
        res, v, m = self.check("eu/banking/crr-own-funds-min-ratios.yaml")
        for rid in m.L1_MUST_RULES + ("IC-01", "IC-02"):
            assert res[rid]["status"] in ("pass", "n_a"), (rid, res[rid])
        assert m.compute_tier(res, micro=False) == "L1"

    def test_crr_own_funds_known_l2_gaps(self):
        res, _, _ = self.check("eu/banking/crr-own-funds-min-ratios.yaml")
        assert res["IC-16"]["status"] == "fail"       # local item/3, assessment/3
        assert res["IC-17"]["status"] == "manual_pending"
        assert res["IC-23"]["status"] == "fail"       # manifest drift

    def test_th_visa_fails_ic13_and_ic18(self):
        res, _, _ = self.check("th/visa.yaml")
        assert res["IC-13"]["status"] == "fail"
        assert res["IC-18"]["status"] == "fail"
        assert res["IC-16"]["status"] == "pass"       # imports kit functors

    def test_us_snap_fails_ic13(self):
        res, _, _ = self.check("us/snap.yaml")
        assert res["IC-13"]["status"] == "fail"

    def test_diversity_jurisdiction_passes_ic01_post_batch_1_1(self):
        # batch-1.1 (commit b0d9080) added -module directive; IC-01 now passes.
        res, _, m = self.check("us/diversity-jurisdiction.yaml")
        assert res["IC-01"]["status"] == "pass"
        assert m.compute_tier(res, micro=False) == "L0"

    def test_eu_gdpr_multi_rulebase_ic25_passes(self):
        res, _, _ = self.check("eu/gdpr.yaml")
        assert res["IC-25"]["status"] == "pass"

    def test_obligation_flavored_deontic_ic05_pending(self):
        # v0.2: cdd + gpsr export *_obligation/3 without a /4 limb surface —
        # IC-05 emits manual_pending (adjudicated n/a in CONFORMANCE-REPORT §3.8)
        for rel in ("eu/aml/amlr-cdd-obligations.yaml",
                    "eu/product-safety/gpsr-economic-operator-obligations.yaml"):
            res, _, _ = self.check(rel)
            assert res["IC-05"]["status"] == "manual_pending", rel
            assert res["IC-28"]["status"] == "pass", rel


# =============================================================================
# Report build — determinism + shape
# =============================================================================

@pytest.mark.skipif(not CATALOG_DIR.exists(), reason="real catalog not present")
class TestReport:
    def test_deterministic(self):
        m = imp()
        r1 = m.render_report(m.build_report(CATALOG_DIR))
        r2 = m.render_report(m.build_report(CATALOG_DIR))
        assert r1 == r2

    def test_shape(self):
        m = imp()
        rep = m.build_report(CATALOG_DIR)
        assert rep["schema_version"] == 0
        assert len(rep["domains"]) == 53
        d0 = rep["domains"][0]
        assert set(d0) == {"domain", "cohort", "micro", "tier", "rules"}
        assert len(d0["rules"]) == 31
        names = [d["domain"] for d in rep["domains"]]
        assert names == sorted(names)

    def test_no_timestamps(self):
        m = imp()
        out = m.render_report(m.build_report(CATALOG_DIR))
        # The only date-like strings allowed are the standard doc's filename
        # in the header — no generation timestamps anywhere.
        assert out.count("2026-07") == out.count(
            "2026-07-06-interface-conformance-standard.md")
        assert "generated_at" not in out
