"""Exact finite checks for banks selected after the ordered square.

This verifier enumerates small groups and full fibres deliberately. It is
not an efficient bank-selection algorithm and is not extracted from Lean.
The exhaustive C2 x C3 x C3 check also searches all complex characters,
represented independently in Z[zeta_6], including the trivial character.
"""

from collections import Counter, defaultdict
from itertools import combinations, product
import argparse
import json
from math import comb
from pathlib import Path

from recoh_exact_decoder import CyclicProduct, character_sum, ordered_square


CASES = [(), (2,), (3,), (4,), (5,), (6,), (8,), (9,), (12,), (16,),
         (18,), (24,), (36,), (2, 2), (2, 4), (2, 8), (4, 4), (2, 2, 2),
         (2, 2, 3), (2, 3, 3), (2, 9), (4, 9), (6, 6), (2, 2, 2, 3)]


def fibres_of(group):
    points = list(product(*(range(q) for q in group.moduli)))
    fibres = defaultdict(list)
    for support in combinations(points, 3):
        fibres[ordered_square(group, support)].append(support)
    assert sum(map(len, fibres.values())) == comb(group.order, 3)
    return fibres


def separates(fibre, bank):
    return len({tuple(character_sum(support, chi) for chi in bank)
                for support in fibre}) == len(fibre)


def check_group(moduli):
    group = CyclicProduct(moduli)
    fibres = fibres_of(group)
    binary = tuple(chi for chi in group.bank if chi.prime == 2)
    ternary = tuple(chi for chi in group.bank if chi.prime == 3)
    histogram = Counter()
    budgets = Counter()
    rules = {}
    extra_characters_used = set()
    for square, fibre in fibres.items():
        size = len(fibre)
        assert size in (2 ** group.r, 2 ** (group.r + 1))
        if size == 2 ** group.r:
            bank = binary
        else:
            # This choice uses the whole fibre determined by `square`.
            # It never uses the unknown member within that fibre.
            candidates = [binary + (chi,) for chi in ternary]
            bank = next((candidate for candidate in candidates
                         if separates(fibre, candidate)), None)
            assert bank is not None, (moduli, square)
            extra_characters_used.add(bank[-1])
        assert separates(fibre, bank), (moduli, square)
        assert 2 ** len(bank) == size
        for chi in bank:
            assert len({character_sum(support, chi) for support in fibre}) <= 2
        rules[square] = bank
        histogram[size] += 1
        budgets[len(bank)] += 1
    # Verify one square-indexed rule, rather than choices indexed by support.
    seen = set()
    for square, fibre in fibres.items():
        for support in fibre:
            observation = (square, tuple(character_sum(support, chi)
                                        for chi in rules[square]))
            assert observation not in seen
            seen.add(observation)
    worst = max(budgets, default=0)
    expected = 0 if group.order < 3 or group.r == 0 else group.r + min(1, group.s)
    assert worst == expected, (moduli, worst, expected)
    fixed = 0 if group.order < 3 or group.r == 0 else group.r + group.s
    return {"cyclic_factors": list(moduli), "order": group.order,
            "binary_rank": group.r, "ternary_rank": group.s,
            "supports": len(seen), "fibres": len(fibres),
            "fibre_size_histogram": dict(sorted(histogram.items())),
            "selected_budget_histogram": dict(sorted(budgets.items())),
            "worst_selected_budget": worst, "fixed_bank_budget": fixed,
            "price_of_fixed_choice": fixed - worst,
            "distinct_extra_ternary_characters_used": len(extra_characters_used)}


# zeta_6^2 = zeta_6 - 1. Each pair is the coefficient of 1 and zeta_6.
ROOTS6 = ((1, 0), (0, 1), (-1, 1), (-1, 0), (0, -1), (1, -1))


def all_character_check():
    group = CyclicProduct((2, 3, 3))
    fibres = list(fibres_of(group).values())
    characters = list(product(range(2), range(3), range(3)))

    def reading(support, chi):
        roots = [ROOTS6[(3 * chi[0] * x[0] +
                        2 * chi[1] * x[1] + 2 * chi[2] * x[2]) % 6]
                 for x in support]
        return tuple(map(sum, zip(*roots)))

    tables = [[[reading(support, chi) for chi in characters]
               for support in fibre] for fibre in fibres]

    def sep(table, bank):
        return len({tuple(row[i] for i in bank) for row in table}) == len(table)

    local_minima = Counter()
    for table in tables:
        for i in range(len(characters)):
            values = {row[i] for row in table}
            assert len(values) <= 2
            assert len({(a*a - b*b, 2*a*b + b*b) for a, b in values}) == 1
        for k in range(4):
            if any(sep(table, bank) for bank in combinations(range(18), k)):
                assert 2 ** k == len(table)
                local_minima[k] += 1
                break
        else:
            raise AssertionError("No local separating bank")
    rejected = {}
    witness = None
    for k in range(4):
        bad = 0
        for bank in combinations(range(18), k):
            if all(sep(table, bank) for table in tables):
                witness = bank
                break
            bad += 1
        rejected[k] = bad
        if witness is not None:
            assert k == 3
            break
    assert witness is not None
    assert local_minima == {1: 336, 2: 36}
    assert rejected[2] == comb(18, 2)
    return {"group": [2, 3, 3], "all_characters": 18,
            "arithmetic": "Z[zeta_6], basis (1,zeta_6), zeta_6^2=zeta_6-1",
            "local_minimum_histogram": dict(sorted(local_minima.items())),
            "fixed_minimum": 3, "selected_worst_minimum": 2,
            "rejected_distinct_banks_by_size": rejected,
            "fixed_bank_witness": [list(characters[i]) for i in witness],
            "repetitions": "cannot improve separation; exhaustive distinct subsets suffice"}


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true",
                        help="compare with the recorded deterministic report")
    args = parser.parse_args()
    groups = [check_group(moduli) for moduli in CASES]
    result = {"model": "complete labelled ordered square; triples with zero allowed; exact labelled complex characters; bank fixed within each fibre",
              "scope": "finite enumerative validation, not extraction or an efficient selector; formal results are in RecohFibreOptimal.lean",
              "groups": groups,
              "total_presentations": len(groups),
              "total_supports": sum(g["supports"] for g in groups),
              "total_fibres": sum(g["fibres"] for g in groups),
              "all_character_example": all_character_check()}
    encoded = json.dumps(result, sort_keys=True, indent=2) + "\n"
    path = Path(__file__).with_name("recoh_fibre_results_20261017.json")
    if args.check:
        assert path.read_text() == encoded, "Recorded fibre replay is stale"
    else:
        path.write_text(encoded)
    print(json.dumps({"presentations": result["total_presentations"],
                      "supports": result["total_supports"],
                      "fibres": result["total_fibres"], "status": "PASS",
                      "all_character_example": result["all_character_example"]}, sort_keys=True))


if __name__ == "__main__":
    main()
