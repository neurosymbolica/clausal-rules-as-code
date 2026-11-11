"""Gold diagnostics and identity-blinded human rubric export/import."""
import copy
from datetime import datetime, timezone
import json
from pathlib import Path
import random
import secrets
from statistics import mean
from .dataset import ROOT, digest_json, read_jsonl, sha256, validate_response, write_json, write_jsonl
from .prompts import public_case

DIMENSIONS = ("legal_decision", "conditions", "exceptions", "legal_basis", "uncertainty")
IDENTITY_FIELDS = ("record_id", "case_id", "repeat", "arm", "provider", "model", "status", "reason", "cost_usd",
                   "billed_cost_usd", "law_sha256", "case_sha256", "case_snapshot_sha256", "corpus_sha256",
                   "config_sha256", "prompt_sha256", "source_sha256", "extraction_group_id", "extraction_sha256",
                   "model_slot", "engine_scope_alignment", "product_capture", "raw_response_sha256", "final_prompt_sha256", "resolved_model", "resolved_models")
ERRORS = {"wrong_legal_basis", "wrong_scope", "wrong_role", "missed_exception", "wrong_threshold", "wrong_deadline", "unsupported_fact",
          "missed_missing_fact", "overconfident_conclusion", "missing_action", "incomplete_answer", "invalid_citation", "inconsistent_reasoning",
          "formalization_error", "tool_misuse", "other"}


def _blind_response(prediction, case):
    if isinstance(prediction, dict) and "text" in prediction:
        if "answers" in prediction or not isinstance(prediction["text"], str) or not prediction["text"].strip():
            raise ValueError("Free-text response must contain nonempty text and no structured answers")
        return {"text": prediction["text"]}
    return validate_response(prediction, case)


def diagnostic_scores(run_dir, gold):
    rows = read_jsonl(Path(run_dir) / "predictions.jsonl")
    scored = []
    for row in rows:
        s = {k: row.get(k) for k in IDENTITY_FIELDS if k in row}
        s.update(metric="provisional_decision_match", score=None, source_predictions_sha256=sha256(Path(run_dir) / "predictions.jsonl"))
        if row["status"] == "ok":
            if "text" in row["prediction"]:
                _blind_response(row["prediction"], None)
                s["scoring_status"] = "not_evaluable"
                s["scoring_reason"] = "Free-text responses require human legal review; no automatic semantic judge"
                scored.append(s)
                continue
            expected = {a["question_id"]: a for a in gold[row["case_id"]]["answers"]}
            answers = row["prediction"]["answers"]
            if len(answers) != len(expected) or {a["question_id"] for a in answers} != set(expected):
                raise ValueError("Prediction/gold question mismatch")
            s["questions"] = [{"question_id": a["question_id"], "predicted": a["decision"], "provisional_expected": expected[a["question_id"]]["decision"],
                               "matches": a["decision"] == expected[a["question_id"]]["decision"]} for a in answers]
            s["score"] = mean(q["matches"] for q in s["questions"])
        scored.append(s)
    return scored


