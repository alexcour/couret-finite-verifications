# COURET–OAI–BRIDGE–01 — T75–T76: Möbius via Liouville and the uniform-family barrier

> **RESEARCH BRANCH — NOT IN v1.0.0 — NO RH CLAIM — NOT PEER REVIEWED.**
> Recorded 2026-10-08. The analytic input below is attributed to OpenAI family 007, not independently re-proved or independently reviewed here. Exact algebraic statements and logical implications are distinguished from analytic inputs. Novelty: NOT AUDITED.

## Primary sources (verified in GitHub connector)
- OpenAI, [family 007 scope](https://github.com/openai/math/blob/main/lean/docs/007.md).
- [PretentiousDistance.lean](https://github.com/openai/math/blob/main/lean/OAI/NumberTheory/TwoPoint/PretentiousDistance.lean) — `UniformlyNonpretentious` and `squaredDistance`; observed blob `31e9010dee390175fcaca4f6e1b58c527d58ad2d`.
- [Statements.lean](https://github.com/openai/math/blob/main/lean/OAI/NumberTheory/TwoPoint/Statements.lean) — the exact scope of the three theorems; observed blob `c637ede9f0a7891859f28c9f4a3a208b7a85a8c0`.
- [Main.lean](https://github.com/openai/math/blob/main/lean/OAI/NumberTheory/TwoPoint/Main.lean) — Lean theorem dependencies; observed blob `5a1a015c0cfe8221af315933c579eb7fb2885d3f`.
- [Basic.lean](https://github.com/openai/math/blob/main/lean/OAI/NumberTheory/TwoPoint/Basic.lean) — definitions of `affineSum`, ordinary multiplicativity and Liouville; observed blob `6758ac5c3f8fa0155485302553eb551c9c278e4f`.
- [FinalMain.lean](https://github.com/openai/math/blob/main/lean/OAI/NumberTheory/TwoPointCorrelations/FinalMain.lean) — the public-facing Lean signatures.
- Couret T62: `research/COURET_OAI_BRIDGE_01_T57_T63.md`, and comparison T71–T74.

## T75-A — exact identity of pretentious distances for μ and λ [D; mathematical observation]
For every prime r, Möbius μ(r)=Liouville λ(r)=-1. The squared distance defined in the OpenAI code is a sum only over primes r≤N:
  D_N(f,χ n^{it})² = Σ_{r≤N, r prime} [1-Re(f(r) overline(χ(r) r^{it}))]/r.
Therefore, identically for all N, χ and t,
  D_N(μ,χ n^{it})² = D_N(λ,χ n^{it})².
Consequently `UniformlyNonpretentious(μ) ↔ UniformlyNonpretentious(λ)` under *that precise definition*. This is a logical equivalence: it does NOT by itself establish either property. No Lean formalization of this equivalence is claimed in this repository.

## T75-B — exact squarefree transfer [D algebra]
For n≥1, μ(n)=λ(n)·1_{squarefree(n)} and
  1_{squarefree(n)} = μ(n)² = Σ_{d²|n} μ(d).
To obtain a bounded 0/1 truncation, for each fixed prime cutoff D≥2 define
  s_D(n) = Π_{r≤D, r prime} [1-1_{r²|n}].
Then 0≤s_D(n)≤1 and
  s_D(n) = Σ_{d|P_D} μ(d)·1_{d²|n},
where P_D is the product of primes ≤D. The full squarefree indicator and s_D differ only if some prime r>D has r²|n. **Use this prime-cutoff product, NOT an unsafeguarded truncation Σ_{d≤D,d²|n} μ(d), which need not lie in [0,1].**

For positive affine arguments n=p m+b, with p prime and b=30h, write
  A_μ(M;p,b) = Σ_{1≤m≤M, pm+b>0} μ(m)μ(pm+b),
  A_{λ,D}(M;p,b) = Σ_{1≤m≤M, pm+b>0} λ(m)λ(pm+b)s_D(m)s_D(pm+b).
Termwise, |A_μ - A_{λ,D}| is bounded by the number of m with a prime-square obstruction r>D in m or pm+b (a crude factor 2 is harmless).

For an integer prime r>D, the congruence r²|pm+b has at most one class modulo r²/gcd(p,r²), if soluble. Thus for any interval of at most M values of m:
  #{m: r²|pm+b} ≤ M gcd(p,r²)/r² + 1.
Because p is prime,
  Σ_{r>D, r prime} gcd(p,r²)/r² ≪ 1/D
uniformly in p. Also r≤√B if 0<pm+b≤B. Hence
  |A_μ(M;p,b)-A_{λ,D}(M;p,b)|
    ≪ M/D + √M + √B
uniformly over p prime, b integer, and 0<pm+b≤B.
For fixed p,b with M→∞ we can take B=pM+|b|=O_{p,b}(M), making the tail o(M) after first taking limsup and then D→∞.

## T75-C — theorem: fixed-affine Möbius correlation is o(M), conditional only on OAI007 Liouville theorem [R]
**Statement.** Assume the main quantitative Liouville theorem of OpenAI family 007 is correct: for any two *fixed* nonproportional affine forms with positive slopes and eventually positive arguments, their ordinary correlation is O(M/(log M)^c), with one absolute c>0 but an implied constant depending on the forms. Then for every *fixed* prime p and integer h≠0,
  A_μ(M;p,30h) = o_{p,h}(M).

**Proof.** Fix D. Expand s_D(m)s_D(pm+30h) into the finite sum over d,e|P_D. For each pair the divisibility conditions d²|m and e²|pm+30h select zero or finitely many residue classes m≡a (mod L), L=lcm(d²,e²). On each class m=Lk+a, the two Liouville arguments are
  Lk+a, pLk+(pa+30h),
whose determinant is L(pa+30h)-pLa=30hL ≠0.
If h<0, discard the finitely many initial k for which an argument is nonpositive; shift k by a fixed amount to apply the nonnegative-intercept theorem. The OAI007 bound applies to every one of these finitely many fixed pairs, so
  A_{λ,D}(M;p,30h) = O_{p,h,D}(M/(log M)^c) = o_{p,h,D}(M).
The preceding tail bound implies
  limsup_{M→∞}|A_μ(M;p,30h)|/M ≪1/D.
Now let D→∞. QED.

**Meaning.** This is a *deduced consequence of the cited OAI007 theorem*, not a new proof of the OAI theorem, not a new Couret-specific phenomenon and not an independently validated original result. It does not require separately proving uniform nonpretentiousness of μ. Standard fixed-cutoff summation by parts extends this qualitative o(M) to bounded-variation weights on a fixed normalized m-window.

## T76-A — why the fixed-parameter theorem does not sum over a growing family [D logical obstruction]
Pointwise statements for each fixed (p,h), with constants C_{p,h}, imply no bound uniform when p=p(X), h=h(X). Elementary counterexample: f_r(M)=1_{M≤r}. For every fixed r, f_r(M)→0; yet sup_{r≥M}f_r(M)=1 at every M. The Liouville theorem's absolute logarithmic *exponent* does not remove this dependence of the implied constant on its affine coefficients.

Our T62 residual:
  C(X)=Σ_{P<p≤2P} χ_5(p) Σ_{h≠0} Σ_m μ(m) μ(pm+30h) W_{p,h,m}(X).
Both p and h vary; the modulus q used in EXP-02 varies in another direction. None of these operations is covered by pointwise O_{p,h} bounds alone.

## T76-B — conditional uniform-family transfer criterion [D implication / O hypothesis]
Let F_X be any finite set of pairs (p,h), with p prime, h≠0, M_{p,h}≥M_min(X)→∞, and 0<pm+30h≤B_X for each counted term. Suppose √B_X/M_min(X)→0.
For every *fixed* prime cutoff D, suppose the Liouville congruence-restricted correlations generated by the finite expansion s_D(m)s_D(pm+30h) satisfy, uniformly over (p,h)∈F_X and over the finitely many d,e|P_D and corresponding residue classes,
  |Σ_{m≤M_{p,h}, m≡a(mod lcm(d²,e²))} λ(m) λ(pm+30h)|/M_{p,h} ≤ ε_D(X),
where ε_D(X)→0 as X→∞.
Then the exact squarefree decomposition gives
  sup_{F_X} |A_μ(M_{p,h};p,30h)|/M_{p,h}
    ≪ 4^{π(D)}ε_D(X)+1/D+1/√M_min(X)+√B_X/M_min(X).
First X→∞ at fixed D, then D→∞ proves the uniform o(1) normalized bound.
The required uniform Liouville premise is **OPEN**; it does not follow from OAI007's fixed-form theorem. Under X-scale geometry M_min≈X/P and B_X≈X, the squarefree-tail condition is satisfied for P=o(√X), but this alone does not supply cancellation.

For bounded-variation weights w_{p,h}(m), summation by parts gives exactly
  Σ_{m≤M} c_{p,h}(m)w_{p,h}(m)
    =S_{p,h}(M)w_{p,h}(M)+Σ_{t<M} S_{p,h}(t)(w_{p,h}(t)-w_{p,h}(t+1)),
where c_{p,h}(m)=μ(m)μ(pm+30h) on positive affine support. Hence any *uniform prefix* bound |S_{p,h}(t)|≤η(X)M_{p,h} for all t≤M_{p,h} yields
  |C(X)|≤η(X) Σ_{F_X} M_{p,h} (|w_{p,h}(M_{p,h})|+TV(w_{p,h})).
This certifies a possible mean upper bound but does not show chi_5 outperforms other quadratic gate controls.

## Verification and status
- Finite checks: a deterministic Python check validates μ=λμ² and squarefree indicators for n≤2000, and 96 truncated affine correlation checks (p=7,11,13; h=±1,±2; M=40,97; D=1,2,3,5). This checks algebra only, *not* an asymptotic theorem.
- T75-A, T75-B: exact identities [D].
- T75-C: derived theorem [R], **conditional on accepting OAI007's analytic Liouville result**; no separate review of that result has been completed.
- T76-A: logical counterexample [D].
- T76-B: exact conditional implication [D] with an **unproved uniform premise [O]**.
- Uniform cancellation in growing (p,h) [O]; Couret-specific improvement [O, not observed in EXP-01/02]; novel zero-free/RH claim NONE.

## Decision
Proceed analytically only by quantifying the dependence on (p,h) in Liouville affine estimates or proving an average over families. Compare chi_5 with chi_3 and chi_15 on held-out data; do not retune past negative panels or promote a fixed-parameter corollary into a growing-family theorem.
