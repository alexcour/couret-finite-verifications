"""COU-20 exact checks of Newton's recurrence (NOT a Lean theorem).

Dependencies: Python >=3.10, sympy. Run this in the tests directory:
    python cou20_newton_exact.py
The calculations use exact integer matrix operations, not floats.
All adjacency matrices remain directed, with possible loops.
"""
import sympy as sp
from cou20_sanity_exact import add, neg, adj

CASES = [
    ((6,), (1,), (1,), (3,)),
    ((12,), (1,), (2,), (6,)),
    ((18,), (1,), (3,), (9,)),
    ((9, 2), (1, 0), (3, 0), (0, 1)),
]

def test_matrix(M, extra=4):
    n = M.rows
    coeffs = M.charpoly().all_coeffs()
    assert coeffs[0] == 1
    traces = [sp.Integer(n)]
    power = sp.eye(n)
    for k in range(1, n + extra + 1):
        power = power * M
        traces.append(power.trace())
        c = lambda j: coeffs[j] if j <= n else sp.S.Zero
        residual = traces[k] + sum(
            c(j) * traces[k - j] for j in range(1, k)
        ) + k * c(k)
        assert residual == 0, (n, k, residual)
    return traces

def main():
    for mods, a, d, h in CASES:
        source = [a, add(a, d, mods), add(add(a, d, mods), h, mods)]
        md = neg(d, mods)
        target = [a, add(a, md, mods), add(add(a, md, mods), h, mods)]
        A, B = adj(mods, source), adj(mods, target)
        powersA = test_matrix(A)
        powersB = test_matrix(B)
        if A.charpoly() == B.charpoly():
            assert powersA == powersB
        else:
            assert powersA != powersB
        print("PASS", mods, "N", A.rows, "same-charpoly",
              A.charpoly() == B.charpoly(), "exponents", A.rows + 4)
    print("PASS: all exact matrix Newton recurrence checks")

if __name__ == "__main__":
    main()
