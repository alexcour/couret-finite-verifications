# COURET–OAI–BRIDGE–01 — T57–T63 prime-family contrast and quadratic-gate test

> **RESEARCH BRANCH — NOT PART OF v1.0.0 — NO RH CLAIM — NOT PEER REVIEWED**
>
> This note turns the Couret prime gate into a balanced family statistic. The central exact reduction is that any selected-versus-complement residual contrast is a covariance with the quadratic character \(\chi_5\). After phase normalization, the matched residual itself is independent of the mod-30 character channel.

## T57 — exact gate projector

Let \(\chi_5\) be the quadratic Dirichlet character modulo 5, restricted to primes \(p\nmid30\).

Because

\[
K_4=\{1,11,19,29\}=\ker\chi_5
\]

inside \(U(30)\), one has for every prime \(p\nmid30\)

\[
\boxed{
\mathbf 1_{p\bmod30\in K_4}
=
\frac{1+\chi_5(p)}{2}.
}
\]

Likewise

\[
\boxed{
\mathbf 1_{p\bmod30\notin K_4}
=
\frac{1-\chi_5(p)}{2}.
}
\]

Thus the Couret-selected and complementary prime classes are the two eigensets of one quadratic character.

## T58 — balanced selected-versus-complement contrast

Let \(\mathcal P\) be any finite set of primes coprime to 30, and let \(Z_p\in\mathbb C\) be any statistic attached to \(p\).

Write

\[
\mathcal P_+
=
\{p\in\mathcal P:\chi_5(p)=1\},
\qquad
\mathcal P_-
=
\{p\in\mathcal P:\chi_5(p)=-1\},
\]

with sizes \(N_+,N_-\), and \(N=N_++N_-\).

Define

\[
\mu_+
=
\frac1{N_+}\sum_{p\in\mathcal P_+}Z_p,
\qquad
\mu_-
=
\frac1{N_-}\sum_{p\in\mathcal P_-}Z_p,
\]

and

\[
S=\sum_{p\in\mathcal P}Z_p,
\qquad
T=\sum_{p\in\mathcal P}\chi_5(p)Z_p.
\]

Then exactly

\[
\boxed{
\mu_+-\mu_-
=
\frac{
N\,T-(N_+-N_-)\,S
}{
2N_+N_-
}.
}
\]

This formula corrects finite-sample imbalance between the two prime groups.

## T59 — covariance form of the Couret contrast

Equip \(\mathcal P\) with the uniform probability measure. Then

\[
\boxed{
\operatorname{Cov}_{\mathcal P}(Z,\chi_5)
=
\frac{2N_+N_-}{N^2}
(\mu_+-\mu_-).
}
\]

Equivalently,

\[
\boxed{
\mu_+-\mu_-
=
\frac{N^2}{2N_+N_-}
\operatorname{Cov}_{\mathcal P}(Z,\chi_5).
}
\]

After the structural diagonal is removed, a residual Couret gate effect is therefore exactly a covariance with \(\chi_5(p)\).

## T60 — fair matched residual for every prime residue

For every prime \(p\nmid30\), let \(a=p\bmod30\). Define

\[
C_{p,a}(X)
=
\sum_{\substack{n,m\\n\equiv am\ (30)}}
a_n\overline{a_m}
W(n/X)\overline{W(pm/X)}.
\]

Since \(a\equiv p\pmod{30}\), the natural diagonal \(n=pm\) is present in this matched channel for every unit residue class.

Define

\[
L_p(X)
=
\sum_m
a_{pm}\overline{a_m}
|W(pm/X)|^2
\]

and

\[
\boxed{
R_p(X)
=
C_{p,p\bmod30}(X)-L_p(X).
}
\]

Thus \(R_p\) is a diagonal-removed statistic defined on all eight prime residue classes.

For causal testing, one must compare these underlying matched residuals across selected and complementary classes. Otherwise one merely rediscovers the structural zero/nonzero weights built into the Couret autocorrelation kernel.

## T61 — phase-normalized matched residual is character-independent

Let \(\psi\) be any Dirichlet character modulo 30.

