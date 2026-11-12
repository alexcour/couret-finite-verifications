#!/usr/bin/env python3
"""STROBO-C3: arithmetic witnesses for the explicit exceptional family.

Standard library only. Does not import nauty, labelg, VF2, or the old STROBO code.
Outputs one verifiable certificate per support pair; reference nauty data are
used ONLY for an optional, logically separate consistency comparison.
"""
import argparse
import csv
import json
from collections import Counter
from itertools import product
from math import gcd
from pathlib import Path


def family(n):
    if n % 6:
        return []
    d, m = n // 6, n // 2
    pairs = set()
    for b, left, right in product(range(m), range(2), range(2)):
        a, c = (b + d) % m, (b + 2*d) % m
        S = tuple(sorted((a, a + m, b + left*m)))
        T = tuple(sorted((c, c + m, b + right*m)))
        if 0 not in S and 0 not in T:
            pairs.add((S, T))
    return sorted(pairs)


def convolution(V, n):
    return Counter((a+b) % n for a in V for b in V)


def walks(V, n, power):
    v = [0]*n
    v[0] = 1
    for _ in range(power):
        nxt = [0]*n
        for i, count in enumerate(v):
            if count:
                for step in V:
                    nxt[(i+step) % n] += count
        v = nxt
    return v


def trace(V, n, power):
    return n * walks(V, n, power)[0]


def arc_counts(V, n, length):
    w = walks(V, n, length-1)
    return tuple(sorted(w[(-s) % n] for s in V))


def odd_delta(n, b, left, right, power):
    """General identity for all odd positive powers; S doubled at b+d."""
    assert power % 2 == 1
    d, m = n//6, n//2
    value = (-3)**((power-1)//2) * (
        int((power*b+d) % m == 0) - int((power*b-d) % m == 0))
    value += int(power*(b+left*m) % n == 0)
    value -= int(power*(b+right*m) % n == 0)
    return n*value


def multiplier(S, T, n):
    target = set(T)
    return next((u for u in range(1,n)
                 if gcd(u,n) == 1 and {(u*s)%n for s in S} == target), None)


def param(V,n):
    m=n//2
    fibers={}
    for x in V:
        fibers.setdefault(x%m, []).append(x)
    b=next(k for k,a in fibers.items() if len(a)==1)
    a=next(k for k,a in fibers.items() if len(a)==2)
    return b,(a-b)%m, (fibers[b][0]-b)//m


