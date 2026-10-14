# CAYLEY-DOUBLET — Order-three rigidity bridge (2026-10-14)

Status: new Lean candidate committed at `b802f051b6b94051a3b6ff1d0356e7be13b3d61f`, compilation **not yet verified** at time of writing. Previous commit `69bf6fee986009de43757f4458e39074011391ca` passed the triple-square replay, general verify, and Cayley Lean workflow.

## Exact scope

In an additive commutative group, if `h+h=0`, `d!=0`, `d!=h`, and `3d=0` or `3d=h`, then `2d!=0` and `2d!=h`. The file `lean/CayleyDoubletCore.lean` adds the candidate `no_cross_collision_of_order_three` and its direct corollary. This excludes the order-four degeneracy in the cross differences of `{a,b,b+h}`. The candidate still needs CI compilation, and this is **not** yet the Lean theorem `DifferenceRigid (TripleSupport a b h) h`.

## Remaining obligations

1. Derive the complete six-difference multiplicity/rigidity theorem for the exceptional triple support, including that other nonzero differences have multiplicity at most one.
2. Instantiate the unique mate and the two colours on the actual cyclic quotient `ZMod (6*r)` for every `r>=1`.
3. Combine with the previously kernel-checked relative-offset transport to obtain a graph nonisomorphism theorem about the explicit two Cayley families.
4. Independently review the mathematics and Brown/Mönius antecedents; do not claim novelty or merge PR #30.

## Source and reproducibility

- Draft PR: https://github.com/alexcour/couret-finite-verifications/pull/30
- Existing PR #25: https://github.com/alexcour/couret-finite-verifications/pull/25
- Workflow: `cayley-doublet-lean`.
- No private correspondence or embargoed FCI content is included.
