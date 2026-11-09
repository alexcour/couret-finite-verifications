"""Build an allowlisted public projection; no private sources or model calls."""
import argparse
import hashlib
import json
import os
from pathlib import Path
import re
import urllib.request
from datetime import datetime, timezone
import xml.etree.ElementTree as ET

ROOT = Path(__file__).resolve().parents[1]
REPO = 'alexcour/couret-finite-verifications'
ORIGIN = 'https://couret-recherche-publique.espace-de-tr-5012.chatgpt.site'
WORKFLOWS = {'.github/workflows/public-mod30.yml', '.github/workflows/verify.yml'}
STATUSES = {'queued', 'in_progress', 'completed', 'waiting', 'requested', 'pending'}
CONCLUSIONS = {None, 'success', 'failure', 'neutral', 'cancelled', 'skipped', 'timed_out', 'action_required', 'stale', 'startup_failure'}

def canonical(obj):
    return json.dumps(obj, ensure_ascii=False, sort_keys=True, separators=(',', ':')).encode()

def digest(obj):
    return hashlib.sha256(canonical(obj)).hexdigest()

def checked_journal(root=ROOT):
    approved = json.loads((root / 'publication/approved_sources.json').read_text())
    if set(approved) != {'schema', 'source', 'canonical_sha256', 'scope'}:
        raise ValueError('INVALID_APPROVAL')
    if approved['schema'] != 'couret-public-approval/1' or approved['scope'] != 'PUBLIC_ONLY_FINITE_PEDAGOGY':
        raise ValueError('INVALID_SCOPE')
    if approved['source'] != 'research/mod30-permutations/journal.json':
        raise ValueError('SOURCE_NOT_ALLOWED')
    data = json.loads((root / approved['source']).read_text())
    if digest(data) != approved['canonical_sha256']:
        raise ValueError('SOURCE_REQUIRES_EDITORIAL_REVIEW')
    if data.get('scope') != approved['scope'] or len(data.get('entries', [])) != 2:
        raise ValueError('INVALID_JOURNAL')
    if any(v is not False for k, v in data['governance'].items() if k != 'publication_scope'):
        raise ValueError('GOVERNANCE_LOCK')
    return data, approved

def project_runs(payload):
    """Select latest run per allowlisted workflow, irrespective of outcome."""
    if not isinstance(payload, dict) or not isinstance(payload.get('workflow_runs'), list):
        raise ValueError('INVALID_RUN_PAYLOAD')
    selected = {}
    for run in payload['workflow_runs']:
        path = run.get('path')
        if path not in WORKFLOWS or run.get('head_branch') != 'main':
            continue
        if run.get('repository', {}).get('full_name') != REPO:
            raise ValueError('WRONG_REPOSITORY')
        rid = run.get('id')
        sha = run.get('head_sha', '')
        if type(rid) is not int or rid <= 0 or not re.fullmatch(r'[0-9a-f]{40}', sha):
            raise ValueError('INVALID_RUN_ID')
        if run.get('html_url') != f'https://github.com/{REPO}/actions/runs/{rid}':
            raise ValueError('UNSAFE_RUN_URL')
        if run.get('status') not in STATUSES or run.get('conclusion') not in CONCLUSIONS:
            raise ValueError('UNKNOWN_RUN_STATE')
        if run.get('status') != 'completed' and run.get('conclusion') is not None:
            raise ValueError('INCONSISTENT_RUN_STATE')
        for field in ('created_at', 'updated_at'):
            datetime.fromisoformat(run[field].replace('Z', '+00:00'))
        row = {k: run[k] for k in ('id', 'path', 'head_sha', 'status', 'conclusion', 'html_url', 'created_at', 'updated_at')}
        if path not in selected or (row['created_at'], row['id']) > (selected[path]['created_at'], selected[path]['id']):
            selected[path] = row
    return [selected[k] for k in sorted(selected)]

