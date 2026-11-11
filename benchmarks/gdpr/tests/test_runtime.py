import copy
import json
import tempfile
import unittest
from pathlib import Path

from gdpr_bench.dataset import load_cases, load_gold, validate_response
from gdpr_bench.law import LawCorpus
from gdpr_bench.prolog import PrologAdapter
from gdpr_bench.prompts import build_prompt

ROOT = Path(__file__).resolve().parents[1]


class RuntimeTests(unittest.TestCase):
    def test_corpus_is_gdpr_and_all_99_articles_present(self):
        law = LawCorpus(ROOT / "sources")
        self.assertEqual(len(law.articles), 99)
        self.assertIn("personal data breach", law.select([33]))
        self.assertNotIn("framework agreement", law.select([33]).lower())

    def test_source_tamper_is_rejected(self):
        import shutil
        with tempfile.TemporaryDirectory() as td:
            path = Path(td) / "sources"
            shutil.copytree(ROOT / "sources", path)
            (path / "articles.json").write_text("{}")
            with self.assertRaises(ValueError):
                LawCorpus(path)

    def test_prompt_never_contains_normalized_facts_or_gold(self):
        case = {"id": "F99", "title": "Example", "scenario": "Situation", "questions": [
            {"id": "q1", "prompt": "Question?", "rule": "SECRET_RULE", "facts": {"SECRET": True}}
        ], "scope": {"included": ["GDPR"], "excluded": []}}
        prompt = build_prompt(case, "LAW")
        self.assertNotIn("SECRET", prompt)
        self.assertIn("LAW", prompt)

    def test_prolog_unconfigured_is_blocked_and_has_no_answers(self):
        result = PrologAdapter().run({"id": "F01", "questions": []})
        self.assertEqual(result["status"], "blocked")
        self.assertNotIn("answers", result)

    def test_prolog_unreviewed_manifest_is_blocked(self):
        with tempfile.TemporaryDirectory() as td:
            p = Path(td) / "manifest.json"
            p.write_text(json.dumps({"legal_regime": "GDPR", "review_status": "pending"}))
            self.assertEqual(PrologAdapter(p).availability()["status"], "blocked")

    def test_response_missing_duplicate_and_extra_answers_rejected(self):
        case = {"questions": [{"id": "q1"}, {"id": "q2"}]}
        a = {"question_id": "q1", "decision": "yes", "reasoning": "Because", "citations": [], "missing_facts": [], "actions": []}
        for answers in [[], [a, a], [a, dict(a, question_id="q3")]]:
            with self.subTest(answers=answers), self.assertRaises(ValueError):
                validate_response({"answers": answers}, case)

    def test_response_unknown_is_legitimate_but_not_missing_answer(self):
        case = {"questions": [{"id": "q1"}]}
        a = {"question_id": "q1", "decision": "unknown", "reasoning": "Facts missing", "citations": [], "missing_facts": ["risk"], "actions": []}
        self.assertEqual(validate_response({"answers": [a]}, case)["answers"][0]["decision"], "unknown")


if __name__ == "__main__":
    unittest.main()
