# COURET–OAI–BRIDGE–01 — NORM-01: squarefree mass lower bound, normalized sparse-prime correlation transfer

> **Research branch / derived classical mathematics; not a priority claim, RH result, or new analytic Möbius cancellation theorem.**
> Recorded 2026-10-09. Original T98–T101 identifiers are already in use for EXP-09 rank/no-go work, so this result is named NORM-01 rather than overwriting that work. This is an analytic extension of SPARSE-01 and T94–T97, using only elementary squarefree counting for the denominator and the published MRSTS 2026 theorem for the numerator. No new randomized numerical experiment; earlier DIAG-02 retrospective/negative verdict preserved.

## Definitions and regime

Take fixed r∈{24,48}, real/integer P→∞ (use integer P for simplicity), X=rP, primes p with P<p≤2P and gcd(p,30)=1, the tent weight
  W(t)=max(0, 1−2|t−3/2|) on [1,2], zero outside.
Take either H_n=floor(sqrt(X)/3) or H_b=floor(X^(2/3)/4), assuming X large so H≥1.
Let
  S_{p,H}=Σ_{m≥1,(m,30)=1} μ(m)W(pm/X) Σ_{0<|h|≤H} μ(pm+30h)W((pm+30h)/X);
  V_{p,H}=Σ_{m≥1,(m,30)=1} |μ(m)|W(pm/X) Σ_{0<|h|≤H}|μ(pm+30h)|W((pm+30h)/X),
with μ(n)=0 for n≤0. Then |S|≤V, and DIAG-02's Z_p=S_p/V_p is only defined when V_p>0.

The deep external input remains:
Matomäki–Radziwiłł–Shao–Tao–Teräväinen, *Higher uniformity of arithmetic functions in short intervals II. Almost all intervals*, Invent. Math. 244 (2026), 967–1091, theorem 1.1(i), https://doi.org/10.1007/s00222-026-01408-6.
As established with detailed scope in research/BRIDGE_T94_T97_MRST2026_SHORT_INTERVAL_TRANSFER.md, for every A>0,
  Σ_{P<p≤2P}|S_{p,H}| ≪_{A,r} H K_{P,X} (log P)^(-A),
where K=#{(p,m): P<p≤2P, (m,30)=1, X≤pm≤2X} ≍_r P/log P.
This is a corollary of the *published* theorem, not our own new Möbius estimate. This document proves the missing lower bound for V, yielding a normalised result.

## NORM-01-A [D] — explicit squarefree anchor indices for all prime labels

For each p/P=u∈(1,2], choose an index m from:
  r=24: {19,23,29};
  r=48: {37,47,59}.
Each listed m is prime (hence squarefree), coprime to 30, and independent of P.

The condition 6X/5≤pm≤9X/5 is equivalent to
  6r/(5m)≤u≤9r/(5m).
These three closed intervals cover [1,2] in each r case, as verified by exact rational comparisons:
 r=24: [144/145,216/145] for 29; [144/115,216/115] for 23; [144/95,216/95] for 19.
 r=48: [288/295,432/295] for 59; [288/235,432/235] for 47; [288/185,432/185] for 37.
