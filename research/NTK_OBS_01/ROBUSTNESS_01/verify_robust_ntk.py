#!/usr/bin/env python3
"""NTK-OBS-01 robustness: exact Fraction and rational interval certificates.
Python 3.9+, standard library only. No pseudo-randomness or float operations.
"""
from fractions import Fraction as F
from itertools import product
from math import isqrt
import json
from pathlib import Path

OUT = Path(__file__).with_name("robustness_results.json")


def frac(x):
    return str(x)


def ceil_dec(x, digits=12):
    assert x >= 0
    scale = 10 ** digits
    n = (x.numerator * scale + x.denominator - 1) // x.denominator
    return f"{n // scale}.{n % scale:0{digits}d}"


def moments(nodes, weights, count=4):
    return [sum((w * q ** k for q, w in zip(nodes, weights)), F(0))
            for k in range(count)]


def hankel_det(m):
    return m[0] * m[2] - m[1] ** 2


def prony_coeffs(m):
    d = hankel_det(m)
    if d == 0:
        raise ZeroDivisionError("Singular Hankel matrix")
    s1 = (m[0] * m[3] - m[1] * m[2]) / d
    s2 = (m[1] * m[3] - m[2] ** 2) / d
    return s1, s2


def sqrt_interval_nonnegative(z, digits=18):
    """Closed rational interval for sqrt(z), with proof by integer squaring."""
    assert z >= 0
    scale = 10 ** digits
    a = isqrt(z.numerator * scale * scale // z.denominator)
    lower = F(a, scale)
    upper = lower if lower * lower == z else F(a + 1, scale)
    assert lower * lower <= z <= upper * upper
    return lower, upper


class I:
    def __init__(self, a, b=None):
        self.lo = F(a)
        self.hi = F(a if b is None else b)
        assert self.lo <= self.hi

    def __add__(self, other):
        other = other if isinstance(other, I) else I(other)
        return I(self.lo + other.lo, self.hi + other.hi)

    __radd__ = __add__

    def __neg__(self):
        return I(-self.hi, -self.lo)

    def __sub__(self, other):
        return self + -(other if isinstance(other, I) else I(other))

    def __rsub__(self, other):
        return (other if isinstance(other, I) else I(other)) - self

    def __mul__(self, other):
        other = other if isinstance(other, I) else I(other)
        p = [a*b for a in (self.lo, self.hi) for b in (other.lo, other.hi)]
        return I(min(p), max(p))

    __rmul__ = __mul__

    def __truediv__(self, other):
        other = other if isinstance(other, I) else I(other)
        assert not (other.lo <= 0 <= other.hi), "division interval crosses zero"
        return self * I(1 / other.hi, 1 / other.lo)

    def __repr__(self):
        return f"[{self.lo},{self.hi}]"


def root_intervals(m, digits=18):
    s1, s2 = prony_coeffs(m)
    discr = s1 * s1 - 4 * s2
    if discr <= 0:
        raise ValueError("Nonpositive reconstructed discriminant")
    lo, hi = sqrt_interval_nonnegative(discr, digits)
    return I((s1 + lo) / 2, (s1 + hi) / 2), I((s1 - hi) / 2, (s1 - lo) / 2)


def max_abs_error(i, reference):
    return max(abs(i.lo - reference), abs(i.hi - reference))


def main():
    q1, q2 = F(9, 16), F(1, 4)
    w1, w2 = F(1), F(4)
    eta = F(1, 2)
    m = moments((q1, q2), (w1, w2))
    assert m == [F(5), F(25, 16), F(145, 256), F(985, 4096)]
    D = hankel_det(m)
    assert D == F(25, 64) == w1 * w2 * (q1 - q2) ** 2
    s1, s2 = prony_coeffs(m)
    assert (s1, s2) == (F(13, 16), F(9, 64))
    gap = q1 - q2
    assert s1 * s1 - 4 * s2 == gap * gap

    # Explicit rational certificate for every componentwise error <= eps.
    eps = F(1, 10**6)
    W = w1 + w2
    trace = m[0] + m[2]
    h0 = D / trace        # Lower bound on lambda_min(H).
    c1 = abs(s1) + abs(s2) # Upper bound on ||(-s2,s1)||_2.
    assert 2 * eps < h0
    rho = ((2 + 2 * c1) * eps) / (h0 - 2 * eps)
    gamma = (2 * abs(s1) + 4) * rho + rho ** 2
    assert gamma < gap * gap
    R = (rho + gamma / gap) / 2
    assert R < F(1, 1000)
    assert R < min(q2, 1-q1, gap/2)
    weight_bound = (2 * eps + W * R) / (gap - 2 * R)
    assert weight_bound < F(1, 50) < min(w1, w2)
    assert q2 - R > F(1, 9)
    lambda_bound = 3 * R  # eta=1/2, sqrt(qmin-R)>1/3.
    assert lambda_bound < F(3, 1000)
    D_pert_bound = (m[0] + m[2] + 2 * m[1]) * eps + 2 * eps**2
    assert D_pert_bound < D

    # A finite deterministic stress-test (not a proof for all noise vectors).
    q_err_max = F(0)
    w_err_max = F(0)
    smallest_pert_det = None
    count = 0
    for signs in product((-1, 0, 1), repeat=4):
        e = [F(x) * eps for x in signs]
        mt = [x + dx for x, dx in zip(m, e)]
        Dt = hankel_det(mt)
        assert abs(Dt - D) <= D_pert_bound
        assert Dt > 0
        smallest_pert_det = Dt if smallest_pert_det is None else min(Dt, smallest_pert_det)
        hi, lo = root_intervals(mt)
        assert 0 < lo.lo <= lo.hi < hi.lo <= hi.hi < 1
        q_err_max = max(q_err_max, max_abs_error(hi, q1), max_abs_error(lo, q2))
        wd = hi - lo
        wa = (I(mt[1]) - lo * I(mt[0])) / wd
        wb = (hi * I(mt[0]) - I(mt[1])) / wd
        assert wa.lo > 0 and wb.lo > 0
        w_err_max = max(w_err_max, max_abs_error(wa, w1), max_abs_error(wb, w2))
        count += 1
    assert count == 81
    assert q_err_max < R
    assert w_err_max < weight_bound

    # Two indistinguishable data sets, each with positive weights and 2 nodes:
    # model A: nodes a+-d, model B: nodes a+-2d, equal weights 1/2.
    # max moment distance is (9/2)d^2; midpoint error eps_d=(9/4)d^2.
    collision = []
    for denom in (8, 16, 64, 256, 1024, 1000):
        d = F(1, denom)
        a = F(1, 2)
        nodesA = (a+d, a-d)
        nodesB = (a+2*d, a-2*d)
        assert 0 < nodesB[1] < nodesA[1] < nodesA[0] < nodesB[0] < 1
        ma = moments(nodesA, (F(1,2), F(1,2)))
        mb = moments(nodesB, (F(1,2), F(1,2)))
        assert ma[0] == mb[0] == 1
        assert ma[1] == mb[1] == F(1,2)
        assert mb[2] - ma[2] == 3*d*d
        assert mb[3] - ma[3] == F(9,2)*d*d
        assert hankel_det(ma) == d*d
        assert hankel_det(mb) == 4*d*d
        observed = [(u+v)/2 for u,v in zip(ma,mb)]
        ed = F(9,4)*d*d
        assert max(abs(observed[i]-ma[i]) for i in range(4)) == ed
        assert max(abs(observed[i]-mb[i]) for i in range(4)) == ed
        # L-infinity matching distance of sorted true node lists is d;
        # at least one model must have reconstruction error >= d/2.
        collision.append({
            "d": frac(d), "model_A_nodes": [frac(x) for x in nodesA],
            "model_B_nodes": [frac(x) for x in nodesB],
            "D_A": frac(hankel_det(ma)), "D_B": frac(hankel_det(mb)),
            "max_raw_moment_distance": frac(F(9,2)*d*d),
            "midpoint_noise_radius": frac(ed),
            "minimax_node_error_lower_bound": frac(d/2),
            "lower_bound_over_noise": frac((d/2)/ed)
        })
    # Noise of order d^2 can collapse a true two-node Hankel matrix to rank one.
    d = F(1, 1000)
    a = F(1, 2)
    twin = moments((a+d, a-d), (F(1,2), F(1,2)))
    singleton = [a**k for k in range(4)]
    assert hankel_det(twin) == d*d and hankel_det(singleton) == 0
    collapse_eps = max(abs(x-y) for x,y in zip(twin, singleton))
    assert collapse_eps == F(3, 2) * d*d
    try:
        prony_coeffs(singleton)
        raise AssertionError("Prony should reject rank-one data")
    except ZeroDivisionError:
        pass

    result = {
        "id": "NTK-OBS-01-ROBUSTNESS-2026-10-11",
        "status": "internal exact rational checks only; no external audit",
        "environment": "Python standard library, fractions.Fraction, integer isqrt, deterministic",
        "baseline": {"q": [frac(q1), frac(q2)], "w": [frac(w1), frac(w2)],
                     "eta": frac(eta), "m": [frac(x) for x in m],
                     "hankel_determinant": frac(D), "s1": frac(s1), "s2": frac(s2)},
        "certificate_for_all_componentwise_errors": {
            "eps": frac(eps), "h0": frac(h0), "rho": frac(rho),
            "gamma": frac(gamma), "R": frac(R),
            "node_error_lt": "1/1000", "weight_error_lt": "1/50",
            "lambda_error_lt": "3/1000 (positive branch, eta=1/2)",
            "hankel_D_abs_error_bound": frac(D_pert_bound),
            "description": "Symbolic inequality for every error vector |e_k| <= eps, not merely test-grid noise"
        },
        "stress_test": {"grid": "{-eps,0,+eps}^4", "cases": count,
                        "min_perturbed_D": frac(smallest_pert_det),
                        "max_certified_node_error_upper_12dp": ceil_dec(q_err_max),
                        "max_certified_weight_error_upper_12dp": ceil_dec(w_err_max),
                        "interval_sqrt_digits": 18,
                        "description": "Cases sampled, not an exhaustive check of continuous noise cube"},
        "colliding_family": collision,
        "rank_collapse_example": {"d": frac(d), "center": frac(a),
                                  "true_moments": [frac(x) for x in twin],
                                  "observed_moments": [frac(x) for x in singleton],
                                  "componentwise_error_radius": frac(collapse_eps),
                                  "original_D": frac(d*d), "observed_D": "0"},
        "limitations": ["two fixed positive modes only", "absolute componentwise noise only",
                        "unweighted spectrum and branch alias not identified", "not externally reviewed"]
    }
    OUT.write_text(json.dumps(result, sort_keys=True, indent=2) + "\n", encoding="utf-8")
    print("PASS: exact model, rational stability certificate, 81 interval tests, 6 collision cases, rank collapse")
    print("rho <", ceil_dec(rho), "R <", ceil_dec(R), "weight error <", ceil_dec(weight_bound))
    print("observed 81 node error <", ceil_dec(q_err_max), "weight error <", ceil_dec(w_err_max))
    print("results:", OUT)


if __name__ == "__main__":
    main()
