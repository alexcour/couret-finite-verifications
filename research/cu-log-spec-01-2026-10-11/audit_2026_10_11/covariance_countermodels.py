#!/usr/bin/env python3
"""No-go audit: same Dirichlet covariance, different energy-ratio laws.

Imports preexisting window_covariance_classical.py. No new prime sieve.
Gaussian and fixed-radius phase models have IDENTICAL means and covariances.
The fixed-radius model respects the translation action of U(210): uniform
angles on complex conjugate pairs, signs on seven quadratic real modes.
Neither is claimed to represent the true prime-race limiting law.
"""
import itertools
import json
import math
from pathlib import Path
import numpy as np
from window_covariance_classical import modes, result

ALPHA=1/3
SEED=21020261015
DRAWS=100000
Q=(15,21,35)
CHI5=(0,2,0)

def summarize(a):
    return {name:dict(mean=float(a[:,j].mean()),sd=float(a[:,j].std()),
                      min=float(a[:,j].min()),max=float(a[:,j].max()),
                      quantile_025=float(np.quantile(a[:,j],.025)),
                      quantile_975=float(np.quantile(a[:,j],.975)))
            for j,name in enumerate(('F15','F21','F35','Gchi5'))}

def projection_scores(squares, m):
    f=np.array([row[1] for row in m])
    den=squares.sum(axis=1)
    return np.column_stack([squares[:,q%f==0].sum(axis=1)/den for q in Q]
                           +[squares[:,[i for i,row in enumerate(m) if row[0]==CHI5][0]]/den])

def run():
    m=modes()
    assert len(m)==47
    v=np.array([row[4] for row in m])
    quadratic=np.array([row[5] for row in m],dtype=bool)
    assert quadratic.sum()==7 and np.all(v>0)
    bias=-(1-math.sqrt(ALPHA))*quadratic.astype(float)
    # Gaussian law in a real orthonormal Fourier basis.
    g=np.random.default_rng(SEED).standard_normal((DRAWS,47))*np.sqrt(v)+bias
    G=projection_scores(g*g,m)
    # Shell law: non-real conjugate pairs have constant squared radius
    # 2*v (uniform angle), each real quadratic mode has random sign.
    # Enumerate all 2**7 sign configurations (angles do not change energies).
    real=[i for i in range(47) if quadratic[i]]
    pairkeys={row[0]:i for i,row in enumerate(m)}
    for i,row in enumerate(m):
        k=row[0]
        kc=tuple((-x)%d for x,d in zip(k,(2,4,6)))
        assert kc in pairkeys
        assert abs(v[i]-v[pairkeys[kc]])<1e-12
    fixed=[]
    for signs in itertools.product((-1,1),repeat=7):
        z=v.copy()
        for sign,i in zip(signs,real):
            z[i]=(sign*math.sqrt(v[i])+bias[i])**2
        fixed.append(projection_scores(z[None,:],m)[0])
    F=np.array(fixed)
    assert F.shape==(128,4)
    # Zero bias: all fixed-shell energies are constants.
    F0=projection_scores(np.broadcast_to(v,(128,47)),m)
    assert np.max(np.ptp(F0,axis=0))<1e-14
    weights=result()['trace_fractions']
    for j,q in enumerate(Q):
        assert abs(F0[0,j]-weights[str(q)])<1e-14
    assert G[:,1].std()>0.04 and F[:,1].std()<0.02
    # Archived holdout only, no new prime computations.
    spec=json.loads((Path(__file__).resolve().parent.parent/'resultats_spec.json').read_text())
    a=spec['windows']['30000000']['counts30']
    contrast=sum(int(vv)*(1 if int(aa)%5 in (1,4) else -1) for aa,vv in a.items())
    assert contrast==-182
    norm2=float(spec['windows']['30000000']['spectral210']['norm2'])
    assert norm2==156804.0
    observed={str(q):spec['holdout']['posthoc_quotient_controls'][str(q)]['energy'] for q in Q}
    observed['Gchi5']=contrast**2/(48*norm2)
    assert abs(observed['Gchi5']-0.004400929398059574)<1e-14
    return {'label':'covariance identical; nonlinear laws differ',
            'modes':47,'real_quadratic_modes':7,'complex_pairs':20,
            'assumed_bias_quadratic_mode':float(-(1-math.sqrt(ALPHA))),
            'mean_and_covariance':'same analytically by construction; diagonal covariance Vchi in real Fourier basis',
            'seed':SEED,'gaussian_draws':DRAWS,'fixed_shell_configs':128,
            'trace_fractions':weights,'observed_10M_30M':observed,
            'gaussian':summarize(G),'phase_shell':summarize(F),
            'gate':'These are countermodels; neither supplies valid p-values or a certified law of prime counts.'}

if __name__=='__main__':
    print(json.dumps(run(),ensure_ascii=False,indent=2))
