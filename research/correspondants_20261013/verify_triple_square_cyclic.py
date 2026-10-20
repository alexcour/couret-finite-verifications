#!/usr/bin/env python3
"""Exact cyclic 3-subset convolution-square fibre classification and graph obstructions.

Date 2026-10-13. No external dependencies. Internal finite verification, not new
priority, not an assembled Lean theorem, and not a graph-isomorphism oracle.

Usage: python3 verify_triple_square_cyclic.py > TRIPLE_SQUARE_CYCLIC_RESULTS.json
"""
import json
from collections import Counter, defaultdict
from itertools import combinations
from math import comb, gcd

MAX_N = 80


def square_signature(n, s):
    """Nine ORDERED modular pair sums including three diagonal terms."""
    a, b, c = s
    return tuple(sorted((2*a % n, 2*b % n, 2*c % n,
                         (a+b) % n, (a+b) % n,
                         (a+c) % n, (a+c) % n,
                         (b+c) % n, (b+c) % n)))


def shift(n, s, d):
    return tuple(sorted((a+d) % n for a in s))


def predicted_fibre(n, s):
    """Direct specialization of written G[2] 3-support proof on PR #25."""
    if n % 2:
        return (s,)
    h = n//2
    classes = defaultdict(list)
    for a in s:
        classes[a % h].append(a)
    if len(classes) == 3:  # (1,1,1): all doubling images distinct
        return tuple(sorted({s, shift(n, s, h)}))
    assert sorted(len(a) for a in classes.values()) == [1, 2]
    a = next(v[0] for v in classes.values() if len(v) == 1)
    b = next(k for k,v in classes.items() if len(v) == 2)
    assert set(classes[b]) == {b,b+h}
    out = {s, shift(n,s,h)}
    if (3*(b-a))%h == 0:
        alt = (2*b-a)%h
        assert alt != b and alt != a % h
        out.add(tuple(sorted((a,alt,alt+h))))
        out.add(tuple(sorted(((a+h)%n,alt,alt+h))))
    assert len(out) in (2,4)
    return tuple(sorted(out))


def neighbourhood_signature(n,s):
    """Vertex-transitive undirected skeleton invariant anchored at zero.

    The full distribution of |N(0) intersect N(x) intersect N(y)| is invariant
    under arbitrary graph isomorphism: translations move any anchor to zero.
    Equal signatures do not imply isomorphism.
    """
    gens=frozenset(s)|frozenset((-a)%n for a in s)
    neighbors=[{(v+a)%n for a in gens} for v in range(n)]
    pair_hist=Counter()
    triple_hist=Counter()
    for x in range(1,n):
        pair_hist[len(neighbors[0]&neighbors[x])]+=1
        for y in range(x+1,n):
            triple_hist[len(neighbors[0]&neighbors[x]&neighbors[y])]+=1
    assert sum(triple_hist.values())==comb(n-1,2)
    return {'degree':len(gens),
            'pair_common':tuple(sorted(pair_hist.items())),
            'triple_common':tuple(sorted(triple_hist.items())),
            'max_three_common':max(triple_hist),
            'inverse_disjoint':not bool(set(s)&{(-a)%n for a in s}),
            'components':gcd(n,*s)}


def invariant_key(info):
    return (info['degree'],info['pair_common'],info['triple_common'])


def to_json_signature(info):
    return {'degree':info['degree'],
            'pair_common':dict((str(k),v) for k,v in info['pair_common']),
            'triple_common':dict((str(k),v) for k,v in info['triple_common']),
            'max_three_common':info['max_three_common'],
            'inverse_disjoint':info['inverse_disjoint'],
            'connected_components':info['components']}


def exact_census(n):
    groups=defaultdict(list)
    # Full basis: includes zero. Each support is an unordered THREE-element set.
    for s in combinations(range(n),3):
        groups[square_signature(n,s)].append(s)
    hist=Counter()
    no_zero=Counter()
    for bucket in groups.values():
        hist[len(bucket)]+=1
        survivors=[s for s in bucket if 0 not in s]
        if survivors:
            no_zero[len(survivors)]+=1
        predicted=predicted_fibre(n,bucket[0])
        assert tuple(bucket)==predicted, (n,bucket,predicted)
        for s in bucket[1:]:
            assert predicted_fibre(n,s)==predicted, (n,s)
    assert sum(sz*cnt for sz,cnt in hist.items())==comb(n,3)
    assert sum(sz*cnt for sz,cnt in no_zero.items())==comb(n-1,3)
    h=n//2
    expected=({1:comb(n,3)} if n%2 else
              {2:comb(n,3)//2-2*(h if h%3==0 else 0),
               4:h if h%3==0 else 0})
    for sz in set(hist)|set(expected):
        assert hist[sz]==expected.get(sz,0), (n,sz,hist,expected)
    return {'n':n,'checked_triplets':comb(n,3),
            'full_fibre_histogram':{str(k):hist[k] for k in sorted(hist)},
            'zero_free_fibre_histogram':{str(k):no_zero[k] for k in sorted(no_zero)}}


