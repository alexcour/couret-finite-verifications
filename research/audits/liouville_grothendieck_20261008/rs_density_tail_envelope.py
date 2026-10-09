#!/usr/bin/env python3
"""Numerical envelope for the Gaussian-tail approximation.

Assumes GRH, LI, and COMPLETENESS of all critical zeros with ordinate <= T.
Quadrature is numerical, not a machine-checked certified integral bound.
"""
import argparse
import json
import math
import numpy as np
from scipy.special import j0, ndtr
from scipy.integrate import simpson

FIRST_J0_ROOT = 2.4048255576957727

def evaluate(data, cutoff=8.0):
    summary, roots = data["summary"], data["zeros"]
    T = summary["T"]
    residual = summary["modeled_tail_variance"]
    total = summary["variance"]
    amplitudes = []
    for key, gammas in roots.items():
        w = 3 if key == "0,2" else 1
        amplitudes.extend(2*w/math.hypot(.5, gamma) for gamma in gammas)
    amplitudes = np.asarray(amplitudes)
    ymax = 6/math.sqrt(T*T+.25)
    if cutoff*ymax >= FIRST_J0_ROOT:
        raise ValueError("Cutoff too large for small-argument log(J0) envelope")
    t = np.linspace(0, cutoff, 16001)
    lowprod = np.ones(t.shape)
    for amplitude in amplitudes:
        lowprod *= j0(amplitude*t)
    # Sum over omitted zeros: log J0(y)+y^2/4 is bounded
    # in modulus by y^4/[64(1-(y/j_01)^2)] for |y|<j_01.
    delta_bound = (9*residual*t**4 /
        (8*(T*T+.25)*(1-(ymax*t/FIRST_J0_ROOT)**2)))
    main_envelope = simpson(
        np.abs(np.sinc(t/np.pi))*np.abs(lowprod)*
        np.exp(-.5*residual*t*t)*delta_bound, x=t)/math.pi
    selected = amplitudes[amplitudes*cutoff > 2/math.pi]
    if len(selected) == 0:
        raise ValueError("Need at least one strong low-zero factor")
    # Standard |J0(z)|<=min(1,sqrt(2/(pi*z))) envelope, z>0;
    # the same bound applies to the true and modeled-tail integrands.
    per_tail_envelope = (2/len(selected))/math.pi * np.prod(
        np.sqrt(2/(math.pi*selected*cutoff)))
    return dict(total_variance=total, gaussian_only_delta=ndtr(-1/math.sqrt(total)),
        gaussian_tail_estimate=summary["sign_density_approximation"]["80"],
        bound_on_0_to_cutoff=float(main_envelope),
        bound_each_integral_tail=float(per_tail_envelope),
        combined_indicator=float(main_envelope+2*per_tail_envelope),
        conditional_warning="Only valid if all lower zeros are known; integrals numerically quadratured, not rigorous certificates.")

def main():
    p=argparse.ArgumentParser()
    p.add_argument("--catalog",required=True)
    p.add_argument("--cutoff",type=float,default=8)
    args=p.parse_args()
    with open(args.catalog, encoding="utf-8") as f:data=json.load(f)
    print(json.dumps(evaluate(data,args.cutoff),indent=2))
if __name__=="__main__":main()
