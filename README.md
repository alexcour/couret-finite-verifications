# Three-point convolution-square fibre cardinalities

For a finite abelian group, let h be the size of the kernel of doubling. The fibre of the full labelled ordered additive convolution square of a three-element support has h or 2h elements, hence at most 2h. Diagonal pairs are retained.

This candidate adapts [the prior Cardinality source](https://github.com/alexcour/couret-finite-verifications/blob/60f6d03fdb26a2498e9e856b49f93ad590b99409/research/strobo-2tors-2026-10-12/lean/Strobo2TorsCardinality.lean) and the already migrated Core at commit 24f69d5c2635ff405a628c170086a62d477fd3a5. Challenge.lean independently defines the observable, doubling kernel and fibre. Solution.lean proves the two advertised statements using the complete implementation in CouretProof.lean and CouretCardinality.lean.

## Status

Current-toolchain build: PENDING. Comparator: NOT_RUN for this candidate. Palomar intake: NOT_STARTED. No novelty or independent human review claimed.

Lean and Mathlib are pinned by lean-toolchain, lakefile.toml and lake-manifest.json. Run lake exe cache get, lake build, then lake env lean Solution.lean. Only propext, Quot.sound and Classical.choice are permitted. The Challenge has two intentional theorem holes; the Solution has none.

The branch is a preparation area, not an accepted Palomar entry or a validation of the full Couret corpus. MIT licence applies to this repository snapshot; upstream dependencies retain their own licences.
