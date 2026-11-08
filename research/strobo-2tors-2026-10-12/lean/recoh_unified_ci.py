from pathlib import Path
import hashlib,json,os,re,subprocess,time

R=Path(__file__).resolve().parent
os.chdir(R)
sha=lambda b:hashlib.sha256(b).hexdigest()
manifest=json.loads((R/'RECOH_UNIFIED_SOURCES.json').read_text())
expected=os.environ['SOURCE_SHA']
checkout=subprocess.check_output(['git','rev-parse','HEAD'],text=True).strip()
assert checkout==expected, 'Checkout does not match the workflow source commit'
assert os.environ['GITHUB_SHA']==expected
for item in manifest['files']:
    assert sha((R/item['path']).read_bytes())==item['sha256'],item['path']
assert len(manifest['project_modules'])==37
logs=R/'ci-evidence';logs.mkdir(exist_ok=True)
receipts=[]
def run(name,args,expect_failure=False):
    t=time.monotonic()
    p=subprocess.run(args,capture_output=True,text=True,encoding='utf-8',timeout=1500)
    out=p.stdout+p.stderr;(logs/(name+'.log')).write_text(out,encoding='utf-8')
    print(out,flush=True)
    if expect_failure:
        assert p.returncode!=0 and out.count('error:')==1 and 'is false' in out
    else:assert p.returncode==0, name+' failed'
    receipts.append({'step':name,'exit_code':p.returncode,'seconds':time.monotonic()-t,'log_sha256':sha(out.encode())})
    return out

version=subprocess.check_output(['lean','--version'],text=True).strip()
assert 'version 4.29.1' in version
run('build',['lake','--no-cache','--no-ansi','build'])
for name in manifest['project_modules']:
    assert (R/'.lake/build/lib/lean'/(name+'.olean')).is_file(),name
audit=run('axioms',['lake','env','lean','PortAudit.lean'])
roots=re.findall(r'^#print axioms (\S+)',(R/'PortAudit.lean').read_text(),re.M)
assert len(roots)==23
axioms={n:[] if d.startswith('does not') else [a.strip() for a in d.split('[',1)[1][:-1].split(',')] for n,d in re.findall(r"'([^']+)' (does not depend on any axioms|depends on axioms: \[[^\]]*\])",audit)}
allowed={'propext','Classical.choice','Quot.sound'}
assert set(axioms)==set(roots)
assert all(set(xs)<=allowed for xs in axioms.values())
run('negative',['lake','env','lean','PortNegative.lean'],expect_failure=True)
dependencies=[]
for p in json.loads((R/'lake-manifest.json').read_text())['packages']:
    path=R/'.lake/packages'/p['name']
    rev=subprocess.check_output(['git','rev-parse','HEAD'],cwd=path,text=True).strip()
    dirty=subprocess.check_output(['git','status','--porcelain','--untracked-files=no'],cwd=path,text=True).strip()
    assert rev==p['rev'] and not dirty,p['name']
    dependencies.append({'name':p['name'],'revision':rev,'tracked_clean':True})
receipt={'result':'PASS_PUBLIC_PORT_EXACT_SHA_CI','source_commit':expected,'checkout_commit':checkout,'workflow_run':os.environ['GITHUB_RUN_ID'],'lean':version,'project_modules':37,'source_manifest':manifest,'steps':receipts,'axiom_roots':23,'axioms':axioms,'axiom_allowlist':sorted(allowed),'native_or_sorry_axioms':False,'negative_expected_rejection':True,'dependencies':dependencies,'original_pr96_branch_modified':False,'selector_1874_cases_replayed':False,'scope':'Dedicated public port from pinned PR96. This certificate is limited to the tested source commit; it is not a merge or release.'}
(logs/'CI_RECOH_RECEIPT.json').write_text(json.dumps(receipt,indent=2)+'\n')
print('RECOH_RECEIPT_JSON '+json.dumps(receipt,separators=(',',':')),flush=True)
print('RECOH_EXACT_SHA_CI_PASS '+expected,flush=True)
