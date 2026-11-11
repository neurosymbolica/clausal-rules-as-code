"""Minimal official REST adapters. Live compatibility is not asserted by mocks."""
from datetime import date
import json
import math
import os
import time
import urllib.error
import urllib.parse
import urllib.request
from .dataset import strict_json

ENV_KEYS = {"openai": ("OPENAI_API_KEY",), "anthropic": ("ANTHROPIC_API_KEY",), "gemini": ("GEMINI_API_KEY", "GOOGLE_API_KEY"), "openai_compatible": ("OPENAI_COMPATIBLE_API_KEY",)}
UNKNOWN_USAGE = {"input_tokens": None, "output_tokens": None, "cached_input_tokens": None, "cache_write_input_tokens": None}


def compatible_base(config):
    base = config.get("base_url", "")
    parsed = urllib.parse.urlsplit(base)
    local = parsed.hostname in {"localhost", "127.0.0.1", "::1"}
    if not parsed.hostname or parsed.username or parsed.password or parsed.query or parsed.fragment or (parsed.scheme != "https" and not (parsed.scheme == "http" and local)):
        raise ValueError("Set a credential-free HTTPS base_url, or HTTP loopback endpoint")
    return base.rstrip("/"), local


def key_names(config):
    custom = config.get("api_key_env")
    if custom is not None:
        if not isinstance(custom, str) or not custom.replace("_", "").isalnum() or not custom.endswith("_API_KEY"):
            raise ValueError("api_key_env must name a *_API_KEY environment variable")
        return (custom,)
    return ENV_KEYS[config["provider"]]


def build_request(config, system, prompt, key):
    provider, model = config["provider"], config.get("model")
    if provider not in ENV_KEYS or not isinstance(model, str) or not model.strip():
        raise ValueError("Configure provider and an exact accessible model ID")
    limit = config.get("max_output_tokens", 4096)
    if type(limit) is not int or limit <= 0:
        raise ValueError("Positive max_output_tokens required")
    temp = config.get("temperature")
    if temp is not None and (type(temp) not in (int, float) or not math.isfinite(temp) or not 0 <= temp <= 2):
        raise ValueError("Invalid temperature")
    options = config.get("request_options", {})
    allowed = {"openai": {"reasoning_effort"}, "anthropic": set(), "gemini": set(), "openai_compatible": {"reasoning_effort", "thinking", "chat_template_kwargs", "top_p", "top_k", "presence_penalty"}}[provider]
    if not isinstance(options, dict) or set(options) - allowed:
        raise ValueError("Unsupported request_options; invariant payload fields cannot be overridden")
    headers = {"Content-Type": "application/json"}
    if provider in {"openai", "openai_compatible"}:
        url = "https://api.openai.com/v1/chat/completions" if provider == "openai" else compatible_base(config)[0] + "/chat/completions"
        if key:
            headers["Authorization"] = "Bearer " + key
        token_field = "max_completion_tokens" if provider == "openai" else config.get("token_limit_field", "max_tokens")
        if token_field not in {"max_tokens", "max_completion_tokens"}:
            raise ValueError("Unsupported token_limit_field")
        body = {"model": model, "messages": [{"role": "system", "content": system}, {"role": "user", "content": prompt}],
                token_field: limit, **options}
        if config.get("json_mode", True):
            body["response_format"] = {"type": "json_object"}
        if temp is not None:
            body["temperature"] = temp
    elif provider == "anthropic":
        url = "https://api.anthropic.com/v1/messages"
        headers.update({"x-api-key": key, "anthropic-version": config.get("api_version", "2023-06-01")})
        body = {"model": model, "system": system, "messages": [{"role": "user", "content": prompt}], "max_tokens": limit}
        if temp is not None:
            body["temperature"] = temp
    else:
        url = "https://generativelanguage.googleapis.com/v1beta/models/" + urllib.parse.quote(model.removeprefix("models/"), safe="") + ":generateContent"
        headers["x-goog-api-key"] = key
        generation = {"maxOutputTokens": limit, "responseMimeType": "application/json"}
        if temp is not None:
            generation["temperature"] = temp
        body = {"systemInstruction": {"parts": [{"text": system}]}, "contents": [{"role": "user", "parts": [{"text": prompt}]}], "generationConfig": generation}
    return url, headers, body


def normalize_response(provider, raw):
    usage, text, stop, model = dict(UNKNOWN_USAGE), "", None, None
    try:
        if provider in {"openai", "openai_compatible"}:
            choice = raw.get("choices", [{}])[0]
            text = choice.get("message", {}).get("content") or ""
            stop, model = choice.get("finish_reason"), raw.get("model")
            u = raw.get("usage")
            if u:
                usage = {"input_tokens": u.get("prompt_tokens"), "output_tokens": u.get("completion_tokens"),
                         "cached_input_tokens": (u.get("prompt_tokens_details") or {}).get("cached_tokens", u.get("prompt_cache_hit_tokens", 0)), "cache_write_input_tokens": 0}
            complete = stop == "stop"
        elif provider == "anthropic":
            text = "".join(p.get("text", "") for p in raw.get("content", []) if p.get("type") == "text")
            stop, model = raw.get("stop_reason"), raw.get("model")
            u = raw.get("usage")
            if u:
                cached, written = u.get("cache_read_input_tokens", 0), u.get("cache_creation_input_tokens", 0)
                inputs = u.get("input_tokens")
                total = inputs + cached + written if all(type(n) is int for n in (inputs, cached, written)) else None
                usage = {"input_tokens": total, "output_tokens": u.get("output_tokens"), "cached_input_tokens": cached, "cache_write_input_tokens": written}
            complete = stop == "end_turn"
        elif provider == "gemini":
            c = raw.get("candidates", [{}])[0]
            text = "".join(p.get("text", "") for p in c.get("content", {}).get("parts", []) if not p.get("thought", False))
            stop, model = c.get("finishReason"), raw.get("modelVersion")
            u = raw.get("usageMetadata")
            if u:
                outputs, thoughts = u.get("candidatesTokenCount"), u.get("thoughtsTokenCount", 0)
                usage = {"input_tokens": u.get("promptTokenCount"), "output_tokens": outputs + thoughts if type(outputs) is int and type(thoughts) is int else None,
                         "cached_input_tokens": u.get("cachedContentTokenCount", 0), "cache_write_input_tokens": 0}
            complete = stop == "STOP"
        else:
            raise ValueError("Unsupported provider")
    except (KeyError, TypeError, IndexError, AttributeError):
        complete = False
    return {"status": "ok" if complete and isinstance(text, str) and text else "failed", "text": text, "finish_reason": stop,
            "provider_model": model, "usage": usage, "raw": raw}


