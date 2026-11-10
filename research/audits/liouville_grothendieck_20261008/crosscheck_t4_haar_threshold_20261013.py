#!/usr/bin/env python3
"""Second rational implementation for the T=4 Haar sign probability.

Condition on theta_1: the second-phase positive angular fraction is
pi^-1 arccos((1-a*cos(theta_1))/b), clipped to [0,1].
Bound it using interval thresholds and monotone cosine-table bisection,
NOT the original square-sign product test or Chebyshev recurrence.

Each cos(k*pi/m) is enclosed independently by its ordinary Taylor
polynomial with exact rational Lagrange remainder. The pi enclosure is
from a direct alternating Machin sum. Root receipts are SHA-pinned.
This is an algorithmically independent trig/geometry cross-check only:
Arb roots and the model definition are still shared premises.
"""
import argparse
import hashlib
import json
from fractions import Fraction as Q
from math import factorial,isqrt
from pathlib import Path

HERE=Path(__file__).resolve().parent
GRID=2048
DEN=10**32
INPUTS={
    "q15_root_interval_certificate_20261012.json":
       "b694a1e8382b25fb3843f80854721a9c569377344d7818e10fb85f5f9c5ff684",
    "q3_q5_root_interval_certificate_20261013.json":
       "5284f66aca1ae9c8df2986214c33020d14fd082840c6e4c8ad9829101545340f",
}


def require(test,message):
    if not test:
        raise ValueError(message)


def atan_pair(q,terms):
    value=Q(0)
    for k in range(terms):
        value+=Q((-1)**k,(2*k+1)*q**(2*k+1))
    remainder=Q((-1)**terms,(2*terms+1)*q**(2*terms+1))
    return min(value,value+remainder),max(value,value+remainder)


def pi_pair():
    a,b=atan_pair(5,35),atan_pair(239,12)
    lo,hi=16*a[0]-4*b[1],16*a[1]-4*b[0]
    require(Q(3)<lo<hi<Q(22,7) and hi-lo<Q(1,10**35),
            "Machin pi enclosure does not close")
    return lo,hi


def cos_table(n):
    require(n>=256 and n<=8192 and n%2==0,"unsupported independent grid")
    plo,phi=pi_pair()
    mid=(plo+phi)/2
    half=(phi-plo)/2
    table=[]
    for k in range(n+1):
        x=mid*k/n
        x2=x*x
        power=Q(1)
        val=Q(1)
        # Taylor through degree 42. Lagrange remainder <= x^44/44!
        for j in range(1,22):
            power=power*x2/Q((2*j-1)*(2*j))
            val+=(-1)**j*power
        rem=power*x2/Q(43*44)
        uncertainty=rem+half*k/n
        table.append((max(Q(-1),val-uncertainty),
                      min(Q(1),val+uncertainty)))
    table[0]=(Q(1),Q(1))
    table[n]=(Q(-1),Q(-1))
    require(all(a<=b for a,b in table),"bad cosine boxes")
    require(all(table[k][0]>=table[k+1][0] and
                table[k][1]>=table[k+1][1] for k in range(n)),
            "cosine monotonicity not independently enclosed")
    return table


