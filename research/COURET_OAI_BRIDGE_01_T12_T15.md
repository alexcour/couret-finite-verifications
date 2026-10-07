# COURET–OAI–BRIDGE–01 — T12–T15 primorial divisor architecture

> **RESEARCH BRANCH — NOT PART OF v1.0.0 — NO RH CLAIM — NOT PEER REVIEWED**
>
> These statements identify the minimal finite state space naturally associated with a truncated reciprocal Euler product. The point is structural: the dynamic inverse polynomial is controlled by prime support, not by residue class modulo 30.

## T12 — periodicity obstruction

Fix a scale (yge2). Define the squarefree (y)-smooth support indicator

[
sigma_y(n)
=
egin{cases}
1,& 	ext{every prime divisor of }n	ext{ is }le y	ext{ and }n	ext{ is squarefree},\
0,& 	ext{otherwise}.
end{cases}
]

### Theorem T12

There is no function (w_y:U(30)	omathbb C) such that

[
sigma_y(n)=w_y(nmod 30)
]

for every integer (n) coprime to 30.

### Elementary proof

Let

[
P_y=prod_{ple y}p
]

and set

[
N=1+30P_y.
]

Then

[
Nequiv1pmod{30}.
]

Moreover, if a prime (rle y) divided (N), then (rmid P_y), hence

[
Nequiv1pmod r,
]

a contradiction. Therefore every prime divisor of (N) is (>y).

Thus

[
1equiv Npmod{30},
]

but

[
sigma_y(1)=1,
qquad
sigma_y(N)=0.
]

So (sigma_y) is not determined by the residue class modulo 30. (square)

### Consequence

No purely periodic mod-30 weight can represent the support of a truncated reciprocal Euler product.

A dynamic inverse polynomial therefore requires state information about **prime factorization/support**, not merely a residue-class state.

---

## T13 — exact primorial divisor formula for the truncated inverse

Let

[
P_y(q)
=
prod_{substack{ple y\p
mid q}}p.
]

For a Dirichlet character (chi) modulo (q), define

[
Q_y(s,chi)
=
prod_{substack{ple y\p
mid q}}
(1-chi(p)p^{-s}).
]

Because (P_y(q)) is squarefree, expanding the Euler product gives

[
oxed{
Q_y(s,chi)
=
sum_{dmid P_y(q)}
rac{mu(d)chi(d)}{d^s}.
}
]

### Proof

Each prime (ple y), (p
mid q), contributes a binary choice:

- choose (1);
- choose (-chi(p)p^{-s}).

A subset (S) of the allowed primes contributes

[
(-1)^{|S|}
prod_{pin S}chi(p)p^{-s}
=
rac{mu(d_S)chi(d_S)}{d_S^s},
qquad
d_S=prod_{pin S}p.
]

The subsets (S) are in bijection with divisors (dmid P_y(q)). (square)

---

## T14 — the natural finite state space is a Boolean divisor lattice

Let

[
mathcal P_y(q)
=
{ple y:p
mid q}.
]

Every divisor (dmid P_y(q)) is uniquely determined by a bit vector

[
arepsilon=(arepsilon_p)_{pinmathcal P_y(q)}
in
{0,1}^{|mathcal P_y(q)|},
]

where

[
d(arepsilon)=prod_p p^{arepsilon_p}.
]

Thus the exact finite state space for (Q_y) is

[
oxed{
operatorname{Div}(P_y(q))
cong
{0,1}^{|mathcal P_y(q)|}.
}
]

The coefficient factorizes coordinatewise:

[
rac{mu(d)chi(d)}{d^s}
=
prod_{pinmathcal P_y(q)}
left(-chi(p)p^{-s}ight)^{arepsilon_p}.
]

Equivalently,

[
Q_y(s,chi)
=
igotimes_{pinmathcal P_y(q)}
left(1-chi(p)p^{-s}ight)
]

in the elementary tensor/product sense.

### Structural interpretation

The prime coordinates are **binary local states**: absent/present.

This is fundamentally different from the unit group

[
U(P_y).
]

The unit group records residues invertible modulo the primorial. The divisor lattice records **which Euler factors have been selected**.

For inverse Euler products, the second object is the native one.

---

## T15 — reinterpretation of the Couret primorial tower

The historical Couret program emphasized levels such as

[
30, 210, 2310, 30030,ldots
]

through unit groups (U(P)), residue transport, and finite character spaces.

T13–T14 suggest a second, distinct primorial tower:

[
oxed{
operatorname{Div}(30)
hookrightarrow
operatorname{Div}(210)
hookrightarrow
operatorname{Div}(2310)
hookrightarrowcdots
}
]

where each new prime adds one binary coordinate.

For example:

[
30=2cdot3cdot5
]

gives the Boolean cube

[
operatorname{Div}(30)cong{0,1}^3.
]

Passing to

[
210=2cdot3cdot5cdot7
]

adds one coordinate:

[
operatorname{Div}(210)cong{0,1}^4.
]

### Important distinction

This divisor-lattice tower is not a replacement for the unit-group tower.

They encode different information:

- (U(P)): character/residue symmetry;
- (operatorname{Div}(P)): selected local Euler factors / prime support.

The analytic inverse polynomial naturally couples them:

[
	ext{character }chi
quad+quad
	ext{prime-subset state }dmid P_y
quadlongmapstoquad
mu(d)chi(d)d^{-s}.
]

This yields a more plausible two-layer finite architecture:

[
oxed{
	ext{residue/character layer}
	imes
	ext{prime-support Boolean layer}.
}
]

---

## Comparison with OpenAI

OpenAI's proof explicitly uses inverse polynomials with ideal Möbius coefficients, permitted/selected prime factors, and separate moment estimates for inverse and plain polynomials. Its refined stage uses selected prime factors as part of the compensated row-count argument.

T13–T15 do **not** reproduce that proof. They identify the finite combinatorial skeleton that any truncated inverse Euler product already possesses.

The significant conceptual correction for Couret–Unification is:

> The primorial object relevant to reciprocal (L)-functions is not only the group of units modulo the primorial. It is also — and more directly — the Boolean lattice of divisors of the primorial.

This may explain why a residue-only model repeatedly reached an Euler bridge obstruction.

---

## New research object

Define the two-layer state space at scale (y):

[
mathcal X_y(q)
=
widehat{U(m)}
	imes
operatorname{Div}(P_y(q)),
]

where (m) is the fixed or slowly varying residue modulus used for the character-routing layer.

A state ((psi,d)) carries weight

[
mu(d)(chipsi)(d)d^{-s}.
]

This is only a proposed organizational object. The next question is whether it supports a nontrivial transform or recursion that **shortens scale** or improves a moment estimate.

Without such a second representation, it remains bookkeeping.

---

## Stop condition

If the two-layer architecture provides only exact factorization/bookkeeping and no scale-reducing identity or new uniform estimate, it should be retained as an explanatory model but **not** promoted as an analytic mechanism.

## Epistemic status

- T12: **[D] elementary periodicity obstruction**.
- T13: **[D] exact finite Euler-product expansion**.
- T14: **[D] exact Boolean-lattice identification**.
- T15 reinterpretation: **[I] structural interpretation**, not a new analytic theorem.
- Two-layer state space (mathcal X_y(q)): **[O] research construction**.
- Any power saving from that state space: **[O]**.
