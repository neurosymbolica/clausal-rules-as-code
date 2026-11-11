import copy
import json
from pathlib import Path
import tempfile
import unittest
from gdpr_bench import evaluation
from gdpr_bench import statistics
from gdpr_bench.evaluation import blind_export, import_reviews, diagnostic_scores
from gdpr_bench.statistics import paired_statistics, holm_adjust, exact_mcnemar, compare_scores
from gdpr_bench.dataset import ROOT, digest_json, sha256, write_json, write_jsonl, read_jsonl


class StatisticsTests(unittest.TestCase):
    def test_exact_sign_flip_constant_positive(self):
        stats = paired_statistics([0, 0, 0, 0, 0], [1, 1, 1, 1, 1])
        self.assertEqual(stats["n_cases"], 5)
        self.assertAlmostEqual(stats["permutation_p_two_sided"], 2 / 32)
        self.assertEqual(stats["mean_difference_b_minus_a"], 1)

    def test_identical_and_missing_pairs(self):
        self.assertEqual(paired_statistics([.2, .3], [.2, .3])["permutation_p_two_sided"], 1)
        self.assertEqual(paired_statistics([], [])["status"], "insufficient_data")

    def test_mcnemar_known(self):
        self.assertEqual(exact_mcnemar(0, 0), 1)
        self.assertAlmostEqual(exact_mcnemar(0, 5), .0625)

    def test_holm_adjustment(self):
        self.assertEqual(holm_adjust([.01, .03, .04]), [.03, .06, .06])

    def test_repeats_aggregate_within_case_not_pseudoreplicates(self):
        rows = []
        for c in ("F01", "F02"):
            for rep in range(3):
                for arm, value in (("a", .1), ("b", .9)):
                    rows.append({"case_id": c, "repeat": rep, "arm": arm, "status": "ok", "score": value})
        stats = compare_scores(rows, "a", "b")
        self.assertEqual(stats["n_cases"], 2)
        self.assertEqual(stats["matched_case_repeats"], 6)

    def test_unpaired_repeat_not_used(self):
        rows = [{"case_id": "F01", "repeat": 0, "arm": "a", "status": "ok", "score": 1}, {"case_id": "F01", "repeat": 1, "arm": "b", "status": "ok", "score": 0}]
        self.assertEqual(compare_scores(rows, "a", "b")["status"], "insufficient_data")


def human_row(cid, arm, score, repeat=0, severe=False):
    return {"record_id": f"{cid}-{arm}-{repeat}", "case_id": cid, "repeat": repeat, "arm": arm,
            "provider": "test-provider", "model": "test-model", "status": "ok", "metric": "human_accuracy",
            "score": score, "severe_error": severe, "reviewer": "reviewed-consensus",
            "law_sha256": "a" * 64, "case_sha256": "b" * 64, "source_predictions_sha256": "c" * 64,
            "gold_sha256": "d" * 64, "extraction_sha256": "e" * 64}


