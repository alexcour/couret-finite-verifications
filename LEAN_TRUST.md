# Lean verification and trust boundary

Status recorded on 20 October 2026 from main commit `0d859677bd842a402d480984ad6549120825222e`.

The finite G30 certificate uses `native_decide`. This evaluates compiled code and extends the trusted code base to the Lean compiler and relevant runtime implementations. It is a finite computational certificate with that explicit trust dependency. It must not be presented as verification by kernel reduction alone. The exact axiom names depend on the Lean version and are printed by the CI receipt.

`decide` and `decide +kernel` use reduction rather than native evaluation. Absence of literal `axiom` declarations or `sorry` in a source does not establish the absence of transitive axioms. Read `#print axioms` for each theorem. Native-evaluation axioms must be disclosed; `sorryAx` is a failure.

## Source inventory on main

Counts below are source-token observations for these exact files. They are not counts of independently reviewed results or a substitute for compilation.

| File | native_decide | plain decide | theorem declarations | Role |
| --- | ---: | ---: | ---: | --- |
| `research/g30-gate-b-lean/G30ComplexSpectrum.lean` | 14 | 0 | 15 | Canonical finite certificate |
| `research/g30-gate-b-lean/G30ComplexSpectrum.drive.lean` | 14 | 0 | 15 | Historical Drive copy; not a second independent proof |
| `research/g30-gate-b-lean/lakefile.lean` | 0 | 0 | 0 | Lake package configuration |

The two mathematical files contain the same fourteen native-computation theorem proofs in two source variants. Counting both files gives twenty-eight tactic occurrences, not twenty-eight independent mathematical results. `RHClaimed_false_G30ComplexSpectrum : True` is a scope marker; its type does not prove any statement about RH.

## Reproducible receipt

The `g30-gate-b-lean` workflow compiles the unchanged canonical source, prints the axioms of all fifteen theorem declarations, rejects `sorryAx`, and archives sources, resolved Lake dependencies, tool versions, build output and source/checkout commits. The archived artifact has a ninety-day retention period; a later durable witness must preserve the bytes and digest before expiry. The existence of this workflow is not a successful-run claim: inspect its exact run and artifact.

This receipt concerns G30 only. It does not recover the historical private v38.5 Lean sources, certify the STROBO or COU-20 draft branches, establish novelty, or replace mathematical review.

## Primary Lean documentation

- [Lean reference on axiom dependencies and native evaluation](https://lean-lang.org/doc/reference/latest/Axioms).
- [Lean tactic documentation for decide and native_decide](https://lean-lang.org/doc/api/Init/Tactics.html).

The emitted axiom list for the pinned toolchain governs the certificate; current manual examples are explanatory.
