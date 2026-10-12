#!/usr/bin/env python3
"""Exact finite algebra for CU-BRUIT-02-C independent-phase laws.

No zeros, GRH/LI, infinite-limit theorem, sign density or originality are
certified by this executable. Uses fractions and Python standard library.
"""
import argparse
import csv
import json
from collections import Counter
from fractions import Fraction as F
from math import comb, factorial
from pathlib import Path

ORDER = ((0, 1), (0, 2), (0, 3), (1, 0), (1, 1), (1, 2), (1, 3))
LABELS = ("5.2", "5.4", "5.3", "3.2", "15.2", "15.14", "15.8")
PROFILES = {
    "Q5": (1, 9, 1, 1, 1, 1, 1),
    "Q3": (1, 1, 1, 9, 1, 1, 1),
    "Q15": (1, 1, 1, 1, 1, 9, 1),
    "C5": (5, 1, 5, 1, 1, 1, 1),
    "C15": (1, 1, 1, 1, 5, 1, 5),
}
EXTRA = {"Q5": (0, 2), "Q3": (1, 0), "Q15": (1, 2),
         "C5": (0, 1), "C15": (1, 1)}


def multiply_series(a, b, n):
    return [sum((a[k] * b[j - k] for k in range(j + 1)
                 if k < len(a) and j - k < len(b)), F(0)) for j in range(n + 1)]


def log_series(a):
    assert a[0] == 1
    result = [F(0)] * len(a)
    for n in range(1, len(a)):
        result[n] = a[n] - sum((F(k) * result[k] * a[n - k]
                               for k in range(1, n)), F(0)) / n
    return result


def bessel_log_ode(n):
    c = [F(0)] * (n + 1)
    c[1] = F(1, 4)
    for m in range(2, n + 1):
        c[m] = sum((F(k * (m - k)) * c[k] * c[m - k]
                    for k in range(1, m)), F(0)) / (m * m)
    return c


def bessel_series(lam, n):
    # Series in s=t^2 of J0(sqrt(lam)*t), without approximating sqrt(lam).
    return [F((-1) ** k, 4 ** k * factorial(k) ** 2) * lam ** k
            for k in range(n + 1)]


