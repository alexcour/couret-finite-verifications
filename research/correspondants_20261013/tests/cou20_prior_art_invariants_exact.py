#!/usr/bin/env python3
"""COU-20: exact arithmetic cross-checks, NOT a universal proof or Lean certificate.

Compares a published Brown (2009) instance with Moenius (2021), and
the first differing trace / characteristic-polynomial coefficient.
Directed Cayley supports; loops and multiplicities of closed walks included.
Only Python standard library; no floating-point arithmetic.
"""
from __future__ import annotations


def trace_powers(n: int, support: set[int], maximum: int) -> list[int]:
    counts = {0: 1}
    traces = [n]
    for _ in range(maximum):
        next_counts = {}
        for x, multiplicity in counts.items():
            for s in support:
                y = (x + s) % n
                next_counts[y] = next_counts.get(y, 0) + multiplicity
        counts = next_counts
        traces.append(n * counts.get(0, 0))
    return traces


def newton_coefficients(traces: list[int]) -> list[int]:
    """Return c_j of det(XI-A)=X^n+c_1 X^(n-1)+..., j<=len(traces)-1."""
    c = [1]
    for j in range(1, len(traces)):
        numerator = sum(c[j - i] * traces[i] for i in range(1, j + 1))
        assert numerator % j == 0
        c.append(-numerator // j)
    return c


def test_odd_quotient(q: int) -> None:
    assert q % 2 == 1 and q % 3 == 0
    n, h, a, d, k = 2 * q, q, 1, q // 3, q // 3
    source = {a % n, (a + d) % n, (a + d + h) % n}
    target = {a % n, (a - d) % n, (a - d + h) % n}
    assert len(source) == len(target) == 3
    p_source, p_target = trace_powers(n, source, k), trace_powers(n, target, k)
    c_source, c_target = newton_coefficients(p_source), newton_coefficients(p_target)
    assert all(p_source[j] == p_target[j] for j in range(1, k))
    assert all(c_source[j] == c_target[j] for j in range(1, k))
    assert abs(p_source[k] - p_target[k]) == n * 3 ** ((k - 1) // 2)
    assert abs(c_source[k] - c_target[k]) == 6 * 3 ** ((k - 1) // 2)
    print(f"ODD q={q}, n={n}, k={k}, trace_delta={p_source[k]-p_target[k]}, "
          f"charpoly_coeff_delta={c_source[k]-c_target[k]}: PASS")


def test_even_quotient(q: int) -> None:
    assert q % 2 == 0 and q % 3 == 0
    n, h, a, d = 2 * q, q, 1, q // 3
    source = {a % n, (a + d) % n, (a + d + h) % n}
    target = {a % n, (a - d) % n, (a - d + h) % n}
    limit = min(5, q // 3 + 2)
    p_source, p_target = trace_powers(n, source, limit), trace_powers(n, target, limit)
    assert p_source == p_target
    assert newton_coefficients(p_source) == newton_coefficients(p_target)
    print(f"EVEN q={q}, n={n}, first_{limit}_trace_and_coeff: PASS")


def test_brown_moenius_mod12() -> None:
    brown_s, brown_t = {1, 5, 11}, {1, 3, 9}
    moenius_s, moenius_t = {5, 7, 11}, {3, 9, 11}
    assert {7 * x % 12 for x in brown_s} == moenius_s
    assert {11 * x % 12 for x in brown_t} == moenius_t
    assert pow(7, -1, 12) == 7 and pow(11, -1, 12) == 11
    print("Brown example 3.1 -> Moenius example 3.1.13 by units 7,11 modulo 12: PASS")


def test_moenius_thm3_necessary_hypothesis_mod12() -> None:
    """Test just the modulo-n/p congruence required to invoke Moenius Thm 3.

    It is NOT a necessary condition for cospectrality, and failing it does
    not mean that no other theorem or other graph presentation could apply.
    """
    from math import gcd

    n, p = 12, 2
    brown_s, brown_t = {1, 5, 11}, {1, 3, 9}
    units = tuple(u for u in range(n) if gcd(u, n) == 1)
    assert units == (1, 5, 7, 11)
    modulus = n // p
    s_reduced = {x % modulus for x in brown_s}
    candidates = {u: {u * x % modulus for x in brown_t} for u in units}
    assert s_reduced == {1, 5}
    assert candidates == {
        1: {1, 3}, 5: {3, 5}, 7: {1, 3}, 11: {3, 5}
    }
    assert all(value != s_reduced for value in candidates.values())
    print("Moenius 2020 Theorem 3 congruence modulo n/2=6 "
          "fails for Brown n=12 pair: PASS")


def test_moenius_theorem3_brown_family_finite() -> None:
    """Finite replays of the symbolic mod-n/2 obstruction for Brown's p=3 family.

    The *general* proof (for every r>=2) is elementary divisibility
    and documented separately in the prior-art report; this loop is
    evidence only for the displayed finite values.
    """
    from math import gcd

    for r in range(2, 11):
        t = 2 ** (r - 1)
        n, reduced_modulus = 6 * t, 3 * t
        reduced_source = {1, 1 + 2 * t}
        reduced_target = {1, 1 + t}
        for m in range(n):
            if gcd(m, n) == 1:
                assert {m * x % reduced_modulus for x in reduced_target} != (
                    reduced_source
                )
    print("Moenius Theorem 3 modulo-n/2 obstruction: Brown family r=2..10 PASS")


if __name__ == "__main__":
    test_brown_moenius_mod12()
    test_moenius_thm3_necessary_hypothesis_mod12()
    test_moenius_theorem3_brown_family_finite()
    for quotient_order in (3, 9, 15, 21, 27):
        test_odd_quotient(quotient_order)
    for quotient_order in (6, 12):
        test_even_quotient(quotient_order)
    print("All exact checks passed; no claim of exhaustive or universal proof.")
