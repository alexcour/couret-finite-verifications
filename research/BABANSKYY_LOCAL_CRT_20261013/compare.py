"""Reproduce exact local/global comparisons; write deterministic JSON/CSV."""
import argparse
import csv
import json
from collections import Counter, defaultdict
from itertools import combinations
from pathlib import Path

import local_crt as crt
import ramanujan_reference as ref


def case(n, support, rows=None):
    f = crt.source_vector(n, support)
    t, p, a = crt.parameters(n)
    parts = ref.components(f)
    counts = Counter()
    supports = set()
    free_levels = [j for j in range(a+1)
                   if all(row[0] % p == 0 for row in crt.residue(f, j, 1))]
    mismatches = []
    for signs in crt.sign_choices(n):
        result = crt.analyze(f, signs)
        nums, v = ref.inverse(parts, signs)
        r2, rp = all(x % t == 0 for x in nums), all(x % p == 0 for x in nums)
        integral = all(x.denominator == 1 for x in v)
        shortcut = all(signs[2**j] == signs[2**j*p] or j in free_levels for j in range(a+1))
        if (result['coefficients'] != v or result['at_2'] != r2 or
                result['at_p'] != rp or (r2 and rp) != integral or shortcut != rp):
            mismatches.append({"signs": signs, "reason": "local/global disagreement"})
        counts['sign_choices'] += 1
        counts['at_2'] += r2
        counts['at_p'] += rp
        counts['integral'] += integral
        counts['2_only'] += r2 and not rp
        counts['p_only'] += rp and not r2
        counts['neither'] += not r2 and not rp
        if integral:
            assert all(x in (0, 1) for x in v) and sum(v) == len(support)
            assert ref.convolution(v) == ref.convolution(f)
            supports.add(tuple(x for x, value in enumerate(v) if value))
        if rows is not None:
            rows.append({"n": n, "orders": ':'.join(map(str, crt.orders(n))),
                         "signs": ':'.join(str(signs[d]) for d in crt.orders(n)),
                         "at_2": int(r2), "at_p": int(rp), "integral": int(integral),
                         "coefficients": ':'.join(map(str, v)),
                         "first_failures_2": json.dumps(result['failures_2'], separators=(',', ':')),
                         "failures_p": json.dumps(result['failures_p'], separators=(',', ':'))})
    assert not mismatches, mismatches
    assert counts['at_p'] == 2**(a+len(free_levels))
    return {"n": n, "a": a, "p": p, "support": support, **dict(counts),
            "p_free_levels": free_levels, "distinct_integral_supports": sorted(supports),
            "disagreements": len(mismatches)}


def run():
    rows = []
    targets = [case(n, [1, 5, 17], rows) for n in (24, 40, 48)]
    # All signs for a fixed support across a bounded rectangular family.
    family = [case(2**a*p, [1, 5, 17]) for a in range(1, 6)
              for p in (3, 5, 7, 11, 13) if 2**a*p > 17]
    # Third, non-Fourier route: exhaustive direct convolution-square fibres.
    direct = []
    for item in targets:
        n = item['n']
        f = crt.source_vector(n, item['support'])
        desired = ref.convolution(f)
        found = [list(s) for s in combinations(range(n), 3)
                 if ref.convolution(crt.source_vector(n, s)) == desired]
        assert found == [list(s) for s in item['distinct_integral_supports']]
        direct.append({"n": n, "triples_examined": n*(n-1)*(n-2)//6, "supports": found})
    census, witnesses = [], []
    for n in (24, 40, 48):
        fibres = defaultdict(list)
        for s in combinations(range(n), 3):
            # An ordered-sum multiset, independent of either spectral algorithm.
            key = tuple(sorted((x+y) % n for x in s for y in s))
            fibres[key].append(s)
        histogram = Counter(map(len, fibres.values()))
        assert sum(k*v for k, v in histogram.items()) == n*(n-1)*(n-2)//6
        exceptional = next((sets for sets in fibres.values() if len(sets) > 2), None)
        census.append({"n": n, "all_triples": n*(n-1)*(n-2)//6,
                       "fibre_count_by_size": dict(sorted(histogram.items())),
                       "exceptional_witness": exceptional})
        if exceptional:
            c = case(n, list(exceptional[0]))
            assert c['distinct_integral_supports'] == exceptional
            witnesses.append(c)
    return {"status": "PASS", "arithmetic": "integers and exact rational fractions",
            "construction_attribution": "Oleksiy Babanskyy, correspondence 2026-10-13 09:35:31 Europe/Paris",
            "targets": targets, "family": family, "direct_convolution": direct,
            "full_triple_census": census, "boundary_witnesses": witnesses,
            "total_sign_choices": sum(x['sign_choices'] for x in targets+family+witnesses),
            "disagreements": 0}, rows


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--check', action='store_true')
    args = parser.parse_args()
    root = Path(__file__).resolve().parent
    results, rows = run()
    encoded = json.dumps(results, indent=2, ensure_ascii=False)+'\n'
    import io
    buf = io.StringIO(newline='')
    writer = csv.DictWriter(buf, fieldnames=list(rows[0]), lineterminator='\n')
    writer.writeheader()
    writer.writerows(rows)
    for name, content in [('results.json', encoded), ('target_signs.csv', buf.getvalue())]:
        path = root/name
        if args.check:
            assert path.read_text() == content, f"stale generated file: {name}"
        else:
            path.write_text(content)
    print(json.dumps({"status": "PASS", "targets": results['targets'],
                      "family_cases": len(results['family']),
                      "total_sign_choices": results['total_sign_choices'], "disagreements": 0}))


if __name__ == '__main__':
    main()
