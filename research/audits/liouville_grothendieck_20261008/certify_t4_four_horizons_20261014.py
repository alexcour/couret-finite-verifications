#!/usr/bin/env python3
"""T=4 Q5 direct finite-horizon sign occupations, four exact time windows.

At B=2^e, y uniformly sampled on [log 2, log B].
The very same T=4 deterministic spectral signal is enclosed over every
rational x cell and compared with (a) the finite arithmetic prime path
and (b) the two-phase Haar reference.

This is four *observations* with certified numerical interval errors,
NOT any uniform-in-B estimate, effective ELI, GRH, LI or an assertion
about the full 67-phase sign law. Shared elementary interval backends
and root receipts are pinned by the imported previous verifier.
"""
import argparse
import json
from fractions import Fraction as Q
from pathlib import Path

from certify_finite_arithmetic_truncation_20261013 import (
    I,SCALE,grid_cells,log_q,prime_sieve,finite_occupation,
    spectral_parameters,spectral_at,root_boxes,pinned_inputs,require
)
from certify_finite_sign_transport_20261013 import check_libraries

HERE=Path(__file__).resolve().parent
EXPONENTS=(10,12,14,16)
PARTS=128
WIDTH_LIMIT=Q(1,32768)
MAX_DEPTH=16
NODE_LIMIT=25000
SOURCE_HAAR="t4_haar_sign_discrepancy_20261013.json"
SOURCE_SIGN="finite_sign_transport_20261013.json"
OUTPUT="t4_multi_horizon_comparison_20261014.json"


def max_interval(a,b):
    return I(max(a.lo,b.lo),max(a.hi,b.hi))


def positive_occupation(e,phases,derivative):
    require(e in EXPONENTS and len(phases)==2 and derivative==4,
            "unsupported T4 trajectory or horizon")
    normalizer=log_q(Q(2**e,2))
    require(normalizer.lo>0,"nonpositive log normalization")
    known=I.of(0)
    unknown=I.of(0)
    nonpositive=I.of(0)
    covered=I.of(0)
    terminal={'positive':0,'nonpositive':0,'unresolved':0}
    nodes=0
    max_depth=0
    previous=Q(2)
    for left,right in grid_cells(e,PARTS):
        require(left==previous and left<right,
                "initial rational grid does not connect")
        previous=right
        stack=[(left,right,0)]
        while stack:
            a,b,depth=stack.pop()
            nodes+=1
            require(nodes<=NODE_LIMIT,
                    "too many cells: no partial convergence report allowed")
            max_depth=max(max_depth,depth)
            mass=log_q(b/a)
            yc=log_q((a+b)/2)
            yl=log_q(a)
            yr=log_q(b)
            radius=max(yc.hi-yl.lo,yr.hi-yc.lo)
            require(radius>=0,"negative time-cell radius")
            box=spectral_at(yc,phases).widened(derivative*radius)
            state=('positive' if box.lo>0 else
                   'nonpositive' if box.hi<=0 else 'unresolved')
            if (state=='unresolved' and depth<MAX_DEPTH and
                    Q(mass.hi,SCALE)>WIDTH_LIMIT):
                mid=(a+b)/2
                require(a<mid<b,"adaptive split fails to progress")
                stack.append((mid,b,depth+1))
                stack.append((a,mid,depth+1))
                continue
            covered+=mass
            terminal[state]+=1
            if state=='positive':
                known+=mass
            elif state=='nonpositive':
                nonpositive+=mass
            else:
                unknown+=mass
    require(previous==2**e and
            covered.lo<=normalizer.hi and covered.hi>=normalizer.lo,
            "terminal cells do not cover the requested log interval")
    # The raw masses are log-lengths, not probabilities: normalize FIRST.
    # Clipping before division erroneously caps lengths to 1.
    raw=I(known.lo,known.hi+unknown.hi)/normalizer
    pos=I(max(0,raw.lo),min(SCALE,raw.hi))
    uncertain=unknown/normalizer
    require(0<=pos.lo<=pos.hi<=SCALE,
            "positive occupation not a probability")
    require(Q(uncertain.hi,SCALE)<Q(1,50),
            "unresolved mass excessive; no result promoted")
    return pos,uncertain,dict(
        cells=terminal,visited_nodes=nodes,max_depth=max_depth,
        covered_log_mass_exact=covered.exact(),
        total_mass_log_exact=normalizer.exact()
    )


def read_haar():
    row=json.loads((HERE/SOURCE_HAAR).read_text())
    require(row['height_cutoff']==4 and row['number_of_phases']==2 and
            row['external_independent_review_completed'] is False and
            row['uniform_in_horizon_rate_proved'] is False,
            "Haar reference scope changed")
    a,b=map(Q,row['positive_haar_probability_exact'])
    require(Q('0.091680')<=a<=b<=Q('0.091765'),
            "Haar reference is not expected certified interval")
    return I(I.of(a).lo,I.of(b).hi)


