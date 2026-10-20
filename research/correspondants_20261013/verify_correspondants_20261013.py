#!/usr/bin/env python3
"""COURET - finite exact reproducible checks for correspondents follow-up (2026-10-13).

Status: finite arithmetic verification, NOT a formal proof, zero certification,
external review, or a theorem about asymptotic prime-race convergence.

Run: python3 verify_correspondants_20261013.py > RESULTS.json
Only Python standard library.
"""
import json
from collections import Counter
from itertools import combinations, product
from math import gcd, log, comb


UNITS30 = tuple(a for a in range(30) if gcd(a, 30) == 1)
TRIPLE30 = frozenset((1, 11, 29))
S_CYCLIC = (1, 5, 17)


def ch3(a):
    return 0 if a % 3 == 1 else 1


def ch5(a):
    return {1: 0, 2: 1, 4: 2, 3: 3}[a % 5]


def character(a, u, v):
    """Character chi_(u,v) of U(30), returned in exact Gaussian integers."""
    z = ((1, 0), (0, 1), (-1, 0), (0, -1))[(v * ch5(a)) % 4]
    sign = (-1) ** (u * ch3(a))
    return sign * z[0], sign * z[1]


def coefficient(signal, u, v):
    real = imag = 0
    for a in UNITS30:
        re, im = character(a, u, v)
        real += signal[a] * re
        imag -= signal[a] * im
    assert real % 8 == imag % 8 == 0
    return real // 8, imag // 8


def fourier30():
    signal = {a: 5 if a in TRIPLE30 else -3 for a in UNITS30}
    assert sum(signal.values()) == 0
    coeff = {(u, v): coefficient(signal, u, v) for u in (0, 1) for v in range(4)}
    expected = {
        (0, 0): (0, 0), (0, 1): (1, 0), (0, 2): (3, 0), (0, 3): (1, 0),
        (1, 0): (-1, 0), (1, 1): (1, 0), (1, 2): (-1, 0), (1, 3): (1, 0),
    }
    assert coeff == expected
    pullback = {a: signal[(a * a) % 30] for a in UNITS30}
    coeff_pullback = {(u, v): coefficient(pullback, u, v)
                      for u in (0, 1) for v in range(4)}
    assert coeff_pullback == {
        (0, 0): (1, 0), (0, 1): (0, 0), (0, 2): (4, 0), (0, 3): (0, 0),
        (1, 0): (0, 0), (1, 1): (0, 0), (1, 2): (0, 0), (1, 3): (0, 0),
    }
    assert all(im == 0 for re, im in coeff.values())
    lambda_t = sum(abs(re) + abs(im) for re, im in coeff.values())
    lambda_star = sum(abs(re) + abs(im) for re, im in coeff_pullback.values())
    assert lambda_t == 9 and lambda_star == 5
    counts = Counter((3 if u else 1) * (5 if v else 1)
                     for (u, v), z in coeff.items() if z != (0, 0))
    assert dict(counts) == {5: 3, 3: 1, 15: 3}
    product_q = 1
    for q, multiplicity in counts.items():
        product_q *= q ** multiplicity
    assert product_q == 3**4 * 5**6 == 1265625
    c_t = max(9 * log(30)**2, 5 * log(30))
    l_k = log(product_q)
    assert abs(l_k - (4 * log(3) + 6 * log(5))) < 1e-12
    return {
        "assumptions": "Only the finite Fourier identities; no GRH or ELI_A invoked for computations",
        "units_mod30": UNITS30,
        "weights": {str(a): signal[a] for a in UNITS30},
        "characters_gaussian_exact": {f"chi_{u}{v}": list(coeff[u, v]) for u in (0,1) for v in range(4)},
        "pullback_characters_gaussian_exact": {f"chi_{u}{v}": list(coeff_pullback[u, v]) for u in (0,1) for v in range(4)},
        "lambda_t": lambda_t,
        "lambda_t_square_pullback": lambda_star,
        "fourier_support_size": 7,
        "conductor_multiplicities": {str(q): counts[q] for q in sorted(counts)},
        "product_conductors_exact": product_q,
        "support_log_k_approx": l_k,
        "k_geometric_mean_approx": product_q ** (1 / 7),
        "C_t_approx": c_t,
        "epsilon_available": 3,
    }


def divisors(n):
    return [d for d in range(1, n + 1) if n % d == 0]


def mobius(n):
    if n == 1: return 1
    factors = 0
    p = 2
    while p*p <= n:
        if n % p == 0:
            n //= p
            factors += 1
            if n % p == 0: return 0
        p += 1
    return (-1) ** (factors + (n > 1))


