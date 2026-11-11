"""Synthetic outcomes test study aggregation; none are actual legal judgments."""
import copy
import importlib.util
import json
from pathlib import Path
import unittest

from gdpr_bench.dataset import digest_json


def fixture_cases():
    return [{"id": f"{prefix}{i:02d}", "kind": kind,
             "questions": [{"id": f"q{q}", "evaluation_tags": []}
                           for q in range(1, questions + 1)]}
            for prefix, kind, count, questions in (("F", "focused", 20, 1), ("C", "complex", 10, 5))
            for i in range(1, count + 1)]


def fixture_study(approved=False):
    study = json.loads((Path(__file__).resolve().parents[1] / "config/study.json").read_text())
    if approved:
        study.update(independent_legal_review_status="approved", preregistration_status="registered")
        study["review_roles"] = {key: "synthetic-fixture-" + key for key in
                                 ("gdpr_reviewer_1", "gdpr_reviewer_2", "third_adjudicator", "independent_analyst")}
    return study


def fixture_row(case, slot, arm, correct, repeat=0):
    return {"record_id": f"{slot}-{case['id']}-{arm}-{repeat}", "case_id": case["id"],
            "arm": arm, "repeat": repeat, "model_slot": slot, "provider": slot,
            "model": slot + "-fixture-v1", "status": "ok", "metric": "human_accuracy",
            "score": int(correct), "severe_error": not bool(correct), "review_status": "adjudicated",
            "case_sha256": digest_json(case), "law_sha256": "a" * 64, "gold_sha256": "b" * 64,
            "corpus_sha256": "c" * 64, "config_sha256": digest_json(slot),
            "extraction_sha256": digest_json({"case": case["id"], "repeat": repeat}),
            "review_evidence": {
                "synthetic_test_fixture": True,
                "reviewers": ["synthetic-fixture-gdpr_reviewer_1", "synthetic-fixture-gdpr_reviewer_2"],
                "adjudicator": "synthetic-fixture-third_adjudicator",
                "roles_sha256": digest_json({"synthetic_fixture_roles": list(fixture_study(approved=True)["review_roles"].values())}),
                "adjudication_sha256": digest_json({"synthetic_fixture": True, "case": case["id"],
                                                   "slot": slot, "arm": arm, "repeat": repeat}),
                "signed_at": "2026-11-06T12:00:00+00:00",
            },
            "questions": [{"question_id": q["id"], "legally_correct": bool(correct),
                           "severe_error": not bool(correct), "dimensions": {"uncertainty": 2}}
                          for q in case["questions"]]}


def complete_baselines_and_anchor(cases, study):
    # Best baseline is gemini (24/30), anchor treatment 27/30, control 18/30.
    rows = [fixture_row(case, slot, "llm_text", i < correct)
            for slot, correct in zip(study["model_slots"], (12, 13, 14, 24, 16, 17))
            for i, case in enumerate(cases)]
    rows += [fixture_row(case, study["primary_model_slot"], arm, i < correct)
             for arm, correct in (("llm_control", 18), ("llm_prolog", 27))
             for i, case in enumerate(cases)]
    return rows


