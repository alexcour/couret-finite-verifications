# STAT-TRANS-13 — Controlled bridge revocation — CURRENT-CANDIDATE

Status date: 2026-10-08
Lifecycle: CURRENT-CANDIDATE
Formal status: CANDIDATE IN CI
Novelty: NON-AUDITEE
Claim boundary: this layer governs whether an already recorded BridgeReceipt is currently enabled for transport. Revocation does not erase history and does not assert that either endpoint claim is false.

## Purpose

STAT-TRANS-11 admitted the first production bridge:
`g30Finite --justification/proof--> t16FixedModulus`.

STAT-TRANS-12 verified the resulting invalidation propagation.

STAT-TRANS-13 adds the inverse operation: controlled revocation.

## Governed receipt

A `GovernedReceipt` contains:
- the historical `BridgeReceipt`;
- an `enabled : Bool` admission bit.

Two registries are defined:
- `governedRegistryV1`: the first receipt enabled;
- `governedRegistryV1Revoked`: the same receipt retained but disabled.

## Required behavior

Before revocation:
- the G30 -> T16 justification receipt is active.

After revocation:
- the direct cross-case justification edge is absent;
- the historical receipt metadata is still present;
- the local T16 proof dependency
  `t16FixedModulus -> t16DerivedNoGain`
  remains active;
- no novelty transport is created by re-enabling the justification receipt;
- STAT-TRANS-08's empty baseline remains unchanged.

## Key theorems

- `first_bridge_enabled_before_revocation`;
- `first_bridge_disabled_after_revocation`;
- `revoked_registry_preserves_receipt_metadata`;
- `revocation_preserves_t16_local_justification`;
- `revoked_g30_to_t16_direct_edge_absent`;
- `explicit_reenable_restores_only_declared_receipt`;
- `empty_baseline_still_unchanged`.

## Interpretation

Revocation means:
"this receipt must no longer be used for current status transport."

It does not mean:
- the G30 theorem is false;
- T16 is false;
- the historical dependency never existed;
- local T16 proof edges are removed;
- novelty or publication status changes;
- any global analytic claim is affected.

## Promotion gate

STAT-TRANS-13 becomes D-Lean only after:
- the module compiles in the specialized `bridge01-lean` workflow;
- the general `verify` workflow succeeds;
- no new sorry is introduced;
- the transitive axiom audit remains within policy.

Until then it remains a formal candidate.
