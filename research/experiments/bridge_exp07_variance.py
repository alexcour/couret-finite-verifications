#!/usr/bin/env python3
"""COURET-OAI-BRIDGE-01 EXP-07: exact conditional sign-null variance audit.
No RH, asymptotic saving, or formal mathematical novelty claims.
Run alongside the canonical exp05 reference implementation.
"""
from pathlib import Path
import csv, hashlib, itertools, json, math, statistics
import numpy as np
import bridge_exp05_spectral_null as e5

OUT = Path(__file__).resolve().parent
P_WINDOWS = (100, 200, 400, 800, 1600, 3200)
RATIOS = (8, 16)
TOL = 1e-8

def integer_kernel(Q, N):
    """Construct integer K_Q(d), 0<=d<N, from Ramanujan divisor sums."""
    mu = e5.mobius_sieve(Q)
    kernel = np.zeros(N, dtype=np.int64)
    for q in range(2, Q+1):
        if math.gcd(q,30) != 1: continue
        for r in range(1,q+1):
            if q%r == 0:
                kernel[::r] += r*int(mu[q//r])
    return kernel

def exact_variance(b, ker):
    b = np.asarray(b, dtype=np.float64)
    E = float(np.dot(b,b)); M=int(ker[0]); N=len(b)
    if E <= 0 or M <= 0: return None
    pow2=b*b
    fftN=1<<(2*N-2).bit_length()
    fft=np.fft.rfft(pow2, n=fftN)
    corr=np.fft.irfft(fft*np.conj(fft), n=fftN)[:N]
    weighted=float(np.dot(np.asarray(ker[1:],float)**2,corr[1:]))
    V=4*max(0,weighted)/(M*M*E*E)
    maxk=float(np.max(np.abs(ker[1:]))) if N>1 else 0.0
    upper=2*(maxk/M)**2
    if V > upper+5e-9: raise AssertionError(('variance upper',V,upper))
    return {'variance':V,'sigma':math.sqrt(V),'var_upper':upper}

def direct_variance(b,ker):
    E=float(np.dot(b,b)); M=int(ker[0]); res=0.0
    for i in range(len(b)):
        for j in range(i+1,len(b)):
            res+=(b[i]*b[j]*int(ker[j-i]))**2
    return 4*res/(M*M*E*E)

def toy_exact_checks():
    checked_ram=0; max_kernel_err=0.0
    for Q in (7,11,13):
        kern=integer_kernel(Q, 41)
        qs,a_by_q,M=e5.frequency_families(Q)
        assert int(kern[0])==M
        for d in range(-40,41):
            k_direct=sum(np.exp(-2j*np.pi*a*d/q) for q in qs for a in a_by_q[q])
            error=abs(k_direct-int(kern[abs(d)]))
            max_kernel_err=max(max_kernel_err,error);checked_ram+=1
            assert error<1e-9,(Q,d,error)
    vectors=[np.array([1.0,-2.0,0.5,-1.5,0.25]),np.array([2.0,0,0,0,0.0]),np.array([1.0,1.0,1.0,-1.0,2.0])]
    checked_toy=0;max_var_err=0.0;max_mean_err=0.0
    for Q in (7,11,13):
        for b in vectors:
            ker=integer_kernel(Q,len(b));M=int(ker[0]);E=float(np.dot(b,b))
            v=exact_variance(b,ker)['variance']
            brute=direct_variance(b,ker)
            assert abs(v-brute)<1e-11
            vals=[]
            for flips in itertools.product([-1,1],repeat=len(b)):
                x=b*np.array(flips,float)
                S=sum(x[i]*x[j]*int(ker[abs(j-i)]) for i in range(len(b)) for j in range(len(b)))
                vals.append(S/(M*E))
            mean=sum(vals)/len(vals)
            var=sum((x-mean)**2 for x in vals)/len(vals)
            max_var_err=max(max_var_err,abs(var-v));max_mean_err=max(max_mean_err,abs(mean-1))
            assert abs(var-v)<1e-11 and abs(mean-1)<1e-11
            checked_toy+=1
    return {'ramanujan_checks':checked_ram,'ramanujan_max_error':max_kernel_err,
      'exhaustive_variance_cases':checked_toy,'exhaustive_variance_max_error':max_var_err,
      'exhaustive_mean_max_error':max_mean_err}

def group_summary(group):
    a=[x for x in group if x['Z'] is not None]
    return {'P':group[0]['P'],'ratio':group[0]['ratio'],'kind':group[0]['kind'],
      'panel':group[0]['panel'],'nprimes':len(group),
      'zero_energy':sum(x['D'] is None for x in group),
      'zero_variance':sum(x['sigma'] in (0,None) for x in group),
      'mean_D':statistics.mean(x['D'] for x in group if x['D'] is not None),
      'mean_sigma':statistics.mean(x['sigma'] for x in a) if a else None,
      'mean_abs_Z':statistics.mean(abs(x['Z']) for x in a) if a else None,
      'frac_abs_Z_ge_2':sum(abs(x['Z'])>=2 for x in a)/len(a) if a else None,
      'frac_abs_Z_ge_3':sum(abs(x['Z'])>=3 for x in a)/len(a) if a else None,
      'frac_positive_Z':sum(x['Z']>0 for x in a)/len(a) if a else None,
      'mean_lambda':statistics.mean(x['lambda'] for x in group)}

def main():
    tests=toy_exact_checks()
    maxX=max(P_WINDOWS)*max(RATIOS)
    mu=e5.mobius_sieve(2*maxX+200)
    units=np.array([math.gcd(i,30)==1 for i in range(len(mu))])
    mu=mu*units; sq=np.abs(mu); plain=units.astype(np.int8)
    allps=e5.prime_sieve(2*max(P_WINDOWS)+20)
    cached={}; rows=[]; maxFFTerror=0.0; maxSat=0.0; fft_checks=0
    for P in P_WINDOWS:
        primes=[p for p in allps if P<p<=2*P and p%30 in e5.RES]
        for ratio in RATIOS:
            X=P*ratio
            for p in primes:
                g=e5.construction(X,p);N=g['Ngeom'];Q=e5.choose_q(N)
                if (Q,N) not in cached:
                    ker=integer_kernel(Q,N)
                    qs,aa,M=e5.frequency_families(Q)
                    assert int(ker[0])==M
                    cached[(Q,N)]=(ker,qs,aa,M)
                ker,qs,aa,M=cached[(Q,N)]
                for kind,co in [('plain',plain),('squarefree',sq),('inverse',mu)]:
                    b=e5.build_b(g,co)
                    spectral=e5.spectral(b,g['hmin'],Q,qs,aa,M,N)
                    V=exact_variance(b,ker)
                    if spectral['E']<=0: raise AssertionError('unexpected zero energy')
                    D=spectral['D'];sigma=V['sigma'];Z=(D-1)/sigma if sigma>0 else None
                    if fft_checks<36:
                        # exact quadratic identity versus FFT for a sampling fixed by loop order
                        matrixval=float(M*np.dot(b,b)+2*sum(int(ker[d])*float(np.dot(b[:-d],b[d:])) for d in range(1,N)))
                        directD=matrixval/(M*float(np.dot(b,b)))
                        err=abs(D-directD)
                        maxFFTerror=max(maxFFTerror,err)
                        assert math.isclose(D,directD,rel_tol=1e-9,abs_tol=1e-9)
                        fft_checks+=1
                    assert 0 not in g['h']
                    assert 0<=spectral['satstar']<=spectral['satfull']+TOL<=1+TOL
                    maxSat=max(maxSat,spectral['satfull'])
                    rows.append({'panel':'EXP05_retro' if P<=800 else 'scale_extension',
                      'P':P,'ratio':ratio,'X':X,'p':p,'kind':kind,'Ngeom':N,'Q':Q,'M':M,
                      'lambda':Q*Q/N,'E':spectral['E'],'D':D,'satstar':spectral['satstar'],
                      'sigma':sigma,'variance':V['variance'],'var_upper':V['var_upper'],'Z':Z})
            print(f'completed P={P} ratio={ratio}, primes={len(primes)}',flush=True)
    tests.update({'fft_vs_kernel_checks':fft_checks,'max_abs_D_discrepancy':maxFFTerror,
                  'max_full_saturation':maxSat,'all_large_sieve_valid':True,
                  'total_prime_rows':len(rows)})
    summary=[]
    for P in P_WINDOWS:
        for ratio in RATIOS:
            for kind in ('plain','squarefree','inverse'):
                summary.append(group_summary([x for x in rows if x['P']==P and x['ratio']==ratio and x['kind']==kind]))
    inv=[x for x in summary if x['kind']=='inverse' and x['P']<=800]
    verdict='UNIFORM_LARGE_STANDARDIZED_DEVIATION' if all(x['mean_abs_Z']>2 for x in inv) else 'NO_UNIFORM_LARGE_STANDARDIZED_DEVIATION'
    result={'protocol':{'P_WINDOWS':P_WINDOWS,'RATIOS':RATIOS,'retrospective_original':[100,200,400,800],
      'scale_extension':[1600,3200],'Q':'nearest >=7 coprime 30 to sqrt(Ngeom)',
      'variance':'4/(M^2 E^2) sum_(h<k) b_h^2 b_k^2 K_Q(k-h)^2'},
      'tests':tests,'verdict':verdict,'summary':summary}
    def write_csv(path,items):
        with path.open('w',newline='') as f:
            w=csv.DictWriter(f,fieldnames=list(items[0].keys()));w.writeheader();w.writerows(items)
    write_csv(OUT/'exp07_prime_rows.csv',rows)
    write_csv(OUT/'exp07_summary.csv',summary)
    with (OUT/'exp07_results.json').open('w') as f:json.dump(result,f,indent=2)
    print('VERDICT',verdict)
    print('TESTS',json.dumps(tests,sort_keys=True))
    print('INVERSE',json.dumps([x for x in summary if x['kind']=='inverse'],indent=2))
    for file in [OUT/'bridge_exp07_variance.py',OUT/'exp07_results.json',OUT/'exp07_prime_rows.csv',OUT/'exp07_summary.csv']:
        print('SHA',file.name,hashlib.sha256(file.read_bytes()).hexdigest())

if __name__=='__main__':main()
