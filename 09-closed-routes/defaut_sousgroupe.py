#!/usr/bin/env python3
"""Numerical exhaustive check of the subgroup-defect identity on eight small finite abelian groups.

All subgroups of each listed ambient group are enumerated. Character values use floating
roots of unity with strict tolerances, so this is a numerical finite certificate; the theorem
itself follows from character orthogonality and is proved in README.md.
"""
import cmath
from itertools import product, combinations
from fractions import Fraction

def els(mods): return [tuple(e) for e in product(*[range(n) for n in mods])]
def ch(mods,c,x): return cmath.exp(2j*cmath.pi*sum(ci*xi/n for ci,xi,n in zip(c,x,mods)))
def add(mods,x,y): return tuple((a+b)%n for a,b,n in zip(x,y,mods))
def subgroup_generated(mods, seed):
    z=tuple(0 for _ in mods)
    H={z}
    for g in seed:
        if g in H: continue
        # add cyclic translates until stable
        old=list(H)
        generated=set(H)
        x=z
        for _ in range(1, max(mods)*len(mods)+1):
            x=add(mods,x,g)
            for h in old:
                generated.add(add(mods,h,x))
            if x==z: break
        H=generated
        # ensure closure
        changed=True
        while changed:
            changed=False
            cur=list(H)
            for a in cur:
                for b in cur:
                    c=add(mods,a,b)
                    if c not in H:
                        H.add(c); changed=True
    return frozenset(H)

def all_subgroups(mods):
    E=els(mods); z=tuple(0 for _ in mods)
    seen={frozenset([z])}; queue=[frozenset([z])]
    while queue:
        S=queue.pop()
        for g in E:
            if g in S: continue
            H=subgroup_generated(mods, list(S)+[g])
            if H not in seen:
                seen.add(H); queue.append(H)
    return seen

inst=0
GROUPS=[(2,4),(2,2,2),(2,6),(2,8),(4,4),(3,3),(2,2,4),(3,6)]
for mods in GROUPS:
    E=els(mods); N=len(E)
    subs=all_subgroups(mods)
    print(mods, 'subgroups', len(subs))
    for A in subs:
        n=len(A); m=N//n
        if m<2 or n<2: continue
        perp=[c for c in E if all(abs(ch(mods,c,a)-1)<1e-9 for a in A)]
        assert len(perp)==m
        for d in range(1,min(n,3)):
            for D in combinations(sorted(A),d):
                T=[a for a in A if a not in D]
                for psi in E:
                    Th=sum(ch(mods,psi,t) for t in T); Dh=sum(ch(mods,psi,x) for x in D)
                    exp=(n-d) if psi in perp else -Dh
                    assert abs(Th-exp)<1e-8, (mods,sorted(A),D,psi)
                Et=sum(abs(sum(ch(mods,p,t) for t in T))**2 for p in E)-len(T)**2
                Ea=(m-1)*(n-d)**2
                assert abs(Et-round(Et))<1e-7
                r=Fraction(round(Ea),round(Et)); want=Fraction((m-1)*(n-d),(m-1)*n+d)
                assert r==want, (mods,sorted(A),D,r,want)
                inst+=1
assert inst == 1088, f'enumeration changed: expected 1088, got {inst}'
print(f'ALL CHECKS PASSED: {inst} (G,A,D) instances across all subgroups of the eight test groups')
