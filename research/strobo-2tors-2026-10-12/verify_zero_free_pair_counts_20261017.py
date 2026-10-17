#!/usr/bin/env python3
"""Exhaustively check STROBO collision counts on finite abelian groups.

The observed counts are obtained directly from the nine ordered sums of each
three-element support.  No proposed classification is used to build the
collision fibres.  Ordinary/exceptional status is assigned only afterwards by
testing translations.

Run with Python 3.10 or newer (standard library only):
    python verify_zero_free_pair_counts.py --max-order 36 --output report.json

The JSON is deterministic: it contains no timestamps or machine-dependent
timings.  Groups are enumerated up to isomorphism using all prime-exponent
partitions, then written in invariant-factor form.
"""

from __future__ import annotations

import argparse
from collections import Counter, defaultdict
from itertools import combinations, product
import json
from math import comb, prod
from pathlib import Path
from typing import Iterator


DELTAS = (2, 4, 6)
KINDS = ("ordinary", "exceptional")


def partitions(total: int, lower: int = 1) -> Iterator[tuple[int, ...]]:
    """Each additive partition of total exactly once, in increasing order."""
    if total == 0:
        yield ()
        return
    for first in range(lower, total + 1):
        for rest in partitions(total - first, first):
            yield (first,) + rest


def prime_factorization(n: int) -> list[tuple[int, int]]:
    answer = []
    divisor = 2
    while divisor * divisor <= n:
        exponent = 0
        while n % divisor == 0:
            n //= divisor
            exponent += 1
        if exponent:
            answer.append((divisor, exponent))
        divisor += 1
    if n > 1:
        answer.append((n, 1))
    return answer


def abelian_groups(max_order: int) -> Iterator[tuple[int, tuple[int, ...]]]:
    """All finite abelian group isomorphism types of order <= max_order."""
    for order in range(1, max_order + 1):
        prime_powers = prime_factorization(order)
        choices = [tuple(partitions(e)) for _, e in prime_powers]
        invariant_factors = []
        for partition_choice in product(*choices):
            width = max(map(len, partition_choice), default=0)
            factors = [1] * width
            for (prime, _), exponents in zip(prime_powers, partition_choice):
                for j, exponent in enumerate((0,) * (width - len(exponents)) + exponents):
                    factors[j] *= prime**exponent
            factors_tuple = tuple(factors)
            assert prod(factors_tuple) == order
            assert all(b % a == 0 for a, b in zip(factors_tuple, factors_tuple[1:]))
            invariant_factors.append(factors_tuple)
        assert len(invariant_factors) == len(set(invariant_factors))
        for factors in sorted(invariant_factors, key=lambda x: (len(x), x)):
            yield order, factors


def group_label(factors: tuple[int, ...]) -> str:
    return " x ".join(f"C{factor}" for factor in factors) or "C1"


def polynomial_numerators(n: int, h: int, t: int, zero_free: bool,
                          truncated: bool = False) -> dict[str, tuple[int, int]]:
    """Proposed expressions, separately evaluated from the collision data."""
    def minus(amount: int) -> int:
        return max(n - amount, 0) if truncated else n - amount

    if zero_free:
        return {
            "delta2_ordinary": (minus(4) * minus(2) * (h - 1), 4),
            "delta4_exceptional": (minus(5) * (h - 1) * (t - 1), 2),
            "delta6_ordinary": (minus(6) * minus(2) * minus(4) * (h - 1), 12),
            "delta6_exceptional": (minus(6) * (h - 1)**2 * (t - 1), 2),
        }
    return {
        "delta2_ordinary": (n * minus(2) * (h - 1), 4),
        "delta4_exceptional": (n * (h - 1) * (t - 1), 2),
        "delta6_ordinary": (n * minus(2) * minus(4) * (h - 1), 12),
        "delta6_exceptional": (n * (h - 1)**2 * (t - 1), 2),
    }


