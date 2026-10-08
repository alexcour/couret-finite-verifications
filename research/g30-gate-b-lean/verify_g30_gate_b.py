from itertools import combinations, permutations, product
from collections import Counter, defaultdict
import json, hashlib

UNITS = [1,7,11,13,17,19,23,29]
IDX = {x:i for i,x in enumerate(UNITS)}
N=8
# Coordinates x = 29^a * 7^b mod 30, consistent with recovered Lean source.
COORD = {
    1:(0,0), 7:(0,1), 11:(1,2), 13:(0,3),
    17:(1,3), 19:(0,2), 23:(1,1), 29:(1,0)
}
CHARS = [(m,n) for m in range(2) for n in range(4)]
TRIPLETS = [tuple(c) for c in combinations(UNITS,3)]
TC = tuple(sorted((1,11,29)))

def mul(x,y): return (x*y)%30

def inv(x):
    for y in UNITS:
        if mul(x,y)==1: return y
    raise AssertionError(x)

def gadd(z,w): return (z[0]+w[0], z[1]+w[1])
def gmul(z,w): return (z[0]*w[0]-z[1]*w[1], z[0]*w[1]+z[1]*w[0])
IPOW=[(1,0),(0,1),(-1,0),(0,-1)]
def chi(m,n,x):
    a,b=COORD[x]
    s = (1,0) if (m*a)%2==0 else (-1,0)
    return gmul(s, IPOW[(n*b)%4])

def fourier_sum(T,m,n):
    z=(0,0)
    for x in T: z=gadd(z,chi(m,n,x))
    return z

def spectrum_key(T):
    return tuple(sorted(fourier_sum(T,m,n) for m,n in CHARS))

def power_key(T):
    return tuple(sorted(z[0]*z[0]+z[1]*z[1] for z in spectrum_key(T)))

def labeled_fourier_key(T):
    return tuple(fourier_sum(T,m,n) for m,n in CHARS)

def autocorr_key(T):
    # labeled directed difference/multiplicative quotient multiset c(g)=#{(x,y) in T^2: x*y^-1=g}
    c=[]
    for g in UNITS:
        count=0
        for x in T:
            for y in T:
                if mul(x, inv(y))==g: count+=1
        c.append(count)
    return tuple(c)

def adjacency_rows(T):
    rows=[]
    for x in UNITS:
        mask=0
        for t in T:
            y=mul(x,t)
            mask |= 1<<IDX[y]
        rows.append(mask)
    return tuple(rows)

PERMS = list(permutations(range(N)))

def permute_graph_code(rows,p):
    # p maps old vertex -> new vertex.
    code=0
    for old_i,rowmask in enumerate(rows):
        ni=p[old_i]
        m=rowmask
        while m:
            lsb=m & -m
            old_j=lsb.bit_length()-1
            nj=p[old_j]
            code |= 1 << (ni*N + nj)
            m-=lsb
    return code

def canonical_graph_code(T):
    rows=adjacency_rows(T)
    best=None
    for p in PERMS:
        c=permute_graph_code(rows,p)
        if best is None or c<best: best=c
    return best

def find_iso(T,U):
    rT=adjacency_rows(T); rU=adjacency_rows(U)
    target=0
    for i,row in enumerate(rU):
        for j in range(N):
            if (row>>j)&1: target |= 1 << (i*N+j)
    for p in PERMS:
        if permute_graph_code(rT,p)==target:
            return p
    return None

# Automorphisms of the group as vertex permutations.
MUL=[[IDX[mul(x,y)] for y in UNITS] for x in UNITS]
AUT=[]
for tail in permutations(range(1,N)):
    p=(0,)+tail
    ok=True
    for i in range(N):
        for j in range(N):
            if p[MUL[i][j]] != MUL[p[i]][p[j]]:
                ok=False; break
        if not ok: break
    if ok: AUT.append(p)
assert len(AUT)==8, len(AUT)

def apply_perm_triplet(T,p):
    return tuple(sorted(UNITS[p[IDX[x]]] for x in T))

def aut_orbit(T): return frozenset(apply_perm_triplet(T,p) for p in AUT)

spec_groups=defaultdict(list); pow_groups=defaultdict(list); ac_groups=defaultdict(list); lab_groups=defaultdict(list)
for T in TRIPLETS:
    spec_groups[spectrum_key(T)].append(T)
    pow_groups[power_key(T)].append(T)
    ac_groups[autocorr_key(T)].append(T)
    lab_groups[labeled_fourier_key(T)].append(T)

