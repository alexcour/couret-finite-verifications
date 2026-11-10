#!/usr/bin/env python3
"""Verified rational cell envelope for all 67 low-phase J0 factors.

Conditional Gaussian replacement of the full q=3/5/15 high-zero tail:
the original error P2/(32*pi)*integral(t^3 |phi_low(t)| dt)
is *rebounded*, not added again. Nonuniform cell bounds use a proven
derivative inequality and a rational J0 enclosure at the cell midpoint.
Beyond t=12, reuse the written universal Bessel power envelope.

This does not certify GRH, LI, Arb receipt validity, or any arithmetic
prime-race density. Root/K validation is delegated to the frozen verifiers.
"""
import argparse
import json
from fractions import Fraction as F
from math import prod

from certify_q5_probability import (
    S, T, compute, j0_bounded, pi_enclosure, outward, need,
)
from verify_q15_tail_bounds import sqrt_bound
from verify_all_tail_bounds import (
    pinned_inputs, all_roots, aggregate, SIGNED, PROFILE_BOOSTS
)
from certify_refined_K_20261013 import make_report

CELLS = 1200
OLD_CUTOFF = F(25)


def ceilfrac(x):
    return -((-x.numerator)//x.denominator)


def upper_mul(a, b):
    """Return ceil(a*b/S) for nonnegative integral, S-scaled a,b."""
    need(0<=a<=S and 0<=b<=S, "out-of-range nonnegative interval factors")
    return (a*b + S-1)//S


def signed_ordinates(roots, receipts):
    """67 independently indexed positive roots; real χ5 alone has v=9."""
    ords=[]
    labels=set()
    for name in ("q15_root_interval_certificate_20261012.json",
                 "q3_q5_root_interval_certificate_20261013.json"):
        for item in receipts[name]["root_intervals"]:
            key=item["character"]
            index=item["index_1based"]
            a,b=F(item["imaginary_lower_exact"]),F(item["imaginary_upper_exact"])
            c=F(item["seed"])
            need(0<a<=c<=b<OLD_CUTOFF and
                 max(c-a,b-c)<=F(1,10**30), "uncertified ordinate center")
            need((a,b)==roots[key][index-1], "signed rank mismatch")
            need((key,index) not in labels, "duplicate signed root")
            labels.add((key,index))
            v=9 if key=="5.4" else 1
            ords.append((key,index,a,b,c,v))
    need(len(ords)==67 and
         sum(1 for o in ords if o[5]==9)==8,
         "incorrect Q5 low-amplitude profile")
    return ords


def amplitude_bounds(ords):
    phases=[]
    for label,index,lo,hi,c,v in ords:
        # r^2 = 4v/(1/4+gamma^2), strictly decreasing on positive gamma.
        r2max=F(4*v)/(F(1,4)+lo**2)
        rmax=sqrt_bound(r2max,upper=True)
        rmin=sqrt_bound(F(4*v)/(F(1,4)+hi**2))
        need(F(0)<rmin<=rmax<F(2),"invalid Q5 amplitude intervals")
        phases.append((label,index,c,v,r2max,rmax,rmin))
    return phases


def cell_integral_upper(phases,cells=CELLS):
    """Bound each cell's entire |phi_Y| using |J0'|<=min(r,r²t/2)."""
    need(isinstance(cells,int) and 100<=cells<=100000,
         "bad verified grid size")
    step=T/cells
    total=F(0)
    worst=0
    for i in range(cells):
        left=step*i
        right=step*(i+1)
        mid=(left+right)/2
        product_hi=S
        for _,_,center,v,r2max,rmax,_ in phases:
            jlo,jhi=j0_bounded(mid,v,center)
            need(-S<=jlo<=jhi<=S,"midpoint Bessel interval outside [-1,1]")
            bound_mid=max(abs(jlo),abs(jhi))
            # J0(r*t)=E cos(r*t*cosθ):
            # |d/dt J0(r*t)|<=r*E|cosθ|<=r
            # and <=r²*t*E(cos²θ)=r²*t/2, for t>=0.
            # This derivative bound is uniform on [left,right].
            drift=min(rmax,r2max*right/2)*(step/2)
            bump=ceilfrac(drift*S)
            factor=min(S,bound_mid+bump)
            product_hi=upper_mul(product_hi,factor)
        worst=max(worst,product_hi)
        # t^3 is positive, so the cell integral is bounded exactly.
        total+=F(product_hi,S)*(right**4-left**4)/4
    return total,worst


def power_tail_upper(phases):
    """For t>=T, select a finite witness for |prod J0(r_j t)|<=C/t^m."""
    lowers=sorted((x[6] for x in phases),reverse=True)
    need(len(lowers)==67 and lowers[-1]>0,"incomplete tail witnesses")
    candidates=[]
    for n in range(10,67,2):
        m=n//2
        C=sqrt_bound(F(2,3)**n/prod(lowers[:n]),upper=True)
        # Integral_T^infinity t^(3-m) dt = T^(4-m)/(m-4).
        integral=C*T**(4-m)/(m-4)
        candidates.append((integral,n,m,C))
    val,n,m,C=min(candidates)
    need(val>=0 and m>4,"invalid high-frequency tail proof")
    return val,n,m,C


def certified_envelope(phases,cells=CELLS):
    finite,top=cell_integral_upper(phases,cells)
    tail,n,m,C=power_tail_upper(phases)
    return finite+tail, {
        "cells":cells, "integral_from_0_to_12_upper_exact":str(finite),
        "integral_from_12_to_infinity_upper_exact":str(tail),
        "total_integral_t_cubed_envelope_upper_exact":str(finite+tail),
        "maximum_grid_factor_upper_exact":str(F(top,S)),
        "power_witness_phases":n, "power_decay_exponent":m,
        "power_constant_upper_exact":str(C),
    }


def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--cells",type=int,default=CELLS)
    args=parser.parse_args()
    need(PROFILE_BOOSTS["Q5"]==("0,2",9),"Q5 Fourier normalization changed")
    data=pinned_inputs()
    roots=all_roots(data["q15_root_interval_certificate_20261012.json"],
                    data["q3_q5_root_interval_certificate_20261013.json"])
    ords=signed_ordinates(roots,data)
    phases=amplitude_bounds(ords)
    refined=make_report()
    base=aggregate(data["q15_root_interval_certificate_20261012.json"],
                   data["q3_q5_root_interval_certificate_20261013.json"],
                   refined)
    p=base["profiles"]["Q5"]
    wlo,whi=(F(p["conditional_full_tail_variance"][k]) for k in
             ("lower_exact","upper_exact"))
    p2=F(p["conditional_full_tail_P2_upper"]["upper_exact"])
    old_eps=F(p["uniform_threshold_probability_error_upper"]["upper_exact"])
    old_I=F(p["integral_t_cubed_envelope_upper_exact"])
    integral,detail=certified_envelope(phases,args.cells)
    need(integral<old_I,"new bound did not improve old envelope")
    pi_lower,_=pi_enclosure()
    # Full-tail characteristic-function telescoping:
    # |phi_Z-phi_G|<=P2*t^4/32. Fourier inversion divided by t:
    # sup_a |Pr(Y+Z>a)-Pr(Y+G>a)|<=P2*I/(32*pi).
    eps=p2*integral/(32*pi_lower)
    need(0<eps<old_eps,"new bound does not improve previous error")
    low=[(k,i,c,v) for k,i,a,b,c,v in ords]
    answer=compute(low,wlo,whi,eps)
    a,b=map(F,answer["p_conditional_exact"])
    need(F("0.287841")<a<b<F("0.291037"),
         "improved Q5 interval must lie inside preceding interval")
    record={
        "id":"CU-BRUIT-02-Q5-67-BESSEL-ENVELOPE-20261013",
        "status":"CONDITIONAL_RATIONAL_CELL_ENCLOSURE_INTERNAL",
        "scope":"All seven-character zero tail above 25 and all 67 low phases",
        "original_replacement_error_upper":outward(old_eps,True,9),
        "new_replacement_error_upper":outward(eps,True,9),
        "new_replacement_error_exact":str(eps),
        "original_integral_envelope_exact":str(old_I),
        "new_envelope":detail,
        "tail_variance_outer":p["conditional_full_tail_variance"]["decimal_outer_bounds"],
        "low_phases":len(phases),
        "p2_upper":p["conditional_full_tail_P2_upper"]["decimal_upper_bound"],
        "p_gaussian_endpoints_outer":{
            "low":answer["p_gaussian_at_Wlo_outer"],
            "high":answer["p_gaussian_at_Whi_outer"],
        },
        "conditional_probability_outer":answer["p_conditional_outer"],
        "conditional_probability_exact":[str(a),str(b)],
        "integral_quadrature_errors":answer["quadrature_integral_errors"],
        "integral_truncation_errors":answer["integral_tail_errors"],
        "requires_GRH":True,
        "requires_independent_uniform_phases":True,
        "internal_root_certificates_trusted":True,
        "independent_external_review":False,
        "arithmetic_prime_density_certified":False,
    }
    print(json.dumps({k:v for k,v in record.items()
                      if k!="conditional_probability_exact"},indent=2,sort_keys=True))


if __name__=="__main__":
    try:
        main()
    except (ValueError,TypeError,KeyError,OSError,AssertionError,ZeroDivisionError) as exc:
        raise SystemExit("FAIL CLOSED: "+str(exc))