def formula_counts(n: int, h: int, t: int, zero_free: bool) -> dict[str, dict[str, int]]:
    signed = polynomial_numerators(n, h, t, zero_free)
    truncated = polynomial_numerators(n, h, t, zero_free, truncated=True)
    assert signed == truncated, (n, h, t, zero_free, signed, truncated)
    values = {}
    for key, (numerator, denominator) in signed.items():
        assert numerator >= 0, (n, h, t, key, numerator)
        assert numerator % denominator == 0, (n, h, t, key, numerator, denominator)
        values[key] = numerator // denominator
    result = {
        "2": {"ordinary": values["delta2_ordinary"], "exceptional": 0},
        "4": {"ordinary": 0, "exceptional": values["delta4_exceptional"]},
        "6": {"ordinary": values["delta6_ordinary"],
              "exceptional": values["delta6_exceptional"]},
    }
    for counts in result.values():
        counts["total"] = counts["ordinary"] + counts["exceptional"]
    return result


def analyse_group(n: int, factors: tuple[int, ...]) -> dict:
    elements = tuple(product(*(range(modulus) for modulus in factors)))
    assert len(elements) == n
    positions = {coordinates: index for index, coordinates in enumerate(elements)}
    assert elements[0] == (0,) * len(factors)
    addition = [
        [positions[tuple((x + y) % modulus for x, y, modulus in zip(a, b, factors))]
         for b in elements]
        for a in elements
    ]
    two_torsion = tuple(g for g in range(n) if addition[g][g] == 0)
    three_torsion = tuple(g for g in range(n) if addition[addition[g][g]][g] == 0)
    h, t = len(two_torsion), len(three_torsion)

    supports = tuple(combinations(range(n), 3))
    support_masks = tuple(sum(1 << g for g in support) for support in supports)
    masks_to_support = dict(zip(support_masks, supports))
    fibres: dict[tuple[int, ...], list[int]] = defaultdict(list)
    for support, mask in zip(supports, support_masks):
        # Sorting the nine ordered sums records every multiplicity exactly.
        signature = tuple(sorted(addition[a][b] for a in support for b in support))
        fibres[signature].append(mask)

    observed = {str(delta): {kind: 0 for kind in KINDS} for delta in DELTAS}
    zero_free = {str(delta): {kind: 0 for kind in KINDS} for delta in DELTAS}
    containing_point = {
        str(delta): {kind: [0] * n for kind in KINDS} for delta in DELTAS
    }
    translate_cache: dict[int, set[int]] = {}
    exceptional_translation_checks = 0
    for fibre in fibres.values():
        for left_mask, right_mask in combinations(fibre, 2):
            delta = (left_mask ^ right_mask).bit_count()
            assert delta in DELTAS
            union_mask = left_mask | right_mask
            union_size = union_mask.bit_count()
            assert union_size == 3 + delta // 2
            left_support = masks_to_support[left_mask]
            if left_mask not in translate_cache:
                translate_cache[left_mask] = {
                    sum(1 << addition[g][u] for g in left_support)
                    for u in two_torsion if u != 0
                }
            ordinary = right_mask in translate_cache[left_mask]
            kind = "ordinary" if ordinary else "exceptional"
            # Independently enforce the stronger meaning of exceptional:
            # the two supports are not translates by ANY group element.
            if not ordinary:
                exceptional_translation_checks += 1
                assert all(
                    sum(1 << addition[g][u] for g in left_support) != right_mask
                    for u in range(n)
                ), (group_label(factors), left_support, masks_to_support[right_mask])
            observed[str(delta)][kind] += 1
            if not union_mask & 1:  # Element 0 is the group identity.
                zero_free[str(delta)][kind] += 1
            remaining_bits = union_mask
            while remaining_bits:
                lowest_bit = remaining_bits & -remaining_bits
                point = lowest_bit.bit_length() - 1
                containing_point[str(delta)][kind][point] += 1
                remaining_bits ^= lowest_bit

    avoiding_point = {}
    for delta in DELTAS:
        delta_key = str(delta)
        union_size = 3 + delta // 2
        avoiding_point[delta_key] = {}
        for kind in KINDS:
            total = observed[delta_key][kind]
            without_zero = zero_free[delta_key][kind]
            point_counts = [total - count for count in containing_point[delta_key][kind]]
            avoiding_point[delta_key][kind] = point_counts
            assert point_counts == [without_zero] * n
            assert n * without_zero == (n - union_size) * total
            if n < union_size:
                assert total == without_zero == 0
        for counts in (observed[delta_key], zero_free[delta_key]):
            counts["total"] = sum(counts[kind] for kind in KINDS)
        avoiding_point[delta_key]["total"] = [
            sum(avoiding_point[delta_key][kind][g] for kind in KINDS)
            for g in range(n)
        ]

    expected = formula_counts(n, h, t, zero_free=False)
    expected_zero_free = formula_counts(n, h, t, zero_free=True)
    assert observed == expected, (group_label(factors), "with zero", observed, expected)
    assert zero_free == expected_zero_free, (
        group_label(factors), "without zero", zero_free, expected_zero_free
    )
    fibre_histogram = Counter(map(len, fibres.values()))
    collision_pairs = sum(comb(size, 2) * multiplicity
                          for size, multiplicity in fibre_histogram.items())
    assert collision_pairs == sum(counts["total"] for counts in observed.values())
    # Directly restrict every original convolution fibre to supports avoiding
    # zero, then count its unordered pairs.  Empty restricted fibres are
    # explicitly omitted from the histogram.
    zero_free_fibre_sizes = [sum(not (mask & 1) for mask in fibre)
                             for fibre in fibres.values()]
    zero_free_fibre_histogram = Counter(size for size in zero_free_fibre_sizes if size)
    zero_free_pairs_from_direct_fibres = sum(
        comb(size, 2) * multiplicity
        for size, multiplicity in zero_free_fibre_histogram.items()
    )
    zero_free_pairs_by_delta = sum(counts["total"] for counts in zero_free.values())
    assert zero_free_pairs_from_direct_fibres == zero_free_pairs_by_delta

    # Compare the new exceptional branches with the previously certified
    # numerical count of zero-free pairs that are not translates.
    assert n % h == 0
    assert (t - 1) % 2 == 0
    legacy_nontranslation_pairs = (
        (h - 1) * ((t - 1) // 2) * (max((n // h) * h * h - 6 * h, 0) + 1)
    )
    new_exceptional_branches = zero_free["4"]["exceptional"] + zero_free["6"]["exceptional"]
    assert legacy_nontranslation_pairs == new_exceptional_branches
    return {
        "group": group_label(factors),
        "invariant_factors": list(factors),
        "n": n,
        "h": h,
        "t": t,
        "supports": len(supports),
        "zero_free_supports": comb(n - 1, 3) if n >= 4 else 0,
        "distinct_convolution_signatures": len(fibres),
        "fibre_size_histogram": {str(k): fibre_histogram[k] for k in sorted(fibre_histogram)},
        "zero_free_distinct_convolution_signatures": sum(zero_free_fibre_histogram.values()),
        "zero_free_fibre_size_histogram": {
            str(k): zero_free_fibre_histogram[k] for k in sorted(zero_free_fibre_histogram)
        },
        "zero_free_fibre_histogram_omits_empty_fibres": True,
        "empty_restricted_original_fibres": zero_free_fibre_sizes.count(0),
        "collision_pairs": collision_pairs,
        "zero_free_collision_pairs_from_direct_fibres": zero_free_pairs_from_direct_fibres,
        "zero_free_collision_pairs_from_delta_counts": zero_free_pairs_by_delta,
        "nontranslationPairs_card_numeric_compatibility": {
            "n_over_h": n // h,
            "legacy_formula": legacy_nontranslation_pairs,
            "exceptional_delta4_plus_delta6": new_exceptional_branches,
        },
        "exceptional_pairs_checked_against_every_translation": exceptional_translation_checks,
        "with_zero_allowed": observed,
        "zero_free": zero_free,
        "avoiding_each_point_counts": avoiding_point,
        "checks": {
            "with_zero_formulas": True,
            "zero_free_formulas": True,
            "all_component_numerators_divisible": True,
            "signed_and_truncated_subtractions_agree": True,
            "all_incidence_identities": True,
            "all_points_have_equal_exclusion_counts": True,
            "small_group_empty_cases": True,
            "exceptional_pairs_are_not_translates": True,
            "legacy_nontranslationPairs_card_numeric": True,
            "zero_free_total_equals_sum_binomial_direct_fibre_sizes": True,
        },
    }


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--max-order", type=int, default=36)
    parser.add_argument("--output", type=Path, default=Path("zero_free_validation_report.json"))
    args = parser.parse_args()
    if args.max_order < 1:
        parser.error("--max-order must be positive")
    groups = [analyse_group(n, factors) for n, factors in abelian_groups(args.max_order)]
    counts_by_order = Counter(group["n"] for group in groups)
    totals = {
        "groups": len(groups),
        "supports": sum(group["supports"] for group in groups),
        "zero_free_supports": sum(group["zero_free_supports"] for group in groups),
        "convolution_signatures": sum(group["distinct_convolution_signatures"] for group in groups),
        "zero_free_convolution_signatures": sum(
            group["zero_free_distinct_convolution_signatures"] for group in groups
        ),
        "collision_pairs": sum(group["collision_pairs"] for group in groups),
        "zero_free_collision_pairs": sum(
            sum(counts["total"] for counts in group["zero_free"].values()) for group in groups
        ),
        "zero_free_collision_pairs_from_direct_fibres": sum(
            group["zero_free_collision_pairs_from_direct_fibres"] for group in groups
        ),
        "zero_free_nontranslation_pairs_legacy_formula": sum(
            group["nontranslationPairs_card_numeric_compatibility"]["legacy_formula"]
            for group in groups
        ),
        "zero_free_nontranslation_pairs_new_exceptional_branches": sum(
            group["nontranslationPairs_card_numeric_compatibility"]["exceptional_delta4_plus_delta6"]
            for group in groups
        ),
        "exceptional_pairs_checked_against_every_translation": sum(
            group["exceptional_pairs_checked_against_every_translation"] for group in groups
        ),
    }
    totals["with_zero_by_delta_and_kind"] = {
        str(delta): {kind: sum(group["with_zero_allowed"][str(delta)][kind] for group in groups)
                     for kind in (*KINDS, "total")}
        for delta in DELTAS
    }
    totals["zero_free_by_delta_and_kind"] = {
        str(delta): {kind: sum(group["zero_free"][str(delta)][kind] for group in groups)
                     for kind in (*KINDS, "total")}
        for delta in DELTAS
    }
    report = {
        "schema_version": 1,
        "method": "Direct fibres of nine ordered sums; unordered distinct support pairs; exhaustive translations",
        "scope": {
            "all_finite_abelian_groups_up_to_isomorphism": True,
            "minimum_order": 1,
            "maximum_order": args.max_order,
            "isomorphism_types_by_order": {str(n): counts_by_order[n] for n in sorted(counts_by_order)},
            "identity_element_index": 0,
            "group_coordinates": "lexicographic Cartesian product of ranges of invariant factors",
        },
        "all_checks_passed": True,
        "totals": totals,
        "groups": groups,
    }
    args.output.write_text(json.dumps(report, ensure_ascii=False, indent=2, sort_keys=True) + "\n",
                           encoding="utf-8")
    print(json.dumps({"all_checks_passed": True, "maximum_order": args.max_order,
                      "totals": totals}, ensure_ascii=False, indent=2, sort_keys=True))


if __name__ == "__main__":
    main()
