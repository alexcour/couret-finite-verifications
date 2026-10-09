#!/usr/bin/env python3
"""Research-only Rubinstein-Sarnak sign-density approximation for CU-BRUIT-01.

GRH and LI are NOT established. A sign-change scan is NOT a certified zero count.
Omitted higher-zero contributions are modeled as normal with matched variance.
The frozen prime-counting protocol and data are never modified.
"""
import argparse
import json
import math
import time
import mpmath as mp
import numpy as np
from scipy.optimize import brentq
from scipy.special import j0
from scipy.integrate import simpson

G = (1, 7, 11, 13, 17, 19, 23, 29)
S = {1, 11, 29}
LOG5 = {1: 0, 2: 1, 4: 2, 3: 3}

def char(a, b, n):
    q = (3 if a else 1) * (5 if b else 1)
    if math.gcd(n, q) != 1:
        return 0j
    return (-1 if a and n % 3 == 2 else 1) * (1j ** (b * LOG5[n % 5]) if b else 1)

def character_data(a, b):
    q = (3 if a else 1) * (5 if b else 1)
    chi = [char(a, b, n) for n in range(q)]
    parity = (a + b) % 2
    tau = mp.fsum(chi[n] * mp.exp(2j * mp.pi * n / q) for n in range(q))
    epsilon = tau / (1j**parity * mp.sqrt(q))
    phase = mp.exp(-1j * mp.arg(epsilon)/2)
    return q, parity, chi, phase

def B_values():
    cache = {}
    def constants(q, n):
        if (q, n) not in cache:
            f = mp.mpf(n)/q
            cache[q, n] = (mp.stieltjes(0, f), mp.stieltjes(1, f))
        return cache[q, n]
    values = {}
    for a in range(2):
        for b in range(4):
            if (a, b) == (0, 0):
                continue
            q, p, chi, _ = character_data(a, b)
            L = mp.mpc(0)
            Lprime = mp.mpc(0)
            for n in range(1, q+1):
                if math.gcd(n, q) != 1:
                    continue
                g0, g1 = constants(q, n)
                z = chi[n % q]
                L += z*g0/q
                Lprime -= z*g1/q
            Lprime -= mp.log(q)*L
            values[f"{a},{b}"] = float(
                2*mp.re(Lprime/L) + mp.log(q/mp.pi) +
                mp.digamma(mp.mpf(p+1)/2))
    return values

def find_critical_zeros(T, step):
    results = {}
    for a in range(2):
        for b in range(4):
            if (a, b) == (0, 0):
                continue
            q, p, chi, phase = character_data(a, b)
            def hardy(t):
                s = mp.mpf("0.5") + 1j*t
                L = mp.dirichlet(s, chi)
                completed = (q/mp.pi)**((s+p)/2)*mp.gamma((s+p)/2)*L
                return float(mp.re(phase*completed))
            N = math.ceil(T/step)
            xs = np.linspace(0, T, N+1)
            prev = hardy(float(xs[0]))
            roots = []
            for left, right in zip(xs[:-1], xs[1:]):
                cur = hardy(float(right))
                if prev*cur < 0:
                    roots.append(float(brentq(hardy, float(left), float(right), xtol=1e-9)))
                prev = cur
            results[f"{a},{b}"] = roots
            print(f"{a},{b}: {len(roots)} sign-change zeros <= {T:g}", flush=True)
    return results

def numerical_density(roots, B):
    variance = 0.0
    ampl = []
    for key, zeros in roots.items():
        weight = 3 if key == "0,2" else 1
        variance += weight**2 * B[key]
        ampl.extend(2*weight/math.hypot(.5, gamma) for gamma in zeros)
    ampl = np.asarray(ampl, dtype=float)
    finite_var = float(np.sum(ampl**2)/2)
    residual = variance - finite_var
    assert residual > 0
    sign = {}
    for upper, h in ((16, .01), (30, .01), (50, .01), (80, .02)):
        t = np.linspace(0, upper, round(upper/h)+1)
        product = np.ones(t.shape)
        for v in ampl:
            product *= j0(v*t)
        modeled_tail = np.exp(-.5*residual*t**2)
        # sinc(t/pi) = sin(t)/t with removable singularity at t=0
        delta = .5 - simpson(np.sinc(t/np.pi)*product*modeled_tail, x=t)/np.pi
        sign[str(upper)] = float(delta)
    return {"mean": -1.0, "variance": variance, "variance_chi5_fraction": 9*B["0,2"]/variance,
            "finite_variance": finite_var, "modeled_tail_variance": residual,
            "sign_density_approximation": sign, "zero_count": len(ampl)}

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--T", type=float, default=15)
    parser.add_argument("--step", type=float, default=.5)
    parser.add_argument("--dps", type=int, default=18)
    parser.add_argument("--out", default="rs_density_results.json")
    args = parser.parse_args()
    assert args.T > 1 and args.step > 0 and args.dps >= 15
    mp.mp.dps = args.dps
    t0 = time.time()
    B = B_values()
    roots = find_critical_zeros(args.T, args.step)
    stats = numerical_density(roots, B)
    stats.update(T=args.T, step=args.step, dps=args.dps,
                 analytic_B=B, zero_counts={key:len(z) for key,z in roots.items()},
                 seconds=round(time.time()-t0,2))
    with open(args.out, "w", encoding="utf-8") as f:
        json.dump({"summary":stats, "zeros":roots}, f, indent=2)
    print("RESEARCH ONLY / NOT CERTIFIED:",json.dumps(stats, indent=2))
if __name__ == "__main__":
    main()
