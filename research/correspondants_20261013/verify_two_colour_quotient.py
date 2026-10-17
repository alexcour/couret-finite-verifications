#!/usr/bin/env python3
"""Exact two-colour Cayley quotient replay, standard library only.

Internal finite checks; mathematical argument in TWO_COLOUR_QUOTIENT_NOTE.md.
"""
import json
from collections import Counter
from math import gcd

def steps(n, S):
    return tuple(sorted(Counter((a+b) % n for a in S for b in S).items()))

def infer(n, S):
    m=n//2
    def out(x): return {(x+s)%n for s in S}
    shared0=out(0)
    assert [y for y in range(1,n) if len(shared0 & out(y))>=2]==[m]
    marked=[]; single=[]
    for x in range(m):
        common=out(x)&out(x+m)
        only=out(x)-out(x+m)
        assert len(common)==2 and len(only)==1
        assert len({y % m for y in common})==1
        marked.append(next(iter(common))%m)
        single.append(next(iter(only))%m)
    return marked,single

def main():
    instances=[]
    for r in range(1,121):
        n=12*r; m=n//2
        S=(1,1+2*r,1+8*r); T=(1,1+4*r,1+10*r)
        assert steps(n,S)==steps(n,T)
        assert gcd(n,*S)==gcd(n,*T)==1
        assert all(x%2 for x in S+T)
        p,q=infer(n,S); pp,qq=infer(n,T)
        assert q==qq==[(x+1)%m for x in range(m)]
        b,c=(1+2*r)%m,(1+4*r)%m
        assert p==[(x+b)%m for x in range(m)]
        assert pp==[(x+c)%m for x in range(m)]
        assert b!=c
        if r%3==0:
            assert gcd(m,b)==gcd(m,c)==1
        instances.append((r,n,b,c))
    return {"test_status":"PASS","instances":len(instances),
        "previously_unresolved_multiples_of_three":sum(r%3==0 for r,_,_,_ in instances),
        "sample_parameters":[list(x) for x in instances if x[0] in (1,2,3,4,6,9,12,36,120)],
        "scope":"finite exact checks; universal result is written, not yet assembled arithmetically in Lean"}

if __name__=="__main__": print(json.dumps(main(),sort_keys=True,indent=2))
