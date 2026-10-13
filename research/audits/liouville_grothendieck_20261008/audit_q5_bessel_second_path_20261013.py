#!/usr/bin/env python3
"""Second-path rational check of the Q5 low-phase Bessel envelope.

This code intentionally DOES NOT import the first Bessel verifier, its J0
interval evaluator, its cell derivative bound, its square-root arithmetic,
or its Fourier inversion. Instead it encloses the entire range of the
Bessel *argument* u=v*t^2/(1/4+gamma^2) on each cell, evaluates J0(2sqrt u)
at the rational middle of that argument range using its own signed-series
fixed-point interpreter, and uses the proved global u-Lipschitz constant 1.
The t>12 bound assumes the published Landau Bessel inequality
sup_{x>0} sqrt(x)*abs(J0(x)) = sqrt(2/pi) (nu=0), hence pi>3 implies
abs(J0(x)) <= sqrt(2/(3*x)).

The original FLINT/Arb root receipts are trusted as inputs, NOT independently
recomputed. P2<=0.056303 is a rounded-up input from the refined K CI.
No GRH, LI, arithmetic density or human independence is asserted.
"""
import argparse
import hashlib
import json
from fractions import Fraction as Q
from math import factorial, isqrt, prod
from pathlib import Path

HERE=Path(__file__).resolve().parent
S=10**40
SERIES_N=48
T=Q(12)
EXPECTED_SHA={
    "q15_root_interval_certificate_20261012.json":
        "b694a1e8382b25fb3843f80854721a9c569377344d7818e10fb85f5f9c5ff684",
    "q3_q5_root_interval_certificate_20261013.json":
        "5284f66aca1ae9c8df2986214c33020d14fd082840c6e4c8ad9829101545340f",
}
COUNTS={"3.2":6,"5.2":8,"5.4":8,"5.3":8,"15.2":12,"15.14":13,"15.8":12}
P2_UPPER=Q("0.056303")    # original refined-K source / independently check in its own task
PREVIOUS_EPS=Q("0.000175363") # previously reported Bessel upper, NOT an axiom


def check(condition, message):
    if not condition:
        raise ValueError(message)


