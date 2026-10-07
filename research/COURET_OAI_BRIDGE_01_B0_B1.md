# COURET–OAI–BRIDGE–01 — B0–B1 finite Dirichlet multiplexer

> **RESEARCH BRANCH ONLY — NO RH CLAIM — NOT PART OF v1.0.0 — NO NOVELTY CLAIM.**

## Result

The finite character-routing layer is now formalized in Lean 4.

### B0 — exact inversion

For any commutative integral domain (R) with enough roots of unity for (U(30)), define

[
\widehat w(\chi)
=
\sum_{b\in U(30)}
w(b)\,\chi(b^{-1}).
]

Lean proves, for every (a\in U(30)),

[
\varphi(30)\,w(a)
=
\sum_{\chi\bmod 30}
\widehat w(\chi)\,\chi(a).
]

This is `u30_dirichlet_fourier_inversion`.

### B1 — weighted finite sums

For every finite family of coefficients (c_i) and residues (r_i\in U(30)),

[
\varphi(30)
\sum_i c_i w(r_i)
=
\sum_{\chi\bmod30}
\widehat w(\chi)
\sum_i c_i\chi(r_i).
]

This is `u30_weighted_sum_multiplex`.

## Interpretation

A fixed weight on the eight units modulo 30 is exactly a finite linear router of the
Dirichlet-character channels. This statement is now mechanically verified.

It does **not** yet say that a channel equals (1/L(s,\chi)), because that identification
requires a Dirichlet-series argument and a region of absolute convergence. B0–B1 therefore
close the finite algebraic layer without crossing the analytic boundary.

## Formal status

- Lean 4.34.1 / Mathlib v4.34.1.
- Zero-sorry.
- Direct source re-elaboration.
- Transitive axiom audit: only `propext`, `Classical.choice`, `Quot.sound`.
- Validation run: `bridge01-lean` `37684125579` — **SUCCESS**.
- Extended audit: 48 public declarations.
- Research branch only; `main` unchanged.
