#!/usr/bin/env python3
"""NTK-OBS-01 / SAMPLING-02. Exact-rational sampling design certificates.

Python >= 3.9, standard library only. No stochastic model, no float in proofs.
All comparisons and binary searches use integers or Fraction. This is not an
independent mathematical review or an assertion of novelty.
"""
import json
from fractions import Fraction as F
from itertools import product
from math import isqrt
from pathlib import Path

HERE = Path(__file__).resolve().parent
OUT = HERE / 'sampling_results.json'
UNIT = 10**12
TARGET_Q = F(1, 100)
TARGET_W = F(1, 10)
ZETA = F(1, 100)
CASES = {
    'NEAR_0.91_0.89': (F(91,100), F(89,100), F(1), F(1)),
    'ORIGINAL_NTK': (F(9,16), F(1,4), F(1), F(4)),
}
STRIDES = range(1,25)


def fr(x):
    return str(x)


def decimal_floor(x, digits=12):
    assert x >= 0
    z = 10**digits
    n = x.numerator*z // x.denominator
    return f'{n//z}.{n%z:0{digits}d}'


def decimal_ceil(x, digits=12):
    assert x >= 0
    z = 10**digits
    n = (x.numerator*z + x.denominator - 1)//x.denominator
    return f'{n//z}.{n%z:0{digits}d}'


def measured_moments(case, h):
    q1,q2,w1,w2 = case
    r1,r2 = q1**h, q2**h
    return [w1*r1**j+w2*r2**j for j in range(4)]


def det_matrix(a):
    A = [list(row) for row in a]
    n = len(A)
    sign, out = 1, F(1)
    for c in range(n):
        pivot = next((r for r in range(c,n) if A[r][c]),None)
        if pivot is None:
            return F(0)
        if pivot != c:
            A[c],A[pivot] = A[pivot],A[c]
            sign = -sign
        p = A[c][c]
        out *= p
        for r in range(c+1,n):
            v = A[r][c]/p
            for j in range(c+1,n):
                A[r][j] -= v*A[c][j]
            A[r][c] = F(0)
    return out*sign


def jacobian_abs(case,h):
    q1,q2,w1,w2 = case
    mat=[]
    for j in range(4):
        k = j*h
        mat.append([q1**k,q2**k,
                    k*w1*q1**(k-1) if k else F(0),
                    k*w2*q2**(k-1) if k else F(0)])
    actual=abs(det_matrix(mat))
    predicted = w1*w2*h*h*q1**(h-1)*q2**(h-1)*(q1**h-q2**h)**4
    assert actual == predicted and actual>0
    return predicted


def rank_epsilon_threshold(case,h):
    """Strict epsilon < returned rational guarantees 3-sample rank witness
    for every admissible noise vector by an OBSERVABLE lower bound.
    """
    m0,m1,m2,_=measured_moments(case,h)
    D=m0*m2-m1*m1
    C=m0+m2+2*m1
    assert D == case[2]*case[3]*(case[0]**h-case[1]**h)**2 > 0
    t=D/(2*C)
    assert 2*t < min(m0,m2)  # required to multiply positive lower bounds
    return t


def rank_witness(observed,h,eps):
    """Only y0,y_h,y2h used. True moments lie in [y-eps,y+eps]."""
    y0,y1,y2=observed[:3]
    if min(y0-eps,y2-eps) <= 0:
        return False
    return (y0-eps)*(y2-eps) - (y1+eps)**2 > 0


