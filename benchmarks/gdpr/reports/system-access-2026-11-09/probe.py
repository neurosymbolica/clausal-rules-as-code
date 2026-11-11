"""Archive direct synthetic-case submissions. No law, gold or encoded facts sent.
Run in a fresh output directory: GDPR_DEMO_BASE_URL=... python3 probe.py OUTPUT
"""
import hashlib, json, os, re, sys, time
from pathlib import Path
from datetime import datetime, timezone
from http.cookiejar import CookieJar
from urllib.request import build_opener, HTTPCookieProcessor, HTTPRedirectHandler, Request
from urllib.parse import urlencode
class NoRedirect(HTTPRedirectHandler):
    def redirect_request(self,*args,**kwargs): return None
root=Path(__file__).resolve().parent
cases_path=root.parent/'edge-pilot-2026-11-09/cases.json'
out=Path(sys.argv[1]); out.mkdir(exist_ok=False)
base=os.environ['GDPR_DEMO_BASE_URL'].rstrip('/')
records=[]
for case in json.loads(cases_path.read_text()):
    opener=build_opener(HTTPCookieProcessor(CookieJar()),NoRedirect())
    page=opener.open(base+'/demo/',timeout=30).read().decode()
    token=re.search(r'<meta name="csrf-token" content="([^"]+)"',page).group(1)
    prompt='Please assess this case under the EU GDPR and, where relevant, Austrian DSG. Answer both questions and identify missing facts.\n\n'+case['title']+'\n\n'+case['scenario']+'\n\n'+'\n'.join(q['id']+': '+q['prompt'] for q in case['questions'])
    (out/(case['id']+'-request.txt')).write_text(prompt+'\n')
    started=datetime.now(timezone.utc).isoformat(); clock=time.monotonic()
    req=Request(base+'/demo/api/send',data=urlencode({'message':prompt}).encode(),headers={'X-CSRFToken':token,'Referer':base+'/demo/','Content-Type':'application/x-www-form-urlencoded'})
    with opener.open(req,timeout=55) as response:
        raw=response.read().decode();status=response.status
    # Fail closed rather than persist private network identifiers or session secrets.
    assert base not in raw and token not in raw
    (out/(case['id']+'-response.txt')).write_text(raw)
    record={'case_id':case['id'],'started_at':started,'http_status':status,'elapsed_seconds':round(time.monotonic()-clock,3),'endpoint':'/demo/api/send','fresh_cookie_session':True,'request_sha256':hashlib.sha256(prompt.encode()).hexdigest(),'response_sha256':hashlib.sha256(raw.encode()).hexdigest(),'model_id':None,'token_usage':None,'cost':None}
    records.append(record); (out/'manifest.json').write_text(json.dumps(records,indent=2)+'\n')
    print(case['id'],status,raw[:2400],flush=True)
