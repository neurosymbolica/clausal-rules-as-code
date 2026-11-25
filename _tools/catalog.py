#!/usr/bin/env python3
# SPDX-License-Identifier: EUPL-1.2
"""catalog.py -- machine-readable catalogue of the rule sets in this repository.

  python3 _tools/catalog.py generate [--release 2e] [--date YYYY-MM-DD]
      writes catalog.json at the repository root and one page per act under _index/by-law/
  python3 _tools/catalog.py check
      fails (exit 1) unless catalog.json and _index/by-law/ match the tree: every rule-set folder
      (a folder holding manifest.yaml) appears exactly once, no entry lacks a folder, every
      citation-derived act/article entry matches the folder's citations-sources.yaml, and each
      by-law page lists exactly the rule sets that cite that act.

Everything is generated from the tree; nothing is written by hand. The act of a citation is the
prefix of its key in citations-sources.yaml (for example eu_reg_2016_679_art_33). `total` is the
number of articles (or sections) of the act where it has been checked against the official text,
otherwise null.
"""
import json, os, re, subprocess, sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SKIP_TOP = {'kit', '_tools', 'docs', '_index', '.git'}

# key prefix -> (page file stem, short name, full name, total, unit)
ACTS = {
    'eu_reg_2016_679': ('gdpr', 'GDPR', 'General Data Protection Regulation (EU) 2016/679', 99, 'articles'),
    'eu_reg_2024_1689': ('ai-act', 'AI Act', 'Artificial Intelligence Act, Regulation (EU) 2024/1689', 113, 'articles'),
    'eu_reg_2022_2554': ('dora', 'DORA', 'Digital Operational Resilience Act, Regulation (EU) 2022/2554', 64, 'articles'),
    'eu_dir_2022_2555': ('nis2', 'NIS2', 'NIS2 Directive (EU) 2022/2555', 46, 'articles'),
    'eu_reg_2024_2847': ('cra', 'Cyber Resilience Act', 'Cyber Resilience Act, Regulation (EU) 2024/2847', 71, 'articles'),
    'eu_dir_2002_58': ('eprivacy', 'ePrivacy Directive', 'ePrivacy Directive 2002/58/EC', 21, 'articles'),
    'eu_reg_2022_1925': ('dma', 'Digital Markets Act', 'Digital Markets Act, Regulation (EU) 2022/1925', 54, 'articles'),
    'eu_reg_2022_2065': ('dsa', 'Digital Services Act', 'Digital Services Act, Regulation (EU) 2022/2065', 93, 'articles'),
    'eu_reg_2023_2854': ('data-act', 'Data Act', 'Data Act, Regulation (EU) 2023/2854', 50, 'articles'),
    'eu_reg_2023_956': ('cbam', 'CBAM', 'Carbon Border Adjustment Mechanism, Regulation (EU) 2023/956', 36, 'articles'),
    'eu_dir_2003_88': ('working-time', 'Working Time Directive', 'Working Time Directive 2003/88/EC', None, 'articles'),
    'eu_dir_2014_24': ('public-procurement', 'Public procurement', 'Public Procurement Directive 2014/24/EU', None, 'articles'),
    'eu_reg_2024_1624': ('aml', 'Anti-money laundering', 'Anti-Money Laundering Regulation (EU) 2024/1624', None, 'articles'),
    'ch_fadp': ('swiss-fadp', 'Swiss FADP', 'Swiss Federal Act on Data Protection', None, 'articles'),
    'cn_pipl': ('china-pipl', 'China PIPL', "Personal Information Protection Law of the People's Republic of China", 74, 'articles'),
    'in_dpdp_act_2023': ('india-dpdp', 'India DPDP Act', 'Digital Personal Data Protection Act, 2023 (India)', 44, 'sections'),
}
KEY = re.compile(r'^(eu_(?:reg|dir)_\d{4}_\d+|ch_fadp|cn_pipl|uk_gdpr|in_dpdp_act_2023)_(?:art|s)_(\d+)')
PLACE = {'eu': 'EU', 'ch': 'Switzerland', 'cn': 'China', 'ind': 'India', 'sg': 'Singapore', 'uk': 'United Kingdom',
         'us': 'United States'}


