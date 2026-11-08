import json,pathlib,subprocess,zipfile
root=pathlib.Path(__file__).resolve().parent
out=pathlib.Path('unified-evidence')
project=pathlib.Path('project');project.mkdir()
with zipfile.ZipFile(out/'sources.zip') as z:z.extractall(project)
def run(command):
    subprocess.run(command,cwd=project,check=True)
run(['lake','update'])
run(['lake','exe','cache','get'])
receipt=json.loads((out/'receipt.json').read_text())
run(['lake','build']+[r['module'] for r in receipt['modules']])
subprocess.run(['python',str(root/'generate_platform.py'),str(out),'generated'],check=True)
subprocess.run(['python',str(root/'parse_axioms.py'),str(out/'axioms.log'),'generated/plan.json','generated/axioms.json'],check=True)
subprocess.run(['python',str(root/'validate_platform.py'),'project','generated','generated/validation'],check=True)
result=json.loads(pathlib.Path('generated/validation/platform-validation.json').read_text())
if result['status']!='PASS':raise SystemExit('Generated migration needs repair; no publication performed')
