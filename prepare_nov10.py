"""Extend the immutable validated release by Lean-oracle-generated nodes only."""
import hashlib,json,pathlib,shutil,subprocess,zipfile
root=pathlib.Path(__file__).resolve().parent
out=pathlib.Path('unified-evidence')
shutil.copytree('recovered/unified-evidence',out)
project=pathlib.Path('project');project.mkdir()
with zipfile.ZipFile(out/'sources.zip') as z:z.extractall(project)
shutil.copytree('recovered/project/.lake/build',project/'.lake/build',dirs_exist_ok=True)
module='RecohBranchComparison'
data=(root/(module+'.lean')).read_bytes()
blob=hashlib.sha1(b'blob '+str(len(data)).encode()+b'\0'+data).hexdigest()
assert blob=='8284b5450363816d3e3516996d494995e4f40319'
(project/(module+'.lean')).write_bytes(data)
with (project/'lakefile.lean').open('a') as f:f.write('\nlean_lib '+module+'\n')
for command in [['lake','update'],['lake','exe','cache','get']]:subprocess.run(command,cwd=project,check=True)
def run(command,log):
    with (out/log).open('w') as f:
        subprocess.run(command,cwd=project,stdout=f,stderr=subprocess.STDOUT,check=True,timeout=1800)
run(['lake','build',module],'nov10-source-build.log')
receipt=json.loads((out/'receipt.json').read_text())
assert module not in {r['module'] for r in receipt['modules']}
receipt['modules'].append({'module':module,'source_path':'research/strobo-2tors-2026-10-12/lean/'+module+'.lean','sha256':hashlib.sha256(data).hexdigest(),'original_locations':[{'repository':'alexcour/couret-finite-verifications','commit':'6cbb19a17462c6db22ebf84a5140f2a904bafd84','git_blob_sha':blob,'original_sha256':hashlib.sha256(data).hexdigest()}],'status':'PASS'})
mods=[r['module'] for r in receipt['modules'] if r['status']=='PASS']
graph=(root/'extract_decl_graph.lean').read_text()
graph=graph.replace('import SumSquares','import Lean\nimport '+module)
old='let projPrefix := `SumSquares\n  let isProj : Name → Bool := fun m => projPrefix.isPrefixOf m'
assert old in graph
graph=graph.replace(old,'let projectModules : List Name := ['+', '.join('`'+m for m in mods)+']\n  let isProj : Name → Bool := fun m => projectModules.contains m')
(project/'extract_decl_graph.lean').write_text(graph)
run(['lake','env','lean','extract_decl_graph.lean'],'nov10-graph.log')
rows=[json.loads(l) for l in (project/'decl_graph.jsonl').read_text().splitlines() if l]
newrows=[r for r in rows if r['module']==module]
assert newrows
with (out/'decl_graph.jsonl').open('a') as f:f.write('\n'+'\n'.join(json.dumps(r) for r in newrows)+'\n')
shutil.copyfile(root/'extract_sketch_info.lean',project/'extract_sketch_info.lean')
run(['lake','env','lean','--run','extract_sketch_info.lean',module+'.lean'],module+'.oracle.jsonl')
receipt['oracle'][module]=0
newnames=sorted(r['name'] for r in newrows if r['kind']=='theorem' and r['startLine']>0 and not r['isPrivate'])
assert len(newnames)==5
receipt['targets']=sorted(set(receipt.get('targets',[]))|set(newnames))
(out/'receipt.json').write_text(json.dumps(receipt,indent=2))
pathlib.Path('nov10-targets.json').write_text(json.dumps(newnames))
with zipfile.ZipFile(out/'sources.zip','w',zipfile.ZIP_DEFLATED) as z:
    for r in receipt['modules']:
        name=r['module']+'.lean'
        if (project/name).exists():z.write(project/name,name)
    for name in ['lakefile.lean','lean-toolchain','lake-manifest.json']:z.write(project/name,name)
subprocess.run(['python',str(root/'generate_platform.py'),str(out),'generated'],check=True)
subprocess.run(['python',str(root/'preserve_existing_release.py'),'recovered/generated','generated','nov10-targets.json'],check=True)
full=json.loads(pathlib.Path('generated/plan.json').read_text())
preserved=json.loads(pathlib.Path('generated/decomposition-receipt.json').read_text())
assert preserved['changed_proof_dependencies']==[] and preserved['reused_proofs']==1590
assert len(full['theorems'])==1595 and not full['unresolved_nodes'] and not full['skipped']
subset={**full,'theorems':[t for t in full['theorems'] if t['name'] in newnames]}
pathlib.Path('generated/plan.full.json').write_text(json.dumps(full,indent=2))
pathlib.Path('generated/plan.json').write_text(json.dumps(subset,indent=2))
(project/'AuditNov10.lean').write_text('import '+module+'\n'+'\n'.join('#print axioms '+n for n in newnames)+'\n')
run(['lake','env','lean','AuditNov10.lean'],'nov10-axioms.log')
subprocess.run(['python',str(root/'parse_axioms.py'),str(out/'nov10-axioms.log'),'generated/plan.json','generated/new-axioms.json'],check=True)
shutil.copytree('recovered/generated/.lake/build','generated/.lake/build',dirs_exist_ok=True)
subprocess.run(['python',str(root/'validate_platform.py'),'project','generated','generated/validation'],check=True)
vpath=pathlib.Path('generated/validation/platform-validation.json')
validation=json.loads(vpath.read_text());assert validation['status']=='PASS'
old=json.loads(pathlib.Path('recovered/generated/plan.json').read_text())
anchors=[]
for t in old['theorems']:
    hashes={}
    for key in ['target','solution']:
        before=(pathlib.Path('recovered/generated')/t[key]).read_bytes()
        after=(pathlib.Path('generated')/t[key]).read_bytes()
        assert before==after
        hashes[key]=hashlib.sha256(after).hexdigest()
    anchors.append({'name':t['name'],**hashes})
validation.update({'scope':'Five new nodes rebuilt and exact types compared; 1590 prior nodes and all definitions preserved byte-for-byte from successful validation 42521218888.','new_theorems':newnames,'unchanged_prior_theorems':len(anchors),'previous_validation_run':42521218888})
vpath.write_text(json.dumps(validation,indent=2))
pathlib.Path('generated/validation/prior-node-anchors.json').write_text(json.dumps(anchors,indent=2))
axioms=json.loads(pathlib.Path('recovered/generated/axioms.json').read_text())
axioms.update(json.loads(pathlib.Path('generated/new-axioms.json').read_text()))
pathlib.Path('generated/axioms.json').write_text(json.dumps(axioms,indent=2))
pathlib.Path('generated/plan.json').write_text(json.dumps(full,indent=2))
print(json.dumps({'status':'PASS','new_theorems':newnames,'total_nodes':len(full['theorems']),'prior_nodes_byte_identical':len(anchors)}),flush=True)
