#!/usr/bin/env python3
"""Research-only numerical argument-principle zero count.

Complements (does not reuse) the critical-line Hardy sign scan.
Counts winding of the completed primitive Dirichlet L along a rectangle
enclosing the critical strip for ordinates 0.001 <= Im(s) <= 25.
This uses floating-point sampling, not interval arithmetic.
It is NOT a certified zero count, NOT a proof of GRH, and NOT
a replacement for an externally certified zero catalogue.
"""
import argparse
import cmath
import json
import math
import mpmath as mp
import numpy as np

LOG5 = {1: 0, 2: 1, 4: 2, 3: 3}
EXPECTED = {(0,1):8, (0,2):8, (0,3):8, (1,0):6, (1,1):12, (1,2):13, (1,3):12}

def chi(a, b, n):
    q = (3 if a else 1)*(5 if b else 1)
    if math.gcd(n,q) != 1:
        return 0j
    return (-1 if a and n%3 == 2 else 1)*(1j**(b*LOG5[n%5]) if b else 1)

def completed_L(z,a,b):
    q = (3 if a else 1)*(5 if b else 1)
    parity = (a+b)%2
    characters = [chi(a,b,n) for n in range(q)]
    L = mp.dirichlet(z,characters)
    return mp.power(q/mp.pi,(z+parity)/2)*mp.gamma((z+parity)/2)*L

def segment(start,end,step):
    pieces=math.ceil(abs(end-start)/step)
    return [start+(end-start)*j/pieces for j in range(pieces)]

def winding(a,b,step=0.28,precision=20):
    mp.mp.dps=precision
    bottom_left=complex(-0.25,0.001)
    bottom_right=complex(1.25,0.001)
    top_right=complex(1.25,25.0)
    top_left=complex(-0.25,25.0)
    path=(segment(bottom_left,bottom_right,step)
          +segment(bottom_right,top_right,step)
          +segment(top_right,top_left,step)
          +segment(top_left,bottom_left,step)
          +[bottom_left])
    values=[complex(completed_L(mp.mpc(z.real,z.imag),a,b)) for z in path]
    arguments=np.angle(np.asarray(values))
    changes=np.angle(np.exp(1j*np.diff(arguments)))
    total=float(np.sum(changes)/(2*math.pi))
    count=int(round(total))
    return {"a":a,"b":b,"step":step,"dps":precision,
            "winding":total,"count":count,"points":len(path),
            "largest_phase_increment":float(np.max(np.abs(changes))),
            "min_sample_modulus":float(np.min(np.abs(values))),
            "expected_critical_line_count":EXPECTED[(a,b)],
            "agrees_with_critical_line_scan":count==EXPECTED[(a,b)],
            "certification":"NUMERICAL_ONLY"}

def main():
    p=argparse.ArgumentParser()
    p.add_argument("--a",type=int,required=True,choices=[0,1])
    p.add_argument("--b",type=int,required=True,choices=[0,1,2,3])
    p.add_argument("--step",type=float,default=0.28)
    p.add_argument("--dps",type=int,default=20)
    p.add_argument("--out")
    opts=p.parse_args()
    if (opts.a,opts.b) not in EXPECTED or opts.step<=0 or opts.dps<16:
        p.error("Invalid primitive character or numerical settings")
    result=winding(opts.a,opts.b,opts.step,opts.dps)
    print(json.dumps(result,indent=2))
    if opts.out:
        with open(opts.out,"w",encoding="utf-8") as f:
            json.dump(result,f,indent=2)
    if not result["agrees_with_critical_line_scan"]:
        raise SystemExit("FAIL regression: mismatch between contour and Hardy scans")
    if result["largest_phase_increment"] >= 1.6:
        raise SystemExit("WARNING/FAIL: boundary undersampled; refine step")
    print("NUMERICAL WITNESS PASS; NOT A PROOF OF COMPLETENESS")

if __name__=="__main__":
    main()
