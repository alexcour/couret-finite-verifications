"""Rebuild generated text remotely and compare each elaborated target type.

Run inside a remote project which already contains source .olean files and its
resolved .lake dependency directory. Generated files are never uploaded here.
"""
import argparse,json,pathlib,shutil,subprocess,concurrent.futures
parser=argparse.ArgumentParser()
parser.add_argument('original')
parser.add_argument('generated')
parser.add_argument('evidence')
args=parser.parse_args()
original=pathlib.Path(args.original).resolve()
generated=pathlib.Path(args.generated).resolve()
out=pathlib.Path(args.evidence).resolve()
out.mkdir(parents=True,exist_ok=True)
plan=json.loads((generated/'plan.json').read_text())
def run(root,command,name):
    with (out/name).open('w') as f:
        try:return subprocess.run(command,cwd=root,stdout=f,stderr=subprocess.STDOUT,timeout=1200).returncode
        except subprocess.TimeoutExpired:f.write('\nTIMEOUT\n');return 124
def type_script(imports,names,filename):
    return 'import Lean\n'+'\n'.join('import '+m for m in sorted(set(imports)))+'''\nopen Lean\npartial def canonicalBinders : Expr → Expr\n  | .forallE _ t b bi => .forallE .anonymous (canonicalBinders t) (canonicalBinders b) bi\n  | .lam _ t b bi => .lam .anonymous (canonicalBinders t) (canonicalBinders b) bi\n  | .letE _ t v b nondep => .letE .anonymous (canonicalBinders t) (canonicalBinders v) (canonicalBinders b) nondep\n  | .app f a => .app (canonicalBinders f) (canonicalBinders a)\n  | .mdata _ e => canonicalBinders e\n  | .proj n i e => .proj n i (canonicalBinders e)\n  | e => e\nrun_meta do\n  let names : List Name := ['''+', '.join('`'+n for n in names)+''']\n  let entries ← names.mapM fun n => do\n    let ci ← getConstInfo n\n    let levels := ci.levelParams.mapIdx fun i _ => Level.param (Name.mkSimple ("u_" ++ toString i))\n    let canonical := canonicalBinders (ci.type.instantiateLevelParams ci.levelParams levels)\n    pure (n.toString, Json.str (repr canonical).pretty)\n  IO.FS.writeFile "'''+filename+'''" (Json.mkObj entries).compress\n'''
theorems=plan['theorems']
names=[t['name'] for t in theorems]
(original/'PrintSourceTypes.lean').write_text(type_script([t['module'] for t in theorems],names,'source-types.json'))
source_exit=run(original,['lake','env','lean','PrintSourceTypes.lean'],'source-types.log')
# Reuse the already-resolved source dependencies, without copying large caches.
(generated/'.lake').mkdir(exist_ok=True)
if (original/'.lake/packages').exists():
    (generated/'.lake/packages').symlink_to(original/'.lake/packages',target_is_directory=True)
shutil.copyfile(original/'lake-manifest.json',generated/'lake-manifest.json')
def_modules=[d['path'][:-5].replace('/','.') for d in plan['definitions']]
proof_modules=[t[kind][:-5].replace('/','.') for t in theorems for kind in ['target','solution']]
checks={
    'definitions':run(generated,['lake','build']+def_modules,'definitions-build.log'),
    'theorems_and_solutions':run(generated,['lake','build']+proof_modules,'platform-build.log')
}
checks['solution_signatures']=0
if checks['definitions']==0 and checks['theorems_and_solutions']==0:
    def emit_signature(t):
        slug=t['name'].replace('.','_')
        signature_file='signature_'+slug+'.json'
        printer='import Lean\nimport '+t['solution'][:-5].replace('/','.')+'''\nopen Lean\nrun_meta do\n  let ci ← getConstInfo `'''+t['temporary_name']+'''\n  let names := ci.levelParams.mapIdx fun i _ => Name.mkSimple ("p2m_u_" ++ toString i)\n  let levels := names.map Level.param\n  let ty := ci.type.instantiateLevelParams ci.levelParams levels\n  let text ← withOptions (fun o => o.setBool `pp.fullNames true |>.setBool `pp.universes true |>.setBool `pp.explicit true |>.setBool `pp.proofs true |>.setBool `pp.notation false) do\n    pure (← Meta.ppExpr ty).pretty\n  let result := Json.mkObj [("universes", toJson (names.map Name.toString)), ("type", Json.str text)]\n  IO.FS.writeFile "'''+signature_file+'''" result.compress\n'''
        printer_file='PrintSolutionSignature_'+slug+'.lean'
        (generated/printer_file).write_text(printer)
        code=run(generated,['lake','env','lean',printer_file],'signature_'+slug+'.log')
        if code!=0:
            return code
        signature=json.loads((generated/signature_file).read_text())
        shutil.copyfile(generated/signature_file,out/signature_file)
        declarations=('universe '+' '.join(signature['universes'])+'\n') if signature['universes'] else ''
        declarations+='theorem solution : '+signature['type']+' := @_root_.'+t['temporary_name']+'\n'
        source=(generated/t['solution']).read_text()
        assert source.count('-- P2M_SOLUTION_SIGNATURE_PENDING')==1
        (generated/t['solution']).write_text(source.replace('-- P2M_SOLUTION_SIGNATURE_PENDING',declarations))
        return 0
    with concurrent.futures.ThreadPoolExecutor(max_workers=4) as pool:
        results=list(pool.map(emit_signature,theorems))
    checks['solution_signatures']=max(results,default=0)
    checks['final_solutions']=run(generated,['lake','build']+[t['solution'][:-5].replace('/','.') for t in theorems],'final-solutions.log')
else:checks['solution_signatures']=1
(generated/'PrintStagedTypes.lean').write_text(type_script([t['target'][:-5].replace('/','.') for t in theorems],names,'staged-types.json'))
staged_exit=run(generated,['lake','env','lean','PrintStagedTypes.lean'],'staged-types.log')
differences=[]
if source_exit==0 and staged_exit==0:
    a=json.loads((original/'source-types.json').read_text())
    b=json.loads((generated/'staged-types.json').read_text())
    differences=[n for n in names if a.get(n)!=b.get(n)]
else:differences=names
for root,name in [(original,'source-types.json'),(generated,'staged-types.json')]:
    if (root/name).exists():shutil.copyfile(root/name,out/name)
result={'source_types_exit':source_exit,'staged_types_exit':staged_exit,'type_differences':differences,'builds':checks,'unresolved_nodes':plan['unresolved_nodes']}
result['status']='PASS' if not differences and source_exit==0 and staged_exit==0 and all(c==0 for c in checks.values()) and not plan['unresolved_nodes'] else 'FAIL'
(out/'platform-validation.json').write_text(json.dumps(result,indent=2))
print(json.dumps({'status':result['status'],'builds':len(checks),'type_differences':len(differences)}))