def lower_sqrt(z):
    require(z>0,"sqrt of nonpositive rational")
    k=isqrt(z.numerator*DEN**2//z.denominator)
    require(Q(k,DEN)**2<=z,"sqrt floor error")
    return Q(k,DEN)


def upper_sqrt(z):
    k=lower_sqrt(z)*DEN
    k=int(k)
    if Q(k,DEN)**2<z:
        k+=1
    require(z<=Q(k,DEN)**2,"sqrt ceiling error")
    return Q(k,DEN)


def amplitudes():
    boxes={}
    for filename,sha in INPUTS.items():
        raw=(HERE/filename).read_bytes()
        require(hashlib.sha256(raw).hexdigest()==sha,"root input digest mismatch")
        d=json.loads(raw)
        require(d["conditional_on_trusted_Arb_backend_and_written_argument"]
                and not d["global_GRH_or_LI_proved"]
                and not d["prime_race_density_certified"],
                "root evidence trust boundary changed")
        for row in d["root_intervals"]:
            lo,hi=Q(row["imaginary_lower_exact"]),Q(row["imaginary_upper_exact"])
            require(lo<hi and hi-lo==Q(2,10**30),"untrusted root width")
            if lo<4<hi:
                raise ValueError("root inclusion ambiguous at height 4")
            if hi<4:
                key=(row["character"],row["index_1based"])
                require(key not in boxes,"repeated T4 root")
                boxes[key]=(lo,hi)
    require(set(boxes)=={("15.2",1),("15.14",1)},
            "expected two signed roots not found")
    # All two Q5 Fourier coefficients have absolute value 1.
    amp=[]
    for key in sorted(boxes):
        lo,hi=boxes[key]
        amp.append((lower_sqrt(Q(4)/(Q(1,4)+hi*hi)),
                    upper_sqrt(Q(4)/(Q(1,4)+lo*lo))))
    require(all(Q(0)<a<=b<Q(1) for a,b in amp),"bad amplitudes")
    return amp


def interval_mul(a,b):
    vals=[a[0]*b[0],a[0]*b[1],a[1]*b[0],a[1]*b[1]]
    return min(vals),max(vals)


def threshold_bounds(a,b,cos_box):
    """Positive b, positive (1-a*cos) give a sound quotient interval."""
    num=interval_mul(a,cos_box)
    lo,hi=1-num[1],1-num[0]
    require(lo>0 and b[0]>0,"threshold denominator or numerator invalid")
    return lo/b[1],hi/b[0]


def direct_conditional_grid(n):
    cosine=cos_table(n)
    a,b=amplitudes()
    lower_cells=upper_cells=0
    for i in range(n):
        # Worst angular boundary at theta1 right; best at theta1 left.
        _,threshold_high=threshold_bounds(a,b,cosine[i+1])
        threshold_low,_=threshold_bounds(a,b,cosine[i])
        require(threshold_low<=threshold_high,"monotone conditional threshold failed")

        # Lower positive guarantee: cos(theta2_right)_lo > threshold_high.
        low=0;high=n
        while low<high:
            j=(low+high)//2
            if cosine[j+1][0]>threshold_high:
                low=j+1
            else:
                high=j
        lower_cells+=low

        # Upper possible positivity: cos(theta2_left)_hi > threshold_low.
        low=0;high=n
        while low<high:
            j=(low+high)//2
            if cosine[j][1]>threshold_low:
                low=j+1
            else:
                high=j
        upper_cells+=low

    require(0<lower_cells<=upper_cells<n*n,
            "invalid Haar probability cell accounting")
    lower=Q(lower_cells,n*n)
    upper=Q(upper_cells,n*n)
    require(Q(9,100)<lower<=upper<Q(1,10),
            "T4 Haar sign range outside conservative sanity interval")
    main=json.loads((HERE/"t4_haar_sign_discrepancy_20261013.json").read_bytes())
    original=[Q(x) for x in main["positive_haar_probability_exact"]]
    require(lower<=original[0]<=original[1]<=upper,
            "independent grid does not enclose the primary Haar interval")
    return {
        "id":"CU-BRUIT-T4-HAAR-SECOND-TRIGONOMETRIC-PATH-20261013",
        "status":"RATIONAL_THRESHOLD_CROSSCHECK_ONLY",
        "grid":n,
        "method":"conditional phase threshold and direct Taylor cosine enclosures",
        "positive_certain_cells":lower_cells,
        "positive_possible_cells":upper_cells,
        "haar_probability_exact_outer":[str(lower),str(upper)],
        "haar_probability_decimal_outer":[
            "{:d}.{:06d}".format((lower.numerator*10**6//lower.denominator)//10**6,
                                 (lower.numerator*10**6//lower.denominator)%10**6),
            "{:d}.{:06d}".format(
                (-((-upper.numerator*10**6)//upper.denominator))//10**6,
                (-((-upper.numerator*10**6)//upper.denominator))%10**6)],
        "encloses_primary_Haar_certificate":True,
        "roots_independently_recertified":False,
        "finite_trajectory_independently_recertified":False,
        "GRH_LI_or_uniform_horizon_rate_proved":False,
        "arithmetic_prime_density_certified":False,
        "external_human_review_claimed":False
    }


def main():
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument("--grid",type=int,default=GRID)
    p.add_argument("--check",action="store_true")
    args=p.parse_args()
    r=direct_conditional_grid(args.grid)
    if args.check:
        require(args.grid==GRID,"noncanonical independent grid")
        expected=(HERE/"t4_haar_threshold_crosscheck_20261013.json").read_text()
        require(expected==json.dumps(r,indent=2,sort_keys=True)+"\n",
                "T4 second-path witness does not match pinned CI receipt")
    print(json.dumps(r,indent=2,sort_keys=True))

if __name__=="__main__":
    try:
        main()
    except (ValueError,TypeError,KeyError,ZeroDivisionError,AssertionError,OSError) as exc:
        raise SystemExit("FAIL CLOSED: "+str(exc))
