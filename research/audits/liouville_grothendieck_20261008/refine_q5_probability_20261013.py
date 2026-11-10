#!/usr/bin/env python3
"""Recompute the conditional Q5 bound using sharpened periodic-Abel K intervals.

No old receipt is overwritten; the new report is independently pinned later.
All reliance on upstream FLINT/Arb, GRH and phase independence remains explicit.
"""
import json
from fractions import Fraction as F
from certify_refined_K_20261013 import make_report
from verify_all_tail_bounds import aggregate, pinned_inputs, all_roots, SIGNED, MULTIPLICITY
from certify_q5_probability import compute, need

def main():
    original=pinned_inputs()
    refined=make_report()
    roots=all_roots(original['q15_root_interval_certificate_20261012.json'],
                    original['q3_q5_root_interval_certificate_20261013.json'])
    old=aggregate(original['q15_root_interval_certificate_20261012.json'],
                  original['q3_q5_root_interval_certificate_20261013.json'],
                  original['spectral_constants_certificate_20261012.json'])
    newer=aggregate(original['q15_root_interval_certificate_20261012.json'],
                    original['q3_q5_root_interval_certificate_20261013.json'],
                    refined)
    prev=old['profiles']['Q5']
    row=newer['profiles']['Q5']
    prior=[F(prev['conditional_full_tail_variance'][key]) for key in
           ('lower_exact','upper_exact')]
    W=[F(row['conditional_full_tail_variance'][key]) for key in
       ('lower_exact','upper_exact')]
    epsilon=F(row['uniform_threshold_probability_error_upper']['upper_exact'])
    oldepsilon=F(prev['uniform_threshold_probability_error_upper']['upper_exact'])
    need(prior[0]<=W[0]<=W[1]<=prior[1],'new W escaped old certified interval')
    need(W[1]-W[0]<(prior[1]-prior[0])/20,'W not tightened by factor 20')
    need(0<epsilon<=oldepsilon,'replacement error not bounded by old certificate')
    ords=[]
    for source in ('q15_root_interval_certificate_20261012.json',
                   'q3_q5_root_interval_certificate_20261013.json'):
        for item in original[source]['root_intervals']:
            ch=item['character']
            a,b=F(item['imaginary_lower_exact']),F(item['imaginary_upper_exact'])
            center=F(item['seed'])
            need(a<=center<=b and max(center-a,b-center)<=F(1,10**30),
                 'root center not in certified interval')
            need((a,b)==roots[ch][item['index_1based']-1],
                 'signed zero label mismatch')
            ords.append((ch,item['index_1based'],center,9 if ch=='5.4' else 1))
    # Guard conservative quadrature domain: W should remain >0.7 and <1.
    result=compute(ords,W[0],W[1],epsilon)
    lo,hi=map(F,result['p_conditional_exact'])
    need(F('0.286450')<lo<=hi<F('0.292650'),
         'refinement did not stay within the older reviewed bound')
    output={
        'id':'CU-BRUIT-02-Q5-REFINED-K-PROBABILITY-20261013',
        'source':'Double-Abel refined K; original 67 low zeros retained',
        'refined_K_parent':'CU-BRUIT-02-C-REFINED-K-20261013',
        'variance_original_outer':old['profiles']['Q5']['conditional_full_tail_variance']['decimal_outer_bounds'],
        'variance_refined_outer':row['conditional_full_tail_variance']['decimal_outer_bounds'],
        'variance_refined_exact':[str(x) for x in W],
        'P2_upper':row['conditional_full_tail_P2_upper']['decimal_upper_bound'],
        'gaussian_replacement_error_upper':row['uniform_threshold_probability_error_upper']['decimal_upper_bound'],
        'probability_outer':result['p_conditional_outer'],
        'p_at_variance_endpoints':{
            'low':result['p_gaussian_at_Wlo_outer'],
            'high':result['p_gaussian_at_Whi_outer']},
        'simpson_integral_errors':result['quadrature_integral_errors'],
        'integral_tail_errors':result['integral_tail_errors'],
        'conditional_on_internal_Arb_zero_certificates':True,
        'GRH_and_independent_phases_required':True,
        'arithmetic_prime_density_proved':False,
        'externally_reviewed':False
    }
    print(json.dumps(output,indent=2,sort_keys=True))

if __name__=='__main__':
    main()
