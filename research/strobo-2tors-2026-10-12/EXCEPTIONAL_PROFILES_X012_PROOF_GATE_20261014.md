# STROBO-2TORS — exceptional profile counts X0/X1/X2 (proof gate)

14 October 2026. **STATUS: MATHEMATICAL DERIVATION / LEAN PROOF NOT YET COMPILED.** PR #25 remains DRAFT / NOT MERGED. This file is a proposed route for formalization, not a certification receipt.

## Precise target

Let G be a finite abelian group, H = G[2] = {x : x+x=0}, n=|G|, h=|H| and t=|G[3]|. Let X_j denote the cardinal of **exceptional supports** S of cardinal three such that |S intersect H|=j, as defined by `exceptionalSupportsProfile` in `Strobo2TorsOrdinaryCount.lean`.

The candidate formulae are:
- X_1 = h*(h-1)*(t-1)
- X_2 = h*(h-1)*(t-1)
- X_0 = (n-2*h)*(h-1)*(t-1) (natural-number subtraction; this count must be proved using actual disjoint finsets, not by unsound cancellation).
- X_3=0 is already a compiled Lean declaration.

## Dependency reduction (already represented in current Lean source)

`exceptionalSupportsProfile_eq_params_image` and `exceptionalSupportsProfile_card_eq_params` identify X_j with the number of admissible unique parameters (a,d,v) satisfying d in H\{0}, v in G[3]\{0}, and j = |{a,a+v,a+v+d} intersect H|. These theorems are in `Strobo2TorsOrdinaryCount.lean` at the starting science SHA `b288281ded5fb7a050f3b095ecb00cf079c5b2ad`, with Lean CI [#38624643350](https://github.com/alexcour/couret-finite-verifications/actions/runs/38624643350) SUCCESS, verify [#38624643367](https://github.com/alexcour/couret-finite-verifications/actions/runs/38624643367) SUCCESS.

`paramSupport_inter_twoTorsion_card` in `Strobo2TorsZeroFree.lean` states the key dichotomy:
- j=1 iff a in H;
- j=2 iff a+v in H;
- j=0 otherwise.
The assertions use admissible d,v, and follow from the three element support with nonzero v of order three. The two cases are disjoint since v cannot be in H.

## Finite-set counting proof on paper

Fix d in H\{0} and v in G[3]\{0}. Translation by -v gives a bijection from H to {a in G : a+v in H}. Hence the first two classes of a have h members each. Since v is not in H, these two classes are disjoint. The complement of their union in G has exactly n-2h members. For each d,v the same counts hold, independently of d and v. There are h-1 choices of d and t-1 choices of v. The unique-parameter theorem ensures multiplication by (h-1)(t-1) counts actual supports, with no duplicate.

**Small-group safety:** if t=1 or h=1 the admissible parameter set is empty. If t>1, then v has order three, so H and H-v are disjoint and 2h<=n. Do not use cancellation or a purported inequality n>=2h absent an admissible nonzero v.

## Lean obligations to discharge, in order

1. For admissible v, prove `v ∉ twoTorsion` using `three_torsion_not_two`, and prove disjointness of the two finsets `twoTorsion` and `Finset.univ.filter (fun a => a+v ∈ twoTorsion)`. Or derive it from `exceptional_param_genuine`.
2. Prove `card {a : a+v ∈ H} = h` using an explicitly injective translation or the equality to `twoTorsion.image (fun x => x-v)`; inspect mathlib's `Finset.card_image_of_injective` signature before using it.
3. Prove counts of a in the profile-1 and profile-2 fibers, then the profile-0 complement via `Finset.card_sdiff_of_subset` / disjoint union cardinality and `Finset.card_univ`. Reuse the already compiled `paramSupport_inter_twoTorsion_card`; avoid `simp` guessing branch order.
4. Reexpress `exceptionalParamsProfile` as an iterated product/filter or use `Finset.card_eq_sum_card_image` to sum first over (d,v), with constant fiber cardinality. Establish three exact equations for X_j, with no sorry/admit/custom axiom.
5. Extend the existing Lean CI placeholder scan and build target only if a separate proof module is added. On an isolated branch require exact-SHA Lean PASS, verify PASS and explicit `#print axioms` without sorryAx for each final X_j theorem before promoting any scientific status.

## Boundary

The previously compiled `ordinaryProfile_card_balance` establishes P_j = h*O_j+X_j; closed X_j formulas are not yet compiled by this note. Completing X_j is still not equivalent to completing the full zero-free histogram: the latter must discard empty restrictions for h=1,2 and aggregate equal sizes from ordinary and exceptional families. No independent expert validation, originality claim, release or merge.
