#!/usr/bin/env python3
"""Internal independent brute-force check; never a substitute for general proof."""
from collections import Counter, defaultdict
from itertools import combinations
from math import comb
import json
import argparse

def square_key(S, n):
    return tuple(sorted((x+y)%n for x in S for y in S))

def pair(S,T):
    return tuple(sorted((S,T)))

def exceptional(n, allow_zero):
    if n%6: return set()
    m=n//2
    d=n//6
    result=set()
    for b in range(m):
        a=(b+d)%m
        c=(b+2*d)%m
        for i in (0,1):
            for j in (0,1):
                S=tuple(sorted((a,a+m,b+i*m)))
                T=tuple(sorted((c,c+m,b+j*m)))
                if allow_zero or (0 not in S and 0 not in T):
                    result.add(pair(S,T))
    return result

def expected_fibres(n, z):
    if n%2: 
        c=comb(n if z else n-1,3)
        return ({1:c} if c else {})
    if z:
        raw=({2:comb(n,3)//2} if n%6 else 
             {2:comb(n,3)//2-n,4:n//2})
    else:
        raw=({1:comb(n-2,2),2:comb(n-2,3)//2} if n%6 else
             {1:comb(n-2,2)-2,2:comb(n-2,3)//2-n+7,4:n//2-3})
    return {k:v for k,v in raw.items() if v}

def run_one(n,z):
    groups=defaultdict(list)
    for S in combinations(range(0 if z else 1,n),3):
        groups[square_key(S,n)].append(S)
    counts=Counter()
    bad=set()
    half=0
    for group in groups.values():
        counts[len(group)]+=1
        for S,T in combinations(group,2):
            h=tuple(sorted((x+n//2)%n for x in S)) if n%2==0 else None
            if h==T: half+=1
            else: bad.add(pair(S,T))
    assert dict(counts)==expected_fibres(n,z),(n,z,counts,expected_fibres(n,z))
    predicted=exceptional(n,z)
    assert bad==predicted,(n,z,list(bad-predicted)[:2],list(predicted-bad)[:2])
    assert len(bad)==((2*n if z else 2*n-11) if n%6==0 else 0)
    assert half==((comb(n,3)//2 if z else comb(n-2,3)//2) if n%2==0 else 0)
    for S,T in bad:
        for u in range(n):
            assert {((s+u)%n) for s in S} != set(T)
    return dict(n=n,zero_allowed=z,supports=sum(k*v for k,v in counts.items()),
                fibres=dict(counts),half_turn_pairs=half,exceptions=len(bad))

def main():
    ap=argparse.ArgumentParser()
    ap.add_argument('--max-n',type=int,default=90)
    ap.add_argument('--output',default='audit_strobo_replay.json')
    args=ap.parse_args()
    records=[run_one(n,z) for n in range(3,args.max_n+1) for z in (False,True)]
    result=dict(status='INTERNAL_BOUNDED_ONLY',modules=list(range(3,args.max_n+1)),
                scans=len(records),supports=sum(r['supports'] for r in records),
                anomalies=0,records=records)
    with open(args.output,'w') as f: json.dump(result,f,indent=2,sort_keys=True)
    print('PASS',len(records),'scans',result['supports'],'supports; no observed contradiction')

if __name__=='__main__': main()
