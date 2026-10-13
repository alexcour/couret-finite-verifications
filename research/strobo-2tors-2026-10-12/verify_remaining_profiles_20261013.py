#!/usr/bin/env python3
"""Independent enumeration of the remaining doubling profiles, stdlib only.

The square is built from all nine ordered pairs, never from a profile formula.
This bounded replay is not a universal proof or an independent expert audit.
"""
from collections import Counter, defaultdict
from itertools import combinations, product
from math import comb
import json
from pathlib import Path
from verify_strobo_2tors import GROUPS


def choose(n, k):
    return comb(n, k) if 0 <= k <= n else 0


def check(mods):
    G = list(product(*(range(m) for m in mods)))
    zero = tuple(0 for _ in mods)
    def add(a, b):
        return tuple((x+y) % m for x, y, m in zip(a, b, mods))
    def mul(k, a):
        return tuple(k*x % m for x, m in zip(a, mods))
    def translated(S, u):
        return tuple(sorted(add(s, u) for s in S))
    def square(S):
        return tuple(sorted(Counter(add(a, b) for a in S for b in S).items()))
    def profile(S):
        return tuple(sorted(Counter(mul(2, s) for s in S).values()))
    def diag(S):
        return Counter(mul(2, s) for s in S)
    def off(S):
        return Counter(add(a, b) for a, b in combinations(S, 2))
    H = [g for g in G if mul(2, g) == zero]
    H_set = set(H)
    h, n = len(H), len(G)
    q = n // h
    r3 = (sum(mul(3, g) == zero for g in G)-1)//2
    fibres = defaultdict(list)
    for S in combinations(G, 3):
        fibres[square(S)].append(S)
    counts, nozero = defaultdict(Counter), Counter()
    profile_supports, comparisons = Counter(), Counter()
    nontranslations = nontranslations_nozero = 0
    orbit_restriction_checks = 0
    for sq, members in fibres.items():
        S = members[0]
        p = profile(S)
        assert all(profile(T) == p for T in members), (mods, S, members)
        counts[p][len(members)] += 1
        profile_supports[p] += len(members)
        nozero[sum(zero not in T for T in members)] += 1
        H_orbit = {translated(S, u) for u in H}
        assert len(H_orbit) == h
        j = sum(s in H_set for s in S)
        assert sum(zero not in X for X in H_orbit) == h-j
        orbit_restriction_checks += 1
        if p in [(1, 1, 1), (3,)]:
            assert set(members) == H_orbit
            for T in members:
                assert diag(S) == diag(T)
                assert off(S) == off(T)
                assert len(off(T)) == 3 and all(v == 1 for v in off(T).values())
                comparisons[p] += 1
        else:
            assert p == (1, 2)
            if len(members) == 2*h:
                T = next(T for T in members if T not in H_orbit)
                assert all(translated(S, g) != T for g in G)
                second = {translated(T, u) for u in H}
                j2 = sum(t in H_set for t in T)
                assert len(second) == h
                assert sum(zero not in X for X in second) == h-j2
                orbit_restriction_checks += 1
                assert not H_orbit & second
                assert set(members) == H_orbit | second
                nontranslations += h*h
                nontranslations_nozero += sum(zero not in X for X in H_orbit)*sum(zero not in X for X in second)
            else:
                assert set(members) == H_orbit
    E = q*(h-1)*r3
    expected = {
        (1, 1, 1): Counter({h: h*h*choose(q, 3)}),
        (3,): Counter({h: q*choose(h, 3)//h}),
        (1, 2): Counter({h: q*(q-1)*h*(h-1)//2-2*E, 2*h: E}),
    }
    for p, exp in expected.items():
        assert +counts[p] == +exp, (mods, p, counts[p], exp)
    # Add contributions: sizes can coincide when h=2. Zero-sized fibres vanish.
    expected_nozero = Counter()
    for j in range(4):
        O = choose(h, j)*choose(n-h, 3-j)//h
        removed = [2*(q-2)*(h-1)*r3, 2*(h-1)*r3, 2*(h-1)*r3, 0][j]
        assert O >= removed
        expected_nozero[h-j] += O-removed
    expected_nozero[2*h] += (q-3)*(h-1)*r3
    expected_nozero[2*h-2] += 3*(h-1)*r3
    nozero.pop(0, None)
    expected_nozero.pop(0, None)
    assert +nozero == +expected_nozero, (mods, nozero, expected_nozero)
    assert nontranslations == q*h*h*(h-1)*r3
    assert nontranslations_nozero == (h-1)*r3*(q*h*h-6*h+1)
    return {"group": list(mods), "order": n, "h": h, "q": q,
            "triple_supports": choose(n, 3),
            "profile_supports": {str(p): profile_supports[p] for p in expected},
            "profile_fibres": {str(p): dict(+counts[p]) for p in expected},
            "zero_free_fibre_histogram": dict(+nozero),
            "reconstruction_comparisons": sum(comparisons.values()),
            "orbit_restriction_checks": orbit_restriction_checks}


def counterexamples():
    def inv(mods, S):
        def add(a,b): return tuple((x+y)%m for x,y,m in zip(a,b,mods))
        D = Counter(add(s,s) for s in S)
        R = Counter(add(a,b) for a in S for b in S)
        return D, R
    cases = [
        ((2,3), ((0,0),(0,1),(0,2)), ((1,0),(0,1),(0,2)), "same diagonals do not suffice in (1,1,1)"),
        ((2,2,2), ((0,0,0),(1,0,0),(0,1,0)), ((0,0,0),(1,0,0),(0,0,1)), "same diagonal does not suffice in (3)"),
        ((4,2), ((0,0),(2,0),(0,1)), ((0,0),(1,0),(3,0)), "one odd coefficient equal to 3 does not separate (3) from (1,2)"),
    ]
    result=[]
    for mods, S, T, claim in cases:
        D, R = inv(mods,S)
        D2, R2 = inv(mods,T)
        assert {z for z,v in R.items() if v%2} == {z for z,v in R2.items() if v%2}
        assert R != R2
        if mods != (4,2): assert D == D2
        else: assert R[(0,0)] == R2[(0,0)] == 3
        result.append({"group":mods,"S":S,"T":T,"refutes":claim})
    # A non-H translation can fix the support: subgroup C3 in C2 x C3.
    S = {(0,0),(0,1),(0,2)}
    assert { (a,(b+1)%3) for a,b in S } == S
    result.append({"group":(2,3),"S":sorted(S),"translation":(0,1),
                   "refutes":"every translation preserving a triple belongs to G[2]"})
    return result


if __name__ == "__main__":
    rows = [check(mods) for mods in GROUPS]
    report = {"status":"PASS", "scope":"bounded exact internal replay; not a universal or independently audited certificate",
              "groups":len(rows), "triple_supports":sum(r["triple_supports"] for r in rows),
              "reconstruction_comparisons":sum(r["reconstruction_comparisons"] for r in rows),
              "orbit_restriction_checks":sum(r["orbit_restriction_checks"] for r in rows),
              "counterexamples":counterexamples(), "results":rows}
    path=Path(__file__).with_name("remaining_profiles_results_20261013.json")
    path.write_text(json.dumps(report,ensure_ascii=False,indent=2)+"\n")
    print(json.dumps({k:v for k,v in report.items() if k not in ("results","counterexamples")}))
