# COURET–OAI–BRIDGE–01 — T94–T97: short Möbius progressions and SPARSE-01

**Research note, 2026-10-09.** This is a rigorous deduction from a published theorem and elementary combinatorics, **not an original theorem of Möbius cancellation**. External published input is not independently formalized in Lean here. Claim boundary: no Couret-specific effect, no RH or zero-free result, no v1 release and no priority claim. The prior DIAG-02 outcome remains adverse (8/12 general criterion vs 10/12, 0/12 Couret-specific).

## Source and precise external statement

K. Matomäki, M. Radziwiłł, X. Shao, T. Tao, J. Teräväinen, *Higher uniformity of arithmetic functions in short intervals II. Almost all intervals*, Inventiones mathematicae 244 (2026), 967–1091, published 2026-01-26, DOI https://doi.org/10.1007/s00222-026-01408-6 .
**Theorem 1.1(i)**, not a theorem about the Couret gate: with a fixed nilmanifold and F≡1, for all A>0, fixed epsilon>0 and Y^(1/3+epsilon)≤L≤Y^(1-epsilon), one has
  sup_{P subset (t,t+L] cap Z; P arithmetic progression}
  |sum_{n in P} mu(n)| ≤ L/(log Y)^A
for all real t∈[Y,2Y] except a set of measure O_{A,epsilon}(Y/(log Y)^A). The theorem is stronger (uniform in bounded-complexity nilsequence and maximal progression). We use ONLY this specialization. Not the weaker 2015 MR qualitative o(L) theorem, and not the Matomäki–Teräväinen 2022 all-interval bound for lengths Y^theta with theta>0.55.
Primary accessible full text:
https://link.springer.com/article/10.1007/s00222-026-01408-6
Sections: Theorem 1.1(i), equation (1.4) defining the supremum over all arithmetic progressions, and the discussion in section 1.1.

## T94 [R from 2026 theorem] — integer-start maximal progression bounds

Fix a length L=L(Y) satisfying the stated power range. If the maximal progression sum at an **integer** t0 exceeds 2L/(log Y)^A, then for any real v in [t0,t0+1/2] the maximizer progression restricted to (v,v+L] loses at most two endpoints (at most two unit-bounded mu values). For Y sufficiently large, L/(log Y)^A≫2, so the maximal progression sum at v still exceeds L/(log Y)^A. These half-unit intervals attached to distinct bad integers are disjoint. Thus the number of bad **integer** starting points in [Y,2Y] (with threshold 2L/(log Y)^A) is O_{A,epsilon}(Y/(log Y)^A), up to harmless dyadic boundary extensions.

The exceptional set in the paper is one of real t, so this transfer to integers is **essential**. Do not silently replace Lebesgue measure by integer count.

## T95 [R, proof supplied] — arbitrary logarithmic decay of our weighted step-30 energy

Let r be fixed in {24,48}, let P→∞, X=rP (integer), W(t)=max(0,1-2|t-3/2|) for t in [1,2], zero outside. Set
 v_X(n)=mu(n) 1_{gcd(n,30)=1} W(n/X) for n≥1, 0 for n≤0,
 G_{X,H}(x)=sum_{1≤|h|≤H} v_X(x+30h),
 E(X,H)=sum_{X≤x≤2X} |G_{X,H}(x)|²,
 e(X,H)=E(X,H)/[(X+1)(2H)²].
Choose either
 H_n(X)=max(1,floor(sqrt(X)/3)), or
 H_b(X)=max(1,floor(X^(2/3)/4)).
For each H set L=30H. Then L∼X^1/2 or L∼X^(2/3), respectively. Choose epsilon=1/12: eventually (cX)^(1/3+epsilon)≤L≤(cX)^(1-epsilon) on each of the O(1) dyadic boxes needed to cover starting points from X−L through 2X.

To evaluate G(x) at integer x, split its h>0 and h<0 terms into the two intervals (x,x+L] and [x−L,x) (endpoint conventions add at most O(1) terms). Inside each interval we select exactly one arithmetic progression, n≡x (mod 30); for x unit all selected integers are units, so 1_{gcd(n,30)=1}=1. When x nonunit, G(x)=0. Theorem 1.1(i) gives a bound for the maximal *unweighted* progression sum. Abel summation transfers it to weights W(n/X), since sup|W|≤1 and total variation on a length-L interval is at most 2L/X≤1 eventually. Thus for all but O_A(X/(log X)^A) integer x∈[X,2X],
  |G_{X,H}(x)| ≪_A H/(log X)^A.
For every x, trivially |G(x)|≤2H. Hence
  E(X,H) ≪_A X H²[(log X)^(-2A)+(log X)^(-A)]
         ≪_A X H²/(log X)^A,
and consequently, **for every B>0**,
  e(X,H) ≪_{B,r} (log X)^(-B).
No new estimates are proved about individual short intervals; this is a transferred average-square result using the 2026 theorem, finite residue progressions, bounded variation and the bad-set count.

