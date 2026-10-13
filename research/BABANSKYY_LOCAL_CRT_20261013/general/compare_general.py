"""Deterministic bounded audit of each prime-local ladder and rational CRT."""
import argparse
from collections import Counter
from itertools import combinations
import json
from pathlib import Path
import random
import sys

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
import ramanujan_reference as ref
from tensor_crt import Plan


def source(n, support):
    out = [0]*n
    for s in support:
        out[s] = 1
    return out


def run_case(n, support, all_signs=True, samples=256):
    f = source(n, support)
    plan, parts = Plan(f), ref.components(f)
    if all_signs:
        signs_iter = plan.signs()
    else:
        rng = random.Random(20261013+n)
        masks = {(1,)*len(plan.orders)}
        masks.add(tuple(1 if d == 1 else (-1 if d % (2**dict(plan.factors).get(2, 0)) == 0 else 1)
                        for d in plan.orders))
        while len(masks) < samples:
            masks.add((1,)+tuple(rng.choice((-1, 1)) for _ in plan.orders[1:]))
        signs_iter = (dict(zip(plan.orders, v)) for v in sorted(masks))
    tested, integral, count, supports = 0, 0, Counter(), set()
    examples = {}
    for signs in signs_iter:
        result = plan.analyze(signs)
        nums, values = ref.inverse(parts, signs)
        assert result['coefficients'] == values, ('coefficients', n, signs)
        for q, a in plan.factors:
            flag = all(v % (q**a) == 0 for v in nums)
            assert flag == result['at_primes'][q], ('local', n, q, signs)
            count[q] += flag
            if not flag and q not in examples:
                examples[q] = {'signs': signs, 'first_failure': result['failures'][q][0]}
        flag = all(v.denominator == 1 for v in values)
        assert all(result['at_primes'].values()) == flag
        tested += 1
        integral += flag
        if flag:
            assert all(v in (0, 1) for v in values) and sum(values) == len(support)
            assert ref.convolution(values) == ref.convolution(f)
            supports.add(tuple(s for s, v in enumerate(values) if v))
    direct = None
    if all_signs and n <= 120:
        wanted = tuple(sorted((x+y) % n for x in support for y in support))
        direct = [s for s in combinations(range(n), 3)
                  if tuple(sorted((x+y) % n for x in s for y in s)) == wanted]
        assert sorted(supports) == direct
    return {'n': n, 'factorization': plan.factors, 'support': support,
            'orders': plan.orders, 'full_sign_space': 2**(len(plan.orders)-1),
            'exhaustive_signs': all_signs, 'tested_signs': tested,
            'admissible_at_primes_in_tested_set': dict(count),
            'integral_in_tested_set': integral, 'distinct_supports_in_tested_set': sorted(supports),
            'direct_complete_fibre': direct, 'first_failure_examples': examples, 'disagreements': 0}


def run():
    complete = [run_case(n, [1, 5, 17]) for n in (18, 24, 30, 36, 40, 48, 50, 60, 72, 90, 100, 108, 120, 200)]
    # A bounded sample only: no sample frequency is presented as a total.
    sampled = [run_case(n, [1, 5, 17], False) for n in (144, 180, 216, 360, 420)]
    witness = run_case(72, [0, 12, 36])
    return {'status': 'PASS', 'arithmetic': 'exact integer and rational tensor CRT',
            'construction_attribution': 'Babanskyy q=2 recursion and local reinjection; classical q-ary prime-power matrix',
            'complete_cases': complete, 'sampled_cases': sampled, 'boundary_witness': witness,
            'total_tested_signs': sum(c['tested_signs'] for c in complete+sampled+[witness]),
            'total_disagreements': 0}


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--check', action='store_true')
    args = parser.parse_args()
    root = Path(__file__).resolve().parent
    result = run()
    text = json.dumps(result, indent=2, ensure_ascii=False)+'\n'
    path = root/'results_general.json'
    if args.check:
        assert path.read_text() == text, 'stored general results are stale'
    else:
        path.write_text(text)
    print(json.dumps({'status': 'PASS', 'total_tested_signs': result['total_tested_signs'],
                      'complete_cases': len(result['complete_cases']), 'sampled_cases': len(result['sampled_cases']),
                      'disagreements': 0}))


if __name__ == '__main__':
    main()
