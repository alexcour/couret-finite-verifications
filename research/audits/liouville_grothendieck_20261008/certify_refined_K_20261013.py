#!/usr/bin/env python3
"""Sharpen five analytic Dirichlet-L K enclosures via two exact Abel summations.

Nonprincipal periodic characters: the first Abel sum is periodic; its
mean gives a main tail term, and its centered sum has bounded partial
sums. Since f=1/x and f=-log(x)/x have eventually one-signed second
derivative, the entire infinite remainder is bounded by one exact
first-difference. The proof is in REFINED_K_AND_Q5_20261013.md.

This reuses the original dyadic interval/log implementation, NOT a
second independently audited log/complex division implementation.
No GRH, LI, zero completeness, or prime density is asserted.
"""
import argparse
import hashlib
import json
from fractions import Fraction as F
from pathlib import Path
from certify_spectral_constants import (
    Interval as I, SCALE, LOG2, LOG_TERMS, REPS, LABELS,
    character, log_rational, log_interval, arctan_reciprocal, ceil_div
)
from verify_all_tail_bounds import HERE, INPUTS, require

CUTOFF = 15000
GAMMA_N = 16384
OUTPUT = HERE / "refined_spectral_constants_20261013.json"
PREVIOUS = "spectral_constants_certificate_20261012.json"


def periodic_abel_stats(a, b, component):
    """Exact mean of the first partial sums and max excursion of the second."""
    q = (3 if a else 1) * (5 if b else 1)
    values = [character(j,a,b)[component] for j in range(1,q+1)]
    require(sum(values)==0, "character is not zero-mean")
    A, running = [], 0
    for x in values:
        running += x
        A.append(running)
    require(running==0, "periodic first primitive does not close")
    mean = F(sum(A),q)
    curr, cmax = F(0), F(0)
    for x in A:
        curr += F(x)-mean
        cmax=max(cmax,abs(curr))
    require(curr==0, "periodic second primitive does not close")
    return q, mean, cmax


def base_function(n, differentiated):
    """Enclosures of f(n) = 1/n or -log(n)/n for positive integers n."""
    return -(log_rational(n)/n) if differentiated else I.rational(1,n)


def refined_tail(a,b,component,differentiated,cutoff=CUTOFF):
    """Full sum n>cutoff, with guaranteed outward dyadic bounds."""
    q,mean,cmax=periodic_abel_stats(a,b,component)
    require(cutoff>=15 and cutoff%q==0,"cutoff not a complete character period")
    # f''(x)=2/x^3>0 for f=1/x. For f=-log(x)/x,
    # f''(x)=(3-2 log x)/x^3<0 for x>=cutoff+1.
    require(log_rational(cutoff+1).lo > 2*SCALE,
            "log sign threshold for derivative monotonicity not certified")
    f1=base_function(cutoff+1,differentiated)
    f2=base_function(cutoff+2,differentiated)
    delta=f1-f2
    # Signed monotonicity is not assumed from floating point: use the
    # elementary derivative formula plus the certified log>2 threshold.
    if differentiated:
        require(delta.hi<0, "derivative-series first difference sign ambiguous")
    else:
        require(delta.lo>0, "L-series first difference sign ambiguous")
    main=I.rational(mean.numerator,mean.denominator)*f1
    radius=ceil_div(cmax.numerator*max(abs(delta.lo),abs(delta.hi)),cmax.denominator)
    full=main.widen(radius)
    return full, {
        "abel_mean_exact":str(mean),
        "second_partial_sum_absolute_max_exact":str(cmax),
        "center_term":main.certificate(),
        "remainder_radius_integer":str(radius),
        "remainder_radius_denominator":str(SCALE),
        "full_tail":full.certificate()
    }


def euler_gamma_precise(n=GAMMA_N):
    """Elementary integral/convexity enclosure without decimal constants.

    D_n=H_n-log n-gamma=sum_{k>=n}(int_k^{k+1} 1/x dx-1/(k+1)).
    Convex trapezoidal upper and tangent lower bounds give
      1/(2(n+1)) <= D_n <= 1/(2n).
    """
    h=I.rational(0)
    for j in range(1,n+1):
        h=h+I.rational(1,j)
    d=I(I.rational(1,2*(n+1)).lo,I.rational(1,2*n).hi)
    gam=h-log_rational(n)-d
    require(gam.lo>0 and gam.hi-gam.lo<SCALE//100000000,
            "Euler gamma enclosure not sufficiently sharp")
    return gam, {"harmonic_cutoff":n, "H_N":h.certificate(),
                 "delta_N_lower_exact":str(F(1,2*(n+1))),
                 "delta_N_upper_exact":str(F(1,2*n)),
                 "gamma":gam.certificate()}


