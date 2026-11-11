"""Human-operated legal-product exchange. No invented proprietary APIs or results."""
from datetime import datetime, timezone
import hashlib
import json
import math
from pathlib import Path
from .dataset import ROOT, digest_json, read_jsonl, sha256, write_json, write_jsonl
from .prompts import SYSTEM, build_prompt

PRODUCTS = ('harvey','legora','noxtua')


def export_product(output, product, cases, law):
    if product not in PRODUCTS:
        raise ValueError('Unknown product')
    output=Path(output)
    output.mkdir(parents=True,exist_ok=False)
    (output/'prompts').mkdir()
    manifest={'schema_version':2,'product':product,'created_at':datetime.now(timezone.utc).isoformat(),
              'evaluation':'black_box_product_comparison','account_access':'unverified','cases':{},'files':{},'law_manifest':law.manifest}
    template=[]
    for case in cases:
        text=SYSTEM+'\n\n'+build_prompt(case,law.select(case['law_articles']))
        name=f"prompts/{case['id']}.txt"
        (output/name).write_text(text,encoding='utf-8')
        manifest['cases'][case['id']]={'case_sha256':digest_json(case),'law_sha256':hashlib.sha256(law.select(case['law_articles']).encode()).hexdigest(),'prompt_file':name,'prompt_sha256':sha256(output/name)}
        manifest['files'][name]=sha256(output/name)
        template.append({'case_id':case['id'],'repeat':0,'status':'not_run','response_text':'','operator':None,'product_version':None,'captured_at':None,
                         'session_id':None,'feature_settings':None,'source_control':'unknown','submitted_prompt':'','evidence_reference':None,
                         'incremental_cost_usd':None,'elapsed_seconds':None,'reason':'Product access and execution pending'})
    write_json(output/'manifest.json',manifest)
    write_jsonl(output/'responses.jsonl',template)
    (output/'INSTRUCTIONS.md').write_text('''# Product operator instructions

This is a manual capture workflow for a genuinely available product account. No product
access or API integration is asserted. Use a fresh session for each case and paste the
complete prompt unchanged wherever the product permits. Do not show reference answers
or structured oracle facts. Record the product edition/build (or explicitly
`not_disclosed`), operator, timestamp with timezone, session identifier, feature settings,
and the exact submitted prompt. Capture the unedited full answer in response_text.

source_control is controlled_inputs only when the complete supplied prompt and law text
were supplied byte-for-byte. Product internals/retrieval remain opaque even then. If source
injection is not supported, choose uncontrolled_inputs and retain the actual prompt and
settings. This is a realistic product comparison, not a causal engine experiment.

Keep unavailable cases as not_run/blocked with a reason. A failure/refusal must be failed,
not silently retried until successful. Report any retries as a separate predeclared repeat
in a separately exported experiment; this export fixes repeat zero. Do not invent costs
or timing; null means unknown. Licence/seat costs belong in the economic model, distinct
from incremental request cost. Product terms/account permission and lawful access must be
checked by the operator; this package creates no accounts or product requests.

Edit a copy of responses.jsonl. Then import with `python -m gdpr_bench product-import`.
No semantic rewriting or human reconstruction of model answers is permitted. Optional
evidence_reference points to an operator-retained screenshot/export (without access tokens).
The package verifies hash consistency, not independent authenticity of operator evidence.
''',encoding='utf-8')
    return {'status':'awaiting_product_access_and_capture','product':product,'tasks':len(cases),'directory':str(output)}


