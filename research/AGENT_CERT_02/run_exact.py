#!/usr/bin/env python3
"""AGENT-CERT-02: exact synthetic decision study; Python standard library only.
No real model, private data, API calls, learned calibration, or oracle action.
Run: python run_exact.py OUTPUT.json
"""
from fractions import Fraction as F
from itertools import product
from functools import lru_cache
from pathlib import Path
import json
import sys

ACTIONS = ('STOP', 'SAMPLE', 'VERIFY', 'SAMPLE_VERIFY', 'ABSTAIN')
RHO = (F(0), F(3, 20), F(3, 5))
ALPHA = (F(0), F(1, 20), F(1, 5))
PRICES = (1, 3, 6, 12)
BUDGETS = (0, 4, 8, 16)
MIN_COVERAGE = F(4, 5)
METRICS = ('extra', 'wrong', 'abstain', 'validated', 'false_accept')


def extra(action: str, price: int) -> int:
    return (4 if action in ('SAMPLE', 'SAMPLE_VERIFY') else 0) + (
        price if action in ('VERIFY', 'SAMPLE_VERIFY') else 0)


@lru_cache(None)
def kernel(rho: F, alpha: F) -> dict:
    """Weighted 7-bit trajectories x 20 verifier tickets, truth fixed to 1.
    The law is label-symmetric. A policy only sees the initial absolute margin.
    Shared component: all correct with probability 1/5, all wrong with 4/5.
    Independent component: each vote correct with probability 3/4.
    """
    out = {(m, a): {k: F(0) for k in METRICS} | {'mass': F(0)}
           for m in (1, 3) for a in ACTIONS}
    for bits in product((0, 1), repeat=7):
        k = sum(bits)
        w = (1-rho) * F(3, 4)**k * F(1, 4)**(7-k)
        w += rho * (F(1, 5) if k == 7 else F(4, 5) if k == 0 else 0)
        margin = abs(2*sum(bits[:3])-3)
        for action in ACTIONS:
            correct = sum(bits) >= 4 if action in ('SAMPLE', 'SAMPLE_VERIFY') else sum(bits[:3]) >= 2
            for ticket in range(20):
                z = w/20
                d = out[margin, action]
                d['mass'] += z
                if action == 'ABSTAIN':
                    d['abstain'] += z
                elif action in ('VERIFY', 'SAMPLE_VERIFY'):
                    accepted = ticket < (19 if correct else 20*alpha)
                    if accepted:
                        d['validated'] += z
                        if not correct:
                            d['wrong'] += z
                            d['false_accept'] += z
                    else:
                        d['abstain'] += z
                elif not correct:
                    d['wrong'] += z
    return out


def evaluate(mapping: tuple, rho: F, alpha: F, price: int) -> dict:
    d = {k: F(0) for k in METRICS}
    table = kernel(rho, alpha)
    mass = F(0)
    for m, a in zip((1, 3), mapping):
        cell = table[m, a]
        mass += cell['mass']
        d['extra'] += extra(a, price)*cell['mass']
        for k in METRICS[1:]:
            d[k] += cell[k]
    assert mass == 1
    d['coverage'] = 1-d['abstain']
    d['correct'] = d['coverage']-d['wrong']
    d['J'] = 3+d['extra']+30*d['wrong']+6*d['abstain']
    assert 0 <= d['false_accept'] <= d['wrong'] <= d['coverage'] <= 1
    assert 0 <= d['false_accept'] <= d['validated'] <= d['coverage']
    return d


def choose(family: str, price: int, budget: int) -> tuple:
    allowed = [a for a in ACTIONS if extra(a, price) <= budget]
    if family == 'RAW':
        candidates = [('STOP', 'STOP')]
    elif family == 'FIXED':
        candidates = [(a, a) for a in allowed]
    elif family == 'UNCERT':
        candidates = [(a, 'STOP') for a in allowed]
    elif family == 'ADAPT':
        candidates = list(product(allowed, repeat=2))
    else:
        raise ValueError(f'Unknown policy family: {family}')
    # Nominal distribution only: never inspect evaluation rho or alpha here.
    scored = [(evaluate(p, F(3, 20), F(1, 20), price), p) for p in candidates]
    feasible = [(d['J'], tuple(ACTIONS.index(a) for a in p), p)
                for d, p in scored if d['coverage'] >= MIN_COVERAGE]
    assert feasible  # STOP/STOP is always feasible.
    return min(feasible)[2]


def run() -> dict:
    rows = []
    for price, budget in product(PRICES, BUDGETS):
        policies = {name: choose(name, price, budget)
                    for name in ('RAW', 'FIXED', 'UNCERT', 'ADAPT')}
        for rho, alpha in product(RHO, ALPHA):
            for name, mapping in policies.items():
                assert all(extra(a, price) <= budget for a in mapping)
                d = evaluate(mapping, rho, alpha, price)
                if alpha == 0:
                    assert d['false_accept'] == 0
                if budget == 0:
                    assert mapping == ('STOP', 'STOP')
                rows.append({'rho': str(rho), 'alpha': str(alpha), 'price': price,
                             'budget': budget, 'policy': name,
                             'mapping': list(mapping),
                             'metrics': {k: str(v) for k, v in d.items()},
                             'coverage_pass': d['coverage'] >= MIN_COVERAGE,
                             'zero_false_accept': d['false_accept'] == 0})
    assert len(rows) == 576
    return {'study': 'AGENT-CERT-02', 'kind': 'exact_synthetic_expectations',
            'nominal': {'rho': '3/20', 'alpha': '1/20', 'sensitivity': '19/20'},
            'costs': {'base': 3, 'sample': 4, 'wrong': 30, 'abstain': 6},
            'minimum_nominal_coverage': '4/5', 'rows': rows}


if __name__ == '__main__':
    if len(sys.argv) != 2:
        raise SystemExit('Usage: python run_exact.py OUTPUT.json')
    path = Path(sys.argv[1])
    if path.exists():
        raise SystemExit(f'Refusing to overwrite existing output: {path}')
    path.write_text(json.dumps(run(), indent=2, sort_keys=True)+'\n', encoding='utf-8')
    print(f'Wrote {path}; 576 exact policy-configuration expectations.')
