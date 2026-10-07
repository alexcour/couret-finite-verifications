# COURET–OAI–BRIDGE–01 — T8–T11 escape criteria

> **RESEARCH BRANCH — NOT PART OF v1.0.0 — NO RH CLAIM — NOT PEER REVIEWED**
>
> These statements refine the boundary between fixed finite character algebra and a genuinely scale-changing analytic mechanism. Novelty is not claimed for the general functional-analytic or Euler-product facts.

## T8 — uniformly well-conditioned variable transforms still cannot create an exponent

T3 treated a fixed invertible map. The same principle survives for a family of maps.

### Theorem T8

Let (E) be a normed vector space and (L_X:E	o E) a family of bounded invertible linear maps. Assume that for all sufficiently large (X),

[
|L_X|le C,
qquad
|L_X^{-1}|le C'
]

with constants independent of (X).

Then for every positive comparison function (g(X)),

[
oxed{
|F(X)|=O(g(X))
iff
|L_XF(X)|=O(g(X)).
}
]

The same holds with (o(g(X))).

### Proof

Use

[
|L_XF(X)|le C|F(X)|
]

and

[
|F(X)|
le C'|L_XF(X)|.
]

The constants are uniform in (X). (square)

### Quantitative conditioning version

More generally, if

[
|L_X|=O(X^a),
qquad
|L_X^{-1}|=O(X^b),
]

then

[
|F(X)|=O(X^alpha)
Longrightarrow
|L_XF(X)|=O(X^{alpha+a}),
]

and

[
|L_XF(X)|=O(X^gamma)
Longrightarrow
|F(X)|=O(X^{gamma+b}).
]

Hence any apparent exponent gain carried only by a badly conditioned transform must be discounted by the growth exponent of the inverse norm.

---

## T8b — Fourier criterion for a scale-dependent periodic filter

Let (w_X:G	omathbb C) and let (C_{w_X}) be convolution by (w_X). Since finite Fourier diagonalizes convolution, the singular values are the moduli

[
|widehat w_X(psi)|.
]

Therefore a uniform bound

[
0<c
le
|widehat w_X(psi)|
le
C<infty
]

for every (X) and every character (psi) implies uniform well-conditioning, hence no exponent gain by T8.

### Escape criterion

After a harmless normalization of overall scale, a scale-dependent periodic filter can escape the T3/T8 no-gain theorem only if at least one Fourier multiplier becomes asymptotically small:

[
oxed{
min_{psi}|widehat w_X(psi)|	o0,
}
]

or the operator becomes genuinely noninvertible.

Thus a putative Couret mechanism based on (w_X) must become asymptotically projective / ill-conditioned, or obtain its gain from additional arithmetic estimates not contained in the finite transform.

---

## T9 — uniqueness of the zeta-selective weight modulo 30

Call a weight (w:G	omathbb C) **zeta-selective** if its Fourier transform vanishes on every nontrivial character:

[
widehat w(psi)=0
qquad
(psi
eq1).
]

### Theorem T9

A weight on (U(30)) is zeta-selective if and only if it is constant on (U(30)).

### Proof

If only the trivial Fourier coefficient is nonzero, Fourier inversion gives

[
w(a)=rac18widehat w(1)
]

for every (ain G). Thus (w) is constant.

Conversely, a constant function is orthogonal to every nontrivial character. (square)

### Corollary T9a

If (Ssubset U(30)) is a proper nonempty subset, its indicator (1_S) necessarily has at least one nontrivial Fourier coefficient.

Therefore no proper nonempty residue subset modulo 30 isolates (1/zeta).

### Corollary T9b — Couret triplet

For (T_C={1,11,29}), in fact every one of the eight Fourier coefficients is nonzero.

Hence (T_C) couples to **all eight Dirichlet-character channels**.

This is stronger than merely saying that (T_C) does not isolate zeta.

---

## T10 — fixed finite Euler correction cannot move a positive-half-plane zero boundary