class PrimaryStatisticsTests(unittest.TestCase):
    def test_changed_returned_model_revision_is_not_a_matched_cohort(self):
        rows=[human_row('F01',arm,1) for arm in ('a','b')]
        rows[0]['resolved_model']='fixture-version-1'
        rows[1]['resolved_model']='fixture-version-2'
        with self.assertRaises(ValueError):statistics.primary_accuracy_compare(rows,'a','b')

    def compare(self, rows):
        self.assertTrue(hasattr(statistics, "primary_accuracy_compare"), "Missing binary primary analysis")
        return statistics.primary_accuracy_compare(rows, "a", "b")

    def test_one_sided_known_binomial_and_repeat_zero_only(self):
        rows = [human_row(f"F{i:02d}", arm, score, repeat)
                for i in range(1, 6) for repeat in range(3)
                for arm, score in (("a", int(repeat != 0)), ("b", int(repeat == 0)))]
        stats = self.compare(rows)
        self.assertEqual(stats["n_cases"], 5)
        self.assertEqual(stats["wins_b"], 5)
        self.assertEqual(stats["losses_b"], 0)
        self.assertEqual(stats["p_one_sided_exact"], 1 / 32)
        self.assertEqual(stats["accuracy_delta"], 1)
        self.assertEqual(stats["bootstrap_percentile_95ci"], [1, 1])

    def test_reverse_difference_does_not_become_one_sided_significance(self):
        rows = [human_row(f"F{i:02d}", arm, score) for i in range(1, 6) for arm, score in (("a", 1), ("b", 0))]
        self.assertEqual(self.compare(rows)["p_one_sided_exact"], 1)

    def test_blocked_unreviewed_missing_and_failed_are_not_primary_zeros(self):
        rows = [human_row("F01", "a", 1), human_row("F01", "b", 1),
                human_row("F02", "a", 1), human_row("F02", "b", None),
                human_row("F03", "a", 1), human_row("F03", "b", None), human_row("F04", "a", 0),
                human_row("F05", "a", 0), human_row("F05", "b", None)]
        rows[3]["status"] = "blocked"
        rows[-1]["status"] = "failed"
        result = self.compare(rows)
        self.assertEqual(result["n_cases"], 1)
        self.assertEqual(result["availability_by_arm"]["b"]["unreviewed"], 1)
        self.assertEqual(result["availability_by_arm"]["b"]["missing"], 1)
        self.assertEqual(result["failure_sensitivity"]["n_cases"], 2)
        self.assertEqual(result["p_one_sided_exact"], 1)

    def test_no_human_scores_have_no_p_value(self):
        automatic = human_row("F01", "a", 1)
        automatic["metric"] = "provisional_decision_match"
        result = self.compare([automatic])
        self.assertEqual(result["status"], "not_evaluable")
        self.assertIsNone(result["p_one_sided_exact"])

    def test_no_human_scores_still_expose_operational_coverage(self):
        rows = [human_row("F01", "a", 1), human_row("F01", "b", None)]
        for row in rows:
            row["metric"] = "provisional_decision_match"
        rows[1]["status"] = "blocked"
        result = self.compare(rows)
        self.assertEqual(result["observed_case_count"], 1)
        self.assertEqual(result["availability_by_arm"]["a"]["unreviewed"], 1)
        self.assertEqual(result["availability_by_arm"]["b"]["blocked"], 1)
        self.assertEqual(result["unobserved_case_count"], 29)
        self.assertEqual(result["failure_sensitivity"]["status"], "not_evaluable")

    def test_mixed_metric_duplicate_and_corrupt_cohorts_rejected(self):
        clean = [human_row("F01", "a", 1), human_row("F01", "b", 0)]
        for field, wrong in (("metric", "provisional_decision_match"), ("case_sha256", "e" * 64),
                             ("law_sha256", None), ("model", "another-model"), ("score", .5)):
            with self.subTest(field=field):
                corrupt = copy.deepcopy(clean)
                corrupt[-1][field] = wrong
                with self.assertRaises(ValueError):
                    self.compare(corrupt)
        with self.assertRaises(ValueError):
            self.compare(clean + [clean[0]])

    def test_controlled_extraction_and_configuration_must_match_when_available(self):
        for field in ("extraction_sha256", "config_sha256"):
            rows = [human_row("F01", "a", 1), human_row("F01", "b", 0)]
            rows[0][field], rows[1][field] = "a" * 64, "b" * 64
            with self.subTest(field=field), self.assertRaises(ValueError):
                self.compare(rows)

    def test_unknown_severe_status_cannot_be_assumed_safe(self):
        rows = [human_row("F01", "a", 1), human_row("F01", "b", 1)]
        rows[1]["severe_error"] = None
        self.assertEqual(self.compare(rows)["status"], "not_evaluable")

    def test_scored_controlled_pairs_require_actual_valid_shared_extraction_hashes(self):
        for missing_or_invalid in (None, "not-a-hash"):
            with self.subTest(value=missing_or_invalid):
                rows = [human_row("F01", "llm_control", 0), human_row("F01", "llm_prolog", 1)]
                for row in rows:
                    row["extraction_sha256"] = missing_or_invalid
                with self.assertRaises(ValueError):
                    statistics.primary_accuracy_compare(rows, "llm_control", "llm_prolog")
        rows = [human_row("F01", "llm_control", 0), human_row("F01", "llm_prolog", None)]
        rows[1].update(status="blocked", extraction_sha256=None)
        self.assertEqual(statistics.primary_accuracy_compare(rows, "llm_control", "llm_prolog")["status"], "not_evaluable")

    def test_binary_agreement_reports_kappa_without_inventing_degenerate_value(self):
        first = [human_row(f"F{i:02d}", "a", score) for i, score in enumerate((0, 0, 1, 1), 1)]
        second = copy.deepcopy(first)
        for row, score in zip(second, (0, 1, 1, 1)):
            row["score"] = score
        agreement = statistics.rater_agreement(first, second)
        self.assertEqual(agreement["binary_accuracy_agreement"], .75)
        self.assertEqual(agreement["cohen_kappa"], .5)
        all_correct = [human_row("F01", "a", 1)]
        self.assertIsNone(statistics.rater_agreement(all_correct, all_correct)["cohen_kappa"])


