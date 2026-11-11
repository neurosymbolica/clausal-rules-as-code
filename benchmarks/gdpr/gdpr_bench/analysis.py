"""Prespecified human-outcome hypotheses for the 30-case GDPR pilot.

Automated reference matching never becomes a human outcome. Secondary analyses
retain cases as clusters, including when a case contains five tagged questions.
"""
import itertools
import math
import random
from statistics import mean

from .dataset import digest_json
from .statistics import _binary_comparison, _human_pairs, paired_statistics, primary_accuracy_compare, quantile


def _complexity(pairs, cases, *, seed=17, samples=20000):
    groups = {kind: [b["score"] - a["score"] for cid, a, b in pairs if cases[cid]["kind"] == kind]
              for kind in ("focused", "complex")}
    focused, complex_ = groups["focused"], groups["complex"]
    result = {"status": "not_evaluable", "n_cases": len(focused) + len(complex_),
              "focused": {"n_cases": len(focused), "accuracy_delta": mean(focused) if focused else None},
              "complex": {"n_cases": len(complex_), "accuracy_delta": mean(complex_) if complex_ else None},
              "effect_difference_complex_minus_focused": None, "p_two_sided": None,
              "bootstrap_percentile_95ci": None, "classification": "secondary_exploratory",
              "assumption": "Case treatment effects must be exchangeable across complexity groups under the null; complexity was not randomized"}
    if not focused or not complex_:
        result["reason"] = "Both complexity groups need paired human outcomes"
        return result
    observed = mean(complex_) - mean(focused)
    result["effect_difference_complex_minus_focused"] = observed
    if min(len(focused), len(complex_)) < 2:
        result["reason"] = "At least two paired cases in each complexity group needed for uncertainty analysis"
        return result
    values = focused + complex_
    n, nc = len(values), len(complex_)
    rng = random.Random(seed)
    def contrast(indices):
        subtotal = sum(values[i] for i in indices)
        return subtotal / nc - (sum(values) - subtotal) / (n - nc)
    assignments = math.comb(n, nc)
    if assignments <= 100000:
        count = sum(abs(contrast(indices)) >= abs(observed) - 1e-12 for indices in itertools.combinations(range(n), nc))
        p = count / assignments
        method = "exact case-level permutation of complexity labels on paired treatment effects"
    else:
        count = sum(abs(contrast(rng.sample(range(n), nc))) >= abs(observed) - 1e-12 for _ in range(samples))
        p = (count + 1) / (samples + 1)
        method = f"Monte Carlo case-level permutation of complexity labels; {samples} samples; plus-one correction"
    boot = [mean(rng.choices(complex_, k=nc)) - mean(rng.choices(focused, k=len(focused))) for _ in range(samples)]
    result.update(status="ok", p_two_sided=p, method=method, seed=seed,
                  bootstrap_percentile_95ci=[quantile(boot, .025), quantile(boot, .975)],
                  bootstrap_unit="whole case, stratified by complexity")
    return result


def _severe_errors(pairs):
    rated = [(cid, a, b) for cid, a, b in pairs if type(a.get("severe_error")) is bool and type(b.get("severe_error")) is bool]
    result = _binary_comparison([int(not a["severe_error"]) for _, a, _ in rated],
                                [int(not b["severe_error"]) for _, _, b in rated])
    result.update(classification="secondary_exploratory", method="one-sided exact McNemar; H1: treatment has fewer severe errors",
                  paired_case_ids=[cid for cid, _, _ in rated], excluded_missing_severe_labels=len(pairs) - len(rated),
                  severe_error_rate_a=None, severe_error_rate_b=None,
                  absolute_severe_error_reduction=None, relative_severe_error_reduction=None)
    if rated:
        a_rate, b_rate = mean(a["severe_error"] for _, a, _ in rated), mean(b["severe_error"] for _, _, b in rated)
        result.update(severe_error_rate_a=a_rate, severe_error_rate_b=b_rate,
                      absolute_severe_error_reduction=a_rate - b_rate,
                      relative_severe_error_reduction=(a_rate - b_rate) / a_rate if a_rate else None)
        if not a_rate:
            result["relative_reduction_status"] = "not_evaluable_zero_baseline"
    # These are freedom-from-severe-error outcomes, not overall legal accuracy.
    result["outcome"] = "case has no severe legal error in any subquestion"
    return result


