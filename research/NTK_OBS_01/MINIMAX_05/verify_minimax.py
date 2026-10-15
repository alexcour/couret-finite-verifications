#!/usr/bin/env python3
"""NTK-OBS-05: exact rational bounded-noise minimax certificates.

Not a model of stochastic noise or trained neural networks. Uses standard library only.
"""
from fractions import Fraction as F
from pathlib import Path
import json

DELTA = F(1, 1000)
EPS_BOX = F(1, 100)
CENTERS = {
    'A': ((F(1,4),F(1,2)),(F(3,4),F(1,2))),
    'B': ((F(3,52),F(1,2)),(F(41,52),F(1,2))),
    'C': ((F(1,20),F(275,108)),(F(23,28),F(49,108))),
    'D': ((F(1,10),F(5,2)),(F(1,2),F(1,2)))
}
A=F(89,100)
B=F(91,100)
W=F(1)
OTHER_Q=F(1,4)
OTHER_W=F(1)
SCALE=10**12
MAX_H=24
# Rational noise levels, no random or floating-point sampling.
NOISES=(F(1,25),F(19,500),F(7,200),F(3,100),F(1,100),F(1,1000),F(1,10000),F(1,100000))
TARGETS=(F(1,200),F(1,1000),F(1,2000),F(1,4000),F(1,10000))


def moment(atoms, t):
    return sum((w*q**t for q,w in atoms),F(0))


def gap(t,d):
    if not t: return F(0)
    assert 0 <= d <= B-A
    return W*((A+d)**t-A**t)


def feasible(d,h,eps):
    return all(gap(k,d)<=2*eps for k in range(1,h+1))


def critical_d(h,eps):
    """Exact root bracket in units of 1e-12. hi=lo+1 unless saturated."""
    cap=(B-A)*SCALE
    assert cap.denominator==1
    cap=int(cap)
    if h==0 or feasible(B-A,h,eps):
        return cap,cap
    lo=0; hi=cap
    assert feasible(F(lo,SCALE),h,eps)
    assert not feasible(F(hi,SCALE),h,eps)
    while hi-lo>1:
        mid=(lo+hi)//2
        if feasible(F(mid,SCALE),h,eps): lo=mid
        else: hi=mid
    assert feasible(F(lo,SCALE),h,eps)
    assert not feasible(F(hi,SCALE),h,eps)
    return lo,hi


def selected_best_time(h,eps):
    if h==0: return None, []
    floors={t:critical_d_single(t,eps) for t in range(1,h+1)}
    smallest=min(x[0] for x in floors.values())
    return min(k for k,z in floors.items() if z[0]==smallest),[k for k,z in floors.items() if z[0]==smallest]


def critical_d_single(t,eps):
    cap=int((B-A)*SCALE)
    if gap(t,B-A)<=2*eps: return cap,cap
    lo=0; hi=cap
    while hi-lo>1:
        mid=(lo+hi)//2
        if gap(t,F(mid,SCALE))<=2*eps: lo=mid
        else: hi=mid
    assert gap(t,F(lo,SCALE))<=2*eps<gap(t,F(hi,SCALE))
    return lo,hi


def risk_row(h,eps):
    lo,hi=critical_d(h,eps)
    saturation=(lo==hi==int((B-A)*SCALE))
    t,best=(None,[]) if saturation else selected_best_time(h,eps)
    if t is not None:
        ownlo,ownhi=critical_d_single(t,eps)
        assert ownlo==lo and ownhi==hi, (h,eps,t,(lo,hi),(ownlo,ownhi))
    return dict(horizon=h,best_single_time=t,grid_ties=best,
                minimax_diameter_lower=str(F(lo,SCALE)),
                minimax_diameter_upper=str(F(hi,SCALE)),
                minimax_risk_lower=str(F(lo,2*SCALE)),
                minimax_risk_upper=str(F(hi,2*SCALE)),
                exact_prior_saturation=saturation,
                unique_best_time_certified=(t is not None and len(best)==1))


def critical_horizon(eps,tau):
    assert tau>0
    if tau>= (B-A)/2:
        return dict(target=str(tau),first_time=None,queries=0,horizon=0,
                    cost='0',status='PRIOR_ALREADY_SUFFICIENT')
    d=2*tau
    valid=[t for t in range(1,12) if gap(t,d)>=2*eps]
    if not valid:
        return dict(target=str(tau),first_time=None,queries=None,horizon=None,
                    cost=None,status='IMPOSSIBLE_AT_ANY_INTEGER_HORIZON')
    t=min(valid)
    # For earlier times there is one common noisy transcript for parameters
    # with a distance strictly larger than 2*tau (by continuity).
    assert all(gap(k,d)<2*eps for k in range(1,t))
    assert gap(t,d)>=2*eps
    return dict(target=str(tau),first_time=t,queries=1,horizon=t,
                cost=str(F(1)+F(t,4)),status='ONE_QUERY_MINIMAX_COST')