class BlindTests(unittest.TestCase):
    def fixture(self, p, *, legacy_metadata=False):
        case = {"id": "F01", "title": "Example", "scenario": "A situation", "scope": {}, "kind": "focused", "questions": [{"id": "q1", "prompt": "Question?"}]}
        gold = {"F01": {"case_id": "F01", "status": "provisional", "answers": [{"question_id": "q1", "decision": "yes", "conclusion": "yes", "reasoning": "because", "required_points": ["point"], "legal_basis": [], "acceptable_alternatives": [], "missing_facts": [], "actions": [], "pitfalls": []}]}}
        prediction = {"answers": [{"question_id": "q1", "decision": "yes", "reasoning": "Because", "citations": [], "missing_facts": [], "actions": []}]}
        if legacy_metadata:
            prediction.update(model="LEGACY_MODEL", arm="llm_text")
            prediction["answers"][0]["provider"] = "LEGACY_PROVIDER"
        write_jsonl(p / "cases.snapshot.jsonl", [case])
        write_jsonl(p / "predictions.jsonl", [{"record_id": "r1", "case_id": "F01", "repeat": 0, "arm": "llm_text", "model": "PRIVATE_MODEL", "provider": "PRIVATE_PROVIDER", "status": "ok", "prediction": prediction}])
        return gold

    def test_blind_export_hides_identity_and_import_validates(self):
        with tempfile.TemporaryDirectory() as td:
            p = Path(td)
            gold = self.fixture(p)
            blind_export(p, p / "reviewer", p / "private.json", gold)
            text = (p / "reviewer/items.jsonl").read_text()
            for identity in ("PRIVATE_MODEL", "PRIVATE_PROVIDER", '"arm"', '"record_id"'):
                self.assertNotIn(identity, text)
            items = read_jsonl(p / "reviewer/items.jsonl")
            with self.assertRaises(ValueError):
                import_reviews(p / "reviewer/items.jsonl", p / "private.json", "expert")
            for item in items:
                for q in item["ratings"]:
                    q["scores"] = {k: 2 for k in q["scores"]}
                    for point in q["required_points"]:
                        point.update(met=True, evidence="Because")
                    q["errors"] = []
                    q["comment"] = "Reviewed"
                    q["legally_correct"] = True
                    q["severe_error"] = False
            write_jsonl(p / "reviewer/items.jsonl", items)
            scores = import_reviews(p / "reviewer/items.jsonl", p / "private.json", "expert")
            self.assertEqual(scores[0]["score"], 1)
            self.assertEqual(scores[0]["arm"], "llm_text")
            self.assertEqual(scores[0]["metric"], "human_accuracy")
            self.assertEqual(scores[0]["rubric_score"], 1)
            changed = copy.deepcopy(items)
            changed[0]["response"]["answers"][0]["decision"] = "no"
            write_jsonl(p / "reviewer/items.jsonl", changed)
            with self.assertRaises(ValueError):
                import_reviews(p / "reviewer/items.jsonl", p / "private.json", "expert")

    def test_key_may_not_be_inside_blind_directory(self):
        with tempfile.TemporaryDirectory() as td:
            p = Path(td)
            gold = self.fixture(p)
            with self.assertRaises(ValueError):
                blind_export(p, p / "reviewer", p / "reviewer/private.json", gold)

    def test_review_bundle_contains_exact_hash_verified_pinned_legislation(self):
        with tempfile.TemporaryDirectory() as td:
            p = Path(td)
            blind_export(p, p / "reviewer", p / "private.json", self.fixture(p))
            law_dir = p / "reviewer/legislation"
            self.assertTrue((law_dir / "gdpr-articles.txt").is_file())
            self.assertEqual(sha256(law_dir / "gdpr-articles.txt"), sha256(ROOT / "sources/gdpr-articles.txt"))
            self.assertEqual((law_dir / "law-manifest.json").read_bytes(), (ROOT / "sources/law-manifest.json").read_bytes())

    def test_legacy_prediction_metadata_is_removed_during_blind_export(self):
        with tempfile.TemporaryDirectory() as td:
            p = Path(td)
            gold = self.fixture(p, legacy_metadata=True)
            original = (p / "predictions.jsonl").read_bytes()
            blind_export(p, p / "reviewer", p / "private.json", gold)
            item = read_jsonl(p / "reviewer/items.jsonl")[0]
            self.assertEqual(item["response"], {"answers": [{"question_id": "q1", "decision": "yes", "reasoning": "Because",
                                                          "citations": [], "missing_facts": [], "actions": []}]})
            self.assertEqual((p / "predictions.jsonl").read_bytes(), original)

    def complete(self, p, **overrides):
        items = read_jsonl(p / "reviewer/items.jsonl")
        for item in items:
            for rating in item["ratings"]:
                rating.update(legally_correct=True, severe_error=False)
                rating["scores"] = {name: 2 for name in ("legal_decision", "conditions", "exceptions", "legal_basis", "uncertainty")}
                for point in rating["required_points"]:
                    point.update(met=True, evidence="Evidence in the answer")
                rating.update(overrides)
        write_jsonl(p / "reviewer/items.jsonl", items)
        return import_reviews(p / "reviewer/items.jsonl", p / "private.json", "actual-reviewer")

    def test_severe_error_vetoes_correctness_without_changing_rubric(self):
        with tempfile.TemporaryDirectory() as td:
            p = Path(td)
            blind_export(p, p / "reviewer", p / "private.json", self.fixture(p))
            scored = self.complete(p, severe_error=True)[0]
            self.assertEqual(scored["score"], 0)
            self.assertTrue(scored["severe_error"])
            self.assertFalse(scored["questions"][0]["legally_correct"])
            self.assertEqual(scored["rubric_score"], 1)

    def test_unassigned_correctness_never_inferred_from_perfect_rubric(self):
        with tempfile.TemporaryDirectory() as td:
            p = Path(td)
            blind_export(p, p / "reviewer", p / "private.json", self.fixture(p))
            with self.assertRaises(ValueError):
                self.complete(p, legally_correct=None)

    def test_free_text_product_remains_verbatim_and_is_not_auto_scored(self):
        with tempfile.TemporaryDirectory() as td:
            p = Path(td)
            gold = self.fixture(p)
            records = read_jsonl(p / "predictions.jsonl")
            records[0]["prediction"] = {"text": "Insufficient facts; explain the exception.", "model": "PRIVATE_MODEL"}
            records[0]["product_capture"] = {"source_control": "PRIVATE_SOURCE_CONTROL", "product_version": "PRIVATE_PRODUCT_VERSION"}
            records[0]["raw_response_sha256"] = "f" * 64
            write_jsonl(p / "predictions.jsonl", records)
            blind_export(p, p / "reviewer", p / "private.json", gold)
            response = read_jsonl(p / "reviewer/items.jsonl")[0]["response"]
            self.assertEqual(response, {"text": "Insufficient facts; explain the exception."})
            bundle = (p / "reviewer/items.jsonl").read_text()
            self.assertNotIn("PRIVATE_SOURCE_CONTROL", bundle)
            self.assertNotIn("PRIVATE_PRODUCT_VERSION", bundle)
            self.assertNotIn("raw_response_sha256", bundle)
            self.assertIsNone(diagnostic_scores(p, gold)[0]["score"])
            result = self.complete(p)[0]
            self.assertEqual(result["score"], 1)
            self.assertEqual(result["product_capture"]["source_control"], "PRIVATE_SOURCE_CONTROL")
            self.assertEqual(result["raw_response_sha256"], "f" * 64)

    def test_unknown_is_valid_reviewable_response_and_can_be_correct(self):
        with tempfile.TemporaryDirectory() as td:
            p = Path(td)
            gold = self.fixture(p)
            records = read_jsonl(p / "predictions.jsonl")
            records[0]["prediction"]["answers"][0]["decision"] = "unknown"
            write_jsonl(p / "predictions.jsonl", records)
            blind_export(p, p / "reviewer", p / "private.json", gold)
            self.assertEqual(self.complete(p)[0]["score"], 1)

    def test_adjudication_is_pending_and_detects_question_disagreement(self):
        self.assertTrue(hasattr(evaluation, "adjudication_export"), "Missing human adjudication workflow")
        with tempfile.TemporaryDirectory() as td:
            p = Path(td)
            blind_export(p, p / "reviewer", p / "private.json", self.fixture(p))
            first = self.complete(p)
            second = copy.deepcopy(first)
            second[0]["reviewer"] = "second-actual-reviewer"
            second[0]["questions"][0]["dimensions"]["conditions"] = 1
            exported = evaluation.adjudication_export(first, second, p / "adjudication.json")
            self.assertEqual(exported["status"], "pending_adjudication")
            self.assertEqual(exported["n_disagreements"], 1)
            self.assertIsNone(exported["adjudicator"])
            self.assertIsNone(exported["disagreements"][0]["resolution"])

    def test_independent_evidence_wording_is_not_itself_a_rating_disagreement(self):
        with tempfile.TemporaryDirectory() as td:
            p = Path(td)
            blind_export(p, p / "reviewer", p / "private.json", self.fixture(p))
            first = self.complete(p)
            second = copy.deepcopy(first)
            second[0]["reviewer"] = "second-actual-reviewer"
            second[0]["questions"][0]["comment"] = "Separate reasoning in my own words"
            second[0]["questions"][0]["required_points"][0]["evidence"] = "Independent evidence wording"
            exported = evaluation.adjudication_export(first, second, p / "adjudication.json")
            self.assertEqual(exported["n_disagreements"], 0)
            self.assertEqual(exported["status"], "pending_human_signoff")

    def test_shared_extraction_and_configuration_provenance_survive_review_import(self):
        with tempfile.TemporaryDirectory() as td:
            p = Path(td)
            gold = self.fixture(p)
            rows = read_jsonl(p / "predictions.jsonl")
            rows[0].update(config_sha256="a" * 64, extraction_sha256="b" * 64, model_slot="registered-slot",
                           engine_scope_alignment={"status": "pending"})
            write_jsonl(p / "predictions.jsonl", rows)
            blind_export(p, p / "reviewer", p / "private.json", gold)
            result = self.complete(p)[0]
            self.assertEqual(result["config_sha256"], "a" * 64)
            self.assertEqual(result["extraction_sha256"], "b" * 64)
            self.assertEqual(result["model_slot"], "registered-slot")
            self.assertEqual(result["engine_scope_alignment"], {"status": "pending"})

    def test_blind_export_rejects_wrong_case_hash_and_duplicate_response_identity(self):
        for corruption in ("case_hash", "duplicate"):
            with self.subTest(corruption=corruption), tempfile.TemporaryDirectory() as td:
                p = Path(td)
                gold = self.fixture(p)
                rows = read_jsonl(p / "predictions.jsonl")
                if corruption == "case_hash":
                    rows[0]["case_sha256"] = "f" * 64
                else:
                    rows.append(copy.deepcopy(rows[0]))
                write_jsonl(p / "predictions.jsonl", rows)
                with self.assertRaises(ValueError):
                    blind_export(p, p / "reviewer", p / "private.json", gold)

    def test_one_wrong_complex_subquestion_fails_primary_without_zeroing_rubric(self):
        with tempfile.TemporaryDirectory() as td:
            p = Path(td)
            gold = self.fixture(p)
            cases = read_jsonl(p / "cases.snapshot.jsonl")
            records = read_jsonl(p / "predictions.jsonl")
            for question_id in ("q2", "q3", "q4", "q5"):
                cases[0]["questions"].append({"id": question_id, "prompt": "Another question?"})
                gold["F01"]["answers"].append(dict(gold["F01"]["answers"][0], question_id=question_id))
                records[0]["prediction"]["answers"].append(dict(records[0]["prediction"]["answers"][0], question_id=question_id))
            write_jsonl(p / "cases.snapshot.jsonl", cases)
            write_jsonl(p / "predictions.jsonl", records)
            blind_export(p, p / "reviewer", p / "private.json", gold)
            self.complete(p)
            items = read_jsonl(p / "reviewer/items.jsonl")
            items[0]["ratings"][4]["legally_correct"] = False
            write_jsonl(p / "reviewer/items.jsonl", items)
            result = import_reviews(p / "reviewer/items.jsonl", p / "private.json", "actual-reviewer")[0]
            self.assertEqual(result["score"], 0)
            self.assertEqual(result["rubric_score"], 1)


