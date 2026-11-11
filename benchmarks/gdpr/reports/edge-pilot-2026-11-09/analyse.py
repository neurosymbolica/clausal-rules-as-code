"""Recompute descriptive results from explicitly recorded assistant ratings."""
from pathlib import Path
import json,csv,math,hashlib,random
P=Path(__file__).resolve().parent
MODELS=['gpt-6.1-sol','gpt-6-astra','claude-opus-5-5','claude-sonnet-5-5'];CONDS=['law','ris','mike']
gold=json.loads((P/'gold.provisional.json').read_text())['answers'];rows=[]
# Assistant-reviewed deductions, with exact supporting excerpts. Full-answer scores are NOT keyword grading.
deductions={
('claude-sonnet-5-5','law','E01.q2'):(1,'Prepare a phased Art. 33 notification to the authority and patient communication, to be sent if the vault is compromised','The response starts assessment now, but makes both notices contingent on vault compromise rather than separately applying the risk and high-risk thresholds promptly. This is a material qualification in the action plan.'),
('claude-sonnet-5-5','law','E05.q1'):(1,'If it is a public body, Art. 37(1)(a) would apply instead.','The recommended designation is correct, but the answer unnecessarily conditions/hedges the independent Article37(1)(c) duty and omits qualified/independent DPO safeguards in its next steps.'),
('claude-sonnet-5-5','ris','E05.q1'):(1,'If it is a public body, Art. 37(1)(a) applies instead.','Correct designation action, but unnecessary conditionality remains and qualified/independent DPO safeguards are not addressed.'),
('claude-sonnet-5-5','mike','E05.q1'):(1,'Some Austrian law considerations are not supplied.','Correctly recognises Article37(1)(c) independence, but unnecessarily hedges the duty on established facts and omits qualified/independent DPO safeguards. No engine rule covers this question.'),
('claude-opus-5-5','law','E04.q2'):(1,'A banner behind a login reaches at most about 20% of active group B users.','Past-year portal usage does not establish an upper bound on actual future banner reach. The insufficiency conclusion is right, but an unsupported quantitative inference remains.'),
('claude-opus-5-5','ris','E04.q2'):(1,'A banner behind a login reaches at most the 20% of group B who used the portal last year.','Same unsupported conversion of historical usage into an actual reach ceiling; core conclusion remains correct.'),
('claude-opus-5-5','mike','E04.q2'):(1,'A login-gated banner reaches at most about the 20% of group B who recently used the portal.','Same reach-ceiling error persists despite correctly explaining that the engine does not certify effectiveness.'),
('claude-opus-5-5','ris','E01.q2'):(1,'send it immediately if the logs show key compromise','The response starts containment/authority work now, but its individual-notice action is framed around positive log confirmation, rather than a prompt likelihood-based decision with current evidence. Treat this deduction as a judgement-sensitive completeness concern, not proof that delay actually occurred.')}
for model in MODELS:
 for condition in CONDS:
  run=P/'runs'/(model+'__'+condition);meta=json.loads((run/'metadata.json').read_text());raw=(run/'original-answer.txt').read_text();s=raw.strip()
  if s.startswith('```'):s='\n'.join(s.splitlines()[1:-1])
  aa=json.loads(s)['answers'];seen=set()
  for a in aa:
   original=a['question_id'];q=original;alignment=None
   if (model,condition,original)==('claude-sonnet-5-5','law','E04.b'):
    q='E04.q2';alignment='Post-run manual semantic alignment of E04.b to E04.q2: the unique group-B banner-sufficiency answer. Strict schema failure is retained; no model retry or answer rewriting.'
   assert q in gold and q not in seen;seen.add(q)
   score,excerpt,note=deductions.get((model,condition,q),(2,None,'Core conclusion and material reasoning/response points substantively addressed. Minor ancillary omissions are not separately penalised.'))
   if excerpt:assert excerpt in raw,(model,condition,q)
   if q=='E02.q2' and model=='claude-sonnet-5-5' and condition in ['law','ris']:
    note+=' Raw decision=no contradicts the notification-required explanation; full semantic answer is scored separately. The compound question wording may have contributed.'
   rows.append({'model':model,'condition':condition,'question_id':q,'original_question_id':original,'raw_decision':a['decision'],'accepted_reference_decisions':gold[q]['accepted_decisions'],'label_match_after_explicit_alignment':a['decision'] in gold[q]['accepted_decisions'],'quality_score':score,'max_score':2,'evidence_excerpt':excerpt,'assessment_note':note,'manual_alignment':alignment,'strict_run_schema_pass':meta['status']=='received','reviewer':'assistant; identities visible; not independent or legally validated'})
  assert len(seen)==12
