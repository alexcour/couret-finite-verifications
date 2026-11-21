#!/usr/bin/env python3
"""CU-MOD-OBS-04: exact finite minimax search under bounded adversarial answer flips.

Assumptions: the complete A_S^2 is an exact, immutable, trusted snapshot;
S is a three-element nonzero subset of Z/nZ, n even >= 6;
questions are repeated membership tests, and at most e individual answers
can differ from the fixed ground truth across the entire interrogation.

No claims of novelty or of transfer to stochastic/physical errors.
Python stdlib only.
"""
import argparse
import hashlib
import itertools
import json
from collections import Counter, defaultdict
from functools import lru_cache
from pathlib import Path


def square_signature(support, n):
    values = [0] * n
    for x in support:
        for y in support:
            values[(x + y) % n] += 1
    return tuple(values)


def support_fibres(n):
    grouped = defaultdict(list)
    for support in itertools.combinations(range(1, n), 3):
        grouped[square_signature(support, n)].append(tuple(support))
    return list(grouped.values())


def queries_for_fibre(fibre, n, costs=None):
    """Keep cheapest member of each nontrivial test partition (up to complement)."""
    m = len(fibre)
    if m < 2:
        return ()
    whole = (1 << m) - 1
    choices = {}
    for x in range(1, n):
        mask = sum(1 << i for i, s in enumerate(fibre) if x in s)
        if mask in (0, whole):
            continue
        key = min(mask, whole ^ mask)
        cost = costs[x] if costs is not None else 1
        candidate = (cost, x, mask)
        if key not in choices or (cost, x) < choices[key][:2]:
            choices[key] = candidate
    return tuple((x, mask, cost) for cost, x, mask in sorted(choices.values()))


def solve_adaptive(fibre, tests, e):
    """Exact Bellman minimax on possible candidates and lie counts.

    A state vector records the number of observed contradictions for each
    candidate, capped at e+1 (excluded). Every terminal leaf has exactly one
    candidate with <=e contradictions. Self-loop tests are discarded.
    """
    m = len(fibre)
    capped = e + 1
    if m <= 1:
        return {'cost': 0, 'first_test': None, 'cache_states': 1,
                'policy': {(0,) * m: (0, None)}}

    @lru_cache(None)
    def solve(lies):
        live = [i for i, l in enumerate(lies) if l <= e]
        if len(live) <= 1:
            return (0, None)
        optimum = (10**12, None)
        for x, mask, cost in tests:
            successors = []
            for answer in (0, 1):
                nxt = tuple(min(capped, l + int(((mask >> i) & 1) != answer))
                            for i, l in enumerate(lies))
                if min(nxt) <= e:
                    successors.append(nxt)
            if not successors or lies in successors:
                continue
            worst = max(solve(nxt)[0] for nxt in successors)
            trial = (cost + worst, x)
            if trial < optimum:
                optimum = trial
        if optimum[1] is None:
            raise RuntimeError('No separating test: %r' % (lies,))
        return optimum

    cost, first = solve((0,) * m)
    # Cache available through solve for constructing and replaying the policy.
    return {'cost': cost, 'first_test': first,
            'cache_states': solve.cache_info().currsize,
            'policy_solver': solve}


def solve_nonadaptive(fibre, tests, e):
    """Exact cheapest fixed multiset; pairwise code distance >= 2e+1.

    Dynamic programming on pair-separation counts, capped at target distance.
    Includes repetitions, no assumption of statistically independent errors.
    """
    m = len(fibre)
    if m <= 1:
        return 0
    pairs = list(itertools.combinations(range(m), 2))
    threshold = 2 * e + 1
    increments = []
    for x, mask, price in tests:
        inc = tuple(int(((mask >> i) & 1) != ((mask >> j) & 1)) for i, j in pairs)
        if any(inc):
            increments.append((x, inc, price))
    finish = (threshold,) * len(pairs)

    @lru_cache(None)
    def value(cov):
        if cov == finish:
            return 0
        best = 10**12
        for x, inc, price in increments:
            nxt = tuple(min(threshold, a + b) for a, b in zip(cov, inc))
            if nxt != cov:
                best = min(best, price + value(nxt))
        return best
    answer = value((0,) * len(pairs))
    if answer >= 10**12:
        raise RuntimeError('Fixed tests do not separate fibre')
    return answer


