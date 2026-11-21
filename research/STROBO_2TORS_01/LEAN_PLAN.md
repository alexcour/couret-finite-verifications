# Lean 4 integration gate — not executed

As of this task, no `lean` or `lake` binary was found in the working environment. **No .lean file has been compiled.** The next action is to integrate into the existing Couret Lean 4 architecture only after a version-pinned mathlib environment is available and the files are reconciled with the upstream root module definitions.

Suggested theorem dependency order:

1. `orderedRep_count`: coefficient of `f_S^2` counts ordered pairs with diagonal.
2. `frobenius_mod_two`, `same_parity_on_double_fibres`.
3. `three_occupancy_profiles`, `typeII_typeIII_disjoint_square`.
4. `profileI_H_translate`, `profileIII_H_translate`.
5. `profileII_rectangle`, `rectangle_has_two_H_cosets`, `rectangle_u_intrinsic`.
6. `profileII_direct`, `profileII_cross_iff_three_delta`.
7. `square_fibre_eq_orbit_or_two_orbits`, `cross_pairs_are_reflections`.
8. `count_order_three_subgroups`, `count_exceptional_fibres`, `excluded_zero_loss`.
9. `count_nontranslated_unordered_nozero`, `total_translated_unordered`.

The formal specification must use a finite abelian group `G`, support as a finset with card=3, coefficients in `Z`, convolution over ordered pairs, and equality of labelled operators. Distinct support elements and diagonal contributions are mandatory. Avoid introducing assumptions that silently require cyclicity or unique involution. Type-II/III separation must be explicit.

Acceptance: clean `lake build` with pinned versions, all necessary theorems zero-sorry, no `admit` or unproven new axiom; review that the formalized statement matches the manuscript. None of these checks is claimed to have occurred.