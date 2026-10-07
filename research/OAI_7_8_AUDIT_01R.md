# OAI-7/8-AUDIT-01R — EXECUTION NOTE — CURRENT

Status date: 2026-10-07
Snapshot: `openai/math@adc7f1241b42e322a6451854ab7e4b4c146bf78a`
Target toolchain: `leanprover/lean4:v4.34.1`
Workflow: `.github/workflows/oai-7-8-audit-01r.yml`

## Frozen criteria

PASS-REPRO is authorized only if the workflow:

1. checks out the exact OpenAI snapshot;
2. prepares the declared Lean environment;
3. runs Comparator on `ComparatorChallenges/QuasiRiemannHypothesis.json`;
4. succeeds under the config permitted axioms;
5. prints the actual axioms used by `OAI.riemannZeta_ne_zero_of_seven_eighths_lt_re`;
6. records a static search for same-name/equivalent-target warning signs;
7. hashes the produced audit logs;
8. uploads the receipt as a workflow artifact.

No criterion may be weakened because of the observed result.

## Documentary checks already passed

- Comparator challenge statement and solution statement have the same theorem name and displayed type.
- Challenge contains a `sorry`; the solution delegates to the published final assembly rather than reusing that challenge proof.
- Comparator configuration explicitly pairs challenge and solution modules.
- Permitted axioms are `propext`, `Quot.sound`, and `Classical.choice`.
- OpenAI scope documentation states the same strict half-plane `Re(s)>7/8` and distinguishes later paper applications from the Lean formalization.
- The target repository snapshot declares Lean 4.34.1.

## Still open until workflow result

- independent Comparator replay;
- actual axiom print from the replay environment;
- environment/build reproducibility under the frozen snapshot;
- stronger dependency-closure analysis beyond the current direct trace;
- novelty/prior art;
- independent mathematical peer review.

## Current execution

GitHub Actions run #1 was triggered by the commit adding the workflow. Its result must be read before any PASS-REPRO promotion.

## Interpretation guard

A successful workflow upgrades reproducibility Q for this theorem. It does not:
- establish novelty;
- constitute peer review;
- imply RH or GRH;
- validate any historical Couret mod-30 to zeta bridge.
