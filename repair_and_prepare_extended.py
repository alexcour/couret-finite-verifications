import concurrent.futures,hashlib,json,pathlib,shutil,subprocess,zipfile
root=pathlib.Path(__file__).resolve().parent
out=pathlib.Path('unified-evidence');shutil.copytree('recovered/unified-evidence',out)
project=pathlib.Path('project');project.mkdir()
with zipfile.ZipFile(out/'sources.zip') as z:z.extractall(project)
cache=pathlib.Path('recovered/project/.lake/build')
if cache.exists():shutil.copytree(cache,project/'.lake/build',dirs_exist_ok=True)
receipt=json.loads((out/'receipt.json').read_text())
repairs=json.loads((root/'proof-repairs.json').read_text())
def run(command,log,allow_failure=False,timeout=3600):
    print('BEGIN',log,flush=True)
    with (out/log).open('w') as f:
        try:code=subprocess.run(command,cwd=project,stdout=f,stderr=subprocess.STDOUT,timeout=timeout).returncode
        except subprocess.TimeoutExpired:code=124
    print('END',log,code,flush=True)
    if code and not allow_failure:raise SystemExit('Check failed: '+log)
    return code
run(['lake','update'],'repair-lake-update.log')
run(['lake','exe','cache','get'],'repair-cache.log')
(project/'extract_sketch_info.lean').write_bytes((root/'extract_sketch_info.lean').read_bytes())
def type_probe(module,names,label):
    source=(project/(module+'.lean')).read_text()
    printer='import Lean\n'+source+'''\nopen Lean
partial def p2mRepairCanonical : Expr → Expr
  | .forallE _ t b bi => .forallE .anonymous (p2mRepairCanonical t) (p2mRepairCanonical b) bi
  | .lam _ t b bi => .lam .anonymous (p2mRepairCanonical t) (p2mRepairCanonical b) bi
  | .letE _ t v b nd => .letE .anonymous (p2mRepairCanonical t) (p2mRepairCanonical v) (p2mRepairCanonical b) nd
  | .app f a => .app (p2mRepairCanonical f) (p2mRepairCanonical a)
  | .mdata _ e => p2mRepairCanonical e
  | .proj n i e => .proj n i (p2mRepairCanonical e)
  | e => e
run_meta do
  let names : List Name := ['''+', '.join('`'+n for n in names)+''']
  let entries ← names.mapM fun n => do
    let ci ← getConstInfo n
    let levels := ci.levelParams.mapIdx fun i _ => Level.param (Name.mkSimple ("u_" ++ toString i))
    let ty := p2mRepairCanonical (ci.type.instantiateLevelParams ci.levelParams levels)
    pure (n.toString, Json.str (repr ty).pretty)
  IO.FS.writeFile "repair-types.json" (Json.mkObj entries).compress
'''
    (project/'ProbeRepairTypes.lean').write_text(printer)
    result=project/'repair-types.json'
    if result.exists():result.unlink()
    code=run(['lake','env','lean','ProbeRepairTypes.lean'],module+'.'+label+'-types.log',True)
    if not result.exists():raise SystemExit('Original statement types unavailable; no proof repair allowed')
    shutil.copyfile(result,out/(module+'.'+label+'-types.json'))
    return json.loads(result.read_text()),code
