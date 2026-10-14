# STROBO-2TORS / M002.1 — Finset product cardinal proof receipt

**Record date:** 14 October 2026 (Paris). **Classification:** internal technical verification; not independent mathematical review. **Disposition:** RESOLVED on exact science SHA `045afdc1b2175b1f415807cd191cb46b5e86a153`; no merge of PR #25.

## Provenance and failure

- PR: https://github.com/alexcour/couret-finite-verifications/pull/25 (OPEN / DRAFT).
- Failing SHA: `d90921ece273ef9707e805ea76101859942da280`; failed Lean workflow https://github.com/alexcour/couret-finite-verifications/actions/runs/38601469897 (job 115981517665, `Strobo2TorsZeroFreeAll.lean:488:8`). Same SHA's independent general `verify` passing did not certify Lean.
- Original failing goal: `((Finset.powersetCard j twoTorsion).product (Finset.powersetCard (3-j) (Finset.univ \\ twoTorsion))).card = twoTorsion.card.choose j * (Fintype.card G - twoTorsion.card).choose (3-j)`.
- `Finset.card_product` rewrites a `×ˢ` product; the file used explicit `.product`. The normalization step was absent.

## Exact committed fix

- Science-source SHA: `045afdc1b2175b1f415807cd191cb46b5e86a153` ([commit](https://github.com/alexcour/couret-finite-verifications/commit/045afdc1b2175b1f415807cd191cb46b5e86a153)); commit title `fix(lean): rewrite Cartesian Finset product before cardinality lemma`.
- File: `research/strobo-2tors-2026-10-12/lean/Strobo2TorsZeroFreeAll.lean`, theorem `tripleSupportsProfile_card`, subproof `hcount`.
- Pre-fix: `rw [Finset.card_product]`.
- Post-fix: `rw [Finset.product_eq_sprod, Finset.card_product]`, followed by `Finset.card_powersetCard`, `Finset.card_sdiff_of_subset`, `simp`.
- The surrounding proof uses `profilePairs_image_eq` (surjectivity by splitting `S∩H` and `S\\H`) and `profilePairs_union_injective` (recovery of both components) to convert counts. Existing proof obligations for those lemmata remained in the same module.

## Reproducible CI evidence (exact science SHA)

- Lean 4/mathlib pinned to `v4.29.1` in project; workflow `strobo-2tors-lean` https://github.com/alexcour/couret-finite-verifications/actions/runs/38605249711 — **SUCCESS**, job `core-and-exact` id `115994341805`.
- GitHub Actions log: `2026-10-14T17:18:50.3094408Z [784/787] Built Strobo2TorsZeroFreeAll (3.8s)`.
- GitHub Actions log: `2026-10-14T17:18:50.3117518Z info: Strobo2TorsZeroFreeAll.lean:523:0: 'Couret.STROBO2TORS.tripleSupportsProfile_card' depends on axioms: [propext, Classical.choice, Quot.sound]`.
- The entire proof-module placeholder scan and `lake build` finished SUCCESS; seven `Strobo2Tors{Core,Cardinality,Enumeration,ZeroFree,ZeroFreeAll,SurvivalCounts,OrdinaryProfiles}.lean` sources are included.
- General `verify` https://github.com/alexcour/couret-finite-verifications/actions/runs/38605249705 — **SUCCESS** (public verifiers and release guard). This is a separate check, not a substitute for Lean.
- Warnings about unused Lean variables/tactics exist; they are not compiler errors. The workflow and `#print axioms` did not expose `sorryAx` for this theorem.

## Exact mathematical scope and remaining work

For finite abelian `G`, `H = G[2]`, `h=|H|`, `n=|G|`, and `0≤j≤3`, `tripleSupportsProfile_card` now kernel-compiles:

`|{S⊆G : |S|=3 ∧ |S∩H|=j}| = Nat.choose h j * Nat.choose (n-h) (3-j)`.

This is **not** a theorem that orbit counts `T_j`, exceptional orbit counts `E_j`, or ordinary counts `O_j` have been closed. The binomial result alone is not the complete zero-free histogram. Small `h=1,2` cases and coincident ordinary/exceptional restricted sizes must be handled without overclaiming. Earlier verified six-module receipt: `310fcaf3c65c36eaed85149d4748bf9a6454ab47`, Lean https://github.com/alexcour/couret-finite-verifications/actions/runs/38582324811 . Keep PR #25 DRAFT / NOT MERGED. No stable release, DOI, priority claim or publication follows from this receipt.
