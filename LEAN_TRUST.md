# Lean verification and trust boundary

Inventory updated on 8 November 2026 for the proposed three-proof kernel migration. Historical baseline: 20 October 2026, main commit `0d859677bd842a402d480984ad6549120825222e`. This file describes the source snapshot containing it; promotion still requires the matching build and axiom receipt.

The finite G30 certificate retains eleven proofs using `native_decide`. Three existing theorem proofs (`triplet_count`, `spectral_rep_count`, `tc_iso_target2`) use `decide +kernel` and, under Lean 4.29.1, depend only on `propext`. The eleven `native_decide` proofs evaluate compiled code and extend the trusted code base to the Lean compiler and relevant runtime implementations. It is a finite computational certificate with that explicit trust dependency. It must not be presented as verification by kernel reduction alone. The exact axiom names depend on the Lean version and are printed by the CI receipt.

`decide` and `decide +kernel` use reduction rather than native evaluation. Absence of literal `axiom` declarations or `sorry` in a source does not establish the absence of transitive axioms. Read `#print axioms` for each theorem. Native-evaluation axioms must be disclosed; `sorryAx` is a failure.

## Source inventory in this snapshot

Counts below are source-token observations for these exact files. They are not counts of independently reviewed results or a substitute for compilation.

| File | native_decide | decide +kernel | theorem declarations | Role |
| --- | ---: | ---: | ---: | --- |
| `research/g30-gate-b-lean/G30ComplexSpectrum.lean` | 11 | 3 | 15 | Canonical finite certificate |
| `research/g30-gate-b-lean/G30ComplexSpectrum.drive.lean` | 14 | 0 | 15 | Historical Drive copy; not a second independent proof |
| `research/g30-gate-b-lean/lakefile.lean` | 0 | 0 | 0 | Lake package configuration |

The canonical file contains eleven native-computation proofs and three kernel-reduction proofs of existing statements. The historical Drive variant retains fourteen native-computation proofs and is not changed by this migration. Counting both files gives twenty-five native tactic occurrences and three kernel tactic occurrences, not twenty-eight independent mathematical results. `RHClaimed_false_G30ComplexSpectrum : True` is a scope marker; its type does not prove any statement about RH.

## Reproducible receipt

The `g30-gate-b-lean` workflow compiles the canonical source, prints the axioms of all fifteen theorem declarations, rejects `sorryAx`, checks the exact three-kernel/eleven-native axiom inventory with `verify_g30_axioms.py`, and archives sources, resolved Lake dependencies, tool versions, build output and source/checkout commits. The migration changes proof methods only; the full certificate still has a native-evaluation trust dependency. The current SHA256 manifest binds the canonical file, historical Drive variant, classification verifier and axiom checker. A previous manifest must not be used after the proof change. The archived artifact has a ninety-day retention period; a later durable witness must preserve the bytes and digest before expiry. The existence of this workflow is not a successful-run claim: inspect its exact run and artifact.

This receipt concerns G30 only. It does not recover the historical private v38.5 Lean sources, certify the STROBO or COU-20 draft branches, establish novelty, or replace mathematical review.

## Primary Lean documentation

- [Lean reference on axiom dependencies and native evaluation](https://lean-lang.org/doc/reference/latest/Axioms).
- [Lean tactic documentation for decide and native_decide](https://lean-lang.org/doc/api/Init/Tactics.html).

The emitted axiom list for the pinned toolchain governs the certificate; current manual examples are explanatory.
