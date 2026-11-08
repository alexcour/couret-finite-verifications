import json,pathlib,subprocess,zipfile
root=pathlib.Path(__file__).resolve().parent
evidence=pathlib.Path('source-evidence')
project=pathlib.Path('project');project.mkdir(exist_ok=True)
with zipfile.ZipFile(evidence/'sources.zip') as z:
    for name in z.namelist():
        assert pathlib.PurePosixPath(name).name==name, 'Unexpected source path'
        (project/name).write_bytes(z.read(name))
receipt=json.loads((evidence/'receipt.json').read_text())
for command in [['lake','update'],['lake','exe','cache','get'],['lake','build']+[r['module'] for r in receipt['modules'] if r['status']=='PASS']]:
    subprocess.run(command,cwd=project,check=True)
subprocess.run(['python',str(root/'generate_platform.py'),str(evidence),'generated'],check=True)
subprocess.run(['python',str(root/'validate_platform.py'),'project','generated','generated/validation'],check=True)
result=json.loads(pathlib.Path('generated/validation/platform-validation.json').read_text())
if result['status']!='PASS':raise SystemExit('Generated source validation failed; no platform submission performed')
