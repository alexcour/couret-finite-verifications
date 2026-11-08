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
assert old==new, 'Cached plan changed'
shutil.copyfile('recovered/generated/axioms.json','generated/axioms.json')
shutil.copytree('recovered/generated/.lake/build','generated/.lake/build',dirs_exist_ok=True)
subprocess.run(['python',str(root/'validate_platform.py'),'project','generated','generated/validation'],check=True)
result=json.loads(pathlib.Path('generated/validation/platform-validation.json').read_text())
if result['status']!='PASS':
    for log in pathlib.Path('generated/validation').glob('*.log'):
        errors=[s for s in log.read_text().splitlines() if 'error:' in s]
        if errors:print(log.name, '\n'.join(errors[:35]),flush=True)
    raise SystemExit('Validation failed; no publication performed')
