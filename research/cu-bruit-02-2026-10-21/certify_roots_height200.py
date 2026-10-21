"""Extend pinned Arb isolation/winding method to height 200, seven primitive L's.

Grid/Newton is search only. Each root is separately certified by strict Hardy
signs and a derivative enclosure, then all roots are compared with the entire
completed-L argument-principle count. No global GRH/LI claim.
"""
import argparse
import hashlib
import json
import sys
import time
from pathlib import Path
from fractions import Fraction as Q
import flint
from flint import arb, acb, acb_series, ctx

ROWS = [(3,2,1,0),(5,2,0,1),(5,4,0,2),(5,3,0,3),
        (15,2,1,1),(15,14,1,2),(15,8,1,3)]
EXPECTED_SOURCES = {
 'certify_q15_root_intervals.py':'339cd95772f171ad22aa53f5ad9f1ddc2365a63d3d33b971dd47f619d0809aed',
 'certify_q3_q5_root_intervals.py':'10d872fd7ac76ef1001c0b9406928816ad7bb53ff876f6f55dcc9ec269c1cdb4'}


def compute(data, height=200, precision=256, checkpoint=None):
    assert height == 200 and precision >= 192
    assert flint.__version__=='0.9.0' and flint.__FLINT_VERSION__=='3.6.0'
    ctx.prec = precision
    sys.path.insert(0, str(data.resolve()))
    import certify_q15_root_intervals as q15
    import certify_q3_q5_root_intervals as small
    from audit_density import A, ball, bounds
    hashes = {name:hashlib.sha256((data/name).read_bytes()).hexdigest() for name in
              ['certify_q15_root_intervals.py','certify_q3_q5_root_intervals.py']}
    assert hashes == EXPECTED_SOURCES, 'pinned source bytes changed'
    # These are original imported source files; exact hashes are stored in receipt.
    radius = Q(1,10**28)
    contour = [(Q(-1,8),Q(0)),(Q(9,8),Q(0)),(Q(9,8),Q(height)),
               (Q(-1,8),Q(height)),(Q(-1,8),Q(0))]
    output = dict(status='INTERNAL_FINITE_ROOT_CERTIFICATE_HEIGHT_200',
        height=height, precision_bits=precision, input_source_sha256=hashes,
        interval_radius_exact=str(radius), contour_vertices=[[str(x),str(y)] for x,y in contour],
        by_character=[], root_intervals=[], global_GRH_proved=False, LI_proved=False,
        independent_review=False, trust='pinned Arb isolation and winding argument, extended height')

    def isolate(chi, seed, left_bracket, right_bracket):
        first = small.refine_search_seed(chi,q15.decimal_rational(seed))
        center = Q(small.refine_search_seed(chi,first))
        left, right = center-radius, center+radius
        assert 0<left<right<height and left_bracket < center < right_bracket
        zl,zr=chi.hardy_z(A(left)),chi.hardy_z(A(right))
        assert zl.imag.is_zero() and zr.imag.is_zero()
        assert q15.sign(zl.real)*q15.sign(zr.real)==-1
        rectangle=acb(ball(Q(1,2)-radius,Q(1,2)+radius),ball(left,right))
        old=ctx.cap
        try:
            ctx.cap=2
            derivative=acb_series([rectangle,1],prec=2).dirichlet_l(chi)[1]
        finally:ctx.cap=old
        assert q15.sign(derivative.real) or q15.sign(derivative.imag)
        return dict(character=f'{chi.modulus()}.{chi.number()}',
            imaginary_lower_exact=str(left),imaginary_upper_exact=str(right),
            left_hardy_sign=q15.sign(zl.real),right_hardy_sign=q15.sign(zr.real),
            left_hardy_enclosure=bounds(zl.real),right_hardy_enclosure=bounds(zr.real),
            derivative_real_enclosure=bounds(derivative.real),
            derivative_imag_enclosure=bounds(derivative.imag),
            simple_zero_on_critical_line=True)

    started=time.monotonic()
    for q,num,a,b in ROWS:
        lab=f'{q}.{num}'
        chi=q15.primitive_character(num,b) if q==15 else small.small_character(q,num,a,b)
        fun=q15.CompletedL(chi) if q==15 else small.SmallCompletedL(chi)
        count=q15.count_contour(fun,corners=contour,max_depth=14)
        target=count['zero_count_with_multiplicity']
        found=[]; used_den=None
        for den in [8,32,128]:
            found=[]
            prev_t=Q(0);prev=chi.hardy_z(A(prev_t))
            assert prev.imag.is_zero() and q15.sign(prev.real)
            for j in range(1,height*den+1):
                t=Q(j,den);current=chi.hardy_z(A(t))
                assert current.imag.is_zero() and q15.sign(current.real), 'unresolved search sample'
                if q15.sign(prev.real)!=q15.sign(current.real):
                    row=isolate(chi,(prev_t+t)/2,prev_t,t)
                    if found:assert Q(found[-1]['imaginary_upper_exact'])<Q(row['imaginary_lower_exact'])
                    found.append(row)
                prev_t,prev=t,current
            used_den=den
            if len(found)==target:break
            assert len(found)<target, 'isolations exceed winding count'
        assert len(found)==target, f'{lab}: search incomplete against certified count'
        for index,row in enumerate(found,1):row['index_1based']=index
        output['root_intervals'].extend(found)
        output['by_character'].append(dict(character=lab,search_step_exact=str(Q(1,used_den)),
            isolated_simple_roots=len(found),**count))
        output['elapsed_seconds']=round(time.monotonic()-started,2)
        if checkpoint:checkpoint.write_text(json.dumps(output,indent=2)+'\n')
        print(json.dumps(dict(character=lab,certified_roots=len(found),
            search_denominator=used_den,seconds=output['elapsed_seconds'])),flush=True)
    ordered=sorted(output['root_intervals'],key=lambda r:Q(r['imaginary_lower_exact']))
    assert all(Q(r['imaginary_upper_exact'])<Q(s['imaginary_lower_exact']) for r,s in zip(ordered,ordered[1:])), 'cross-character separation unresolved'
    output['all_positive_intervals_globally_disjoint']=True
    output['minimum_intercharacter_or_intracharacter_gap_exact']=str(min(
        Q(s['imaginary_lower_exact'])-Q(r['imaginary_upper_exact']) for r,s in zip(ordered,ordered[1:])))
    output['positive_root_count']=len(ordered)
    output['finite_completeness_and_simplicity']=True
    return output


if __name__=='__main__':
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument('--data',type=Path,required=True)
    p.add_argument('--precision',type=int,default=256)
    p.add_argument('--out',type=Path,required=True)
    args=p.parse_args()
    r=compute(args.data,precision=args.precision,checkpoint=args.out.with_suffix('.checkpoint.json'))
    r['script_sha256']=hashlib.sha256(Path(__file__).read_bytes()).hexdigest()
    args.out.write_text(json.dumps(r,indent=2)+'\n')
    print(json.dumps(dict(status=r['status'],total=r['positive_root_count'],
        globally_disjoint=True,seconds=r['elapsed_seconds'])),flush=True)
