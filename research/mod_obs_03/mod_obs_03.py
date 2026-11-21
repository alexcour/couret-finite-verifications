#!/usr/bin/env python3
"""MOD-OBS-03: exact finite sequential binary experiments (standard library only).

All error guarantees are conditional. Analytic computations use Fractions;
logarithms are used only for the expected-cost KL lower bound.
"""
from __future__ import annotations
import hashlib
import json
import math
from fractions import Fraction as F
from pathlib import Path

N = 18
FIBER = {
    "11": (1, 4, 13),
    "10": (1, 7, 16),
    "01": (4, 10, 13),
    "00": (7, 10, 16),
}
CHANNELS = {
    "q1": {"element": 1, "p_max": F(1, 10), "cost": F(2)},
    "q4": {"element": 4, "p_max": F(1, 5), "cost": F(1)},
}
DELTA = F(1, 20)


def frac(v: F) -> dict:
    z = F(v)
    return {"fraction": str(z), "decimal": float(z)}


def convolution(support, n=N):
    return tuple(sum((a+b)%n == t for a in support for b in support)
                 for t in range(n))


def check_fiber():
    observations = {convolution(s) for s in FIBER.values()}
    assert len(observations) == 1, "The four supports are not square-equivalent"
    for key, s in FIBER.items():
        assert (int(1 in s), int(4 in s)) == (int(key[0]), int(key[1]))
    return next(iter(observations))


def threshold(p: F, risk_inverse: F) -> int:
    """Smallest r where ((1-p)/p)^r >= risk_inverse, using only integers."""
    odds = (1-p) / p
    assert p > 0 and p < F(1,2) and risk_inverse > 1
    r = 0
    while odds**r < risk_inverse:
        r += 1
    return r


def gambler_ruin(p: F, r: int) -> tuple[F, F]:
    """IID Bernoulli-flip rate p, start at zero; stop at +-r.

    Returns (exact wrong-decision probability, expected number of queries).
    """
    assert 0 < p < F(1, 2) and r >= 1
    rho = p / (1-p)
    e = rho**r / (1 + rho**r)
    expected = F(r) * (1-2*e) / (1-2*p)
    return e, expected


def channel_policy(which: str, risk_inverse: F):
    c = CHANNELS[which]
    r = threshold(c["p_max"], risk_inverse)
    e, num = gambler_ruin(c["p_max"],r)
    return {"question": which, "element": c["element"],
            "error_parameter":frac(c["p_max"]),
            "cost_per_query":frac(c["cost"]),
            "likelihood_ratio_threshold":frac(risk_inverse),
            "net_votes_threshold":r,
            "exact_error_probability_iid":frac(e),
            "expected_queries_iid":frac(num),
            "expected_cost_iid":frac(num*c["cost"])}


def actual_cost_errors(delta=DELTA):
    one = F(1,1) / delta
    two = F(2,1) / delta
    q1 = channel_policy("q1",one)
    q4 = channel_policy("q4",one)
    r1 = channel_policy("q1",two)
    r4 = channel_policy("q4",two)
    e1,n1 = gambler_ruin(CHANNELS["q1"]["p_max"],r1["net_votes_threshold"])
    e4,n4 = gambler_ruin(CHANNELS["q4"]["p_max"],r4["net_votes_threshold"])
    cost = CHANNELS["q1"]["cost"]*n1 + CHANNELS["q4"]["cost"]*n4
    error = 1-(1-e1)*(1-e4)
    return {"target_delta":frac(delta),
            "property_contains_1":q1,
            "property_contains_4":q4,
            "reconstruction":{"first":r1,"second":r4,
                "exact_error_probability_iid":frac(error),
                "expected_queries_iid":frac(n1+n4),
                "expected_cost_iid":frac(cost),
                "uniform_risk_bound_robust":frac(delta)}}


def kl_lower_bound(delta=DELTA):
    """Data processing + Wald KL identities for any delta-correct algorithm.

    This is a *universal lower bound*, not an optimizer or exact minimum.
    """
    d=float(delta)
    kappa=(1-2*d)*math.log((1-d)/d)
    info={q:(1-2*float(c['p_max']))*math.log((1-float(c['p_max']))/float(c['p_max']))
          for q,c in CHANNELS.items()}
    cost_lower=sum(float(CHANNELS[q]['cost'])*kappa/info[q] for q in CHANNELS)
    property_witness=float(F(actual_cost_errors(delta)["property_contains_1"]["expected_cost_iid"]["fraction"]))
    return {"data_processing_kl_bound_nats":kappa,
            "per_probe_information_kl_nats":info,
            "reconstruction_minimax_expected_cost_lower_bound":cost_lower,
            "property_contains_1_valid_strategy_expected_cost_upper_bound":property_witness,
            "lower_bound_minus_property_upper_bound":cost_lower-property_witness,
            "strict_optimal_cost_separation_certified":cost_lower>property_witness}


