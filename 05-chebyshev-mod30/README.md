# Chebyshev bias mod 30 — finite measurements

## Status

- residue classes and counts at the stated cutoffs: **exact finite computation**;
- first-order equidistribution: classical prime number theorem in arithmetic progressions;
- residual prime-race interpretation: the Rubinstein–Sarnak framework, **conditional on GRH
  and linear independence of the relevant zero ordinates**.

No novelty claim is made.

## Finite measurements

The reduced residue classes mod 30 are
`{1,7,11,13,17,19,23,29}`. Their quadratic residues within this group are `{1,19}`.

Define

`D(X) = pi(X; six non-squares) - 3*pi(X; two squares)`.

The supplied script reproduces:

| X | D(X) |
|---:|---:|
| 100,000 | 65 |
| 1,000,000 | 115 |
| 10,000,000 | 524 |

Thus `D(X)` is positive and increases **across these three selected checkpoints**. No global
monotonicity is asserted. At `10^7`, the two least-populated classes are 1 and 19, the two
quadratic-residue classes.

The elementary twin-admissibility check gives lower classes `{11,17,29}`, corresponding to
pairs `11/13`, `17/19`, `29/1` modulo 30.

## Historical-source caution

The finite mod-30 computation stands independently of any manuscript attribution. Statements
about what a historical manuscript specifically claims should be supported by a separately
archived source identifier/page image before they are used as provenance evidence.

## File

`verify_chebyshev.py` — blocking assertions. Requires SymPy 1.14.0.
