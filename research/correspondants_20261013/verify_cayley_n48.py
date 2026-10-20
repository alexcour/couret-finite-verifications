#!/usr/bin/env python3
"""Exact n=48 exceptional triple-square Cayley isomorphism census.

All calculations use Python's standard library and integer arithmetic.
The graph isomorphism decisions are justified by an intrinsic quotient
cycle invariant or an explicit unit permutation, never by a failure of a
black-box graph isomorphism search.

Reproduce:
  python3 verify_cayley_n48.py > CAYLEY_N48_RESULTS.json
"""
import json
from collections import Counter, defaultdict
from itertools import combinations
from math import comb, gcd

N = 48
H = 24


def ordered_square(n, support):
    return tuple(sorted((x+y) % n for x in support for y in support))


def plus_h(n, support):
    h = n//2
    return tuple(sorted((x+h) % n for x in support))


def unit_image(n, support, u):
    assert gcd(n,u) == 1
    return tuple(sorted((u*x) % n for x in support))


def parameters(n, support):
    h = n//2
    s = set(support)
    pair = [(b,b+h) for b in range(h) if b in s and b+h in s]
    assert len(pair) == 1
    b, bh = pair[0]
    a, = s-{b,bh}
    assert (a-b) % h != 0
    assert (3*(a-b)) % h == 0
    return a,b


def neighbors(n, support, symmetric=False):
    increments = set(support)
    if symmetric:
        increments |= {(-x)%n for x in support}
    assert 0 not in increments
    return [frozenset((x+d)%n for d in increments) for x in range(n)]


def adjacency_square_from_walks(adj):
    """Independent explicit adjacency two-step paths, not nine-sum enumeration."""
    n=len(adj)
    out=[]
    for x in range(n):
        v=[0]*n
        for y in adj[x]:
            for z in adj[y]:
                v[z]+=1
        out.append(tuple(v))
    return tuple(out)


def cycle_lengths(mapping):
    remaining=set(mapping)
    result=[]
    while remaining:
        current=min(remaining)
        seed=current
        length=0
        while current in remaining:
            remaining.remove(current)
            current=mapping[current]
            length+=1
        assert current == seed, (seed,current)
        result.append(length)
    return tuple(sorted(result))


