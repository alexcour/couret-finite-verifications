#!/usr/bin/env python3
"""Rigorous finite-horizon T=4 Q5 sign mixing (two phases, not 67).

A *direct* rational Haar-sign computation on [0,pi]^2 is compared with
the existing independently replayed finite-time sign occupation. Both
are the SAME height-4 trigonometric polynomial, not the full 67-phase
law. A truncated Fourier-mode/Delta bound is not used: this proves a
finite-horizon discrepancy by direct enclosure, NOT a uniform rate.

The proof of the cosine recurrence's error is in
Q5_T4_DIRECT_HAAR_SIGN_20261013.md. Requires the pinned internal
root isolations and the earlier finite-time interval receipt; it does
not re-audit FLINT/Arb or the sign-occupation interval backend.
"""
import argparse
import hashlib
import json
from fractions import Fraction as Q
from math import factorial, isqrt
from pathlib import Path

HERE=Path(__file__).resolve().parent
S=10**38
M=8192
ROOT_SHA={
  "q15_root_interval_certificate_20261012.json":
    "b694a1e8382b25fb3843f80854721a9c569377344d7818e10fb85f5f9c5ff684",
  "q3_q5_root_interval_certificate_20261013.json":
    "5284f66aca1ae9c8df2986214c33020d14fd082840c6e4c8ad9829101545340f",
}
RECEIPT="t4_haar_sign_discrepancy_20261013.json"


def need(condition,message):
    if not condition:
        raise ValueError(message)


