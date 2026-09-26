#!/usr/bin/env python3
"""Numerical exhaustive verification of the index-2 defect identity on selected finite abelian groups.

The theorem itself is proved in README.md by character orthogonality. This script checks every
(G, chi, D) instance in the listed finite test family and fails on the first deviation.
Character values are floating complex roots of unity, so this is a numerical certificate,
not an exact-arithmetic proof.
"""
import itertools, cmath
from fractions import Fraction

TOL=1e-8
GROUPS=[(2,4),(2,2),(2,6),(2,8),(4,4),(2,2,2),(2,10)]

def group(cyc): return list(itertools.product(*[range(m) for m in cyc]))
def chars(cyc): return group(cyc)
def chi(c,x,cyc):
    return cmath.exp(2j*cmath.pi*sum(c[i]*x[i]/cyc[i] for i in range(len(cyc))))
def order2_chars(cyc):
    return [c for c in chars(cyc)
            if any(c) and all((2*c[i])%cyc[i]==0 for i in range(len(cyc)))]
def hat(S,c,cyc): return sum(chi(c,x,cyc) for x in S)

def verify_group(cyc,dmax=3):
    G=group(cyc); N=len(G); cases=0
    for q in order2_chars(cyc):
        A=[x for x in G if abs(chi(q,x,cyc)-1)<1e-9]
        n=len(A)
        assert 2*n==N
        for d in range(1,min(dmax,n-1)+1):
            for D in itertools.combinations(A,d):
                T=[x for x in A if x not in D]
                for c in chars(cyc):
                    lhs=hat(T,c,cyc)
                    rhs=complex(n-d,0) if (not any(c) or c==q) else -hat(D,c,cyc)
                    assert abs(lhs-rhs)<=TOL, (cyc,q,D,c,lhs,rhs)
                Enq=sum(abs(hat(T,c,cyc))**2 for c in chars(cyc) if any(c))
                Eq=abs(hat(T,q,cyc))**2
                expected=Fraction(n-d,n+d)
                assert abs(Eq/Enq-float(expected))<=1e-9, (cyc,q,D,Eq/Enq,expected)
                cases+=1
    return cases

count=0
for cyc in GROUPS:
    c=verify_group(cyc)
    count+=c
    print(f"{cyc}: {c} (chi,D) cases passed")
assert count==1346, f"enumeration changed: expected 1346, got {count}"
print(f"ALL CHECKS PASSED: {count} (G, chi, D) instances; tolerance={TOL}")
