"""Paired, case-clustered statistics with standard-library exact/Monte Carlo tests."""
from collections import Counter, defaultdict
import itertools
import math
import random
from statistics import mean


def quantile(values, p):
    ordered = sorted(values)
    at = (len(ordered) - 1) * p
    low = int(at)
    high = min(low + 1, len(ordered) - 1)
    return ordered[low] + (ordered[high] - ordered[low]) * (at - low)


def exact_mcnemar(a_only_correct, b_only_correct):
    n = a_only_correct + b_only_correct
    if n == 0:
        return 1.0
    return min(1.0, 2 * sum(math.comb(n, k) for k in range(min(a_only_correct, b_only_correct) + 1)) / 2**n)


def holm_adjust(pvalues):
    if any(p is None or not 0 <= p <= 1 for p in pvalues):
        raise ValueError("Holm input must be finite p values")
    order = sorted(range(len(pvalues)), key=lambda i: pvalues[i])
    adjusted, previous = [0.0] * len(pvalues), 0.0
    for rank, i in enumerate(order):
        previous = max(previous, min(1.0, (len(order) - rank) * pvalues[i]))
        adjusted[i] = previous
    return adjusted


def paired_statistics(a, b, *, seed=17, samples=20000):
    if len(a) != len(b):
        raise ValueError("Paired vectors must have equal length")
    if any(type(x) not in (int, float) or not math.isfinite(x) or not 0 <= x <= 1 for x in [*a, *b]):
        raise ValueError("Scores must be finite in [0,1]")
    n = len(a)
    if n < 2:
        return {"status": "insufficient_data", "n_cases": n, "reason": "At least two complete paired cases required; no p value fabricated"}
    differences = [right - left for left, right in zip(a, b)]
    nonzero = [d for d in differences if d != 0]
    observed = abs(sum(differences))
    rng = random.Random(seed)
    if len(nonzero) <= 18:
        values = (abs(sum(d * sign for d, sign in zip(nonzero, signs))) for signs in itertools.product((-1, 1), repeat=len(nonzero)))
        count = sum(value >= observed - 1e-12 for value in values)
        pvalue = count / 2**len(nonzero)
        method = "exact paired sign-flip permutation"
    else:
        count = sum(abs(sum(d * rng.choice((-1, 1)) for d in nonzero)) >= observed - 1e-12 for _ in range(samples))
        pvalue = (count + 1) / (samples + 1)
        method = f"Monte Carlo paired sign-flip permutation; plus-one correction; {samples} samples"
    boot = [mean(rng.choices(differences, k=n)) for _ in range(samples)]
    a_only = sum(x == 1 and y < 1 for x, y in zip(a, b))
    b_only = sum(y == 1 and x < 1 for x, y in zip(a, b))
    return {"status": "ok", "n_cases": n, "mean_a": mean(a), "mean_b": mean(b), "mean_difference_b_minus_a": mean(differences),
            "bootstrap_percentile_95ci": [quantile(boot, .025), quantile(boot, .975)], "bootstrap_unit": "case after within-case repeat aggregation",
            "permutation_p_two_sided": pvalue, "permutation_method": method, "seed": seed,
            "mcnemar_perfect_case": {"a_only_perfect": a_only, "b_only_perfect": b_only, "p_two_sided_exact": exact_mcnemar(a_only, b_only)},
            "inference_status": "exploratory; requires exchangeability under null; provisional references and purposive small corpus limit generalization"}


