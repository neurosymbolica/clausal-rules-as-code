import json
from pathlib import Path
import tempfile
import unittest
from gdpr_bench.dataset import read_jsonl, write_jsonl
from gdpr_bench.law import LawCorpus
from gdpr_bench.products import export_product, import_product
from test_live_contract import CASE

ROOT=Path(__file__).resolve().parents[1]


class ProductExchangeTests(unittest.TestCase):
    def test_pending_export_import_is_blocked_without_fake_answers(self):
        with tempfile.TemporaryDirectory() as td:
            p=Path(td)
            export_product(p/'export','harvey',[CASE],LawCorpus(ROOT/'sources'))
            m=import_product(p/'export',p/'export/responses.jsonl',p/'run',[CASE])
            row=read_jsonl(p/'run/predictions.jsonl')[0]
            self.assertEqual(row['status'],'blocked')
            self.assertNotIn('prediction',row)
            self.assertEqual(m['counts']['blocked'],1)
            prompt=(p/'export/prompts/F01.txt').read_text()
            self.assertNotIn('eu_establishment_context',prompt)

    def test_actual_operator_text_retained_and_sources_checked(self):
        with tempfile.TemporaryDirectory() as td:
            p=Path(td)
            export_product(p/'export','legora',[CASE],LawCorpus(ROOT/'sources'))
            responses=read_jsonl(p/'export/responses.jsonl')
            responses[0].update(status='ok',response_text='Operator-supplied test fixture answer.',operator='fixture-operator',product_version='fixture-version',
                                captured_at='2026-11-06T12:00:00+00:00',source_control='controlled_inputs',submitted_prompt=(p/'export/prompts/F01.txt').read_text(),
                                session_id='fixture-session',feature_settings='fixture retrieval disabled')
            write_jsonl(p/'filled.jsonl',responses)
            m=import_product(p/'export',p/'filled.jsonl',p/'run',[CASE])
            row=read_jsonl(p/'run/predictions.jsonl')[0]
            self.assertEqual(row['prediction'],{'text':'Operator-supplied test fixture answer.'})
            self.assertIsNone(row['cost_usd'])
            self.assertEqual(row['arm'],'product:legora')
            (p/'export/prompts/F01.txt').write_text('tampered')
            with self.assertRaises(ValueError):
                import_product(p/'export',p/'filled.jsonl',p/'bad',[CASE])
            self.assertFalse((p/'bad').exists())

    def test_controlled_input_claim_requires_exact_submitted_prompt(self):
        with tempfile.TemporaryDirectory() as td:
            p=Path(td)
            export_product(p/'export','noxtua',[CASE],LawCorpus(ROOT/'sources'))
            responses=read_jsonl(p/'export/responses.jsonl')
            responses[0].update(status='ok',response_text='fixture',operator='fixture',product_version='fixture',captured_at='2026-11-06T12:00:00+00:00',
                                source_control='controlled_inputs',submitted_prompt='different',session_id='fixture',feature_settings='fixture')
            write_jsonl(p/'filled.jsonl',responses)
            with self.assertRaises(ValueError):
                import_product(p/'export',p/'filled.jsonl',p/'bad',[CASE])

    def test_failed_capture_retains_attempt_evidence_and_cost_without_prediction(self):
        with tempfile.TemporaryDirectory() as td:
            p=Path(td)
            export_product(p/'export','harvey',[CASE],LawCorpus(ROOT/'sources'))
            responses=read_jsonl(p/'export/responses.jsonl')
            responses[0].update(status='failed',response_text='Synthetic refusal fixture',operator='fixture',
                                product_version='fixture-version',captured_at='2026-11-06T12:00:00+00:00',
                                submitted_prompt=(p/'export/prompts/F01.txt').read_text(),source_control='controlled_inputs',
                                incremental_cost_usd=1.25,elapsed_seconds=12,reason='Synthetic refusal fixture')
            write_jsonl(p/'filled.jsonl',responses)
            import_product(p/'export',p/'filled.jsonl',p/'run',[CASE])
            row=read_jsonl(p/'run/predictions.jsonl')[0]
            self.assertEqual(row['status'],'failed')
            self.assertEqual(row['cost_usd'],1.25)
            self.assertEqual(row['latency_seconds'],12)
            self.assertEqual(row['raw_response_text'],'Synthetic refusal fixture')
            self.assertEqual(row['product_capture']['operator'],'fixture')
            self.assertNotIn('prediction',row)
            self.assertEqual((p/'run/capture.source.jsonl').read_bytes(),(p/'filled.jsonl').read_bytes())


if __name__=='__main__':unittest.main()
