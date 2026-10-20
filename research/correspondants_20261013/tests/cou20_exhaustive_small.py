"""Deterministic exact COU-20 finite regression (NOT a universal proof).
16 abelian-group presentations; directed arcs, loops allowed.
Python 3 + SymPy. Run: python cou20_exhaustive_small.py
"""
import json
from itertools import product
from math import prod
from fractions import Fraction
import sympy as sp

FAMILIES = [(6,), (12,), (18,), (24,), (30,), (6,2), (6,3),
            (6,4), (9,2), (9,4), (3,4), (3,6), (3,8),
            (2,2,3), (2,3,3), (2,2,6)]

def add(M, *xs):
    return tuple(sum(x[i] for x in xs) % m for i,m in enumerate(M))

def smul(M, k, x):
    return tuple(k*t % m for t,m in zip(x,M))

def neg(M, x):
    return smul(M,-1,x)

def subgroup(M, gens):
    z=(0,)*len(M); seen={z}; queue=[z]
    while queue:
        x=queue.pop()
        for g in gens:
            for y in (add(M,x,g),add(M,x,neg(M,g))):
                if y not in seen:
                    seen.add(y); queue.append(y)
    return seen

def trace_series(M, steps):
    pts=list(product(*(range(n) for n in M)))
    N=len(pts); ix={p:i for i,p in enumerate(pts)}
    trans=[[ix[add(M,x,s)] for s in set(steps)] for x in pts]
    walk=[0]*N; walk[0]=1; values=[]
    for _ in range(N):
        following=[0]*N
        for i,count in enumerate(walk):
            for j in trans[i]:
                following[j]+=count
        walk=following
        values.append(N*walk[0])
    return values

def newton_coeff(traces,k):
    coeff=[Fraction(1)]
    for m in range(1,k+1):
        total=Fraction(traces[m-1])+sum(coeff[j]*traces[m-j-1]
                    for j in range(1,m))
        coeff.append(-total/m)
    return coeff

def charpoly_direct(M,steps):
    pts=list(product(*(range(n) for n in M)))
    N=len(pts); ix={p:i for i,p in enumerate(pts)}
    A=sp.zeros(N)
    for i,x in enumerate(pts):
        for s in set(steps):
            A[i,ix[add(M,x,s)]]=1
    return A.charpoly().as_expr()

def main():
    counts=dict(configurations=0,odd_first_difference=0,even_quotient=0,
                odd_nongeneration=0,with_loops=0,cospectral=0,sympy_crosschecks=0)
    for M in FAMILIES:
        elements=list(product(*(range(n) for n in M)))
        N=prod(M); z=(0,)*len(M); q=N//2
        for h in elements:
            if h==z or add(M,h,h)!=z: continue
            H=subgroup(M,[h]); assert len(H)==2
            for d in elements:
                if d in H or smul(M,3,d) not in H: continue
                for a in elements:
                    if len(subgroup(M,[a,d,h]))!=N: continue
                    full=len(subgroup(M,[a,h]))==N
                    S={a,add(M,a,d),add(M,a,d,h)}
                    T={a,add(M,a,neg(M,d)),add(M,a,neg(M,d),h)}
                    assert len(S)==len(T)==3
                    u,v=trace_series(M,S),trace_series(M,T)
                    cospec=(u==v)
                    assert cospec==((not full) or q%2==0)
                    assert all(u[k-1]==v[k-1] for k in range(2,N+1,2))
                    if q%2 and full:
                        ell=q//3
                        assert q==3*ell and ell%2==1 and ell<=N
                        assert (add(M,smul(M,ell,a),d) in H or
                                add(M,smul(M,ell,a),neg(M,d)) in H)
                        assert u[:ell-1]==v[:ell-1] and u[ell-1]!=v[ell-1]
                        cu,cv=newton_coeff(u,ell),newton_coeff(v,ell)
                        assert cu[:ell]==cv[:ell]
                        assert cu[ell]-cv[ell]==-Fraction(u[ell-1]-v[ell-1],ell)
                        assert abs(cu[ell]-cv[ell])==6*3**((ell-1)//2)
                        counts['odd_first_difference']+=1
                    elif q%2==0:
                        counts['even_quotient']+=1
                    else:
                        counts['odd_nongeneration']+=1
                    if z in S or z in T:
                        counts['with_loops']+=1
                    if cospec:
                        counts['cospectral']+=1
                    if (counts['sympy_crosschecks']<10 and N<=18
                        and counts['configurations']%17==0):
                        assert (charpoly_direct(M,S)==charpoly_direct(M,T))==cospec
                        counts['sympy_crosschecks']+=1
                    counts['configurations']+=1
    expected=dict(configurations=1224,odd_first_difference=176,even_quotient=432,
                  odd_nongeneration=616,with_loops=20,cospectral=1048,
                  sympy_crosschecks=10)
    assert counts==expected,counts
    print(json.dumps(dict(families=len(FAMILIES),**counts),sort_keys=True))

if __name__=='__main__':
    main()
