#!/usr/bin/env python3
"""Independent full belief-set audit of MOD-OBS-02. No imports from main solver."""
import argparse
from collections import Counter, defaultdict
from functools import lru_cache
from itertools import combinations
import json
import math
from pathlib import Path


def sq2(S,n):
    o=[0]*n
    for x in S:
        o[(2*x)%n]+=1
    for x,y in combinations(S,2):
        o[(x+y)%n]+=2
    return tuple(o)


def all_fibers(n):
    d=defaultdict(list)
    for S in combinations(range(1,n),3):
        d[sq2(S,n)].append(S)
    return list(d.values())


def tval(S,n,name):
    if name=='reconstruction':return tuple(S)
    if name=='contains_1':return 1 in S
    if name=='contains_halfturn':return (n//2) in S
    if name=='connected':return math.gcd(n,*S)==1
    if name=='symmetric':return all((-x)%n in S for x in S)
    if name=='majority_lower_half':return sum(x<n/2 for x in S)>=2
    if name=='closed_walk_length_3':
        return any((a+b+c)%n==0 for a in S for b in S for c in S)
    raise ValueError(name)


def audit_fiber(f,n,target,b,regime):
    """Belief is an explicit set of feasible (candidate-index, consumed-lies) worlds."""
    values=tuple(tval(s,n,target) for s in f)
    costs={q: (1 if regime=='U' else 1+q%3) for q in range(1,n)}
    @lru_cache(maxsize=None)
    def fmin(worlds):
        labels={values[i] for i,k in worlds}
        if len(labels)==1: return 0
        best=math.inf
        for q in range(1,n):
            branches=[]
            for a in (0,1):
                w=frozenset((i,k+(a!=(q in f[i])))
                           for i,k in worlds if k+(a!=(q in f[i]))<=b)
                if not w: continue
                if w==worlds:
                    branches=[]
                    break
                branches.append(w)
            if not branches:continue
            candidate=costs[q] + max(fmin(w) for w in branches)
            if candidate<best:best=candidate
        if best == math.inf:raise ValueError('unseparable', f, worlds)
        return best
    return fmin(frozenset((i,0) for i in range(len(f))))


def main():
    parser=argparse.ArgumentParser()
    parser.add_argument('--reference', default=str(Path(__file__).with_name('results.json')))
    parser.add_argument('--output',default=str(Path(__file__).with_name('independent_audit.json')))
    args=parser.parse_args()
    data=json.loads(Path(args.reference).read_text())
    names=('reconstruction','contains_1','connected','closed_walk_length_3',
           'symmetric','majority_lower_half','contains_halfturn')
    out={'scopes':{}}
    for n in (12,18,24):
        fibers=all_fibers(n)
        if n==18:
            assert Counter(map(len,fibers))=={1:118,2:269,4:6}
        node={'n':n,'fibers':len(fibers),'regimes':{}}
        out['scopes'][str(n)]=node
        for regime in (('U','W') if n==18 else ('U',)):
            for b in (0,1):
                key=f'{regime}_b{b}'
                node['regimes'][key]={}
                for name in names:
                    hist=Counter(audit_fiber(f,n,name,b,regime) for f in fibers)
                    expected=data['n'][str(n)]['regimes'][key][name]
                    assert {str(k):v for k,v in sorted(hist.items())} == expected['cost_hist_per_fiber'],(n,key,name,hist,expected)
                    node['regimes'][key][name]={str(k):v for k,v in sorted(hist.items())}
                print('n=',n,key,'independent audit passed all',len(names),'targets across',len(fibers),'fibers')
    Path(args.output).write_text(json.dumps(out,sort_keys=True,indent=2)+'\n')

if __name__=='__main__':main()
