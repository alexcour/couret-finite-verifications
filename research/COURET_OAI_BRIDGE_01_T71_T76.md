# COURET-OAI-BRIDGE-01 - T71-T76 large-sieve benchmark for the shift spectrum

> **RESEARCH BRANCH - NOT PART OF v1.0.0 - NO RH CLAIM - NOT PEER REVIEWED**
>
> This note benchmarks the growing-modulus shift-frequency mechanism against the classical analytic large sieve. The goal is no longer to favor a Couret residue gate, but to determine whether the residual shift spectrum is unusually concentrated relative to a generic family-energy bound.

## T71 - Farey frequency family

Let \(b_h\) be a finitely supported residual shift sequence, supported in an integer interval of length \(N\).

For \(Q\ge1\), define the reduced rational frequency set

\[
\mathcal F_Q
=
\{0\}
\cup
\left\{
\frac aq\bmod1:
1\le q\le Q,\ (q,30)=1,\ 1\le a<q,\ (a,q)=1
\right\}.
\]

Distinct reduced fractions in \(\mathcal F_Q\) satisfy

\[
\left\|
\frac aq-\frac{a'}{q'}
\right\|_{\mathbb R/\mathbb Z}
\ge
\frac1{qq'}
\ge
\frac1{Q^2}.
\]

Thus \(\mathcal F_Q\) is \(Q^{-2}\)-separated.

## T72 - large-sieve energy bound

Define

\[
S_b(\alpha)
=
\sum_h b_h e(-\alpha h),
\]

and

\[
\mathcal L_Q(b)
=
\sum_{\alpha\in\mathcal F_Q}
|S_b(\alpha)|^2.
\]

The sharp analytic large sieve for \(Q^{-2}\)-separated frequencies gives

\[
\boxed{
\mathcal L_Q(b)
\le
(N-1+Q^2)
\sum_h|b_h|^2.
}
\]

The same inequality remains true after deleting the zero frequency from the left-hand side.

This is an external classical benchmark, not a Couret theorem.

## T73 - dimensionless saturation ratio

For nonzero \(b\), define

\[
\boxed{
\mathfrak S_Q(b)
=
\frac{\mathcal L_Q(b)}
{(N-1+Q^2)\sum_h|b_h|^2}.
}
\]

Then

\[
0\le\mathfrak S_Q(b)\le1.
\]

Also define the nonzero-frequency saturation

\[
\boxed{
\mathfrak S_Q^\ast(b)
=
\frac{
\sum_{\alpha\in\mathcal F_Q\setminus\{0\}}
|S_b(\alpha)|^2
}{
(N-1+Q^2)\sum_h|b_h|^2
}.
}
\]

If \(\mathfrak S_Q\) is large but \(\mathfrak S_Q^\ast\) is small, the apparent saturation comes mainly from a nonzero mean rather than oscillatory frequency structure.

## T74 - critical resolution parameter

Define

\[
\lambda=\frac{Q^2}{N}.
\]

Then:

- \(\lambda\ll1\): interval-length term dominates the large-sieve scale;
- \(\lambda\asymp1\): transition/critical regime;
- \(\lambda\gg1\): frequency-family term dominates.

A meaningful EXP-03 should sample all three regimes rather than optimize \(Q\) after inspection.

## T75 - what would count as a mechanism signal

A large value of \(\mathfrak S_Q\) is not automatically a gain. It means the residual sequence nearly saturates a generic upper bound.

The relevant diagnostics are:

1. full saturation \(\mathfrak S_Q\);
2. oscillatory saturation \(\mathfrak S_Q^\ast\);
3. dependence on \(\lambda=Q^2/N\);
4. comparison plain versus inverse/Mobius;
5. stability across prime and length windows.

The growing-modulus mechanism would be analytically interesting if it exposed a reproducible spectral organization not attributable only to the zero mode or a single hand-picked denominator.

## T76 - no Couret attribution at this stage

After the negative EXP-01 and EXP-02 gate comparisons, EXP-03 deliberately removes the Couret-vs-complement contrast from the primary endpoint.

The primary question is now

\[
\boxed{
\text{How close is the inverse residual shift spectrum to the large-sieve envelope?}
}
\]

Only after this mechanism is understood would it be meaningful to ask whether the historical Couret routing contributes causally.

## Epistemic status

- T71: **[D] elementary Farey spacing**.
- T72: **[L] classical analytic large-sieve inequality**.
- T73: **[D] normalized consequence of T72**.
- T74: **[D/I] dimensionless regime classification**.
- T75: **[M] experimental interpretation**.
- T76: **[M] causal-scope decision after negative gate tests**.
- Any new power saving: **[O]**.