def validate_policy(fibre, tests, e, data):
    """Independently replay all response histories with <=e flips."""
    if len(fibre) <= 1:
        return {'max_cost': 0, 'max_depth': 0, 'terminal_histories': 1}
    lookups = {x: (mask, cost) for x, mask, cost in tests}
    visit_count = 0
    max_depth = 0
    max_cost = 0
    decision = data['policy_solver']
    m = len(fibre)

    for truth in range(m):
        def follow(state, errors_used, accum, depth):
            nonlocal visit_count, max_depth, max_cost
            eligible = [i for i, l in enumerate(state) if l <= e]
            if len(eligible) == 1:
                assert eligible[0] == truth
                visit_count += 1
                max_depth = max(max_depth, depth)
                max_cost = max(max_cost, accum)
                return
            x = decision(state)[1]
            assert x in lookups
            mask, price = lookups[x]
            answer_correct = (mask >> truth) & 1
            for answer in (0, 1):
                new_errors = errors_used + int(answer != answer_correct)
                if new_errors > e:
                    continue
                nxt = tuple(min(e + 1, l + int(((mask >> i) & 1) != answer))
                            for i, l in enumerate(state))
                assert state != nxt and min(nxt) <= e
                follow(nxt, new_errors, accum + price, depth + 1)
        follow((0,) * m, 0, 0, 0)
    assert max_cost == data['cost']
    return {'max_cost': max_cost, 'max_depth': max_depth,
            'terminal_histories': visit_count}


