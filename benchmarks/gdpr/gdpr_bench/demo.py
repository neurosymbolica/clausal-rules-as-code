"""Exploratory demo bridge. Never supplies a reviewed Prolog benchmark arm.

Uses the form contract observed on 2026-11-09. Remote rule source/version and
legal correctness remain unverified. Only operator-supplied synthetic facts
are sent; template answers and provisional gold never enter requests.
"""
import csv
from datetime import datetime, timezone
import hashlib
from html.parser import HTMLParser
from http.cookiejar import CookieJar
from http.client import HTTPException
import ipaddress
import json
from pathlib import Path
import re
import time
from urllib.error import HTTPError, URLError
from urllib.parse import urlencode, urlsplit
from urllib.request import build_opener, HTTPCookieProcessor, HTTPRedirectHandler, ProxyHandler, Request

from .dataset import ROOT, digest_json, load_cases, load_gold, sha256, write_json, write_jsonl
from .fact_schema import validate_fact

PILOT = {'F14': ('q1',), 'F15': ('q1',), 'C02': ('q2', 'q3'), 'C09': ('q4', 'q5'), 'C10': ('q3', 'q4')}
RULES = {'breach_authority', 'breach_communication'}
FIELD_MAP = {
    'data_unintelligible': 'appropriate_protection_measures_applied_to_affected_data',
    'later_measures_avert_high_risk': 'subsequent_measures_ensure_high_risk_no_longer_likely',
    'individual_contact_disproportionate': 'communication_would_involve_disproportionate_effort',
}
PAGE = '/demo/books/breach/NOT-2569/'
ENDPOINT = '/demo/api/books/run'
QUERY = 'notification_obligation'
MAX_BYTES = 2_000_000
LIMIT = 'Duty projection only; timing, notification content, reasoning completeness and next steps are not evaluated.'


def now():
    return datetime.now(timezone.utc).isoformat()


def build_request(case, question_id, *, assume_no_order=False):
    if question_id not in PILOT.get(case['id'], ()):
        raise ValueError('Subquestion outside the registered eight-question integration pilot')
    question = next(q for q in case['questions'] if q['id'] == question_id)
    if question['rule'] not in RULES:
        raise ValueError('Unsupported source rule')
    merged, sources = {}, {}
    # The combined remote query needs both duties. Same-incident sibling facts
    # are disclosed as such, never copied from the demo's selected example.
    for q in case['questions']:
        if q['rule'] not in RULES:
            continue
        for key, value in q['facts'].items():
            validate_fact(key, value)
            if value is None:
                continue
            if key in merged and merged[key] != value:
                raise ValueError('Conflicting source facts within one incident')
            merged[key] = value
            sources.setdefault(key, []).append(f"{case['id']}.{q['id']}")
    if merged.get('personal_data_breach') is not True:
        raise ValueError('Remote book presupposes an established personal data breach')
    facts = {'party_role': 'controller'}
    provenance = {'party_role': ['case narrative: controller role interpretation, review pending']}
    risk = merged.get('risk_assessment')
    if risk is not None:
        facts['breach_unlikely_to_result_in_risk'] = risk == 'unlikely'
        facts['breach_likely_to_result_in_high_risk'] = risk == 'high'
        for key in ('breach_unlikely_to_result_in_risk', 'breach_likely_to_result_in_high_risk'):
            provenance[key] = sources['risk_assessment']
    for source, target in FIELD_MAP.items():
        if source in merged:
            facts[target] = merged[source]
            provenance[target] = sources[source]
    assumptions = []
    if assume_no_order:
        facts['supervisory_authority_decision_on_communication'] = 'no_decision'
        assumptions.append('No supervisory-authority decision on communication; NOT stated in the source case. Sensitivity scenario only.')
        provenance['supervisory_authority_decision_on_communication'] = ['explicit sensitivity assumption']
    return {'book': 'breach', 'case': 'NOT-2569', 'query': QUERY, 'facts': facts, 'arguments': {},
            'fact_sources': provenance, 'assumptions': assumptions,
            'unmapped_source_fields': ['hours_since_awareness'] if 'hours_since_awareness' in question['facts'] else [],
            'preconditions': ['Established personal data breach', 'Controller role interpreted from synthetic scenario'],
            'coverage': 'partial', 'limitations': [LIMIT, 'Risk and exception assessments are supplied facts, not engine-derived legal judgements.']}


