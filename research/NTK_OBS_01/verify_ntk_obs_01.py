#!/usr/bin/env python3
"""NTK-OBS-01: exact rational verification of loss observability for fixed PSD kernels.
No external dependencies; all numerical quantities are Fractions.
Usage: python verify_ntk_obs_01.py [--check results.json] [--write path]
"""
import argparse
import json
from fractions import Fraction as F
from math import isqrt
from pathlib import Path


def show(x):
    if isinstance(x, F):
        return str(x.numerator) if x.denominator == 1 else f"{x.numerator}/{x.denominator}"
    if isinstance(x, dict):
        return {str(k): show(v) for k, v in x.items()}
    if isinstance(x, (list, tuple)):
        return [show(v) for v in x]
    return x


def mv(K, v):
    return [sum((K[i][j]*v[j] for j in range(len(v))), F(0)) for i in range(len(v))]


def update(K, v, eta):
    Kv = mv(K, v)
    return [vi-eta*ki for vi, ki in zip(v, Kv)]


def loss(v):
    return sum((vi*vi for vi in v), F(0))/2


def trajectory(K, e0, eta, steps):
    v = list(e0)
    values = []
    states = []
    for k in range(steps + 1):
        states.append(v)
        values.append(loss(v))
        v = update(K, v, eta)
    return states, values


def diag_loss(lambdas, weights, eta, k):
    return sum((w*(1-eta*lam)**(2*k) for lam, w in zip(lambdas, weights)),F(0))/2


def sqrt_fraction(x):
    assert x >= 0
    a,b = isqrt(x.numerator),isqrt(x.denominator)
    assert a*a == x.numerator and b*b == x.denominator, f"Non-square rational: {x}"
    return F(a,b)


def prony_two(m):
    """Recover exactly q1,q2,w1,w2 from four exact moments m0..m3."""
    assert len(m)==4
    m0,m1,m2,m3=m
    # m2 = s1*m1 - s2*m0; m3=s1*m2-s2*m1.
    a,b,c,d=m1,-m0,m2,-m1
    det=a*d-b*c
    assert det!=0
    s1=(m2*d-b*m3)/det
    s2=(a*m3-m2*c)/det
    delta=s1*s1-4*s2
    sq=sqrt_fraction(delta)
    q1,q2=(s1+sq)/2,(s1-sq)/2
    assert q1!=q2
    w1=(m1-q2*m0)/(q1-q2)
    w2=m0-w1
    assert q1>q2>=0 and w1>0 and w2>0
    assert [w1*q1**k+w2*q2**k for k in range(4)]==m
    return {"q":[q1,q2],"weights":[w1,w2],"recurrence":{"sum_q":s1,"prod_q":s2}}


def main_result():
    zero=F(0); one=F(1)
    K1=[[F(1),zero],[zero,F(4)]]
    K2=[[F(4),zero],[zero,F(1)]]
    e0=[one,zero]
    eta=F(1,8)
    states1,L1=trajectory(K1,e0,eta,12)
    states2,L2=trajectory(K2,e0,eta,12)
    assert L1[0]==L2[0] and all(L1[k]!=L2[k] for k in range(1,13))
    for k in range(13):
        assert L1[k]==diag_loss([F(1),F(4)],[one,zero],eta,k)
        assert L2[k]==diag_loss([F(4),F(1)],[one,zero],eta,k)

    # Control: co-transform the task, and the loss is identical.
    _,L2_rotated=trajectory(K2,[zero,one],eta,12)
    assert L1==L2_rotated

    # Discrete loss is invariant under lambda <-> 2/eta - lambda.
    KA=[[F(1,2)]]; KB=[[F(3,2)]]
    sa,La=trajectory(KA,[one],one,12)
    sb,Lb=trajectory(KB,[one],one,12)
    assert La==Lb
    assert sa[1]!=sb[1] and sa[2]==sb[2]
    assert all(La[k]==F(1,2)*F(1,4)**k for k in range(13))

    # Exact moment inversion: lambdas (1/2,1), eta=1/2, e0=(1,2).
    KC=[[F(1,2),zero],[zero,one]]
    eC=[one,F(2)]; etaC=F(1,2)
    _,LC=trajectory(KC,eC,etaC,12)
    moments=[2*LC[k] for k in range(4)]
    reconstruction=prony_two(moments)
    assert reconstruction['q']==[F(9,16),F(1,4)]
    assert reconstruction['weights']==[F(1),F(4)]
    # Under 0 < eta*lambda < 1 the map lambda -> q is injective.
    recovered_lambdas=[(1-sqrt_fraction(q))/etaC for q in reconstruction['q']]
    assert recovered_lambdas == [F(1,2),one]
    for k in range(13):
        assert LC[k]==diag_loss([F(1,2),one],[one,F(4)],etaC,k)

    # Counterexample: first 3 moments admit two different positive 2-atom measures.
    alternative_q=[F(1,2),F(11,48)]
    alternative_weights=[F(20,13),F(45,13)]
    assert all(sum((w*q**k for w,q in zip(alternative_weights,alternative_q)), F(0))==moments[k] for k in range(3))
    m3_alt=sum((w*q**3 for w,q in zip(alternative_weights, alternative_q)),F(0))
    assert m3_alt!=moments[3]

    return show({
        "project":"NTK-OBS-01","date":"2026-10-11",
        "claim_scope":"classical exact finite identities; no novelty assertion",
        "isospectral_task_alignment":{
            "K1":K1,"K2":K2,"shared_e0":e0,"eta":eta,
            "loss_K1_first_5":L1[:5],"loss_K2_first_5":L2[:5],
            "losses_different_steps_1_to_12":all(L1[k]!=L2[k] for k in range(1,13)),
            "co_transformed_e0": [zero,one],
            "co_transformed_losses_identical_steps_0_to_12":L1==L2_rotated
        },
        "discrete_alias":{
            "eta":one,"K_A":KA,"K_B":KB,"e0":[one],
            "losses_first_6":La[:6],
            "same_losses_steps_0_to_12":La==Lb,
            "state_after_1_A":sa[1],"state_after_1_B":sb[1],
            "same_state_after_2":sa[2]==sb[2]
        },
        "two_mode_identification":{
            "K":KC,"eta":etaC,"e0":eC,"moments_m0_through_m3":moments,
            "prony":reconstruction,"recovered_lambdas_in_monotone_branch":recovered_lambdas,
            "alternative_three_sample_solution":{
                "q":alternative_q,"weights":alternative_weights,
                "m3_alternative":m3_alt,
                "m3_original":moments[3],"first_three_match":True,
                "fourth_separates":True
            }
        }
    })


def main():
    parser=argparse.ArgumentParser()
    parser.add_argument('--check', type=Path, help="Assert JSON matches the archived result exactly")
    parser.add_argument('--write', type=Path, help="Write deterministic result JSON")
    args=parser.parse_args()
    data=main_result()
    output=json.dumps(data,ensure_ascii=False,indent=2,sort_keys=True)+"\n"
    if args.check:
        assert args.check.read_text(encoding='utf-8')==output,"Result file mismatch"
        print('PASS: regenerated exact rational results match',args.check)
    if args.write:
        args.write.write_text(output,encoding='utf-8')
        print('wrote',args.write)
    if not args.check and not args.write:
        print(output)

if __name__=='__main__':
    main()