# CU-BRUIT-02 — quantitative specialization and finite non-resonance

13 October 2026. Internal derivations and exact receipt arithmetic, offered
for independent review. This note separates arithmetic convergence, approximation
of a defined independent-phase law, and evaluation of a sign probability.
The reference is Bailleul, Hayani and Untrau,
[*A Wasserstein metric approach to generalized Skewes' numbers. I. Prime number races*](https://arxiv.org/html/2603.20093v2).
No correspondence or private message is published by this note.

## 1. Observable and exact specialization parameters

Put `t=8*1_{1,11,29}-3` on `U(30)` and
`D(x)=sum_a t(a)*pi(x;30,a)`. The average of t is zero. The normalized
Fourier transform uses `(1/8)*sum_a t(a)*conj(chi(a))`.
Write `chi_(e,k)=chi_-3^e*chi_5^k`, with `chi_5(2)=i`.

| Character (e,k) | Fourier coefficient | Primitive conductor |
|---|---:|---:|
| (0,0) | 0 | 1 |
| (0,1) | 1 | 5 |
| (0,2) | 3 | 5 |
| (0,3) | 1 | 5 |
| (1,0) | -1 | 3 |
| (1,1) | 1 | 15 |
| (1,2) | -1 | 15 |
| (1,3) | 1 | 15 |

For a nonprincipal character, the coefficient equals the sum over the three
support elements. Their residues modulo 5 are 1,1,4 and modulo 3 are 1,2,2;
these yield the table directly. The verifier recalculates it with integer
pairs for Gaussian integers, not floating-point complex arithmetic.
The normalized Parseval sum is 15, `lambda(t)=9`, and `||t_hat||_infinity=3`.
Since `t(a^2)=1+4*chi_(0,2)(a)`, `lambda(t*)=5`. There are four square roots
of each of 1 and 19 in U(30), giving `-<t,r_30>=-1`.
The mean -1 requires the absence of central zeros as in the pinned model;
non-resonance of *positive* ordinates alone does not establish that absence.

The parameters of the cited article are therefore

```text
C(t)=max(9*(log 30)^2,5*log 30)=9*(log 30)^2,
B=|supp(t_hat)|*log k(t)=4*log 3+6*log 5,
k(t)=(3^4*5^6)^(1/7), |supp(t_hat)|=7, epsilon=3.
```

All seven nonprincipal primitive characters contribute. Positive ordinates
of complex conjugate characters are separate lists: conjugation reverses
the sign of the ordinate. The [full-tail proof](ALL_TAIL_BOUNDS_20261013.md)
keeps those conventions and central-zero exclusion explicit.

## 2. Conditional rates, with all hypotheses retained

Let `E(y)=y*exp(-y/2)*D(exp(y))`, let mu_X be its law for uniform y in
`[log 2,X]`, and let mu be the independent-phase limit law. Here X is a
*logarithmic* horizon; the upper prime-counting argument is exp(X).
The article's conjecture 4.1, ELI_A with A>1, concerns the positive zero
multiset of the Fourier support. For every sufficiently large T and every
nonzero integer m with `||m||_infinity<=N(T)`, it assumes

```text
|m.gamma| >= c_A*N(T)^(-N(T)^A),  c_A>0.
```

To compute an error, a numerical witness c_A and a validity threshold T_A
are needed; neither is produced by the finite zero receipts. ELI_A implies
LI for fixed finite relations by passing to sufficiently large T.

With C and B above, Theorems 5.13 and 5.17 specialize, under GRH and ELI_A,
at horizons `X>=B^((Lcal*B)^A)`, to

```text
W1(mu_X,mu)
 <= K_A*C^(3/2)*(log C)^(1/(2A))*(log log X)^2/(log X)^(1/(2A)),
|F_X-delta|
 <= K_(A,3)*C^(3/4)*(log C)^(1/(4A))*(log log X)/(log X)^(1/(4A)),
F_X=(X-log 2)^(-1)*integral_[log 2,X] 1_{D(exp y)>0}dy.
```

K_A, K_(A,3) and Lcal stand for the constants in the published statements,
not evaluated constants set to 1. The extra Fourier-size hypothesis for
Theorem 5.17 is verified exactly. These are valid conditional
specializations, not numerical guarantees at a selected practical horizon.
Qualitative GRH+LI identification of the independent-phase law does not
by itself supply a uniform quantified rate.

## 3. What a finite gap does, and what positivity alone misses

For `L=X-log 2` and `omega=m.gamma`, the normalized time Fourier coefficient
is the integral of `exp(i*omega*y)` over that interval. When omega is nonzero,
its modulus is `2*|sin(omega*L/2)|/(L*|omega|)` and is bounded by
`min(1,2/(L*|omega|))`. A tiny positive gap can therefore leave a coefficient
near 1. For example, `(1,1+eta)` with arbitrarily small irrational eta is
linearly independent over Q, while its (1,-1) mode remains nearly constant
when `L*eta` is small. This is a torus example, not a claimed pair of L zeros.

Under LI, the orbit closure is the full product torus. Theorem 3.4 gives,
for n=N(T), resolution M and a certified lower bound `d<=Delta(T,M)`,

```text
Q_TMX=4*sqrt(3*n)/M
 + 2/L*sqrt(sum_[0<||m||_inf<=M] 1/(||m||_2^2*|m.gamma|^2))
 <=4*sqrt(3*n)/M+2*sqrt(S_nM)/(L*d),
S_nM=sum_[0<||m||_inf<=M] 1/||m||_2^2 <=(2*M+1)^n-1.
```

Thus d must be numerical and compared to L; the number and weights of modes
matter. A certificate at one M does not prove global LI. Without LI the
article's orbit Haar measure may be supported on a proper subtorus.
This note retains LI when applying its stated theorem to full Haar.

Let L_T=sqrt(2*V_low), the Lipschitz constant of the finite projection, and
let A_arith be the averaged absolute error between E and its spectral
truncation E_T. Coupling the independent phase tail gives

```text
W1(mu_X,mu) <= R=A_arith+L_T*Q_TMX+sqrt(V_tail).
|F_X-delta| <= min(1,2*sqrt(H*R)), if ||f_mu||_infinity<=H.
```

The article's Lemma 5.8 bounds A_arith in terms of
`C*(log T/sqrt T+1/sqrt X)`; its multiplicative constant still needs to be
explicit for a numerical certificate. At fixed T and M the resolution and
tail terms do not vanish by merely increasing X. A rate for the full law
requires jointly increasing T,M and controlling the relevant gaps.

## 4. New finite result: the entire T=4 truncation

The pinned 67-root certificates are complete below 25 within their stated
trust boundary. Exactly two positive ordinates lie below 4: the first zeros
of Conrey 15.2 and 15.14. All remaining root intervals lie strictly above 4.
The new [stdlib checker](verify_quantitative_specialization_20261013.py)
propagates both endpoints of the two rational intervals through **every**
nonzero integer vector with `||m||_infinity<=64`. There are **16,640** vectors.
No propagated interval contains zero. The minimum of their distances to
zero is attained by the interval for `(-17,19)` and its negative:

```text
Delta(4,64) >= 1183909348980774875979191422617989/10^35
             > 0.011839.
S_(2,64) < 30.
```

The rational square-root bounds `sqrt(6)<49/20` and `sqrt(30)<11/2` then give,
under LI for the full-Haar use of Theorem 3.4,

```text
W1(two-frequency time occupation, two-dimensional Haar)
 <=49/320+11000000/(11839*(X-log 2)).
```

The two-frequency projection has Lipschitz constant <1, so the same majorant
also bounds the **two-frequency projected laws**. The nonvanishing conclusion
is finite and conditional on source enclosures, not on ELI. The displayed
W1 majorant includes neither A_arith nor the rest of the phase law. It must
not be called a bound for the full prime race or Delta(25,67).

## 5. New exact anti-concentration bound for the full Q5 phase law

The twelve low-phase witnesses in
[all_tail_bounds_20261013.json](all_tail_bounds_20261013.json) give
`C_B=6914450088843/10^12`. The new verifier checks each amplitude lower bound
against its root interval and Q5 weight, rejects duplicated witnesses, and
checks `C_B^2*product(a_j)>=(2/3)^12` with exact fractions.

The Bessel bound `|J0(x)|<=min(1,sqrt(2/(pi*x)))` for x>0 yields
`|phi(u)|<=min(1,C_B*|u|^-6)`. The other independent factors have modulus
at most 1. The proof of this envelope follows from the energy of
`sqrt(x)*J0(x)` and its asymptotic limit; see the
[existing written proof](Q15_TAIL_BOUNDS_20261012.md#5-passage-aux-probabilités-de-seuil-sans-quadrature),
and NIST DLMF [10.2](https://dlmf.nist.gov/10.2),
[10.9](https://dlmf.nist.gov/10.9), [10.17](https://dlmf.nist.gov/10.17).
These analytic facts are not established by the finite program alone.

Fourier inversion, splitting at `a=69/50`, and pi>3 give

```text
||f_mu||_infinity <=1/pi*(a+C_B/(5*a^5))
 <13816087424921/25024501584000 <553/1000.
mu([-h,h])<=553*h/500.
```

This holds for the independent-phase Q5 law and its truncation at 25, where
all twelve witnesses are retained. The verifier also recomputes
`2.412114<V_low<2.412115`, `L_25<2.197` and the conservative coupling
`sqrt(V_tail)<0.918`. The density bound does not produce A_arith, ELI,
or a small W1 error. Its arithmetic interpretation remains conditional.

## 6. Precision obstruction for T=25 and M=67

For n positive frequencies below T, the (M+1)^n subset sums with integer
coefficients between 0 and M lie in an interval of length M*sum(gamma_j).
Consecutive sums yield a nonzero signed vector with coefficients at most M:

```text
Delta(T,M)<=M*sum(gamma_j)/((M+1)^n-1)<M*n*T/((M+1)^n-1).
```

A coincident pair already gives a resonance. For n=M=67, T=25 the upper
bound is `112225/(68^67-1)<1.88e-118`. Apply the same argument to the
**rational centres** of the pinned root boxes: their small combination
has modulus <1.88e-118, whereas direct interval propagation has radius
`sum |m_j|*10^-30>=10^-30`. Thus at least one propagated combination
necessarily contains zero. The current boxes cannot certify all modes
in this range by treating them as independent intervals.

This does not disprove LI or ELI, does not determine the actual gap,
and does not rule out finer enclosures or additional joint information.
The full signed box has about `5.40e142` nonzero modes; a partial lattice
search cannot certify the unexplored modes by absence of a discovered relation.

## 7. Relation to the Q5 probability receipt

The [existing internal Q5 inversion](Q5_CONDITIONAL_PROBABILITY_20261013.md)
keeps all 67 low phases and uses `W in [0.747557,0.842503]`. Its replacement
error for the *entire* high tail is <=0.001714 and is already included once
in the reported model interval **[0.286450,0.292650]**.
This checker does not recompute that probability or change its inputs.

Under GRH+LI, central-zero exclusion and the correct explicit formula, the
arithmetic logarithmic density equals the independent-phase sign probability.
If the pinned certificates and written arguments are also valid, the model
interval transfers to that density **conditionally**. A frequency at finite
logarithmic horizon X requires an additional arithmetic error: if one is
proved as eps_arith(X), expand the model interval by eps_arith(X), clipping
to [0,1]. Do not add 0.001714 again. No eps_arith(X) is established here.

## 8. Reproduction and remaining guarantees

Source receipts are pinned by SHA-256; the source commit is
`cc2c15c7320153478e0782204d95c4a68cb76d7f`. Reproduction uses Python's
standard library only, without site packages or FLINT:

```bash
python -S research/audits/liouville_grothendieck_20261008/verify_quantitative_specialization_20261013.py --check
python -S research/audits/liouville_grothendieck_20261008/test_quantitative_specialization_20261013.py
```

The [new receipt](quantitative_specialization_20261013.json) records the
exact gap, weighted sum, witness bounds, Fourier identities and explicit
scope flags. Eleven adversarial controls cover cancellation, interval
overlap with zero, extremely slow near-resonance, oversized search space,
duplicate or inflated phases, an undersized envelope, wrong Q5 weights,
missing roots, altered source bytes and an impermissible scope promotion.
Local replay and all eleven controls passed before integration into CI.

The producers' analytic enclosures must still be trusted or independently
audited. No global GRH/LI/ELI proof, independent human review, unconditional
prime density, finite-horizon arithmetic certificate, merge, release or
priority claim follows. The general mechanism and quantitative theorem
are prior literature; these are specializations and finite audit outputs.
