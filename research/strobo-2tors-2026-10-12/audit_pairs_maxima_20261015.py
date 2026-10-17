#!/usr/bin/env python3
"""Bounded independent direct-enumeration audit; not a universal proof."""
from itertools import combinations, product
from collections import defaultdict

CASES = [(1,), (2,), (3,), (4,), (5,), (6,), (7,), (8,), (9,), (10,), (12,), (15,), (18,), (24,), (4,2), (2,2), (2,3), (2,2,2), (2,2,3), (2,2,2,3), (2,6), (3,3), (2,3,3), (4,3), (6,3), (2,2,5), (2,2,2,2), (3,3,3), (2,2,2,2,3)]

def audit(mods):
    group = list(product(*(range(m) for m in mods)))
    n = len(group)
    index = {x:i for i,x in enumerate(group)}
    zero = tuple(0 for _ in mods)
    def add(x,y): return tuple((a+b)%m for a,b,m in zip(x,y,mods))
    H = [x for x in group if add(x,x)==zero]
    h=len(H); q=n//h
    t=sum(add(add(x,x),x)==zero for x in group)
    r=(t-1)//2
    fibre=defaultdict(list)
    for S in combinations(group,3):
        square=[0]*n
        for x in S:
            for y in S:
                square[index[add(x,y)]] += 1
        fibre[tuple(square)].append(frozenset(S))
    exc=pairs=pairs_nozero=maximum=0
    for members in fibre.values():
        maximum=max(maximum, sum(zero not in S for S in members))
        if len(members)==2*h: exc+=1
        else: assert len(members)==h, (mods,len(members),h)
        for S,T in combinations(members,2):
            if not any(frozenset(add(x,u) for x in S)==T for u in group):
                pairs+=1
                if zero not in S and zero not in T:
                    pairs_nozero+=1
    expected_pairs=q*h*h*(h-1)*r
    expected_zero=0 if h==1 or r==0 else (h-1)*r*((q-3)*h*h+(h-1)**2+2*h*(h-2))
    expected_max=((2*h if q>3 else 2*h-2) if h>1 and t>1 else min(h,max(n-3,0)))
    expected_exc=q*(h-1)*r
    assert (exc,pairs,pairs_nozero,maximum)==(expected_exc,expected_pairs,expected_zero,expected_max), (mods,exc,pairs,pairs_nozero,maximum)
    return (mods,n,h,q,t,pairs,pairs_nozero,maximum)

if __name__=="__main__":
    for row in map(audit,CASES):
        print("%-16s n=%2s h=%2s q=%2s t=%2s pair=%6s zeroFreePairs=%6s max=%2s OK" % row)
    print("PASS:",len(CASES),"finite product-group presentations; no universal proof implied")
