import argparse, hashlib, io, json, pathlib, subprocess, urllib.request, zipfile

PIN = 'c5ea00351c28e24afc9f0f84379aa41082b1188f'
TOOLCHAIN = 'leanprover/lean4:v4.30.0'
ROOT = pathlib.Path(__file__).resolve().parent
parser = argparse.ArgumentParser()
parser.add_argument('group')
args = parser.parse_args()
specs = json.loads((ROOT/'source-groups.json').read_text())
spec = next(s for s in specs if s['name']==args.group)
out = pathlib.Path('evidence')
out.mkdir(exist_ok=True)
project = pathlib.Path('project')
project.mkdir(exist_ok=True)
sources = {}
if 'record' in spec:
    archives=json.loads((ROOT/'archives.json').read_text())
    archive=next(a for a in archives if a['record']==spec['record'])
    payload=urllib.request.urlopen(archive['url'],timeout=120).read()
    assert len(payload)==archive['bytes']
    assert hashlib.sha256(payload).hexdigest()==archive['sha256']
    with zipfile.ZipFile(io.BytesIO(payload)) as z:
        for name in z.namelist():
            p=pathlib.PurePosixPath(name)
            if p.parent.as_posix()==spec['path'] and p.suffix=='.lean' and p.name!='lakefile.lean':
                sources[p.stem]=(name,z.read(name))
else:
    repo=pathlib.Path('source-repo')
    subprocess.run(['git','init',str(repo)],check=True)
    subprocess.run(['git','-C',str(repo),'remote','add','origin',spec['repo']],check=True)
    subprocess.run(['git','-C',str(repo),'fetch','--depth','1','origin',spec['commit']],check=True)
    subprocess.run(['git','-C',str(repo),'checkout','--detach','FETCH_HEAD'],check=True)
    for p in (repo/spec['path']).glob('*.lean'):
        if p.name not in ['lakefile.lean','G30ComplexSpectrum.drive.lean']:
            sources[p.stem]=(p.relative_to(repo).as_posix(),p.read_bytes())
assert sources, 'No sources'
receipt={'group':args.group,'source':spec,'mathlib_rev':PIN,'toolchain':TOOLCHAIN,'modules':[]}
for module,(name,data) in sorted(sources.items()):
    (project/(module+'.lean')).write_bytes(data)
    receipt['modules'].append({'module':module,'source_path':name,'sha256':hashlib.sha256(data).hexdigest(),'status':'NOT_RUN'})
(project/'lean-toolchain').write_text(TOOLCHAIN+'\n')
lake='import Lake\nopen Lake DSL\npackage CouretProve2Me where\nrequire mathlib from git "https://github.com/leanprover-community/mathlib4.git" @ "'+PIN+'"\n'
lake+='\n'.join('lean_lib '+m for m in sources)+'\n'
(project/'lakefile.lean').write_text(lake)
def run(command,log,timeout=1800):
    with (out/log).open('w') as f:
        try:
            p=subprocess.run(command,cwd=project,stdout=f,stderr=subprocess.STDOUT,timeout=timeout)
            return p.returncode
        except subprocess.TimeoutExpired:
            f.write('\nTIMEOUT\n')
            return 124
assert run(['lake','update'],'lake-update.log')==0, 'lake update failed'
assert run(['lake','exe','cache','get'],'mathlib-cache.log')==0, 'cache failed'
built=[]
for row in receipt['modules']:
    m=row['module']
    if m.startswith(('Audit','Check','Print')):
        row['status']='AUDIT_SOURCE';continue
    code=run(['lake','build',m],m+'.build.log',600)
    row['status']='PASS' if code==0 else 'FAIL'
    if code==0:built.append(m)
    (out/'receipt.json').write_text(json.dumps(receipt,indent=2))
    print(m,row['status'],flush=True)
graph=(ROOT/'extract_decl_graph.lean').read_text()
graph=graph.replace('import SumSquares','\n'.join('import '+m for m in built))
graph=graph.replace('let projPrefix := `SumSquares\n  let isProj : Name → Bool := fun m => projPrefix.isPrefixOf m',
 'let projectModules : List Name := ['+', '.join('`'+m for m in built)+']\n  let isProj : Name → Bool := fun m => projectModules.contains m')
(project/'extract_decl_graph.lean').write_text(graph)
if built:
    receipt['graph_exit']=run(['lake','env','lean','extract_decl_graph.lean'],'graph.log',600)
    if (project/'decl_graph.jsonl').exists():
        (out/'decl_graph.jsonl').write_bytes((project/'decl_graph.jsonl').read_bytes())
    (project/'extract_sketch_info.lean').write_bytes((ROOT/'extract_sketch_info.lean').read_bytes())
    for m in built:
        receipt.setdefault('oracle',{})[m]=run(['lake','env','lean','--run','extract_sketch_info.lean',m+'.lean'],m+'.oracle.jsonl',600)
    if (out/'decl_graph.jsonl').exists():
        rows=[json.loads(l) for l in (out/'decl_graph.jsonl').read_text().splitlines()]
        audit='\n'.join('import '+m for m in built)+'\n'+'\n'.join('#print axioms '+r['name'] for r in rows if r['kind']=='theorem' and r['startLine']>0)+'\n'
        (project/'AuditAxioms.lean').write_text(audit)
        receipt['axioms_exit']=run(['lake','env','lean','AuditAxioms.lean'],'axioms.log',600)
(out/'receipt.json').write_text(json.dumps(receipt,indent=2))
with zipfile.ZipFile(out/'sources.zip','w',zipfile.ZIP_DEFLATED) as z:
    for p in project.glob('*.lean'):
        if not p.name.startswith('extract_'):z.write(p,p.name)
    z.write(project/'lean-toolchain','lean-toolchain')
    if (project/'lake-manifest.json').exists():z.write(project/'lake-manifest.json','lake-manifest.json')
print(json.dumps({'group':args.group,'passed':len(built),'total':len(receipt['modules'])}),flush=True)