def phase_moments(lambdas, n):
    # Independent binomial convolution of E[(sqrt(lam)*cos(theta))^k].
    out = [F(0)] * (n + 1)
    out[0] = F(1)
    for lam in lambdas:
        term = [F(0)] * (n + 1)
        for k in range(0, n + 1, 2):
            term[k] = lam ** (k // 2) * F(comb(k, k // 2), 2 ** k)
        out = [sum((F(comb(k, j)) * out[j] * term[k - j]
                    for j in range(k + 1)), F(0)) for k in range(n + 1)]
    return out


def elementary_from_powers(lambdas):
    n = len(lambdas)
    power = [sum((x ** k for x in lambdas), F(0)) for k in range(n + 1)]
    e = [F(1)]
    for k in range(1, n + 1):
        e.append(sum((F((-1) ** (j - 1)) * e[k - j] * power[j]
                      for j in range(1, k + 1)), F(0)) / k)
    return e


def elementary_direct(lambdas):
    # Product of (1+lam*x), independently of Newton's power-sum identities.
    out = [F(1)]
    for lam in lambdas:
        nxt = out + [F(0)]
        for j in range(1, len(nxt)):
            nxt[j] += lam * out[j - 1]
        out = nxt
    return out


def check_catalogue_fixture():
    classes = Counter()
    toy_laws = Counter()
    with Path(__file__).with_name("census_56.csv").open(encoding="utf-8", newline="") as f:
        rows = list(csv.DictReader(f))
    assert len(rows) == 56
    seen = set()
    for row in rows:
        t = tuple(map(int, row["triplet"].split("-")))
        assert t not in seen
        seen.add(t)
        mu = int(row["mu"])
        assert mu == 3 - 4 * len({1, 19}.intersection(t))
        name = row["profile"]
        v = tuple(int(row[f"v{a}{b}_{label}"])
                  for (a, b), label in zip(ORDER, LABELS))
        assert v == PROFILES[name]
        classes[(mu, name)] += 1
        toy_laws[(mu, tuple(sorted(v)))] += 1
    assert len(classes) == 13 and len(toy_laws) == 5
    assert sorted(toy_laws.values()) == [6, 6, 8, 12, 24]
    # Means separate bias values; P2 separates Q and C despite equal P1.
    for v in PROFILES.values():
        assert sum(v) == 15
    assert sum(x * x for x in PROFILES["Q5"]) == 87
    assert sum(x * x for x in PROFILES["C5"]) == 55
    return {"rows_compared": len(rows), "finite_bias_profile_classes": len(classes),
            "synthetic_equal_channel_model_laws": len(toy_laws),
            "synthetic_law_sizes": sorted(toy_laws.values())}


def audit(check=False):
    n = 16
    c = bessel_log_ode(n)
    independent = log_series(bessel_series(F(1), n))
    assert all(c[k] == -independent[k] > 0 for k in range(1, n + 1))
    assert c[1:5] == [F(1, 4), F(1, 64), F(1, 576), F(11, 49152)]
    checked_vectors = [[], [F(1)], [F(1), F(1)], [F(2)],
                       [F(1, 2), F(2, 3), F(2, 3)], [F(0), F(1), F(4)]]
    for lambdas in checked_vectors:
        moments = phase_moments(lambdas, 2 * n)
        via_moments = [F((-1) ** k, factorial(2 * k)) * moments[2 * k]
                       for k in range(n + 1)]
        via_product = [F(1)] + [F(0)] * n
        for lam in lambdas:
            via_product = multiply_series(via_product, bessel_series(lam, n), n)
        assert via_moments == via_product
        ell = log_series(via_product)
        for m in range(1, n + 1):
            power = sum((lam ** m for lam in lambdas), F(0))
            assert ell[m] == -c[m] * power
        assert elementary_from_powers(lambdas) == elementary_direct(lambdas)
        p1, p2 = sum(lambdas, F(0)), sum((x*x for x in lambdas), F(0))
        assert moments[2] == p1 / 2
        assert moments[4] - 3 * moments[2] ** 2 == -F(3, 8) * p2

    m_a, m_b = phase_moments([F(1), F(1)], 4), phase_moments([F(2)], 4)
    assert m_a[2] == m_b[2] == 1
    assert m_a[4] == F(9, 4) and m_b[4] == F(3, 2)
    assert m_a[4] != m_b[4]
    # Correlated cosine terms: coefficients (1,1) vs (1,-1), same moduli.
    assert F((1 + 1) ** 2, 2) == 2
    assert F((1 - 1) ** 2, 2) == 0

    # Artificial positive weights: deliberately unequal conjugate A values.
    positive = dict(zip(ORDER, [F(1, 5), F(2, 7), F(3, 11), F(5, 13),
                               F(7, 17), F(11, 19), F(13, 23)]))
    conjugate = lambda c: (c[0], (-c[1]) % 4)
    signed = {chi: positive[chi] + positive[conjugate(chi)] for chi in ORDER}
    assert positive[(0, 1)] != positive[(0, 3)]
    assert signed[(0, 1)] == signed[(0, 3)]
    baseline = sum(signed.values(), F(0))
    for name, vector in PROFILES.items():
        v = dict(zip(ORDER, vector))
        by_positive = 2 * sum((v[chi] * positive[chi] for chi in ORDER), F(0))
        by_signed = sum((v[chi] * signed[chi] for chi in ORDER), F(0))
        assert by_positive == by_signed == baseline + 8 * signed[EXTRA[name]]

    corrupted = list(c)
    corrupted[2] *= 2
    assert corrupted[2] != -independent[2]
    assert sum((F(v) * positive[chi] for chi, v in zip(ORDER, PROFILES["C5"])), F(0)) != baseline + 8 * signed[(0, 1)]
    fixture = check_catalogue_fixture() if check else {"csv_comparison": "not requested"}
    return {
        "schema": "CU-BRUIT-02-C exact independent-phase identities v1",
        "log_bessel_coefficients_checked_through_t_order": 2 * n,
        "first_log_bessel_coefficients": [str(x) for x in c[1:5]],
        "independent_moment_product_and_newton_vectors": len(checked_vectors),
        "same_variance_different_fourth_moments": [str(m_a[4]), str(m_b[4])],
        "correlated_equal_moduli_variances": [2, 0],
        "signed_conjugate_variance_aggregation": "PASS with unequal positive lists",
        "five_profile_variance_formulas": "PASS exact synthetic rational weights",
        "corrupted_log_coefficient_and_missing_variance_factor": "rejected",
        **fixture,
        "proved_by_execution": "finite rational identities only",
        "not_certified": ["countable reconstruction theorem", "GRH/LI",
                          "prime limiting law", "actual zero data or tail",
                          "thirteen distinct actual prime-race laws", "sign density", "novelty"],
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--check", action="store_true", help="also compare the existing 56-row census")
    args = parser.parse_args()
    print(json.dumps(audit(args.check), indent=2, sort_keys=True))


if __name__ == "__main__":
    main()