Take the first fitting m in the listed order; ties are allowed and are resolved deterministically. Denote x_p=p m_p∈[6X/5,9X/5]. For P>2r one has 2X<P², so p→x_p is injective: if x_p=x_{p'}, it is divisible by distinct primes p,p'>P and is at least pp'>P²>2X.

## NORM-01-B [D] — elementary almost-all-center squarefree lower density in progression 30

Fix arbitrary D>0. Put T=floor((log X)^D), choosing X large enough that T≥7, T≤H/12 and 30H≤X/20; all hold eventually for either prescribed H scale.

For an integer x∈[X,2X] let
  B_T(x)=Σ_{h=1}^H Σ_{primes ℓ>T, ℓ²≤3X} 1_{ℓ²|x+30h}.
Since x+30H≤3X, every large prime-square obstruction is counted. For fixed ℓ,h, among integer x∈[X,2X] the congruence x≡−30h mod ℓ² has at most X/ℓ²+1 solutions. Summing over all x (including nonunits is harmless),
  Σ_{X≤x≤2X} B_T(x) ≤ H Σ_{T<ℓ≤sqrt(3X), ℓ prime}(X/ℓ²+1)
  ≤ H[X/(T−1)+sqrt(3X)].
By Markov's counting inequality, all except
  O(X/T+sqrt X)
integers x in [X,2X] satisfy B_T(x)≤H/4.

Take such a good **unit** x, gcd(x,30)=1. For ℓ≤T with ℓ≥7 prime, gcd(ℓ,30)=1; the congruence ℓ²|x+30h has at most H/ℓ²+1 solutions in 1≤h≤H. Primes 2,3,5 cannot divide x+30h. Thus the number of h lost to small prime squares is at most
  H Σ_{ℓ≥7, ℓ prime} 1/ℓ² + π(T)
  ≤ H Σ_{n≥7} 1/n² + T
  ≤ H/6 + T.
Large prime squares discard at most H/4 shifts. Therefore the number of h∈[1,H] with μ(x+30h)²=1 is at least
  H−(H/6+T)−H/4 ≥ H/2
for X large with T≤H/12. This proof is elementary: no unproved independence assumptions, no uniform-in-every-short-interval squarefree theorem.

The number of bad centers is O_D(X/(log X)^D+sqrt X), hence O_D(X/(log X)^D) after enlarging X. Constants may depend on D; no effective small-X threshold is claimed.

## NORM-01-C [R elementary] — V_{p,H} lower bound for all but logarithmically few primes

For x_p selected in NORM-01-A, gcd(x_p,30)=1. On [6X/5,9X/5], W(x_p/X)≥2/5; and because 30H≤X/20, every 1≤h≤H satisfies (x_p+30h)/X∈[6/5,37/20], so W((x_p+30h)/X)≥3/10.
For a good center, at least H/2 values of h∈[1,H] have |μ(x_p+30h)|=1, and |μ(m_p)|=1. These nonnegative pair contributions belong to V_p. Therefore **explicitly**
  V_{p,H} ≥ (2/5)*(3/10)*(H/2)=3H/50.
Since p→x_p is injective, at most O_D(X/log^D X+sqrt X)=O_{D,r}(P/log^D P) primes can select bad centers, for any fixed D>0.
Hence for every B>0,
  #{P<p≤2P: V_{p,H}<3H/50} = O_{B,r}(P/(log P)^B).
In particular the fraction of p for which V_p=0 is O_{B,r}((log P)^{1−B}), and eventually any fixed large log power is achievable after choosing B. **This is an almost-all prime lower bound, not a uniform bound for every p.**

## NORM-01-D [R from T94–T97 + classical sieve] — normalized correlation decay and all quadratic gates

Let \mathcal P^+ be primes p∈(P,2P] with V_p>0. For good p, |Z_p|=|S_p|/V_p≤(50/3H)|S_p|. For the exceptional p with V_p>0, |Z_p|≤1 automatically.
Thus
  Σ_{p∈\mathcal P^+}|Z_p|
  ≤ (50/(3H)) Σ_{P<p≤2P}|S_{p,H}| + O_{B,r}(P/log^B P)
  ≪_{A,r} K(log P)^(-A)+P(log P)^(-B).
Since π(2P)−π(P)≍P/log P and K≍_r P/log P, choosing A,B arbitrarily large yields, for every C>0,
  (1/π(P,2P)) Σ_{p∈\mathcal P^+}|Z_p|
  ≪_{C,r} (log P)^(-C),
where π(P,2P)=#{p:P<p≤2P}.
The omitted primes with V_p=0 form an arbitrarily-logarithmically-small proportion; no imputation of Z=0 is needed in the original DIAG-02 dataset.

For any fixed real nontrivial quadratic character ξ of U(30), the prime number theorem in fixed progressions gives approximately half of P<p≤2P with ξ(p)=+1 and half with ξ(p)=−1. Removing negligible zero-denominator primes preserves both group sizes ≍P/log P. Therefore the **unweighted balanced difference**
  [mean_{ξ=+1,V>0} Z_p] − [mean_{ξ=−1,V>0} Z_p]
  = O_{C,r}((log P)^(-C))
for every C>0. This holds uniformly among the three fixed ξ∈{χ3,χ5,χ15} (finite list).
It does NOT imply any statistically exceptional superiority of χ5; instead ALL three normalized group-contrast magnitudes vanish. The result is a **corollary of published 2026 Möbius short-interval cancellation and elementary squarefree counting**, not a new proof of a named zero-free theorem.

## Claim boundaries and next actions

- NORM-01-A/B/C: exact combinatorial and squarefree sieve arguments [D / classical], statements asymptotic with explicit dependence on fixed r and log parameter D.
- NORM-01-D: derived from published MRSTS theorem 1.1(i) via T94–T97, plus classical PNT in fixed progressions [R]. External input is not independently Lean-replayed.
- The stronger pointwise conclusion for **every** prime p is not established; neither is a new exponent or better comparison for χ5 versus the other labels.
- DIAG-02 finite pilot with non-confirmatory 8/12 general and 0/12 χ5 verdict remains unchanged. This asymptotic theorem does not imply that any specific finite P passes the experiment.
- Original T98–T101 already label the EXP-09 support-mask audit and must not be repurposed. Retain NORM-01 as separate track.
- T89's growing-Q four-affine-form Ramanujan kernel bound remains OPEN; this result is for restricted shifts and fixed r, not that distinct spectral target.
- Preserve research-only status. Do not tag a release, claim mathematical priority, or imply RH or Dirichlet zero-free consequences.

## Sources

1. MRSTS 2026 theorem 1.1(i): https://link.springer.com/article/10.1007/s00222-026-01408-6
2. SPARSE-01: research/BRIDGE_SPARSE01_ENERGY_TRANSFER.md
3. T94–T97: research/BRIDGE_T94_T97_MRST2026_SHORT_INTERVAL_TRANSFER.md
4. Historical DIAG-02: research/experiments/BRIDGE_DIAG02_PROTOCOL.md and BRIDGE_DIAG02_REPORT.md

Next: independently referee each asymptotic quantifier and the exceptional-measure-to-integer-start argument in T94–T97; then seek whether the normalisation transfer extends to variable X/P or to fixed microscopic H below X^{1/3+ε}. A simple integer-arithmetic regression of NORM-01-A and the finite squarefree sieve can be added without claiming it verifies any asymptotic theorem.
