# STAT-TRANS-07 — Concrete case registry — CURRENT

Status date: 2026-10-08
Lifecycle: CURRENT
Dependency: STAT-TRANS-01..06
Novelty: NON-AUDITEE
Claim boundary: this registry binds scientific case labels to concrete artifacts and typed dependency receipts. It does not prove that the external artifact contents are authentic merely because their identifiers are stored here.

## Purpose

STAT-TRANS-06 proves the policy on bounded scientific encodings.
STAT-TRANS-07 makes the bindings explicit:

- which concrete claim each node represents;
- which artifact is authoritative for that node;
- which typed edge is being asserted;
- which receipt or source justifies that edge;
- which promotions remain forbidden.

The machine-checked graph policy and the documentary binding remain separate assurance dimensions.

## Case G30

### G30-A — finite certificate

Claim:
exact finite mod-30 result, read only inside its declared finite scope.

Primary authority:
Google Drive document `00 — STATUS & CLAIM BOUNDARY — CURRENT — MOD30 & NOYAU FINI`
ID: `1BfnMwX8BJYrtGJGx_JY-iT5YfuFYyAwT7MHvKKll27g`.

Boundary from authority:
no finite result alone authorizes a uniform law, RH consequence, or general mechanism.

### G30-B — local derived claim

Dependency:
`G30-A --proof--> G30-B`.

Meaning:
a local consequence may inherit semantic force only when a proof bridge is supplied.

Receipt class:
identified finite theorem / exact artifact for the specific derived statement.

### G30-C — unsupported global extension

Dependency encoded in STAT-TRANS-06:
`G30-B --documentary--> G30-C`.

Meaning:
a narrative or documentary association to a global extension is not a semantic proof edge.

Required result:
semantic reachability from G30-A to G30-C remains blocked.

### G30-D — documentary pointer

Dependency:
`G30-C --documentary--> G30-D`.

Forbidden promotion:
finite mod-30 evidence => global prime law, RH, Hilbert–Polya, or canonical physical transport.

## Case T16

### T16-A — abstract equivalence/no-gain theorem

Authority:
`research/COURET_OAI_BRIDGE_01_T16.md`.

Statement:
Big-O class is preserved under a continuous linear equivalence.

Current source status:
A0–A2 are recorded as compiled zero-sorry under Lean 4.34.1 / Mathlib 4.34.1 with prior successful CI and axiom audit.

### T16-B — fixed-modulus instantiation

Dependency:
`T16-A --proof--> T16-B`.

Meaning:
instantiate the abstract theorem with the fixed Couret convolution equivalence.

### T16-C — derived fixed-modulus no-gain claim

Dependency:
`T16-B --proof--> T16-C`.

Statement boundary:
the fixed invertible modulus-30 filter cannot by itself improve the global asymptotic exponent of the full finite-dimensional state vector.

### T16-D — novelty audit

Dependency:
`T16-C --novelty--> T16-D`.

Meaning:
novelty is a separate channel. Semantic proof reaches T16-C, not T16-D as a semantic fact.

Forbidden promotion:
formal proof => originality.

## Case Cayley

### CAYLEY-A — prior-art result

Authority:
`alexcour/cayley-prime-translation-cospectrality/PUBLICATION_STATUS.md`
plus `PRIOR_ART.md` for exact antecedence statements.

Current boundary:
Mönius 2020 overlaps a specified subfamily; broader novelty remains NON AUDITEE.

### CAYLEY-B — originality review

Dependency:
`CAYLEY-A --novelty--> CAYLEY-B`.

Meaning:
new prior art can change N without revoking the truth of a theorem.

### CAYLEY-C — public-review document

Dependency:
`CAYLEY-B --documentary--> CAYLEY-C`.

Current dissemination:
PUBLIC REVIEW / 0.1.x.

### CAYLEY-D — independently audited mathematical proof

No edge from CAYLEY-A is licensed to CAYLEY-D in the current registry.

Reason:
prior art and novelty review do not automatically invalidate semantic proof or replay.

Forbidden promotion:
public review => external validation;
N open => priority claim.

## Case OAI-7/8

### OAI-A — verifier/toolchain contract

Authority:
OpenAI snapshot `openai/math@adc7f1241b42e322a6451854ab7e4b4c146bf78a`;
target Lean `v4.34.1`;
Comparator challenge `ComparatorChallenges.QuasiRiemannHypothesis`.

Couret audit authority:
Google Drive `OAI-7/8-AUDIT-01 — ... — CURRENT`
ID: `1iK5IrXXEB-mM9YC_zVzzvKQPy9Ezp6zMqcmTmMhP2mQ`.

### OAI-B — replay result

Dependency:
`OAI-A --replay--> OAI-B`.

Meaning:
successful independent replay may upgrade Q-Reproducibility for the theorem.

### OAI-C — published narrative

Dependency:
`OAI-B --documentary--> OAI-C`.

Meaning:
replay success does not by itself upgrade publication claims beyond the actual public artifact.

### OAI-D — novelty audit

No replay edge is licensed from OAI-A/B to OAI-D.

Current audit status:
novelty OPEN; external peer review OPEN; transitive dependency audit OPEN in the documentary audit unless separately closed by OAI-7/8-AUDIT-01R.

Forbidden promotion:
replay PASS => novelty;
Lean proof => peer review;
7/8 theorem => RH or GRH;
OAI result => validation of historical Couret mod-30-to-zeta bridges.

## Cross-case isolation

No typed dependency edge is authorized between G30, T16, Cayley, and OAI-7/8 merely because they coexist in the same program.

Any future cross-case edge must name:
- source claim;
- target claim;
- dependency kind;
- bridge statement;
- witness;
- version/commit;
- invalidation consequences.

## Formalization plan

The corresponding Lean layer should use concrete case/claim identifiers and prove:

1. every registered typed edge stays inside its declared scientific case unless a cross-case bridge is explicitly added;
2. G30 finite evidence has no semantic path to the unsupported global-extension node;
3. T16 proof edges carry semantic impact through the fixed-modulus chain while novelty remains a separate axis;
4. Cayley prior-art changes propagate novelty without manufacturing semantic or replay invalidation;
5. OAI replay propagates replay only and does not create novelty;
6. disconnected cross-case nodes are unreachable for all axes.

Artifact identifiers are metadata. Lean will certify the graph and propagation policy, not independently authenticate Google Drive or GitHub contents.

## Formal verification status

STAT-TRANS-07 is FORMALLY VERIFIED for its declared bounded graph-policy perimeter.

Evidence:
- Lean layer: `research/lean/CouretOaiBridge01/STAT_TRANS_07_ConcreteRegistry.lean`;
- exposed by `CouretOaiBridge01.lean`;
- commit: `a287e7cebeb26f80ab569b61aa28b2f7336b7087`;
- `bridge01-lean` run #60: SUCCESS;
- `verify` run #147: SUCCESS;
- transitive axiom audit: PASSED;
- reported public declarations: 53;
- allowed standard axioms observed: `propext`, `Classical.choice`, `Quot.sound`.

Boundary:
this verifies the typed graph, propagation policy, case-locality, scope firewall, and selected no-cross-case reachability statements. It does not authenticate external files from their string identifiers, close novelty audits, or establish new mathematical links between the four scientific cases.

