# COURET–OAI–BRIDGE–01 — T36–T41 cross-scale correlation and marked-prime operators

> **RESEARCH BRANCH — NOT PART OF v1.0.0 — NO RH CLAIM — NOT PEER REVIEWED**
>
> This note identifies the exact quantity that controls whether selected-prime compensation helps: cross-scale correlation. It also separates the behavior of plain and Möbius/inverse polynomials under prime marking.

## T36 — coefficient form of the compensated packet

Let (a_ninmathbb C), and for (rin U(30)) define

[
A_r(X)
=
sum_{substack{nge1\nequiv r (30)}}
a_n W(n/X),
]

where (W) is a fixed test function.

For (pequiv1pmod{30}), define

[
B_r(X)
=
A_r(X)-p^eta A_r(X/p).
]

Then exactly

[
oxed{
B_r(X)
=
sum_{nequiv r (30)}
a_n
left[
W(n/X)-p^eta W(pn/X)
ight].
}
]

Thus compensation changes the weight inside each residue packet but does not mix residue classes.

---

## T37 — disjoint-window obstruction to coefficientwise cancellation

Assume

[
operatorname{supp}Wsubset[A,B]
qquad
(0<A<B<infty).
]

Then

[
W(t)
eq0
implies
tin[A,B],
]

whereas

[
W(pt)
eq0
implies
tin[A/p,B/p].
]

If

[
oxed{
p>B/A,
}
]

these intervals are disjoint.

Hence for every fixed index (n), at most one of

[
W(n/X),qquad W(pn/X)
]

is nonzero.

### Consequence

For a standard dyadic window supported in ([1,2]), every prime (pge3) gives disjoint coefficient ranges.

Therefore the compensation

[
A(X)-p^eta A(X/p)
]

does **not** create pointwise coefficient cancellation in that regime.

Its possible gain must come from correlation between two different scale blocks, not from cancellation of the same coefficient.

---

## T38 — exact compensated energy identity

Let

[
A(X)=(A_r(X))_{rin U(30)}
]

and define

[
E(X)=|A(X)|_2^2.
]

Set

[
C_p(X)
=
langle A(X),A(X/p)angle
=
sum_r
A_r(X)overline{A_r(X/p)}.
]

For

[
B(X)=A(X)-p^eta A(X/p),
]

one has exactly

[
oxed{
|B(X)|_2^2
=
E(X)
+
p^{2eta}E(X/p)
-
2p^etaRe C_p(X).
}
]

By Cauchy–Schwarz,

[
|C_p(X)|
le
sqrt{E(X)E(X/p)}.
]

Therefore

[
oxed{
left(
sqrt{E(X)}
-
p^etasqrt{E(X/p)}
ight)^2
le
|B(X)|_2^2
le
left(
sqrt{E(X)}
+
p^etasqrt{E(X/p)}
ight)^2.
}
]

### Interpretation

Selected-prime centering helps only to the extent that the two packet vectors at scales (X) and (X/p) are phase-aligned/correlated.

If they are nearly orthogonal, the compensated energy is approximately the **sum** of the two scale energies, not a saving.

---

## T39 — normalized cross-scale correlation is the decisive statistic

Whenever (E(X)E(X/p)
eq0), define

[
ho_p(X)
=
rac{C_p(X)}
{sqrt{E(X)E(X/p)}}.
]

Then

[
|ho_p(X)|le1,
]

and

[
oxed{
|B(X)|_2^2
=
E(X)+p^{2eta}E(X/p)
-
2p^eta
sqrt{E(X)E(X/p)}
Reho_p(X).
}
]

If

[
A(X)=X^eta M+R(X)
]

with a common vector profile (M), then the leading pieces satisfy

[
A(X/p)sim p^{-eta}A(X),
]

so (ho_p(X)	o1) at the main-profile level and T33 cancels that component.

Thus the real analytic problem after centering is:

[
oxed{
	ext{control the cross-scale correlation of the remainder.}
}
]

A compensation experiment should therefore report (E(X)), (E(X/p)), and (ho_p(X)), not only the final compensated norm.

