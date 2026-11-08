import hashlib,json,pathlib,subprocess,zipfile
root=pathlib.Path(__file__).resolve().parent
out=pathlib.Path('unified-evidence');project=pathlib.Path('project');project.mkdir()
receipt=json.loads((out/'receipt.json').read_text())
with zipfile.ZipFile(out/'sources.zip') as z:z.extractall(project)
manifest=json.loads((root/'extensions-manifest.json').read_text())
checkout=pathlib.Path('branch-sources');checkout.mkdir()
subprocess.run(['git','init'],cwd=checkout,check=True,stdout=subprocess.DEVNULL)
subprocess.run(['git','remote','add','origin','https://github.com/alexcour/couret-finite-verifications.git'],cwd=checkout,check=True)
for sha in sorted({m['location']['commit'] for m in manifest['modules']}):
    subprocess.run(['git','fetch','--depth=1','origin',sha],cwd=checkout,check=True,stdout=subprocess.DEVNULL)
# Only import paths are flattened; every declaration and its namespace is retained.
mapping={}
for m in manifest['modules']:
    p=m['location']['path']; stem=m['module']
    mapping[stem]=stem
    if '/research/lean/' in '/'+p:full=p.split('research/lean/',1)[1][:-5].replace('/','.');mapping[full]=stem
    if '/lean/STROBO2Tors/' in p:mapping['STROBO2Tors.'+stem]=stem
for m in manifest['modules']:
    loc=m['location'];data=subprocess.check_output(['git','show',loc['commit']+':'+loc['path']],cwd=checkout)
    assert hashlib.sha256(data).hexdigest()==m['sha256']
    lines=[]
    for line in data.decode('utf-8-sig').splitlines():
        if line.startswith('import '):line='import '+' '.join(mapping.get(p,p) for p in line[7:].split())
        lines.append(line)
    data=('\n'.join(lines)+'\n').encode();(project/(m['module']+'.lean')).write_bytes(data)
    receipt['modules'].append({'module':m['module'],'source_path':loc['path'],'sha256':hashlib.sha256(data).hexdigest(),'status':'NOT_RUN','original_locations':[{'group':'branch-extension','source':{'repo':'https://github.com/'+loc['repository']+'.git','commit':loc['commit']},'module':m['module'],'source_path':loc['path'],'original_sha256':m['sha256']}],'import_paths_flattened':True})
pin=receipt['mathlib_rev']
lake='import Lake\nopen Lake DSL\npackage CouretExtended where\nrequire mathlib from git "https://github.com/leanprover-community/mathlib4.git" @ "'+pin+'"\n'
(project/'lakefile.lean').write_text(lake+'\n'.join('lean_lib '+m['module'] for m in receipt['modules'])+'\n')
def run(command,log,timeout=2400):
    with (out/log).open('w') as f:
        try:return subprocess.run(command,cwd=project,stdout=f,stderr=subprocess.STDOUT,timeout=timeout).returncode
        except subprocess.TimeoutExpired:f.write('\nTIMEOUT\n');return 124
assert run(['lake','update'],'extension-lake-update.log')==0
assert run(['lake','exe','cache','get'],'extension-cache.log')==0
base=[m['module'] for m in receipt['modules'] if m['status']=='PASS']
assert run(['lake','build']+base,'extension-base-build.log')==0
(project/'extract_sketch_info.lean').write_bytes((root/'extract_sketch_info.lean').read_bytes())
for m in receipt['modules']:
    if m['status']=='PASS':continue
    name=m['module'];code=run(['lake','build',name],name+'.build.log',900)
    m['status']='PASS' if code==0 else 'FAIL';print(name,'BUILD',code,flush=True)
    if code==0:
        oracle=run(['lake','env','lean','--run','extract_sketch_info.lean',name+'.lean'],name+'.oracle.jsonl',600)
        receipt['oracle'][name]=oracle
        if oracle==0:
            facts=[json.loads(l) for l in (out/(name+'.oracle.jsonl')).read_text().splitlines() if l.startswith('{')]
            if any(f.get('kind')=='decl' and f.get('nameText')=='main' for f in facts):m['status']='EXECUTABLE_EXCLUDED'
    (out/'receipt.json').write_text(json.dumps(receipt,indent=2))
modules=[m['module'] for m in receipt['modules'] if m['status']=='PASS' and receipt['oracle'].get(m['module'])==0]
graph=(root/'extract_decl_graph.lean').read_text().replace('import SumSquares','import Lean\n'+'\n'.join('import '+m for m in modules))
graph=graph.replace('let projPrefix := `SumSquares\n  let isProj : Name → Bool := fun m => projPrefix.isPrefixOf m','let projectModules : List Name := ['+', '.join('`'+m for m in modules)+']\n  let isProj : Name → Bool := fun m => projectModules.contains m')
(project/'extract_decl_graph.lean').write_text(graph)
receipt['graph_exit']=run(['lake','env','lean','extract_decl_graph.lean'],'extension-graph.log')
(out/'receipt.json').write_text(json.dumps(receipt,indent=2))
if receipt['graph_exit']:raise SystemExit('Extended declaration graph needs repair')
(out/'decl_graph.jsonl').write_bytes((project/'decl_graph.jsonl').read_bytes())
rows=[json.loads(l) for l in (out/'decl_graph.jsonl').read_text().splitlines()]
(project/'AuditAxioms.lean').write_text('import Lean\n'+'\n'.join('import '+m for m in modules)+'\n'+'\n'.join('#print axioms '+r['name'] for r in rows if r['kind']=='theorem' and r['startLine']>0 and not r['isPrivate'])+'\n')
receipt['axioms_exit']=run(['lake','env','lean','AuditAxioms.lean'],'axioms.log')
(out/'receipt.json').write_text(json.dumps(receipt,indent=2))
with zipfile.ZipFile(out/'sources.zip','w',zipfile.ZIP_DEFLATED) as z:
    for m in receipt['modules']:z.write(project/(m['module']+'.lean'),m['module']+'.lean')
    for name in ['lakefile.lean','lean-toolchain','lake-manifest.json']:z.write(project/name,name)
subprocess.run(['python',str(root/'generate_platform.py'),str(out),'generated'],check=True)
subprocess.run(['python',str(root/'parse_axioms.py'),str(out/'axioms.log'),'generated/plan.json','generated/axioms.json'],check=True)
subprocess.run(['python',str(root/'validate_platform.py'),'project','generated','generated/validation'],check=True)
if json.loads(pathlib.Path('generated/validation/platform-validation.json').read_text())['status']!='PASS':raise SystemExit('Extended migration validation failed')