def price_usage(usage, pricing):
    """USD estimate, not invoice. Missing or contradictory counters remain unknown."""
    n, o, c, w = (usage.get(k) for k in ("input_tokens", "output_tokens", "cached_input_tokens", "cache_write_input_tokens"))
    if not all(type(x) is int and x >= 0 for x in (n, o, c, w)) or c + w > n:
        return None
    required = ["input_per_million", "output_per_million"] + (["cached_input_per_million"] if c else []) + (["cache_write_per_million"] if w else [])
    if any(type(pricing.get(k)) not in (int, float) or not math.isfinite(pricing[k]) or pricing[k] < 0 for k in required):
        return None
    cost = ((n - c - w) * pricing["input_per_million"] + o * pricing["output_per_million"] + c * pricing.get("cached_input_per_million", 0) + w * pricing.get("cache_write_per_million", 0)) / 1_000_000
    return round(cost, 10)


def reservation_usd(config, system, prompt):
    pricing = config.get("pricing", {})
    if not pricing.get("source_url") or not pricing.get("checked_at") or not pricing.get("valid_until"):
        raise ValueError("Document current pricing source/date/valid_until before paid calls")
    checked, valid = date.fromisoformat(pricing["checked_at"]), date.fromisoformat(pricing["valid_until"])
    if checked > date.today() or valid < date.today() or valid < checked:
        raise ValueError("Pricing is future-dated or expired")
    for k in ("input_per_million", "output_per_million", "cached_input_per_million", "cache_write_per_million"):
        v = pricing.get(k)
        if type(v) not in (int, float) or not math.isfinite(v) or v < 0:
            raise ValueError(f"Set nonnegative finite price {k}; use zero only when actually uncharged")
    # Conservative reservation, not a provider-enforced billing cap. The operator
    # must set provider account limits. No retries or external paid tools are used.
    max_inputs = len((system + prompt).encode("utf-8")) + 4096
    if pricing.get("max_input_tokens_at_price") is not None and max_inputs > pricing["max_input_tokens_at_price"]:
        raise ValueError("Prompt exceeds configured pricing tier; update rates/tier explicitly")
    input_rate = max(pricing[k] for k in ("input_per_million", "cached_input_per_million", "cache_write_per_million"))
    return (max_inputs * input_rate + config.get("max_output_tokens", 4096) * pricing["output_per_million"]) / 1_000_000


class Provider:
    def __init__(self, config, transport=None):
        self.config = config
        self.transport = transport or self._http

    def availability(self):
        p = self.config.get("provider")
        if p not in ENV_KEYS or not self.config.get("model"):
            return "Configure an exact provider/model ID"
        try:
            local = compatible_base(self.config)[1] if p == "openai_compatible" else False
            names = key_names(self.config)
        except ValueError:
            return "Invalid compatible endpoint or API-key environment-variable configuration"
        if not local and not any(os.environ.get(k) for k in names):
            return "API key absent from process environment"
        return None

    @staticmethod
    def _http(url, headers, body):
        request = urllib.request.Request(url, headers=headers, data=json.dumps(body).encode(), method="POST")
        # Refuse redirects so credential-bearing requests never follow another host.
        class NoRedirect(urllib.request.HTTPRedirectHandler):
            def redirect_request(self, *args, **kwargs):
                return None
        with urllib.request.build_opener(NoRedirect).open(request, timeout=90) as response:
            return strict_json(response.read())

    def generate(self, system, prompt):
        why = self.availability()
        if why:
            return {"status": "blocked", "reason": why, "usage": dict(UNKNOWN_USAGE), "cost_usd": None, "latency_seconds": 0}
        provider = self.config["provider"]
        key = next((os.environ[k] for k in key_names(self.config) if os.environ.get(k)), "")
        url, headers, body = build_request(self.config, system, prompt, key)
        start = time.monotonic()
        try:
            raw = self.transport(url, headers, body)
            # Injected transports must obey the same finite JSON contract as HTTP.
            json.dumps(raw, allow_nan=False)
            result = normalize_response(provider, raw)
            result["cost_usd"] = price_usage(result["usage"], self.config.get("pricing", {}))
        except urllib.error.HTTPError as error:
            result = {"status": "failed", "reason": f"Provider HTTP {error.code}; no automatic retry", "usage": dict(UNKNOWN_USAGE), "cost_usd": None}
        except (urllib.error.URLError, TimeoutError, OSError, ValueError):
            result = {"status": "failed", "reason": "Provider transport or JSON decoding failure; billing unknown", "usage": dict(UNKNOWN_USAGE), "cost_usd": None}
        result["latency_seconds"] = round(time.monotonic() - start, 6)
        return result
