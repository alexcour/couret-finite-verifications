"""Exact Fourier conventions and direct Arb central nonvanishing, no GRH/LI.

The L evaluations use the same trusted FLINT backend as the root certificates.
They are a finite alternative to the earlier Hadamard K argument, not an
independent implementation or a proof of any zero-independence hypothesis.
"""
import argparse
import hashlib
import json
from fractions import Fraction as Q
from pathlib import Path
import flint
from flint import acb, arb, ctx, dirichlet_char
from audit_density import A, bounds

ROWS = [(0,1,5,2,1),(0,2,5,4,3),(0,3,5,3,1),
        (1,0,3,2,-1),(1,1,15,2,1),(1,2,15,14,-1),(1,3,15,8,1)]


def compute(precision):
    assert precision >= 128
    assert flint.__version__ == '0.9.0' and flint.__FLINT_VERSION__ == '3.6.0'
    ctx.prec = precision
    # Gaussian integers encode the characters exactly, without floating point.
    ipowers = [(1,0),(0,1),(-1,0),(0,-1)]
    coords = {(pow(11,x,30)*pow(7,y,30))%30:(x,y)
              for x in range(2) for y in range(4)}
    assert len(coords) == 8
    def value(a,b,n):
        x,y = coords[n]
        re,im = ipowers[b*y%4]
        s = (-1)**(a*x)
        return (s*re,s*im)
    weights = {n:5 if n in (1,11,29) else -3 for n in coords}
    assert sum(weights.values()) == 0
    output = []
    for a,b,q,num,expected_h in ROWS:
        h = tuple(sum(value(a,b,n)[k] for n in (1,11,29)) for k in (0,1))
        assert h == (expected_h,0)
        chi = dirichlet_char(q,num)
        bar = dirichlet_char(q,pow(num,-1,q))
        assert chi.is_primitive() and not chi.is_principal()
        assert chi.conductor() == q and chi.parity() == (a+b)%2
        for n in coords:
            re,im = value(a,b,n)
            assert chi(n) == acb(re,im)
            assert bar(n) == chi(n).conjugate()
        central = chi.l_function(acb(A(Q(1,2))))
        assert central.is_finite() and not central.contains(0)
        modulus_lower = central.abs_lower()
        assert modulus_lower > A(Q(1,10))
        output.append(dict(character=f'{q}.{num}', a=a,b=b,h=expected_h,
            squared_weight=expected_h**2,conjugate=f'{q}.{bar.number()}',
            parity=chi.parity(),central_real=bounds(central.real),
            central_imag=bounds(central.imag),
            central_modulus_lower=bounds(modulus_lower),central_nonzero=True))
    # Prime-square constant: only nonprincipal quadratic characters contribute.
    mean = -sum(h for a,b,q,num,h in ROWS if b%2==0)
    assert mean == -1
    squares = {n*n%30 for n in coords}
    assert squares == {1,19}
    assert mean == -sum(weights[n] for n in squares)/2
    return dict(status='INTERNAL_EXACT_CHARACTERS_AND_CENTRAL_NONVANISHING',
        precision_bits=precision,characters=output,conventional_mean=mean,
        all_seven_central_moduli_greater_than='1/10',
        GRH_assumed=False,LI_proved=False,independent_review=False,
        trust='Python-FLINT 0.9.0 / FLINT 3.6.0 direct L(1/2) enclosures',
        script_sha256=hashlib.sha256(Path(__file__).read_bytes()).hexdigest())


if __name__ == '__main__':
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument('--precision',type=int,default=256)
    p.add_argument('--out',type=Path,required=True)
    a=p.parse_args(); result=compute(a.precision)
    a.out.write_text(json.dumps(result,indent=2)+'\n')
    print(json.dumps(dict(status=result['status'],precision=a.precision,
        mean=result['conventional_mean'],central_nonzero=7),indent=2))
