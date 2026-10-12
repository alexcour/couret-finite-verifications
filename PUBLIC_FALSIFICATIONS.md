# Public register of refutations, demotions and failed hypotheses

**Updated 2026-10-09.** This public register summarizes selected entries of the internal *JOURNAL F — FALSIFICATIONS & DÉMOTIONS — CURRENT*. It is a **scientific correction log**, not evidence that all underlying computations have received outside review. Private source reports may not be publicly readable. Claims marked historical are **not** to be reused as current findings.

## F-001 — Incorrect observed prime proportion for {1,11,29} mod 30

**Historical, REFUTED observational claim:** A prime proportion near `0.378` was reported at `x=10^9` (sometimes further extrapolated toward `1/sqrt(7)`).

**Correct finite measurement:** `π(10^9)=50,847,534`, and `19,067,732` primes have residue `1`, `11`, or `29` modulo 30, giving `0.374998166086`, very near `3/8`.

The following individual class counts were independently recomputed with a C++17 segmented sieve: `6,355,189`, `6,356,197`, and `6,356,346`. This check was executed locally on 2026-10-09, independently of the historic program.

**Reproduce:** [C++17 source](research/open-reproduction/falsifications/verify_mod30_prime_proportion.cpp).
```bash
g++ -std=c++17 -O2 -Wall -Wextra research/open-reproduction/falsifications/verify_mod30_prime_proportion.cpp -o verify_mod30
./verify_mod30 1000000000
```

This exact finite count **does not** establish a prime-number theorem, a fluctuation limit, a `1/√7` bias or a new phenomenon. It refutes the earlier reported numerical observation only.

**Source status:** Derived from internal F-001 journal entry, with a separate independent executable check. [Historical research report](https://docs.google.com/document/d/1A9TT9PYQLyBzGG-99TydmA6v0PZL1pLRU6FAWxM9Lzc/edit) (sharing permissions not asserted).

## F-CONT-TIME-001 through -006 — selection effects, not an intrinsic prime clock

The internal frozen-protocol sequence documents: v1.0 design flaws; failure of positive memory at v1.1; v1.2 and v1.4 apparent positive comparisons with inadequate nulls; at v1.3 surrogate stopping-time controls account for the gains; and at v1.5 stronger locally matched null models fail to show robust excess time structure for the tested H3/H4 signals.

**Outcome:** Historical positive results v1.2/v1.4 are demoted; they should **not** be cited as detection of an independent arithmetical clock. This is a methodological result within the tested protocol, not a proof that no prime-based intrinsic time observable could ever exist.

**Reproduction status:** Full tested scripts and input data were **not** collected into this public register. Their existence and portability require separate checking.

## F-002 / F-003 — erroneous limit-point classifications

The internal audit records corrections to older assertions that the *minimal* classical regular Legendre and regular finite-interval Schrödinger operators were LP/LP with deficiency indices `(0,0)`. Correct statement for the declared regular/Legendre examples: LC/LC with indices `(2,2)`, with explicit endpoint choices. Do not infer universal classifications for singular finite-interval endpoints.

**Scope:** Classical functional analysis; not a new theorem or an RH result. External replay of historical source versions has not been asserted here.

## F-004 / F-005 — certificate failures, not necessarily false mathematical propositions

- F-004: historical Bessel computational certificate failed audit (sign, deficiency equation, truncation); the relevant `|ν|=1` classical threshold remains valid in its standard domain.
- F-005: the claimed Weyl/Kato proof route for an integral Hilbert–Pólya candidate was invalid; **invalid proof ≠ counterexample to the underlying, still open operator property**.

No claim of solving RH is permitted.

## F-006 / F-007 / F-008 / F-009 — group and cohomology corrections

- F-006: `U(30) ≅ C2^3` was wrong. Correct: `U(30) ≅ C2 × C4`.
- F-007: the earlier assertions `H^1_et(F_q,Z/ℓ)=0` and `Pic(Spec(Z/30))` identified with the unit-group characters were incorrect. The audited calculation uses `H^1_et(F_q,Z/ℓ) ≅ Z/ℓ` (for the constant étale sheaf in the stated setting) and `Pic(Spec(Z/30))=0`.
- F-008: the supposed `0.378` cohomological Frobenius trace attached to `Spec(Z/30)` was invalid; the elementary prime density for any three of eight coprime residue classes is `3/8` asymptotically.
- F-009: `3/8` as a proposed novel invariant was demoted; it is an elementary count of three classes among eight, not a discovery.

**Review scope:** Independent identification of precise corrections and of older prior art is welcome. The finite G30 class computation is separately reproducible in [the G30 public package](research/open-reproduction/g30/README.md).

## CU-BRUIT-02 — explicitly conditional and numerically incomplete, not a refutation

The journal also records conditional Rubinstein–Sarnak calculations under unproved GRH+LI assumptions, based on finite numerical root lists not certified exhaustive at the published heights. This is **not** an unconditional result and must not be conflated with F-001.

## Provenance and independent scrutiny

The underlying [living F journal](https://docs.google.com/document/d/1Cln8aCg1p76nkk54Ng7Yj6IeRMiYVNl14DeAAeBvJIE/edit) contains additional later entries, timestamps and changes of experimental status, including superseded CI notices. **This public summary does not imply the whole journal is already open or independently replayed.**

If any correction here is in error, or if the original statement has been mischaracterized, please open an issue and provide the precise definition, counterexample, citation or reproducible script. Later retractions should be appended with dates and earlier versions retained.

**Principle:** Keep falsifications, audit limitations and negative results at least as discoverable as successful finite computations. Neither GitHub publication nor passing tests equals independent peer review.
