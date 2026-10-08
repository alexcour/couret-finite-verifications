import json, hashlib
from sympy import Poly, symbols, cyclotomic_poly, totient
from math import gcd
x=symbols('x')
rows=[]
for Q in [7,11,13,17,23,29,49]:
    qs=[q for q in range(2,Q+1) if gcd(q,30)==1]
    M=sum(int(totient(q)) for q in qs); N=Q*Q
    C=Poly(1,x,domain='ZZ')
    for q in qs:C*=Poly(cyclotomic_poly(q,x),x,domain='ZZ')
    assert C.degree()==M and N>M
    B=C*Poly(x,x,domain='ZZ')
    if N-M-1:B*=Poly(1+x**(N-M-1),x,domain='ZZ')
    assert B.degree()==N and B.nth(1)!=0 and B.nth(N)!=0
    for q in qs: assert B.rem(Poly(cyclotomic_poly(q,x),x,domain='ZZ')).is_zero
    co={int(k):int(v) for (k,),v in B.terms() if v}
    E=sum(v*v for v in co.values())
    # Integer Ramanujan via mobius sum
    from sympy import mobius
    def kernel(d):return sum(sum(r*int(mobius(q//r)) for r in range(1,q+1) if q%r==0 and d%r==0) for q in qs)
    # autocorrelation sparse per populated pairs
    gram=sum(v*w*kernel(a-b) for a,v in co.items() for b,w in co.items())
    assert gram==0,(Q,gram)
    rows.append(dict(Q=Q,M=M,N=N,nonzeros=len(co),energy_digits=len(str(E)),gram=gram))
# positive Q=7 comparator
N=49;Q=7;M=6
b={h:(6 if h%7==0 else -1) for h in range(1,N+1)}
def k(d):return 6 if d%7==0 else -1
E=sum(v*v for v in b.values());numer=sum(v*w*k(h-j) for h,v in b.items() for j,w in b.items())
assert E==6*N and numer==M*N*N and numer==E*N
with open('/mnt/data/bridge_exp08/exp08_results.json','w') as f:json.dump({'rows':rows,'positive':{'Q':7,'N':N,'D_numerator':N,'D_denominator':M}},f,indent=2)
print('PASS cyclotomic exact roots and integer Gram for 7 Q; positive D=49/6')
for r in rows:print(r)
