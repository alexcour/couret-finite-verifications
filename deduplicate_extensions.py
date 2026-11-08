import json,pathlib,subprocess

def remove_verified_duplicate(project,out,module,name,provider):
    def fingerprint(import_module,filename):
        text='import Lean\nimport '+import_module+'''\nopen Lean
partial def anonBinders : Expr → Expr
  | .forallE _ t b bi => .forallE .anonymous (anonBinders t) (anonBinders b) bi
  | .lam _ t b bi => .lam .anonymous (anonBinders t) (anonBinders b) bi
  | .letE _ t v b nd => .letE .anonymous (anonBinders t) (anonBinders v) (anonBinders b) nd
  | .app f a => .app (anonBinders f) (anonBinders a)
  | .mdata _ e => anonBinders e
  | .proj n i e => .proj n i (anonBinders e)
  | e => e
run_meta do
  let ci ← getConstInfo `'''+name+'''
  let levels := ci.levelParams.mapIdx fun i _ => Level.param (Name.mkSimple ("u_" ++ toString i))
  let ty := anonBinders (ci.type.instantiateLevelParams ci.levelParams levels)
  IO.FS.writeFile "'''+filename+'''" (repr ty).pretty
'''
        (project/'PrintDuplicateType.lean').write_text(text)
        subprocess.run(['lake','env','lean','PrintDuplicateType.lean'],cwd=project,check=True)
        value=(project/filename).read_bytes();(out/filename).write_bytes(value);return value
    assert fingerprint(module,'duplicate-candidate-type.txt')==fingerprint(provider,'duplicate-provider-type.txt'),'Duplicate types differ'
    facts=[json.loads(l) for l in (out/(module+'.oracle.jsonl')).read_text().splitlines() if l.startswith('{')]
    refs=[r for r in facts if r['kind']=='ref' and r['const']==name]
    decls=[d for d in facts if d['kind']=='decl' and d.get('valStart') and any(d['declStart']['offset']<=r['start']['offset'] and r['end']['offset']<=d['valStart']['offset'] for r in refs)]
    assert len(decls)==1,'Expected one binding span for duplicate'
    d=decls[0];source=project/(module+'.lean');data=source.read_bytes()
    source.write_bytes(('import '+provider+'\n').encode()+data[:d['declStart']['offset']]+data[d['declEnd']['offset']:])
    subprocess.run(['lake','build',module],cwd=project,check=True)
    with (out/(module+'.oracle.jsonl')).open('w') as f:subprocess.run(['lake','env','lean','--run','extract_sketch_info.lean',module+'.lean'],cwd=project,stdout=f,check=True)
    return {'name':name,'provider':provider,'elaborated_types_identical':True,'source_span_removed_by_lean_oracle':d,'added_import_lines':1}
