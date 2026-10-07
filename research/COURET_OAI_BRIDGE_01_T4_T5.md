# COURET–OAI–BRIDGE–01 — T4–T5 analytic bridge

> **RESEARCH BRANCH — NOT PART OF v1.0.0 — NO RH CLAIM — NOT PEER REVIEWED**
>
> The identities below are standard analytic-number-theory consequences of Euler products and partial summation. They are recorded to locate exactly where the finite Couret layer ends and the genuine analytic difficulty begins. No novelty is claimed.

## T4 — Möbius on the units modulo 30

Define

[
u_{30}(n)=
egin{cases}
1,&(n,30)=1,\
0,&(n,30)>1.
end{cases}
]

For (Re(s)>1), absolute convergence gives

[
F_{30}(s)
:=
sum_{nge1}rac{mu(n)u_{30}(n)}{n^s}
=
prod_{p
mid30}(1-p^{-s}).
]

Since

[
rac1{zeta(s)}=prod_p(1-p^{-s}),
]

we obtain

[
oxed{
F_{30}(s)
=
rac{H_{30}(s)}{zeta(s)},
qquad
H_{30}(s)
=
prod_{pmid30}(1-p^{-s})^{-1}.
}
]

Thus explicitly

[
H_{30}(s)
=
(1-2^{-s})^{-1}
(1-3^{-s})^{-1}
(1-5^{-s})^{-1}.
]

### Local-factor status

For (Re(s)>0), each equation (1-p^{-s}=0) would require

[
s=rac{2pi i k}{log p}
]

for some integer (k), hence (Re(s)=0). Therefore

[
oxed{H_{30}(s)	ext{ is holomorphic and nonzero on }Re(s)>0.}
]

So the factors (2,3,5) do not create an obstruction inside any positive zero-free half-plane.

### Important interpretation

This exact reciprocal-zeta channel uses the indicator of **all units modulo 30**, not the Couret triplet (T_C).

Therefore T4 is a clean mod-30/Euler identity, but it does not establish a special causal role for (T_C).

---

## T4b — the Couret triplet gives a finite mixture of reciprocal L-functions

Let (w_C=1_{T_C}) on (U(30)). Fourier inversion gives

[
w_C(a)
=
rac18
sum_{psiinwidehat{U(30)}}
widehat w_C(psi)psi(a).
]

The exact finite Fourier multipliers have values

[
{3,3,1,1,1,1,-1,-1}
]

up to character ordering.

For (Re(s)>1),

[
D_C(s)
=
sum_{substack{nge1\(n,30)=1}}
rac{mu(n)w_C(n)}{n^s}
]

therefore becomes a finite linear combination of the eight twisted reciprocal Dirichlet series

[
sum_nrac{mu(n)psi(n)}{n^s}.
]

After primitive/imprimitive local-factor bookkeeping, these are finite local factors times reciprocals (1/L(s,psi^*)).

### Consequence

The Couret triplet does **not** isolate (1/zeta(s)). Its Fourier spectrum gives two modes of maximal amplitude (3): the trivial character and one nontrivial quadratic channel.

Hence a direct reading

[
T_Clongrightarrow zeta
]

is not supported by the exact finite character algebra. The more faithful reading is

[
oxed{
T_Clongrightarrow 	ext{finite mixture of character twists}.
}
]

---

## T5 — continuation from a power-saving Möbius bound

Define

[
M_{30}(x)
=
sum_{substack{nle x\(n,30)=1}}mu(n).
]

Assume that for some real (	heta<1),

[
M_{30}(x)=O(x^	heta).
]

Then for every (s) with (Re(s)>	heta), partial summation yields

[
sum_{substack{nge1\(n,30)=1}}
rac{mu(n)}{n^s}
=
sint_1^infty M_{30}(x)x^{-s-1},dx,
]

up to the standard lower-end boundary convention.

Indeed, if (sigma=Re(s)>	heta),

[
|M_{30}(x)x^{-s-1}|
ll
x^{	heta-sigma-1},
]

and

[
int_1^infty x^{	heta-sigma-1},dx<infty.
]

Thus the right-hand side defines a holomorphic function in

[
Re(s)>	heta.
]

On the overlap (Re(s)>1), it agrees with (H_{30}(s)/zeta(s)). By uniqueness of analytic continuation, it extends that reciprocal expression to (Re(s)>	heta).

Since (H_{30}) is holomorphic and nonzero for (Re(s)>0), we obtain:

### Theorem T5

If (0le	heta<1) and

[
M_{30}(x)=O(x^	heta),
]

then

[
oxed{
zeta(s)
eq0
quad	ext{for every }s	ext{ with }Re(s)>	heta,
}
]

apart from the usual pole of (zeta) at (s=1), which is not a zero.

More precisely, (1/zeta(s)) has a holomorphic continuation to that half-plane, with a zero at (s=1) corresponding to the pole of (zeta).

### Variant

The same argument applies to a Dirichlet character (chi) once the relevant primitive/imprimitive local factors are kept explicitly and a power-saving bound is proved for

[
M_chi(x)=sum_{nle x}mu(n)chi(n).
]

This is the classical analytic bridge from cancellation of reciprocal coefficients to nonvanishing of the corresponding (L)-function.

---

## What T5 proves about the research program

T5 identifies the missing quantity with much greater precision.

The obstacle is **not**:

- finding another exact mod-30 identity;
- computing another finite spectrum;
- finding another normalization constant.

The obstacle is:

[
oxed{
	ext{prove a uniform power saving for an appropriate Möbius/Dirichlet polynomial}.
}
]

A fixed finite Fourier transform cannot supply that power saving by T3.

Therefore any genuine Couret contribution must modify the analytic problem in a way that creates cancellation beyond fixed-dimensional norm equivalence.

---

## Comparison with OpenAI

OpenAI's quasi-RH proof follows the same broad analytic logic but does not assume the power saving. It manufactures it through additional machinery:

1. a zero detector;
2. inverse polynomials with ideal Möbius coefficients;
3. a second plain polynomial;
4. theta/reflection and Poisson representations;
5. recursive shortening;
6. moment estimates;
7. sextic large sieve;
8. selected-prime local compensation;
9. a Mellin continuation criterion.

T5 is therefore the point at which the Couret finite program and the OpenAI analytic program can be placed on the same diagram:

[
	ext{finite character organization}
longrightarrow
oxed{	ext{power saving}}
longrightarrow
1/L
longrightarrow
	ext{zero-free region}.
]

The boxed step is precisely the one not supplied by T1–T4.

## Epistemic status

- T4: **[D] classical Euler-product identity in (Re(s)>1)**.
- Holomorphy/nonvanishing of (H_{30}) on (Re(s)>0): **[D] elementary**.
- T4b: **[D] finite Fourier decomposition**, subject to explicit character/local-factor conventions.
- T5: **[D] standard partial-summation/analytic-continuation implication**, not project novelty.
- A bound (M_{30}(x)=O(x^	heta)) with a useful fixed (	heta<1): **not supplied here**.
- Any Couret-specific improvement in such a bound: **[O]**.
