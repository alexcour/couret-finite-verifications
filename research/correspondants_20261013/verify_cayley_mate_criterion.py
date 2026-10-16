#!/usr/bin/env python3
"""Exact finite audit of the half-turn mate criterion (research, not a proof)."""
import json
from collections import Counter
from math import gcd

def mates_by_differences(n, s):
    c = Counter((u-v)%n for u in s for v in s if u != v)
    return {d:k for d,k in c.items() if k >= 2}

def cycles(q):
    remaining=set(q); out=[]
    while remaining:
        x=start=min(remaining); k=0
        while x in remaining:
            remaining.remove(x); x=q[x]; k+=1
        assert x == start
        out.append(k)
    return sorted(out)

def run(limit=160):
    totals=Counter(); by_n=[]
    for n in range(4,limit+1,2):
        h=n//2; row=Counter()
        for a in range(n):
            for b in range(h):
                if a%h==b: continue
                d=(b-a)%n
                actual=mates_by_differences(n,(a,b,b+h))
                unique=(2*d)%n!=h
                expected=({h:2} if unique else {h:2,d:2,(-d)%n:2})
                assert actual==expected,(n,a,b,actual,expected)
                exceptional=3*d%h==0
                assert not exceptional or unique
                if exceptional:
                    permutation={x:(x+b)%h for x in range(h)}
                    assert cycles(permutation)==[h//gcd(h,b)]*gcd(h,b)
                for x in (0,1,n-1):
                    succ=lambda z:{(z+s)%n for s in (a,b,b+h)}
                    common=succ(x)&succ((x+h)%n)
                    assert common=={(x+b)%n,(x+b+h)%n}
                row['parameterizations']+=1
                row['unique']+=unique
                row['nonunique']+=not unique
                row['exceptional']+=exceptional
        assert row['nonunique']==(n if n%4==0 else 0)
        totals.update(row); by_n.append({'n':n,**row})
    assert totals=={'parameterizations':341280,'unique':338000,
                   'nonunique':3280,'exceptional':4212}
    return {'status':'EXACT_FINITE_INTERNAL_NOT_LEAN',
            'max_even_modulus':limit,'counts':dict(totals),
            'counterexample':{'n':8,'support':[0,2,6],'mates_of_zero':[2,4,6]},
            'by_n':by_n,'test_status':'PASS'}

if __name__=='__main__':
    print(json.dumps(run(),indent=2,sort_keys=True))