def audit():
    boxes={}
    for label,atoms in CENTERS.items():
        q0,w0=atoms[0]
        assert F(0)<q0-DELTA<q0+DELTA<atoms[1][0]-DELTA
        assert all(w>DELTA for q,w in atoms)
        # Perturb the weight w0 +/- delta; entire observation stream identical
        # to center within eps because |delta * q0**t| <= delta < eps.
        weight_bound=DELTA
        assert weight_bound < EPS_BOX
        # Independently perturb q0 +/- delta, same y_t=center trajectory.
        # |(q +/- d)^t-q^t| <= t (q+d)^(t-1) d <= d/(1-q-d).
        node_bound=w0*DELTA/(1-q0-DELTA)
        assert node_bound<EPS_BOX
        for t in range(0,121):
            center=moment(atoms,t)
            for sign in [-1,1]:
                shifted_w=((q0,w0+sign*DELTA),atoms[1])
                shifted_q=((q0+sign*DELTA,w0),atoms[1])
                assert abs(moment(shifted_w,t)-center)<=weight_bound
                assert abs(moment(shifted_q,t)-center)<=node_bound
        boxes[label]={
            'full_parameter_linf_minimax_exact':str(DELTA),
            'nodes_only_linf_minimax_exact':str(DELTA),
            'weight_shift_all_time_upper':str(weight_bound),
            'node_shift_all_time_upper':str(node_bound),
            'all_time_common_observation':'center trajectory',
            'upper_estimator':'known family box center, zero measurements',
            'witness_node':'q0 +/- 1/1000',
            'witness_weight':'w0 +/- 1/1000',
        }

    # Every later sample t>=12 has smaller separation than t=11 for every
    # q within [A,B]; (t+1)*x**t <= t*x**(t-1) for t>=11, x<=B.
    assert F(12,11)*B<1
    for d in [F(1,100000),F(1,1000),B-A]:
        for t in range(11,MAX_H):
            assert gap(t+1,d)<=gap(t,d)

    noise_cases={}
    for ep in NOISES:
        rows=[risk_row(h,ep) for h in range(MAX_H+1)]
        for h in range(1,MAX_H+1):
            assert F(rows[h]['minimax_risk_lower'])<=F(rows[h-1]['minimax_risk_lower'])
        # No additional information beyond time 11 in this 1D bounded-noise sense.
        assert all((row['minimax_risk_lower'],row['minimax_risk_upper'])==
                   (rows[11]['minimax_risk_lower'],rows[11]['minimax_risk_upper'])
                   for row in rows[12:])
        epskey=str(ep)
        noise_cases[epskey]={
            'horizons':rows,
            'unrestricted_time_same_as_h11':True,
            'all_time_minimax_risk_certified_interval':[
                rows[11]['minimax_risk_lower'],rows[11]['minimax_risk_upper']],
            'time_at_h11':rows[11]['best_single_time'],
            'target_costs': [critical_horizon(ep,tau) for tau in TARGETS],
        }

    # Entire interval a<=q<=b, and all q distinct from fixed fast mode 1/4.
    assert 0<OTHER_Q<A<B<1 and W>0 and OTHER_W>0
    return {
        'project':'NTK-OBS-05','date':'2026-10-11',
        'scope':'deterministic L-infinity minimax for known boxes; independent one-dimensional positive 2-atom slice',
        'external_review':'OPEN','novelty':'NO CLAIM',
        'box_result':{'radius':str(DELTA),'noise':str(EPS_BOX),
                      'conditional_on_family_label_known':True,
                      'all_integer_times_and_any_adaptive_strategy':True,
                      'families':boxes},
        'slow_slice':{'low_q':str(A),'high_q':str(B),'variable_weight':str(W),
                      'fixed_other_q':str(OTHER_Q),'fixed_other_weight':str(OTHER_W),
                      'parameter':'higher node q only, other three parameters KNOWN',
                      'noise_type':'independently BOUNDED per time (not probabilistically independent)',
                      'risk_grid_denominator':SCALE,'noise_cases':noise_cases,
                      'certified_dominance':'for all k>=12, gap(k,d)<=gap(11,d) for every d in [0,b-a]'},
        'theorem_status':'local proofs included; independent external verification open',
        'warning':'time t=0 is uninformative on slow slice; prior midpoint costs zero if target >= 1/100; no claim of globally optimal 4-parameter strategy'
    }


if __name__=='__main__':
    data=audit()
    path=Path(__file__).with_name('results.json')
    path.write_text(json.dumps(data,ensure_ascii=True,indent=2,sort_keys=True)+'\n',encoding='utf-8')
    print('PASS: all 4 previous continuous boxes have exact all-time within-box minimax Linf risk = 1/1000')
    print('PASS: positive PSD two-mode slow slice 1D risk brackets and one-query optimality')
    print('PASS: no new minimax information after horizon 11; target-cost phase diagram')