def ceildiv(a,b):
    need(b>0,"division by nonpositive integer")
    return -((-a)//b)


def ceilq(q):
    return ceildiv(q.numerator,q.denominator)


def atan_interval(q,n):
    """Exact alternating arctangent with outward first omitted term."""
    x=Q(1,q)
    val=sum(((-1)**k * x**(2*k+1)/(2*k+1) for k in range(n)),Q(0))
    next_term=(-1)**n*x**(2*n+1)/(2*n+1)
    return min(val,val+next_term),max(val,val+next_term)


def pi_interval():
    a,b=atan_interval(5,40),atan_interval(239,12)
    lo,hi=16*a[0]-4*b[1],16*a[1]-4*b[0]
    need(3<lo<hi<Q(22,7),"Machin pi interval failed")
    return lo,hi


def cosine_delta_interval(m):
    """Outward cos(pi/m) using alternating Taylor and monotonicity."""
    need(isinstance(m,int) and m>=128 and (m & (m-1))==0,
         "grid must be a power of two and >=128")
    pl,ph=pi_interval()
    a,b=pl/m,ph/m
    need(Q(0)<a<=b<Q(1,16),"cosine series argument not small")
    lo=sum(((-1)**k*b**(2*k)/factorial(2*k) for k in range(8)),Q(0))
    hi=sum(((-1)**k*a**(2*k)/factorial(2*k) for k in range(9)),Q(0))
    need(Q(0)<lo<hi<1,"cosine delta enclosure failed")
    return lo,hi


def integer_cosine_grid(m):
    """Scale-S cosine grid with proven O(m^2/S) absolute recurrence error.

    If c=cos(pi/m), q integer/S approx c, cos(k*pi/m)=T_k(c).
    Chebyshev Markov bound |T'_k(x)|<=k^2 for x in [-1,1].
    For recurrence rounded by floor, each step has error <1/S; its
    propagation through U_j(q) has |U_j(q)|<=j+1 for |q|<=1.
    Thus the scaled absolute error at index k is at most
       k^2*ceil(S*|c-q|) + k*(k-1)/2.
    """
    lo,hi=cosine_delta_interval(m)
    centre=(lo+hi)/2
    qnum=(centre.numerator*S)//centre.denominator
    q=Q(qnum,S)
    delta=ceilq(S*max(abs(q-lo),abs(hi-q)))
    need(0<qnum<S and 0<=delta<=2,"cosine first-step precision failed")
    approximations=[S,qnum]
    for k in range(1,m):
        approximations.append((2*qnum*approximations[-1])//S-
                              approximations[-2])
    bounds=[]
    for k,v in enumerate(approximations):
        err=k*k*delta+k*(k-1)//2
        low=max(-S,v-err)
        high=min(S,v+err)
        need(-S<=low<=high<=S,"cosine enclosure invalid")
        bounds.append((low,high))
    # Exact periodic values, independent of recurrence quality.
    bounds[0]=(S,S)
    bounds[m]=(-S,-S)
    need(all(bounds[k][0]>=bounds[k+1][0] and
             bounds[k][1]>=bounds[k+1][1] for k in range(m)),
         "monotone cosine grid not certified")
    need(bounds[m//2][0]<=0<=bounds[m//2][1],
         "cos(pi/2) not contained")
    return bounds,delta


def sqrt_integer_bounds(x):
    """Outward integer-scaled sqrt(x), no floating-point constants."""
    need(x>0,"nonpositive amplitude square")
    N=x.numerator*S*S//x.denominator
    a=isqrt(N)
    b=a if a*a*x.denominator==x.numerator*S*S else a+1
    need(a*a*x.denominator<=x.numerator*S*S<=b*b*x.denominator,
         "square root bound not enclosing")
    return (a,b)


def pinned_t4_roots():
    chosen={}
    for name,sha in ROOT_SHA.items():
        raw=(HERE/name).read_bytes()
        need(hashlib.sha256(raw).hexdigest()==sha,"root receipt SHA changed")
        data=json.loads(raw)
        need(data["global_GRH_or_LI_proved"] is False and
             data["prime_race_density_certified"] is False and
             data["conditional_on_trusted_Arb_backend_and_written_argument"] is True,
             "root trust boundary removed")
        for row in data["root_intervals"]:
            a,b=Q(row["imaginary_lower_exact"]),Q(row["imaginary_upper_exact"])
            if a<4<b:
                raise ValueError("root crosses height 4")
            if b>=4:
                continue
            key=(row["character"],row["index_1based"])
            need(key not in chosen and a>0 and b-a==Q(2,10**30),
                 "invalid T=4 root isolation")
            chosen[key]=(a,b)
    need(set(chosen)=={("15.2",1),("15.14",1)},
         "unexpected number, label or rank of T=4 roots")
    return chosen


def amplitudes(chosen):
    # The actual T=4 signal has coefficients -1 on both low roots:
    #  -1 + sum_j 2*(cos(theta_j)/2+gamma_j sin(theta_j))/
    #                             (1/4+gamma_j^2).
    # A phase rotation converts each into r_j*cos(phi_j),
    # r_j=2/sqrt(1/4+gamma_j^2). Haar is phase-translation invariant.
    bounds=[]
    for key in sorted(chosen):
        a,b=chosen[key]
        r2lo=Q(4)/(Q(1,4)+b*b)
        r2hi=Q(4)/(Q(1,4)+a*a)
        al=sqrt_integer_bounds(r2lo)[0]
        ah=sqrt_integer_bounds(r2hi)[1]
        need(0<al<=ah<S,"amplitude outside positive unit range")
        bounds.append((key,al,ah))
    need(sum(x[2] for x in bounds)>S,
         "T=4 sign probability unexpectedly identically zero")
    return bounds


def interval_product(amplitude,cos_interval):
    al,ah=amplitude
    cl,ch=cos_interval
    products=(al*cl,al*ch,ah*cl,ah*ch)
    return min(products),max(products)


def signed_sign_range(amplitudes,cos_a,cos_b):
    a=interval_product(amplitudes[0],cos_a)
    b=interval_product(amplitudes[1],cos_b)
    return a[0]+b[0]-S*S,a[1]+b[1]-S*S


def grid_area(m=M):
    chosen=pinned_t4_roots()
    amps=amplitudes(chosen)
    c,delta=integer_cosine_grid(m)
    a=[x[1:] for x in amps]
    positive=negative=unknown=0
    for i in range(m):
        # Every cell [i,i+1]x[j,j+1] is positive if its lower right
        # corner lower enclosure is positive; negative if the upper
        # left corner upper enclosure is nonpositive.
        left=0;right=m
        while left<right:
            j=(left+right)//2
            signlo,_=signed_sign_range(a,c[i+1],c[j+1])
            if signlo>0:left=j+1
            else:right=j
        pos=left
        left=0;right=m
        while left<right:
            j=(left+right)//2
            _,signhi=signed_sign_range(a,c[i],c[j])
            if signhi>0:left=j+1
            else:right=j
        neg=m-left
        need(0<=pos<=m and 0<=neg<=m and pos+neg<=m,
             "cell partition contradictory")
        positive+=pos;negative+=neg;unknown+=m-pos-neg
    need(positive+negative+unknown==m*m,
         "certified rectangle accounting incomplete")
    pl=Q(positive,m*m)
    ph=Q(positive+unknown,m*m)
    need(Q("0.085")<pl<=ph<Q("0.100"),
         "unexpected two-phase Haar sign occupation")
    need(unknown < m*m//100,
         "unresolved Haar mass exceeds 1 percent")
    return pl,ph,dict(grid=m,positive_cells=positive,
          nonpositive_cells=negative,unresolved_cells=unknown,
          unresolved_fraction_exact=str(Q(unknown,m*m)),
          cosine_chebyshev_c_error_integer=delta,
          root_labels=[list(x[0]) for x in amps],
          amplitude_integer_intervals=[[str(x[1]),str(x[2])] for x in amps],
          precision_scale=str(S))


def finite_occupation():
    d=json.loads((HERE/"finite_sign_transport_20261013.json").read_bytes())
    need(d["prime_argument_upper"]==65536 and
         d["time_occupation_identified_with_Haar_or_independent_phase_law"] is False
         and d["unresolved_cells_counted_in_all_upper_bounds"] is True
         and d["independent_human_review_claimed"] is False,
         "previous finite-trajectory statement not in scope")
    row=d["profiles"]["4"]
    need(row["phases"]==2 and
         row["cells"]["unresolved"]==11 and
         row["maximum_depth_used"]<=8,
         "T=4 path witness no longer matches")
    lo,hi=map(Q,row["measures"]["spectral_positive_occupation"]["exact"])
    need(Q("0.133751")<=lo<=hi<=Q("0.133776"),
         "time occupation escaped prior interval")
    return lo,hi


def outward(x,upper=False,digits=6):
    q=10**digits
    n=x.numerator*q//x.denominator
    if upper and Q(n,q)<x:n+=1
    sign="-" if n<0 else ""
    return sign+str(abs(n)//q)+"."+str(abs(n)%q).zfill(digits)


def report(m=M):
    pl,ph,detail=grid_area(m)
    tl,th=finite_occupation()
    signedlo,signedhi=tl-ph,th-pl
    need(Q(0)<signedlo<=signedhi<Q(1,10),
         "finite T=4 mixing discrepancy not positively isolated")
    return {
      "id":"CU-BRUIT-T4-DIRECT-HAAR-SIGN-MIXING-20261013",
      "method":"rational Chebyshev grid on Haar T2 and pinned finite-time sign cover",
      "height_cutoff":4,
      "number_of_phases":2,
      "positive_haar_probability_exact":[str(pl),str(ph)],
      "positive_haar_probability_outer":[outward(pl),outward(ph,True)],
      "finite_time_positive_probability_exact":[str(tl),str(th)],
      "finite_time_positive_probability_outer":[outward(tl),outward(th,True)],
      "finite_time_minus_haar_sign_probability_exact":[str(signedlo),str(signedhi)],
      "finite_time_minus_haar_sign_probability_outer":
        [outward(signedlo),outward(signedhi,True)],
      "direct_haar_grid":detail,
      "finite_mode_gap_4_64_proved_elsewhere_not_used":True,
      "root_enclosures_and_finite_sign_receipt_trusted":True,
      "global_GRH_LI_ELI_or_effective_67_phase_mixing_proved":False,
      "uniform_in_horizon_rate_proved":False,
      "full_67_phase_probability_approximated_by_this_proof":False,
      "arithmetic_prime_race_density_proved":False,
      "external_independent_review_completed":False
    }


def main():
    p=argparse.ArgumentParser(description=__doc__)
    mode=p.add_mutually_exclusive_group()
    mode.add_argument("--write",action="store_true")
    mode.add_argument("--check",action="store_true")
    p.add_argument("--grid",type=int,default=M)
    args=p.parse_args()
    result=report(args.grid)
    rendered=json.dumps(result,indent=2,sort_keys=True)+"\n"
    receipt=HERE/RECEIPT
    if args.write:
        receipt.write_text(rendered,encoding="utf-8",newline="")
    if args.check:
        need(args.grid==M,"noncanonical T=4 grid cannot check pinned receipt")
        need(receipt.read_bytes()==rendered.encode(),
             "T=4 Haar sign receipt differs from exact reconstruction")
    print(rendered,end="")


if __name__=="__main__":
    try: main()
    except (ValueError,KeyError,TypeError,OSError,ZeroDivisionError,AssertionError) as exc:
        raise SystemExit("FAIL CLOSED: "+str(exc))
