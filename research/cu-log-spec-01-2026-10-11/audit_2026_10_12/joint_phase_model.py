#!/usr/bin/env python3
"""CU-LOG-SPEC-05: conditional phase model and negative controls.

No sieve, no prime-count input, no reserved-window observations.
NumPy/SciPy arithmetic is reproducible numerical arithmetic, not interval
certification. A partial zero catalogue NEVER generates a forecast here.
"""
import cmath
import itertools
import json
import math
from fractions import Fraction
from pathlib import Path

import numpy as np
from scipy.special import j0

ORDERS = (2, 4, 6)
PRIMES = (3, 5, 7)
ALPHA = 1 / 3
CHI5 = (0, 2, 0)
KEYS = tuple(k for k in itertools.product(*(range(d) for d in ORDERS))
             if k != (0, 0, 0))
INDEX = {k: i for i, k in enumerate(KEYS)}


def conjugate(k):
    return tuple((-v) % d for v, d in zip(k, ORDERS))


def conductor(k):
    return math.prod(p for p, v in zip(PRIMES, k) if v)


def real_keys():
    return tuple(k for k in KEYS if conjugate(k) == k)


def pair_keys():
    return tuple(k for k in KEYS if k < conjugate(k))


def coefficient(gamma, alpha=ALPHA):
    if not (gamma > 0 and 0 < alpha < 1):
        raise ValueError('positive ordinate and 0 < alpha < 1 required')
    return (1 - math.sqrt(alpha) * cmath.exp(1j * gamma * math.log(alpha))) / (.5 + 1j * gamma)


def classical_variances():
    """Formal filtered zero sums; stochastic interpretation needs stated LI/NVC."""
    values = []
    for k in KEYS:
        f = conductor(k)
        odd = sum(k) % 2
        chi2 = math.cos(2 * math.pi * (k[0] / 2 + k[1] / 4 + k[2] / 3))
        values.append((2 / 3) * (math.log(f / math.pi) - np.euler_gamma)
                      + odd * (math.log(2) / 3 + math.log(9 / 8))
                      - math.log(2) / 3 * chi2)
    return np.array(values)


def validate_catalog(entries):
    seen = set()
    for item in entries:
        k = tuple(item['character'])
        gamma = float(item['gamma'])
        if k not in INDEX or not math.isfinite(gamma) or gamma <= 0:
            raise ValueError('invalid character or positive ordinate')
        token = (k, str(item['gamma']))
        if token in seen:
            raise ValueError('duplicate labelled zero')
        seen.add(token)


def sample_modes(entries, draws, seed):
    """Independent Haar phases for a FINITE declared catalogue.

    The caller must not identify synthetic/partial data with the complete
    L-zero law. A positive zero of chi contributes to chi and its conjugate.
    Positive zeros of a non-real chi and bar(chi) are separate entries.
    """
    validate_catalog(entries)
    rng = np.random.default_rng(seed)
    z = np.zeros((draws, 47), dtype=complex)
    beta = 1 - math.sqrt(ALPHA)
    for k in real_keys():
        z[:, INDEX[k]] = -beta
    for item in entries:
        k = tuple(item['character'])
        kc = conjugate(k)
        w = coefficient(float(item['gamma'])) * np.exp(2j * np.pi * rng.random(draws))
        if k == kc:
            z[:, INDEX[k]] -= 2 * w.real
        else:
            z[:, INDEX[k]] -= w
            z[:, INDEX[kc]] -= w.conjugate()
    return z


def real_coordinates(z):
    columns = [z[:, INDEX[k]].real for k in real_keys()]
    for k in pair_keys():
        columns.extend([math.sqrt(2) * z[:, INDEX[k]].real,
                        math.sqrt(2) * z[:, INDEX[k]].imag])
    return np.column_stack(columns)


def ratios(z):
    squares = np.abs(z) ** 2
    den = squares.sum(axis=1)
    if np.any(den <= 0):
        raise ValueError('undefined energy ratios at zero denominator')
    f = np.array([conductor(k) for k in KEYS])
    return np.column_stack([squares[:, q % f == 0].sum(axis=1) / den
                            for q in (15, 21, 35)]
                           + [squares[:, INDEX[CHI5]] / den])


