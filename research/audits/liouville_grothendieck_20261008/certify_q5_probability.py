#!/usr/bin/env python3
"""CU-BRUIT Q5: rational Fourier/Simpson enclosure of the conditional phase law.

Never asserts GRH, LI, an arithmetic density, or independent root review.
Reads and pins the same 67-root/K receipts as verify_all_tail_bounds.py.
"""
import argparse
import json
from fractions import Fraction as F
from math import factorial

S = 10**30                    # exact fixed-point denominator
N = 600                      # even, Simpson subintervals on [0,12]
T = F(12)
WMIN = F(7,10)
JTERMS, STERMS, ETERMS = 41, 45, 38


def need(ok, reason):
    if not ok:
        raise ValueError(reason)


def ceildiv(a, b):
    return -((-a)//b)


def bounds_of_alternating(x, divisor, n):
    """Fixed-point interval for sum (-1)^k x^k / product(divisor(i)).

    The omitted alternating tail is less than 1/S; run() checks the
    global rational remainder inequalities before using this routine.
    """
    lo=hi=S
    a=b=S
    for k in range(1,n+1):
        den = x.denominator * divisor(k)
        a = a*x.numerator//den
        b = ceildiv(b*x.numerator,den)
        if k%2:
            lo -= b; hi -= a
        else:
            lo += a; hi += b
    return lo-1,hi+1


def multiply(A,B):
    p=[A[0]*B[0],A[0]*B[1],A[1]*B[0],A[1]*B[1]]
    return min(p)//S,ceildiv(max(p),S)


def j0_bounded(t, v, center):
    u=F(v)*t*t/(F(1,4)+center*center)
    need(0<=u<=32,'Bessel expansion range exceeded')
    a,b=bounds_of_alternating(u, lambda k:k*k,JTERMS)
    # |d/du J0(2 sqrt(u))| <= 1. For gamma>=2, t<=12, v<=9,
    # |du/dgamma| <= 2*v*t^2/gamma^3 <= 324.
    # Certified |gamma-center| <= 1e-30; add 325/S outward.
    return max(-S,a-325),min(S,b+325)


def sinc_bounded(t):
    a,b=bounds_of_alternating(t*t,lambda k:(2*k)*(2*k+1),STERMS)
    return max(-S,a),min(S,b)


def exp_bounded(y):
    need(0<=y<=62,'exponential argument outside proof')
    # exp(-y) = exp(-y/128)^128; round y down to a fixed-point.
    y0=F(y.numerator*S//y.denominator,S)
    a,b=bounds_of_alternating(y0/128,lambda k:k,ETERMS)
    a=max(0,a); b=min(S,b)
    need(0<a<=b<=S,'invalid exponential Taylor enclosure')
    for _ in range(7):
        a=a*a//S
        b=ceildiv(b*b,S)
    # |exp(-y)-exp(-y0)| <= |y-y0| < 1/S.
    return max(0,a-1),min(S,b+1)


def mul_rational(A,z):
    x=F(A[0])*z; y=F(A[1])*z
    a,b=min(x,y),max(x,y)
    return a.numerator//a.denominator,ceildiv(b.numerator,b.denominator)


def atan_enclosure(q,n):
    t=F(1,q); s=F(0)
    for k in range(n):
        s+=(-1)**k*t**(2*k+1)/(2*k+1)
    e=t**(2*n+1)/(2*n+1)
    return (s,s+e) if n%2==0 else (s-e,s)


def pi_enclosure():
    al,ah=atan_enclosure(5,32)
    bl,bh=atan_enclosure(239,12)
    pl,ph=16*al-4*bh,16*ah-4*bl
    need(F(3141592653589793238462643383279,10**30)<pl<ph<
         F(3141592653589793238462643383280,10**30), 'Machin pi proof failed')
    return pl,ph


def over_pi(a,b,pl,ph):
    q=[a/pl,a/ph,b/pl,b/ph]
    return min(q),max(q)


def outward(x,up=False,digits=6):
    base=10**digits
    q=x.numerator*base//x.denominator
    if up and F(q,base)<x:
        q+=1
    sign='-' if q<0 else ''
    return sign+str(abs(q)//base)+'.'+str(abs(q)%base).zfill(digits)


def compute(ordinates, wlo, whi, eps):
    """ordinates: 67 tuples (label, rank, exact center, Fourier-square v)."""
    need(len(ordinates)==67 and 0<WMIN<=wlo<=whi<1,'invalid full-tail variance')
    need(eps>=0 and eps<=F(1714,10**6),'Gaussian error certificate not in scope')
    need(N%2==0 and N>=2,'Simpson partition invalid')
    need(S*(32**(JTERMS+1))*2<factorial(JTERMS+1)**2,'J0 remainder too large')
    need(S*12**(2*(STERMS+1))<factorial(2*(STERMS+1)+1),'sinc remainder too large')
    need(S<2**(ETERMS+1)*factorial(ETERMS+1),'exp remainder too large')
    need(3**50<2**80,'exponential tail inequality failed')
    need(all(F(2)<center<F(25) and weight in (1,9) for _,_,center,weight in ordinates),
         'invalid spectral root or normalization')
    # Total variance (low cosine phases + independent Gaussian) is <4.
    vlo=sum((2*weight/(F(1,4)+center**2)
             for _,_,center,weight in ordinates),F(0))
    # Root-center discrepancies below 1e-30 perturb variance by <1e-20.
    need(vlo+whi+F(1,10**20)<4,'sixth-moment variance budget failed')
    w0=(wlo+whi)/2
    h=T/N
    sums=[[0,0] for _ in range(3)]  # at Wlo, Wmid, Whi
    sglo=sghi=0
    for i in range(N+1):
        t=h*i
        product=(S,S)
        for _,_,center,v in ordinates:
            product=multiply(product,j0_bounded(t,v,center))
        ss=sinc_bounded(t)
        base=multiply((-ss[1],-ss[0]),product)
        weight=1 if i==0 or i==N else (4 if i%2 else 2)
        for j,W in enumerate((wlo,w0,whi)):
            gauss=exp_bounded(W*t*t/2)
            f=multiply(base,gauss)
            sums[j][0]+=weight*f[0]
            sums[j][1]+=weight*f[1]
            if j==1:
                g=mul_rational(f,-t*t/2)
                sglo+=weight*g[0];sghi+=weight*g[1]
    # f(t)=E[sin(tX)/t]; X=-1+67 independent phases+Gaussian.
    # E X^4 <= 1+6*4+3*4^2=73;
    # E X^6 <= 1+15*4+45*4^2+15*4^3=1741.
    # |f^(k)(t)| <= E|X|^(k+1)/(k+1).
    m2=F(1+73,3)
    m3=F(73,4)
    m4=F(1+1741,5)
    mg4=(T*T*m4+8*T*m3+12*m2)/2
    ef=T*h**4*m4/180
    eg=T*h**4*mg4/180
    # For t>=12, exp(-W t^2/2) <= exp(-50) < 2^-70.
    # This follows from e>8/3 and 3^50<2^80.
    tf=F(1,2**70)/(WMIN*T*T)
    tg=F(1,2**70)/(2*WMIN)
    pl,ph=pi_enclosure()
    probability_ranges=[]
    for sflo,sfhi in sums:
        farea=(F(sflo)*h/(3*S)-ef-tf,F(sfhi)*h/(3*S)+ef+tf)
        pa,pb=over_pi(*farea,pl,ph)
        probability_ranges.append((pa+F(1,2),pb+F(1,2)))
    garea=(F(sglo)*h/(3*S)-eg-tg,F(sghi)*h/(3*S)+eg+tg)
    da,db=over_pi(*garea,pl,ph)
    dw=(whi-wlo)/2
    # |P''(W)| <=1/(2*pi*WMIN^2) <1/(6*WMIN^2).
    # A positive derivative on the whole variance interval follows
    # from the certified derivative at midpoint plus the global bound.
    derivative_drift=dw/(6*WMIN*WMIN)
    need(da>derivative_drift,'monotonicity of Q5 sign probability not certified')
    low=probability_ranges[0][0]-eps
    high=probability_ranges[2][1]+eps
    need(F(0)<low<high<F(1),'Q5 enclosure not a valid probability range')
    return {
      'status':'CONDITIONAL_ON_PINNED_INTERNAL_CERTIFICATES',
      'low_phases':67,'mu':'-1', 'cutoff':'25','simpson_intervals':N,
      'W_bounds':[str(wlo),str(whi)],'W_mid':str(w0),
      'p_gaussian_at_Wlo_outer':[outward(probability_ranges[0][0]),outward(probability_ranges[0][1],True)],
      'p_gaussian_at_Wmid_outer':[outward(probability_ranges[1][0]),outward(probability_ranges[1][1],True)],
      'p_gaussian_at_Whi_outer':[outward(probability_ranges[2][0]),outward(probability_ranges[2][1],True)],
      'dp_dW_at_Wmid_outer':[outward(da),outward(db,True)],
      'derivative_drift_bound':str(derivative_drift),
      'quadrature_integral_errors':[str(ef),str(eg)],
      'integral_tail_errors':[str(tf),str(tg)],
      'gaussian_replacement_error':str(eps),
      'p_conditional_outer':[outward(low),outward(high,True)],
      'p_conditional_exact':[str(low),str(high)],
      'global_GRH_or_LI_proved':False,
      'actual_prime_density_certified':False,
      'independent_human_review_claimed':False,
    }


def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--check',action='store_true',help='replay a conservative audited interval')
    parser.parse_args()
    from verify_all_tail_bounds import (HERE, pinned_inputs,all_roots,SIGNED,MULTIPLICITY,
                                        LABEL_TO_AB,PROFILE_BOOSTS)
    need(PROFILE_BOOSTS['Q5']==('0,2',9) and LABEL_TO_AB['5.4']=='0,2',
         'spectral Q5 normalization changed')
    inputs=pinned_inputs()
    roots=all_roots(inputs['q15_root_interval_certificate_20261012.json'],
                    inputs['q3_q5_root_interval_certificate_20261013.json'])
    cert=json.loads((HERE/'all_tail_bounds_20261013.json').read_text())
    need(cert['positive_roots']==67 and cert['input_sha256'] ==
         {k:v for k,v in __import__('verify_all_tail_bounds').INPUTS.items()},
         'full tail certificate mismatch')
    K=inputs['spectral_constants_certificate_20261012.json']['analytic_constants']
    Wlo=Whi=F(0)
    for key,(labels,factor) in SIGNED.items():
        k=K[key]['K']
        kl,ku=F(int(k['lower_integer']),int(k['denominator'])),F(int(k['upper_integer']),int(k['denominator']))
        slow=sum((factor/(F(1,4)+hi*hi) for label in labels for _,hi in roots[label]),F(0))
        shigh=sum((factor/(F(1,4)+lo*lo) for label in labels for lo,_ in roots[label]),F(0))
        wt=MULTIPLICITY[key]*(9 if key=='0,2' else 1)
        Wlo+=wt*(kl-shigh);Whi+=wt*(ku-slow)
    recorded=cert['profiles']['Q5']['conditional_full_tail_variance']
    need(F(recorded['lower_exact'])<=Wlo<=Whi<=F(recorded['upper_exact']),
         'recomputed Q5 variance escaped receipt')
    epsilon=F(cert['profiles']['Q5']['uniform_threshold_probability_error_upper']['upper_exact'])
    ords=[]
    for source in ('q15_root_interval_certificate_20261012.json',
                   'q3_q5_root_interval_certificate_20261013.json'):
        for row in inputs[source]['root_intervals']:
            label=row['character'];rank=row['index_1based']
            center=F(row['seed']);a=F(row['imaginary_lower_exact']);b=F(row['imaginary_upper_exact'])
            need(0<=center-a<=F(1,10**30) and 0<=b-center<=F(1,10**30),
                 'zero center not within asserted radius')
            need((a,b)==roots[label][rank-1],'zero center has wrong signed label')
            v=9 if label=='5.4' else 1
            ords.append((label,rank,center,v))
    coarse_lo,coarse_hi=F('0.747557'),F('0.842503')
    need(coarse_lo<=F(recorded['lower_exact']) and
         F(recorded['upper_exact'])<=coarse_hi,'displayed variance bounds not outward')
    out=compute(ords,coarse_lo,coarse_hi,epsilon)
    a,b=map(F,out['p_conditional_exact'])
    need(F('0.286450')<=a<b<=F('0.292650'),
         'probability did not fit review interval')
    print(json.dumps({k:v for k,v in out.items() if k!='p_conditional_exact'},
                     indent=2,sort_keys=True))


if __name__=='__main__':
    try:
        main()
    except (ValueError,KeyError,OSError,AssertionError,ZeroDivisionError) as exc:
        raise SystemExit('FAIL CLOSED: '+str(exc))
