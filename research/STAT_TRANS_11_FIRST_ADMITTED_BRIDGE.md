# STAT-TRANS-11 — First admitted cross-case bridge — CURRENT

Status date: 2026-10-08
Lifecycle: CURRENT-CANDIDATE
Formal status: CANDIDATE IN CI
Novelty: NON-AUDITEE
Claim boundary: this layer admits one narrowly scoped cross-case justification dependency. It does not transport semantic truth, replay status, novelty, publication status, or any global analytic claim.

## Bridge admitted

Source:
`g30Finite`

Target:
`t16FixedModulus`

Axis:
`justification`

Dependency kind:
`proof`

## Why this bridge is real

The target Lean module
`BRIDGE01_A2_FixedModulusNoGain.lean`
imports
`BRIDGE01_A1_U30KernelInverse.lean`.

A1 proves:
`CouretOaiBridge01.tau_mul_sigma`.

A2 defines the coefficient extension
`rationalToReal : U30Alg →+* U30AlgR`
and proves:
`CouretOaiBridge01.tauR_mul_sigmaR`
by applying `congrArg rationalToReal tau_mul_sigma` and simplifying the mapped terms.

Therefore the justification of the real fixed-modulus equivalence in A2 depends on the finite inverse certificate established in A1.

## Pinned witnesses

A1 blob:
`40072f43ce3ebac6959fd04e86321818567b1c4c`.

A2 blob:
`f14a47b397de6314e68e0c9e014d15f36eebb799`.

Source declaration:
`CouretOaiBridge01.tau_mul_sigma`.

Transport declaration:
`CouretOaiBridge01.tauR_mul_sigmaR`.

## What the bridge transports

Only the `justification` axis.

Meaning:
if the A1 inverse certificate is withdrawn or invalidated, the proof support for the A2 fixed-modulus construction must be reopened.

## What the bridge does not transport

The receipt explicitly does not admit:
- semantic transport from G30 to T16;
- replay transport;
- novelty transport;
- publication transport;
- any path from finite mod-30 evidence to a global zeta/RH claim;
- any claim that T16 is original merely because A1 is formally verified.

## Lean layer

File:
`research/lean/CouretOaiBridge01/STAT_TRANS_11_FirstAdmittedBridge.lean`.

Main receipt:
`g30ToT16JustificationReceipt`.

Production registry:
`productionBridgeReceiptsV1`.

Key statements:
- `g30_to_t16_justification_admitted`;
- `g30_to_t16_semantic_not_admitted`;
- `g30_to_t16_replay_not_admitted`;
- `g30_to_t16_novelty_not_admitted`;
- `no_receipt_to_g30_global_extension`;
- `empty_baseline_remains_empty`.

## Baseline preservation

STAT-TRANS-08's
`currentBridgeReceipts = []`
remains unchanged as the empty baseline.

STAT-TRANS-11 introduces a separately versioned production registry:
`productionBridgeReceiptsV1`.

This preserves replayability of the zero-bridge baseline while allowing an explicit first admission.

## Promotion gate

STAT-TRANS-11 becomes D-Lean only after:
- the module compiles in `bridge01-lean`;
- the general `verify` workflow passes;
- no new sorry is introduced;
- the transitive axiom audit remains within the declared policy.

Until then, this first production bridge is a formally specified candidate, not a promoted bridge.
