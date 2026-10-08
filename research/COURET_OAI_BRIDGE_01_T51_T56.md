# COURET–OAI–BRIDGE–01 — T51–T56 baselines and shift-direction no-go

> **RESEARCH BRANCH — NOT PART OF v1.0.0 — NO RH CLAIM — NOT PEER REVIEWED**
>
> This note sets the baseline for the residual shifted convolution (U_{p,a}) and proves that fixed mod-30 structure is blind in the shift direction (h). Any power saving in that direction must come from additional arithmetic/analytic input.

## T51 — crude pair-counting baseline

Assume

[
operatorname{supp}Wsubset[A,B],
qquad
0<A<B<infty,
]

and

[
|a_n|le M_a,
qquad
|W|_inftyle M_W.
]

For the matched Couret channel (a=pmod30),

[
U_{p,a}(X)
=
sum_{h
e0}
sum_m
a_{pm+30h}overline{a_m}
W((pm+30h)/X)overline{W(pm/X)}.
]

The second weight forces

[
min[AX/p,BX/p],
]

so the number of possible (m)'s is at most

[
N_mle (B-A)X/p+1.
]

For each such (m), the first weight forces

[
pm+30hin[AX,BX],
]

so the number of possible (h)'s is at most

[
N_hle (B-A)X/30+1.
]

Therefore

[
oxed{
|U_{p,a}(X)|
le
M_a^2M_W^2
left((B-A)X/p+1ight)
left((B-A)X/30+1ight).
}
]

This is only a counting bound. Its leading scale is (X^2/p) up to the fixed modulus-30 constant and the window constants.

Any claimed cancellation should be measured against this baseline.

---

## T52 — energy/Cauchy baseline

Let

[
C_{p,a}(X)
=
L_p(X)+U_{p,a}(X)
=
langle A(X),P_aA(X/p)angle,
]

where (P_a) is the unitary residue permutation associated with multiplication by (a).

With

[
E(X)=|A(X)|_2^2,
]

Cauchy–Schwarz gives

[
oxed{
|C_{p,a}(X)|
le
sqrt{E(X)E(X/p)}.
}
]

Hence

[
oxed{
|U_{p,a}(X)|
le
sqrt{E(X)E(X/p)}
+
|L_p(X)|.
}
]

This bound is generic: it uses no special property of (T_C) beyond the identification of the matched channel.

---

## T53 — fixed mod-30 weights are blind in the shift direction

Let (w:mathbb Z	omathbb C) be periodic modulo 30. Then for all integers (m,h),

[
oxed{
w(pm+30h)=w(pm).
}
]

Therefore any fixed periodic mod-30 coefficient is constant as (h) varies in

[
n=pm+30h.
]

### Consequence

The Couret triplet, every Dirichlet character modulo 30, and every finite linear combination of such weights can select residue channels, but none of them can create oscillation in the residual shift variable (h).

This is a strict fixed-modulus no-go at the T50 remainder stage.

---

## T54 — plain characters give no arithmetic cancellation across h

Let (psi) be a Dirichlet character modulo 30, let (p
mid30), and restrict to (m) coprime to 30.

For

[
n=pm+30h,
]

one has

[
psi(n)
=
psi(pm)
=
psi(p)psi(m).
]

Therefore

[
oxed{
psi(pm+30h)overline{psi(m)}
=
psi(p)|psi(m)|^2.
}
]

On the unit support,

[
|psi(m)|^2=1.
]

Thus the character factor in the entire h-sum has one constant phase (psi(p)).

If (W) is real and nonnegative, then

[
oxed{
overline{psi(p)},U^{m plain}_{p,a}(X)ge0.
}
]

There is no character-induced cancellation in (h).

The mod-30 character structure is therefore maximally coherent, not oscillatory, along the residual shifts (30h).

---

## T55 — for Möbius coefficients, all h-cancellation comes from Möbius

Take

[
a_n=mu(n)psi(n).
]

Again, for (n=pm+30h),

[
psi(n)overline{psi(m)}
=
psi(p)|psi(m)|^2.
]

Hence

[
oxed{
U^{m inv}_{p,a}(X)
=
psi(p)
sum_{h
e0}
sum_m
mu(pm+30h)mu(m)
|psi(m)|^2
W((pm+30h)/X)overline{W(pm/X)}.
}
]

Thus every sign/phase cancellation in the shift direction is carried by

[
mu(pm+30h)mu(m)
]

and by the analytic window, not by the fixed mod-30 character.

### Consequence

A nontrivial estimate for (U^{m inv}_{p,a}) is a Möbius-correlation problem after the finite residue routing has been removed.

Any claim of a Couret-specific analytic gain must therefore identify an additional mechanism beyond fixed mod-30 periodicity.

---

## T56 — literature boundary: Chowla/Elliott territory, but not an automatic theorem for U

For fixed (p) and fixed (h
e0), the coefficient correlation

[
mlongmapsto mu(pm+30h)mu(m)
]

is a two-point correlation of a bounded multiplicative function along two distinct affine-linear forms.

This places the fixed-shift problem in the broad Chowla/Elliott family.

Relevant known results include:

- Terence Tao, *The logarithmically averaged Chowla and Elliott conjectures for two-point correlations* (2015), which proves logarithmically averaged cancellation for fixed distinct affine-linear forms and extends to general bounded multiplicative functions:
  https://arxiv.org/abs/1509.05422
- Kaisa Matomäki, Maksym Radziwiłł, Terence Tao, *An averaged form of Chowla's conjecture* (2015), which obtains cancellation after averaging over shifts and extends to more general bounded multiplicative functions:
  https://arxiv.org/abs/1503.05121
- Matomäki–Radziwiłł–Tao–Teräväinen–Ziegler, *Higher uniformity of bounded multiplicative functions in short intervals on average* (Annals of Mathematics, 2023), which proves stronger averaged short-interval uniformity:
  https://annals.math.princeton.edu/2023/197-2/p03

### Important scope warning

These results do **not** immediately give the uniform weighted bound in the simultaneous variables (p,h,X) required by the present bridge.

Moreover, the fully summed (U_{p,a}) also has the exact packet factorization from T47/T52:

[
C_{p,a}(X)
=
sum_r
A_{ar}(X)overline{A_r(X/p)}.
]

So there are two distinct analytic routes:

1. **packet route** — bound the residue packet sums (A_r);
2. **shift route** — exploit cancellation in the individual/averaged correlations (mu(pm+30h)mu(m)).

They should not be conflated.

---

## Structural verdict after T56

The fixed Couret layer has now been exhausted in the h-direction:

[
oxed{
T_C
	ext{ selects which prime-residue channels are exposed,}
}
]

but

[
oxed{
T_C
	ext{ supplies no oscillation along }h.
}
]

Therefore a genuine next step must import or construct one of:

- nonperiodic scale-dependent weights;
- a growing modulus/conductor;
- Möbius-correlation estimates;
- Poisson/Voronoi/circle-method type transformation in the shift variable;
- family averaging strong enough to control the residual correlations.

## Epistemic status

- T51: **[D] elementary counting bound**.
- T52: **[D] exact Cauchy–Schwarz energy bound**.
- T53: **[D] exact periodicity no-go**.
- T54: **[D] exact no-oscillation identity for plain mod-30 characters**.
- T55: **[D] exact reduction of h-cancellation to Möbius correlation**.
- T56: **[L/I] literature placement and scope interpretation**.
- Uniform power saving for (U_{p,a}): **[O]**.
