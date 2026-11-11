"""Read-only live integration for the frozen edge cases; no changes to formal arms."""
import json,os,sys,hashlib
from pathlib import Path
from datetime import datetime,timezone
P=Path(__file__).resolve().parent;sys.path.insert(0,str(P.parents[1]))
from gdpr_bench.demo import DemoClient,parse_result,validate_effective_input,project_decision
if (P/'demo-observations.json').exists():raise FileExistsError('Do not overwrite live evidence')
cases=json.loads((P/'cases.json').read_text());client=DemoClient(os.environ['GDPR_DEMO_BASE_URL']);schema=client.prepare();rows=[]
for c in cases:
 for req in c['demo_requests']:
  payload={'book':'breach','case':'NOT-2569','query':'notification_obligation','facts':req['facts'],'arguments':{}}
  row={'id':req['id'],'case_id':c['id'],'request':payload,'limits':req['limits'],'observed_at':datetime.now(timezone.utc).isoformat(),'source_revision':None,'legal_review':'pending'}
  try:
   receipt=client.run(payload);result=parse_result(receipt.pop('response_text'));row.update(receipt);row['result']=result
   validate_effective_input(result,payload['facts']);row['effective_input_verified']=result['kind']!='held_out';row['status']='received'
   # Keep contradiction/missing/referral output intact; don't fabricate target decisions.
   try:row['projections']={r:project_decision(result,r) for r in ['breach_authority','breach_communication']}
   except ValueError as e:row['projection_error']=str(e)
  except ValueError as e:row['status']='failed';row['error']=str(e)
  rows.append(row);print(row['id'],row['status'],row.get('result',{}).get('kind'),flush=True)
(P/'demo-observations.json').write_text(json.dumps(rows,ensure_ascii=False,indent=2)+'\n')
(P/'demo-schema.json').write_text(json.dumps(schema,indent=2)+'\n')
# Frozen, compact inference supplement: exactly observed kind/headline/lines/raw and limits, no template expected answer.
summary=[]
for c in cases:
 rr=[r for r in rows if r['case_id']==c['id']]
 summary.append({'case_id':c['id'],'outputs':[{'request_id':r['id'],'status':r['status'],'engine_result':{k:v for k,v in r.get('result',{}).items() if k in ['kind','headline','lines','raw','why','relied']},'error':r.get('error'),'coverage_limits':r['limits']} for r in rr],'coverage':'No mapped rule for these questions' if not rr else 'Partial breach-duty interface only','rule_revision':None,'legal_validation':'pending'})
(P/'demo-supplement.json').write_text(json.dumps(summary,ensure_ascii=False,indent=2)+'\n')
