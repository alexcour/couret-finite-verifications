#!/usr/bin/env python3
"""Independent segmented prime sieve for the 10m-30m validation window.

Uses trial-division base primes (independent of spec30_210.py sieve).
Run: python verify_segmented.py
"""
from __future__ import annotations
import json
import math
from pathlib import Path

WINDOW_LOW=10_000_000
WINDOW_HIGH=30_000_000
SEGMENT_SIZE=400_000


def trial_primes_at_most(n:int)->list[int]:
    return [k for k in range(2,n+1) if all(k%d for d in range(2,math.isqrt(k)+1))]


def segmented_primes(lo:int,hi:int):
    base=trial_primes_at_most(math.isqrt(hi))
    for start in range(lo+1,hi+1,SEGMENT_SIZE):
        end=min(hi+1,start+SEGMENT_SIZE)
        flags=bytearray(b'\x01')*(end-start)
        for p in base:
            first=max(p*p,((start+p-1)//p)*p)
            if first<end:
                flags[first-start:end-start:p]=b'\x00'*((end-first-1)//p+1)
        for pos,flag in enumerate(flags):
            if flag and start+pos>=2:
                yield start+pos


def main()->None:
    results_path=Path(__file__).with_name('resultats_spec.json')
    reference=json.loads(results_path.read_text(encoding='utf8'))
    key=str(WINDOW_HIGH)
    expected=reference['windows'][key]['counts210']
    counts={int(a):0 for a in expected}
    total=0
    for p in segmented_primes(WINDOW_LOW,WINDOW_HIGH):
        total+=1
        if p%210 in counts:
            counts[p%210]+=1
    assert total==sum(counts.values()),'All primes in (1e7,3e7] must be units of 210'
    bad={a:(count,int(expected[str(a)])) for a,count in counts.items() if count!=expected[str(a)]}
    assert not bad,bad
    print('Segmented independent count verified: total =',total,'48 residue classes = PASS')


if __name__=='__main__':main()