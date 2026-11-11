import unittest
from gdpr_bench.providers import build_request, normalize_response, price_usage, reservation_usd, Provider


class ProviderTests(unittest.TestCase):
    def config(self, provider):
        return {"provider": provider, "model": "fixture-model", "max_output_tokens": 300, "temperature": None}

    def test_all_three_payloads_use_requested_model_and_no_key_in_body(self):
        for p in ("openai", "anthropic", "gemini"):
            url, headers, body = build_request(self.config(p), "SYSTEM", "PROMPT", "secret-fixture")
            self.assertNotIn("secret-fixture", str(body))
            self.assertNotIn("secret-fixture", url)
            self.assertIn("fixture-model", str(body) + url)
            self.assertIn("PROMPT", str(body))

    def test_openai_cache_is_not_double_counted(self):
        r = normalize_response("openai", {"model": "x", "choices": [{"finish_reason": "stop", "message": {"content": "{}"}}], "usage": {"prompt_tokens": 100, "completion_tokens": 20, "prompt_tokens_details": {"cached_tokens": 40}}})
        self.assertEqual(r["usage"]["input_tokens"], 100)
        self.assertAlmostEqual(price_usage(r["usage"], {"input_per_million": 10, "output_per_million": 20, "cached_input_per_million": 1}), .00104)

    def test_anthropic_cache_tokens_added_to_input(self):
        r = normalize_response("anthropic", {"content": [{"type": "text", "text": "{}"}], "stop_reason": "end_turn", "usage": {"input_tokens": 10, "cache_read_input_tokens": 30, "cache_creation_input_tokens": 20, "output_tokens": 5}})
        self.assertEqual(r["usage"]["input_tokens"], 60)
        self.assertIsNone(price_usage(r["usage"], {"input_per_million": 1, "output_per_million": 1}))

    def test_gemini_thoughts_counted_not_shown(self):
        r = normalize_response("gemini", {"candidates": [{"finishReason": "STOP", "content": {"parts": [{"text": "internal", "thought": True}, {"text": "{}"}]}}], "usageMetadata": {"promptTokenCount": 10, "candidatesTokenCount": 4, "thoughtsTokenCount": 9}})
        self.assertEqual(r["text"], "{}")
        self.assertEqual(r["usage"]["output_tokens"], 13)

    def test_missing_usage_unknown_not_zero(self):
        r = normalize_response("openai", {"choices": [{"finish_reason": "stop", "message": {"content": "{}"}}]})
        self.assertIsNone(r["usage"]["input_tokens"])
        self.assertIsNone(price_usage(r["usage"], {"input_per_million": 1, "output_per_million": 1}))

    def test_truncation_is_not_ok(self):
        r = normalize_response("anthropic", {"content": [{"type": "text", "text": "{"}], "stop_reason": "max_tokens", "usage": {"input_tokens": 10, "output_tokens": 300}})
        self.assertEqual(r["status"], "failed")
        self.assertEqual(r["usage"]["output_tokens"], 300)

    def test_invalid_prices_and_options_rejected(self):
        with self.assertRaises(ValueError):
            reservation_usd(self.config("openai"), "s", "p")
        config = self.config("openai") | {"request_options": {"messages": []}}
        with self.assertRaises(ValueError):
            build_request(config, "s", "p", "k")

    def test_invalid_counts_cannot_produce_negative_cost(self):
        usage = {"input_tokens": 2, "output_tokens": 1, "cached_input_tokens": 3, "cache_write_input_tokens": 0}
        self.assertIsNone(price_usage(usage, {"input_per_million": 1, "output_per_million": 1, "cached_input_per_million": 1}))


if __name__ == "__main__":
    unittest.main()
