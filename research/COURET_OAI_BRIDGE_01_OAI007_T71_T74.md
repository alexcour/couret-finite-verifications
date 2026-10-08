# COURET–OAI–BRIDGE–01 — T71–T74: confrontation directe avec OpenAI, famille 007

> RESEARCH BRANCH — NOT PART OF v1.0.0 — NO RH CLAIM — NOT PEER REVIEWED
> Source-exact comparison recorded 2026-10-08. External OpenAI statements are cited, not independently re-proved in this note. No Couret-specific gain or priority claim.

## Sources and scope
- OpenAI math: `lean/docs/007.md` (observed blob dad638d19609ebbddc93a5594dfc2ecd2a26a7a6): https://github.com/openai/math/blob/main/lean/docs/007.md
- OpenAI quantitative source: `preprints/Ordinary-two-point-correlations-of-multiplicative-functions-September-24-2026/build/quantitative/01-setup.tex` (observed blob 0a4b3fab1f06706cc4a10db00d0317bdef84d03e): https://github.com/openai/math/blob/main/preprints/Ordinary-two-point-correlations-of-multiplicative-functions-September-24-2026/build/quantitative/01-setup.tex
- OpenAI Lean theorem signatures: https://github.com/openai/math/blob/main/lean/OAI/NumberTheory/TwoPointCorrelations/FinalMain.lean
- Couret definitions: `research/COURET_OAI_BRIDGE_01_T57_T63.md` and EXP-01/EXP-02 reports on this research branch.

## T71 — exact residue overlap, but different projectors [D]
The quantitative OpenAI proof deliberately builds auxiliary prime supplies
`P_i = {r prime: r == 1 (mod 5), Y_{i-1} <= log r < Y_i, r does not divide l*h}`,
and padding primes `Q = {r prime: r != 1 (mod 5), r <= exp(L), r does not divide l*h}`.
The auxiliary prime r here must NOT be confused with the exterior prime p in our T62 family.

On U(30), primes r == 1 (mod 5) have exactly the residue classes {1,11}; this is strictly included in T_C={1,11,29}, which is strictly included in ker(chi_5)={1,11,19,29}.
If omega is a quartic character mod 5 with omega(2)=i, then on U(30)
  1_{r == 1 (mod 5)} = (1 + omega(r) + omega(r)^2 + omega(r)^3)/4,
where chi_5=omega^2; by contrast,
  1_{chi_5(r)=1} = (1 + chi_5(r))/2.
So OpenAI's selection is an index-four residue projector using quartic as well as quadratic modes; T57's kernel selection is an index-two projector. The intersection is exact, but NOT an identification of mechanisms and gives no evidence of use of T_C or influence from Couret.

## T72 — fixed-affine-form intersection for Liouville [D algebra / L cited OpenAI theorem]
Our off-diagonal term has forms L_1(m)=m and L_2(m)=p*m+30*h. Their determinant is 30*h, nonzero when h != 0. For fixed p and h with arguments positive (reindexing m for a negative h), these are nonproportional affine forms.
The cited OpenAI family 007 states for Liouville lambda a log-saving of shape
  sum_{m<=M} lambda(m)*lambda(p*m+30*h) = O_{p,h}(M/(log M)^c),
with an absolute c>0 but implied constant depending on the affine forms. This comparison is an application of the cited result, conditional on its correctness, NOT a new theorem proved by us.
A smooth bounded-variation window in m can be transferred by partial summation, still for fixed p,h.

## T73 — Möbius is NOT Liouville [I/O]
Our T62 observable uses mu(m)*mu(p*m+30*h), not lambda(m)*lambda(p*m+30*h). The family 007 also states a corrected Elliott asymptotic for one-bounded multiplicative functions under explicit *uniform nonpretentiousness* hypotheses.
To invoke that theorem for mu, one must check the hypotheses (in the exact sense of the paper and, for Lean, its formal definition); no such bridge is asserted here. That general conclusion is qualitative o(M) for each fixed pair, not automatically a log-saving with uniform constants.
Do NOT replace mu by lambda silently. Alternatively one may expand mu(n)=lambda(n) mu(n)^2 via squarefree sieve, but the resulting divisibility and progression conditions require separate uniform estimates.

## T74 — the missing quantified uniformity [O]
Our T62 family is
  Sum_{P<p<=2P} chi_5(p) Sum_{h!=0} Sum_m mu(m)*mu(p*m+30*h)*W_{p,h,m}(X).
In EXP-01/EXP-02, p and the admissible h vary with X; h ranges over a support of scale about X/30. The 007 theorem for each *fixed* affine pair offers no uniform constant in (p,h), and does not control the additional prime-label twist chi_5(p), signed summation over h, or q-growing additive-frequency energy.
A legitimate bridge needs an averaged or uniform estimate with explicit joint ranges p~P(X), h~H(X), m~X/p, plus a separately quantified comparison of quadratic labels or a genuinely new cancellation mechanism.
Proposed next theoretical benchmark: first compare lambda vs mu on precisely the same affine geometry, then determine whether any available average-in-h or large-sieve inequality is genuinely nontrivial after H+Q^2 accounting. Pre-specify any new experiments and do not tune toward chi_5.

## Already observed negative evidence (DO NOT reopen by tuning)
EXP-01, preregistered 12 regimes: inverse/Möbius mean absolute covariance chi_5=0.0160188 versus chi_15=0.0470625; chi_5 mean rank 27.25/35 and top-5 in 0/12 regimes. No Couret-specific residual signal.
EXP-02 growing-modulus pilot: mean signed chi_5 selected-vs-complement spectral-concentration gap -0.0007177 across q={7,11,13,17}, with 2 positive and 2 negative q. Shift-frequency resolution exists, but no stable Couret advantage.
No power saving or zero-free consequence is established by our work.

## Claim and status boundary
- T71 congruence/projector identities: [D] exact finite algebra.
- T72 affine determinant: [D]; Liouville log saving: [L] attributed to OpenAI 007, independent audit not asserted.
- T73 transfer to mu: [O], hypotheses and quantitative strength must be checked.
- T74 uniform prime/shift family bound: [O].
- Claim "Couret gate causes 007 cancellation": unsupported; do not make.
- RH/zero-free claims: none.

Decision: comparative alignment is strongest at the level of *exact residue tools and affine correlation geometry*. The analytical leap (uniform cancellation in a growing prime/shift family) remains open.
