"""Command-line entry point. All output paths are new, never silently overwritten."""
import argparse
import hashlib
import json
import os
from pathlib import Path
import sys
from .dataset import ROOT, digest_json, load_cases, load_gold, read_jsonl, sha256, write_json, write_jsonl
from .evaluation import blind_export, diagnostic_scores, import_reviews, summarize_scores
from .law import LawCorpus
from .prolog import PrologAdapter
from .providers import Provider
from .runner import ARMS, run_experiment
from .statistics import compare_scores, holm_adjust, rater_agreement
from .statistics import primary_accuracy_compare
from .analysis import hypotheses_report
from .economics import evaluate_economics, decision_report
from .products import export_product, import_product, PRODUCTS
from .matrix import evaluation_matrix, write_matrix


def emit(value):
    print(json.dumps(value, ensure_ascii=False, indent=2, allow_nan=False))


def new_output(path, value, lines=False):
    p = Path(path)
    if p.exists():
        raise FileExistsError(f"Output exists: {p}")
    p.parent.mkdir(parents=True, exist_ok=True)
    (write_jsonl if lines else write_json)(p, value)


def validate():
    cases, gold, law = load_cases(), load_gold(), LawCorpus(ROOT / "sources")
    freeze_path = ROOT / "data/freeze.json"
    if freeze_path.exists():
        for name, digest in json.loads(freeze_path.read_text())["sha256"].items():
            if sha256(ROOT / name) != digest:
                raise ValueError(f"Frozen artifact changed: {name}; deliberate re-freeze required")
    return {"status": "valid", "tasks": len(cases), "focused": sum(c["kind"] == "focused" for c in cases), "complex": sum(c["kind"] == "complex" for c in cases),
            "subquestions": sum(len(c["questions"]) for c in cases), "gold_status": "provisional", "independent_legal_reviews_completed": sum(g["independent_review"]["status"] == "approved" for g in gold.values()),
            "law_articles": len(law.articles), "freeze_present": freeze_path.exists()}


def check_run_gold(run):
    manifest_file = Path(run) / "manifest.json"
    if manifest_file.exists():
        manifest = json.loads(manifest_file.read_text())
        if manifest.get("gold_file_sha256") != sha256(ROOT / "data/gold.provisional.jsonl"):
            raise ValueError("Gold changed since run; use the pinned original release")
        if manifest.get("predictions_sha256") != sha256(Path(run) / "predictions.jsonl"):
            raise ValueError("Run predictions changed since completion")
    current = {c["id"]: c for c in load_cases()}
    for c in read_jsonl(Path(run) / "cases.snapshot.jsonl"):
        if c["id"] not in current or digest_json(c) != digest_json(current[c["id"]]):
            raise ValueError("Run cases differ from current gold corpus")
    law = LawCorpus(ROOT / 'sources')
    for row in read_jsonl(Path(run) / 'predictions.jsonl'):
        case = current[row['case_id']]
        if row.get('case_sha256') != digest_json(case):
            raise ValueError('Run prediction case hash differs from current corpus')
        expected = hashlib.sha256(law.select(case['law_articles']).encode()).hexdigest()
        if row.get('law_sha256') != expected:
            raise ValueError('Run law differs from the pinned legislation supplied to reviewers')


