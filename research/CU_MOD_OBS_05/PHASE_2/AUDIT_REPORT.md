# CU-MOD-OBS-05 Phase 2: scientific audit of dynamic versioned certification

Date: 2026-10-11. Status: **INTERNAL REPRODUCIBLE PILOT / EXTERNAL REVIEW PENDING**.

## Executive finding

**Conditional finite result:** On a fixed exact `A^2` fiber, answers that are each true at their respective observation times need not form a coherent description of ANY state. A monotone, nonreused version token checked with an atomic compare-and-act can restore a *version-relative* guarantee when the number of mutations and false replies is globally bounded. The exact minimax cost depends on the target property, and cannot simply be inferred from a static query bound.

## Two algebraic negative controls

**n=18 mixed-time phantom.** Four supports share the integer adjacency square. During one mutation `S=(1,4,13)` to `T=(7,10,16)`, read `q_1(S)=1` then `q_4(T)=0`. The transcript `(1,0)` identifies `R=(1,7,16)` if one falsely assumes a fixed state. R was never visited. Every reply is honest (`e=0`). Reading `A^2` again is insufficient to detect the mutation.

**n=22 property switching.** All 1,330 nonzero-labelled triple supports are scanned. The selected square fiber has exactly two elements: `S=(1,3,13)`, `T=(2,12,14)=S+11`. Their *entire integer* squares agree; both cubic traces vanish; but `gcd(22,S)=1` and `gcd(22,T)=2`. Thus neither the square nor that cubic trace decides connectivity on this fiber. Any `A^2`-only checksum is equally blind.

## Minimax table: after baseline / including baseline

Actions: membership query or binary monotone-version compare, each cost 1. `e` lies globally; `m` mutations globally. The initial baseline read costs an additional 1. Bracketed values below are TOTAL including this read.

| e | m | n=18 reconstruction | n=18 contains_1 | n=22 connectivity |
|---:|---:|---:|---:|---:|
| 0 | 0 | 3 [4] | 2 [3] | 2 [3] |
| 1 | 0 | 6 [7] | 4 [5] | 4 [5] |
| 2 | 0 | 9 [10] | 6 [7] | 6 [7] |
| 0 | 1 | 6 [7] | 4 [5] | 4 [5] |
| 1 | 1 | **11 [12]** | **7 [8]** | **7 [8]** |
| 2 | 1 | 16 [17] | 10 [11] | 10 [11] |
| 0 | 2 | 9 [10] | 6 [7] | 6 [7] |
| 1 | 2 | 16 [17] | 10 [11] | 10 [11] |
| 2 | 2 | **23 [24]** | **14 [15]** | **13 [14]** |

All 27 entries are EXACT integer decision-game computations *under the precise model in `FORMAL_MODEL.md`*; two self-contained implementations agree and the next-smaller maximum depth is infeasible in both.

### Static regressions, conditional separation

For m=0, after subtracting the final version check the n=18 reconstruction counts are 2,5,8 for e=0,1,2 respectively, and membership-property counts are 1,3,5. These match the static Phase 1 model. With e=m=1, full n=18 reconstruction requires 12 total actions but a single target property only 8. This separation survives temporal uncertainty **within this game**, not necessarily under different oracles, target classes, or pricing.

A conservative retry policy always completes a FULL STATIC e-error-robust interrogation and then checks its version. It costs at most `1+(m+1)*(Q_static(e)+1)` under these assumptions. For n=18 reconstruction, e=m=1, this is 13 versus the dynamic optimum 12; for e=m=2, 28 versus 24. The optimal game can retain legitimate information/budget constraints after detecting a stale version.

### Linear extrapolation failure

For n=22 connectivity at e=2, the optimal post-baseline costs for m=0,1,2 are `(6,10,13)`, **not** `(6,10,14)`. A naive constant cost-per-mutation rule is refuted in this exact small example. Alternation between only two admissible states constrains where an even number of true mutations can end; no universal formula is inferred from this observation. This example is an internal computed finding, not a claimed original law.

## Independent checks

- Integer-mask minimax and a separate frozenset-of-worlds solver agree on 27 configurations.
- Three explicit DAG policies for `e=m=1` have respectively 142 nodes (n=18 reconstruction), 27 (n=18 membership property), and 27 (n=22 connectivity).
- Every DAG edge is checked against a separate mutation-and-lie transition generator, and physical true-world trajectories are replayed at every branch. Only SAME atomic validation edges can terminate with the correct target.
- `test_dynamic.py` reports 10 passing tests, including full-square fiber counts, false-inference witnesses, modulo-2 version ABA, n=22 trace, historical static regressions, independent lower bounds, exhaustive world replay, and the nonlinearity witness.
- No external code, hardware prototype, live AI system, user data or experimental oracle calibration was involved.

## Explicit failure modes and scope limits

1. **A^2 and Tr(A^3) are NOT version tokens.** n=22 furnishes a property-changing mutation invisible to both.
2. **Finite modular version counters are unsafe without wraparound control.** In the n=18 fiber, `S0 -> S3 -> S1` causes version modulo 2 to read 0,1,0 even though S1 differs from S0.
3. **TOCTOU:** a correct version check followed by an unguarded later action does not certify that later action.
4. **Unlimited mutations:** the adversary can prevent completion by invalidating each attempted certificate. Safety does not imply liveness.
5. **No empirical version calibration:** monotonicity, exact change detection, atomicity and linearizability are stipulated contracts. Real implementations need separate formal or systems validation.
6. **Selective finite domain:** the only dynamic transition graphs are complete mutation graphs on these one chosen n=18 fiber and one n=22 pair. Other fibers and n require new campaigns.
7. **No pricing transfer:** these are abstract unit costs, not joules, wall-clock latencies, API costs, or expected costs under a physical hazard model.
8. **No priority claim:** algorithmic adversarial search, versioning, linearizability and atomic snapshots have substantial prior art. This report is not a novelty audit.
9. **Not preregistered:** this phase's protocol and analyses were finalized alongside exploratory calculations. The next protocol is separated prospectively.

## Bibliography / antecedent boundaries

- Herlihy & Wing (1990), *Linearizability: A Correctness Condition for Concurrent Objects*, DOI: https://doi.org/10.1145/78969.78972 . The atomic commit requirement belongs to classical concurrent correctness, not a Couret-specific novelty.
- Afek et al. (1993), *Atomic Snapshots of Shared Memory*, DOI: https://doi.org/10.1145/153724.153741 . Prior art for temporal snapshot consistency.
- A. Pelc (2002), *Searching games with errors -- fifty years of coping with liars*, DOI: https://doi.org/10.1016/S0304-3975(01)00303-6 . Prior art for adversarial error-tolerant interrogation.
- Internal source: CU-MOD-OBS-04, archived 2026-10-11, and CU-MOD-OBS-05 Phase 1. General STROBO-C3 classification and novelty are not audited here.

## Gate status and external falsification targets

E: finite proof by exhaustive recurrence **internal**; conditional freshness proposition follows the oracle contract. Q: two source implementations and explicit replay **pass locally**. N: novelty **unresolved**. R: independent EXTERNAL reviewer **pending**.

Falsify by any valid shorter policy under the complete rules; an omitted adversary response path; a trace whose true target differs at SAME atomic validation; a missing n=22 same-square support; a different cubic trace; a prior result already encompassing the whole claim; or an implementation failure of the assumed version oracle.

**Disposition:** add to the existing PR #21 as an unfused, clearly separate Phase 2; synchronize to Drive; request contradiction and reviewer testing before any stable release.