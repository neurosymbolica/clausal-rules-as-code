"""Immutable randomized runs; matched treatments share one extracted fact set."""
from datetime import datetime, timezone
import copy
import hashlib
import json
import math
from pathlib import Path
import platform
import random
import time
from .dataset import ROOT, digest_json, sha256, validate_response, write_json, write_jsonl, strict_json
from .fact_schema import validate_fact
from .prolog import PrologAdapter
from .prompts import SYSTEM, EXTRACTION_SYSTEM, build_prompt, controlled_prompt
from .providers import Provider, reservation_usd
from .rules import answer_case

ARMS = ("llm_text", "llm_control", "llm_python", "llm_prolog", "python_rules", "prolog_oracle")
CONTROLLED = {"llm_control", "llm_python", "llm_prolog"}


def extraction_prompt(case, law_text):
    schemas = [{"id": q["id"], "rule": q["rule"], "facts": {k: None for k in q["facts"]}} for q in case["questions"]]
    schema_help = (ROOT / "data/RULE_INPUTS.md").read_text(encoding="utf-8")
    return ('Extract facts only from the case. Return JSON {"questions":[...]} using this template. Unknown=null. '
            'Keep all IDs, rule names and fact keys; never fill missing facts by guessing.\n' + json.dumps(schemas, ensure_ascii=False)
            + '\nField definitions:\n' + schema_help + '\n' + build_prompt(case, law_text))


def validate_extraction(questions, case):
    expected = {q["id"]: q for q in case["questions"]}
    if (not isinstance(questions, list) or len(questions) != len(expected)
            or any(not isinstance(q, dict) or not isinstance(q.get("id"), str) for q in questions)
            or {q["id"] for q in questions} != set(expected)):
        raise ValueError("Invalid extracted question collection")
    canonical = []
    for q in questions:
        original = expected[q["id"]]
        if q.get("rule") != original["rule"] or not isinstance(q.get("facts"), dict) or set(q["facts"]) != set(original["facts"]):
            raise ValueError("Extracted fact schema mismatch")
        for name, value in q["facts"].items():
            validate_fact(name, value)
        canonical.append({"id":q["id"], "rule":q["rule"], "facts":q["facts"]})
    return sorted(canonical, key=lambda q:q["id"])


