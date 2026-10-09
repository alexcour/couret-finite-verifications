# COURET–OAI–BRIDGE–01 — EXP-11: exact prime-parity second-moment audit

**FROZEN BEFORE EXP-11 NUMERIC MEASUREMENTS.** Branch `research/couret-oai-bridge-01`. Finite classical orthogonality only. No RH, new large-sieve estimate, novelty or asymptotic theorem. EXP-10 outcomes already known: this is a motivated diagnostic, not independent confirmation.

## Algebraic hypothesis and exact identities (to verify independently)

Let `f_epsilon(n)=mu(n)^2 prod_(ell|n) epsilon_ell`, with independent Rademacher signs indexed by primes ell. On the squarefree pairs `n=pm+30h`, `h!=0`, `(m,30)=1`, under the same EXP-10 tent weights, write `t(n,m)=nm/gcd(n,m)^2` (the squarefree kernel of nm). For **each fixed p,X**, let `c[h,t]` be the sum of the positive integer weights `T_X(pm) T_X(n)` of all squarefree admissible pairs that have shift h and label t. Then

`B_h(epsilon)=sum_t c[h,t] epsilon(t)`, `B_h(mu)=sum_t c[h,t] mu(t)`.

Prime-sign orthogonality gives the **exact** identity
`C(h,k)=E_epsilon[B_h B_k]=sum_t c[h,t] c[k,t]`.

For the T81 Ramanujan kernel `K_Q(h-k)`, define
`Ebar=sum_h C(h,h)`, `Nbar=sum_hk K_Q(h-k) C(h,k)`, `rho=Nbar/(M Ebar)` for `Ebar>0`. These are exact *ratios of expected quadratic forms*. **rho is not E_epsilon[D]** and must never be represented as such. For independent coefficient-level signs, the analogous cross-shift covariance is zero and rho=1 exactly, because large n and small m live in disjoint ranges.

The deviation `rho-1` arises solely from distinct shifts sharing the same prime-parity signature t; a generic no-collision family has `rho=1`. `C(h,k)>=0`, but `K_Q` can have either sign.

## Frozen panel / no tuning

- P in {100,200,400,800}, p prime in (P,2P], p not dividing 30; X/P in {8,16,32}; complete 12 cells of (P, ratio); treat ratio 8/16 as retrospective to EXP-10 and ratio 32 as exploratory extension, not blinded.
- W(y) triangular supported [1,2] (maximum at 3/2); integer `T_X(v)=2 min(v-X,2X-v)` for X<v<2X; all admissible m,n are in U30, h=(n-pm)/30 is a nonzero integer. Preserve only pairs with mu(m)mu(n) nonzero for the prime-parity witness; true B_h is an exact integer.
- Plain geometric shift interval controls `Ngeom`, not the support of the squarefree witness. Q=nearest integer >=7 coprime to 30 to sqrt(Ngeom), ties to smaller; M=sum phi(q) for 2<=q<=Q,(q,30)=1.
- For each (p,X), save: pair_count, distinct_label_count, reused_label_count (number t appearing at >=2 different h), Ebar, Nbar, `offshift=Nbar-M Ebar`, `rho`, true energy Etrue, true spectral numerator Ntrue, Dtrue=Ntrue/(M Etrue), with zero-energy exceptions explicitly retained; min/max of `rho` and Dtrue per regime.
- For each of 12 (P,ratio) regimes, report arithmetic means of `rho`, Dtrue, absolute `rho-1`, proportion of primes with `rho!=1` exactly, fraction of reused labels, and mean `Dtrue-rho`. Equal weight by prime per regime, do not pool ratios as independent evidence.

**Frozen screening rule** on four ratio-32 regimes: 'STRONG_STRUCTURAL_SHIFT' if in all four cells |`mean rho-1`|>=0.05 with the same sign, otherwise 'NO_STRONG_STRUCTURAL_SHIFT'. 'ROBUST_DETERMINISTIC_RESIDUAL' if in all four regimes |`mean Dtrue-mean rho`|>=0.10 with same sign, otherwise 'NO_ROBUST_DETERMINISTIC_RESIDUAL'. These are *arbitrary descriptive gates* and no inferential confidence intervals/p-values or prospective validation claims follow.

## Required independent checks before interpreting outcomes

1. For all 1<=n<=300, mu sieve equals factorization; for at least 30 sample (p,X), direct n,m pair enumeration agrees exactly with b coefficient sequence.
2. For at least 200 squarefree (n,m), `t(n,m)` is squarefree, and `mu(n)mu(m)=mu(t)`. Check the product of independent assigned prime signs for n and m equals sign(t).
3. For Q in [7,11,13,17] and 100 sample (Q,d), Ramanujan integer K equals direct reduced Fourier sum within 1e-9.
4. At least 8 tiny synthetic multiple-edge examples enumerate every 2^r prime sign configuration (r<=9); verify C, Ebar, Nbar to exact rational arithmetic. Include at least one label repeated across two distinct shifts and one label only on one shift. **Do not use simulation** as evidence of the exact identity.
5. For >=12 real arithmetic cells verify true b reconstructed by labels equals direct integer sums, and Ntrue from autocorrelation Ramanujan matches direct Fourier/FFT within numerical tolerance.
6. Preserve observed no-collision and nonzero-collision cases, no post-outcome threshold changes.

## Interpretation

No uniform Möbius estimate follows; the source of differences between actual `Dtrue` and `rho` is not automatically a new arithmetic phenomenon. `rho` only calibrates the second moment of the prime-parity null, rather than its expected normalized D. Since the normalized ratio is nonlinear, `rho` is *not* directly interchangeable with the sample mean D of the 16 EXP-10 replicates. A new deterministic theorem would have to control signed correlations between distinct parity labels, uniformly in growing p,Q,X and their support geometry; this is not proved here.