def ramanujan(d, m):
    """Exact Ramanujan sum c_d(m) = sum_{e|gcd(d,m)} e * mu(d/e)."""
    return sum(e * mobius(d // e) for e in divisors(gcd(d, abs(m))))


def convolution(n, support):
    return tuple(Counter((a+b) % n for a in support for b in support)[x] for x in range(n))


def prime_powers(n):
    result = []
    p = 2
    while p * p <= n:
        if n % p == 0:
            power = 1
            while n % p == 0:
                n //= p
                power *= p
            result.append(power)
        p += 1
    if n > 1: result.append(n)
    return result


def affine_support_class(n, base, candidate):
    b = set(base)
    q = set(candidate)
    shifts = [t for t in range(n) if {(a+t)%n for a in b} == q]
    reflected_shifts = [t for t in range(n) if {(-a+t)%n for a in b} == q]
    unit_multipliers = [u for u in range(n) if gcd(u,n)==1
                        and {(a*u)%n for a in b} == q]
    return {
        "translated": bool(shifts), "translation_shift_witnesses": shifts,
        "inverted_then_translated": bool(reflected_shifts),
        "reflection_shift_witnesses": reflected_shifts,
        "group_unit_multiple": bool(unit_multipliers),
        "unit_multiplier_witnesses": unit_multipliers,
    }


def cyclic_phase_signs(n, base):
    """Exact DFT sign enumeration by rational Galois orbit (indexed by order d|n)."""
    dlist = divisors(n)
    R = {d: [sum(ramanujan(d, a-x) for a in base) for x in range(n)] for d in dlist}
    nonzero_orbits = [d for d in dlist if any(z != 0 for z in R[d])]
    assert nonzero_orbits == dlist, "Redundant signs on zero Fourier orbits: adjust counting."
    mods = prime_powers(n)
    local_counts = {str(m): 0 for m in mods}
    all_integer = 0
    all_binary = 0
    distinct = set()
    for bits in product((-1, 1), repeat=len(dlist)-1):
        signs = {1: 1, **dict(zip(dlist[1:], bits))}
        nums = [sum(signs[d] * R[d][x] for d in dlist) for x in range(n)]
        for m in mods:
            if all(z % m == 0 for z in nums):
                local_counts[str(m)] += 1
        if all(z % n == 0 for z in nums):
            all_integer += 1
            vals = [z // n for z in nums]
            if all(v in (0, 1) for v in vals):
                all_binary += 1
                candidate = tuple(x for x, v in enumerate(vals) if v == 1)
                assert sum(vals) == len(base)
                assert convolution(n, candidate) == convolution(n, base)
                distinct.add(candidate)
    assert all_binary == len(distinct)
    # Independent brute-force oracle over all subsets of the prescribed cardinality.
    # Independent 9-term ordered-sum multiset, rather than Ramanujan inversion.
    target_counts = Counter((a+b) % n for a in base for b in base)
    direct = {S for S in combinations(range(n), len(base))
              if Counter((a+b) % n for a in S for b in S) == target_counts}
    assert direct == distinct, (direct, distinct)
    return {
        "n": n,
        "support_initial": list(base),
        "divisors": dlist,
        "all_orbits_nonzero": True,
        "raw_signs": 2**(len(dlist)-1),
        "prime_power_local_counts": local_counts,
        "global_integer_solutions": all_integer,
        "global_binary_solutions": all_binary,
        "independent_bruteforce_checked_subsets": comb(n,len(base)),
        "independent_bruteforce_matches": len(direct),
        "solutions": [
            {"set": list(S), "relationship_to_initial": affine_support_class(n, base, S)}
            for S in sorted(distinct)
        ],
    }


def reciprocal_components(n, support):
    """Undirected components of reciprocal arcs, loop-free Cayley digraph."""
    s = set(a % n for a in support)
    assert 0 not in s
    reciprocal = {a for a in s if -a % n in s}
    if not reciprocal: return []
    unseen = set(range(n)); components = []
    while unseen:
        root = unseen.pop(); stack=[root]; size=1
        while stack:
            x=stack.pop()
            for a in reciprocal:
                y=(x+a)%n
                if y in unseen:
                    unseen.remove(y);size+=1;stack.append(y)
        components.append(size)
    return sorted(components)


def graph_checks():
    # Illustrates the structural certificate: this is NOT a claimed
    # adjacency-cospectral pair or the exact Royle correspondents' supports.
    assert reciprocal_components(12, (1,11)) == [12]
    assert reciprocal_components(12, (3,9)) == [4,4,4]
    assert reciprocal_components(24, (1,5,17)) == []
    return {"n12_reciprocal_arc_toy": {
        "S_equal_plus_minus_1": [12], "S_equal_plus_minus_3": [4,4,4],
        "warning": "Illustrates invariant only; does NOT establish cospectrality or reproduce Royle pair"},
        "n24_reciprocal_empty_for_initial": True}


def main():
    import sys
    assert len(sys.argv) <= 2 and (len(sys.argv) == 1 or sys.argv[1] == "--extended"), \
        "Usage: python3 verify_correspondants_20261013.py [--extended]"
    data={"date": "2026-10-13", "status": "FINITE_EXACT_INTERNAL_NOT_EXTERNALLY_AUDITED",
          "race_mod_30": fourier30(),
          "cyclotomic_signs_n24": cyclic_phase_signs(24,S_CYCLIC),
          "cyclotomic_signs_n40": cyclic_phase_signs(40,S_CYCLIC),
          "graph_reciprocal_toy": graph_checks(),
          "tests": "PASS"}
    assert data["cyclotomic_signs_n24"]["raw_signs"] == 128
    assert data["cyclotomic_signs_n24"]["prime_power_local_counts"] == {"8":8,"3":64}
    assert data["cyclotomic_signs_n24"]["global_integer_solutions"] == 4
    assert data["cyclotomic_signs_n40"]["prime_power_local_counts"] == {"8":8,"5":8}
    assert data["cyclotomic_signs_n40"]["global_integer_solutions"] == 2
    if len(sys.argv) == 2:
        data["extended_moduli"] = {
            str(n): cyclic_phase_signs(n, S_CYCLIC) for n in (32,48,56,60,72,80)
        }
        for n, row in data["extended_moduli"].items():
            assert row["global_binary_solutions"] == 2, (n,row)
            half_shift = tuple(sorted((a + int(n)//2) % int(n) for a in S_CYCLIC))
            assert {tuple(item["set"]) for item in row["solutions"]} == {
                tuple(S_CYCLIC), half_shift}, (n,row)
    print(json.dumps(data,indent=2,ensure_ascii=False,sort_keys=True))

if __name__ == '__main__':
    main()
