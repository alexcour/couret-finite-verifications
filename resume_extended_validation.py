import json,pathlib,shutil,subprocess,zipfile
root=pathlib.Path(__file__).resolve().parent
shutil.copytree('recovered/unified-evidence','unified-evidence')
project=pathlib.Path('project');project.mkdir()
with zipfile.ZipFile('unified-evidence/sources.zip') as z:z.extractall(project)
shutil.copytree('recovered/project/.lake/build',project/'.lake/build',dirs_exist_ok=True)
for command in [['lake','update'],['lake','exe','cache','get']]:
    subprocess.run(command,cwd=project,check=True)
subprocess.run(['python',str(root/'generate_platform.py'),'unified-evidence','generated'],check=True)
old=json.loads(pathlib.Path('recovered/generated/plan.json').read_text())
new=json.loads(pathlib.Path('generated/plan.json').read_text())
assert old['source']==new['source'] and old['mathlib_rev']==new['mathlib_rev']
assert {d['module'] for d in old['definitions']}=={d['module'] for d in new['definitions']}
assert old==new, 'Exact checked plan changed'
axiom_source='\n'.join('import '+m for m in sorted({t['module'] for t in new['theorems']}))+'\n'
axiom_source+='\n'.join('#print axioms '+t['name'] for t in new['theorems'])+'\n'
(project/'PrintMigrationAxioms.lean').write_text(axiom_source)
with pathlib.Path('unified-evidence/resumed-axioms.log').open('w') as log:
    subprocess.run(['lake','env','lean','PrintMigrationAxioms.lean'],cwd=project,stdout=log,stderr=subprocess.STDOUT,check=True)
subprocess.run(['python',str(root/'parse_axioms.py'),'unified-evidence/resumed-axioms.log','generated/plan.json','generated/axioms.json'],check=True)
shutil.copytree('recovered/generated/.lake/build','generated/.lake/build',dirs_exist_ok=True)
subprocess.run(['python',str(root/'validate_platform.py'),'project','generated','generated/validation'],check=True)
result=json.loads(pathlib.Path('generated/validation/platform-validation.json').read_text())
if result['status']!='PASS':
    for log in pathlib.Path('generated/validation').glob('*.log'):
        errors=[s for s in log.read_text().splitlines() if s.startswith('error:') or ': error' in s or 'PANIC' in s or 'Stack overflow' in s]
        if errors:print(log.name, '\n'.join(errors[:35]),flush=True)
    raise SystemExit('Validation failed; no publication performed')
