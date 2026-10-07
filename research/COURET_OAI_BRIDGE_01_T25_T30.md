# COURET–OAI–BRIDGE–01 — T25–T30 scale recursion and prime compensation

> **RESEARCH BRANCH — NOT PART OF v1.0.0 — NO RH CLAIM — NOT PEER REVIEWED**
>
> This note introduces an external length scale X and studies the first exact X-changing recursion. It also isolates a toy prime-compensation operator whose Mellin multiplier has a prescribed simple zero. This is a structural comparison only; it is not the OpenAI compensation argument.

## T25 — exact X-shortening recursion

Let P be squarefree and let psi be a Dirichlet character. For a test function W on (0,infinity), define

S_{P,psi}(X)
=
sum_{d|P} mu(d) psi(d) W(d/X).

Let p be prime with p not dividing P. Then every divisor of Pp is uniquely d or pd with d|P. Since mu(pd)=-mu(d) when p does not divide d,

[
oxed{
S_{Pp,psi}(X)
=
S_{P,psi}(X)
-
psi(p)S_{P,psi}(X/p).
}
]

### Proof

Split the divisor sum into the divisors not containing p and those containing p:

S_{Pp,psi}(X)
=
sum_{d|P} mu(d)psi(d)W(d/X)
+
sum_{d|P} mu(pd)psi(pd)W(pd/X).

Using mu(pd)=-mu(d), multiplicativity of psi, and

W(pd/X)=W(d/(X/p)),

gives the formula.

### Interpretation

This is the first exact relation in the bridge program that genuinely changes the external length variable:

[
X longmapsto X/p.
]

But it is still inclusion-exclusion on the divisor cube. A shorter argument does not automatically mean a better estimate.

---

## T26 — Mellin representation of the smoothed divisor sum

Assume W is smooth and compactly supported in (0,infinity), and define its Mellin transform

[
widetilde W(s)
=
int_0^infty W(x)x^{s-1},dx.
]

Mellin inversion gives

[
W(d/X)
=
rac{1}{2pi i}
int_{(c)}
widetilde W(s)X^s d^{-s},ds
]

for any admissible vertical line.

Since the divisor sum is finite,

[
oxed{
S_{P,psi}(X)
=
rac{1}{2pi i}
int_{(c)}
widetilde W(s)X^s
prod_{p|P}
left(1-psi(p)p^{-s}ight)
,ds.
}
]

Thus T25 is diagonalized by Mellin transform: the scale difference

F(X)-psi(p)F(X/p)

corresponds to multiplication by

[
1-psi(p)p^{-s}.
]

### Important limitation

T26 is a second exact representation, but not yet a dual summation formula. It does not replace a long sum by a genuinely different short-frequency sum; it merely diagonalizes the same inclusion-exclusion recursion.

---

## T27 — compensated prime difference and exact main-term annihilation

Fix a real beta and define, for a character eta and prime p,

[
mathcal C_{p,eta,eta}F(X)
=
F(X)
-
eta(p)p^eta F(X/p).
]

On a Mellin mode X^s, the multiplier is

[
oxed{
m_{p,eta,eta}(s)
=
1-eta(p)p^{eta-s}.
}
]

If eta(p)=1, then

[
m_{p,eta,eta}(eta)=0.
]

Equivalently,

[
oxed{
mathcal C_{p,eta,eta}(X^eta)=0
qquad	ext{when }eta(p)=1.
}
]

Thus a selected prime lying in the kernel of the target character gives an exact finite-difference operator that kills a prescribed power-law main term.

---

## T28 — compensation reveals a remainder; it does not manufacture one

Assume, uniformly in the range under consideration,

[
F(X)
=
cX^eta
+
O(X^{eta-delta})
]

for some delta>0.

If eta(p)=1, then

[
mathcal C_{p,eta,eta}F(X)
=
Oleft(
X^{eta-delta}
+
p^eta (X/p)^{eta-delta}
ight).
]

Hence

[
oxed{
mathcal C_{p,eta,eta}F(X)
=
Oleft(
(1+p^delta)X^{eta-delta}
ight).
}
]

For fixed p, the compensated expression retains the same power saving delta after the main term is removed.

If p is allowed to grow with X and

[
ple X^kappa
qquad(0lekappa<1),
]

