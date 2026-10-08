# COURET–OAI–BRIDGE–01 — T64–T70 growing modulus and shift-frequency lift

> **RESEARCH BRANCH — NOT PART OF v1.0.0 — NO RH CLAIM — NOT PEER REVIEWED**
>
> This note changes mechanism after the negative EXP-01 verdict. The modulus is no longer fixed at 30. A new coprime modulus q is introduced specifically to resolve the residual shift variable h.

## T64 — lifting from mod 30 to mod 30q resolves h modulo q

Assume \((q,30)=1\), let \(p\nmid30q\), and consider the matched relation

\[
n=pm+30h.
\]

Fix \(r\in\mathbb Z/q\mathbb Z\). Then

\[
\boxed{
n\equiv pm+30r\pmod{30q}
\iff
h\equiv r\pmod q.
}
\]

### Proof

Subtract \(pm\):

\[
n-pm=30h.
\]

The lifted congruence says

\[
30h\equiv30r\pmod{30q},
\]

equivalently

\[
q\mid(h-r).
\]

Thus lifting the modulus from \(30\) to \(30q\) refines the residual shift into q residue classes.

### Interpretation

The fixed mod-30 layer selects multiplicative residue channels.  
The new mod-q layer resolves the previously invisible shift variable \(h\).

This is a genuine mechanism change relative to T53.

---

## T65 — q shift packets and additive Fourier transform

Let \(b_h\) denote the residual shift contribution after all m-summation and diagonal removal.

Define q shift packets

\[
H_q(r)
=
\sum_{h\equiv r\ (q)} b_h,
\qquad
r\in\mathbb Z/q\mathbb Z.
\]

Their discrete Fourier transform is

\[
\widehat H_q(j)
=
\sum_{r\bmod q}
H_q(r)e(-jr/q).
\]

Substituting the packet definition gives

\[
\boxed{
\widehat H_q(j)
=
\sum_h
b_h e(-jh/q).
}
\]

Thus the growing modulus introduces q additive frequencies in the h-variable.

---

## T66 — exact Parseval bridge in the shift direction

Discrete Parseval gives

\[
\boxed{
\sum_{r\bmod q}|H_q(r)|^2
=
\frac1q
\sum_{j\bmod q}
|\widehat H_q(j)|^2.
}
\]

This is the shift-direction analogue of the earlier mod-30 character Parseval identity.

### Important distinction

For fixed q, T66 is only a finite unitary change of basis.  
It cannot create a power saving by itself.

The analytic novelty can only come from allowing q to grow with the scale.

---

## T67 — fixed-q no-gain, growing-q escape

Let \(q\) be fixed. Then the map

\[
(H_q(r))_{r\bmod q}
\longleftrightarrow
(\widehat H_q(j))_{j\bmod q}
\]

is a fixed finite-dimensional unitary transform.

Therefore fixed-q additive Fourier analysis inherits the same no-gain principle as T3/T8.

If

\[
q=q(X)\to\infty,
\]

the dimension and frequency resolution increase with the analytic scale.

Hence:

\[
\boxed{
\text{growing q is necessary if this new Fourier layer is to escape the fixed-dimensional no-go.}
}
\]

Necessary does not mean sufficient.

---

## T68 — resolution versus averaging tradeoff

Assume the residual shifts \(h\) lie in an interval of length at most \(H_X\).

Then a packet \(h\equiv r\pmod q\) contains at most

\[
\boxed{
1+\left\lfloor H_X/q\right\rfloor
}
\]

possible shifts.

Therefore:

### coarse regime
\[
q\ll H_X
\]

Each packet averages many h-values.

### transition regime
\[
q\asymp H_X
\]

Packets contain O(1) shifts.

### over-resolved regime
\[
q>H_X
\]

Every packet contains at most one shift.

### Consequence

There is a real scale tradeoff.

