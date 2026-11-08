"""Plan platform files from Lean-generated declaration spans and dependencies.

Input: a completed remote evidence directory with sources.zip, decl_graph.jsonl,
and *.oracle.jsonl. No declaration boundary is inferred from a text search.
All generated text still requires compilation and an elaborated-type comparison.
"""
import argparse, collections, json, pathlib, re, zipfile

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
def deps(n):
    r=graph.get(n,{})
    return set(r.get('typeDeps',[])+r.get('valueDeps',[]))
def closure(seeds):
    result=set();work=list(seeds)
    while work:
        n=work.pop()
        if n in result:continue
        result.add(n);work.extend(deps(n)-result)
    return result
# Definitions need actual proofs for all supporting proof constants, never stubs.
def_roots={r['name'] for r in rows if r['module'] in sources and joined.get(r['name']) and not theorem_unit(r)}
embedded=closure(def_roots)
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
modules={m:'Couret_'+receipt['group'].replace('-','_')+'_'+m for m in sources}
def keep_span_names(m,keep):
    return {key(graph[n]) for n in keep if n in graph and graph[n]['module']==m and key(graph[n])}
def skeleton(m,keep,extra_imports=(),stub=None):
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
    for a,b,value in sorted(edits,reverse=True):data=data[:a]+value+data[b:]
    lines=data.decode('utf-8-sig').splitlines()
    rewritten=[]
    for line in lines:
        if line.startswith('import '):
            imports=line[7:].split()
            rewritten.extend('import Definitions.Def_'+modules[p] if p in modules else 'import '+p for p in imports)
        elif line.startswith(('#print ','#check ','#eval ')):
            continue
        else:rewritten.append(line)
    # Extra imports precede every namespace/section and preserve all source scope.
    return '\n'.join(['import '+p for p in sorted(set(extra_imports))]+rewritten)+'\n'
for folder in ['Definitions','Theorems','Solutions']:(dest/folder).mkdir(exist_ok=True)
plan={'source':receipt['source'],'mathlib_rev':receipt['mathlib_rev'],'group':receipt['group'],'definitions':[],'theorems':[],'skipped':skipped,'status':'GENERATED_UNCOMPILED'}
for m in sources:
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
        if d in embedded:continue
        if d not in graph:continue
        if not joined.get(d):work.extend(deps(d));continue
        if graph[d]['module']!=m:
            blocked.append(d);continue
        needed.add(d);work.extend(deps(d))
    if blocked:
        plan['skipped'].append({'name':n,'reason':'unresolved_cross_module_helper','dependencies':sorted(set(blocked))});continue
    slug=n.replace('.','_')
    imports=['Definitions.Def_'+modules[m]]+['Theorems.Thm_'+d.replace('.','_') for d in child]
    stub=skeleton(m,{n},imports,stub=n)
    preamble, rest=stub.split('-- P2M_TARGET_BEGIN\n',1)
    formal, tail=rest.split('-- P2M_TARGET_END\n',1)
    formal_statement=formal+tail
    stub=preamble+formal_statement
    solution=skeleton(m,needed|{n},imports)+'\ntheorem solution := @'+n+'\n'
    target='Theorems/Thm_'+slug+'.lean';proof='Solutions/Sol_'+slug+'.lean'
    (dest/target).write_text(stub);(dest/proof).write_text(solution)
    plan['theorems'].append({'name':n,'module':m,'target':target,'solution':proof,'preamble':preamble,'formal_statement':formal_statement,'children':sorted(child),'source_path':next(r['source_path'] for r in receipt['modules'] if r['module']==m),'start_line':joined[n]['declStart']['line'],'end_line':joined[n]['declEnd']['line']})
# A missing child is a gate failure, not a silently omitted proof dependency.
names={t['name'] for t in plan['theorems']}
plan['unresolved_nodes']=sorted({c for t in plan['theorems'] for c in t['children'] if c not in names})
(dest/'plan.json').write_text(json.dumps(plan,indent=2))
(dest/'lean-toolchain').write_text(receipt['toolchain']+'\n')
lake='import Lake\nopen Lake DSL\npackage CouretPlatform where\nrequire mathlib from git "https://github.com/leanprover-community/mathlib4.git" @ "'+receipt['mathlib_rev']+'"\nlean_lib Definitions\nlean_lib Theorems\nlean_lib Solutions\n'
(dest/'lakefile.lean').write_text(lake)
print(json.dumps({'definitions':len(plan['definitions']),'theorems':len(plan['theorems']),'skipped':len(plan['skipped']),'unresolved_nodes':plan['unresolved_nodes']}))