def _tagged_subgroup(pairs, cases, tag):
    planned = {cid: {q["id"] for q in case["questions"] if tag in q.get("evaluation_tags", [])}
               for cid, case in cases.items()}
    planned = {cid: questions for cid, questions in planned.items() if questions}
    a_values, b_values, included, n_questions = [], [], [], 0
    for cid, a, b in pairs:
        if cid not in planned:
            continue
        arm_values = []
        for row in (a, b):
            questions = row.get("questions", [])
            index = {q["question_id"]: q for q in questions}
            if len(index) != len(questions):
                raise ValueError("Duplicate question ratings in a case")
            values = []
            for qid in sorted(planned[cid]):
                question = index.get(qid, {})
                if type(question.get("legally_correct")) is not bool or type(question.get("severe_error")) is not bool:
                    break
                value = question["legally_correct"] and not question["severe_error"]
                if tag == "missing_information":
                    uncertainty = question.get("dimensions", {}).get("uncertainty")
                    if type(uncertainty) is not int or uncertainty not in (0, 1, 2):
                        break
                    value = value and uncertainty == 2
                values.append(int(value))
            arm_values.append(mean(values) if len(values) == len(planned[cid]) else None)
        if all(value is not None for value in arm_values):
            a_values.append(arm_values[0])
            b_values.append(arm_values[1])
            included.append(cid)
            n_questions += len(planned[cid])
    result = {"status": "not_evaluable", "classification": "secondary_exploratory", "tag": tag,
              "n_cases": len(included), "n_questions": n_questions, "planned_cases": len(planned),
              "planned_questions": sum(map(len, planned.values())), "paired_case_ids": included,
              "accuracy_a": mean(a_values) if a_values else None, "accuracy_b": mean(b_values) if b_values else None,
              "accuracy_delta": mean(y - x for x, y in zip(a_values, b_values)) if a_values else None,
              "bootstrap_percentile_95ci": None, "p_two_sided": None,
              "unit": "mean tagged-question accuracy within each case, then equal case weight",
              "criterion": "human question correctness with severe-error veto" +
                           (" and uncertainty dimension = 2" if tag == "missing_information" else "")}
    if len(included) >= 2:
        stats = paired_statistics(a_values, b_values)
        result.update(status="ok", bootstrap_percentile_95ci=stats["bootstrap_percentile_95ci"],
                      p_two_sided=stats["permutation_p_two_sided"], method=stats["permutation_method"])
    else:
        result["reason"] = "At least two case clusters with complete tagged human question ratings required"
    return result


def _target(observed, threshold, *, covered, less_than=False, reason="Complete planned human review and explicit two-reviewer/adjudicator finalization required"):
    status = "not_evaluable"
    if observed is not None and covered:
        status = "pass" if (observed < threshold if less_than else observed >= threshold) else "fail"
    result = {"status": status, "observed": observed, "threshold": threshold,
              "operator": "<" if less_than else ">=", "threshold_status": "proposed_not_validated"}
    if status == "not_evaluable":
        result["reason"] = reason
    return result


