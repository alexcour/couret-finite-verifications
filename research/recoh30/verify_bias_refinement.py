#!/usr/bin/env python3
"""Finite U(30) regression: labelled convolution, square-root bias, probe cost.

Only finite integer/Gaussian-integer arithmetic, standard-library Python.
Does not prove anything about analytic prime-race densities, GRH or novelty.
"""
from collections import Counter, defaultdict
from itertools import combinations
from math import gcd
from pathlib import Path
import hashlib
import json

G = tuple(x for x in range(30) if gcd(x, 30) == 1)
assert G == (1, 7, 11, 13, 17, 19, 23, 29)
H = tuple(x for x in G if x*x % 30 == 1)
K = tuple(sorted({x*x % 30 for x in G}))
assert H == (1, 11, 19, 29) and K == (1, 19)
COORD = {(pow(11, a, 30) * pow(7, b, 30)) % 30: (a, b)
         for a in (0, 1) for b in range(4)}
assert len(COORD) == len(G)
ROOTS = ((1, 0), (0, 1), (-1, 0), (0, -1))
PROBES = tuple((u, v) for u in range(2) for v in range(4)
               if (u, v) != (0, 0))
TRIPLES = tuple(combinations(G, 3))
assert len(TRIPLES) == 56 and len(PROBES) == 7


def ordered_square(t):
    counts = Counter(a*b % 30 for a in t for b in t)
    return tuple(counts[g] for g in G)


def bias_constant(t):
    c = {g: 8*int(g in t)-3 for g in G}
    r = Counter(a*a % 30 for a in G)
    q = -sum(c[g]*(r[g]-1) for g in G)
    assert q % 8 == 0
    return q // 8


def character_sum(ch, t):
    u, v = ch
    values = [ROOTS[(2*u*COORD[g][0]+v*COORD[g][1]) % 4]
              for g in t]
    z = (sum(a for a, _ in values), sum(b for _, b in values))
    assert z != (0, 0)  # An odd number of fourth roots cannot sum to zero.
    return z


def spectrum(t):
    return tuple(sorted(character_sum((u, v), t)
                        for u in range(2) for v in range(4)))


R = {t: ordered_square(t) for t in TRIPLES}
MU = {t: bias_constant(t) for t in TRIPLES}
F = {(t, p): character_sum(p, t) for t in TRIPLES for p in PROBES}
groups_r, groups_aug = defaultdict(list), defaultdict(list)
for t in TRIPLES:
    groups_r[R[t]].append(t)
    groups_aug[(R[t], MU[t])].append(t)

assert len(groups_r) == 14
assert Counter(map(len, groups_r.values())) == {4: 14}
assert len(groups_aug) == 23
assert Counter(map(len, groups_aug.values())) == {2: 18, 4: 5}
assert Counter(MU.values()) == {3: 20, -1: 30, -5: 6}
for t in TRIPLES:
    orbit = {tuple(sorted(h*x % 30 for x in t)) for h in H}
    assert orbit == set(groups_r[R[t]])
    assert MU[t] == 3-4*len(set(t) & set(K))


def signature(t, probes):
    return tuple(F[(t, p)] for p in probes)


def separates_all(probes, groups):
    return all(len({signature(t, probes) for t in members}) == len(members)
               for members in groups.values())


def isolates(t, probes, groups, augmented):
    members = groups[(R[t], MU[t])] if augmented else groups[R[t]]
    return all(signature(t, probes) != signature(other, probes)
               for other in members if other != t)


winning = {}
for m in range(len(PROBES)+1):
    winning[m] = [ps for ps in combinations(PROBES, m)
                  if separates_all(ps, groups_aug)]
assert not winning[0] and not winning[1] and len(winning[2]) == 12
assert separates_all(((0, 1), (1, 0)), groups_aug)
assert separates_all(((0, 1), (1, 0)), groups_r)
assert not any(separates_all((p,), groups_r) for p in PROBES)

target_aug, target_r = {}, {}
for t in TRIPLES:
    for m in range(len(PROBES)+1):
        candidates = combinations(PROBES, m)
        if t not in target_aug and any(isolates(t, ps, groups_aug, True)
                                       for ps in candidates):
            target_aug[t] = m
        if t not in target_r and any(isolates(t, ps, groups_r, False)
                                     for ps in combinations(PROBES, m)):
            target_r[t] = m
assert Counter(target_aug.values()) == {1: 36, 2: 20}
assert Counter(target_r.values()) == {2: 56}

# The 12 universal pairs are exactly independent restrictions to H.
def restriction(p):
    return p[0], p[1] % 2  # Signs at the involutions 11, 19.

predicted = {
    pair for pair in combinations(PROBES, 2)
    if all(restriction(p) != (0, 0) for p in pair)
    and restriction(pair[0]) != restriction(pair[1])
}
assert set(winning[2]) == predicted and len(predicted) == 12

B, C, D = (1, 11, 29), (1, 11, 19), (1, 7, 13)
assert R[B] == R[C] and MU[B] == -1 and MU[C] == -5
assert spectrum(B) == spectrum(D) and R[B] != R[D]
G24 = tuple(x for x in range(24) if gcd(x, 24) == 1)
assert len(G24) == 8 and all(x*x % 24 == 1 for x in G24)
r24 = Counter(x*x % 24 for x in G24)
def mu24(t):
    c = {g: 8*int(g in t)-3 for g in G24}
    val = -sum(c[g]*(r24[g]-1) for g in G24)
    assert val % 8 == 0
    return val // 8
t24 = [(1, a, b) for a, b in combinations(G24[1:], 2)]
assert len(t24) == 21 and {mu24(t) for t in t24} == {-5}

cert = {
    "date": "2026-10-14",
    "scope": "finite U30 labelled convolution + algebraic bias + Fourier probes",
    "status": "exact Python finite checks; no Lean, external review or analytic claim",
    "triples": len(TRIPLES),
    "convolution_fibres": len(groups_r),
    "augmented_states": len(groups_aug),
    "augmented_fibre_sizes": dict(Counter(map(len, groups_aug.values()))),
    "bias_counts": dict(Counter(MU.values())),
    "universal_minimum_after_R_mu": 2,
    "universal_2probe_banks": [[list(ch) for ch in bank] for bank in winning[2]],
    "universal_banks_by_size": {str(k): len(v) for k, v in winning.items()},
    "targeted_minimum_after_R_only": dict(Counter(target_r.values())),
    "targeted_minimum_after_R_mu": dict(Counter(target_aug.values())),
    "negative_fixtures": ["R does not determine bias",
                          "spectrum multiset does not determine labelled R",
                          "U24 identity triple bias cannot isolate candidates"],
    "publication_boundary": "review branch only; no merge, stable release or novelty claim",
}
p = Path(__file__).with_name("recoh_bias_refinement_certificate.json")
p.write_text(json.dumps(cert, indent=2, sort_keys=True) + "\n", encoding="utf-8")
print("RECOH BIAS/PROBES FINITE EXACT PASS")
print("56 supports; 14 convolution fibres; 23 augmented states")
print("targeted: 36 at 1 probe, 20 at 2; universal: 2 probes, 12 pairs")
print("Certificate SHA256:", hashlib.sha256(p.read_bytes()).hexdigest())