This resolves the *published-input target* previously recorded as [O] in SPARSE-01 for these two H ranges. It does not establish the full more general T89 Ramanujan autocorrelation-kernel target.

## T96 [R] — asymptotic sparse prime-family saving on the geometric scale

SPARSE-01 defines
 u_{p,m}=mu(m)1_{gcd(m,30)=1}W(pm/X),
 S_{p,H}=sum_m u_{p,m} G(pm);
 K=#{(p,m): P<p≤2P prime, gcd(m,30)=1, X≤pm≤2X},
 A=sum_{p,m}|u_{p,m}|²≤K,
 L_occ=max_x #{p∈(P,2P]:p divides x}.
For X=rP, P>2r, 2X<P², so L_occ=1: different prime labels cannot reuse the same center x=pm.

For each r∈{24,48}, classical prime number theorem ensures K∼_bounds X/log P:
- r=24: take m=31, primes p∈[1.2P,1.4P], so X<pm<2X and (m,30)=1;
- r=48: take m=47, primes p∈[1.3P,1.6P], similarly.
Conversely each p contributes at most 2r possible m. So K≍_r X/log P and A≤K.
SPARSE-01's exact Cauchy bound gives
  sum_{P<p≤2P}|S_{p,H}| ≤ sqrt(A L_occ E(X,H))
                      ≤ sqrt(K E(X,H)).
Inserting T95:
  [sum_p |S_{p,H}|]/(2H K)
     ≪_{B,r} sqrt(log P) (log X)^(-B/2).
As log X∼log P, and B is arbitrarily large, for EVERY C>0,
  **sum_p |S_{p,H}| ≪_{C,r} H K (log P)^(-C).**
Also #primes p∈(P,2P] ≍ P/log P and K≍_r P/logP, so
  (1/#primes) sum_p |S_{p,H}| ≪_{C,r} H (log P)^(-C).
The bound also applies to |sum_p ξ_p S_p| when |ξ_p|≤1, hence in particular ξ_p=chi3(p),chi5(p),chi15(p). It does NOT prove chi5 is relatively better than the other gates.

## T97 [R / boundary] — exceptional-center direct proof and limits

The stronger direct counting route gives the same log-power conclusion without losing a square-root in exponents. For good centers x, |G(x)|≪_A H/log^A X; there are at most O_A(X/log^A X) bad centers x. With occupancy one, each bad x contributes to at most one (p,m) in the family. Therefore,
  sum_p |S_p| ≤ sum_{p,m}|u_{p,m}||G(pm)|
              ≪ H[K/log^A X + X/log^A X]
              ≪_r H K (log P)^(1-A).
Choosing any A>C+1 proves arbitrary log-power decay. This independently checks the strength of the T96 deduction.

For every C,D>0, Markov's inequality then yields
 #{p∈(P,2P]: |S_{p,H}| > H/(log P)^C}
   ≪_{C,D,r} [#primes]/(log P)^D,
by first proving the average with exponent C+D. This is an **almost-all-prime raw-correlation theorem derived from the 2026 source**, not pointwise in every prime.

**Boundaries / not established:**
(1) No uniform lower bound for the actual squarefree pair mass V_p of DIAG-02 is proved here. Therefore do not infer the same decay for individually normalized Z_p=S_p/V_p or for averages of Z_p.
(2) The case P larger or smaller relative to X, such that 2X≥P² or K not ≍X/logP, needs separate occupancy and density analysis.
(3) No comparison shows χ5 cancellation beyond χ3 or χ15; negative retrospective DIAG-02 gate verdict preserved.
(4) Not a proof of a new zero-free region, the Riemann hypothesis, or T89's full growing-Q autocorrelation kernel bound.
(5) External deep theorem is cited as an input and is not independently Lean-replayed in this repository.

## Claim status and next action

T94 [R] integer-start lemma, T95 [R] weighted step-30 mean-square log-power transfer, T96 [R] sparse-prime family, T97 [R] direct exceptional-center argument and [O] normalization issues. All are derived corollaries of Matomäki–Radziwiłł–Shao–Tao–Teräväinen (2026) and classical elementary operations; originality NOT AUDITED and NOT CLAIMED.

Previously open requirement SPARSE-01 e(X,H)logP→0: **CLOSED for r in {24,48} and H_n/H_b asymptotic families** by the published theorem. Retain [O] for broader parameters and specific gates.

Recommended next mathematical work: investigate whether a uniform lower bound for squarefree pair mass V_p on almost all prime centers can be established, without using these same data post hoc; alternatively optimize occupancy when 2X≥P². Audit published prior art before any novelty statement.

Reproducibility: SPARSE-01's exact finite program still validates its independent algebraic inequality on DIAG-02; no new empirical experiment was run to decide this analytical result. GitHub research branch research/couret-t94-mrsts-2026-10-09; retain DIAG-01, DIAG-02, EXP-02C and EXP-03–07 without overwrite.
