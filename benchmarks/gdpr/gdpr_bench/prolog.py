"""Contract for a future, independently reviewed GDPR Prolog bridge.

No GDPR rulebase or fabricated oracle is bundled. Availability fails closed.
The executable is a trusted operator-supplied local program, never model text.
"""
import json
import os
from pathlib import Path
import subprocess
from .dataset import sha256, validate_response, strict_json


class PrologAdapter:
    def __init__(self, manifest_path=None):
        self.path = Path(manifest_path).resolve() if manifest_path else None
        self.manifest = None

    def availability(self, case=None):
        def blocked(reason):
            return {"status": "blocked", "reason": reason}
        if self.path is None:
            return blocked("No independently reviewed GDPR Prolog modules configured; see sources/upstream-check.json")
        try:
            m = json.loads(self.path.read_text())
            review = m.get("independent_review", {})
            if m.get("legal_regime") != "GDPR" or review.get("status") != "approved" or not review.get("reviewer") or not review.get("reviewed_at"):
                return blocked("GDPR scope and independent review evidence required")
            if not m.get("source_url") or not m.get("source_revision") or not m.get("engine"):
                return blocked("Prolog source provenance and engine are missing")
            files = m.get("artifacts", {})
            if not files or not any(Path(name).suffix in {".pl", ".clausal"} for name in files):
                return blocked("No actual Prolog rule artifacts declared")
            for name, digest in files.items():
                p = (self.path.parent / name).resolve()
                if not p.is_file() or sha256(p) != digest:
                    return blocked("Prolog artifact missing or hash mismatch")
            command = m.get("command")
            if not isinstance(command, list) or not command or not all(isinstance(x, str) and x for x in command):
                return blocked("Trusted local bridge command list missing")
            executable = Path(command[0])
            if not executable.is_absolute() or not executable.is_file() or not os.access(executable, os.X_OK):
                return blocked("Bridge executable must be an existing absolute executable path")
            if case and any(q["rule"] not in m.get("supported_rules", []) for q in case["questions"]):
                return blocked("GDPR modules do not cover every subquestion in this case")
            self.manifest = m
            return {"status": "ready", "manifest_sha256": sha256(self.path), "source_revision": m["source_revision"], "engine": m["engine"],
                    "python_equivalence_review": m.get("python_equivalence_review", {"status":"pending"})}
        except (OSError, ValueError, TypeError, KeyError):
            return blocked("Invalid or unreadable Prolog manifest")

    def run(self, case, *, extracted_questions=None):
        available = self.availability(case)
        if available["status"] != "ready":
            return available
        questions = extracted_questions if extracted_questions is not None else [{"id": q["id"], "rule": q["rule"], "facts": q["facts"]} for q in case["questions"]]
        expected = {q["id"]: q for q in case["questions"]}
        if (not isinstance(questions, list) or len(questions) != len(expected)
                or any(not isinstance(q, dict) or not isinstance(q.get("id"), str) for q in questions)
                or {q["id"] for q in questions} != set(expected)):
            return {"status": "failed", "reason": "Invalid extracted question set"}
        for q in questions:
            if q.get("rule") != expected[q["id"]]["rule"] or not isinstance(q.get("facts"), dict) or set(q["facts"]) != set(expected[q["id"]]["facts"]):
                return {"status": "failed", "reason": "Invalid extracted fact schema"}
        payload = {"schema_version": 1, "case_id": case["id"], "mode": "model_extraction" if extracted_questions is not None else "oracle", "questions": questions}
        try:
            process = subprocess.run(self.manifest["command"], cwd=self.path.parent, input=json.dumps(payload),
                                     text=True, capture_output=True, timeout=30, check=False)
            if process.returncode:
                return {"status": "failed", "reason": "Prolog bridge nonzero exit", "exit_code": process.returncode}
            output = strict_json(process.stdout)
            if not isinstance(output, dict):
                return {"status": "failed", "reason": "Invalid Prolog bridge response"}
            if output.get("status") != "ok":
                return {"status": "blocked" if output.get("status") == "blocked" else "failed", "reason": "Prolog bridge declined evaluation"}
            prediction = validate_response(output["prediction"], case)
            return {"status": "ok", "prediction": prediction, "trace": output.get("trace"), "provenance": available}
        except subprocess.TimeoutExpired:
            return {"status": "failed", "reason": "Prolog bridge timeout"}
        except (OSError, ValueError, TypeError, KeyError):
            return {"status": "failed", "reason": "Invalid Prolog bridge response"}
