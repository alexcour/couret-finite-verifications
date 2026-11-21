#!/usr/bin/env python3
"""Alternative local witnesses for 37 q=15 critical-line zeros.

Trust: ball-arithmetic point evaluations of Dirichlet L, Gamma, elementary
functions and characters in python-flint/FLINT. This does NOT call Hardy Z,
acb_dirichlet_l_jet or acb_series. It does NOT certify global completeness:
the original contour-based argument remains a distinct necessary step.
"""
import argparse
import hashlib
import json
from fractions import Fraction as Q
from pathlib import Path

import flint
from flint import acb, arb, ctx, dirichlet_char, fmpq

HERE = Path(__file__).resolve().parent
CATALOGUE_NAME = 'q15_roots_refined_20261009.json'
CATALOGUE_SHA256 = 'a71da95c1d29452651734b53c5830098d67a9abc7b062a8f18623f46ff7aa3b2'
CHARACTERS = {'1,1': (2, 1, 12), '1,2': (14, 2, 13), '1,3': (8, 3, 12)}
UNITS = (1, 2, 4, 7, 8, 11, 13, 14)
LOG5 = {1: 0, 2: 1, 4: 2, 3: 3}
ROOT_RADIUS = Q(1, 10**30)
H = Q(1, 10**10)
R = Q(1, 4)
RHO = 2 * ROOT_RADIUS
M = Q(1600)
ERROR_BUDGET = Q(2, 10**15)


def require(condition, message):
    if not condition:
        raise ValueError(message)


def A(q):
    q = Q(q)
    return arb(fmpq(q.numerator, q.denominator))


def at(re, im):
    return acb(A(re), A(im))


def sign(x):
    return 1 if x > 0 else -1 if x < 0 else 0


def error_bound():
    """Exact Cauchy estimates for |L' on root box - central difference|."""
    t = H / R
    u = RHO / R
    # |L| <= 1600 on |z-(1/2+i gamma)| <= 1/4 for 0<gamma<25.
    # The symmetric finite difference drops even powers of its Taylor series.
    finite_difference_error = (M / R) * t**2 / (1 - t**2)
    derivative_variation = (M / R) * (1 / (1 - u)**2 - 1)
    return finite_difference_error + derivative_variation


def character(number, b):
    chi = dirichlet_char(15, number)
    require(chi.number() == number and chi.conductor() == 15 and
            chi.is_primitive() and not chi.is_principal(), 'character metadata')
    require(chi.parity() == (1+b) % 2, 'character parity')
    ipowers = [acb(1), acb(0, 1), acb(-1), acb(0, -1)]
    for n in range(15):
        expected = acb(0) if n not in UNITS else (-1 if n % 3 == 2 else 1) * ipowers[(b * LOG5[n % 5]) % 4]
        require(chi(n) == expected, 'character value mismatch')
    return chi


def completed_point(chi, s):
    """Direct pointwise completed L; no Taylor series and no reflection."""
    v = (s + int(chi.parity())) / 2
    factor = ((arb(15) / arb.pi()).log() * v).exp() * v.gamma()
    return factor * chi.l_function(s)


def phase_reference(chi):
    """Choose a nonzero point on the line; ratios are real by the FE."""
    for t in (Q(0), Q(1, 3), Q(1, 2), Q(1)):
        value = completed_point(chi, at(Q(1, 2), t))
        if value.is_finite() and not value.contains(0):
            return t, value
    raise ValueError('no nonzero phase reference')


def signed_completed_ratio(chi, anchor, t):
    ratio = completed_point(chi, at(Q(1, 2), t)) / anchor
    require(ratio.is_finite() and ratio.imag.contains(0),
            'completed L ratio does not enclose the real axis')
    return sign(ratio.real)


def witness(chi, seed, anchor):
    c = Q(seed)
    left, right = c - ROOT_RADIUS, c + ROOT_RADIUS
    require(Q(0) < left < c < right < Q(25), 'root interval outside declared domain')

    # Analytic fact: Lambda_chi(1/2+it) / Lambda_chi(1/2+it_ref)
    # is real for t real, by the primitive Dirichlet L functional equation.
    # Strict opposite real ball signs yield a root by continuity.
    ls = signed_completed_ratio(chi, anchor, left)
    rs = signed_completed_ratio(chi, anchor, right)
    require(ls * rs == -1, 'strict opposite completed-L signs not established')

    # Avoid both FLINT's Hardy Z and Taylor-jet derivative routines.
    zplus = at(Q(1, 2) + H, c)
    zminus = at(Q(1, 2) - H, c)
    derivative_approx = (chi.l_function(zplus) - chi.l_function(zminus)) / A(2*H)
    require(derivative_approx.is_finite(), 'nonfinite symmetric derivative')
    threshold = A(ERROR_BUDGET)
    # Comparisons are certified only if the entire ball is outside [-E, E].
    real_ok = derivative_approx.real > threshold or derivative_approx.real < -threshold
    imag_ok = derivative_approx.imag > threshold or derivative_approx.imag < -threshold
    require(real_ok or imag_ok, 'derivative component not separated from zero')
    return {'left_sign': ls, 'right_sign': rs,
            'derivative_component': 'real' if real_ok else 'imag',
            'unique_simple_zero_in_rectangle_under_point_L_contract': True}


def main():
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument('--local', type=Path, default=HERE / CATALOGUE_NAME)
    p.add_argument('--precision', type=int, default=256)
    args = p.parse_args()
    require(flint.__version__ == '0.9.0' and flint.__FLINT_VERSION__ == '3.6.0',
            'different FLINT version: audit first')
    require(args.precision >= 192, 'insufficient ball precision')
    require(error_bound() < ERROR_BUDGET, 'Cauchy error budget not justified')
    ctx.prec = args.precision
    source = args.local.read_bytes()
    require(hashlib.sha256(source).hexdigest() == CATALOGUE_SHA256,
            'local catalogue hash mismatch')
    catalog = json.loads(source)
    require(catalog.get('dps') == 40 and set(catalog['results']) == set(CHARACTERS),
            'unexpected catalogue layout')
    outcomes = []
    for key, (num, b, count) in CHARACTERS.items():
        chi = character(num, b)
        row = catalog['results'][key]
        require(row['conrey_label'] == '15.' + str(num) and
                row['count'] == count and len(row['zeros']) == count,
                'catalogue count or label mismatch')
        t_ref, anchor = phase_reference(chi)
        previous = Q(0)
        for i, seed in enumerate(row['zeros'], 1):
            require(Q(seed) - ROOT_RADIUS > previous, 'root intervals overlap')
            result = witness(chi, seed, anchor)
            previous = Q(seed) + ROOT_RADIUS
            outcomes.append({'character': '15.' + str(num), 'index': i, **result})
    require(len(outcomes) == 37, 'missing roots')
    print(json.dumps({'status': 'ALTERNATIVE_LOCAL_WITNESSES_PASS',
                      'witnesses': len(outcomes),
                      'by_character': {str(num): sum(x['character']=='15.'+str(num) for x in outcomes)
                                       for num,_,_ in CHARACTERS.values()},
                      'precision': args.precision,
                      'cauchy_error_budget': str(ERROR_BUDGET),
                      'exhaustive_contour_count_proved_by_this_script': False,
                      'independent_native_backend': False,
                      'global_GRH_LI_or_density_proved': False}, indent=2))


if __name__ == '__main__':
    main()