def negative_controls():
    p1=CHANNELS["q1"]["p_max"]
    p4=CHANNELS["q4"]["p_max"]
    persistent_property=p1
    persistent_full=1-(1-p1)*(1-p4)
    # Miscalibrated but independent Bernoulli flips (the threshold is kept frozen).
    bad_p1=F(1,4); bad_p4=F(7,20)
    policy=actual_cost_errors(DELTA)
    r1=policy["reconstruction"]["first"]["net_votes_threshold"]
    r4=policy["reconstruction"]["second"]["net_votes_threshold"]
    ebad1,_=gambler_ruin(bad_p1,r1)
    ebad4,_=gambler_ruin(bad_p4,r4)
    return {"latent_persistent_flip_per_channel":{
               "description":"one Bernoulli flip per channel, held fixed for all repeats; marginals match the declared rates but conditional bound fails",
               "property_contains_1_actual_error":frac(persistent_property),
               "reconstruction_actual_error":frac(persistent_full)},
            "iid_miscalibration":{
               "actual_p1":frac(bad_p1),"actual_p4":frac(bad_p4),
               "property_contains_1_actual_error":frac(gambler_ruin(bad_p1,policy["property_contains_1"]["net_votes_threshold"])[0]),
               "reconstruction_actual_error":frac(1-(1-ebad1)*(1-ebad4))}}


def verify_transcript(bit: str, responses: list[int], risk_inverse: F, claimed: int) -> dict:
    """Mechanical verifier of ONE sequential bit certificate.

    The certificate establishes a likelihood-ratio threshold GIVEN p_max;
    checking this transcript cannot establish reliability of the oracle.
    """
    if bit not in CHANNELS:raise ValueError("question not admissible")
    if claimed not in (0,1) or any(y not in (0,1) for y in responses):
        raise ValueError("invalid binary response/claim")
    r=threshold(CHANNELS[bit]["p_max"],risk_inverse)
    net=0
    for i,y in enumerate(responses):
        net+=1 if y==1 else -1
        if abs(net)>=r and i != len(responses)-1:
            return {"accepted":False,"reason":"questions continue after first hitting time"}
    final=1 if net>=r else (0 if net<=-r else None)
    accepted= final is not None and final==claimed
    evidence=((1-CHANNELS[bit]["p_max"])/CHANNELS[bit]["p_max"])**abs(net)
    return {"accepted":accepted,"risk_model_threshold":str(risk_inverse),
            "net_votes":net,"net_votes_threshold":r,"computed_verdict":final,
            "evidence_ratio":str(evidence),
            "query_cost":str(F(len(responses))*CHANNELS[bit]["cost"])}


def study():
    sq=check_fiber()
    main=actual_cost_errors()
    lb=kl_lower_bound()
    assert lb["strict_optimal_cost_separation_certified"]
    return {"experiment":"MOD-OBS-03 / 2026-10-11",
            "protocol_sha256":hashlib.sha256(Path(__file__).with_name('PROTOCOL_FREEZE.md').read_bytes()).hexdigest(),
            "scope":"finite four-support n=18 Cayley fiber; risk model, not real source calibration",
            "fiber":{k:list(v) for k,v in FIBER.items()},
            "common_square_convolution":list(sq),
            "assumptions":{"A2":"exact and free in conditional problem",
                "allowed_questions":"q1 and q4 only; repeated with positive unit cost",
                "noise_risk":"conditional error probability <= declared p_max at every query",
                "noise_expected_cost":"IID Bernoulli errors at declared p_max",
                "risk_target":str(DELTA),"no_deterministic_horizon":True},
            "policies":main,
            "universal_reconstruction_lower_bound":lb,
            "negative_controls":negative_controls(),
            "certificate_examples":{
                "property_correct":verify_transcript('q1',[1,0,1,1],1/DELTA,1),
                "property_premature":verify_transcript('q1',[1],1/DELTA,1),
                "property_wrong_claim":verify_transcript('q1',[1,0,1,1],1/DELTA,0),
                "full_first_bit":verify_transcript('q1',[1,1],2/DELTA,1),
                "full_second_bit":verify_transcript('q4',[0,0,0],2/DELTA,0)
            },
            "sensitivity":[actual_cost_errors(d) for d in [F(1,10),F(1,20),F(1,100)]]}


if __name__=='__main__':
    report=study()
    dest=Path(__file__).with_name('results.json')
    dest.write_text(json.dumps(report,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
    print('MOD-OBS-03 protocol_sha256:',report['protocol_sha256'])
    print('Fiber supports:',len(report['fiber']))
    p=report['policies']
    print('Property q1 expected cost:',p['property_contains_1']['expected_cost_iid'])
    print('Reconstruction expected cost:',p['reconstruction']['expected_cost_iid'])
    print('Reconstruction risk:',p['reconstruction']['exact_error_probability_iid'])
    print('Universal reconstruction lower bound:',report['universal_reconstruction_lower_bound'])
    print('Results:',dest)