---

## T40 — a first difference exactly sieves the plain polynomial

Define the smoothed plain character polynomial

[
P_psi(X)
=
sum_{nge1}psi(n)W(n/X).
]

Let (p) be a prime with (psi(p)
eq0). Then

[
psi(p)P_psi(X/p)
=
sum_{substack{mge1\pmid m}}
psi(m)W(m/X).
]

Hence

[
oxed{
P_psi(X)
-
psi(p)P_psi(X/p)
=
sum_{substack{nge1\p
mid n}}
psi(n)W(n/X).
}
]

So a single scale difference removes **all multiples of p** from the plain polynomial exactly.

For (pequiv1pmod{30}), this same operator works uniformly for all eight mod-30 characters.

### Mellin form

The corresponding Mellin multiplier is

[
1-psi(p)p^{-s},
]

exactly the local Euler factor.

---

## T41 — the inverse/Möbius polynomial requires a scale resolvent, not one difference

Define

[
M_psi(X)
=
sum_{nge1}mu(n)psi(n)W(n/X).
]

A single first difference does not simply remove the multiples of p, because the Möbius coefficients already contain the p-local inclusion–exclusion.

Instead define the scale resolvent

[
oxed{
mathcal R_{p,psi}
=
sum_{jge0}
psi(p)^jD_p^j,
qquad
(D_pF)(X)=F(X/p).
}
]

For compactly supported (W), this sum is pointwise finite for fixed (X).

Then one has the exact coefficient identity

[
oxed{
(mathcal R_{p,psi}M_psi)(X)
=
sum_{substack{nge1\p
mid n}}
mu(n)psi(n)W(n/X).
}
]

### Coefficient proof

Fix (m=p^kv) with (p
mid v).

The coefficient of (W(m/X)) in the resolvent is

[
sum_{j=0}^k
psi(p)^j
mu(m/p^j)psi(m/p^j).
]

If (k=0), this is simply (mu(m)psi(m)).

If (kge1), only the terms (j=k-1) and (j=k) can be nonzero, and they cancel exactly because

[
mu(pv)=-mu(v).
]

Thus every coefficient with (pmid m) vanishes.

### Mellin form

On Mellin modes,

[
mathcal R_{p,psi}
quad	ext{has multiplier}quad
rac{1}{1-psi(p)p^{-s}}.
]

This cancels the p-local Euler factor already present in the Möbius reciprocal series.

---

## Structural consequence: plain and inverse polynomials react differently to prime marking

The plain polynomial satisfies

[
oxed{
	ext{remove p-multiples}
=
(I-psi(p)D_p)P_psi.
}
]

The inverse/Möbius polynomial satisfies

[
oxed{
	ext{remove p-multiples}
=
(I-psi(p)D_p)^{-1}M_psi
}
]

in the scale-operator sense above.

This asymmetry is important.

OpenAI's refined argument requires separate moment estimates for a plain polynomial and an inverse polynomial with Möbius coefficients. T40–T41 give an elementary structural reason, in the one-dimensional Dirichlet setting, why prime marking interacts differently with those two species.

This is only an analogy and not an identification with the OpenAI proof.

---

## Next falsifiable experiment

For the packet vectors built from the two polynomial types:

1. compute the cross-scale correlation (ho_p(X));
2. compare before and after p-marking;
3. use primes (pequiv1pmod{30}) for uniform eight-channel compensation;
4. compare against primes in order-2 and order-4 residue classes;
5. compare against generic residue weights not derived from (T_C).

A useful Couret-specific effect requires a reproducible improvement of the centered/off-diagonal moment that is not explained solely by the exact sieve identities T40–T41.

## Epistemic status

- T36: [D] exact coefficient identity.
- T37: [D] support-separation lemma.
- T38: [D] exact Hilbert-space energy identity.
- T39: [D] normalized-correlation reformulation.
- T40: [D] exact plain-polynomial p-sieving identity.
- T41: [D] exact Möbius scale-resolvent identity.
- Improved centered remainder moment: [O].
- Couret-specific effect beyond generic p-marking: [O].
