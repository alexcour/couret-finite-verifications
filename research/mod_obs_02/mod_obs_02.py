#!/usr/bin/env python3
"""MOD-OBS-02. Exact minimax decision under bounded adversarial membership lies.

Only the Python standard library is used. All calculations on finite sets
and nonnegative integers. Initial adjacency square is assumed trusted.
"""
import argparse
import collections
import functools
import hashlib
import itertools
import json
import math
from pathlib import Path


def square_signature(support, n):
    arr = [0] * n
    for x in support:
        for y in support:
            arr[(x + y) % n] += 1
    return tuple(arr)


def cube_trace(support, n):
    return n * sum(1 for x in support for y in support for z in support
                   if (x + y + z) % n == 0)


def observation_fibers(n):
    d = collections.defaultdict(list)
    for support in itertools.combinations(range(1, n), 3):
        d[square_signature(support, n)].append(support)
    return [d[key] for key in sorted(d)]


def target_map(n):
    return {
        'reconstruction': None,
        'contains_1': lambda S: 1 in S,
        'connected': lambda S: math.gcd(n, *S) == 1,
        'closed_walk_length_3': lambda S: cube_trace(S, n) > 0,
        'symmetric': lambda S: all(((-x) % n) in S for x in S),
        'majority_lower_half': lambda S: sum(1 for x in S if x < n/2) >= 2,
        'contains_halfturn': lambda S: n//2 in S,
    }


def costs_for(n, regime):
    if regime == 'U':
        return {x: 1 for x in range(1, n)}
    if regime == 'W':
        return {x: 1 + x % 3 for x in range(1, n)}
    raise ValueError(regime)


class MinimaxSolver:
    def __init__(self, fiber, n, target, lie_budget, regime):
        self.fiber = tuple(fiber)
        self.n = n
        self.b = lie_budget
        self.probes = tuple(range(1, n))
        self.answers = tuple(tuple(int(x in S) for S in fiber) for x in self.probes)
        self.costs = costs_for(n, regime)
        self.target = tuple(range(len(fiber)) if target is None else
                            [int(target(S)) for S in fiber])
        self.policy = {}
        self.state_count = 0
        self.edge_count = 0

        @functools.lru_cache(None)
        def solve(state):
            self.state_count += 1
            live = tuple(i for i, e in enumerate(state) if e <= self.b)
            assert live, 'empty belief state should not be explored'
            if len({self.target[i] for i in live}) == 1:
                self.policy[state] = {'terminal': int(self.target[live[0]])}
                return 0
            best, chosen, best_edges = math.inf, None, None
            for x, qvec in zip(self.probes, self.answers):
                children = []
                skip = False
                for ans in (0, 1):
                    nextstate = tuple(min(self.b+1, state[i] + (ans != qvec[i]))
                                      for i in range(len(state)))
                    if all(z > self.b for z in nextstate):
                        continue
                    if nextstate == state:
                        skip = True
                        break
                    children.append((ans, nextstate))
                if skip or not children:
                    continue
                self.edge_count += len(children)
                worst = max(solve(t) for _, t in children)
                total = self.costs[x] + worst
                if (total, x) < (best, chosen if chosen is not None else n+1):
                    best, chosen, best_edges = total, x, children
            if chosen is None:
                raise RuntimeError('no separating probe from live ambiguity: '+str(state))
            self.policy[state] = {
                'question': chosen, 'cost': self.costs[chosen],
                'branches': {str(v): list(s) for v, s in best_edges},
                'worst_cost': best,
            }
            return best

        self._solve = solve

    def solve(self):
        return self._solve(tuple(0 for _ in self.fiber))

    def reachable_policy(self):
        root = tuple(0 for _ in self.fiber)
        visited = set()
        agenda = [root]
        nodes = []
        while agenda:
            s = agenda.pop()
            if s in visited:
                continue
            visited.add(s)
            entry = self.policy[s]
            nodes.append({'state': list(s), **entry})
            for nxt in entry.get('branches', {}).values():
                agenda.append(tuple(nxt))
        return {'fiber': list(self.fiber), 'target_values': list(self.target),
                'lies': self.b, 'node_count': len(nodes),
                'minimax_cost': self.solve(), 'nodes': sorted(nodes, key=lambda z: z['state'])}