def full_certificate(case,h,eps):
    """Conservative all-errors Prony bound transferred from r=q**h back to q.

    Conditions of prior ROBUSTNESS-01 applied to four decimated moments,
    then the elementary x**h difference factorization gives a rational q-bound.
    Returns (boolean, rational-detail-or-failure reason).
    """
    q1,q2,w1,w2=case
    r1,r2=q1**h,q2**h
    d=r1-r2;W=w1+w2
    m0,m1,m2,m3=measured_moments(case,h)
    D=m0*m2-m1*m1
    h0=D/(m0+m2)
    if not 2*eps<h0:
        return False,'Hankel_gap'
    s1,s2=r1+r2,r1*r2
    C=s1+s2
    rho=(2+2*C)*eps/(h0-2*eps)
    gamma=(2*s1+4)*rho+rho*rho
    if not gamma<d*d:
        return False,'root_discriminant'
    R=(rho+gamma/d)/2
    if not R < min(r2,1-r1,d/2):
        return False,'root_range'
    B=(2*eps+W*R)/(d-2*R)
    if not B<min(w1,w2):
        return False,'weight_sign'
    a=q2
    assert 0<ZETA<a
    if not R<a**h-(a-ZETA)**h:
        return False,'q_lower_gap'
    Q=R/(h*(a-ZETA)**(h-1))
    if not Q<TARGET_Q:
        return False,'node_precision_target'
    if not B<TARGET_W:
        return False,'weight_precision_target'
    return True,{'D':D,'h0':h0,'rho':rho,'gamma':gamma,
                 'gap_r':d,'root_error_R':R,'node_error_Q':Q,
                 'weight_error_B':B,'jacobian_abs':jacobian_abs(case,h)}


def max_grid_epsilon(case,h):
    """Largest grid multiple of 10^-12 PASSing a monotone sufficient test."""
    lo,hi=0,UNIT
    assert full_certificate(case,h,F(0))[0]
    assert not full_certificate(case,h,F(hi,UNIT))[0]
    while lo+1<hi:
        mid=(lo+hi)//2
        if full_certificate(case,h,F(mid,UNIT))[0]:
            lo=mid
        else:
            hi=mid
    assert full_certificate(case,h,F(lo,UNIT))[0]
    assert not full_certificate(case,h,F(lo+1,UNIT))[0]
    return lo


