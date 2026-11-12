#!/usr/bin/env python3
"""Independent exact replay using ordered convolution, not the main checker.

This verifier does not import audit_mod_obs_03. It tests the stored JSON
against a second construction of the full 18-vertex signature dataset, plus
an independent n=12 boundary example. Internal finite check only.
"""
from collections import Counter,defaultdict
from itertools import combinations,product
import json
import math
from pathlib import Path

N=18

def multiply(a,b,n):
    x=[0]*n
    for i,u in enumerate(a):
        if not u:continue
        for j,v in enumerate(b):
            if v:x[(i+j)%n]+=u*v
    return tuple(x)

def seqs(s,n=N):
    a=tuple(1 if x in s else 0 for x in range(n))
    out={1:a}
    for k in range(2,7):out[k]=multiply(out[k-1],a,n)
    return out

def main():
    truth=json.loads(Path(__file__).with_name('results.json').read_text('utf-8'))
    d=defaultdict(list)
    vals={}
    for s in combinations(range(N),3):
        p=seqs(s)
        vals[s]=(N*p[3][0],N*p[4][0],N*p[5][0],N*p[6][0])+p[3]
        d[p[2]].append(s)
    assert len(d)==399
    assert Counter(len(z) for z in d.values())==Counter({2:390,4:9})
    pairs=[(s,t) for z in d.values() for s,t in combinations(z,2)]
    assert len(pairs)==444
    covers=[sum(1<<i for i,(s,t) in enumerate(pairs) if vals[s][j]!=vals[t][j]) for j in range(22)]
    allbits=(1<<444)-1
    assert min(444-c.bit_count() for c in covers)==90
    assert min(444-(covers[i]|covers[j]).bit_count() for i,j in combinations(range(22),2))==24
    assert (covers[4]|covers[7]|covers[10])==allbits
    # Every quad has two (and not one) separating cubic coefficient probes.
    quadr=0
    for grp in d.values():
        if len(grp)==4:
            quadr+=1
            assert not any(len(set(vals[s][4+j] for s in grp))==4 for j in range(18))
            assert any(len({(vals[s][4+i],vals[s][4+j]) for s in grp})==4 for i,j in combinations(range(18),2))
    assert quadr==9
    # Property decision: gcd(n, S)=1, reflected by trace(A^3) on uncertain fibres.
    known=undecided=0
    for grp in d.values():
        conn=lambda s:math.gcd(N,*s)==1
        if len(set(conn(s) for s in grp))==1:known+=1
        else:
            undecided+=1
            assert all(vals[s][0]!=vals[t][0] for s,t in combinations(grp,2) if conn(s)!=conn(t))
    assert (known,undecided)==(316,83)
    # All 0-forbidden supports, independently grouped.
    valid=defaultdict(list)
    for s in combinations(range(1,N),3):valid[seqs(s)[2]].append(s)
    assert Counter(map(len,valid.values()))==Counter({1:118,2:269,4:6})
    # n12 nonisomorphic cospectral example: exact squares and out-arc cubic invariants.
    p=seqs((1,3,9),12);q=seqs((1,5,11),12)
    assert p[2]==q[2] and p[3]!=q[3]
    assert len(truth['n18']['fibre_size_distribution'])==2
    assert truth['n18']['fixed_bank']['best_two_remaining_pairs']==24
    assert truth['n18']['connectivity_property']['uncertain_after_square_fibres']==83
    print('PASS: independent ordered-convolution verifier; 816 triples; 444 pairs; 316/83 connectivity fibres; global 90/24/0')

if __name__=='__main__':main()