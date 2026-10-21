"""Internal interval computation. GRH and joint LI remain hypotheses."""
import json, hashlib, argparse, time
from pathlib import Path
from fractions import Fraction as Q
import flint
from flint import arb, acb, fmpq, ctx

BASE=Path(__file__).parent/'proof_check/research/audits/liouville_grothendieck_20261008'
EXPECTED={
 'q15_root_interval_certificate_20261012.json':'b694a1e8382b25fb3843f80854721a9c569377344d7818e10fb85f5f9c5ff684',
 'q3_q5_root_interval_certificate_20261013.json':'5284f66aca1ae9c8df2986214c33020d14fd082840c6e4c8ad9829101545340f',
 'all_tail_bounds_20261013.json':'5d3d0c7d462fa84e2701be3585ca7b8f11269287062613e1c4ba1d6157862189'}

def A(q):
    q=Q(q)
    return arb(fmpq(q.numerator,q.denominator))

def ball(lo,hi):
    return arb(A((lo+hi)/2), A((hi-lo)/2))

def exact(q):
    m,e=q.man_exp()
    return str(Q(int(m))*Q(2)**int(e))

def bounds(v):
    assert v.is_finite()
    return {'lower_exact':exact(v.lower()),'upper_exact':exact(v.upper()),'display':str(v)}

def inputs(constants=None):
    names=['q15_root_interval_certificate_20261012.json',
           'q3_q5_root_interval_certificate_20261013.json','all_tail_bounds_20261013.json']
    raw={n:(BASE/n).read_bytes() for n in names}
    assert {n:hashlib.sha256(r).hexdigest() for n,r in raw.items()}==EXPECTED, 'pinned input changed'
    data={n:json.loads(r) for n,r in raw.items()}
    roots=[]
    for n in names[:2]:
        for z in data[n]['root_intervals']:
            lo,hi=Q(z['imaginary_lower_exact']),Q(z['imaginary_upper_exact'])
            assert 0<lo<hi<25
            roots.append((lo,hi,z['character']))
    roots.sort()
    assert len(roots)==67 and all(x[1]<y[0] for x,y in zip(roots,roots[1:]))
    profile=data[names[2]]['profiles']['Q5']
    v=profile['conditional_full_tail_variance']
    wlo,whi=Q(v['lower_exact']),Q(v['upper_exact'])
    hashes=dict(EXPECTED)
    if constants is not None:
        rr=constants.read_bytes(); j=json.loads(rr)
        hashes['refined_analytic_constants']=hashlib.sha256(rr).hexdigest()
        assert hashes['refined_analytic_constants']=='e3756fd893dd9b85bbbd99ad84f84bafe6b35f39f749b79d53dbc34261210cb1', 'refined constants changed'
        assert j['cutoff']==150000 and j['bits']==80
        total_lo=total_hi=Q(0)
        for ab,weight in {'1,0':1,'0,2':9,'0,1':2,'1,1':2,'1,2':1}.items():
            k=j['analytic_constants'][ab]['K']
            total_lo+=weight*Q(int(k['lower_integer']),int(k['denominator']))
            total_hi+=weight*Q(int(k['upper_integer']),int(k['denominator']))
        low_lo=sum((2*(9 if lab=='5.4' else 1)/(Q(1,4)+hi*hi) for lo,hi,lab in roots),Q(0))
        low_hi=sum((2*(9 if lab=='5.4' else 1)/(Q(1,4)+lo*lo) for lo,hi,lab in roots),Q(0))
        wlo,whi=max(wlo,total_lo-low_hi),min(whi,total_hi-low_lo)
        # Compact outward dyadic endpoints; never decimal truncation inward.
        scale=1<<160
        wlo=Q((wlo*scale).__floor__(),scale)
        whi=Q((whi*scale).__ceil__(),scale)
        assert 0<wlo<whi<1
    return roots,wlo,whi,Q(profile['uniform_threshold_probability_error_upper']['upper_exact']),hashes

