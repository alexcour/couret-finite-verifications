#!/usr/bin/env python3
"""T81-T85: exact Ramanujan kernel and collision-free coefficient null.
A verification script; no statistical or RH theorem is claimed.
"""
import importlib.util
import itertools
import json
import math
from collections import defaultdict
from pathlib import Path
import numpy as np

HERE=Path(__file__).resolve().parent
SRC=HERE/'bridge_exp05_spectral_null.py'
spec=importlib.util.spec_from_file_location('bridge_exp05',SRC)
exp05=importlib.util.module_from_spec(spec)
spec.loader.exec_module(exp05)

def mue(n):
    if n==0:return 0
    n=abs(n)
    if n==1:return 1
    prime_count=0
    p=2
    while p*p<=n:
        if n%p==0:
            n//=p
            if n%p==0:return 0
            prime_count+=1
        p+=1
    if n>1: prime_count+=1
    return (-1)**prime_count

def c_formula(q,d):
    return sum(r*mue(q//r) for r in range(1,q+1) if q%r==0 and d%r==0)

def c_exp(q,d):
    return sum(np.exp(-2j*np.pi*a*d/q) for a in range(1,q+1) if math.gcd(a,q)==1)

def kernel(Q,d):
    return sum(c_formula(q,d) for q in range(2,Q+1) if math.gcd(q,30)==1)

def kernel_mertens(Q,d):
    if d==0:return sum(sum(1 for a in range(1,q+1) if math.gcd(a,q)==1) for q in range(2,Q+1) if math.gcd(q,30)==1)
    ret=0
    for r in range(1,Q+1):
        if d%r!=0 or math.gcd(r,30)!=1:continue
        ret+=r*sum(mue(s) for s in range(1,Q//r+1) if math.gcd(s,30)==1)
    return ret-1

def Fourier_packet(q,b,hmin):
    H=np.arange(len(b))+hmin
    pkt=np.bincount(H%q,weights=b,minlength=q)
    ft=np.fft.fft(pkt)
    return sum(abs(ft[a])**2 for a in range(1,q) if math.gcd(a,q)==1)

def spectral_direct(b,hmin,Q):
    return sum(Fourier_packet(q,b,hmin) for q in range(2,Q+1) if math.gcd(q,30)==1)

def spectral_ramanujan(b,Q):
    N=len(b)
    ac=np.correlate(b,b,mode='full')[N-1:]
    M=kernel(Q,0)
    return M*float(ac[0])+2*sum(kernel(Q,d)*float(ac[d]) for d in range(1,N))

def spectral_divisor_packet(b,hmin,Q):
    H=np.arange(len(b))+hmin
    val=0.0
    for q in range(2,Q+1):
        if math.gcd(q,30)!=1:continue
        for r in range(1,q+1):
            if q%r: continue
            packet=np.bincount(H%r,weights=b,minlength=r)
            val+=r*mue(q//r)*float(np.dot(packet,packet))
    return val

def collisionfree_test():
    allprimes=exp05.prime_sieve(2*max(exp05.P_WINDOWS)+10)
    panels=0;maxspan=0;maxpairs=0;maxn=0
    for P in exp05.P_WINDOWS:
        ps=[p for p in allprimes if P<p<=2*P and p%30 in exp05.RES]
        for ratio in exp05.RATIOS:
            X=P*ratio
            for p in ps:
                geo=exp05.construction(X,p)
                m=geo['m'];n=geo['n'];h=geo['h']
                assert X/p<30
                assert len(set(n.tolist()))==len(n), (P,ratio,p,'repeat n')
                assert 0 not in h
                assert np.all(n>m)
                assert len(set(m.tolist())) <= math.ceil(X/p)+1
                panels+=1;maxspan=max(maxspan,X/p);maxpairs=max(maxpairs,len(n));maxn=max(maxn,geo['Ngeom'])
    return {'panel_prime_scale_rows':panels,'maximum_X_over_p':maxspan,'maximum_pairs':maxpairs,'maximum_Ngeom':maxn,'all_big_indices_n_unique':True}

def exact_conditional_toy():
    # Synthetic matching with each n used once, m allowed to recur.
    edges=[('n1','m1',-2,2),('n2','m1',-2,1),('n3','m1',-1,3),('n4','m2',1,1),('n5','m2',2,2),('n6','m2',2,1)]
    nodes=sorted(set(t for e in edges for t in e[:2]))
    Q=13;M=kernel(Q,0)
    ds=[];sample_count=0
    for ss in itertools.product([-1,1],repeat=len(nodes)):
        eps=dict(zip(nodes,ss));b=defaultdict(int)
        for n,m,h,w in edges:b[h]+=w*eps[n]*eps[m]
        E=sum(v*v for v in b.values())
        assert E>0
        R=sum(b[h]*b[k]*kernel(Q,h-k) for h in b for k in b)
        ds.append(R/(M*E));sample_count+=1
    meanD=sum(ds)/len(ds)
    assert abs(meanD-1)<1e-12,meanD
    return {'toy_nodes':len(nodes),'configurations':sample_count,'mean_D':meanD,'all_n_distinct':True}

def noncollision_counterexample():
    edges=[((2,1),2,2),((0,0),2,3),((0,1),2,1),((2,2),2,2),((0,2),-1,1),((2,0),3,1),((1,1),-2,1)]
    Q=7;M=kernel(Q,0); ds=[]
    for ss in itertools.product([-1,1],repeat=6):
        b=defaultdict(int)
        for (i,j),h,w in edges:b[h]+=w*ss[i]*ss[j+3]
        E=sum(v*v for v in b.values())
        assert E>0
        R=sum(b[h]*b[k]*kernel(Q,h-k) for h in b for k in b)
        ds.append(R/(M*E))
    meanD=sum(ds)/len(ds)
    assert abs(meanD-1)>0.01
    return {'toy_configurations':len(ds),'mean_D':meanD,'shows_individual_n_uniqueness_is_needed':True}

def main():
    checks=0;maxerr=0.0
    for q in range(2,41):
        for d in range(-45,46):
            z=c_exp(q,d);formula=c_formula(q,d)
            maxerr=max(maxerr,abs(z-formula));checks+=1
            assert abs(z-formula)<1e-9,(q,d,z,formula)
    km=0
    for Q in (7,11,13,23,41):
        for d in range(-125,126):
            assert kernel(Q,d)==kernel_mertens(Q,d),(Q,d)
            km+=1
    panels=collisionfree_test()
    # Fourier direct, autocorrelation / Ramanujan, and divisor/packet formula
    mu=exp05.mobius_sieve(27000)
    units=np.array([math.gcd(i,30)==1 for i in range(len(mu))]);mu=mu*units
    coeffs=[units.astype(np.int8),np.abs(mu),mu]
    samples=[(101,800),(103,1600),(307,3200),(809,12800)]
    comparisons=[]
    for p,X in samples:
        geo=exp05.construction(X,p);Q=exp05.choose_q(geo['Ngeom'])
        for kind,coef in zip(['plain','squarefree','inverse'],coeffs):
            b=exp05.build_b(geo,coef)
            freq=spectral_direct(b,geo['hmin'],Q)
            ram=spectral_ramanujan(b,Q)
            div=spectral_divisor_packet(b,geo['hmin'],Q)
            err=max(abs(freq-ram),abs(freq-div))
            assert np.isclose(freq,ram,rtol=5e-12,atol=5e-8),(p,X,kind,err)
            assert np.isclose(freq,div,rtol=5e-12,atol=5e-8),(p,X,kind,err)
            comparisons.append({'p':p,'X':X,'kind':kind,'Q':Q,'energy':float(np.dot(b,b)),'frequency_power':float(freq),'kernel_power':float(ram),'packet_power':float(div),'max_abs_error':float(err)})
    output={'ramanujan_trig_checks':checks,'max_ramanujan_trig_error':maxerr,'kernel_divisor_checks':km,'panel':panels,'collisionfree_toy':exact_conditional_toy(),'repeated_n_counterexample':noncollision_counterexample(),'numerical':comparisons}
    (HERE/'T81_T85_exact_checks.json').write_text(json.dumps(output,indent=2)+'\n')
    print('Ramanujan trig checks:',checks,'max abs error',maxerr)
    print('Kernel Mertens checks:',km)
    print('Panels:',panels)
    print('Conditional toy:',output['collisionfree_toy'])
    print('Repeated-n counterexample:',output['repeated_n_counterexample'])
    print('Frequency-vs-kernel checks:',len(comparisons),'max error',max(r['max_abs_error'] for r in comparisons))
    print('All checks PASS')

if __name__=='__main__':main()
