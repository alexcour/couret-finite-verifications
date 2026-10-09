# EXP-11 — exact prime-parity second moments

**Research only. Protocol frozen at commit `94fda41a106a07420bc7cbe453939a7020012686` before computing EXP-11 observations. Not independent of previous design choices. No RH / zero-free region / new asymptotic bound / priority claim.**

## Definitions and exact identities

For independent prime signs ε_l and the classical squarefree-supported Rademacher multiplicative function `f(n)=mu(n)^2 prod_{l|n} ε_l`, let each admissible pair `(n,m)` have label `t=nm/gcd(n,m)^2` and a nonnegative integer tent weight. Since both n,m are squarefree, `t` is the parity-of-prime-factors symmetric difference. Writing `B_h=Σ_t c[h,t] ε(t)`, with positive integer packet weights `c[h,t]`, exact prime-sign orthogonality yields

`C(h,k)=E[B_h B_k]=Σ_t c[h,t] c[k,t]`.

With `K_Q` the integer Ramanujan/Farey kernel, `M=K_Q(0)` and `Ebar=Σ_h C(h,h)`, the exact averaged spectral numerator is `Nbar=Σ_h,k K_Q(h-k) C(h,k)` and `rho=Nbar/(M Ebar)` for `Ebar>0`. **rho is the ratio of expected quadratic forms, NOT E[D].** The true deterministic Möbius vector is `B_h(mu)=Σ_t c[h,t]mu(t)` exactly.

## Frozen experiment

Windows `P=100,200,400,800`, ratios `X/P=8,16,32`, all primes `P<p<=2P` coprime to 30, full tent and U(30) restrictions, and all nonzero shifts. Q is the nearest integer >=7 coprime to 30 to sqrt(Ngeom), chosen from the plain geometry only. Original 8/16 ratios retrospective; 32 an exploratory, non-blind extension. Complete 678 prime/scale cells. All arithmetic numerator calculations use integers; floating divisions only for reported ratios.

## Outcome

|P|ratio=32: mean rho|ratio=32: true mean D|mean D-rho|
|---:|---:|---:|---:|
|100|0.999407248|0.959979234|-0.039428014|
|200|0.997158258|0.923503375|-0.073654883|
|400|0.997204040|0.964869195|-0.032334845|
|800|0.997956972|0.994714834|-0.003242139|

The shift-reuse effect is small: `mean rho` differs from 1 in these four regimes by -0.000593, -0.002842, -0.002796 and -0.002043. All four relative deviations are **smaller than 0.05**, the frozen structural screen. The deterministic gaps all have negative sign but are less than 0.10 in magnitude; the frozen deterministic screen also fails. Verdict: `NO_STRONG_STRUCTURAL_SHIFT`; `NO_ROBUST_DETERMINISTIC_RESIDUAL`.

The re-use fraction of labels (labels appearing on >=2 shifts) on the four ratio-32 cells is about 2.26%, 2.48%, 2.42%, and 2.46%. Reuse occurs, but its exact weighted contribution does not explain a large systematic departure of the ratio-of-moments. This is a finite observation, not a bound uniform in parameters.

## Verification and limits

300 Möbius values against trial division, 100 Ramanujan/Fourier comparisons, and 8 synthetic finite exhaustive sign models pass. The result contains 678 individual records and 12 regime summaries. Algebraic proofs use independence of prime signs, not numerical extrapolation. The EXP-10 16-replicate mean of normalized D **must not** be silently replaced by rho; the two expectations are non-interchangeable in general. T89, the deterministic four-affine-form uniformity problem, remains open. Avoid p-values or any claim on RH.
