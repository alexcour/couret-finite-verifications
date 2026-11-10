#!/usr/bin/env python3
"""Independent (non-Arb) Dirichlet L evaluator using Euler-Maclaurin plus explicit remainder.
Uses only elementary mpmath.iv interval operations. This is EXPERIMENTAL because
mpmath.iv support is documented as experimental; do not label global certificate.
"""
import math
import functools
from fractions import Fraction as Q
from mpmath import iv

Q15_UNITS=(1,2,4,7,8,11,13,14)
LOG5={1:0,2:1,4:2,3:3}
N=20
P=28
M=50
iv.dps=40

@functools.lru_cache(None)
def bernoulli_even(max_k):
    a=[]
    out={}
    for m in range(2*max_k+1):
        a.append(Q(1,m+1))
        for j in range(m,0,-1):
            a[j-1]=j*(a[j-1]-a[j])
        if m>0 and m%2==0:
            out[m//2]=a[0]/math.factorial(m)
    return out

def Z(v):
    return iv.mpc(v)

def fi(q):
    if isinstance(q,int): return iv.mpf(q)
    q=Q(q)
    return iv.mpf(q.numerator)/iv.mpf(q.denominator)

def xinterval(lo,hi):
    def endpoint(v,which):
        x=fi(v)
        return x.a if which=='a' else x.b
    return iv.mpf([endpoint(lo,'a'),endpoint(hi,'b')])

def box(relo,rehi,imlo,imhi):
    return iv.mpc(xinterval(relo,rehi),xinterval(imlo,imhi))

def get_bound(n=N,p=P,m=M):
    # Strictly conservative bound on total Euler-Maclaurin remainder and exprel tail.
    product=math.prod(range(27,27+2*p))
    em=Q(16*4*product*n*n,6**(2*p)*(2*p-2)*n**(2*p))
    er=Q(128*n*2**m,math.factorial(m+1))
    return em,er

class Evaluator:
    def __init__(self,dps=35,n=N,p=P,m=M):
        iv.dps=dps
        self.n=n;self.p=p;self.m=m
        self.elem=[];self.tail=[]
        for a in Q15_UNITS:
            logs=[iv.log(fi(k)+fi(Q(a,15))) for k in range(n)]
            v=fi(n)+fi(Q(a,15))
            lv=iv.log(v)
            h=lv-iv.log(fi(n))
            self.elem.append(logs)
            self.tail.append((lv,h,v))
        self.coeff=[None]+[fi(v) for k,v in sorted(bernoulli_even(p).items())]
        em,er=get_bound(n,p,m)
        self.em=em;self.exprelerr=er
        self.err_Q=em+er
        self.err=fi(em+er)
        self.log15=iv.log(iv.mpf(15));self.logn=iv.log(fi(n))
        self.halfi=iv.mpf(1)/2
    def exprel(self,z):
        term=iv.mpc(1);v=iv.mpc(1)
        for k in range(1,self.m):
            term=term*z/iv.mpf(k+1)
            v=v+term
        return v
    def evaluate(self,s,b):
        assert b in (1,2,3)
        w=s-1
        t=iv.exp(-w*self.logn)
        val=iv.mpc(0)
        for a,logs,tail in zip(Q15_UNITS,self.elem,self.tail):
            lv,h,v=tail
            baseterm=iv.exp(-s*lv)
            a_sum=iv.mpc(0)
            for log in logs:
                a_sum += iv.exp(-s*log)
            a_sum += -t *h*self.exprel(-w*h) + self.halfi*baseterm
            poch=iv.mpc(1)
            invv=1/v
            invv2=invv*invv
            denom=invv
            for k in range(1,self.p+1):
                poch=poch*(s+(2*k-2))
                a_sum += self.coeff[k]*poch*baseterm*denom
                poch=poch*(s+(2*k-1))
                denom=denom*invv2
            index=(b*LOG5[a%5])%4
            # i^index times (-1)^chi_3
            if a%3==2: index=(index+2)%4
            val += (a_sum if index==0 else 1j*a_sum if index==1 else -a_sum if index==2 else -1j*a_sum)
        value=iv.exp(-s*self.log15)*val
        error=iv.mpf([-self.err.b,self.err.b])
        return value+iv.mpc(error,error)

if __name__=='__main__':
    from mpmath import mp
    import time
    ev=Evaluator(dps=35)
    print('analytic error',*[str(float(x)) for x in get_bound()])
    for b in [1,2,3]:
        for re,im in [('.5','3'),('-0.125','4'),('1.0','0'),('1.125','25'),('.5','15.0')]:
            s=box(re,re,im,im)
            t0=time.time();res=ev.evaluate(s,b)
            chars=[0j]*15
            for a in Q15_UNITS:
                idx=(b*LOG5[a%5]+(2 if a%3==2 else 0))%4
                chars[a]=1j**idx
            mp.dps=35;expect=mp.dirichlet(mp.mpc(re,im),chars)
            print('b',b,'s',re,im,'iv',str(res)[:150],'mp',str(expect)[:65],'sec',round(time.time()-t0,2))

class GroupedEvaluator(Evaluator):
    """Same proven Euler-Mac formula, grouped by character cancellation for tighter balls."""
    def __init__(self,dps=40,n=N,p=P,m=M):
        super().__init__(dps=dps,n=n,p=p,m=m)
        self.grps=[]
        for n0 in range(1,n+1):
            ln=iv.log(iv.mpf(n0));slist=[]
            for a in Q15_UNITS:
                h=iv.log(iv.mpf(1)+fi(Q(a,15*n0)))
                slist.append(h)
            self.grps.append((ln,slist))
        self.firstlogs=[iv.log(fi(Q(a,15))) for a in Q15_UNITS]
        self.npow=iv.exp(-self.logn)
        self.tail_h=[s[1] for s in self.tail]
        self.qphase={}
        for b in (1,2,3):
            self.qphase[b]=[]
            for a in Q15_UNITS:
                idx=((b*LOG5[a%5])+(2 if a%3==2 else 0))%4
                self.qphase[b].append([1,1j,-1,-1j][idx])
    def character_sum(self,terms,b):
        tot=iv.mpc(0)
        for ch,term in zip(self.qphase[b],terms): tot+=ch*term
        return tot
    def evaluate(self,s,b):
        w=s-1
        val=self.character_sum([iv.exp(-s*log) for log in self.firstlogs],b)
        # For n>=1, use sum chi(a)=0 before interval arithmetic.
        for n,(ln,hs) in enumerate(self.grps[:-1],1):
            common=iv.exp(-s*ln)
            val += common*self.character_sum([iv.exp(-s*h)-1 for h in hs],b)
        tailpref=iv.exp(-w*self.logn)
        val += -tailpref*self.character_sum([h*self.exprel(-w*h) for h in self.tail_h],b)
        base=iv.exp(-s*self.logn)
        val += self.halfi*base*self.character_sum([iv.exp(-s*h)-1 for h in self.tail_h],b)
        poch=iv.mpc(1)
        invn=1/fi(self.n);ivn2=invn*invn
        denom=invn
        for k in range(1,self.p+1):
            poch*=s+2*k-2
            twok=2*k-1
            val += self.coeff[k]*poch*base*denom*self.character_sum(
                [iv.exp(-(s+twok)*h)-1 for h in self.tail_h],b)
            poch*=s+2*k-1
            denom*=ivn2
        value=iv.exp(-s*self.log15)*val
        error=iv.mpf([-self.err.b,self.err.b])
        return value+iv.mpc(error,error)

def mpc_for_jet(v):
    if isinstance(v,complex):return iv.mpc(str(v.real),str(v.imag))
    if hasattr(v,"_mpci_"):return iv.mpc(v.real,v.imag)
    return iv.mpc(v)

class J2:
    def __init__(self,v,d1=None,d2=None):
        self.v=mpc_for_jet(v)
        self.d1=mpc_for_jet(0 if d1 is None else d1)
        self.d2=mpc_for_jet(0 if d2 is None else d2)
    def __add__(self,other):
        other=asjet(other)
        return J2(self.v+other.v,self.d1+other.d1,self.d2+other.d2)
    __radd__=__add__
    def __neg__(self):return J2(-self.v,-self.d1,-self.d2)
    def __sub__(self,other):return self+-asjet(other)
    def __rsub__(self,other):return asjet(other)+-self
    def __mul__(self,other):
        other=asjet(other)
        return J2(self.v*other.v,
                  self.d1*other.v+self.v*other.d1,
                  self.d2*other.v+2*self.d1*other.d1+self.v*other.d2)
    __rmul__=__mul__
    def __truediv__(self,other):
        other=asjet(other)
        u=1/other.v
        inv=J2(u,-other.d1*u*u,(2*other.d1*other.d1-other.d2*other.v)*u*u*u)
        return self*inv
    def exp(self):
        u=iv.exp(self.v)
        return J2(u,u*self.d1,u*(self.d1*self.d1+self.d2))

def asjet(x):return x if isinstance(x,J2) else J2(x)

class TaylorEvaluator(GroupedEvaluator):
    # Entire correction E(s) is holomorphic. Cauchy on radius 1/10 around
    # the specified contour: |E|<1e-14, |E'|<1e-13, |E''|<2e-12.
    GLOBAL_ERROR_FOR_CAUCHY=Q(1,10**14)
    CAUCHY_RADIUS=Q(1,10)
    def approx_jet(self,s,b):
        s=J2(s,1,0);w=s-1
        F=asjet(0)
        def ex(t):return t.exp()
        F+=self.character_sum_j([ex(-s*log) for log in self.firstlogs],b)
        for ln,hs in self.grps[:-1]:
            F+=ex(-s*ln)*self.character_sum_j([ex(-s*h)-1 for h in hs],b)
        F+=-ex(-w*self.logn)*self.character_sum_j([self.exprel_j(-w*h)*h for h in self.tail_h],b)
        base=ex(-s*self.logn)
        F+=base*self.halfi*self.character_sum_j([ex(-s*h)-1 for h in self.tail_h],b)
        poch=asjet(1)
        invn=1/fi(self.n);invn2=invn*invn;denom=invn
        for k in range(1,self.p+1):
            poch*=s+(2*k-2)
            two=2*k-1
            F+=poch*self.coeff[k]*base*denom*self.character_sum_j([ex(-(s+two)*h)-1 for h in self.tail_h],b)
            poch*=s+(2*k-1)
            denom*=invn2
        return ex(-s*self.log15)*F
    def exprel_j(self,z):
        term=asjet(1);val=asjet(1)
        for k in range(1,self.m):
            term=term*z/iv.mpf(k+1)
            val+=term
        return val
    def character_sum_j(self,terms,b):
        val=asjet(0)
        for chi,t in zip(self.qphase[b],terms):val+=chi*t
        return val
    def interval_error(self, radius):
        u=fi(radius)
        return iv.mpc(iv.mpf([-u.b,u.b]),iv.mpf([-u.b,u.b]))
    def tight(self,sc,box_s,b):
        c=J2(sc)
        fp=self.approx_jet(sc,b)
        fsecond=self.approx_jet(box_s,b)
        d=box_s-sc
        # The analytic correction bound extends to 1/10-neighborhood of
        # all contour segments, conservatively bounded by 10^-14.
        return (fp.v+self.interval_error(self.err_Q)
                + (fp.d1+self.interval_error(Q(1,10**13)))*d
                + (fsecond.d2+self.interval_error(Q(2,10**12)))*d*d/2)