# Exact classwise digraph-isomorphism check.
# Isomorphism implies cospectrality (permutation similarity), so it suffices to
# exhibit an isomorphism from one representative to every member of each exact
# spectral class. This avoids 56 full canonical-label scans.
graph_class_witnesses={}
for key,grp in spec_groups.items():
    rep=grp[0]
    ws={}
    for U in grp:
        p=find_iso(rep,U)
        if p is None:
            raise AssertionError(("cospectral_not_isomorphic",rep,U))
        ws[str(U)]=list(p)
    graph_class_witnesses[str(rep)] = ws
pairwise_equal=True
graph_groups={i:grp for i,grp in enumerate(spec_groups.values(),1)}
# Aut orbits across all triplets.
seen=set(); aut_orbits=[]
for T in TRIPLETS:
    if T not in seen:
        orb=aut_orbit(T)
        aut_orbits.append(sorted(orb))
        seen |= orb
assert len(seen)==56

tc_spec=sorted(spec_groups[spectrum_key(TC)])
tc_aut_classes=[]; tc_seen=set()
for T in tc_spec:
    if T not in tc_seen:
        o=aut_orbit(T) & frozenset(tc_spec)
        tc_aut_classes.append(sorted(o)); tc_seen |= o

iso_witnesses={}
for U in tc_spec:
    p=find_iso(TC,U)
    assert p is not None
    iso_witnesses[str(U)] = {
        "old_index_to_new_index": list(p),
        "old_unit_to_new_unit": {str(UNITS[i]):UNITS[p[i]] for i in range(N)}
    }

spec_sizes=sorted(len(v) for v in spec_groups.values())
graph_sizes=sorted(len(v) for v in graph_groups.values())
pow_sizes=sorted(len(v) for v in pow_groups.values())
ac_sizes=sorted(len(v) for v in ac_groups.values())
lab_sizes=sorted(len(v) for v in lab_groups.values())

# Representatives, sorted lexicographically with class size.
classes=[]
for key,grp in sorted(spec_groups.items(), key=lambda kv:(kv[1][0],len(kv[1]))):
    classes.append({"representative":list(grp[0]),"size":len(grp),"members":[list(x) for x in sorted(grp)],"spectrum":[list(z) for z in key]})

out={
    "group":"U(30)",
    "units":UNITS,
    "triplet_count":len(TRIPLETS),
    "automorphism_count":len(AUT),
    "aut_orbit_count":len(aut_orbits),
    "spectral_class_count":len(spec_groups),
    "spectral_class_sizes":spec_sizes,
    "power_class_count":len(pow_groups),
    "power_class_sizes":pow_sizes,
    "autocorr_class_count":len(ac_groups),
    "autocorr_class_sizes":ac_sizes,
    "labeled_fourier_class_count":len(lab_groups),
    "labeled_fourier_class_sizes":lab_sizes,
    "digraph_iso_class_count":len(graph_groups),
    "digraph_iso_class_sizes":graph_sizes,
    "spectral_partition_equals_digraph_iso_partition":pairwise_equal,
    "TC":list(TC),
    "TC_spectral_fiber_size":len(tc_spec),
    "TC_spectral_fiber":[list(x) for x in tc_spec],
    "TC_aut_quotient_class_count":len(tc_aut_classes),
    "TC_aut_quotient_classes":[[list(x) for x in c] for c in tc_aut_classes],
    "TC_spectral_fiber_digraph_iso_class_count":1,
    "TC_isomorphism_witnesses":iso_witnesses,
    "spectral_classes":classes,
}
with open('/mnt/data/RESULTS_G30_GATE_B_2026-10-07.json','w') as f:
    json.dump(out,f,indent=2,sort_keys=True)

print('triplets',len(TRIPLETS))
print('Aut(G)',len(AUT),'orbits',len(aut_orbits))
print('spectral classes',len(spec_groups),spec_sizes)
print('power classes',len(pow_groups),pow_sizes)
print('autocorr classes',len(ac_groups),ac_sizes)
print('labeled Fourier classes',len(lab_groups),lab_sizes[:10], '...')
print('digraph iso classes',len(graph_groups),graph_sizes)
print('spec == digraph iso partition',pairwise_equal)
print('TC spectral fiber',tc_spec)
print('TC aut quotient classes',tc_aut_classes)
print('TC fiber digraph iso classes',1)
print('TC witnesses:')
for U,w in iso_witnesses.items(): print(U,w['old_unit_to_new_unit'])