"""Transport fixtures exercise paid-path logic WITHOUT calling any external API."""
from datetime import date, timedelta
import json
import os
from pathlib import Path
import subprocess
import tempfile
from types import SimpleNamespace
import unittest
from unittest.mock import patch
from gdpr_bench.dataset import read_jsonl
from gdpr_bench.law import LawCorpus
from gdpr_bench.prolog import PrologAdapter
from gdpr_bench.providers import Provider
from gdpr_bench.runner import run_experiment

ROOT = Path(__file__).resolve().parents[1]
CASE = {"id": "F01", "kind": "focused", "title": "Fixture", "scenario": "EU company", "scope": {}, "law_articles": [3],
        "questions": [{"id": "q1", "prompt": "In scope?", "rule": "territorial_scope", "facts": {"eu_establishment_context": True}}]}
ANSWER = {"answers": [{"question_id": "q1", "decision": "yes", "reasoning": "EU establishment", "citations": ["GDPR Art. 3(1)"], "missing_facts": [], "actions": []}]}


def config():
    return {"provider": "openai", "model": "fixture-not-a-real-model", "max_output_tokens": 100,
            "pricing": {"input_per_million": 1, "output_per_million": 2, "cached_input_per_million": 1, "cache_write_per_million": 1,
                        "source_url": "https://example.invalid/fixture", "checked_at": str(date.today()), "valid_until": str(date.today() + timedelta(days=1))}}


