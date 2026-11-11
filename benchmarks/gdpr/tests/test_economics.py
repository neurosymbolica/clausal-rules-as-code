import copy
import json
from pathlib import Path
import unittest
from gdpr_bench.economics import evaluate_economics, decision_report, REQUIRED_TARGETS

ROOT=Path(__file__).resolve().parents[1]


class EconomicsTests(unittest.TestCase):
    def inputs(self):
        return json.loads((ROOT/'config/economics.example.json').read_text())

    def test_illustrative_example_reconciles_and_does_not_validate_business(self):
        report=evaluate_economics(self.inputs())
        self.assertEqual(report['strategies']['baseline']['annual_cost_usd'],37200)
        self.assertEqual(report['strategies']['candidate']['annual_cost_usd'],34800)
        self.assertEqual(report['comparison']['cash_saving_usd'],2400)
        self.assertEqual(report['comparison']['cash_break_even_cases'],982)
        self.assertEqual(report['comparison']['quality_adjusted_break_even_cases'],848)
        self.assertEqual(report['H5']['status'],'not_evaluable')
        self.assertEqual(decision_report({'status':'not_evaluable'},report)['decision'],'inconclusive')

    def test_zero_or_unknown_quality_never_produces_division_or_positive_H5(self):
        for quality in (0,None):
            data=self.inputs();data['strategies']['candidate']['correct_rate']=quality
            result=evaluate_economics(data)
            self.assertIsNone(result['strategies']['candidate']['cost_per_correct_usd'])
            self.assertIsNone(result['comparison']['saving_per_correct_usd'])
            self.assertEqual(result['H5']['status'],'not_evaluable')

    def test_invalid_and_missing_costs_not_treated_as_free(self):
        data=self.inputs();data['strategies']['candidate']['per_case']['api_cost_usd']=None
        with self.assertRaises(ValueError):evaluate_economics(data)
        data=self.inputs();data['strategies']['candidate']['annual']['hosting_usd']=-1
        with self.assertRaises(ValueError):evaluate_economics(data)

    def test_error_loss_is_explicit_and_separate(self):
        data=self.inputs();data['strategies']['candidate']['error_risk']={'probability':.01,'loss_per_event_usd':1000}
        result=evaluate_economics(data)['strategies']['candidate']
        self.assertEqual(result['annual_cost_usd'],34800)
        self.assertEqual(result['risk_adjusted_annual_cost_usd'],46800)

    def test_rater_estimates_cannot_pass_final_decision_gate(self):
        report = {'status':'ok','targets':{'accuracy':{'status':'pass'}}}
        economics = {'H5':{'status':'pass'}}
        self.assertEqual(decision_report(report,economics)['decision'],'inconclusive')
        report['final_review_complete'] = True
        self.assertEqual(decision_report(report,economics)['decision'],'inconclusive')
        report.update(metric='human_accuracy',model_reports={str(i):{} for i in range(6)},
                      targets={name:{'status':'pass'} for name in REQUIRED_TARGETS})
        self.assertEqual(decision_report(report,economics)['decision'],'go_to_customer_pilot')

    def test_saved_report_preserves_evidence_and_assumptions(self):
        inputs=self.inputs()
        inputs['evidence_references']=['synthetic-fixture-only']
        result=evaluate_economics(inputs)
        self.assertEqual(result['input_assumptions'],inputs)
        self.assertEqual(result['evidence_references'],['synthetic-fixture-only'])
        self.assertEqual(len(result['input_sha256']),64)


if __name__=='__main__':unittest.main()
