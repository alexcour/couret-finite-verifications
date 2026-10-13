#!/usr/bin/env python3
"""Conditional lower bound for CU-BRUIT-02 spectral tail using BMOR Thm 1.1.

Bennett-Martin-O'Bryant-Rechnitzer, Counting Zeros of Dirichlet L-Functions,
Math. Comp. 90 (2021), DOI 10.1090/mcom/3599, Theorem 1.1.

All inequalities involving pi, natural logarithms, and final comparisons
use exact Fraction arithmetic and rational power-series enclosures.

The count is unconditional, but identifying the imaginary-part sums with
the model's critical-line phase variance requires GRH. This DOES NOT prove
GRH/LI, or independently certify any individual zero or sign density.
"""
from fractions import Fraction as F
import json

T = F(25)
PI_LO = F(314,100)     # pi > 3.14
PI_HI = F(22,7)       # pi < 22/7
C_BMOR = F(22737,100000)
# Squared Fourier weights for 7 nonprincipal primitive characters:
# conductor 3: 1; conductor 5: 1+9+1; conductor 15: 1+1+1.
WEIGHTS = {3:1, 5:11, 15:3}


def log_bounds_ge_one(x, terms=15):
    """Rational lower and upper bounds for log(x), x rational >= 1.

    log(z) = 2*sum_{n>=0} y^(2n+1)/(2n+1), y=(z-1)/(z+1).
    Scale x by powers of 2 so 1<=z<2, 0<=y<1/3. Error after
    n=terms-1 is at most 2*y^(2*terms+1)/
    ((2*terms+1)*(1-y*y)). For log(2), y=1/3.
    """
    assert isinstance(x,F) and x>=1
    scale=1
    shift=0
    while x >= 2*scale:
        scale*=2
        shift+=1
    z=x/F(scale)
    assert 1<=z<2

    def series(y):
        acc=F(0)
        power=y
        for n in range(terms):
            acc+=2*power/(2*n+1)
            power*=y*y
        remainder=2*power/((2*terms+1)*(1-y*y))
        return acc,acc+remainder
    a,b=series(F(1,3))
    u,v=series((z-1)/(z+1))
    lo,hi=shift*a+u,shift*b+v
    assert 0<=lo<=hi
    return lo,hi


def lower_bound():
    total=F(0)
    components={}
    for q,weight in WEIGHTS.items():
        ell_T_lower=log_bounds_ge_one(F(q)*(T+2)/(2*PI_HI))[0]
        ell_T_upper=log_bounds_ge_one(F(q)*(T+2)/(2*PI_LO))[1]
        ell0_lower=log_bounds_ge_one(F(q)*T/(2*PI_HI))[0]
        assert ell_T_lower>F(1567,1000)

        # BMOR: |N(t,chi)-[t/pi*log(q*t/(2*pi*e))-chi(-1)/4]|
        # <= E(t), E=0.22737*ell+2*log(1+ell)-0.5.
        error_upper=(C_BMOR*ell_T_upper
                     +2*log_bounds_ge_one(1+ell_T_upper)[1]-F(1,2))
        slope_upper=C_BMOR+2/(1+ell_T_lower)

        # Stieltjes integration by parts of f(t)=1/(t^2+1/4).
        # Main term integral: (1/pi)*int_T^inf
        # log(q*t/(2*pi)) / (t^2+1/4) dt.
        # Using 1/(t^2+1/4) >= 1/t^2 - 1/(4*t^4),
        # pi<22/7, and the bound ell0_lower.
        main_lower=F(7,22)*(
            (ell0_lower+1)/T -
            (ell0_lower+F(1,3))/(12*T**3))

        # E(t) <= E(T)+k*log(t/T) for t>=T, since
        # E'(ell)<=k and ell(t)-ell(T)<=log(t/T).
        # -f'(t)<=2/t^3 and f(T)<=1/T^2, giving
        # error <= (2*E(T)+k/2)/T^2.
        error_loss_upper=(2*error_upper+slope_upper/2)/T**2
        per_character=main_lower-error_loss_upper
        assert per_character>0
        total+=weight*per_character
        components[str(q)]={
          "squared_coefficient_sum":weight,
          "ell_T_lower":float(ell_T_lower),
          "ell_T_upper":float(ell_T_upper),
          "BMOR_E_T_upper":float(error_upper),
          "main_tail_lower":float(main_lower),
          "integration_error_upper":float(error_loss_upper),
          "per_character_tail_lower":float(per_character)
        }
    assert total>F(63,100),float(total)
    # Exact floor at six decimals: compact, reproducible witness without
    # converting a giant Fraction numerator/denominator to a string.
    floor_6dp = (total.numerator * 1000000) // total.denominator
    assert floor_6dp > 630000
    return {"strict_rational_lower_6dp":f"{floor_6dp}/1000000",
            "float_for_display_only":float(total),
            "proved_implication":"GRH for seven primitive Dirichlet characters => V_25 > 63/100",
            "relies_on":"BMOR Theorem 1.1 counting all signed ordinates in strip",
            "q15_external_decimal_comparisons_used":0,
            "cannot_infer":["GRH","LI","individual certified zeros","sign density"],
            "details":components}


if __name__=="__main__":
    print(json.dumps(lower_bound(),indent=2,sort_keys=True))
