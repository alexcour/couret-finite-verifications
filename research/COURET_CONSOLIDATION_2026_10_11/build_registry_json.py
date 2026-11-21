#!/usr/bin/env python3
"""Materialize a machine-readable registry from the curated canonical register."""
import datetime
import json
import pathlib
import re
P=pathlib.Path(__file__).resolve().parent
md=(P/'REGISTRE_CANONIQUE.md').read_text(encoding='utf8')
entries=[]
for line in md.splitlines():
    if not line.startswith('| **CU-'):
        continue
    cells=[s.strip() for s in line.strip().strip('|').split('|')]
    assert len(cells)==5, cells
    canonical=cells[0].replace('**','')
    sources=re.findall(r'\]\((https?://[^)]+)\)', cells[3])
    shas=re.findall(r'[a-f0-9]{40}', cells[3])
    entries.append({'canonical_id':canonical,'historical_alias':cells[1],
                    'exact_claim_scope':cells[2], 'source_links':sources,
                    'reference_commit_sha':shas[0] if shas else None,
                    'gate_as_of_2026_10_11':cells[4]})
assert len(entries)==12,len(entries)
assert len(set(z['canonical_id'] for z in entries))==len(entries)
jsonpath=P/'REGISTRE_CANONIQUE.json'
jsonpath.write_text(json.dumps({'generated_from':'REGISTRE_CANONIQUE.md',
                   'date':'2026-10-11','status':'NON AUDITEE: bibliographic originality and external review open',
                   'claims':entries},ensure_ascii=False,indent=2)+'\n',encoding='utf8')
print('PASS registry entries',len(entries),jsonpath)
