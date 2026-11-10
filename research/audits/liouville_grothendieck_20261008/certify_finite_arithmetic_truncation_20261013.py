#!/usr/bin/env python3
"""Direct finite prime-race/truncated-signal integral enclosures.

Integer outward rounding, elementary series, and a deterministic prime sieve.
No asymptotic constant or arithmetic limiting density is certified here.
"""
import argparse
import hashlib
import json
from fractions import Fraction as Q
from functools import lru_cache
from math import factorial, gcd, isqrt
from pathlib import Path
from verify_quantitative_specialization_20261013 import INPUTS, pinned_inputs, root_boxes, require

HERE = Path(__file__).resolve().parent
SCALE = 10**50
COEFFICIENTS = {'3.2':-1, '5.2':1, '5.3':1, '5.4':3,
                '15.2':1, '15.8':1, '15.14':-1}
FIXTURE = 'finite_arithmetic_truncation_20261013.json'


def ceil_div(a, b):
    require(b > 0, 'nonpositive integer divisor')
    return -((-a)//b)


class I:
    """Closed interval [lo/SCALE,hi/SCALE], using integers only."""
    __slots__ = ('lo', 'hi')

    def __init__(self, lo, hi):
        require(isinstance(lo, int) and isinstance(hi, int) and lo <= hi,
                'invalid fixed-point interval')
        self.lo, self.hi = lo, hi

    @staticmethod
    def of(value):
        if isinstance(value, I):
            return value
        require(isinstance(value, (int, Q)) and not isinstance(value, bool),
                'floating-point or unsupported input refused')
        value = Q(value)
        a = value.numerator*SCALE
        return I(a//value.denominator, ceil_div(a, value.denominator))

    def __add__(self, other):
        other = I.of(other)
        return I(self.lo+other.lo, self.hi+other.hi)

    __radd__ = __add__

    def __neg__(self):
        return I(-self.hi, -self.lo)

    def __sub__(self, other):
        return self+-I.of(other)

    def __rsub__(self, other):
        return I.of(other)+-self

    def __mul__(self, other):
        other = I.of(other)
        products = (self.lo*other.lo, self.lo*other.hi,
                    self.hi*other.lo, self.hi*other.hi)
        return I(min(products)//SCALE, ceil_div(max(products), SCALE))

    __rmul__ = __mul__

    def inverse(self):
        require(self.lo > 0 or self.hi < 0, 'division by a zero-containing interval')
        if self.hi < 0:
            return -(-self).inverse()
        return I(SCALE*SCALE//self.hi, ceil_div(SCALE*SCALE, self.lo))

    def __truediv__(self, other):
        return self*I.of(other).inverse()

    def square(self):
        low = 0 if self.lo <= 0 <= self.hi else min(self.lo*self.lo, self.hi*self.hi)
        high = max(self.lo*self.lo, self.hi*self.hi)
        return I(low//SCALE, ceil_div(high, SCALE))

    def sqrt(self):
        require(self.lo >= 0, 'negative square-root argument')
        lo = isqrt(self.lo*SCALE)
        target = self.hi*SCALE
        hi = isqrt(target)
        return I(lo, hi+(hi*hi < target))

    def abs(self):
        if self.lo >= 0:
            return self
        if self.hi <= 0:
            return -self
        return I(0, max(-self.lo, self.hi))

    def widened(self, radius):
        require(isinstance(radius, int) and radius >= 0, 'invalid radius')
        return I(self.lo-radius, self.hi+radius)

    def clip_unit(self):
        lo, hi = max(-SCALE, self.lo), min(SCALE, self.hi)
        require(lo <= hi, 'trigonometric enclosure incompatible with unit range')
        return I(lo, hi)

    def exact(self):
        return [str(Q(self.lo,SCALE)), str(Q(self.hi,SCALE))]

    def decimal(self, digits=6):
        multiplier = 10**digits
        a = self.lo*multiplier//SCALE
        b = ceil_div(self.hi*multiplier,SCALE)
        def fmt(n):
            sign = '-' if n < 0 else ''
            n = abs(n)
            return sign+str(n//multiplier)+'.'+str(n%multiplier).zfill(digits)
        return [fmt(a), fmt(b)]


def log_unit(value):
    """log(value), 1<=value<=2, by an atanh series plus a positive tail."""
    require(isinstance(value,(int,Q)) and not isinstance(value,bool),
            'floating-point or unsupported logarithm input refused')
    value = Q(value)
    require(1 <= value <= 2, 'log series reduction outside [1,2]')
    z = (value-1)/(value+1)
    x, x2 = I.of(z), I.of(z*z)
    total, power = I.of(0), x
    for k in range(64):
        total += power*Q(2,2*k+1)
        power *= x2
    tail = 2*z**129/(129*(1-z*z))
    return I(total.lo, total.hi+ceil_div(tail.numerator*SCALE,tail.denominator))


LOG2 = log_unit(Q(2))


@lru_cache(maxsize=50000,typed=True)
def log_q(value):
    require(isinstance(value,(int,Q)) and not isinstance(value,bool),
            'floating-point or unsupported logarithm input refused')
    value = Q(value)
    require(value > 0, 'nonpositive logarithm argument')
    reduced, exponent = value, 0
    while reduced >= 2:
        reduced /= 2
        exponent += 1
    while reduced < 1:
        reduced *= 2
        exponent -= 1
    return exponent*LOG2+log_unit(reduced)


def sincos(angle):
    """Enclose sin/cos on an angle box via division by 512 and nine doublings."""
    angle = I.of(angle)
    require(0 <= angle.lo <= angle.hi <= 512*SCALE, 'trigonometric range unsupported')
    x = angle*Q(1,512)
    x2 = x.square()
    cosine, sine, cterm, sterm = I.of(1), x, I.of(1), x
    for k in range(1,21):
        cterm = -(cterm*x2)*Q(1,(2*k-1)*(2*k))
        sterm = -(sterm*x2)*Q(1,(2*k)*(2*k+1))
        cosine += cterm
        sine += sterm
    # For |x|<=1, the omitted tails of these alternating series are
    # bounded by 1/42! and 1/43!, respectively. Rounding is separate.
    cosine = cosine.widened(ceil_div(SCALE,factorial(42)))
    sine = sine.widened(ceil_div(SCALE,factorial(43)))
    for _ in range(9):
        cosine, sine = ((cosine.square()-sine.square()).clip_unit(),
                        (2*cosine*sine).clip_unit())
    return sine, cosine


def prime_sieve(bound):
    require(isinstance(bound,int) and bound >= 2, 'invalid sieve bound')
    flags = bytearray(b'\x01')*(bound+1)
    flags[:2] = b'\x00\x00'
    for p in range(2,isqrt(bound)+1):
        if flags[p]:
            start = p*p
            flags[start:bound+1:p] = b'\x00'*((bound-start)//p+1)
    return flags


def prime_weight(p):
    return 0 if gcd(p,30) != 1 else (5 if p%30 in {1,11,29} else -3)


def weighted_path(flags):
    path = [0]*len(flags)
    value, A, B = 0, 0, 0
    for n in range(2,len(flags)):
        if flags[n]:
            w = prime_weight(n)
            value += w
            A += w == 5
            B += w == -3
        path[n] = value
    return path, A, B


def finite_occupation(flags):
    """Exactly weighted log lengths of prime-constant positive sign intervals."""
    last, value, integral = 2, 0, I.of(0)
    for p in range(2,len(flags)):
        if not flags[p] or not prime_weight(p):
            continue
        if value > 0:
            integral += log_q(Q(p,last))
        value += prime_weight(p)
        last = p
    bound = len(flags)-1
    if value > 0:
        integral += log_q(Q(bound,last))
    return integral/log_q(Q(bound,2))


def grid_cells(exponent, parts):
    require(isinstance(exponent,int) and 2 <= exponent <= 16, 'unsupported finite horizon')
    require(isinstance(parts,int) and parts > 0, 'invalid grid resolution')
    previous, count = Q(2), 0
    for k in range(1,exponent):
        for j in range(parts):
            left = Q(2**k*(parts+j),parts)
            right = Q(2**k*(parts+j+1),parts)
            require(left == previous and left < right, 'grid gap or overlap')
            yield left, right
            previous, count = right, count+1
    require(previous == 2**exponent and count == (exponent-1)*parts,
            'grid does not cover full finite horizon')


def spectral_parameters(rows, cutoff):
    require(all(hi < cutoff or lo > cutoff for lo,hi in rows.values()),
            'cutoff membership unresolved')
    phases = []
    for (label,index),(lo,hi) in sorted(rows.items()):
        if hi >= cutoff:
            continue
        g = I(I.of(lo).lo,I.of(hi).hi)
        c = COEFFICIENTS[label]
        den = Q(1,4)+g.square()
        phases.append((g,I.of(Q(c,2))/den,c*g/den))
    return phases, 2*sum(abs(COEFFICIENTS[k[0]]) for k,b in rows.items() if b[1]<cutoff)


def spectral_at(y, phases):
    result = I.of(-1)
    for gamma, alpha, beta in phases:
        sine, cosine = sincos(gamma*y)
        result -= 2*(alpha*cosine+beta*sine)
    return result


def build_report(exponent=16, parts=512):
    require(isinstance(exponent,int) and not isinstance(exponent,bool)
            and 2 <= exponent <= 16, 'unsupported finite horizon')
    require(isinstance(parts,int) and not isinstance(parts,bool)
            and 0 < parts <= 512, 'unsupported grid resolution')
    rows = root_boxes(pinned_inputs())
    bound = 2**exponent
    flags = prime_sieve(bound)
    path, A, B = weighted_path(flags)
    normalizer = log_q(Q(bound,2))
    parameters = {cut:spectral_parameters(rows,Q(cut)) for cut in (4,25)}
    require([len(parameters[k][0]) for k in (4,25)] == [2,67]
            and [parameters[k][1] for k in (4,25)] == [4,166],
            'unexpected phase or derivative accounting')
    totals = {cut:I.of(0) for cut in parameters}
    trace = hashlib.sha256()
    for left,right in grid_cells(exponent,parts):
        midpoint = (left+right)/2
        ylo, yhi, yc = log_q(left), log_q(right), log_q(midpoint)
        radius = max(yc.hi-ylo.lo,yhi.hi-yc.lo)
        mass = log_q(right/left)
        dvalues = path[left.numerator//left.denominator:right.numerator//right.denominator+1]
        require(dvalues, 'empty arithmetic cell')
        dbox = I.of(Q(min(dvalues)))
        dbox = I(dbox.lo,I.of(Q(max(dvalues))).hi)
        sqrt_left, sqrt_right = I.of(left).sqrt(), I.of(right).sqrt()
        # log(x)/sqrt(x) is enclosed without assuming monotonicity near e^2.
        factor = I((ylo/sqrt_right).lo,(yhi/sqrt_left).hi)
        arithmetic = dbox*factor
        for cutoff,(phases,derivative_bound) in parameters.items():
            spectral = spectral_at(yc,phases).widened(derivative_bound*radius)
            error = (arithmetic-spectral).abs()
            totals[cutoff] += mass*error
            trace.update((str(left)+'|'+str(right)+'|'+str(cutoff)+'|'+
                          '|'.join(error.exact())+'\n').encode())
    errors = {str(k):(v/normalizer) for k,v in totals.items()}
    occupancy = finite_occupation(flags)
    require(0 <= occupancy.lo <= occupancy.hi <= SCALE, 'occupation outside probability range')
    return dict(id='CU-BRUIT-DIRECT-FINITE-ARITHMETIC-TRUNCATION-20261013',
        status='INTERNAL_FINITE_INTERVAL_CERTIFICATE_NOT_AN_ASYMPTOTIC_RATE',
        prime_argument_upper=bound,logarithmic_horizon_symbolic='log('+str(bound)+')',
        normalized_interval_symbolic='[log(2),log('+str(bound)+')]',
        log_interval_length_exact=normalizer.exact(),
        grid=dict(exponent=exponent,parts_per_doubling=parts,total_cells=(exponent-1)*parts),
        arithmetic=dict(primes_through_bound=sum(flags),support_prime_count=A,
                        complement_prime_count=B,D_at_bound=path[-1],
                        sieve_bitmap_sha256=hashlib.sha256(flags).hexdigest()),
        finite_positive_log_occupation=dict(exact=occupancy.exact(),decimal_outer=occupancy.decimal(),
                                             GRH_LI_ELI_needed=False),
        averaged_absolute_truncation_error={k:dict(exact=v.exact(),decimal_outer=v.decimal(),
             phases=len(parameters[int(k)][0]),time_derivative_upper=parameters[int(k)][1])
             for k,v in errors.items()},
        arithmetic_function='E(y)=y*exp(-y/2)*D(exp(y))',
        spectral_function='E_T(y)=-1-2*sum c_chi*(cos(gamma*y)/2+gamma*sin(gamma*y))/(1/4+gamma^2)',
        cell_cover_and_interval_trace_sha256=trace.hexdigest(),
        elementary_arithmetic=dict(scale=str(SCALE),log_atanh_terms=64,
                                  sine_cosine_terms=21,angle_divisor=512,doublings=9),
        root_input_sha256={k:v for k,v in INPUTS.items() if 'root_interval' in k},
        root_enclosures_trusted=True,root_enclosures_recomputed_by_this_program=False,
        global_GRH_LI_ELI_needed_for_this_finite_comparison=False,
        limit_law_identification_still_requires_analytic_hypotheses=True,
        uniform_in_horizon_arithmetic_rate_certified=False,
        complete_arithmetic_to_limit_budget_closed=False,
        independent_human_review_claimed=False)


def render(report):
    return json.dumps(report,indent=2,sort_keys=True)+'\n'


def main():
    p = argparse.ArgumentParser(description=__doc__)
    g = p.add_mutually_exclusive_group()
    g.add_argument('--check',action='store_true')
    g.add_argument('--write',action='store_true')
    args = p.parse_args()
    report = build_report()
    target = HERE/FIXTURE
    if args.write:
        target.write_text(render(report),encoding='utf-8',newline='')
    if args.check:
        require(target.read_bytes() == render(report).encode(), 'finite arithmetic receipt differs')
    print(json.dumps({k:report[k] for k in ('status','arithmetic',
        'finite_positive_log_occupation','averaged_absolute_truncation_error')},indent=2))


if __name__ == '__main__':
    try:
        main()
    except (ValueError,KeyError,TypeError,OSError) as e:
        raise SystemExit('FAIL CLOSED: '+str(e))
