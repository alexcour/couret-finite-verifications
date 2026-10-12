#!/usr/bin/env python3
"""Blocking finite and numerical audit, separate from the frozen CU-BRUIT-01 run."""
import math
import sympy as sp
import mpmath as mp

G=(1,7,11,13,17,19,23,29)
S={1,11,29}
def weight(g): return 5 if g in S else -3

assert sorted({(a*a)%30 for a in G}) == [1,19]
assert [a for a in G if pow(a,2,30)==1] == [1,11,19,29]
assert sum(weight(g) for g in G)==0
assert sum(weight(g)**2 for g in G)==120

x=sp.symbols("x",positive=True)
assert sp.simplify(sp.diff((1-x*x)*sp.diff(sp.atanh(x),x),x))==0
assert abs(float(sp.N(sp.Integral(sp.atanh(x)**2,(x,0,1))))-math.pi**2/12)<1e-12

e5={1:0,2:1,4:2,3:3}
def chi(n,a,b):
    if math.gcd(n,30)!=1: return 0j
    return (-1 if a and n%3==2 else 1)*(1j**(b*e5[n%5]))

fourier={}
for a in (0,1):
    for b in range(4):
        if (a,b)==(0,0):continue
        val=sum(weight(g)*chi(g,a,b).conjugate() for g in G)
        fourier[a,b]=val
        assert abs(abs(val)-(24 if (a,b)==(0,2) else 8))<1e-9
assert sum(abs(v)**2 for v in fourier.values())==960

mp.mp.dps=35
cache={}
def zero_constants(q,n):
    if (q,n) not in cache:
        cache[q,n]=(mp.stieltjes(0,mp.mpf(n)/q),mp.stieltjes(1,mp.mpf(n)/q))
    return cache[q,n]

def primitive_char(n,a,b):
    if a and n%3==0 or b and n%5==0:return 0j
    return (-1 if a and n%3==2 else 1)*(1j**(b*e5[n%5]) if b else 1)

B={}
for a,b in fourier:
    q=(3 if a else 1)*(5 if b else 1)
    L=mp.mpc(0); Lp=mp.mpc(0)
    for n in range(1,q+1):
        if math.gcd(n,q)!=1: continue
        v=primitive_char(n,a,b)
        g0,g1=zero_constants(q,n)
        L+=v*g0/q
        Lp-=v*g1/q
    Lp-=mp.log(q)*L
    parity=(a+b)%2
    B[a,b]=float(2*mp.re(Lp/L)+mp.log(q/mp.pi)+mp.digamma(mp.mpf(1+parity)/2))
    assert B[a,b]>0

variance=sum((abs(v)/8)**2*B[k] for k,v in fourier.items())
share=9*B[0,2]/variance
assert abs(share-0.4399030503937205)<2e-7

roots={g:sum(h*h%30==g for h in G) for g in G}
mean=-sum(weight(g)*(roots[g]-1) for g in G)/8
assert mean==-1
print("PASS finite Legendre, group/Fourier/Parseval, analytic B(chi) numerical audit")
print("chi5 variance fraction: %.10f; Rubinstein-Sarnak mean: %.1f" % (share,mean))
print("B:",[(k,round(v,7)) for k,v in sorted(B.items())])