def import_product(export_dir, responses_file, output, cases):
    export_dir,output=Path(export_dir),Path(output)
    manifest=json.loads((export_dir/'manifest.json').read_text())
    if manifest.get('schema_version')!=2 or manifest.get('product') not in PRODUCTS:
        raise ValueError('Unknown product export')
    for name,digest in manifest['files'].items():
        p=(export_dir/name).resolve()
        if not p.is_relative_to(export_dir.resolve()) or sha256(p)!=digest:
            raise ValueError('Product prompt/source integrity failure')
    by_id={c['id']:c for c in cases}
    responses=read_jsonl(responses_file)
    if len(responses)!=len(manifest['cases']) or any(not isinstance(r,dict) for r in responses) or {r.get('case_id') for r in responses}!=set(manifest['cases']):
        raise ValueError('Product response set must match the complete export')
    rows=[]
    for index,r in enumerate(responses):
        cid=r['case_id']; spec=manifest['cases'][cid]
        if cid not in by_id or digest_json(by_id[cid])!=spec['case_sha256']:
            raise ValueError('Case changed since product export')
        if type(r.get('repeat')) is not int or r.get('repeat')!=0 or r.get('status') not in {'not_run','blocked','failed','ok'}:
            raise ValueError('Unknown product status/repeat')
        status='blocked' if r['status']=='not_run' else r['status']
        row={'record_id':f'product-{index:05d}','case_id':cid,'repeat':0,'arm':'product:'+manifest['product'],'provider':manifest['product'],
             'model':r.get('product_version'),'status':status,'case_sha256':spec['case_sha256'],'law_sha256':spec['law_sha256'],
             'cost_usd':None,'billed_cost_usd':None,'calls':[],'capture_origin':'operator_reported_manual_product','reason':r.get('reason')}
        for field in ('incremental_cost_usd','elapsed_seconds'):
            value=r.get(field)
            if value is not None and (type(value) not in (int,float) or not math.isfinite(value) or value<0):
                raise ValueError(f'Invalid {field}')
        if status in {'ok','failed'}:
            for field in ('response_text','operator','product_version','captured_at','session_id','feature_settings','submitted_prompt'):
                value=r.get(field)
                if status=='ok' and (not isinstance(value,str) or not value.strip()):
                    raise ValueError(f'Completed product record requires {field}')
                if value is not None and not isinstance(value,str):
                    raise ValueError(f'Capture field must be text: {field}')
            if r.get('captured_at'):
                stamp=datetime.fromisoformat(r['captured_at'].replace('Z','+00:00'))
                if stamp.tzinfo is None:
                    raise ValueError('Capture timestamp requires timezone')
            if r.get('source_control') not in ({'controlled_inputs','uncontrolled_inputs'} if status=='ok' else {'controlled_inputs','uncontrolled_inputs','unknown',None}):
                raise ValueError('Declare actual source control for a completed capture')
            if r.get('source_control')=='controlled_inputs' and (not isinstance(r.get('submitted_prompt'),str) or hashlib.sha256(r['submitted_prompt'].encode()).hexdigest()!=spec['prompt_sha256']):
                raise ValueError('Controlled-input claim conflicts with submitted prompt')
            row.update(cost_usd=r.get('incremental_cost_usd'),billed_cost_usd=r.get('incremental_cost_usd'),
                       latency_seconds=r.get('elapsed_seconds'),product_capture={k:r.get(k) for k in ('operator','product_version','captured_at','session_id','feature_settings','source_control','submitted_prompt','evidence_reference')},
                       raw_response_text=r.get('response_text'),prompt_sha256=hashlib.sha256((r.get('submitted_prompt') or '').encode()).hexdigest(),
                       raw_response_sha256=hashlib.sha256((r.get('response_text') or '').encode()).hexdigest())
            if status=='ok':row['prediction']={'text':r['response_text']}
        if status!='ok' and (not isinstance(r.get('reason'),str) or not r['reason'].strip()):
            raise ValueError('Unavailable capture needs a reason')
        rows.append(row)
    output.mkdir(parents=True,exist_ok=False)
    (output/'capture.source.jsonl').write_bytes(Path(responses_file).read_bytes())
    (output/'export.manifest.json').write_bytes((export_dir/'manifest.json').read_bytes())
    write_jsonl(output/'cases.snapshot.jsonl',[by_id[cid] for cid in manifest['cases']])
    write_jsonl(output/'predictions.jsonl',rows)
    result={'schema_version':2,'release':'2.0.0','status':'imported_operator_captures','product':manifest['product'],'created_at':datetime.now(timezone.utc).isoformat(),
            'source_export_sha256':sha256(export_dir/'manifest.json'),'source_capture_sha256':sha256(responses_file),'predictions_sha256':sha256(output/'predictions.jsonl'),
            'case_snapshot_sha256':sha256(output/'cases.snapshot.jsonl'),'gold_file_sha256':sha256(ROOT/'data/gold.provisional.jsonl'),
            'counts':{s:sum(r['status']==s for r in rows) for s in ('ok','blocked','failed')},'actual_api_calls':0,
            'billing_note':'No requests executed by this importer. Operator product costs may be unknown; licences accounted separately.',
            'law_manifest':manifest['law_manifest'],'independent_capture_authenticity':'not_verified'}
    write_json(output/'manifest.json',result)
    return result