def audit_order(n, e_values=(0, 1, 2)):
    groups = support_fibres(n)
    profile = Counter(map(len, groups))
    costs_by_error = {}
    policy_profiles = {}
    for e in e_values:
        outcome_cache = {}
        scores = []
        fixed_scores = []
        for fibre in groups:
            if len(fibre) <= 1:
                scores.append(0)
                fixed_scores.append(0)
                continue
            tests = queries_for_fibre(fibre, n)
            key = (len(fibre), tuple(sorted(mask for _, mask, _ in tests)))
            if key not in outcome_cache:
                adapt = solve_adaptive(fibre, tests, e)
                fixed = solve_nonadaptive(fibre, tests, e)
                outcome_cache[key] = (adapt['cost'], fixed)
            c_a, c_f = outcome_cache[key]
            assert c_a <= c_f
            scores.append(c_a)
            fixed_scores.append(c_f)
        costs_by_error['e%d' % e] = {
            'worst_adaptive': max(scores),
            'worst_conditional_fixed': max(fixed_scores),
            'distinct_test_geometries': len(outcome_cache)
        }
        policy_profiles['e%d' % e] = dict(sorted(Counter(scores).items()))
    return {
        'n': n,
        'supports': sum(len(group) for group in groups),
        'fibres': len(groups),
        'fibre_profile': dict(sorted(profile.items())),
        'collision_pairs': sum(k * (k - 1) // 2 * v for k, v in profile.items()),
        'costs': costs_by_error,
        'adaptive_cost_profile': policy_profiles
    }



def policy_certificate(fibre, tests, e, data):
    """Export an explicit policy DAG: every possible answer edge is included."""
    test_lookup = {x: (mask, price) for x, mask, price in tests}
    todo = [(0,) * len(fibre)]
    seen = {}
    while todo:
        state = todo.pop()
        if state in seen:
            continue
        live = [i for i, lies in enumerate(state) if lies <= e]
        if len(live) == 1:
            seen[state] = {'lies': list(state), 'winner': live[0]}
            continue
        x = data['policy_solver'](state)[1]
        mask, price = test_lookup[x]
        answers = {}
        for bit in (0, 1):
            nxt = tuple(min(e + 1, lies + int(((mask >> i) & 1) != bit))
                        for i, lies in enumerate(state))
            if min(nxt) <= e:
                answers[str(bit)] = list(nxt)
                todo.append(nxt)
        seen[state] = {'lies': list(state), 'question': x,
                       'cost': price, 'answers': answers}
    return {'e': e, 'max_cost': data['cost'],
            'root': [0] * len(fibre),
            'states': [seen[s] for s in sorted(seen)]}


def audit_special_n18():
    n = 18
    expected = sorted([tuple(sorted(z)) for z in
                       ((1, 4, 13), (4, 10, 13), (1, 7, 16), (7, 10, 16))])
    fibre = next(group for group in support_fibres(n)
                 if tuple(sorted(group)) == tuple(expected))
    tests = queries_for_fibre(fibre, n)
    canonical_patterns = {min(mask, ((1 << 4) - 1) ^ mask) for _, mask, _ in tests}
    assert len(canonical_patterns) == 2
    assert len(tests) == 2
    result = {'n': n, 'fibre': [list(s) for s in fibre],
              'test_classes': [{'x': x, 'mask': mask, 'cost': cost}
                               for x, mask, cost in tests]}
    result['policies'] = {}
    for e in (0, 1, 2, 3):
        a = solve_adaptive(fibre, tests, e)
        r = validate_policy(fibre, tests, e, a)
        f = solve_nonadaptive(fibre, tests, e)
        result['unit_e%d' % e] = {'adaptive': a['cost'], 'fixed': f,
                                'states': a['cache_states'], **r}
        if e in (1, 2):
            result['policies']['unit_e%d' % e] = policy_certificate(fibre, tests, e, a)
    # Costs are attached to question sites; all other sites are expensive.
    weighted = {x: 20 for x in range(1, n)}
    weighted[1] = 1
    weighted[4] = 2
    wtests = queries_for_fibre(fibre, n, weighted)
    assert {x for x, _, _ in wtests} == {1, 4}
    result['heterogeneous_costs'] = {'q1': 1, 'q4': 2,
                                    'all_other_membership_tests': 20}
    for e in (0, 1, 2):
        a = solve_adaptive(fibre, wtests, e)
        r = validate_policy(fibre, wtests, e, a)
        f = solve_nonadaptive(fibre, wtests, e)
        result['weighted_e%d' % e] = {'adaptive': a['cost'], 'fixed': f,
                                     'states': a['cache_states'], **r}
        if e == 1:
            result['policies']['weighted_e1'] = policy_certificate(fibre, wtests, e, a)
    # Exact identical squares for different generator supports; a square
    # cannot serve as a snapshot-version token.
    assert square_signature((1, 4, 13), 18) == square_signature((4, 10, 13), 18)
    result['stale_square_counterexample'] = {'old': [1, 4, 13],
                                             'new': [4, 10, 13],
                                             'squares_equal': True,
                                             'membership_at_1_changed': True}
    return result


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--output', type=Path,
                        default=Path('MOD_OBS_04_RESULTS.json'))
    args = parser.parse_args()
    data = {
        'program': 'CU-MOD-OBS-04',
        'status': 'FINITE_EXHAUSTIVE_CHECKS_AND_INTERNAL_PROOFS_NOT_EXTERNAL_AUDIT',
        'assumptions': 'nonzero 3-subsets of even Z/nZ; exact immutable full square; '
                       'up to e adversarial flips over repeated membership answers',
        'orders': [audit_order(n) for n in range(6, 31, 2)],
        'n18_four_fibre': audit_special_n18()
    }
    assert sum(v['supports'] for v in data['orders']) == 14664
    for rec in data['orders']:
        n = rec['n']
        assert rec['supports'] == (n-1)*(n-2)*(n-3)//6
        for e in (0, 1, 2):
            pair = rec['costs']['e%d' % e]
            expected = (0 if e == 0 else 0) + (2*e+1)
            if n < 12 or n % 6:
                assert pair['worst_adaptive'] == expected
                assert pair['worst_conditional_fixed'] == expected
            else:
                assert pair['worst_adaptive'] == 3*e+2  # independently checked only e<=2
                assert pair['worst_conditional_fixed'] == 4*e+2
    target = data['n18_four_fibre']
    assert (target['unit_e1']['adaptive'], target['unit_e1']['fixed']) == (5, 6)
    assert (target['unit_e2']['adaptive'], target['unit_e2']['fixed']) == (8, 10)
    assert (target['weighted_e1']['adaptive'], target['weighted_e1']['fixed']) == (7, 9)
    assert (target['weighted_e2']['adaptive'], target['weighted_e2']['fixed']) == (11, 15)
    args.output.write_text(json.dumps(data, indent=2, ensure_ascii=False,
                                      sort_keys=True) + '\n', encoding='utf-8')
    for row in data['orders']:
        print('n=%d supports=%d max_fibre=%d e1_adaptive=%d e1_fixed=%d e2_adaptive=%d e2_fixed=%d' %
              (row['n'], row['supports'], max(row['fibre_profile']),
               row['costs']['e1']['worst_adaptive'],
               row['costs']['e1']['worst_conditional_fixed'],
               row['costs']['e2']['worst_adaptive'],
               row['costs']['e2']['worst_conditional_fixed']))
    print('OUTPUT', args.output)


if __name__ == '__main__':
    main()
