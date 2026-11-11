"""Data loading and strict output contracts; gold is loaded only by evaluators."""
import hashlib
import json
import math
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
DECISIONS = {"yes", "no", "conditional", "unknown", "not_applicable"}


def strict_json(value):
    def reject(token):
        raise ValueError('Non-finite JSON numeric constant')
    def finite_float(token):
        number = float(token)
        if not math.isfinite(number):
            raise ValueError('Non-finite JSON number')
        return number
    return json.loads(value, parse_constant=reject, parse_float=finite_float)


def sha256(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def digest_json(value):
    return hashlib.sha256(json.dumps(value, sort_keys=True, ensure_ascii=False).encode()).hexdigest()


def read_jsonl(path):
    with Path(path).open(encoding="utf-8") as handle:
        return [strict_json(line) for line in handle if line.strip()]


def write_json(path, data):
    Path(path).write_text(json.dumps(data, ensure_ascii=False, indent=2, allow_nan=False) + "\n", encoding="utf-8")


def write_jsonl(path, rows):
    with Path(path).open("w", encoding="utf-8") as handle:
        for row in rows:
            handle.write(json.dumps(row, ensure_ascii=False, allow_nan=False) + "\n")


def load_cases(root=ROOT):
    cases = read_jsonl(Path(root) / "data/cases.jsonl")
    expected = {f"F{i:02d}" for i in range(1, 21)} | {f"C{i:02d}" for i in range(1, 11)}
    if len(cases) != 30 or {c["id"] for c in cases} != expected:
        raise ValueError("Exactly F01..F20 and C01..C10 required")
    for c in cases:
        kind = "focused" if c["id"].startswith("F") else "complex"
        if c["kind"] != kind or not c["scenario"].strip() or not c["title"].strip():
            raise ValueError(f"Invalid case {c['id']}")
        questions = c["questions"]
        if (kind == "focused" and len(questions) != 1) or (kind == "complex" and len(questions) != 5):
            raise ValueError(f"Invalid subquestion count {c['id']}")
        if len({q["id"] for q in questions}) != len(questions):
            raise ValueError("Duplicate question ID")
        if not c["law_articles"] or any(type(a) is not int or not 1 <= a <= 99 for a in c["law_articles"]):
            raise ValueError("Invalid law article set")
        for q in questions:
            if not q["prompt"].strip() or not q["rule"] or not isinstance(q["facts"], dict):
                raise ValueError("Invalid question")
    return cases


def load_gold(root=ROOT):
    cases = {c["id"]: c for c in load_cases(root)}
    rows = read_jsonl(Path(root) / "data/gold.provisional.jsonl")
    if len(rows) != len(cases) or {g["case_id"] for g in rows} != set(cases):
        raise ValueError("Gold/case mismatch")
    for row in rows:
        if row["status"] != "provisional":
            raise ValueError("This release only supports provisional gold")
        answers = row["answers"]
        if len(answers) != len(cases[row["case_id"]]["questions"]) or {a["question_id"] for a in answers} != {q["id"] for q in cases[row["case_id"]]["questions"]}:
            raise ValueError("Gold question mismatch")
        for a in answers:
            if a["decision"] not in DECISIONS or not a["required_points"] or not a["legal_basis"]:
                raise ValueError("Incomplete gold")
            if any(ref["article"] not in cases[row["case_id"]]["law_articles"] for ref in a["legal_basis"]):
                raise ValueError("Gold reference missing from shared law context")
    return {g["case_id"]: g for g in rows}


def validate_response(response, case):
    """Validate and return only the fields in the answer contract."""
    if not isinstance(response, dict) or not isinstance(response.get("answers"), list):
        raise ValueError("Response must contain answers list")
    answers = response["answers"]
    required = {q["id"] for q in case["questions"]}
    if len(answers) != len(required) or {a.get("question_id") for a in answers if isinstance(a, dict)} != required:
        raise ValueError("Exactly one answer per question required")
    canonical_answers = []
    for a in answers:
        if a.get("decision") not in DECISIONS or not isinstance(a.get("reasoning"), str) or not a["reasoning"].strip():
            raise ValueError("Invalid decision or reasoning")
        answer = {key: a[key] for key in ("question_id", "decision", "reasoning")}
        for key in ("citations", "missing_facts", "actions"):
            if not isinstance(a.get(key), list) or not all(isinstance(s, str) for s in a[key]):
                raise ValueError(f"Invalid {key}")
            answer[key] = a[key]
        canonical_answers.append(answer)
    return {"answers": canonical_answers}
