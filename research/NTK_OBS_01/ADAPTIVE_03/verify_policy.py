#!/usr/bin/env python3
"""NTK-OBS-03: adversarial-noise version-space dynamic programming (Fraction only).

The finite class, query times, and cost are fixed in this script. Every possible
continuous observation outcome is covered by rational interval endpoints and the
open cells between them. No random numbers, external modules, or float tests.
"""
from __future__ import annotations
import itertools
import json
from fractions import Fraction as F
from functools import lru_cache
from pathlib import Path

Q = {
    'A': ((F(1, 4), F(1, 2)), (F(3, 4), F(1, 2))),
    'B': ((F(3, 52), F(1, 2)), (F(41, 52), F(1, 2))),
    'C': ((F(1, 20), F(275, 108)), (F(23, 28), F(49, 108))),
    'D': ((F(1, 10), F(5, 2)), (F(1, 2), F(1, 2))),
}
TIMES = (0, 1, 2)
EPS = F(1, 100)
WAIT_COST = F(1, 4)
QUERY_COST = F(1)
NAMES = tuple(sorted(Q))
ALL = frozenset(NAMES)


def mom(name: str, t: int) -> F:
    return sum((w * q**t for q, w in Q[name]), F(0))


def encode(x):
    if isinstance(x, F):
        return str(x)
    if isinstance(x, dict):
        return {str(k): encode(v) for k,v in x.items()}
    if isinstance(x, (list, tuple)):
        return [encode(v) for v in x]
    return x


def outcomes(candidates: frozenset[str], t: int, eps: F):
    """All nonempty observational version spaces, including boundary-only sets."""
    endpoints = sorted(set(p for name in candidates for p in
                           (mom(name, t) - eps, mom(name, t) + eps)))
    witnesses = endpoints + [(a+b)/2 for a,b in zip(endpoints, endpoints[1:])]
    collection = {}
    for y in witnesses:
        compatible = frozenset(name for name in candidates
                               if abs(y - mom(name, t)) <= eps)
        if compatible:
            signature = ''.join(sorted(compatible))
            collection.setdefault(signature, (compatible, y))
    return sorted(collection.values(), key=lambda item: ''.join(sorted(item[0])))


def solve(eps: F, label_by_model: dict[str,str] | None = None,
          query_cost=QUERY_COST, wait_cost=WAIT_COST):
    if label_by_model is None:
        label_by_model = {name:name for name in NAMES}

    @lru_cache(None)
    def opt(candidates: frozenset[str], prev: int):
        if len({label_by_model[name] for name in candidates}) == 1:
            return F(0), {'stop':sorted(candidates),
                          'label':label_by_model[next(iter(candidates))]}
        choices = []
        for t in TIMES:
            if t <= prev:
                continue
            branches = []
            possible = True
            for group,y in outcomes(candidates,t,eps):
                outcome = opt(group,t)
                if outcome is None:
                    possible = False
                    break
                branches.append((group, y, outcome))
            if not possible or not branches:
                continue
            # Cost is additive number of observations plus elapsed time since last
            # selected instant; telescope to J = n_queries + wait_cost*horizon.
            step_cost = query_cost + wait_cost * (t - max(prev,0))
            candidate_cost = step_cost + max(z[2][0] for z in branches)
            tree = {'query_time':t, 'candidate_models':sorted(candidates),
                    'worst_case_cost':str(candidate_cost),
                    'outcomes':[{'compatible_models':sorted(g), 'witness_y':str(y),
                                 'continuation':res[1]} for g,y,res in branches]}
            choices.append((candidate_cost,t,tree))
        if not choices:
            return None
        best = min(choices, key=lambda item:(item[0],item[1]))
        return best[0], best[2]

    result = opt(ALL,-1)
    return None if result is None else {'optimal_cost':str(result[0]),
                                        'policy':result[1],
                                        'visited_dp_states':opt.cache_info().currsize}


def robustly_separates(i, j, schedule, eps):
    return any(abs(mom(i,t)-mom(j,t))>2*eps for t in schedule)