def one_character(a,b,logpi,gamma,cutoff=CUTOFF):
    q=(3 if a else 1)*(5 if b else 1)
    require(cutoff%q==0,"incompatible conductor")
    chars=[character(j,a,b) for j in range(1,q+1)]
    require(sum(x[0] for x in chars)==0 and sum(x[1] for x in chars)==0,
            "nonzero period mean")
    lows=[I.rational(0),I.rational(0)]
    ders=[I.rational(0),I.rational(0)]
    for n in range(1,cutoff+1):
        cr,ci=chars[(n-1)%q]
        if not cr and not ci:
            continue
        inv=I.rational(1,n)
        deriv=-(log_rational(n)/n)
        for j,x in enumerate((cr,ci)):
            if x:
                lows[j]=lows[j]+x*inv
                ders[j]=ders[j]+x*deriv
    tails={}
    for j,name in enumerate(("real","imag")):
        t0,meta0=refined_tail(a,b,j,False,cutoff)
        t1,meta1=refined_tail(a,b,j,True,cutoff)
        lows[j]=lows[j]+t0
        ders[j]=ders[j]+t1
        tails[name]={"L":meta0, "Lp":meta1}
    norm=lows[0].square()+lows[1].square()
    require(norm.lo>0,"L(1,chi) nonvanishing not enclosed")
    quotient=(ders[0]*lows[0]+ders[1]*lows[1])/norm
    K=2*quotient+log_rational(q)-logpi-gamma
    if (a+b)%2==0:
        K=K-2*LOG2
    require(K.lo>0 and K.hi<4*SCALE,"refined K not in positive/real-zero-exclusion region")
    return K,{"label":LABELS[(a,b)],"ab":[a,b],"conductor":q,
              "character_parity":(a+b)%2,"L_real":lows[0].certificate(),
              "L_imag":lows[1].certificate(),"Lp_real":ders[0].certificate(),
              "Lp_imag":ders[1].certificate(),"L_norm_square":norm.certificate(),
              "tails":tails,"K":K.certificate()}


def make_report():
    raw=(HERE/PREVIOUS).read_bytes()
    require(hashlib.sha256(raw).hexdigest()==INPUTS[PREVIOUS],
            "original spectral certificate no longer pinned")
    old=json.loads(raw)
    pi=16*arctan_reciprocal(5,48)-4*arctan_reciprocal(239,8)
    require(pi.lo>3*SCALE, "pi >3 unresolved")
    gamma,gamma_meta=euler_gamma_precise()
    records={}
    for a,b in REPS:
        key=f"{a},{b}"
        K,row=one_character(a,b,log_interval(pi),gamma)
        oldK=old["analytic_constants"][key]["K"]
        require(int(oldK["lower_integer"])<=K.lo<=K.hi<=int(oldK["upper_integer"]),
                "refined K escaped original analytic certificate for "+key)
        require(K.hi-K.lo < (int(oldK["upper_integer"])-int(oldK["lower_integer"]))//100,
                "refined K did not improve original enclosure by factor >100")
        records[key]=row
    assert set(records)=={"1,0","0,2","0,1","1,1","1,2"}
    return {
        "id":"CU-BRUIT-02-C-REFINED-K-20261013",
        "cutoff":CUTOFF, "dyadic_bits":SCALE.bit_length()-1,
        "source_original_sha256":INPUTS[PREVIOUS],
        "gamma_proof":"Convexity/tangent bound on unit intervals; no floating constants",
        "periodic_tail_proof":"Double Abel summation, signed f-second-derivative, bounded second primitive",
        "euler_gamma":gamma_meta,
        "pi":pi.certificate(),
        "analytic_constants":records,
        "GRH_or_LI_proved":False,
        "prime_density_certified":False,
        "independent_log_arithmetic_or_external_review":False
    }


def main():
    parser=argparse.ArgumentParser(description=__doc__)
    mode=parser.add_mutually_exclusive_group()
    mode.add_argument("--write",action="store_true")
    mode.add_argument("--check",action="store_true")
    args=parser.parse_args()
    result=make_report()
    rendered=json.dumps(result,indent=2,sort_keys=True)+"\n"
    if args.write:
        OUTPUT.write_text(rendered,encoding="utf-8",newline="")
    if args.check:
        require(OUTPUT.exists() and OUTPUT.read_bytes()==rendered.encode(),
                "refined K receipt differs from the recomputation")
    print(rendered,end="")


if __name__=="__main__":
    try:
        main()
    except (ValueError,TypeError,KeyError,OSError,AssertionError,ZeroDivisionError) as e:
        raise SystemExit("FAIL CLOSED: "+str(e))
