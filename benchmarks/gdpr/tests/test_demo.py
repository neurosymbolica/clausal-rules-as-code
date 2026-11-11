import copy
import json
from pathlib import Path
import tempfile
import unittest
from unittest.mock import patch
from contextlib import redirect_stdout
import io
from contextlib import redirect_stderr

from gdpr_bench.dataset import load_cases
from gdpr_bench.demo import build_request, coverage_matrix, parse_result, project_decision, DemoClient, run_integration


CASES = {c['id']: c for c in load_cases()}


def wire(raw, kind='answer'):
    return '(book_result (kind ' + json.dumps(kind) + ') (headline "Live") (lines ["Live line"]) (cites []) (raw ' + json.dumps(raw) + ') (input "submitted") (reason_us 12) (expected (raw "DO NOT USE")))'


class DemoTests(unittest.TestCase):
    def test_absent_authority_decision_never_defaults_to_no_order(self):
        r = build_request(CASES['C02'], 'q2')
        self.assertNotIn('supervisory_authority_decision_on_communication', r['facts'])
        self.assertEqual(r['facts']['party_role'], 'controller')
        self.assertEqual(r['facts']['appropriate_protection_measures_applied_to_affected_data'], False)
        self.assertIn('C02.q3', r['fact_sources']['appropriate_protection_measures_applied_to_affected_data'])
        self.assertIn('hours_since_awareness', r['unmapped_source_fields'])
        self.assertEqual(r['assumptions'], [])

    def test_sensitivity_assumption_explicit(self):
        r = build_request(CASES['F15'], 'q1', assume_no_order=True)
        self.assertEqual(r['facts']['supervisory_authority_decision_on_communication'], 'no_decision')
        self.assertEqual(len(r['assumptions']), 1)
        self.assertTrue(r['facts']['appropriate_protection_measures_applied_to_affected_data'])

    def test_unknown_does_not_become_false(self):
        c = copy.deepcopy(CASES['F15'])
        c['questions'][0]['facts']['data_unintelligible'] = None
        c['questions'][0]['facts']['risk_assessment'] = None
        f = build_request(c, 'q1')['facts']
        self.assertNotIn('appropriate_protection_measures_applied_to_affected_data', f)
        self.assertNotIn('breach_unlikely_to_result_in_risk', f)
        self.assertNotIn('breach_likely_to_result_in_high_risk', f)

    def test_conflicting_same_incident_facts_fail(self):
        c = copy.deepcopy(CASES['C02'])
        c['questions'][2]['facts']['risk_assessment'] = 'unlikely'
        with self.assertRaises(ValueError): build_request(c, 'q2')

    def test_invalid_types_and_out_of_scope_fail(self):
        c = copy.deepcopy(CASES['F15'])
        c['questions'][0]['facts']['data_unintelligible'] = 'false'
        with self.assertRaises(ValueError): build_request(c, 'q1')
        with self.assertRaises(ValueError): build_request(CASES['C02'], 'q1')
        c = copy.deepcopy(CASES['F15']); c['questions'][0]['facts']['personal_data_breach'] = False
        with self.assertRaises(ValueError): build_request(c, 'q1')

    def test_matrix_covers_all_questions_but_only_eight_partial(self):
        rows = coverage_matrix(list(CASES.values()))
        self.assertEqual(len(rows), 70)
        self.assertEqual(sum(r['coverage'] == 'partial' for r in rows), 8)
        self.assertEqual({r['question_id'] for r in rows if r['case_id']=='C02' and r['coverage']=='partial'}, {'q2','q3'})
        self.assertTrue(all(r['full_answer_covered'] is False for r in rows))

    def test_parser_preserves_live_missing_and_ignores_recorded_answer(self):
        result = parse_result(wire('indeterminate([supervisory_authority_decision_on_communication])', 'missing'))
        self.assertNotIn('expected', result)
        self.assertEqual(result['kind'], 'missing')
        self.assertIsNone(project_decision(result, 'breach_authority')['decision'])
        for bad in [wire('[]')+' garbage', '(book_result (kind "answer") (kind "missing"))', '(book_result (raw "x")', '(__import__ "os")']:
            with self.assertRaises(ValueError): parse_result(bad)

    def test_public_communication_is_no_to_individual_only(self):
        r = parse_result(wire('[notify_supervisory_authority(cite(eu_reg_2016_679_art_33_1)),document_breach(cite(eu_reg_2016_679_art_33_5)),public_communication_or_similar_measure(cite(eu_reg_2016_679_art_34_3_c))]'))
        answer = project_decision(r, 'breach_communication')
        self.assertEqual(answer['decision'], 'no')
        self.assertEqual(answer['communication_route'], 'public_or_similar')
        self.assertTrue(answer['substitute_communication_required'])
        self.assertEqual(project_decision(r, 'breach_authority')['decision'], 'yes')

    def test_unknown_answer_shape_never_fabricates_decision(self):
        r = parse_result(wire('[novel_predicate(cite(foo))]'))
        with self.assertRaises(ValueError): project_decision(r, 'breach_authority')
        r = parse_result(wire('[no_communication_required(cite(eu_reg_2016_679_art_34_3_a)),communicate_to_data_subject(cite(eu_reg_2016_679_art_34_1))]'))
        with self.assertRaises(ValueError): project_decision(r, 'breach_communication')

    def test_held_out_notice_is_preserved_without_retry_or_answer(self):
        r = parse_result('(notice (text "This case is held out for benchmarking."))')
        self.assertEqual(r['kind'], 'held_out')
        self.assertIsNone(project_decision(r, 'breach_authority')['decision'])
        with self.assertRaises(ValueError): parse_result('(notice (text "Something changed"))')

    def test_absent_communication_output_is_not_inferred_from_authority_exemption(self):
        r = parse_result(wire('[no_notification_required(cite(eu_reg_2016_679_art_33_1)),document_breach(cite(eu_reg_2016_679_art_33_5))]'))
        self.assertEqual(project_decision(r,'breach_authority')['decision'],'no')
        self.assertIsNone(project_decision(r,'breach_communication')['decision'])
        self.assertEqual(project_decision(r,'breach_communication')['status'],'not_returned')

    def test_url_validation_and_redirects(self):
        for url in ['http://example.com','https://user:secret@example.com','https://example.com/?token=x','file:///tmp/x','https://example.com/wrong']:
            with self.assertRaises(ValueError): DemoClient(url)
        DemoClient('http://127.0.0.1:8987')
        from urllib.request import Request
        from urllib.error import HTTPError
        from gdpr_bench.demo import NoRedirect
        with self.assertRaises(HTTPError):
            try:
                NoRedirect().redirect_request(Request('https://example.com'), None, 302, 'Moved', {}, 'https://elsewhere.test')
            except HTTPError as exc:
                exc.close()
                raise

    def test_cli_coverage_and_offline_gate(self):
        from gdpr_bench.cli import main
        with tempfile.TemporaryDirectory() as d, redirect_stdout(io.StringIO()), redirect_stderr(io.StringIO()):
            out = Path(d)/'matrix.json'
            self.assertEqual(main(['demo-coverage','--out',str(out)]),0)
            self.assertEqual(len(json.loads(out.read_text())),70)
            with patch.dict('os.environ', {'GDPR_DEMO_BASE_URL':'http://127.0.0.1:8987'}):
                self.assertEqual(main(['demo-run','--out',str(Path(d)/'run')]),2)
                self.assertFalse((Path(d)/'run').exists())

    def test_offline_requires_explicit_live_and_no_output_overwrite(self):
        with tempfile.TemporaryDirectory() as d:
            out = Path(d)/'run'
            with patch.object(DemoClient, 'prepare', side_effect=AssertionError('must not access network')):
                with self.assertRaises(ValueError): run_integration(out, 'http://127.0.0.1:8987', live=False)
            out.mkdir()
            with self.assertRaises(FileExistsError): run_integration(out, 'http://127.0.0.1:8987', live=True)

