"""Explicit registered candidate × condition × case matrix; readiness is not a result."""
import csv
import hashlib
import json
from pathlib import Path
from .dataset import digest_json, read_jsonl
from .products import PRODUCTS
from .providers import Provider
from .prolog import PrologAdapter


def evaluation_matrix(cases,model_config,law,*,prolog=None,run_dirs=()):
    prolog=prolog or PrologAdapter()
    cells=[]
    for case in cases:
        common={'case_id':case['id'],'kind':case['kind'],'subquestions':len(case['questions']),'case_sha256':digest_json(case),
                'law_sha256':hashlib.sha256(law.select(case['law_articles']).encode()).hexdigest()}
        for slot,cfg in model_config['models'].items():
            for arm in ('llm_text','llm_control','llm_python','llm_prolog'):
                reason=Provider(cfg).availability()
                if arm=='llm_prolog' and prolog.availability(case)['status']!='ready':reason=prolog.availability(case)['reason']
                cells.append(dict(common,candidate=slot,provider=cfg['provider'],model=cfg.get('model'),arm=arm,experiment='A' if arm!='llm_text' else 'A_deployment_baseline',
                                  readiness='blocked' if reason else 'configured_unverified',reason=reason or 'Account/model execution not verified',execution_status='not_run',score=None))
        for arm in ('python_rules','prolog_oracle'):
            available=prolog.availability(case) if arm=='prolog_oracle' else {'status':'ready'}
            cells.append(dict(common,candidate=arm,provider='symbolic',model=None,arm=arm,experiment='oracle_diagnostic',
                              readiness='available' if available['status']=='ready' else 'blocked',reason=available.get('reason','Supplied-fact baseline; not an NLP comparison'),execution_status='not_run',score=None))
        for product in PRODUCTS:
            cells.append(dict(common,candidate=product,provider='product',model=None,arm='product:'+product,experiment='B',readiness='requires_access_and_capture',
                              reason='Manual export/import available; actual product access and answers unverified',execution_status='not_run',score=None))
    lookup={(r['candidate'],r['arm'],r['case_id']):r for r in cells}
    for cell in cells:
        cell.update(executed_provider=None, executed_model=None, executed_config_sha256=None)
    seen=set()
    for directory in run_dirs:
        manifest=json.loads((Path(directory)/'manifest.json').read_text())
        for row in read_jsonl(Path(directory)/'predictions.jsonl'):
            if row.get('repeat',0)!=0:continue
            candidate=row['arm'].split(':',1)[1] if row['arm'].startswith('product:') else row.get('model_slot') or manifest.get('config',{}).get('slot')
            if row['arm'] in ('python_rules','prolog_oracle'):candidate=row['arm']
            key=(candidate,row['arm'],row['case_id'])
            if key not in lookup:raise ValueError('Run does not belong to this registered matrix')
            if key in seen:raise ValueError('Duplicate primary cell; choose one run per registered condition')
            seen.add(key)
            cell=lookup[key]
            if any(row.get(k)!=cell[k] for k in ('case_sha256','law_sha256')):raise ValueError('Run case/law changed relative to matrix')
            if row['arm'].startswith('llm_'):
                if row.get('provider') != cell['provider']:
                    raise ValueError('Executed provider differs from registered matrix candidate')
                if cell['model'] is not None and row.get('model') != cell['model']:
                    raise ValueError('Executed model differs from configured matrix candidate')
            cell.update(executed_provider=row.get('provider'), executed_model=row.get('model'),
                        executed_config_sha256=row.get('config_sha256'))
            cell['execution_status']=row['status']
            cell['reason']=row.get('reason') or ('Executed; human correctness still unscored' if row['status']=='ok' else cell['reason'])
    return cells


def write_matrix(path,rows):
    path=Path(path)
    if path.exists():raise FileExistsError('Matrix output exists')
    path.parent.mkdir(parents=True,exist_ok=True)
    if path.suffix.lower()=='.json':
        path.write_text(json.dumps(rows,indent=2)+'\n')
    else:
        with path.open('w',newline='',encoding='utf-8') as f:
            writer=csv.DictWriter(f,fieldnames=list(rows[0]))
            writer.writeheader();writer.writerows(rows)
    return {'cells':len(rows),'conditions':len({(r['candidate'],r['arm']) for r in rows}),'tasks':len({r['case_id'] for r in rows}),
            'executed_ok':sum(r['execution_status']=='ok' for r in rows),'human_scores_available':sum(r['score'] is not None for r in rows)}
