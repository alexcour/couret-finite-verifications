import RecohCyclicCoefficientDecoder
import RecohEarlySignChecks

set_option autoImplicit false

/-!
The concrete cyclic decoder with early square and reading checks.

All bank parameters, coefficient encodings, binary coordinates, and square
support data are constructed by the cyclic interface.  This module uses
those data in the early-rejection control flow: check the representative's
square and binary/ternary readings, recover its translation, then retain the
independent full final check.  The guarded decoder is equal to the complete
typed coefficient decoder for every input, including rejected input.

The equality relates executable Lean definitions on typed data.  It does
not identify the external Python parser, caches, or runtime with those
definitions, nor does the candidate bound assert bit complexity.
-/

namespace Couret.STROBO2TORS

variable {d : ℕ} (q : Fin d → ℕ) [∀ i, NeZero (q i)]

/-- The canonical cyclic core with square and reading checks before recovery. -/
def recohCyclicPreparedCore
    (entries : List (((i : Fin d) → ZMod (q i)) × ℕ))
    (terms : RecohCyclicBankIndex q → RecohSparseTerms) :
    Finset (Finset ((i : Fin d) → ZMod (q i))) :=
  recohEarlyCoefficientBackendDecoder
    (recohTypedSquareSupport entries) (recohTypedSquareValue entries)
    (recohProductHalf q) (recohProductTwoCoordinates q)
    (recohCyclicBankPrime q) (recohCyclicBankDepth q) (recohCyclicBankEncoding q) terms

/-- The canonical bank discharges every role contract needed for reordering
the checks.  Only the reduced observed-coefficient condition remains here;
the guarded decoder below checks it on the input. -/
theorem recoh_cyclic_prepared_core_eq_coefficient
    (entries : List (((i : Fin d) → ZMod (q i)) × ℕ))
    (terms : RecohCyclicBankIndex q → RecohSparseTerms)
    (hred : ∀ i, RecohCoefficientsReduced
      (recohCyclicBankPrime q i) (recohCyclicBankDepth q i) (terms i)) :
    recohCyclicPreparedCore q entries terms = recohCyclicCoefficientCore q entries terms := by
  apply recoh_early_coefficient_backend_decoder_eq_backend
    (recohTypedSquareSupport entries) (recohTypedSquareValue entries)
    (recohProductHalf q) (recohProductTwoCoordinates q)
    (recohCyclicBankPrime q) (recohCyclicBankDepth q) (recohCyclicBankEncoding q) terms
    (recohCyclicObservedBank q) (recohCyclicBankRoot q)
    (fun i => recohCoefficientValue (recohCyclicBankRoot q i) (terms i))
  · exact recoh_typed_square_covered entries
  · exact recoh_cyclic_bank_prime q
  · exact recoh_cyclic_bank_root_primitive q
  · exact hred
  · exact recoh_cyclic_bank_encoding_interpret q
  · intro i; rfl
  · intro u i
    exact recoh_cyclic_binary_bank_sign_coordinates q (recohCanonicalPrimaryData q 2) u i
  · intro u i
    apply recoh_cyclic_ternary_bank_trivial_on_two q (recohCanonicalPrimaryData q 3)
      ⟨i.val, i.property.1⟩ u.val
    simpa only [recoh_mem_torsion_subgroup, two_nsmul] using u.property

/-- The same typed input guard as the coefficient decoder, followed by
the concrete early-rejection core. -/
def recohCyclicPreparedDecoder
    (entries : List (((i : Fin d) → ZMod (q i)) × ℕ))
    (terms : RecohCyclicBankIndex q → RecohSparseTerms) :
    Finset (Finset ((i : Fin d) → ZMod (q i))) :=
  if recohCyclicInputCheck q entries terms then recohCyclicPreparedCore q entries terms
  else ∅

/-- Early rejection changes neither accepted nor rejected typed inputs. -/
theorem recoh_cyclic_prepared_decoder_eq_coefficient
    (entries : List (((i : Fin d) → ZMod (q i)) × ℕ))
    (terms : RecohCyclicBankIndex q → RecohSparseTerms) :
    recohCyclicPreparedDecoder q entries terms =
      recohCyclicCoefficientDecoder q entries terms := by
  by_cases hformat : RecohCyclicInputFormat q entries terms
  · have hcheck := (recoh_cyclic_input_check_iff q entries terms).mpr hformat
    simp only [recohCyclicPreparedDecoder, recohCyclicCoefficientDecoder, hcheck, if_true]
    exact recoh_cyclic_prepared_core_eq_coefficient q entries terms
      (fun i => (hformat.2.2.2 i).1)
  · have hcheck : ¬ recohCyclicInputCheck q entries terms = true :=
      fun h => hformat ((recoh_cyclic_input_check_iff q entries terms).mp h)
    simp only [recohCyclicPreparedDecoder, recohCyclicCoefficientDecoder, if_neg hcheck]

