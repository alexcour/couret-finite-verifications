#!/usr/bin/env python3
"""Exact Q5 anti-concentration and finite non-resonance audit.

Standard library only. Receipt arithmetic does not replay Arb inclusions,
prove GRH/LI/ELI, or certify a finite-horizon arithmetic prime race.
"""
import argparse
import hashlib
import itertools
import json
from fractions import Fraction as Q
from pathlib import Path

HERE = Path(__file__).resolve().parent
INPUTS = {
    'q15_root_interval_certificate_20261012.json':
        'b694a1e8382b25fb3843f80854721a9c569377344d7818e10fb85f5f9c5ff684',
    'q3_q5_root_interval_certificate_20261013.json':
        '5284f66aca1ae9c8df2986214c33020d14fd082840c6e4c8ad9829101545340f',
    'all_tail_bounds_20261013.json':
        '5d3d0c7d462fa84e2701be3585ca7b8f11269287062613e1c4ba1d6157862189',
}
EXPECTED_COUNTS = {'3.2': 6, '5.2': 8, '5.4': 8, '5.3': 8,
                   '15.2': 12, '15.14': 13, '15.8': 12}
WIDTH = Q(2, 10**30)
RECEIPT = 'quantitative_specialization_20261013.json'


def require(condition, message):
    if not condition:
        raise ValueError(message)


def pinned_inputs(directory=HERE):
    data = {}
    for name, digest in INPUTS.items():
        raw = (directory / name).read_bytes()
        require(hashlib.sha256(raw).hexdigest() == digest,
                'pinned input changed: ' + name)
        data[name] = json.loads(raw)
    return data


def fourier_parameters():
    units = (1, 7, 11, 13, 17, 19, 23, 29)
    support = {1, 11, 29}
    log5 = {1: 0, 2: 1, 4: 2, 3: 3}
    ipowers = ((1, 0), (0, 1), (-1, 0), (0, -1))

    def transform(values):
        out = []
        for epsilon in range(2):
            for k in range(4):
                re, im = 0, 0
                for a, value in zip(units, values):
                    sign = (-1)**(epsilon * (a % 3 == 2))
                    u, v = ipowers[(-k * log5[a % 5]) % 4]
                    re += value * sign * u
                    im += value * sign * v
                out.append((Q(re, 8), Q(im, 8)))
        return out

    values = [5 if a in support else -3 for a in units]
    coeff = transform(values)
    expected = [0, 1, 3, 1, -1, 1, -1, 1]
    require(coeff == [(Q(c), Q(0)) for c in expected], 'Q5 Fourier mismatch')
    square_coeff = transform([5 if a*a % 30 in support else -3 for a in units])
    require(square_coeff == [(Q(c), Q(0)) for c in (1, 0, 4, 0, 0, 0, 0, 0)],
            'square pullback Fourier mismatch')
    bias = -Q(sum(v * sum(b*b % 30 == a for b in units)
                  for a, v in zip(units, values)), 8)
    require(bias == -1, 'prime-square bias mismatch')
    return dict(coefficients=expected, conductor_list=[5, 5, 5, 3, 15, 15, 15],
                lambda_t=9, lambda_t_square_pullback=5,
                parseval_normalized=15, bias_exact=str(bias),
                C_exact_symbolic='9*(log(30))^2',
                B_exact_symbolic='4*log(3)+6*log(5)',
                epsilon_for_theorem_5_17=3)


def root_boxes(data):
    rows = {}
    for name in INPUTS:
        if name == 'all_tail_bounds_20261013.json':
            continue
        doc = data[name]
        for flag in ('global_GRH_or_LI_proved', 'prime_race_density_certified',
                     'independent_human_review_claimed'):
            require(doc[flag] is False, 'root scope flag changed: ' + flag)
        require(doc['conditional_on_trusted_Arb_backend_and_written_argument'] is True,
                'root trust boundary removed')
        for row in doc['root_intervals']:
            key = (row['character'], row['index_1based'])
            require(key not in rows, 'duplicate root')
            lo, hi = Q(row['imaginary_lower_exact']), Q(row['imaginary_upper_exact'])
            require(0 < lo < hi < 25 and hi-lo == WIDTH, 'invalid root box')
            require(row['unique_simple_zero_in_rectangle'] is True,
                    'local isolation unresolved')
            rows[key] = (lo, hi)
        for row in doc['by_character']:
            label = row['character']
            count = EXPECTED_COUNTS[label]
            require(row['isolated_simple_roots'] == row['zero_count_with_multiplicity'] == count,
                    'root count mismatch')
            require(row['boundary_proved_nonzero_by_interval_charts'] is True,
                    'contour boundary unresolved')
    require(len(rows) == 67, 'incomplete catalogue')
    for label, count in EXPECTED_COUNTS.items():
        keys = sorted(i for char, i in rows if char == label)
        require(keys == list(range(1, count+1)), 'character catalogue mismatch')
        for i in range(1, count):
            require(rows[label, i][1] < rows[label, i+1][0], 'root boxes overlap')
    return rows


