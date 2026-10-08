# COURET–OAI–BRIDGE–01 — EXP-04 critical-scale spectrum (PRE-FROZEN PROTOCOL)

> RESEARCH BRANCH • EXPLORATORY SCALING CHECK • NOT PEER REVIEWED • NO RH CLAIM • NO NEW POWER-SAVING CLAIM.
>
> Protocol recorded **before** EXP-04 calculations were inspected. EXP-02 and EXP-03 outcomes already informed the *choice of question*; EXP-04 is therefore not an independent validation of their discoveries.

## Question

At increasing arithmetic scales, with **one deterministic, non-optimised** frequency cap satisfying Q²/N≈1, does the nonzero Farey-frequency saturation of the Möbius shift residual decrease, remain comparable, or increase? Compare squarefree support without Möbius signs, not only all-positive coefficients.

## Frozen design

- Prime windows `P<p<=2P`, `P=[100,200,400,800,1600]` (exclude p dividing 30).
- `X/P=[8,16]`. Fixed triangular `W(t)=max(0,1-2*abs(t-1.5))` on [1,2].
- Three coefficient channels for gcd(n,30)=1: `plain=1`, `squarefree=abs(mu(n))`, `inverse=mu(n)`; 0 otherwise.
- For each p,X, define `b_h=sum_m a_(p*m+30*h)*a_m*W((p*m+30*h)/X)*W(p*m/X)` for **h≠0**. All sums finite; never insert h=0.
- Fix `Ngeom` **before** examining inverse/squarefree values: the length of the smallest integer interval from nonzero h appearing in the **plain** sequence (same p,X); this is used as denominator support length for *all* three channels. Also record each channel's observed support length diagnostically; Ngeom is conservative and comparable by construction.
- Set `Href=2*X/30` and choose **Q(X)=the integer q>=7 with gcd(q,30)=1 nearest to sqrt(Href)**, ties toward smaller q. This mapping uses only X, not b or a result. Keep Q even if observed `lambda=Q²/Ngeom` differs from 1. No result-dependent frequency selection.
- Farey family `F_Q={0} union {a/q mod1 : 2<=q<=Q, gcd(q,30)=1, 1<=a<q, gcd(a,q)=1}`.
- `S_b(alpha)=sum_h b_h exp(-2*pi*i*alpha*h)`; energy `E=sum_h |b_h|²`. Primary endpoint `sat_nonzero=sum_{alpha in F_Q excluding 0}|S_b(alpha)|² / ((Ngeom-1+Q²)*E)` (zero for E=0, counted separately), secondary `sat_full` including zero, `zero_share`, lambda.
- Summaries by P, ratio, channel: prime count, mean, median, 25%-75% percentiles, min/max, mean lambda, and zero-energy counts. Individual prime records retained.
- Geometric primary reference: arithmetic mean over all primes of each window, **never weight windows by their number of primes for scaling**. Show both length ratios separately.
- Scaling descriptive slopes: least-squares slope of `log(mean sat_nonzero)` against `log(P)` for the three largest P values [400,800,1600], both ratios separately (if all means strictly positive); no fitting-window selection.
- Descriptive uncertainty only: 512 bootstrap replicates resampling primes *within* (P,ratio,kind), RNG seed 20261008, 5%-95% slope percentiles. Prime outcomes are deterministic and windows share an X dependence, hence intervals are not inferential confidence statements.
- Strong finite decay pattern requires, **in both ratios**, consecutive means 400>800>1600, fitted slope <=-0.25, and bootstrap upper 95th percentile <0. No pattern means NO SCALING SIGNAL DETECTED. This is a conservative **experimental decision rule, not a theorem**. Even passing is not proof of asymptotic power saving.
- Sign-specific descriptive effect requires inverse minus squarefree mean nonzero saturation to have a constant sign and absolute difference >=0.01 for each of P=[400,800,1600], both ratios. No Couret chi5 subgroup is primary, because EXP-01/02 were negative.
- No automatic p-value; do not treat 10 regimes or repeated ratios as independent samples. Any adjusted P,Q,threshold or window after outcomes is a **new exploratory analysis** with separate label.

## Required exact checks before results

1. Cross-check `b_h` from direct loops on tiny synthetic cases and remove h=0 exactly.
2. For packet Fourier values `B_r=sum_{h=r mod q}b_h`, check direct sums vs FFT and finite Parseval `sum_a |DFT(B)_a|² = q*sum_r |B_r|²`.
3. Verify every q chosen is coprime to 30, no duplicated reduced frequencies; computed `sat_full,sat_nonzero` within [0,1+1e-8].
4. Confirm positive geometric support interval and `Ngeom>=Nobserved` for all channels, and that same normalization is used on controls.
5. Save exact script version and machine-readable rows, summaries, hashes and observed failures, including negative outcomes.

## Epistemic firewall

EXP-04 is scale testing of a classical large-sieve observable, not an RH route. The upper bound `(N-1+Q²)E` is classical. No conclusion about `chi5`, Couret-specific cancellation, additional power saving, a zero-free region, or mathematical novelty without independent analytic argument and prior-art audit.
