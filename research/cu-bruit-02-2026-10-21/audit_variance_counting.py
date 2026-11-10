"""Explicit variance bound without a global simplicity/multiplicity assumption.

Uses finite Arb root completeness/disjointness to height 200 and Bennett--Martin--
O'Bryant--Rechnitzer (Math. Comp. 2021), Theorem 1.1, beyond that height.
GRH7 and the low-block independence/separation hypotheses remain conditional.
"""
import argparse
import hashlib
import json
import time
from fractions import Fraction as Q
from pathlib import Path
import flint
from flint import arb, ctx
import audit_density as prior
from audit_density import A, ball, bounds

META = {'3.2':(3,1,1),'5.2':(5,1,1),'5.4':(5,0,9),'5.3':(5,1,1),
        '15.2':(15,0,1),'15.14':(15,1,1),'15.8':(15,0,1)}
CONJ = {'3.2':'3.2','5.4':'5.4','15.14':'15.14',
        '5.2':'5.3','5.3':'5.2','15.2':'15.8','15.8':'15.2'}


def compute(data, constants, root_certificate, precision=128):
    assert precision >=96
    assert flint.__version__=='0.9.0' and flint.__FLINT_VERSION__=='3.6.0'
    ctx.prec=precision
    prior.BASE=data
    low,_,w_hi,_,hashes=prior.inputs(constants)
    raw=root_certificate.read_bytes(); high=json.loads(raw)
    assert high['status']=='INTERNAL_FINITE_ROOT_CERTIFICATE_HEIGHT_200'
    assert high['height']==200 and high['precision_bits']>=192
    assert high['finite_completeness_and_simplicity']
    assert high['all_positive_intervals_globally_disjoint']
    hashes['height200_root_certificate']=hashlib.sha256(raw).hexdigest()
    counts={r['character']:r['zero_count_with_multiplicity'] for r in high['by_character']}
    assert set(counts)==set(META)
    roots=high['root_intervals']
    assert len(roots)==sum(counts.values())==high['positive_root_count']
    ordered=sorted(roots,key=lambda r:Q(r['imaginary_lower_exact']))
    assert all(Q(x['imaginary_upper_exact'])<Q(y['imaginary_lower_exact'])
        for x,y in zip(ordered,ordered[1:]))
    for lab in counts:
        assert len([r for r in roots if r['character']==lab])==counts[lab]
    lower_roots=[r for r in roots if Q(r['imaginary_upper_exact'])<25]
    band=[r for r in roots if Q(r['imaginary_lower_exact'])>25]
    assert len(lower_roots)==67 and len(lower_roots)+len(band)==len(roots)
    for lo,hi,lab in low:
        matches=[r for r in lower_roots if r['character']==lab and
                 Q(r['imaginary_lower_exact'])<lo<hi<Q(r['imaginary_upper_exact'])]
        assert len(matches)==1, 'old and new low root identification unresolved'
    band_var=arb(0)
    for row in band:
        lo,hi=Q(row['imaginary_lower_exact']),Q(row['imaginary_upper_exact'])
        assert 25<lo<hi<200 and row['simple_zero_on_critical_line']
        gamma=ball(lo,hi);v=META[row['character']][2]
        band_var+=2*v/(A(Q(1,4))+gamma*gamma)
    # Each interval is globally disjoint, so the finite band has no shared frequencies.
    assert band_var>0 and band_var.upper()<A(w_hi)

    H=Q(200); coefficient=Q(22737,100000)
    errors={};slopes={};logs={}
    for lab,(q,parity,v) in META.items():
        ell=(A(q*(H+2))/(2*arb.pi())).log()
        assert ell>A(Q(1567,1000))
        errors[lab]=A(coefficient)*ell+2*(1+ell).log()-A(Q(1,2))
        slopes[lab]=A(coefficient)+2/(1+ell)
        logs[lab]=(A(q*H)/(2*arb.pi())).log()
    B0=sum(errors.values(),arb(0));D0=sum(slopes.values(),arb(0))
    # For t>=H, B(t)>=B0 and t B'(t)<=D0, hence B(t)/t^2 decreases.
    assert 2*B0>D0 and B0>0
    contributions={};tail=arb(0)
    for lab,(q,parity,v) in META.items():
        # The BMOR N counts ALL signed ordinates. Conjugation reverses signs.
        n_signed=counts[lab]+counts[CONJ[lab]]
        chi_minus_one=1 if parity==0 else -1
        main=A(H)/arb.pi()*(logs[lab]-1)-A(Q(chi_minus_one,4))
        upper_count=main+errors[lab]
        slack=upper_count-n_signed
        assert slack>0
        boundary=B0/A(H*H)*slack
        # Concavity: E_q(t)<=E_q(H)+d_q log(t/H).
        # Integrate the resulting exponential moments exactly after t=H exp(u).
        integrated=(B0*logs[lab]+B0+D0*logs[lab]+2*D0)/(arb.pi()*A(H))
        integrated+=slopes[lab]/A(H*H)*(B0/2+D0/4)
        contribution=boundary+integrated
        contributions[lab]=dict(conductor=q,parity=parity,weight=v,
            signed_zero_count_to_H=n_signed,error_at_H=bounds(errors[lab]),
            error_log_slope_at_H=bounds(slopes[lab]),count_slack_upper=bounds(slack),
            boundary_term=bounds(boundary),integrated_term=bounds(integrated),
            signed_weighted_sum_upper=bounds(contribution))
        tail+=v*contribution
    variance=band_var+tail
    probability=A(Q(67,200))+A(Q(11,500))*variance
    assert variance.upper()<A(Q(15,2))
    assert variance.upper()<A(Q(754,125))  # 6.032
    assert tail.upper()<A(Q(5391,1000))
    assert probability.upper()<A(Q(117,250))  # 0.468
    return dict(status='INTERNAL_CONDITIONAL_VARIANCE_WITHOUT_GLOBAL_MULTIPLICITY',
        precision_bits=precision,height=200,input_sha256=hashes,
        finite_positive_roots=len(roots),finite_band_positive_roots=len(band),
        positive_counts=counts,finite_band_variance=bounds(band_var),
        counting_theorem='Bennett--Martin--O\u0027Bryant--Rechnitzer 2021, Theorem 1.1',
        B_at_H=bounds(B0),B_log_slope_upper=bounds(D0),
        signed_character_contributions=contributions,
        high_tail_variance_upper=bounds(tail),total_remainder_variance_upper=bounds(variance),
        sign_probability_upper=bounds(probability),
        global_simplicity_assumed=False,uniform_multiplicity_assumed=False,
        global_noncoincidence_assumed=False,global_parity_assumed=False,
        internal_tail_LI_assumed=False,
        sufficient_hypotheses=['GRH for seven primitive L functions',
            'central nonvanishing supported by internal K certificate',
            'joint rational independence of the original 67 low positive ordinates',
            'rational spans of those 67 ordinates and the remaining active spectrum intersect trivially'],
        trust='pinned finite Arb certificates, quadratic majorant, BMOR counting theorem',
        original_low_independence_proved=False,GRH_proved=False,
        independent_review=False,originality_claimed=False)


if __name__=='__main__':
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument('--data',type=Path,required=True)
    p.add_argument('--constants',type=Path,required=True)
    p.add_argument('--roots',type=Path,required=True)
    p.add_argument('--precision',type=int,default=128)
    p.add_argument('--out',type=Path,required=True)
    a=p.parse_args();start=time.monotonic()
    r=compute(a.data,a.constants,a.roots,a.precision)
    r['seconds']=round(time.monotonic()-start,2)
    r['script_sha256']=hashlib.sha256(Path(__file__).read_bytes()).hexdigest()
    a.out.write_text(json.dumps(r,indent=2)+'\n')
    print(json.dumps({k:r[k] for k in ['status','finite_positive_roots',
        'finite_band_variance','high_tail_variance_upper','total_remainder_variance_upper',
        'sign_probability_upper','seconds']},indent=2))
