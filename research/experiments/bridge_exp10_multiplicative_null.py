#!/usr/bin/env python3
"""EXP-10: frozen random multiplicative vs coefficient-iid nulls.
Only standard Python and NumPy; no RH, new theorem or inferential claims.
"""
from __future__ import annotations
import csv, json, math, hashlib, statistics
from collections import defaultdict
from pathlib import Path
import numpy as np

ROOT = Path(__file__).resolve().parent
PS = (100,200,400,800)
RATIOS = (8,16,32)
NREP = 16
SEED = 20261009
U30 = {1,7,11,13,17,19,23,29}

def sieve(nmax):
    lp=np.zeros(nmax+1,dtype=np.int32)
    mu=np.zeros(nmax+1,dtype=np.int8)
    mu[1]=1
    primes=[]
    for n in range(2,nmax+1):
        if lp[n]==0:
            lp[n]=n;primes.append(n);mu[n]=-1
        for p in primes:
            t=n*p
            if t>nmax or p>lp[n]:break
            lp[t]=p
            mu[t]=0 if p==lp[n] else -mu[n]
    return mu, lp, primes

def tweight(v,X):
    return 2*min(v-X,2*X-v) if X<v<2*X else 0

def geom(p,X):
    hh=[];mm=[];nn=[];ww=[]
    for m in range(max(1,X//p-2),2*X//p+3):
        if m%30 not in U30:continue
        wm=tweight(p*m,X)
        if wm<=0:continue
        n0=X+1+((p*m-(X+1))%30)
        for n in range(n0,2*X,30):
            if n==p*m:continue
            wn=tweight(n,X)
            if wn<=0:continue
            hh.append((n-p*m)//30); mm.append(m);nn.append(n);ww.append(wm*wn/(X*X))
    if not hh: raise AssertionError('empty geometry')
    h=np.array(hh,dtype=np.int32)
    a=int(h.min());b=int(h.max());N=b-a+1
    return {'h':h,'m':np.array(mm,dtype=np.int32),'n':np.array(nn,dtype=np.int32),
            'w':np.array(ww,dtype=float),'hmin':a,'N':N,'H':np.arange(a,b+1,dtype=np.int32)}

def make_b(g,coeff):
    w=g['w']*coeff[g['m']].astype(float)*coeff[g['n']].astype(float)
    return np.bincount(g['h']-g['hmin'],weights=w,minlength=g['N']).astype(float)

def select_q(N):
    t=math.sqrt(N)
    opts=(q for q in range(7,max(12,math.ceil(t)+8)) if math.gcd(q,30)==1)
    return min(opts,key=lambda q:(abs(q-t),q))

def family(Q):
    ff={q:np.array([a for a in range(1,q) if math.gcd(a,q)==1],dtype=int)
        for q in range(2,Q+1) if math.gcd(q,30)==1}
    return ff,sum(len(a) for a in ff.values())

def eval_spectral(b,g,Q,ff,M):
    E=float(b@b)
    if E<=0: return {'D':None,'satstar':None,'satfull':None,'E':0.0}
    pow_=0.
    for q,aa in ff.items():
        packet=np.bincount(g['H']%q,weights=b,minlength=q)
        ft=np.fft.fft(packet)
        pow_+=float(np.sum(np.abs(ft[aa])**2))
    zer=float(b.sum()**2)
    denom=(g['N']-1+Q*Q)*E
    ds=pow_/(M*E)
    sat=pow_/denom;full=(pow_+zer)/denom
    assert -1e-9<=sat<=full+1e-9<=1+1e-8,(sat,full,Q)
    return {'D':ds,'satstar':sat,'satfull':full,'E':E}

def slow_mu(n):
    k=0
    if n==1:return 1
    for p in range(2,math.isqrt(n)+1):
        if n%p==0:
            n//=p;k+=1
            if n%p==0:return 0
    if n>1:k+=1
    return -1 if k%2 else 1

def chi3(n):return 0 if n%3==0 else (1 if n%3==1 else -1)
def chi5(n):return 0 if n%5==0 else (1 if n%5 in (1,4) else -1)

def chi15(n):return chi3(n)*chi5(n)

def brute(p,X,coef):
    d=defaultdict(int)
    for m in range(1,2*X//p+3):
        if m%30 not in U30:continue
        wm=tweight(p*m,X)
        if not wm:continue
        for n in range(X+1,2*X):
            if (n-p*m)%30 or n==p*m:continue
            d[(n-p*m)//30]+=int(coef[m])*int(coef[n])*wm*tweight(n,X)
    return {h:v for h,v in d.items() if v}

def exact_from_geom(g,p,X,co):
    d=defaultdict(int)
    for h,m,n in zip(g['h'],g['m'],g['n']):
        d[int(h)]+=int(co[int(n)])*int(co[int(m)])*tweight(p*int(m),X)*tweight(int(n),X)
    return {h:v for h,v in d.items() if v}

def checks(mu,lp,units,prime_values):
    assert all(slow_mu(n)==int(mu[n]) for n in range(1,301))
    assert all(abs(tweight(n,X)/X-max(0.,1.-2*abs(n/X-1.5)))<1e-12
               for X in (100,500,800) for n in (X, X+1,5*X//4,3*X//2,2*X-1,2*X))
    freqs={}
    tests={'mobius_300':300,'brute_pairs':0,'character_phase_cases':0,'FFT_direct_cases':0,'Ramanujan_cases':0,'max_direct_error':0.,'max_ramanujan_error':0.}
    base=mu*units
    for p in (101,103,107,109):
        for X in (800,1600,3200,6400,12800,25600):
            if 2*X>=len(mu):continue
            g=geom(p,X)
            got=exact_from_geom(g,p,X,base)
            expect=brute(p,X,base)
            assert got==expect,(p,X)
            tests['brute_pairs']+=1
    for p in (101,103,107):
        for X in (800,1600,3200):
            g=geom(p,X);baseB=exact_from_geom(g,p,X,base)
            for char in (chi3,chi5,chi15):
                twist=np.array([int(mu[n])*char(n) if units[n] else 0 for n in range(len(mu))],dtype=np.int8)
                tw=exact_from_geom(g,p,X,twist)
                assert all(tw.get(h,0)==char(p)*val for h,val in baseB.items())
                assert set(tw)==set(baseB)
                tests['character_phase_cases']+=1
    for p,X in [(101,800),(103,1600),(107,3200),(109,6400)]:
        g=geom(p,X);b=make_b(g,base)
        Q=select_q(g['N']);ff,M=family(Q)
        ev=eval_spectral(b,g,Q,ff,M);pow1=ev['D']*M*ev['E']
        pow2=0.
        for q,aa in ff.items():
            for a in aa:
                s=np.dot(b,np.exp(-2j*np.pi*a*g['H']/q))
                pow2+=float(abs(s)**2)
        error=abs(pow1-pow2)/max(1,abs(pow1),abs(pow2))
        assert error<2e-9,(p,X,error)
        tests['FFT_direct_cases']+=1
        tests['max_direct_error']=max(tests['max_direct_error'],error)
        for q,aa in ff.items():
            def c(d):return sum(r*slow_mu(q//r) for r in range(1,q+1) if q%r==0 and d%r==0)
            packet=np.bincount(g['H']%q,weights=b,minlength=q)
            ft=np.fft.fft(packet)
            lhs=float(np.sum(np.abs(ft[aa])**2))
            kern=0.
            for i in range(len(b)):
                if not b[i]: continue
                for j in range(len(b)):
                    if b[j]:kern+=b[i]*b[j]*c(i-j)
            err=abs(lhs-kern)/max(1,abs(lhs),abs(kern))
            assert err<1e-9,(q,err)
            tests['Ramanujan_cases']+=1
            tests['max_ramanujan_error']=max(tests['max_ramanujan_error'],err)
    # multiplicativity on coprime arguments for a fixed random prime assignment
    rng=np.random.Generator(np.random.PCG64(SEED+1000))
    ep=np.ones(len(mu),dtype=np.int8)
    for p in prime_values:ep[p]=2*int(rng.integers(0,2))-1
    ff=np.zeros(len(mu),dtype=np.int8);ff[1]=1
    for n in range(2,len(mu)):
        if mu[n]!=0:ff[n]=int(ff[n//int(lp[n])])*int(ep[int(lp[n])])
    tests['mult_coprime_cases']=0
    for a in range(1,100):
        for b in range(1,100):
            if math.gcd(a,b)==1:
                assert ff[a*b]==ff[a]*ff[b]
                tests['mult_coprime_cases']+=1
    assert np.all(np.abs(ff)==np.abs(mu))
    return tests

def moments(vals):
    return float(statistics.mean(vals)) if vals else None

def main():
    maxX=max(PS)*max(RATIOS);nmax=2*maxX+64
    mu,lp,primes=sieve(nmax)
    units=np.array([n%30 in U30 for n in range(nmax+1)],dtype=np.int8)
    base=mu*units;sq=np.abs(base);plain=units.copy()
    tests=checks(mu,lp,units,primes)
    coefficient_sets={}
    for fam in ('mult','iid'):
        arrays=[]
        for r in range(NREP):
            rng=np.random.Generator(np.random.PCG64(SEED + 1000*(1 if fam=='mult' else 2)+r))
            if fam=='iid':
                ep=rng.integers(0,2,size=nmax+1,dtype=np.int8)*2-1
                a=sq*ep
            else:
                ep=np.ones(nmax+1,dtype=np.int8)
                vals=rng.integers(0,2,size=len(primes),dtype=np.int8)*2-1
                for p,v in zip(primes,vals):ep[p]=v
                a=np.zeros(nmax+1,dtype=np.int8);a[1]=1
                for n in range(2,nmax+1):
                    if mu[n]:a[n]=a[n//int(lp[n])]*ep[int(lp[n])]
                a*=units
            assert np.array_equal(np.abs(a),sq)
            arrays.append(a)
        assert any(np.any(arrays[i]!=arrays[i+1]) for i in range(NREP-1))
        coefficient_sets[fam]=arrays
    rows=[];surr=[];zero_energy=0;max_sat=0.;groups=defaultdict(list);rep_groups=defaultdict(list)
    freq_cache={}
    for P in PS:
        ps=[p for p in primes if P<p<=2*P and p%30 in U30]
        for ratio in RATIOS:
            X=P*ratio
            for p in ps:
                g=geom(p,X);Q=select_q(g['N'])
                if Q not in freq_cache:freq_cache[Q]=family(Q)
                ff,M=freq_cache[Q]
                for kind,arr in [('mobius',base),('squarefree',sq),('plain',plain)]:
                    ev=eval_spectral(make_b(g,arr),g,Q,ff,M)
                    if ev['D'] is None:zero_energy+=1
                    else:max_sat=max(max_sat,ev['satfull'])
                    row={'P':P,'ratio':ratio,'X':X,'p':p,'Q':Q,'M':M,'Ngeom':g['N'],'kind':kind,**ev}
                    rows.append(row);groups[(P,ratio,kind)].append(row)
                for fam,arrs in coefficient_sets.items():
                    for r,arr in enumerate(arrs):
                        ev=eval_spectral(make_b(g,arr),g,Q,ff,M)
                        if ev['D'] is None:zero_energy+=1
                        else:max_sat=max(max_sat,ev['satfull'])
                        rep_groups[(P,ratio,fam,r)].append(ev['D'])
    summaries=[];rep_means=[]
    for P in PS:
        for ratio in RATIOS:
            for kind in ('mobius','squarefree','plain'):
                z=groups[(P,ratio,kind)]
                ds=[x['D'] for x in z if x['D'] is not None]
                summaries.append({'P':P,'ratio':ratio,'kind':kind,'nprimes':len(z),'zero_energy':len(z)-len(ds),
                                  'mean_D':moments(ds),'median_D':float(statistics.median(ds)) if ds else None})
            for fam in ('mult','iid'):
                vals=[]
                for r in range(NREP):
                    q=rep_groups[(P,ratio,fam,r)]
                    z=[x for x in q if x is not None]
                    m=moments(z)
                    rep_means.append({'P':P,'ratio':ratio,'family':fam,'replicate':r,'nprimes':len(q),'zero_energy':len(q)-len(z),'mean_D':m})
                    if m is not None:vals.append(m)
                act=next(x['mean_D'] for x in summaries if x['P']==P and x['ratio']==ratio and x['kind']=='mobius')
                summaries.append({'P':P,'ratio':ratio,'kind':fam+'_replicate_means','nprimes':len(groups[(P,ratio,'mobius')]),'zero_energy':None,
                                  'mean_D':moments(vals),'median_D':float(statistics.median(vals)) if vals else None,
                                  'min_rep_mean_D':min(vals) if vals else None,'max_rep_mean_D':max(vals) if vals else None,
                                  'mobius_minus_rep_mean':act-moments(vals) if vals else None,
                                  'mobius_over_rep_mean_minus_one':act/moments(vals)-1 if vals and moments(vals) else None})
    gaps=[]
    for P in PS:
        ratio=32
        a=next(x for x in summaries if x['P']==P and x['ratio']==ratio and x['kind']=='mobius')
        b=next(x for x in summaries if x['P']==P and x['ratio']==ratio and x['kind']=='mult_replicate_means')
        outside=(a['mean_D']<b['min_rep_mean_D'] or a['mean_D']>b['max_rep_mean_D'])
        delta=b['mobius_over_rep_mean_minus_one']
        gaps.append({'P':P,'ratio':ratio,'mobius':a['mean_D'],'mult_mean':b['mean_D'],'mult_min':b['min_rep_mean_D'],
                     'mult_max':b['max_rep_mean_D'],'relative_gap':delta,'outside_range':outside})
    signs=[int(math.copysign(1,x['relative_gap'])) for x in gaps]
    robust=(all(x['outside_range'] and abs(x['relative_gap'])>=.10 for x in gaps) and len(set(signs))==1)
    res={'provenance':{'protocol_commit':'626414361b0c19dd784c226971caf576c99c5ad6',
                       'P':PS,'ratios':RATIOS,'replicates':NREP,'seed':SEED,
                       'status':'retrospective prior P/ratio 8,16; exploratory ratio 32; finite only'},
         'checks':tests,'number_actual_rows':len(rows),'number_replicate_regime_rows':len(rep_means),
         'zero_energy_all':zero_energy,'max_sat_full':max_sat,'screen_verdict':'ROBUST_MULTIPLICATIVE_DEVIATION' if robust else 'NO_ROBUST_MULTIPLICATIVE_DEVIATION',
         'ratio32_gaps':gaps,'summary':summaries,'replicate_regime_means':rep_means}
    (ROOT/'EXP10_results.json').write_text(json.dumps(res,indent=2,ensure_ascii=False)+'\n',encoding='utf-8')
    for name,arr in [('EXP10_actual_prime_rows.csv',rows),('EXP10_regime_summaries.csv',summaries),('EXP10_replicate_means.csv',rep_means)]:
        keys=list(dict.fromkeys(k for z in arr for k in z))
        with (ROOT/name).open('w',newline='',encoding='utf-8') as f:
            writer=csv.DictWriter(f,fieldnames=keys);writer.writeheader();writer.writerows(arr)
    print('EXACT_CHECKS',json.dumps(tests,sort_keys=True))
    print('SUMMARY',json.dumps({'n_actual':len(rows),'n_rep':len(rep_means),'zero':zero_energy,'max_sat':max_sat,'verdict':res['screen_verdict']}))
    print('NEW_RATIO32_GAPS',json.dumps(gaps,indent=2))
    print('ALL_SUMMARIES',json.dumps(summaries))
    for fn in ('bridge_exp10_multiplicative_null.py','EXP10_results.json','EXP10_actual_prime_rows.csv','EXP10_regime_summaries.csv','EXP10_replicate_means.csv'):
        p=ROOT/fn;print('SHA256',fn,hashlib.sha256(p.read_bytes()).hexdigest())

if __name__=='__main__':main()
