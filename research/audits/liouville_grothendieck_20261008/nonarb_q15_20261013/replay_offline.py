#!/usr/bin/env python3
"""Exact-rational replay of six non-Arb interval-generated contour certificates.
Does not recompute the analytic enclosures; that must be checked separately.
"""
import glob,hashlib,json,sys
from fractions import Fraction as Q
from pathlib import Path
from combine_verify import verify
from math import factorial,prod
def get_bound(n=20,p=28,m=50):
    em=Q(16*4*prod(range(27,27+2*p))*n*n,6**(2*p)*(2*p-2)*n**(2*p))
    exprel=Q(128*n*2**m,factorial(m+1))
    return em,exprel

ROOT=Path(__file__).resolve().parent
LABEL={1:'15.2',2:'15.14',3:'15.8'}
EXPECT_LARGE={1:13,2:13,3:13}
EXPECT_SMALL={1:1,2:0,3:1}

def replay(directory):
    em,exprel=get_bound()
    assert em+exprel<Q(1,10**14)
    # Extended neighborhood bound for using analytic Cauchy estimates.
    import math
    P=28;N=20
    expanded=Q(16*4*math.prod(range(29,29+2*P))*N*N,6**(2*P)*(2*P-2)*N**(2*P))
    assert expanded+exprel<Q(1,10**14)
    result={}
    parts=[]
    for b in (1,2,3):
        profile={}
        for tag,top,expected in [('large',Q(25),EXPECT_LARGE[b]),('small',Q(1,2),EXPECT_SMALL[b])]:
            paths=sorted(glob.glob(str(directory/f'b{b}_{tag}_*.json')))
            assert paths, f'no parts b{b} {tag}'
            rec=verify(paths,b,top)
            if rec['winding']!=expected:
                raise ValueError(f'count mismatch {LABEL[b]}, {tag}: {rec["winding"]} != {expected}')
            profile[tag]=rec
            parts += [{'filename':Path(p).name,'sha256':hashlib.sha256(Path(p).read_bytes()).hexdigest()} for p in paths]
        profile['positive_up_to_25']=profile['large']['winding']-profile['small']['winding']
        assert profile['positive_up_to_25']=={1:12,2:13,3:12}[b]
        result[LABEL[b]]=profile
    out={
        'id':'CU-BRUIT-Q15-NONARB-EM-20261013',
        'status':'NON_ARB_EXPERIMENTAL_INTERVAL_CONTOUR_CHECK_PASSED',
        'date':'2026-10-13',
        'analytic_method':'Dirichlet L via conductor-15 Hurwitz decomposition, cancellation, 20-term pre-sum, 28 Euler-Maclaurin corrections, 50-term exprel polynomial',
        'backend':'mpmath.iv 1.3.0, experimental interval support; no Arb/FLINT',
        'precision_decimal_digits':40,
        'upper_bound_em_remainder':str(em),
        'upper_bound_exprel_remainder':str(exprel),
        'expanded_neighborhood_error_upper_bound':str(expanded+exprel),
        'contour_large':'[-1/8, 9/8] + i[-1/2,25]',
        'contour_small':'[-1/8, 9/8] + i[-1/2,1/2]',
        'trivial_zero_at_s0':{'15.2':1,'15.14':0,'15.8':1},
        'by_character':result,
        'parts':parts,
        'scope':'finite conductor 15 and positive imaginary ordinates less than 25 only',
        'independent_of_arb':True,
        'independently_audited_elementary_interval_implementation':False,
        'independent_human_mathematical_review_claimed':False,
        'global_GRH_or_LI_proved':False,
        'prime_race_density_certified':False,
        'publication_or_merge_authorized':False
    }
    return out

if __name__=='__main__':
    root=Path(sys.argv[1]) if len(sys.argv)>1 else ROOT/'parts'
    data=replay(root)
    (ROOT/'nonarb_q15_summary_20261013.json').write_text(json.dumps(data,indent=2,ensure_ascii=False)+'\n')
    print(json.dumps({k:{'large':v['large']['winding'],'small':v['small']['winding'],'positive':v['positive_up_to_25'],'charts':v['large']['charts']+v['small']['charts']} for k,v in data['by_character'].items()},indent=2))
    print('PARTS',len(data['parts']), 'CONDITIONAL NON-ARB INTERVAL CHECK PASSED')
