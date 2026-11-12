#!/usr/bin/env python3
"""Second in-package implementation (not an external expert review).

Independent of verify_continuous.py: brute-force all 16 parameter vertices,
permutation formula for Jacobian determinants, direct collision witnesses.
"""
from fractions import Fraction as F
from itertools import combinations, permutations, product

D = F(1,1000)
E = F(1,100)
# Parameters (q0,w0,q1,w1), ordered q0 < q1.
P = {
  'A':(F(1,4),F(1,2),F(3,4),F(1,2)),
  'B':(F(3,52),F(1,2),F(41,52),F(1,2)),
  'C':(F(1,20),F(275,108),F(23,28),F(49,108)),
  'D':(F(1,10),F(5,2),F(1,2),F(1,2)),
}

def m(x,k):
    return x[1]*x[0]**k + x[3]*x[2]**k

def det(matrix):
    n=len(matrix)
    ans=F(0)
    for s in permutations(range(n)):
        inv=sum(s[i]>s[j] for i in range(n) for j in range(i+1,n))
        v=F(1)
        for i in range(n): v*=matrix[i][s[i]]
        ans += -v if inv%2 else v
    return ans

def jac(x,times):
    a,w,b,v=x
    return [[a**t,b**t,w*t*a**(t-1) if t else F(0),
             v*t*b**(t-1) if t else F(0)] for t in times]

def audit():
    limits={}
    for name,x in P.items():
        corners=[[x[i]+s[i]*D for i in range(4)] for s in product((-1,1),repeat=4)]
        assert all(0 < z[0] < z[2] < 1 and z[1]>0 and z[3]>0 for z in corners)
        limits[name]={t:(min(m(z,t) for z in corners),max(m(z,t) for z in corners))
                      for t in (0,1,2)}
        # Compare independent corner enumeration with direct closed endpoints.
        for t in (0,1,2):
            lo,hi=limits[name][t]
            assert lo == (x[1]-D)*(x[0]-D)**t+(x[3]-D)*(x[2]-D)**t
            assert hi == (x[1]+D)*(x[0]+D)**t+(x[3]+D)*(x[2]+D)**t
        # Positive 3-row minor (for different times) in 4D Prony parameter map.
        for ts in combinations(range(8),3):
            mat=jac(x,ts)
            assert det([[row[0],row[1],row[3]] for row in mat]) != 0
        # 4 separate times have a nonsingular 4x4 generalized Prony Jacobian.
        for ts in combinations(range(6),4):
            assert det(jac(x,ts)) != 0

    def separated(a,b,t,noise):
        a0,a1=limits[a][t];b0,b1=limits[b][t]
        return a1+noise < b0-noise or b1+noise < a0-noise

    assert all(separated(a,b,0,E) for a in ('A','B') for b in ('C','D'))
    assert separated('A','B',1,E)
    assert separated('C','D',2,E)
    assert not separated('A','B',2,E)
    assert not separated('C','D',1,E)
    for ts in combinations((0,1,2),2):
        assert any(all(m(P[a],t)==m(P[b],t) for t in ts)
                   for a,b in combinations(P,2))

    gap_ab=limits['A'][1][0]-limits['B'][1][1]
    gap_cd=limits['C'][2][0]-limits['D'][2][1]
    gap_0=min(limits[z][0][0] for z in ('C','D'))-max(limits[z][0][1] for z in ('A','B'))
    assert gap_ab == F(19,260)
    assert min(gap_ab,gap_cd,gap_0)==gap_ab
    assert E < gap_ab/2

    # All-time nonlinear spectral-node perturbation witness: both trajectories
    # match the same observation sequence within this exact universal bound.
    x=P['A']; q=x[0]; w=x[1]
    bound=w*D/(1-q-D)**2
    assert bound==F(500,561001)<E
    for k in range(301):
        for sign in (-1,1):
            z=(q+sign*D,x[1],x[2],x[3])
            assert abs(m(z,k)-m(x,k))<=bound
    assert F(3) + F(1,2) == F(7,2)
    assert F(2) + F(1,2) == F(5,2)
    print('PASS independent corner enumeration: 4*16 boxes, 3 moments each')
    print('PASS 224 nonzero 3-row minor checks and 60 full 4-row checks')
    print('PASS direct collisions, exact gap 19/260 and 301-step witness sweep')

if __name__=='__main__':
    audit()
