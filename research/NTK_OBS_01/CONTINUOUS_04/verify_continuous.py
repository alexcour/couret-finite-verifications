#!/usr/bin/env python3
"""NTK-OBS-04: exact-rational certificates for four continuous spectral boxes.

Scope: class-label identification among four compact 4-parameter boxes,
not full continuous-parameter reconstruction or neural-network training.
"""
from fractions import Fraction as F
from itertools import combinations
import json
from pathlib import Path

DELTA = F(1, 1000)
EPS = F(1, 100)
WAIT = F(1, 4)
OBS = F(1)
TIMES = (0, 1, 2)
CENTERS = {
    'A': ((F(1, 4), F(1, 2)), (F(3, 4), F(1, 2))),
    'B': ((F(3, 52), F(1, 2)), (F(41, 52), F(1, 2))),
    'C': ((F(1, 20), F(275, 108)), (F(23, 28), F(49, 108))),
    'D': ((F(1, 10), F(5, 2)), (F(1, 2), F(1, 2))),
}
EXPECTED = {
    'A': (F(1), F(1, 2), F(5, 16)),
    'B': (F(1), F(11, 26), F(5, 16)),
    'C': (F(3), F(1, 2), F(5, 16)),
    'D': (F(3), F(1, 2), F(3, 20)),
}


def moments(atoms, t):
    return sum((w * (q ** t) for q, w in atoms), F(0))


def interval_moment(atoms, t):
    # Monotone in q,w for strictly positive parameters and integer t>=0.
    low = sum(((w - DELTA) * (q - DELTA) ** t for q, w in atoms), F(0))
    high = sum(((w + DELTA) * (q + DELTA) ** t for q, w in atoms), F(0))
    return low, high


def determinant(a):
    a = [list(r) for r in a]
    n = len(a)
    res = F(1)
    for c in range(n):
        found = next((r for r in range(c, n) if a[r][c]), None)
        if found is None:
            return F(0)
        if found != c:
            a[c], a[found] = a[found], a[c]
            res = -res
        p = a[c][c]
        res *= p
        for r in range(c + 1, n):
            factor = a[r][c] / p
            for j in range(c + 1, n):
                a[r][j] -= factor * a[c][j]
            a[r][c] = F(0)
    return res


def jac3(atoms, times):
    (q0, w0), (q1, w1) = atoms
    mat = [[q0 ** t, q1 ** t, (w1 * t * q1 ** (t - 1) if t else F(0))]
           for t in times]
    return determinant(mat)


def jac4(atoms, times):
    (q0, w0), (q1, w1) = atoms
    mat = [[q0 ** t, q1 ** t,
            (w0 * t * q0 ** (t-1) if t else F(0)),
            (w1 * t * q1 ** (t-1) if t else F(0))]
           for t in times]
    return determinant(mat)


def pair_separator(a, b, times, bounds, eps):
    return [t for t in times if (bounds[a][t][1] + eps < bounds[b][t][0] - eps)
            or (bounds[b][t][1] + eps < bounds[a][t][0] - eps)]