def fetch_runs():
    req = urllib.request.Request(f'https://api.github.com/repos/{REPO}/actions/runs?branch=main&per_page=50', headers={'Accept': 'application/vnd.github+json', 'User-Agent': 'Couret-public-distribution'})
    token = os.environ.get('GITHUB_TOKEN')
    if token:
        req.add_header('Authorization', 'Bearer ' + token)
    with urllib.request.urlopen(req, timeout=20) as response:
        raw = response.read(1500001)
    if len(raw) > 1500000:
        raise ValueError('RUN_PAYLOAD_TOO_LARGE')
    return project_runs(json.loads(raw))

def make_rss(entries):
    rss = ET.Element('rss', version='2.0')
    channel = ET.SubElement(rss, 'channel')
    for key, value in [('title', 'Couret–Unification — Journal public'), ('link', ORIGIN + '/journal.html'), ('description', 'Calculs finis, questions ouvertes, sources et limites.'), ('language', 'fr')]:
        ET.SubElement(channel, key).text = value
    for entry in entries:
        item = ET.SubElement(channel, 'item')
        ET.SubElement(item, 'title').text = entry['title']
        ET.SubElement(item, 'link').text = ORIGIN + '/journal.html#' + entry['id']
        ET.SubElement(item, 'guid', isPermaLink='false').text = 'urn:couret:public:' + entry['id']
        ET.SubElement(item, 'pubDate').text = datetime.fromisoformat(entry['date']).replace(tzinfo=timezone.utc).strftime('%a, %d %b %Y %H:%M:%S GMT')
        ET.SubElement(item, 'category').text = entry['status']
        ET.SubElement(item, 'description').text = entry['summary'] + ' Limites : ' + entry['limitations']
    return ET.tostring(rss, encoding='utf-8', xml_declaration=True) + b'\n'

def build(root=ROOT, source_sha='', runs=None):
    if not re.fullmatch(r'[0-9a-f]{40}', source_sha):
        raise ValueError('EXACT_SOURCE_SHA_REQUIRED')
    data, approved = checked_journal(root)
    if runs is None:
        runs = []
    material = {'journal': data, 'runs': runs, 'approval': approved}
    key = digest(material)
    output = root / 'publication/generated'
    previous = output / 'status.json'
    if previous.exists():
        old = json.loads(previous.read_text())
        if old.get('content_key') == key:
            # Check all files still agree before treating this as an idempotent replay.
            receipt = json.loads((output / 'receipt.json').read_text())
            for name, value in receipt['files_sha256'].items():
                if name not in {'status.json', 'feed.xml'} or hashlib.sha256((output / name).read_bytes()).hexdigest() != value:
                    raise ValueError('GENERATED_INTEGRITY_MISMATCH')
            if set(receipt['files_sha256']) != {'status.json', 'feed.xml'}:
                raise ValueError('INCOMPLETE_RECEIPT')
            return False
    output.mkdir(parents=True, exist_ok=True)
    now = datetime.now(timezone.utc).isoformat()
    result = {'schema': 'couret-public-distribution/1', 'content_key': key, 'generated_at': now, 'source_sha': source_sha, 'repository': REPO, 'entries': data['entries'], 'governance': data['governance'], 'runs': runs, 'run_observation': 'OBSERVED_PUBLIC_API' if runs else 'NOT_OBSERVED', 'limitations': 'CI logicielle et intégrité documentaire ; aucune validation scientifique indépendante ni qualification physique.'}
    (output / 'status.json').write_text(json.dumps(result, ensure_ascii=False, indent=2) + '\n')
    (output / 'feed.xml').write_bytes(make_rss(data['entries']))
    receipt = {'schema': 'couret-public-receipt/1', 'generated_at': now, 'source_sha': source_sha, 'journal_canonical_sha256': approved['canonical_sha256'], 'files_sha256': {n: hashlib.sha256((output / n).read_bytes()).hexdigest() for n in ('status.json', 'feed.xml')}, 'independent_validation': False}
    (output / 'receipt.json').write_text(json.dumps(receipt, indent=2) + '\n')
    return True

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--source-sha', required=True)
    parser.add_argument('--fetch-runs', action='store_true')
    args = parser.parse_args()
    changed = build(source_sha=args.source_sha, runs=fetch_runs() if args.fetch_runs else [])
    print('PUBLIC_SNAPSHOT_UPDATED' if changed else 'NO_MATERIAL_CHANGE')