def run(bound, output, reference=None):
    output.mkdir(parents=True, exist_ok=True)
    records=[]
    for n in range(6,bound+1,6):
        d=n//6
        pairs=family(n)
        assert len(pairs)==2*n-11,(n,len(pairs))
        for S,T in pairs:
            b, ad, left=param(S,n)
            bt, cd, right=param(T,n)
            assert b==bt and ad==d and cd==2*d
            assert convolution(S,n)==convolution(T,n)
            g=gcd(b,d)
            r=d//g
            B=b//g
            assert gcd(B,r)==1
            odd_q=next((q for q in range(1,r+1,2)
                        if trace(S,n,q)!=trace(T,n,q)),None) if r%2 else None
            if odd_q is not None:
                assert odd_q==r
                assert trace(S,n,odd_q)-trace(T,n,odd_q)==odd_delta(n,b,left,right,odd_q)
            # Test the all-odd formula at every odd length <= 2*n-1.
            aS=[0]*n; aS[0]=1
            aT=aS.copy()
            for q in range(1,2*n,2):
                for _ in range(2 if q>1 else 1):
                    aS=step_walk(aS,S,n)
                    aT=step_walk(aT,T,n)
                assert n*(aS[0]-aT[0])==odd_delta(n,b,left,right,q)
            if odd_q is None:
                assert all(odd_delta(n,b,left,right,q)==0 for q in range(1,2*n,2))
            arc_q=None
            if odd_q is None and r%2==0 and B%3:
                arc_q=next((q for q in range(2,max(4,r)+1,2)
                            if arc_counts(S,n,q)!=arc_counts(T,n,q)),None)
                assert arc_q is not None
            u=None
            if odd_q is None and arc_q is None:
                u=multiplier(S,T,n)
                assert u is not None
            algebraic='odd_trace' if odd_q else ('arc_cycle' if arc_q else 'multiplier_iso')
            assert algebraic==('odd_trace' if r%2 and (B%3 or left!=right)
                 else ('arc_cycle' if r%2==0 and B%3 else 'multiplier_iso'))
            witness_q=odd_q or arc_q
            rec={'n':n,'S':list(S),'T':list(T),'b':b,'r':r,'B_mod3':B%3,
                 'singleton_lifts':[left,right],'certificate':algebraic,
                 'odd_length':odd_q,'odd_trace_delta':odd_delta(n,b,left,right,odd_q) if odd_q else None,
                 'arc_length':arc_q,
                 'arc_signature_S':list(arc_counts(S,n,arc_q)) if arc_q else None,
                 'arc_signature_T':list(arc_counts(T,n,arc_q)) if arc_q else None,
                 'unit_multiplier':u}
            records.append(rec)
    counts=Counter(rec['certificate'] for rec in records)
    rows=[]
    for n in range(6,bound+1,6):
        subset=[v for v in records if v['n']==n]
        rows.append({'n':n,'pairs':len(subset), **{k:sum(x['certificate']==k for x in subset)
                                               for k in ['odd_trace','arc_cycle','multiplier_iso']}})
    if reference:
        reference=json.loads(reference.read_text())['STROBO_C3_01']
        ref={(row['n'],tuple(sorted((tuple(p['S']),tuple(p['T']))))):p['isomorphic_nauty']
             for row in reference['by_n'] for p in row['pair_details']}
        assert len(ref)==len(records)
        for row in records:
            k=(row['n'],tuple(sorted((tuple(row['S']),tuple(row['T'])))))
            assert k in ref
            assert ref[k] == (row['certificate']=='multiplier_iso'), k
    summary={'status':'INTERNAL_EXACT_VERIFICATION_NOT_EXTERNAL_REVIEW',
             'bound':bound, 'family':'explicit nontranslation pairs; zero excluded',
             'witness18':{'S':[1,4,13],'T':[1,7,16],'trace3_S':108,'trace3_T':54},
             'totals':{'pairs':len(records),**counts},'by_n':rows,
             'reference_nauty_comparison':'agree_all_pairs' if reference else 'not_performed',
             'scope':'No originality claim, no general STROBO exhaustiveness proof, no merge.'}
    assert convolution((1,4,13),18)==convolution((1,7,16),18)
    assert trace((1,4,13),18,3)==108 and trace((1,7,16),18,3)==54
    (output/'STROBO_ODD_ARC_SUMMARY.json').write_text(json.dumps(summary,indent=2,ensure_ascii=False)+'\n')
    with (output/'STROBO_ODD_ARC_WITNESSES.csv').open('w',newline='') as fh:
        cols=['n','S','T','b','r','B_mod3','singleton_lifts','certificate','odd_length',
              'odd_trace_delta','arc_length','arc_signature_S','arc_signature_T','unit_multiplier']
        writer=csv.DictWriter(fh,fieldnames=cols)
        writer.writeheader()
        for rec in records:
            writer.writerow({k:(json.dumps(rec[k],separators=(',',':')) if isinstance(rec[k],list)
                                else rec[k]) for k in cols})
    print(json.dumps(summary,indent=2,ensure_ascii=False))
    return summary


def step_walk(w, V, n):
    v=[0]*n
    for i,c in enumerate(w):
        if c:
            for j in V:v[(i+j)%n]+=c
    return v


if __name__=='__main__':
    p=argparse.ArgumentParser()
    p.add_argument('--bound',type=int,default=60)
    p.add_argument('--output',type=Path,default=Path('.'))
    p.add_argument('--reference',type=Path,default=None,
                   help='Optional prior audit JSON; checked only after internal certificates')
    args=p.parse_args()
    run(args.bound,args.output,args.reference)
