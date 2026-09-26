#!/usr/bin/env python3
"""Exact bookkeeping for E[1-|Z_k|^2] with iid uniform unit phases.

For Z_k=(U_1+...+U_k)/k, E[U_i conjugate(U_j)]=1 when i=j and 0 otherwise.
Hence E|Z_k|^2=k/k^2=1/k and E[1-|Z_k|^2]=(k-1)/k.
This script encodes that finite expectation bookkeeping with rational arithmetic.
"""
from fractions import Fraction

for k in (2,3,4,5,8):
    diagonal_terms=k
    off_diagonal_terms=k*(k-1)
    diagonal_expectation=Fraction(1,1)
    off_diagonal_expectation=Fraction(0,1)
    e_abs2=(diagonal_terms*diagonal_expectation +
            off_diagonal_terms*off_diagonal_expectation)/Fraction(k*k,1)
    deficit=Fraction(1,1)-e_abs2
    assert e_abs2==Fraction(1,k)
    assert deficit==Fraction(k-1,k)
    print(f"k={k}: E|Z|^2={e_abs2}; E[1-|Z|^2]={deficit}")
assert Fraction(3-1,3)==Fraction(2,3)
print("ALL EXACT BOOKKEEPING ASSERTIONS PASSED; k=3 gives 2/3")
