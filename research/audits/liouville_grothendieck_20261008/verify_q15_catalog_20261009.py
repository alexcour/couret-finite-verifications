#!/usr/bin/env python3
"""Exact Conrey-index checks + numerical refinement of 37 q15 roots.

Not a validated zero-completeness proof; q15 ordinates are NOT
compared against certified external zero lists.
"""
import json
import math
from pathlib import Path
import mpmath as mp

mp.mp.dps=40
LOG2={1:0,2:1,4:2,3:3}
G=(1,2,4,7,8,11,13,14)
LMFDB_15_8={1:1,2:1j,4:-1,7:-1j,8:-1j,11:-1,13:1j,14:1}
LMFDB_15_14={1:1,2:1,4:1,7:-1,8:1,11:-1,13:-1,14:-1}
LABELS={1:'15.2',2:'15.14',3:'15.8'}

def character(b,n):
    if math.gcd(n,15)!=1:
        return 0j
    return (-1 if n%3==2 else 1)*(1j**(b*LOG2[n%5]))

def test_labels():
    for b in (1,2,3):
        n=next(v for v in G if v%3==2 and v%5==pow(2,b,5))
        assert f'15.{n}'==LABELS[b]
        if n==8:
            assert all(character(b,x)==v for x,v in LMFDB_15_8.items())
        if n==14:
            assert all(character(b,x)==v for x,v in LMFDB_15_14.items())
        if n==2:
            assert all(character(b,x)==complex(v).conjugate() for x,v in LMFDB_15_8.items())
    print('PASS CRT/Conrey and LMFDB character value table tests')

def main():
    test_labels()
    data=json.loads(Path(__file__).with_name('q15_roots_refined_20261009.json').read_text(encoding='utf-8'))
    assert data['dps']==40
    count=0
    for ab,row in data['results'].items():
        a,b=map(int,ab.split(','))
        assert a==1 and row['conrey_label']==LABELS[b]
        values=[character(b,n) for n in range(15)]
        maxres=mp.mpf(0)
        for gamma in row['zeros']:
            seed=mp.mpf('.5')+1j*mp.mpf(gamma)
            z=mp.findroot(lambda s:mp.dirichlet(s,values),(seed,seed+1j*mp.mpf('1e-7')),tol=mp.mpf('1e-33'),maxsteps=30)
            assert abs(mp.re(z)-mp.mpf('.5'))<mp.mpf('1e-30')
            assert abs(mp.im(z)-mp.mpf(gamma))<mp.mpf('1e-30')
            r=abs(mp.dirichlet(z,values))
            assert r<mp.mpf('1e-32')
            maxres=max(maxres,r)
            count+=1
        assert len(row['zeros'])==row['count']
        print('PASS',row['conrey_label'],'zeros',row['count'],'residual',mp.nstr(maxres,5))
    assert count==37
    print('PASS: 37 q15 numerical roots; EXTERNAL ZERO LIST NOT YET MATCHED')
if __name__=='__main__':
    main()
