#!/usr/bin/env python3
"""MATH-ANC-01 B-04: finite, independently replayable wheel-30 ranks checks.

This is a contemporary reconstruction informed by selected Couret pages,
NOT a transcription or certification of the whole historical algorithm.
It uses only the Python standard library and produces a deterministic JSON receipt.
"""
from __future__ import annotations
import argparse
import hashlib
import json
from itertools import combinations_with_replacement
from math import gcd, isqrt
from pathlib import Path

UNITS = (1, 7, 11, 13, 17, 19, 23, 29)
INV = {i: next(j for j in UNITS if i*j % 30 == 1) for i in UNITS}


def indep_sieve(limit):
    p = bytearray(b'\x01')*(limit+1)
    p[:2] = b'\x00\x00'
    for q in range(2, isqrt(limit)+1):
        if p[q]:
            p[q*q:limit+1:q] = b'\x00'*(((limit-q*q)//q)+1)
    return p


def rank_witness(n):
    """Return a proper factor certificate or None for a prime n.

    First reject 2/3/5 and prefilter 7. For each potential small factor
    d=30r+i>7, solve the EXACT rank identity for a nonnegative cofactor
    rank a; the unique partner class j is determined by k=n mod 30.
    Classes are grouped into 36 unordered pairs, but both orientations
    of off-diagonal pairs are effectively tested.
    """
    if n < 2:
        return {'kind': 'nonprime-boundary', 'n': n}
    if n in (2, 3, 5, 7):
        return None
    for p in (2, 3, 5, 7):
        if n % p == 0:
            return {'kind': 'small-prime-prefilter', 'n': n, 'd': p, 'q': n//p}
    assert gcd(n, 30) == 1
    k = n % 30
    R = (n-k)//30
    bound = isqrt(n)
    for i in UNITS:
        j = (k*INV[i]) % 30
        assert j in UNITS
        c = (i*j-k)//30
        # d=1 is trivial, and d=7 has already been screened.
        r = 1 if i in (1, 7) else 0
        while (d := 30*r+i) <= bound:
            numerator = R - j*r - c
            if numerator >= 0 and numerator % d == 0:
                a = numerator//d
                q = 30*a+j
                if q >= d and n == d*q:
                    return {
                        'kind': 'rank-factor', 'n': n, 'd': d, 'q': q,
                        'factor_class': i, 'cofactor_class': j,
                        'unordered_pair': sorted((i, j)),
                        'factor_rank': r, 'cofactor_rank': a,
                        'carry': c, 'N_rank': R,
                        'diagonal': d == q,
                    }
            r += 1
    return None


def full_pair_tables():
    pairs = []
    for i, j in combinations_with_replacement(UNITS, 2):
        k = i*j % 30
        c = (i*j-k)//30
        # Witness product uses two primes >7, not necessarily equal.
        di = 31 if i == 1 else 37 if i == 7 else i
        dj = 31 if j == 1 else 37 if j == 7 else j
        n = di*dj
        hit = rank_witness(n)
        assert hit is not None and hit['kind'] == 'rank-factor'
        assert hit['unordered_pair'] == [i, j]
        pairs.append({'i':i, 'j':j, 'k':k, 'carry':c,
                      'example_n':n, 'example_factors':[di,dj],
                      'detected_d':hit['d'], 'diagonal_class':i == j})
    assert len(pairs) == 36
    hist = {str(k):sum(row['k']==k for row in pairs) for k in UNITS}
    assert sum(hist.values()) == 36
    assert hist['1'] == hist['19'] == 6
    assert all(v==4 for k,v in hist.items() if k not in ('1','19'))
    # The eight separate 7x(class) residues form a permutation of units.
    seven = [{'input_class':i,'output_class':7*i%30} for i in UNITS]
    assert set(x['output_class'] for x in seven) == set(UNITS)
    return pairs,seven,hist


def exhaustive(limit):
    independent = indep_sieve(limit)
    admissible = primes = composites = via7 = via_rank = diag = 0
    mismatches = []
    examples = {str(n):rank_witness(n) for n in (1,7,11,31,49,77,121,169,407,961,1369,1517,1891)}
    for n in range(7,limit+1):
        if gcd(n,30) != 1:
            continue
        admissible += 1
        hit = rank_witness(n)
        observed = hit is None
        if observed != bool(independent[n]):
            mismatches.append({'n':n,'computed_prime':observed,'expected_prime':bool(independent[n]),'witness':hit})
        if observed:
            primes += 1
        else:
            composites += 1
            if hit['kind']=='small-prime-prefilter':
                assert hit['d']==7
                via7 += 1
            else:
                via_rank += 1
                diag += bool(hit['diagonal'])
    assert not mismatches, mismatches[:4]
    assert admissible == primes+composites == sum(gcd(n,30)==1 for n in range(7,limit+1))
    assert via_rank+via7 == composites
    return {'limit_inclusive':limit,'admissible_n':admissible,'primes':primes,
            'composites':composites,'via_prefilter_7':via7,
            'via_rank_classes':via_rank,'diagonal_witnesses':diag,
            'independent_oracle':'standalone Eratosthenes sieve',
            'disagreements':len(mismatches),'selected_witnesses':examples}


def identity_checks():
    checks = 0
    for i in UNITS:
        for j in UNITS:
            k = i*j%30
            c = (i*j-k)//30
            for r in range(7):
                for a in range(7):
                    d = 30*r+i
                    q = 30*a+j
                    R = (d*q-k)//30
                    assert R == 30*r*a + i*a+j*r+c
                    checks += 1
    assert checks == 64*49
    # Show why a single orientation per unordered class is inadequate.
    w = rank_witness(407)
    assert w and w['factor_class']==11 and w['cofactor_class']==7
    w2 = rank_witness(1517)
    assert w2 and w2['factor_class']==7 and w2['cofactor_class']==11
    # Distinguish the first successor from the diagonal in S1xS1.
    square = rank_witness(31**2)
    assert square and square['diagonal'] and square['d']==31
    assert ((31*61)-1)//30 == 63 and ((31*31)-1)//30 == 32
    return {'ordered_pair_rank_identites':checks,
            'two_orientation_examples':[407,1517],
            'S1_diagonal_example':{'n':961,'R_square':32,'R_first_successor':63}}


def run(limit):
    pairs,seven,hist=full_pair_tables()
    identity=identity_checks()
    exhaustive_results=exhaustive(limit)
    receipt={
      'schema':'MATH-ANC-01-B04-v1', 'date':'2026-10-14',
      'status':'finite mathematical check; contemporary reconstruction; NOT a complete historical algorithm attestation',
      'claim_boundary':'No original novelty, ancient epigraphy, Lean certification or external peer review asserted.',
      'units_mod30':list(UNITS),
      'historical_36_unordered_class_pairs':pairs,
      'historical_eight_7_prefilter_class_routes':seven,
      'pair_count_by_product_class':hist,
      'proof_checks':identity,'exhaustive_verification':exhaustive_results,
    }
    return receipt


def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--limit',type=int,default=100000)
    parser.add_argument('--output',default='',help='write canonical JSON certificate to this file')
    a=parser.parse_args()
    assert 10000<=a.limit<=1_000_000
    doc=run(a.limit)
    raw=json.dumps(doc,ensure_ascii=True,sort_keys=True,indent=2)+'\n'
    if a.output:
        Path(a.output).write_text(raw,encoding='utf-8')
    print('PASS 36 unordered class pairs, 8 seven-prefilter routes, 64 oriented class pairs')
    print('PASS 3136 independent rank identities, both off-diagonal orientations, 31^2 diagonal')
    c=doc['exhaustive_verification']
    print('PASS n<=%d, admissible=%d, prime=%d, composite=%d, mismatches=%d'%(a.limit,c['admissible_n'],c['primes'],c['composites'],c['disagreements']))
    print('composite branches: 7-prefilter=%d, other ranks=%d, diagonal=%d'%(c['via_prefilter_7'],c['via_rank_classes'],c['diagonal_witnesses']))
    if a.output:
        print('receipt_sha256='+hashlib.sha256(raw.encode('utf-8')).hexdigest())


if __name__=='__main__':
    main()
