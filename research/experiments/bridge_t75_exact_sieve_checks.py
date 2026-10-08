#!/usr/bin/env python3
"""Finite sanity check for T75. NOT an asymptotic proof."""
from math import isqrt

def prime(n):
    return n > 1 and all(n % d for d in range(2, isqrt(n) + 1))

def mobius(n):
    if n <= 0:
        raise ValueError(n)
    x, result = n, 1
    for d in range(2, isqrt(x) + 1):
        if x % d:
            continue
        x //= d
        result = -result
        if x % d == 0:
            return 0
        while x % d == 0:
            x //= d
    return -result if x > 1 else result

def liouville(n):
    if n <= 0:
        raise ValueError(n)
    x, parity = n, 0
    for d in range(2, isqrt(x) + 1):
        while x % d == 0:
            x //= d
            parity ^= 1
    if x > 1:
        parity ^= 1
    return -1 if parity else 1

def squarefree_sieve(n, D):
    return int(all(n % (r*r) for r in range(2, D+1) if prime(r)))

def check():
    for n in range(1, 2001):
        mu=mobius(n)
        assert mu == liouville(n) * mu*mu
        assert mu*mu == squarefree_sieve(n, isqrt(n))
    tests=0
    for p in (7, 11, 13):
        for h in (-2, -1, 1, 2):
            for M in (40, 97):
                pairs=[(m,p*m+30*h) for m in range(1,M+1) if p*m+30*h>0]
                base=sum(mobius(m)*mobius(n) for m,n in pairs)
                exact=sum(liouville(m)*liouville(n)*squarefree_sieve(m,isqrt(m))*squarefree_sieve(n,isqrt(n)) for m,n in pairs)
                assert base==exact
                for D in (1,2,3,5):
                    truncated=sum(liouville(m)*liouville(n)*squarefree_sieve(m,D)*squarefree_sieve(n,D) for m,n in pairs)
                    tail=sum(1 for m,n in pairs if any(prime(r) and m%(r*r)==0 for r in range(D+1,isqrt(m)+1)) or any(prime(r) and n%(r*r)==0 for r in range(D+1,isqrt(n)+1)))
                    assert abs(base-truncated) <= 2*tail
                    tests+=1
    print(f"PASS: 2000 exact squarefree checks; {tests} affine truncation checks")

if __name__=="__main__":
    check()