for module,spec in repairs.items():
    path=project/(module+'.lean');original=path.read_bytes()
    assert hashlib.sha256(original).hexdigest()==spec['expected_sha256']
    before,before_rc=type_probe(module,list(spec['proofs']),'before')
    run(['lake','env','lean','--run','extract_sketch_info.lean',module+'.lean'],module+'.repair-oracle.jsonl',True)
    facts=[json.loads(l) for l in (out/(module+'.repair-oracle.jsonl')).read_text().splitlines() if l.startswith('{')]
    decls=[f for f in facts if f['kind']=='decl'];assert decls,'No authoritative parser spans'
    changes=[];headers={}
    for name,proof in spec['proofs'].items():
        candidates=[d for d in decls if d.get('nameText')==name.rsplit('.',1)[-1]]
        assert len(candidates)==1 and candidates[0]['valKind']=='simple'
        d=candidates[0];a=d['valStart']['offset'];b=d['declEnd']['offset']
        headers[name]=hashlib.sha256(original[d['declStart']['offset']:a]).hexdigest()
        changes.append((a,b,(':= '+proof).encode()))
    data=original
    for a,b,value in sorted(changes,reverse=True):data=data[:a]+value+data[b:]
    path.write_bytes(data)
    run(['lake','build',module],module+'.repaired-build.log')
    after,after_rc=type_probe(module,list(spec['proofs']),'after')
    assert after_rc==0 and before==after,'Repaired theorem types differ'
    m=next(m for m in receipt['modules'] if m['module']==module)
    m['status']='PASS';m['sha256']=hashlib.sha256(data).hexdigest()
    m['proof_repairs']={'names':list(spec['proofs']),'before_had_errors':before_rc!=0,'elaborated_types_identical':True,'original_statement_header_hashes':headers}
    m['source_declaration_spans']={spec['namespace']+'.'+d['nameText']:{'start':d['declStart']['line'],'end':d['declEnd']['line']} for d in decls if d.get('nameText')}
    (out/'receipt.json').write_text(json.dumps(receipt,indent=2))
for module in ['STROBO2Tors','CouretOaiBridge01']:
    run(['lake','build',module],module+'.repaired-build.log')
    next(m for m in receipt['modules'] if m['module']==module)['status']='PASS'
modules=[m['module'] for m in receipt['modules'] if m['status']=='PASS']
assert not any(m['status']=='FAIL' for m in receipt['modules']),'Unresolved source errors'
# Refresh added-module facts so local instance modifiers and repaired spans are
# taken from the exact successfully elaborated source text.
new_modules={m['module'] for m in json.loads((root/'extensions-manifest.json').read_text())['modules']}
def oracle(module):
    code=run(['lake','env','lean','--run','extract_sketch_info.lean',module+'.lean'],module+'.oracle.jsonl',timeout=900)
    return module,code
with concurrent.futures.ThreadPoolExecutor(max_workers=2) as pool:
    for name,code in pool.map(oracle,[m for m in modules if m in new_modules]):receipt['oracle'][name]=code
graph=(root/'extract_decl_graph.lean').read_text().replace('import SumSquares','import Lean\n'+'\n'.join('import '+m for m in sorted(modules)))
graph=graph.replace('let projPrefix := `SumSquares\n  let isProj : Name → Bool := fun m => projPrefix.isPrefixOf m','let projectModules : List Name := ['+', '.join('`'+m for m in sorted(modules))+']\n  let isProj : Name → Bool := fun m => projectModules.contains m')
(project/'extract_decl_graph.lean').write_text(graph)
run(['lake','env','lean','extract_decl_graph.lean'],'final-source-graph.log')
(out/'decl_graph.jsonl').write_bytes((project/'decl_graph.jsonl').read_bytes())
rows=[json.loads(l) for l in (out/'decl_graph.jsonl').read_text().splitlines()]
(project/'AuditAxioms.lean').write_text('import Lean\n'+'\n'.join('import '+m for m in sorted(modules))+'\n'+'\n'.join('#print axioms '+r['name'] for r in rows if r['kind']=='theorem' and r['startLine']>0 and not r['isPrivate'])+'\n')
receipt['axioms_exit']=run(['lake','env','lean','AuditAxioms.lean'],'axioms.log')
receipt['graph_exit']=0
(out/'receipt.json').write_text(json.dumps(receipt,indent=2))
with zipfile.ZipFile(out/'sources.zip','w',zipfile.ZIP_DEFLATED) as z:
    for m in receipt['modules']:z.write(project/(m['module']+'.lean'),m['module']+'.lean')
    for name in ['lakefile.lean','lean-toolchain','lake-manifest.json']:z.write(project/name,name)
subprocess.run(['python',str(root/'generate_platform.py'),str(out),'generated'],check=True)
subprocess.run(['python',str(root/'parse_axioms.py'),str(out/'axioms.log'),'generated/plan.json','generated/axioms.json'],check=True)