def historical_65536():
    row=json.loads((HERE/SOURCE_SIGN).read_text())
    require(row['prime_argument_upper']==65536 and
            row['unresolved_cells_counted_in_all_upper_bounds'] and
            not row['time_occupation_identified_with_Haar_or_independent_phase_law'],
            'previous finite sign receipt trust boundary changed')
    p=row['profiles']['4']['measures']
    return (
      I(I.of(Q(p['arithmetic_positive_occupation']['exact'][0])).lo,
        I.of(Q(p['arithmetic_positive_occupation']['exact'][1])).hi),
      I(I.of(Q(p['spectral_positive_occupation']['exact'][0])).lo,
        I.of(Q(p['spectral_positive_occupation']['exact'][1])).hi)
    )


def intersects(a,b):
    return a.lo<=b.hi and b.lo<=a.hi


def interval_data(value):
    return dict(exact=value.exact(),decimal_outer=value.decimal())


def build():
    check_libraries()
    roots=root_boxes(pinned_inputs())
    phases,derivative=spectral_parameters(roots,Q(4))
    require(len(phases)==2 and derivative==4,
            'T4 requires exactly two primitive signed phases')
    haar=read_haar()
    old_a,old_s=historical_65536()
    records={}
    for e in EXPONENTS:
        B=2**e
        spectrum,unresolved,meta=positive_occupation(e,phases,derivative)
        arithmetic=finite_occupation(prime_sieve(B))
        require(0<=arithmetic.lo<=arithmetic.hi<=SCALE,
                'arithmetic finite occupation outside probability range')
        if e==16:
            require(intersects(spectrum,old_s) and intersects(arithmetic,old_a),
                    'new B=65536 cover contradicts prior pinned signed cover')
        # Strictly same fixed finite time window in arithmetic and spectrum.
        first=(arithmetic-spectrum).abs()
        second=(spectrum-haar).abs()
        direct=(arithmetic-haar).abs()
        require(direct.lo<=first.hi+second.hi,
                'triangle relation contradicts interval bounds')
        records[str(B)]=dict(
            horizon_prime_argument=B,
            log_time_window='[log(2),log('+str(B)+')]',
            arithmetic_prime_sign=interval_data(arithmetic),
            truncated_T4_time_sign=interval_data(spectrum),
            T4_Haar_sign=interval_data(haar),
            finite_arithmetic_vs_T4_time_absolute=interval_data(first),
            finite_T4_time_vs_Haar_absolute=interval_data(second),
            finite_arithmetic_vs_T4_Haar_absolute=interval_data(direct),
            triangle_bound_arithmetic_vs_T4_Haar=interval_data(first+second),
            unresolved_T4_time_mass=interval_data(unresolved),
            interval_cover=meta,
            raw_tail_comparison_to_full_67_phase_law=None,
            uniform_mixing_rate_or_global_LI_proved=False
        )
    return dict(
       id="CU-BRUIT-Q5-T4-FOUR-FINITE-HORIZONS-20261014",
       status="FOUR_DIRECT_FINITE_HORIZON_SIGN_ENCLOSURES",
       cut_off_height=4,
       root_count=2,
       horizons=list(EXPONENTS),
       source_files=[SOURCE_HAAR,SOURCE_SIGN],
       profiles=records,
       same_log_time_definition_for_first_two_terms=True,
       target_is_T4_Haar_not_full_phase_delta=True,
       independent_second_T4_Haar_verifier_required_for_this_result=False,
       trust_original_Arb_and_elementary_interval_backend=True,
       interval_count_not_asymptotic_rate=True,
       full_arithmetic_limiting_density_proved=False,
       full_67_frequency_torus_mixing_proved=False,
       GRH_LI_ELI_proved=False,
       independent_external_review_completed=False
    )


def main():
    p=argparse.ArgumentParser(description=__doc__)
    m=p.add_mutually_exclusive_group()
    m.add_argument('--write',action='store_true')
    m.add_argument('--check',action='store_true')
    args=p.parse_args()
    record=build()
    rendered=json.dumps(record,indent=2,sort_keys=True)+'\n'
    if args.write:
        (HERE/OUTPUT).write_text(rendered,encoding='utf-8',newline='')
    if args.check:
        require((HERE/OUTPUT).read_bytes()==rendered.encode(),
                'multi-horizon T4 receipt differs from signed recomputation')
    compact={h:{k:r[k]['decimal_outer'] for k in
       ('arithmetic_prime_sign','truncated_T4_time_sign',
        'finite_T4_time_vs_Haar_absolute','unresolved_T4_time_mass')}
       for h,r in record['profiles'].items()}
    print(json.dumps(dict(status=record['status'],horizons=compact,
          uniform_rate_proved=False,full_67_phase_density_proved=False),
          indent=2,sort_keys=True))


if __name__=='__main__':
    try:main()
    except (ValueError,KeyError,TypeError,OSError,ZeroDivisionError,AssertionError) as e:
        raise SystemExit('FAIL CLOSED: '+str(e))