def coverage_matrix(cases):
    rows = []
    for c in cases:
        for q in c['questions']:
            selected = q['id'] in PILOT.get(c['id'], ())
            rows.append({'case_id': c['id'], 'question_id': q['id'], 'rule': q['rule'],
                         'coverage': 'partial' if selected else 'not_mapped', 'full_answer_covered': False,
                         'remote_query': QUERY if selected else None,
                         'projection': ('authority_notification_duty' if q['rule']=='breach_authority' else 'individual_communication_duty') if selected else None,
                         'missing_context': 'supervisory_authority_decision_on_communication' if selected else None,
                         'limitation': LIMIT if selected else 'No mapping implemented; no claim about all capabilities of the remote engine.',
                         'legal_review': 'pending', 'benchmark_eligible': False})
    return rows


def write_coverage(path, cases=None):
    path = Path(path)
    if path.exists():
        raise FileExistsError('Coverage output already exists')
    path.parent.mkdir(parents=True, exist_ok=True)
    rows = coverage_matrix(load_cases() if cases is None else cases)
    if path.suffix == '.csv':
        with path.open('w', encoding='utf-8', newline='') as f:
            writer = csv.DictWriter(f, fieldnames=list(rows[0]))
            writer.writeheader(); writer.writerows(rows)
    else:
        write_json(path, rows)
    return {'subquestions': len(rows), 'partially_mapped': sum(r['coverage']=='partial' for r in rows), 'full_answers_covered': 0}


# Parse the demo's data-only S-expression wire format. Never eval or execute it.
_TOKEN = re.compile(r'\s*(\(|\)|\[|\]|"(?:\\.|[^"\\])*"|[^\s()\[\]"]+)')


def parse_result(text):
    if len(text.encode()) > MAX_BYTES:
        raise ValueError('Oversized remote response')
    tokens, pos = [], 0
    while pos < len(text):
        match = _TOKEN.match(text, pos)
        if not match:
            if not text[pos:].strip():
                break
            raise ValueError('Malformed response token')
        tokens.append(match.group(1)); pos = match.end()
    index = 0
    def parse(depth=0):
        nonlocal index
        if depth > 40 or index >= len(tokens):
            raise ValueError('Invalid response nesting')
        token = tokens[index]; index += 1
        if token in ('(', '['):
            end = ')' if token == '(' else ']'
            values = []
            while index < len(tokens) and tokens[index] != end:
                values.append(parse(depth+1))
            if index >= len(tokens):
                raise ValueError('Unclosed response')
            index += 1
            return values
        if token in (')', ']'):
            raise ValueError('Unexpected closing delimiter')
        if token.startswith('"'):
            return json.loads(token)
        if re.fullmatch(r'-?\d+', token):
            return int(token)
        return token
    tree = parse()
    if index == len(tokens) and tree == ['notice', ['text', 'This case is held out for benchmarking.']]:
        return {'kind':'held_out', 'headline':'This case is held out for benchmarking.', 'lines':[], 'raw':''}
    if index != len(tokens) or not isinstance(tree, list) or not tree or tree[0] != 'book_result':
        raise ValueError('Unexpected response envelope')
    fields = {}
    for field in tree[1:]:
        if not isinstance(field, list) or len(field)<2 or not isinstance(field[0], str) or field[0] in fields:
            raise ValueError('Invalid or duplicate response field')
        fields[field[0]] = field[1] if len(field)==2 else field[1:]
    for key in ('kind', 'headline', 'raw'):
        if not isinstance(fields.get(key), str):
            raise ValueError('Missing response field')
    if not isinstance(fields.get('lines'), list) or not all(isinstance(x,str) for x in fields['lines']):
        raise ValueError('Invalid response lines')
    # Do not export or score the demo template's recorded answer (expected).
    allowed = ('kind','headline','lines','relied','cites','readings','raw','input','ms','load_ms','reason_us','why_us','question','why')
    return {k: fields[k] for k in allowed if k in fields}


