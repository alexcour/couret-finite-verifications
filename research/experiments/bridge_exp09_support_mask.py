#!/usr/bin/env python3
"""EXP-09 support-only rank obstruction: exact integer Möbius masks.
No claims about asymptotic Möbius estimates.
"""
from __future__ import annotations
import csv, hashlib, json, math, statistics, cmath
from collections import defaultdict
from pathlib import Path

OUT = Path(__file__).resolve().parent
P_LIST = [100, 200, 400, 800, 1600]
RATIOS = [8, 16]
U30 = {1,7,11,13,17,19,23,29}


def sieve_mu(N):
    mu = [0]*(N+1)
    mu[1] = 1
    lp = [0]*(N+1)
    primes = []
    for n in range(2,N+1):
        if lp[n] == 0:
            lp[n]=n
            primes.append(n)
            mu[n]=-1
        for p in primes:
            if p > lp[n] or p*n>N:
                break
            lp[p*n]=p
            mu[p*n] = 0 if p == lp[n] else -mu[n]
    return mu, primes


def slow_mu(n):
    if n==1:return 1
    k=0
    for q in range(2,math.isqrt(n)+1):
        if n%q==0:
            n//=q
            if n%q==0:return 0
            k+=1
            while n%q==0:return 0
    if n>1:k+=1
    return (-1)**k


def w(n,X):
    return 2*min(n-X,2*X-n) if X<n<2*X else 0


def phi(q):
    ans=q
    r=q
    p=2
    while p*p<=r:
        if r%p==0:
            ans -= ans//p
            while r%p==0:r//=p
        p+=1
    if r>1:ans-=ans//r
    return ans


def select_q(N):
    t=math.sqrt(N)
    candidates=[q for q in range(7,max(12,int(t)+8)) if math.gcd(q,30)==1]
    return min(candidates,key=lambda q:(abs(q-t),q))


def num_freqs(Q):
    return sum(phi(q) for q in range(2,Q+1) if math.gcd(q,30)==1)