/-- The concrete prepared control flow has the same full observation
contract, with no externally supplied semantic witnesses. -/
theorem recoh_mem_cyclic_prepared_decoder_iff
    (entries : List (((i : Fin d) → ZMod (q i)) × ℕ))
    (terms : RecohCyclicBankIndex q → RecohSparseTerms)
    (S : Finset ((i : Fin d) → ZMod (q i))) :
    S ∈ recohCyclicPreparedDecoder q entries terms ↔
      RecohCyclicInputFormat q entries terms ∧ S.card = 3 ∧
        recohObservation (recohCyclicObservedBank q) S =
          recohCyclicTypedObservation q entries terms := by
  rw [recoh_cyclic_prepared_decoder_eq_coefficient]
  exact recoh_mem_cyclic_coefficient_decoder_iff q entries terms S

/-- A valid observation of a triple is reconstructed uniquely after
the canonical early checks and direct sign recovery. -/
theorem recoh_cyclic_prepared_decoder_singleton
    (entries : List (((i : Fin d) → ZMod (q i)) × ℕ))
    (terms : RecohCyclicBankIndex q → RecohSparseTerms)
    (hformat : RecohCyclicInputFormat q entries terms)
    (S : Finset ((i : Fin d) → ZMod (q i))) (hS : S.card = 3)
    (hobs : recohObservation (recohCyclicObservedBank q) S =
      recohCyclicTypedObservation q entries terms) :
    recohCyclicPreparedDecoder q entries terms = {S} := by
  rw [recoh_cyclic_prepared_decoder_eq_coefficient]
  exact recoh_cyclic_coefficient_decoder_singleton q entries terms hformat S hS hobs

/-- Arbitrary typed inputs return at most one support. -/
theorem recoh_cyclic_prepared_decoder_card_le_one
    (entries : List (((i : Fin d) → ZMod (q i)) × ℕ))
    (terms : RecohCyclicBankIndex q → RecohSparseTerms) :
    (recohCyclicPreparedDecoder q entries terms).card ≤ 1 := by
  rw [recoh_cyclic_prepared_decoder_eq_coefficient]
  exact recoh_cyclic_coefficient_decoder_card_le_one q entries terms

/-- Before the full final check, at most twenty candidates survive the
early checks and recovery on a well-formed typed input. -/
theorem recoh_cyclic_prepared_candidates_le_twenty
    (entries : List (((i : Fin d) → ZMod (q i)) × ℕ))
    (terms : RecohCyclicBankIndex q → RecohSparseTerms)
    (hformat : RecohCyclicInputFormat q entries terms) :
    (recohPreparedFastCandidates (recohTypedSquareSupport entries) (recohProductHalf q)
      (recohIndexedRecoverSupport (recohProductTwoCoordinates q)
        (recohCoefficientSignBools Sum.inl (recohCyclicBankPrime q)
          (recohCyclicBankDepth q) (recohCyclicBankEncoding q) terms))
      (recohEarlyCandidateCheck (recohTypedSquareSupport entries)
        (recohTypedSquareValue entries) (recohCyclicBankPrime q)
        (recohCyclicBankDepth q) (recohCyclicBankEncoding q) terms)).card ≤ 20 := by
  apply recoh_prepared_fast_candidates_card_le_twenty
  exact recoh_typed_square_support_card_le_six entries hformat.2.2.1

end Couret.STROBO2TORS

#print axioms Couret.STROBO2TORS.recoh_cyclic_prepared_core_eq_coefficient
#print axioms Couret.STROBO2TORS.recoh_cyclic_prepared_decoder_eq_coefficient
#print axioms Couret.STROBO2TORS.recoh_mem_cyclic_prepared_decoder_iff
#print axioms Couret.STROBO2TORS.recoh_cyclic_prepared_decoder_singleton
#print axioms Couret.STROBO2TORS.recoh_cyclic_prepared_decoder_card_le_one
#print axioms Couret.STROBO2TORS.recoh_cyclic_prepared_candidates_le_twenty