def project_decision(result, rule):
    if rule not in RULES:
        raise ValueError('Unsupported projection')
    if result['kind'] in ('missing','referral','held_out'):
        return {'decision': None, 'status': result['kind'], 'communication_route': None, 'substitute_communication_required': None}
    if result['kind'] != 'answer':
        raise ValueError('Unrecognised demo result kind')
    raw = result['raw']
    # Only a list of known duty(cite(identifier)) terms is supported. Fail closed
    # on new wire semantics rather than derive yes/no from English or gold.
    term = r'[a-z_]+\(cite\([a-z0-9_]+\)\)'
    if not re.fullmatch(r'\['+term+r'(?:,'+term+r')*\]', raw):
        raise ValueError('Unsupported duty response syntax')
    actions = re.findall(r'([a-z_]+)\(cite\(', raw)
    allowed = {'notify_supervisory_authority','no_notification_required','document_breach',
               'communicate_to_data_subject','no_communication_required','public_communication_or_similar_measure'}
    if set(actions)-allowed or len(actions)!=len(set(actions)):
        raise ValueError('Unknown or duplicate duty in response')
    authority = set(actions) & {'notify_supervisory_authority','no_notification_required'}
    comm = set(actions) & {'communicate_to_data_subject','no_communication_required','public_communication_or_similar_measure'}
    if len(authority)>1 or len(comm)>1:
        raise ValueError('Incomplete or contradictory duty result')
    target = authority if rule=='breach_authority' else comm
    if not target:
        return {'decision':None, 'status':'not_returned', 'communication_route':None,
                'substitute_communication_required':None, 'actions':actions}
    route = {'communicate_to_data_subject':'individual','no_communication_required':'exempt',
             'public_communication_or_similar_measure':'public_or_similar'}.get(next(iter(comm),None))
    decision = ('yes' if 'notify_supervisory_authority' in authority else 'no') if rule=='breach_authority' else ('yes' if route=='individual' else 'no')
    return {'decision': decision, 'status':'answered_projection', 'communication_route':route,
            'substitute_communication_required':None if route is None else route=='public_or_similar', 'actions':actions}


def validate_effective_input(result, facts):
    """Check the engine's echoed attributes; template defaults cannot go unnoticed."""
    if result['kind'] == 'held_out':
        return  # The protected response intentionally supplies no effective input.
    raw = result.get('input')
    attribute = r'attribute\(([a-z_]+),([a-z_]+)\)'
    if not isinstance(raw, str) or not re.fullmatch(r'\[\['+attribute+r'(?:,'+attribute+r')*\]\]',raw):
        raise ValueError('Missing or unsupported effective input from demo')
    pairs = re.findall(attribute,raw)
    echoed = dict(pairs)
    expected = {k:'true' if v is True else 'false' if v is False else v for k,v in facts.items()}
    if len(echoed)!=len(pairs) or echoed!=expected:
        raise ValueError('Demo effective input differs from submitted facts')


class NoRedirect(HTTPRedirectHandler):
    def redirect_request(self, req, fp, code, msg, headers, newurl):
        raise HTTPError(req.full_url, code, 'Redirect refused', headers, fp)


class FormContract(HTMLParser):
    def __init__(self):
        super().__init__(); self.csrf=None; self.base=None; self.form=None; self.fields={}; self.active=False; self.select=None
    def handle_starttag(self, tag, attrs):
        d=dict(attrs)
        if tag=='meta' and d.get('name')=='csrf-token': self.csrf=d.get('content')
        if tag=='meta' and d.get('name')=='lr-base': self.base=d.get('content')
        if tag=='form' and d.get('id')=='book-form':
            self.active=True; self.form={k:d.get('data-'+k) for k in ('book','case','query')}
        if self.active and tag in ('input','select') and d.get('name','').startswith('f:'):
            key=d['name'][2:]; self.fields.setdefault(key,[])
            if tag=='select': self.select=key
            elif d.get('value'): self.fields[key].append(d['value'])
        if self.active and tag=='option' and self.select and d.get('value'):
            self.fields[self.select].append(d['value'])
    def handle_endtag(self, tag):
        if tag=='form': self.active=False
        if tag=='select': self.select=None
    def public(self):
        return {'base':self.base,'form':self.form,'fields':self.fields}


