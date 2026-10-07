# COURET–OAI–BRIDGE–01 — T16–T20 prime recursion and exact moment bridge

> **RESEARCH BRANCH — NOT PART OF v1.0.0 — NO RH CLAIM — NOT PEER REVIEWED**
>
> This note develops the two-layer architecture
> character/residue × prime-support/divisor lattice.
> The main new point is an exact second-moment identity coupling the two layers. No novelty claim is made.

## T16 — exact prime-adjoining recursion on the divisor cube

Let (P) be squarefree and let (p
mid Pq) be prime. For a Dirichlet character (chi) modulo (q), define on divisors (dmid P)

[
v_P(d;s,chi)=rac{mu(d)chi(d)}{d^s}.
]

For (P'=Pp), every divisor of (P') is uniquely either (d) or (pd) with (dmid P). Therefore

[
v_{P'}(d)=v_P(d),
]

and

[
v_{P'}(pd)
=
-chi(p)p^{-s}v_P(d).
]

Hence, under the identification

[
operatorname{Div}(Pp)
cong
operatorname{Div}(P)	imes{0,1},
]

the coefficient vector factorizes exactly as

[
oxed{
v_{Pp}
=
v_Potimes
left(1,-chi(p)p^{-s}ight).
}
]

Summing all coordinates gives the Euler recursion

[
oxed{
Q_{Pp}(s,chi)
=
left(1-chi(p)p^{-s}ight)Q_P(s,chi).
}
]

### Interpretation

Adding one prime adds one binary support coordinate. This is an exact tensor recursion, but by itself it is only factorization/bookkeeping.

---

## T17 — exact prime-removal contraction

Define

[
R_p:
mathbb C^{operatorname{Div}(Pp)}
longrightarrow
mathbb C^{operatorname{Div}(P)}
]

by

[
(R_pf)(d)=f(d)+f(pd).
]

Applied to the special Euler coefficient vector,

[
R_pv_{Pp}
=
left(1-chi(p)p^{-s}ight)v_P.
]

Thus whenever

[
1-chi(p)p^{-s}
eq0,
]

one recovers (v_P) from this special vector by normalized contraction:

[
oxed{
v_P
=
rac{1}{1-chi(p)p^{-s}}
R_pv_{Pp}.
}
]

### Important caveat

As a linear map on the full divisor-space, (R_p) is dimension-reducing and noninvertible. On the one-dimensional tensor family (v_{Pp}), however, it merely removes a known local factor.

Therefore this exact recursion does **not** yet play the role of Poisson/reflection: it reduces a support coordinate but does not produce a new estimate or shorten an external arithmetic summation range.

---

## T18 — conditioning transition of the trivial Euler channel

Take the trivial character and real (s=sigma>0). Then

[
Q_y(sigma,1)
=
prod_{ple y}(1-p^{-sigma}),
]

up to omission of any fixed finite set of primes.

### Theorem T18

If (sigma>1),

[
Q_y(sigma,1)
longrightarrow
rac1{zeta(sigma)}>0.
]

If (0<sigmale1),

[
oxed{
Q_y(sigma,1)longrightarrow0.
}
]

### Proof of the second assertion

For (0<sigmale1),

[
sum_p p^{-sigma}
]

diverges, because (p^{-sigma}ge p^{-1}) and Euler's sum of reciprocal primes diverges.

Using

[
log(1-x)le -x
qquad(0<x<1),
]

we obtain

[
log Q_y(sigma,1)
=
sum_{ple y}log(1-p^{-sigma})
le
-sum_{ple y}p^{-sigma}
	o-infty.
]

Hence (Q_y(sigma,1)	o0). (square)

### Interpretation

The accumulated normalized prime-removal factor

[
Q_y(sigma,1)^{-1}
]

loses uniform boundedness precisely once one enters (sigmale1).

This is the classical absolute-Euler-product boundary, not a new zero-free result.

It shows that the dynamic divisor architecture escapes the uniformly-well-conditioned no-go only where the ordinary Euler product itself becomes analytically delicate.

---

## T19 — exact two-layer second-moment bridge

Now let (P) be squarefree and coprime to 30. Let (c_dinmathbb C) be arbitrary coefficients for (dmid P).

For each residue (rin U(30)), define the residue packet

[
A_r
=
sum_{substack{dmid P\dequiv r (30)}}c_d.
]

For each character (psiinwidehat{U(30)}), define the twisted divisor sum

[
Q(psi)
=
sum_{dmid P}c_dpsi(d).
]

Then

[
Q(psi)
=
sum_{rin U(30)}A_rpsi(r).
]

By Parseval on the finite group (U(30)),

[
oxed{
rac18
sum_{psiinwidehat{U(30)}}
|Q(psi)|^2
=
sum_{rin U(30)}|A_r|^2.
}
]

### Möbius/Euler specialization

Take

[
c_d
=
rac{mu(d)chi(d)}{d^s}
]

for any auxiliary character (chi) for which the expression is defined.

Then T19 gives an exact identity between:

- a second moment over the eight mod-30 twists (chipsi);
- the (L^2) energy of Möbius-weighted divisor packets grouped by residue modulo 30.

This is the first exact theorem in the bridge program that **couples the character layer and the prime-support layer nontrivially**.

### Equivalent orthogonality form

Expanding the left-hand side and using character orthogonality gives

[
rac18sum_psi |Q(psi)|^2
=
sum_{substack{d,emid P\dequiv e (30)}}
c_doverline{c_e}.
]

Thus the moment problem becomes a signed/complex weighted congruent-divisor-pair problem on the Boolean support lattice.

---

## T20 — exact role of the Couret triplet inside the dynamic second moment

Let (A=(A_r)_{rin U(30)}) be the residue packet vector from T19, and let

[
C_{T_C}A
=
1_{T_C}*A.
]

Fourier diagonalization gives

[
widehat{C_{T_C}A}(psi)
=
widehat{1_{T_C}}(psi),Q(psi)
]

up to the fixed conjugation convention, irrelevant after taking absolute values.

Therefore

[
oxed{
|C_{T_C}A|_2^2
=
rac18
sum_{psi}
|widehat{1_{T_C}}(psi)|^2
|Q(psi)|^2.
}
]

Since

[
|widehat{1_{T_C}}(psi)|^2in{1,9},
]

we obtain the exact comparison

[
oxed{
rac18sum_psi |Q(psi)|^2
le
|C_{T_C}A|_2^2
le
9left(
rac18sum_psi |Q(psi)|^2
ight).
}
]

Equivalently,

[
oxed{
|A|_2^2
le
|C_{T_C}A|_2^2
le
9|A|_2^2.
}
]

### Interpretation

After enriching the model with the correct prime-support layer, the fixed Couret triplet has a precise role:

> it reweights the exact second moment of dynamic inverse-polynomial packets by fixed factors (1) or (9).

It still cannot create a new scale exponent.

Therefore any Couret-specific power saving must arise from a **nonseparable interaction** between residue/character structure and scale-dependent prime support, not from applying the fixed (T_C) convolution after the divisor packets have been formed.

---

## Why T19 matters for the OpenAI comparison

OpenAI's proof relies on moment estimates for inverse and plain polynomials over character families.

T19 does not reproduce those estimates. It supplies a finite exact analogue of the first algebraic step:

[
	ext{moment over twists}
longleftrightarrow
	ext{energy of residue-grouped prime-support packets}.
]

The missing step remains an estimate strong enough to beat the diagonal/trivial scale and produce a power saving.

This gives a sharper target than before:

[
oxed{
	ext{control the off-diagonal congruent-divisor pairs}
}
]

or find a transform that reorganizes them into a shorter/dual problem.

That is the first place where the two-layer Couret architecture could, in principle, become analytically useful.

---

## Next target

Define

[
mathcal E_{30}(P;c)
=
sum_{rin U(30)}
left|
sum_{substack{dmid P\dequiv r (30)}}c_d
ight|^2.
]

For Möbius/Euler coefficients (c_d), split

[
mathcal E_{30}
=
mathcal D+mathcal O,
]

where

[
mathcal D=sum_{dmid P}|c_d|^2
]

is the diagonal contribution and

[
mathcal O
=
sum_{substack{d
e e\dequiv e (30)}}
c_doverline{c_e}
]

is the off-diagonal contribution.

The next falsifiable question is whether the Couret structure yields any nontrivial control of (mathcal O) beyond generic character orthogonality.

## Epistemic status

- T16: **[D] exact tensor recursion**.
- T17: **[D] exact contraction identity**.
- T18: **[D] classical Euler-product conditioning transition**.
- T19: **[D] exact finite Parseval/orthogonality identity**.
- T20: **[D] exact bounded Couret reweighting of the dynamic second moment**.
- Any power saving for the off-diagonal term: **[O]**.
- Any identification with OpenAI's analytic moment bounds: **not claimed**.