def fixed_schedules(eps: F, query_cost=QUERY_COST,wait_cost=WAIT_COST):
    entries=[]
    for length in range(1,len(TIMES)+1):
        for scheduled in itertools.combinations(TIMES,length):
            bad=[i+j for i,j in itertools.combinations(NAMES,2)
                 if not robustly_separates(i,j,scheduled,eps)]
            item={'times':list(scheduled),'query_count':length,
                  'horizon':scheduled[-1],
                  'worst_unconditional_cost':str(query_cost*length+wait_cost*scheduled[-1]),
                  'ambiguous_pairs':bad,'successful':not bad}
            entries.append(item)
    feasible=[item for item in entries if item['successful']]
    best=min(feasible,key=lambda x:(F(x['worst_unconditional_cost']), x['query_count'])) if feasible else None
    return entries,best


def run_policy(tree, true_model, errors=None):
    errors={} if errors is None else errors
    path=[]
    while 'query_time' in tree:
        t=tree['query_time']
        obs=mom(true_model,t)+errors.get(t,F(0))
        compatible=frozenset(name for name in tree['candidate_models']
                             if abs(mom(name,t)-obs)<=EPS)
        matches=[z for z in tree['outcomes'] if frozenset(z['compatible_models'])==compatible]
        assert len(matches)==1, (true_model,t,compatible)
        tree=matches[0]['continuation']
        path.append(t)
    assert true_model in tree['stop']
    assert len(tree['stop'])==1
    return path,tree['label']


