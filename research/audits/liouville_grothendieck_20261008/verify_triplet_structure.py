#!/usr/bin/env python3
"""Independent exact check of the quotient proof for triples in U(30).

Uses coordinates from generators 11 and 7, not the existing character code.
Does not establish prime limiting laws, GRH/LI, certified zeros, or novelty.
"""
import argparse
import csv
import json
from collections import Counter, defaultdict
from itertools import combinations, product
from pathlib import Path

ORDER = ((0, 1), (0, 2), (0, 3), (1, 0), (1, 1), (1, 2), (1, 3))
LABELS = ("5.2", "5.4", "5.3", "3.2", "15.2", "15.14", "15.8")
REAL = ((0, 2), (1, 0), (1, 2))
REAL_NAMES = {(0, 2): "Q5", (1, 0): "Q3", (1, 2): "Q15"}
COORD = {(pow(11, x, 30) * pow(7, y, 30)) % 30: (x, y)
         for x, y in product(range(2), range(4))}
G = tuple(sorted(COORD))
Q = frozenset(n for n, (x, y) in COORD.items() if x == 0 and y % 2 == 0)
I_POWERS = ((1, 0), (0, 1), (-1, 0), (0, -1))


def char(n, a, b):
    x, y = COORD[n]
    re, im = I_POWERS[(b * y) % 4]
    sign = (-1) ** (a * x)
    return sign * re, sign * im


def direct_profile(t):
    result = []
    for a, b in ORDER:
        re = sum(char(n, a, b)[0] for n in t)
        im = sum(char(n, a, b)[1] for n in t)
        result.append(re * re + im * im)
    return tuple(result)


def expected_profile(name):
    v = [1] * 7
    if name.startswith("Q"):
        c = next(c for c, p in REAL_NAMES.items() if p == name)
        v[ORDER.index(c)] = 9
    else:
        a = 0 if name == "C5" else 1
        v[ORDER.index((a, 1))] = v[ORDER.index((a, 3))] = 5
    return tuple(v)


def quotient(n):
    x, y = COORD[n]
    return x, y % 2


def structural_name(t):
    """Predict from quotient geometry, before computing any Fourier norms."""
    occupied = {quotient(n) for n in t}
    if len(occupied) == 2:
        constant = [c for c in REAL if len({char(n, *c) for n in t}) == 1]
        assert len(constant) == 1
        return REAL_NAMES[constant[0]]
    assert len(occupied) == 3
    same_parity = next([n for n in t if COORD[n][1] % 2 == parity]
                       for parity in (0, 1)
                       if sum(COORD[n][1] % 2 == parity for n in t) == 2)
    p, q = same_parity
    assert COORD[p][0] != COORD[q][0]
    z, w = char(p, 0, 1), char(q, 0, 1)
    assert w in (z, (-z[0], -z[1]))
    return "C5" if z == w else "C15"


def multiply(t, u):
    return tuple(sorted(n * u % 30 for n in t))


def inverse(t):
    return tuple(sorted(pow(n, -1, 30) for n in t))


def bias(t):
    return 3 - 4 * len(Q.intersection(t))


def predicted_counts():
    """Counts from cosets and lifts in the proof, not from the CSV."""
    out = Counter()
    for name in REAL_NAMES.values():
        out[(3, name)] = 4
        out[(-1, name)] = 2
        out[(-5, name)] = 2
    for name in ("C5", "C15"):
        out[(3, name)] = 4
        out[(-1, name)] = 3 * 4
    return out


def check_csv(triples, names):
    path = Path(__file__).with_name("census_56.csv")
    with path.open(encoding="utf-8", newline="") as f:
        reader = csv.DictReader(f)
        expected_header = ["triplet", "mu", "profile"] + [
            f"v{a}{b}_{label}" for (a, b), label in zip(ORDER, LABELS)
        ] + ["partner_times_19"]
        assert reader.fieldnames == expected_header
        rows = list(reader)
    assert len(rows) == len(triples) == 56
    seen = set()
    for row in rows:
        t = tuple(map(int, row["triplet"].split("-")))
        assert t in names and t not in seen
        seen.add(t)
        assert int(row["mu"]) == bias(t)
        assert row["profile"] == names[t]
        v = tuple(int(row[f"v{a}{b}_{label}"])
                  for (a, b), label in zip(ORDER, LABELS))
        assert v == direct_profile(t) == expected_profile(names[t])
        assert tuple(map(int, row["partner_times_19"].split("-"))) == multiply(t, 19)
    assert seen == set(triples)


