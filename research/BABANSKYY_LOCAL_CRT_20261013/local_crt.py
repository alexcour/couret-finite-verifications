"""Exact implementation of Oleksiy Babanskyy's local lifting construction.

Source: correspondence of 2026-10-13, 09:35:31 Europe/Paris (NR13-O).
Classical background: Mahatab--Sampath, arXiv:1401.7696v3.
No Ramanujan sums, floating point, symbolic algebra, or Fourier inversion here.
Coordinates: X -> yz, y^t=z^p=1, t=2**a. Coefficients are Python integers
or fractions.Fraction; finite arithmetic is in Z, not a truncated p-adic field.
"""

from fractions import Fraction
from itertools import product
from math import isqrt


def parameters(n):
    """Accept precisely n=2**a*p, a>=0, p an odd prime."""
    if not isinstance(n, int) or n < 3:
        raise ValueError("n must be 2**a times an odd prime")
    t, p, a = 1, n, 0
    while p % 2 == 0:
        t, p, a = 2*t, p//2, a+1
    if p < 3 or any(p % q == 0 for q in range(2, isqrt(p)+1)):
        raise ValueError("odd part must be prime")
    return t, p, a


def orders(n):
    _, p, a = parameters(n)
    return sorted(2**j*e for e in (1, p) for j in range(a+1))


def sign_choices(n):
    ds = orders(n)
    for bits in product((1, -1), repeat=len(ds)-1):
        yield dict(zip(ds, (1,)+bits))


def source_vector(n, support):
    f = [0]*n
    for s in set(support):
        if not isinstance(s, int) or not 0 <= s < n:
            raise ValueError("support must contain residues in [0,n)")
        f[s] = 1
    return f


def residue(f, j, e):
    """F(y,z) mod (Phi_(2**j)(y), Phi_e(z)), in monomial bases.

    Rows are y coefficients; columns are z coefficients. For j=0, y=1.
    For j>=1, Phi_(2**j)=y**h+1, h=2**(j-1). For e=p,
    z**(p-1)=-(1+z+...+z**(p-2)); e=1 means z=1.
    """
    h, width = (1 if j == 0 else 2**(j-1)), (1 if e == 1 else e-1)
    out = [[0]*width for _ in range(h)]
    for s, coefficient in enumerate(f):
        if not coefficient:
            continue
        u, ysign = (0, 1) if j == 0 else (s % h, (-1)**(s//h))
        v = s % e
        if e == 1:
            out[u][0] += coefficient*ysign
        elif v == e-1:
            for k in range(width):
                out[u][k] -= coefficient*ysign
        else:
            out[u][v] += coefficient*ysign
    return out


def signed_residues(f, signs):
    n = len(f)
    _, p, a = parameters(n)
    if set(signs) != set(orders(n)) or any(s not in (-1, 1) for s in signs.values()):
        raise ValueError("one sign +/-1 is required for each divisor")
    return {(j, e): [[signs[2**j*e]*v for v in row] for row in residue(f, j, e)]
            for e in (1, p) for j in range(a+1)}


def lift(P, Q):
    """Babanskyy step: H=(P+Q)/2+y**h*(P-Q)/2; keep exact fractions."""
    if len(P) != len(Q) or not P or any(len(row) != len(P[0]) for row in P+Q):
        raise ValueError("equal nonempty rectangular coefficient arrays required")
    return ([[Fraction(x+y, 2) for x, y in zip(u, v)] for u, v in zip(P, Q)]
            + [[Fraction(x-y, 2) for x, y in zip(u, v)] for u, v in zip(P, Q)])


def two_local(data, p, a):
    """Recursive parity check in both odd blocks; report first failing level.

    Stops a block at its first failure. Each successful H, not its original
    residue, is fed into the next level. All preceding arrays are integral.
    """
    failures = []
    for e in (1, p):
        P = data[0, e]
        for j in range(1, a+1):
            Q = data[j, e]
            bad = [(u, v) for u in range(len(P)) for v in range(len(P[0]))
                   if (P[u][v]-Q[u][v]) % 2]
            if bad:
                failures.append({"odd_block": e, "level": j, "positions": bad})
                break
            P = [[int(x) for x in row] for row in lift(P, Q)]
    return not failures, failures


def odd_local(data, p, a):
    """Gluing alpha at z=1 to beta mod Phi_p: alpha=beta(1) mod p.

    Apply in every y-order block. These blocks split over Z_(p), because
    p does not divide 2**a. No 2-local admissibility is assumed.
    """
    failures = []
    for j in range(a+1):
        alpha, beta = data[j, 1], data[j, p]
        bad = [u for u in range(len(alpha)) if (alpha[u][0]-sum(beta[u])) % p]
        if bad:
            failures.append({"level": j, "positions": bad})
    return not failures, failures


def reconstruct(data, n):
    """Rational polynomial CRT reconstruction, also for inadmissible tuples."""
    t, p, a = parameters(n)
    blocks = {}
    for e in (1, p):
        P = data[0, e]
        for j in range(1, a+1):
            P = lift(P, data[j, e])
        blocks[e] = P
    alpha, beta = blocks[1], blocks[p]
    vector = [Fraction(0)]*n
    for u in range(t):
        delta = Fraction(alpha[u][0]-sum(beta[u]), p)
        for v in range(p):
            coefficient = delta + (beta[u][v] if v < p-1 else 0)
            # Unique s with s mod t=u and s mod p=v (X -> yz).
            s = u + t*((v-u)*pow(t, -1, p) % p)
            vector[s] = coefficient
    return vector


def analyze(f, signs):
    n = len(f)
    _, p, a = parameters(n)
    data = signed_residues(f, signs)
    at_two, two_failures = two_local(data, p, a)
    at_p, p_failures = odd_local(data, p, a)
    return {"at_2": at_two, "at_p": at_p,
            "failures_2": two_failures, "failures_p": p_failures,
            "coefficients": reconstruct(data, n)}
