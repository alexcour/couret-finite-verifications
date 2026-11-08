import argparse,hashlib,json,os,pathlib,shutil
p=argparse.ArgumentParser();p.add_argument('old');p.add_argument('new');p.add_argument('targets');args=p.parse_args()
oldroot=pathlib.Path(args.old);newroot=pathlib.Path(args.new)
assert json.loads((oldroot/'validation/platform-validation.json').read_text())['status']=='PASS'
old=json.loads((oldroot/'plan.json').read_text());new=json.loads((newroot/'plan.json').read_text())
extra=set(json.loads(pathlib.Path(args.targets).read_text()))
assert old['source']==new['source'] and old['mathlib_rev']==new['mathlib_rev']
assert old['definitions']==new['definitions']
for d in old['definitions']:
    before=(oldroot/d['path']).read_bytes();after=(newroot/d['path']).read_bytes()
    assert before==after or (os.name=='nt' and before==after.replace(b'\r\n',b'\n'))
    shutil.copyfile(oldroot/d['path'],newroot/d['path'])
oldnodes={t['name']:t for t in old['theorems']};newnodes={t['name']:t for t in new['theorems']}
assert set(newnodes)==set(oldnodes)|extra and not set(oldnodes)&extra
reused={};changed=[]
for name,before in oldnodes.items():
    after=newnodes[name]
    for field in ['preamble','formal_statement']:
        after[field]=before[field]
    shutil.copyfile(oldroot/before['target'],newroot/after['target'])
    if before['children']==after['children']:
        shutil.copyfile(oldroot/before['solution'],newroot/after['solution'])
        reused[name]=hashlib.sha256((newroot/after['solution']).read_bytes()).hexdigest()
    else:changed.append(name)
(newroot/'plan.json').write_text(json.dumps(new,indent=2))
(newroot/'prevalidated-solution-hashes.json').write_text(json.dumps(reused,indent=2))
(newroot/'decomposition-receipt.json').write_text(json.dumps({'new_nodes':sorted(extra),'changed_proof_dependencies':changed,'reused_proofs':len(reused),'all_previous_target_payloads_preserved':True,'all_definition_bytes_preserved':True},indent=2))
print(json.dumps({'new_nodes':len(extra),'changed_proofs':changed,'reused_proofs':len(reused)}),flush=True)