def blind_export(run_dir, reviewer_dir, key_file, gold):
    from .law import LawCorpus
    run_dir, reviewer_dir, key_file = Path(run_dir), Path(reviewer_dir), Path(key_file)
    if key_file.resolve().is_relative_to(reviewer_dir.resolve()):
        raise ValueError("Private mapping must be OUTSIDE reviewer directory")
    if reviewer_dir.exists() or key_file.exists():
        raise FileExistsError("Never overwrite review or mapping files")
    legislation = LawCorpus(ROOT / "sources")  # Verify pinned source bytes before any export writes.
    snapshot = read_jsonl(run_dir / "cases.snapshot.jsonl")
    cases = {c["id"]: c for c in snapshot}
    records = read_jsonl(run_dir / "predictions.jsonl")
    if len(cases) != len(snapshot) or len({r.get("record_id") for r in records}) != len(records):
        raise ValueError("Duplicate case or response identity in source run")
    for row in records:
        if row["case_id"] not in cases or (row.get("case_sha256") is not None and row["case_sha256"] != digest_json(cases[row["case_id"]])):
            raise ValueError("Source response does not match its case snapshot")
    bundle, mappings = [], {}
    for row in records:
        if row["status"] != "ok":
            continue
        bid = secrets.token_hex(12)
        case = cases[row["case_id"]]
        case_gold = gold[row["case_id"]]
        ratings = []
        for a in case_gold["answers"]:
            ratings.append({"question_id": a["question_id"], "legally_correct": None, "severe_error": None,
                            "required_points": [{"text": text, "met": None, "evidence": ""} for text in a["required_points"]],
                            "scores": {d: None for d in DIMENSIONS}, "errors": [], "comment": ""})
        item = {"blind_id": bid, "case": public_case(case), "relevant_articles": case.get("law_articles"),
                "response": _blind_response(row["prediction"], case),
                "reference_status": "provisional; independent legal review pending", "reference": case_gold["answers"], "ratings": ratings}
        immutable = {k: v for k, v in item.items() if k != "ratings"}
        mappings[bid] = {"identity": {k: row.get(k) for k in IDENTITY_FIELDS if k in row},
                         "immutable_sha256": digest_json(immutable), "point_texts": {r["question_id"]: [p["text"] for p in r["required_points"]] for r in ratings}}
        bundle.append(item)
    random.SystemRandom().shuffle(bundle)
    reviewer_dir.mkdir(parents=True)
    law_dir = reviewer_dir / "legislation"
    law_dir.mkdir()
    for name in ("gdpr-articles.txt", "law-manifest.json"):
        (law_dir / name).write_bytes((legislation.directory / name).read_bytes())
    key_file.parent.mkdir(parents=True, exist_ok=True)
    write_jsonl(reviewer_dir / "items.jsonl", bundle)
    write_json(key_file, {"schema_version": 2, "source_predictions_sha256": sha256(run_dir / "predictions.jsonl"), "gold_sha256": digest_json(gold),
                          "mapping": mappings, "unavailable": [{k: r.get(k) for k in IDENTITY_FIELDS if k in r} for r in records if r["status"] != "ok"]})
    key_file.chmod(0o600)
    write_json(reviewer_dir / "roles.json", {"status": "unassigned", "reviewer_1": None, "reviewer_2": None,
                                            "third_adjudicator": None, "independent_analyst": None})
    (reviewer_dir / "INSTRUCTIONS.md").write_text("""# Independent blind legal review

Two independent qualified GDPR reviewers must each rate a separate copy of the same
items.jsonl before seeing the other's ratings. A third independent qualified GDPR
adjudicator resolves disagreements; an independent analyst performs the analysis.
All roles start UNASSIGNED in roles.json. Record actual identity, qualifications,
acceptance date, independence from authorship and conflicts before final analysis.
An imported reviewer identifier alone does not certify qualifications or independence.

The legislation directory contains the exact pinned English GDPR article text and
its source manifest. Source-file hashes were verified before copying. Use the
item's relevant_articles and the complete article text when assessing its legal
bases and exceptions; the provisional reference is not authoritative gold. Copy
verification does not itself certify that a source run supplied those same law
bytes: run-law provenance is separately checked by the release CLI. Null article
metadata in a synthetic/development fixture is not a verified article selection.

To assign reviewer_1, reviewer_2 or third_adjudicator in roles.json, replace that
role's null with an object containing id, qualifications, independent_of_authorship
(true only if actually declared), conflicts (including an explicit no-conflict
declaration when applicable), and accepted_at (ISO date/time). The third_adjudicator
must also declare independent_of_reviewers: true and have a different id from both
reviewers. Keep independent_analyst null until a real person accepts that role.
Declarations are recorded; this tool does not independently verify credentials.

After independent imports, adjudication_export creates a pending checklist. For
each dispute, an actual third reviewer chooses resolution {"choice":"first"},
{"choice":"second"}, or {"choice":"custom","ratings":[complete original rating
objects with scores, legally_correct, severe_error, required_points, errors,
comment and question_id]}. Every dispute needs rationale and resolved_at. Preserve
the original ratings, blind IDs and source hashes. Complete adjudicator,
qualifications (matching roles.json), independent_of_reviewers_and_authorship and
signed_at, and only after actual sign-off change status to completed. Agreements
also require that sign-off. finalize_adjudication validates these files, recomputes
the primary/severity/rubric outcomes from actual ratings and retains both original
reviews as hashed evidence. Blank assignments or resolutions never become results.

Edit only ratings. Preserve the case, response and provisional reference exactly.
For every question explicitly set legally_correct and severe_error to true or false.
A severe error is a material legal error that could lead to unlawful processing,
loss of a right, a missed mandatory duty or materially unsafe legal advice. Explain
it in comment, identify the error category and provide supporting point evidence.
Any severe error vetoes correctness. A task is correct only if ALL subquestions are
legally correct with no severe error. Do not infer correctness from rubric points.

Five secondary dimensions each use integer 0/1/2 (wrong or absent / partial / sound):
legal_decision: correct legally qualified conclusion;
conditions: application of the relevant legal conditions to the supplied facts;
exceptions: identifying and applying relevant exceptions, or justifying none;
legal_basis: correct applicable legal bases and accurate supporting references;
uncertainty: acknowledging material missing facts and avoiding invented certainty.
Appropriate definiteness can earn full uncertainty credit when facts are sufficient.
The secondary question rubric score is the sum of these five dimensions / 10.
Mark every required point met true/false with a short evidence explanation. Point
coverage is a separate checklist, never a sixth dimension or primary correctness.
References are provisional; explain a reasoned disagreement rather than copying them.
An unknown/conditional answer can be legally correct; unreviewed is never zero.

Raw product responses are supplied verbatim. Score each case question against that
response; do not invent a structured answer or use an automated judge. System,
model and operational metadata are removed, but style or self-identification in the
answer can reveal a condition. Do not seek identity. Record suspected unblinding.
Pending templates are not results. Adjudication exports are checklists, not approvals.

Error categories: """ + ", ".join(sorted(ERRORS)) + "\n", encoding="utf-8")
    return {"items": len(bundle), "unavailable_records": len(records) - len(bundle), "reviewer_directory": str(reviewer_dir), "private_key": str(key_file)}