def compare_scores(rows, arm_a, arm_b, *, failure_policy="exclude", seed=17):
    if arm_a == arm_b or failure_policy not in {"exclude", "zero"}:
        raise ValueError("Two distinct arms and known failure policy required")
    index, available = {}, defaultdict(Counter)
    for r in rows:
        if r["arm"] not in {arm_a, arm_b}:
            continue
        key = (r["case_id"], r.get("repeat", 0), r["arm"])
        if key in index:
            raise ValueError("Duplicate case/repeat/arm: select one model/run or adjudicate raters before comparison")
        available[r["arm"]][r["status"]] += 1
        value = r.get("score")
        if r["status"] == "failed" and failure_policy == "zero":
            value = 0.0
        elif r["status"] != "ok":
            value = None
        index[key] = value
    by_case = defaultdict(list)
    units = {(cid, rep) for cid, rep, _ in index}
    for cid, rep in sorted(units):
        left, right = index.get((cid, rep, arm_a)), index.get((cid, rep, arm_b))
        if left is not None and right is not None:
            by_case[cid].append((left, right))
    a = [mean(x for x, _ in by_case[cid]) for cid in sorted(by_case)]
    b = [mean(y for _, y in by_case[cid]) for cid in sorted(by_case)]
    result = paired_statistics(a, b, seed=seed)
    result.update(arm_a=arm_a, arm_b=arm_b, failure_policy=failure_policy, matched_case_repeats=sum(map(len, by_case.values())),
                  total_case_repeat_units=len(units), paired_case_ids=sorted(by_case), availability_by_arm={k: dict(v) for k, v in available.items()})
    return result


def _binary_comparison(a, b, *, seed=17, samples=20000):
    """One-sided paired binary test, with case-pair bootstrap uncertainty."""
    if len(a) != len(b) or any(type(v) not in (int, float, bool) or v not in (0, 1) for v in [*a, *b]):
        raise ValueError("Equal-length binary paired vectors required")
    result = {"status": "not_evaluable", "n_cases": len(a), "accuracy_a": None, "accuracy_b": None,
              "accuracy_delta": None, "wins_b": None, "losses_b": None, "p_one_sided_exact": None,
              "bootstrap_percentile_95ci": None, "bootstrap_unit": "case", "seed": seed,
              "method": "one-sided exact McNemar (conditional binomial, H1: b > a)", "alpha": .05}
    if not a:
        result["reason"] = "No complete paired human binary observations; no p value fabricated"
        return result
    wins = sum(x == 0 and y == 1 for x, y in zip(a, b))
    losses = sum(x == 1 and y == 0 for x, y in zip(a, b))
    discordant = wins + losses
    p = sum(math.comb(discordant, k) for k in range(wins, discordant + 1)) / 2**discordant
    differences = [y - x for x, y in zip(a, b)]
    rng = random.Random(seed)
    boot = [mean(rng.choices(differences, k=len(differences))) for _ in range(samples)]
    result.update(status="ok", accuracy_a=mean(a), accuracy_b=mean(b), accuracy_delta=mean(differences),
                  wins_b=wins, losses_b=losses, p_one_sided_exact=p,
                  both_correct=sum(x == y == 1 for x, y in zip(a, b)),
                  both_incorrect=sum(x == y == 0 for x, y in zip(a, b)),
                  bootstrap_percentile_95ci=[quantile(boot, .025), quantile(boot, .975)])
    return result


