# BRIDGE DIAG-02 — Prospective restricted-shift Möbius diagnostic (FROZEN BEFORE DATA)
Date: 2026-10-08. This is exploratory arithmetic research, NOT an asymptotic theorem, not independent confirmation of previous panels, not a claim regarding RH or a Couret-specific effect. The original fixed-h OAI007 bound does not deliver growing-parameter uniformity.

## Distinct scientific question
Unlike DIAG-01 / EXP-01, now retain ONLY nonzero integer shifts h with |h|<=H(X), for n=pm+30h, in the original tent windows. Full-shift bilinear factorization ceases to be a SINGLE product of residue one-point sums; a continuous Fourier integral still factorizes the integrand. The actual arithmetic signal must exceed controls and not be attributed solely to support geometry.

## Parameters fixed BEFORE computation
- P in {150,300,600}, prime p with P<p<=2P, gcd(p,30)=1, and X=P*r with r in {24,48}. These regimes were chosen independently of DIAG-02 outcomes; older Couret experiments exist, so this is NOT an independent validation.
- Tent W(t)=max(0,1-2*abs(t-1.5)) for 1<=t<=2, 0 otherwise.
- Restricted shift widths H_narrow=max(1,floor(sqrt(X)/3)), H_broad=max(1,floor(X^(2/3)/4)), h integer, 0<|h|<=H; strict h=0 exclusion. Require H_broad>H_narrow and H_broad < X/30 for every regime.
- m>=1, gcd(m,30)=1, pm in support of W(pm/X); n=pm+30h>=1, gcd(n,30)=1 and W(n/X)>0. Consequently n and m lie in matching classes mod30.
- coefficients a_n=mu(n) on gcd(n,30)=1, zero otherwise; squarefree support s_n=|mu(n)|. A separate PLAIN geometric control takes coefficients a_n=1 on units, zero outside.
- For every p,H, compute A_p,H=sum_{0<|h|<=H} sum_m mu(n)mu(m) W(n/X)W(pm/X) and V_p,H=sum_{pairs}|mu(n)mu(m)| W(n/X)W(pm/X). If V=0, Z undefined, count and exclude that p for ALL squarefree-supported signed comparisons; never fill as zero. Define Z_obs=A/V in [-1,1].
- Full-shift R_p=C_p+D_p computed independently by exactly factorized eight-residue C_p and nonnegative D_p. This is a CONSISTENCY control, not a competing test used for significance.
- Deterministic squarefree-supported surrogate: 32 global independent-by-n random signs epsilon_n for n<=max(2X); a_n^(r)=|mu(n)|epsilon_n; seed=20261008+1000*r. Reuse each replicate's globally fixed sign vector across every p, X and H. Compute Z_r on precisely the same (m,n) pairs and same denominator V.
- Other controls: exact PLAIN support V_plain=sum_pairs W(n/X)W(pm/X), A_plain=V_plain; the squarefree absolute support also yields A_abs/V=1. Report both geometry pair count and squarefree pair count.

## Predeclared outputs / metrics
For 6 P-r regimes x 2 H widths = 12 cells:
1. unweighted prime mean Z_obs and mean absolute Z_obs; 32 global-coefficient-surrogate means and mean absolute surrogate z. Descriptive signed difference between observed mean and median-surrogate mean; count whether abs(observed mean) exceeds the empirical 90th percentile of abs(surrogate mean). Also signed direction per cell. Because surrogate arrays are reused and cells overlap, DO NOT count as independent trials or quote p-values.
2. For xi in {chi3, chi5, chi15}, contrasts g_xi = mean_{xi=+1} Z - mean_{xi=-1} Z. Use the SAME unweighted p sample for all characters; report nplus/nminus, the 32 surrogate contrasts, abs contrast rank versus surrogate distribution, and chi5 ranking among the three.
3. Balanced 4/4 partitions of U30 up to complement with representative 1 in the plus set (35 total), evaluated as additional diagnostic gates; report chi5 abs contrast rank among 35. This rank must NOT be interpreted as an independent multiple-test-adjusted p-value.
4. The within-p difference Z_broad-Z_narrow and its cell mean; report support sizes. Finite diagnostic only.
5. Tests: squarefree indicator identity, |Z|<=1, direct versus FFT/poly product full-shift identity for at least 2 sentinel primes per regime, direct negative-diagonal formula, narrow and broad nested support and fixed coefficients reused.

## Frozen continuation criteria, heuristic not hypothesis-test
- General nontrivial restricted-shift observation only if abs(mean Z_obs) exceeds empirical 90th percentile abs(surrogate mean) in >=10/12 cells, with the sign constant across both widths per P-r.
- Couret specificity only if abs(g_chi5) exceeds both abs(g_chi3), abs(g_chi15) in >=10/12 cells AND the abs(g_chi5) beats empirical 90th percentile abs surrogate chi5 contrast in >=10/12 cells. Otherwise no Couret-specific evidence, regardless of isolated positive cells.
- No reruns with changed windows, seed, coefficients, q, metrics, or classifications after results. Do NOT overwrite the preexisting EXP-02C, EXP-03, EXP-04 or EXP-05 records.

## Mathematical clarification
The windowed sum has the exact integral representation with Dirichlet kernel
S_p(H) = integral_0^1 D_H(theta)* F_p(theta) dtheta - L_p,
where D_H(theta)=sum_{|h|<=H}exp(2*pi*i*theta*h), F_p(theta)=sum_h b_{p,h}exp(-2*pi*i*theta*h), L_p=b_{p,0}; F_p(theta) factorizes for each theta as twisted one-point residue sums with exp phases exp(±2*pi*i*theta*n/30). Finite bandwidth in h does NOT by itself prove genuinely irreducible arithmetic two-point cancellation.

## Required artifacts and release
Deterministic source code; compact raw JSON and per-p rows CSV, per-cell summary CSV, hashed manifest; report with all adverse results; upload archive into current Couret Drive SCHEMAS & PROTOCOLES; update existing living journal; commit all material to dedicated research branch. No release tag and no publication priority claim.