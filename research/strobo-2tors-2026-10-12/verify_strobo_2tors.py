#!/usr/bin/env python3
"""Exact audit of triple square-convolution fibres; Python standard library only."""
from itertools import product, combinations
from collections import Counter, defaultdict
from math import comb

GROUPS=[(2,2,3),(2,2,5),(2,2,9),(2,2,3,3),(2,2,2,2),(2,2,2,3),(2,2,2,3,3),(4,4),(4,4,3),(4,2,3),(8,2,3),(2,2,2,2,3),(6,2),(4,2,5)]

def check(mods):
    G=list(product(*(range(m) for m in mods)))
    def add(a,b): return tuple((x+y)%m for x,y,m in zip(a,b,mods))
    def mul(k,a): return tuple(k*x%m for x,m in zip(a,mods))
    def neg(a): return mul(-1,a)
    z=tuple(0 for _ in mods)
    H=[u for u in G if mul(2,u)==z]
    h=len(H); q=len(G)//h
    r3=(sum(mul(3,u)==z for u in G)-1)//2
    def norm(s): return tuple(sorted(s))
    def square(s): return tuple(sorted(Counter(add(a,b) for a in s for b in s).items()))
    def predicts(S):
        out={norm(add(s,u) for s in S) for u in H}
        fibres=defaultdict(list)
        for a in S: fibres[mul(2,a)].append(a)
        if sorted(map(len,fibres.values()))==[1,2]:
            a=next(v[0] for v in fibres.values() if len(v)==1)
            b,c=next(v for v in fibres.values() if len(v)==2)
            d=add(c,neg(b)); v=add(b,neg(a))
            if mul(3,v) in [z,d]:
                e=add(mul(2,b),neg(a))
                T=(a,e,add(e,d))
                out|={norm(add(s,u) for s in T) for u in H}
        return out
    fs=defaultdict(set)
    for S in combinations(G,3):
        assert sum(n for _,n in square(S))==9
        fs[square(S)].add(S)
    for sq,f in fs.items():
        S=next(iter(f))
        assert f==predicts(S),(mods,S,len(f),len(predicts(S)))
        assert all(square(T)==sq for T in f)
    actual=Counter(map(len,fs.values()))
    exp={h:comb(len(G),3)//h-2*q*(h-1)*r3}
    if r3: exp[2*h]=q*(h-1)*r3
    assert dict(actual)==exp,(mods,actual,exp)
    nozero=Counter(sum(z not in S for S in f) for f in fs.values())
    del nozero[0]
    if h>=4:
        ordinary={}
        for j in range(4):
            a=comb(h,j)*comb(len(G)-h,3-j)//h if j<=h and 0<=3-j<=len(G)-h else 0
            e=[2*(q-2)*(h-1)*r3,2*(h-1)*r3,2*(h-1)*r3,0][j]
            if a-e: ordinary[h-j]=a-e
        if (q-3)*(h-1)*r3: ordinary[2*h]=(q-3)*(h-1)*r3
        if 3*(h-1)*r3: ordinary[2*h-2]=3*(h-1)*r3
        assert dict(nozero)==ordinary,(mods,nozero,ordinary)
    return mods,len(G),comb(len(G),3),dict(actual),dict(nozero)

if __name__=='__main__':
    total=0
    for mod in GROUPS:
        row=check(mod); total+=row[2]; print(row)
    print('PASS',len(GROUPS),'groups',total,'triple supports')
