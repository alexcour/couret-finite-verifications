#!/usr/bin/env python3
"""Exact verifier for COURET–OAI–BRIDGE–01 / T38-T41.

Research branch only. No RH claim.
"""

from fractions import Fraction

# T38: exact energy identity in Q^8
A = [Fraction(i+1, 3) for i in range(8)]
B = [Fraction((-1)**i * (i+2), 5) for i in range(8)]
p = 31
beta = 2

def dot(x,y):
    return sum(a*b for a,b in zip(x,y))

lhs_vec = [A[i] - Fraction(p**beta) * B[i] for i in range(8)]
lhs = dot(lhs_vec,lhs_vec)
rhs = dot(A,A) + Fraction(p**(2*beta))*dot(B,B) - 2*Fraction(p**beta)*dot(A,B)
assert lhs == rhs

# T40/T41 coefficient checks on finitely many indices, with a compactly supported toy window.
def W_num(n, X):
    # exact toy window: 1 on X <= n <= 2X, else 0
    return Fraction(1) if X <= n <= 2*X else Fraction(0)

def psi(n):
    # real multiplicative toy character mod 5: Legendre symbol with zero on multiples of 5
    r=n%5
    return {0:0,1:1,2:-1,3:-1,4:1}[r]

def mu(n):
    x=n
    sign=1
    q=2
    while q*q<=x:
        e=0
        while x%q==0:
            x//=q; e+=1
        if e>=2: return 0
        if e==1: sign*=-1
        q+=1
    if x>1: sign*=-1
    return sign

X=20
p=3
N=300

plain=sum(Fraction(psi(n))*W_num(n,X) for n in range(1,N+1))
plain_shift=sum(Fraction(psi(n))*W_num(n,X/p) for n in range(1,N+1))
left=plain-Fraction(psi(p))*plain_shift
right=sum(Fraction(psi(n))*W_num(n,X) for n in range(1,N+1) if n%p!=0)
assert left==right, (left,right)

# T41 resolvent: finite because toy window gives zero after enough shifts.
mob=sum(Fraction(mu(n)*psi(n))*W_num(n,X) for n in range(1,N+1))
res=Fraction(0)
j=0
while True:
    Xj=Fraction(X, p**j)
    term=sum(Fraction(mu(n)*psi(n))*W_num(n,Xj) for n in range(1,N+1))
    if term==0 and Xj < 1:
        break
    res += Fraction(psi(p))**j * term
    j+=1
    if j>20:
        raise AssertionError("resolvent did not terminate in toy test")
mob_no_p=sum(Fraction(mu(n)*psi(n))*W_num(n,X) for n in range(1,N+1) if n%p!=0)
assert res==mob_no_p, (res,mob_no_p)

print("ALL EXACT ASSERTIONS PASSED")
print("T38 energy identity verified.")
print("T40 plain p-sieve identity verified.")
print("T41 Möbius scale-resolvent identity verified.")