def _score_ratings(ratings, point_texts):
    if not isinstance(ratings, list) or not ratings or len(ratings) != len(point_texts) or {r["question_id"] for r in ratings} != set(point_texts):
        raise ValueError("Ratings question mismatch")
    question_scores = []
    for r in ratings:
        points, dimensions = r["required_points"], r["scores"]
        if [p["text"] for p in points] != point_texts[r["question_id"]] or not points:
            raise ValueError("Required-point rubric changed")
        if any(type(p.get("met")) is not bool or not isinstance(p.get("evidence"), str) or not p["evidence"].strip() for p in points):
            raise ValueError("Complete every point with a boolean and evidence")
        if set(dimensions) != set(DIMENSIONS) or any(type(v) is not int or v not in (0, 1, 2) for v in dimensions.values()):
            raise ValueError("Every dimension must have an integer 0/1/2")
        if type(r.get("legally_correct")) is not bool or type(r.get("severe_error")) is not bool:
            raise ValueError("Explicit human legally_correct and severe_error booleans required for every question")
        if not isinstance(r["errors"], list) or any(e not in ERRORS for e in r["errors"]):
            raise ValueError("Unknown error category")
        if not isinstance(r.get("comment", ""), str):
            raise ValueError("Rating comment must be text")
        correct = r["legally_correct"] and not r["severe_error"]
        question_scores.append({"question_id": r["question_id"], "score": int(correct), "legally_correct": correct,
                                "reviewer_legally_correct": r["legally_correct"], "severe_error": r["severe_error"],
                                "rubric_score": sum(dimensions.values()) / 10, "point_coverage": mean(p["met"] for p in points),
                                "required_points": points, "dimensions": dimensions, "errors": r["errors"], "comment": r.get("comment", "")})
    return question_scores


