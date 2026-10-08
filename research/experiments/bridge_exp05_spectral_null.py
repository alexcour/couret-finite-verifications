#!/usr/bin/env python3
"""EXP-05: prespecified density-corrected spectral and sign controls.
Only numpy and Python stdlib are required. Run from any working directory.
"""
import os, csv, json, math, hashlib, itertools, statistics
from collections import defaultdict
from pathlib import Path
import numpy as np

P_WINDOWS = [100, 200, 400, 800]
RATIOS = [8, 16]
REPLICATES = 16
SEED = 20261008
RES = {1,7,11,13,17,19,23,29}
OUT = Path(__file__).resolve().parent


def window(t):
    if t < 1 or t > 2:
        return 0.0
    return max(0.0, 1.0-2.0*abs(t-1.5))


def prime_sieve(N):
    v = bytearray(b'\x01')*(N+1)
    v[:2] = b'\x00\x00'
    for n in range(2, math.isqrt(N)+1):
        if v[n]:
            v[n*n:N+1:n] = b'\x00'*(((N-n*n)//n)+1)
    return [n for n in range(2,N+1) if v[n]]


def mobius_sieve(N):
    lp=[0]*(N+1); primes=[]; mu=np.zeros(N+1,dtype=np.int8);mu[1]=1
    for n in range(2,N+1):
        if lp[n]==0:
            lp[n]=n;primes.append(n);mu[n]=-1
        for p in primes:
            k=n*p
            if k>N or p>lp[n]: break
            lp[k]=p
            mu[k]=0 if p==lp[n] else -mu[n]
    return mu


def construction(X,p):
    """Returns all strictly positively-weighted off-diagonal pairs, no number-theoretic coefficients."""
    allh=[]; allm=[]; alln=[]; allw=[]
    for m in range(max(1,int(math.floor(X/p))-2),int(math.ceil(2*X/p))+3):
        if m%30 not in RES: continue
        wm=window(p*m/X)
        if wm <= 0: continue
        hl=math.ceil((X-p*m)/30)
        hr=math.floor((2*X-p*m)/30)
        for h in range(hl,hr+1):
            if h==0: continue
            n=p*m+30*h
            if n<=0 or n%30 not in RES:continue
            wn=window(n/X)
            if wn<=0: continue
            allh.append(h);allm.append(m);alln.append(n);allw.append(wm*wn)
    if not allh:
        raise AssertionError('Unexpected empty geometry')
    h=np.array(allh,dtype=np.int32)
    lo=int(min(h));hi=int(max(h))
    return {'h':h,'m':np.array(allm,dtype=np.int32),'n':np.array(alln,dtype=np.int32),
            'w':np.array(allw,dtype=np.float64),'hmin':lo,'hmax':hi,'Ngeom':hi-lo+1}


def brute_b(X,p,coeff):
    d=defaultdict(float)
    nmax=int(2*X)+1
    for m in range(1,math.ceil(2*X/p)+2):
        if m>=len(coeff) or coeff[m]==0: continue
        wm=window(p*m/X)
        if wm==0:continue
        for n in range(1,min(nmax,len(coeff))):
            if coeff[n]==0 or (n-p*m)%30!=0 or n==p*m:continue
            wn=window(n/X)
            if wn>0: d[(n-p*m)//30]+=float(coeff[n]*coeff[m])*wn*wm
    return d


def build_b(g,coeff):
    weights=g['w']*coeff[g['m']]*coeff[g['n']]
    vals=np.bincount(g['h']-g['hmin'],weights=weights,minlength=g['Ngeom'])
    return vals.astype(np.float64)


def frequency_families(Q):
    qs=[]; a_by_q={};freq=set()
    for q in range(2,Q+1):
        if math.gcd(q,30)!=1:continue
        aa=np.array([a for a in range(1,q) if math.gcd(a,q)==1],dtype=np.int32)
        if len(aa):
            qs.append(q);a_by_q[q]=aa
            for a in aa:
                if (int(a),q) in freq:raise AssertionError('duplicate')
                freq.add((int(a),q))
    return qs,a_by_q,len(freq)


def choose_q(N):
    target=math.sqrt(N)
    opts=[q for q in range(7,max(9,math.ceil(target)+5)) if math.gcd(q,30)==1]
    return min(opts,key=lambda q:(abs(q-target),q))


def spectral(b, hmin, Q, qs, a_by_q, M, Ngeom):
    energy=float(np.dot(b,b))
    if energy<=0:
        return {'E':0.0,'satstar':None,'satfull':None,'D':None,'zero_frac':None}
    H=np.arange(Ngeom,dtype=np.int32)+hmin
    psum=0.0
    for q in qs:
        packets=np.bincount(H%q,weights=b,minlength=q)
        FT=np.fft.fft(packets)
        aa=a_by_q[q]
        psum+=float(np.sum(np.abs(FT[aa])**2))
    z=float(np.sum(b))**2
    den=(Ngeom-1+Q*Q)*energy
    return {'E':energy,'satstar':psum/den,'satfull':(psum+z)/den,
            'D':psum/(M*energy),'zero_frac':z/(psum+z) if psum+z>0 else None}


def check_tests(mu, plain, sq):
    # independent direct double-sum vs aggregated shift b_h
    checked=0;maxdiff=0.0
    for p in [101,103,107]:
        for X in [800,1600]:
            g=construction(X,p)
            for co in [plain,sq,mu]:
                b=build_b(g,co)
                bd=brute_b(X,p,co)
                vals=np.zeros(g['Ngeom'])
                for h,v in bd.items():
                    if not g['hmin']<=h<=g['hmax']:raise AssertionError('invalid h')
                    vals[h-g['hmin']]=v
                dif=float(np.max(np.abs(vals-b)))
                checked+=1;maxdiff=max(maxdiff,dif)
                assert dif<1e-9, (p,X,dif)
                assert 0 not in g['h']
    # FFT and finite Parseval, including negative h
    checked_fft=0;maxfft=0.0;maxparseval=0.0
    for p,X in [(101,800),(103,1600),(107,1200)]:
        g=construction(X,p);b=build_b(g,mu);H=np.arange(g['Ngeom'])+g['hmin']
        for q in [7,11,13,17]:
            packets=np.bincount(H%q,weights=b,minlength=q)
            ff=np.fft.fft(packets)
            direct=np.array([sum(v*np.exp(-2j*np.pi*a*h/q) for h,v in zip(H,b)) for a in range(q)])
            maxfft=max(maxfft,float(np.max(np.abs(ff-direct))))
            maxparseval=max(maxparseval,abs(float(sum(abs(ff)**2))-q*float(np.dot(packets,packets))))
            assert np.allclose(ff,direct,rtol=1e-9,atol=2e-9)
            assert np.allclose(sum(abs(ff)**2),q*np.dot(packets,packets),rtol=1e-9)
            checked_fft+=1
    # finite exact sign-flip expectation and off-diagonal identity for small b
    toy=np.array([0.2,-0.3,0.4,-0.5])
    h=np.array([-2,-1,0,1])
    Q=7;qs,aq,M=frequency_families(Q)
    s0=spectral(toy,-2,Q,qs,aq,M,4)
    conditional=[]
    for ss in itertools.product([-1,1],repeat=len(toy)):
        conditional.append(spectral(toy*np.array(ss),-2,Q,qs,aq,M,4)['satstar'])
    expected=M/(3+Q*Q)
    assert abs(np.mean(conditional)-expected)<1e-12
    K=lambda d:sum(np.exp(-2j*np.pi*a*d/q) for q in qs for a in aq[q])
    expansion=M*sum(abs(toy)**2)+sum(toy[i]*toy[j]*K(int(h[i]-h[j])) for i in range(4) for j in range(4) if i!=j)
    assert abs(expansion.imag)<1e-10
    assert abs(float(expansion.real)-s0['D']*M*sum(abs(toy)**2))<1e-9
    return dict(checked_b=checked,max_brute_diff=maxdiff,checked_fft=checked_fft,
                max_fft_diff=maxfft,max_parseval_diff=maxparseval,
                sign_flip_exhaustive=16,sign_flip_expectation=expected,
                offdiag_identity='PASS')


def mean(x):return sum(x)/len(x) if x else None

def percentiles(x):
    return {str(k):float(np.percentile(x,k)) for k in (5,50,95)}


def main():
    maxX=max(P_WINDOWS)*max(RATIOS);maxn=2*maxX+200
    mu=mobius_sieve(maxn)
    units=np.array([math.gcd(i,30)==1 for i in range(maxn+1)])
    mu=mu*units
    plain=units.astype(np.int8)
    sq=np.abs(mu)
    tests=check_tests(mu,plain,sq)
    # pre-generate replicate coefficient arrays; shared n-level draws across all p,X within each replicate
    randomco=[]
    for i in range(REPLICATES):
        rng=np.random.Generator(np.random.PCG64(SEED+i))
        eps=rng.integers(0,2,size=maxn+1,dtype=np.int8)*2-1
        randomco.append(sq*eps)
    prime_list=prime_sieve(2*max(P_WINDOWS)+10)
    allrows=[];groups=defaultdict(list); surrogate_groups=defaultdict(list)
    freqs_cache={}; tests['all_large_sieve']='PASS'; tests['max_full_sat']=0.0
    for P in P_WINDOWS:
        ps=[p for p in prime_list if P<p<=2*P and p%30 in RES]
        for ratio in RATIOS:
            X=P*ratio
            for p in ps:
                g=construction(X,p);Ng=g['Ngeom'];Q=choose_q(Ng)
                if Q not in freqs_cache:freqs_cache[Q]=frequency_families(Q)
                qs,aq,M=freqs_cache[Q]
                null=M/(Ng-1+Q*Q)
                for kind,co in [('plain',plain),('squarefree',sq),('inverse',mu)]:
                    b=build_b(g,co)
                    v=spectral(b,g['hmin'],Q,qs,aq,M,Ng)
                    if v['satfull'] is not None:
                        assert -1e-8<=v['satstar']<=v['satfull']+1e-8<=1+1e-8
                        tests['max_full_sat']=max(tests['max_full_sat'],v['satfull'])
                    ob={'P':P,'ratio':ratio,'X':X,'p':p,'kind':kind,'Ngeom':Ng,'Q':Q,'M':M,'lambda':Q*Q/Ng,
                        'null_sat':null,**v}
                    allrows.append(ob);groups[(P,ratio,kind)].append(ob)
                for j,co in enumerate(randomco):
                    b=build_b(g,co)
                    v=spectral(b,g['hmin'],Q,qs,aq,M,Ng)
                    surrogate_groups[(P,ratio,j)].append(v['D'])
    summaries=[]; repsum=[];comparisons=[]
    for P in P_WINDOWS:
        for ratio in RATIOS:
            for kind in ['plain','squarefree','inverse']:
                ar=groups[(P,ratio,kind)]
                active=[x for x in ar if x['D'] is not None]
                summaries.append({'P':P,'ratio':ratio,'kind':kind,'nprimes':len(ar),
                                  'zero_energy':len(ar)-len(active),'mean_D':mean([x['D'] for x in active]),
                                  'median_D':float(statistics.median([x['D'] for x in active])) if active else None,
                                  'mean_satstar':mean([x['satstar'] for x in active]),
                                  'mean_null_sat':mean([x['null_sat'] for x in active]),
                                  'mean_Ngeom':mean([x['Ngeom'] for x in ar]),
                                  'mean_Q':mean([x['Q'] for x in ar]),'mean_M':mean([x['M'] for x in ar]),
                                  'mean_lambda':mean([x['lambda'] for x in ar])})
            for j in range(REPLICATES):
                vals=[x for x in surrogate_groups[(P,ratio,j)] if x is not None]
                repsum.append({'P':P,'ratio':ratio,'replicate':j,'nprimes':len(vals),'mean_D':mean(vals)})
            inv=groups[(P,ratio,'inverse')];sqf=groups[(P,ratio,'squarefree')]
            dpaired=[x['D']-y['D'] for x,y in zip(inv,sqf) if x['D'] is not None and y['D'] is not None]
            invd=mean([x['D'] for x in inv if x['D'] is not None])
            surrogates=[x['mean_D'] for x in repsum if x['P']==P and x['ratio']==ratio]
            sur_mean=mean(surrogates)
            comparisons.append({'P':P,'ratio':ratio,'inverse_D':invd,'mean_surrogate_D':sur_mean,
                                'inverse_minus_surrogate':invd-sur_mean,
                                'relative_difference':invd/sur_mean-1 if sur_mean else None,
                                'surrogate_D_min':min(surrogates),'surrogate_D_max':max(surrogates),
                                'surrogate_D_p05':float(np.percentile(surrogates,5)),
                                'surrogate_D_p95':float(np.percentile(surrogates,95)),
                                'mean_paired_inverse_minus_squarefree':mean(dpaired)})
    iD={(r['P'],r['ratio']):r['mean_D'] for r in summaries if r['kind']=='inverse'}
    inv_direction='EXCESS' if all(v>1.10 for v in iD.values()) else ('DEFICIT' if all(v<0.90 for v in iD.values()) else 'NONE')
    sur_diff=[r['relative_difference'] for r in comparisons]
    surrogate_direction='EXCESS' if all(v>=0.10 for v in sur_diff) else ('DEFICIT' if all(v<=-0.10 for v in sur_diff) else 'NONE')
    verdict={'inverse_shift_sign_uniform_direction':inv_direction,
             'coefficient_null_uniform_direction':surrogate_direction,
             'claims':'finite exploratory diagnostics only; no RH, no power saving, no chi5 specificity'}
    obj={'protocol':{'P_WINDOWS':P_WINDOWS,'ratios':RATIOS,'replicates':REPLICATES,'seed':SEED,
                     'Q':'nearest integer >=7 coprime to 30 to sqrt(Ngeom), tie smaller',
                     'primary':'D=sum_nonzero_power/(M*shift_energy)','baseline':'E_signflip[D | b]=1',
                     'surrogates':'coefficient-level iid random Rademacher at squarefree n'},
         'tests':tests,'verdict':verdict,'summaries':summaries,'surrogate_replicates':repsum,
         'comparisons':comparisons,'n_prime_kind_rows':len(allrows)}
    with (OUT/'bridge_exp05_results.json').open('w') as f:json.dump(obj,f,indent=2)
    for name,rows in [('bridge_exp05_prime_rows.csv',allrows),('bridge_exp05_summaries.csv',summaries),
                      ('bridge_exp05_surrogate_means.csv',repsum),('bridge_exp05_comparisons.csv',comparisons)]:
        with (OUT/name).open('w',newline='') as f:
            w=csv.DictWriter(f,fieldnames=list(rows[0]));w.writeheader();w.writerows(rows)
    print('TESTS',json.dumps(tests,sort_keys=True))
    print('VERDICT',json.dumps(verdict,sort_keys=True))
    print('COMPARISONS',json.dumps(comparisons,indent=2))
    print('SUMMARY',json.dumps([{'P':r['P'],'ratio':r['ratio'],'kind':r['kind'],'D':r['mean_D'],'sat':r['mean_satstar']} for r in summaries],indent=2))
    print('FILES')
    for path in sorted(OUT.glob('bridge_exp05*')):
        if path.is_file():
            print(path.name,path.stat().st_size,hashlib.sha256(path.read_bytes()).hexdigest())

if __name__=='__main__':main()
