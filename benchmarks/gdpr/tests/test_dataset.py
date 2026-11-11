"""Verify the packaged benchmark data against the public data contract."""

import hashlib
import json
import re
import unittest
from collections import Counter
from pathlib import Path
import xml.etree.ElementTree as ET


DATA = Path(__file__).resolve().parents[1] / "data"
DECISIONS = {"yes", "no", "conditional", "unknown", "not_applicable"}
ELI = "https://eur-lex.europa.eu/eli/reg/2016/679/oj"


def read_jsonl(name):
    path = DATA / name
    if not path.is_file():
        raise AssertionError(f"Missing dataset artifact: {path.name}")
    return [json.loads(line) for line in path.read_text(encoding="utf-8").splitlines()]


class DatasetTests(unittest.TestCase):
    def setUp(self):
        self.cases = read_jsonl("cases.jsonl")
        self.gold = read_jsonl("gold.provisional.jsonl")

    def test_exact_case_inventory_and_question_counts(self):
        expected = {
            **{f"F{i:02d}": "focused" for i in range(1, 21)},
            **{f"C{i:02d}": "complex" for i in range(1, 11)},
        }
        self.assertEqual(len(self.cases), 30)
        self.assertEqual({case["id"]: case["kind"] for case in self.cases}, expected)
        for case in self.cases:
            with self.subTest(case=case["id"]):
                self.assertEqual(case["provenance"]["origin"], "synthetic")
                self.assertTrue(case["title"].strip() and case["scenario"].strip())
                self.assertTrue(case["scope"]["included"] and case["scope"]["excluded"])
                self.assertIsInstance(case["missing_facts"], list)
                questions = case["questions"]
                if case["kind"] == "focused":
                    self.assertEqual(len(questions), 1)
                else:
                    self.assertEqual(len(questions), 5)
                self.assertEqual(
                    [q["id"] for q in questions],
                    [f"q{i}" for i in range(1, len(questions) + 1)],
                )
                self.assertEqual(len({q["id"] for q in questions}), len(questions))
                self.assertEqual(len({q["prompt"] for q in questions}), len(questions))
                for question in questions:
                    self.assertIn("?", question["prompt"])
                    self.assertRegex(question["rule"], r"^[a-z]+(?:_[a-z]+)*$")
                    self.assertIsInstance(question["facts"], dict)
                    self.assertTrue(question["facts"])
                    self.assertTrue(
                        question["facts"].keys().isdisjoint(
                            {"answer", "decision", "expected", "label", "outcome"}
                        )
                    )
        self.assertEqual(sum(len(c["questions"]) for c in self.cases), 70)

    def test_release_language_and_complete_english_reading_views(self):
        """Catch untranslated prose and missing sections, not certify legal quality."""
        case_view = (DATA.parent / "docs/CASES.md").read_text(encoding="utf-8")
        reference_view = (DATA.parent / "docs/REFERENCE_ANSWERS.md").read_text(encoding="utf-8")
        german_markers = re.compile(
            r"[äöüÄÖÜß]|\b(?:DSGVO|DSFA|Buchst|Begründe|benenne|"
            r"Einwilligung|Verarbeitung|Betroffenen|Verantwortliche|"
            r"Rechtsgrundlage|Auftragsverarbeiter|Widerruf|Nein)\b"
        )

        def strings(value):
            if isinstance(value, str):
                yield value
            elif isinstance(value, list):
                for item in value:
                    yield from strings(item)
            elif isinstance(value, dict):
                for item in value.values():
                    yield from strings(item)

        for record in self.cases + self.gold:
            self.assertEqual(record["provenance"]["language"], "en")
            self.assertEqual(record["provenance"]["release"], "2.0")
            for prose in strings(record):
                self.assertIsNone(german_markers.search(prose), prose)
        for case in self.cases:
            self.assertIn(case["title"], case_view)
            self.assertIn(case["scenario"], case_view)
            for item in case["scope"]["included"] + case["scope"]["excluded"] + case["missing_facts"]:
                self.assertIn(item, case_view)
            for question in case["questions"]:
                self.assertIn(question["prompt"], case_view)
                self.assertIn(question["prompt"], reference_view)
                self.assertTrue(question["prompt"].endswith("Explain your answer and identify the next steps."))
        for record in self.gold:
            for answer in record["answers"]:
                for field in ("conclusion", "reasoning", "required_points", "acceptable_alternatives", "missing_facts", "actions", "pitfalls"):
                    for prose in strings(answer[field]):
                        self.assertIn(prose, reference_view)
        for path in (DATA / "RULE_INPUTS.md", DATA.parent / "gdpr_bench/rules.py"):
            self.assertIsNone(german_markers.search(path.read_text(encoding="utf-8")), path)

    def test_translation_preserves_original_structured_semantics(self):
        # Baseline hashes independently calculated from the pre-translation corpus.
        # Exclude translated free prose and interest descriptions; preserve all typed
        # rule inputs, IDs, law subsets, decisions, review states and citation objects.
        case_semantics = [{
            "id": c["id"], "kind": c["kind"], "law_articles": c["law_articles"],
            "questions": [{
                "id": q["id"], "rule": q["rule"],
                "facts": {key: "<free text>" if key == "interest" else value
                          for key, value in q["facts"].items()},
            } for q in c["questions"]],
        } for c in self.cases]
        reference_semantics = [{
            "case_id": r["case_id"], "status": r["status"],
            "independent_review": r["independent_review"],
            "answers": [{key: a[key] for key in ("question_id", "decision", "legal_basis")}
                        for a in r["answers"]],
        } for r in self.gold]
        for values, expected in (
            (case_semantics, "415a52d0d44c13dfa73f41996a1967ae8d856ad1b39a0060b01925531394b255"),
            (reference_semantics, "a809c73a7a6e8720f7bc85f114ac72eb639553da054e6ebd27c6cb56a588618b"),
        ):
            digest = hashlib.sha256(json.dumps(values, sort_keys=True, separators=(",", ":")).encode()).hexdigest()
            self.assertEqual(digest, expected)

    def test_tags_identify_material_unknowns_not_incidental_nulls(self):
        questions = {f"{c['id']}/{q['id']}": q for c in self.cases for q in c["questions"]}
        # These inputs are material to the question's conclusion, unlike unknown
        # implementation details or fields superseded by an established legal route.
        material = {
            "C04/q4": {"effective_protection_assessed"},
            "C04/q5": {"monitoring_core_activity", "large_scale_monitoring"},
            "C05/q3": {"equally_effective_less_intrusive_option", "safeguards_in_place", "reasonable_expectation"},
            "C07/q4": {"equally_effective_less_intrusive_option", "safeguards_in_place", "reasonable_expectation"},
            "C08/q5": {"tested_restore"},
            "C09/q1": {"reasonable_expectation"},
        }
        actual = {key for key, q in questions.items() if "missing_information" in q["evaluation_tags"]}
        self.assertEqual(actual, set(material))
        for key, fields in material.items():
            for field in fields:
                self.assertIsNone(questions[key]["facts"][field], (key, field))
        for key in ("C07/q1", "C09/q4", "C10/q1"):
            self.assertIn(None, questions[key]["facts"].values())
            self.assertNotIn("missing_information", questions[key]["evaluation_tags"])
        for key in ("F01/q1", "F14/q1", "F18/q1", "C10/q3"):
            self.assertNotIn("missing_information", questions[key]["evaluation_tags"])

    def test_exception_tags_have_scenario_rationales_and_are_not_outcome_labels(self):
        case_view = (DATA.parent / "docs/CASES.md").read_text(encoding="utf-8")
        tagged = set()
        for case in self.cases:
            for question in case["questions"]:
                tags = question["evaluation_tags"]
                self.assertIsInstance(tags, list)
                self.assertEqual(len(tags), len(set(tags)))
                self.assertLessEqual(set(tags), {"exception_boundary", "missing_information"})
                key = f"{case['id']}/{question['id']}"
                for tag in tags:
                    self.assertIn(f"| {key} | `{tag}` | ", case_view)
                if "exception_boundary" in tags:
                    tagged.add(key)
                self.assertNotIn("evaluation_tags", question["facts"])
        # Matched contrasts cover opposite sides of specific legal boundaries.
        for positive, negative in (("C03/q5", "F07/q1"), ("C10/q1", "F18/q1"),
                                   ("F20/q1", "C07/q5"), ("C07/q2", "C09/q2"),
                                   ("F17/q1", "C01/q5"), ("C02/q3", "F15/q1")):
            self.assertIn(positive, tagged)
            self.assertIn(negative, tagged)
        # Clear ordinary applications are not automatically tagged merely because
        # every legal rule has conditions or because an answer is yes/no.
        for ordinary in ("F02/q1", "F06/q1", "F10/q1", "F13/q1", "C02/q1"):
            self.assertNotIn(ordinary, tagged)
        decisions = {a["decision"] for r in self.gold for a in r["answers"]
                     if f"{r['case_id']}/{a['question_id']}" in tagged}
        self.assertGreaterEqual(decisions, {"yes", "no", "unknown"})

    def test_gold_has_a_provisional_rubric_for_each_question(self):
        cases = {case["id"]: case for case in self.cases}
        self.assertEqual(Counter(record["case_id"] for record in self.gold), Counter(cases.keys()))
        for record in self.gold:
            case = cases[record["case_id"]]
            with self.subTest(case=case["id"]):
                self.assertEqual(record["status"], "provisional")
                self.assertEqual(
                    record["independent_review"],
                    {"status": "pending", "reviewer": None, "reviewed_at": None},
                )
                self.assertEqual(
                    Counter(answer["question_id"] for answer in record["answers"]),
                    Counter(question["id"] for question in case["questions"]),
                )
                for answer in record["answers"]:
                    self.assertIn(answer["decision"], DECISIONS)
                    self.assertTrue(answer["conclusion"].strip() and answer["reasoning"].strip())
                    self.assertGreaterEqual(len(set(answer["required_points"])), 2)
                    for field in ("actions", "acceptable_alternatives", "pitfalls"):
                        self.assertTrue(answer[field], field)
                    self.assertIsInstance(answer["missing_facts"], list)
                    self.assertTrue(answer["legal_basis"])
                    for citation in answer["legal_basis"]:
                        self.assertIn(citation["article"], case["law_articles"])
                        self.assertIsInstance(citation["paragraph"], str)
                        self.assertIsInstance(citation["point"], str)
                        self.assertTrue(citation["url"].startswith(ELI))

    def test_every_structured_citation_exists_in_frozen_official_gdpr(self):
        # This verifies locations, not whether the proposed legal interpretation is correct.
        source = ET.parse(DATA.parent / "sources/gdpr.xml")
        articles = {int(a.attrib["IDENTIFIER"]): a for a in source.findall(".//ARTICLE")}
        self.assertEqual(sum(len(a["legal_basis"]) for r in self.gold for a in r["answers"]), 293)
        for record in self.gold:
            for answer in record["answers"]:
                for citation in answer["legal_basis"]:
                    with self.subTest(case=record["case_id"], question=answer["question_id"], citation=citation):
                        node = articles[citation["article"]]
                        if citation["paragraph"]:
                            identifier = f"{citation['article']:03d}.{int(citation['paragraph']):03d}"
                            node = node.find(f".//PARAG[@IDENTIFIER='{identifier}']")
                            self.assertIsNotNone(node)
                        if citation["point"]:
                            labels = {"".join(p.itertext()).strip().strip("(). ") for p in node.findall(".//NO.P")}
                            self.assertIn(citation["point"], labels)


if __name__ == "__main__":
    unittest.main()