def verify_strategy(policy, n, regime):
    """Exhaustively expand all feasible answer transcripts of the chosen policy.
    Does not call solve(); tests outcomes, exact answer truth, and minimax cost.
    """
    fiber = [tuple(s) for s in policy['fiber']]
    values = policy['target_values']
    b = policy['lies']
    entries = {tuple(a['state']): a for a in policy['nodes']}
    costmap = costs_for(n, regime)
    comparisons = 0
    leaves = 0
    worst = 0
    # Explicit true-support + used-errors game, for all starts in initial fiber.
    for true_index, truth in enumerate(fiber):
        work = [(tuple(0 for _ in fiber), 0, 0)]
        while work:
            state, lies_used, cost_so_far = work.pop()
            if state not in entries:
                raise AssertionError('missing policy state')
            e = entries[state]
            comparisons += len(fiber)
            if 'terminal' in e:
                leaves += 1
                assert e['terminal'] == values[true_index]
                assert state[true_index] <= b
                worst = max(worst, cost_so_far)
                continue
            x = e['question']
            assert e['cost'] == costmap[x]
            for ans in (0, 1):
                used = lies_used + int(ans != int(x in truth))
                if used > b:
                    continue
                s2 = tuple(min(b+1, state[i] + int(ans != int(x in fiber[i])))
                           for i in range(len(fiber)))
                assert str(ans) in e['branches']
                assert tuple(e['branches'][str(ans)]) == s2
                work.append((s2, used, cost_so_far+costmap[x]))
    assert worst == policy['minimax_cost'], (worst, policy['minimax_cost'])
    return {'replayed_leaves': leaves, 'candidate_comparisons': comparisons,
            'verified_worst_cost': worst}


def experiment(n, budgets, regimes, targets):
    fibers = observation_fibers(n)
    hist_f = collections.Counter(map(len, fibers))
    counts = {'n': n, 'zero_excluded': True,
              'supports': sum(map(len, fibers)), 'fibers': len(fibers),
              'collisions': sum(len(f)*(len(f)-1)//2 for f in fibers),
              'fiber_hist': dict(sorted(hist_f.items())),
              'regimes': {}}
    for b in budgets:
        for regime in regimes:
            label=f'{regime}_b{b}'
            block={}
            for name in targets:
                target = target_map(n)[name]
                depths=[]
                steps = 0
                for f in fibers:
                    solver=MinimaxSolver(f,n,target,b,regime)
                    v=solver.solve()
                    depths.append(v)
                    steps += solver.state_count
                hh=collections.Counter(depths)
                block[name]={'worst': max(depths),
                             'cost_hist_per_fiber': {str(k):v for k,v in sorted(hh.items())},
                             'mean_per_fiber_exact': f'{sum(depths)}/{len(depths)}',
                             'mean_per_fiber':round(sum(depths)/len(depths),6),
                             'expanded_states': steps}
            counts['regimes'][label] = block
    # Representatives: known n18 four-member fiber with explicit supporting sets.
    if n==18:
        exemplar = sorted(next(f for f in fibers if len(f)==4 and (1,4,13) in f))
        counts['four_fiber'] = [list(s) for s in exemplar]
    return counts


def main():
    ap=argparse.ArgumentParser()
    ap.add_argument('--output',default=str(Path(__file__).with_name('results.json')))
    args=ap.parse_args()
    objectives=list(target_map(18))
    spec={12:([0,1],['U']),18:([0,1],['U','W']),24:([0,1],['U'])}
    result={'experiment':'MOD-OBS-02', 'date':'2026-10-11',
            'protocol_sha256':hashlib.sha256(Path(__file__).with_name('PROTOCOL_FREEZE.md').read_bytes()).hexdigest(),
            'n':{}, 'exemplar_policies':{}}
    for n,(bs,regimes) in spec.items():
        data=experiment(n,bs,regimes,objectives)
        result['n'][str(n)]=data
        print('n=',n, 'fibers=',data['fibers'],'hist=',data['fiber_hist'])
        for label,block in data['regimes'].items():
            print(' ',label,'reconstruct=',block['reconstruction']['worst'],
                  'contains_1=',block['contains_1']['worst'],
                  'connected=',block['connected']['worst'])
    exemplar = [tuple(s) for s in result['n']['18']['four_fiber']]
    for b in (0,1):
        for regime in ('U','W'):
            for name in ('reconstruction','contains_1','connected','majority_lower_half'):
                solver=MinimaxSolver(exemplar,18,target_map(18)[name],b,regime)
                solver.solve()
                policy=solver.reachable_policy()
                policy['verified'] = verify_strategy(policy,18,regime)
                result['exemplar_policies'][f'{regime}_b{b}_{name}']=policy
                print(' policy',regime,b,name,'cost',policy['minimax_cost'],'replay leaves',policy['verified']['replayed_leaves'])
    Path(args.output).write_text(json.dumps(result,ensure_ascii=False,indent=2,sort_keys=True)+'\n',encoding='utf-8')
    print('written',args.output)

if __name__=='__main__':
    main()
