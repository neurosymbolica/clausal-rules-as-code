import contextlib
import io
import json
from pathlib import Path
import tempfile
import unittest
from gdpr_bench.cli import main, check_run_gold
from gdpr_bench.dataset import ROOT, load_cases, read_jsonl, write_jsonl, sha256
from gdpr_bench.runner import run_experiment
from gdpr_bench.law import LawCorpus
from gdpr_bench.matrix import evaluation_matrix


class MatrixCliTests(unittest.TestCase):
    def test_exact_complete_registration_without_fabricated_scores(self):
        config = json.loads((ROOT / 'config/models.example.json').read_text())
        rows = evaluation_matrix(load_cases(), config, LawCorpus(ROOT / 'sources'))
        self.assertEqual(len(rows), 870)
        self.assertEqual(len({(r['candidate'], r['arm']) for r in rows}), 29)
        self.assertTrue(all(r['score'] is None and r['execution_status'] == 'not_run' for r in rows))
        self.assertEqual(sum(r['readiness'] == 'available' for r in rows), 30)
        self.assertTrue(all(r['readiness'] == 'blocked' for r in rows if 'prolog' in r['arm']))

    def test_economics_and_matrix_commands_write_reviewable_outputs(self):
        with tempfile.TemporaryDirectory() as tmp, contextlib.redirect_stdout(io.StringIO()):
            econ = Path(tmp) / 'economics.json'
            matrix = Path(tmp) / 'matrix.json'
            self.assertEqual(main(['economics', '--out', str(econ)]), 0)
            self.assertEqual(main(['matrix', '--out', str(matrix)]), 0)
            self.assertEqual(json.loads(econ.read_text())['H5']['status'], 'not_evaluable')
            self.assertEqual(len(json.loads(matrix.read_text())), 870)

    def test_pending_product_cli_never_invents_an_answer(self):
        with tempfile.TemporaryDirectory() as tmp, contextlib.redirect_stdout(io.StringIO()):
            packet, run = Path(tmp) / 'packet', Path(tmp) / 'imported'
            self.assertEqual(main(['product-export', '--product', 'harvey', '--out', str(packet)]), 0)
            self.assertEqual(main(['product-import', str(packet), str(packet / 'responses.jsonl'), '--out', str(run)]), 0)
            manifest = json.loads((run / 'manifest.json').read_text())
            self.assertEqual(manifest['counts'], {'ok': 0, 'blocked': 30, 'failed': 0})

    def test_matrix_rejects_changed_model_and_preserves_actual_execution_identity(self):
        config = json.loads((ROOT / 'config/models.example.json').read_text())
        cases, law = load_cases(), LawCorpus(ROOT / 'sources')
        cell = evaluation_matrix(cases, config, law)[0]
        row = dict(case_id=cell['case_id'], arm='llm_text', model_slot='openai', repeat=0,
                   provider='openai', model='fixture-executed-model', config_sha256='a'*64,
                   case_sha256=cell['case_sha256'], law_sha256=cell['law_sha256'], status='ok')
        with tempfile.TemporaryDirectory() as tmp:
            p = Path(tmp)
            (p/'manifest.json').write_text('{}')
            (p/'predictions.jsonl').write_text(json.dumps(row)+'\n')
            executed = evaluation_matrix(cases,config,law,run_dirs=[p])[0]
            self.assertEqual(executed['executed_model'],'fixture-executed-model')
            self.assertEqual(executed['executed_config_sha256'],'a'*64)
            config['models']['openai']['model'] = 'different-configured-model'
            with self.assertRaises(ValueError):evaluation_matrix(cases,config,law,run_dirs=[p])

    def test_blind_cli_rejects_different_law_even_when_run_hash_is_consistent(self):
        with tempfile.TemporaryDirectory() as tmp:
            run=Path(tmp)/'run'
            run_experiment(run,load_cases()[:1],LawCorpus(ROOT/'sources'),['python_rules'])
            check_run_gold(run)
            rows=read_jsonl(run/'predictions.jsonl')
            rows[0]['law_sha256']='f'*64
            write_jsonl(run/'predictions.jsonl',rows)
            manifest=json.loads((run/'manifest.json').read_text())
            manifest['predictions_sha256']=sha256(run/'predictions.jsonl')
            (run/'manifest.json').write_text(json.dumps(manifest))
            with self.assertRaisesRegex(ValueError,'Run law differs'):check_run_gold(run)


if __name__ == '__main__':
    unittest.main()