def run_experiment(output, cases, law, arms, *, config=None, repeats=1, seed=17, live=False, max_cost_usd=0,
                   prolog=None, provider=None):
    if not arms or len(arms) != len(set(arms)) or set(arms) - set(ARMS):
        raise ValueError("Choose unique known arms")
    if type(repeats) is not int or not 1 <= repeats <= 100:
        raise ValueError("repeats must be 1..100")
    if not cases or len({c["id"] for c in cases}) != len(cases):
        raise ValueError("Nonempty unique case set required")
    if type(max_cost_usd) not in (float, int) or not math.isfinite(max_cost_usd) or max_cost_usd < 0:
        raise ValueError("Invalid budget")
    if live and max_cost_usd <= 0:
        raise ValueError("Paid mode requires an explicit positive budget")
    config = config or {}
    public_config = {k:config[k] for k in ("slot","provider","model","label","base_url","api_key_env","token_limit_field","json_mode","max_output_tokens","temperature","request_options","api_version","pricing") if k in config}
    prolog, provider = prolog or PrologAdapter(), provider or Provider(config)
    output = Path(output)
    output.mkdir(parents=True, exist_ok=False)
    rng = random.Random(seed)
    blocks = [(c["id"], rep) for rep in range(repeats) for c in cases]
    rng.shuffle(blocks)
    schedule = []
    for cid, rep in blocks:
        order = list(arms)
        rng.shuffle(order)
        schedule.extend({"case_id":cid,"repeat":rep,"arm":arm} for arm in order)
    write_json(output / "schedule.json", schedule)
    write_jsonl(output / "cases.snapshot.jsonl", cases)
    manifest = {"schema_version":2,"release":"2.0.0","created_at":datetime.now(timezone.utc).isoformat(),"status":"running","seed":seed,
                "repeats":repeats,"primary_repeat":0,"arms":arms,"case_count":len(cases),"config":public_config,"live":live,
                "max_cost_usd":max_cost_usd,"python":platform.python_version(),"platform":platform.platform(),
                "case_snapshot_sha256":sha256(output / "cases.snapshot.jsonl"),"law_manifest":law.manifest,
                "code_sha256":{p.name:sha256(p) for p in sorted((ROOT / "gdpr_bench").glob("*.py"))},
                "config_sha256":digest_json(public_config),"rule_input_sha256":sha256(ROOT / "data/RULE_INPUTS.md"),
                "gold_used_for_inference":False,"gold_file_sha256":sha256(ROOT / "data/gold.provisional.jsonl"),"prolog_availability":prolog.availability(),
                "controlled_design":"One shared extraction per case/repeat; identical final template and SYSTEM; only engine-evidence slot differs.",
                "cost_semantics":"row cost_usd attributes full extraction cost to each standalone arm; billed_cost_usd and manifest total count a shared request once",
                "statistical_status":"exploratory; provisional gold; human evaluation pending"}
    write_json(output / "manifest.json", manifest)
    by_id, extraction_cache = {c["id"]:c for c in cases}, {}
    spent, billing_unknown, calls_count = 0.0, False, 0
    rows, metered_calls = [], []

    def call(system, prompt):
        nonlocal spent, billing_unknown, calls_count
        if billing_unknown:
            return {"status":"blocked","reason":"Prior request cost unknown; further paid requests stopped"}
        why = provider.availability()
        if why:
            return {"status":"blocked","reason":why}
        try:
            reserve = reservation_usd(config, system, prompt)
        except (ValueError, TypeError):
            return {"status":"blocked","reason":"Current pricing/configuration required before paid inference"}
        if spent + reserve > max_cost_usd:
            return {"status":"blocked","reason":"Conservative reservation exceeds remaining budget","reservation_usd":reserve}
        result = provider.generate(system, prompt)
        if result["status"] != "blocked":
            calls_count += 1
            result["call_id"] = f"api-{calls_count:05d}"
            result["reused"] = False
            metered_calls.append(result)
            if result.get("cost_usd") is None:
                billing_unknown = True
            else:
                spent += result["cost_usd"]
        result["request"] = {"system":system,"prompt":prompt}
        result["reservation_usd"] = reserve
        return result

    with (output / "predictions.jsonl").open("w", encoding="utf-8") as handle:
        for number, item in enumerate(schedule):
            c, arm = by_id[item["case_id"]], item["arm"]
            law_text = law.select(c["law_articles"])
            row = dict(item,record_id=f"r{number:05d}",model=config.get("model") if arm.startswith("llm") else None,
                       model_slot=config.get("slot") if arm.startswith("llm") else None,
                       provider=config.get("provider") if arm.startswith("llm") else None,case_sha256=digest_json(c),
                       law_sha256=hashlib.sha256(law_text.encode()).hexdigest(),config_sha256=digest_json(public_config),calls=[])
            alignment = prolog.availability(c).get("python_equivalence_review", {})
            if (alignment.get("status") == "approved" and alignment.get("reviewer") and alignment.get("reviewed_at")
                    and alignment.get("python_rules_sha256") == sha256(ROOT / "gdpr_bench/rules.py")
                    and alignment.get("case_dataset_sha256") == sha256(ROOT / "data/cases.jsonl")):
                row["engine_scope_alignment"] = dict(alignment, case_sha256=digest_json(c))
            else:
                row["engine_scope_alignment"] = {"status":"pending", "reason":"Reviewed Python/Prolog scope equivalence for this code and corpus not established"}
            start = time.monotonic()
            try:
                if arm == "python_rules":
                    row.update(status="ok",prediction=validate_response(answer_case(c),c))
                elif arm in {"prolog_oracle","llm_prolog"} and prolog.availability(c)["status"] != "ready":
                    row.update(prolog.availability(c))
                elif arm == "prolog_oracle":
                    row.update(prolog.run(c))
                elif not live:
                    row.update(status="blocked",reason="Live inference disabled; configure model/key/prices and enable --live with budget")
                else:
                    final_prompt = build_prompt(c,law_text)
                    if arm in CONTROLLED:
                        cache_key = (c["id"],item["repeat"])
                        reused = cache_key in extraction_cache
                        if not reused:
                            extraction_cache[cache_key] = call(EXTRACTION_SYSTEM,extraction_prompt(c,law_text))
                        extracted_call = copy.deepcopy(extraction_cache[cache_key])
                        extracted_call["reused"] = reused
                        row["calls"].append(extracted_call)
                        if extracted_call["status"] != "ok":
                            row.update(status=extracted_call["status"],reason=extracted_call.get("reason","Fact extraction incomplete"))
                        else:
                            raw_extraction = strict_json(extracted_call["text"])
                            questions = validate_extraction(raw_extraction.get("questions") if isinstance(raw_extraction,dict) else None,c)
                            row["extraction_sha256"] = digest_json(questions)
                            row["extracted_questions"] = questions
                            if arm == "llm_control":
                                evidence = {"status":"not_used","prediction":None}
                            elif arm == "llm_python":
                                evidence = {"status":"ok","prediction":validate_response(answer_case({"questions":questions}),c)}
                            else:
                                evidence = prolog.run(c,extracted_questions=questions)
                            row["engine_result"] = evidence
                            if arm != "llm_control" and evidence["status"] != "ok":
                                row.update(status=evidence["status"],reason=evidence.get("reason","Engine declined evaluation"))
                            final_prompt = controlled_prompt(c,law_text,questions,{k:evidence[k] for k in ("status","prediction") if k in evidence})
                    if "status" not in row:
                        generated = call(SYSTEM,final_prompt)
                        row["calls"].append(generated)
                        row["final_prompt_sha256"] = hashlib.sha256(final_prompt.encode()).hexdigest()
                        if generated["status"] != "ok":
                            row.update(status=generated["status"],reason=generated.get("reason","Generation incomplete or refused"))
                        else:
                            row.update(status="ok",prediction=validate_response(strict_json(generated["text"]),c))
            except (ValueError,TypeError,KeyError,OSError,AttributeError) as exc:
                row.update(status="failed",reason=f"Invalid response or input ({type(exc).__name__}); request evidence retained")
            active = [request for request in row["calls"] if request["status"] != "blocked"]
            resolved = sorted({r['provider_model'] for r in active if isinstance(r.get('provider_model'),str) and r['provider_model']})
            row['resolved_models'] = resolved
            row['resolved_model'] = resolved[0] if len(resolved)==1 else None
            if len(resolved)>1:
                row.update(status='failed',reason='Provider reported different model revisions within the controlled pipeline')
                row.pop('prediction',None)
            billed = [request for request in active if not request.get("reused")]
            def total(requests):
                return None if any(r.get("cost_usd") is None for r in requests) else round(sum(r["cost_usd"] for r in requests),10)
            row["cost_usd"],row["billed_cost_usd"] = total(active),total(billed)
            row["latency_seconds"] = round(time.monotonic()-start,6)
            row["attributed_api_latency_seconds"] = sum(r.get("latency_seconds",0) for r in active)
            handle.write(json.dumps(row,ensure_ascii=False,allow_nan=False)+"\n")
            handle.flush()
            rows.append(row)
    statuses = {status:sum(r["status"]==status for r in rows) for status in ("ok","blocked","failed")}
    usage = {}
    for metric in ("input_tokens","output_tokens","cached_input_tokens","cache_write_input_tokens"):
        values = [r.get("usage",{}).get(metric) for r in metered_calls]
        usage[metric] = sum(values) if all(type(v) is int for v in values) else None
    manifest.update(status="completed" if statuses["blocked"]==statuses["failed"]==0 else "completed_with_unavailable_results",
                    completed_at=datetime.now(timezone.utc).isoformat(),counts=statuses,actual_api_calls=calls_count,
                    known_cost_usd=round(spent,10),total_cost_usd=None if billing_unknown else round(spent,10),token_usage=usage,
                    billing_unknown=billing_unknown,predictions_sha256=sha256(output / "predictions.jsonl"))
    write_json(output / "manifest.json",manifest)
    return manifest
