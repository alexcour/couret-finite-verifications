#!/usr/bin/env python3
"""STROBO-MOD-OBS-04: adversarial connectivity and observability audit.

All integer arithmetic, standard Python. Internal implementation, not external
peer review. No arithmetic-prime experiment is performed here.
"""
import argparse
from collections import defaultdict, Counter
from itertools import combinations
from math import gcd
import json
from pathlib import Path


def square(s,n):
    v=[0]*n
    for a in s:
        for b in s:
            v[(a+b)%n]+=1
    return tuple(v)


def cube(s,n):
    v=[0]*n
    for a in s:
        for b in s:
            for c in s:
                v[(a+b+c)%n]+=1
    return tuple(v)


def odd_primes(n):
    out=[];d=3
    while n%2==0:n//=2
    while d*d<=n:
        if n%d==0:
            out.append(d)
            while n%d==0:n//=d
        d+=2
    if n>1 and n%2:out.append(n)
    return out


def square_based_connectivity(square_vec,n):
    """Returns exact decision if odd n or 4|n; otherwise may return None."""
    for p in odd_primes(n):
        if not any(cnt>0 and r%p for r,cnt in enumerate(square_vec)):
            return False
    if n%2:return True
    if n%4:
        if any(cnt>0 for r,cnt in enumerate(square_vec) if r%2):
            return True
        return None
    if any(cnt>0 for r,cnt in enumerate(square_vec) if r%2):
        return True
    theta=sum(square_vec[r] for r in range(0,n,4))%2
    # On a uniform-parity triple, theta=1 means three even elements.
    return theta==0


def strong_connection(s,n):
    return gcd(n,*s)==1


def group_and_check(n,zero_allowed):
    groups=defaultdict(list)
    candidates=range(0 if zero_allowed else 1,n)
    for s in combinations(candidates,3):
        k=square(s,n)
        expected=strong_connection(s,n)
        pred=square_based_connectivity(k,n)
        if n%2 or n%4==0:
            assert pred==expected,(n,s,pred,expected)
        elif pred is False:
            assert not expected,(n,s)
        elif pred is True:
            assert expected,(n,s)
        groups[k].append((s,expected))
    mixed=0;trace_fails=[]
    for k,entries in groups.items():
        statuses={b for _,b in entries}
        if n%2 or n%4==0:assert len(statuses)==1
        if len(statuses)==1:continue
        mixed+=1
        z=[(s,b,n*cube(s,n)[0]) for s,b in entries]
        for s,b,tr in z:
            for t,c,tc in z:
                if b!=c and tr==tc:
                    trace_fails.append((s,t,tr))
                    break
            if trace_fails:break
    return len(groups),mixed,trace_fails


def exceptional_conn_gcd(max_d):
    # Exact check of algebraic gcd identity on explicit 4-member families.
    checked=0
    for d in range(1,max_d+1):
        h=3*d;n=2*h
        for b in range(h):
            a=(b+d)%h;c=(b+2*d)%h
            for v in (a,c):
                for sigma in (0,1):
                    s=(v,v+h,b+sigma*h)
                    assert len(set(s))==3
                    assert gcd(n,*s)==gcd(b,d),(d,b,s)
                    checked+=1
    return checked


def run(max_n,max_d):
    assert max_n>=22 and max_d>=3
    witness10_a=(2,4,6)
    witness10_b=tuple(sorted((s+5)%10 for s in witness10_a))
    assert square(witness10_a,10)==square(witness10_b,10)
    assert strong_connection(witness10_a,10)==False
    assert strong_connection(witness10_b,10)==True
    witness22_a=(1,3,13)
    witness22_b=tuple(sorted((s+11)%22 for s in witness22_a))
    assert witness22_b==(2,12,14)
    assert square(witness22_a,22)==square(witness22_b,22)
    assert cube(witness22_a,22)[0]==cube(witness22_b,22)[0]==0
    assert strong_connection(witness22_a,22)==True
    assert strong_connection(witness22_b,22)==False
    assert cube(witness22_a,22)!=cube(witness22_b,22)
    # The one global Fourier coefficient of A^3 is NOT a single cube entry.
    assert sum((-1)**r*v for r,v in enumerate(cube(witness22_a,22)))==-27
    assert sum((-1)**r*v for r,v in enumerate(cube(witness22_b,22)))==27
    # Families of counterexamples for n=2h with h odd >=5, zero forbidden.
    for n in range(10,max_n+1,4):
        h=n//2
        a=(2,4,6);b=tuple(sorted((x+h)%n for x in a))
        assert square(a,n)==square(b,n)
        assert strong_connection(a,n)==False and strong_connection(b,n)==True
        assert 0 not in a and 0 not in b
    scans=[];first_trace_failure=None
    for n in range(5,max_n+1):
        for zero_allowed in (False,True):
            size,mixed,failures=group_and_check(n,zero_allowed)
            row={"n":n,"zero_allowed":zero_allowed,"square_fibres":size,"mixed_connectivity_fibres":mixed,"trace_cube_failed":bool(failures)}
            scans.append(row)
            if failures and first_trace_failure is None:
                s,t,tr=failures[0]
                first_trace_failure={"n":n,"zero_allowed":zero_allowed,"S":list(s),"T":list(t),"common_trace_cube":tr}
            if n==18 and zero_allowed:
                assert (size,mixed)==(399,83)
    assert first_trace_failure and first_trace_failure['n']==22,first_trace_failure
    checked=exceptional_conn_gcd(max_d)
    return {
      "id":"STROBO-MOD-OBS-04", "date":"2026-10-11",
      "status":"internal exact integer controls, not external review; no novelty claim",
      "scans":len(scans),"max_n":max_n,"exceptional_four_support_instances":checked,
      "n18":{"square_fibres":399,"mixed_connectivity_fibres":83,"trace_cube_suffices_there":True},
      "witness_n10":{"S":list(witness10_a),"T":list(witness10_b),"square_equal":True,"strong_connection_S":False,"strong_connection_T":True},
      "witness_n22":{"S":list(witness22_a),"T":list(witness22_b),"square_equal":True,"trace_cube_each":0,"strong_connection_S":True,"strong_connection_T":False,"parity_fourier_of_cube_S":-27,"parity_fourier_of_cube_T":27},
      "first_trace_failure":first_trace_failure,
      "prediction":"For odd n or 4|n, A^2 determines strong connectivity for triples",
      "no_new_prime_calculations":True,
      "by_order":scans
    }


def main():
    p=argparse.ArgumentParser()
    p.add_argument('--max-n',type=int,default=60)
    p.add_argument('--max-d',type=int,default=130)
    p.add_argument('--output',type=Path,default=Path('RESULTS.json'))
    a=p.parse_args()
    result=run(a.max_n,a.max_d)
    a.output.write_text(json.dumps(result,sort_keys=True,indent=2)+'\n',encoding='utf-8')
    print('PASS',result['scans'],'scans,',result['exceptional_four_support_instances'],'family members, first trace failure',result['first_trace_failure'])

if __name__=='__main__':main()
