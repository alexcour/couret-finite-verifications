#!/usr/bin/env python3
"""T77-T79 finite regression: exact full-shift factorization, diagonal and Fourier twist.

Uses integer tent weights X*W(n/X); values therefore scaled by X**2.
No numerical test implies an asymptotic theorem or validates an external result.
"""
from math import gcd, cos, sin, pi
from collections import defaultdict

def mobius_sieve(N):
    mu=[0]*(N+1); mu[1]=1; lp=[0]*(N+1); primes=[]
    for n in range(2,N+1):
        if lp[n]==0:
            lp[n]=n; primes.append(n); mu[n]=-1
        for p in primes:
            if p>lp[n] or n*p>N: break
            lp[n*p]=p
            mu[n*p]=0 if n%p==0 else -mu[n]
    return mu

def weight(n,X):
    return max(0,2*min(n-X,2*X-n))

def direct(X,p,mu):
    b=defaultdict(int); L=0
    for m in range(1,2*X//p+2):
        if gcd(m,30)>1: continue
        wm=weight(p*m,X)
        if not wm: continue
        for n in range(X+1,2*X):
            if n%30 != (p*m)%30: continue
            wn=weight(n,X)
            if not wn: continue
            v=mu[m]*mu[n]*wm*wn
            h=(n-p*m)//30
            b[h]+=v
            if h==0: L+=v
    return b,L,{h:v for h,v in b.items() if h!=0}

def factored(X,p,mu):
    Ax=[0]*30; Ap=[0]*30
    for n in range(X+1,2*X):
        if gcd(n,30)==1: Ax[n%30]+=mu[n]*weight(n,X)
    for m in range(1,2*X//p+2):
        if gcd(m,30)==1: Ap[m%30]+=mu[m]*weight(p*m,X)
    return sum(Ax[(p*a)%30]*Ap[a] for a in range(30) if gcd(a,30)==1)

def diagonal_squarefree(X,p,mu):
    return sum(mu[m]**2*weight(p*m,X)**2 for m in range(1,2*X//p+2) if gcd(m,30*p)==1)

def fourier(b,q,j):
    return sum(v*complex(cos(-2*pi*j*h/q),sin(-2*pi*j*h/q)) for h,v in b.items())

def factored_fourier(X,p,q,j,mu):
    inverse30=pow(30,-1,q)
    Sx=[0j]*30; Sm=[0j]*30
    for n in range(X+1,2*X):
        if gcd(n,30)!=1: continue
        theta=-2*pi*j*inverse30*n/q
        Sx[n%30]+=mu[n]*weight(n,X)*complex(cos(theta),sin(theta))
    for m in range(1,2*X//p+2):
        if gcd(m,30)!=1: continue
        theta=2*pi*j*inverse30*p*m/q
        Sm[m%30]+=mu[m]*weight(p*m,X)*complex(cos(theta),sin(theta))
    return sum(Sx[(p*a)%30]*Sm[a] for a in range(30) if gcd(a,30)==1)

def main():
    mu=mobius_sieve(5000); count=0
    for X in (120,210,330,420,660):
        for p in (7,11,13,17):
            b,L,off=direct(X,p,mu)
            C=sum(b.values())
            assert C==factored(X,p,mu)
            assert L==-diagonal_squarefree(X,p,mu)
            assert sum(off.values())==C-L
            for q in (7,11,13,17):
                for j in range(q):
                    lhs=fourier(off,q,j)
                    rhs=factored_fourier(X,p,q,j,mu)-L
                    assert abs(lhs-rhs)<1e-5*max(1,abs(lhs),abs(rhs)),(X,p,q,j,lhs,rhs)
                    count+=1
    print("PASS: 20 exact product/diagonal tests; %d Fourier factorization checks" % count)

if __name__=="__main__":
    main()
