# COURET–OAI–BRIDGE–01 — exploratory research log

> **RESEARCH BRANCH — NOT PART OF v1.0.0 — NO RH CLAIM — NOT PEER REVIEWED**
>
> This note records an exploratory comparison between finite Couret–Unification objects and the analytic architecture of OpenAI's October 2026 quasi-Riemann-hypothesis work. It does **not** claim a proof of RH, a new zero-free region, or mathematical priority. Statements below are classified locally as exact finite facts, elementary derivations to be formalized, historical observations, or open targets.

## Purpose

The question is no longer whether a fixed mod-30 object can be read directly as the spectrum of the Riemann zeros. The working question is narrower and falsifiable:

> Can the finite character architecture of U(30), or a justified extension of it, contribute a genuinely new **uniform cancellation estimate** for the Möbius/Dirichlet-polynomial objects that control reciprocals 1/L(s,χ)?

The comparison is made against the public OpenAI repository openai/math, especially the quasi-RH preprint and its Lean scope/solution files.

## Current claim boundary

- Exact finite statements about U(30), T_C={1,11,29}, its Fourier spectrum, and related finite operators retain their existing bounded status.
- No fixed finite computation is promoted to a uniform asymptotic statement.
- No statement in this note implies RH, GRH, Hilbert–Pólya, or a zero-free half-plane.
- The OpenAI result is used as a comparison target, not as validation of earlier Couret claims.
- Historical Couret–Unification files are evidence of the research trajectory only; CURRENT status documents and primary artifacts dominate retrospective summaries.

## 1. Where the reasoning genuinely converges

The strongest shared architecture is:

finite characters / twists
→ local Euler structure
→ Möbius or inverse polynomials
→ quadratic/moment control
→ Mellin representation containing 1/L
→ analytic continuation / zero-free region.

Historical Couret work had already reached the following ingredients, at varying epistemic levels:

1. decomposition by Dirichlet characters modulo 30;
2. finite Fourier/Parseval control;
3. Möbius/Euler decompositions;
4. primitive/imprimitive character bookkeeping;
5. local Euler-factor corrections;
6. Mellin transforms and an explicit recognition that the Euler bridge was the central open wall;
7. later correction from a binary prime-power split to a ternary split m=1 | m=2 | m≥3;
8. identification of sieve / zero-density type estimates as missing analytic machinery.

OpenAI's public proof supplies the part that Couret–Unification did not: a zero detector, theta/Poisson transformations, uniform moment bounds, a sextic large sieve, local prime compensation, and the resulting power saving used in a continuation criterion.

## 2. Exact finite fact: the Couret triplet is an invertible Fourier filter

For G=U(30), the indicator of T_C={1,11,29} has Fourier power profile

|hat(1_T_C)|^2=(9,1,1,1,9,1,1,1).

Hence every Fourier coefficient is nonzero. Therefore convolution by 1_T_C is invertible on the finite group algebra C[G].

With the standard finite Fourier normalization, the convolution eigenvalues have absolute values 3 or 1. Consequently, for the counting L2-norm, one has norm equivalence of the form

||f||_2 ≤ ||1_T_C * f||_2 ≤ 3 ||f||_2

up to the exact Fourier normalization convention.

### Interpretation

This gives a strong **fixed-modulus no-gain heuristic/theorem target**:

> A fixed invertible mod-30 convolution can reorganize and reweight finite character channels, but it cannot by itself create a new asymptotic exponent of cancellation.

This is the opposite of the old intuition that a special finite spectrum might directly encode a zero distribution.

## 3. Fixed-modulus twist decomposition

Let w:U(30)→C, and extend it periodically to integers coprime to 30. Fourier inversion gives

w(a)=(1/8) Σ_{ψ in U(30)^} hat(w)(ψ) overline(ψ(a)).

For Re(s)>1, define

D_{χ,w}(s)=Σ_{n≥1} μ(n)χ(n)w(n mod 30)/n^s,

with the local convention that w is supported on (n,30)=1. Then formally, and absolutely in the initial half-plane,

D_{χ,w}(s)
=(1/8) Σ_ψ hat(w)(ψ)
Σ_{n≥1} μ(n)(χ overline(ψ))(n)/n^s.

After the usual finite local-factor bookkeeping between imprimitive characters and their primitive inducing characters, this is a finite linear combination of reciprocals 1/L(s,χ overline(ψ)).

### Working interpretation

A fixed mod-30 weight acts naturally as a **finite multiplexer of L-function twists**. It does not automatically supply the analytic cancellation needed to continue those reciprocals to the left.

## 4. Möbius on the units gives a direct reciprocal-zeta channel

For Re(s)>1,

Σ_{(n,30)=1} μ(n)/n^s
= ∏_{p∤30}(1-p^{-s})
= (1/ζ(s)) ∏_{p|30}(1-p^{-s})^{-1}.

The finite factor

H_30(s)=∏_{p=2,3,5}(1-p^{-s})^{-1}

is holomorphic and nonzero on Re(s)>0. Thus the analytic obstruction is not the finite local factor but the continuation/control of the Möbius sum itself.

If

M_30(X)=Σ_{n≤X,(n,30)=1} μ(n)

