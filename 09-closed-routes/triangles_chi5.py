#!/usr/bin/env python3
"""Finite Pythagorean congruence check.

For odd x coprime to 30 and (x,b,c)=(x,(x^2-1)/2,(x^2+1)/2), verify that
12 divides b and that divisibility by 5 lies in b or c according to chi_5(x).
This is an elementary finite check; no novelty is claimed.
"""
from math import gcd
def chi5(x): return 1 if x*x%5==1 else -1
n=0
for x in range(1,100000,2):
    if gcd(x,30)!=1: continue
    b=(x*x-1)//2; c=(x*x+1)//2
    assert x*x+b*b==c*c and c-b==1
    assert b%12==0, "2 et 3 toujours dans b"
    if chi5(x)==1: assert b%5==0 and c%5!=0
    else:          assert c%5==0 and b%5!=0
    n+=1
# l'information portee sur la classe mod 30 est exactement chi5
classes={r:chi5(r) for r in range(30) if gcd(r,30)==1}
assert sorted(classes.values()).count(1)==4 and sorted(classes.values()).count(-1)==4
print(f"Triangles OK sur {n} valeurs de x : 12 | b toujours ; 5 dans b ou dans c selon chi5(x)")
print(f"  chi5 = +1 sur {sorted(r for r,v in classes.items() if v==1)} ; -1 sur {sorted(r for r,v in classes.items() if v==-1)}")
print("  mod-30 class information in this check reduces to chi5(x)")
