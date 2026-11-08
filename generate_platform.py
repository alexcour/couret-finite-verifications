"""Plan platform files from Lean-generated declaration spans and dependencies.

Input: a completed remote evidence directory with sources.zip, decl_graph.jsonl,
and *.oracle.jsonl. No declaration boundary is inferred from a text search.
All generated text still requires compilation and an elaborated-type comparison.
"""
import argparse, collections, functools, hashlib, json, pathlib, re, zipfile

parser=argparse.ArgumentParser()
parser.add_argument('evidence')
parser.add_argument('destination')
args=parser.parse_args()
evidence=pathlib.Path(args.evidence)
dest=pathlib.Path(args.destination)
dest.mkdir(parents=True,exist_ok=True)
receipt=json.loads((evidence/'receipt.json').read_text())
rows=[json.loads(l) for l in (evidence/'decl_graph.jsonl').read_text().splitlines() if l.strip()]
graph={r['name']:r for r in rows}
sources={}
with zipfile.ZipFile(evidence/'sources.zip') as z:
    for row in receipt['modules']:
        m=row['module']
        if row['status']=='PASS' and receipt.get('oracle',{}).get(m)==0:
            sources[m]=z.read(m+'.lean')
oracles={}
for m in sources:
    facts=[]
    for line in (evidence/(m+'.oracle.jsonl')).read_text().splitlines():
        if line.startswith('{'):
            facts.append(json.loads(line))
    oracles[m]=facts
decls={m:[f for f in facts if f['kind']=='decl'] for m,facts in oracles.items()}
def join(row):
    candidates=[d for d in decls.get(row['module'],[]) if d['declStart']['line']<=row['startLine']<=d['declEnd']['line']]
    return min(candidates,key=lambda d:d['declEnd']['offset']-d['declStart']['offset']) if candidates else None
joined={n:join(r) for n,r in graph.items() if r['startLine']>0}
def key(row):
    d=joined.get(row['name'])
    return (row['module'],d['declStart']['offset'],d['declEnd']['offset']) if d else None
units=collections.defaultdict(list)
for row in rows:
    if key(row):units[key(row)].append(row)
def theorem_unit(row):
    unit=units.get(key(row),[])
    return row['kind']=='theorem' and not any(r['kind'] in ['def','inductive','opaque','axiom'] for r in unit)
source_refs=collections.defaultdict(set)
for m,facts in oracles.items():
    for ref in facts:
        if ref['kind']!='ref':continue
        name=ref['const']
        if name not in graph:
            matches=[r['name'] for r in rows if r['module']==m and r['isPrivate'] and name.endswith('.'+r['userName'])]
            if len(matches)!=1:continue
            name=matches[0]
        for d in decls[m]:
            if d['declStart']['offset']<=ref['start']['offset']<d['declEnd']['offset']:
                k=(m,d['declStart']['offset'],d['declEnd']['offset'])
                for row in units[k]:
                    if name!=row['name']:source_refs[row['name']].add(name)
def deps(n):
    r=graph.get(n,{})
    return set(r.get('typeDeps',[])+r.get('valueDeps',[]))|source_refs[n]
def closure(seeds):
    result=set();work=list(seeds)
    while work:
        n=work.pop()
        if n in result:continue
        result.add(n);work.extend(deps(n)-result)
    return result
# Definitions need actual proofs for all supporting proof constants, never stubs.
def_roots={r['name'] for r in rows if r['module'] in sources and joined.get(r['name']) and ((not theorem_unit(r) and not r['isPrivate']) or r['isInstance'])}
embedded=closure(def_roots)
active_defs={r['module'] for r in rows if r['module'] in sources and joined.get(r['name']) and r['name'] in embedded}
# This source module provides an opened namespace even when its result bodies
# become separate theorem nodes. Preserve that namespace through its interface.
if 'AffineEquivalenceTransport' in sources:active_defs.add('AffineEquivalenceTransport')
module_imports={m:[p for line in data.decode('utf-8-sig').splitlines() if line.startswith('import ') for p in line[7:].split() if p in sources] for m,data in sources.items()}
external_imports={m:[p for line in data.decode('utf-8-sig').splitlines() if line.startswith('import ') for p in line[7:].split() if p not in sources] for m,data in sources.items()}
@functools.cache
def inherited_external(m):
    return set(external_imports[m]).union(*(inherited_external(p) for p in module_imports[m]))
provider_cache={}
def providers(m,active=()):
    if m in active_defs:return [m]
    if m in provider_cache:return provider_cache[m]
    if m in active:raise ValueError('Import forwarding cycle: '+m)
    provider_cache[m]=list(dict.fromkeys(p for child in module_imports[m] for p in providers(child,active+(m,))))
    return provider_cache[m]
