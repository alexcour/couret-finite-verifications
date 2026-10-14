# Cayley two-colour bridge — audit addendum (2026-10-14)

**Status: CANDIDATE, NOT CERTIFIED for this new Lean file.** Based on previously verified SHA `b7afc59a1f561d9b1a1d197ccae13da0ffb3200a`; the workflow `cayley-doublet-lean` passed at that SHA. New commits must be judged separately.

## Verified on base SHA
- `halfTurn_unique_of_order_three`: intrinsic mate uniqueness under explicit group/order-three hypotheses.
- `bothColours_quotient_formulas`: shared and unshared successors map to `+b` and `+a` under any additive quotient killing the half-turn.
- `relativeOffset_iff` and `noTwoColourConjugacy`: abstract two-colour conjugacy obstruction.
- Exact Python finite replay is a test, not universal proof.

## Newly added candidate
`lean/CayleyTwoColourFamily.lean` provides a shorter direct route:
`singleton_step_preserved` derives `f(x+a)=f(x)+a` from intrinsic uniqueness on the target, then `noIso_of_two_colours` propagates this equality through natural iterates `b=k • a` and contradicts the shared-doublet colour if `b ≠ c` and `b ≠ c+h`. This avoids falsely assuming a priori that an unknown graph isomorphism respects a coordinate quotient. The algebraic criterion is *conditional*: do not call it the entire ZMod family theorem.

## Remaining arithmetic instantiation (not yet Lean-complete)
For `r>0`, set `G=ZMod(12*r)`, `h=6*r`, `a=1`, `b=1+2*r`, `c=1+4*r`, `k=1+2*r`. Prove in Lean: `h+h=0`, `h ≠ 0`, `a ≠ b,b+h,c,c+h`, `b ≠ c,c+h`; and `3(a-c)=0` or `h`. Then instantiate `noIso_of_two_colours` to obtain the desired universal graph nonisomorphism for every positive `r`. In the quotient modulo `6*r`, `Q=+1`, `P_S=+(1+2*r)`, `P_T=+(1+4*r)`.

## Risk checks
- The uniqueness criterion would fail without the order-three condition: `n=8, S={0,2,6}` has three mates of 0.
- No conversion from **directed** to **undirected** spectra is justified for all r.
- `r` divisible by 3 is essential in tests; matching cycle counts cannot distinguish the two marked maps, whereas the relative displacement can.
- The missing cyclic instantiation is not certified by a success of the abstract lemma workflow.
- Prior work of Mönius and Brown; no academic priority, outside audit, stable release, or merge.

## Reproduction
```bash
cd research/correspondants_20261013/lean
lake resolve-deps
lake exe cache get
lake env lean -o CayleyDoubletCore.olean CayleyDoubletCore.lean
lake env lean CayleyTwoColourFamily.lean
```
Run `python3 research/correspondants_20261013/verify_two_colour_quotient.py` for finite checks. The dedicated workflow `cayley-two-colour-family-lean` is responsible for certifying the NEW Lean candidate. CI failure, skip or no run is NOT success.

**Release gate: DRAFT / NO-GO.** No private correspondence or embargoed material.
