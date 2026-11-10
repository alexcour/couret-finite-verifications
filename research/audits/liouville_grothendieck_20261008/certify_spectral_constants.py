#!/usr/bin/env python3
"""Dyadic outward enclosures of five analytic Dirichlet L constants.

Standard library, integer arithmetic only. Periodic-character summation tails
are bounded analytically. No zero list or GRH/LI is certified by this script.
"""
import argparse
import json
from functools import lru_cache
from fractions import Fraction
from itertools import product
from math import gcd
from pathlib import Path

BITS = 80
SCALE = 1 << BITS
LOG_TERMS = 48
GAMMA_CUTOFF = 16384
REPS = ((1, 0), (0, 2), (0, 1), (1, 1), (1, 2))
LABELS = {(1, 0): "3.2", (0, 2): "5.4", (0, 1): "5.2/5.3",
          (1, 1): "15.2/15.8", (1, 2): "15.14"}
EXPO5 = {1: 0, 2: 1, 4: 2, 3: 3}
UNITS = ((1, 0), (0, 1), (-1, 0), (0, -1))


def ceil_div(n, d):
    return -((-n) // d)


class Interval:
    """[lo/SCALE,hi/SCALE]; all endpoints and calculations are integers."""
    __slots__ = ("lo", "hi")

    def __init__(self, lo, hi):
        assert isinstance(lo, int) and isinstance(hi, int) and lo <= hi
        self.lo, self.hi = lo, hi

    @staticmethod
    def rational(n, d=1):
        assert d > 0
        return Interval(n * SCALE // d, ceil_div(n * SCALE, d))

    def __add__(self, other):
        if isinstance(other, int):
            other = Interval.rational(other)
        return Interval(self.lo + other.lo, self.hi + other.hi)

    __radd__ = __add__

    def __neg__(self):
        return Interval(-self.hi, -self.lo)

    def __sub__(self, other):
        return self + (-other)

    def __mul__(self, other):
        if isinstance(other, int):
            other = Interval.rational(other)
        p = [a * b for a in (self.lo, self.hi) for b in (other.lo, other.hi)]
        return Interval(min(p) // SCALE, ceil_div(max(p), SCALE))

    __rmul__ = __mul__

    def __truediv__(self, other):
        if isinstance(other, int):
            other = Interval.rational(other)
        if other.lo <= 0 <= other.hi:
            raise ValueError("interval denominator contains zero")
        pairs = [(a * SCALE, b) for a in (self.lo, self.hi)
                 for b in (other.lo, other.hi)]
        return Interval(min(n // d for n, d in pairs), max(ceil_div(n, d) for n, d in pairs))

    def square(self):
        high = max(self.lo ** 2, self.hi ** 2)
        low = 0 if self.lo <= 0 <= self.hi else min(self.lo ** 2, self.hi ** 2)
        return Interval(low // SCALE, ceil_div(high, SCALE))

    def widen(self, upper_radius):
        assert upper_radius >= 0
        return Interval(self.lo - upper_radius, self.hi + upper_radius)

    def decimal_bounds(self, digits=6):
        base = 10 ** digits
        low = self.lo * base // SCALE
        high = ceil_div(self.hi * base, SCALE)
        def render(n):
            sign = "-" if n < 0 else ""
            a, b = divmod(abs(n), base)
            return f"{sign}{a}.{b:0{digits}d}"
        return [render(low), render(high)]

    def certificate(self):
        return {"lower_integer": str(self.lo), "upper_integer": str(self.hi),
                "denominator": str(SCALE), "decimal_outer_bounds": self.decimal_bounds()}


def reduced_log(n, d):
    assert d <= n < 2 * d
    u = Interval.rational(n - d, n + d)
    u2, power = u.square(), u
    out = Interval.rational(0)
    for k in range(LOG_TERMS):
        out = out + power / (2 * k + 1)
        power = power * u2
    # Remaining positive series <= u^(2M+1)/((2M+1)(1-u^2)).
    rem = (2 * power) / ((Interval.rational(1) - u2) * (2 * LOG_TERMS + 1))
    return Interval((2 * out).lo, (2 * out).hi + rem.hi)


LOG2 = reduced_log(3, 2) + reduced_log(4, 3)  # log 2, with u=1/5 and 1/7


@lru_cache(maxsize=None)
def log_rational(n, d=1):
    assert n > 0 and d > 0
    k = n.bit_length() - d.bit_length()
    if k >= 0:
        a, b = n, d << k
    else:
        a, b = n << (-k), d
    if a < b:
        a *= 2
        k -= 1
    elif a >= 2 * b:
        b *= 2
        k += 1
    return reduced_log(a, b) + k * LOG2


def log_interval(value):
    assert value.lo > 0
    return Interval(log_rational(value.lo, SCALE).lo, log_rational(value.hi, SCALE).hi)


def arctan_reciprocal(d, terms):
    x = Interval.rational(1, d)
    square, power = x.square(), x
    total = Interval.rational(0)
    for k in range(terms):
        total = total + ((-1) ** k) * (power / (2 * k + 1))
        power = power * square
    error = (power / (2 * terms + 1)).hi
    return Interval(total.lo - (error if terms % 2 else 0),
                    total.hi + (error if terms % 2 == 0 else 0))


def fundamental_constants():
    pi = 16 * arctan_reciprocal(5, 48) - 4 * arctan_reciprocal(239, 8)
    harmonic = Interval.rational(0)
    for n in range(1, GAMMA_CUTOFF + 1):
        harmonic = harmonic + Interval.rational(1, n)
    # Elementary integral bounds, not a quoted decimal of Euler's constant.
    gamma = Interval(harmonic.lo - log_rational(GAMMA_CUTOFF + 1).hi,
                     harmonic.hi - log_rational(GAMMA_CUTOFF).lo)
    return pi, gamma


def character(n, a, b):
    q = (3 if a else 1) * (5 if b else 1)
    if gcd(n, q) != 1:
        return 0, 0
    sign = -1 if a and n % 3 == 2 else 1
    re, im = UNITS[(b * EXPO5[n % 5]) % 4] if b else (1, 0)
    return sign * re, sign * im


def constant_enclosure(a, b, cutoff, logpi, gamma):
    q = (3 if a else 1) * (5 if b else 1)
    assert cutoff % q == 0 and cutoff >= 3
    table = [character(n, a, b) for n in range(1, q + 1)]
    assert tuple(map(sum, zip(*table))) == (0, 0)
    bound = []
    for component in range(2):
        partial, maximum = 0, 0
        for z in table:
            partial += z[component]
            maximum = max(maximum, abs(partial))
        assert partial == 0
        bound.append(maximum)
    L = [Interval.rational(0), Interval.rational(0)]
    Lp = [Interval.rational(0), Interval.rational(0)]
    for n in range(1, cutoff + 1):
        re, im = table[(n - 1) % q]
        if not (re or im):
            continue
        inv = Interval.rational(1, n)
        deriv = -(log_rational(n) / n)
        for j, value in enumerate((re, im)):
            if value:
                L[j] = L[j] + value * inv
                Lp[j] = Lp[j] + value * deriv
    tails = []
    for j, maximum in enumerate(bound):
        e = Interval.rational(maximum, cutoff)
        ep = maximum * log_rational(cutoff) / cutoff
        L[j], Lp[j] = L[j].widen(e.hi), Lp[j].widen(ep.hi)
        tails.append({"L_tail": e.decimal_bounds(10), "Lp_tail": ep.decimal_bounds(10)})
    norm = L[0].square() + L[1].square()
    if norm.lo <= 0:
        raise ValueError("cannot certify L(1) nonzero")
    quotient_real = (Lp[0] * L[0] + Lp[1] * L[1]) / norm
    K = 2 * quotient_real + log_rational(q) - logpi - gamma
    if (a + b) % 2 == 0:
        K = K - 2 * LOG2
    return K, {"ab": [a, b], "label": LABELS.get((a, b), str((a, b))),
               "conductor": q, "parity": "even" if (a + b) % 2 == 0 else "odd",
               "period_partial_sum_bounds": bound, "tail_component_bounds": tails,
               "L_real": L[0].certificate(), "L_imag": L[1].certificate(),
               "Lp_real": Lp[0].certificate(), "Lp_imag": Lp[1].certificate(),
               "L_norm_square": norm.certificate(), "K": K.certificate()}


def certify(cutoff=15000):
    if cutoff < 3 or cutoff % 15:
        raise ValueError("cutoff must be a positive multiple of 15, at least 15")
    pi, gamma = fundamental_constants()
    intervals, records = {}, {}
    for a, b in REPS:
        K, record = constant_enclosure(a, b, cutoff, log_interval(pi), gamma)
        intervals[(a, b)], records[f"{a},{b}"] = K, record
    ordered = sorted(intervals, key=lambda ab: intervals[ab].lo)
    gaps = []
    for a, b in zip(ordered, ordered[1:]):
        if intervals[a].hi >= intervals[b].lo:
            raise ValueError("analytic constant enclosures overlap: separation not certified")
        gaps.append({"lower_ab": list(a), "upper_ab": list(b),
                     "gap_lower_integer": str(intervals[b].lo - intervals[a].hi),
                     "denominator": str(SCALE)})
    assert ordered == [(1, 0), (0, 2), (0, 1), (1, 1), (1, 2)]
    assert all(0 < value.lo <= value.hi < 4 * SCALE for value in intervals.values())
    all_constants = dict(intervals)
    all_constants[(0, 3)] = intervals[(0, 1)]
    all_constants[(1, 3)] = intervals[(1, 1)]
    baseline = sum(all_constants.values(), Interval.rational(0))
    targets = {"Q3": (1, 0), "Q5": (0, 2), "C5": (0, 1),
               "C15": (1, 1), "Q15": (1, 2)}
    variances = {name: baseline + 8 * intervals[ab] for name, ab in targets.items()}
    previous = None
    for name in targets:
        if previous is not None and variances[previous].hi >= variances[name].lo:
            raise ValueError("model variance enclosures overlap")
        previous = name
    return {"schema": "CU-BRUIT-02-C dyadic analytic constants certificate v1",
            "cutoff": cutoff, "bits": BITS, "log_series_terms": LOG_TERMS,
            "gamma_harmonic_cutoff": GAMMA_CUTOFF,
            "pi": pi.certificate(), "euler_gamma": gamma.certificate(),
            "analytic_constants": records, "ordered_ab": [list(a) for a in ordered],
            "strict_adjacent_gaps": gaps,
            "baseline_variance": baseline.certificate(),
            "conditional_profile_variances": {name: value.certificate() for name, value in variances.items()},
            "analytic_enclosures": "unconditional elementary periodic-series bounds",
            "real_zero_exclusion": "K(chi)<4 plus classical completed-L Hadamard identity excludes real nontrivial zeros",
            "thirteen_distinct_model_laws": "conditional on the signed-zero model identification",
            "not_certified": ["GRH/LI", "actual prime limiting law", "individual zero data",
                              "zero completeness", "numerical sign density", "originality"]}


def self_checks():
    """Independent Fraction arithmetic checks, never floating-point or zero data."""
    F = Fraction
    values = [F(-5, 3), F(-1, 7), F(0), F(1, 7), F(3, 2)]
    checks = 0
    for a, b in product(values, repeat=2):
        ia, ib = Interval.rational(a.numerator, a.denominator), Interval.rational(b.numerator, b.denominator)
        operations = [(ia + ib, a + b), (ia - ib, a - b), (ia * ib, a * b)]
        if b:
            operations.append((ia / ib, a / b))
        for value, exact in operations:
            assert F(value.lo, SCALE) <= exact <= F(value.hi, SCALE)
            checks += 1
        squared = ia.square()
        assert F(squared.lo, SCALE) <= a * a <= F(squared.hi, SCALE)
    try:
        Interval.rational(1) / Interval(-SCALE, SCALE)
    except ValueError:
        pass
    else:
        raise AssertionError("zero-containing denominator accepted")

    def atanh_log(u, terms=60):
        total = 2 * sum((u ** (2*k+1) / (2*k+1) for k in range(terms)), F(0))
        tail = 2*u**(2*terms+1)/((2*terms+1)*(1-u*u))
        return total, total + tail
    log2_lo, log2_hi = atanh_log(F(1, 3))
    assert F(LOG2.lo, SCALE) <= log2_lo <= log2_hi <= F(LOG2.hi, SCALE)
    for n in (1, 3, 5, 15, 15000, GAMMA_CUTOFF, GAMMA_CUTOFF+1):
        k = n.bit_length()-1
        u = F(n-(1<<k), n+(1<<k))
        lo, hi = atanh_log(u)
        reference_lo, reference_hi = lo+k*log2_lo, hi+k*log2_hi
        dyadic = log_rational(n)
        assert F(dyadic.lo, SCALE) <= reference_lo <= reference_hi <= F(dyadic.hi, SCALE)
    def atan_fraction(d, terms):
        x = F(1, d)
        partial = sum(((-1)**k*x**(2*k+1)/(2*k+1) for k in range(terms)), F(0))
        next_term = (-1)**terms*x**(2*terms+1)/(2*terms+1)
        return min(partial, partial+next_term), max(partial, partial+next_term)
    a_lo, a_hi = atan_fraction(5, 48)
    b_lo, b_hi = atan_fraction(239, 8)
    pi, gamma = fundamental_constants()
    assert F(pi.lo, SCALE) <= 16*a_lo-4*b_hi <= 16*a_hi-4*b_lo <= F(pi.hi, SCALE)
    harmonic = sum((F(1, n) for n in range(1, GAMMA_CUTOFF+1)), F(0))
    def integer_log_fraction(n):
        k = n.bit_length()-1
        lo, hi = atanh_log(F(n-(1<<k), n+(1<<k)))
        return lo+k*log2_lo, hi+k*log2_hi
    log_m_lo, _ = integer_log_fraction(GAMMA_CUTOFF)
    _, log_mp1_hi = integer_log_fraction(GAMMA_CUTOFF+1)
    assert F(gamma.lo, SCALE) <= harmonic-log_mp1_hi <= harmonic-log_m_lo <= F(gamma.hi, SCALE)
    for a, b in REPS:
        q = (3 if a else 1)*(5 if b else 1)
        units = [n for n in range(1, q+1) if gcd(n, q) == 1]
        for n, m in product(units, repeat=2):
            x, y = character(n, a, b), character(m, a, b)
            z = (x[0]*y[0]-x[1]*y[1], x[0]*y[1]+x[1]*y[0])
            assert character(n*m, a, b) == z
        for divisor in range(1, q):
            if q % divisor == 0:
                assert any(n % divisor == m % divisor and character(n,a,b) != character(m,a,b)
                           for n,m in product(units,repeat=2))
    return {"fraction_operation_comparisons": checks, "independent_log_rational_checks": 8,
            "fraction_machin_pi_and_harmonic_gamma_checks": "PASS",
            "character_homomorphism_and_primitive_conductors": "PASS",
            "zero_containing_denominator": "rejected"}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--cutoff", type=int, default=15000)
    group = parser.add_mutually_exclusive_group()
    group.add_argument("--check", action="store_true", help="compare deterministic committed certificate")
    group.add_argument("--write", action="store_true", help="write deterministic certificate explicitly")
    args = parser.parse_args()
    report = certify(args.cutoff)
    report["arithmetic_self_checks"] = self_checks()
    rendered = json.dumps(report, indent=2, sort_keys=True) + "\n"
    fixture = Path(__file__).with_name("spectral_constants_certificate_20261012.json")
    if args.write:
        fixture.write_text(rendered, encoding="utf-8", newline="")
    if args.check and (not fixture.exists() or fixture.read_bytes() != rendered.encode("utf-8")):
        raise SystemExit("FAIL: committed spectral constant certificate differs from exact recomputation")
    print(rendered, end="")


if __name__ == "__main__":
    main()
