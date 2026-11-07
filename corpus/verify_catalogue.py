#!/usr/bin/env python3
"""Check the catalogued bytes. Does not execute Lean or download anything."""
import argparse
import collections
import hashlib
import json
import subprocess
import sys
import zipfile
from pathlib import Path


def sha256(data):
    return hashlib.sha256(data).hexdigest()


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--catalogue', type=Path, default=Path(__file__).with_name('catalogue.json'))
    parser.add_argument('--git-mirror', type=Path)
    parser.add_argument('--github-blobs', type=Path, help='Optional authenticated-fetch JSON for the same blobs; an alternative to a local Git mirror.')
    parser.add_argument('--archives', type=Path)
    args = parser.parse_args()
    data = json.loads(args.catalogue.read_text())
    variants = {v['sha256']: v for v in data['variants']}
    assert len(variants) == len(data['variants']) == data['summary']['combined_lean_content_variants']
    sources = {}
    archive_members = collections.defaultdict(dict)
    expected_snapshots = collections.defaultdict(dict)
    snapshots = {s['id']: s for s in data['snapshots']}
    for h, v in variants.items():
        for loc in v['locations']:
            if loc['kind'] == 'github':
                sources[loc['git_blob_sha']] = h
                for sid in loc['snapshots']:
                    assert sid in snapshots
                    expected_snapshots[sid][loc['path']] = loc['git_blob_sha']
            else:
                archive_members[loc['archive']][loc['path']] = h
    results = {'catalogue_structure': 'pass', 'variants': len(variants),
               'github_blobs': 'not checked', 'git_snapshots': 'not checked', 'archives': 'not checked',
               'lean_build': 'NOT_RUN', 'axiom_audit': 'NOT_RUN'}
    errors = []
    if args.github_blobs:
        fetched = {b['sha']: b for b in json.loads(args.github_blobs.read_text()) if 'content' in b}
        for blob, h in sources.items():
            if blob not in fetched:
                errors.append('Missing fetched Git blob: ' + blob)
                continue
            raw = fetched[blob]['content'].encode('utf8')
            if sha256(raw) != h:
                errors.append('Git SHA-256 mismatch: ' + blob)
            if hashlib.sha1(b'blob ' + str(len(raw)).encode() + b'\0' + raw).hexdigest() != blob:
                errors.append('Git object SHA-1 mismatch: ' + blob)
        results['github_blobs'] = {'checked': len(sources), 'source': 'authenticated-fetch JSON'}
    if args.git_mirror:
        for blob, h in sources.items():
            run = subprocess.run(['git', '-C', str(args.git_mirror), 'cat-file', 'blob', blob], capture_output=True)
            if run.returncode or sha256(run.stdout) != h:
                errors.append('Git mirror content unavailable or different: ' + blob)
        checked = 0
        for sid, expected in expected_snapshots.items():
            s = snapshots[sid]
            if s['repository'] != 'alexcour/couret-finite-verifications':
                errors.append('A separate repository mirror is required for ' + s['repository'])
                continue
            run = subprocess.run(['git', '-C', str(args.git_mirror), 'ls-tree', '-r', '--full-tree', s['commit']], capture_output=True)
            if run.returncode:
                errors.append('Commit unavailable: ' + s['commit'])
                continue
            actual = {}
            for line in run.stdout.decode().splitlines():
                meta, path = line.split('\t', 1)
                if path.endswith('.lean'):
                    mode, kind, blob = meta.split()
                    actual[path] = blob
            if actual != expected:
                errors.append('Lean source tree differs from snapshot ' + sid)
            checked += 1
        results['github_blobs'] = {'checked': len(sources), 'source': 'local Git mirror'}
        results['git_snapshots'] = {'checked': checked}
    if args.archives:
        checked = 0
        for a in data['archives']:
            path = args.archives / a['name']
            if not path.is_file():
                errors.append('Missing archive: ' + a['name'])
                continue
            if sha256(path.read_bytes()) != a['sha256']:
                errors.append('Archive SHA-256 mismatch: ' + a['name'])
                continue
            with zipfile.ZipFile(path) as z:
                names = {n for n in z.namelist() if n.endswith('.lean')}
                expected = archive_members[a['name']]
                if names != set(expected):
                    errors.append('Lean member list differs: ' + a['name'])
                for name in sorted(names & set(expected)):
                    if sha256(z.read(name)) != expected[name]:
                        errors.append('Archive member SHA-256 mismatch: ' + a['name'] + ':' + name)
                    checked += 1
        results['archives'] = {'archive_count': len(data['archives']), 'lean_members_checked': checked}
    if not (args.git_mirror or args.github_blobs or args.archives):
        results['coverage_note'] = 'Catalogue structure only. Supply local sources to verify bytes.'
    results['errors'] = errors
    results['status'] = 'fail' if errors else 'pass_for_the_reported_coverage'
    print(json.dumps(results, ensure_ascii=False, indent=2))
    return bool(errors)


if __name__ == '__main__':
    sys.exit(main())
