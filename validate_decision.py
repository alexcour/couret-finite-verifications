import json,pathlib,re,subprocess,zipfile
root=pathlib.Path(__file__).resolve().parent
evidence=pathlib.Path('source-evidence')
project=pathlib.Path('project');project.mkdir(exist_ok=True)
with zipfile.ZipFile(evidence/'sources.zip') as z:
    source=z.read('DecisionInterface.lean')
    (project/'DecisionInterface.lean').write_bytes(source)
    (project/'lean-toolchain').write_bytes(z.read('lean-toolchain'))
(project/'lakefile.lean').write_text('import Lake\nopen Lake DSL\npackage CouretDecision where\nlean_lib DecisionInterface\n')
subprocess.run(['lake','build','DecisionInterface'],cwd=project,check=True)
graph=(root/'extract_decl_graph.lean').read_text().replace('import SumSquares','import Lean\nimport DecisionInterface').replace('let projPrefix := `SumSquares','let projPrefix := `DecisionInterface')
(project/'extract_decl_graph.lean').write_text(graph)
subprocess.run(['lake','env','lean','extract_decl_graph.lean'],cwd=project,check=True)
(evidence/'decl_graph.jsonl').write_bytes((project/'decl_graph.jsonl').read_bytes())
(project/'extract_sketch_info.lean').write_bytes((root/'extract_sketch_info.lean').read_bytes())
with (evidence/'DecisionInterface.oracle.jsonl').open('w') as out:
    subprocess.run(['lake','env','lean','--run','extract_sketch_info.lean','DecisionInterface.lean'],cwd=project,stdout=out,check=True)
receipt=json.loads((evidence/'receipt.json').read_text())
receipt['graph_exit']=0;receipt['oracle']={'DecisionInterface':0}
receipt['targets']=['Couret.DecisionInterface.factorization_on_image_iff']
(evidence/'receipt.json').write_text(json.dumps(receipt,indent=2))
subprocess.run(['python',str(root/'generate_platform.py'),str(evidence),'generated'],check=True)
generated=pathlib.Path('generated')
lake=(generated/'lakefile.lean').read_text()
lake='\n'.join(l for l in lake.splitlines() if not l.startswith('require mathlib'))+'\n'
(generated/'lakefile.lean').write_text(lake)
subprocess.run(['python',str(root/'validate_platform.py'),'project','generated','generated/validation'],check=True)
result=json.loads((generated/'validation/platform-validation.json').read_text())
if result['status']!='PASS':raise SystemExit('Generated decision source validation failed; no publication performed')
plan=json.loads((generated/'plan.json').read_text())
names=[t['name'] for t in plan['theorems']]
(project/'AuditDecision.lean').write_text('import Lean\nimport DecisionInterface\n'+'\n'.join('#print axioms '+n for n in names)+'\n')
with (evidence/'axioms.log').open('w') as output:
    subprocess.run(['lake','env','lean','AuditDecision.lean'],cwd=project,stdout=output,stderr=subprocess.STDOUT,check=True)
text=(evidence/'axioms.log').read_text()
axioms={n:[a.strip() for a in body.split(',') if a.strip()] for n,body in re.findall(r"'([^'\n]+)' depends on axioms: \[([^\]]*)\]",text,re.S)}
axioms.update({n:[] for n in re.findall(r"'([^'\n]+)' does not depend on any axioms",text)})
assert all(n in axioms and set(axioms[n])<={'propext','Classical.choice','Quot.sound'} for n in names)
(generated/'validation/axioms.json').write_text(json.dumps(axioms,indent=2))