class StudyTests(unittest.TestCase):
    def report(self, rows, cases=None, study=None):
        self.assertIsNotNone(importlib.util.find_spec("gdpr_bench.study"), "Missing cross-model study analysis")
        from gdpr_bench.study import analyse_study
        return analyse_study(rows, fixture_cases() if cases is None else cases,
                             fixture_study() if study is None else study)

    def test_no_results_keep_all_registered_models_missing_without_inventing_p_values(self):
        result = self.report([])
        self.assertEqual(result["status"], "not_evaluable")
        self.assertEqual(set(result["model_reports"]), set(fixture_study()["model_slots"]))
        self.assertFalse(result["final_review_complete"])
        self.assertEqual(result["targets"]["best_llm_accuracy_improvement"]["status"], "not_evaluable")
        self.assertEqual(result["multiplicity"]["family_size"], 6)
        for test in result["multiplicity"]["tests"].values():
            self.assertIsNone(test["p_raw"])
            self.assertIsNone(test["p_holm"])
            self.assertEqual(test["adjustment_input"], 1)

    def test_blocked_human_templates_without_configured_models_remain_unavailable(self):
        case = fixture_cases()[0]
        rows = [fixture_row(case, slot, arm, False)
                for slot in fixture_study()["model_slots"]
                for arm in ("llm_control", "llm_prolog", "llm_text")]
        for row in rows:
            row.update(status="blocked", score=None, severe_error=None, model=None)
        result = self.report(rows, [case])
        self.assertEqual(result["status"], "not_evaluable")
        self.assertFalse(result["final_review_complete"])
        self.assertEqual(result["best_single_pass_baseline"]["baselines"]["qwen"]["human_reviewed_cases"], 0)

    def test_holm_uses_all_six_models_and_does_not_pool_opposite_effects(self):
        cases = fixture_cases()[:5]
        rows = [fixture_row(case, slot, arm, arm == winning_arm)
                for slot, winning_arm in (("openai", "llm_prolog"), ("anthropic_opus", "llm_control"))
                for case in cases for arm in ("llm_control", "llm_prolog")]
        report = self.report(rows, cases)
        h1a = report["model_reports"]["openai"]["hypotheses"]["H1"]
        h1b = report["model_reports"]["anthropic_opus"]["hypotheses"]["H1"]
        self.assertEqual((h1a["n_cases"], h1b["n_cases"]), (5, 5))
        self.assertEqual((h1a["accuracy_delta"], h1b["accuracy_delta"]), (1, -1))
        adjusted = report["multiplicity"]["tests"]
        self.assertEqual(adjusted["openai"]["p_raw"], 1 / 32)
        self.assertEqual(adjusted["openai"]["p_holm"], 6 / 32)
        self.assertEqual(adjusted["anthropic_opus"]["p_holm"], 1)
        self.assertIsNone(adjusted["qwen"]["p_holm"])
        self.assertEqual(report["targets"]["primary_significance"]["observed"], 6 / 32)
        self.assertEqual(report["targets"]["primary_significance"]["status"], "not_evaluable")

    def test_best_baseline_requires_all_six_complete_human_baselines(self):
        cases, study = fixture_cases(), fixture_study()
        rows = complete_baselines_and_anchor(cases, study)
        result = self.report(rows, cases, study)
        best = result["best_single_pass_baseline"]
        self.assertEqual(best["best_model_slots"], ["gemini"])
        self.assertAlmostEqual(best["best_accuracy"], .8)
        self.assertAlmostEqual(result["targets"]["best_llm_accuracy_improvement"]["observed"], .1)
        self.assertAlmostEqual(result["targets"]["accuracy_improvement"]["observed"], .3)
        self.assertEqual(result["targets"]["best_llm_accuracy_improvement"]["status"], "pass")
        self.assertIsNone(best["p_one_sided_exact"])
        self.assertIn("selection", best["classification"])
        missing_one = rows[1:]
        incomplete = self.report(missing_one, cases, study)
        self.assertEqual(incomplete["targets"]["best_llm_accuracy_improvement"]["status"], "not_evaluable")
        self.assertIsNone(incomplete["best_single_pass_baseline"]["best_accuracy"])

    def test_unreviewed_or_automatic_baseline_cannot_fill_missing_human_evidence(self):
        cases, study = fixture_cases(), fixture_study()
        rows = complete_baselines_and_anchor(cases, study)
        for row in rows:
            if row["model_slot"] == "deepseek":
                row["metric"] = "provisional_decision_match"
        result = self.report(rows, cases, study)
        summary = result["best_single_pass_baseline"]["baselines"]["deepseek"]
        self.assertEqual(summary["completed_outputs"], 30)
        self.assertEqual(summary["human_reviewed_cases"], 0)
        self.assertIsNone(summary["accuracy"])
        self.assertEqual(result["targets"]["best_llm_accuracy_improvement"]["status"], "not_evaluable")

    def test_best_baseline_ties_are_reported_and_repeat_one_does_not_replace_repeat_zero(self):
        cases, study = fixture_cases(), fixture_study()
        rows = complete_baselines_and_anchor(cases, study)
        for i, row in enumerate(r for r in rows if r["model_slot"] == "qwen"):
            row["score"], row["severe_error"] = int(i < 24), i >= 24
        rows += [fixture_row(case, "deepseek", "llm_text", True, repeat=1) for case in cases]
        best = self.report(rows, cases, study)["best_single_pass_baseline"]
        self.assertEqual(best["best_model_slots"], ["gemini", "qwen"])
        self.assertEqual(best["baselines"]["deepseek"]["human_reviewed_cases"], 30)
        self.assertAlmostEqual(best["baselines"]["deepseek"]["accuracy"], 17 / 30)

    def test_final_review_gate_requires_adjudication_registration_and_distinct_roles(self):
        cases, study = fixture_cases(), fixture_study(approved=True)
        rows = complete_baselines_and_anchor(cases, study)
        self.assertTrue(self.report(rows, cases, study)["final_review_complete"])
        for key, value in (("independent_legal_review_status", "pending"), ("preregistration_status", "draft_not_registered")):
            changed = copy.deepcopy(study)
            changed[key] = value
            self.assertFalse(self.report(rows, cases, changed)["final_review_complete"])
        changed = copy.deepcopy(study)
        changed["review_roles"]["independent_analyst"] = changed["review_roles"]["gdpr_reviewer_1"].upper()
        self.assertFalse(self.report(rows, cases, changed)["final_review_complete"])
        changed = copy.deepcopy(rows)
        changed[0]["review_status"] = "independent_review"
        self.assertFalse(self.report(changed, cases, study)["final_review_complete"])
        # A second model's used H1 outcomes also need adjudication.
        extra = [fixture_row(cases[0], "qwen", arm, arm == "llm_prolog")
                 for arm in ("llm_control", "llm_prolog")]
        extra[0]["review_status"] = "independent_review"
        self.assertFalse(self.report(rows + extra, cases, study)["final_review_complete"])

    def test_adjudicated_label_without_review_evidence_cannot_finalize_study_or_targets(self):
        cases, study = fixture_cases(), fixture_study(approved=True)
        original = complete_baselines_and_anchor(cases, study)
        for arm in ("llm_control", "llm_prolog", "llm_text"):
            rows = copy.deepcopy(original)
            row = next(r for r in rows if r["arm"] == arm)
            row.pop("review_evidence")
            self.assertEqual(row["review_status"], "adjudicated")
            report = self.report(rows, cases, study)
            with self.subTest(arm=arm):
                self.assertFalse(report["final_review_complete"])
                self.assertFalse(report["review_gate"]["all_used_h1_and_baseline_rows_adjudicated"])
                if arm in {"llm_control", "llm_prolog"}:
                    self.assertFalse(report["anchor_report"]["hypotheses"]["H1"]["human_review_finalized"])
                    self.assertEqual(report["targets"]["primary_significance"]["status"], "not_evaluable")
                if arm in {"llm_prolog", "llm_text"}:
                    self.assertEqual(report["targets"]["best_llm_accuracy_improvement"]["status"], "not_evaluable")

    def test_incomplete_signed_evidence_in_any_used_h1_prevents_final_significance(self):
        cases, study = fixture_cases(), fixture_study(approved=True)
        original = complete_baselines_and_anchor(cases, study)
        original += [fixture_row(cases[0], "qwen", arm, arm == "llm_prolog")
                     for arm in ("llm_control", "llm_prolog")]
        for field in ("reviewers", "adjudicator", "roles_sha256", "adjudication_sha256", "signed_at"):
            rows = copy.deepcopy(original)
            rows[-1]["review_evidence"].pop(field)
            report = self.report(rows, cases, study)
            with self.subTest(field=field):
                self.assertTrue(report["anchor_report"]["hypotheses"]["H1"]["human_review_finalized"])
                self.assertFalse(report["final_review_complete"])
                self.assertEqual(report["targets"]["primary_significance"]["status"], "not_evaluable")

    def test_unregistered_slots_mixed_models_and_duplicate_cells_are_rejected(self):
        cases = fixture_cases()[:2]
        base = [fixture_row(cases[i], "openai", "llm_text", True) for i in range(2)]
        variants = []
        unknown = copy.deepcopy(base); unknown[0]["model_slot"] = "unregistered"; variants.append(unknown)
        mixed = copy.deepcopy(base); mixed[0]["model"] = "other-version"; variants.append(mixed)
        variants.append(base + [copy.deepcopy(base[0])])
        repeated = copy.deepcopy(base); repeated[0]["repeat"] = True; variants.append(repeated)
        for rows in variants:
            with self.subTest(rows=rows), self.assertRaises(ValueError):
                self.report(rows, cases)
        study = fixture_study(); study["model_slots"].pop()
        with self.assertRaises(ValueError):
            self.report([], cases, study)

    def test_cross_model_baselines_require_identical_corpus_and_law_provenance(self):
        cases = fixture_cases()[:2]
        rows = [fixture_row(case, slot, "llm_text", True)
                for slot in ("openai", "qwen") for case in cases]
        for field in ("case_sha256", "law_sha256", "corpus_sha256", "gold_sha256"):
            changed = copy.deepcopy(rows); changed[-1][field] = "f" * 64
            with self.subTest(field=field), self.assertRaises(ValueError):
                self.report(changed, cases)

    def test_invalid_human_baseline_scores_are_rejected_without_a_control_arm(self):
        case = fixture_cases()[0]
        for changes in ({"score": .5}, {"score": 1, "severe_error": True}, {"law_sha256": "bad"}, {"model": None}):
            row = fixture_row(case, "openai", "llm_text", True)
            row.update(changes)
            with self.subTest(changes=changes), self.assertRaises(ValueError):
                self.report([row], [case])

    def test_products_remain_descriptive_and_cannot_supply_h1_or_best_model_results(self):
        cases = fixture_cases()
        rows = []
        for i, case in enumerate(cases[:5]):
            row = fixture_row(case, "harvey", "product:harvey", i < 4)
            row.pop("model_slot")
            row["product_capture"] = {"source_control": "uncontrolled_inputs", "product_version": row["model"]}
            rows.append(row)
        result = self.report(rows, cases)
        product = result["products"]["harvey"]
        self.assertEqual(product["human_reviewed_cases"], 5)
        self.assertAlmostEqual(product["accuracy"], .8)
        self.assertEqual(product["missing_cases"], 25)
        self.assertEqual(product["source_control_counts"], {"uncontrolled_inputs": 5})
        self.assertFalse(product["causal_comparison_supported"])
        self.assertEqual(result["status"], "not_evaluable")
        self.assertIsNone(result["multiplicity"]["tests"]["openai"]["p_raw"])
        self.assertEqual(result["targets"]["best_llm_accuracy_improvement"]["status"], "not_evaluable")
        self.assertIn("legora", result["products"])

    def test_inputs_are_not_mutated(self):
        cases = fixture_cases()[:1]
        rows = [fixture_row(cases[0], "openai", "llm_text", True)]
        study = fixture_study()
        original = copy.deepcopy((rows, cases, study))
        self.report(rows, cases, study)
        self.assertEqual((rows, cases, study), original)


if __name__ == "__main__":
    unittest.main()