def sqrt_interval(z,digits=18):
    assert z>=0
    scale=10**digits
    i=isqrt((z.numerator*scale*scale)//z.denominator)
    a=F(i,scale)
    b=a if a*a==z else F(i+1,scale)
    assert a*a<=z<=b*b
    return a,b


def nth_root_interval(z,h,digits=18):
    assert F(0)<=z<=F(1) and h>=1
    scale=10**digits
    if z==1:return F(1),F(1)
    if z==0:return F(0),F(0)
    b= z.numerator * scale**h
    den=z.denominator
    lo,hi=0,scale
    while lo+1<hi:
        mid=(lo+hi)//2
        if mid**h*den<=b:lo=mid
        else:hi=mid
    a=F(lo,scale)
    c=a if lo**h*den==b else F(lo+1,scale)
    assert a**h<=z<=c**h
    return a,c


class Interval:
    def __init__(self,lo,hi=None):
        self.lo=F(lo)
        self.hi=F(lo if hi is None else hi)
        assert self.lo<=self.hi
    def __add__(self,x):
        x=x if isinstance(x,Interval) else Interval(x)
        return Interval(self.lo+x.lo,self.hi+x.hi)
    __radd__=__add__
    def __neg__(self):return Interval(-self.hi,-self.lo)
    def __sub__(self,x):return self+-(x if isinstance(x,Interval) else Interval(x))
    def __rsub__(self,x):return (x if isinstance(x,Interval) else Interval(x))-self
    def __mul__(self,x):
        x=x if isinstance(x,Interval) else Interval(x)
        c=[a*b for a in (self.lo,self.hi) for b in (x.lo,x.hi)]
        return Interval(min(c),max(c))
    __rmul__=__mul__
    def __truediv__(self,x):
        x=x if isinstance(x,Interval) else Interval(x)
        assert x.hi<0 or x.lo>0
        return self*Interval(1/x.hi,1/x.lo)


def worst_abs_error(box,true):
    return max(abs(box.lo-true),abs(box.hi-true))


def prony_interval_recovery(observed,h,digits=18):
    z0,z1,z2,z3=observed
    D=z0*z2-z1*z1
    assert D>0
    s1=(z0*z3-z1*z2)/D
    s2=(z1*z3-z2*z2)/D
    disc=s1*s1-4*s2
    assert disc>0
    low,high=sqrt_interval(disc,digits)
    rh=Interval((s1+low)/2,(s1+high)/2)
    rl=Interval((s1-high)/2,(s1-low)/2)
    assert 0<rl.lo<=rl.hi<rh.lo<=rh.hi<1
    qw1=Interval(*nth_root_interval(rh.lo,h,digits))
    qw1.hi=nth_root_interval(rh.hi,h,digits)[1]
    qw2=Interval(*nth_root_interval(rl.lo,h,digits))
    qw2.hi=nth_root_interval(rl.hi,h,digits)[1]
    gap=rh-rl
    w1=(Interval(z1)-rl*Interval(z0))/gap
    w2=(rh*Interval(z0)-Interval(z1))/gap
    assert 0<w1.lo<=w1.hi and 0<w2.lo<=w2.hi
    return qw1,qw2,w1,w2


def grid_stress(case,h,eps):
    """81 checked points are diagnostics; the certificate is all-errors."""
    assert full_certificate(case,h,eps)[0]
    ms=measured_moments(case,h)
    q1,q2,w1,w2=case
    worst_q,worst_w=F(0),F(0)
    for signs in product((-1,0,1),repeat=4):
        y=[m+F(s)*eps for m,s in zip(ms,signs)]
        b1,b2,u1,u2=prony_interval_recovery(y,h)
        worst_q=max(worst_q,worst_abs_error(b1,q1),worst_abs_error(b2,q2))
        worst_w=max(worst_w,worst_abs_error(u1,w1),worst_abs_error(u2,w2))
    _,full=full_certificate(case,h,eps)
    assert worst_q<=full['node_error_Q'] and worst_w<=full['weight_error_B']
    return {'cases':81,'outward_root_digits':18,
            'q_error_upper_12dp':decimal_ceil(worst_q),
            'weight_error_upper_12dp':decimal_ceil(worst_w)}


def test_global_obstruction():
    """Analytic global obstruction recorded in report; finite k only a check."""
    out=[]
    for d in [F(1,16),F(1,100),F(1,1000),F(1,10000)]:
        a=F(1,2)
        A=(a+d,a-d);B=(a+2*d,a-2*d)
        max_diff=F(0)
        for k in range(0,101):
            ma=(A[0]**k+A[1]**k)/2
            mb=(B[0]**k+B[1]**k)/2
            delta=abs(mb-ma)
            assert delta<=F(15,2)*d*d
            max_diff=max(max_diff,delta)
        out.append({'d':fr(d),'different_modes_distance':fr(d),
                    'universal_infinite_horizon_midpoint_noise_sufficient':fr(F(15,4)*d*d),
                    'unavoidable_max_matching_error_at_least':fr(d/2),
                    'largest_exact_difference_k0_to_100':fr(max_diff)})
    # Exact maximum f_k'' <= 5 on [3/8,5/8] for all k>=0:
    # f_k''(x) <= k(k-1)*(5/8)^(k-2). k=5 is the maximizing integer.
    vals=[F(k*(k-1)) * F(5,8)**(k-2) for k in range(2,20)]
    assert max(vals)==F(20)*F(5,8)**3 == F(625,128) < 5
    assert F(5*6,8*4)<1  # f_6'' / f_5'' = 15/16
    # For all k>=5 the f_(k+1)/f_k ratio decreases, stays <1.
    return out


def main():
    output={'id':'NTK-OBS-01-SAMPLING-02-2026-10-11',
            'status':'internal exact-rational demonstration; independent audit OPEN; no originality claimed',
            'noise_model':'adversarial absolute error |y_k-m_k| <= eps for each selected k',
            'threshold_targets':{'max_q_abs_error_strict':fr(TARGET_Q),
                                 'max_weight_abs_error_strict':fr(TARGET_W),
                                 'a_priori_branch_gap_zeta':fr(ZETA),
                                 'epsilon_grid_step':'1/1000000000000'},
            'global_obstruction':test_global_obstruction(),
            'cases':{}}
    for label,case in CASES.items():
        assert F(0)<case[1]<case[0]<F(1)
        assert case[2]>0 and case[3]>0
        rows=[]
        for h in STRIDES:
            jac=jacobian_abs(case,h)
            erank=rank_epsilon_threshold(case,h)
            n=max_grid_epsilon(case,h)
            e=F(n,UNIT)
            flag,c=full_certificate(case,h,e)
            assert flag and c['jacobian_abs']==jac
            # Guarantee of three-point OBSERVED support certificate on all
            # errors at eps = threshold / 2 (finite 27-corner diagnostic).
            eps_rank=erank/2
            ms=measured_moments(case,h)
            assert rank_witness(ms,h,eps_rank)
            for signs in product((-1,0,1),repeat=3):
                obs=[m+eps_rank*s for m,s in zip(ms[:3],signs)]
                assert rank_witness(obs,h,eps_rank)
            # Sharp boundary of this particular universal interval-witness test.
            eps_edge=erank
            obs_edge=[ms[0]-eps_edge,ms[1]+eps_edge,ms[2]-eps_edge]
            assert not rank_witness(obs_edge,h,eps_edge)
            rows.append({'stride':h,'time_horizon':3*h,'three_sample_rank_epsilon_supremum':fr(erank),
                         'three_sample_rank_eps_floor_12dp':decimal_floor(erank),
                         'full_prony_eps_units_1e-12':n,
                         'full_prony_eps_floor_12dp':decimal_floor(e),
                         'Hankel_D_h':fr(c['D']),
                         'Jacobian_abs_det':fr(jac)})
        best_rank=max(rows,key=lambda z:F(z['three_sample_rank_epsilon_supremum']))
        best_full=max(rows,key=lambda z:z['full_prony_eps_units_1e-12'])
        # Selected fixed schedules and exact proof+interval diagnostics.
        examples={}
        for h in set([1,best_full['stride']]):
            n=next(x['full_prony_eps_units_1e-12'] for x in rows if x['stride']==h)
            if n==0:continue
            eps=F(n,UNIT)
            ok,bounds=full_certificate(case,h,eps)
            assert ok
            examples[str(h)]={'epsilon':fr(eps),
                'q_error_rational_bound':fr(bounds['node_error_Q']),
                'w_error_rational_bound':fr(bounds['weight_error_B']),
                'checked_sign_patterns':grid_stress(case,h,eps)}
        output['cases'][label]={
            'nodes_q':[fr(case[0]),fr(case[1])],
            'weights':[fr(case[2]),fr(case[3])],
            'best_rank_stride_in_preselected_1_to_24':best_rank['stride'],
            'best_full_stride_in_preselected_1_to_24':best_full['stride'],
            'examples':examples,
            'grid':rows,
        }
    assert output['cases']['NEAR_0.91_0.89']['best_full_stride_in_preselected_1_to_24']==12
    assert output['cases']['ORIGINAL_NTK']['best_full_stride_in_preselected_1_to_24']==1
    assert output['cases']['NEAR_0.91_0.89']['best_rank_stride_in_preselected_1_to_24']==12
    assert output['cases']['ORIGINAL_NTK']['best_rank_stride_in_preselected_1_to_24']==1
    OUT.write_text(json.dumps(output,sort_keys=True,indent=2)+'\n',encoding='utf-8')
    print('PASS: 2 models x 24 strides, exact Jacobian formula, 3-point observed rank witness,')
    print('      all-errors sufficient 4-point Prony certificate, 81-point interval checks,')
    print('      rational decimation, global counterexample (finite diagnostic only).')
    for label,entry in output['cases'].items():
        h=entry['best_full_stride_in_preselected_1_to_24']
        r=entry['grid'][h-1]
        print(label,'best_stride',h,'max grid eps',r['full_prony_eps_floor_12dp'],
              'rank_eps',r['three_sample_rank_eps_floor_12dp'])


if __name__=='__main__':
    main()
