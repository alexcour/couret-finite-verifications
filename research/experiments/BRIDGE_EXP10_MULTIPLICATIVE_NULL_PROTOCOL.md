# COURET–OAI–BRIDGE–01 — EXP-10-MULTIPLICATIVE-NULL — frozen protocol

> RESEARCH BRANCH; not an independent confirmation of EXP-05/07/09. NOT an RH, large-sieve, power-saving or novelty claim. Original EXP-05 outcomes and T61 phase equivariance are already known.

## Question

Can the finite observed normalized spectral ratio D of genuine Möbius shifts be distinguished on prechosen regimes from a **prime-level Rademacher multiplicative model** preserving (a) squarefree support, (b) multiplicativity on coprime indices, and (c) global reuse of each prime sign, rather than the coefficient-wise independent randomization already tested in EXP-05?

The random multiplicative model is classical (Wintner/Harper); this is a specific finite comparison, not a new probabilistic construction. Also retain a coefficient-wise iid sign surrogate for a contrast with EXP-05.

## Fixed regime and observable (freeze before new computations)

- Prime windows P in {100,200,400,800}; p prime with P<p<=2P; ratios X/P in {8,16,32}, thus 12 regimes. Use **all** primes coprime to 30; do not select p afterwards.
- Positive triangular tent W(t)=max(0,1-2*abs(t-1.5)), supported [1,2]; integer numerator T_X(n)=2 min(n-X,2X-n) if X<n<2X, else zero, with W(n/X)=T_X(n)/X. Work with integer shift coefficients B_h=sum_m a_(pm+30h)a_m T_X(pm)T_X(pm+30h) (h!=0) so D is unaffected by dividing B_h by X^2.
- On U(30), baseline `a_n=mu(n)`, squarefree `a_n=abs(mu(n))` and plain `a_n=1`; zero off U(30).
- Wintner/Rademacher random multiplicative surrogate `f_r(n)=mu(n)^2 product_{ell | n} epsilon_{r,ell}` for squarefree n, zero otherwise, with **one independent sign per prime ell, for each replicate**; reuse the same prime-sign map across all p,X cells within replicate.
- coefficient-iid surrogate `g_r(n)=abs(mu(n))*eta_{r,n}` for each n on U(30) (reused globally across all cells for that replicate).
- Ngeom is inclusive min..max geometric h-range of **plain** nonzero-weight pairs, common to all channels and replicas. Choose Q deterministically as integer q>=7 with gcd(q,30)=1 nearest sqrt(Ngeom), ties to smaller q. F*_Q={a/q:2<=q<=Q,(q,30)=1,1<=a<q,(a,q)=1}, M=#F*_Q, and `D= sum_{alpha in F*_Q}|sum_h B_h exp(-2pi*i alpha h)|² / (M sum_h B_h²)` for E>0. Report zero energies, and do not impute D=1 in those cases.
- 16 global replicates for each of the two surrogate families; Python numpy PCG64 with SEED=20261009, independently seed each stream by `seed=20261009 + 1000*family + r` for family=1 prime-sign, 2 coefficient-iid, r=0..15. For prime signs draw one sign for every prime <=2*max X, including 2,3,5 (their values are unused on U30). For iid signs draw one sign for every integer <=2*max X.
- All original (P,ratio) means are unweighted across prime p; report individual per-prime D for actual channels and 16 replicate regime means for each surrogate, 12 regime summaries with mean/median D, min and max replica mean D, difference actual - surrogate mean, and relative difference. Report the 8 already-observed EXP-05 regimes separately as retrospective and the ratio-32 extension as exploratory; do not describe it as a blinded confirmatory study.
- Preselected **screening**: call `ROBUST_MULTIPLICATIVE_DEVIATION` only if, in all **four ratio-32 extension regimes**, actual Möbius mean D is outside the min/max of all 16 multiplicative-surrogate means, AND the sign of its excess/deficit is the same in all four, AND the absolute relative deviation from multiplicative mean is >=10% in each. Otherwise `NO_ROBUST_MULTIPLICATIVE_DEVIATION`. This is a deliberately strict descriptive gate, **not** a statistical test or inferential p-value.
- Secondary descriptive check: the four new ratio-32 regimes, separately, against iid coefficient-level null; report differences but no claims from post-hoc selected regimes. Spectral comparison is not a proof of T89.

## Exact identities and verification before aggregate results

1. Confirm mobius sieve (first 300 values), plain geometric support and integer tent equality; confirm h=0 never added, no geometry overlap errors.
2. Check `f_r(ab)=f_r(a) f_r(b)` when gcd(a,b)=1, and `f_r(n)=0 iff mu(n)=0` for sample n (on U30). Check the 16 prime-sign arrays are distinct.
3. **Character phase control, existing T61:** for any quadratic Dirichlet character xi on U(30), and `a_n=mu(n)xi(n)`, the sesquilinear shift series obeys `B_h^{xi}=xi(p) B_h^{mu}` for each h when n=pm+30h. Verify all xi3, xi5, xi15 with direct integer sums on at least nine (p,X) samples. For complex order-four characters, the same equivalence uses conjugation on second factor as in T61; DO NOT label this a novel theorem.
4. Check 24 sample integer shift-series vs independent exhaustive double sum; D from FFT residue packets vs direct Fourier for at least 12 sample comparisons; finite Ramanujan integer quadratic identity for at least 12 checks; `0 <= satstar <= satfull <=1+1e-8`.
5. Preserve exact script source/hash, CSV, JSON, all positive and negative results.

## Methodological boundary

Prime-random multiplicative signs are not an assumption about the distribution of deterministic Möbius signs. Rademacher functions do not establish an asymptotic theorem for T89. The quadratic character control is already subsumed by T61. Any apparent distinction is finite, conditional on the chosen family and cannot rehabilitate a Couret-specific chi5 claim; claims of novelty require separate prior-art audit. References: Wintner random multiplicative function, Harper/Nikeghbali/Radziwill work; Matomäki–Radziwiłł–Tao–Teräväinen–Ziegler (Annals 2023) on averaged short-interval higher uniformity, with careful distinction from this four-affine coefficient-growing regime.
