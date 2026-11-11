"""Synthetic numerical fixtures test analysis, never claim real legal judgments."""
import copy
import importlib.util
import unittest

from gdpr_bench.dataset import digest_json
from tests.test_evaluation import human_row


def example_cases():
    return [{"id": cid, "kind": kind, "questions": [
        {"id": f"q{i}", "evaluation_tags": ["exception_boundary", "missing_information"]}
        for i in range(1, count + 1)]}
        for cid, kind, count in (("F01", "focused", 1), ("F02", "focused", 1),
                                 ("C01", "complex", 5), ("C02", "complex", 5))]


def example_rows(cases):
    rows = []
    for case in cases:
        for arm in ("llm_control", "llm_prolog", "llm_python"):
            correct = int(arm == "llm_prolog" and case["kind"] == "complex")
            row = human_row(case["id"], arm, correct, severe=not bool(correct))
            row["case_sha256"] = digest_json(case)
            row["questions"] = [{"question_id": q["id"], "legally_correct": bool(correct),
                                  "score": correct, "severe_error": not bool(correct),
                                  "dimensions": {"uncertainty": 2}} for q in case["questions"]]
            rows.append(row)
    return rows


class HypothesesTests(unittest.TestCase):
    def report(self, rows, cases):
        self.assertIsNotNone(importlib.util.find_spec("gdpr_bench.analysis"), "Missing hypotheses report")
        from gdpr_bench.analysis import hypotheses_report
        return hypotheses_report(rows, cases)

    def test_hypotheses_and_tags_remain_case_level_despite_subquestions_and_repeats(self):
        cases = example_cases()
        rows = example_rows(cases)
        repeated = copy.deepcopy(rows)
        for row in repeated:
            row["repeat"] = 1
            row["record_id"] += "-repeat1"
        report = self.report(rows + repeated, cases)
        self.assertEqual(report["hypotheses"]["H1"]["n_cases"], 4)
        h2 = report["hypotheses"]["H2"]
        self.assertEqual(h2["n_cases"], 4)
        self.assertEqual(h2["effect_difference_complex_minus_focused"], 1)
        self.assertAlmostEqual(h2["p_two_sided"], 1 / 3)
        h3 = report["hypotheses"]["H3"]
        self.assertEqual(h3["n_cases"], 4)
        self.assertEqual(h3["relative_severe_error_reduction"], .5)
        self.assertEqual(h3["p_one_sided_exact"], .25)
        self.assertEqual(report["hypotheses"]["H4"]["n_cases"], 4)
        subgroup = report["subgroups"]["exception_boundary"]
        self.assertEqual(subgroup["n_cases"], 4)
        self.assertEqual(subgroup["n_questions"], 12)
        self.assertEqual(subgroup["accuracy_delta"], .5)

    def test_automatic_gold_diagnostics_cannot_satisfy_human_hypotheses_or_targets(self):
        cases = example_cases()
        rows = example_rows(cases)
        for row in rows:
            row["metric"] = "provisional_decision_match"
        report = self.report(rows, cases)
        self.assertEqual(report["status"], "not_evaluable")
        for hypothesis in report["hypotheses"].values():
            self.assertEqual(hypothesis["status"], "not_evaluable")
        for target in report["targets"].values():
            self.assertEqual(target["status"], "not_evaluable")

    def test_missing_severe_labels_remain_unknown_not_zero(self):
        cases = example_cases()
        rows = example_rows(cases)
        for row in rows:
            row["severe_error"] = None
        report = self.report(rows, cases)
        self.assertEqual(report["hypotheses"]["H3"]["status"], "not_evaluable")
        self.assertIsNone(report["targets"]["severe_error_reduction"]["observed"])

    def test_no_exception_or_missing_info_tags_does_not_infer_subgroups(self):
        cases = example_cases()
        for case in cases:
            for question in case["questions"]:
                question["evaluation_tags"] = []
        report = self.report(example_rows(cases), cases)
        for subgroup in report["subgroups"].values():
            self.assertEqual(subgroup["status"], "not_evaluable")
            self.assertEqual(subgroup["n_cases"], 0)

    def test_missing_information_requires_explicit_appropriate_uncertainty(self):
        cases = example_cases()
        rows = example_rows(cases)
        for row in rows:
            if row["arm"] == "llm_prolog":
                for q in row["questions"]:
                    q["dimensions"]["uncertainty"] = 0
        report = self.report(rows, cases)
        self.assertEqual(report["subgroups"]["missing_information"]["accuracy_b"], 0)

    def test_case_revision_or_unplanned_case_rejected(self):
        cases = example_cases()
        rows = example_rows(cases)
        cases[0]["questions"][0]["evaluation_tags"] = []
        with self.assertRaises(ValueError):
            self.report(rows, cases)
        rows[0]["case_id"] = "unplanned"
        with self.assertRaises(ValueError):
            self.report(rows, example_cases())

    def test_zero_baseline_severe_error_reduction_is_undefined(self):
        cases = example_cases()
        rows = example_rows(cases)
        for row in rows:
            row["severe_error"] = False
        h3 = self.report(rows, cases)["hypotheses"]["H3"]
        self.assertIsNone(h3["relative_severe_error_reduction"])
        self.assertEqual(h3["p_one_sided_exact"], 1)

    def test_python_prolog_inference_requires_reviewed_scope_alignment(self):
        cases = example_cases()
        rows = example_rows(cases)
        report = self.report(rows, cases)
        self.assertEqual(report["hypotheses"]["H4"]["status"], "not_evaluable")
        self.assertEqual(report["hypotheses"]["H4"]["descriptive_contrast"]["n_cases"], 4)
        for row in rows:
            row["engine_scope_alignment"] = {"status": "approved", "case_sha256": row["case_sha256"],
                                              "reviewer": "synthetic-fixture-reviewer", "reviewed_at": "2026-11-06"}
        self.assertEqual(self.report(rows, cases)["hypotheses"]["H4"]["status"], "ok")
        rows[1]["engine_scope_alignment"]["case_sha256"] = "e" * 64
        self.assertEqual(self.report(rows, cases)["hypotheses"]["H4"]["status"], "not_evaluable")

    def test_full_corpus_single_reviewer_does_not_pass_final_decision_targets(self):
        cases = [{"id": f"F{i:02d}", "kind": "focused", "questions": [{"id": "q1"}]} for i in range(1, 21)]
        cases += [{"id": f"C{i:02d}", "kind": "complex", "questions": [{"id": f"q{q}"} for q in range(1, 6)]} for i in range(1, 11)]
        rows = example_rows(cases)
        for row in rows:
            row["review_status"] = "independent_review"
        report = self.report(rows, cases)
        self.assertEqual(report["targets"]["accuracy_improvement"]["status"], "not_evaluable")
        self.assertFalse(report["hypotheses"]["H1"]["human_review_finalized"])


if __name__ == "__main__":
    unittest.main()
