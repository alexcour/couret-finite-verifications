# COURET–OAI–BRIDGE–01 — T46–T50 Couret autocorrelation gate and shifted remainder

> **RESEARCH BRANCH — NOT PART OF v1.0.0 — NO RH CLAIM — NOT PEER REVIEWED**
>
> This note isolates the exact effect of the Couret triplet on cross-scale moments. The effect is real but finite: it opens four multiplicative residue channels, exactly the Klein subgroup (K_4={1,11,19,29}). Any power saving still requires an estimate on the shifted remainder.

## T46 — exact autocorrelation kernel of the Couret triplet

Let

[
	au=delta_1+delta_{11}+delta_{29}
]

in the group algebra of (G=U(30)).

Because (1,11,29) are involutions in (G), (	au^ast=	au). Using

[
11cdot29=19,
]

one gets

[
oxed{
	au^ast * 	au
=
3delta_1
+
2delta_{11}
+
2delta_{19}
+
2delta_{29}.
}
]

Thus the support of the autocorrelation kernel is exactly

[
oxed{
K_4={1,11,19,29}.
}
]

For residue-packet vectors (A,Binmathbb C^{U(30)}),

[
oxed{
langle 	au*A,	au*Bangle
=
3,C_1(A,B)
+
2,C_{11}(A,B)
+
2,C_{19}(A,B)
+
2,C_{29}(A,B),
}
]

where

[
C_k(A,B)
=
sum_{rin U(30)}
A_r,overline{B_{k^{-1}r}}.
]

## T47 — coefficient interpretation: four multiplicative congruence channels

Let

[
A_r(X)
=
sum_{substack{nge1\nequiv r (30)}}
a_nW(n/X).
]

Then

[
C_{p,k}(X)
:=
C_k(A(X),A(X/p))
]

has the exact expansion

[
oxed{
C_{p,k}(X)
=
sum_{substack{n,mge1\
nequiv km (30)}}
a_noverline{a_m}
W(n/X)overline{W(pm/X)}.
}
]

Therefore

[
oxed{
langle	au*A(X),	au*A(X/p)angle
=
3C_{p,1}(X)
+
2C_{p,11}(X)
+
2C_{p,19}(X)
+
2C_{p,29}(X).
}
]

The fixed Couret filter does not merely amplify the ordinary congruence channel (nequiv mpmod{30}): its cross-scale autocorrelation opens exactly the four channels

[
nequiv kmpmod{30},
qquad
kin K_4.
]

This is an exact Couret-specific finite effect.

## T48 — selected-prime gate

Let (p
mid30) be prime and write

[
a=pmod30in U(30).
]

The natural cross-scale multiplicative diagonal is

[
n=pm.
]

This pair belongs to the (k)-channel precisely when

[
a=k.
]

Hence the p-linked diagonal (n=pm) appears in the Couret-filtered cross-scale moment if and only if

[
oxed{
pmod30in K_4.
}
]

Its autocorrelation coefficient is

[
oxed{
kappa(a)
=
egin{cases}
3,&a=1,\
2,&ain{11,19,29}.
end{cases}
}
]

Primes in the other four unit residue classes do not contribute their natural (n=pm) diagonal to the Couret autocorrelation kernel.

### Quadratic-mod-5 form

Let (chi_5) be the quadratic Dirichlet character modulo 5. On (U(30)),

[
oxed{
K_4=kerchi_5.
}
]

Indeed the residues (1,11,19,29) are exactly those congruent to (1) or (4pmod5).

Therefore the selected-prime gate is equivalently

[
oxed{
chi_5(p)=1.
}
]

This is a genuine arithmetic characterization of the four Couret autocorrelation channels.

## T49 — dual spectral form: two heavy character channels

Finite Fourier diagonalization gives

[
widehat{	au^ast*	au}(psi)
=
|widehat	au(psi)|^2.
]

For the Couret triplet,

[
|widehat	au(psi)|^2
in{1,9}.
]

The value (9) occurs exactly on the annihilator

[
K_4^perp
=
{mathbf 1,chi_5}.
]

Thus the same finite structure has two dual descriptions:

### residue side

[
oxed{
operatorname{supp}(	au^ast*	au)=K_4=kerchi_5;
}
]

