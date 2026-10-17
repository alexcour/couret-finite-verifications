import RecohCoefficientDecoder
import RecohTypedObservation
import RecohCyclicPrimaryBank

set_option autoImplicit false

/-!
An instantiated RECOH decoder on typed observations of cyclic products.

The user supplies only the moduli, labelled square entries, and the observed
coefficient lists.  The primary parameters, exponent encoders, binary
coordinates, doubling solver, square-value function and its covering set
are constructed here.  Their correctness contracts are all discharged.

There is one binary slot for every even factor. Ternary slots occur only
when some factor is even, exactly as for the fixed bank in the Python
decoder. The input guard also imposes moduli at least two, group order at
least three, and the typed numeric/uniqueness checks of its observation
readers. JSON syntax, machine execution and serialization remain separate.
-/

namespace Couret.STROBO2TORS

open scoped BigOperators

variable {d : ℕ} (q : Fin d → ℕ) [∀ i, NeZero (q i)]

/-- Ternary measurements are used only in the presence of binary torsion. -/
abbrev RecohActiveTernaryCoordinate :=
  {i : Fin d // 3 ∣ q i ∧ ∃ j : Fin d, 2 ∣ q j}

/-- The labelled fixed bank of the external product presentation. -/
abbrev RecohCyclicBankIndex := RecohEvenCoordinate q ⊕ RecohActiveTernaryCoordinate q

/-- The prime attached to each bank slot. -/
def recohCyclicBankPrime : RecohCyclicBankIndex q → ℕ :=
  Sum.elim (fun _ => 2) (fun _ => 3)

/-- Primary exponents computed from the moduli, not supplied as contracts. -/
def recohCyclicBankDepth : RecohCyclicBankIndex q → ℕ :=
  Sum.elim
    (fun i => (recohCanonicalPrimaryData q 2).exponent i)
    (fun i => (recohCanonicalPrimaryData q 3).exponent ⟨i.val, i.property.1⟩)

/-- Actual coordinate exponents for every candidate, with multiplicities. -/
def recohCyclicBankEncoding : RecohCyclicBankIndex q →
    Finset ((i : Fin d) → ZMod (q i)) → List ℕ :=
  Sum.elim (fun i => recohCyclicExponents q i.val)
    (fun i => recohCyclicExponents q i.val)

/-- The semantic roots are determined by the primary orders. -/
noncomputable def recohCyclicBankRoot : RecohCyclicBankIndex q → ℂ :=
  Sum.elim
    (fun i => recohCyclicRoot (2 ^ ((recohCanonicalPrimaryData q 2).exponent i + 1)))
    (fun i => recohCyclicRoot
      (3 ^ ((recohCanonicalPrimaryData q 3).exponent ⟨i.val, i.property.1⟩ + 1)))

/-- The fully determined complex bank appears only in the specification. -/
noncomputable def recohCyclicObservedBank : RecohCyclicBankIndex q →
    AddChar ((i : Fin d) → ZMod (q i)) ℂ :=
  Sum.elim
    (recohCyclicPrimaryBank q 2 (recohCanonicalPrimaryData q 2))
    (fun i => recohCyclicPrimaryBank q 3 (recohCanonicalPrimaryData q 3)
      ⟨i.val, i.property.1⟩)

omit [∀ i, NeZero (q i)] in
theorem recoh_cyclic_bank_prime (i : RecohCyclicBankIndex q) :
    (recohCyclicBankPrime q i).Prime := by
  cases i with
  | inl _ => exact Nat.prime_two
  | inr _ => exact Nat.prime_three

theorem recoh_cyclic_bank_root_primitive (i : RecohCyclicBankIndex q) :
    IsPrimitiveRoot (recohCyclicBankRoot q i)
      ((recohCyclicBankPrime q i) ^ (recohCyclicBankDepth q i + 1)) := by
  cases i with
  | inl j => exact recoh_cyclic_root_primitive _
  | inr j => exact recoh_cyclic_root_primitive _

theorem recoh_cyclic_bank_encoding_interpret (i : RecohCyclicBankIndex q)
    (S : Finset ((i : Fin d) → ZMod (q i))) :
    ((recohCyclicBankEncoding q i S).map (recohCyclicBankRoot q i ^ ·)).sum =
      recohSupportProbe (recohCyclicObservedBank q i) S := by
  cases i with
  | inl j => exact recoh_cyclic_primary_bank_interpret q 2 (recohCanonicalPrimaryData q 2) j S
  | inr j =>
    exact recoh_cyclic_primary_bank_interpret q 3 (recohCanonicalPrimaryData q 3)
      ⟨j.val, j.property.1⟩ S

omit [∀ i, NeZero (q i)] in
theorem recoh_cyclic_bank_encoding_length (i : RecohCyclicBankIndex q)
    (S : Finset ((i : Fin d) → ZMod (q i))) :
    (recohCyclicBankEncoding q i S).length = S.card := by
  cases i with
  | inl j => exact recoh_cyclic_exponents_length q j.val S
  | inr j => exact recoh_cyclic_exponents_length q j.val S

/-- The conditional bank reconstructs triples also in the odd-order case,
where it has no slots and the square alone is injective. -/
theorem recoh_cyclic_observed_bank_injective :
    Function.Injective (fun S :
      {S : Finset ((i : Fin d) → ZMod (q i)) // S.card = 3} =>
      recohObservation (recohCyclicObservedBank q) S.1) := by
  intro S T hobs
  by_cases heven : ∃ j : Fin d, 2 ∣ q j
  · apply recoh_cyclic_primary_observation_injective q
      (recohCanonicalPrimaryData q 2) (recohCanonicalPrimaryData q 3)
    apply Prod.ext
    · change orderedSquare S.1 = orderedSquare T.1
      exact congrArg Prod.fst hobs
    · funext i
      cases i with
      | inl j => exact congrFun (congrArg Prod.snd hobs) (Sum.inl j)
      | inr j =>
        exact congrFun (congrArg Prod.snd hobs)
          (Sum.inr ⟨j.val, j.property, heven⟩)
  · apply recoh_square_injective_of_trivial_two_torsion
    · intro u hu
      funext i
      have hcop : Nat.Coprime 2 (q i) :=
        Nat.prime_two.coprime_iff_not_dvd.mpr (fun hi => heven ⟨i, hi⟩)
      apply recoh_cyclic_torsion_zero_of_coprime 2 (q i) hcop (u i)
      simpa only [two_nsmul, Pi.add_apply, Pi.zero_apply] using congrFun hu i
    · exact congrArg Prod.fst hobs

/-- The algorithm before the typed input guard. All auxiliary data are
computed from the moduli and from the observed square itself. -/
def recohCyclicCoefficientCore
    (entries : List (((i : Fin d) → ZMod (q i)) × ℕ))
    (terms : RecohCyclicBankIndex q → RecohSparseTerms) :
    Finset (Finset ((i : Fin d) → ZMod (q i))) :=
  recohCoefficientBackendDecoder
    (recohTypedSquareSupport entries) (recohTypedSquareValue entries)
    (recohProductHalf q) Sum.inl (recohProductTwoCoordinates q)
    (recohCyclicBankPrime q) (recohCyclicBankDepth q) (recohCyclicBankEncoding q) terms

/-- The semantic observation represented by the typed input. -/
noncomputable def recohCyclicTypedObservation
    (entries : List (((i : Fin d) → ZMod (q i)) × ℕ))
    (terms : RecohCyclicBankIndex q → RecohSparseTerms) :=
  (recohTypedSquareValue entries,
    fun i => recohCoefficientValue (recohCyclicBankRoot q i) (terms i))

/-- No supplied coordinate, half-solver, encoding, primitive-root or
coverage contract remains in this refinement theorem. -/
theorem recoh_cyclic_coefficient_core_eq_exact
    (entries : List (((i : Fin d) → ZMod (q i)) × ℕ))
    (terms : RecohCyclicBankIndex q → RecohSparseTerms)
    (hred : ∀ i, RecohCoefficientsReduced
      (recohCyclicBankPrime q i) (recohCyclicBankDepth q i) (terms i)) :
    recohCyclicCoefficientCore q entries terms =
      recohExactDecoder (recohCyclicObservedBank q) (recohCyclicTypedObservation q entries terms) := by
  apply recoh_coefficient_backend_decoder_eq_exact
    (recohTypedSquareSupport entries) (recohTypedSquareValue entries)
    (recohProductHalf q) Sum.inl (recohProductTwoCoordinates q)
    (recohCyclicBankPrime q) (recohCyclicBankDepth q) (recohCyclicBankEncoding q) terms
    (recohCyclicObservedBank q) (recohCyclicBankRoot q)
    (fun i => recohCoefficientValue (recohCyclicBankRoot q i) (terms i))
  · exact recoh_product_half_spec q
  · exact recoh_typed_square_covered entries
  · exact recoh_cyclic_bank_prime q
  · exact recoh_cyclic_bank_root_primitive q
  · exact hred
  · exact recoh_cyclic_bank_encoding_interpret q
  · intro i; rfl
  · intro u i
    exact recoh_cyclic_binary_bank_sign_coordinates q (recohCanonicalPrimaryData q 2) u i
  · intro i S hS
    exact recoh_cyclic_binary_probe_nonzero q (recohCanonicalPrimaryData q 2) i S hS

/-- Numeric and shape checks after the JSON values have been given their
types. The order of entries and terms is not constrained. -/
def RecohCyclicInputFormat
    (entries : List (((i : Fin d) → ZMod (q i)) × ℕ))
    (terms : RecohCyclicBankIndex q → RecohSparseTerms) : Prop :=
  (∀ i, 2 ≤ q i) ∧ 3 ≤ ∏ i, q i ∧ RecohTypedSquareFormat entries ∧
    ∀ i, RecohCoefficientFormat (recohCyclicBankPrime q i) (recohCyclicBankDepth q i) (terms i)

def recohCyclicInputCheck
    (entries : List (((i : Fin d) → ZMod (q i)) × ℕ))
    (terms : RecohCyclicBankIndex q → RecohSparseTerms) : Bool :=
  decide (∀ i, 2 ≤ q i) && decide (3 ≤ ∏ i, q i) &&
    recohTypedSquareFormatCheck entries &&
    recohAllCoefficientFormats (recohCyclicBankPrime q) (recohCyclicBankDepth q) terms

theorem recoh_cyclic_input_check_iff
    (entries : List (((i : Fin d) → ZMod (q i)) × ℕ))
    (terms : RecohCyclicBankIndex q → RecohSparseTerms) :
    recohCyclicInputCheck q entries terms = true ↔ RecohCyclicInputFormat q entries terms := by
  simp [recohCyclicInputCheck, RecohCyclicInputFormat,
    recoh_typed_square_format_check_iff, recoh_all_coefficient_formats_iff, and_assoc]

/-- Complete typed decoder with the input checks of the external format. -/
def recohCyclicCoefficientDecoder
    (entries : List (((i : Fin d) → ZMod (q i)) × ℕ))
    (terms : RecohCyclicBankIndex q → RecohSparseTerms) :
    Finset (Finset ((i : Fin d) → ZMod (q i))) :=
  if recohCyclicInputCheck q entries terms then recohCyclicCoefficientCore q entries terms
  else ∅

theorem recoh_cyclic_coefficient_decoder_eq_exact
    (entries : List (((i : Fin d) → ZMod (q i)) × ℕ))
    (terms : RecohCyclicBankIndex q → RecohSparseTerms)
    (hformat : RecohCyclicInputFormat q entries terms) :
    recohCyclicCoefficientDecoder q entries terms =
      recohExactDecoder (recohCyclicObservedBank q) (recohCyclicTypedObservation q entries terms) := by
  rw [recohCyclicCoefficientDecoder,
    if_pos ((recoh_cyclic_input_check_iff q entries terms).mpr hformat)]
  exact recoh_cyclic_coefficient_core_eq_exact q entries terms (fun i => (hformat.2.2.2 i).1)

/-- Invalid typed input is rejected deterministically. -/
theorem recoh_cyclic_coefficient_decoder_rejects
    (entries : List (((i : Fin d) → ZMod (q i)) × ℕ))
    (terms : RecohCyclicBankIndex q → RecohSparseTerms)
    (hformat : ¬ RecohCyclicInputFormat q entries terms) :
    recohCyclicCoefficientDecoder q entries terms = ∅ := by
  simp only [recohCyclicCoefficientDecoder]
  rw [if_neg (fun h => hformat ((recoh_cyclic_input_check_iff q entries terms).mp h))]

/-- The input representation, all auxiliary constructions and the exact
output contract are linked in one theorem, with no semantic input witnesses. -/
theorem recoh_mem_cyclic_coefficient_decoder_iff
    (entries : List (((i : Fin d) → ZMod (q i)) × ℕ))
    (terms : RecohCyclicBankIndex q → RecohSparseTerms)
    (S : Finset ((i : Fin d) → ZMod (q i))) :
    S ∈ recohCyclicCoefficientDecoder q entries terms ↔
      RecohCyclicInputFormat q entries terms ∧ S.card = 3 ∧
        recohObservation (recohCyclicObservedBank q) S = recohCyclicTypedObservation q entries terms := by
  by_cases hformat : RecohCyclicInputFormat q entries terms
  · rw [recoh_cyclic_coefficient_decoder_eq_exact q entries terms hformat,
      recoh_mem_exact_decoder_iff]
    simp only [hformat, true_and]
  · rw [recoh_cyclic_coefficient_decoder_rejects q entries terms hformat]
    simp [hformat]

/-- An observation of an actual triple reconstructs that triple uniquely,
using the explicitly constructed bank and coordinate arithmetic. -/
theorem recoh_cyclic_coefficient_decoder_singleton
    (entries : List (((i : Fin d) → ZMod (q i)) × ℕ))
    (terms : RecohCyclicBankIndex q → RecohSparseTerms)
    (hformat : RecohCyclicInputFormat q entries terms)
    (S : Finset ((i : Fin d) → ZMod (q i))) (hS : S.card = 3)
    (hobs : recohObservation (recohCyclicObservedBank q) S =
      recohCyclicTypedObservation q entries terms) :
    recohCyclicCoefficientDecoder q entries terms = {S} := by
  rw [recoh_cyclic_coefficient_decoder_eq_exact q entries terms hformat, ← hobs]
  exact recoh_exact_decoder_singleton (recohCyclicObservedBank q)
    (recoh_cyclic_observed_bank_injective q) S hS

/-- Even arbitrary typed inputs return at most one support. -/
theorem recoh_cyclic_coefficient_decoder_card_le_one
    (entries : List (((i : Fin d) → ZMod (q i)) × ℕ))
    (terms : RecohCyclicBankIndex q → RecohSparseTerms) :
    (recohCyclicCoefficientDecoder q entries terms).card ≤ 1 := by
  apply Finset.card_le_one.mpr
  intro S hS T hT
  have hs := (recoh_mem_cyclic_coefficient_decoder_iff q entries terms S).mp hS
  have ht := (recoh_mem_cyclic_coefficient_decoder_iff q entries terms T).mp hT
  exact congrArg Subtype.val ((recoh_cyclic_observed_bank_injective q)
    (show recohObservation (recohCyclicObservedBank q)
      (⟨S, hs.2.1⟩ : {S : Finset ((i : Fin d) → ZMod (q i)) // S.card = 3}).1 =
      recohObservation (recohCyclicObservedBank q)
      (⟨T, ht.2.1⟩ : {S : Finset ((i : Fin d) → ZMod (q i)) // S.card = 3}).1 from
        hs.2.2.trans ht.2.2.symm))

/-- Before the final filter, valid input yields at most twenty recovered
candidates. This is a cardinality bound, not a bit-complexity theorem. -/
theorem recoh_cyclic_coefficient_candidates_le_twenty
    (entries : List (((i : Fin d) → ZMod (q i)) × ℕ))
    (terms : RecohCyclicBankIndex q → RecohSparseTerms)
    (hformat : RecohCyclicInputFormat q entries terms) :
    (recohFastCandidates (recohTypedSquareSupport entries) (recohProductHalf q)
      (recohIndexedRecoverSupport (recohProductTwoCoordinates q)
        (recohCoefficientSignBools Sum.inl (recohCyclicBankPrime q)
          (recohCyclicBankDepth q) (recohCyclicBankEncoding q) terms))).card ≤ 20 := by
  apply recoh_fast_candidates_card_le_twenty
  exact recoh_typed_square_support_card_le_six entries hformat.2.2.1

end Couret.STROBO2TORS

#print axioms Couret.STROBO2TORS.recoh_cyclic_bank_prime
#print axioms Couret.STROBO2TORS.recoh_cyclic_bank_root_primitive
#print axioms Couret.STROBO2TORS.recoh_cyclic_bank_encoding_interpret
#print axioms Couret.STROBO2TORS.recoh_cyclic_bank_encoding_length
#print axioms Couret.STROBO2TORS.recoh_cyclic_observed_bank_injective
#print axioms Couret.STROBO2TORS.recoh_cyclic_coefficient_core_eq_exact
#print axioms Couret.STROBO2TORS.recoh_cyclic_input_check_iff
#print axioms Couret.STROBO2TORS.recoh_cyclic_coefficient_decoder_eq_exact
#print axioms Couret.STROBO2TORS.recoh_cyclic_coefficient_decoder_rejects
#print axioms Couret.STROBO2TORS.recoh_mem_cyclic_coefficient_decoder_iff
#print axioms Couret.STROBO2TORS.recoh_cyclic_coefficient_decoder_singleton
#print axioms Couret.STROBO2TORS.recoh_cyclic_coefficient_decoder_card_le_one
#print axioms Couret.STROBO2TORS.recoh_cyclic_coefficient_candidates_le_twenty
