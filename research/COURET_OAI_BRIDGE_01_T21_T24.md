# COURET–OAI–BRIDGE–01 — T21–T24 residue-packet transfer operators

> **RESEARCH BRANCH — NOT PART OF v1.0.0 — NO RH CLAIM — NOT PEER REVIEWED**

## T21 — prime-adjoining transfer on residue packets

Let (P) be squarefree and coprime to 30. Define, for (rin U(30)),

[
A_P(r)
=
sum_{substack{dmid P\dequiv r (30)}}
rac{mu(d)chi(d)}{d^s}.
]

Let (p
mid 30Pq) be prime and set (P'=Pp).

Every divisor of (P') is either (d) or (pd), (dmid P). Therefore

[
A_{P'}(r)
=
A_P(r)
-
chi(p)p^{-s}
A_P(p^{-1}r),
]

where (p^{-1}) is taken in (U(30)).

Define the permutation operator

[
(mathsf P_p f)(r)=f(p^{-1}r).
]

Then

[
oxed{
A_{Pp}
=
left(I-chi(p)p^{-s}mathsf P_pight)A_P.
}
]

This is an exact finite transfer law.

---

## T22 — simultaneous diagonalization by the mod-30 characters

Each (mathsf P_p) is a permutation/unitary operator on (mathbb C^{U(30)}). The characters diagonalize it:

[
mathsf P_ppsi
=
psi(p)^{-1}psi
]

up to the chosen left/right convention.

Hence the transfer operator

[
mathsf T_p(s,chi)
=
I-chi(p)p^{-s}mathsf P_p
]

is diagonal in the character basis.

Its character multiplier is, up to the same convention,

[
oxed{
1-(chipsi)(p)p^{-s}.
}
]

Therefore the product over primes gives exactly

[
A_{P_y}
=
prod_{ple y}
mathsf T_p(s,chi),A_1,
]

and on character channel (psi),

[
oxed{
widehat{A_{P_y}}(psi)
=
prod_{ple y}
left(1-(chipsi)(p)p^{-s}ight)
widehat{A_1}(psi).
}
]

This is the residue-packet form of the truncated reciprocal Euler product.

---

## T23 — exact singular values and conditioning

Because (mathsf P_p) is unitary and diagonalized by characters, the singular values of (mathsf T_p(s,chi)) are

[
oxed{
left|
1-(chipsi)(p)p^{-s}
ight|,
qquad
psiinwidehat{U(30)}.
}
]

Thus the full primorial transfer has singular values

[
oxed{
prod_{ple y}
left|
1-(chipsi)(p)p^{-s}
ight|.
}
]

For real (s=sigma>0),

[
1-p^{-sigma}
le
left|1-(chipsi)(p)p^{-sigma}ight|
le
1+p^{-sigma}.
]

Consequently,

[
prod_{ple y}(1-p^{-sigma})
le
sigma_{min}(mathsf T_{le y})
le
sigma_{max}(mathsf T_{le y})
le
prod_{ple y}(1+p^{-sigma}),
]

after omission of primes at which the characters vanish.

### Interpretation

This gives an exact conditioning mechanism for the dynamic residue-packet evolution.

- For (sigma>1), both bounding Euler products converge to finite positive limits, so the transfer remains uniformly well-conditioned.
- For (0<sigmale1), the lower product tends to zero, so uniform invertibility can fail.

This recovers T18 at the operator level and shows precisely how the dynamic primorial system escapes the fixed-filter no-go.

---

## T24 — why this is still not Poisson

The transfer law

[
A_{Pp}
=
(I-alpha_pmathsf P_p)A_P
]

with (alpha_p=chi(p)p^{-s}) is exact and scale-dependent, but it is still diagonal in the same finite character basis.

Therefore it does not mix frequencies, create a dual length, or shorten an external sum.

It is a multiplicative Euler recursion, not a duality transform.

### Consequence

The two-layer Couret architecture now has an exact dynamic operator theory:

[
	ext{prime support growth}
longleftrightarrow
	ext{product of residue permutations}
longleftrightarrow
	ext{Euler factors on character channels}.
]

But the step corresponding to OpenAI's genuine analytic gain remains absent:

[
oxed{
	ext{a second representation that changes scale and enables a power-saving estimate}.
}
]

---

## New target after T24

The next nontrivial target is to introduce a **length variable** (X) in addition to the prime-support scale (y), for example through smoothed sums

[
S_{psi}(X,y)
=
sum_n
mu(n)psi(n)
W(n/X)
mathbf 1_{{pmid nRightarrow ple y}},
]

or a related truncated-inverse polynomial.

Then one must seek a second exact/controlled representation that transforms (X) nontrivially.

Without an (Xmapsto X^ast) or conductor/range tradeoff, the current machinery remains an exact Euler bookkeeping system.

## Epistemic status

- T21: **[D] exact divisor-partition recursion**.
- T22: **[D] exact character diagonalization**.
- T23: **[D] exact singular-value formula + elementary bounds**.
- T24: **[I] structural interpretation/no-go**.
- Any scale-changing dual representation: **[O]**.
