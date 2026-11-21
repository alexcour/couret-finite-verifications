# Proposed prospective protocol / CU-MOD-OBS-05 Phase 3 (NOT EXECUTED)

Prepared on 2026-10-11 after Phase 2 audit. This document is a plan, not an assertion of having preregistered Phase 2, and must be frozen with a content hash BEFORE new Phase 3 result generation.

## Primary questions

1. Does a full-version oracle improve the exact minimax cost relative to a binary same/changed oracle, at fixed query/validation cost?
2. Under weighted costs `(c_query,c_version) = (4,1)` and `(1,2)`, does the difference between property-certification and reconstruction remain strict under `e=m=1`?
3. Does the finite-state decision tree remain correct under a separately implemented concurrent state simulator with atomic compare-and-act, including ABA failures when version wrap is permitted?
4. Do previously noticed `m=0,1,2` cost patterns fail on a second independent square-fiber family beyond the chosen n=18 and n=22 instances?

## Required controls and falsifiers

- Lock all target supports, transition graphs, oracles, action costs and optimization budgets in a signed/hash-pinned protocol before execution.
- Extend audit to a fully separate implementation language or independently maintained code, not merely two programs written in the same environment.
- Keep global-versus-per-retry lie-budget conventions explicit.
- Count acquisitions and version oracle pricing independently; do not collapse an abstract cost into elapsed time.
- Include a negative non-atomic compare-then-act implementation that must fail under one precisely scheduled mutation.
- Keep safety (no incorrect successful certificates) separate from liveness (eventual completion).
- List all prior work checked and abstain from novelty or AI-safety claims without independent evidence.
- Publish the entire policy certificates, failed tests, manifests, environment details, and expected outputs.

## Gate

NOT RUN / NOT VALIDATED. Phase 3 can proceed only after protocol hash is frozen and code/results are developed against that frozen specification.