def odd_graph_census(n):
    assert n%2==0
    groups=defaultdict(list)
    odds=list(range(1,n,2))
    for s in combinations(odds,3):groups[square_signature(n,s)].append(s)
    hist=Counter(len(b) for b in groups.values())
    assert sum(sz*c for sz,c in hist.items())==comb(n//2,3)
    exceptional=[bucket for bucket in groups.values() if len(bucket)==4]
    # All exceptional supports of odd type must occur only at 12|n.
    expected_f4=(n//4 if n%12==0 else 0)
    assert len(exceptional)==expected_f4,(n,len(exceptional),expected_f4)
    if n%4==0:
        assert hist[2]==(comb(n//2,3)-4*expected_f4)//2,(n,hist)
        assert not hist[1]
    else:
        assert hist[1]==comb(n//2,3) and not hist[2] and not hist[4]
    structural=[]
    for bucket in exceptional:
        sigs=[neighbourhood_signature(n,s) for s in bucket]
        if len({invariant_key(s) for s in sigs})>1:
            ii=next((i,j) for i in range(4) for j in range(i+1,4)
                    if invariant_key(sigs[i])!=invariant_key(sigs[j]))
            i,j=ii
            structural.append({'first':list(bucket[i]),'second':list(bucket[j]),
                               'first_invariant':to_json_signature(sigs[i]),
                               'second_invariant':to_json_signature(sigs[j])})
    return {'n':n,'checked_odd_triplets':comb(n//2,3),
            'inverse_disjoint_separated_fibres':sum(1 for row in structural if row['first_invariant']['inverse_disjoint'] and row['second_invariant']['inverse_disjoint']),
            'connected_inverse_disjoint_separated_fibres':sum(1 for row in structural if row['first_invariant']['inverse_disjoint'] and row['second_invariant']['inverse_disjoint'] and row['first_invariant']['connected_components']==row['second_invariant']['connected_components']==1),
            'odd_fibre_histogram':{str(k):hist[k] for k in sorted(hist)},
            'exceptional_fibres':len(exceptional),
            'structurally_separated_exceptional_fibres':len(structural),
            'representative':(structural[0] if structural else None)}


def lift_n24(r):
    """Embedding Z/24Z -> Z/(24*r) preserves sum-square certificates."""
    n=24*r
    s=tuple(r*a for a in (1,5,17))
    t=tuple(r*a for a in (1,9,21))
    assert square_signature(n,s)==square_signature(n,t)
    # The disjoint copies are indexed by residue modulo r.
    assert gcd(n,*s)==gcd(n,*t)==r
    return {'n':n,'s':list(s),'t':list(t),
            'components_each':r,'nonisomorphic_by_lifted_K33_certificate':True,
            'directed_cospectral_by_disjoint_union':True}


def independent_direct_oracle():
    '''Completely separate nine ordered sums via Counter, checking n <= 40.'''
    tested=0
    for n in range(3,41):
        for s in combinations(range(n),3):
            direct=Counter((a+b)%n for a in s for b in s)
            flat=tuple(sorted(a for a,mult in direct.items() for _ in range(mult)))
            assert flat==square_signature(n,s), (n,s)
            tested+=1
    assert tested==101270
    return tested


def run():
    independent_checks=independent_direct_oracle()
    full=[]
    for n in range(3,MAX_N+1):
        full.append(exact_census(n))
    odd=[odd_graph_census(n) for n in range(8,MAX_N+1,2)]
    checks=sum(row['checked_triplets'] for row in full)
    assert checks==1663740
    assert sum(row['checked_odd_triplets'] for row in odd)==101269
    targets={row['n']:row for row in odd}
    assert {n:targets[n]['exceptional_fibres'] for n in (12,24,36,48,60,72)}=={
        12:3,24:6,36:9,48:12,60:15,72:18}
    assert {n:targets[n]['structurally_separated_exceptional_fibres']
            for n in (12,24,36,48,60,72)}=={12:2,24:4,36:2,48:0,60:2,72:4}
    assert {n:targets[n]['inverse_disjoint_separated_fibres']
            for n in (12,24,36,48,60,72)}=={12:0,24:4,36:0,48:0,60:0,72:4}
    assert {n:targets[n]['connected_inverse_disjoint_separated_fibres']
            for n in (12,24,36,48,60,72)}=={12:0,24:4,36:0,48:0,60:0,72:0}
    # Validate strong n=24 certificate pair survives the global census.
    a=neighbourhood_signature(24,(1,5,17))
    b=neighbourhood_signature(24,(1,9,21))
    assert a['degree']==b['degree']==6
    assert a['max_three_common']==2 and b['max_three_common']==4
    assert a['inverse_disjoint'] and b['inverse_disjoint']
    # Everything labelled: no claim of arbitrary isomorphism classification.
    return {'date':'2026-10-13',
            'status':'FINITE_EXACT_INTERNAL_NO_INDEPENDENT_AUDIT',
            'mathematical_basis':'Specialization of written triple-square 2-torsion classification in PR #25; NOT a new priority claim or a fully assembled Lean theorem',
            'max_n':MAX_N,
            'total_full_triplets_checked':checks,
            'independent_raw_counter_checks':independent_checks,
            'total_odd_triplets_checked':sum(row['checked_odd_triplets'] for row in odd),
            'all_moduli':full,
            'odd_triplet_bipartite_cayley':odd,
            'lift_witnesses':[lift_n24(r) for r in (1,2,3,4,5)],
            'caveat':'Common-neighbour histograms separate some nonisomorphic undirected skeletons; equal invariants never certify isomorphism. For inverse-overlapping directed support, underlying simple graph may fail to be cospectral.',
            'test_status':'PASS'}


if __name__=='__main__':
    print(json.dumps(run(),sort_keys=True,ensure_ascii=False,indent=2))