### character side

[
oxed{
|widehat	au|^2=9
	ext{ on }
{mathbf1,chi_5},
quad
|widehat	au|^2=1
	ext{ on the other six channels}.
}
]

Consequently, under the Fourier normalization

[
langle A,Bangle
=
rac18sum_psi
widehat A(psi)overline{widehat B(psi)},
]

one has

[
oxed{
langle	au*A,	au*Bangle
=
langle A,Bangle
+
widehat A(mathbf1)overline{widehat B(mathbf1)}
+
widehat A(chi_5)overline{widehat B(chi_5)}.
}
]

The Couret reweighting therefore adds exactly the trivial and quadratic-mod-5 cross-channel correlations to the unfiltered correlation.

## T50 — matched channel = natural diagonal + additive shifted remainder

Assume now that

[
pmod30=ain K_4.
]

In the matched channel (k=a), the congruence condition is

[
nequiv pmpmod{30}.
]

Hence there is a unique integer shift (h) such that

[
oxed{
n=pm+30h.
}
]

Therefore

[
C_{p,a}(X)
=
L_p(X)+U_{p,a}(X),
]

where the natural diagonal is

[
oxed{
L_p(X)
=
sum_m
a_{pm}overline{a_m}
|W(pm/X)|^2
}
]

and the residual shifted convolution is

[
oxed{
U_{p,a}(X)
=
sum_{h
e0}
sum_{substack{mge1\pm+30hge1}}
a_{pm+30h}overline{a_m}
W((pm+30h)/X)overline{W(pm/X)}.
}
]

This identifies the first genuinely analytic remainder in the Couret-selected prime channel:

[
oxed{
	ext{estimate a shifted convolution with shifts }30h.
}
]

The factor (30) is now structural rather than decorative: it is the exact step size left after matching the multiplicative diagonal (n=pm).

### Fixed-modulus additive Fourier representation

The congruence condition also admits

[
mathbf1_{nequiv km (30)}
=
rac1{30}
sum_{jmod30}
e!left(rac{j(n-km)}{30}ight).
]

Hence every (C_{p,k}) factorizes into 30 additive-frequency products.

This is an exact additive Fourier representation, but it is still a fixed modulus 30 transform. By itself it does not shorten the (n)- or (m)-ranges.

### Consequence

The next analytic step cannot come from more finite mod-30 Fourier algebra alone.

One needs an estimate or transform acting on the shifted-convolution variable (h), the length variable (X), or a growing modulus/conductor.

That is the first point where a genuine Poisson/Voronoi/large-sieve type input could enter.

## Plain vs inverse sign on the matched diagonal

For (a_n=psi(n)), the matched p-linked term has local factor

[
a_{pm}overline{a_m}
=
psi(p)|psi(m)|^2.
]

For (a_n=mu(n)psi(n)) and (p
mid m),

[
a_{pm}overline{a_m}
=
-psi(p)|mu(m)psi(m)|^2.
]

Thus the sign asymmetry from T43–T44 persists in every Couret-selected prime residue class.

The Couret gate chooses which prime residues expose the natural p-linked diagonal; the plain/inverse coefficient species determine its sign.

## Research consequence

T46–T50 identify a Couret-specific effect that survives the earlier no-gain results:

> the (T_C) autocorrelation kernel selects the prime residue gate (chi_5(p)=1) and exposes the natural cross-scale diagonal (n=pm) in four residue classes instead of only the identity class.

But this remains finite structural information.

A new exponent can arise only if the residual shifted convolution

[
U_{p,a}(X)
]

admits a nontrivial bound that is stronger for the Couret-selected gate than for generic residue channels.

That is the next falsifiable target.

## Epistemic status

- T46: **[D] exact group-algebra autocorrelation identity**.
- T47: **[D] exact coefficient expansion**.
- T48: **[D] exact selected-prime residue gate**.
- (K_4=kerchi_5): **[D] exact finite character fact**.
- T49: **[D] exact Fourier dual description**.
- T50: **[D] exact matched-channel shifted-convolution decomposition**.
- Nontrivial estimate for (U_{p,a}): **[O]**.
- Couret-specific power saving for (U_{p,a}): **[O]**.