def density_bound(tail, rows):
    require(tail['global_GRH_or_LI_proved'] is False
            and tail['prime_race_density_certified'] is False
            and tail['independent_human_review_claimed'] is False,
            'full-tail scope promoted')
    require(tail['independent_uniform_phases_required_for_probability_bounds'] is True
            and tail['conditional_on_zero_certificate_trust_base'] is True,
            'full-tail trust assumptions removed')
    require(tail['counts_by_character'] == EXPECTED_COUNTS and tail['positive_roots'] == 67,
            'full-tail count mismatch')
    profile = tail['profiles']['Q5']
    require(profile['v_by_signed_representative'] ==
            {'0,1': 1, '0,2': 9, '1,0': 1, '1,1': 1, '1,2': 1},
            'wrong Fourier weights')
    witnesses = profile['selected_phase_witnesses']
    require(len(witnesses) == profile['selected_independent_low_phases'] == 12,
            'twelve distinct phases required')
    used, product = set(), Q(1)
    for item in witnesses:
        key = (item['character'], item['index_1based'])
        require(key not in used and key in rows, 'missing or repeated phase witness')
        used.add(key)
        a = Q(item['amplitude_lower_exact'])
        require(a > 0, 'nonpositive amplitude lower bound')
        v = 9 if key[0] == '5.4' else 1
        hi = rows[key][1]
        require(a*a * (Q(1, 4)+hi*hi) <= 4*v, 'amplitude witness exceeds root bound')
        product *= a
    C = Q(profile['bessel_product_C_upper_exact'])
    require(C > 0 and C*C*product >= Q(2, 3)**12, 'invalid Bessel envelope constant')
    split = Q(69, 50)
    H = (split+C/(5*split**5))/3
    require(H < Q(553, 1000), 'density bound does not close')
    # Exact summation over all positive roots: V=2*sum(v/(1/4+gamma^2)).
    vlo = sum((2*(9 if k[0] == '5.4' else 1)/(Q(1,4)+hi*hi)
               for k, (lo, hi) in rows.items()), Q(0))
    vhi = sum((2*(9 if k[0] == '5.4' else 1)/(Q(1,4)+lo*lo)
               for k, (lo, hi) in rows.items()), Q(0))
    require(2*vhi < Q(2197, 1000)**2, 'Lipschitz upper bound does not close')
    w = profile['conditional_full_tail_variance']
    require(0 < Q(w['lower_exact']) <= Q(w['upper_exact']) <= Q(842503, 10**6),
            'tail variance upper bound changed')
    require(Q(842503, 10**6) < Q(918, 1000)**2, 'tail coupling bound does not close')
    return dict(Bessel_C_upper_exact=str(C), split_exact=str(split),
                density_upper_exact=str(H), density_safe_upper_exact='553/1000',
                symmetric_window_bound='mu([-h,h])<=553*h/500',
                V_low_safe_bounds=['2412114/1000000', '2412115/1000000'],
                V_low_safe_bounds_checked=(Q(2412114, 10**6) < vlo <= vhi < Q(2412115, 10**6)),
                Lipschitz_safe_upper_exact='2197/1000',
                tail_coupling_safe_upper_exact='459/500',
                valid_for='independent-phase Q5 law and its 25-height truncation',
                probability_sign_computed_by_this_checker=False)


def certify_finite_gap(boxes, M, max_modes=100000):
    """Exhaust every nonzero integer mode; fail if any interval contains zero.

    Only small finite systems are supported. Returns a lower gap bound, not
    global LI or ELI. Intervals need not be independent probabilistically.
    """
    require(isinstance(M, int) and not isinstance(M, bool) and M >= 1, 'invalid mode cap')
    require(boxes and all(0 < lo <= hi for lo, hi in boxes), 'invalid frequency boxes')
    n = len(boxes)
    count = (2*M+1)**n-1
    require(count <= max_modes, 'mode budget exceeded; no certificate issued')
    # A common integer denominator keeps every propagated endpoint exact.
    from math import lcm
    den = 1
    for lo, hi in boxes:
        den = lcm(den, lo.denominator, hi.denominator)
    ints = [(int(lo*den), int(hi*den)) for lo, hi in boxes]
    best, argmin, tested, S = None, None, 0, Q(0)
    for mode in itertools.product(range(-M, M+1), repeat=n):
        norm2 = sum(m*m for m in mode)
        if not norm2:
            continue
        lower = sum(m*(lo if m >= 0 else hi) for m, (lo, hi) in zip(mode, ints))
        upper = sum(m*(hi if m >= 0 else lo) for m, (lo, hi) in zip(mode, ints))
        require(lower > 0 or upper < 0, 'a propagated mode contains zero')
        gap = min(abs(lower), abs(upper))
        if best is None or gap < best:
            best, argmin = gap, mode
        tested += 1
        S += Q(1, norm2)
    require(tested == count and best > 0, 'incomplete finite-mode coverage')
    return dict(gap_lower_exact=str(Q(best, den)), min_lower_bound_mode=list(argmin),
                modes_checked=tested, mode_cap=M, dimension=n,
                S_weighted_exact=str(S), global_LI_or_ELI_proved=False)