def residual_variances(entries):
    """Numerical residuals, not certificates for the input roots."""
    validate_catalog(entries)
    captured = np.zeros(47)
    for item in entries:
        k = tuple(item['character'])
        kc = conjugate(k)
        a = abs(coefficient(float(item['gamma']))) ** 2
        if k == kc:
            captured[INDEX[k]] += 2 * a
        else:
            captured[INDEX[k]] += a
            captured[INDEX[kc]] += a
    return classical_variances() - captured, captured


def ratio_error_bound(epsilon, r):
    """If ||zT||>=r and ||z-zT||<=epsilon<r, each ratio error<=this."""
    if not (0 <= epsilon < r):
        raise ValueError('0 <= epsilon < r required')
    return min(1.0, 4 * epsilon / r)


def counting_envelope_bound(T, A, B, C=0.0, D=0.0, known_N_T=0):
    """Conditional on N(t)<=A*t*log(B*t)+C*log(B*t)+D for ALL t>=T.

    N counts BOTH signs. Constants are not supplied or certified here.
    known_N_T must be a certified count. No numerical L-zero certification.
    """
    if T <= 0 or B * T < 1 or min(A, C, D, known_N_T) < 0:
        raise ValueError('invalid envelope parameters')
    integral = (2 * A * (math.log(B * T) + 1) / T
                + (C * (math.log(B * T) + .5) + D) / T ** 2
                - known_N_T / T ** 2)
    if integral < 0:
        raise ValueError('inconsistent count/envelope')
    return (1 + math.sqrt(ALPHA)) ** 2 * integral


def bmor_height_tail(f, T):
    """Analytic upper bound from Bennett-Martin-O'Bryant-Rechnitzer Cor.1.2.

    Both signs, multiplicities. Uses the pair (0.247,6.894), valid T>=5/7.
    Numerically evaluated with floats: NOT an outward-rounded certificate.
    A complete low-zero catalogue is still needed to instantiate truncation.
    """
    if f <= 1 or T < 5 / 7:
        raise ValueError('f>1 and T>=5/7 required')
    c, d = .247, 6.894
    main = T / math.pi * math.log(f * T / (2 * math.pi * math.e))
    error = c * math.log(f * T) + d
    lower_count = max(0., main - error)
    integrated_upper = (2 / math.pi * (math.log(f * T / (2 * math.pi * math.e)) + 1) / T
                        + (c * (math.log(f * T) + .5) + d) / T ** 2)
    return (1 + math.sqrt(ALPHA)) ** 2 * (integrated_upper - lower_count / T ** 2)


def haar_moment(*frequencies):
    """Exact integral of a product of cos(n*theta), by Laurent coefficients."""
    poly = {0: Fraction(1)}
    for n in frequencies:
        nxt = {}
        for e, c in poly.items():
            for sign in (-1, 1):
                nxt[e + sign * n] = nxt.get(e + sign * n, Fraction(0)) + c / 2
        poly = nxt
    return poly.get(0, Fraction(0))


