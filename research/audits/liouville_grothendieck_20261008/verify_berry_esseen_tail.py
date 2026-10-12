#!/usr/bin/env python3
"""CU-BRUIT-02: Berry--Esseen bound for an independent-phase spectral tail.

This is a classical probability inequality, not a certified zero catalogue,
a proof of GRH/LI, or a numerical theorem about prime-race densities.

Reference: I. S. Tyurin, "A Refinement of the Remainder in the Lyapunov
Theorem", Theory Probab. Appl., DOI 10.1137/S0040585X9798572X.
Non-i.i.d. Berry--Esseen constant 0.5591 is reported there. We use 0.56.
"""
import argparse
import json
import math

C_BE = 0.56


def variance(b):
    """Var(2*b*cos(U)) where U is uniform on [0,2*pi)."""
    assert b >= 0 and math.isfinite(b)
    return 2.0*b*b


def third_abs(b):
    """E[|2*b*cos(U)|^3] = (32/(3*pi))*b^3."""
    assert b >= 0 and math.isfinite(b)
    return 32.0*b**3/(3.0*math.pi)


def finite_tail_bound(amplitudes):
    """Berry--Esseen sum bound and easier maximal-amplitude upper bound."""
    amps = tuple(amplitudes)
    if not amps or any(a < 0 or not math.isfinite(a) for a in amps):
        raise ValueError("Provide a nonempty list of nonnegative finite amplitudes.")
    V = math.fsum(variance(a) for a in amps)
    if V <= 0:
        raise ValueError("Positive variance required.")
    third_sum = math.fsum(third_abs(a) for a in amps)
    be = C_BE*third_sum/(V**1.5)
    envelope = C_BE*16.0/(3.0*math.pi)*max(amps)/math.sqrt(V)
    assert be <= envelope*(1+1e-12)
    return {"tail_variance":V, "third_abs_moment_sum":third_sum,
            "berry_esseen_bound":min(1.0,be),
            "max_amplitude_envelope":min(1.0,envelope)}


def cutoff_envelope(T, valid_tail_variance_lower_bound, max_abs_coefficient=3.0):
    """Theorem conditional on the independence model and a VALID V lower bound.

    If gamma>T and b=|c_chi|/hypot(gamma,0.5), then
    b <= max_abs_coefficient/hypot(T,0.5). A numerical lower bound on V
    must come from separately certified data; no zero counts are checked here.
    """
    V = valid_tail_variance_lower_bound
    if not (math.isfinite(T) and T > 0 and math.isfinite(V) and V > 0
            and math.isfinite(max_abs_coefficient) and max_abs_coefficient > 0):
        raise ValueError("Positive finite T, V and coefficient bound required.")
    M = max_abs_coefficient/math.hypot(T,0.5)
    result = min(1.0,C_BE*16.0/(3.0*math.pi)*M/math.sqrt(V))
    return {"T":T, "sup_tail_amplitude_bound":M,
            "provided_tail_variance_or_lower_bound":V,
            "max_abs_coefficient":max_abs_coefficient,
            "Kolmogorov_and_sign_probability_bound":result,
            "gate":"Conditional on product-phase independence and a CERTIFIED positive lower bound for V_T."}


def self_test():
    assert math.isclose(variance(2.0),8.0)
    assert math.isclose(third_abs(2.0),256.0/(3.0*math.pi))
    for amps in ([0.01,0.02,0.03],[1.0],[0.9,0.1,0.05],[1e-6]*100):
        b=finite_tail_bound(amps)
        assert 0<=b["berry_esseen_bound"]<=b["max_amplitude_envelope"]<=1
    assert cutoff_envelope(30,0.8)["Kolmogorov_and_sign_probability_bound"] < cutoff_envelope(25,0.8)["Kolmogorov_and_sign_probability_bound"]
    assert cutoff_envelope(25,1.0)["Kolmogorov_and_sign_probability_bound"] < cutoff_envelope(25,0.8)["Kolmogorov_and_sign_probability_bound"]
    return "PASS: identities/consistency (NOT a test of Berry--Esseen proof or zeros)."


def main():
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument("--self-test",action="store_true")
    p.add_argument("--illustrative",action="store_true",
                   help="Use exploratory, UNVALIDATED CU-BRUIT-02 T=25 tail variance.")
    args=p.parse_args()
    output={"status":"CONDITIONAL-PROBABILITY-INEQUALITY-ONLY",
            "Berry_Esseen_constant":C_BE,
            "source":"Tyurin, DOI 10.1137/S0040585X9798572X"}
    if args.self_test:
        output["self_test"]=self_test()
    if args.illustrative:
        output["illustration_NOT_CERTIFIED"]=cutoff_envelope(25.0,0.7908925527,3.0)
        output["warning"]="The supplied variance is exploratory: do not report a certified numeric error bound or prime sign density."
    if not(args.self_test or args.illustrative):
        output["formula"]="min(1, 0.56*16/(3*pi) * M_T/sqrt(V_T))"
    print(json.dumps(output,indent=2,sort_keys=True))


if __name__=="__main__":
    main()