class AdjudicationTests(unittest.TestCase):
    """All identities/declarations here are synthetic test data, not real reviewers."""
    def fixture(self, p, *, disagree=True):
        helper = BlindTests()
        gold = helper.fixture(p)
        rows = read_jsonl(p / "predictions.jsonl")
        rows[0].update(case_sha256=digest_json(read_jsonl(p / "cases.snapshot.jsonl")[0]), law_sha256="a" * 64)
        write_jsonl(p / "predictions.jsonl", rows)
        blind_export(p, p / "reviewer", p / "private.json", gold)
        first = helper.complete(p)
        second = helper.complete(p, legally_correct=not disagree)
        second[0]["reviewer"] = "reviewer-two"
        template = evaluation.adjudication_export(first, second, p / "adjudication.json")
        roles = {name: {"id": identifier, "qualifications": "Synthetic qualified-reviewer declaration",
                        "independent_of_authorship": True, "conflicts": "None declared in fixture", "accepted_at": "2026-11-06"}
                 for name, identifier in (("reviewer_1", "actual-reviewer"), ("reviewer_2", "reviewer-two"),
                                          ("third_adjudicator", "reviewer-three"))}
        roles["third_adjudicator"]["independent_of_reviewers"] = True
        write_json(p / "roles.json", roles)
        return first, second, template

    def sign(self, p, template, *, choice="first"):
        template.update(status="completed", adjudicator="reviewer-three",
                        qualifications="Synthetic qualified-reviewer declaration",
                        independent_of_reviewers_and_authorship=True, signed_at="2026-11-06T12:00:00+00:00")
        for item in template["disagreements"]:
            item.update(resolution={"choice": choice}, rationale="Explicit third-reviewer rationale in fixture",
                        resolved_at="2026-11-06T12:00:00+00:00")
        write_json(p / "adjudication.json", template)

    def finalize(self, p, first, second):
        self.assertTrue(hasattr(evaluation, "finalize_adjudication"), "Missing actual human finalization workflow")
        return evaluation.finalize_adjudication(first, second, p / "adjudication.json", p / "roles.json")

    def test_explicit_third_review_finalizes_actual_decision_and_preserves_sources(self):
        with tempfile.TemporaryDirectory() as td:
            p = Path(td)
            first, second, template = self.fixture(p)
            original = copy.deepcopy((first, second))
            self.sign(p, template, choice="second")
            finalized = self.finalize(p, first, second)
            self.assertEqual(finalized[0]["score"], 0)
            self.assertEqual(finalized[0]["review_status"], "adjudicated")
            self.assertEqual(finalized[0]["review_evidence"]["reviewers"], ["actual-reviewer", "reviewer-two"])
            self.assertEqual(finalized[0]["review_evidence"]["adjudicator"], "reviewer-three")
            self.assertFalse(finalized[0]["review_evidence"]["declarations_independently_verified"])
            self.assertEqual((first, second), original)

    def test_pending_template_never_finalizes(self):
        with tempfile.TemporaryDirectory() as td:
            p = Path(td)
            first, second, _ = self.fixture(p)
            with self.assertRaises(ValueError):
                self.finalize(p, first, second)

    def test_custom_third_rating_recomputes_severe_veto(self):
        with tempfile.TemporaryDirectory() as td:
            p = Path(td)
            first, second, template = self.fixture(p)
            self.sign(p, template)
            ratings = read_jsonl(p / "reviewer/items.jsonl")[0]["ratings"]
            ratings[0].update(legally_correct=True, severe_error=True, errors=["wrong_legal_basis"],
                              comment="Material error identified by the third reviewer in fixture")
            template["disagreements"][0]["resolution"] = {"choice": "custom", "ratings": ratings}
            write_json(p / "adjudication.json", template)
            result = self.finalize(p, first, second)[0]
            self.assertEqual(result["score"], 0)
            self.assertTrue(result["severe_error"])
            self.assertEqual(result["rubric_score"], 1)

    def test_agreed_ratings_still_require_actual_signoff(self):
        with tempfile.TemporaryDirectory() as td:
            p = Path(td)
            first, second, template = self.fixture(p, disagree=False)
            with self.assertRaises(ValueError):
                self.finalize(p, first, second)
            self.sign(p, template)
            self.assertEqual(self.finalize(p, first, second)[0]["score"], 1)

    def test_missing_qualifications_identity_conflicts_and_immutable_tampering_rejected(self):
        for issue in ("qualification", "identity", "independence", "immutable", "unresolved"):
            with self.subTest(issue=issue), tempfile.TemporaryDirectory() as td:
                p = Path(td)
                first, second, template = self.fixture(p)
                self.sign(p, template)
                roles = json.loads((p / "roles.json").read_text())
                if issue == "qualification":
                    roles["reviewer_1"]["qualifications"] = ""
                elif issue == "identity":
                    roles["third_adjudicator"]["id"] = "actual-reviewer"
                elif issue == "independence":
                    roles["reviewer_2"]["independent_of_authorship"] = False
                elif issue == "immutable":
                    template["disagreements"][0]["first_rating"]["score"] = 0
                else:
                    template["disagreements"][0]["resolution"] = None
                write_json(p / "roles.json", roles)
                write_json(p / "adjudication.json", template)
                with self.assertRaises(ValueError):
                    self.finalize(p, first, second)


if __name__ == "__main__":
    unittest.main()