- Small q preserves averaging but gives low frequency resolution.
- Large q resolves individual shifts but destroys packet averaging.
- The potentially interesting regime is \(q\) growing below or around the natural shift length.

For windows supported in \([A,B]\), the T51 geometry gives a shift-span of order

\[
H_X\asymp (B-A)X/30.
\]

---

## T69 — analytic large-sieve baseline for the new frequencies

Let \(f(h)\) be supported on an interval of length \(H\).  
For \(\delta\)-separated frequencies \(\xi_1,\dots,\xi_J\in\mathbb R/\mathbb Z\), the classical analytic large sieve gives schematically

\[
\boxed{
\sum_{j=1}^J
\left|
\sum_h f(h)e(-\xi_jh)
\right|^2
\ll
\left(H+\delta^{-1}\right)
\sum_h|f(h)|^2.
}
\]

For rational frequencies \(a/q\) with \(q\le Q\), the natural spacing scale is about \(Q^{-2}\), leading to the standard \(H+Q^2\) barrier.

This provides the first external analytic tool whose strength grows with the new family of shift frequencies.

### Research boundary

The large sieve does not prove a Couret effect.

It gives a family-level benchmark for what can be gained once the modulus/conductor grows.

Reference:
Terence Tao, 254A Notes 3: The large sieve and the Bombieri–Vinogradov theorem.

---

## T70 — direct Poisson on h requires a genuinely transformable h-weight

If \(b_h\) were a smooth function of h, Poisson summation could convert

\[
\sum_h b_h e(-jh/q)
\]

into a dual sum with reciprocal scale.

But in the inverse/Möbius problem,

\[
b_h
=
\sum_m
\mu(pm+30h)\mu(m)\,\mathcal W_{p,h,m}(X),
\]

so the h-dependence contains the arithmetic coefficient

\[
\mu(pm+30h).
\]

Therefore ordinary Poisson cannot be applied as though \(b_h\) were a smooth weight.

A true duality requires one of:

1. a prior decomposition that separates the arithmetic coefficient from h;
2. a family average that converts it into a tractable correlation;
3. a trace formula / Voronoi-type transform adapted to the coefficient sequence;
4. a replacement object with a known summation formula.

### Consequence

The growing modulus creates the correct frequency variable, but the Möbius coefficient remains the hard analytic obstruction.

---

## Updated architecture after EXP-01

The bridge now separates into three layers:

### Layer A — fixed Couret routing
\[
U(30),\ T_C,\ \chi_5.
\]

Exact but no residual power saving detected.

### Layer B — growing shift resolution
\[
30
\longrightarrow
30q,
\qquad
h\bmod q,
\qquad
e(jh/q).
\]

This is the first layer that genuinely grows with scale.

### Layer C — analytic estimate
large sieve / dual transform / correlation estimate on the h-frequency family.

Only Layer C can create a new exponent.

---

## Next experiment

EXP-02 should not retune EXP-01.

It should test the new mechanism:

1. form the residual shift sequence \(b_h\);
2. choose a pre-specified growing family \(q\);
3. compute the q-frequency spectrum \(\widehat H_q(j)\);
4. measure spectral concentration versus Parseval energy;
5. compare inverse and plain cases;
6. compare Couret-selected prime windows to matched controls;
7. benchmark against the large-sieve scale \(H+Q^2\).

A positive result would still not imply a zero-free region.  
It would only show that the growing-modulus lift exposes nontrivial frequency structure absent from the fixed mod-30 model.

## Epistemic status

- T64: **[D] exact congruence lift**.
- T65: **[D] exact additive Fourier identity**.
- T66: **[D] exact Parseval identity**.
- T67: **[D/I] fixed-dimensional no-gain + mechanism interpretation**.
- T68: **[D] exact packet-size bound / scale tradeoff**.
- T69: **[L] classical analytic large-sieve benchmark**.
- T70: **[I] analytic obstruction statement**.
- New power saving from growing q: **[O]**.
