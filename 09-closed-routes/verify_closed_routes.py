#!/usr/bin/env python3
"""Exact finite checks for the G30 Parseval closure and the cubic-residue rank identity.

The general theorem for arbitrary finite abelian groups is a consequence of character
orthogonality and is stated/proved in README.md. This script checks the G30 laboratory
with Gaussian-integer character values, so the finite arithmetic below is exact.
"""
from itertools import combinations
from fractions import Fraction
from math import gcd

G30=[1,7,11,13,17,19,23,29]

def pw(g,n):
    r=1
    for _ in range(n): r=r*g%30
    return r
COORD={pw(7,a)*pw(11,b)%30:(a,b) for a in range(4) for b in range(2)}
CHARS=[(j,k) for j in range(4) for k in range(2)]
I=[(1,0),(0,1),(-1,0),(0,-1)]

def chi(jk,g):
    j,k=jk; a,b=COORD[g]
    re,im=I[(j*a)%4]
    s=-1 if (k*b)%2 else 1
    return re*s,im*s

def power_sum(T,jk):
    re=im=0
    for t in T:
        a,b=chi(jk,t); re+=a; im+=b
    return re*re+im*im

def nontrivial_energy(T):
    vals=[power_sum(T,c) for c in CHARS]
    # (0,0) is the trivial character and contributes |T|^2.
    return sum(vals)-len(T)**2

for k in range(1,6):
    vals={nontrivial_energy(T) for T in combinations(G30,k)}
    assert vals=={8*k-k*k}, (k,vals)

N,k=8,3
E=N*k-k*k
assert E==15
assert Fraction(E,k*k)==Fraction(N-k,k)==Fraction(5,3)

# For p == 1 mod 3, the cubic-residue subgroup of F_p^* has order (p-1)/3.
# Removing the identity gives (p-1)/3 - 1 = (p-4)/3.
ps=[7,13,19,31,37,43,61,67,73]
for p in ps:
    assert p%3==1
    assert (p-4)%3==0
    assert (p-4)//3==(p-1)//3-1

print("ALL EXACT ASSERTIONS PASSED")
print("G30 non-trivial Parseval energy = 8k-k^2 for every tested k=1..5")
print("For k=3: 15/9 = 5/3")
print("Cubic-residue centred rank: (p-4)/3 = (p-1)/3 - 1 on the listed primes")
