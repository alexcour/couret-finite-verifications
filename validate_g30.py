import hashlib,json,pathlib,subprocess,zipfile
root=pathlib.Path(__file__).resolve().parent
evidence=pathlib.Path('source-evidence'); project=pathlib.Path('project'); project.mkdir()
receipt=json.loads((evidence/'receipt.json').read_text())
with zipfile.ZipFile(evidence/'sources.zip') as z:
    source=z.read('G30ComplexSpectrum.lean')
    for name in ['lean-toolchain','lakefile.lean','lake-manifest.json']:
        (project/name).write_bytes(z.read(name))
facts=[json.loads(l) for l in (evidence/'G30ComplexSpectrum.oracle.jsonl').read_text().splitlines() if l.startswith('{')]
rows=[json.loads(l) for l in (evidence/'decl_graph.jsonl').read_text().splitlines() if l.startswith('{')]
targets=[r for r in rows if r['kind']=='theorem' and r['startLine']>0 and not r['isPrivate']]
edits=[]; names=[]
for r in targets:
    d=next(d for d in facts if d['kind']=='decl' and d['declStart']['line']<=r['startLine']<=d['declEnd']['line'])
    if r['name'].endswith('.RHClaimed_false_G30ComplexSpectrum'):
        edits.append((d['declStart']['offset'],d['declEnd']['offset'],b''));continue
    names.append(r['name'])
    edits.append((d['valStart']['offset'],d['declEnd']['offset'],b':= by decide'))
for a,b,v in sorted(edits,reverse=True):source=source[:a]+v+source[b:]
# An ordinary option command follows imports and does not alter any statement.
source=source.replace(b'import Mathlib.Tactic',b'import Mathlib.Tactic\nset_option maxHeartbeats 0',1)
(project/'G30ComplexSpectrum.lean').write_bytes(source)
def run(command,log,timeout=2400):
    with (evidence/log).open('w') as f:
        try:code=subprocess.run(command,cwd=project,stdout=f,stderr=subprocess.STDOUT,timeout=timeout).returncode
        except subprocess.TimeoutExpired:code=124
    print(log,code,flush=True)
    if code:raise SystemExit('G30 kernel migration stopped: '+log)
run(['lake','update'],'kernel-lake-update.log')
run(['lake','exe','cache','get'],'kernel-cache.log')
run(['lake','build','G30ComplexSpectrum'],'kernel-build.log')
graph=(root/'extract_decl_graph.lean').read_text().replace('import SumSquares','import Lean\nimport G30ComplexSpectrum').replace('let projPrefix := `SumSquares','let projPrefix := `G30ComplexSpectrum')
(project/'extract_decl_graph.lean').write_text(graph)
run(['lake','env','lean','extract_decl_graph.lean'],'graph.log')
(evidence/'decl_graph.jsonl').write_bytes((project/'decl_graph.jsonl').read_bytes())
(project/'extract_sketch_info.lean').write_bytes((root/'extract_sketch_info.lean').read_bytes())
run(['lake','env','lean','--run','extract_sketch_info.lean','G30ComplexSpectrum.lean'],'G30ComplexSpectrum.oracle.jsonl')
(project/'AuditG30.lean').write_text('import G30ComplexSpectrum\n'+'\n'.join('#print axioms '+n for n in names)+'\n')
run(['lake','env','lean','AuditG30.lean'],'axioms.log')
receipt['targets']=names
receipt['proof_migration']={'method':'oracle-spanned native_decide proofs replaced by kernel decide; statement spans unchanged','original_sha256':receipt['modules'][0]['sha256'],'migrated_sha256':hashlib.sha256(source).hexdigest(),'removed_scope_marker':'RHClaimed_false_G30ComplexSpectrum : True'}
receipt['modules'][0]['sha256']=hashlib.sha256(source).hexdigest()
(evidence/'receipt.json').write_text(json.dumps(receipt,indent=2))
with zipfile.ZipFile(evidence/'sources.zip','w',zipfile.ZIP_DEFLATED) as z:
    for name in ['G30ComplexSpectrum.lean','lean-toolchain','lakefile.lean','lake-manifest.json']:z.write(project/name,name)
subprocess.run(['python',str(root/'generate_platform.py'),str(evidence),'generated'],check=True)
subprocess.run(['python',str(root/'parse_axioms.py'),str(evidence/'axioms.log'),'generated/plan.json','generated/axioms.json'],check=True)
subprocess.run(['python',str(root/'validate_platform.py'),'project','generated','generated/validation'],check=True)
if json.loads(pathlib.Path('generated/validation/platform-validation.json').read_text())['status']!='PASS':raise SystemExit('G30 generated migration needs repair')
