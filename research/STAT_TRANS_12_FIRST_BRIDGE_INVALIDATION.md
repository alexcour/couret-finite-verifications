# STAT-TRANS-12 — Invalidation through the first admitted bridge — CURRENT

Status date: 2026-10-08
Lifecycle: CURRENT-CANDIDATE
Formal status: CANDIDATE IN CI
Novelty: NON-AUDITEE
Claim boundary: this layer tests invalidation propagation through the first admitted bridge. It does not create a second bridge and does not expand the mathematical scope of G30 or T16.

## Purpose

STAT-TRANS-11 admits one narrow cross-case receipt:

`g30Finite --justification/proof--> t16FixedModulus`.

STAT-TRANS-12 asks the operational question:

if the proof support at `g30Finite` changes, which assurances downstream must be reopened?

## Pre-specified mutation

The mutation is local and support-only:

- node: `g30Finite`;
- `proofSupportChanged = true`;
- no semantic delta;
- no replay delta;
- no novelty delta.

Therefore `g30Finite` is a justification seed only.

## Expected propagation

The admitted receipt must carry justification impact to:

`t16FixedModulus`.

Then the already registered local proof edge must continue justification impact to:

`t16DerivedNoGain`.

So the expected chain is:

`g30Finite -> t16FixedModulus -> t16DerivedNoGain`

on the justification axis only.

## Forbidden propagation

The same support-only mutation must not create:
- semantic impact;
- replay impact;
- novelty impact;
- justification reachability to `g30GlobalUnsupported`.

This keeps the first real bridge conservative.

## Lean layer

File:
`research/lean/CouretOaiBridge01/STAT_TRANS_12_FirstBridgeInvalidation.lean`.

Main definitions:
- `g30ProofSupportLoss`;
- `ProductionImpacted`;
- `productionStepV1`;
- `walkProductionV1`.

Key theorems:
- `g30_is_justification_seed`;
- `g30_support_loss_impacts_t16_fixed_modulus`;
- `g30_support_loss_impacts_t16_derived_no_gain`;
- `no_semantic_impact_from_support_only_change`;
- `no_replay_impact_from_support_only_change`;
- `no_novelty_impact_from_support_only_change`;
- `bounded_oracle_first_bridge_behavior`.

## Bounded oracle

The finite production oracle checks that:
- justification reaches `t16FixedModulus`;
- justification reaches `t16DerivedNoGain`;
- justification does not reach `g30GlobalUnsupported`;
- semantic does not cross the bridge;
- replay does not cross the bridge;
- novelty does not cross the bridge.

## Promotion gate

STAT-TRANS-12 becomes D-Lean only after:
- `bridge01-lean` succeeds on a head importing STAT-TRANS-12;
- `verify` succeeds;
- no new sorry is introduced;
- the transitive axiom audit remains inside the declared policy.

Until then, it remains a formal candidate.