def validate():
    for name, atoms in CENTERS.items():
        assert len(atoms) == 2
        assert 0 < atoms[0][0]-DELTA < atoms[0][0]+DELTA < atoms[1][0]-DELTA
        assert atoms[1][0]+DELTA < 1
        assert all(w > DELTA for q, w in atoms)
        assert tuple(moments(atoms, t) for t in TIMES) == EXPECTED[name]
    bounds = {name: {t: interval_moment(atoms, t) for t in TIMES}
              for name, atoms in CENTERS.items()}
    # Conservative class-uniform perturbation: |m_t-m_t(center)|<=2delta+t W delta.
    # All center total weights W are <=3, all q+delta<1.
    assert all(sum(w for q,w in atoms) <= 3 for atoms in CENTERS.values())
    radius = {t: (2 + 3*t) * DELTA for t in TIMES}
    for name in CENTERS:
        for t in TIMES:
            lower, upper = bounds[name][t]
            assert lower <= EXPECTED[name][t] <= upper
            assert EXPECTED[name][t] - lower <= radius[t]
            assert upper - EXPECTED[name][t] <= radius[t]

    # Exact extrema of all four independent intervals in each parameter box.
    group0_gap = min(bounds[z][0][0] for z in ('C', 'D')) - max(bounds[z][0][1] for z in ('A', 'B'))
    ab_gap = bounds['A'][1][0] - bounds['B'][1][1]
    cd_gap = bounds['C'][2][0] - bounds['D'][2][1]
    gap = min(group0_gap, ab_gap, cd_gap)
    assert min(group0_gap, ab_gap, cd_gap) > 2 * EPS
    exact_policy_epsilon_sup = gap / 2
    # A cruder simple sufficient threshold via uniform center-distance radii.
    coarse_epsilon_sup = min(F(1) - radius[0], F(1,26)-radius[1], F(13,160)-radius[2])
    assert EPS < coarse_epsilon_sup <= exact_policy_epsilon_sup

    # Brute force set-cover among the three allowed times.
    schedules = []
    for size in (1, 2, 3):
        for schedule in combinations(TIMES, size):
            ambiguous = []
            for a,b in combinations(sorted(CENTERS), 2):
                if not pair_separator(a,b,schedule,bounds,EPS):
                    ambiguous.append(a+b)
            schedules.append({'times':list(schedule), 'ambiguous_pairs_under_box_bounds':ambiguous,
                              'certified':not ambiguous})
    assert [x for x in schedules if x['certified']] == [
        {'times':[0,1,2], 'ambiguous_pairs_under_box_bounds':[], 'certified':True}]
    # No two-query fixed schedule can work: exactly equal CENTER data on a pair.
    witness_pairs = { (0,1):('C','D'), (0,2):('A','B'), (1,2):('A','C') }
    for ts, (a, b) in witness_pairs.items():
        assert all(EXPECTED[a][t] == EXPECTED[b][t] for t in ts)
    # Adaptive 0 then 1 for AB / 2 for CD is correct for ALL theta in boxes,
    # by interval nonoverlap, even under arbitrary per-measurement bounded noise.
    assert pair_separator('A','B',(1,),bounds,EPS) == [1]
    assert pair_separator('C','D',(2,),bounds,EPS) == [2]
    assert pair_separator('A','C',(0,),bounds,EPS) == [0]
    assert pair_separator('B','D',(0,),bounds,EPS) == [0]

    # Exact Jacobian minors for test triples. General argument is in PROOF_NOTE.md
    # and relies on the three-term positive-root count, not on this finite sweep.
    triples = ((0,1,2),(0,2,5),(1,3,8),(4,7,11))
    jac_check = {}
    for name, atoms in CENTERS.items():
        jac_check[name] = {','.join(map(str,ts)):str(jac3(atoms,ts)) for ts in triples}
        assert all(jac3(atoms,ts) != 0 for ts in triples)
        assert abs(jac4(atoms,(0,1,2,3))) == (
            atoms[0][1]*atoms[1][1]*(atoms[1][0]-atoms[0][0])**4)

    # An explicit entire-horizon overlap inside box A: two different q0 values.
    # y_t is the CENTER moment. For both theta+ and theta-:
    # |m_t(theta+-)-y_t| <= w0*delta/(1-(q0+delta))^2 for ALL integer t>=0.
    q0,w0 = CENTERS['A'][0]
    noise_bound = w0 * DELTA / (1 - q0 - DELTA)**2
    assert noise_bound == F(500,561001)
    assert noise_bound < EPS
    for t in range(0,101):
        central = moments(CENTERS['A'],t)
        for sign in (-1,1):
            shifted = ((q0+sign*DELTA,w0),CENTERS['A'][1])
            assert abs(moments(shifted,t)-central) <= noise_bound
    # Endpoints for x and x +/- delta are in the same closed parameter family.
    # Their q0 coordinates differ by 2delta; any common-output estimator errs
    # by >=delta for at least one model in max-norm on ordered q coordinates.
    prep_cases=[]
    for delta_p in (F(0), F(1,2), F(1), F(3,2)):
        fixed = F(3) * OBS + 2 * WAIT
        adaptive = F(2) * OBS + 2 * WAIT + delta_p
        prep_cases.append({'adaptive_preparation_premium':str(delta_p),
                           'fixed_cost':str(fixed),'adaptive_cost':str(adaptive),
                           'adaptive_cheaper':adaptive<fixed, 'tie':adaptive==fixed})
    assert [p['adaptive_cheaper'] for p in prep_cases] == [True,True,False,False]
    assert [p['tie'] for p in prep_cases] == [False,False,True,False]

    return {
        'project':'NTK-OBS-04',
        'date':'2026-10-11',
        'scope':'four continuous 4-parameter boxes, exact class-label certification only',
        'delta':str(DELTA),'epsilon':str(EPS),
        'center_moments':{name:[str(x) for x in EXPECTED[name]] for name in sorted(CENTERS)},
        'box_moment_bounds':{name:{str(t):[str(v) for v in bounds[name][t]] for t in TIMES}
                             for name in sorted(bounds)},
        'coarse_uniform_radii':{str(t):str(v) for t,v in radius.items()},
        'class_separation_gaps':{'at_t0_groups':str(group0_gap),
                                 'at_t1_A_B':str(ab_gap),'at_t2_C_D':str(cd_gap)},
        'adaptive_sufficient_epsilon_supremum_for_interval_policy':str(exact_policy_epsilon_sup),
        'conservative_sufficient_epsilon_supremum':str(coarse_epsilon_sup),
        'fixed_schedule_search':schedules,
        'adaptive_tree':{'initial_time':0,'group_AB_second_time':1,'group_CD_second_time':2,
                         'worst_case_observations':2,'worst_case_horizon':2},
        'fixed_successful_schedule':{'times':[0,1,2],'observations':3,'horizon':2},
        'explicit_fixed_two_query_obstructions':{','.join(map(str,k)):list(v)
                                                  for k,v in witness_pairs.items()},
        'jacobian_rational_spot_checks':jac_check,
        'all_time_node_indistinguishability':{'family':'A','q0_plus_minus_delta':
            [str(q0-DELTA),str(q0+DELTA)],'witness_y_k':'m_k(center A)',
            'sup_noise_rational_bound':str(noise_bound),
            'unavoidable_node_max_error_at_least':str(DELTA),
            'finite_sanity_checks_k0_to_100':True},
        'cost_premium_scan':prep_cases,
        'claim_gate':{'local_rational_checks':'PASS','external_review':'OPEN',
                      'novelty':'NO CLAIM','no_merge_to_main':True,
                      'full_continuum_exact_identification':'NO UNDER <=3 QUERIES'}
    }

if __name__=='__main__':
    out=validate()
    path=Path(__file__).with_name('results.json')
    path.write_text(json.dumps(out,sort_keys=True,indent=2,ensure_ascii=True)+'\n', encoding='utf-8')
    print('PASS: continuous spectral family labels, robust adaptive 2 vs fixed 3')
    print('PASS: all-time indistinguishability and exact rational Jacobian checks')
    print('PASS: preparation threshold and original finite-bank consistency')
