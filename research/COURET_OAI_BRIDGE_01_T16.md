# COURET–OAI–BRIDGE–01 — T16 explicit inverse, abstract no-gain, and Lean A0–A2

> **RESEARCH BRANCH — NOT PART OF v1.0.0 — NO RH CLAIM — NOT PEER REVIEWED**
>
> Status: exact finite/group-algebra derivation plus an abstract asymptotic consequence. Novelty is **not** claimed. Lean formalization remains to be compiled and audited separately.

## T16.1 — explicit inverse of the Couret kernel

Let

[
G=U(30)={1,7,11,13,17,19,23,29}.
]

Write in the group algebra over a characteristic-zero field

[
	au=delta_1+delta_{11}+delta_{29}.
]

Inside (G),

[
11^2equiv 29^2equiv 19^2equiv 1pmod{30},
qquad
11cdot 29equiv 19pmod{30}.
]

Thus ({1,11,19,29}) is a Klein four subgroup. Define

[
sigma
=
rac13
left(
delta_1+delta_{11}+delta_{29}-2delta_{19}

ight).
]

Then

[
(delta_1+delta_{11}+delta_{29})
(delta_1+delta_{11}+delta_{29}-2delta_{19})
=
3delta_1,
]

because, writing (b=11), (c=29), (d=19=bc),

[
(1+b+c)^2=3+2b+2c+2d
]

and

[
(1+b+c)d=d+c+b.
]

Therefore

[
oxed{	ausigma=sigma	au=delta_1}.
]

Hence convolution by (	au) is invertible, with inverse convolution by (sigma).

### Exact inverse certificate

[
oxed{
	au^{-1}
=
rac13
(delta_1+delta_{11}+delta_{29}-2delta_{19})
}
]

This gives an algebraic certificate of invertibility that does not require Fourier diagonalization.

---

## T16.2 — abstract no-gain theorem

Let (E) be a normed vector space and let

[
T:E	o E
]

be a continuous linear equivalence. For any family (F:X	o E), any comparison function (g:X	o Y) valued in a seminormed space, and any filter (l),

[
Tcirc F = O_l(g)
quadLongleftrightarrowquad
F = O_l(g).
]

The forward direction uses boundedness of (T^{-1}); the reverse direction uses boundedness of (T).

For the fixed Couret kernel (T=C_{T_C}), this yields

[
oxed{
C_{T_C}F = O_l(g)
iff
F = O_l(g).
}
]

In particular, for any exponent (alpha),

[
|C_{T_C}F(X)|=O(X^alpha)
quadLongleftrightarrowquad
|F(X)|=O(X^alpha).
]

### Interpretation

A fixed invertible modulus-30 filter can reorganize, route, or reweight information, but it cannot by itself improve the global asymptotic exponent of a full finite-dimensional state vector.

This falsifies only the mechanism

[
	ext{fixed invertible filter} Longrightarrow 	ext{new power saving}.
]

It does **not** falsify the use of (T_C) as a finite spectral diagnostic, a character router, or an exact finite certificate.

---

## T16.3 — relation to the previously computed Fourier spectrum

The previously established spectrum

[
{3,3,1,1,1,1,-1,-1}
]

is compatible with the explicit inverse above: every Fourier multiplier is nonzero.

On the mean-zero subspace, the trivial (3)-eigenvalue is removed, leaving

[
{3,1,1,1,1,-1,-1}.
]

The Fourier calculation remains useful for interpretation and sharp (ell^2) distortion bounds; the explicit inverse is preferable as a compact algebraic certificate.

---

## T16.4 — Lean formalization plan

The first Lean milestone should be split into three independent targets.

### A0 — generic no-gain

Target file:

`BRIDGE01_A0_GenericNoGain.lean`

Goal: prove the Big-O equivalence for a `ContinuousLinearEquiv`.

Mathlib already exposes the relevant asymptotic comparison lemmas through the continuous-linear-equivalence API, so this layer should contain no number theory.

### A1 — exact inverse in (U(30))

Target file:

`BRIDGE01_A1_U30KernelInverse.lean`

Goal: encode (U(30)), the elements (11,29,19), the kernel (	au), the explicit inverse (sigma), and prove

[
	ausigma=1.
]

Preferred proof strategy: exact finite arithmetic / group-algebra normalization, with no analytic dependencies.

### A2 — fixed-modulus no-gain

Target file:

`BRIDGE01_A2_FixedModulusNoGain.lean`

Goal: instantiate A0 with convolution by (	au), using A1 to build the inverse.

Target theorem:

[
oxed{
C_{T_C}F = O_l(g)
iff
F = O_l(g)
}
]

for arbitrary families (F).

---

## T16.5 — corrected research status

- **[D]** explicit algebraic inverse of the modulus-30 kernel.
- **[D]** invertibility of convolution by (T_C).
- **[D]** nonzero Fourier spectrum.
- **[D]** preservation of asymptotic Big-O classes under the fixed invertible filter.
- **[F]** “fixed invertible modulus-30 filter alone produces a new asymptotic exponent”.
- **[D-math]** A0–A2 compiled zero-sorry under Lean 4.34.1 / Mathlib v4.34.1; reference CI run for the complete chain: `bridge01-lean` run `37674743493`.
- **[O]** analytic closure under conductor-changing / Poisson / theta-type transformations.
- **[O]** independent novelty and literature audit.

## Boundary

This note does not claim a proof of the Riemann hypothesis, a new zero-free region, or a reproduction of OpenAI's (7/8) theorem. It records a limitation theorem for the fixed finite modulus-30 layer.


## Lean closure update — 2026-10-07

The A0–A2 chain is now mechanically compiled on the research branch.

- A0: generic Big-O invariance under a continuous linear equivalence — **[D-math]**.
- A1: explicit inverse certificate for the (U(30)) kernel — **[D-math]**.
- A2: real eight-coordinate realization, coefficient sup norm transported from (U(30)\to\mathbb R), multiplication by (	au) promoted to a continuous linear equivalence, and fixed-modulus no-gain theorem — **[D-math]**.
- Complete-chain CI: `bridge01-lean` run `37674743493` — **SUCCESS**.
- No `sorry` is used in A0, A1, or A2.

A2 is deliberately realized over (mathbb R), rather than (mathbb Q), because the Mathlib finite-dimensional continuity promotion used here requires the scalar field to be complete. This changes no finite algebraic identity of the (U(30)) kernel.

## Reproducible A0–A2 audit

A0–A2 were rebuilt and each source was re-elaborated under the locked Lean/Mathlib
environment at source commit `36206a0484fc97b6fdaeb98f2e0f11cf261040ee`.
[bridge01-lean #12](https://github.com/alexcour/couret-finite-verifications/actions/runs/37677075770)
completed successfully, including the clean-build and transitive axiom audit.

A2 now derives the real inverse laws from the rational A1 theorems through the
coefficient ring homomorphism `rationalToReal`. Its coordinate convolution and
inverse formulas are also checked. The full real coefficient vector carries the
transported sup norm.

The audit covers 45 public declarations and permits exactly `propext`,
`Classical.choice` and `Quot.sound`; it reports no `sorryAx` or new axiom.
Exact source hashes, package commits, imported-module closures and direct constant
dependencies are recorded in [the validation report](lean/VALIDATION.md) and its
evidence files. The change remains on the research branch; `main` was not modified.
**NO RH CLAIM.**