def audit():
    path = Path(__file__).with_name('chi5_partial_catalog.json')
    catalog = json.loads(path.read_text(encoding='utf8'))
    entries = catalog['positive_zeros']
    residual, captured = residual_variances(entries)
    variances = classical_variances()
    i5 = INDEX[CHI5]
    a = [abs(coefficient(float(x['gamma']))) ** 2 for x in entries]
    tail_half = residual[i5] / 2
    quartic = sum(v * v for v in a)
    kappa_interval = [-6 * (quartic + tail_half ** 2) / variances[i5] ** 2,
                      -6 * quartic / variances[i5] ** 2]
    # Deterministic checks of phase CF / Gaussian-replacement bounds for the
    # finite supplied chi5 subset. These are not full-tail distribution checks.
    max_cf_error = max_gaussian_error = 0.0
    for t in (0.1, 0.5, 1., 2., 3., 5., 10.):
        phi = float(np.prod([j0(2 * math.sqrt(v) * t) for v in a]))
        gauss = math.exp(-t * t * sum(a))
        max_gaussian_error = max(max_gaussian_error, abs(phi - gauss))
        assert abs(phi - gauss) <= .75 * t ** 4 * quartic + 1e-14
        # Drop the last five known entries and bound the CF difference.
        first = float(np.prod([j0(2 * math.sqrt(v) * t) for v in a[:-5]]))
        err = abs(first - phi)
        max_cf_error = max(max_cf_error, err)
        assert err <= t * t * sum(a[-5:]) + 1e-14
    # LI alone has no uniform finite-time rate: 1 and 1+sqrt(2)/10^6
    # are Q-independent, but their beat remains almost constant over Y=100.
    Y = 100.
    difference = math.sqrt(2) / 1_000_000
    beat = abs(math.sin(difference * Y / 2) / (difference * Y / 2))
    # One-zero conjugacy failure: correct energy=2|c|^2; modelling one
    # member as a real cosine then copying doubles the expected energy.
    synthetic_a = abs(coefficient(7.0)) ** 2
    # A small absolute perturbation near zero has a fixed ratio error 1/2.
    epsilon = Fraction(1, 10**12)
    # Full-energy laws cannot identify U versus (U,U^2) dependence when
    # magnitudes are fixed: both pair energies are exactly 2.
    result = {
        'date': '2026-10-12',
        'parent_commit': 'a39bee37187d71d0f5007d5bf6225217683d52b3',
        'status': 'first conditional joint model; NO full numerical forecast',
        'prime_counts_computed': False,
        'reserved_window_examined': False,
        'statistics': ['F15', 'F21', 'F35', 'Gchi5'],
        'characters': 47, 'real_modes': len(real_keys()),
        'complex_pairs': len(pair_keys()), 'independent_character_blocks_under_LI': 27,
        'conductor_dimensions': {str(f): sum(conductor(k) == f for k in KEYS)
                                  for f in (3, 5, 7, 15, 21, 35, 105)},
        'numerical_not_interval_certified': {
            'formal_trace_variance': float(variances.sum()),
            'catalogued_positive_zeros': len(entries),
            'catalogued_characters': 1,
            'captured_trace_variance': float(captured.sum()),
            'uncaptured_trace_variance': float(residual.sum()),
            'uncaptured_fraction': float(residual.sum() / variances.sum()),
            'chi5_uncaptured_variance': float(residual[i5]),
            'chi5_excess_kurtosis_outer_bounds': kappa_interval,
            'max_known_subset_cf_drop_error': max_cf_error,
            'max_known_subset_cf_gaussian_error': max_gaussian_error,
            'finite_identity_r_at_300M': math.sqrt(ALPHA) * math.log(300_000_000) / math.log(100_000_000),
            'asymptotic_r': math.sqrt(ALPHA),
            'near_resonance_beating_average_abs': beat,
            'synthetic_conjugacy_correct_energy': 2 * synthetic_a,
            'synthetic_conjugacy_wrong_cosine_energy': 4 * synthetic_a,
        },
        'exact_negative_controls': {
            'resonant_cov_cos1_cos2': str(haar_moment(1, 2)),
            'resonant_E_cos1_squared_cos2': str(haar_moment(1, 1, 2)),
            'resonant_E_cos1_squared_cos2_squared': str(haar_moment(1, 1, 2, 2)),
            'resonant_cov_cos1_cos3': str(haar_moment(1, 3)),
            'resonant_E_cos1_cubed_cos3': str(haar_moment(1, 1, 1, 3)),
            'near_zero_absolute_error_norm': str(epsilon),
            'near_zero_ratio_change': '1/2',
            'equal_radius_dependent_and_independent_four_ratios': 'identical; energies cannot recover phase dependence',
        },
        'catalog_certification': catalog['certification'],
        'analytic_height_bound_float_evaluations': {
            str(T): sum(bmor_height_tail(conductor(k), T) for k in KEYS)
            for T in (100, 1000, 10000, 100000, 1000000)
        },
        'height_bound_scope': 'Hypothetical complete truncation of all 47 primitive modes at T. Published BMOR bound and analytic integration; float evaluations only, no corresponding complete catalogues available here.',
        'test_gate': 'NOT READY: other character zero catalogues, interval root/weight bounds, ratio small-ball control and finite-scale calibration missing',
    }
    return result


if __name__ == '__main__':
    print(json.dumps(audit(), ensure_ascii=False, indent=2))