crossfile={d for r in rows for d in deps(r['name']) if d in graph and graph[d]['module']!=r['module']}
type_theorems={d for r in rows for d in r['typeDeps'] if d in graph and theorem_unit(graph[d])}
nodes=set()
skipped=[]
for r in rows:
    n=r['name'];d=joined.get(n)
    if r['module'] not in sources or not d or not theorem_unit(r) or r['isPrivate'] or n in embedded:continue
    if not re.fullmatch(r'[A-Za-z_][A-Za-z0-9_.]*',n):
        skipped.append({'name':n,'reason':'identifier_requires_oracle_based_rename'});continue
    length=d['declEnd']['line']-(d['valStart'] or d['declStart'])['line']
    if length>10 or n in crossfile or n in type_theorems:nodes.add(n)
# Preserve one capstone per source module even when it has a short proof.
for m in sources:
    candidates=[r for r in rows if r['module']==m and joined.get(r['name']) and theorem_unit(r) and not r['isPrivate'] and r['name'] not in embedded and re.fullmatch(r'[A-Za-z_][A-Za-z0-9_.]*',r['name'])]
    if candidates:nodes.add(max(candidates,key=lambda r:r['startLine'])['name'])
for n in receipt.get('targets',[]):
    if n not in graph or not joined.get(n) or not theorem_unit(graph[n]):raise ValueError('Unknown requested capstone: '+n)
    if n not in embedded:nodes.add(n)
modules={m:m for m in sources}
def keep_span_names(m,keep):
    return {key(graph[n]) for n in keep if n in graph and graph[n]['module']==m and key(graph[n])}
def skeleton(m,keep,extra_imports=(),stub=None,rename_target=None):
    data=sources[m];edits=[];wanted=keep_span_names(m,keep)
    for d in decls[m]:
        k=(m,d['declStart']['offset'],d['declEnd']['offset'])
        if k not in wanted:edits.append((k[1],k[2],b''))
    if stub:
        d=joined[stub]
        assert d['valStart'] is not None
        a=d['declStart']['offset'];v=d['valStart']['offset'];b=d['declEnd']['offset']
        header=data[a:v]
        if d.get('docstring'):
            da=d['docstring']['start']['offset']-a;db=d['docstring']['end']['offset']-a
            header=header[:da]+header[db:]
        edits.append((a,b,b'-- P2M_TARGET_BEGIN\n'+header+b':= by sorry\n-- P2M_TARGET_END\n'))
    if rename_target:
        d=joined[rename_target]
        refs=[r for r in oracles[m] if r['kind']=='ref' and r['const']==rename_target and d['declStart']['offset']<=r['start']['offset']<d['declEnd']['offset']]
        binding=[r for r in refs if r['end']['offset']<=d['valStart']['offset']]
        if len(binding)!=1:raise ValueError('Expected one elaborator binding range: '+rename_target)
        temp='p2m_local_'+rename_target.rsplit('.',1)[-1]
        fully_qualified=rename_target.rsplit('.',1)[0]+'.'+temp if '.' in rename_target else temp
        for ref in refs:
            a=ref['start']['offset'];b=ref['end']['offset']
            if ref is binding[0]:
                original=data[a:b].decode()
                replacement=original.rsplit('.',1)[0]+'.'+temp if '.' in original else temp
            else:replacement='_root_.'+fully_qualified
            edits.append((a,b,replacement.encode()))
    for a,b,value in sorted(edits,reverse=True):data=data[:a]+value+data[b:]
    lines=data.decode('utf-8-sig').splitlines()
    rewritten=[]
    for line in lines:
        if line.startswith('import '):
            imports=line[7:].split()
            for p in imports:
                if p in sources:rewritten.extend('import Definitions.Def_'+modules[q] for q in providers(p))
                else:rewritten.append('import '+p)
        elif line.startswith(('#print ','#check ','#eval ')):
            continue
        else:rewritten.append(line)
    # Reapply source-local instance attributes to the imported canonical
    # constants. The instance declarations themselves live in the Def bundle.
    local_attrs=[]
    if stub or rename_target:
        for d in decls[m]:
            if not d.get('localInstance'):continue
            k=(m,d['declStart']['offset'],d['declEnd']['offset'])
            for r in units[k]:
                if r['kind']=='def' and not r['isPrivate'] and r['name'] in embedded:
                    local_attrs.append('attribute [local instance] '+r['name'])
    prefix=['import '+p for p in sorted(set(extra_imports)|inherited_external(m))]
    if local_attrs:
        imports=list(dict.fromkeys(prefix+[line for line in rewritten if line.startswith('import ')]))
        return '\n'.join(imports+list(dict.fromkeys(local_attrs))+[line for line in rewritten if not line.startswith('import ')])+'\n'
    return '\n'.join(prefix+rewritten)+'\n'
