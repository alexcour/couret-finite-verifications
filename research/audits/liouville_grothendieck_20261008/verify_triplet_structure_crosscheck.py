#!/usr/bin/env python3
"""Independent exact replay of the C2 x C4 structural triplet proof.

No imports from verify_triplet_census.py. Standard library, integer arithmetic.
This checks finite mathematics, not GRH/LI, zero completeness or prime density.
"""
import argparse
import csv
import json
from collections import Counter
from itertools import combinations, product
from math import comb
from pathlib import Path

ELEMENTS = tuple(product(range(2), range(4)))
RESIDUE = {(e, b): pow(11, e, 30) * pow(7, b, 30) % 30
           for e, b in ELEMENTS}
COORD = {n: g for g, n in RESIDUE.items()}
G = tuple(sorted(COORD))
Z = (0, 2)
Q = frozenset(((0, 0), Z))
CHARS = ((0, 1), (0, 2), (0, 3), (1, 0), (1, 1), (1, 2), (1, 3))
PATTERNS = {
    "Q5": (1, 9, 1, 1, 1, 1, 1),
    "Q3": (1, 1, 1, 9, 1, 1, 1),
    "Q15": (1, 1, 1, 1, 1, 9, 1),
    "C5": (5, 1, 5, 1, 1, 1, 1),
    "C15": (1, 1, 1, 1, 5, 1, 5),
}


def add(x, y):
    return ((x[0] + y[0]) % 2, (x[1] + y[1]) % 4)


def neg(x):
    return (x[0], -x[1] % 4)


def project(x):
    return x[0], x[1] % 2


def triple(ns):
    return frozenset(COORD[n] for n in ns)


def residues(t):
    return tuple(sorted(RESIDUE[x] for x in t))


def translate(t, u):
    return frozenset(add(u, x) for x in t)


def invert(t):
    return frozenset(neg(x) for x in t)


def shear(t):
    return frozenset((e, (b + 2 * e) % 4) for e, b in t)


def mu(t):
    return 3 - 4 * len(t & Q)


def structural_profile(t):
    """Decision from quotient fibres only; no character sums or CSV."""
    fibres = {}
    for x in t:
        fibres.setdefault(project(x), []).append(x)
    if len(fibres) == 2:
        p = next(k for k, v in fibres.items() if len(v) == 2)
        q = next(k for k, v in fibres.items() if len(v) == 1)
        de, db = (p[0] - q[0]) % 2, (p[1] - q[1]) % 2
        assert (de, db) != (0, 0)
        return "Q5" if db == 0 else "Q3" if de == 0 else "Q15"
    assert len(fibres) == 3
    parity_counts = Counter(b % 2 for e, b in t)
    parity = next(p for p, n in parity_counts.items() if n == 2)
    repeated = [x for x in t if x[1] % 2 == parity]
    assert repeated[0][0] != repeated[1][0]
    return "C5" if repeated[0][1] == repeated[1][1] else "C15"


def value(x, a, b):
    e, j = x
    return ((1, 0), (0, 1), (-1, 0), (0, -1))[(2 * a * e + b * j) % 4]


def direct_profile(t):
    result = []
    for a, b in CHARS:
        vals = [value(x, a, b) for x in t]
        re = sum(z[0] for z in vals)
        im = sum(z[1] for z in vals)
        result.append(re * re + im * im)
    return tuple(result)


def autocorrelation_profile(t):
    counts = Counter(add(x, neg(y)) for x in t for y in t)
    result = []
    for a, b in CHARS:
        re = sum(n * value(x, a, b)[0] for x, n in counts.items())
        im = sum(n * value(x, a, b)[1] for x, n in counts.items())
        assert im == 0
        result.append(re)
    return tuple(result)


def derived_counts():
    """Counts from coset sizes and a bias-preserving C5/C15 bijection."""
    table = {}
    for k in range(3):
        total_k = comb(2, k) * comb(6, 3 - k)
        q_count = comb(4, 3) if k == 0 else 2
        for p in ("Q5", "Q3", "Q15"):
            table[(3 - 4 * k, p)] = q_count
        remainder = total_k - 3 * q_count
        assert remainder >= 0 and remainder % 2 == 0
        if remainder:
            for p in ("C5", "C15"):
                table[(3 - 4 * k, p)] = remainder // 2
    return Counter(table)


def orbit(t, reflections=False):
    result = {translate(t, u) for u in ELEMENTS}
    if reflections:
        result |= {translate(invert(t), u) for u in ELEMENTS}
    return result


def prime_counts(limit):
    sieve = bytearray(b"\x01") * (limit + 1)
    sieve[:2] = b"\x00\x00"
    p = 2
    while p * p <= limit:
        if sieve[p]:
            for n in range(p * p, limit + 1, p):
                sieve[n] = 0
        p += 1
    return [n for n in range(2, limit + 1) if sieve[n]]


def race(ns, modulus, primes, x):
    reduced = {n % modulus for n in G}
    support = {n % modulus for n in ns}
    return sum(8 * (p % modulus in support) - 3
               for p in primes if p <= x and p % modulus in reduced)


def check_elementary_two_group():
    """Negative control C2^3, using an independently computed Walsh transform."""
    group = tuple(product(range(2), repeat=3))
    chars = group[1:]
    counts = Counter()
    for t in combinations(group, 3):
        v = tuple(sum((-1) ** (sum(a * b for a, b in zip(c, x)) % 2)
                      for x in t) ** 2 for c in chars)
        assert sorted(v) == [1, 1, 1, 1, 1, 1, 9]
        counts[v] += 1
    assert len(counts) == 7 and set(counts.values()) == {8}
    return len(counts)