def rule_set_folders():
    out = []
    for top in sorted(os.listdir(ROOT)):
        if top in SKIP_TOP or top.startswith('.') or not os.path.isdir(os.path.join(ROOT, top)):
            continue
        for dp, dn, fn in os.walk(os.path.join(ROOT, top)):
            dn[:] = sorted(d for d in dn if d not in ('__pycache__', 'iso', 'tests', 'sources'))
            if 'manifest.yaml' in fn:
                out.append(os.path.relpath(dp, ROOT).replace(os.sep, '/'))
    return sorted(out)


def cited(folder):
    """{act key: sorted set of article numbers} from the folder's citations-sources.yaml."""
    p = os.path.join(ROOT, folder, 'citations-sources.yaml')
    acts = {}
    if not os.path.exists(p):
        return acts
    for line in open(p, encoding='utf8'):
        m = re.match(r'^([a-z0-9_]+):', line)
        if not m:
            continue
        k = KEY.match(m.group(1))
        if k and k.group(1) in ACTS:
            acts.setdefault(k.group(1), set()).add(int(k.group(2)))
    return acts


def titles():
    t = {}
    p = os.path.join(ROOT, 'docs', 'domains', 'index.md')
    if os.path.exists(p):
        for line in open(p, encoding='utf8'):
            m = re.match(r'^\| \[?`([^`]+)`\]?(?:\([^)]*\))? \| (.*) \|\s*$', line)
            if m:
                t[m.group(1)] = m.group(2).strip()
    return t


def ledgers():
    p = os.path.join(ROOT, '_index', 'STATUS.md')
    s = set()
    if os.path.exists(p):
        for line in open(p, encoding='utf8'):
            m = re.match(r'^\| `([^`]+)` \|', line)
            if m and '| enforced:' in line:
                s.add(m.group(1))
    return s


def first_published(folder, default):
    try:
        r = subprocess.run(['git', '-C', ROOT, 'log', '--diff-filter=A', '--reverse', '--format=%ad', '--date=short',
                            '--', folder + '/manifest.yaml'], capture_output=True, text=True, timeout=60)
        lines = [x for x in r.stdout.split() if x]
        return lines[0] if lines else default
    except Exception:
        return default


def build(release, date):
    ti, led = titles(), ledgers()
    sets, used = [], set()
    for f in rule_set_folders():
        c = cited(f)
        used.update(c)
        sets.append({'id': f, 'path': f, 'title': ti.get(f, ''), 'jurisdiction': PLACE.get(f.split('/')[0], f.split('/')[0]),
                     'acts': [{'key': k, 'articles': [str(n) for n in sorted(v)]} for k, v in sorted(c.items())],
                     'ledger': f in led, 'firstPublished': first_published(f, date)})
    acts = {k: {'name': ACTS[k][1], 'full': ACTS[k][2], 'total': ACTS[k][3], 'unit': ACTS[k][4], 'page': ACTS[k][0]}
            for k in ACTS if k in used}
    return {'release': release, 'commit': 'self', 'date': date, 'ruleSets': sets, 'acts': acts}


