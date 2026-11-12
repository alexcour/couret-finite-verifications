#!/usr/bin/env python3
"""Exact graph certificates and Fourier specialization, standard library only."""
from collections import Counter
from pathlib import Path
import json
import math

UNITS = (1, 7, 11, 13, 17, 19, 23, 29)
SUPPORT = (1, 11, 29)


def chi(a, u, v):
    e3 = 0 if a % 3 == 1 else 1
    e5 = {1: 0, 2: 1, 4: 2, 3: 3}[a % 5]
    return ((1, 0), (0, 1), (-1, 0), (0, -1))[(2 * u * e3 + v * e5) % 4]


def fourier(weights, u, v):
    re = sum(weights[a] * chi(a, u, v)[0] for a in UNITS)
    im = -sum(weights[a] * chi(a, u, v)[1] for a in UNITS)
    assert re % 8 == 0 and im % 8 == 0
    return (re // 8, im // 8)


def conductor(u, v):
    for d in (1, 2, 3, 5, 6, 10, 15, 30):
        if all(a % d != b % d or chi(a, u, v) == chi(b, u, v)
               for a in UNITS for b in UNITS):
            return d
    raise AssertionError('no conductor')


def weighted_race():
    weights = {a: 5 if a in SUPPORT else -3 for a in UNITS}
    star = {a: weights[a * a % 30] for a in UNITS}
    rows = [dict(u=u, v=v, conductor=conductor(u, v),
                 t_hat=list(fourier(weights, u, v)),
                 t_star_hat=list(fourier(star, u, v)))
            for u in range(2) for v in range(4)]
    assert fourier(weights, 0, 0) == (0, 0)
    assert all(row['t_hat'][1] == 0 for row in rows)
    lam = sum(abs(row['t_hat'][0]) for row in rows)
    lamstar = sum(abs(row['t_star_hat'][0]) for row in rows)
    active = [row for row in rows if row['t_hat'] != [0, 0]]
    product_q = math.prod(row['conductor'] for row in active)
    roots = {a: sum(b * b % 30 == a for b in UNITS) for a in UNITS}
    mu_num = -sum(weights[a] * roots[a] for a in UNITS)
    assert (lam, lamstar, product_q, mu_num) == (9, 5, 3 ** 4 * 5 ** 6, -8)
    return dict(rows=rows, support_size=len(active), lambda_t=lam,
                lambda_t_star=lamstar, conductor_product=product_q,
                mean_numerator=mu_num, mean_denominator=8,
                C_exploratory_float=max(lam * math.log(30) ** 2, lamstar * math.log(30)),
                log_conductor_product_exploratory_float=math.log(product_q),
                full_H1_frequency_pairs_N67=(3 ** 67 - 1) // 2,
                boundary='Fourier data exact; logarithmic floats not interval certificates.')


def square(n, s):
    c = Counter((x + y) % n for x in s for y in s)
    return [c[x] for x in range(n)]


def walk_data(n, s):
    c = [int(x == 0) for x in range(n)]
    traces, edges = [], []
    for k in range(1, n + 1):
        c = [sum(c[(x - step) % n] for step in s) for x in range(n)]
        traces.append(n * c[0])
        edges.append(sorted(c[-step % n] for step in s))
    # Newton identities compute the characteristic polynomial over Z exactly.
    coeff = [1]
    for k in range(1, n + 1):
        numerator = -sum(coeff[k - i] * traces[i - 1] for i in range(1, k + 1))
        assert numerator % k == 0
        coeff.append(numerator // k)
    return traces, edges, coeff


def reciprocal_components(n, s):
    steps = [x for x in s if -x % n in s]
    if not steps:
        return []
    todo, sizes = set(range(n)), []
    while todo:
        component, stack = set(), [min(todo)]
        while stack:
            x = stack.pop()
            if x in component:
                continue
            component.add(x)
            stack.extend((x + t) % n for t in steps if (x + t) % n not in component)
        todo -= component
        sizes.append(len(component))
    return sorted(sizes)


def graph_case(n, s, t):
    assert square(n, s) == square(n, t)
    ts, es, cs = walk_data(n, s)
    tt, et, ct = walk_data(n, t)
    assert cs == ct and ts == tt
    k = next(k for k in range(n) if es[k] != et[k])
    assert k == 2
    return dict(n=n, S=list(s), T=list(t), same_labelled_square=True,
                cospectral_by_exact_newton_identities=True,
                characteristic_polynomial_coefficients_descending=cs,
                reciprocal_component_sizes_S=reciprocal_components(n, s),
                reciprocal_component_sizes_T=reciprocal_components(n, t),
                separating_return_length=k + 1,
                arc_return_values_S=es[k], arc_return_values_T=et[k],
                multiplicity_per_step=n,
                nonisomorphism_reason='Isomorphisms preserve the multiset of (A^3)[v,u] over directed arcs u->v.')


def main():
    result = dict(status='PASS', race=weighted_race(),
                  graphs=[graph_case(12, (1, 3, 9), (1, 5, 11)),
                          graph_case(24, (1, 5, 17), (1, 9, 21))],
                  boundary='No zero certification, no prime-race density, no nauty census.')
    (Path(__file__).parent / 'bridges_results.json').write_text(json.dumps(result, indent=2) + '\n')
    print(json.dumps(result, indent=2))


if __name__ == '__main__':
    main()
