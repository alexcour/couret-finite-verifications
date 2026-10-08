# STAT-TRANS-10 — Bridge-receipt and differential mutation suite — CURRENT

Status date: 2026-10-08
Lifecycle: CURRENT
Formal status: D-Lean / bounded formal perimeter
Novelty: NON-AUDITEE
Claim boundary: this layer validates mutation/oracle mechanics only. It does not admit a real cross-case scientific bridge, authenticate external artifacts, close novelty review, or prove an external replay.

## Two complementary test surfaces

### A. Lean bridge-receipt mutation suite

File:
`research/lean/CouretOaiBridge01/STAT_TRANS_10_BridgeReceiptMutationSuite.lean`

Purpose:
pre-specify ACCEPT / REJECT behavior for untrusted bridge drafts and synthetic receipts.

The executable pre-check requires:
- different scientific cases;
- non-empty bridge statement;
- non-empty witness reference;
- non-empty version reference;
- transported axis explicitly listed in reopened axes;
- compatibility with the refined V2 axis/dependency policy.

The B01–B12 matrix covers:
- complete semantic/proof bridge: ACCEPT;
- same-case bridge: REJECT;
- empty statement: REJECT;
- empty witness: REJECT;
- empty version: REJECT;
- missing reopened axis: REJECT;
- documentary active bridge: REJECT;
- proof used for novelty: REJECT;
- replay/replay bridge: ACCEPT;
- replay used for semantics: REJECT;
- novelty/novelty bridge: ACCEPT;
- proof/justification bridge: ACCEPT.

B13–B16 use a synthetic semantic receipt to verify:
- the declared semantic axis is admitted;
- novelty is not admitted;
- the synthetic receipt is not in the production registry;
- the current production registry remains case-local.

### B. Concrete differential mutation oracle

Files:
- `research/STAT_TRANS_10_MUTATION_ORACLES.json`
- `scripts/test_stat_trans_mutations.py`

Purpose:
test differential invalidation over the 16 concrete registry nodes bound by STAT-TRANS-09.

The fixed oracle currently contains nine cases:
- T16 proof-support change;
- G30 proof-support change;
- Cayley prior-art change;
- OAI toolchain/version change;
- T16 novelty-only change;
- OAI publication/diffusion-only change;
- T16 replay dependency change;
- OAI replay quality change;
- G30 provenance-only change.

The script checks both:
- audit impact: everything that should be rechecked;
- admission impact: only paths whose edges are already admitted with the required assurance.

This distinction prevents an open `requires_bridge` edge from silently becoming an admitted proof dependency.

## Current production bridge registry

`currentBridgeReceipts = []`.

Therefore no real cross-case scientific bridge is admitted.

A synthetic receipt used in tests does not mutate the production registry.

## GitHub verification

Reconciliation head:
`c81388f0b9b5a2ca1954c92b7cf669729ccbaade`.

Results:
- `bridge01-lean` #70: SUCCESS;
- `verify` #170: SUCCESS.

The specialized workflow compiles the Lean research library, verifies STAT-TRANS-09 artifact bindings, runs the fixed STAT-TRANS-10 mutation oracle, and then runs the transitive Lean axiom audit.

## Permanent boundary

A PASS here means:
- the typed bridge admission mechanics behave as pre-specified;
- the current differential mutation oracle produces no false positives or misses against its fixed expected sets;
- no synthetic bridge leaks into the production registry.

It does not mean:
- any G30↔T16↔Cayley↔OAI bridge is scientifically true;
- any external source string is authenticated by Lean;
- novelty is established;
- peer review is acquired;
- OAI replay is independently closed;
- RH or GRH is claimed.

## Next gate

Before any first real `BridgeReceipt` can enter production, it must have:
1. a concrete source claim and target claim;
2. a non-synthetic bridge statement;
3. an identified witness that actually proves the bridge;
4. a pinned version/commit;
5. the exact transported axis;
6. explicit reopened/invalidation axes;
7. successful compilation and mutation tests;
8. a separate novelty/review assessment where relevant.

Until those conditions are met, the empty production bridge registry is the correct state.
