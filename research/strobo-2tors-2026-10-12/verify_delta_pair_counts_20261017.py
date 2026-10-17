#!/usr/bin/env python3
"""Direct finite checks of the universal delta-pair formulae, zero allowed.

Enumerate every three-element support, calculate the nine labelled ordered
sums (including the diagonal), and compare unordered pairs within each
actual square fibre. Translation tests inspect the concrete group elements;
no Lean theorem, exceptional normal form, or repository classifier is used.

The JSON on stdout is deterministic. These bounded checks are independent
evidence, not a proof for every finite abelian group or a novelty claim.
"""

from collections import defaultdict
from itertools import combinations, product
import json
from math import comb


def require(condition, message, **context):
    if not condition:
        raise AssertionError(f"{message}: {context}")


def nat_sub(a, b):
    """Natural-number subtraction, including the small-group cases."""
    return max(a - b, 0)


def exact_quotient(numerator, denominator, moduli, label):
    quotient, remainder = divmod(numerator, denominator)
    require(remainder == 0, "Nonintegral predicted count", moduli=moduli,
            label=label, numerator=numerator, denominator=denominator)
    return quotient


def check_group(moduli):
    elements = tuple(product(*(range(modulus) for modulus in moduli)))
    element_index = {element: index for index, element in enumerate(elements)}
    n = len(elements)
    zero = element_index[(0,) * len(moduli)]
    addition = tuple(
        tuple(element_index[tuple((x + y) % modulus
                                  for x, y, modulus in zip(a, b, moduli))]
              for b in elements)
        for a in elements
    )
    two_torsion = tuple(x for x in range(n) if addition[x][x] == zero)
    h = len(two_torsion)
    t = sum(addition[addition[x][x]][x] == zero for x in range(n))

    # The vector indices retain the labels z in R_S(z); sorting the counts
    # themselves would lose those labels and would check a different problem.
    fibres = defaultdict(list)
    support_count = 0
    for support in combinations(range(n), 3):
        signature = [0] * n
        for x in support:
            for y in support:
                signature[addition[x][y]] += 1
        fibres[tuple(signature)].append(support)
        support_count += 1

    delta_counts = {2: 0, 4: 0, 6: 0}
    ordinary_counts = {2: 0, 4: 0, 6: 0}
    nontranslation_counts = {2: 0, 4: 0, 6: 0}

    def translate(support, shift):
        return tuple(sorted(addition[x][shift] for x in support))

    for fibre in fibres.values():
        for index, left in enumerate(fibre[:-1]):
            ordinary_translates = {translate(left, u) for u in two_torsion}
            all_translates = (ordinary_translates if h == n else
                              {translate(left, u) for u in range(n)})
            left_set = set(left)
            for right in fibre[index + 1:]:
                delta = len(left_set.symmetric_difference(right))
                require(delta in delta_counts, "Unexpected delta", moduli=moduli,
                        left=left, right=right, delta=delta)
                delta_counts[delta] += 1
                if right in ordinary_translates:
                    ordinary_counts[delta] += 1
                else:
                    require(right not in all_translates,
                            "Equal-square translated pair lacks a two-torsion witness",
                            moduli=moduli, left=left, right=right)
                    nontranslation_counts[delta] += 1

    expected_two = exact_quotient(
        n * nat_sub(n, 2) * nat_sub(h, 1), 4, moduli, "delta_two")
    expected_four = exact_quotient(
        n * nat_sub(h, 1) * nat_sub(t, 1), 2, moduli, "delta_four")
    expected_six_ordinary = exact_quotient(
        n * nat_sub(n, 2) * nat_sub(n, 4) * nat_sub(h, 1),
        12, moduli, "delta_six_ordinary")
    expected_six_nontranslation = exact_quotient(
        n * nat_sub(h, 1) ** 2 * nat_sub(t, 1),
        2, moduli, "delta_six_nontranslation")
    expected = {
        2: expected_two,
        4: expected_four,
        6: expected_six_ordinary + expected_six_nontranslation,
    }

    require(delta_counts == expected, "Delta formula mismatch", moduli=moduli,
            actual=delta_counts, expected=expected)
    require(ordinary_counts == {2: expected_two, 4: 0, 6: expected_six_ordinary},
            "Ordinary branch mismatch", moduli=moduli, actual=ordinary_counts)
    require(nontranslation_counts ==
            {2: 0, 4: expected_four, 6: expected_six_nontranslation},
            "Nontranslation branch mismatch", moduli=moduli,
            actual=nontranslation_counts)

    expected_supports = comb(n, 3) if n >= 3 else 0
    ordinary_pairs = sum(ordinary_counts.values())
    nontranslation_pairs = sum(nontranslation_counts.values())
    require(support_count == expected_supports, "Incomplete support enumeration",
            moduli=moduli, actual=support_count, expected=expected_supports)
    require(2 * ordinary_pairs == expected_supports * nat_sub(h, 1),
            "Ordinary total mismatch", moduli=moduli, actual=ordinary_pairs)
    require(2 * nontranslation_pairs == n * nat_sub(h, 1) * nat_sub(t, 1) * h,
            "Nontranslation total mismatch", moduli=moduli,
            actual=nontranslation_pairs)

    return {
        "moduli": list(moduli),
        "order": n,
        "h": h,
        "t": t,
        "supports": support_count,
        "square_fibres": len(fibres),
        "maximum_fibre_size": max(map(len, fibres.values()), default=0),
        "unordered_collision_pairs": sum(delta_counts.values()),
        "ordinary_pairs": ordinary_pairs,
        "nontranslation_pairs": nontranslation_pairs,
        "delta_pair_counts": delta_counts,
        "delta_six_ordinary_pairs": ordinary_counts[6],
        "delta_six_nontranslation_pairs": nontranslation_counts[6],
        "formula_counts": expected,
        "all_checks_passed": True,
    }


def main():
    cases = [(n,) for n in range(1, 25)] + [
        (2, 2), (2, 3), (2, 2, 3), (2, 2, 2, 3),
        (2, 3, 3), (2, 2, 3, 3), (2, 2, 2, 2, 2),
        (2, 4), (4, 4),
    ]
    rows = [check_group(moduli) for moduli in cases]
    result = {
        "status": "FINITE_CHECK_ONLY",
        "scope": {
            "zero_allowed": True,
            "ordered_square_diagonals_included": True,
            "ordered_sums_per_support": 9,
            "pairs": "unordered pairs of distinct three-element supports",
            "signature": "labelled vector of ordered-sum multiplicities",
            "nontranslation_test": "all translations in the ambient group",
            "small_group_subtraction": "truncated natural-number subtraction",
        },
        "presentations": len(rows),
        "maximum_group_order": max(row["order"] for row in rows),
        "supports": sum(row["supports"] for row in rows),
        "square_fibres": sum(row["square_fibres"] for row in rows),
        "unordered_collision_pairs": sum(row["unordered_collision_pairs"] for row in rows),
        "ordinary_pairs": sum(row["ordinary_pairs"] for row in rows),
        "nontranslation_pairs": sum(row["nontranslation_pairs"] for row in rows),
        "delta_pair_totals": {
            delta: sum(row["delta_pair_counts"][delta] for row in rows)
            for delta in (2, 4, 6)
        },
        "all_checks_passed": all(row["all_checks_passed"] for row in rows),
        "rows": rows,
    }
    print(json.dumps(result, indent=2, sort_keys=True))


if __name__ == "__main__":
    main()
