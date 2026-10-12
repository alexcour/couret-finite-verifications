#!/usr/bin/env python3
"""Conservative rational Bessel error implication using sixteen published q=5 entries.

THIS IS NOT an unconditional prime-race certificate. Required inputs:
GRH, sufficient LI, published 16 ordinates with authentic upper enclosures,
and the BMOR-derived V25>0.63. All inequality arithmetic is exact Fraction.
"""
from fractions import Fraction as F
from decimal import Decimal
from math import isqrt
import json

DATA=(
("5.4","6.64845334472771471612327845997","6.648455",3),
("5.4","9.831444432886669616348321347458","9.831446",3),
("5.4","11.95884562608351453026565868826","11.958847",3),
("5.3","4.13290370521285159500191933156","4.132905",1),
("5.4","16.03382112838423567459325378224","16.033823",3),
("5.4","17.566994292325555202701595268144","17.566996",3),
("5.2","6.18357819545085391437751730970","6.183580",1),
("5.4","19.54073262278475025037869002299","19.540734",3),
("5.4","22.227405454459410911877624963081","22.227407",3),
("5.4","24.58846621740819520765626997608","24.588468",3),
("5.2","8.45722917442323072160535286274","8.457231",1),
("5.3","9.44293112972850911710026212431","9.442933",1),
("5.3","11.2828964415816001332254807924","11.282898",1),
("5.2","12.67494641701135578048229914508","12.674948",1),
("5.3","14.11546426656964617536066631834","14.115466",1),
("5.2","14.82502557032842825143025217404","14.825027",1),
)
SCALE=10**12
def sqrt_upper(x):
    n=isqrt(x.numerator*SCALE*SCALE//x.denominator)+1
    v=F(n,SCALE)
    assert v*v>x
    return v

def check():
    assert len(DATA)==16 and len(set((a,b) for a,b,_,_ in DATA))==16
    pi_lower=F(314,100)
    V_lower=F(63,100)
    M=F(3,25)
    H=F(9,2)
    j01_lower=F(2)
    ratio=(2*M*H/j01_lower)**2
    assert ratio==F(729,2500)<1
    small=M*M/(4*pi_lower*V_lower*(1-ratio))
    factors=F(1)
    for label,printed,U,weight in DATA:
        z=F(Decimal(printed)); upper=F(Decimal(U))
        assert label in ("5.2","5.3","5.4")
        assert weight==(3 if label=="5.4" else 1)
        assert 1<z<upper-F(1,10**20) and upper<25
        # gamma<=upper and gamma>=1 => b >= weight/(upper+1/8)
        factors*=sqrt_upper((upper+F(1,8))/(pi_lower*weight*H))
    large=F(4,len(DATA))/pi_lower*factors
    total=small+large
    assert total<F(29,10000)
    return {
      "strict_bound_under_assumptions":"<0.0029",
      "rational_total":str(total),
      "decimal_for_orientation_only":float(total),
      "low_frequency_rational":str(small),
      "high_frequency_rational":str(large),
      "selected_q5_factors":len(DATA),
      "gate":"Needs authentication/rigorous enclosure of published ordinates, GRH+LI; NOT a certified prime sign-density bound",
      "q15_external_matches":0
    }
if __name__=="__main__":
    print(json.dumps(check(),indent=2))
