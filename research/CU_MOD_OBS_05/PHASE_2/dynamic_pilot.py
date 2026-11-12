#!/usr/bin/env python3
"""CU-MOD-OBS-05 phase 2, exact finite adversarial dynamic-query model.

Python stdlib only. Cost: each membership query and each version validation = 1.
The initial baseline version read is a mandatory extra operation (cost 1).
Version comparisons have binary same/changed outputs, not full timestamps.
Every transition updates a nonreusable monotone version; final decision and
validation are atomic; mutations can occur before any operation.
"""
from __future__ import annotations
import argparse
import json
from functools import lru_cache
from itertools import combinations, product
from math import gcd

F18 = ((1,4,13), (1,7,16), (4,10,13), (7,10,16))
F22 = ((1,3,13), (2,12,14))


def square(n, support):
    result = [0] * n
    for a in support:
        for b in support:
            result[(a+b) % n] += 1
    return tuple(result)


def cube_trace(n, support):
    return n * sum((a+b+c) % n == 0
                   for a in support for b in support for c in support)


def target(n, supports, idx, goal):
    if goal == 'reconstruction': return idx
    if goal == 'contains_1': return int(1 in supports[idx])
    if goal == 'connected': return int(gcd(n, *supports[idx]) == 1)
    raise ValueError(goal)


class ExactDynamicGame:
    def __init__(self, n, supports, queries, e=0, m=0, goal='reconstruction'):
        self.n = n
        self.supports = tuple(tuple(s) for s in supports)
        self.queries = tuple(queries)
        self.e, self.m, self.goal = e, m, goal
        # World = (current support, number of mutations, lies spent, dirty)
        self.worlds = tuple(product(range(len(supports)), range(m+1), range(e+1), (0,1)))
        self.windex = {w:i for i,w in enumerate(self.worlds)}
        self.initial = sum(1 << self.windex[(s,0,0,0)] for s in range(len(supports)))
        self.actions = self.queries + ('version',)
        self.reach = self._reachability()
        self.one = self._make_one_world_transitions()
        self.choice = {}
        self.calls = 0

    def _reachability(self):
        # Exactly k true state changes, each to a DIFFERENT support.
        sizes = len(self.supports)
        r = {(s,0):(s,) for s in range(sizes)}
        for k in range(1,self.m+1):
            for s in range(sizes):
                r[(s,k)] = tuple(sorted({dest
                    for intermediate in r[(s,k-1)]
                    for dest in range(sizes) if dest != intermediate}))
        return r

    def _make_one_world_transitions(self):
        transitions=[]
        for (s,used_m,used_e,dirty) in self.worlds:
            out={act:{} for act in self.actions}
            for k in range(self.m-used_m+1):
                for dest in self.reach[(s,k)]:
                    dnew = int(dirty or k > 0)
                    for q in self.queries:
                        honest = int(q in self.supports[dest])
                        for answer in (0,1):
                            e2 = used_e + int(honest != answer)
                            if e2 > self.e: continue
                            bit = 1 << self.windex[(dest,used_m+k,e2,dnew)]
                            out[q][answer] = out[q].get(answer,0) | bit
                    # The check compares the version with the baseline; a
                    # changed check also becomes the baseline for the retry.
                    bit = 1 << self.windex[(dest,used_m+k,used_e,0)]
                    out['version'][dnew] = out['version'].get(dnew,0) | bit
            transitions.append(out)
        return transitions

    @lru_cache(None)
    def outcomes(self, belief, action):
        accum = {}
        while belief:
            low = belief & -belief
            idx = low.bit_length()-1
            belief -= low
            for obs, bitset in self.one[idx][action].items():
                accum[obs] = accum.get(obs,0) | bitset
        return tuple(sorted(accum.items()))

    @lru_cache(None)
    def agrees(self, belief):
        values=set()
        while belief:
            low=belief & -belief
            idx=low.bit_length()-1
            belief-=low
            values.add(target(self.n,self.supports,self.worlds[idx][0],self.goal))
            if len(values)>1:return False
        return True

    def single_value(self,belief):
        values={target(self.n,self.supports,w[0],self.goal)
                for i,w in enumerate(self.worlds) if belief & (1<<i)}
        assert len(values)==1
        return next(iter(values))

    @lru_cache(None)
    def possible(self, belief, remaining):
        self.calls += 1
        if remaining == 0:return False
        for action in self.actions:
            branches = self.outcomes(belief,action)
            works = True
            for reply,nxt in branches:
                if action == 'version' and reply == 0 and self.agrees(nxt):
                    continue  # atomic validate-and-act
                if not self.possible(nxt,remaining-1):
                    works = False
                    break
            if works:
                self.choice[(belief,remaining)] = action
                return True
        return False

    def optimum(self, max_actions=35):
        for depth in range(1,max_actions+1):
            if self.possible(self.initial,depth):
                return depth
        raise RuntimeError('No finite policy found within bound')

    def certificate(self,optimal_depth):
        """DAG of policy nodes including every possible adversary answer."""
        nodes = {}
        stack = [(self.initial,optimal_depth)]
        while stack:
            belief,rem = stack.pop()
            key=f'{belief:x}@{rem}'
            if key in nodes:continue
            assert self.possible(belief,rem)
            a = self.choice[(belief,rem)]
            edges={}
            for answer,nxt in self.outcomes(belief,a):
                outcome=str(answer)
                if a == 'version' and answer == 0 and self.agrees(nxt):
                    edges[outcome]={'terminal':self.single_value(nxt), 'belief':f'{nxt:x}'}
                else:
                    assert rem>1
                    assert self.possible(nxt,rem-1)
                    edges[outcome]={'node':f'{nxt:x}@{rem-1}'}
                    stack.append((nxt,rem-1))
            nodes[key]={'action':a,'edges':edges}
        return {'schema':'dynamic-game-policy-v1','root':f'{self.initial:x}@{optimal_depth}',
                'goal':self.goal,'e':self.e,'m':self.m,
                'n':self.n,'supports':self.supports,'queries':self.queries,
                'mutations_per_gap':'0..remaining, each true change between distinct states',
                'version':'binary same/changed, monotone, atomic compare-and-act',
                'cost':'one per action; initial baseline version read extra',
                'optimal_after_baseline':optimal_depth,'nodes':nodes}


