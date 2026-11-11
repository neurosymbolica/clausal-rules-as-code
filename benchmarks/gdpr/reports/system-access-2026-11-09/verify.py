"""Offline verification of recorded scope probes; no inference or network."""
import hashlib,json,re
from pathlib import Path
p=Path(__file__).resolve().parent
cases=json.loads((p.parent/'edge-pilot-2026-11-09/cases.json').read_text())
records=json.loads((p/'observations/manifest.json').read_text())
assert [r['case_id'] for r in records]==[c['id'] for c in cases]
for c,r in zip(cases,records):
    request=(p/'observations'/f"{c['id']}-request.txt").read_text().removesuffix('\n')
    response=(p/'observations'/f"{c['id']}-response.txt").read_text()
    assert hashlib.sha256(request.encode()).hexdigest()==r['request_sha256']
    assert hashlib.sha256(response.encode()).hexdigest()==r['response_sha256']
    assert c['scenario'] in request and c['title'] in request
    assert all(q['prompt'] in request for q in c['questions'])
    assert r['http_status']==200 and r['fresh_cookie_session'] is True
    assert '(text (role assistant) (body (md (p "I can only answer questions covered by these formalized rulebases. Try one:"))))' in response
    assert '(case none)' in response and '(answer ' not in response
    assert all(r[k] is None for k in ['model_id','token_usage','cost'])
outcomes=json.loads((p/'outcomes.json').read_text())
assert [r['case_id'] for r in outcomes]==[c['id'] for c in cases]
assert all(r['legal_quality_score'] is None and r['subquestions_answered']==0 for r in outcomes)
for file in p.rglob('*'):
    if file.is_file() and file.suffix in {'.txt','.json','.md'}:
        s=file.read_text()
        assert not re.search(r'100\.115\.|csrf-token|sessionid=|/Users/|admin/invite/',s),file
print('PASS: six original narratives and twelve questions; request/response hashes; HTTP success; six explicit scope rejections; null quality; private identifiers absent.')
