#!/usr/bin/env python3
"""Exact aggregation of 67 certified low roots and full high-phase tail bounds.

Prerequisite numerical inclusions must be independently replayed by their Arb
instruments. GRH is required for K residuals as phase weights; independence is
required for Gaussian probability bounds. No actual prime density is claimed.
"""
import argparse
import hashlib
import json
from fractions import Fraction as Q
from verify_q15_tail_bounds import (HERE, INPUTS as Q15_INPUTS, require, validate_roots,
    low_mass, interval, upper_bound, sign_envelope_for_weights, D)

INPUTS = dict(Q15_INPUTS, **{'q3_q5_root_interval_certificate_20261013.json':
    '5284f66aca1ae9c8df2986214c33020d14fd082840c6e4c8ad9829101545340f'})
SMALL_LABELS = {'3.2':6,'5.2':8,'5.4':8,'5.3':8}
SIGNED = {'1,0':(('3.2',),2), '0,2':(('5.4',),2),
          '0,1':(('5.2','5.3'),1), '1,1':(('15.2','15.8'),1),
          '1,2':(('15.14',),2)}
MULTIPLICITY = {'1,0':1,'0,2':1,'0,1':2,'1,1':2,'1,2':1}
LABEL_TO_AB = {'3.2':'1,0','5.4':'0,2','5.2':'0,1','5.3':'0,1',
               '15.2':'1,1','15.8':'1,1','15.14':'1,2'}
PROFILE_BOOSTS = {'Q5':('0,2',9),'Q3':('1,0',9),'Q15':('1,2',9),
                  'C5':('0,1',5),'C15':('1,1',5)}


def all_roots(q15, small):
    roots = validate_roots(q15)
    extra = validate_roots(small,SMALL_LABELS,30,
                          'finite_positive_catalogue_complete_within_declared_region')
    require(not set(roots)&set(extra), 'duplicate character catalogue')
    roots.update(extra)
    require(set(roots)==set(LABEL_TO_AB) and sum(map(len,roots.values()))==67,
            'full catalogue accounting failed')
    return roots


def aggregate(q15, small, constants):
    roots = all_roots(q15,small)
    residuals, low = {}, {}
    for ab,(labels,factor) in SIGNED.items():
        slo,shi = low_mass(roots,labels,Q(factor))
        k = constants['analytic_constants'][ab]['K']
        klo,khi = Q(int(k['lower_integer']),int(k['denominator'])),Q(int(k['upper_integer']),int(k['denominator']))
        require(0 < klo <= khi < 4, 'K certificate lacks real-zero exclusion')
        require(klo-shi>0, 'positive tail residual unresolved')
        low[ab] = interval(slo,shi)
        residuals[ab] = interval(klo-shi,khi-slo)
    profiles = {}
    for name,(ab,boost) in PROFILE_BOOSTS.items():
        weights = {key:boost if key==ab else 1 for key in SIGNED}
        wlo = sum((MULTIPLICITY[key]*v*Q(residuals[key]['lower_exact']) for key,v in weights.items()),Q(0))
        whi = sum((MULTIPLICITY[key]*v*Q(residuals[key]['upper_exact']) for key,v in weights.items()),Q(0))
        p2 = 8/D*sum((MULTIPLICITY[key]*v*v*Q(residuals[key]['upper_exact']) for key,v in weights.items()),Q(0))
        label_weights = {label:weights[key] for label,key in LABEL_TO_AB.items()}
        profiles[name] = dict(v_by_signed_representative=weights,
            conditional_full_tail_variance=interval(wlo,whi),
            conditional_full_tail_P2_upper=upper_bound(p2),
            smooth_error_coefficient_upper=upper_bound(3*p2/64),
            uniform_characteristic_error_coefficient_upper=upper_bound(p2/32),
            **sign_envelope_for_weights(roots,label_weights,p2,Q(1,32)))
    return dict(id='CU-BRUIT-ALL-TAIL-BOUNDS-20261013',
        status='EXACT_67_ROOT_AGGREGATION_AND_CONDITIONAL_FULL_TAIL_BOUNDS',
        input_sha256=INPUTS,cutoff_exact='25',positive_roots=67,
        counts_by_character={k:len(v) for k,v in roots.items()},
        unconditional_Hadamard_low_masses=low,
        unconditional_positive_Hadamard_residuals=residuals,
        GRH_required_for_residual_as_phase_tail_weight=True,
        independent_uniform_phases_required_for_probability_bounds=True,
        conditional_on_zero_certificate_trust_base=True,
        replacement_scope='All seven-character phases with positive ordinate >25; 67 low phases retained',
        profiles=profiles,global_GRH_or_LI_proved=False,prime_race_density_certified=False,
        Gaussian_density_evaluated_by_this_program=False,independent_human_review_claimed=False,
        originality_claimed=False)


def pinned_inputs():
    data = {}
    for name,digest in INPUTS.items():
        raw = (HERE/name).read_bytes()
        require(hashlib.sha256(raw).hexdigest()==digest,'pinned input changed: '+name)
        data[name] = json.loads(raw)
    return data


def main():
    p = argparse.ArgumentParser(description=__doc__)
    g = p.add_mutually_exclusive_group()
    g.add_argument('--check',action='store_true')
    g.add_argument('--write',action='store_true')
    args = p.parse_args()
    data = pinned_inputs()
    report = aggregate(data['q15_root_interval_certificate_20261012.json'],
                       data['q3_q5_root_interval_certificate_20261013.json'],
                       data['spectral_constants_certificate_20261012.json'])
    rendered = json.dumps(report,indent=2,sort_keys=True)+'\n'
    fixture = HERE/'all_tail_bounds_20261013.json'
    if args.write:
        fixture.write_text(rendered,encoding='utf-8',newline='')
    if args.check:
        require(fixture.read_bytes()==rendered.encode(),'full tail receipt differs from exact replay')
    print(json.dumps(dict(status=report['status'],positive_roots=67,
        residuals={k:v['decimal_outer_bounds'] for k,v in report['unconditional_positive_Hadamard_residuals'].items()},
        profiles={k:dict(variance=v['conditional_full_tail_variance']['decimal_outer_bounds'],
                        error_upper=v['uniform_threshold_probability_error_upper']['decimal_upper_bound'])
                  for k,v in report['profiles'].items()},prime_density_certified=False),indent=2))


if __name__=='__main__':
    try:
        main()
    except (ValueError,KeyError,OSError,TypeError) as e:
        raise SystemExit('FAIL CLOSED: '+str(e))
