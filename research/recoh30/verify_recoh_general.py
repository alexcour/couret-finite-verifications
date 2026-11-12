#!/usr/bin/env python3
"""RECOH finite regression across unit groups, exact arithmetic only.

The assertions concern labelled convolution and a purely algebraic
square-root correction. No analytic prime-race density or priority claim.
"""
from collections import Counter, defaultdict
from itertools import combinations
from math import gcd
from pathlib import Path
import hashlib
import json

MODULES = (5, 7, 11, 13, 15, 20, 21, 24, 32, 40)
# (phi(n), |G[2]|, |G^2|, R-fibres, (R,mu)-fibres, R-fibres split by mu)
EXPECTED = {
    5: (4, 2, 2, 2, 2, 0),
    7: (6, 2, 3, 7, 14, 7),
    11: (10, 2, 5, 60, 120, 60),
    13: (12, 2, 6, 104, 104, 0),
    15: (8, 4, 2, 14, 23, 9),
    20: (8, 4, 2, 14, 23, 9),
    21: (12, 4, 3, 46, 110, 46),
    24: (8, 8, 1, 7, 14, 7),
    32: (16, 4, 4, 140, 234, 94),
    40: (16, 8, 2, 70, 136, 63),
}

def classify(n):
    G = tuple(a for a in range(1, n) if gcd(a, n) == 1)
    N = len(G)
    H = tuple(a for a in G if a*a % n == 1)
    K = {a*a % n for a in G}
    h = len(H)
    roots = Counter(a*a % n for a in G)
    assert all(roots[g] == (h if g in K else 0) for g in G)
    assert len(K)*h == N
    triples = tuple(combinations(G, 3))
    R, MU = {}, {}
    fibres = defaultdict(list)
    for T in triples:
        pairs = Counter(a*b % n for a in T for b in T)
        R[T] = tuple(pairs[g] for g in G)
        c = {g: N*int(g in T)-3 for g in G}
        num = -sum(c[g]*(roots[g]-1) for g in G)
        assert num % N == 0
        MU[T] = num // N
        assert MU[T] == 3-h*len(K.intersection(T))
        fibres[R[T]].append(T)
    refined = defaultdict(list)
    for T in triples:
        refined[(R[T], MU[T])].append(T)
    split = sum(len({MU[T] for T in ts})>1 for ts in fibres.values())
    result = (N, h, len(K), len(fibres), len(refined), split)
    assert result == EXPECTED[n], (n, result)
    three_torsion = any(a != 1 and pow(a, 3, n)==1 for a in G)
    if not three_torsion:
        assert all(len(v)==h for v in fibres.values())
    assert all(len(v) in (h, 2*h) for v in fibres.values())
    for T in triples:
        translated = {tuple(sorted(t*a % n for a in T)) for t in H}
        assert len(translated) == h
        assert translated.issubset(set(fibres[R[T]]))
        for t in H:
            shifted = tuple(sorted(t*a % n for a in T))
            if t in K:
                assert MU[T] == MU[shifted]
    if set(H).issubset(K):
        assert all(MU[T] == MU[tuple(sorted(t*a % n for a in T))]
                   for T in triples for t in H)
    else:
        assert any(MU[T] != MU[tuple(sorted(t*a % n for a in T))]
                   for T in triples for t in H)
    witness = next(({
       'T': list(T), 'h': t,
       'hT': list(tuple(sorted(t*a % n for a in T))),
       'mu_T': MU[T], 'mu_hT': MU[tuple(sorted(t*a % n for a in T))]
    } for T in triples for t in H
       if MU[T] != MU[tuple(sorted(t*a % n for a in T))]), None)
    return {
        'module': n, 'order': N, 'two_torsion_size': h,
        'squares_size': len(K), 'H_subset_K': set(H).issubset(K),
        'three_torsion': three_torsion, 'triples': len(triples),
        'R_fibres': len(fibres), 'Rmu_fibres': len(refined),
        'R_fibres_split': split,
        'R_fibre_size_hist': dict(sorted(Counter(map(len, fibres.values())).items())),
        'Rmu_fibre_size_hist': dict(sorted(Counter(map(len, refined.values())).items())),
        'different_bias_H_translate_witness': witness,
    }, fibres, refined

# Exact cyclotomic representations: Phi_6(x)=x^2-x+1,
# Phi_12(x)=x^4-x^2+1. No floating-point roots of unity.
ZETA6 = ((1,0),(0,1),(-1,1),(-1,0),(0,-1),(1,-1))
zeta12 = [(1,0,0,0)]
for _ in range(11):
    a,b,c,d = zeta12[-1]
    zeta12.append((-d,a,b+d,c))
assert len(zeta12)==12
assert (-zeta12[-1][3],zeta12[-1][0],zeta12[-1][1]+zeta12[-1][3],zeta12[-1][2]) == zeta12[0]