def compute(precision=128,panels=128,T=12,constants=None):
    ctx.prec=precision
    assert flint.__version__=='0.9.0' and flint.__FLINT_VERSION__=='3.6.0'
    assert precision>=96 and panels>=32
    roots,wlo,whi,replacement,hashes=inputs(constants)
    amps=[]
    for lo,hi,label in roots:
        g=ball(lo,hi)
        amp=2*(3 if label=='5.4' else 1)/(A(Q(1,4))+g*g).sqrt()
        amps.append(amp)
    wmid=(wlo+whi)/2
    def prod(z):
        p=acb(1)
        for a in amps: p *= (z*a).bessel_j(0)
        return p
    def fun(z,_):
        return z.sinc()*prod(z)*(-A(wmid)*z*z/2).exp()
    nominal_integral=acb(0)
    for left in range(0,T,2):
        v=acb.integral(fun,left,min(left+2,T),abs_tol=A(Q(1,10**13)),rel_tol=A(Q(1,10**13)),eval_limit=100000,deg_limit=100)
        assert v.is_finite()
        nominal_integral += v
    # |P(t)| <= 1 and |sin(t)/t| <= 1/t for t>=T.
    # Integral remainder <= exp(-wmid*T^2/2)/(wmid*T^2).
    rem=(-A(wmid)*T*T/2).exp()/(A(wmid)*T*T)
    nominal=arb(1)/2-nominal_integral.real/arb.pi()
    nominal+=arb(0,(rem/arb.pi()).upper())
    # Independent composite Simpson enclosure for the same entire integrand.
    # f is the characteristic function of U[-1,1] + sum(a cos Theta) + N(0,wmid).
    # Its fourth derivative has modulus <= E Z^4 <= 3 Var(Z)^2 (all kappa_4<=0).
    step=Q(1,128); count=T*128
    simpson=arb(0)
    for k in range(count+1):
        t=A(k*step)
        value=t.sinc()*(-A(wmid)*t*t/2).exp()
        for amp in amps: value*=(amp*t).bessel_j(0)
        simpson+=(1 if k in (0,count) else 4 if k%2 else 2)*value
    simpson*=A(step/3)
    var=A(Q(1,3)+wmid)+sum((a*a/2 for a in amps),arb(0))
    m4=(3*var*var).upper()
    simpson_error=(A(Q(T,180)*step**4)*m4).upper()
    simpson+=arb(0,simpson_error)
    assert simpson.contains(nominal_integral.real), 'independent quadratures disagree'
    # Uniform variance sensitivity on [wlo,whi].
    # |delta'(W)| <= (2*pi)^-1 integral t|sin t||P(t)|exp(-wlo*t^2/2)dt.
    # Rigorous upper Riemann rectangles, rational endpoints, outward balls.
    env=arb(0)
    for k in range(T*panels):
        lo,hi=Q(k,panels),Q(k+1,panels)
        z=ball(lo,hi)
        p=arb(1)
        for a in amps:
            u=(z*a).bessel_j(0).abs_upper()
            if u>1: u=arb(1)  # exact characteristic-function bound
            p*=u
        env+=A(Q(1,panels))*A(hi)*z.sin().abs_upper()*p*(-A(wlo)*A(lo)**2/2).exp()
    # The uncomputed derivative tail uses |sin|,|P|<=1.
    env+=(-A(wlo)*T*T/2).exp()/A(wlo)
    derivative=(env/(2*arb.pi())).upper()
    uncertainty=(A((whi-wlo)/2)*derivative).upper()
    replaced=nominal+arb(0,uncertainty)
    full=replaced+arb(0,A(replacement).upper())
    simpson_nominal=arb(1)/2-simpson/arb.pi()+arb(0,(rem/arb.pi()).upper())
    simpson_full=simpson_nominal+arb(0,uncertainty+A(replacement).upper())
    result={'status':'INTERNAL_CONDITIONAL_INTERVAL_ENCLOSURE','precision_bits':precision,
      'quadrature_cutoff':T,'sensitivity_panels_per_unit':panels,'input_sha256':hashes,
      'positive_roots':67,'variance_interval':[str(wlo),str(whi)],
      'variance_midpoint_exact':str(wmid),'nominal_integral':bounds(nominal_integral.real),
      'simpson_integral':bounds(simpson),'simpson_error_upper':bounds(simpson_error),
      'simpson_fourth_derivative_upper':bounds(m4),'simpson_step_exact':str(step),
      'nominal_gaussian_replaced_density':bounds(nominal),
      'derivative_upper':bounds(derivative),'variance_uncertainty_error':bounds(uncertainty),
      'gaussian_replaced_density_for_all_variances':bounds(replaced),
      'spectral_tail_replacement_error_exact':str(replacement),
      'full_independent_phase_density':bounds(full),
      'full_density_by_independent_simpson':bounds(simpson_full),
      'GRH_proved':False,'LI_proved':False,'independent_review':False,
      'trust':'Python-FLINT 0.9.0 / FLINT 3.6.0, pinned root and tail certificates'}
    assert Q(result['full_independent_phase_density']['lower_exact'])>0
    assert Q(result['full_independent_phase_density']['upper_exact'])<Q(1,2)
    return result

if __name__=='__main__':
    p=argparse.ArgumentParser()
    p.add_argument('--precision',type=int,default=128)
    p.add_argument('--panels',type=int,default=128)
    p.add_argument('--data',type=Path)
    p.add_argument('--constants',type=Path)
    p.add_argument('--out',type=Path,required=True)
    a=p.parse_args(); start=time.monotonic()
    if a.data: BASE=a.data
    r=compute(a.precision,a.panels,constants=a.constants)
    r['seconds']=round(time.monotonic()-start,2)
    a.out.write_text(json.dumps(r,indent=2)+'\n')
    print(json.dumps(r,indent=2))