def hypotheses_report(rows, cases, control="llm_control", treatment="llm_prolog", python_arm="llm_python", primary_repeat=0):
    """Report H1–H4, case-clustered subgroups and proposed decision targets.

    H5 full economics is supplied by the separate economics module. Numerical
    results are estimates, never certification of reviewer qualification.
    """
    rows = list(rows)
    case_list = list(cases.values()) if isinstance(cases, dict) else list(cases)
    cases = {case["id"]: case for case in case_list}
    if len(cases) != len(case_list) or any(c.get("kind") not in {"focused", "complex"} for c in case_list):
        raise ValueError("Unique cases and focused/complex classification required")
    for row in rows:
        if row.get("metric") == "human_accuracy" and row.get("arm") in {control, treatment, python_arm}:
            if row.get("case_id") not in cases or row.get("case_sha256") != digest_json(cases[row["case_id"]]):
                raise ValueError("Human rating case provenance does not match the supplied frozen corpus")
    h1 = primary_accuracy_compare(rows, control, treatment, primary_repeat)
    _, pairs, _, _ = _human_pairs(rows, control, treatment, primary_repeat)
    h2, h3 = _complexity(pairs, cases), _severe_errors(pairs)
    h4 = primary_accuracy_compare(rows, python_arm, treatment, primary_repeat)
    _, engine_pairs, _, _ = _human_pairs(rows, python_arm, treatment, primary_repeat)
    aligned = bool(engine_pairs)
    for _, a, b in engine_pairs:
        for row in (a, b):
            review = row.get("engine_scope_alignment") or {}
            aligned = aligned and review.get("status") == "approved" and review.get("case_sha256") == row["case_sha256"]
            aligned = aligned and all(isinstance(review.get(field), str) and review[field].strip()
                                      for field in ("reviewer", "reviewed_at"))
    if not aligned:
        h4 = {**h4, "descriptive_contrast": h4, "status": "not_evaluable", "p_one_sided_exact": None,
              "reason": "Reviewed Python/Prolog scope-equivalence evidence for these case hashes is absent or incomplete"}
    h4.update(classification="secondary_exploratory",
              engine_scope_alignment_status="approved" if aligned else "pending",
              interpretation="Python versus Prolog requires matched formal rule coverage; a programming-language superiority claim is not identified")
    subgroups = {tag: _tagged_subgroup(pairs, cases, tag) for tag in ("exception_boundary", "missing_information")}
    full_corpus = len(cases) == 30 and h1["n_cases"] == len(cases) and h1["human_review_finalized"]
    targets = {
        "accuracy_improvement": _target(h1["accuracy_delta"], .05, covered=full_corpus),
        "severe_error_reduction": _target(h3["relative_severe_error_reduction"], .30,
                                           covered=full_corpus and h3["n_cases"] == len(cases)),
        "exception_boundary_improvement": _target(subgroups["exception_boundary"]["accuracy_delta"], .10,
                                                   covered=full_corpus and subgroups["exception_boundary"]["n_cases"] == subgroups["exception_boundary"]["planned_cases"]),
        "missing_information_correct_handling": _target(subgroups["missing_information"]["accuracy_b"], .95,
                                                        covered=full_corpus and subgroups["missing_information"]["n_cases"] == subgroups["missing_information"]["planned_cases"]),
        "primary_significance": _target(h1["p_one_sided_exact"], .05, covered=full_corpus, less_than=True),
        "positive_saving_per_correct_case": _target(None, 0, covered=False, reason="H5 requires full economics inputs and human accuracy in the economics module"),
    }
    targets["positive_saving_per_correct_case"]["operator"] = ">"
    targets["primary_significance"]["multiplicity"] = "Raw per-model p value; Holm correction over all prespecified model comparisons required before a family-level claim"
    return {"status": "ok" if h1["status"] == "ok" else "not_evaluable", "primary_repeat": primary_repeat,
            "review_status": h1["review_status"],
            "metric": "human_accuracy", "corpus_case_count": len(cases), "protocol_case_count": 30,
            "hypotheses": {"H1": h1, "H2": h2, "H3": h3, "H4": h4}, "subgroups": subgroups, "targets": targets,
            "H5": {"status": "not_evaluable", "module": "economics", "reason": "Separate full-cost analysis required"},
            "multiplicity": "H1 one-sided alpha .05 per prespecified model; Holm adjustment across model family. H2/H3/H4 and tagged subgroups are exploratory; report all tests.",
            "limitations": ["Thirty purposively selected cases cannot establish universal superiority or fine-grained effect sizes",
                            "Repetitions are robustness checks, not additional independent cases",
                            "Unknown or unreviewed labels are excluded and reported, never silently coded as correct or incorrect",
                            "Target pass/fail requires the complete planned 30-case human review; observed partial estimates remain visible"]}
