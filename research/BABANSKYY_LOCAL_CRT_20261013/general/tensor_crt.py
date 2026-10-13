"""Prime-power tensor implementation of classical integral cyclotomic CRT.

The q=2 lifting/reinjection construction is attributed to Oleksiy Babanskyy
(correspondence 2026-10-13). The q-ary block formula is an implementation of
the classical prime-power matrix in Mahatab--Sampath, Lemma 2.5. No originality
or collaboration acceptance is asserted. This module is independent of
Ramanujan sums and of the first, special-family implementation.

Coordinates: X -> product(y_i), y_i^(q_i^a_i)=1, for distinct prime factors.
Finite exact arithmetic only; integer residues and fractions.Fraction.
"""
from dataclasses import dataclass
from fractions import Fraction
from itertools import product
from math import prod


def factor(n):
    if not isinstance(n, int) or isinstance(n, bool) or n < 1:
        raise ValueError('positive integer modulus required')
    out, q = [], 2
    while q*q <= n:
        a = 0
        while n % q == 0:
            n //= q
            a += 1
        if a:
            out.append((q, a))
        q += 1
    if n > 1:
        out.append((n, 1))
    return tuple(out)


def level_grid(factors):
    return product(*(range(a+1) for q, a in factors))


def order_at(factors, levels):
    return prod(q**k for (q, a), k in zip(factors, levels))


def degree(q, k):
    return 1 if k == 0 else (q-1)*q**(k-1)


def monomial(s, q, k):
    """y**s modulo Phi_(q**k), in the canonical monomial basis."""
    if k == 0:
        return ((0, 1),)
    h = q**(k-1)
    u = s % (q*h)
    if u < (q-1)*h:
        return ((u, 1),)
    r = u % h
    return tuple((r+i*h, -1) for i in range(q-1))


@dataclass
class Polynomial:
    shape: tuple
    coefficients: dict

    def value(self, index):
        return self.coefficients.get(index, 0)

    def signed(self, sign):
        return Polynomial(self.shape, {index: sign*v for index, v in self.coefficients.items()})


def residue(f, factors, levels):
    shape = tuple(degree(q, k) for (q, a), k in zip(factors, levels))
    coefficients = {}
    for s, v in enumerate(f):
        if not v:
            continue
        choices = [monomial(s, q, k) for (q, a), k in zip(factors, levels)]
        for terms in product(*choices):
            index = tuple(u for u, c in terms)
            value = v*prod(c for u, c in terms)
            coefficients[index] = coefficients.get(index, 0)+value
    return Polynomial(shape, {index: v for index, v in coefficients.items() if v})


def prime_lift(P, Q, axis, q):
    """Canonical q-ary inverse of the prime-power reduction matrix.

    Q=sum(i=0..q-2) y**(i*h) Q_i, deg Q_i<h.
    D=(P-sum Q_i)/q. H_i=Q_i+D for i<q-1; H_(q-1)=D.
    For q=2 this is exactly Babanskyy's displayed formula.
    Also return indices where the divisibility condition fails.
    """
    h = P.shape[axis]
    expected = list(P.shape)
    expected[axis] = (q-1)*h
    if tuple(expected) != Q.shape:
        raise ValueError('incompatible prime-power block shapes')
    shape = list(P.shape)
    shape[axis] = q*h
    out, bad = {}, []
    for index in product(*(range(v) for v in P.shape)):
        qs = []
        for i in range(q-1):
            shifted = list(index)
            shifted[axis] += i*h
            qs.append(Q.value(tuple(shifted)))
        D = Fraction(P.value(index)-sum(qs), q)
        if D.denominator != 1:
            bad.append(index)
        for i in range(q):
            shifted = list(index)
            shifted[axis] += i*h
            value = D + (qs[i] if i < q-1 else 0)
            if value:
                out[tuple(shifted)] = value
    return Polynomial(tuple(shape), out), bad


class Plan:
    """Precompute source residues, then analyze order-constant sign tuples."""
    def __init__(self, f):
        if not f or any(not isinstance(x, int) for x in f):
            raise ValueError('nonempty integer source vector required')
        self.f, self.n = tuple(f), len(f)
        self.factors = factor(self.n)
        self.levels = tuple(level_grid(self.factors))
        self.orders = tuple(sorted(order_at(self.factors, lev) for lev in self.levels))
        self.residues = {lev: residue(f, self.factors, lev) for lev in self.levels}

    def signs(self):
        for values in product((1, -1), repeat=len(self.orders)-1):
            yield dict(zip(self.orders, (1,)+values))

    def signed(self, signs):
        if set(signs) != set(self.orders) or any(v not in (1, -1) for v in signs.values()):
            raise ValueError('exactly one sign +/-1 per divisor is required')
        return {lev: P.signed(signs[order_at(self.factors, lev)]) for lev, P in self.residues.items()}

    def local(self, data, axis):
        q, a = self.factors[axis]
        failures = []
        other_axes = [i for i in range(len(self.factors)) if i != axis]
        other_ranges = [range(self.factors[i][1]+1) for i in other_axes]
        for others in product(*other_ranges):
            lev = [0]*len(self.factors)
            for i, k in zip(other_axes, others):
                lev[i] = k
            P = data[tuple(lev)]
            for k in range(1, a+1):
                lev[axis] = k
                H, bad = prime_lift(P, data[tuple(lev)], axis, q)
                if bad:
                    failures.append({'prime': q, 'level': k,
                                     'other_levels': others, 'positions': bad})
                    break
                # A successful integral H must be retained at the next level.
                P = Polynomial(H.shape, {index: int(v) for index, v in H.coefficients.items()})
        return not failures, failures

    def reconstruct(self, data, axes=None):
        axes = tuple(range(len(self.factors))) if axes is None else tuple(axes)
        if sorted(axes) != list(range(len(self.factors))):
            raise ValueError('each prime-power axis must be folded once')
        current = data
        for axis in axes:
            q, a = self.factors[axis]
            collapsed = {}
            for base in current:
                if base[axis] != 0:
                    continue
                lev = list(base)
                P = current[base]
                for k in range(1, a+1):
                    lev[axis] = k
                    P, _ = prime_lift(P, current[tuple(lev)], axis, q)
                collapsed[base] = P
            current = collapsed
        H = current[(0,)*len(self.factors)]
        moduli = tuple(q**a for q, a in self.factors)
        # Enumeration s -> (s mod q_i**a_i) implements the inverse group CRT
        # exactly, without solving a floating-point system.
        return [Fraction(H.value(tuple(s % m for m in moduli))) for s in range(self.n)]

    def analyze(self, signs, axes=None):
        data = self.signed(signs)
        at, failures = {}, {}
        for axis, (q, a) in enumerate(self.factors):
            at[q], failures[q] = self.local(data, axis)
        return {'at_primes': at, 'failures': failures,
                'coefficients': self.reconstruct(data, axes)}
