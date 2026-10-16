# RECOH — Closing the information-set hypothesis (private draft)

Date: 2026-10-16. PR #36 baseline a5e25425eb24a7e6d014e51e8bae7defb0049760.

## Verified prior Lean result
At 7af53b254abb, RECOH Lean workflow 38933168857 succeeded, and #print axioms of recoh_binary_information_set_additive listed propext, Classical.choice, Quot.sound (no sorryAx). Later HEAD a5e25425 has verify success 38933650976, but a new Lean certificate at that SHA has not been identified.

## Exact bridge to prove next
The existing theorem recoh_short_bank_collision_dichotomy requires
  hinfo : Injective (fun a : H => fun i => binary i a)
       -> exists pivot : Fin r -> Fin k, Injective pivot /\
          Surjective (fun a : H => fun j => binary (pivot j) a).

The current RecohBinaryLinearTransport.lean additionally defines
  recoh_binary_information_set_of_card
under explicit assumptions:
  (h2 : forall a : H, a + a = 0)
  (hcardH : Fintype.card H = 2 ^ r).
Its conclusion is precisely hinfo's consequent for each hinj.
Thus the intended Lean application is:
  hinfo := fun hinj =>
    recoh_binary_information_set_of_card r k h2 hcardH binary hinj.

The composition should reuse recoh_short_bank_collision_dichotomy with all
other hypotheses unchanged. It yields a disjunction of actual collisions,
not yet an unconditional statement B(G)=r+s.

## Important proof boundaries
- Verify the precise Lean certificate for recoh_binary_information_set_of_card before relying on it in a published theorem.
- h2 applies to the binary torsion subgroup H, not to the full 2-primary part of U(30)=C2 x C4.
- The translation branch assumes an initial 3-element support; the reflection branch constructs a special one.
- To infer the global lower bound, check the exact definition of admissible support families and all edge cases (r=0, s=0, nonexistence of three-point supports).
- Upper bound still needs a separately verified separating bank and a proof of its cardinality.
- Historical F-006 to F-009 remain falsified. Do not merge or publish.

## Counter-tests
1. H=(ZMod 2)^2, two independent probes: information-set branch.
2. H=(ZMod 2)^2, two duplicate probes: binary kernel branch.
3. H=(ZMod 2)^2, three probes with one redundant: select two pivots.
4. H=ZMod 4: h2 fails; theorem must not be instantiated.
5. r=0 and s=0: inspect vacuity and existence of triple supports.

Status: dependency map and next proof specification, NOT a new Lean certificate.
