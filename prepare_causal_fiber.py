import hashlib,json,pathlib,subprocess,zipfile
root=pathlib.Path(__file__).resolve().parent
out=pathlib.Path('source-evidence');out.mkdir()
project=pathlib.Path('project');project.mkdir()
module='CausalFiber01';data=(root/(module+'.lean')).read_bytes()
assert hashlib.sha1(b'blob '+str(len(data)).encode()+b'\0'+data).hexdigest()=='f6e0900928dc5fe99ad162a36f9aa1945d4790da'
(project/(module+'.lean')).write_bytes(data)
(project/'lean-toolchain').write_text('leanprover/lean4:v4.30.0\n')
(project/'lakefile.lean').write_text('import Lake\nopen Lake DSL\npackage CausalFiberImport where\nlean_lib CausalFiber01\n')
def run(command,log):
    with (out/log).open('w') as f:subprocess.run(command,cwd=project,stdout=f,stderr=subprocess.STDOUT,check=True,timeout=900)
run(['lake','update'],'lake-update.log')
run(['lake','build',module],'source-build.log')
graph=(root/'extract_decl_graph.lean').read_text().replace('import SumSquares','import Lean\nimport '+module).replace('let projPrefix := `SumSquares','let projPrefix := `'+module)
(project/'extract_decl_graph.lean').write_text(graph)
run(['lake','env','lean','extract_decl_graph.lean'],'graph.log')
(out/'decl_graph.jsonl').write_bytes((project/'decl_graph.jsonl').read_bytes())
(project/'extract_sketch_info.lean').write_bytes((root/'extract_sketch_info.lean').read_bytes())
run(['lake','env','lean','--run','extract_sketch_info.lean',module+'.lean'],module+'.oracle.jsonl')
rows=[json.loads(l) for l in (out/'decl_graph.jsonl').read_text().splitlines() if l]
facts=[json.loads(l) for l in (out/(module+'.oracle.jsonl')).read_text().splitlines() if l.startswith('{')]
decls=[f for f in facts if f['kind']=='decl' and f.get('nameText')]
targets=sorted(r['name'] for r in rows if r['kind']=='theorem' and not r['isPrivate'] and r['startLine']>0 and any(d['declStart']['line']<=r['startLine']<=d['declEnd']['line'] and (r['name']==d['nameText'] or r['name'].endswith('.'+d['nameText'])) for d in decls))
assert targets
receipt={'group':'causal-fiber-01','source':{'repository':'alexcour/CAUSAL-PAIR-01','commit':'02bcbbf17dfaade51171885578a228b16736d425','path':'causal_fiber_01/CausalFiber01.lean'},'mathlib_rev':'c5ea00351c28e24afc9f0f84379aa41082b1188f','toolchain':'leanprover/lean4:v4.30.0','modules':[{'module':module,'source_path':'causal_fiber_01/CausalFiber01.lean','sha256':hashlib.sha256(data).hexdigest(),'status':'PASS'}],'oracle':{module:0},'targets':targets}
(out/'receipt.json').write_text(json.dumps(receipt,indent=2))
with zipfile.ZipFile(out/'sources.zip','w',zipfile.ZIP_DEFLATED) as z:
    for name in [module+'.lean','lakefile.lean','lean-toolchain','lake-manifest.json']:z.write(project/name,name)
subprocess.run(['python',str(root/'generate_platform.py'),str(out),'generated'],check=True)
gen=pathlib.Path('generated');plan=json.loads((gen/'plan.json').read_text())
assert {t['name'] for t in plan['theorems']}==set(targets) and not plan['skipped'] and not plan['unresolved_nodes']
(gen/'lakefile.lean').write_text('\n'.join(l for l in (gen/'lakefile.lean').read_text().splitlines() if not l.startswith('require mathlib'))+'\n')
(project/'AuditSource.lean').write_text('import '+module+'\n'+'\n'.join('#print axioms '+n for n in targets)+'\n')
run(['lake','env','lean','AuditSource.lean'],'axioms.log')
subprocess.run(['python',str(root/'parse_axioms.py'),str(out/'axioms.log'),str(gen/'plan.json'),str(gen/'axioms.json')],check=True)
subprocess.run(['python',str(root/'validate_platform.py'),'project','generated','generated/validation'],check=True)
assert json.loads((gen/'validation/platform-validation.json').read_text())['status']=='PASS'
print(json.dumps({'status':'PASS','theorems':targets,'definitions':len(plan['definitions'])}),flush=True)