satisfied a uniform power saving M_30(X)=O(X^θ) with θ<1, partial summation would continue the Mellin/Dirichlet representation into Re(s)>θ, yielding a zero-free region there.

This is the clean bridge:

uniform Möbius cancellation
→ continuation of 1/ζ
→ zero-free half-plane.

The hard step is the first arrow.

## 5. Correction preserved from the historical record: primitive vs imprimitive

A historical note incorrectly collapsed an imprimitive Dirichlet L-function to its primitive inducing L-function. The corrected factorization is

L(s,χ)=L(s,χ*) ∏_{p|q, p∤d}(1-χ*(p)p^{-s}),

where d is the conductor of χ*.

Therefore the logarithmic derivative contains finite local correction terms. These factors do not disappear; they must be retained, controlled, or compensated.

This correction is conceptually close to OpenAI's refined 7/8 stage, where selected prime factors provide a local compensation cancelling an unwanted Euler contribution.

## 6. A structural no-go: mod 30 cannot contain the sextic mechanism

U(30)≃C2×C4.

Its exponent is 4. Hence U(30) has no characters of order 3 or 6.

OpenAI's proof uses cubic/sextic character structure over Q(sqrt(-3)). Therefore that mechanism cannot live inside the fixed mod-30 character group alone.

At the next primorial level,

U(210)≃C2×C4×C6,

so order-6 characters appear in the finite model. This does **not** identify them with the Hecke characters used by OpenAI; it only makes 210 a structurally more relevant finite comparison laboratory than 30.

## 7. What OpenAI adds that the fixed finite model lacks

The decisive missing ingredient is not another finite spectral identity. It is a transformation-and-estimate engine that changes analytic scale:

- zero detector producing large inverse and plain Dirichlet polynomials;
- ideal Möbius coefficients representing truncated reciprocals;
- exact theta/reflection and Poisson representations;
- recursive shortening of ranges;
- reflected-energy terminal bounds;
- uniform moment estimates;
- sextic large sieve;
- selected-prime local compensation;
- a Mellin continuation criterion with a uniform positive exponent margin.

Finite Fourier on U(30) is an 8→8 change of basis. It does not shorten a length-X sum, reduce a conductor, or produce a new power saving.

## 8. COURET–OAI–BRIDGE–01 targets

### T1 — finite twist decomposition
Formalize the finite Fourier decomposition of a periodic weight w into Dirichlet twists.

### T2 — invertibility of the Couret filter
Prove from the nonvanishing Fourier spectrum that convolution by 1_T_C is invertible, with explicit norm constants.

### T3 — fixed-modulus no-gain theorem
State and prove an exponent-preservation theorem: any X^α-type L2 bound for a finite vector of residue-class sums is equivalent, up to fixed constants, before and after an invertible fixed-modulus transform.

This does **not** rule out gains from noninvertible projections, scale-dependent weights, conductor-dependent transforms, or genuinely analytic transforms such as Poisson.

### T4 — reciprocal-zeta identity on U(30)
Formalize the exact finite-local-factor identity for the Möbius series on integers coprime to 30 in its domain of absolute convergence.

### T5 — continuation lemma
Isolate the standard implication:
M_30(X)=O(X^θ)
⇒ H_30(s)/ζ(s) extends to Re(s)>θ.

This is classical analytic number theory and must be attributed as such, not claimed as project novelty.

### T6 — causal-value test for T_C
Design a falsifiable comparison against generic fixed weights and matched random/structured weights. A Couret-specific role exists only if a scale-dependent construction using T_C improves a quantitative bound beyond what follows from fixed finite-dimensional norm equivalence.

## 9. Stop conditions

The analytic Couret branch should stop or be demoted if:

1. every proposed T_C insertion reduces to an invertible fixed finite change of basis;
2. no second exact representation of the same scale-dependent sum is found;
3. no uniform exponent improvement survives generic-weight controls;
4. a claimed continuation step presupposes the zero-free region it is meant to prove;
5. a local Euler correction is silently dropped;
6. a finite computation is promoted into an asymptotic theorem without a separate uniform estimate.

## 10. Public OpenAI references used for comparison

- OpenAI announcement: https://openai.com/index/sharing-ai-progress-in-mathematics/
- Repository: https://github.com/openai/math
- Quasi-RH paper: https://github.com/openai/math/blob/main/preprints/The-Quasi-Riemann-Hypothesis-September-30-2026/paper.pdf
- Lean scope: https://github.com/openai/math/blob/main/lean/docs/003.md
- Lean solution module: https://github.com/openai/math/blob/main/lean/OAI/NumberTheory/DirichletL/Nonvanishing.lean

Snapshot used in the internal audit: openai/math commit adc7f1241b42e322a6451854ab7e4b4c146bf78a.

## 11. Synchronization policy

This file is the **public-safe versioned mirror** of a fuller internal research journal. Future updates should:

1. append or revise reasoning only on this research branch until explicit review;
2. preserve corrections and demotions rather than rewriting history;
3. classify each new statement before promoting it;
4. keep main unchanged unless a separate release/publication decision is made;
5. never infer novelty from repository timestamps or from similarity to OpenAI's result.