class DemoClient:
    def __init__(self, base_url, *, timeout=20):
        p=urlsplit(base_url)
        if p.scheme not in ('http','https') or not p.hostname or p.username or p.password or p.query or p.fragment or p.path not in ('','/'):
            raise ValueError('Use an origin-only demo URL without credentials, path or query')
        if p.scheme=='http':
            try:
                ip=ipaddress.ip_address(p.hostname)
                permitted=ip.is_loopback or ip in ipaddress.ip_network('100.64.0.0/10')
            except ValueError:
                permitted=p.hostname=='localhost'
            if not permitted:
                raise ValueError('HTTP is restricted to loopback or the authorized Tailscale address range')
        self.origin=base_url.rstrip('/'); self.timeout=timeout
        self.opener=build_opener(ProxyHandler({}), NoRedirect(), HTTPCookieProcessor(CookieJar()))
        self.contract=None
    def request(self, path, data=None, headers=None):
        request=Request(self.origin+path, data=data, headers=headers or {})
        try:
            with self.opener.open(request,timeout=self.timeout) as response:
                body=response.read(MAX_BYTES+1)
                if len(body)>MAX_BYTES: raise ValueError('Oversized demo response')
                return body.decode('utf-8')
        except HTTPError as exc:
            code = exc.code
            exc.close()
            raise ValueError(f'Demo HTTP status {code}; response not accepted') from None
        except (URLError, TimeoutError, OSError, UnicodeError, HTTPException):
            raise ValueError('Demo transport failed or response was not UTF-8') from None
    def prepare(self):
        page=self.request(PAGE); contract=FormContract();contract.feed(page)
        if not contract.csrf or contract.base!='/demo/' or contract.form!={'book':'breach','case':'NOT-2569','query':QUERY}:
            raise ValueError('Demo form contract changed')
        required=set(FIELD_MAP.values())|{'party_role','breach_unlikely_to_result_in_risk','breach_likely_to_result_in_high_risk','supervisory_authority_decision_on_communication'}
        if not required.issubset(contract.fields):
            raise ValueError('Required input fields missing in remote form')
        self.contract=contract
        return {'form_schema_sha256':digest_json(contract.public()), 'form_schema':contract.public(),
                'page_path':PAGE,'endpoint_path':ENDPOINT,'remote_rule_revision':None,
                'remote_rule_files_available':False,'independent_legal_review':'pending',
                'version_limit':'Observed web form schema only; does not pin or authenticate the deployed rule source.'}
    def run(self, payload):
        if self.contract is None: raise ValueError('Prepare the demo session first')
        for key,value in payload['facts'].items():
            serial='true' if value is True else 'false' if value is False else value
            if not isinstance(serial,str) or serial not in self.contract.fields.get(key,[]):
                raise ValueError('Fact incompatible with observed input contract')
        data=urlencode({k:json.dumps(payload[k],allow_nan=False) if k in ('facts','arguments') else payload[k]
                        for k in ('book','case','query','facts','arguments')}).encode()
        started=time.perf_counter()
        text=self.request(ENDPOINT,data,{'X-CSRFToken':self.contract.csrf,'Referer':self.origin+PAGE,
                                         'Content-Type':'application/x-www-form-urlencoded'})
        return {'response_text':text,'response_sha256':hashlib.sha256(text.encode()).hexdigest(),
                'roundtrip_ms':round((time.perf_counter()-started)*1000,3)}


