"""Offline integrity and arithmetic verification. Does not validate legal correctness."""
import json,hashlib,sys
from pathlib import Path
from datetime import datetime,timezone
P=Path(__file__).resolve().parent
sys.path.insert(0,str(P.parents[1]))
from gdpr_bench.demo import validate_effective_input
sha=lambda b:hashlib.sha256(b).hexdigest()
checks=[]
def check(name,ok):
 if not ok:raise AssertionError(name)
 checks.append(name)
freeze=json.loads((P/'freeze.json').read_text())
check('Frozen input and executed runner hashes',all(sha((P/n).read_bytes())==h for n,h in freeze.items()))
cases=json.loads((P/'cases.json').read_text());ids={c['id']+'.'+q['id'] for c in cases for q in c['questions']}
check('Six cases and twelve unique questions',len(cases)==6 and len(ids)==12)
m=json.loads((P/'manifest.json').read_text());check('Twelve completed CLI calls',len(m['runs'])==12 and all(r.get('exit_code')==0 for r in m['runs']))
check('Eleven strict-schema passes; one explicit ID failure',sum(r['status']=='received' for r in m['runs'])==11 and [r['id'] for r in m['runs'] if r['status']!='received']==['claude-sonnet-5-5__law'])
raw_count=0
for r in m['runs']:
 run=P/'runs'/r['id'];raw=(run/'original-answer.txt').read_text();s=raw.strip()
 if s.startswith('```'):s='\n'.join(s.splitlines()[1:-1])
 aa=json.loads(s)['answers'];raw_count+=len(aa)
 check('Prompt hash '+r['id'],sha((P/'prompts'/(r['condition']+'.txt')).read_bytes())==r['prompt_sha256'])
 if r['status']=='received':check('Answer hash '+r['id'],sha(raw.encode())==r['answer_sha256'])
 else:check('Single documented ID deviation',({a['question_id'] for a in aa}-ids)=={'E04.b'} and (ids-{a['question_id'] for a in aa})=={'E04.q2'})
 if r['model_requested'].startswith('gpt-'):check('No OpenAI tool events '+r['id'],r.get('tool_items')==[])
 else:check('Exact Claude identity and no tool-use requests '+r['id'],list(r['model_usage'])==[r['model_requested']] and r['num_turns']==1 and all(v==0 for v in r['usage'].get('server_tool_use',{}).values()))
check('144 original answer objects',raw_count==144)
rows=json.loads((P/'assessment.json').read_text());check('144 uniquely scored answers',len(rows)==144 and len({(r['model'],r['condition'],r['question_id']) for r in rows})==144)
check('Ratings remain provisional and bounded',all(r['quality_score'] in [0,1,2] and 'not independent' in r['reviewer'] for r in rows))
a=json.loads((P/'analysis.json').read_text());check('Scoring totals recompute',all(sum(r['quality_score'] for r in rows if r['condition']==c)==s for c,s in a['pooled_quality_points'].items()))
check('Primary paired counts',a['pair_counts']['mike']=={'improved':1,'unchanged':47,'worse':0})
check('Small-sample test explicitly uninformative',a['sign_tests']['mike']['two_sided_p']==1 and a['sign_tests']['mike']['nonzero_n']==1)
obs=json.loads((P/'demo-observations.json').read_text());kinds=[r['result']['kind'] for r in obs]
check('Six live demo results and coverage',len(obs)==6 and {k:kinds.count(k) for k in set(kinds)}=={'held_out':3,'missing':1,'answer':1,'problems':1})
for r in obs:validate_effective_input(r['result'],r['request']['facts'])
check('Non-held-out effective inputs verified',sum(bool(r.get('effective_input_verified')) for r in obs)==3)
statutes=json.loads((P/'ris-statutes.json').read_text());decisions=json.loads((P/'ris-decisions.json').read_text())
for i,sourceid in [(0,'dsg30_text'),(1,'hospital_decision')]:
 native=json.loads((P/'sources'/f'native-recheck-{i}.json').read_text())['structuredContent'];frozen=next(r for r in statutes+decisions if r['source_id']==sourceid)
 check('Native MCP text agrees '+sourceid,native['text']==frozen['text'])
core=[json.loads(l) for l in (P.parents[1]/'data/cases.jsonl').read_text().splitlines()]
check('Core GDPR30 preserved counts',len(core)==30 and sum(c['kind']=='complex' for c in core)==10 and sum(len(c['questions']) for c in core)==70)
for f in P.rglob('*'):
 if f.is_file() and f.suffix not in ['.pyc'] and f.name!='verify.py':
  txt=f.read_text()
  check('No private origin/account data '+str(f.relative_to(P)),all(x not in txt for x in ['100.115.235.96','luc@lumeus-app.de','login.tailscale.com/admin/invite/','/Users/lucthiery/']))
result={'checked_at_utc':datetime.now(timezone.utc).isoformat(),'status':'passed','checks':len(checks),'model_calls':12,'raw_answer_objects':144,'strict_schema_valid_calls':11,'core_tests_observed':{'command':'python3 -m unittest discover -s tests -q','tests':137,'result':'OK','note':'Executed earlier in this task after setup; core code and dataset unchanged.'},'legal_review':'pending','checks_cover':'Artifact integrity and scoring arithmetic, not independent legal validation'}
(P/'verification.json').write_text(json.dumps(result,indent=2)+'\n');print(json.dumps(result,indent=2))