### Plain coefficients

Take \(a_n=\psi(n)\). For every matched pair \(n=pm+30h\),

\[
\psi(n)\overline{\psi(m)}
=
\psi(p)|\psi(m)|^2.
\]

On the unit support, \(|\psi(m)|^2=1\). Hence

\[
\boxed{
\overline{\psi(p)}\,R^{\rm plain}_{p,\psi}(X)
=
R^{\rm plain}_{p,\mathbf1}(X).
}
\]

### Möbius/inverse coefficients

Take \(a_n=\mu(n)\psi(n)\). The same residue identity gives

\[
\boxed{
\overline{\psi(p)}\,R^{\rm inv}_{p,\psi}(X)
=
R^{\rm inv}_{p,\mathbf1}(X).
}
\]

Thus, after phase normalization, the eight mod-30 character channels collapse to one plain residual problem and one Möbius residual problem.

## T62 — residual Couret contrast becomes a quadratic-prime-twisted Möbius form

For the inverse/Möbius matched residual, define the phase-normalized statistic

\[
H_p(X)
=
\overline{\psi(p)}\,R^{\rm inv}_{p,\psi}(X).
\]

By T61 this is independent of the chosen mod-30 character \(\psi\).

The unnormalized selected-minus-complement contrast is

\[
\boxed{
\sum_{p\in\mathcal P}\chi_5(p)H_p(X).
}
\]

Expanding the shifted remainder gives a trilinear form of the shape

\[
\boxed{
\sum_{p\in\mathcal P}
\chi_5(p)
\sum_{h\ne0}
\sum_m
\mu(pm+30h)\mu(m)
\,\mathcal W_{p,h,m}(X).
}
\]

This is the first prime-family analytic target remaining after the finite Couret structure has been factored out.

Any nonzero residual contrast is a correlation between the quadratic prime label \(\chi_5(p)\) and Möbius correlations along \(pm+30h\) and \(m\).

## T63 — causal control: compare all nontrivial quadratic gates

The group \(U(30)\simeq C_4\times C_2\) has exactly three nontrivial real-valued characters.

The Couret triplet singles out \(\chi_5\) because its Fourier power is maximal on \(\{\mathbf1,\chi_5\}\).

For each nontrivial quadratic character \(\xi\) on \(U(30)\), form

\[
\boxed{
\Gamma_\xi(X)
=
\operatorname{Cov}_{p\in\mathcal P}
(H_p(X),\xi(p)).
}
\]

Then compare

\[
|\Gamma_{\chi_5}(X)|
\]

against the two other quadratic controls, with the same prime window, normalization, and diagonal subtraction.

A Couret-specific residual effect requires more than \(\Gamma_{\chi_5}\ne0\). At minimum one should observe a reproducible excess of the \(\chi_5\) channel over the other quadratic gates and over matched randomized residue partitions.

## Experimental protocol after T63

For dyadic prime windows \(P<p\le2P\) and length scales \(X\):

1. compute \(R_p(X)\) after exact removal of \(L_p(X)\);
2. phase-normalize when using a character channel;
3. normalize by the T51 counting scale and/or T52 energy scale;
4. record \(N_+,N_-\);
5. compute the balanced contrast by T58;
6. compute covariance \(\Gamma_{\chi_5}\);
7. compute the same covariance for the other two quadratic characters;
8. repeat for plain and Möbius/inverse coefficients;
9. repeat across several \((P,X)\) regimes;
10. pre-specify the test before inspecting outcomes.

A positive result is not a zero-free theorem. It would only justify continued investigation of a prime-family residual effect.

## Epistemic status

- T57: **[D] exact quadratic gate projector**.
- T58: **[D] exact finite-sample contrast identity**.
- T59: **[D] exact covariance identity**.
- T60: **[D] exact matched-residual definition and structural de-biasing**.
- T61: **[D] exact character-independence after phase normalization**.
- T62: **[D/I] exact reduction to a quadratic-prime-twisted Möbius form; analytic interpretation**.
- T63: **[M] causal experimental control design**.
- Nonzero or power-saving residual covariance: **[O]**.
