"""Exact finite checks of COU-20 (not a Lean proof or exhaustive theorem).

Dependencies: Python 3 and sympy. Execute: python cou20_sanity_exact.py
Directed edges x -> x+s, with loops and distinct increments preserved.
"""
from itertools import product
import sympy as sp

def add(x,y,mods):
    return tuple((i+j)%m for i,j,m in zip(x,y,mods))

def neg(x,mods):
    return tuple(-i%m for i,m in zip(x,mods))

def smul(k,x,mods):
    return tuple(k*i%m for i,m in zip(x,mods))

def subgroup(mods,gens):
    zero=tuple(0 for _ in mods)
    found={zero}
    frontier=[zero]
    while frontier:
        x=frontier.pop()
        for g in gens:
            for y in (add(x,g,mods),add(x,neg(g,mods),mods)):
                if y not in found:
                    found.add(y)
                    frontier.append(y)
    return found

def adj(mods,steps):
    vertices=list(product(*(range(m) for m in mods)))
    index={x:i for i,x in enumerate(vertices)}
    A=sp.zeros(len(vertices))
    for i,x in enumerate(vertices):
        for s in set(steps):
            A[i,index[add(x,s,mods)]]=1
    return A

def run_case(mods,a,d,h,require_generation=True):
    zero=tuple(0 for _ in mods)
    assert h!=zero and add(h,h,mods)==zero
    H=subgroup(mods,[h])
    assert d not in H and smul(3,d,mods) in H
    order=1
    for m in mods: order*=m
    q=order//len(H)
    generation=len(subgroup(mods,[a,d,h]))==order
    if require_generation: assert generation
    pairfull=len(subgroup(mods,[a,h]))==order
    S=(a,add(a,d,mods),add(add(a,d,mods),h,mods))
    md=neg(d,mods)
    T=(a,add(a,md,mods),add(add(a,md,mods),h,mods))
    A,B=adj(mods,S),adj(mods,T)
    cospec=A.charpoly().as_expr()==B.charpoly().as_expr()
    if generation:
        assert cospec == ((not pairfull) or q%2==0)
    if pairfull and q%2==1:
        assert q%3==0
        k=q//3
        assert k%2==1
        assert (add(smul(k,a,mods),d,mods) in H
                or add(smul(k,a,mods),md,mods) in H)
        assert (A**k).trace()!=(B**k).trace()
    else:
        k=None
    loop=(zero in S or zero in T)
    return (mods,a,d,h,generation,pairfull,q,loop,cospec,k)

def main():
    cyclic=[(6,0,1),(6,1,1),(6,3,1),
            (12,1,2),(12,3,2),(18,1,3),
            (24,1,4),(24,3,4),(30,1,5),(30,3,5)]
    rows=[run_case((n,),(a,),(d,),(n//2,)) for n,a,d in cyclic]
    rows.extend([
        run_case((6,2),(0,1),(1,0),(3,0)),
        run_case((6,2),(1,1),(2,0),(3,0)),
        run_case((9,2),(1,0),(3,0),(0,1)),
        run_case((3,4),(1,1),(1,0),(0,2)),
    ])
    counter=run_case((6,2),(1,0),(1,0),(3,0),
                     require_generation=False)
    assert not counter[4] and not counter[5]
    assert counter[6]%2==0 and counter[7] and not counter[8]
    print("SUCCESS: 14 exact admissible cases; 1 dropped-generation counterexample")
    for case in rows: print(case)
    print("COUNTEREXAMPLE:",counter)

if __name__=="__main__":
    main()
