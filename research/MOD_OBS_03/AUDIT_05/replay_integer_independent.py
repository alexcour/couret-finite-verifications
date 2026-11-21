#!/usr/bin/env python3
"""Standalone adversarial ordered-integer Cayley audit. Python 3 stdlib only."""
import collections
import itertools
import json
import math
from pathlib import Path


def vec(s,n):
    return [int(i in s) for i in range(n)]


def conv(a,b):
    n=len(a)
    z=[0]*n
    for i,x in enumerate(a):
        if not x: continue
        for j,y in enumerate(b):
            if y: z[(i+j)%n] += x*y
    return z


def rows(s,n):
    a=vec(set(s),n)
    k2=conv(a,a)
    k3=conv(k2,a)
    return k2,k3


def connected(s,n):
    return math.gcd(n,*s)==1


def parity_fourier(k3):
    return sum((-1)**r * z for r,z in enumerate(k3))


def mod22():
    n=22
    S=(1,3,13)
    T=(2,12,14)
    ss2,ss3=rows(S,n)
    tt2,tt3=rows(T,n)
    assert set((s+11)%22 for s in S)==set(T)
    assert ss2 == tt2
    assert ss3[0] == tt3[0] == 0
    assert (ss3[3],tt3[3])==(1,0)
    assert connected(S,n) and not connected(T,n)
    assert (parity_fourier(ss3),parity_fourier(tt3))==(-27,27)
    assert ss3 != tt3
    for i in range(n):
        for j in range(n):
            assert ss2[(j-i)%n] == tt2[(j-i)%n]
    return {
      'n':n,'S':list(S),'T':list(T), 'A2_equal':True,
      'K2_full':ss2,'Tr_AS3':n*ss3[0], 'Tr_AT3':n*tt3[0],
      'A3_0_3_S':ss3[3], 'A3_0_3_T':tt3[3],
      'Fourier_parity_cubic_S':parity_fourier(ss3),
      'Fourier_parity_cubic_T':parity_fourier(tt3),
      'A3_S':ss3,'A3_T':tt3,'S_connected':True,'T_connected':False
    }


def challenge_triples(max_n=45):
    by_n=[]
    first_trace_failure=None
    total=0
    for n in range(5,max_n+1):
        for allow_zero in [False,True]:
            groups=collections.defaultdict(list)
            universe=range(0 if allow_zero else 1,n)
            for S in itertools.combinations(universe,3):
                k2,k3=rows(S,n)
                groups[tuple(k2)].append((S,n*k3[0],connected(S,n)))
                total+=1
            mixed=sum(len({v[2] for v in group})>1 for group in groups.values())
            trace_failed = any(any(a[2]!=b[2] and a[1]==b[1]
                for a,b in itertools.combinations(group,2)) for group in groups.values())
            if (n%2==1 or n%4==0) and mixed:
                raise AssertionError(f'Theorem A boundary failed: n={n} allow_zero={allow_zero}')
            if first_trace_failure is None and trace_failed:
                first_trace_failure=(n,allow_zero)
            by_n.append(dict(n=n,zero_allowed=allow_zero,
                mixed_connectivity_fibres=mixed,trace_cube_failed=trace_failed,
                square_fibres=len(groups)))
    return {'max_n':max_n,'supports_scanned':total,'first_trace_failure':first_trace_failure,
            'n18':[x for x in by_n if x['n']==18],
            'n22':[x for x in by_n if x['n']==22]}


def challenge_boundaries():
    for n in range(4,49,4):
        S=tuple(range(1,n,2))
        T=tuple(range(0,n,2))
        assert len(S)==len(T)==n//2 and (n//2)%2==0
        assert rows(S,n)[0]==rows(T,n)[0]
        assert connected(S,n) and not connected(T,n)
    for h in range(41,201,2):
        n=2*h
        S=(1,3,13)
        T=(h+1,h+3,h+13)
        k2s,k3s=rows(S,n)
        k2t,k3t=rows(T,n)
        assert k2s==k2t and n*k3s[0]==n*k3t[0]==0
        assert k3s[3]==1 and k3t[3]==0
        assert connected(S,n) and not connected(T,n)
    for h in range(5,100,2):
        n=2*h
        S=(2,4,6)
        T=tuple(sorted((s+h)%n for s in S))
        assert 0 not in S and 0 not in T and len(set(T))==3
        assert rows(S,n)[0]==rows(T,n)[0]
        assert not connected(S,n) and connected(T,n)
    cases=0
    for d in range(1,48):
        n=6*d
        h=3*d
        for b in range(h):
            a=(b+d)%h
            c=(b+2*d)%h
            family=[(a,a+h,b),(a,a+h,b+h),(c,c+h,b),(c,c+h,b+h)]
            assert all(len(set(S))==3 for S in family)
            k2=rows(family[0],n)[0]
            assert all(rows(S,n)[0]==k2 for S in family)
            assert all(math.gcd(n,*S)==math.gcd(b,d) for S in family)
            cases+=1
    return {'even_cardinality_boundary_n4':{'S':[1,3],'T':[0,2]},
            'family_B_h_values_tested':len(range(5,100,2)),
            'infinite_trace_failure_family_h_tested':len(range(41,201,2)),
            'family_D_b_values_tested':cases}


def main():
    out={'MOD22':mod22(),'adversarial_exhaustive':challenge_triples(45),
         'boundary':challenge_boundaries()}
    p=Path(__file__).with_name('RESULTS_INDEPENDENT.json')
    p.write_text(json.dumps(out,indent=2,ensure_ascii=False,sort_keys=True)+'\n',
        encoding='utf-8')
    print(json.dumps({'n22':{k:v for k,v in out['MOD22'].items()
        if not k.startswith('A3_') and k!='K2_full'},
        'scans':out['adversarial_exhaustive'],
        'boundary':out['boundary']},indent=2,ensure_ascii=False,sort_keys=True))
    print('PASS (independent integer replay; see RESULTS_INDEPENDENT.json)')


if __name__=='__main__':
    main()
