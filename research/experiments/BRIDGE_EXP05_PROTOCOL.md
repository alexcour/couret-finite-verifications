# COURET–OAI–BRIDGE–01 — EXP-05 PROTOCOL (frozen before inspection)

> Research branch; independent exploratory mechanistic control. No RH, power-saving, novelty, or asymptotic claim.

## Prior knowledge and question

EXP-01 found no chi5 specificity. EXP-02/03 reveal a nonzero Möbius shift-frequency spectrum. The existing EXP-04 and separate EXP-04B found finite-scale spectral persistence; EXP-04B compared coefficients 1, |mu|, mu. Their numerical outcomes informed EXP-05 design; this is not a fresh confirmation of those results.

**Question:** When the frequency set, support geometry and per-row energy are controlled, is Möbius spectral energy at reduced nonzero rational frequencies exceptional relative to (A) an *exact conditional independent sign-flip null on b_h* and (B) a *coefficient-level random-sign null preserving squarefree support*?

## Locked geometry and series

Prime windows: P in {100,200,400,800}, with P<p<=2P, p coprime to 30. Two length rules X=8P and X=16P; real tent W(t)=max(0,1-2|t-1.5|) for 1<=t<=2, zero otherwise.

On units modulo 30, coefficient arrays: plain a_n=1; squarefree a_n=|mu(n)|; inverse a_n=mu(n); zero off units. For each p,X construct b_h=sum_{m>=1} a_{pm+30h} a_m W((pm+30h)/X) W(pm/X) on nonzero integer h. There is NO h=0 term. Geometry Ngeom = inclusive min-to-max nonzero-h support length for the *plain* b_h at that exact p,X; use same Ngeom for all kinds, even if inverse vanishes at some shifts. Exclude zero-energy cases from conditional averages and report their counts.

Deterministic cap Q = integer >=7 coprime to 30 nearest sqrt(Ngeom), tie smaller. No tuning. Set FQstar={a/q mod 1: 2<=q<=Q, (q,30)=1, 1<=a<q, (a,q)=1}; M=|FQstar|.

## Exact primary benchmark

For E=sum_h |b_h|^2>0, define S(alpha)=sum_h b_h exp(-2 pi i alpha h), satstar=sum_{alpha in FQstar}|S(alpha)|^2/((Ngeom-1+Q^2) E). The independent Rademacher signs epsilon_h multiplying *fixed observed b_h*, independent over shifts, satisfy the **exact conditional expectation**

E_epsilon[satstar(epsilon b)] = M/(Ngeom-1+Q^2).

Hence primary **density-corrected ratio** D = satstar/[M/(Ngeom-1+Q^2)] = (sum_alpha |S(alpha)|^2)/(M E). No random p-values are attached to this expectation: it is an algebraic reference, not a sampling distribution. D>1 means excess vs the independent shift-sign expectation; D<1 a deficit.

Equivalent identity to test numerically:
(sum_alpha |S(alpha)|^2) - M E = sum_{h != k} b_h conj(b_k) K_Q(h-k), K_Q(d)=sum_alpha exp(-2pi i alpha d).
This is an **exact** weighted off-diagonal correlation identity; it does NOT by itself yield a number-theoretic cancellation bound.

## Second control: random signs at n level

For each of 16 replicates r=0,...,15, create an independent Rademacher sign vector epsilon_n using Numpy PCG64 seed 20261008+r for all n up to max(2X), the same vector across all p,X within that replicate. On units n with |mu(n)|=1 set a_n^(r)=|mu(n)|epsilon_n; otherwise 0. This null holds squarefree support at the n-level but destroys multiplicative sign structure. For each p,X compute the same b_h, Q, E, S, D. Aggregate per P, ratio, replicate by arithmetic mean over eligible primes. Also display inverse D minus surrogate-replicate mean D, and relative gap (inverse D/surrogate D -1).

## Prespecified summaries and decisions

For each of 8 regimes and kind report prime N, mean and median D, mean satstar, mean geometric N, mean M and Q, zero-energy counts. Also report mean of per-prime paired differences D(inverse)-D(squarefree), not solely ratio of means. For the coefficient-level null report 16 per-regime replica means and their min,max,5% and 95% descriptive quantiles (not confidence intervals).

**Uniform inverse shift-sign excess** only if mean D(inverse)>1.10 for *each* of eight regimes. Uniform inverse shift-sign deficit only if mean D(inverse)<0.90 for each regime; otherwise **no uniform conditional-null directional effect**.

**Consistent coefficient-level difference** only if (mean inverse D)/(mean surrogate D)-1 is consistently >=0.10 in all 8 regimes, or <=-0.10 in all 8 regimes. Otherwise **no robust directional difference on this panel**. The thresholds are pilot screening heuristics, not p-values or theorems.

No cherry-picking P or X ratios; do not treat repetitions/ranges as independent inferential replicates. Preserve all results including nulls and negatives.

## Required tests before seeing data

1. Direct enumerate n,m to verify b_h for several small p,X; ensure h=0 absent.
2. Direct complex-exponential S vs residue-class FFT S for multiple q, including negative h; finite Parseval.
3. Check algebraic random sign expectation by expanding diagonal terms, optionally numerical exhaustive n=2,3 toy sign-flips.
4. Check weighted off-diagonal identity on multiple small exact b sequences and sampled real b.
5. Verify all Q coprime to 30, fractions reduced/unique; 0<=satstar<=satfull<=1+1e-8; Ngeom covers all active shifts.
6. Save scripts, structured outputs, hashes; do not silently redefine endpoints on failure.

## Scope boundary

D can be >1 without any violation of the large sieve: it is a *fractional spectral-density correction* to a random-shift-sign reference. Surrogate signs do not model multiplicativity and are not an analytic comparison theorem. Neither the finite D nor its inverse-control difference proves or suggests by itself a power saving, a zero-free region, RH, a Couret-specific chi5 advantage, or a novelty claim.