Let (chi) be a Dirichlet character and let (S) be a fixed finite set of primes. Consider a finite Euler factor

[
P_S(s)
=
prod_{pin S, chi(p)
eq0}
(1-chi(p)p^{-s})^{m_p}
]

with integer exponents (m_p), interpreted meromorphically if some (m_p<0).

If (chi(p)
eq0), then (|chi(p)|=1). Any zero of

[
1-chi(p)p^{-s}
]

satisfies

[
p^{-Re(s)}=1,
]

hence (Re(s)=0).

Therefore:

### Theorem T10

A fixed finite Euler correction (P_S) is holomorphic and nonzero on (Re(s)>0) whenever it is written without denominator poles there; more generally its zeros/poles arising from these local factors lie on (Re(s)=0).

Consequently, multiplying or dividing by a fixed finite set of such local factors cannot create a new zero-free boundary inside a positive half-plane.

### Interpretation

Finite local corrections are essential for **statement fidelity** and exact primitive/imprimitive bookkeeping, but they are not by themselves the source of a power saving or a positive zero-free exponent.

To matter asymptotically, prime compensation must vary with scale/conductor, or enter before the final estimate in a way that changes cancellation.

---

## T11 — growing prime products give the first natural scale-dependent escape

Let (yge2), and define the finite Euler polynomial

[
Q_y(s,chi)
=
prod_{substack{ple y\p
mid q}}
(1-chi(p)p^{-s}).
]

Expanding the finite product gives exactly

[
oxed{
Q_y(s,chi)
=
sum_{substack{d 	ext{squarefree}\
pmid dRightarrow ple y\
(d,q)=1}}
rac{mu(d)chi(d)}{d^s}.
}
]

Thus (Q_y) is a finite Möbius/Dirichlet polynomial: a truncated reciprocal Euler product.

It depends on the scale (y), so T3 does not apply to it as a fixed transform.

### But no automatic gain follows

For (Re(s)>1),

[
rac1{L(s,chi)}
=
Q_y(s,chi)
prod_{substack{p>y\p
mid q}}
(1-chi(p)p^{-s}).
]

The tail over (p>y) is precisely the analytic remainder that must be controlled.

Therefore the growing product identifies a **correct kind of object**, not a solution.

### Research interpretation

T11 is the simplest toy model of the move from:

[
	ext{fixed finite local correction}
]

to

[
	ext{scale-dependent inverse polynomial}.
]

This is structurally much closer to the inverse Dirichlet polynomials used in zero-detection arguments than any fixed mod-30 convolution.

---

## Consequence for the Couret program

After T8–T11, three routes are sharply separated.

### Closed as a source of exponent gain

1. fixed invertible (T_C) convolution;
2. uniformly well-conditioned scale-dependent variants;
3. fixed finite Euler corrections;
4. any claim that a proper fixed residue subset isolates zeta.

### Still open

1. asymptotically projective / ill-conditioned (w_X);
2. scale-growing prime products or inverse polynomials;
3. conductor-dependent selected-prime compensation;
4. a second exact representation that changes analytic scale;
5. moment estimates proving a power saving for those dynamic objects.

### New falsifiable question

The next Couret-specific test is no longer:

> Does (T_C) encode zeta?

It is:

> Can a scale- or conductor-dependent construction **derived from the Couret character architecture** produce a cancellation estimate that survives comparison with generic controls and cannot be explained by conditioning alone?

That is the first remaining question capable of reaching the OpenAI side of the bridge.

## Epistemic status

- T8/T8b: **[D] elementary norm/Fourier facts**.
- T9 and corollaries: **[D] exact finite Fourier facts**.
- T10: **[D] elementary local-factor fact**.
- T11 finite-product expansion: **[D] exact elementary identity**.
- Approximation quality of (Q_y) in critical regions: **[O]**.
- Couret-specific dynamic compensation giving a power saving: **[O]**.
