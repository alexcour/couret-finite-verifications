#!/usr/bin/env python3
"""Refined-K conditional Q5 probability, keeping historical certificates intact.

Never treats CI as an independent mathematical review or this conditional
model probability as an unconditional prime-number density.
"""
import argparse
import hashlib
import json
from fractions import Fraction as F
from verify_all_tail_bounds import (HERE,INPUTS,SIGNED,MULTIPLICITY,
                                    all_roots,pinned_inputs,low_mass,D)
from certify_q5_probability import compute,need
from certify_refined_K_20261013 import make_report,OUTPUT

NEW_FILE="q5_refined_conditional_probability_20261013.json"


def main():
    parser=argparse.ArgumentParser(description=__doc__)
    modes=parser.add_mutually_exclusive_group()
    modes.add_argument("--check",action="store_true")
    modes.add_argument("--write",action="store_true")
    args=parser.parse_args()

    # Replay mathematical construction, not simply a self-declared JSON.
    refined=make_report()
    raw=OUTPUT.read_bytes()
    canonical=(json.dumps(refined,indent=2,sort_keys=True)+"\n").encode()
    need(raw==canonical,"refined K receipt not equal to exact recomputation")
    data=pinned_inputs()
    roots=all_roots(data["q15_root_interval_certificate_20261012.json"],
                    data["q3_q5_root_interval_certificate_20261013.json"])
    base=json.loads((HERE/"all_tail_bounds_20261013.json").read_text())
    epsilon=F(base["profiles"]["Q5"]["uniform_threshold_probability_error_upper"]["upper_exact"])
    lo=hi=F(0)
    p2=F(0)
    residuals={}
    for key,(labels,factor) in SIGNED.items():
        old_row=data["spectral_constants_certificate_20261012.json"]["analytic_constants"][key]["K"]
        new_row=refined["analytic_constants"][key]["K"]
        old_low=F(int(old_row["lower_integer"]),int(old_row["denominator"]))
        old_high=F(int(old_row["upper_integer"]),int(old_row["denominator"]))
        kl=F(int(new_row["lower_integer"]),int(new_row["denominator"]))
        kh=F(int(new_row["upper_integer"]),int(new_row["denominator"]))
        need(old_low<=kl<=kh<=old_high,"new K interval escaped original")
        slow,shigh=low_mass(roots,labels,F(factor))
        rl,rh=kl-shigh,kh-slow
        need(0<rl<=rh,"nonpositive residual")
        residuals[key]=[str(rl),str(rh)]
        boost=9 if key=="0,2" else 1
        mult=MULTIPLICITY[key]
        lo+=mult*boost*rl
        hi+=mult*boost*rh
        p2+=F(8,D)*mult*boost*boost*rh

    # Known comparison theorem with same phase witness:
    # epsilon_refined = P2_refined * I/96 (P2 exact upper)
    witness=F(base["profiles"]["Q5"]["integral_t_cubed_envelope_upper_exact"])
    improved_epsilon=p2*witness/96
    need(0<improved_epsilon<=epsilon,"refined comparison worsened the old rigorous bound")
    need(F(7,10)<lo<=hi<1,"refined W outside proved Simpson/exp range")
    ords=[]
    for source in ("q15_root_interval_certificate_20261012.json",
                   "q3_q5_root_interval_certificate_20261013.json"):
        for row in data[source]["root_intervals"]:
            a,b=F(row["imaginary_lower_exact"]),F(row["imaginary_upper_exact"])
            center=F(row["seed"])
            need(a<=center<=b and b-a==F(2,10**30),"untrusted zero center")
            ords.append((row["character"],row["index_1based"],center,
                         9 if row["character"]=="5.4" else 1))
    computed=compute(ords,lo,hi,improved_epsilon)
    # Construct a strict outward decimal review interval from computed exact
    # fractions, avoiding an invented rounded point or fragile hardcoded claim.
    pmin,pmax=map(F,computed["p_conditional_exact"])
    need(pmin>F("0.2864") and pmax<F("0.2927"),
         "refined probability outside previously documented safe range")
    report={
        "id":"CU-BRUIT-Q5-REFINED-CONDITIONAL-20261013",
        "source_refined_K_sha256":hashlib.sha256(raw).hexdigest(),
        "source_original_K_sha256":INPUTS["spectral_constants_certificate_20261012.json"],
        "input_sha256":INPUTS,
        "signed_residuals":residuals,
        "W_exact_bounds":[str(lo),str(hi)],
        "W_decimal_outer":computed["W_bounds"],
        "P2_refined_upper_exact":str(p2),
        "uniform_replacement_error_refined_exact":str(improved_epsilon),
        "uniform_replacement_error_refined_decimal_upper":
            __import__("certify_q5_probability").outward(improved_epsilon,True),
        "full_Q5_probability":computed,
        "conditional_on_GRH_and_independent_phases":True,
        "conditional_on_Arb_and_analytic_input_certificates":True,
        "independent_review_completed":False,
        "prime_density_inconditional":False
    }
    rendered=json.dumps(report,indent=2,sort_keys=True)+"\n"
    fixture=HERE/NEW_FILE
    if args.write:
        fixture.write_text(rendered,encoding="utf-8",newline="")
    if args.check:
        need(fixture.read_bytes()==rendered.encode(),
             "refined Q5 receipt differs from rational recomputation")
    print(rendered,end="")


if __name__=="__main__":
    try: main()
    except (ValueError,AssertionError,KeyError,TypeError,OSError,ZeroDivisionError) as e:
        raise SystemExit("FAIL CLOSED: "+str(e))