then

[
oxed{
mathcal C_{p,eta,eta}F(X)
=
Oleft(
X^{eta-delta(1-kappa)}
ight).
}
]

### Consequence

Prime compensation can cancel a known main term, but the surviving power saving comes from a pre-existing estimate on the remainder.

The size of the selected prime consumes part of the exponent margin if p grows with X.

This is a necessary accounting rule for any Couret-style compensation experiment.

---

## T29 — finite annihilation of several power-law main terms

Suppose

[
F(X)
=
sum_{j=1}^m c_jX^{eta_j}
+
R(X).
]

Choose fixed primes p_j with eta_j(p_j)=1 and define commuting compensation operators

[
mathcal C_j
=
I-p_j^{eta_j}D_{p_j},
qquad
(D_pF)(X)=F(X/p).
]

Then

[
oxed{
left(prod_{j=1}^mmathcal C_jight)
X^{eta_k}
=
0
quad
	ext{for every }k.
}
]

Indeed, the factor j=k annihilates the kth power mode.

Therefore

[
oxed{
left(prod_jmathcal C_jight)F
=
left(prod_jmathcal C_jight)R.
}
]

For fixed selected primes, any power-saving estimate for R survives up to a constant depending on the finite prime set.

### Interpretation

Selected-prime compensation is naturally an annihilator of a finite list of known Mellin/power modes. It is not, by itself, a source of cancellation in the unknown remainder.

---

## T30 — local affine Mellin factor

Assume eta(p)=1. The Mellin multiplier of T27 is

[
m_{p,eta}(s)
=
1-p^{eta-s}.
]

Writing h=s-beta,

[
p^{eta-s}
=
e^{-hlog p}.
]

Hence near s=beta,

[
1-p^{eta-s}
=
(s-eta)log p
+
Oleft(
(s-eta)^2(log p)^2
ight).
]

Therefore

[
oxed{
rac{1-p^{eta-s}}{log p}
=
(s-eta)
+
Oleft(
(s-eta)^2log p
ight).
}
]

### Structural comparison with OpenAI

The OpenAI quasi-RH proof uses normalized Mellin signals with affine factors

[
C_{mathrm I}(s)=s-rac23,
qquad
C_{mathrm{II}}(s)=s-rac{11}{16},
]

and its refined second stage introduces selected-prime compensation plus scalar normalization.

T30 shows that a selected-prime finite difference provides an elementary mechanism that produces a simple Mellin zero and locally linearizes to an affine factor s-beta.

This is **not** an identification of the two constructions. OpenAI's factors arise inside a completed theta/Poisson/residue calculation with asymmetric scales and moment estimates. T30 is only a one-dimensional toy analogue of the local Mellin algebra.

---

## Updated bridge picture

The current chain is now:

1. divisor support gives the exact inverse-polynomial coefficients;
2. adding p gives the exact recursion X -> X/p;
3. Mellin diagonalizes that recursion by the Euler factor 1-psi(p)p^{-s};
4. a rescaled selected-prime difference can annihilate a prescribed Mellin/power mode;
5. the surviving estimate still requires independent control of the remainder.

Thus the genuinely hard step remains:

[
oxed{
	ext{prove a nontrivial uniform estimate for the compensated remainder}.
}
]

That is where moment estimates, large-sieve input, or a true dual transform would have to enter.

## Next target

Define a compensated two-scale family

[
S^{mathrm{comp}}_{psi}(X,y)
]

by applying one or more T27 operators to S_{P_y,psi}(X).

Then study its second moment over characters and split it into:

- diagonal terms;
- off-diagonal congruent-divisor terms;
- compensation cross-terms.

The next falsifiable question is whether compensation creates a **centered off-diagonal form** whose main contribution cancels before any large-sieve estimate is applied.

## Epistemic status

- T25: [D] exact finite divisor recursion.
- T26: [D] standard Mellin inversion applied to a finite sum.
- T27: [D] exact finite-difference identity.
- T28: [D] elementary propagation of an assumed remainder bound.
- T29: [D] finite annihilation identity.
- T30: [D] local Taylor expansion / structural comparison.
- Any new power saving from compensation: [O].
- Equality with OpenAI's prime-compensation mechanism: not claimed.
