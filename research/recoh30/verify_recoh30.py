#!/usr/bin/env python3
"""RECOH-30 v0.1: exact finite Fourier reconstruction tests.

Scope: U(30) spectral fiber and U(210)->U(30) signed transport.
Finite, exact, standard-library-only; no global analytic claim.
"""
from collections import Counter
from itertools import combinations
from math import gcd
import hashlib
import json
from pathlib import Path

G30 = tuple(a for a in range(30) if gcd(a, 30) == 1)
G210 = tuple(a for a in range(210) if gcd(a, 210) == 1)
assert len(G30) == 8 and len(G210) == 48

# U(30) = <11> x <7> with orders 2 and 4.
coord = {}
for e in range(2):
    for k in range(4):
        a = pow(11, e, 30) * pow(7, k, 30) % 30
        assert a not in coord
        coord[a] = (e, k)
assert set(coord) == set(G30)

POW_I = ((1, 0), (0, 1), (-1, 0), (0, -1))
CHAR30 = tuple((u, v) for u in range(2) for v in range(4))
NONTRIV = tuple(c for c in CHAR30 if c != (0, 0))
QUADRATIC = tuple(c for c in NONTRIV if c[1] % 2 == 0)

def chi30(c, a):
    u, v = c
    e, k = coord[a]
    return POW_I[(2 * u * e + v * k) % 4]

def fourier30(c, support):
    return tuple(sum(chi30(c, a)[j] for a in support) for j in (0, 1))

def phi1(support):
    return tuple(sorted(fourier30(c, support) for c in CHAR30))

TRIPLES = tuple(combinations(G30, 3))
assert len(TRIPLES) == 56
TC = (1, 11, 29)
spectrum = phi1(TC)
FIBER = tuple(t for t in TRIPLES if phi1(t) == spectrum)
assert set(FIBER) == {
    (1, 19, 29), (1, 11, 29), (1, 11, 19), (1, 7, 13), (1, 17, 23)
}
assert Counter(spectrum) == {(3, 0): 2, (1, 0): 4, (-1, 0): 2}

# Each permitted probe is ONE labeled Fourier coefficient.
def sig30(probes, support):
    return tuple(fourier30(c, support) for c in probes)

def separates30(probes):
    return len(set(sig30(probes, t) for t in FIBER)) == len(FIBER)

counts = {}
global_budget = None
global_winners = []
for m in range(1, len(NONTRIV) + 1):
    winners = [p for p in combinations(NONTRIV, m) if separates30(p)]
    counts[str(m)] = len(winners)
    if winners:
        global_budget, global_winners = m, winners
        break
assert global_budget == 3 and len(global_winners) == 12
assert not separates30(QUADRATIC)

# Even ALL quadratic characters do not separate these two triples.
a, c = (1, 19, 29), (1, 11, 19)
assert all(fourier30(ch, a) == fourier30(ch, c) for ch in QUADRATIC)
assert fourier30((0, 1), a) != fourier30((0, 1), c)

# Isolation of TC is a different problem than global reconstruction.
isolating = []
for m in range(1, len(NONTRIV) + 1):
    isolating = [
        p for p in combinations(NONTRIV, m)
        if all(sig30(p, t) != sig30(p, TC) for t in FIBER if t != TC)
    ]
    if isolating:
        break
assert m == 2 and ((0, 2), (1, 0)) in isolating

# U(210) lifts of class 11 modulo 30.
LIFTS = tuple(x for x in G210 if x % 30 == 11)
assert LIFTS == (11, 41, 71, 101, 131, 191)

# Twice the signed group-algebra operator D_x = (P_x - P_(x^-1))/2.
def operator(x):
    y = pow(x, -1, 210)
    return tuple() if x == y else tuple(sorted(((x, 1), (y, -1))))

ops = {x: operator(x) for x in LIFTS}
assert len(set(ops.values())) == 5
assert ops[41] == ops[71] == ()

# The coarse pullback is annihilated, exactly.
for x in LIFTS:
    inv = pow(x, -1, 210)
    for state in G210:
        assert (x * state) % 30 == (inv * state) % 30

def orbit_count_square(x):
    sq = x * x % 210
    remaining = set(G210)
    count = 0
    while remaining:
        state = next(iter(remaining))
        orbit = set()
        while state not in orbit:
            orbit.add(state)
            state = state * sq % 210
        assert orbit <= remaining
        remaining -= orbit
        count += 1
    return count

ranks = {x: 48 - orbit_count_square(x) for x in LIFTS}
assert ranks == {11: 32, 41: 0, 71: 0, 101: 32, 131: 32, 191: 32}

# U(7)=<3> has order 6. Im(chi_k(x)) scaled by 2/sqrt(3).
powers = tuple(pow(3, j, 7) for j in range(6))
assert powers == (1, 3, 2, 6, 4, 5)
discrete_log = {a: j for j, a in enumerate(powers)}
SIN6 = (0, 1, 1, 0, -1, -1)

def sig210(probes, x):
    j = discrete_log[x % 7]
    return tuple(SIN6[(k * j) % 6] for k in probes)

def separates210(probes):
    signatures = {}
    for x in LIFTS:
        op, sig = ops[x], sig210(probes, x)
        if op in signatures:
            assert signatures[op] == sig
        else:
            signatures[op] = sig
    return len(set(signatures.values())) == len(signatures)

assert not any(separates210((k,)) for k in range(6))
pairs = tuple(p for p in combinations(range(1, 6), 2) if separates210(p))
assert pairs == ((1, 2), (1, 4), (2, 5), (4, 5))

certificate = {
    "protocol": "RECOH-30-v0.1",
    "status": "exact finite Python assertions PASS; Lean, prior art, peer review NOT audited",
    "num_triples_checked": len(TRIPLES),
    "spectral_fiber_size": len(FIBER),
    "spectral_fiber": FIBER,
    "minimal_Fourier_probe_budget_global": global_budget,
    "num_separating_triples": len(global_winners),
    "example_global_probes": global_winners[0],
    "minimal_Fourier_probe_budget_TC_only": 2,
    "lifts_mod210": LIFTS,
    "distinct_signed_operators": len(set(ops.values())),
    "ranks": ranks,
    "minimal_fiber_character_budget_operators": 2,
    "separating_pairs": pairs,
    "boundaries": [
        "Only individual labeled Fourier-character probes are allowed.",
        "The target is a 5-object spectral fiber, not all subsets.",
        "The second target is 5 signed operators, not 6 origin lifts.",
        "No global analytic, novelty, or Riemann-hypothesis claim."
    ]
}
out = Path(__file__).with_name("recoh30_certificate.json")
out.write_text(json.dumps(certificate, indent=2, sort_keys=True) + "\n")
print("RECOH-30 EXACT PASS")
print("56 triples / 5 spectral supports / global 3 probes / TC-only 2")
print("6 lifts / 5 signed operators / 2 fiber-character probes")
print("Certificate SHA256:", hashlib.sha256(out.read_bytes()).hexdigest())
