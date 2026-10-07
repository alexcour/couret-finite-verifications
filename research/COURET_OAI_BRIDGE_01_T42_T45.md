# COURET–OAI–BRIDGE–01 — T42–T45 p-linked cross-scale pairs

> **RESEARCH BRANCH — NOT PART OF v1.0.0 — NO RH CLAIM — NOT PEER REVIEWED**
>
> This note refines the cross-scale statistic from T38–T41 by isolating the natural subdiagonal n = p m. It shows an exact sign asymmetry between plain and Möbius coefficients.

## T42 — exact cross-scale pair expansion

Let

[
A_r(X)=sum_{substack{nge1\nequiv r (30)}} a_n W(n/X),
]

and

[
C_p(X)=langle A(X),A(X/p)angle.
]

Then

[
oxed{
C_p(X)
=
sum_{substack{n,mge1\nequiv m (30)}}
a_noverline{a_m}
W(n/X)overline{W(pm/X)}.
}
]

Assume (pequiv1pmod{30}). Then every pair (n=pm) automatically satisfies

[
nequiv mpmod{30}.
]

Hence the cross-correlation contains the distinguished p-linked contribution

[
oxed{
L_p(X)
=
sum_{mge1}
a_{pm}overline{a_m}
|W(pm/X)|^2.
}
]

Write

[
C_p(X)=L_p(X)+U_p(X),
]

where (U_p) contains the remaining congruent pairs (n
e pm).

Thus the cross-scale problem splits into:

1. an exact arithmetic p-linked term;
2. a genuinely off-p-linked congruence correlation.

---

## T43 — positive p-linked mass for the plain mod-30 characters

Let (psi) be a Dirichlet character modulo 30 and let (pequiv1pmod{30}). For integers (m) coprime to 30,

[
psi(pm)=psi(p)psi(m)=psi(m).
]

Take

[
a_n=psi(n).
]

Then

[
a_{pm}overline{a_m}
=
|psi(m)|^2.
]

On the unit support this equals 1. Therefore

[
oxed{
L_p^{mathrm{plain}}(X)
=
sum_{substack{mge1\(m,30)=1}}
|W(pm/X)|^2
ge0.
}
]

So the natural p-linked subdiagonal contributes with **positive sign** to the cross-scale correlation.

In the compensated energy

[
E_{mathrm{comp}}
=
E(X)+p^{2eta}E(X/p)
-
2p^etaRe C_p(X),
]

this positive p-linked correlation is subtractive and can genuinely reduce the energy before the uncontrolled remainder (U_p) is considered.

This is an exact structural reason why a first difference is natural for the plain polynomial.

---

## T44 — negative p-linked mass for Möbius/inverse coefficients

Now take

[
a_n=mu(n)psi(n),
]

with (pequiv1pmod{30}).

If (p
mid m), then

[
mu(pm)=-mu(m)
]

and

[
psi(pm)=psi(m).
]

Hence

[
a_{pm}overline{a_m}
=
-|mu(m)psi(m)|^2.
]

If (pmid m), then (mu(pm)=0), so there is no p-linked contribution from that m.

Therefore

[
oxed{
L_p^{mathrm{inv}}(X)
=
-
sum_{substack{mge1\p
mid m\(m,30)=1}}
|mu(m)|^2
|W(pm/X)|^2
le0.
}
]

Thus the same subtractive compensation used for the plain polynomial has the **wrong sign** on the natural p-linked Möbius correlation: the term

[
-2p^etaRe C_p
]

turns the negative linked correlation into a positive energy contribution.

This gives an exact coefficient-level explanation for the asymmetry identified abstractly in T40–T41.

---

## T45 — first Möbius correction cancels exponent-1 p-support but creates a p^2 ghost

Consider

[
M_psi(X)
=
sum_nmu(n)psi(n)W(n/X)
]

and the first positive correction

[
M_psi(X)+psi(p)M_psi(X/p).
]

For an integer (n=p^kv) with (p
mid v):

- if (k=1), the two contributions cancel exactly;
- if (k=0), only the original term remains;
- if (k=2), the original Möbius coefficient is zero but the shifted term coming from (pv) is generally nonzero.

Thus a one-step positive correction removes the p-exponent-1 layer but creates a new p-exponent-2 scale image.

The next term

[
psi(p)^2M_psi(X/p^2)
]

cancels that ghost, but creates the next scale image, and so on.

This telescoping mechanism is exactly why the full scale resolvent

[
oxed{
mathcal R_{p,psi}
=
I+psi(p)D_p+psi(p)^2D_p^2+cdots
}
]

is the natural exact p-removal operator for the Möbius/inverse polynomial.

For compactly supported (W) and fixed X, only finitely many scale images contribute to any fixed coefficient range.

---

## Consequence for moment design

The cross-scale statistic should now be split into three parts:

[
C_p
=
L_p+U_p,
]

where:

- (L_p) is the explicit p-linked subdiagonal;
- (U_p) is the remaining congruent-pair correlation.

For the plain polynomial, (L_pge0).

For the Möbius inverse polynomial, (L_ple0).

Therefore a meaningful centered-moment experiment should not compare the two species with the same local operator.

Instead:

- plain: first difference / p-sieving operator;
- inverse: scale resolvent / local Euler-factor removal.

The genuinely difficult quantity in both cases is the residual correlation (U_p).

---

## New target

Define normalized residual cross-correlation

[
ho_p^{mathrm{res}}(X)
=
rac{U_p(X)}
{sqrt{E(X)E(X/p)}}
]

when the denominator is nonzero.

The next question is whether residue/character structure — and specifically the Couret weighting — yields any nontrivial control of

[
U_p(X)
]

beyond generic congruence counting.

If not, the local p-linked mechanism is completely explained by standard multiplicativity and no Couret-specific analytic effect remains.

## Epistemic status

- T42: [D] exact cross-scale expansion.
- T43: [D] exact positive p-linked identity for plain mod-30 characters.
- T44: [D] exact negative p-linked identity for Möbius coefficients.
- T45: [D] exact telescoping explanation of the scale resolvent.
- Nontrivial bound on residual (U_p): [O].
- Couret-specific improvement of residual correlation: [O].
