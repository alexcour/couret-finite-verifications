#!/usr/bin/env python3
"""Exact, standalone finite check of the triplet appendix in the supplied audit.

Enumerates all finite abelian group types through --max-order using invariant
factors, and every three-element subset, with labelled coordinates. No third
party dependencies, no project code, no floating point arithmetic.
This is an AI-assisted internal replay, not independent human review.
"""
from __future__ import annotations

import argparse
from collections import Counter, defaultdict
from itertools import combinations, product
import json
from math import comb, prod
from pathlib import Path
import platform
import hashlib


def invariant_factors(n: int, previous: int = 1):
    if n == 1:
        yield ()
        return
    for d in range(max(2, previous), n + 1):
        if n % d == 0 and d % previous == 0:
            if d == n:
                yield (d,)
            elif n // d >= d:
                for rest in invariant_factors(n // d, d):
                    yield (d,) + rest


class Group:
    def __init__(self, factors):
        self.factors = tuple(factors)
        self.points = list(product(*(range(d) for d in factors)))
        self.index = {p: i for i, p in enumerate(self.points)}
        self.n = len(self.points)
        self.add = [[self.index[tuple((a + b) % d for a, b, d in zip(x, y, factors))]
                     for y in self.points] for x in self.points]
        self.neg = [self.index[tuple((-a) % d for a, d in zip(x, factors))]
                    for x in self.points]
        self.two = [self.add[x][x] for x in range(self.n)]
        self.three = [self.add[self.two[x]][x] for x in range(self.n)]
        self.torsion2 = [x for x in range(self.n) if self.two[x] == 0]
        self.order2 = [x for x in self.torsion2 if x]
        self.order3 = [x for x in range(1, self.n) if self.three[x] == 0]

    def footprint(self, support):
        counts = [0] * self.n
        for x in support:
            for y in support:
                counts[self.add[x][y]] += 1
        assert sum(counts) == 9
        return tuple(counts)

    def translate(self, support, tau):
        return frozenset(self.add[x][tau] for x in support)

    def reflection_witness(self, support, target):
        # Test the actual displayed parametrisation, including alpha in G[2].
        target = frozenset(target)
        for a in support:
            for d in self.order3:
                ad = self.add[a][d]
                for h in self.order2:
                    if frozenset((a, ad, self.add[ad][h])) != frozenset(support):
                        continue
                    for alpha in self.torsion2:
                        c = self.add[self.two[a]][alpha]
                        reflected = frozenset(self.add[c][self.neg[x]] for x in support)
                        if reflected == target:
                            return dict(a=a, d=d, h=h, alpha=alpha)
        return None


def audit_group(factors):
    g = Group(factors)
    buckets = defaultdict(list)
    support_count = 0
    zero_free_count = 0
    for support in combinations(range(g.n), 3):
        signature = g.footprint(support)
        buckets[signature].append(support)
        support_count += 1
        zero_free_count += 0 not in support
    assert support_count == comb(g.n, 3)
    assert zero_free_count == comb(max(g.n - 1, 0), 3)
    counts = Counter()
    all_collisions = 0
    for fibre in buckets.values():
        for s, t in combinations(fibre, 2):
            all_collisions += 1
            fs, ft = frozenset(s), frozenset(t)
            translation = any(g.translate(s, tau) == ft for tau in g.torsion2)
            if not translation:
                witness = g.reflection_witness(s, t)
                assert witness is not None, (factors, s, t, "classification counterexample")
            if 0 in fs or 0 in ft:
                continue
            delta = len(fs ^ ft)
            counts[("translation" if translation else "reflection", delta)] += 1
    n, h, t = g.n, len(g.torsion2), len(g.order3) + 1
    numerators = {
        ("translation", 2): ((n - 4) * (n - 2) * (h - 1), 4),
        ("translation", 6): ((n - 6) * (n - 4) * (n - 2) * (h - 1), 12),
        ("reflection", 4): ((n - 5) * (h - 1) * (t - 1), 2),
        ("reflection", 6): ((n - 6) * (h - 1) ** 2 * (t - 1), 2),
    }
    for key, (num, denom) in numerators.items():
        assert num % denom == 0, (factors, key, "non-integer formula")
        assert counts[key] == num // denom, (factors, key, counts[key], num // denom)
    assert set(counts) <= set(numerators)
    return dict(factors=list(factors), order=n, torsion2=h, torsion3=t,
                supports=support_count, zero_free_supports=zero_free_count,
                all_collisions=all_collisions,
                zero_free_collisions=sum(counts.values()),
                classes={f"{kind}_delta{delta}": counts[(kind, delta)]
                         for kind, delta in numerators})


def example_checks():
    g = Group((6,))
    examples = []
    for name, s, t in [
        ("homepage_translation", (1, 2, 4), (1, 4, 5)),
        ("nontranslation_reflection", (1, 3, 4), (2, 3, 5)),
    ]:
        rs, rt = g.footprint(s), g.footprint(t)
        assert rs == rt
        translations = [tau for tau in range(6) if g.translate(s, tau) == frozenset(t)]
        # trace(A^3) = |G| times the number of ordered triples summing to zero.
        def trace3(u):
            return 6 * sum(g.add[g.add[x][y]][z] == 0 for x in u for y in u for z in u)
        traces = (trace3(s), trace3(t))
        examples.append(dict(name=name, S=list(s), T=list(t), R=list(rs),
                             translations=translations, trace_cubes=list(traces)))
    assert examples[0]["trace_cubes"] == [30, 24]
    assert examples[1]["translations"] == []
    assert frozenset(g.neg[x] for x in (1, 3, 4)) == frozenset((2, 3, 5))
    return examples


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--max-order", type=int, default=36)
    parser.add_argument("--output", type=Path, default=Path("resultats_triplets.json"))
    args = parser.parse_args()
    if not 1 <= args.max_order <= 96:
        parser.error("--max-order must be between 1 and 96")
    groups = [audit_group(f) for n in range(1, args.max_order + 1) for f in invariant_factors(n)]
    totals = {key: sum(row[key] for row in groups)
              for key in ("supports", "zero_free_supports", "all_collisions", "zero_free_collisions")}
    totals["group_types"] = len(groups)
    totals["classes"] = dict(Counter({key: sum(row["classes"].get(key, 0) for row in groups)
                                        for key in groups[-1]["classes"]}))
    if args.max_order == 36:
        assert totals["group_types"] == 62
        assert totals["supports"] == 137315
        assert totals["zero_free_supports"] == 122962
        assert totals["zero_free_collisions"] == 190930
        assert totals["classes"] == {
            "translation_delta2": 20532, "translation_delta6": 166744,
            "reflection_delta4": 948, "reflection_delta6": 2706,
        }
    result = dict(status="PASS_FINITE_INTERNAL_REPLAY", max_order=args.max_order,
                  group_convention="all invariant-factor types; labelled elements; additive groups",
                  support_convention="three distinct elements; ordered sums; diagonals included",
                  pair_convention="unordered pairs of distinct supports; no symmetry quotient",
                  zero_free_convention="zero excluded from both supports for the four counting formulae",
                  source_sha256=hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),
                  python_version=platform.python_version(), totals=totals,
                  examples=example_checks(), groups=groups,
                  limits=["Finite bound only; no universal proof from enumeration.",
                          "AI-assisted internal replay; not external human review.",
                          "No Lean compilation; no claim of mathematical novelty.",
                          "No reproduction of the report's order-96 or graph-isomorphism census."])
    args.output.write_text(json.dumps(result, ensure_ascii=False, indent=2) + "\n")
    print(json.dumps({k: v for k, v in result.items() if k not in ("groups",)}, ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()