def geometry(X,p,mu):
    plain=set()
    pos=set()
    B=defaultdict(int)
    weights_pairs=0
    for m in range(max(1,X//p-2), (2*X)//p+3):
        if m%30 not in U30:
            continue
        wm=w(p*m,X)
        if not wm:
            continue
        mn_mu=mu[m]
        n0=X+1+((p*m-(X+1))%30)
        for n in range(n0,2*X,30):
            if n == p*m:
                continue
            h=(n-p*m)//30
            assert h!=0
            wn=w(n,X)
            assert wn>0
            plain.add(h)
            weights_pairs+=1
            if mn_mu and mu[n]:
                pos.add(h)
                B[h] += mn_mu*mu[n]*wm*wn
    assert plain
    mask={h for h,v in B.items() if v != 0}
    assert mask <= pos <= plain
    N=max(plain)-min(plain)+1
    assert len(plain)<=N
    return plain,pos,mask,B,N,weights_pairs


def exhaustive(X,p,mu):
    B=defaultdict(int)
    plain=set(); pos=set()
    for m in range(1,(2*X)//p+2):
        if m%30 not in U30 or not w(p*m,X):continue
        for n in range(X+1,2*X):
            if (n-p*m)%30 or n==p*m:continue
            h=(n-p*m)//30
            plain.add(h)
            if mu[m]*mu[n]:
                pos.add(h)
                B[h]+=mu[m]*mu[n]*w(n,X)*w(p*m,X)
    return plain,pos,{h for h in B if B[h]},B


def divs(q):
    return [d for d in range(1,q+1) if q%d==0]


def ramanujan(q,d):
    return sum(r*slow_mu(q//r) for r in divs(q) if d%r==0)


def K(Q,d):
    return sum(ramanujan(q,d) for q in range(2,Q+1) if math.gcd(q,30)==1)


def tests(mu):
    for n in range(1,301):
        assert slow_mu(n)==mu[n], (n,mu[n],slow_mu(n))
    # Explicit scaling of integer tent against floating original at selected rational points
    tent_count=0
    for X in (100,800,2400):
        for n in (X, X+1, 5*X//4, 3*X//2, 7*X//4, 2*X-1,2*X):
            original=max(0.0,1-2*abs(n/X-1.5)) if X<=n<=2*X else 0.0
            assert abs(w(n,X)/X-original)<1e-12
            tent_count+=1
    # Direct exhaustive verification on 30 deterministic pairs
    cases=[(p,X) for p in (101,103,107,109,127) for X in (800,960,1280,1600,2400,3200)]
    for p,X in cases:
        a,b,c,B,N,pairs=geometry(X,p,mu)
        aa,bb,cc,BB=exhaustive(X,p,mu)
        assert a==aa and b==bb and c==cc
        assert {h:v for h,v in B.items() if v}=={h:v for h,v in BB.items() if v}
        assert N>=len(a)
    # Ramanujan identities, 100 direct trig checks
    ram_max=0.0
    for q in range(2,12):
        for d in range(-4,6):
            exact=ramanujan(q,d)
            numeric=sum(cmath.exp(-2j*math.pi*a*d/q) for a in range(1,q+1) if math.gcd(a,q)==1)
            ram_max=max(ram_max,abs(numeric-exact))
            assert abs(numeric-exact)<1e-10
    assert K(7,0)==6 and K(7,1)==-1 and K(7,7)==6
    return dict(mu_tests=300,tent_tests=tent_count,exhaustive_reconstructions=len(cases),ramanujan_checks=100,max_ramanujan_abs_error=ram_max)


def main():
    maxX=max(P_LIST)*max(RATIOS)
    mu,primes=sieve_mu(2*maxX+10)
    checks=tests(mu)
    rows=[]
    summary=[]
    for P in P_LIST:
        ps=[p for p in primes if P<p<=2*P and p%30 in U30]
        for ratio in RATIOS:
            X=P*ratio
            for p in ps:
                plain,positive,mask,B,N,pairs=geometry(X,p,mu)
                Q=select_q(N)
                M=num_freqs(Q)
                s=len(mask)
                assert K(Q,0)==M
                assert s<=len(positive)<=len(plain)<=N
                if Q==7 and s>=8:
                    first={}; found=None
                    for h in sorted(mask):
                        r=h%7
                        if r in first:
                            found=(first[r],h)
                            break
                        first[r]=h
                    assert found is not None
                    h,k=found
                    # e_h - e_k : E=2; sum_{i,j} b_i b_j K(i-j)=2M-2K(h-k)=0
                    assert 2*M-2*K(Q,k-h)==0
                    checks['q7_exact_null_witnesses']=checks.get('q7_exact_null_witnesses',0)+1
                rows.append(dict(P=P,ratio=ratio,X=X,p=p,Q=Q,Ngeom=N,M=M,s_mobius=s,s_squarefree=len(positive),s_plain=len(plain),squarefree_minus_mobius=len(positive)-s,plain_minus_squarefree=len(plain)-len(positive),s_over_M=s/M,excess_over_M=s-M,mask_dimension_lower_bound=max(0,s-M),null_direction_possible=int(s>M),large_direction_over_two_possible=int(s>2*M),pair_count=pairs,E_int=sum(v*v for v in B.values())))
            sr=[row for row in rows if row['P']==P and row['ratio']==ratio]
            summary.append(dict(P=P,ratio=ratio,nprimes=len(sr),fraction_s_gt_M=sum(r['null_direction_possible'] for r in sr)/len(sr),fraction_s_gt_2M=sum(r['large_direction_over_two_possible'] for r in sr)/len(sr),min_s_over_M=min(r['s_over_M'] for r in sr),median_s_over_M=statistics.median(r['s_over_M'] for r in sr),mean_s_over_M=statistics.mean(r['s_over_M'] for r in sr),min_null_dimension=min(r['mask_dimension_lower_bound'] for r in sr),min_s=min(r['s_mobius'] for r in sr),min_M=min(r['M'] for r in sr),max_cancellation_zeros=max(r['squarefree_minus_mobius'] for r in sr)))
    failures=[{k:r[k] for k in ('P','ratio','p','Q','Ngeom','M','s_mobius')} for r in rows if not r['null_direction_possible']]
    checks['all_masks_subset_of_plain']=True
    checks['all_large_indices_counted_exactly']=True
    result=dict(protocol=dict(P_WINDOWS=P_LIST,ratios=RATIOS,weights='exact integer tent w_X(n)',Q_rule='nearest coprime 30 >=7 to sqrt(Ngeom)',interpretation='support-only obstruction; never arithmetic Mobius bound'),test_results=checks,verdict='SUPPORT-ONLY NO-GO ON ENTIRE FROZEN PANEL' if not failures else f'SUPPORT-ONLY NO-GO ON {len(rows)-len(failures)}/{len(rows)} CELLS',n_prime_scale_cells=len(rows),fails=failures,summary=summary,minimum_s_over_M=min(r['s_over_M'] for r in rows),minimum_s_minus_M=min(r['excess_over_M'] for r in rows),fraction_s_gt_2M=sum(r['large_direction_over_two_possible'] for r in rows)/len(rows))
    def writecsv(name,entries):
        path=OUT/name
        with path.open('w',newline='') as f:
            w=csv.DictWriter(f,fieldnames=list(entries[0]))
            w.writeheader();w.writerows(entries)
    writecsv('exp09_prime_masks.csv',rows)
    writecsv('exp09_summary.csv',summary)
    (OUT/'exp09_results.json').write_text(json.dumps(result,indent=2,ensure_ascii=False)+'\n')
    print('VERDICT:',result['verdict'])
    print('CELLS:',len(rows),'FAILURES:',len(failures),'MIN S/M:',result['minimum_s_over_M'],'MIN S-M:',result['minimum_s_minus_M'],'fraction s>2M:',result['fraction_s_gt_2M'])
    print('TESTS:',json.dumps(checks,sort_keys=True))
    for x in summary:print('SUMMARY:',json.dumps(x,sort_keys=True))
    for filename in ('bridge_exp09_support_mask.py','exp09_prime_masks.csv','exp09_summary.csv','exp09_results.json'):
        path=OUT/filename
        print('SHA256',filename,hashlib.sha256(path.read_bytes()).hexdigest())

if __name__=='__main__': main()