def _human_pairs(rows, arm_a, arm_b, primary_repeat=0):
    """Validate one human cohort and retain availability without imputing scores."""
    if arm_a == arm_b or type(primary_repeat) is not int or primary_repeat < 0:
        raise ValueError("Distinct arms and a nonnegative prespecified repeat required")
    selected = [r for r in rows if r.get("arm") in {arm_a, arm_b}]
    if not any(r.get("metric") == "human_accuracy" for r in selected):
        current = [r for r in selected if r.get("repeat", 0) == primary_repeat]
        cases = sorted({r["case_id"] for r in current})
        availability = {arm_a: Counter(), arm_b: Counter()}
        for arm in (arm_a, arm_b):
            arm_rows = [r for r in current if r["arm"] == arm]
            availability[arm].update("unreviewed" if r["status"] == "ok" else r["status"] for r in arm_rows)
            missing = len(set(cases) - {r["case_id"] for r in arm_rows})
            if missing:
                availability[arm]["missing"] = missing
        return {}, [], {k: dict(v) for k, v in availability.items()}, cases
    if any(r.get("metric") != "human_accuracy" for r in selected):
        raise ValueError("Primary analysis requires human_accuracy only; never mix metrics")
    seen, ids = set(), set()
    for row in selected:
        if type(row.get("repeat")) is not int or row["repeat"] < 0:
            raise ValueError("Every human row requires a valid repeat")
        key = (row.get("case_id"), row["repeat"], row["arm"])
        if key in seen or not row.get("record_id") or row["record_id"] in ids:
            raise ValueError("Duplicate records or case/repeat/arm; select one cohort and resolve raters first")
        seen.add(key)
        ids.add(row["record_id"])
        for field in ("case_sha256", "law_sha256"):
            value = row.get(field)
            if not isinstance(value, str) or len(value) != 64 or any(c not in "0123456789abcdef" for c in value):
                raise ValueError(f"Missing or corrupt {field} provenance")
        if row.get("score") is not None:
            if row.get("status") != "ok" or type(row["score"]) not in (int, float, bool) or row["score"] not in (0, 1):
                raise ValueError("Primary scores must be binary and attached to an ok human-reviewed row")
            if row.get("severe_error") is True and row["score"] == 1:
                raise ValueError("Severe error cannot coexist with primary correctness")
    # Different providers/models or gold/corpus revisions are not additional cases.
    if len({r['resolved_model'] for r in selected if r.get('resolved_model')}) > 1:
        raise ValueError('Provider-reported model revision changed within the cohort')
    for field in ("model", "provider", "model_slot", "gold_sha256", "case_snapshot_sha256", "corpus_sha256", "config_sha256"):
        values = {r.get(field) for r in selected}
        if len(values) > 1:
            raise ValueError(f"Mixed {field} cohort; compare a single model and frozen corpus")
    index = {(r["case_id"], r["arm"]): r for r in selected if r["repeat"] == primary_repeat}
    cases = sorted({cid for cid, _ in index})
    availability = {arm_a: Counter(), arm_b: Counter()}
    pairs, missing = [], []
    for cid in cases:
        pair = [index.get((cid, arm)) for arm in (arm_a, arm_b)]
        for arm, row in zip((arm_a, arm_b), pair):
            status = "missing" if row is None else "unreviewed" if row["status"] == "ok" and not _reviewed(row) else row["status"]
            availability[arm][status] += 1
        if all(pair):
            for field in ("case_sha256", "law_sha256"):
                if pair[0][field] != pair[1][field]:
                    raise ValueError(f"Paired cases have mismatched {field}")
            extractions = [r.get("extraction_sha256") for r in pair]
            controlled = {arm_a, arm_b} <= {"llm_control", "llm_python", "llm_prolog"}
            if all(_reviewed(row) for row in pair):
                if controlled and any(not isinstance(value, str) or len(value) != 64 or
                                      any(c not in "0123456789abcdef" for c in value) for value in extractions):
                    raise ValueError("Reviewed controlled pairs require valid shared extraction hashes in both arms")
                if all(extractions) and extractions[0] != extractions[1]:
                    raise ValueError("Paired conditions have mismatched shared extraction")
        if all(_reviewed(r) for r in pair):
            pairs.append((cid, pair[0], pair[1]))
        else:
            missing.append(cid)
    return index, pairs, {k: dict(v) for k, v in availability.items()}, missing


def _reviewed(row):
    return row is not None and row["status"] == "ok" and row.get("score") is not None and type(row.get("severe_error")) is bool


def _finalized_review(row):
    evidence = row.get("review_evidence") or {}
    reviewers = evidence.get("reviewers")
    if row.get("review_status") != "adjudicated" or not isinstance(reviewers, list) or len(reviewers) != 2:
        return False
    identities = [*reviewers, evidence.get("adjudicator")]
    if any(not isinstance(v, str) or not v.strip() for v in identities) or len(set(identities)) != 3:
        return False
    return all(isinstance(evidence.get(field), str) and evidence[field].strip()
               for field in ("roles_sha256", "adjudication_sha256", "signed_at"))


