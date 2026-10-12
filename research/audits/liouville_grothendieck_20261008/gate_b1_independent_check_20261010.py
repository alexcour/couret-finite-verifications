#!/usr/bin/env python3
"""CU-BRUIT-02: independently check frozen U(30) Fourier/bias identities.

--numeric additionally checks the B(chi) L'/L constants via independent
symmetric finite differences with mpmath.dirichlet at s=1 (not the historic
Stieltjes-constant implementation). Numerical values are NOT interval-certified.
This script does not certify zeros, GRH, LI, or the sign density.
"""
import argparse
import math

G=(1,7,11,13,17,19,23,29)
S={1,11,29}
LOG5={1:0,2:1,4:2,3:3}
EXPECTED={'0,1':1,'0,2':3,'0,3':1,'1,0':-1,
          '1,1':1,'1,2':-1,'1,3':1}

def character(a,b,n):
    q=(3 if a else 1)*(5 if b else 1)
    if math.gcd(q,n)>1:return 0
    return (-1 if a and n%3==2 else 1)*(1j**(b*LOG5[n%5]) if b else 1)

def weight(n):return 5 if n in S else -3

def exact_checks():
    assert sum(weight(x) for x in G)==0
    assert sorted(set(pow(x,2,30) for x in G))==[1,19]
    assert all(sum(pow(x,2,30)==a for x in G)==(4 if a in (1,19) else 0) for a in G)
    meanshift=-sum(weight(a)*(sum(pow(x,2,30)==a for x in G)-1)
                   for a in G)/len(G)
    assert meanshift==-1
    values={}
    for a in (0,1):
        for b in range(4):
            if a==b==0:continue
            label=f'{a},{b}'
            z=sum(weight(n)*character(a,b,n).conjugate() for n in G)/len(G)
            assert z==EXPECTED[label]
            values[label]=int(z.real)
    unnormalized=sum((8*values[k])**2 for k in values)
    assert unnormalized==960
    assert sum(abs(values[k])**2 for k in values)==15
    print('PASS exact U(30): coefficients',values,'mu=-1; Parseval=960')
    return values

def numerical_check():
    import mpmath as mp
    mp.mp.dps=18
    h=mp.mpf('0.0001')
    results={}
    reps=[(0,1),(0,2),(1,0),(1,1),(1,2)]
    for a,b in reps:
        q=(3 if a else 1)*(5 if b else 1)
        parity=(a+b)%2
        chi=[character(a,b,n) for n in range(q)]
        f=lambda s:mp.dirichlet(s,chi)
        L=f(1)
        dL=(f(1+h)-f(1-h))/(2*h)
        B=2*mp.re(dL/L)+mp.log(q/mp.pi)+mp.digamma(mp.mpf(parity+1)/2)
        results[f'{a},{b}']=B
        print('B',a,b,mp.nstr(B,15),flush=True)
    results['0,3']=results['0,1']
    results['1,3']=results['1,1']
    variance=mp.fsum((9 if key=='0,2' else 1)*b for key,b in results.items())
    share=9*results['0,2']/variance
    print('VAR',mp.nstr(variance,17),'CHI5_SHARE',mp.nstr(share,15))
    assert abs(variance-mp.mpf('3.203007082327546'))<mp.mpf('0.000001')
    assert abs(share-mp.mpf('0.4399030503937205'))<mp.mpf('0.000001')
    print('PASS numerical cross-check, not rigorous interval/error bounds')

if __name__=='__main__':
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--numeric',action='store_true')
    arguments=parser.parse_args()
    exact_checks()
    if arguments.numeric:numerical_check()
