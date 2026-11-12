#!/usr/bin/env python3
"""Independent set-of-worlds verifier: no primary dynamic-pilot import.

This verifier separately builds possible mutations, reply lies, same/changed
version responses, and checks both minimax lower bounds and policy DAGs.
"""
from __future__ import annotations
import json
from functools import lru_cache
from itertools import product
from math import gcd


def value(n, supports, goal, current):
    if goal == 'reconstruction': return current
    if goal == 'contains_1': return int(1 in supports[current])
    if goal == 'connected': return int(gcd(n,*supports[current])==1)
    raise ValueError(goal)


class IndependentGame:
    def __init__(self,n,supports,queries,e,m,goal):
        self.n=n
        self.supports=tuple(tuple(s) for s in supports)
        self.queries=tuple(queries)
        self.e=e;self.m=m;self.goal=goal
        self.all_worlds=tuple(product(range(len(supports)),range(m+1),range(e+1),(0,1)))
        self.initial=frozenset((s,0,0,0) for s in range(len(supports)))
        self.actions=self.queries+('version',)
        self.reach={}
        for s in range(len(supports)):
            for k in range(m+1):
                at={s}
                for _ in range(k):
                    at={j for i in at for j in range(len(supports)) if j!=i}
                self.reach[s,k]=at
        self.visits=0

    @lru_cache(None)
    def evolve(self, belief, action):
        answers={}
        for original,used_m,used_e,dirty in belief:
            for k in range(self.m-used_m+1):
                for current in self.reach[original,k]:
                    was_changed=(dirty==1 or k>0)
                    if action == 'version':
                        status=int(was_changed)
                        answers.setdefault(status,set()).add((current,used_m+k,used_e,0))
                    else:
                        true_bit=int(action in self.supports[current])
                        for obs in (0,1):
                            new_e=used_e+int(obs!=true_bit)
                            if new_e<=self.e:
                                answers.setdefault(obs,set()).add((current,used_m+k,new_e,int(was_changed)))
        return tuple(sorted((answer,frozenset(v)) for answer,v in answers.items()))

    def known(self, belief):
        return len({value(self.n,self.supports,self.goal,w[0]) for w in belief})==1

    @lru_cache(None)
    def can_finish(self,belief,actions_left):
        self.visits+=1
        if not actions_left:return False
        for action in self.actions:
            if all((action=='version' and obs==0 and self.known(b2)) or
                    self.can_finish(b2,actions_left-1)
                   for obs,b2 in self.evolve(belief,action)):
                return True
        return False

    def optimum(self,max_depth=35):
        for t in range(1,max_depth+1):
            if self.can_finish(self.initial,t):
                assert not self.can_finish(self.initial,t-1)
                return t
        raise ValueError('no policy within limit')

    def decode_belief(self, bitset):
        return frozenset(world for i,world in enumerate(self.all_worlds) if bitset & (1<<i))

    def encode_belief(self,belief):
        return sum(1<<i for i,w in enumerate(self.all_worlds) if w in belief)

    def verify_certificate(self,certificate):
        nodes=certificate['nodes']
        depth=certificate['optimal_after_baseline']
        assert certificate['root']==f'{self.encode_belief(self.initial):x}@{depth}'
        reached=set(); edges=0; terminal_edges=0
        todo=[certificate['root']]
        while todo:
            key=todo.pop()
            if key in reached:continue
            reached.add(key)
            data=nodes[key]
            raw,rem=key.split('@'); rem=int(rem)
            belief=self.decode_belief(int(raw,16))
            assert belief
            assert rem>=1
            action=data['action']
            assert action in self.actions
            outs=dict(self.evolve(belief,action))
            assert set(data['edges'])==set(map(str,outs))
            for raw_obs,item in data['edges'].items():
                obs=int(raw_obs)
                next_belief=outs[obs]
                edges+=1
                if 'terminal' in item:
                    assert action=='version' and obs==0
                    assert self.known(next_belief)
                    assert item['belief']==f'{self.encode_belief(next_belief):x}'
                    all_answers={value(self.n,self.supports,self.goal,w[0]) for w in next_belief}
                    assert all_answers=={item['terminal']}
                    terminal_edges+=1
                else:
                    assert rem>=2
                    nxt=f'{self.encode_belief(next_belief):x}@{rem-1}'
                    assert item['node']==nxt
                    assert nxt in nodes
                    todo.append(nxt)
        assert reached==set(nodes),f'unreachable nodes: {len(set(nodes)-reached)}'
        return {'nodes':len(nodes),'edges':edges,'terminal_edges':terminal_edges}


def audit(results_path,policy_path):
    with open(results_path,encoding='utf-8') as f:data=json.load(f)
    with open(policy_path,encoding='utf-8') as f:policies=json.load(f)
    summary={}
    for key,table in data['exact_minimax'].items():
        n=18 if key.startswith('n18_') else 22
        goal=key.split('_',1)[1]
        su=data[f'n{n}']['selected_full_fiber']
        queries=(1,4) if n==18 else (1,)
        checked={}
        for entry,record in table.items():
            g=IndependentGame(n,su,queries,record['e_lies'],record['m_mutations'],goal)
            answer=g.optimum()
            assert answer==record['optimal_after_baseline'],(key,entry,answer,record)
            checked[entry]=answer
        summary[key]=checked
    for key,policy in policies.items():
        n=policy['n']; su=policy['supports'];qs=policy['queries'];goal=policy['goal']
        verifier=IndependentGame(n,su,qs,policy['e'],policy['m'],goal)
        assert verifier.optimum()==policy['optimal_after_baseline']
        summary[key+'_policy_check']=verifier.verify_certificate(policy)
    return summary


def main():
    import argparse
    ap=argparse.ArgumentParser()
    ap.add_argument('--results',required=True)
    ap.add_argument('--policies',required=True)
    args=ap.parse_args()
    print(json.dumps(audit(args.results,args.policies),sort_keys=True,indent=2))

if __name__=='__main__':main()