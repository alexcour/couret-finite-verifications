# RECOH — Structural binary bridge and collision composition

> Historical snapshot. The integrated result of 17 October 2026 is described in [RECOH_OPTIMAL_BANK_20261017.md](RECOH_OPTIMAL_BANK_20261017.md), with certification tied to its exact source commit. The dated statements and certificates below are preserved as research history.

Date: 16 October 2026. Research PR #36; retain draft status.

## Exact structural contract

Let `H` be a finite additive commutative group. The new structural interface requires

- `h2 : ∀ a : H, a + a = 0`;
- `hcardH : Fintype.card H = 2 ^ r`.

The exponent condition supplies a `Module (ZMod 2) H` using
`AddCommGroup.zmodModule`. The identity `Module.card_eq_pow_finrank`
and injectivity of powers of 2 prove `Module.finrank (ZMod 2) H = r`.
`Module.finBasisOfFinrankEq` then supplies a basis and its linear coordinate
equivalence `H ≃ₗ[ZMod 2] (Fin r → ZMod 2)`; forgetting scalars gives the
additive equivalence used by the existing transport interface. No choice of
coordinates is assumed as an extra mathematical hypothesis.

For each `binary i : H →+ ZMod 2`, composition with the inverse coordinate
equivalence yields an additive map on the standard coordinate space.
Mathlib's `AddMonoidHom.toZModLinearMap 2` supplies its linear structure,
with the same underlying evaluation function. Injectivity transports to
the standard coordinates, `recoh_binary_information_set_linear` extracts
`r` distinct indices, and surjectivity transports back to `H`.

## New interfaces

- `recoh_binary_coordinates_of_card`: constructs the coordinate equivalence
  from exponent and cardinality (including the singleton case `r=0`).
- `recoh_binary_information_set_of_card`: discharges the information-set
  conclusion for every injective additive binary bank, including redundant
  banks with `k>r`.
- `recoh_short_bank_collision_of_binary_card` in
  `lean/RecohBinaryStructuralDichotomy.lean`: invokes the existing conditional
  dichotomy with this proved information-set implication. There is no `hinfo`
  parameter in the new corollary.

The older `recoh_short_bank_collision_dichotomy` remains a valid general
conditional interface. Its signature is preserved for compatibility.
The new corollary replaces its information-set premise by the structural
cardinality hypothesis and uses its existing exponent-two hypothesis.

## Hypotheses deliberately retained

The collision corollary still requires `0 < r`, `k < r+s`, the ternary group
of cardinality `3^s` and exponent dividing 3, injective additive embeddings
of both torsion groups into `G`, a multiplicative normalized probe bank,
and additive binary and ternary encodings compatible with those probes.
It also requires a witnessed three-element support for the translation
branch. None of these obligations is discharged merely by linearization.
In particular, this bridge does not construct those encodings for every
complex character bank, establish the independent upper bound, or identify
the complete optimal-bank problem with this collision interface.

`ZMod 4` and `C2 × C4` fail the exponent-two condition despite having
power-of-two cardinality. This theorem can apply to their elementary
2-torsion subgroup when all stated hypotheses hold, not to the whole group.
No rank is inferred from cardinality alone without the exponent condition.

## Verification status

Certified proof commit: `7af53b254abb833d85f1085dc42f671dee0223f3`.
Lean compilation SUCCESS on that exact commit (3,297 build jobs):
https://github.com/alexcour/couret-finite-verifications/actions/runs/38933168857
General verification SUCCESS:
https://github.com/alexcour/couret-finite-verifications/actions/runs/38933169050

The job log prints `recoh_binary_information_set_additive`,
`recoh_binary_coordinates_of_card`, `recoh_binary_information_set_of_card`,
and `recoh_short_bank_collision_of_binary_card` with only `propext`,
`Classical.choice`, and `Quot.sound`. No `sorryAx` occurs in the job log.
The source guard against proof placeholders and custom axioms also passes.
These are machine-checked results under the stated assumptions, not an
independent mathematical review. A later documentation-only commit does
not change the Lean source or the scope of this certificate. `B(G)=r+s` remains open in Lean. No independent human
review or novelty certificate, merge, release, or publication is claimed.
