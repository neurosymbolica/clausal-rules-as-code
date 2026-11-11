"""Prespecified model-family analysis without pooling models or product results.

Numerical estimates may precede final adjudication. The separate review gate
records whether the declared final-review prerequisites have been met; it does
not authenticate reviewer identities or establish commercial validity.
"""
import copy
import math
from collections import Counter
from statistics import mean

from .analysis import hypotheses_report
from .dataset import digest_json
from .statistics import _finalized_review, holm_adjust

MODEL_ARMS = {"llm_text", "llm_control", "llm_python", "llm_prolog"}
REVIEW_ROLES = ("gdpr_reviewer_1", "gdpr_reviewer_2", "third_adjudicator", "independent_analyst")


def _nonempty(value):
    return isinstance(value, str) and bool(value.strip())


def _human(row):
    return (row.get("metric") == "human_accuracy" and row.get("status") == "ok"
            and row.get("score") is not None and type(row.get("severe_error")) is bool)


def _validate_human(row, cases):
    if row.get("metric") != "human_accuracy":
        return
    if not _nonempty(row.get("record_id")):
        raise ValueError("Human observations require a record_id")
    for field in ("case_sha256", "law_sha256"):
        value = row.get(field)
        if not isinstance(value, str) or len(value) != 64 or any(c not in "0123456789abcdef" for c in value):
            raise ValueError(f"Missing or corrupt {field} provenance")
    if row["case_sha256"] != digest_json(cases[row["case_id"]]):
        raise ValueError("Human rating case provenance differs from the supplied corpus")
    score = row.get("score")
    if score is not None:
        if row.get("status") != "ok" or type(score) not in (bool, int, float) or score not in (0, 1):
            raise ValueError("Human case-level accuracy must be binary on an ok row")
        if score == 1 and row.get("severe_error") is True:
            raise ValueError("A severe error vetoes case-level correctness")


def _partition(rows, cases, slots, products):
    models = {slot: [] for slot in slots}
    captures = {product: [] for product in products}
    seen, ignored = set(), Counter()
    for row in rows:
        arm = row.get("arm")
        if arm in {"python_rules", "prolog_oracle"}:
            ignored[arm] += 1
            continue
        if arm in MODEL_ARMS:
            group = row.get("model_slot")
            if group not in models:
                raise ValueError("Model observation has an unregistered or absent model_slot")
            destination = models[group]
        elif isinstance(arm, str) and arm.startswith("product:"):
            group = arm.split(":", 1)[1]
            if group not in captures:
                raise ValueError("Unregistered product observation")
            destination = captures[group]
        else:
            raise ValueError("Unknown study arm")
        if row.get("case_id") not in cases:
            raise ValueError("Observation refers to an unregistered case")
        if type(row.get("repeat")) is not int or row["repeat"] < 0:
            raise ValueError("A nonnegative integer repeat is required")
        cell = (group, arm, row["case_id"], row["repeat"])
        if cell in seen:
            raise ValueError("Duplicate model/product, arm, case and repeat cell; resolve reviewers/runs first")
        seen.add(cell)
        _validate_human(row, cases)
        if arm in MODEL_ARMS and row.get("metric") == "human_accuracy" and row.get("score") is not None:
            if not all(_nonempty(row.get(key)) for key in ("provider", "model")):
                raise ValueError("Human model outcomes require explicit provider and model identity")
        destination.append(row)
    for slot, cohort in models.items():
        for field in ("provider", "model", "resolved_model", "config_sha256"):
            values = {r[field] for r in cohort if r.get(field) is not None}
            if len(values) > 1:
                raise ValueError(f"Mixed {field} inside registered model slot {slot}")
    # Corpus and law contexts must match across the registered model comparisons.
    # A different model-specific configuration hash is expected across slots.
    human = [r for cohort in models.values() for r in cohort if r.get("metric") == "human_accuracy"]
    for field in ("corpus_sha256", "case_snapshot_sha256", "gold_sha256"):
        supplied = {r[field] for r in human if r.get(field) is not None}
        if len(supplied) > 1:
            raise ValueError(f"Mixed {field} across model observations")
    laws = {}
    for row in human:
        previous = laws.setdefault(row["case_id"], row["law_sha256"])
        if previous != row["law_sha256"]:
            raise ValueError("Model observations for a case have mismatched law_sha256")
    return models, captures, dict(ignored)