(P/'assessment.json').write_text(json.dumps(rows,indent=2)+'\n')
with (P/'assessment.csv').open('w') as f:
 w=csv.DictWriter(f,fieldnames=list(rows[0]),lineterminator="\n");w.writeheader();w.writerows(rows)
summary={m:{c:{'quality_points':sum(r['quality_score'] for r in rows if r['model']==m and r['condition']==c),'max_points':24,'label_matches':sum(r['label_match_after_explicit_alignment'] for r in rows if r['model']==m and r['condition']==c),'questions':12,'strict_schema_pass':json.loads((P/'runs'/(m+'__'+c)/'metadata.json').read_text())['status']=='received'} for c in CONDS} for m in MODELS}
index={(r['model'],r['condition'],r['question_id']):r for r in rows};paired=[]
for treatment in ['ris','mike']:
 for model in MODELS:
  for q in gold:
   paired.append({'model':model,'treatment':treatment,'question_id':q,'law_score':index[model,'law',q]['quality_score'],'treatment_score':index[model,treatment,q]['quality_score'],'delta':index[model,treatment,q]['quality_score']-index[model,'law',q]['quality_score']})
case_deltas={t:{case:sum(r['delta'] for r in paired if r['treatment']==t and r['question_id'].startswith(case+'.'))/4 for case in ['E01','E02','E03','E04','E05','E06']} for t in ['ris','mike']}
def sign(values):
 pos=sum(v>0 for v in values);neg=sum(v<0 for v in values);n=pos+neg
 return {'positive_cases':pos,'negative_cases':neg,'ties':len(values)-n,'nonzero_n':n,'two_sided_p':None if n==0 else min(1,2*sum(math.comb(n,k) for k in range(min(pos,neg)+1))/2**n),'interpretation':'Exploratory small-sample sign test; ties excluded. No causal/superiority or equivalence inference.'}
result={'models':summary,'pooled_quality_points':{c:sum(summary[m][c]['quality_points'] for m in MODELS) for c in CONDS},'pooled_max':96,'pair_counts':{t:{'improved':sum(r['delta']>0 for r in paired if r['treatment']==t),'unchanged':sum(r['delta']==0 for r in paired if r['treatment']==t),'worse':sum(r['delta']<0 for r in paired if r['treatment']==t)} for t in ['ris','mike']},'case_mean_score_deltas':case_deltas,'sign_tests':{t:sign(list(v.values())) for t,v in case_deltas.items()},'rating_status':'provisional_unblinded_assistant_review','protocol_deviation':'One unique Sonnet law question ID manually aligned for content review; strict schema result retained. No inference retry. Sensitivity excluding that entire run is reported in README.'}
(P/'analysis.json').write_text(json.dumps(result,indent=2)+'\n');(P/'paired-deltas.json').write_text(json.dumps(paired,indent=2)+'\n')
# Reusable identity-masked review packet; original answers remain public and condition may be inferred.
packet=[];key=[]
for model in MODELS:
 for cond in CONDS:
  run=P/'runs'/(model+'__'+cond);text=(run/'original-answer.txt').read_text();bid=hashlib.sha256((model+'__'+cond+'edge-review').encode()).hexdigest()[:12]
  packet.append({'review_id':bid,'answer_text':text,'instructions':'Rate against provisional rubric. Do not consult named outputs or study results before review. Identity masking is not guaranteed condition blinding.'});key.append({'review_id':bid,'model':model,'condition':cond})
random.Random(20261109).shuffle(packet)
(P/'review-packet.jsonl').write_text('\n'.join(json.dumps(r) for r in packet)+'\n')
# Key remains outside published repository.
private=P.parents[4]/'experiments'/'edge-pilot-review-key-2026-11-09.json';private.write_text(json.dumps(key,indent=2)+'\n')
print(json.dumps(result,indent=2))