# Bundle identities include the selected source skeleton, environment and the
# full dependency fingerprint. Identical imported bundles can be reused across
# source groups; a changed source or import closure receives a distinct name.
abstract={m:skeleton(m,{n for n in embedded if n in graph and graph[n]['module']==m}) for m in sources}
fingerprints={}
def fingerprint(m,active=()):
    if m in fingerprints:return fingerprints[m]
    if m in active:raise ValueError('Module import cycle: '+m)
    imports=re.findall(r'^import Definitions\.Def_([^\s]+)$',abstract[m],re.M)
    children=[(p,fingerprint(p,active+(m,))) for p in imports if p in sources]
    fingerprints[m]=hashlib.sha256(json.dumps([receipt['mathlib_rev'],abstract[m],children],sort_keys=True).encode()).hexdigest()
    return fingerprints[m]
modules={m:'Couret_'+m+'_'+fingerprint(m)[:12] for m in active_defs}
for folder in ['Definitions','Theorems','Solutions']:(dest/folder).mkdir(exist_ok=True)
plan={'source':receipt['source'],'mathlib_rev':receipt['mathlib_rev'],'group':receipt['group'],'definitions':[],'theorems':[],'skipped':skipped,'status':'GENERATED_UNCOMPILED'}
for m in sorted(active_defs):
    keep={n for n in embedded if n in graph and graph[n]['module']==m}
    text=skeleton(m,keep)
    path='Definitions/Def_'+modules[m]+'.lean'
    (dest/path).write_text(text)
    plan['definitions'].append({'module':m,'definition_name':modules[m],'path':path,'source_path':next(r['source_path'] for r in receipt['modules'] if r['module']==m)})
for n in sorted(nodes):
    row=graph[n];m=row['module'];needed=set();child=set();work=list(deps(n));blocked=[]
    while work:
        d=work.pop()
        if d in needed or d==n:continue
        if d in nodes:child.add(d);continue
        if d in embedded and not graph.get(d,{}).get('isPrivate'):continue
        if d not in graph:continue
        if not joined.get(d):work.extend(deps(d));continue
        if graph[d]['module']!=m:
            blocked.append(d);continue
        needed.add(d);work.extend(deps(d))
    if blocked:
        plan['skipped'].append({'name':n,'reason':'unresolved_cross_module_helper','dependencies':sorted(set(blocked))});continue
    slug=n.replace('.','_')
    imports=['Definitions.Def_'+modules[p] for p in providers(m)]+['Theorems.Thm_'+d.replace('.','_') for d in child]
    stub=skeleton(m,{n},imports,stub=n)
    preamble, rest=stub.split('-- P2M_TARGET_BEGIN\n',1)
    formal, tail=rest.split('-- P2M_TARGET_END\n',1)
    formal_statement=formal+tail
    stub=preamble+formal_statement
    temporary=n.rsplit('.',1)[0]+'.p2m_local_'+n.rsplit('.',1)[-1] if '.' in n else 'p2m_local_'+n
    solution=skeleton(m,needed|{n},imports,rename_target=n)+'\n-- P2M_SOLUTION_SIGNATURE_PENDING\n'
    target='Theorems/Thm_'+slug+'.lean';proof='Solutions/Sol_'+slug+'.lean'
    (dest/target).write_text(stub);(dest/proof).write_text(solution)
    plan['theorems'].append({'name':n,'module':m,'target':target,'solution':proof,'temporary_name':temporary,'preamble':preamble,'formal_statement':formal_statement,'children':sorted(child),'source_path':next(r['source_path'] for r in receipt['modules'] if r['module']==m),'start_line':joined[n]['declStart']['line'],'end_line':joined[n]['declEnd']['line']})
# A missing child is a gate failure, not a silently omitted proof dependency.
names={t['name'] for t in plan['theorems']}
plan['unresolved_nodes']=sorted({c for t in plan['theorems'] for c in t['children'] if c not in names})
(dest/'plan.json').write_text(json.dumps(plan,indent=2))
(dest/'lean-toolchain').write_text(receipt['toolchain']+'\n')
lake='import Lake\nopen Lake DSL\npackage CouretPlatform where\nrequire mathlib from git "https://github.com/leanprover-community/mathlib4.git" @ "'+receipt['mathlib_rev']+'"\nlean_lib Definitions\nlean_lib Theorems\nlean_lib Solutions\n'
(dest/'lakefile.lean').write_text(lake)
print(json.dumps({'definitions':len(plan['definitions']),'theorems':len(plan['theorems']),'skipped':len(plan['skipped']),'unresolved_nodes':plan['unresolved_nodes']}))