def run_integration(out, base_url, *, live=False, include_sensitivity=False):
    if not live: raise ValueError('Explicit --live is required for remote demo requests')
    out=Path(out)
    if out.exists(): raise FileExistsError('Integration output already exists')
    cases=load_cases(); client=DemoClient(base_url)
    out.mkdir(parents=True)
    started=now(); observations=[]; provenance=None; setup_error=None
    try: provenance=client.prepare()
    except ValueError as exc: setup_error=str(exc)
    variants=['strict_source']+(['assume_no_authority_decision'] if include_sensitivity else [])
    # No gold loaded until all requests and observations have completed.
    for c in cases:
        for qid in PILOT.get(c['id'],()):
            q=next(q for q in c['questions'] if q['id']==qid)
            for variant in variants:
                payload=build_request(c,qid,assume_no_order=variant!='strict_source')
                row={'case_id':c['id'],'question_id':qid,'rule':q['rule'],'variant':variant,'observed_at':now(),
                     'artifact_type':'exploratory_demo_observation','legal_review':'pending','benchmark_eligible':False,
                     'case_sha256':digest_json(c),'request':payload,'request_sha256':digest_json({k:payload[k] for k in ('book','case','query','facts','arguments')}),
                     'status':'blocked','projection':None}
                if setup_error: row['reason']=setup_error
                else:
                    try:
                        receipt=client.run(payload)
                        response_text=receipt.pop('response_text')
                        row.update(receipt)
                        row['result']=parse_result(response_text)
                        validate_effective_input(row['result'],payload['facts'])
                        row['effective_input_verified']=row['result']['kind']!='held_out'
                        row['status']='received'
                        row['projection']=project_decision(row['result'],q['rule'])
                    except ValueError as exc:
                        row['status']='failed';row['reason']=str(exc)
                observations.append(row)
    # A second form check detects observable contract drift; source drift remains unknown.
    stable=None
    if provenance:
        try: stable=client.prepare()['form_schema_sha256']==provenance['form_schema_sha256']
        except ValueError: stable=False
    write_jsonl(out/'observations.jsonl',observations)
    write_coverage(out/'coverage.csv',cases)
    # Post-run label comparison, explicitly NOT full-answer correctness or a test score.
    gold=load_gold(); comparisons=[]
    for row in observations:
        answer=next(a for a in gold[row['case_id']]['answers'] if a['question_id']==row['question_id'])
        decision=(row.get('projection') or {}).get('decision')
        comparisons.append({'case_id':row['case_id'],'question_id':row['question_id'],'variant':row['variant'],
                            'remote_projected_decision':decision,'provisional_label':answer['decision'],
                            'label_agreement':None if decision is None else decision==answer['decision'],
                            'metric':'exploratory_duty_label_agreement','full_answer_correctness':None,
                            'legal_review':'pending','benchmark_eligible':False})
    write_jsonl(out/'comparisons.jsonl',comparisons)
    counts={v:{'requests':0,'received':0,'failed':0,'blocked':0,'answered':0,'missing':0,'referral':0,'held_out':0,'not_returned':0} for v in variants}
    for row in observations:
        count=counts[row['variant']];count['requests']+=int(setup_error is None);count[row['status']]+=1
        projection=row.get('projection') or {}
        kind=projection.get('status')
        if kind=='answered_projection': count['answered']+=1
        elif kind in ('missing','referral','held_out','not_returned'): count[kind]+=1
    manifest={'schema_version':1,'artifact_type':'exploratory_demo_integration','started_at':started,'finished_at':now(),
              'status':'completed' if all(r['status']=='received' for r in observations) and stable else 'incomplete',
              'source':'Operator-configured private demo; origin and credentials intentionally omitted',
              'selected_subquestions':8,'source_top_level_tasks':5,'full_company_cases_evaluated':0,
              'variants':variants,'counts':counts,'provenance':provenance,'form_contract_stable':stable,
              'gold_used_for_requests':False,'gold_used_after_requests_for_label_comparison':True,
              'remote_rule_revision_verified':False,'independent_legal_review':'pending','benchmark_eligible':False,
              'external_llm_calls':0,'formal_prolog_conditions':'blocked; unchanged',
              'source_hashes':{name:sha256(ROOT/name) for name in ('data/cases.jsonl','data/gold.provisional.jsonl','data/freeze.json','gdpr_bench/demo.py')},
              'outputs':{name:sha256(out/name) for name in ('observations.jsonl','comparisons.jsonl','coverage.csv')}}
    write_json(out/'manifest.json',manifest)
    return manifest
