import hashlib,json,pathlib,subprocess,zipfile
root=pathlib.Path(__file__).resolve().parent
out=pathlib.Path('unified-evidence');out.mkdir()
project=pathlib.Path('project');project.mkdir()
source_dir=pathlib.Path('all-evidence')
sources={};provenance={};exclusions=[]
for receipt_path in sorted(source_dir.glob('*/receipt.json')):
    receipt=json.loads(receipt_path.read_text());group=receipt['group']
    with zipfile.ZipFile(receipt_path.parent/'sources.zip') as z:
        for row in receipt['modules']:
            old=row['module']
            if old.startswith(('Audit','Check','Print')) or old in ['Strobo2TorsExceptionProfileTwo','RecohDataBridgeReplay','RecohSelectorReplay']:
                exclusions.append({'group':group,'module':old,'reason':'audit_executable_or_redundant_historical_variant'});continue
            if group=='g30':
                exclusions.append({'group':group,'module':old,'reason':'native_axioms_require_separate_kernel_migration'});continue
            oracle=receipt_path.parent/(old+'.oracle.jsonl')
            if oracle.exists():
                facts=[json.loads(l) for l in oracle.read_text().splitlines() if l.startswith('{')]
                if any(f.get('kind')=='decl' and f.get('nameText')=='main' for f in facts):
                    exclusions.append({'group':group,'module':old,'reason':'executable_entry_point'});continue
            data=z.read(old+'.lean')
            original=data
            module=old
            if group in ['bc-minimality','bc-saturation']:
                replacement='BCS4MaskSemantics' if group=='bc-minimality' else 'BCS5MaskSemantics'
                if old=='MaskSemantics':module=replacement
                data=data.replace(b'import MaskSemantics',('import '+replacement).encode())
            if module in sources and sources[module]!=data:
                raise ValueError('Unresolved nonidentical module variant: '+module)
            sources[module]=data
            provenance.setdefault(module,[]).append({'group':group,'source':receipt['source'],'module':old,'source_path':row['source_path'],'original_sha256':hashlib.sha256(original).hexdigest()})
assert sources
for m,data in sources.items():(project/(m+'.lean')).write_bytes(data)
pin='c5ea00351c28e24afc9f0f84379aa41082b1188f'
(project/'lean-toolchain').write_text('leanprover/lean4:v4.30.0\n')
lake='import Lake\nopen Lake DSL\npackage CouretUnified where\nrequire mathlib from git "https://github.com/leanprover-community/mathlib4.git" @ "'+pin+'"\n'
lake+='\n'.join('lean_lib '+m for m in sorted(sources))+'\n'
(project/'lakefile.lean').write_text(lake)
receipt={'group':'unified','source':{'records':[23980513,23981308,23981750,23983731,23989640],'github_source':'65b828d9ffd016ce2a1b05403f303fa5f948c10f','source_run':42495420377},'mathlib_rev':pin,'toolchain':'leanprover/lean4:v4.30.0','modules':[{'module':m,'source_path':provenance[m][0]['source_path'],'sha256':hashlib.sha256(sources[m]).hexdigest(),'original_locations':provenance[m],'status':'NOT_RUN'} for m in sorted(sources)],'exclusions':exclusions,'targets':['Couret.DecisionInterface.factorization_on_image_iff']}
(out/'receipt.json').write_text(json.dumps(receipt,indent=2))
def run(command,log,timeout=3600):
    with (out/log).open('w') as f:
        try:return subprocess.run(command,cwd=project,stdout=f,stderr=subprocess.STDOUT,timeout=timeout).returncode
        except subprocess.TimeoutExpired:f.write('\nTIMEOUT\n');return 124
assert run(['lake','update'],'lake-update.log')==0
assert run(['lake','exe','cache','get'],'cache.log')==0
build=run(['lake','build']+sorted(sources),'source-build.log')
receipt['source_build_exit']=build
(out/'receipt.json').write_text(json.dumps(receipt,indent=2))
if build!=0:raise SystemExit('Unified source build needs repair; no publication performed')
for row in receipt['modules']:row['status']='PASS'
graph=(root/'extract_decl_graph.lean').read_text()
graph=graph.replace('import SumSquares','import Lean\n'+'\n'.join('import '+m for m in sorted(sources)))
graph=graph.replace('let projPrefix := `SumSquares\n  let isProj : Name → Bool := fun m => projPrefix.isPrefixOf m','let projectModules : List Name := ['+', '.join('`'+m for m in sorted(sources))+']\n  let isProj : Name → Bool := fun m => projectModules.contains m')
(project/'extract_decl_graph.lean').write_text(graph)
receipt['graph_exit']=run(['lake','env','lean','extract_decl_graph.lean'],'graph.log')
if receipt['graph_exit']!=0:raise SystemExit('Unified declaration extraction needs repair')
(out/'decl_graph.jsonl').write_bytes((project/'decl_graph.jsonl').read_bytes())
(project/'extract_sketch_info.lean').write_bytes((root/'extract_sketch_info.lean').read_bytes())
receipt['oracle']={}
for m in sorted(sources):
    code=run(['lake','env','lean','--run','extract_sketch_info.lean',m+'.lean'],m+'.oracle.jsonl',600)
    receipt['oracle'][m]=code
    print(m,'ORACLE',code,flush=True)
rows=[json.loads(l) for l in (out/'decl_graph.jsonl').read_text().splitlines()]
audit='import Lean\n'+'\n'.join('import '+m for m in sorted(sources))+'\n'+'\n'.join('#print axioms '+r['name'] for r in rows if r['kind']=='theorem' and r['startLine']>0 and not r['isPrivate'])+'\n'
(project/'AuditAxioms.lean').write_text(audit)
receipt['axioms_exit']=run(['lake','env','lean','AuditAxioms.lean'],'axioms.log')
(out/'receipt.json').write_text(json.dumps(receipt,indent=2))
with zipfile.ZipFile(out/'sources.zip','w',zipfile.ZIP_DEFLATED) as z:
    for m in sorted(sources):z.write(project/(m+'.lean'),m+'.lean')
    for n in ['lakefile.lean','lean-toolchain','lake-manifest.json']:z.write(project/n,n)
subprocess.run(['python',str(root/'generate_platform.py'),str(out),'generated'],check=True)
subprocess.run(['python',str(root/'parse_axioms.py'),str(out/'axioms.log'),'generated/plan.json','generated/axioms.json'],check=True)
subprocess.run(['python',str(root/'validate_platform.py'),'project','generated','generated/validation'],check=True)
result=json.loads(pathlib.Path('generated/validation/platform-validation.json').read_text())
if result['status']!='PASS':raise SystemExit('Generated migration needs repair; no publication performed')
