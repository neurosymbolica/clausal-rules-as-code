import json
from pathlib import Path
import tempfile
import unittest
from gdpr_bench.runner import run_experiment
from gdpr_bench.law import LawCorpus
from gdpr_bench.dataset import read_jsonl

ROOT = Path(__file__).resolve().parents[1]
CASE = {"id": "F01", "kind": "focused", "title": "Test", "scenario": "An EU company.", "scope": {}, "law_articles": [3],
        "questions": [{"id": "q1", "prompt": "In scope?", "rule": "territorial_scope", "facts": {"eu_establishment_context": True}}]}


class RunnerTests(unittest.TestCase):
    def test_every_blocked_slot_retained_without_fake_answers(self):
        with tempfile.TemporaryDirectory() as td:
            p = Path(td) / "run"
            run_experiment(p, [CASE], LawCorpus(ROOT / "sources"), ["python_rules", "prolog_oracle", "llm_prolog", "llm_text"], repeats=2)
            rows = read_jsonl(p / "predictions.jsonl")
            self.assertEqual(len(rows), 8)
            self.assertEqual(sum(r["status"] == "ok" for r in rows), 2)
            self.assertTrue(all("prediction" not in r for r in rows if r["status"] == "blocked"))
            self.assertEqual(len({r["law_sha256"] for r in rows}), 1)
            with self.assertRaises(FileExistsError):
                run_experiment(p, [CASE], LawCorpus(ROOT / "sources"), ["python_rules"])

    def test_schedule_reproducible(self):
        with tempfile.TemporaryDirectory() as td:
            for name in ("a", "b"):
                run_experiment(Path(td) / name, [CASE], LawCorpus(ROOT / "sources"), ["python_rules", "prolog_oracle"], repeats=3, seed=91)
            self.assertEqual(json.loads((Path(td) / "a/schedule.json").read_text()), json.loads((Path(td) / "b/schedule.json").read_text()))

    def test_invalid_arms_fail_before_directory_creation(self):
        with tempfile.TemporaryDirectory() as td:
            p = Path(td) / "run"
            with self.assertRaises(ValueError):
                run_experiment(p, [CASE], LawCorpus(ROOT / "sources"), ["fake"])
            self.assertFalse(p.exists())


if __name__ == "__main__":
    unittest.main()
