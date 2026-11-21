#!/usr/bin/env python3
"""CU-MOD-OBS-05: exact finite audit and Poisson-cost toy model.

Python 3, standard library only. Re-run: python3 pilot.py > results.json
This is a finite internal calculation, not a test of a live AI system.
"""
import json
import math
from functools import lru_cache

N = 18
SUPPORTS = ((1, 4, 13), (4, 10, 13), (1, 7, 16), (7, 10, 16))
QUERIES = (1, 4)
RATES = (0.0, 0.05, 0.2, 0.3, 0.5)
QUERY_COST = 1.0
VERSION_COST = 0.25
QUERY_DURATION = 1.0


def square(support):
    out = [0] * N
    for a in support:
        for b in support:
            out[(a + b) % N] += 1
    return tuple(out)


def truth(candidate, query):
    return int(query in SUPPORTS[candidate])


def target_value(candidate, target):
    return candidate if target == 'reconstruction' else truth(candidate, 1)


def optimize(e, target):
    """Bellman minimax on per-candidate contradiction counts."""
    initial = (0, 0, 0, 0)
    policy = {}

    @lru_cache(None)
    def value(losses):
        live = tuple(i for i, a in enumerate(losses) if a <= e)
        if len({target_value(i, target) for i in live}) <= 1:
            return 0
        best = None
        for q in QUERIES:
            states = []
            for response in (0, 1):
                child = tuple(min(e + 1, losses[i] + int(truth(i, q) != response))
                              for i in range(len(SUPPORTS)))
                if any(v <= e for v in child):
                    states.append(child)
            # A non-progress branch can be bypassed with positive query costs.
            if not states or any(child == losses for child in states):
                continue
            candidate_cost = 1 + max(value(child) for child in states)
            if best is None or candidate_cost < best[0]:
                best = (candidate_cost, q)
        if best is None:
            raise AssertionError('A nonterminal state has no separating question')
        policy[losses] = best[1]
        return best[0]

    worst = value(initial)
    leaves = 0
    max_realized = 0

    def replay(true_candidate, losses, lies, steps):
        nonlocal leaves, max_realized
        live = [i for i, a in enumerate(losses) if a <= e]
        if len({target_value(i, target) for i in live}) <= 1:
            assert target_value(true_candidate, target) == target_value(live[0], target)
            leaves += 1
            max_realized = max(max_realized, steps)
            return
        q = policy[losses]
        for response in (0, 1):
            new_lies = lies + int(truth(true_candidate, q) != response)
            if new_lies > e:
                continue
            child = tuple(min(e + 1, losses[i] + int(truth(i, q) != response))
                          for i in range(len(SUPPORTS)))
            replay(true_candidate, child, new_lies, steps + 1)

    for i in range(4):
        replay(i, initial, 0, 0)
    assert max_realized == worst
    return {'worst_questions': worst, 'validated_adversarial_paths': leaves,
            'reachable_policy_states': len(policy)}


def independent_feasibility(e, target):
    """Independent representation: a set of (candidate, number_of_lies)."""
    first = tuple((i, 0) for i in range(4))

    @lru_cache(None)
    def feasible(state, depth):
        if len({target_value(i, target) for i, _ in state}) <= 1:
            return True
        if depth == 0:
            return False
        for q in QUERIES:
            all_ok = True
            for reply in (0, 1):
                next_state = tuple((i, used + int(truth(i, q) != reply))
                                   for i, used in state
                                   if used + int(truth(i, q) != reply) <= e)
                if next_state and not feasible(next_state, depth - 1):
                    all_ok = False
                    break
            if all_ok:
                return True
        return False

    for bound in range(0, 20):
        if feasible(first, bound):
            assert bound == 0 or not feasible(first, bound - 1)
            return bound
    raise AssertionError('Feasibility bound not found')


def stochastic():
    """Two honest queries, monotone version, Poisson mutation, full restart."""
    rows = []
    for lam in RATES:
        p = math.exp(-lam * QUERY_DURATION)
        # End-only: version, q1, q4, version. Always perform both queries.
        end = (2 * QUERY_COST + 2 * VERSION_COST) / (p * p)
        # Intermediate: version, q1, version, then (if valid) q4, version.
        mid = ((QUERY_COST + 2 * VERSION_COST) +
               p * (QUERY_COST + VERSION_COST)) / (p * p)
        rows.append({'lambda_per_unit': lam,
                     'end_only_expected_cost': round(end, 9),
                     'intermediate_expected_cost': round(mid, 9),
                     'lowest_expected_cost': 'end_only' if end <= mid else 'intermediate'})
    return rows


def main():
    sq = [square(s) for s in SUPPORTS]
    assert len(set(sq)) == 1
    assert len({(truth(i, 1), truth(i, 4)) for i in range(4)}) == 4
    # Mixed-time observations (1,0) imply a third state not visited.
    assert (truth(0, 1), truth(3, 4)) == (1, 0)
    assert [i for i in range(4) if (truth(i, 1), truth(i, 4)) == (1, 0)] == [2]
    static = {}
    for e in (0, 1, 2):
        static[str(e)] = {}
        for t in ('reconstruction', 'contains_1'):
            a = optimize(e, t)
            b = independent_feasibility(e, t)
            assert a['worst_questions'] == b
            a['independent_feasibility_bound'] = b
            static[str(e)][t] = a
    assert [static[str(e)]['reconstruction']['worst_questions'] for e in (0, 1, 2)] == [2, 5, 8]
    assert [static[str(e)]['contains_1']['worst_questions'] for e in (0, 1, 2)] == [1, 3, 5]
    # Fixed-bank optimum for full reconstruction: 2*(2e+1).
    fixed = {str(e): 2 * (2 * e + 1) for e in (0, 1, 2)}
    threshold = math.log(1 + VERSION_COST / QUERY_COST) / QUERY_DURATION
    out = {
        'program': 'CU-MOD-OBS-05', 'date': '2026-10-11',
        'status': 'internal exact pilot; novelty/external audit NOT established',
        'n': N, 'supports': [list(s) for s in SUPPORTS],
        'equal_adjacency_squares': True, 'queries': list(QUERIES),
        'mixed_time_witness': {'first_state_index': 0, 'second_state_index': 3,
                               'answers': [1, 0], 'inferred_third_state_index': 2},
        'static_minimax': static, 'fixed_bank_reconstruction': fixed,
        'versioned_adversarial_upper_bounds': [
            {'mutation_budget': m, 'response_error_budget': 1,
             'max_queries': (m + 1) * 5, 'max_version_reads': 2 * (m + 1),
             'note': 'constructive, not shown optimal; requires bounded mutations and atomic version contract'}
            for m in (0, 1, 2)],
        'poisson': {'model': 'e=0, two mandatory queries of one time unit each; Poisson changes; instantaneous reliable version reads; complete restart on detected change',
                    'query_cost': QUERY_COST, 'version_read_cost': VERSION_COST,
                    'lambda_crossover': round(threshold, 9), 'rows': stochastic()},
        'limitations': ['No unconditional current-state guarantee without an atomic freshness/use contract',
                        'Rates and version reliability are stipulated, not empirically calibrated',
                        'Costs are abstract and do not describe AI systems or hardware',
                        'No claim of novelty, independent peer review or globally optimal version-checking schedule']
    }
    print(json.dumps(out, indent=2, ensure_ascii=False, sort_keys=True))


if __name__ == '__main__':
    main()