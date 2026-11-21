#!/usr/bin/env python3
"""CU-LOG-SPEC-01 addendum, 2026-10-11: independent conductor audit.

No new primes are calculated. Reads the existing resultats_spec.json.
Exact arithmetic uses stdlib; --forecast additionally needs numpy and scipy.
Surrogate forecast is NOT the full Rubinstein-Sarnak interval model.
"""
import argparse
import itertools
import json
import math
from fractions import Fraction
from pathlib import Path

SOURCE = Path(__file__).resolve().parent.parent / "resultats_spec.json"
PRIMES = (3, 5, 7)
ORDERS = (2, 4, 6)
LOGS = {
    3: {pow(2, j, 3): j for j in range(2)},
    5: {pow(2, j, 5): j for j in range(4)},
    7: {pow(3, j, 7): j for j in range(6)},
}

def phi(q):
    return sum(math.gcd(a, q) == 1 for a in range(1, q + 1))

def exact():
    data = json.loads(SOURCE.read_text(encoding="utf8"))
    n = {int(a): int(v) for a, v in
         data["windows"]["30000000"]["counts210"].items()}
    assert sorted(n) == [a for a in range(1, 210) if math.gcd(a, 210) == 1]
    assert sum(n.values()) == 1193280
    avg = Fraction(sum(n.values()), 48)
    tot = sum((Fraction(v) - avg) ** 2 for v in n.values())
    assert tot == 156804
    divisors = (1, 3, 5, 7, 15, 21, 35, 105)
    e = {}
    for q in divisors:
        counts = {a: 0 for a in range(q) if math.gcd(a, q) == 1}
        for a, v in n.items():
            counts[a % q] += v
        fiber = Fraction(48, phi(q))
        e[q] = sum((Fraction(v) - fiber * avg) ** 2 / fiber
                   for v in counts.values())
    assert e[105] == tot
    weight = {}
    for f in divisors:
        weight[f] = e[f] - sum(weight[d] for d in weight if f % d == 0)
    assert sum(weight.values()) == tot
    print("exact norm2", tot)
    for f in divisors[1:]:
        print("conductor", f, "energy", weight[f],
              "fraction", float(weight[f] / tot))
    for q, expected in ((15, 0.042384122854008825),
                        (21, 0.05865921787709497),
                        (35, 0.2975498074028724)):
        score = float(e[q] / tot)
        print("projection", q, "rank", phi(q)-1, "energy", e[q],
              "fraction", score, "uniform-benchmark", (phi(q)-1)/47)
        assert abs(score - expected) < 1e-12

def forecast():
    import numpy as np
    from scipy.special import zeta, digamma
    keys, cond, weights, real_quadratic = [], [], [], []
    for k in itertools.product(range(2), range(4), range(6)):
        if k == (0, 0, 0):
            continue
        f = math.prod(p for p, v in zip(PRIMES, k) if v)
        a = np.array([a for a in range(1, f + 1)
                      if math.gcd(a, f) == 1])
        z = a / f
        phase = sum(v * np.array([LOGS[p][aa % p] for aa in a]) / order
                    for p, v, order in zip(PRIMES, k, ORDERS) if v)
        chi = np.exp(2j * np.pi * phase)
        h = 0.002
        r0 = -digamma(z)
        def r(j):
            t = j * h
            return zeta(1 + t, z) - 1 / t
        r1 = (-25*r0 + 48*r(1) - 36*r(2) + 16*r(3) - 3*r(4))/(12*h)
        L1 = np.sum(chi * r0) / f
        Lp = (-np.log(f)*np.sum(chi*r0) + np.sum(chi*r1)) / f
        parity = (-1)**sum(k)
        b = np.log(f/np.pi) - np.euler_gamma - (1+parity)*np.log(2)
        b += 2 * np.real(Lp / L1)
        assert b > 0
        keys.append(k)
        cond.append(f)
        weights.append(float(b))
        real_quadratic.append(all(v in (0, order//2)
                                  for v, order in zip(k, ORDERS)))
    cond = np.array(cond, dtype=int)
    weights = np.array(weights)
    real_quadratic = np.array(real_quadratic)
    assert len(keys) == 47 and sum(real_quadratic) == 7
    for q in (15, 21, 35):
        ratio = weights[q % cond == 0].sum() / weights.sum()
        print("unfiltered-b trace-ratio", q, "%.10f" % ratio)
    assert abs(weights[15 % cond == 0].sum() / weights.sum()
               - 0.034208468) < 1e-6
    alpha = 1/3
    mu = -(1 - math.sqrt(alpha)) * real_quadratic.astype(float)
    sigma = np.sqrt((1 + alpha)*weights)
    seed, total = 21020261012, 300000
    rng = np.random.default_rng(seed)
    scores = np.empty((total, 4))
    i5 = keys.index((0, 2, 0))
    for start in range(0, total, 15000):
        end = min(total, start + 15000)
        a = rng.standard_normal((end-start, 47))*sigma + mu
        sq = a*a
        den = sq.sum(axis=1)
        scores[start:end] = np.column_stack(
            [sq[:, q % cond == 0].sum(axis=1)/den for q in (15, 21, 35)]
            + [sq[:, i5]/den]
        )
    center = scores.mean(axis=0)
    C = np.cov(scores, rowvar=False)
    deviations = scores-center
    dist2 = np.einsum("ij,jk,ik->i", deviations,
                     np.linalg.inv(C), deviations)
    result = {"alpha": alpha, "seed": seed, "draws": total,
              "statistic_order": ["F15", "F21", "F35", "G_chi5"],
              "mean": center.tolist(), "covariance": C.tolist(),
              "joint_D2_99pct": float(np.quantile(dist2, 0.99)),
              "warning": "Gaussian surrogate. Missing window cross-term; NOT a prime-number p-value."}
    print("PREFROZEN_GAUSSIAN_SURROGATE", json.dumps(result, indent=2))

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--forecast", action="store_true")
    options = parser.parse_args()
    exact()
    if options.forecast:
        forecast()
