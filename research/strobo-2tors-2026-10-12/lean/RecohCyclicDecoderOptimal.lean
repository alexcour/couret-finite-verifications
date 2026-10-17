import RecohCyclicCoefficientDecoder

set_option autoImplicit false

/-!
The bank actually indexed by the typed cyclic decoder attains the minimal
measurement budget, including its empty bank on odd-order products.
The short-term bounds below apply to candidate triples. No length bound
is imposed on arbitrary externally supplied coefficient observations.
-/

namespace Couret.STROBO2TORS

open scoped BigOperators

variable {d : ℕ} (q : Fin d → ℕ) [∀ i, NeZero (q i)]

omit [∀ i, NeZero (q i)] in
theorem recoh_cyclic_bank_card_of_even (heven : ∃ i : Fin d, 2 ∣ q i) :
    Fintype.card (RecohCyclicBankIndex q) =
      Fintype.card (RecohPrimaryCoordinate q 2) +
        Fintype.card (RecohPrimaryCoordinate q 3) := by
  let e : RecohActiveTernaryCoordinate q ≃ RecohPrimaryCoordinate q 3 :=
    { toFun := fun i => ⟨i.val, i.property.1⟩
      invFun := fun i => ⟨i.val, i.property, heven⟩
      left_inv := fun i => by apply Subtype.ext; rfl
      right_inv := fun i => by apply Subtype.ext; rfl }
  change Fintype.card (RecohEvenCoordinate q ⊕ RecohActiveTernaryCoordinate q) = _
  rw [Fintype.card_sum, Fintype.card_congr e]

omit [∀ i, NeZero (q i)] in
theorem recoh_cyclic_bank_card_of_odd (hodd : ¬ ∃ i : Fin d, 2 ∣ q i) :
    Fintype.card (RecohCyclicBankIndex q) = 0 := by
  letI : IsEmpty (RecohEvenCoordinate q) :=
    ⟨fun i => hodd ⟨i.val, i.property⟩⟩
  letI : IsEmpty (RecohActiveTernaryCoordinate q) :=
    ⟨fun i => hodd i.property.2⟩
  simp only [RecohCyclicBankIndex, Fintype.card_of_isEmpty]

omit [∀ i, NeZero (q i)] in
theorem recoh_cyclic_bank_card :
    Fintype.card (RecohCyclicBankIndex q) =
      if ∃ i : Fin d, 2 ∣ q i then
        Fintype.card (RecohPrimaryCoordinate q 2) +
          Fintype.card (RecohPrimaryCoordinate q 3)
      else 0 := by
  split_ifs with heven
  · exact recoh_cyclic_bank_card_of_even q heven
  · exact recoh_cyclic_bank_card_of_odd q heven

/-- The lower bound counts the very slots used by the executable decoder,
and quantifies over every competing fixed complex-character bank. -/
theorem recoh_cyclic_observed_bank_minimal
    (hG3 : 3 ≤ ∏ i, q i) :
    Function.Injective (fun S :
      {S : Finset ((i : Fin d) → ZMod (q i)) // S.card = 3} =>
      recohObservation (recohCyclicObservedBank q) S.1) ∧
    (∀ k : ℕ, k < Fintype.card (RecohCyclicBankIndex q) →
      ∀ bank : Fin k → AddChar ((i : Fin d) → ZMod (q i)) ℂ,
        ¬ Function.Injective (fun S :
          {S : Finset ((i : Fin d) → ZMod (q i)) // S.card = 3} =>
          recohObservation bank S.1)) := by
  refine ⟨recoh_cyclic_observed_bank_injective q, ?_⟩
  intro k hk bank
  by_cases heven : ∃ i : Fin d, 2 ∣ q i
  · rw [recoh_cyclic_bank_card_of_even q heven] at hk
    have hcard : 3 ≤ Fintype.card ((i : Fin d) → ZMod (q i)) := by
      simpa only [Fintype.card_pi, ZMod.card] using hG3
    exact (recoh_cyclic_canonical_bank_optimal q heven hcard).2 k hk bank
  · rw [recoh_cyclic_bank_card_of_odd q heven] at hk
    exact (Nat.not_lt_zero k hk).elim

/-- Exact typed reconstruction and the minimal fixed-bank budget hold
simultaneously for the same fully instantiated decoder. -/
theorem recoh_cyclic_decoder_uses_minimal_bank
    (entries : List (((i : Fin d) → ZMod (q i)) × ℕ))
    (terms : RecohCyclicBankIndex q → RecohSparseTerms)
    (hformat : RecohCyclicInputFormat q entries terms) :
    recohCyclicCoefficientDecoder q entries terms =
      recohExactDecoder (recohCyclicObservedBank q)
        (recohCyclicTypedObservation q entries terms) ∧
    (∀ k : ℕ, k < Fintype.card (RecohCyclicBankIndex q) →
      ∀ bank : Fin k → AddChar ((i : Fin d) → ZMod (q i)) ℂ,
        ¬ Function.Injective (fun S :
          {S : Finset ((i : Fin d) → ZMod (q i)) // S.card = 3} =>
          recohObservation bank S.1)) := by
  exact ⟨recoh_cyclic_coefficient_decoder_eq_exact q entries terms hformat,
    (recoh_cyclic_observed_bank_minimal q hformat.2.1).2⟩

omit [∀ i, NeZero (q i)] in
theorem recoh_cyclic_binary_candidate_terms_le_three
    (i : RecohEvenCoordinate q)
    (S : Finset ((i : Fin d) → ZMod (q i))) (hS : S.card = 3)
    (k : ℕ) :
    (recohReducedTerms 2 k (recohCyclicBankEncoding q (Sum.inl i) S)).length ≤ 3 := by
  have h := recoh_reduced_terms_length_le Nat.prime_two k
    (recohCyclicBankEncoding q (Sum.inl i) S)
  simpa only [recoh_cyclic_bank_encoding_length, hS, Nat.reduceSub,
    Nat.mul_one] using h

omit [∀ i, NeZero (q i)] in
theorem recoh_cyclic_ternary_candidate_terms_le_six
    (i : RecohActiveTernaryCoordinate q)
    (S : Finset ((i : Fin d) → ZMod (q i))) (hS : S.card = 3)
    (k : ℕ) :
    (recohReducedTerms 3 k (recohCyclicBankEncoding q (Sum.inr i) S)).length ≤ 6 := by
  have h := recoh_reduced_terms_length_le Nat.prime_three k
    (recohCyclicBankEncoding q (Sum.inr i) S)
  simpa only [recoh_cyclic_bank_encoding_length, hS, Nat.reduceSub,
    Nat.reduceMul] using h

end Couret.STROBO2TORS

#print axioms Couret.STROBO2TORS.recoh_cyclic_bank_card_of_even
#print axioms Couret.STROBO2TORS.recoh_cyclic_bank_card_of_odd
#print axioms Couret.STROBO2TORS.recoh_cyclic_bank_card
#print axioms Couret.STROBO2TORS.recoh_cyclic_observed_bank_minimal
#print axioms Couret.STROBO2TORS.recoh_cyclic_decoder_uses_minimal_bank
#print axioms Couret.STROBO2TORS.recoh_cyclic_binary_candidate_terms_le_three
#print axioms Couret.STROBO2TORS.recoh_cyclic_ternary_candidate_terms_le_six