def pilot():
    # All supports are LABELLED, of cardinal three, zero excluded.
    fib22 = tuple(s for s in combinations(range(1,22),3) if square(22,s) == square(22,F22[0]))
    assert fib22 == F22
    assert square(22,F22[0])==square(22,F22[1])
    assert cube_trace(22,F22[0])==cube_trace(22,F22[1])==0
    assert [target(22,F22,i,'connected') for i in range(2)] == [1,0]
    fib18 = tuple(s for s in combinations(range(1,18),3) if square(18,s) == square(18,F18[0]))
    assert fib18 == F18
    out={'program':'CU-MOD-OBS-05','campaign':'phase-2','date':'2026-10-11',
         'status':'internal exact finite model; no external audit or novelty claim',
         'rules':{'version_action':'binary same/changed, atomic compare-and-act',
                  'baseline_version_read_cost':1,'query_cost':1,'version_validation_cost':1,
                  'mutations':'adversarial at any operation boundary, including before final validation',
                  'lie_budget':'global across retries','mutation_budget':'global across retries',
                  'scope':'only selected exact square fibers; no all-n or AI guarantee'},
         'n22':{'total_supports':1330,'selected_full_fiber':[list(s) for s in fib22],
                'same_square':True,'cube_traces':[cube_trace(22,s) for s in fib22],
                'connectivities':[bool(gcd(22,*s)==1) for s in fib22]},
         'n18':{'total_supports':680,'selected_full_fiber':[list(s) for s in fib18]},
         'exact_minimax':{}, 'certificates':{}}
    for name,su,queries,goals in (
        ('n18',F18,(1,4),('reconstruction','contains_1')),
        ('n22',F22,(1,),('connected',))):
        for goal in goals:
            table={}
            for e,m in ((0,0),(1,0),(2,0),(0,1),(1,1),(2,1),(0,2),(1,2),(2,2)):
                solver=ExactDynamicGame(18 if name=='n18' else 22,su,queries,e,m,goal)
                depth=solver.optimum(30)
                row={'e_lies':e,'m_mutations':m,'optimal_after_baseline':depth,
                     'optimal_including_baseline':depth+1,
                     'lower_depth_infeasible':not solver.possible(solver.initial,depth-1),
                     'dp_visited_states':solver.calls,
                     'worlds':len(solver.worlds)}
                table[f'e{e}_m{m}']=row
                if (e,m)==(1,1):
                    cert=solver.certificate(depth)
                    out['certificates'][f'{name}_{goal}_e1_m1']=cert
                    row['policy_dag_nodes']=len(cert['nodes'])
            out['exact_minimax'][f'{name}_{goal}']=table
    # True but time-incoherent transcript of two honest queries on n18.
    assert int(1 in F18[0])==1 and int(4 in F18[3])==0
    phantom = [i for i,s in enumerate(F18) if int(1 in s)==1 and int(4 in s)==0]
    assert phantom == [1] and 1 not in (0,3)
    out['negative_controls']={
        'n18_phantom':{'first_state':list(F18[0]),'second_state':list(F18[3]),
                       'queries':[1,4],'honest_responses':[1,0],
                       'false_inferred_state':list(F18[1]),'mutations':1,'lies':0},
        'n22_cubic_trace_blindness':True,
        'version_modulo_2_ABA':{'states':[list(F18[0]),list(F18[3]),list(F18[1])],
                                'versions_mod2':[0,1,0],
                                'warning':'same token after two mutations; state is different'},
        'post_validation_mutation':'unprotected validate-then-act not certified'}
    return out


def main():
    parser=argparse.ArgumentParser()
    parser.add_argument('--output',required=True)
    parser.add_argument('--policy-output',required=True)
    args=parser.parse_args()
    data=pilot()
    certs=data.pop('certificates')
    with open(args.output,'w',encoding='utf-8',newline='\n') as f:
        json.dump(data,f,sort_keys=True,indent=2,ensure_ascii=True)
        f.write('\n')
    with open(args.policy_output,'w',encoding='utf-8',newline='\n') as f:
        json.dump(certs,f,sort_keys=True,indent=2,ensure_ascii=True)
        f.write('\n')
    print(json.dumps({'results':args.output,'certificates':args.policy_output,
                      'profiles':data['exact_minimax'],
                      'nodes':{k:len(v['nodes']) for k,v in certs.items()}},sort_keys=True))

if __name__=='__main__':main()