def validate():
    # Each is physically realizable with eta=1, diagonal PSD K having
    # eigenvalues 1-sqrt(q_i) in (0,1), and residual coordinate sqrt(w_i).
    for name,atoms in Q.items():
        assert len(atoms)==2 and atoms[0][0]!=atoms[1][0]
        assert all(F(0)<q<F(1) and w>0 for q,w in atoms),name
    expected={
        'A':(F(1),F(1,2),F(5,16)),
        'B':(F(1),F(11,26),F(5,16)),
        'C':(F(3),F(1,2),F(5,16)),
        'D':(F(3),F(1,2),F(3,20))}
    for name in NAMES:
        assert tuple(mom(name,t) for t in TIMES)==expected[name]
    assert mom('A',0)==mom('B',0) and mom('A',2)==mom('B',2)
    assert mom('C',0)==mom('D',0) and mom('C',1)==mom('D',1)
    assert mom('A',1)==mom('C',1) and mom('A',2)==mom('C',2)
    assert mom('A',1)-mom('B',1)==F(1,13)
    assert mom('C',2)-mom('D',2)==F(13,80)

    base=solve(EPS)
    assert base is not None and base['optimal_cost']=='5/2'
    tree=base['policy']
    assert tree['query_time']==0
    groups={tuple(x['compatible_models']):x['continuation']['query_time']
            for x in tree['outcomes']}
    assert groups == {('A','B'):1, ('C','D'):2},groups
    schedules,best=fixed_schedules(EPS)
    assert best is not None and best['times']==[0,1,2]
    assert best['worst_unconditional_cost']=='7/2'
    assert {tuple(x['times']):x['ambiguous_pairs']
            for x in schedules if len(x['times'])==2} == {
              (0,1):['CD'], (0,2):['AB'], (1,2):['AC']}

    # 4 models x 3^2 chosen-path adversarial perturbation patterns.
    checks=0
    paths={}
    for name in NAMES:
        for e0,eother in itertools.product((-EPS,F(0),EPS),repeat=2):
            next_time=1 if name in 'AB' else 2
            path,decision=run_policy(tree,name,{0:e0,next_time:eother})
            assert decision==name
            assert path==([0,next_time])
            checks+=1
        paths[name]=[0,1 if name in 'AB' else 2]
    assert checks==36
    # A/B become indistinguishable at eps = 1/26, even on arbitrarily
    # repeated probes of times {0,1,2}: use the same midpoint at time 1.
    threshold=F(1,26)
    y={0:F(1),1:F(6,13),2:F(5,16)}
    assert all(abs(y[t]-mom(name,t))<=threshold for name in ('A','B') for t in TIMES)
    assert all(abs(y[t]-mom(name,t))==0 for name in ('A','B') for t in (0,2))
    assert abs(y[1]-mom('A',1))==threshold
    assert abs(y[1]-mom('B',1))==threshold
    eps_results={}
    for ep in (F(0),EPS,F(1,30),threshold-F(1,1000),threshold,F(1,20)):
        adaptive=solve(ep)
        fs,fx=fixed_schedules(ep)
        assert (adaptive is None)==(ep>=threshold)
        assert (fx is None)==(ep>=threshold)
        eps_results[str(ep)]={
            'adaptive_minimax_cost':None if adaptive is None else adaptive['optimal_cost'],
            'fixed_unconditional_minimax_cost':None if fx is None else fx['worst_unconditional_cost'],
            'robust_exact_identification_possible':adaptive is not None,
            'dp_states':None if adaptive is None else adaptive['visited_dp_states']}
    # Property-only task: distinguish total initial weight (m0=1 vs m0=3).
    property_policy=solve(EPS,{'A':'mass1','B':'mass1','C':'mass3','D':'mass3'})
    assert property_policy is not None
    assert property_policy['optimal_cost']=='1'
    assert property_policy['policy']['query_time']==0

    # In the absence of stochastic assumptions, 'average' below means a
    # conventionally chosen uniform prior on the four candidate labels.
    avg_adaptive=sum((F(len(paths[n]))+WAIT_COST*paths[n][-1]
                      for n in NAMES),F(0))/len(NAMES)
    # fixed chronological schedule 0,1,2 with early stopping when singleton
    fixed_early={}
    for name in NAMES:
        candidates=set(NAMES)
        path=[]
        for t in TIMES:
            path.append(t)
            candidates={other for other in candidates if mom(other,t)==mom(name,t)}
            if len(candidates)==1:
                break
        assert candidates=={name}
        fixed_early[name]=path
    avg_fixed=sum((F(len(p))+WAIT_COST*p[-1] for p in fixed_early.values()),F(0))/4
    assert avg_adaptive==F(19,8)
    assert avg_fixed==F(23,8)
    weight_checks={}
    for beta in (F(0),F(1,4),F(1),F(3)):
        ad=solve(EPS,wait_cost=beta)
        _,fixed=fixed_schedules(EPS,wait_cost=beta)
        assert ad is not None and fixed is not None
        assert F(ad['optimal_cost'])==2+2*beta
        assert F(fixed['worst_unconditional_cost'])==3+2*beta
        weight_checks[str(beta)]={'adaptive':ad['optimal_cost'],
                                  'fixed':fixed['worst_unconditional_cost']}
    result={
        'project':'NTK-OBS-03', 'date':'2026-10-11',
        'claim_scope':'finite known two-atom hypothesis bank; classical decision-tree and Prony framework; no novelty claimed',
        'observation_times':list(TIMES),
        'noise_model':{'absolute_epsilon':str(EPS),'sharp_feasibility_threshold':str(threshold),
                       'noise_at_loss_L_scale':str(EPS/2)},
        'models':{n:{'atoms':[{'q':str(q),'w':str(w)} for q,w in Q[n]],
                     'moments_0_1_2':[str(mom(n,t)) for t in TIMES]}
                  for n in NAMES},
        'query_partitions_at_nominal_epsilon':{
           str(t):[{'candidates':sorted(group),'rational_witness':str(y)}
                   for group,y in outcomes(ALL,t,EPS)] for t in TIMES},
        'unconditional_fixed_designs':schedules,
        'fixed_best':best,
        'adaptive_minimax':base,
        'alternative_property_minimax':property_policy,
        'sharp_boundary_midpoint_observations':{str(k):str(v) for k,v in y.items()},
        'epsilon_scan':eps_results,
        'time_cost_weight_scan':weight_checks,
        'adversarial_corner_and_center_checks':checks,
        'path_by_model':paths,
        'fixed_path_with_early_stop':fixed_early,
        'uniform_prior_comparison':{'adaptive_average_cost':str(avg_adaptive),
                                    'fixed_early_stop_average_cost':str(avg_fixed)},
        'status':{'local_exact_arithmetic':'PASS','external_independent_review':'OPEN',
                  'novelty':'NO CLAIM','general_ntk_training_theorem':'NO'}
    }
    return result

if __name__=='__main__':
    report=validate()
    p=Path(__file__).with_name('results.json')
    p.write_text(json.dumps(report,indent=2,ensure_ascii=False,sort_keys=True)+'\n',encoding='utf-8')
    print('PASS exact finite adaptive minimax: optimal J=5/2; fixed J=7/2; sharp epsilon=1/26')
    print('PASS 36 noise-sign patterns, endpoint-aware dynamic programming, exact fractions')
