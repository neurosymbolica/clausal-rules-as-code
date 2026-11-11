"""Local fixtures for matched extraction and accounting; never legal evidence."""
import json
import copy
import os
from pathlib import Path
import tempfile
import unittest
from unittest.mock import patch
from test_live_contract import CASE, ANSWER, config
from gdpr_bench.dataset import read_jsonl, load_cases
from gdpr_bench.fact_schema import validate_fact
from gdpr_bench.law import LawCorpus
from gdpr_bench.providers import Provider, build_request
from gdpr_bench.runner import run_experiment, validate_extraction

ROOT = Path(__file__).resolve().parents[1]


class ControlledPipelineTests(unittest.TestCase):
    def test_control_and_python_share_extraction_not_oracle_facts(self):
        cfg = config()
        def transport(url, headers, body):
            if body['messages'][0]['content'].startswith('Extract'):
                answer = {'questions': [{'id': 'q1', 'rule': 'territorial_scope', 'facts': {'eu_establishment_context': False}}]}
            else:
                answer = ANSWER
            return {'choices': [{'finish_reason': 'stop', 'message': {'content': json.dumps(answer)}}], 'usage': {'prompt_tokens': 50, 'completion_tokens': 20}}
        with tempfile.TemporaryDirectory() as td, patch.dict(os.environ, {'OPENAI_API_KEY': 'test-only-key'}):
            root = Path(td) / 'run'
            manifest = run_experiment(root, [CASE], LawCorpus(ROOT / 'sources'), ['llm_control','llm_python','llm_prolog'], config=cfg,
                                      live=True, max_cost_usd=2, provider=Provider(cfg, transport))
            rows = {r['arm']: r for r in read_jsonl(root / 'predictions.jsonl')}
            self.assertEqual(manifest['actual_api_calls'], 3)
            self.assertEqual(rows['llm_prolog']['status'], 'blocked')
            a,b = rows['llm_control'],rows['llm_python']
            self.assertEqual(a['extraction_sha256'], b['extraction_sha256'])
            self.assertEqual(a['calls'][0]['call_id'], b['calls'][0]['call_id'])
            self.assertEqual(a['calls'][-1]['request']['system'], b['calls'][-1]['request']['system'])
            prefix = lambda r: r['calls'][-1]['request']['prompt'].split('\n\nENGINE EVIDENCE\n')[0]
            self.assertEqual(prefix(a), prefix(b))
            self.assertNotEqual(b['engine_result']['prediction']['answers'][0]['decision'], 'yes')
            self.assertAlmostEqual(sum(r['billed_cost_usd'] for r in rows.values()), manifest['total_cost_usd'])
            self.assertGreater(a['cost_usd']+b['cost_usd'], manifest['total_cost_usd'])

    def test_openai_compatible_endpoint_and_token_field(self):
        cfg={'provider':'openai_compatible','model':'frozen-test-model','base_url':'http://127.0.0.1:8000/v1','max_output_tokens':42}
        url,headers,body=build_request(cfg,'system','prompt','')
        self.assertEqual(url,'http://127.0.0.1:8000/v1/chat/completions')
        self.assertEqual(body['max_tokens'],42)
        self.assertNotIn('Authorization',headers)
        for bad in ['http://remote.example/v1','https://user:pass@example.com/v1','https://example.com/v1?key=secret']:
            with self.subTest(bad=bad),self.assertRaises(ValueError):
                build_request(cfg|{'base_url':bad},'system','prompt','key')

    def test_schema_validates_nullable_facts_independently_of_oracle_values(self):
        for case in load_cases():
            for question in case['questions']:
                for name,value in question['facts'].items():
                    validate_fact(name,value)
        case=copy.deepcopy(CASE)
        case['questions'][0]['facts']['eu_establishment_context']=None
        for invalid in (float('nan'),{},'true',1):
            questions=[{'id':'q1','rule':'territorial_scope','facts':{'eu_establishment_context':invalid}}]
            with self.assertRaises(ValueError):validate_extraction(questions,case)

    def test_nonfinite_model_json_is_recorded_as_failed_with_cost_retained(self):
        cfg=config()
        case=copy.deepcopy(CASE)
        case['questions'][0]['facts']['eu_establishment_context']=None
        for numeric in ('NaN','Infinity','1e999'):
            def transport(url,headers,body):
                content='{"questions":[{"id":"q1","rule":"territorial_scope","facts":{"eu_establishment_context":'+numeric+'}}]}'
                return {'choices':[{'finish_reason':'stop','message':{'content':content}}],
                        'usage':{'prompt_tokens':50,'completion_tokens':20}}
            with self.subTest(numeric=numeric), tempfile.TemporaryDirectory() as td, patch.dict(os.environ,{'OPENAI_API_KEY':'test-only-key'}):
                result=run_experiment(Path(td)/'run',[case],LawCorpus(ROOT/'sources'),['llm_control'],config=cfg,
                                      live=True,max_cost_usd=2,provider=Provider(cfg,transport))
                self.assertEqual(result['counts']['failed'],1)
                self.assertEqual(result['actual_api_calls'],1)
                self.assertGreater(result['total_cost_usd'],0)
                row=read_jsonl(Path(td)/'run/predictions.jsonl')[0]
                self.assertNotIn('extracted_questions',row)
                self.assertIn(numeric,row['calls'][0]['text'])

    def test_nonfinite_provider_envelope_fails_without_breaking_accounting(self):
        cfg=config()
        with patch.dict(os.environ,{'OPENAI_API_KEY':'test-only-key'}):
            result=Provider(cfg,lambda *args:{'unexpected':float('nan')}).generate('system','prompt')
        self.assertEqual(result['status'],'failed')
        self.assertIsNone(result['cost_usd'])
        json.dumps(result,allow_nan=False)

    def test_returned_model_drift_marks_pipeline_failed_and_keeps_paid_calls(self):
        cfg=config()
        def transport(url,headers,body):
            extracting=body['messages'][0]['content'].startswith('Extract')
            value={'questions':[{'id':'q1','rule':'territorial_scope','facts':{'eu_establishment_context':True}}]} if extracting else ANSWER
            return {'model':'fixture-extraction-version' if extracting else 'fixture-answer-version',
                    'choices':[{'finish_reason':'stop','message':{'content':json.dumps(value)}}],
                    'usage':{'prompt_tokens':50,'completion_tokens':20}}
        with tempfile.TemporaryDirectory() as td,patch.dict(os.environ,{'OPENAI_API_KEY':'test-only-key'}):
            result=run_experiment(Path(td)/'run',[CASE],LawCorpus(ROOT/'sources'),['llm_control'],config=cfg,
                                  live=True,max_cost_usd=2,provider=Provider(cfg,transport))
            self.assertEqual(result['counts']['failed'],1)
            self.assertEqual(result['actual_api_calls'],2)
            row=read_jsonl(Path(td)/'run/predictions.jsonl')[0]
            self.assertEqual(len(row['resolved_models']),2)
            self.assertNotIn('prediction',row)


if __name__ == '__main__':
    unittest.main()