def other_group_counterexamples():
    # C2^3, constructed without reference to U(30) or its labels.
    group = tuple(product(range(2), repeat=3))
    zero = (0, 0, 0)
    characters = tuple(x for x in group if x != zero)
    profiles, classes = Counter(), Counter()
    for t in combinations(group, 3):
        v = tuple(sum((-1) ** (sum(a * b for a, b in zip(c, n)) % 2)
                      for n in t) ** 2 for c in characters)
        assert sorted(v) == [1] * 6 + [9]
        profiles[v] += 1
        classes[(3 - 8 * (zero in t), v)] += 1
    assert len(profiles) == 7 and set(profiles.values()) == {8}
    assert len(classes) == 14
    assert all(classes[(3, v)] == 5 and classes[(-5, v)] == 3 for v in profiles)

    # C2 x C8: all three real characters are constant on this triple.
    t = ((0, 0), (0, 2), (0, 4))
    quadratic_norms = tuple(sum((-1) ** ((a * x + b * y) % 2)
                                for x, y in t) ** 2
                            for a, b in ((0, 1), (1, 0), (1, 1)))
    assert quadratic_norms == (9, 9, 9)
    return {"C2^3_profiles": 7, "C2^3_bias_profile_classes": 14,
            "C2_x_C8_witness_quadratic_norms": quadratic_norms}


def audit(check=False):
    assert len(COORD) == 8 and G == (1, 7, 11, 13, 17, 19, 23, 29)
    assert Q == frozenset((1, 19))
    assert Counter(n * n % 30 for n in G) == {1: 4, 19: 4}
    for n, m in product(G, repeat=2):
        x, y = COORD[n]
        xx, yy = COORD[m]
        assert COORD[n * m % 30] == ((x + xx) % 2, (y + yy) % 4)
    triples = tuple(combinations(G, 3))
    names, count = {}, Counter()
    by_quotient = defaultdict(Counter)
    orbits = defaultdict(set)
    profile_orbits = defaultdict(set)
    for t in triples:
        name = structural_name(t)
        names[t] = name
        v = direct_profile(t)
        assert v == expected_profile(name) and sum(v) == 15
        count[(bias(t), name)] += 1
        occupied = frozenset(quotient(n) for n in t)
        if len(occupied) == 3:
            by_quotient[occupied][name] += 1
        translates = {multiply(t, u) for u in G}
        assert len(translates) == 8
        representative = min(translates)
        orbits[representative].add(t)
        profile_orbits[name].add(representative)
        assert direct_profile(inverse(t)) == v and bias(inverse(t)) == bias(t)
        if name.startswith("C"):
            assert inverse(t) not in translates
        for u in G:
            assert direct_profile(multiply(t, u)) == v
            if u in Q:
                assert bias(multiply(t, u)) == bias(t)
        partner = multiply(t, 19)
        assert partner != t and multiply(partner, 19) == t
    assert len(by_quotient) == 4
    assert all(c == {"C5": 4, "C15": 4} for c in by_quotient.values())
    assert count == predicted_counts()
    assert len(orbits) == 7 and all(len(o) == 8 for o in orbits.values())
    assert {k: len(v) for k, v in profile_orbits.items()} == {
        "Q5": 1, "Q3": 1, "Q15": 1, "C5": 2, "C15": 2}
    assert len({frozenset((t, multiply(t, 19))) for t in triples}) == 28
    bias_preservers = [u for u in G if all(bias(multiply(t, u)) == bias(t) for t in triples)]
    assert bias_preservers == [1, 19]
    for t in triples:
        equivalent = {multiply(s, u) for s in (t, inverse(t)) for u in G}
        assert equivalent == {s for s in triples if names[s] == names[t]}

    # Witnesses for false strengthened conclusions.
    assert bias((1, 11, 29)) == -1
    assert bias(multiply((1, 11, 29), 7)) == 3
    a, b = (7, 13, 17), (7, 17, 23)
    assert names[a] == names[b] == "Q5" and bias(a) == bias(b) == 3
    assert multiply(a, 19) != b
    a, b = (1, 7, 11), (1, 11, 13)
    assert inverse(a) == b and names[a] == names[b] == "C5"
    assert bias(a) == bias(b) == -1
    assert all(multiply(a, u) != b for u in G)
    assert multiply(a, 19) != b
    # Primes 2,3,5 are outside G; the only reduced prime <=7 is 7.
    assert (5 if 7 in a else -3) == 5
    assert (5 if 7 in b else -3) == -3
    unlabelled = {tuple(sorted(direct_profile(t))) for t in triples}
    assert len(unlabelled) == 2
    other = other_group_counterexamples()
    if check:
        check_csv(triples, names)
    return {
        "schema": "CU-BRUIT-02 structural quotient audit v1",
        "triplets": len(triples), "labelled_profiles": len(set(names.values())),
        "nonempty_bias_profile_classes": len(count), "pairs_times_19": 28,
        "translation_orbits": len(orbits),
        "translation_orbits_per_profile": {k: len(v) for k, v in sorted(profile_orbits.items())},
        "counts": {f"mu={mu},profile={p}": n for (mu, p), n in sorted(count.items())},
        "multipliers_preserving_bias_for_every_triple": bias_preservers,
        "same_profile_iff_translate_or_translate_of_inverse": "PASS finite check",
        "csv_semantic_comparison": "PASS 56 rows" if check else "not requested",
        "counterexamples": other,
        "unlabelled_profiles": len(unlabelled),
        "analytic_claims": "none; no GRH/LI, zero or sign-density certification",
        "proof_status": "written quotient proof; no independent human review or Lean formalization",
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--check", action="store_true", help="compare all 56 existing CSV rows")
    args = parser.parse_args()
    print(json.dumps(audit(args.check), indent=2, sort_keys=True))


if __name__ == "__main__":
    main()
