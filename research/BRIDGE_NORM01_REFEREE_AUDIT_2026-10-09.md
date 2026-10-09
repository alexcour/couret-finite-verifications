# NORM-01 — Critical referee audit (2026-10-09)

**Research-only referee pass. Not an external peer review, not a Lean proof.** Existing NORM-01 and T94–T97 records are preserved unchanged.

## Source
Matomäki–Radziwiłł–Shao–Tao–Teräväinen, *Higher uniformity of arithmetic functions in short intervals II. Almost all intervals*, Inventiones mathematicae (2026), theorem 1.1(i), https://doi.org/10.1007/s00222-026-01408-6 .

## Adversarial findings
1. **External theorem scope:** the published almost-all short-interval result permits maximal arithmetic-progression subsums and arbitrary fixed logarithmic saving on the stated polynomial range of interval lengths. The use of the specialization f=mu and constant nilsequence is legitimate in principle; it is not an independently reproduced proof of the external theorem.
2. **Real-to-integer exceptional set:** do not equate Lebesgue exceptional measure with counts of exceptional integer origins. Integer translates of length up to a half-unit have at most two changed interval endpoints, so a large discrepancy at an integer persists on a positive-measure subinterval once H/log^A X grows. This extra step is necessary and accounted for in T94.
3. **Weighted step-30 progression:** summation by parts is appropriate for tent weights. The 30H interval lengths are asymptotically between X^(1/3+epsilon) and X^(1-epsilon); finitely many dyadic windows suffice. Endpoint conventions require an O(1) correction, negligible against any fixed log-power.
4. **Anchor cover:** for r=24, m in {19,23,29}, and r=48, m in {37,47,59}, rational subintervals cover u=p/P in [1,2]. Chosen m are squarefree and units modulo 30, and x=pm is in the central tent segment. Injection p->x uses 2X<P² and is asymptotic, not a small-P universal fact.
5. **Squarefree sieve:** primes 2,3,5 do not divide x+30h when gcd(x,30)=1. Small prime square losses are at most H sum_(n>=7)1/n² + pi(T) ≤ H/6+T. Average large square losses are at most H(X/(T-1)+sqrt(3X)), yielding O(X/T+sqrt X) exceptional x. This is a count of starting centers, not of all primes.
6. **Weights and denominator:** for x in [6X/5,9X/5], W(x/X)>=2/5, while x+30h ≤37X/20 if 30H≤X/20, so W((x+30h)/X)>=3/10. For at least H/2 squarefree positive shifts, V_p≥3H/50.
7. **Average normalized conclusion:** the upper bound on sum_p |S_p| combined with exceptional-prime count and |S|≤V gives average_p,V>0 |S/V|≪_C log^(-C) P for every fixed C, for fixed r∈{24,48} and prescribed H. Balanced χ3/χ5/χ15 contrasts consequently all vanish, with no specific χ5 superiority.

## Scope and residual risks
- This is a **conditional corollary of the exact published theorem as used**, with its constants depending on the fixed logarithmic exponent and fixed window parameters; no explicit finite threshold follows.
- Mathematical audit of the transfer found **no decisive gap**; independent line-by-line peer review and formal Lean verification have not been performed.
- The step using the theorem's supremum over arithmetic progressions (including the constant nilsequence) is the most important external dependency; retain the exact citation and theorem scope.
- The integer-start stability should be written with a fixed-length interval and a half-unit perturbation; its O(1) endpoint loss is absorbed because L/log^A X→∞.
- The finite arithmetic regression is a sanity check, not evidence of an asymptotic theorem.
- No pointwise-for-every-prime statement, no general growing-Q T89 theorem, no χ5-specific gain, no original Möbius theorem, and no RH or zero-free inference.

## Independent sanity checks
Script verify_norm01_referee.py: exact rational anchor coverage for both r; prime-square tail comparison; finite squarefree sieve witness checks for five eligible unit centers, PASS. SHA256 3a2aec5218c488019b4c69a5ab0f5b48a107427b4125c9af4fc6570efd237f44.

**Verdict: ACCEPT AS A PUBLISHED-THEOREM COROLLARY WITH EXPLICIT DEPENDENCIES; NOT AUDITED AS ORIGINAL RESEARCH; RETAIN RESEARCH BRANCH.**
