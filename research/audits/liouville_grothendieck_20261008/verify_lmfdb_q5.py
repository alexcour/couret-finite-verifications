#!/usr/bin/env python3
"""Independent q=5 published-zero decimal replay, NOT universal zero certification.
Source of frozen fixture: LMFDB L-functions 1/5/5.2, 5.4, 5.3, 2026-10-09.
Only q=5 has external decimal zero lists checked; q=3 and 15 remain pending.
"""
import math
import json
from pathlib import Path
import numpy as np
import mpmath as mp
from scipy.optimize import brentq
E5={1:0,2:1,4:2,3:3}
mp.mp.dps=24
def calculate(b,T=25,step=.16):
    q=5
    parity=b%2
    chi=[0j if n%5==0 else 1j**(b*E5[n%5]) for n in range(q)]
    tau=mp.fsum(chi[n]*mp.exp(2j*mp.pi*n/q) for n in range(q))
    phase=mp.exp(-.5j*mp.arg(tau/(1j**parity*mp.sqrt(q))))
    def hardy(t):
        s=mp.mpf('.5')+1j*t
        z=(q/mp.pi)**((s+parity)/2)*mp.gamma((s+parity)/2)*mp.dirichlet(s,chi)
        return float(mp.re(phase*z))
    xs=np.linspace(0,T,math.ceil(T/step)+1)
    ys=[hardy(float(x)) for x in xs]
    return [float(brentq(hardy,float(xs[i]),float(xs[i+1]),xtol=1e-12))
            for i in range(len(xs)-1) if ys[i]*ys[i+1]<0]
def main():
    file=Path(__file__).with_name("lmfdb_zero_comparison_20261009.json")
    entries=json.loads(file.read_text(encoding="utf-8"))["entries"]
    verified=0
    for row in entries:
        if row["status"]!="LMFDB_ORDINATES_MATCHED":
            print(row["ab"],"NOT EXTERNALLY CHECKED; SKIP")
            continue
        b=int(row["ab"].split(",")[1])
        actual=calculate(b)
        reference=row["positive_zero_ordinates_under_25"]
        if len(actual)!=len(reference):
            raise AssertionError((row["ab"],len(actual),len(reference)))
        err=max(abs(a-b) for a,b in zip(actual,reference))
        if err>2e-9:raise AssertionError((row["ab"],err))
        print(row["ab"],"LMFDB q5 decimal match",len(actual),"max_diff",err)
        verified+=len(actual)
    assert verified==24
    print("PASS 24/24 q=5 decimal checks. 43 q=3/15 remain pending.")
if __name__=="__main__":
    main()
