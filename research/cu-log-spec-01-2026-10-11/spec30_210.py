#!/usr/bin/env python3
"""CU-LOG-SPEC-01: exact group combinatorics, finite prime counts and permutations.

Reproduce: python spec30_210.py --limit 30000000 --out resultats_spec.json
Prerequisite: numpy >=1.24, Python >=3.10. All constants M(30,a) are
from the PRIOR CU-LOG-30 experiment; they are *not* recomputed here.

Epistemic warning: permutation label randomization is a descriptive
benchmark, not a probability model of primes nor evidence of a new theorem.
"""
from __future__ import annotations
import argparse
from collections import Counter
from fractions import Fraction
import hashlib
import itertools
import json
import math
from pathlib import Path
import platform
import numpy as np

UNITS30 = tuple(a for a in range(1, 30) if math.gcd(a,30) == 1)
UNITS210 = tuple(a for a in range(1, 210) if math.gcd(a,210) == 1)
EXPLORATION_CUTOFFS = (10_000, 100_000, 1_000_000, 10_000_000)
VALIDATION_CUTOFF = 30_000_000
SEED = 21020261011
NUM_PERMUTATIONS = 20_000
THRESHOLD = .05


def primes_sieve(limit: int):
    """Erathosthenes sieve; output independently checked by trial division."""
    flags = bytearray(b'\x01') * (limit + 1)
    flags[:2] = b'\x00\x00'
    for p in range(2, math.isqrt(limit) + 1):
        if flags[p]:
            flags[p*p:limit+1:p] = b'\x00' * ((limit - p*p)//p + 1)
    return (p for p in range(2, limit+1) if flags[p])


def is_prime_naive(n: int) -> bool:
    return n >= 2 and all(n % d for d in range(2,math.isqrt(n)+1))


def cumulative_counts(cutoffs: tuple[int,...]) -> dict[int, dict[int, np.ndarray]]:
    """Counts all prime residue classes at each cutoff, without skipping windows."""
    assert sorted(set(cutoffs)) == list(cutoffs)
    map30 = {a:i for i,a in enumerate(UNITS30)}
    map210 = {a:i for i,a in enumerate(UNITS210)}
    c30 = np.zeros(8, dtype=np.int64)
    c210 = np.zeros(48, dtype=np.int64)
    snapshot = {}
    idx = 0
    for p in primes_sieve(max(cutoffs)):
        while idx < len(cutoffs) and p > cutoffs[idx]:
            snapshot[cutoffs[idx]] = {30:c30.copy(),210:c210.copy()}
            idx += 1
        if idx == len(cutoffs):
            break
        k30=map30.get(p%30)
        if k30 is not None:
            c30[k30]+=1
        k210=map210.get(p%210)
        if k210 is not None:
            c210[k210]+=1
    while idx < len(cutoffs):
        snapshot[cutoffs[idx]] = {30:c30.copy(),210:c210.copy()}
        idx += 1
    return snapshot


def adjacency_sym(q: int, gens=(11,29)) -> np.ndarray:
    """I+symmetrized right-translation matrices; real symmetric."""
    u=UNITS30 if q==30 else UNITS210
    assert q in (30,210)
    idx={a:i for i,a in enumerate(u)}
    A=np.eye(len(u))
    for g in gens:
        assert math.gcd(g,q)==1
        P=np.zeros_like(A)
        for i,a in enumerate(u):
            P[i,idx[(a*g)%q]]=1
        A+=(P+P.T)/2
    return A


def transfer_matrices() -> tuple[np.ndarray,np.ndarray,np.ndarray,np.ndarray]:
    """L: lift 8->48; P30: fiber-constant projection; P0: global mean."""
    index30={a:i for i,a in enumerate(UNITS30)}
    L=np.zeros((48,8),dtype=float)
    for i,a in enumerate(UNITS210):
        L[i,index30[a%30]]=1
    return L, L.T/6, L@L.T/6, np.ones((48,48))/48


def spectral_projectors30(A: np.ndarray) -> dict[int,np.ndarray]:
    """Lagrange polynomials in A on the entire 8d vector space."""
    I=np.eye(8)
    J=np.ones((8,8))/8
    return {
        3: (A-I)@(A+I)/8-J,    # 1d after removing constant vector
        1: (3*I-A)@(A+I)/4,   # 4d
        -1:(A-3*I)@(A-I)/8   # 2d
    }


def centered(x: np.ndarray) -> np.ndarray:
    return np.asarray(x,dtype=float)-np.mean(x)


def energies30(x: np.ndarray, A: np.ndarray, projections: dict[int,np.ndarray]):
    x=centered(x)
    d=float(x@x)
    assert d>0
    e={str(k):float(x@P@x/d) for k,P in projections.items()}
    return {'energy':e, 'rayleigh':float(x@A@x/d),'norm2':d}


def exhaustive_label_controls30(x: np.ndarray, A: np.ndarray,
                               P: dict[int,np.ndarray]) -> dict:
    """All 8! permutations as finite label diagnostics, not a statistical null."""
    v=centered(x)
    z=v[np.array(list(itertools.permutations(range(8))),dtype=np.int8)]
    d=float(v@v)
    obs=energies30(v,A,P)
    samples={str(k):np.einsum('bi,ij,bj->b',z,Pr,z)/d for k,Pr in P.items()}
    samples['rayleigh']=np.einsum('bi,ij,bj->b',z,A,z)/d
    scores={}
    for k,arr in samples.items():
        target=obs['rayleigh'] if k=='rayleigh' else obs['energy'][k]
        # Include numerical ties to tolerance; exact data labels are unique.
        scores[k]={
            'observed':target,
            'tail_ge_count':int(np.count_nonzero(arr>=target-1e-13)),
            'tail_ge_fraction':float(np.mean(arr>=target-1e-13)),
            'reference_mean':float(np.mean(arr)),
            'min':float(np.min(arr)),
            'max':float(np.max(arr))
        }
    return {'permutations_exhaustive':int(len(z)), 'scores':scores,
            'interpretation':'label permutation diagnostics only; no stochastic inference about arithmetic.'}


def spectral_character_mod5():
    """χ5(a)=(a|5), lifted to residues in U(30)."""
    return np.array([1 if a%5 in (1,4) else -1 for a in UNITS30],dtype=float)


def energy_210(z: np.ndarray, P30: np.ndarray, P0: np.ndarray,
               A210: np.ndarray) -> dict:
    y=centered(z)
    d=float(y@y)
    if d==0: raise ValueError('Zero deviation vector')
    coarse=float(y@(P30-P0)@y/d)
    return {'coarse_energy':coarse,'fine_energy':1-coarse,
            'A210_rayleigh':float(y@A210@y/d), 'norm2':d}


def label_monte_carlo_210(z: np.ndarray, L: np.ndarray,
                          samples=NUM_PERMUTATIONS,seed=SEED) -> dict:
    """Shuffles labels independently per Monte-Carlo row (avoid shared shuffles!)."""
    y=centered(z)
    n=len(y)
    d=float(y@y)
    actual=float(np.sum((L.T@y)**2)/6/d)
    rng=np.random.default_rng(seed)
    positions=np.argsort(rng.random((samples,n)),axis=1)
    shuffled=y[positions]
    projected_sums=shuffled@L
    values=np.sum(projected_sums**2,axis=1)/(6*d)
    count=int(np.count_nonzero(values<=actual+1e-13))
    fraction=count/samples
    se=(fraction*(1-fraction)/samples)**.5
    return {'random_seed':seed,'permutations':samples,
            'le_count':count,'fraction_le':fraction,'mc_standard_error_nominal':se,
            'mean':float(np.mean(values)),'expected_mean_exact':'7/47',
            'interpretation':'not a p-value: primes deterministic and residue labels nonexchangeable under a justified arithmetic law'}



def posthoc_quotient_controls(z: np.ndarray, moduli=(3,5,7,15,21,35,30,42,70)) -> dict:
    """Post hoc NEGATIVE controls, NOT part of frozen hypothesis protocol.

    Projection onto the functions constant on U(210) fibers modulo q.
    The reference fraction (phi(q)-1)/47 is merely a random-label mean.
    """
    y=centered(z)
    denom=float(y@y)
    out={}
    for q in moduli:
        groups={int(a%q) for a in UNITS210}
        fiber=48//len(groups)
        assert fiber*len(groups)==48
        val=sum(sum(y[i] for i,a in enumerate(UNITS210) if a%q==r)**2
                for r in groups)/(fiber*denom)
        ref=(len(groups)-1)/47
        out[str(q)]={'rank':len(groups)-1,'energy':float(val),
                      'random_label_mean':ref,'energy_over_random_label_mean':float(val/ref)}
    return out


def checks(q30: dict[int,np.ndarray],q210:dict[int,np.ndarray],
           ref:dict, A30:np.ndarray,A210:np.ndarray,L:np.ndarray):
    # Algebraic check: exact because matrices have integer/half-integer entries.
    assert np.array_equal(A210@L,L@A30)
    for cut in EXPLORATION_CUTOFFS:
        reference=np.array([ref['finite_cumulative_counts_30'][str(cut)][str(a)] for a in UNITS30], dtype=np.int64)
        assert np.array_equal(q30[cut],reference),f'Legacy finite count disagrees at {cut}'
    for cut in q30:
        reduced=L.T@q210[cut]
        # p=7 is a U30 prime but nonunit mod 210
        correction=np.array([int(a==7) for a in UNITS30])
        assert np.array_equal(reduced.astype(int)+correction,q30[cut])
    assert np.array_equal(np.array(list(primes_sieve(5000))),
                          np.array([k for k in range(5001) if is_prime_naive(k)]))


def run(limit:int=VALIDATION_CUTOFF)->dict:
    if limit!=VALIDATION_CUTOFF:
        raise ValueError('Frozen horizon: --limit must be exactly 30000000')
    src=Path(__file__).with_name('M30_reference.json')
    ref=json.loads(src.read_text(encoding='utf8'))
    assert tuple(ref['units'])==UNITS30
    M=np.array([float(ref['M30'][str(a)]) for a in UNITS30])
    A30=adjacency_sym(30)
    A210=adjacency_sym(210)
    P=spectral_projectors30(A30)
    L,aver,P30,P0=transfer_matrices()
    x=centered(M)
    assert np.allclose(sum(P.values()),np.eye(8)-np.ones((8,8))/8,atol=1e-13)
    for eig,Pr in P.items():
        assert np.allclose(Pr@Pr,Pr,atol=1e-13)
        assert np.allclose(A30@Pr,eig*Pr,atol=1e-13)
    chi5=spectral_character_mod5()
    assert np.allclose(P[3],np.outer(chi5,chi5)/8,atol=1e-13)
    assert np.array_equal(A210@L,L@A30)
    spectrum30={str(v):int(np.count_nonzero(np.isclose(np.linalg.eigvalsh(A30),v,atol=1e-9))) for v in [-1,1,3]}
    spectrum210={str(float(v)):int(np.count_nonzero(np.isclose(np.linalg.eigvalsh(A210),v,atol=1e-9))) for v in [-1,-.5,.5,1,1.5,2.5,3]}
    cutoffs=tuple(EXPLORATION_CUTOFFS)+(VALIDATION_CUTOFF,)
    cumulative=cumulative_counts(cutoffs)
    q30={t:cumulative[t][30] for t in cutoffs}
    q210={t:cumulative[t][210] for t in cutoffs}
    checks(q30,q210,ref,A30,A210,L)
    labels={}
    last30=np.zeros(8,dtype=np.int64)
    last210=np.zeros(48,dtype=np.int64)
    for cut in cutoffs:
        block30=q30[cut]-last30
        block210=q210[cut]-last210
        assert sum(block30)-sum(block210)==(1 if cut==10_000 else 0)
        z30=centered(block30)
        labels[str(cut)]={
            'window_open':int(cutoffs[cutoffs.index(cut)-1]) if cut!=cutoffs[0] else 0,
            'window_closed':int(cut),
            'first_primes_in_units30':int(sum(block30)),
            'first_primes_in_units210':int(sum(block210)),
            'spectral30':energies30(block30,A30,P),
            'spectral210':energy_210(block210,P30,P0,A210),
            'cosine_30_counts_vs_M':float(z30@x/math.sqrt((z30@z30)*(x@x))),
            'counts30':{str(a):int(v) for a,v in zip(UNITS30,block30)},
            'counts210':{str(a):int(v) for a,v in zip(UNITS210,block210)}
        }
        last30=q30[cut]
        last210=q210[cut]
    last_block210=q210[VALIDATION_CUTOFF]-q210[10_000_000]
    mc=label_monte_carlo_210(last_block210,L)
    E=labels[str(VALIDATION_CUTOFF)]['spectral210']['coarse_energy']
    return {
        'id':'CU-LOG-SPEC-01', 'date':'2026-10-11',
        'protocol_file':'PROTOCOLE_GELE.md',
        'protocol_sha256':hashlib.sha256(Path(__file__).with_name('PROTOCOLE_GELE.md').read_bytes()).hexdigest(),
        'legacy_reference_sha256':ref['source_sha256'],
        'environment':{'python':platform.python_version(),'numpy':np.__version__},
        'definitions':{'A30':'I + R11 + R29 over U(30), both generators involutions',
            'A210':'I + (R11+R11^-1)/2 + (R29+R29^-1)/2 over U(210)',
            'E30':'orthogonal energy of centered 210-count vector in 7d subspace lifted from U(30)',
            'M30':'preexisting Mertens constants M(30,a) from CU-LOG-30'},
        'spectrum30_full':spectrum30,
        'spectrum30_centered':{'3':1,'1':4,'-1':2},
        'spectrum210_full':spectrum210,
        'character5_vector_on_units30':{str(a):int(v) for a,v in zip(UNITS30,chi5)},
        'spectral_M30':energies30(M,A30,P),
        'quadratic_character_contrast':float(chi5@M),
        'spectral_E3_identity_from_character5':float((chi5@M)**2/(8*(x@x))),
        'exhaustive_30_label_checks':exhaustive_label_controls30(M,A30,P),
        'windows':labels,
        'holdout':{'window':'(10000000,30000000]',
            'predefined_threshold':THRESHOLD,
            'coarse_fraction':E,
            'passes_predefined_threshold':bool(E<THRESHOLD),
            'mean_reference_under_label_permutation':'7/47',
            'monte_carlo_label_control':mc,
            'posthoc_quotient_controls':posthoc_quotient_controls(last_block210),
            'inference_limit':'Label permutation tails are descriptive; no probability model, no new theorem.'},
        'algebraic_cross_checks':{'A210_L_eq_L_A30':True,
            'prime_7_correction_from_210_to_30':True,
            'legacy_counts_matched_at_four_cutoffs':True,
            'naive_prime_check_up_to_5000':True,
            'P3_eq_quadratic_character_projection':True},
        'gate':'CLASSICAL_PLUS_FINITE_CHECKS; spectral-novelty claim=NO, random inference=NO'
    }


def main():
    parser=argparse.ArgumentParser()
    parser.add_argument('--out',type=Path,default=Path(__file__).with_name('resultats_spec.json'))
    parser.add_argument('--limit',type=int,default=VALIDATION_CUTOFF)
    args=parser.parse_args()
    results=run(args.limit)
    args.out.write_text(json.dumps(results,ensure_ascii=False,indent=2)+'\n',encoding='utf8')
    print('Spectral M(30) energies:',results['spectral_M30']['energy'])
    print('E3 label upper tail:',results['exhaustive_30_label_checks']['scores']['3']['tail_ge_fraction'])
    print('Holdout 210 coarse energy:',results['holdout']['coarse_fraction'],
          '< 0.05:',results['holdout']['passes_predefined_threshold'])
    print('Holdout random-label lower-tail fraction:',results['holdout']['monte_carlo_label_control']['fraction_le'])
    print('Protocol SHA-256:',results['protocol_sha256'])
    print('Output:',args.out)


if __name__=='__main__':main()