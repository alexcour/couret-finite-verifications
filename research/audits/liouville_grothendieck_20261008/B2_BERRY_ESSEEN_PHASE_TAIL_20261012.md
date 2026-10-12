# CU-BRUIT-02 — B2: a classical conditional Berry–Esseen bound for phase tails (12 October 2026)

**Scope**: mathematical lemma about independent Haar phases. It is NOT an unconditional prime theorem, a verified zero list, a certified variance, or a certified numerical sign density. New work is confined to branch `research/cu-bruit-02-b2-tail-20261012` derived from main after PR #4 integration, and does not alter the merged record.

## Lemma

Let the tail consist of independent random variables
`Y_j=2 b_j cos(U_j)`, with `b_j>=0`, independent `U_j` uniform on `[0,2 pi)`. Suppose `V=sum_j 2 b_j^2` is finite and strictly positive. For a finite tail, Berry–Esseen for independent, not necessarily identically distributed summands yields

`sup_x |P(S/sqrt(V)<=x)-Phi(x)| <= C_BE (sum_j E|Y_j|^3)/V^(3/2)`

with conservative `C_BE=0.56` (Tyurin, DOI 10.1137/S0040585X9798572X). Since `E|cos U|^3=4/(3 pi)`, `E|Y_j|^3=32 b_j^3/(3 pi)`. Hence

`d_K(S,N(0,V)) <= 0.56 * 16/(3*pi) * (max_j b_j)/sqrt(V)`.

For an infinite independent tail with `sum 2b_j^2=V<infinity`, the sums converge in L2 (and in distribution); apply the finite-tail inequality to partial sums and pass to the limit using continuity of the Gaussian cdf. Thus the same bound holds with `sup_j b_j`. This uses no knowledge of the zeta or Dirichlet zeros beyond the existence of the proposed independent-phase model.

If `W` is independent of the tail, convolution cannot increase Kolmogorov distance: `sup_x|P(W+S<=x)-P(W+G<=x)|<=d_K(S,G)`. Therefore the difference of strictly positive sign probabilities is at most this bound; any atom at the comparison threshold is handled by the left-limit formula. No density/anti-concentration bound is assumed for the low-frequency component.

## Prime-race-model specialization (conditional only)

For the frozen CU-BRUIT-02 Fourier coefficients, the maximal `|c_chi|` is 3. Within a **correct** Rubinstein–Sarnak product-phase representation indexed by each signed-zero convention, `b_(chi,gamma)=|c_chi|/sqrt(1/4+gamma^2)`. For all omitted positive ordinates `gamma>T`,

`M_T <= 3/sqrt(T^2+1/4)`.

If `V_T` denotes the true variance of **all** omitted independent phase factors, `V_T=sum_(gamma>T)2|c_chi|^2/(1/4+gamma^2)`, then

`|P(X>0)-P(X_(<=T)+G_T>0)| <= min(1, 0.56*16/(3*pi)*3/(sqrt(T^2+1/4)*sqrt(V_T)))`

where `G_T~N(0,V_T)` is independent of the low-phase sum. It is enough to supply a **certified positive lower bound** on `V_T` to obtain a valid numerical upper bound in this inequality. Computing `V_T` as an approximate difference of two noncertified numbers does not give one.

For `T=25` and the **uncertified exploratory** residual variance `V_T=0.7908925527`, the formula evaluates to approximately `0.12825448`. This is an illustration, NOT a certified bound for the prime race and far too coarse to claim precision on model probability `0.2894`.

The variance identity for each phase is `Var(Y_j)=2 b_j^2`. Character conjugacy sends an ordinate `gamma` of `chi` to `-gamma` of `bar chi`; it does NOT identify their positive ordinate lists. Separately verify the proper phase indexing under GRH and appropriate LI. The previous 37 local conductor-15 zero candidates have **0/37 external matches**; zero-count completeness, interval quadrature, gamma tails and prior art review remain open.

## Reproducibility

```bash
python research/audits/liouville_grothendieck_20261008/verify_berry_esseen_tail.py --self-test --illustrative
```

This script tests moment identities and algebraic monotonicity, **not** the probabilistic theorem nor zero completeness. Independent mathematical scrutiny is encouraged. Better Bessel-product/tail estimates are required before claiming a numerically useful error budget.

**Research gate**: A3 zero comparison HOLD, B1 conditional law under review, B2 illustrative inequality not numerical certificate. No merge, release, new data request or researcher follow-up.