def main(argv=None):
    parser = argparse.ArgumentParser(description="GDPR Legal-AI benchmark: provisional gold, explicit blocked Prolog conditions")
    sub = parser.add_subparsers(dest="command", required=True)
    sub.add_parser("validate", help="Validate exact 30/20/10 inventory, gold, law and frozen hashes")
    p = sub.add_parser("demo-coverage", help="Exploratory demo mapping across 70 subquestions; not the study matrix")
    p.add_argument("--out", required=True)
    p = sub.add_parser("demo-run", help="Eight synthetic breach subquestions against an operator-configured private demo")
    p.add_argument("--out", required=True)
    p.add_argument("--base-url-env", default="GDPR_DEMO_BASE_URL")
    p.add_argument("--live", action="store_true")
    p.add_argument("--include-no-order-sensitivity", action="store_true", help="Also run an explicitly assumed no-authority-decision scenario")
    p = sub.add_parser("doctor", help="Local source/provider readiness; no network requests or credentials printed")
    p.add_argument("--models", default=str(ROOT / "config/models.example.json"))
    p.add_argument("--prolog-manifest")
    p = sub.add_parser("analyse", help="Human primary accuracy, H1-H4 and proposed targets for one model")
    p.add_argument("--scores", nargs="+", required=True)
    p.add_argument("--out", required=True)
    p = sub.add_parser("study-analyse", help="Registered multi-model study with conservative Holm adjustment")
    p.add_argument("--scores", nargs="+", required=True)
    p.add_argument("--study", default=str(ROOT / "config/study.json"))
    p.add_argument("--out", required=True)
    p = sub.add_parser("economics", help="Full-cost scenario, sensitivity and evidence-gated H5")
    p.add_argument("--config", default=str(ROOT / "config/economics.example.json"))
    p.add_argument("--out", required=True)
    p = sub.add_parser("decision", help="Combine study and economic evidence; unknown evidence stays inconclusive")
    p.add_argument("--analysis", required=True)
    p.add_argument("--economics", required=True)
    p.add_argument("--out", required=True)
    p = sub.add_parser("matrix", help="Export all registered model/product/condition/case cells")
    p.add_argument("--models", default=str(ROOT / "config/models.example.json"))
    p.add_argument("--prolog-manifest")
    p.add_argument("--runs", nargs="*", default=[])
    p.add_argument("--out", required=True)
    p = sub.add_parser("product-export", help="Create genuine manual product response capture templates")
    p.add_argument("--product", required=True, choices=PRODUCTS)
    p.add_argument("--out", required=True)
    p = sub.add_parser("product-import", help="Import real captured product answers, or retain blocked status")
    p.add_argument("export_dir")
    p.add_argument("responses_file")
    p.add_argument("--out", required=True)
    p = sub.add_parser("adjudication-export", help="Prepare disagreements for the third independent reviewer")
    p.add_argument("first")
    p.add_argument("second")
    p.add_argument("--out", required=True)
    p = sub.add_parser("adjudication-finalize", help="Validate actual human resolutions and recompute final scores")
    p.add_argument("first")
    p.add_argument("second")
    p.add_argument("--adjudication", required=True)
    p.add_argument("--roles", required=True)
    p.add_argument("--out", required=True)
    p = sub.add_parser("run", help="Run cases locally or explicitly enable paid model inference")
    p.add_argument("--out", required=True)
    p.add_argument("--arms", nargs="+", choices=ARMS, default=list(ARMS))
    p.add_argument("--models", default=str(ROOT / "config/models.example.json"))
    p.add_argument("--slot", default="openai")
    p.add_argument("--cases", nargs="+", help="Optional exact IDs, e.g. F01 C01")
    p.add_argument("--repeats", type=int, default=1)
    p.add_argument("--seed", type=int, default=17)
    p.add_argument("--live", action="store_true")
    p.add_argument("--budget-usd", type=float, default=0)
    p.add_argument("--prolog-manifest")
    p = sub.add_parser("score", help="Secondary exact-decision diagnostics against provisional labels")
    p.add_argument("run_dir")
    p.add_argument("--out", required=True)
    p = sub.add_parser("blind", help="Export anonymous reviewer bundle and separate private identity key")
    p.add_argument("run_dir")
    p.add_argument("--out", required=True)
    p.add_argument("--key", required=True)
    p = sub.add_parser("review-import", help="Validate completed independent human ratings; no automatic judge")
    p.add_argument("review_file")
    p.add_argument("--key", required=True)
    p.add_argument("--reviewer", required=True)
    p.add_argument("--out", required=True)
    p = sub.add_parser("compare", help="Paired statistics at case level, one model/run/rater per comparison")
    p.add_argument("--scores", nargs="+", required=True)
    p.add_argument("--a", default="llm_control")
    p.add_argument("--b", default="llm_prolog")
    p.add_argument("--failure-policy", choices=("exclude", "zero"), default="exclude")
    p.add_argument("--seed", type=int, default=17)
    p.add_argument("--metric", choices=("primary", "diagnostic"), default="primary")
    p.add_argument("--primary-repeat", type=int, default=0)
    p.add_argument("--out", required=True)
    p = sub.add_parser("holm", help="Adjust a prespecified family of p-values across model comparisons")
    p.add_argument("pvalues", nargs="+", type=float)
    p = sub.add_parser("agreement", help="Describe independent rater agreement before adjudication")
    p.add_argument("first")
    p.add_argument("second")
    p.add_argument("--out", required=True)
    p = sub.add_parser("gold-review-template", help="Export blank independent legal review checklist")
    p.add_argument("--out", required=True)
    args = parser.parse_args(argv)
    try:
        if args.command == "validate":
            emit(validate())
        elif args.command == "demo-coverage":
            from .demo import write_coverage
            validate()
            emit(write_coverage(args.out))
        elif args.command == "demo-run":
            from .demo import run_integration
            validate()
            base_url = os.environ.get(args.base_url_env)
            if not base_url:
                raise ValueError("Set the demo origin in the chosen environment variable; do not commit access details")
            result = run_integration(args.out, base_url, live=args.live, include_sensitivity=args.include_no_order_sensitivity)
            emit({k: result[k] for k in ("status", "selected_subquestions", "counts", "benchmark_eligible")})
            return 0 if result["status"] == "completed" else 3
        elif args.command == "doctor":
            config = json.loads(Path(args.models).read_text())
            emit({"dataset": validate(), "prolog": PrologAdapter(args.prolog_manifest).availability(),
                  "models": {name: {"provider": cfg["provider"], "model": cfg.get("model"), "status": "blocked" if Provider(cfg).availability() else "configured_unverified", "reason": Provider(cfg).availability()} for name, cfg in config["models"].items()}})
        elif args.command == "run":
            validate()
            config = json.loads(Path(args.models).read_text())["models"][args.slot]
            config = dict(config, slot=args.slot)
            cases = load_cases()
            if args.cases:
                if len(args.cases) != len(set(args.cases)) or set(args.cases) - {c["id"] for c in cases}:
                    raise ValueError("Unknown or duplicate case selection")
                cases = [c for c in cases if c["id"] in args.cases]
            result = run_experiment(args.out, cases, LawCorpus(ROOT / "sources"), args.arms, config=config, repeats=args.repeats,
                                    seed=args.seed, live=args.live, max_cost_usd=args.budget_usd, prolog=PrologAdapter(args.prolog_manifest))
            emit({k: result[k] for k in ("status", "counts", "actual_api_calls", "total_cost_usd")})
            return 0 if result["counts"]["blocked"] == result["counts"]["failed"] == 0 else 3
        elif args.command == "score":
            check_run_gold(args.run_dir)
            rows = diagnostic_scores(args.run_dir, load_gold())
            new_output(args.out, rows, lines=True)
            emit(summarize_scores(rows))
        elif args.command == "blind":
            check_run_gold(args.run_dir)
            emit(blind_export(args.run_dir, args.out, args.key, load_gold()))
        elif args.command == "review-import":
            rows = import_reviews(args.review_file, args.key, args.reviewer)
            new_output(args.out, rows, lines=True)
            emit(summarize_scores(rows))
        elif args.command == "compare":
            rows = [r for f in args.scores for r in read_jsonl(f)]
            if len({r.get("metric") for r in rows}) != 1:
                raise ValueError("Do not mix automatic diagnostics and human rubric scores")
            # Do not pool different LLMs or corpus versions into a single treatment contrast.
            llm_models = {(r.get("provider"), r.get("model")) for r in rows if r["arm"].startswith("llm")}
            if len(llm_models) > 1:
                raise ValueError("Select one exact model/provider for a paired comparison")
            for key in ("law_sha256", "case_sha256"):
                by_case = {}
                for r in rows:
                    if r.get(key):
                        by_case.setdefault(r["case_id"], set()).add(r[key])
                if any(len(values) > 1 for values in by_case.values()):
                    raise ValueError("Case or law mismatch across compared conditions")
            result = (primary_accuracy_compare(rows, args.a, args.b, args.primary_repeat) if args.metric == "primary"
                      else compare_scores(rows, args.a, args.b, failure_policy=args.failure_policy, seed=args.seed))
            result["metric"] = rows[0].get("metric") if rows else None
            new_output(args.out, result)
            emit(result)
        elif args.command == "holm":
            emit({"raw": args.pvalues, "holm_adjusted": holm_adjust(args.pvalues)})
        elif args.command == "agreement":
            result = rater_agreement(read_jsonl(args.first), read_jsonl(args.second))
            new_output(args.out, result)
            emit(result)
        elif args.command == "gold-review-template":
            rows = [{"case_id": cid, "gold_sha256": digest_json(g), "review_status": "pending", "reviewer": None, "qualifications": None, "independent_of_authorship": None,
                     "reviewed_at": None, "questions": [{"question_id": a["question_id"], "facts_checked": None, "law_checked": None, "conclusion_checked": None,
                      "alternatives_checked": None, "rubric_checked": None, "correction": ""} for a in g["answers"]]} for cid, g in load_gold().items()]
            new_output(args.out, rows, lines=True)
            emit({"status": "pending", "tasks": len(rows)})
        elif args.command in {"analyse", "study-analyse"}:
            rows = [r for f in args.scores for r in read_jsonl(f)]
            if args.command == "study-analyse":
                from .study import analyse_study
                result = analyse_study(rows, load_cases(), json.loads(Path(args.study).read_text()))
            else:
                result = hypotheses_report(rows, load_cases())
            result['input_provenance'] = {'score_files': [{'path': str(Path(f)), 'sha256': sha256(f)} for f in args.scores],
                                          'cases_sha256': sha256(ROOT / 'data/cases.jsonl')}
            if args.command == 'study-analyse':
                result['input_provenance']['study_file'] = {'path': str(Path(args.study)), 'sha256': sha256(args.study)}
                result['study_registration'] = json.loads(Path(args.study).read_text())
            new_output(args.out, result)
            emit({"status": result["status"], "report": args.out, "final_review_complete": result.get("final_review_complete", False)})
        elif args.command == "economics":
            result = evaluate_economics(json.loads(Path(args.config).read_text()))
            result['input_file'] = {'path': str(Path(args.config)), 'sha256': sha256(args.config)}
            new_output(args.out, result)
            emit(result)
        elif args.command == "decision":
            result = decision_report(json.loads(Path(args.analysis).read_text()), json.loads(Path(args.economics).read_text()))
            result['input_provenance'] = {name:{'path': path,'sha256':sha256(path)} for name,path in
                                          (('analysis',args.analysis),('economics',args.economics))}
            new_output(args.out, result)
            emit(result)
        elif args.command == "matrix":
            rows = evaluation_matrix(load_cases(), json.loads(Path(args.models).read_text()), LawCorpus(ROOT / "sources"),
                                     prolog=PrologAdapter(args.prolog_manifest), run_dirs=args.runs)
            emit(write_matrix(args.out, rows))
        elif args.command == "product-export":
            emit(export_product(args.out, args.product, load_cases(), LawCorpus(ROOT / "sources")))
        elif args.command == "product-import":
            emit(import_product(args.export_dir, args.responses_file, args.out, load_cases()))
        elif args.command == "adjudication-export":
            from .evaluation import adjudication_export
            emit(adjudication_export(read_jsonl(args.first), read_jsonl(args.second), args.out))
        elif args.command == "adjudication-finalize":
            from .evaluation import finalize_adjudication
            rows = finalize_adjudication(read_jsonl(args.first), read_jsonl(args.second), args.adjudication, args.roles)
            new_output(args.out, rows, lines=True)
            emit(summarize_scores(rows))
        return 0
    except (ValueError, KeyError, OSError, TypeError) as error:
        print(f"ERROR: {error}", file=sys.stderr)
        return 2


if __name__ == "__main__":
    sys.exit(main())
