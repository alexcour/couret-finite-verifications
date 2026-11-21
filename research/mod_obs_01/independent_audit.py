#!/usr/bin/env python3
"""Independent matrix-based audit of MOD-OBS-01 (not importing the primary code)."""
import collections
import itertools
import json
import math
import pathlib


def matrix_square_circulant(S,n):
    # Construct all rows of A and multiply first row against every column of A.
    A = [[int((j-i)%n in S) for j in range(n)] for i in range(n)]
    return tuple(sum(A[0][z] * A[z][j] for z in range(n)) for j in range(n))


def matrix_by_sum_explicit(S,n):
    c=[0]*n
    for t in range(n):
        c[t]=len([a for a in S if (t-a)%n in S])
    return tuple(c)


def audit(n):
    d={}
    for S in itertools.combinations(range(1,n),3):
        key=matrix_square_circulant(S,n)
        assert key==matrix_by_sum_explicit(S,n)
        d.setdefault(key,[]).append(S)
        if n%2==0:
            # Characteristic-two projection of the square.
            h=n//2
            for r in range(h):
                lhs=key[(2*r)%n]%2
                rhs=((r in S) ^ ((r+h) in S))
                assert lhs==rhs,(n,S,r,lhs,rhs)
    H=collections.Counter(map(len,d.values()))
    return {'n':n,'supports':sum(map(len,d.values())),'fibres':len(d),'size_hist':dict(sorted(H.items())),
            'collisions':sum(k*(k-1)//2*H[k] for k in H)}


def proof_construction_tests(n):
    # For every nonzero projection residue a, exhibit pair with same square,
    # different membership ONLY in the pair a,a+h.
    assert n%2==0 and n>=6
    h=n//2
    witnesses=[]
    for a in range(1,h):
        b=next(b for b in range(1,h) if b!=a)
        S=(a,b,b+h)
        T=(a+h,b,b+h)
        assert 0 not in S and 0 not in T
        assert matrix_square_circulant(S,n)==matrix_square_circulant(T,n)
        assert set(S)^set(T)=={a,a+h}
        witnesses.append({'unqueried_coset':[a,a+h], 'pair':[sorted(S),sorted(T)]})
    return witnesses


def main():
    content={'audit':'matrix multiplication + independent coefficient count','experiments':[]}
    for n in (6,8,12,18):
        item=audit(n)
        item['lower_bound_witnesses']=proof_construction_tests(n)
        content['experiments'].append(item)
        print('audit',n,item['size_hist'],item['collisions'])
    dest=pathlib.Path(__file__).with_name('independent_audit.json')
    dest.write_text(json.dumps(content,indent=2),encoding='utf-8')
    print('Output:',dest)
if __name__=='__main__': main()