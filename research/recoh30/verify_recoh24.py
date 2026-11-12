#!/usr/bin/env python3
"""RECOH-24: exact character probe budgets on U(24) (C2)^3.

A probe is exactly one labeled character Fourier coefficient.
The 21 spectral-fiber triples need 2 probes to isolate any fixed
triple, and 6 probes to reconstruct all 21 simultaneously.
Finite exact arithmetic only; no novelty or global analytic claim.
"""
from collections import Counter
from itertools import combinations
from math import gcd
from pathlib import Path
import hashlib
import json

G = tuple(x for x in range(24) if gcd(x, 24) == 1)
assert G == (1, 5, 7, 11, 13, 17, 19, 23)
# Multiplicative basis: 5,7,13, each of order 2.
coords = {}
for mask in range(8):
    x = 1
    for j, gen in enumerate((5, 7, 13)):
        if mask & (1 << j):
            x = x * gen % 24
    assert x not in coords
    coords[x] = mask
assert set(coords) == set(G)

CHARS = tuple(range(1, 8))

def chi(u, x):
    return 1 - 2 * ((u & coords[x]).bit_count() % 2)

def fourier(u, triple):
    return sum(chi(u, x) for x in triple)

def spectrum(triple):
    return tuple(sorted(fourier(u, triple) for u in range(8)))

all_triples = tuple(combinations(G, 3))
target = (1, 5, 7)
fiber = tuple(t for t in all_triples if spectrum(t) == spectrum(target))
assert len(all_triples) == 56 and len(fiber) == 21
assert set(fiber) == {(1, a, b) for a,b in combinations(G[1:], 2)}
assert Counter(spectrum(target)) == {-1:2,1:4,3:2}

def signature(probes, t):
    return tuple(fourier(u, t) for u in probes)

def separates_all(probes):
    return len(set(signature(probes, t) for t in fiber)) == len(fiber)

winners = {}
for m in range(1, 8):
    winners[m] = tuple(p for p in combinations(CHARS, m)
                       if separates_all(p))
assert [len(winners[m]) for m in range(1,8)] == [0,0,0,0,0,7,1]

# For any two omitted characters u != v:
# d=(chi_u-chi_v)/2 is +/-1 twice each, and zero at the identity.
# The positive/negative supports, each joined to {1},
# are different triples indistinguishable on other characters.
collisions = []
for u, v in combinations(CHARS, 2):
    plus = tuple(x for x in G if (chi(u,x)-chi(v,x))//2 == 1)
    minus = tuple(x for x in G if (chi(u,x)-chi(v,x))//2 == -1)
    assert len(plus) == len(minus) == 2
    assert 1 not in plus and 1 not in minus
    ta = tuple(sorted((1, *plus)))
    tb = tuple(sorted((1, *minus)))
    assert ta in fiber and tb in fiber and ta != tb
    observed = tuple(z for z in CHARS if z not in (u,v))
    assert signature(observed,ta) == signature(observed,tb)
    collisions.append({'missing': (u,v), 'collision': (ta,tb)})
assert len(collisions) == 21

# Isolate each fixed T with two characters (not one).
isolators = []
for t in fiber:
    for u in CHARS:
        assert any(signature((u,),t)==signature((u,),q) for q in fiber if q!=t)
    pairs = tuple(p for p in combinations(CHARS,2)
                  if all(signature(p,t)!=signature(p,q) for q in fiber if q!=t))
    assert len(pairs) == 3
    a,b = t[1:]
    eta = next(u for u in CHARS if fourier(u,t)==3)
    psi = next(u for u in CHARS if chi(u,a)==chi(u,b)==-1)
    assert tuple(sorted((eta,psi))) in pairs
    isolators.append({'triple': t, 'isolators': pairs})

report = {
  'protocol':'RECOH-24-v0.2',
  'U24_units':G,
  'U24_generators':(5,7,13),
  'triples_tested':len(all_triples),
  'spectral_fiber_size':len(fiber),
  'minimal_targeted_character_probes':2,
  'minimal_global_character_probes':6,
  'universal_winners_by_budget':{str(m):len(winners[m]) for m in winners},
  'omitted_pair_collisions':collisions,
  'targeted_isolators':isolators,
  'boundary':'exact finite Python check; no Lean, novelty, or global analytic claim',
}
out=Path(__file__).with_name('recoh24_certificate.json')
out.write_text(json.dumps(report,sort_keys=True,indent=2)+'\n')
print('RECOH-24 EXACT PASS: 56 triples, 21 in fiber')
print('Targeted characters=2, global characters=6')
print('All 21 omitted-character-pair collisions explicitly certified')
print('SHA256',hashlib.sha256(out.read_bytes()).hexdigest())
