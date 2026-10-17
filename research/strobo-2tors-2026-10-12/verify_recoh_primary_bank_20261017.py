"""Exact bounded replay of the fixed primary-character construction.

Groups are products of cyclic prime-power factors. Character sums are stored
in the integral power basis of the appropriate cyclotomic field; no floating
point comparison is used. This checks the observable and the construction,
not the universal lower bound (which is a separate Lean theorem).
"""

from collections import Counter
from itertools import combinations, product
import json
from pathlib import Path


CASES = [
    (3,), (5,), (9,), (3, 3), (4,), (8,), (2, 2), (2, 4),
    (2, 3), (4, 3), (2, 9), (4, 9), (8, 9),
    (4, 4, 3), (2, 3, 3), (2, 9, 3), (8, 3, 3),
]


def primary_base(q):
    for p in (2, 3, 5):
        t = q
        while t % p == 0:
            t //= p
        if t == 1:
            return p
    raise ValueError(f"Unsupported prime-power factor: {q}")


def root_sum_key(exponents, q, p):
    """Reduce modulo Phi_(p^a)=sum_j X^(j*p^(a-1))."""
    coeff = [0] * q
    for e in exponents:
        coeff[e % q] += 1
    stride = q // p
    for j in range(p - 1):
        for t in range(stride):
            coeff[j * stride + t] -= coeff[(p - 1) * stride + t]
    return tuple(coeff[: (p - 1) * stride])


def check_group(moduli):
    points = list(product(*(range(q) for q in moduli)))
    index = {x: i for i, x in enumerate(points)}
    bases = [primary_base(q) for q in moduli]
    r, s = bases.count(2), bases.count(3)
    selected = [j for j, p in enumerate(bases) if p in (2, 3)] if r else []
    budget = r + s if r else 0
    assert len(selected) == budget
    addition = [[index[tuple((a[j] + b[j]) % q for j, q in enumerate(moduli))]
                 for b in points] for a in points]
    observed, squares = {}, Counter()
    total = 0
    for support in combinations(range(len(points)), 3):
        square = tuple(sorted(Counter(addition[a][b]
                                     for a in support for b in support).items()))
        assert sum(multiplicity for _, multiplicity in square) == 9
        probes = tuple(root_sum_key((points[a][j] for a in support),
                                    moduli[j], bases[j]) for j in selected)
        key = square, probes
        assert key not in observed, (moduli, observed.get(key), support)
        observed[key] = support
        squares[square] += 1
        total += 1
    return {
        "cyclic_factors": list(moduli), "order": len(points),
        "r": r, "s": s, "constructed_bank_size": budget,
        "supports": total, "square_fibres": len(squares),
        "ambiguous_pairs_before_probes": sum(n * (n - 1) // 2 for n in squares.values()),
        "collisions_after_probes": 0,
    }


def main():
    groups = [check_group(moduli) for moduli in CASES]
    result = {
        "model": "labelled ordered square, exactly three distinct support points, zero allowed; fixed individual complex primary-character coefficients",
        "arithmetic": "exact integer cyclotomic power-basis coefficients",
        "scope": "bounded replay of construction, not a universal proof or independent human review",
        "groups": groups,
        "total_supports": sum(g["supports"] for g in groups),
        "total_ambiguous_pairs_before_probes": sum(g["ambiguous_pairs_before_probes"] for g in groups),
        "total_collisions_after_probes": 0,
    }
    path = Path(__file__).with_name("recoh_primary_bank_results_20261017.json")
    path.write_text(json.dumps(result, indent=2, sort_keys=True) + "\n")
    print(json.dumps({k: v for k, v in result.items() if k != "groups"}, sort_keys=True))


if __name__ == "__main__":
    main()
