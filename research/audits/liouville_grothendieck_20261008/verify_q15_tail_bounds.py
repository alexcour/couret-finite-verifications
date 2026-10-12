#!/usr/bin/env python3
"""Exact q15 tail aggregation; conditional phase/Gaussian error bounds.

This stdlib check consumes pinned receipts. The Arb zero replay and analytic
constant replay are separate necessary checks; parsing a receipt is not a proof
of its numerical enclosures. No GRH, LI or prime density is certified here.
"""
import argparse
import hashlib
import json
from fractions import Fraction as Q
from math import isqrt, prod
from pathlib import Path

HERE = Path(__file__).resolve().parent
INPUTS = {
    'q15_root_interval_certificate_20261012.json':
        'b694a1e8382b25fb3843f80854721a9c569377344d7818e10fb85f5f9c5ff684',
    'spectral_constants_certificate_20261012.json':
        '7d511b7d67697b287e41f1459e3e635b39a66cf6aa5c9c4897a7c1121ab64355',
}
LABELS = {'15.2': 12, '15.14': 13, '15.8': 12}
D = Q(2501, 4)
GRID = 10**12
SCALE = 2**80


def require(ok, message):
    if not ok:
        raise ValueError(message)


def dyadic(pair):
    m, e = int(pair[0]), int(pair[1])
    return Q(m) * Q(2)**e


def outward(x, upper=False, digits=6):
    scale = 10**digits
    n = (x.numerator*scale)//x.denominator
    if upper and Q(n, scale) < x:
        n += 1
    sign = '-' if n < 0 else ''
    return f'{sign}{abs(n)//scale}.{abs(n)%scale:0{digits}d}'


def interval(lo, hi):
    require(lo <= hi, 'reversed interval')
    return {'lower_exact': str(lo), 'upper_exact': str(hi),
            'decimal_outer_bounds': [outward(lo), outward(hi, True)]}


def upper_bound(x):
    require(x >= 0, 'negative error bound')
    return {'upper_exact': str(x), 'decimal_upper_bound': outward(x, True)}