def pages(cat):
    out = {}
    for k, a in cat['acts'].items():
        stem = ACTS[k][0]
        rows = [(s, next(x for x in s['acts'] if x['key'] == k)) for s in cat['ruleSets'] if any(x['key'] == k for x in s['acts'])]
        lines = ['# ' + a['name'], '', a['full'], '',
                 f"{len(rows)} rule sets cite this act. Generated from `catalog.json`; do not edit by hand.", '',
                 '| Rule set | Articles cited |' if a['unit'] == 'articles' else '| Rule set | Sections cited |', '|---|---|']
        for s, x in sorted(rows, key=lambda r: r[0]['id']):
            lines.append(f"| [`{s['id']}`](../../{s['path']}/) | {', '.join(x['articles'])} |")
        out[stem + '.md'] = '\n'.join(lines) + '\n'
    idx = ['# Rule sets by law', '', 'One page per act, generated from `catalog.json`; do not edit by hand.', '',
           '| Act | Rule sets |', '|---|---|']
    for k, a in cat['acts'].items():
        n = sum(1 for s in cat['ruleSets'] if any(x['key'] == k for x in s['acts']))
        idx.append(f"| [{a['name']}]({ACTS[k][0]}.md) | {n} |")
    out['README.md'] = '\n'.join(idx) + '\n'
    return out


def dumps(cat):
    return json.dumps(cat, indent=1, ensure_ascii=False) + '\n'


def generate(release, date):
    cat = build(release, date)
    open(os.path.join(ROOT, 'catalog.json'), 'w', encoding='utf8').write(dumps(cat))
    d = os.path.join(ROOT, '_index', 'by-law')
    os.makedirs(d, exist_ok=True)
    for fn in os.listdir(d):
        os.remove(os.path.join(d, fn))
    for fn, text in pages(cat).items():
        open(os.path.join(d, fn), 'w', encoding='utf8').write(text)
    print(f'catalog.json: {len(cat["ruleSets"])} rule sets, {len(cat["acts"])} acts')


def check():
    bad = []
    try:
        cat = json.load(open(os.path.join(ROOT, 'catalog.json'), encoding='utf8'))
    except Exception as e:
        print('catalog.json unreadable:', e)
        return 1
    folders = rule_set_folders()
    ids = [s['id'] for s in cat['ruleSets']]
    for i in sorted(set(ids)):
        if ids.count(i) != 1:
            bad.append(f'{i}: listed {ids.count(i)} times')
    bad += [f'{f}: folder not in catalog.json' for f in folders if f not in ids]
    bad += [f'{i}: entry without a folder' for i in ids if i not in folders]
    for s in cat['ruleSets']:
        if s['id'] in folders:
            want = [{'key': k, 'articles': [str(n) for n in sorted(v)]} for k, v in sorted(cited(s['id']).items())]
            if s['acts'] != want:
                bad.append(f"{s['id']}: acts/articles differ from citations-sources.yaml")
            if s['path'] != s['id']:
                bad.append(f"{s['id']}: path differs from id")
    bad += [f'act {k} has no rule set' for k in cat['acts'] if not any(x['key'] == k for s in cat['ruleSets'] for x in s['acts'])]
    for s in cat['ruleSets']:
        bad += [f"{s['id']}: act {x['key']} missing from acts" for x in s['acts'] if x['key'] not in cat['acts']]
    want_pages = pages(cat)
    d = os.path.join(ROOT, '_index', 'by-law')
    have = sorted(os.listdir(d)) if os.path.isdir(d) else []
    if have != sorted(want_pages):
        bad.append(f'_index/by-law files differ: {have} vs {sorted(want_pages)}')
    for fn, text in want_pages.items():
        p = os.path.join(d, fn)
        if os.path.exists(p) and open(p, encoding='utf8').read() != text:
            bad.append(f'_index/by-law/{fn} differs from catalog.json')
    for b in bad:
        print('FAIL', b)
    print(f'catalog check: {len(folders)} rule-set folders, {len(ids)} entries,', 'FAIL' if bad else 'ok')
    return 1 if bad else 0


if __name__ == '__main__':
    a = sys.argv[1:]
    if a[:1] == ['check']:
        sys.exit(check())
    if a[:1] == ['generate']:
        rel = a[a.index('--release') + 1] if '--release' in a else ''
        dt = a[a.index('--date') + 1] if '--date' in a else ''
        generate(rel, dt)
        sys.exit(0)
    print(__doc__)
    sys.exit(2)