class LiveContractTests(unittest.TestCase):
    def test_real_adapter_to_runner_injected_transport_logs_usage(self):
        cfg = config()
        captured = []
        def transport(url, headers, body):
            captured.append(body)
            return {"model": "fixture-snapshot", "choices": [{"finish_reason": "stop", "message": {"content": json.dumps(ANSWER)}}], "usage": {"prompt_tokens": 50, "completion_tokens": 20}}
        with tempfile.TemporaryDirectory() as td, patch.dict(os.environ, {"OPENAI_API_KEY": "test-only-key"}):
            path = Path(td) / "run"
            m = run_experiment(path, [CASE], LawCorpus(ROOT / "sources"), ["llm_text"], config=cfg, live=True, max_cost_usd=1, provider=Provider(cfg, transport))
            row = read_jsonl(path / "predictions.jsonl")[0]
            self.assertEqual(m["actual_api_calls"], 1)
            self.assertEqual(row["prediction"], ANSWER)
            self.assertEqual(row["calls"][0]["usage"]["input_tokens"], 50)
            self.assertNotIn("test-only-key", (path / "predictions.jsonl").read_text())

    def test_unknown_billing_stops_subsequent_requests(self):
        cfg = config()
        def transport(*args):
            return {"choices": [{"finish_reason": "stop", "message": {"content": json.dumps(ANSWER)}}]}
        with tempfile.TemporaryDirectory() as td, patch.dict(os.environ, {"OPENAI_API_KEY": "test-only-key"}):
            m = run_experiment(Path(td) / "run", [CASE], LawCorpus(ROOT / "sources"), ["llm_text"], repeats=3, config=cfg, live=True, max_cost_usd=1, provider=Provider(cfg, transport))
            self.assertEqual(m["actual_api_calls"], 1)
            self.assertTrue(m["billing_unknown"])
            self.assertIsNone(m["total_cost_usd"])
            self.assertEqual(m["counts"]["blocked"], 2)

    def test_reservation_blocks_before_transport(self):
        cfg = config()
        def transport(*args):
            raise AssertionError("Network should not be called")
        with tempfile.TemporaryDirectory() as td, patch.dict(os.environ, {"OPENAI_API_KEY": "test-only-key"}):
            m = run_experiment(Path(td) / "run", [CASE], LawCorpus(ROOT / "sources"), ["llm_text"], config=cfg, live=True, max_cost_usd=.00000001, provider=Provider(cfg, transport))
            self.assertEqual(m["actual_api_calls"], 0)
            self.assertEqual(m["counts"]["blocked"], 1)

    def test_invalid_json_is_failed_but_usage_not_lost(self):
        cfg = config()
        def transport(*args):
            return {"choices": [{"finish_reason": "stop", "message": {"content": "not JSON"}}], "usage": {"prompt_tokens": 50, "completion_tokens": 20}}
        with tempfile.TemporaryDirectory() as td, patch.dict(os.environ, {"OPENAI_API_KEY": "test-only-key"}):
            m = run_experiment(Path(td) / "run", [CASE], LawCorpus(ROOT / "sources"), ["llm_text"], config=cfg, live=True, max_cost_usd=1, provider=Provider(cfg, transport))
            self.assertEqual(m["counts"]["failed"], 1)
            self.assertGreater(m["total_cost_usd"], 0)

    def test_malformed_prolog_input_keeps_paid_failed_row_and_continues(self):
        cfg = config()
        extracted_question = {"id": "q1", "rule": "territorial_scope", "facts": {"eu_establishment_context": True}}
        malformed_inputs = [
            ("null collection", None, None),
            ("object collection", {"q1": extracted_question}, None),
            ("string element", ["q1"], None),
            ("array bridge result", [extracted_question], "[]"),
        ]
        for label, questions, bridge_stdout in malformed_inputs:
            with self.subTest(label=label), tempfile.TemporaryDirectory() as td:
                def transport(url, headers, body):
                    extraction = body["messages"][0]["content"].startswith("Extract")
                    answer = {"questions": questions} if extraction else ANSWER
                    return {"choices": [{"finish_reason": "stop", "message": {"content": json.dumps(answer)}}],
                            "usage": {"prompt_tokens": 50, "completion_tokens": 20}}

                def bridge(*args, **kwargs):
                    if bridge_stdout is None:
                        self.fail("Invalid extraction reached the bridge")
                    return subprocess.CompletedProcess(args[0], 0, stdout=bridge_stdout, stderr="")

                prolog = PrologAdapter(Path(td) / "manifest.json")
                prolog.manifest = {"command": ["/test-bridge"]}
                path = Path(td) / "run"
                with (patch.dict(os.environ, {"OPENAI_API_KEY": "test-only-key"}),
                      patch.object(prolog, "availability", return_value={"status": "ready"}),
                      patch("gdpr_bench.prolog.subprocess", SimpleNamespace(run=bridge, TimeoutExpired=subprocess.TimeoutExpired))):
                    manifest = run_experiment(path, [CASE], LawCorpus(ROOT / "sources"), ["llm_prolog", "llm_text"],
                                              config=cfg, seed=0, live=True, max_cost_usd=1,
                                              prolog=prolog, provider=Provider(cfg, transport))

                failed, succeeding = read_jsonl(path / "predictions.jsonl")
                self.assertEqual((failed["arm"], failed["status"]), ("llm_prolog", "failed"))
                self.assertNotIn("prediction", failed)
                self.assertEqual(failed["cost_usd"], .00009)
                self.assertEqual(len(failed["calls"]), 1)
                self.assertEqual((succeeding["arm"], succeeding["status"]), ("llm_text", "ok"))
                self.assertEqual(succeeding["prediction"], ANSWER)
                self.assertEqual(manifest["status"], "completed_with_unavailable_results")
                self.assertEqual(manifest["actual_api_calls"], 2)
                self.assertEqual(manifest["total_cost_usd"], .00018)

    def test_model_prediction_keeps_identity_metadata_only_in_private_call(self):
        cfg = config()
        model_answer = {"model": "PRIVATE_MODEL", "answers": [dict(ANSWER["answers"][0], provider="PRIVATE_PROVIDER")]}
        raw = {"choices": [{"finish_reason": "stop", "message": {"content": json.dumps(model_answer)}}],
               "usage": {"prompt_tokens": 50, "completion_tokens": 20}}
        with tempfile.TemporaryDirectory() as td, patch.dict(os.environ, {"OPENAI_API_KEY": "test-only-key"}):
            path = Path(td) / "run"
            run_experiment(path, [CASE], LawCorpus(ROOT / "sources"), ["llm_text"], config=cfg, live=True,
                           max_cost_usd=1, provider=Provider(cfg, lambda *args: raw))
            row = read_jsonl(path / "predictions.jsonl")[0]
            self.assertEqual(row["status"], "ok")
            self.assertEqual(row["prediction"], ANSWER)
            self.assertEqual(row["calls"][0]["raw"], raw)


if __name__ == "__main__":
    unittest.main()
