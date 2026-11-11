import unittest
from gdpr_bench.rules import evaluate, add_months, answer_case


class RuleTests(unittest.TestCase):
    def test_scope_unknown_not_false(self):
        self.assertEqual(evaluate("territorial_scope", {"eu_establishment_context": None, "offers_to_people_in_eu": False, "monitors_behaviour_in_eu": False})[0], "unknown")
        self.assertEqual(evaluate("territorial_scope", {"eu_establishment_context": True})[0], "yes")

    def test_breach_deadline_does_not_extinguish_duty(self):
        for hours in [0, 72, 73, 1000]:
            self.assertEqual(evaluate("breach_authority", {"personal_data_breach": True, "risk_assessment": "risk", "hours_since_awareness": hours})[0], "yes")

    def test_authority_and_individual_thresholds_differ(self):
        facts = {"personal_data_breach": True, "risk_assessment": "risk"}
        self.assertEqual(evaluate("breach_authority", facts)[0], "yes")
        self.assertEqual(evaluate("breach_communication", facts)[0], "no")

    def test_encryption_exception_requires_known_protection(self):
        facts = {"personal_data_breach": True, "risk_assessment": "high", "data_unintelligible": None, "later_measures_avert_high_risk": False, "individual_contact_disproportionate": False}
        self.assertEqual(evaluate("breach_communication", facts)[0], "unknown")
        facts["data_unintelligible"] = True
        self.assertEqual(evaluate("breach_communication", facts)[0], "no")

    def test_calendar_month_not_30_days(self):
        self.assertEqual(str(add_months("2027-01-31", 1)), "2027-02-28")
        f = {"received_date": "2026-01-15", "proposed_response_date": "2026-02-15"}
        self.assertEqual(evaluate("rights_deadline", f)[0], "yes")
        f["proposed_response_date"] = "2026-02-16"
        f.update(complex_or_numerous=False, notice_explains_delay=True, extension_notice_date="2026-02-01")
        self.assertEqual(evaluate("rights_deadline", f)[0], "no")

    def test_erasure_retention_exception(self):
        self.assertEqual(evaluate("erasure", {"purpose_ended": True, "statutory_retention": True})[0], "no")

    def test_fine_higher_not_lower_and_exact_boundary(self):
        f = {"infringed_articles": [6], "worldwide_prior_year_turnover_eur": 1000000000, "proposed_fine_eur": 40000000}
        self.assertEqual(evaluate("fine_cap", f)[0], "yes")
        f["proposed_fine_eur"] += 1
        self.assertEqual(evaluate("fine_cap", f)[0], "no")

    def test_bad_boolean_not_coerced(self):
        with self.assertRaises(ValueError):
            evaluate("territorial_scope", {"eu_establishment_context": "false"})

    def test_rule_not_case_id_controls_output(self):
        case = {"id": "F01", "questions": [{"id": "q1", "rule": "direct_marketing_objection", "facts": {"direct_marketing": True, "objection_received": True}}]}
        one = answer_case(case)
        case["id"] = "UNSEEN"
        self.assertEqual(one, answer_case(case))
        case["questions"][0]["facts"]["objection_received"] = False
        self.assertNotEqual(one, answer_case(case))


if __name__ == "__main__":
    unittest.main()