def _coverage(rows, case_ids, repeat):
    selected = [r for r in rows if r["repeat"] == repeat]
    reviewed = [r for r in selected if _human(r)]
    complete = len(case_ids) == 30 and {r["case_id"] for r in reviewed} == case_ids
    finalized = bool(reviewed) and all(_finalized_review(r) for r in reviewed)
    statuses = Counter("unreviewed" if r.get("status") == "ok" and not _human(r)
                       else r.get("status", "unknown") for r in selected)
    missing = len(case_ids - {r["case_id"] for r in selected})
    return {"status": "ok" if complete else "not_evaluable", "complete": complete,
            "planned_case_count": 30, "supplied_corpus_case_count": len(case_ids),
            "submitted_cases": len(selected), "missing_cases": missing,
            "completed_outputs": sum(r.get("status") == "ok" for r in selected),
            "human_reviewed_cases": len(reviewed),
            "adjudicated_cases": sum(_finalized_review(r) for r in reviewed),
            "human_review_finalized": finalized,
            "accuracy": mean(r["score"] for r in reviewed) if reviewed else None,
            "availability": dict(statuses)}, reviewed


def _best_baseline(models, slots, anchor, cases, repeat, treatment):
    summaries, baseline_rows = {}, []
    for slot in slots:
        summaries[slot], reviewed = _coverage([r for r in models[slot] if r["arm"] == "llm_text"], cases, repeat)
        baseline_rows.extend(reviewed)
    candidate, candidate_rows = _coverage([r for r in models[anchor] if r["arm"] == treatment], cases, repeat)
    complete = (candidate["complete"] and candidate["human_review_finalized"]
                and all(s["complete"] and s["human_review_finalized"] for s in summaries.values()))
    result = {"status": "ok" if complete else "not_evaluable", "arm": "llm_text", "primary_repeat": repeat,
              "classification": "descriptive_selection_aware", "baselines": summaries,
              "candidate": {"model_slot": anchor, "arm": treatment, **candidate},
              "best_model_slots": [], "best_accuracy": None, "accuracy_delta": None,
              "p_one_sided_exact": None,
              "interpretation": "Best baseline is selected from all six observed single-pass accuracies; this selected comparison is descriptive, not a causal or unadjusted significance test"}
    if complete:
        best = max(s["accuracy"] for s in summaries.values())
        result.update(best_accuracy=best, best_model_slots=[slot for slot in slots if summaries[slot]["accuracy"] == best],
                      accuracy_delta=candidate["accuracy"] - best)
    else:
        result["reason"] = "All 30 repeat-0 human case outcomes with finalized signed review evidence are required for the anchor treatment and each of all six registered single-pass baselines"
    target = {"status": ("pass" if result["accuracy_delta"] >= .05 else "fail") if complete else "not_evaluable",
              "observed": result["accuracy_delta"], "threshold": .05, "operator": ">=",
              "threshold_status": "proposed_not_validated", "classification": "descriptive_selection_aware"}
    if not complete:
        target["reason"] = result["reason"]
    return result, target, baseline_rows + candidate_rows


def _product_summary(rows, cases, repeat):
    result, reviewed = _coverage(rows, cases, repeat)
    captures = [r for r in rows if r["repeat"] == repeat and r.get("status") == "ok"]
    source_control = Counter((r.get("product_capture") or {}).get("source_control", r.get("source_control", "unknown")) or "unknown"
                             for r in captures)
    versions = sorted({r["model"] for r in captures if _nonempty(r.get("model"))})
    if len(versions) > 1:
        result.update(status="not_evaluable", complete=False, accuracy=None,
                      reason="Mixed product versions are not pooled into a product accuracy")
    result.update(classification="descriptive_product_observations", source_control_counts=dict(source_control),
                  product_versions=versions, causal_comparison_supported=False,
                  p_one_sided_exact=None,
                  limitations=["Commercial product observations never enter the model-family H1 tests or selected best-model baseline",
                               "Controlled supplied inputs do not control undisclosed retrieval, system prompts, model versions or internal tools",
                               "Absent source-control metadata remains unknown; uncontrolled inputs limit comparability",
                               "Accuracy is descriptive over available human-reviewed cases; completion is reported separately"])
    return result


