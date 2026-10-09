#!/usr/bin/env python3
"""Separate implementation: grouped binomial law and analytic verifier outcomes.
Does not import or execute the producer. Same author/session: not external review.
Run: python audit_exact.py RESULTS.json
"""
from fractions import Fraction as Q
from itertools import product
from math import comb
from pathlib import Path
import json
import sys

NAMES = ('STOP', 'SAMPLE', 'VERIFY', 'SAMPLE_VERIFY', 'ABSTAIN')
FIELDS = ('extra', 'wrong', 'abstain', 'validated', 'false_accept', 'coverage', 'correct', 'J')


def cost(a, c):
    return {'STOP': 0, 'SAMPLE': 4, 'VERIFY': c, 'SAMPLE_VERIFY': c+4, 'ABSTAIN': 0}[a]


def assess(mapping, r, f, c):
    acc = dict.fromkeys(FIELDS, Q(0))
    total = Q(0)
    for i in range(4):
        for j in range(5):
            weight = (1-r)*comb(3, i)*comb(4, j)*Q(3**(i+j), 4**7)
            if i == 3 and j == 4:
                weight += r/5
            if i == 0 and j == 0:
                weight += 4*r/5
            total += weight
            a = mapping[0 if i in (1, 2) else 1]
            error = (i+j < 4) if a in ('SAMPLE', 'SAMPLE_VERIFY') else (i < 2)
            acc['extra'] += weight*cost(a, c)
            if a == 'ABSTAIN':
                acc['abstain'] += weight
            elif a in ('VERIFY', 'SAMPLE_VERIFY'):
                acceptance = f if error else Q(19, 20)
                acc['validated'] += weight*acceptance
                acc['abstain'] += weight*(1-acceptance)
                if error:
                    acc['wrong'] += weight*acceptance
                    acc['false_accept'] += weight*acceptance
            elif error:
                acc['wrong'] += weight
    assert total == 1
    acc['coverage'] = 1-acc['abstain']
    acc['correct'] = 1-acc['abstain']-acc['wrong']
    acc['J'] = 3+acc['extra']+30*acc['wrong']+6*acc['abstain']
    return acc


def audit(data):
    expected = set(product(('0', '3/20', '3/5'), ('0', '1/20', '1/5'),
                           (1, 3, 6, 12), (0, 4, 8, 16), ('RAW', 'FIXED', 'UNCERT', 'ADAPT')))
    observed = set()
    choices = {}
    for row in data['rows']:
        key = tuple(row[k] for k in ('rho', 'alpha', 'price', 'budget', 'policy'))
        assert key in expected and key not in observed, ('missing/duplicate/extra', key)
        observed.add(key)
        r, f, c, b, family = Q(key[0]), Q(key[1]), key[2], key[3], key[4]
        mapping = tuple(row['mapping'])
        allowed = [a for a in NAMES if cost(a, c) <= b]
        assert len(mapping) == 2 and all(a in allowed for a in mapping)
        ck = (c, b, family)
        if ck not in choices:
            pairs = list(product(allowed, repeat=2))
            if family == 'RAW':
                pairs = [('STOP', 'STOP')]
            elif family == 'FIXED':
                pairs = [p for p in pairs if p[0] == p[1]]
            elif family == 'UNCERT':
                pairs = [p for p in pairs if p[1] == 'STOP']
            feasible = []
            for p in pairs:
                d = assess(p, Q(3, 20), Q(1, 20), c)
                if d['coverage'] >= Q(4, 5):
                    feasible.append((d['J'], tuple(NAMES.index(a) for a in p), p))
            choices[ck] = min(feasible)[2]
        assert mapping == choices[ck], ('nominal choice/leakage', key)
        d = assess(mapping, r, f, c)
        assert set(row['metrics']) == set(FIELDS)
        for field in FIELDS:
            assert Q(row['metrics'][field]) == d[field], (key, field)
        assert row['coverage_pass'] == (d['coverage'] >= Q(4, 5))
        assert row['zero_false_accept'] == (d['false_accept'] == 0)
    assert observed == expected and len(data['rows']) == 576
    return {'status': 'PASS', 'rows': 576, 'exact_metric_comparisons': 576*8,
            'choice_configurations': len(choices),
            'method': 'separate binomial implementation; no producer import',
            'external_review': False}


if __name__ == '__main__':
    if len(sys.argv) != 2:
        raise SystemExit('Usage: python audit_exact.py RESULTS.json')
    data = json.loads(Path(sys.argv[1]).read_text(encoding='utf-8'))
    print(json.dumps(audit(data), indent=2, sort_keys=True))
