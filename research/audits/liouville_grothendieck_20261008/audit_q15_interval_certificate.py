#!/usr/bin/env python3
"""Internal adversarial replay; shares the certificate's trusted Arb backend.

Different contours and precision are cross-checks, not independent expertise
or a second proof implementation. The original instrument and receipt stay
byte-for-byte pinned. No claim is extended beyond positive q15 heights <= 25.
"""
import argparse
import hashlib
import json
import sys
from fractions import Fraction as Q
from pathlib import Path
from flint import acb
from certify_q15_root_intervals import (
    HERE, ROWS, CONTOUR, A, point, require, certificate, verify_receipt,
    primitive_character, CompletedL, count_contour,
)

AUDITED_COMMIT = '04fbd2f56de679bb1b8d5c7dc56354b20d3c9ccd'
INSTRUMENT_SHA = '339cd95772f171ad22aa53f5ad9f1ddc2365a63d3d33b971dd47f619d0809aed'
RECEIPT_SHA = 'b694a1e8382b25fb3843f80854721a9c569377344d7818e10fb85f5f9c5ff684'
AUDIT_PRECISION = 320
OUT_NAME = 'q15_interval_adversarial_audit_20261012.json'


def rectangle(left, right):
    return [(left,Q(0)), (right,Q(0)), (right,Q(25)),
            (left,Q(25)), (left,Q(0))]


def positive_rectangle(corners):
    """Check the geometry used here, not an arbitrary callback's analyticity."""
    require(len(corners) == 5 and corners[0] == corners[-1], 'not a four-edge closed rectangle')
    a,b,c,d,_ = corners
    require(a[0] < b[0] and a[1] < d[1] and
            a[1] == b[1] and b[0] == c[0] and
            c[1] == d[1] and d[0] == a[0], 'rectangle is not simple and positively oriented')


def pinned_file(name, expected):
    data = (HERE/name).read_bytes()
    require(hashlib.sha256(data).hexdigest() == expected, 'audited file changed: '+name)
    return data


