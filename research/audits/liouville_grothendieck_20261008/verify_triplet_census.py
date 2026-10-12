#!/usr/bin/env python3
"""Exact, dependency-free census of weighted 3-class prime races in U(30).

No statement about RH, LI, analytic zero completeness, sign densities, or
novelty follows from this finite verifier.
"""
import argparse
import csv
import io
import json
from collections import Counter
from itertools import combinations
from math import gcd
from pathlib import Path

G = tuple(n for n in range(30) if gcd(n, 30) == 1)
ORDER = ((0, 1), (0, 2), (0, 3), (1, 0), (1, 1), (1, 2), (1, 3))
LABELS = ("5.2", "5.4", "5.3", "3.2", "15.2", "15.14", "15.8")
EXPO5 = {1: 0, 2: 1, 4: 2, 3: 3}
Q = frozenset((1, 19))
TC = (1, 11, 29)
EXPECTED_CLASSES = {
    (3, "Q5"): 4, (3, "Q3"): 4, (3, "Q15"): 4,
    (3, "C5"): 4, (3, "C15"): 4,
    (-1, "Q5"): 2, (-1, "Q3"): 2, (-1, "Q15"): 2,
    (-1, "C5"): 12, (-1, "C15"): 12,
    (-5, "Q5"): 2, (-5, "Q3"): 2, (-5, "Q15"): 2,
}


def char(n, a, b):
    """Return Gaussian-integer values (real, imaginary) of chi_(a,b)(n)."""
    assert n in G
    sign = -1 if a and n % 3 == 2 else 1
    i_power = (b * EXPO5[n % 5]) % 4
    unit = ((1, 0), (0, 1), (-1, 0), (0, -1))[i_power]
    return sign * unit[0], sign * unit[1]


def spectrum(triple):
    """Direct character sums, all integral arithmetic."""
    out = []
    for a, b in ORDER:
        real = imag = 0
        for n in triple:
            x, y = char(n, a, b)
            real += x
            imag += y
        out.append(real * real + imag * imag)
    return tuple(out)


def ratio_spectrum(triple):
    """Independent quotient identity |sum chi(n)|^2=sum chi(m/n)."""
    out = []
    for a, b in ORDER:
        re = im = 0
        for m in triple:
            for n in triple:
                quotient = (m * pow(n, -1, 30)) % 30
                x, y = char(quotient, a, b)
                re += x
                im += y
        assert im == 0
        out.append(re)
    return tuple(out)


def bias(triple):
    return 3 - 4 * len(Q.intersection(triple))


def partner(triple):
    return tuple(sorted((19 * n) % 30 for n in triple))


def profile_name(profile):
    """Recognize five labelled patterns; fail on any unforeseen pattern."""
    if profile == (1, 9, 1, 1, 1, 1, 1):
        return "Q5"
    if profile == (1, 1, 1, 9, 1, 1, 1):
        return "Q3"
    if profile == (1, 1, 1, 1, 1, 9, 1):
        return "Q15"
    if profile == (5, 1, 5, 1, 1, 1, 1):
        return "C5"
    if profile == (1, 1, 1, 1, 5, 1, 5):
        return "C15"
    raise AssertionError(f"unexpected labelled profile {profile}")