if __name__ == '__main__': unittest.main()

class DemoTransportTests(unittest.TestCase):
    def test_malformed_http_is_recorded_not_left_as_empty_run(self):
        from http.client import BadStatusLine, IncompleteRead
        for exc in (BadStatusLine('bad status'), IncompleteRead(b'partial', 100)):
            with tempfile.TemporaryDirectory() as d, patch('urllib.request.OpenerDirector.open',side_effect=exc):
                m=run_integration(Path(d)/'run','http://127.0.0.1:8987',live=True)
                self.assertEqual(m['status'],'incomplete')
                self.assertEqual(m['counts']['strict_source']['blocked'],8)
                self.assertTrue((Path(d)/'run'/'manifest.json').is_file())

    def test_effective_inputs_must_match_without_duplicates(self):
        from gdpr_bench.demo import validate_effective_input
        facts={'party_role':'controller','breach_unlikely_to_result_in_risk':False}
        result={'kind':'answer','input':'[[attribute(breach_unlikely_to_result_in_risk,false),attribute(party_role,controller)]]'}
        validate_effective_input(result,facts)
        for raw in ('[[attribute(party_role,processor)]]', '[[attribute(party_role,controller),attribute(party_role,controller)]]', '[[attribute(party_role,controller)]]', None):
            with self.assertRaises(ValueError): validate_effective_input({'kind':'answer','input':raw},facts)
        validate_effective_input({'kind':'held_out'},facts)

    def test_real_http_session_evidence_and_schema_drift(self):
        from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
        from threading import Thread
        from urllib.parse import parse_qs
        from gdpr_bench.demo import parse_result
        fields = {
            'party_role':['controller','processor'],
            'breach_unlikely_to_result_in_risk':['true','false','unsure'],
            'breach_likely_to_result_in_high_risk':['true','false','unsure'],
            'supervisory_authority_decision_on_communication':['no_decision','required_communication'],
            'appropriate_protection_measures_applied_to_affected_data':['true','false','unsure'],
            'subsequent_measures_ensure_high_risk_no_longer_likely':['true','false','unsure'],
            'communication_would_involve_disproportionate_effort':['true','false','unsure'],
        }
        received=[]
        class Handler(BaseHTTPRequestHandler):
            corrupt_input=False
            def log_message(self, *args): pass
            def do_GET(self):
                html='<meta name="csrf-token" content="TEST_CSRF_NOT_FOR_PUBLICATION"><meta name="lr-base" content="/demo/">'
                html+='<form id="book-form" data-book="breach" data-case="NOT-2569" data-query="notification_obligation">'
                for key,values in fields.items():
                    html+=f'<select name="f:{key}">'+''.join(f'<option value="{v}">{v}</option>' for v in values)+'</select>'
                html+='</form>'
                self.send_response(200);self.send_header('Set-Cookie','demo_session=TEST_COOKIE_NOT_FOR_PUBLICATION; Path=/');self.end_headers();self.wfile.write(html.encode())
            def do_POST(self):
                if self.headers.get('X-CSRFToken')!='TEST_CSRF_NOT_FOR_PUBLICATION' or 'demo_session=' not in self.headers.get('Cookie',''):
                    self.send_error(403);return
                data=parse_qs(self.rfile.read(int(self.headers['Content-Length'])).decode());received.append(data)
                self.send_response(200);self.end_headers()
                facts=json.loads(data['facts'][0])
                if self.corrupt_input:
                    facts={'party_role':'processor'}
                terms=[f"attribute({k},{'true' if v is True else 'false' if v is False else v})" for k,v in facts.items()]
                response=wire('indeterminate([supervisory_authority_decision_on_communication])','missing').replace('"submitted"',json.dumps('[['+','.join(terms)+']]'))
                self.wfile.write(response.encode())
        server=ThreadingHTTPServer(('127.0.0.1',0),Handler)
        thread=Thread(target=server.serve_forever,daemon=True);thread.start()
        try:
            base=f'http://127.0.0.1:{server.server_port}'
            client=DemoClient(base);client.prepare()
            receipt=client.run(build_request(CASES['C02'],'q2'))
            self.assertEqual(parse_result(receipt['response_text'])['kind'],'missing')
            self.assertEqual(len(receipt['response_sha256']),64)
            sent=json.loads(received[-1]['facts'][0])
            self.assertNotIn('supervisory_authority_decision_on_communication',sent)
            self.assertEqual(received[-1]['arguments'],['{}'])
            self.assertEqual(set(received[-1]),{'book','case','query','facts','arguments'})
            with tempfile.TemporaryDirectory() as d:
                out=Path(d)/'run'
                m=run_integration(out,base,live=True,include_sensitivity=True)
                self.assertEqual(m['status'],'completed')
                self.assertEqual(m['counts']['strict_source']['missing'],8)
                self.assertEqual(m['counts']['assume_no_authority_decision']['requests'],8)
                self.assertFalse(m['benchmark_eligible'])
                self.assertEqual(len((out/'observations.jsonl').read_text().splitlines()),16)
                evidence=''.join(p.read_text() for p in out.iterdir())
                for private in ('TEST_CSRF_NOT_FOR_PUBLICATION','TEST_COOKIE_NOT_FOR_PUBLICATION',base,'DO NOT USE'):
                    self.assertNotIn(private,evidence)
                self.assertFalse((out/'predictions.jsonl').exists())
                self.assertTrue(all(json.loads(line)['effective_input_verified'] for line in (out/'observations.jsonl').read_text().splitlines()))
                Handler.corrupt_input=True
                mismatch=Path(d)/'mismatch'
                bad=run_integration(mismatch,base,live=True)
                self.assertEqual(bad['counts']['strict_source']['failed'],8)
                self.assertEqual(bad['counts']['strict_source']['answered'],0)
                self.assertEqual(bad['status'],'incomplete')
                self.assertTrue(all(json.loads(line)['response_sha256'] for line in (mismatch/'observations.jsonl').read_text().splitlines()))
            fields.pop('party_role')
            with self.assertRaises(ValueError): client.prepare()
        finally:
            server.shutdown();server.server_close();thread.join()

    def test_connection_failure_keeps_all_eight_blocked(self):
        with tempfile.TemporaryDirectory() as d:
            with patch.object(DemoClient,'prepare',side_effect=ValueError('Demo unavailable')):
                m=run_integration(Path(d)/'run','http://127.0.0.1:8987',live=True)
            self.assertEqual(m['counts']['strict_source']['blocked'],8)
            self.assertEqual(m['counts']['strict_source']['requests'],0)
            self.assertEqual(m['status'],'incomplete')