def _case_scores(questions):
    return {"score": int(all(q["legally_correct"] for q in questions)),
            "severe_error": any(q["severe_error"] for q in questions),
            "rubric_score": mean(q["rubric_score"] for q in questions), "questions": questions}


def import_reviews(review_file, key_file, reviewer):
    if not isinstance(reviewer, str) or not reviewer.strip():
        raise ValueError("An actual reviewer identifier is required")
    key = json.loads(Path(key_file).read_text())
    items = read_jsonl(review_file)
    ids = [i["blind_id"] for i in items]
    if len(set(ids)) != len(ids) or set(ids) != set(key["mapping"]):
        raise ValueError("Review set must match the complete blind export; no duplicates or omissions")
    scored = []
    for item in items:
        link = key["mapping"][item["blind_id"]]
        if digest_json({k: v for k, v in item.items() if k != "ratings"}) != link["immutable_sha256"]:
            raise ValueError("Review changed immutable case/reference/response fields")
        question_scores = _score_ratings(item["ratings"], link["point_texts"])
        scored.append(dict(link["identity"], **_case_scores(question_scores), blind_id=item["blind_id"], reviewer=reviewer, metric="human_accuracy",
                           review_status="independent_review", source_predictions_sha256=key["source_predictions_sha256"], gold_sha256=key["gold_sha256"],
                           imported_at=datetime.now(timezone.utc).isoformat()))
    scored.extend(dict(r, metric="human_accuracy", score=None, rubric_score=None, severe_error=None, reviewer=reviewer,
                       source_predictions_sha256=key["source_predictions_sha256"], gold_sha256=key["gold_sha256"]) for r in key["unavailable"])
    return scored


def _review_index(rows):
    index = {(r.get("source_predictions_sha256"), r.get("record_id")): r for r in rows}
    if len(index) != len(rows):
        raise ValueError("Duplicate independent review records")
    return index


def _adjudication_template(first_scores, second_scores):
    from .statistics import rater_agreement
    agreement = rater_agreement(first_scores, second_scores)
    first, second = _review_index(first_scores), _review_index(second_scores)
    if set(first) != set(second):
        raise ValueError("Both reviewers must score the same records before adjudication")
    disagreements = []
    comparable = ("score", "rubric_score", "severe_error", "questions")
    def decisions(row):
        # Independent explanatory wording is expected. Disagreements concern
        # judgments, dimensions, checklist decisions and assigned error labels.
        questions = [{k: q.get(k) for k in ("question_id", "legally_correct", "reviewer_legally_correct",
                                           "score", "severe_error", "dimensions", "errors")} |
                     {"points_met": [p.get("met") for p in q.get("required_points", [])]}
                     for q in row.get("questions", [])]
        return (row.get("score"), row.get("rubric_score"), row.get("severe_error"),
                sorted(questions, key=lambda q: q["question_id"]))
    for key in sorted(first):
        a, b = first[key], second[key]
        if not a.get("reviewer") or not b.get("reviewer") or a["reviewer"] == b["reviewer"]:
            raise ValueError("Two distinct actual reviewer identifiers required")
        if a.get("metric") != "human_accuracy" or b.get("metric") != "human_accuracy":
            raise ValueError("Adjudication requires independent human_accuracy reviews")
        for field in (*IDENTITY_FIELDS, "blind_id", "gold_sha256"):
            if a.get(field) != b.get(field):
                raise ValueError(f"Independent reviews disagree on immutable {field} provenance")
        if (a.get("score") is None) != (b.get("score") is None):
            raise ValueError("Both independent reviews must be complete before adjudication")
        if a.get("score") is None:
            if a.get("status") == "ok":
                raise ValueError("Unreviewed available response cannot be adjudicated")
            continue
        if decisions(a) != decisions(b):
            disagreements.append({"blind_id": a.get("blind_id"), "reviewer_a": a["reviewer"], "reviewer_b": b["reviewer"],
                                  "first_rating": {k: a.get(k) for k in comparable},
                                  "second_rating": {k: b.get(k) for k in comparable},
                                  "resolution": None, "rationale": "", "resolved_at": None})
    return {"schema_version": 2, "status": "pending_adjudication" if disagreements else "pending_human_signoff",
              "adjudicator": None, "qualifications": None, "independent_of_reviewers_and_authorship": None,
              "signed_at": None, "first_review_sha256": digest_json(first_scores), "second_review_sha256": digest_json(second_scores),
              "n_records": sum(r.get("score") is not None for r in first.values()), "n_disagreements": len(disagreements),
              "agreement": {k: v for k, v in agreement.items() if k != "disagreements"}, "disagreements": disagreements,
              "instructions": "Third qualified GDPR reviewer: set each resolution to {'choice':'first'}, {'choice':'second'}, or {'choice':'custom','ratings':[complete original-shaped ratings]}; provide rationale and resolved_at. Complete adjudicator declarations, signed_at and status='completed' only after actual review. Pending fields generate no final scores."}