def cyclic_probes(n, generator, roots):
    G = tuple(a for a in range(1,n) if gcd(a,n)==1)
    N = len(G)
    logs = {pow(generator, j, n):j for j in range(N)}
    assert len(logs)==N and len(roots)==N
    T = tuple(combinations(G,3))
    values = {(t,k):tuple(sum(roots[(k*logs[a]) % N][i] for a in t)
                          for i in range(len(roots[0])))
              for t in T for k in range(1,N)}
    def signature(t, bank):
        return tuple(values[(t,k)] for k in bank)
    def minimum(groups):
        for k in range(N):
            wins = [bank for bank in combinations(range(1,N),k)
                    if all(len({signature(t,bank) for t in f}) == len(f)
                           for f in groups.values())]
            if wins:
                return k, wins
        raise AssertionError('No separating bank')
    _,f,ref = classify(n)
    r, rw = minimum(f)
    b, bw = minimum(ref)
    return {'R_min_probes':r, 'R_winning_banks':len(rw),
            'Rmu_min_probes':b, 'Rmu_winning_banks':len(bw),
            'R_first_bank':list(rw[0]), 'Rmu_first_bank':list(bw[0])}

# U(24)=C2^3. Characters are sign characters in generator basis.
def elementary_24_probes():
    n=24
    G=tuple(a for a in range(1,n) if gcd(a,n)==1)
    gens=(5,7,13)
    coords={}
    for a in range(2):
        for b in range(2):
            for c in range(2):
                x=(pow(gens[0],a,n)*pow(gens[1],b,n)*pow(gens[2],c,n))%n
                assert x not in coords
                coords[x]=(a,b,c)
    assert set(coords)==set(G)
    probes=tuple(p for p in coords.values() if p!=(0,0,0))
    def f(t,p):
        return sum((-1)**sum(q*x for q,x in zip(p,coords[v])) for v in t)
    _, R, refined=classify(n)
    def wins(fibres, bank):
        return all(len({tuple(f(t,p) for p in bank) for t in ts})==len(ts)
                   for ts in fibres.values())
    for groups, expected in ((R,3),(refined,3)):
        assert not any(wins(groups,ps) for ps in combinations(probes,expected-1))
        winners = [ps for ps in combinations(probes,expected) if wins(groups,ps)]
        assert len(winners)==28
    return {'R_min_probes':3, 'Rmu_min_probes':3,
            'R_winning_banks':28, 'Rmu_winning_banks':28}

def main():
    cases=[]
    for n in MODULES:
        row,_,_ = classify(n)
        cases.append(row)
    assert len(cases)==len(MODULES)
    probes = {'7':cyclic_probes(7,3,ZETA6),
              '13':cyclic_probes(13,2,zeta12),
              '24':elementary_24_probes()}
    assert (probes['7']['R_min_probes'],probes['7']['Rmu_min_probes']) == (2,1)
    assert probes['7']['Rmu_winning_banks'] == 2
    assert (probes['13']['R_min_probes'],probes['13']['Rmu_min_probes']) == (2,2)
    assert probes['13']['R_winning_banks'] == 8
    assert (probes['24']['R_min_probes'],probes['24']['Rmu_min_probes']) == (3,3)
    assert next(x for x in cases if x['module']==11)['Rmu_fibres']==120
    out={
      'scope':'finite labelled convolution, square-root correction, Fourier probes',
      'date':'2026-10-14',
      'status':'integer exact Python checks only; no analytic/Lean/novelty assertion',
      'modules':cases,
      'exact_probe_costs':probes,
      'new_theorems_explained_in_note':[
          'mu_alg(T)=m-|G[2]|*|T intersect G^2|',
          'H translations conserve labelled R',
          'H subset G^2 iff mu is H-translation-invariant for all m-subsets, 1<=m<N',
          'for odd T, rank_2(H) 2-power-order character probes separate H orbit',
          '3-torsion may enlarge R fibres beyond H orbits: U7 counterexample'
      ],
      'not_claimed':['universal fibre classification from finite census',
                     'prime bias limit law','Lean formalization','novelty','release'],
    }
    path=Path(__file__).with_name('recoh_general_20261014_certificate.json')
    path.write_text(json.dumps(out,indent=2,sort_keys=True)+'\n',encoding='utf-8')
    print('RECOH GENERAL EXACT PASS: %d modules, %d tested 3-subsets'
          %(len(cases),sum(t['triples'] for t in cases)))
    print('U7 (R,Rmu) probes =',probes['7']['R_min_probes'],probes['7']['Rmu_min_probes'])
    print('U13 (R,Rmu) probes =',probes['13']['R_min_probes'],probes['13']['Rmu_min_probes'])
    print('U24 (R,Rmu) probes =',probes['24']['R_min_probes'],probes['24']['Rmu_min_probes'])
    print('SHA256:',hashlib.sha256(path.read_bytes()).hexdigest())

if __name__=='__main__':main()