def sqrt_bound(x, upper=False):
    require(x > 0, 'nonpositive square-root input')
    n = isqrt((x.numerator*GRID*GRID)//x.denominator)
    if upper and Q(n, GRID)**2 < x:
        n += 1
    result = Q(n, GRID)
    require(result > 0, 'square-root lower bound unresolved')
    require(result**2 >= x if upper else result**2 <= x, 'invalid sqrt bound')
    return result


def validate_roots(c):
    require(c['global_GRH_or_LI_proved'] is False and
            c['prime_race_density_certified'] is False, 'false global promotion')
    require(c['finite_positive_q15_catalogue_complete_within_declared_region'] is True,
            'finite completeness absent')
    require(c['contour_vertices_exact'] ==
            [['-1/8','0'], ['9/8','0'], ['9/8','25'], ['-1/8','25'], ['-1/8','0']],
            'cutoff contour changed')
    require(c['isolated_simple_critical_line_roots'] == 37 and
            c['total_nontrivial_positive_zeros_counted'] == 37, 'total count changed')
    require(len(c['by_character']) == 3, 'character count changed')
    counts = {row['character']: row for row in c['by_character']}
    require(set(counts) == set(LABELS), 'character labels changed')
    roots = {label: [] for label in LABELS}
    for row in c['root_intervals']:
        label = row['character']
        require(label in roots, 'unknown root character')
        a, b = Q(row['imaginary_lower_exact']), Q(row['imaginary_upper_exact'])
        require(0 < a < b < 25 and b-a == Q(2,10**30), 'invalid root interval')
        require(row['existence_on_critical_line'] is True and
                row['unique_simple_zero_in_rectangle'] is True, 'missing isolation')
        require(row['left_hardy_sign']*row['right_hardy_sign'] == -1, 'no sign change')
        for side in ('left', 'right'):
            enclosure = row[side+'_hardy_enclosure']
            lo, hi = map(dyadic, (enclosure['lower_dyadic'], enclosure['upper_dyadic']))
            s = row[side+'_hardy_sign']
            require(lo <= hi and ((lo > 0 and s == 1) or (hi < 0 and s == -1)),
                    'recorded Hardy enclosure lacks strict sign')
        component = row['nonzero_derivative_component']
        require(component in ('real','imaginary'), 'derivative component changed')
        enclosure = row['derivative_'+component+'_enclosure_over_rectangle']
        lo, hi = map(dyadic, (enclosure['lower_dyadic'], enclosure['upper_dyadic']))
        require(lo <= hi and (lo > 0 or hi < 0), 'derivative enclosure contains zero')
        require(row['index_1based'] == len(roots[label])+1, 'root rank changed')
        require(not roots[label] or roots[label][-1][1] < a, 'root intervals overlap')
        roots[label].append((a,b))
    for label, number in LABELS.items():
        row = counts[label]
        require(len(roots[label]) == number == row['isolated_simple_roots'] ==
                row['zero_count_with_multiplicity'], 'isolated/count mismatch')
        require(row['boundary_proved_nonzero_by_interval_charts'] is True and
                row['integer_isolated'] is True, 'boundary/count witness absent')
        e = row['winding_enclosure']
        lo, hi = map(dyadic, (e['lower_dyadic'],e['upper_dyadic']))
        require(number-1 < lo <= number <= hi < number+1, 'winding integer not isolated')
        require(dyadic(row['minimum_rotated_real_lower_dyadic']) > 0,
                'contour margin not positive')
    return roots


def low_mass(roots, labels, factor):
    def rounded(x, upper=False):
        n = x.numerator*SCALE//x.denominator
        if upper and Q(n,SCALE) < x:
            n += 1
        return Q(n,SCALE)
    return (sum((rounded(factor/(Q(1,4)+b*b))
                 for label in labels for a,b in roots[label]), Q(0)),
            sum((rounded(factor/(Q(1,4)+a*a),True)
                 for label in labels for a,b in roots[label]), Q(0)))


def sign_envelope(roots, vq, vr, p2):
    amplitudes = sorted([(4*(vr if label == '15.14' else vq)/(Q(1,4)+b*b),
                          label, rank)
                         for label in roots for rank,(a,b) in enumerate(roots[label],1)],
                        reverse=True)
    choices = []
    for number in range(10,37,2):
        selected = amplitudes[:number]
        m = number//2
        lowers = [sqrt_bound(x[0]) for x in selected]
        C = sqrt_bound(Q(2,3)**number/prod(lowers), upper=True)
        # This finite grid only chooses witnesses; no optimization claim is made.
        candidates = [(Q(j,100)**4/4 + C*Q(j,100)**(4-m)/(m-4), Q(j,100))
                      for j in range(1,1001)]
        integral, tau = min(candidates)
        choices.append((p2*integral/64, number, tau, C, integral, selected, lowers))
    error, number, tau, C, integral, selected, lowers = min(choices, key=lambda x:x[0])
    return {'uniform_threshold_probability_error_upper': upper_bound(error),
            'selected_independent_low_phases': number, 'split_t_exact': str(tau),
            'bessel_product_C_upper_exact': str(C),
            'integral_t_cubed_envelope_upper_exact': str(integral),
            'selected_phase_witnesses': [dict(character=x[1], index_1based=x[2],
                                            amplitude_lower_exact=str(r))
                                         for x,r in zip(selected,lowers)]}


def aggregate(c, k):
    roots = validate_roots(c)
    constants = k['analytic_constants']
    residuals, lows = {}, {}
    for ab, labels, factor in [('1,1',('15.2','15.8'),Q(1)),
                               ('1,2',('15.14',),Q(2))]:
        lo, hi = low_mass(roots, labels, factor)
        row = constants[ab]['K']
        kl, kh = Q(int(row['lower_integer']),int(row['denominator'])), Q(int(row['upper_integer']),int(row['denominator']))
        require(0 < kl <= kh < 4, 'analytic K bounds outside declared scope')
        rl, rh = kl-hi, kh-lo
        require(rl > 0, 'positive residual not established')
        lows[ab], residuals[ab] = interval(lo,hi), interval(rl,rh)
    qlo, qhi = map(Q, (residuals['1,1']['lower_exact'],residuals['1,1']['upper_exact']))
    rlo, rhi = map(Q, (residuals['1,2']['lower_exact'],residuals['1,2']['upper_exact']))
    profiles = {}
    for group, names, vq, vr in [('base',('Q5','Q3','C5'),1,1),
                                 ('Q15',('Q15',),1,9), ('C15',('C15',),5,1)]:
        p2 = (16*vq*vq*qhi + 8*vr*vr*rhi)/D
        profiles[group] = dict(profile_names=list(names), quartic_v=vq, real_v=vr,
            conditional_q15_tail_variance=interval(2*vq*qlo+vr*rlo,2*vq*qhi+vr*rhi),
            conditional_tail_P2_upper=upper_bound(p2),
            smooth_and_characteristic_error_coefficient_upper=upper_bound(3*p2/64),
            **sign_envelope(roots,vq,vr,p2))
    single_lo, single_hi = low_mass(roots,('15.2',),Q(2))
    pair_lo, pair_hi = map(Q,(lows['1,1']['lower_exact'],lows['1,1']['upper_exact']))
    require(single_hi < pair_lo or pair_hi < single_lo,
            'conjugate-copy counterexample not separated')
    return {'id':'CU-BRUIT-Q15-TAIL-BOUNDS-20261012',
            'status':'EXACT_RECEIPT_AGGREGATION_AND_CONDITIONAL_PHASE_BOUNDS',
            'source_pr28_commit':'04fbd2f56de679bb1b8d5c7dc56354b20d3c9ccd',
            'input_sha256':INPUTS, 'cutoff_exact':'25',
            'unconditional_Hadamard_low_masses':lows,
            'unconditional_positive_Hadamard_residuals':residuals,
            'conditional_on_zero_certificate_trust_base':True,
            'GRH_required_for_residual_as_phase_tail_weight':True,
            'independent_uniform_phases_required_for_probability_bounds':True,
            'replacement_scope':'Only q15 phases with positive ordinate >25; all other phases unchanged',
            'profiles':profiles,
            'conjugate_positive_copy_counterexample':{'incorrect_2_times_15_2_positive_mass':interval(single_lo,single_hi),
                                                     'correct_signed_pair_mass':lows['1,1']},
            'global_GRH_or_LI_proved':False, 'prime_race_density_certified':False,
            'q3_q5_zero_certification_performed':False,
            'independent_human_review_claimed':False, 'originality_claimed':False}


def main():
    p = argparse.ArgumentParser(description=__doc__)
    g = p.add_mutually_exclusive_group()
    g.add_argument('--check',action='store_true')
    g.add_argument('--write',action='store_true')
    args = p.parse_args()
    data = {}
    for name, digest in INPUTS.items():
        raw = (HERE/name).read_bytes()
        require(hashlib.sha256(raw).hexdigest() == digest, 'pinned input receipt changed: '+name)
        data[name] = json.loads(raw)
    report = aggregate(data['q15_root_interval_certificate_20261012.json'],
                       data['spectral_constants_certificate_20261012.json'])
    rendered = json.dumps(report,indent=2,sort_keys=True)+'\n'
    fixture = HERE/'q15_tail_bounds_20261012.json'
    if args.write:
        fixture.write_text(rendered,encoding='utf-8',newline='')
    if args.check:
        require(fixture.read_bytes() == rendered.encode(), 'tail receipt differs from exact recomputation')
    print(json.dumps({'status':report['status'], 'positive_residuals':{n:r['decimal_outer_bounds']
                         for n,r in report['unconditional_positive_Hadamard_residuals'].items()},
                      'conditional_probability_error_bounds':{n:r['uniform_threshold_probability_error_upper']['decimal_upper_bound']
                          for n,r in report['profiles'].items()},'prime_race_density_certified':False},indent=2))


if __name__ == '__main__':
    try:
        main()
    except (ValueError,KeyError,OSError,TypeError) as e:
        raise SystemExit('FAIL CLOSED: '+str(e))