def adjudication_export(first_scores, second_scores, output_path):
    """Prepare unresolved differences, never manufacture a consensus or approval."""
    result = _adjudication_template(first_scores, second_scores)
    path = Path(output_path)
    if path.exists():
        raise FileExistsError("Never overwrite an adjudication record")
    write_json(path, result)
    return result


def _original_ratings(row):
    return [{"question_id": q["question_id"], "legally_correct": q["reviewer_legally_correct"],
             "severe_error": q["severe_error"], "scores": q["dimensions"], "required_points": q["required_points"],
             "errors": q["errors"], "comment": q.get("comment", "")} for q in row["questions"]]


def finalize_adjudication(first_scores, second_scores, adjudication_file, roles_file):
    """Finalize actual two-reviewer judgments after explicit independent third sign-off.

    Declarations are recorded and validated for completeness, never claimed to be
    independently verified credentials. This function cannot invent missing ratings.
    """
    first_scores, second_scores = list(first_scores), list(second_scores)
    expected = _adjudication_template(first_scores, second_scores)
    adjudication = json.loads(Path(adjudication_file).read_text(encoding="utf-8"))
    roles = json.loads(Path(roles_file).read_text(encoding="utf-8"))
    if not expected["n_records"]:
        raise ValueError("No complete human response reviews to finalize")
    for field in ("schema_version", "first_review_sha256", "second_review_sha256", "n_records", "n_disagreements", "agreement"):
        if adjudication.get(field) != expected[field]:
            raise ValueError("Adjudication immutable source/review-set evidence changed")
    def nonempty(value):
        return isinstance(value, str) and bool(value.strip())
    def actual_date(value):
        if not nonempty(value):
            return False
        try:
            datetime.fromisoformat(value.replace("Z", "+00:00"))
            return True
        except ValueError:
            return False
    declarations = []
    for name in ("reviewer_1", "reviewer_2", "third_adjudicator"):
        role = roles.get(name)
        if not isinstance(role, dict) or any(not nonempty(role.get(field)) for field in ("id", "qualifications", "conflicts")):
            raise ValueError("Actual reviewer identity, qualifications and conflict declarations required")
        if role.get("independent_of_authorship") is not True or not actual_date(role.get("accepted_at")):
            raise ValueError("Actual dated independent-reviewer acceptance required")
        declarations.append(role)
    identifiers = [role["id"] for role in declarations]
    if len(set(identifiers)) != 3 or declarations[2].get("independent_of_reviewers") is not True:
        raise ValueError("Third adjudicator must be distinct and declare independence from both reviewers")
    for rows, identifier in zip((first_scores, second_scores), identifiers):
        if {r.get("reviewer") for r in rows} != {identifier}:
            raise ValueError("Role identities do not match the two independent review files")
    if (adjudication.get("status") != "completed" or adjudication.get("adjudicator") != identifiers[2]
            or adjudication.get("qualifications") != declarations[2]["qualifications"]
            or adjudication.get("independent_of_reviewers_and_authorship") is not True
            or not actual_date(adjudication.get("signed_at"))):
        raise ValueError("Explicit completed third-reviewer sign-off and declarations required")
    submitted = adjudication.get("disagreements", [])
    if not isinstance(submitted, list) or len(submitted) != len(expected["disagreements"]):
        raise ValueError("Complete the unchanged disagreement set")
    resolutions = {}
    expected_by_id = {item["blind_id"]: item for item in expected["disagreements"]}
    for item in submitted:
        blind_id = item.get("blind_id")
        if blind_id not in expected_by_id or blind_id in resolutions:
            raise ValueError("Changed or duplicate adjudication blind identity")
        for field in ("reviewer_a", "reviewer_b", "first_rating", "second_rating"):
            if item.get(field) != expected_by_id[blind_id][field]:
                raise ValueError("Immutable independent rating evidence was altered")
        resolution = item.get("resolution")
        if (not isinstance(resolution, dict) or resolution.get("choice") not in {"first", "second", "custom"}
                or not nonempty(item.get("rationale")) or not actual_date(item.get("resolved_at"))):
            raise ValueError("Each disputed response needs an explicit third decision, rationale and date")
        resolutions[blind_id] = item
    first, second = _review_index(first_scores), _review_index(second_scores)
    finalized = []
    for key in sorted(first):
        a, b = first[key], second[key]
        for field in ("case_sha256", "law_sha256", "source_predictions_sha256", "gold_sha256"):
            value = a.get(field)
            if not isinstance(value, str) or len(value) != 64 or any(c not in "0123456789abcdef" for c in value):
                raise ValueError(f"Final human outcomes require complete {field} provenance")
        result = copy.deepcopy(a)
        if a.get("score") is None:
            result.update(review_status="unavailable", score=None, rubric_score=None, severe_error=None)
            finalized.append(result)
            continue
        point_texts = {q["question_id"]: [p["text"] for p in q["required_points"]] for q in a["questions"]}
        # Both complete original reviews must still validate; selecting one cannot
        # hide an incomplete or fabricated counterpart.
        for source in (a, b):
            checked = _case_scores(_score_ratings(_original_ratings(source), point_texts))
            if any(source.get(field) != checked[field] for field in ("score", "severe_error", "rubric_score")):
                raise ValueError("Independent review scores do not match their actual question judgments")
        dispute = resolutions.get(a.get("blind_id"))
        choice = dispute["resolution"]["choice"] if dispute else "agreement"
        raw_ratings = (dispute["resolution"].get("ratings") if choice == "custom" else
                       _original_ratings(b if choice == "second" else a))
        result.update(_case_scores(copy.deepcopy(_score_ratings(raw_ratings, point_texts))))
        result.update(review_status="adjudicated", reviewer=identifiers[2],
                      review_evidence={"reviewers": identifiers[:2], "adjudicator": identifiers[2],
                                       "declarations": declarations, "declarations_independently_verified": False,
                                       "decision": choice, "rationale": dispute["rationale"] if dispute else "Both independent ratings agree; explicit third-reviewer sign-off recorded",
                                       "signed_at": adjudication["signed_at"], "roles_sha256": digest_json(roles),
                                       "adjudication_sha256": digest_json(adjudication),
                                       "first_review_sha256": expected["first_review_sha256"], "second_review_sha256": expected["second_review_sha256"]})
        finalized.append(result)
    return finalized


def summarize_scores(rows):
    arms = {}
    for arm in sorted({r["arm"] for r in rows}):
        selected = [r for r in rows if r["arm"] == arm]
        by_case = {}
        for r in selected:
            if r.get("score") is not None:
                by_case.setdefault(r["case_id"], []).append(r["score"])
        means = [mean(values) for values in by_case.values()]
        arms[arm] = {"records": len(selected), "counts": {s: sum(r["status"] == s for r in selected) for s in ("ok", "blocked", "failed")},
                     "scored_cases": len(means), "mean_case_score": mean(means) if means else None,
                     "error_counts": ({e: sum(e in q.get("errors", []) for r in selected for q in r.get("questions", [])) for e in sorted(ERRORS)}
                                      if any(r.get("metric") in {"human_accuracy", "human_rubric"} and r.get("score") is not None for r in selected) else None)}
    return {"metric": sorted({r.get("metric", "unknown") for r in rows}), "status": "provisional_exploratory", "arms": arms}
