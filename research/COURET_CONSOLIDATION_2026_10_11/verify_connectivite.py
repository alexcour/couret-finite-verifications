#!/usr/bin/env python3
"""Standalone finite audit: square-convolution observability of strong connectivity.
Stdlib only. Excludes any novelty/independent peer-review inference.
"""
import collections
import itertools
import json
import math
import pathlib


def conv2(S, n):
    out = [0] * n
    for s in S:
        for t in S:
            out[(s + t) % n] += 1
    return tuple(out)


def conv3(S, n):
    out = [0] * n
    for x, y, z in itertools.product(S, repeat=3):
        out[(x+y+z) % n] += 1
    return tuple(out)


def strong(S, n):
    return math.gcd(n, *S) == 1


def primes_dividing(n):
    result = []
    i = 2
    while i * i <= n:
        if n % i == 0:
            result.append(i)
            while n % i == 0:
                n //= i
        i += 1
    if n > 1:
        result.append(n)
    return result


def predict_from_square(K, n, support_size=3):
    """Theorem A decision algorithm; n odd or n divisible by four, odd support size."""
    if n % 2 == 0 and n % 4 != 0:
        raise ValueError('Theorem A does not cover n = 2 mod 4')
    if support_size % 2 == 0:
        raise ValueError('Need odd support size')
    for p in primes_dividing(n):
        if p > 2 and all((r % p == 0) for r, count in enumerate(K) if count):
            return False
    if n % 2 == 1:
        return True
    if any(K[r] for r in range(1, n, 2)):
        return True
    theta = sum(K[r] for r in range(0, n, 4)) % 2
    return theta == 0


def scan_fibers(n, allow_zero):
    universe = range(n) if allow_zero else range(1, n)
    fibers = collections.defaultdict(list)
    for S in itertools.combinations(universe, 3):
        K = conv2(S, n)
        if n % 2 or n % 4 == 0:
            assert predict_from_square(K, n) == strong(S, n), (n, S)
        fibers[K].append(S)
    disagreements = []
    hist = collections.Counter(map(len, fibers.values()))
    pairs = sum(len(F) * (len(F)-1)//2 for F in fibers.values())
    for K, F in fibers.items():
        if len({strong(S,n) for S in F})>1:
            disagreements.append({'S':F[0], 'T':next(S for S in F if strong(S,n)!=strong(F[0],n))})
    if n%2 or n%4==0:
        assert not disagreements, (n, disagreements[:2])
    return {'n':n, 'allow_zero':allow_zero,'supports':sum(map(len, fibers.values())),
            'fibers':len(fibers),'histogram':dict(sorted(hist.items())),
            'collisions':pairs,'ambiguous_connectivity_fibers':len(disagreements),
            'first_counterexample':disagreements[0] if disagreements else None}


def explicit_witnesses():
    S10,T10=(2,4,6),(1,7,9)
    assert conv2(S10,10)==conv2(T10,10)
    assert strong(S10,10) is False and strong(T10,10) is True
    S22,T22=(1,3,13),(2,12,14)
    assert conv2(S22,22)==conv2(T22,22)
    assert strong(S22,22) and not strong(T22,22)
    cS,cT=conv3(S22,22),conv3(T22,22)
    assert cS[0]==cT[0]==0 and cS[3]>=1 and cT[3]==0
    A6,B6=(0,1,4),(0,2,5)
    assert conv2(A6,6)==conv2(B6,6)
    S18a=(1,4,13);S18b=(1,7,16)
    assert conv2(S18a,18)==conv2(S18b,18)
    assert 18*conv3(S18a,18)[0]==108
    assert 18*conv3(S18b,18)[0]==54
    return {'n10':{'S':S10,'T':T10,'equal_squares':True,'strong_S':False,'strong_T':True},
            'n22':{'S':S22,'T':T22,'equal_squares':True,'trace3_S':22*cS[0],
                   'trace3_T':22*cT[0],'cubic_coefficient_r3_S':cS[3],'cubic_coefficient_r3_T':cT[3]},
            'n6_ordered_representation':{'A':A6,'B':B6,'equal_squares':True},
            'n18_trace':{'S':S18a,'T':S18b,'trace3_S':108,'trace3_T':54}}


def exceptional_families():
    result=[]
    for d in range(1,13):
        n=6*d;h=3*d
        for b in range(h):
            a=(b+d)%h;c=(b+2*d)%h
            F=[tuple(sorted((v, v+h, b+sigma*h))) for v in (a,c) for sigma in (0,1)]
            assert len(set(F))==4
            assert len({conv2(S,n) for S in F})==1
            assert all(math.gcd(n,*S)==math.gcd(b,d) for S in F)
        result.append({'n':n,'tested_quadruples':h})
    return result


def main():
    scans=[]
    for n in range(5,37):
        for allow_zero in (False,True):
            scans.append(scan_fibers(n,allow_zero))
    witness=explicit_witnesses()
    exceptional=exceptional_families()
    row18=next(r for r in scans if r['n']==18 and not r['allow_zero'])
    assert row18['supports']==680 and row18['histogram']=={1:118,2:269,4:6}
    assert row18['collisions']==305
    row18z=next(r for r in scans if r['n']==18 and r['allow_zero'])
    assert row18z['supports']==816 and row18z['histogram']=={2:390,4:9}
    assert row18z['collisions']==444
    assert all(r['ambiguous_connectivity_fibers']==0 for r in scans if r['n']%2 or r['n']%4==0)
    data={'scope':'Finite exact independent audit, n=5..36, both zero conventions; no external review',
          'theorem_A':'If n odd or 4|n, A^2 identifies strong connectivity of 3-support Cayley digraphs.',
          'rows':scans,'witnesses':witness,'exceptional_family_checks':exceptional}
    p=pathlib.Path(__file__).with_name('RESULTATS_CONTROLES.json')
    p.write_text(json.dumps(data,indent=2,ensure_ascii=False)+'\n',encoding='utf-8')
    print('PASS',len(scans),'scans; n18 nonzero',row18)
    print('PASS',len(exceptional),'family moduli; n22',witness['n22'])
    print('Output',p)

if __name__=='__main__':
    main()