def check(check_csv):
    assert len(COORD) == 8 and G == (1, 7, 11, 13, 17, 19, 23, 29)
    assert {add(x, x) for x in ELEMENTS} == Q
    for x, y in product(ELEMENTS, repeat=2):
        assert RESIDUE[add(x, y)] == RESIDUE[x] * RESIDUE[y] % 30
    triples = [triple(ns) for ns in combinations(G, 3)]
    classes, shapes = Counter(), Counter()
    expected_rows = []
    for t in triples:
        name = structural_profile(t)
        v = direct_profile(t)
        assert v == PATTERNS[name] == autocorrelation_profile(t), residues(t)
        assert sum(v) == 15
        classes[(mu(t), name)] += 1
        shapes[len({project(x) for x in t})] += 1
        # Independent square-root expression for the conventional parameter.
        roots = Counter(add(x, x) for x in ELEMENTS)
        numerator = -sum((8 * (a in t) - 3) * (roots[a] - 1) for a in ELEMENTS)
        assert numerator == 8 * mu(t)
        partner = translate(t, Z)
        assert partner != t and translate(partner, Z) == t
        assert mu(partner) == mu(t) and direct_profile(partner) == v
        assert direct_profile(invert(t)) == v and mu(invert(t)) == mu(t)
        assert mu(shear(t)) == mu(t)
        swapped = {"C5": "C15", "C15": "C5"}.get(name, name)
        assert structural_profile(shear(t)) == swapped
        for u in ELEMENTS:
            assert direct_profile(translate(t, u)) == v
        assert len(orbit(t)) == 8
        expected_rows.append(["-".join(map(str, residues(t))), str(mu(t)), name,
                              *map(str, v), "-".join(map(str, residues(partner)))])
    assert len(triples) == 56 and shapes == {2: 24, 3: 32}
    assert classes == derived_counts() and len(classes) == 13
    profiles = {direct_profile(t) for t in triples}
    assert profiles == set(PATTERNS.values())
    translation_orbits = {frozenset(orbit(t)) for t in triples}
    reflection_orbits = {frozenset(orbit(t, True)) for t in triples}
    assert len(translation_orbits) == 7 and len(reflection_orbits) == 5
    for name in PATTERNS:
        fibre = {t for t in triples if structural_profile(t) == name}
        assert fibre == orbit(next(iter(fibre)), True)
    pairs = {frozenset((t, translate(t, Z))) for t in triples}
    assert len(pairs) == 28
    globally_bias_preserving = {u for u in ELEMENTS
                               if all(mu(translate(t, u)) == mu(t) for t in triples)}
    assert globally_bias_preserving == Q
    for m in range(9):
        fixed = sum(translate(frozenset(t), Z) == frozenset(t)
                    for t in combinations(ELEMENTS, m))
        assert fixed == (comb(4, m // 2) if m % 2 == 0 else 0)
    t, other = triple((1, 7, 11)), triple((1, 11, 13))
    assert invert(t) == other and other not in orbit(t)
    assert (mu(t), direct_profile(t)) == (mu(other), direct_profile(other))
    tc = triple((1, 11, 29))
    assert mu(tc) == -1 and mu(translate(tc, COORD[7])) == 3
    assert translate(frozenset(Q), Z) == Q
    assert structural_profile(triple((7, 13, 17))) == "Q5"
    assert structural_profile(triple((11, 17, 23))) == "Q3"
    assert mu(triple((7, 13, 17))) == mu(triple((11, 17, 23))) == 3
    primes = prime_counts(1000)
    for t in triples:
        ns = residues(t)
        correction = 3 - 8 * (17 in ns)
        for x in (0, 1, 2, 3, 5, 7, 19, 31, 100, 1000):
            assert race(ns, 30, primes, x) == race(ns, 15, primes, x) + (correction if x >= 2 else 0)
    finite_pair = [race(residues(t), 30, primes, 19)
                   for t in (tc, translate(tc, Z))]
    assert finite_pair == [-7, 1]
    rows_checked = 0
    if check_csv:
        with Path(__file__).with_name("census_56.csv").open(newline="", encoding="utf-8") as f:
            rows = list(csv.reader(f))
        assert rows[0] == ["triplet", "mu", "profile", "v01_5.2", "v02_5.4",
                           "v03_5.3", "v10_3.2", "v11_15.2", "v12_15.14",
                           "v13_15.8", "partner_times_19"]
        assert rows[1:] == expected_rows, "CSV differs from independent structural calculation"
        rows_checked = len(rows) - 1
    negative_group_profiles = check_elementary_two_group()
    return {
        "status": "PASS_EXACT_FINITE_STRUCTURE",
        "triplets": len(triples), "fibre_shapes": {"2+1": shapes[2], "1+1+1": shapes[3]},
        "labelled_profiles": len(profiles), "bias_profile_classes": len(classes),
        "pairs_times_19": len(pairs), "translation_orbits": len(translation_orbits),
        "translation_and_inversion_orbits": len(reflection_orbits),
        "csv_rows_compared": rows_checked,
        "counts": {f"mu={m},profile={p}": n for (m, p), n in sorted(classes.items())},
        "same_invariants_nontranslation_pair": [[1, 7, 11], [1, 11, 13]],
        "D_19_original_and_partner": finite_pair,
        "C2_cubed_labelled_profiles": negative_group_profiles,
        "finite_prime_reduction_checks": 56 * 10,
        "external_peer_review": False,
        "not_established": ["GRH", "LI", "Dirichlet zero completeness", "sign density", "novelty"],
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--check", action="store_true", help="compare all fields of the existing CSV")
    args = parser.parse_args()
    print(json.dumps(check(args.check), indent=2, sort_keys=True))


if __name__ == "__main__":
    main()
