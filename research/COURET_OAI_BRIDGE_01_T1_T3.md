# COURET–OAI–BRIDGE–01 — T1–T3 exact statements

> **RESEARCH BRANCH — NOT PART OF v1.0.0 — NO RH CLAIM — NOT PEER REVIEWED**
>
> Status of this note: elementary finite/group-theoretic and normed-space derivations. Novelty is **not** claimed. Lean formalization is still open.

## Conventions

Let

[
G=U(30)={1,7,11,13,17,19,23,29},
qquad |G|=8.
]

For a function (w:G	omathbb C) and a character (psiinwidehat G), define

[
widehat w(psi)=sum_{ain G}w(a)overline{psi(a)}.
]

Then Fourier inversion is

[
w(a)=rac1{8}sum_{psiinwidehat G}widehat w(psi)psi(a).
]

All statements below use this convention.

---

## T1 — finite twist decomposition

### Theorem T1

Let (I) be a finite index set. For each (iin I), let (c_iinmathbb C) and (r_iin G). Then for every (w:G	omathbb C),

[
oxed{
sum_{iin I}c_i,w(r_i)
=
rac1{8}
sum_{psiinwidehat G}
widehat w(psi)
sum_{iin I}c_i,psi(r_i).
}
]

### Proof

Substitute Fourier inversion into the left-hand side:

[
sum_i c_i w(r_i)
=
sum_i c_i
left(
rac1{8}sum_psi widehat w(psi)psi(r_i)
ight).
]

Both sums are finite, so they may be interchanged:

[
=
rac1{8}
sum_psi
widehat w(psi)
sum_i c_ipsi(r_i).
]

This is the claimed identity. (square)

### Arithmetic specialization

For any finite smoothed or truncated arithmetic sum supported on integers coprime to 30, take

[
c_n=mu(n)chi(n)W(n/X)
]

or any other coefficient sequence. Then the (w)-weighted sum is exactly a finite linear combination of the eight character-twisted sums.

For Dirichlet series with (Re(s)>1), absolute convergence permits the same finite character decomposition with (c_n=mu(n)chi(n)n^{-s}). Passing from imprimitive characters to primitive inducing characters requires the usual finite Euler-factor corrections.

### Interpretation

T1 is a routing identity. It reorganizes a weighted sum into finitely many character channels. It supplies no cancellation estimate by itself.

---

## T2 — exact inverse of the Couret triplet filter

Let

[
T_C={1,11,29}
]

and write in the group algebra

[
A=delta_1+delta_{11}+delta_{29}.
]

The multiplicative closure of (T_C) is the Klein four subgroup

[
K_4={1,11,19,29},
]

with

[
11^2=29^2=19^2=1,
qquad
11cdot29=19.
]

Thus (19) is the unique element of (K_4setminus T_C), i.e. the previously identified closure residue.

### Theorem T2

In (mathbb Q[G]),

[
oxed{
A^{-1}
=
rac13
left(
delta_1+delta_{11}+delta_{29}-2delta_{19}
ight).
}
]

Equivalently,

[
oxed{
Aleft(A-2delta_{19}ight)=3delta_1.
}
]

### Proof

Set

[
a=11,qquad b=29,qquad c=19=ab.
]

Inside (K_4), all three nonidentity elements are involutions and (ac=b), (bc=a). Hence

[
A^2
=
(delta_1+delta_a+delta_b)^2
=
3delta_1+2(delta_a+delta_b+delta_c).
]

Also

[
Adelta_c
=
delta_c+delta_{ac}+delta_{bc}
=
delta_c+delta_b+delta_a.
]

Therefore

[
A(A-2delta_c)
=
A^2-2Adelta_c
=
3delta_1.
]

Division by (3) gives the inverse formula. (square)

### Fourier form

The eight Fourier multipliers of (A) are, up to the fixed ordering of characters,

[
{3,3,1,1,1,1,-1,-1}.
]

Therefore no multiplier vanishes.

Since (T_C=T_C^{-1}), convolution by (A) is self-adjoint for the counting inner product. Its singular values are

[
3,3,1,1,1,1,1,1.
]

Hence

[
oxed{
|f|_2
le
|A*f|_2
le
3|f|_2.
}
]

The inverse satisfies (|A^{-1}|_{2	o2}=1), while (|A|_{2	o2}=3).

### New structural interpretation of the residue 19

The element (19) is not merely the missing closure element of (T_C). It is exactly the corrective term required to invert the (T_C) convolution filter:

[
A^{-1}=rac13(A-2delta_{19}).
]

This is an exact finite identity. No global arithmetic or RH interpretation follows from it.

---

## T3 — fixed invertible transforms preserve asymptotic exponents

The correct statement is deliberately more general than mod 30.

### Theorem T3

Let (E) be a normed vector space and let (L:E	o E) be a bounded invertible linear map whose inverse is bounded. Let (F(X)in E) be any family, and let (g(X)>0).

Then

[
oxed{
|F(X)|=O(g(X))
iff
|L F(X)|=O(g(X)).
}
]

The same equivalence holds with (o(g(X))) in place of (O(g(X))).

### Proof

Boundedness gives

[
|LF(X)|
le
|L|,|F(X)|.
]

Thus an (O(g)) or (o(g)) bound for (F) implies the same bound for (LF).

Conversely,

[
F(X)=L^{-1}LF(X),
]

so

[
|F(X)|
le
|L^{-1}|,|LF(X)|.
]

This gives the reverse implication. (square)

### Corollary T3-Couret

Let (M(X)inmathbb C^8) be the vector of eight residue-class sums modulo 30, and let (C_{T_C}) be convolution by (1_{T_C}). Then for every exponent (alpha),

[
oxed{
|M(X)|_2=O(X^alpha)
iff
|C_{T_C}M(X)|_2=O(X^alpha).
}
]

Likewise for little-o estimates.

Thus the **complete eight-channel translated Couret-filter output** cannot have a better polynomial growth exponent than the original eight-channel residue vector merely because the fixed filter was applied.

---

## Essential caveat — what T3 does NOT say

T3 does **not** imply that every single scalar Couret-weighted sum has the same exponent as every original residue sum.

A single coordinate or scalar functional such as

[
sum_{ain T_C} M_a(X)
]

is a projection from (mathbb C^8) to (mathbb C), not an invertible transformation. A special scalar combination may cancel a leading component.

Therefore the correct no-go is:

> **No exponent gain can arise from the full fixed invertible 8-channel transform itself.**

A scalar (T_C)-weighted channel could exhibit extra cancellation, but any such gain must come from a genuine arithmetic relation among the character-twisted sums, not from invertibility/Fourier algebra alone.

This distinction is mandatory in all later uses of T3.

---

## Consequence for the OpenAI comparison

OpenAI's analytic machinery is not a fixed finite-dimensional change of basis. Its reflection/Poisson steps alter analytic scale and shorten ranges; its moment and large-sieve estimates then yield a power saving.

T1–T3 therefore isolate the exact boundary:

[
	ext{finite character routing}
quad	ext{vs.}quad
	ext{genuine scale-changing analytic cancellation}.
]

If a Couret-specific improvement exists, it must enter beyond T1–T3 through a scale-dependent or conductor-dependent construction, a noninvertible but mathematically justified projection, or an analytic transform that supplies new cancellation.

## Epistemic status

- T1: **[D] elementary finite Fourier identity**.
- T2: **[D] elementary exact group-algebra identity**, finite verification to be attached.
- T3: **[D] elementary normed-space theorem**.
- Lean encoding of T1–T3: **[O]**.
- Couret-specific asymptotic gain: **[O]**.
- Any implication for a zero-free region: **not established**.