def replay(local_path):
    pinned_file('certify_q15_root_intervals.py', INSTRUMENT_SHA)
    original = json.loads(pinned_file('q15_root_interval_certificate_20261012.json', RECEIPT_SHA))
    positive_rectangle(CONTOUR)
    print('Audit: original 256-bit receipt replay', file=sys.stderr, flush=True)
    verify_receipt(certificate(local_path,256),original)

    print('Audit: all 37 isolations and counts at 320 bits', file=sys.stderr, flush=True)
    higher = certificate(local_path,AUDIT_PRECISION)
    require(higher['isolated_simple_critical_line_roots'] == 37 and
            higher['total_nontrivial_positive_zeros_counted'] == 37, 'higher-precision count changed')
    require(all((x[k] == y[k]) for x,y in zip(original['root_intervals'],higher['root_intervals'])
                for k in ['character','index_1based','imaginary_lower_exact','imaginary_upper_exact',
                          'left_hardy_sign','right_hardy_sign','unique_simple_zero_in_rectangle']),
            'root identity or signs changed with precision')
    higher_digest = hashlib.sha256(json.dumps(higher,sort_keys=True,separators=(',',':')).encode()).hexdigest()

    alternatives = []
    regularization = []
    for number,b,expected in ROWS.values():
        chi = primitive_character(number,b)
        function = CompletedL(chi)
        for label,corners in [('wider',rectangle(Q(-1,4),Q(5,4))),
                              ('narrower',rectangle(Q(1,4),Q(3,4)))]:
            positive_rectangle(corners)
            print(f'Audit: {number} / {label} contour at 320 bits',file=sys.stderr,flush=True)
            result = count_contour(function,corners)
            require(result['zero_count_with_multiplicity'] == expected, 'alternative contour count changed')
            alternatives.append({'character':'15.'+str(number),'contour':label,
                                 'vertices_exact':[[str(x),str(y)] for x,y in corners],**result})

        # Different native evaluation paths at exact points near the apparent
        # Hurwitz pole. Overlap is a regression check, not a proof by sampling.
        for re,im in [(Q(1),Q(0)),(Q(31,25),Q(1,100)),
                      (Q(19,25),Q(1,100)),(Q(49,50),Q(1,50))]:
            s = point((re,im))
            taylor = function.regular_l(s,chi)
            direct = chi.l_function(s)
            require(taylor.is_finite() and direct.is_finite() and taylor.overlaps(direct),
                    'Taylor/direct L cross-check failed')
        box = acb(A(Q(99,100)).union(A(Q(101,100))),
                  A(Q(-1,100)).union(A(Q(1,100))))
        box_value = function(box)
        require(box_value.is_finite(), 'completed-function ball containing one is not finite')
        for re,im in [(Q(1),Q(0)),(Q(99,100),Q(1,100)),(Q(101,100),Q(-1,100))]:
            require(box_value.overlaps(function(point((re,im)))), 'box/point cross-check failed')
        regularization.append({'character':'15.'+str(number),'exact_point_cross_checks':4,
                               'completed_box_containing_one_finite':True,
                               'box_point_cross_checks':3})

    # Generic contour counting computes a signed winding number. The zero
    # interpretation additionally needs a holomorphic function and a simple
    # positive contour; for meromorphic input it is zeros minus poles.
    print('Audit: orientation, meromorphic and oscillatory controls',file=sys.stderr,flush=True)
    chi = primitive_character(2,1)
    reverse = count_contour(CompletedL(chi),list(reversed(CONTOUR)))
    require(reverse['zero_count_with_multiplicity'] == -12, 'orientation control failed')
    a,b = point((Q(1,2),Q(2))),point((Q(1,4),Q(10)))
    meromorphic = count_contour(lambda z:(z-a)/(z-b)**2)
    require(meromorphic['zero_count_with_multiplicity'] == -1, 'zero-minus-pole control failed')
    oscillatory = count_contour(lambda z:(acb(0,64)*z).exp())
    require(oscillatory['zero_count_with_multiplicity'] == 0, 'nonvanishing exponential winding changed')
    require(oscillatory['maximum_subdivision_depth'] > 0, 'oscillatory control did not exercise subdivision')
    try:
        count_contour(lambda z:(acb(0,64)*z).exp(),max_depth=0)
    except ValueError as e:
        require('chart unresolved' in str(e), 'unexpected unresolved-chart failure')
    else:
        raise ValueError('unresolved charts were accepted at zero subdivision depth')

    return {
        'id':'CU-BRUIT-Q15-ADVERSARIAL-AUDIT-20261012',
        'status':'INTERNAL_ADVERSARIAL_REPLAY_PASSED',
        'audited_original_commit':AUDITED_COMMIT,
        'instrument_sha256':INSTRUMENT_SHA,'original_receipt_sha256':RECEIPT_SHA,
        'original_256_bit_receipt_exact_replay':True,
        'cross_check_precision_bits':AUDIT_PRECISION,
        'higher_precision_certificate_canonical_json_sha256':higher_digest,
        'higher_precision_root_identities_and_endpoint_signs_unchanged':True,
        'higher_precision_counts':higher['by_character'],
        'alternative_contour_counts':alternatives,
        'regularization_near_one':regularization,
        'clockwise_15_2_winding':reverse,
        'meromorphic_one_zero_two_poles_winding':meromorphic,
        'entire_nonvanishing_exponential_winding':oscillatory,
        'unresolved_oscillatory_charts_rejected':True,
        'simple_positive_rectangle_geometry_checked':True,
        'generic_count_callback_holomorphicity_is_a_caller_obligation':True,
        'same_Arb_backend_and_same_counting_instrument_used':True,
        'second_independent_proof_implementation_claimed':False,
        'independent_human_review_claimed':False,'Lean_formalization_claimed':False,
        'global_GRH_or_LI_proved':False,'prime_race_density_certified':False,
        'scientific_scope_extended':False,
    }


def main():
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument('--local',type=Path,default=HERE/'q15_roots_refined_20261009.json')
    p.add_argument('--out',type=Path)
    p.add_argument('--check',action='store_true')
    args = p.parse_args()
    result = replay(args.local)
    if args.check:
        require(result == json.loads((HERE/OUT_NAME).read_text()), 'audit receipt differs from fresh replay')
    if args.out:
        args.out.write_text(json.dumps(result,indent=2,ensure_ascii=False)+'\n')
    print(json.dumps({'status':result['status'],'higher_precision_counts':
                     [x['zero_count_with_multiplicity'] for x in result['higher_precision_counts']],
                     'alternative_contours':len(result['alternative_contour_counts']),
                     'independent_human_review':False,'global_GRH_or_LI':False},indent=2))


if __name__ == '__main__':
    try:
        main()
    except (ValueError,OSError,KeyError,TypeError) as e:
        print('FAIL CLOSED: '+str(e),file=sys.stderr)
        sys.exit(2)
