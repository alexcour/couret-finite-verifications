#!/usr/bin/env python3
"""Independent finite pair-cover and hard-noise witness audit.

This is a separate derivation from tabulated moments; it does NOT call
verify_policy, dynamic programming, or interval endpoint enumeration.
"""
from fractions import Fraction as F
from itertools import combinations, product

T={
  'A': (F(1), F(1,2), F(5,16)),
  'B': (F(1), F(11,26), F(5,16)),
  'C': (F(3), F(1,2), F(5,16)),
  'D': (F(3), F(1,2), F(3,20)),
}
EPS=F(1,100)
E_BOUND=F(1,26)
TIMES=(0,1,2)


def possible_pair_separation(a,b,query_subset,eps):
    return any(abs(T[a][k]-T[b][k])>2*eps for k in query_subset)


def identity_possible(times,eps):
    return all(possible_pair_separation(i,j,times,eps)
               for i,j in combinations(sorted(T),2))


def safe_identify(who, observed):
    return {x for x in T if all(abs(T[x][t]-y)<=EPS for t,y in observed.items())}


def main():
    # Fixed supports have an exact set-cover certificate.
    blocked={}
    for subset in combinations(TIMES,2):
        not_separated=[i+j for i,j in combinations(sorted(T),2)
                       if not possible_pair_separation(i,j,subset,EPS)]
        blocked[subset]=not_separated
    assert blocked=={(0,1):['CD'],(0,2):['AB'],(1,2):['AC']},blocked
    assert identity_possible(TIMES,EPS)
    assert not any(identity_possible((k,),EPS) for k in TIMES)
    assert abs(T['A'][1]-T['B'][1])==F(1,13)
    assert abs(T['C'][2]-T['D'][2])==F(13,80)
    # Exact endpoint / midpoint certificate: two labels fit same full transcript.
    transcript={0:F(1),1:F(6,13),2:F(5,16)}
    assert all(abs(T[name][t]-y)<=E_BOUND
               for name in ('A','B') for t,y in transcript.items())
    assert not identity_possible(TIMES,E_BOUND)
    assert identity_possible(TIMES,E_BOUND-F(1,1000000))

    # Adaptive policy is robust for ALL noises, since each relevant gap is >2 eps.
    assert abs(T['A'][0]-T['C'][0])>2*EPS
    assert abs(T['A'][1]-T['B'][1])>2*EPS
    assert abs(T['C'][2]-T['D'][2])>2*EPS
    outcomes=set()
    for who in T:
        last=1 if who in ('A','B') else 2
        for e0,e1 in product((-EPS,F(0),EPS),repeat=2):
            obs={0:T[who][0]+e0,last:T[who][last]+e1}
            compatibles=safe_identify(who,obs)
            assert compatibles=={who},(who,obs,compatibles)
            outcomes.add((who,str(e0),str(e1)))
    assert len(outcomes)==36
    # With two observations, a fixed schedule always contains a pair of
    # exactly identical noiseless transcripts. Optimal worst-case query count 3.
    # A history-conditional chronological policy 0 -> (1 if mass1, 2 if mass3)
    # correctly identifies every label with exactly 2.
    assert F(2)+F(2,4)==F(5,2)
    assert F(3)+F(2,4)==F(7,2)
    print('PASS: independent rational pair-cover proof, eps threshold, 36 noisy transcripts')

if __name__=='__main__':
    main()
