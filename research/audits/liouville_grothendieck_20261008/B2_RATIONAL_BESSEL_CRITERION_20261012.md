# CU-BRUIT-02 — B2R: fully rational Bessel-tail criterion under explicit unverified inputs

**Research note — 12 October 2026. No new prime theorem or originality claim.**
Branch: `research/cu-bruit-02-b2-tail-20261012`. The merged PR #4 remains unchanged; this is an **additional** independent review packet.

## Precise problem and conditional lemma

Assume a valid Rubinstein–Sarnak random-phase representation for the selected weighted prime race (GRH and the appropriate LI assumptions are not proved). Let

`X = mu + X_{<=T} + S_T`, with `S_T = sum_{gamma>T} 2 b_j cos U_j`, `b_j=|c_chi|/sqrt(1/4+gamma_j^2)`.

The phases `U_j` are independent uniform circle variables, and the nonzero finite variance of the **actual** tail is `V_T=2 sum_{gamma>T} b_j^2`. Let `G_T` be an independent Gaussian `N(0,V_T)`, and let `j_{0,1}` be the first positive zero of `J_0`.

For `M>=sup_{gamma>T} b_j` and `H>0` with `2 M H<j_{0,1}`, suppose `m>=1` actual low-frequency phase factors of `X_{<=T}` have coefficients `b_1,...,b_m>0`. Then

`|P(X>0)-P(mu+X_{<=T}+G_T>0)| <= L(H)+R(H)`,

where

`L(H) = M^2/[4 pi V_T (1-(2 M H/j_{0,1})^2)]`

and

`R(H) = [4/(m pi)] * product_{k=1}^m [1/sqrt(pi b_k H)]`.

This is a **sufficient inequality** derived from classical Bessel-product bounds, not a claimed new theorem.

### Proof of the two-frequency split

The Hadamard product `J_0(z)=prod_{k>=1}(1-z^2/j_{0,k}^2)`, plus the series at zero, gives `sum_k j_{0,k}^{-4}=1/32`. For `|z|<j_{0,1}`, expand the logarithm of the product and bound all powers `r>=2` by the fourth-power Rayleigh sum:

`0 <= -log J_0(z)-z^2/4 <= z^4 / (64 * [1-(z/j_{0,1})^2])`.

Thus, if `0<=t<=H` and `q=(2 M H/j_{0,1})^2<1`, writing the actual tail characteristic function as `phi_S(t)=prod_j J_0(2 b_j t)` and its Gaussian surrogate as `phi_G(t)=exp(-V_T t^2/2)`,

`|phi_S(t)-phi_G(t)| <= exp(-V_T t^2/2) * [M^2 V_T t^4/(8(1-q))]`.

Here `sum b_j^4<=M^2 sum b_j^2=M^2 V_T/2`. The (Gil–Pelaez/Fourier) difference of sign probabilities is bounded by `(1/pi) int_0^infinity |phi_low(t)| |phi_S(t)-phi_G(t)| dt/t`, where the deterministic mean is a unimodular factor and `|phi_low|<=1`. Integrating on `[0,H]` and using `int_0^infinity t^3 exp(-V_T t^2/2) dt = 2/V_T^2` gives `L(H)`.

For `t>=H`, use the known uniform bound `|J_0(x)|<=sqrt(2/(pi x))` for `x>0`, so each of `m` true low factors contributes at most `1/sqrt(pi b_j t)`. All other characteristic factors have modulus at most 1, and `|phi_S-phi_G|<=2`. Integrating `(2/pi) prod_j (pi b_j)^{-1/2} int_H^infinity t^{-1-m/2}dt` gives `R(H)`. This establishes the split inequality; continuity is ensured by the independent low factors and the convergence assumptions.

Classical references: NIST DLMF §10.21(iii) (Bessel infinite products), https://dlmf.nist.gov/10.21 ; Watson, *A Treatise on the Theory of Bessel Functions*, pp.205–208 for the global J0 modulus bound (a proof is discussed at https://math.stackexchange.com/questions/1447137/conjectured-bound-on-bessel-function-of-the-first-kind).

## An EXACT rational implication — its assumptions are NOT established

Use conservative *algebraic* substitutions:
- T=25, H=9/2, `M<=3/25` from the maximum Fourier coefficient 3.
- `pi>314/100` and `j_{0,1}>2` (the latter also follows elementarily since the alternating J0 series stays positive on [0,2]).
- **UNVERIFIED ASSUMPTION A:** actual spectral-tail variance `V_25>=3/4`.
- **UNVERIFIED ASSUMPTION B:** 18 distinct positive ordinates of the indicated conductor 3/5 characters are genuinely zeros with `1<=gamma_j<=U_j<25`, where `U_j` are the conservative six-decimal upper numbers printed in `verify_bessel_rational_criterion.py`.
- **UNVERIFIED ASSUMPTION C:** correct independent-phase analytic model (GRH/LI and signed-zero conventions).

For `gamma>=1`, `sqrt(gamma^2+1/4)<=gamma+1/8`, hence `b_j>=|c_j|/(U_j+1/8)`. The 18 factors require no conductor-15 ordinate data for the **high-frequency product bound**. For these choices, `q<=(2*(3/25)*(9/2)/2)^2=729/2500`.

All arithmetic of the implication is performed with Python `fractions.Fraction` and integer `isqrt`, with outward rational bounds on every square root and without float quadrature. The resulting outward rational components are approximately:

- low-frequency integral contribution `L<=0.00215790856`;
- high-frequency integral contribution `R<=0.00015621593`;
- combined outward estimate about `0.00231412449` and an **exact rational assertion** `L+R < 3/1250 = 0.0024`.

**Proper claim: IF A, B and C hold, THEN the Gaussian-tail replacement changes the conditional model sign probability by less than 0.0024.** This is substantially narrower than the earlier *illustrative* Berry–Esseen envelope of approximately 0.1283. It is **not** a 0.0024-certified error for the actual CU-BRUIT probability or a proof of 0.2894: A and B have not been certified; the 37 conductor-15 candidates remain 0/37 externally matched, and the quadrature of the Gaussian-surrogate probability has no certified interval.

## Exact reproducibility

```bash
python research/audits/liouville_grothendieck_20261008/verify_bessel_rational_criterion.py --check
```

The script checks eighteen transcriptions against the previously committed `lmfdb_zero_comparison_20261009.json`, but the comparison is only to a decimal-matched catalog, not to source-proved zero intervals. It fails if the rational criterion `<0.0024` does not hold. **A CI PASS is a check of the rational implication under the assumptions, not a successful input certification.**

## Next gates, in order

1. Certify a usable lower bound `V_25>=0.75`, e.g. using validated L'/L constants and a validated low-zero contribution or rigorously established zero counting.
2. Independently obtain valid 18 low-zero enclosures; require provenance and upper interval endpoints, not just decimal agreement. This can be tackled using the conductor 3/5 data before q15.
3. Resolve conductor-15 37/37 candidates and zero counting under the required signed index convention to evaluate the Gaussian-surrogate law itself.
4. Interval-certify Bessel-product inversion/quadrature, then combine error budgets; do not report an unconditional density or originality.

**Publication gate:** research-only, no merge/release and no additional unsolicited researcher emails.
