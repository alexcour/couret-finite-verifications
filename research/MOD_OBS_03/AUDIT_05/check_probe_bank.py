#!/usr/bin/env python3
"""Independent exact test of n=18 fixed-probe-bank redundancies."""
from collections import defaultdict
from itertools import combinations
from replay_integer_independent import conv,vec

n=18
sq={}
sig={}
for S in combinations(range(n),3):
    a=vec(set(S),n)
    k2=conv(a,a)
    k3=conv(k2,a)
    k4=conv(k2,k2)
    k5=conv(k4,a)
    k6=conv(k4,k2)
    sq[S]=tuple(k2)
    sig[S]=(n*k3[0],n*k4[0],n*k5[0],n*k6[0],*k3)
fib=defaultdict(list)
for S,v in sq.items():
    fib[v].append(S)
pairs=[(s,t) for group in fib.values() for s,t in combinations(group,2)]
assert len(sq)==816 and len(fib)==399 and len(pairs)==444
cover=[sum(1<<i for i,(s,t) in enumerate(pairs) if sig[s][j]!=sig[t][j])
       for j in range(22)]
full=(1<<len(pairs))-1
for ids,label in [(list(range(22)),'bank22'),
                  (list(range(4,22)),'cubic18'),
                  ([2,*range(4,22)],'effective19')]:
    co=[cover[i] for i in ids]
    one=min(len(pairs)-x.bit_count() for x in co)
    two=min(len(pairs)-(x|y).bit_count() for x,y in combinations(co,2))
    winning_three=next((tuple(ids[i] for i in tri)
         for tri in combinations(range(len(co)),3)
         if (co[tri[0]]|co[tri[1]]|co[tri[2]])==full),None)
    assert (one,two)==(90,24) and winning_three is not None
    print(label,'one',one,'two',two,'three',0,'example',winning_three)
assert all(sig[S][0]==n*sig[S][4] for S in sq)
assert cover[1].bit_count()==0 and cover[3].bit_count()==0
assert cover[0]==cover[4]
print('PASS: tr(A^3)=18*C(0), tr(A^4) and tr(A^6) known from A^2; optimum preserved.')