def intrinsic_doublet_permutation(n, s):
    """Recognize h-mates by common out-neighbor multiplicity and quotient arcs."""
    h=n//2
    adj=neighbors(n,s)
    mates={}
    for x in range(n):
        candidates=[y for y in range(n) if y != x and len(adj[x]&adj[y]) == 2]
        assert candidates == [(x+h)%n], (n,x,candidates)
        mates[x]=candidates[0]
    assert all(mates[mates[x]]==x for x in range(n))
    quotient={}
    for x in range(h):
        common=adj[x]&adj[mates[x]]
        assert len(common)==2 and any((y+h)%n in common for y in common)
        q={y%h for y in common}
        assert len(q)==1
        quotient[x]=q.pop()
    assert set(quotient.values())==set(range(h))
    a,b=parameters(n,s)
    assert all(quotient[x] == (x+b)%h for x in range(h))
    cycles=cycle_lengths(quotient)
    assert cycles == tuple([h//gcd(h,b)]*gcd(h,b))
    return {'singleton_a':a, 'doublet_b_mod_h':b,
            'quotient_cycle_lengths':list(cycles),
            'quotient_cycle_count':len(cycles)}


def parity_twist_isomorphism(n,s):
    """For all-odd generators in n divisible by four, S -> S+h."""
    h=n//2
    assert n%4==0 and all(x%2 for x in s)
    dst=set(plus_h(n,s))
    f=lambda x: (x+h*(x%2))%n
    assert len({f(x) for x in range(n)})==n
    return all((f((x+d)%n)-f(x))%n in dst
               for x in range(n) for d in s)


def unit_isomorphism(n,s,t,u):
    """Verify the explicit permutation x -> u*x respects every directed arc."""
    assert gcd(n,u)==1
    target=set(t)
    f=lambda x:(u*x)%n
    return len({f(x) for x in range(n)})==n and all(
        (f((x+d)%n)-f(x))%n in target for x in range(n) for d in s)


def joint_rooted_refinement(n,s,t,rounds=6):
    """An independent UNDIRECTED rooted 1-WL nonisomorphism obstruction.

    As Cayley skeletons are vertex-transitive, an unrooted isomorphism can
    be translated so that the image of the root 0 is also root 0.
    Consequently different rooted WL color-count multisets prove
    nonisomorphism of the underlying *undirected* graphs.
    """
    adj=[neighbors(n,s,symmetric=True),neighbors(n,t,symmetric=True)]
    colors=[[int(x==0) for x in range(n)] for _ in range(2)]
    for step in range(1,rounds+1):
        sigs=[[(colors[i][x], tuple(sorted(colors[i][y] for y in adj[i][x])))
              for x in range(n)] for i in (0,1)]
        dictionary={key:i for i,key in enumerate(sorted(set(sigs[0])|set(sigs[1])))}
        colors=[[dictionary[sig] for sig in sigs[i]] for i in (0,1)]
        h0,h1=Counter(colors[0]),Counter(colors[1])
        if h0 != h1:
            return {'separated':True, 'first_round':step,
                    'color_counts_S':[[k,h0[k]] for k in sorted(h0)],
                    'color_counts_T':[[k,h1[k]] for k in sorted(h1)]}
    return {'separated':False,'checked_rounds':rounds}


def classify_n48():
    fibres=defaultdict(list)
    for s in combinations(range(1,N,2),3):
        fibres[ordered_square(N,s)].append(s)
    assert len(fibres)==1000
    assert Counter(map(len,fibres.values()))==Counter({2:988,4:12})
    special=sorted(tuple(v) for v in fibres.values() if len(v)==4)
    assert len(special)==12
    records=[]
    classes=Counter()
    for fibre in special:
        s=fibre[0]
        sh=plus_h(N,s)
        t=next(v for v in fibre if v not in (s,sh))
        th=plus_h(N,t)
        assert set(fibre)=={s,sh,t,th}
        assert all(plus_h(N,v) in fibre for v in fibre)
        assert all(parity_twist_isomorphism(N,v) for v in fibre)
        assert all(gcd(N,*v)==1 for v in fibre), (N,fibre)
        assert all(set(v).isdisjoint({(-x)%N for x in v}) for v in fibre)
        assert all(ordered_square(N,v)==ordered_square(N,s) for v in fibre)
        sq0=adjacency_square_from_walks(neighbors(N,s))
        uq0=adjacency_square_from_walks(neighbors(N,s,symmetric=True))
        for v in fibre[1:]:
            assert adjacency_square_from_walks(neighbors(N,v))==sq0
            assert adjacency_square_from_walks(neighbors(N,v,symmetric=True))==uq0
        cs=intrinsic_doublet_permutation(N,s)
        ct=intrinsic_doublet_permutation(N,t)
        cycle_diff=(cs['quotient_cycle_lengths']!=ct['quotient_cycle_lengths'])
        w=joint_rooted_refinement(N,s,t)
        units=[u for u in range(N) if gcd(N,u)==1 and unit_image(N,s,u)==t]
        if cycle_diff:
            assert cs['quotient_cycle_count']!=ct['quotient_cycle_count']
            assert not units
            assert w['separated'] and w['first_round']==4, (fibre,w)
            status='nonisomorphic'
            iso_classes=2
        else:
            assert units==[17], (fibre,units)
            assert unit_isomorphism(N,s,t,17)
            assert not w['separated']
            status='isomorphic'
            iso_classes=1
        classes[status]+=1
        records.append({'representative_S':list(s),'representative_T':list(t),
                        'S_plus_24':list(sh),'T_plus_24':list(th),
                        'same_ordered_square':True,'all_connected':True,
                        'same_directed_adjacency_square':True,
                        'same_undirected_adjacency_square':True,
                        'doublet_quotient_S':cs,'doublet_quotient_T':ct,
                        'cross_classes_status':status,
                        'directed_iso_classes_in_fibre':iso_classes,
                        'undirected_iso_classes_in_fibre':iso_classes,
                        'unit_isomorphism_witnesses':units,
                        'underlying_rooted_WL':w})
    assert classes=={'isomorphic':4,'nonisomorphic':8}
    assert sum(row['directed_iso_classes_in_fibre'] for row in records)==20
    return records,dict(classes)


def family_replay(max_r=36):
    """Finite tests of the algebraic family; the note separately proves all r."""
    rows=[]
    for r in range(1,max_r+1):
        if r%3==0:
            continue
        n=12*r
        s=tuple(sorted((1,1+2*r,1+8*r)))
        t=tuple(sorted((1,1+4*r,1+10*r)))
        assert ordered_square(n,s)==ordered_square(n,t)
        assert gcd(n,*s)==gcd(n,*t)==1
        assert all(x%2 for x in s+t)
        ds=intrinsic_doublet_permutation(n,s)
        dt=intrinsic_doublet_permutation(n,t)
        assert sorted((ds['quotient_cycle_count'],dt['quotient_cycle_count']))==[1,3]
        assert sorted((ds['quotient_cycle_lengths'][0],dt['quotient_cycle_lengths'][0]))==[2*r,6*r]
        rows.append({'r':r,'n':n,'S':list(s),'T':list(t),
                     'quotient_cycle_counts':[ds['quotient_cycle_count'],dt['quotient_cycle_count']],
                     'gcd_pair':[gcd(n//2,1+2*r),gcd(n//2,1+4*r)],
                     'connected_bipartite':True,'nonisomorphic_by_quotient':True,
                     'same_square':True})
    assert len(rows)==max_r-max_r//3
    return rows


def main():
    records,counts=classify_n48()
    fam=family_replay()
    return {'date':'2026-10-13',
            'scope':'n=48 all exceptional all-odd triple-square fibres, plus algebraic n=12r family',
            'status':'EXACT_FINITE_INTERNAL_WITH_WRITTEN_PROOF_NOT_EXTERNALLY_AUDITED',
            'odd_triples_examined':comb(24,3),
            'exceptional_fibres_n48':len(records),
            'exceptional_fibres_n48_by_cross_orbit_isomorphism':counts,
            'four_triplet_fibre_graph_class_count':Counter(str(v['directed_iso_classes_in_fibre']) for v in records),
            'all_n48_exceptional_pairs_connected_and_directed_cospectral':True,
            'all_n48_exceptional_underlying_simple_pairs_cospectral':True,
            'independent_undirected_rooted_WL_separations':sum(int(v['underlying_rooted_WL']['separated']) for v in records),
            'per_fibre_certificates':records,
            'algebraic_family':'n=12r for r>=1 and r not divisible by 3; connectivity by 1, nonisomorphism by 1 vs 3 quotient permutation cycles. Not a novelty claim.',
            'family_bounded_replay_max_r':36,'family_tested_instances':len(fam),
            'family_finite_receipts':fam,'test_status':'PASS'}


if __name__=='__main__':
    print(json.dumps(main(),sort_keys=True,indent=2,ensure_ascii=False))
