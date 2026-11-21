# CU-MOD-OBS-05 / Phase 2: dynamic observability and atomic freshness

**Date:** 2026-10-11. **Status:** internal, exact *finite-model* results; external review and novelty **NOT established**. This is a post-hoc documented pilot, **not** a study preregistered before its computations. Preserve Phase 1 unchanged.

This phase extends the finite STROBO/MOD-OBS setting from immutable supports to a finite adversarial game with (i) bounded mutations of the hidden state, (ii) bounded false membership answers, and (iii) a monotone version equality oracle enabling an atomic compare-and-act. It contrasts reconstruction against certification of a target property. It separately audits the n=22 connectivity obstruction after observing A^2 and Tr(A^3).

## Files and replay

- `FORMAL_MODEL.md`: complete semantics, objective, dynamic programming recurrence.
- `AUDIT_REPORT.md`: quantitative findings, attack transcripts, limitations, bibliography, audit gates.
- `NEXT_PROTOCOL.md`: prospective experiment ideas **not yet executed**.
- `dynamic_pilot.py`: exact integer-mask decision-tree search and exported DAG policies.
- `independent_verify.py`: distinct frozenset-of-worlds minimax solver and independent DAG checker.
- `test_dynamic.py`: regression tests and physical trajectory replay.
- `RESULTS_PHASE2.json`: 27 exact instances, original witnesses, cost model.
- `POLICY_CERTIFICATES.json`: 3 complete policy DAGs for (e,m)=(1,1).
- `INDEPENDENT_AUDIT.json`: independent solver verdicts on all 27 instances and DAG checks.
- `verify.sh`: regenerate outputs, compare byte-for-byte, run tests, check SHA-256.
- `SHA256SUMS.txt`: integrity of all relevant files other than itself.

Run from this folder:

```sh
sh verify.sh
```

Python 3 standard library, plus POSIX shell/coreutils (`sha256sum`, `cmp`, `mktemp`). The script does not use the network and does not modify any repository branch.

## Conditionally exact central pilot

With e=1 globally erroneous answer, m=1 total mutation, unit cost per question and per version validation, plus one initial version read:

- n=18 quadruple fiber, reconstruct support: **12** actions at worst.
- n=18 quadruple fiber, certify property `1 in S`: **8** actions at worst.
- n=22 paired fiber, certify strong connectivity: **8** actions at worst.

The minimax certificate measures an abstract, explicitly specified game, NOT a real AI or concurrent process. Initial acquisition/validation of A^2, transaction implementation and real costs are excluded.

## Publication and synchronization

Parent research draft PR: https://github.com/alexcour/couret-finite-verifications/pull/21

Parent Drive archive: https://drive.google.com/drive/folders/1YwNTUgB4XQ-XjarmSddeAlTALQ6YO8Hc

**Gate:** DRAFT / E internal proof proposals / Q finite program checked / N originality unresolved / R external audit pending. Do not merge as a mature theorem or claim priority from this pilot.