def precision_obstruction(rows):
    n, M, T = len(rows), 67, Q(25)
    require(n == 67, 'precision obstruction needs the full catalogue')
    centres = [(lo+hi)/2 for lo, hi in rows.values()]
    require(all(0 < g < T for g in centres), 'centre outside cutoff')
    pigeonhole = M*n*T/((M+1)**n-1)
    require(pigeonhole < Q(188, 10**120) < WIDTH/2, 'precision obstruction does not close')
    return dict(dimension=n, mode_cap=M, cutoff_exact=str(T),
                subset_sum_count=str((M+1)**n),
                signed_nonzero_mode_count=str((2*M+1)**n-1),
                gap_upper_exact=str(pigeonhole), gap_decimal_safe_upper='1.88e-118',
                smallest_nonzero_propagation_radius_exact=str(WIDTH/2),
                independent_box_propagation_can_certify_all_modes=False,
                global_nonresonance_refuted=False,
                actual_gap_computed=False)


def build_report(data):
    rows = root_boxes(data)
    H = density_bound(data['all_tail_bounds_20261013.json'], rows)
    require(H['V_low_safe_bounds_checked'], 'low-variance enclosure does not close')
    cutoff = Q(4)
    require(all(hi < cutoff or lo > cutoff for lo, hi in rows.values()),
            'small-cutoff root membership unresolved')
    selected = sorted((k, bounds) for k, bounds in rows.items() if bounds[1] < cutoff)
    require(len(selected) == 2, 'unexpected T=4 truncation')
    small = certify_finite_gap([b for k, b in selected], 64)
    require(Q(small['gap_lower_exact']) > Q(11839, 10**6)
            and Q(small['S_weighted_exact']) < 30, 'small-gap quantitative bounds do not close')
    # sqrt(6)<49/20 and sqrt(30)<11/2 give the stated torus majorant.
    require(Q(49,20)**2 > 6 and Q(11,2)**2 > 30,
            'torus rational square-root majorants invalid')
    L4_squared_upper = 4*sum((1/(Q(1,4)+b[0]*b[0]) for k, b in selected), Q(0))
    require(L4_squared_upper < 1, 'height-4 projection bound does not close')
    small.update(cutoff_exact='4',
                 frequency_labels=[{'character': k[0], 'index_1based': k[1]} for k, b in selected],
                 finite_positive_catalogue_complete_under_source_trust=True,
                 applies_to='two-frequency height-4 truncation, not the 67-frequency height-25 system',
                 gap_safe_lower_exact='11839/1000000', S_safe_upper_exact='30',
                 projected_Lipschitz_safe_upper_exact='1',
                 torus_W1_bound='49/320+11000000/(11839*(X-log(2)))',
                 global_LI_assumed_for_full_Haar_in_theorem_3_4_application=True,
                 arithmetic_truncation_or_full_phase_tail_included_in_this_bound=False)
    return dict(id='CU-BRUIT-Q5-QUANTITATIVE-SPECIALIZATION-20261013',
                status='EXACT_RECEIPT_ARITHMETIC_AND_FINITE_SMALL_GAP',
                input_sha256=INPUTS, Fourier=fourier_parameters(),
                density_and_coupling=H, precision_obstruction=precision_obstruction(rows),
                finite_gap_height_4=small,
                conditional_on_internal_source_enclosures=True,
                density_requires_independent_uniform_phases=True,
                GRH_or_LI_or_ELI_proved=False,
                arithmetic_error_at_any_finite_horizon_certified=False,
                complete_arithmetic_to_model_budget_closed=False,
                independent_human_review_claimed=False)


def render(report):
    return json.dumps(report, indent=2, sort_keys=True)+'\n'


def main():
    p = argparse.ArgumentParser(description=__doc__)
    g = p.add_mutually_exclusive_group()
    g.add_argument('--check', action='store_true')
    g.add_argument('--write', action='store_true')
    args = p.parse_args()
    report = build_report(pinned_inputs())
    fixture = HERE / RECEIPT
    if args.write:
        fixture.write_text(render(report), encoding='utf-8', newline='')
    if args.check:
        require(fixture.read_bytes() == render(report).encode(), 'quantitative audit receipt differs')
    print(json.dumps(dict(status=report['status'],
          density_upper=report['density_and_coupling']['density_safe_upper_exact'],
          finite_gap_height_4=report['finite_gap_height_4']['gap_lower_exact'],
          finite_modes_checked=report['finite_gap_height_4']['modes_checked'],
          height_25_gap_upper=report['precision_obstruction']['gap_decimal_safe_upper'],
          finite_horizon_arithmetic_certified=False), indent=2))


if __name__ == '__main__':
    try:
        main()
    except (ValueError, KeyError, TypeError, OSError) as e:
        raise SystemExit('FAIL CLOSED: '+str(e))
