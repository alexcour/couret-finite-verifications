# RECOH — Binary character linearization: exact remaining bridge (private, draft)

**Historical plan, superseded for obligations (A) and (B).** The structural
bridge and its verified scope are recorded in
[RECOH_BINARY_STRUCTURAL_BRIDGE_20261016.md](RECOH_BINARY_STRUCTURAL_BRIDGE_20261016.md).
The original plan below is retained as history.

Date: 2026-10-16. PR #36, certified baseline f877dad13346a98b9fc49f5094514f3868cf4018.
Lean run 38898014066 SUCCESS; verify 38898014246 SUCCESS.
No merge, release, or public dissemination is authorized.

## Proven baseline (scope restricted)
- RecohInformationSet.lean: injective linear probes on (ZMod 2)^r admit r distinct coordinate probes yielding a surjective evaluation. The relevant #print axioms log lists only propext, Classical.choice, Quot.sound.
- RecohBinaryDichotomy.lean: kernel-or-injective dichotomy and conditional collision interface. Its hinfo premise has NOT been eliminated for arbitrary additive characters by the certified information-set theorem alone.
- Historical falsifications F-006 through F-009, including U(30) ≅ C2 × C4, remain unchanged.

## Next theorem: explicit hypotheses, not yet Lean-certified
Let H be an elementary abelian 2-group and e : H ≃+ (Fin r → ZMod 2) an additive equivalence.
For any k additive characters binary : Fin k → (H →+ ZMod 2), define
  bank i : Module.Dual (ZMod 2) (Fin r → ZMod 2)
by transport through e.symm.
Because the domain is a vector space over F2, additive maps to F2 are F2-linear.
Then the following implication should hold:
  Injective (fun h : H => fun i => binary i h)
  → ∃ pivot : Fin r → Fin k, Injective pivot ∧
      Surjective (fun h : H => fun j => binary (pivot j) h).
Proof sketch: transport injectivity along e; apply
recoh_binary_information_set_linear; transport surjectivity back.
Do NOT silently assume an additive equivalence for an arbitrary 2-group:
C2 × C4 is a counter-test to the exponent-two premise.

## Reproducible tests
1. H = (ZMod 2)^2, k=2, characters (x0,x1): full evaluation injective;
   pivot is a permutation, surjective.
2. H = (ZMod 2)^2, k=2, characters (x0,x0): kernel includes (0,1);
   no claim of injective-bank pivot.
3. H = (ZMod 2)^2, k=3, characters (x0,x1,x0+x1): full evaluation
   injective; a two-coordinate information set exists.
4. H = ZMod 4 (or C2 × C4), binary additive characters cannot separate
   all elements: element 2 in C4 maps to 0 under every binary character.
   This demonstrates why a general U(30) bridge must use H[2], not
   the full 2-primary group.
5. r=0, k=0: trivial singleton domain, empty pivot, surjective.
6. r=2, k=1: injectivity impossible by cardinality.

## Open proof obligations
(A) implement transport additive-map -> linear-map with no sorryAx;
(B) connect to hinfo in recoh_short_bank_collision_dichotomy;
(C) establish the independent upper bound/construction for B(G)=r+s;
(D) independently review novelty and statement scope.
Only (A)+(B) can close the lower-bound interface, not (C).

Status: research plan; no new Lean theorem claimed in this document.