def analyse_study(rows, cases, study):
    """Analyse all six registered model slots, preserving the anchor's targets.

    Missing H1 tests use p=1 only inside the six-test Holm calculation; their
    published raw and adjusted p values remain null. No product or diagnostic
    oracle observations are pooled into a model hypothesis.
    """
    rows = list(rows)
    case_list = list(cases.values()) if isinstance(cases, dict) else list(cases)
    case_map = {c["id"]: c for c in case_list}
    if len(case_map) != len(case_list):
        raise ValueError("Unique corpus cases required")
    slots = study.get("model_slots")
    if not isinstance(slots, list) or len(slots) != 6 or not all(_nonempty(s) for s in slots) or len(set(slots)) != 6:
        raise ValueError("Exactly six distinct prespecified model slots are required")
    anchor, repeat = study.get("primary_model_slot"), study.get("primary_repeat", 0)
    control, treatment = study.get("primary_control", "llm_control"), study.get("primary_treatment", "llm_prolog")
    if anchor not in slots or type(repeat) is not int or repeat != 0:
        raise ValueError("A registered anchor and prespecified repeat 0 are required")
    if (control, treatment) != ("llm_control", "llm_prolog") or study.get("tasks", 30) != 30:
        raise ValueError("The registered 30-case control/Prolog study is required")
    alpha = study.get("alpha", .05)
    if type(alpha) not in (int, float) or not math.isfinite(alpha) or not 0 < alpha < 1:
        raise ValueError("A finite alpha between zero and one is required")
    products = study.get("product_candidates", [])
    if not isinstance(products, list) or not all(_nonempty(p) for p in products) or len(set(products)) != len(products):
        raise ValueError("Unique registered product candidates required")
    models, captures, ignored = _partition(rows, case_map, slots, products)
    reports = {slot: hypotheses_report(models[slot], case_list, control=control, treatment=treatment, primary_repeat=repeat)
               for slot in slots}
    raw = [reports[slot]["hypotheses"]["H1"]["p_one_sided_exact"] for slot in slots]
    inputs = [p if p is not None else 1.0 for p in raw]
    adjusted = holm_adjust(inputs)
    tests = {slot: {"p_raw": p, "p_holm": adj if p is not None else None,
                    "adjustment_input": value, "status": "available" if p is not None else "not_evaluable",
                    "n_cases": reports[slot]["hypotheses"]["H1"]["n_cases"]}
             for slot, p, adj, value in zip(slots, raw, adjusted, inputs)}
    anchor_report = reports[anchor]
    targets = copy.deepcopy(anchor_report["targets"])
    best, targets["best_llm_accuracy_improvement"], baseline_rows = _best_baseline(models, slots, anchor, set(case_map), repeat, treatment)
    anchor_h1 = anchor_report["hypotheses"]["H1"]
    anchor_complete = len(case_map) == 30 and anchor_h1["n_cases"] == 30 and anchor_h1["human_review_finalized"]
    used_h1 = [row for slot in slots for row in models[slot]
               if row["repeat"] == repeat and row["arm"] in {control, treatment}
               and row["case_id"] in reports[slot]["hypotheses"]["H1"]["paired_case_ids"]]
    all_used_h1_finalized = bool(used_h1) and all(_finalized_review(row) for row in used_h1)
    p_holm = tests[anchor]["p_holm"]
    targets["primary_significance"].update(
        observed=p_holm, raw_p=tests[anchor]["p_raw"], threshold=alpha,
        status=("pass" if p_holm < alpha else "fail") if anchor_complete and all_used_h1_finalized and p_holm is not None else "not_evaluable",
        multiplicity="Holm-adjusted across all six prespecified H1 tests; unavailable tests enter adjustment as 1")
    if targets["primary_significance"]["status"] == "not_evaluable":
        targets["primary_significance"]["reason"] = "Complete anchor H1 and finalized signed review evidence for every used model-family H1 row are required"
    role_values = [(study.get("review_roles") or {}).get(role) for role in REVIEW_ROLES]
    roles_valid = all(_nonempty(value) for value in role_values) and len({" ".join(v.split()).casefold() for v in role_values}) == 4
    gate = {"anchor_h1_complete": anchor_complete,
            "all_six_baselines_and_anchor_treatment_complete": best["status"] == "ok",
            "all_used_h1_and_baseline_rows_adjudicated": bool(used_h1 and baseline_rows) and
                all(_finalized_review(r) for r in used_h1 + baseline_rows),
            "independent_legal_review_approved": study.get("independent_legal_review_status") == "approved",
            "four_distinct_nonempty_review_roles": roles_valid,
            "preregistration_registered": study.get("preregistration_status") == "registered"}
    return {"status": anchor_report["status"], "metric": "human_accuracy", "primary_repeat": repeat,
            "primary_model_slot": anchor, "model_reports": reports, "anchor_report": anchor_report,
            "targets": targets, "best_single_pass_baseline": best,
            "multiplicity": {"method": "Holm", "family_size": 6, "alpha": alpha, "tests": tests,
                             "missing_test_policy": "Use 1 for conservative adjustment only; report missing raw and adjusted p values as null"},
            "products": {name: _product_summary(cohort, set(case_map), repeat) for name, cohort in captures.items()},
            "ignored_diagnostic_rows": ignored, "final_review_complete": all(gate.values()), "review_gate": gate,
            "limitations": ["Models are separate cohorts; their cases are never pooled to increase the sample size",
                            "The selected best baseline comparison is descriptive and selection-aware",
                            "Final-review declarations are recorded, not independently authenticated",
                            "The 30-case purposive pilot does not establish general superiority or commercial demand"]}