def prime_race_at_100000(triple):
    """Small finite-example sanity check (not a replay of historic 1e9 data)."""
    nmax = 100000
    sieve = bytearray(b"\x01") * (nmax + 1)
    sieve[0:2] = b"\x00\x00"
    for p in range(2, int(nmax**0.5) + 1):
        if sieve[p]:
            sieve[p * p::p] = b"\x00" * ((nmax - p * p) // p + 1)
    return sum((5 if p % 30 in triple else -3)
               for p in range(2, nmax + 1) if sieve[p] and p % 30 in G)


def census():
    assert G == (1, 7, 11, 13, 17, 19, 23, 29)
    assert set(pow(n, 2, 30) for n in G) == Q
    assert Counter(pow(n, 2, 30) for n in G) == {1: 4, 19: 4}
    assert all(len({char(n, a, b) for n in G}) > 1 for a, b in ORDER)
    assert LABELS == ("5.2", "5.4", "5.3", "3.2", "15.2", "15.14", "15.8")

    triples = list(combinations(G, 3))
    profiles = set()
    count = Counter()
    rows = []
    for t in triples:
        v = spectrum(t)
        assert v == ratio_spectrum(t), (t, v, ratio_spectrum(t))
        assert sum(v) == 15
        profiles.add(v)
        mu = bias(t)
        pname = profile_name(v)
        count[(mu, pname)] += 1
        u = partner(t)
        assert u != t and partner(u) == t
        assert bias(u) == mu and spectrum(u) == v
        rows.append(["-".join(map(str, t)), mu, pname,
                     *v, "-".join(map(str, u))])
    assert len(triples) == 56
    assert len(profiles) == 5
    assert count == EXPECTED_CLASSES, (count, EXPECTED_CLASSES)
    assert sorted(count.values(), reverse=True) == [12,12,4,4,4,4,4,2,2,2,2,2,2]
    assert len({frozenset((t, partner(t))) for t in triples}) == 28
    assert spectrum(TC) == (1,9,1,1,1,1,1)
    assert bias(TC) == -1
    assert partner(TC) == (11,19,29)

    # The nonprincipal c_T coefficients equal conjugates of sum_T chi.
    coeff = []
    for a, b in ORDER:
        s = [sum((5 if n in TC else -3) * char(n, a, b)[k]
                 for n in G) for k in (0, 1)]
        assert all(z % 8 == 0 for z in s)
        coeff.append((s[0] // 8, -s[1] // 8))
    assert coeff == [(1,0),(3,0),(1,0),(-1,0),(1,0),(-1,0),(1,0)]
    assert sum(64 * (re * re + im * im) for re, im in coeff) == 960
    assert prime_race_at_100000(TC) == -87
    assert prime_race_at_100000(partner(TC)) == -63

    csv_buffer = io.StringIO(newline="")
    writer = csv.writer(csv_buffer, lineterminator="\n")
    writer.writerow(["triplet", "mu", "profile", "v01_5.2", "v02_5.4",
                     "v03_5.3", "v10_3.2", "v11_15.2", "v12_15.14",
                     "v13_15.8", "partner_times_19"])
    writer.writerows(rows)
    return csv_buffer.getvalue(), {
        "schema": "CU-BRUIT-02 finite 56-three-class census v1",
        "tested_triplets": 56,
        "labelled_spectral_profiles": 5,
        "mean_and_profile_classes": 13,
        "distinct_partner_pairs_times_19": 28,
        "census_counts": {f"mu={mu},profile={p}": n for (mu,p), n in
                          sorted(count.items())},
        "original_partner": list(partner(TC)),
        "D_100000_original": -87,
        "D_100000_partner": -63,
        "spectral_and_bias_derivation": "exact finite group/character arithmetic only",
        "not_established": ["GRH", "LI", "zero completeness", "sign density", "novelty"],
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write", action="store_true", help="write deterministic CSV fixture")
    parser.add_argument("--check", action="store_true", help="compare against committed CSV")
    p = parser.parse_args()
    if p.write and p.check:
        parser.error("--write and --check are mutually exclusive")
    fixture = Path(__file__).with_name("census_56.csv")
    rendered, summary = census()
    if p.write:
        fixture.write_text(rendered, encoding="utf-8", newline="")
    if p.check:
        if not fixture.exists():
            raise SystemExit("FAIL: missing committed fixture census_56.csv")
        if fixture.read_bytes() != rendered.encode("utf-8"):
            raise SystemExit("FAIL: census_56.csv not byte-for-byte reproducible")
    print(json.dumps(summary, sort_keys=True, indent=2))


if __name__ == "__main__":
    main()