def primary_accuracy_compare(rows, a, b, primary_repeat=0):
    """Prespecified case-level binary primary contrast; repetitions never increase n."""
    rows = list(rows)
    index, pairs, availability, missing = _human_pairs(rows, a, b, primary_repeat)
    observed = {r["case_id"] for r in rows if r.get("arm") in {a, b} and r.get("repeat", 0) == primary_repeat}
    planned = {f"F{i:02d}" for i in range(1, 21)} | {f"C{i:02d}" for i in range(1, 11)}
    result = _binary_comparison([x["score"] for _, x, _ in pairs], [y["score"] for _, _, y in pairs])
    result.update(metric="human_accuracy", arm_a=a, arm_b=b, primary_repeat=primary_repeat,
                  null_hypothesis="p_b <= p_a", alternative_hypothesis="p_b > p_a",
                  paired_case_ids=[cid for cid, _, _ in pairs], excluded_case_ids=missing,
                  availability_by_arm=availability, observed_case_count=len(observed),
                  unobserved_case_count=len(planned - observed), unobserved_case_ids=sorted(planned - observed),
                  planned_case_count=30, failure_policy="exclude",
                  review_requirement="Final inference requires two independent qualified GDPR reviewers and documented third-reviewer adjudication",
                  inference_status="Pilot estimate; purposive 30-case corpus and incomplete coverage limit generalization")
    result["human_review_finalized"] = bool(pairs) and all(_finalized_review(row) for _, x, y in pairs for row in (x, y))
    result["review_status"] = "finalized" if result["human_review_finalized"] else "preliminary_or_unreviewed"
    # Separate sensitivity: technical failures alone become zero. Blocked, absent,
    # and unreviewed answers remain unknown, never manufactured human outcomes.
    sensitivity_pairs = []
    for cid in sorted({cid for cid, _ in index}):
        values = []
        for arm in (a, b):
            row = index.get((cid, arm))
            values.append(0 if row and row["status"] == "failed" else
                          row.get("score") if _reviewed(row) else None)
        if all(v is not None for v in values):
            sensitivity_pairs.append(values)
    result["failure_sensitivity"] = dict(_binary_comparison([v[0] for v in sensitivity_pairs], [v[1] for v in sensitivity_pairs]),
                                         failure_policy="technical_failed_as_zero_only", metric="operational_sensitivity_not_human_legal_accuracy")
    return result


def rater_agreement(first, second):
    """Descriptive agreement; ratings are paired by record identity, never averaged silently."""
    def key(r):
        return (r.get("source_predictions_sha256"), r.get("record_id"))
    def index(rows):
        selected = [r for r in rows if r.get("score") is not None]
        indexed = {key(r): r for r in selected}
        if len(indexed) != len(selected):
            raise ValueError("Duplicate reviewer records")
        return indexed
    a, b = index(first), index(second)
    common = sorted(set(a) & set(b))
    if not common:
        return {"status": "insufficient_data", "n_records": 0}
    differences = [abs(a[k]["score"] - b[k]["score"]) for k in common]
    result = {"status": "ok", "n_records": len(common), "mean_absolute_score_difference": mean(differences),
            "exact_score_agreement": sum(d == 0 for d in differences) / len(common),
            "disagreements": [{"record_id": a[k]["record_id"], "score_a": a[k]["score"], "score_b": b[k]["score"]} for k in common if a[k]["score"] != b[k]["score"]]}
    binary = all(a[k].get("metric") == b[k].get("metric") == "human_accuracy" and
                 a[k]["score"] in (0, 1) and b[k]["score"] in (0, 1) for k in common)
    result.update(binary_accuracy_agreement=None, cohen_kappa=None, kappa_status="not_evaluable")
    if binary:
        observed = result["exact_score_agreement"]
        prevalence_a, prevalence_b = mean(a[k]["score"] for k in common), mean(b[k]["score"] for k in common)
        expected = prevalence_a * prevalence_b + (1 - prevalence_a) * (1 - prevalence_b)
        result.update(binary_accuracy_agreement=observed,
                      cohen_kappa=(observed - expected) / (1 - expected) if expected < 1 else None,
                      kappa_status="ok" if expected < 1 else "not_evaluable_constant_marginals")
    return result