def ceil_ratio(n,d):
    check(d>0,"nonpositive denominator")
    return -((-n)//d)


def positive_frac_sqrt(q,up=False,precision=10**20):
    check(q>0, "square-root argument not positive")
    scale=precision**2
    n=isqrt(q.numerator*scale//q.denominator)
    if up and n*n*q.denominator < q.numerator*scale:
        n+=1
    out=Q(n,precision)
    check(out*out>=q if up else out*out<=q,"rounded root invalid")
    return out


def load_inputs(root=HERE):
    rows=[]
    for filename,digest in EXPECTED_SHA.items():
        raw=(root/filename).read_bytes()
        check(hashlib.sha256(raw).hexdigest()==digest,
              "root receipt changed: "+filename)
        d=json.loads(raw)
        check(d["global_GRH_or_LI_proved"] is False and
              d["prime_race_density_certified"] is False,"global-claim regression")
        rows+=d["root_intervals"]
    counts={label:0 for label in COUNTS}
    phases=[]
    for row in rows:
        label=row["character"]
        check(label in counts,"unknown spectral label")
        counts[label]+=1
        check(row["index_1based"]==counts[label],"incorrect signed character rank")
        a=Q(row["imaginary_lower_exact"])
        b=Q(row["imaginary_upper_exact"])
        check(Q(2)<a<b<25 and b-a==Q(2,10**30),"bad root isolation")
        check(row["existence_on_critical_line"] is True and
              row["unique_simple_zero_in_rectangle"] is True,
              "root witness not isolated and simple")
        v=9 if label=="5.4" else 1
        # u=v*t^2/(1/4+gamma^2); both are exact rational enclosures.
        a_coefficient=Q(v)/(Q(1,4)+b*b)
        b_coefficient=Q(v)/(Q(1,4)+a*a)
        check(0<a_coefficient<=b_coefficient, "invalid phase coefficients")
        phases.append((label,row["index_1based"],v,
                       a_coefficient,b_coefficient))
    check(counts==COUNTS and len(phases)==67,
          "67 low phases / seven signed channels not matched")
    return phases


def series_at_argument(u):
    """Fractional enclosure for J0(2sqrt(u)), wholly independent implementation.

    The omitted term after k=48 is <=32^49/49!^2<1e-40; after
    k>=49 the term magnitudes decrease for all 0<=u<=32.
    All individual term bounds are rounded outward to denominator S.
    """
    check(Q(0)<=u<=32,"J0 argument exceeds proved series range")
    check(S*32**(SERIES_N+1)<factorial(SERIES_N+1)**2,
          "Bessel Taylor remainder not less than scale")
    low=high=S
    lower_term=upper_term=S
    for k in range(1,SERIES_N+1):
        denominator=u.denominator*k*k
        lower_term=(lower_term*u.numerator)//denominator
        upper_term=ceil_ratio(upper_term*u.numerator,denominator)
        if k&1:
            low-=upper_term
            high-=lower_term
        else:
            low+=lower_term
            high+=upper_term
    next_upper=ceil_ratio(upper_term*u.numerator,
                          u.denominator*(SERIES_N+1)**2)
    # This may be smaller than the generic <1/S bound, but both are valid.
    check(next_upper<=2,"Bessel tail unexpectedly large")
    low=max(-S,low-next_upper)
    high=min(S,high+next_upper)
    check(-S<=low<=high<=S,"polynomial enclosure inconsistent")
    return low,high


def grid_bound(phases,cells):
    check(isinstance(cells,int) and 100<=cells<=20000,
          "cell count outside tested complexity range")
    h=T/cells
    integral=Q(0)
    for k in range(cells):
        a=h*k; b=h*(k+1)
        aa=a*a;bb=b*b
        upper_prod=S
        for _,_,_,cmin,cmax in phases:
            umin=cmin*aa
            umax=cmax*bb
            center=(umin+umax)/2
            drift=(umax-umin)/2
            lo,hi=series_at_argument(center)
            abs_center=max(-lo,hi)
            # |d/du J0(2sqrt(u))| <= 1:
            # average_theta |sin(2sqrt(u)cos theta)*cos(theta)|/sqrt(u)
            # <= 2 E(cos(theta)^2)=1. Works at u=0 by continuity.
            certified=min(S,abs_center+ceil_ratio(drift.numerator*S,drift.denominator))
            upper_prod=ceil_ratio(upper_prod*certified,S)
        integral+=Q(upper_prod,S)*(b**4-a**4)/4
    return integral


def power_tail(phases):
    # Landau (2000), v=0, and pi>3 supply the external pointwise theorem.
    # Build all amplitude lower bounds without reusing the original sqrt code.
    amplitudes=[positive_frac_sqrt(4*cmin) for _,_,_,cmin,_ in phases]
    check(min(amplitudes)>0,"a root cannot produce zero amplitude")
    amplitudes.sort(reverse=True)
    candidates=[]
    for n in range(10,67,2):
        m=n//2
        candidate_c=positive_frac_sqrt(Q(2,3)**n/prod(amplitudes[:n]),up=True)
        candidate_integral=candidate_c*T**(4-m)/(m-4)
        candidates.append((candidate_integral,n,m,candidate_c))
    val,n,m,C=min(candidates)
    check(0<val<Q(1,10),"large-frequency tail unexpectedly loose")
    return val,n,m,C


def atan_inverse(n,terms):
    s=sum((Q(-1)**k/(Q(2*k+1)*n**(2*k+1))
           for k in range(terms)),Q(0))
    term=Q(-1)**terms/(Q(2*terms+1)*n**(2*terms+1))
    return min(s,s+term),max(s,s+term)


def lower_pi():
    a,b=atan_inverse(5,35),atan_inverse(239,10)
    lo=16*a[0]-4*b[1]
    hi=16*a[1]-4*b[0]
    check(3<lo<hi<Q(22,7),"rational Machin enclosure for pi invalid")
    return lo


def upper_decimal(frac,digits=9):
    scale=10**digits
    k=ceil_ratio(frac.numerator*scale,frac.denominator)
    return str(k//scale)+"."+str(k%scale).zfill(digits)


def report(cells):
    roots=load_inputs()
    finite=grid_bound(roots,cells)
    tail,n,m,C=power_tail(roots)
    I=finite+tail
    eps=P2_UPPER*I/(32*lower_pi())
    check(0<I<Q(3),"low-phase envelope unreasonable")
    check(0<eps<Q("0.001596446"),
          "independent comparison has not beaten original witness")
    return {
        "status":"SECOND_PATH_RATIONAL_BESSEL_SUBCERTIFICATE",
        "scope":"Gaussian replacement error only, not full sign probability",
        "method":"argument-range cells, fixed-point signed series, u-Lipschitz, Landau tail",
        "number_signed_phases":len(roots),
        "cells":cells,
        "low_frequency_integral_exact":str(finite),
        "high_frequency_integral_exact":str(tail),
        "integral_upper_exact":str(I),
        "tail_witness_count":n,
        "tail_witness_power":m,
        "tail_witness_constant_exact":str(C),
        "P2_used_as_external_upper":"56303/1000000",
        "uniform_error_upper":upper_decimal(eps),
        "independently_reproduces_first_0_000175363_bound":eps<=PREVIOUS_EPS,
        "root_sha256":EXPECTED_SHA,
        "root_completeness_independently_proved":False,
        "global_GRH_or_LI_proved":False,
        "arithmetic_density_certified":False,
        "outside_human_review_completed":False,
    }


def main():
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument("--cells",type=int,default=2400)
    p.add_argument("--check",action="store_true")
    args=p.parse_args()
    result=report(args.cells)
    if args.check:
        check(result["cells"]==2400,"non-standard grid in pinned check")
    print(json.dumps(result,indent=2,sort_keys=True))


if __name__=="__main__":
    try:
        main()
    except (ValueError,AssertionError,KeyError,OSError,ZeroDivisionError) as exc:
        raise SystemExit("FAIL CLOSED: "+str(exc))
