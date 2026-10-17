import RecohSelectedDecoder
import RecohExceptionalStability
import RecohNoisyUniqueness

set_option autoImplicit false

/-!
Quantitative reconstruction with the square-selected minimum-size bank.
Each binary character is replaced by a prescribed odd power; the selected
ternary character and the measurement index type are unchanged.

The multipliers are parameters of the bank and are fixed before readings are
received. The quantitative theorems require a certified amplitude bound on
the square fibre. A separate square-only selector supplies these parameters
and that bound.

The rational-decoder bridges use a supplied candidate set contained in the
fibre. They do not introduce an executable enumeration of the ambient group
or its powerset. Prediction error is included in the uniqueness budget.
-/

namespace Couret.STROBO2TORS

/-- Odd powers leave the restriction of any character to two-torsion
unchanged. -/
theorem recoh_character_odd_power_on_two
    {G : Type*} [AddCommGroup G] (chi : AddChar G ℂ)
    (k : ℕ) (hk : Odd k) (u : G) (hu : u + u = 0) :
    (chi ^ k) u = chi u := by
  classical
  rw [AddChar.pow_apply]
  rcases recoh_two_torsion_probe_is_sign chi chi.map_add_eq_mul
    chi.map_zero_eq_one u hu with h | h
  · simp [h]
  · rw [h, hk.neg_one_pow]

variable {d : ℕ} (q : Fin d → ℕ) [∀ i, NeZero (q i)]

/-- One prescribed power of each canonical binary character. -/
noncomputable def recohStableBinaryBank (multipliers : RecohEvenCoordinate q → ℕ) :
    RecohEvenCoordinate q → AddChar ((i : Fin d) → ZMod (q i)) ℂ :=
  fun i => (recohCyclicPrimaryBank q 2 (recohCanonicalPrimaryData q 2) i) ^ multipliers i

theorem recoh_stable_binary_bank_apply (multipliers : RecohEvenCoordinate q → ℕ)
    (i : RecohEvenCoordinate q) (x : (j : Fin d) → ZMod (q j)) :
    recohStableBinaryBank q multipliers i x =
      (recohCyclicPrimaryBank q 2 (recohCanonicalPrimaryData q 2) i x) ^ multipliers i := rfl

/-- The powered character still satisfies the original two-primary
annihilation bound. This statement does not require oddness. -/
theorem recoh_stable_binary_bank_pow (multipliers : RecohEvenCoordinate q → ℕ)
    (i : RecohEvenCoordinate q) (x : (j : Fin d) → ZMod (q j)) :
    (recohStableBinaryBank q multipliers i x) ^
      (2 ^ ((recohCanonicalPrimaryData q 2).exponent i + 1)) = 1 := by
  rw [recoh_stable_binary_bank_apply, ← pow_mul,
    Nat.mul_comm (multipliers i), pow_mul,
    recoh_cyclic_primary_bank_pow q 2 (recohCanonicalPrimaryData q 2), one_pow]

/-- Odd powers preserve the full primary root order. -/
theorem recoh_stable_binary_root_primitive
    (multipliers : RecohEvenCoordinate q → ℕ) (hodd : ∀ i, Odd (multipliers i))
    (i : RecohEvenCoordinate q) :
    IsPrimitiveRoot
      ((recohCyclicRoot (2 ^ ((recohCanonicalPrimaryData q 2).exponent i + 1))) ^ multipliers i)
      (2 ^ ((recohCanonicalPrimaryData q 2).exponent i + 1)) := by
  apply (recoh_cyclic_root_primitive _).pow_of_coprime
  exact (hodd i).coprime_two_right.pow_right _

theorem recoh_stable_binary_bank_on_two (multipliers : RecohEvenCoordinate q → ℕ)
    (hodd : ∀ i, Odd (multipliers i)) (i : RecohEvenCoordinate q)
    (u : (j : Fin d) → ZMod (q j)) (hu : u + u = 0) :
    recohStableBinaryBank q multipliers i u =
      recohCyclicPrimaryBank q 2 (recohCanonicalPrimaryData q 2) i u :=
  recoh_character_odd_power_on_two
    (recohCyclicPrimaryBank q 2 (recohCanonicalPrimaryData q 2) i)
    (multipliers i) (hodd i) u hu

/-- Every original binary coordinate is preserved exactly, not merely
the joint kernel of the bank. -/
theorem recoh_stable_binary_bank_sign_coordinates
    (multipliers : RecohEvenCoordinate q → ℕ) (hodd : ∀ i, Odd (multipliers i))
    (u : recohTorsionSubgroup (G := (j : Fin d) → ZMod (q j)) 2)
    (i : RecohEvenCoordinate q) :
    recohStableBinaryBank q multipliers i u.val =
      if recohProductTwoCoordinates q u i = 0 then 1 else -1 := by
  rw [recoh_stable_binary_bank_on_two q multipliers hodd i u.val
    (by simpa only [recoh_mem_torsion_subgroup, two_nsmul] using u.property)]
  exact recoh_cyclic_binary_bank_sign_coordinates q (recohCanonicalPrimaryData q 2) u i

/-- Preserving the signs preserves detection of every nonzero involution. -/
theorem recoh_stable_binary_bank_separates
    (multipliers : RecohEvenCoordinate q → ℕ) (hodd : ∀ i, Odd (multipliers i))
    (u : (j : Fin d) → ZMod (q j)) (hu : u + u = 0)
    (hbank : ∀ i, recohStableBinaryBank q multipliers i u = 1) : u = 0 := by
  apply recoh_cyclic_primary_bank_separates q 2 (recohCanonicalPrimaryData q 2) u
    (by simpa only [two_nsmul] using hu)
  intro i
  rw [← recoh_stable_binary_bank_on_two q multipliers hodd i u hu]
  exact hbank i

/-- The measurement slots are exactly those of the square-selected bank. -/
noncomputable def recohStableObservedBank
    (entries : List (((i : Fin d) → ZMod (q i)) × ℕ))
    (multipliers : RecohEvenCoordinate q → ℕ) :
    RecohSelectedBankIndex q entries → AddChar ((i : Fin d) → ZMod (q i)) ℂ :=
  Sum.elim (recohStableBinaryBank q multipliers)
    (fun i => recohCyclicPrimaryBank q 3 (recohCanonicalPrimaryData q 3) i.val)

theorem recoh_stable_observed_bank_binary
    (entries : List (((i : Fin d) → ZMod (q i)) × ℕ))
    (multipliers : RecohEvenCoordinate q → ℕ) (i : RecohEvenCoordinate q) :
    recohStableObservedBank q entries multipliers (Sum.inl i) =
      recohStableBinaryBank q multipliers i := rfl

theorem recoh_stable_observed_bank_ternary
    (entries : List (((i : Fin d) → ZMod (q i)) × ℕ))
    (multipliers : RecohEvenCoordinate q → ℕ) (i : RecohSelectedTernaryIndex q entries) :
    recohStableObservedBank q entries multipliers (Sum.inr i) =
      recohSelectedObservedBank q entries (Sum.inr i) := rfl

/-- The existing square-only ternary selector and any certified binary
amplitude bound give quantitative separation with the same slots. -/
theorem recoh_stable_bank_separated
    (entries : List (((i : Fin d) → ZMod (q i)) × ℕ))
    (multipliers : RecohEvenCoordinate q → ℕ) (hodd : ∀ i, Odd (multipliers i))
    (S : Finset ((i : Fin d) → ZMod (q i)))
    (hSR : orderedSquare S = recohTypedSquareValue entries)
    (a : ℝ) (ha : a ≤ Real.sqrt 3)
    (hamp : ∀ T ∈ squareFibre S, ∀ i, a ≤ ‖recohSupportProbe
      (recohStableBinaryBank q multipliers i) T‖) :
    RecohProbeSeparated (recohStableObservedBank q entries multipliers)
      (squareFibre S) (2 * a) := by
  apply recoh_probe_separated_square_fibre
    (recohStableBinaryBank q multipliers)
    (fun i : RecohSelectedTernaryIndex q entries =>
      recohCyclicPrimaryBank q 3 (recohCanonicalPrimaryData q 3) i.val)
    S a ha hamp
  · exact recoh_stable_binary_bank_separates q multipliers hodd
  · intro j u hu
    exact recoh_cyclic_ternary_bank_trivial_on_two q (recohCanonicalPrimaryData q 3) j.val u hu
  · intro B hB C hC hread
    have hBdata := (mem_squareFibre S B).mp hB
    have hCdata := (mem_squareFibre S C).mp hC
    have hBR : orderedSquare B = recohTypedSquareValue entries := by
      funext z
      exact (hBdata.2 z).symm.trans (congrFun hSR z)
    have hCR : orderedSquare C = recohTypedSquareValue entries := by
      funext z
      exact (hCdata.2 z).symm.trans (congrFun hSR z)
    apply recoh_square_selected_orbits q entries B C hBdata.1 hCdata.1 hBR hCR
    intro j hj
    exact hread ⟨j, hj⟩

/-- The two-choice Newton certificate gives separation one without
increasing the number of character readings. -/
theorem recoh_stable_bank_separated_one
    (entries : List (((i : Fin d) → ZMod (q i)) × ℕ))
    (multipliers : RecohEvenCoordinate q → ℕ) (hodd : ∀ i, Odd (multipliers i))
    (S : Finset ((i : Fin d) → ZMod (q i)))
    (hSR : orderedSquare S = recohTypedSquareValue entries)
    (hamp : ∀ T ∈ squareFibre S, ∀ i, (1 / 2 : ℝ) ≤ ‖recohSupportProbe
      (recohStableBinaryBank q multipliers i) T‖) :
    RecohProbeSeparated (recohStableObservedBank q entries multipliers) (squareFibre S) 1 := by
  have hsqrt : (1 / 2 : ℝ) ≤ Real.sqrt 3 := by
    nlinarith [Real.sq_sqrt (by norm_num : (0 : ℝ) ≤ 3), Real.sqrt_nonneg (3 : ℝ)]
  convert recoh_stable_bank_separated q entries multipliers hodd S hSR (1 / 2) hsqrt hamp using 1
  norm_num

/-- Unit binary amplitudes imply uniform separation two on the whole
observed square fibre, including the ordinary case and singleton fibres. -/
theorem recoh_stable_bank_separated_two
    (entries : List (((i : Fin d) → ZMod (q i)) × ℕ))
    (multipliers : RecohEvenCoordinate q → ℕ) (hodd : ∀ i, Odd (multipliers i))
    (S : Finset ((i : Fin d) → ZMod (q i)))
    (hSR : orderedSquare S = recohTypedSquareValue entries)
    (hamp : ∀ T ∈ squareFibre S, ∀ i, 1 ≤ ‖recohSupportProbe
      (recohStableBinaryBank q multipliers i) T‖) :
    RecohProbeSeparated (recohStableObservedBank q entries multipliers) (squareFibre S) 2 := by
  have hsqrt : (1 : ℝ) ≤ Real.sqrt 3 := by
    nlinarith [Real.sq_sqrt (by norm_num : (0 : ℝ) ≤ 3), Real.sqrt_nonneg (3 : ℝ)]
  simpa only [mul_one] using
    recoh_stable_bank_separated q entries multipliers hodd S hSR 1 hsqrt hamp

/-- The stable bank attains both its claimed separation and the previously
proved minimum number of measurements for this fibre. -/
theorem recoh_stable_bank_optimal
    (entries : List (((i : Fin d) → ZMod (q i)) × ℕ))
    (multipliers : RecohEvenCoordinate q → ℕ) (hodd : ∀ i, Odd (multipliers i))
    (S : Finset ((i : Fin d) → ZMod (q i))) (hS : S.card = 3)
    (hSR : orderedSquare S = recohTypedSquareValue entries)
    (hamp : ∀ T ∈ squareFibre S, ∀ i, 1 ≤ ‖recohSupportProbe
      (recohStableBinaryBank q multipliers i) T‖) :
    RecohProbeSeparated (recohStableObservedBank q entries multipliers) (squareFibre S) 2 ∧
      Fintype.card (RecohSelectedBankIndex q entries) = recohFibreBudget S ∧
      ∀ (k : ℕ), k < Fintype.card (RecohSelectedBankIndex q entries) →
        ∀ bank : Fin k → AddChar ((i : Fin d) → ZMod (q i)) ℂ,
          ¬ Set.InjOn (fun T : Finset ((i : Fin d) → ZMod (q i)) =>
            fun i => recohSupportProbe (bank i) T) (squareFibre S) := by
  refine ⟨recoh_stable_bank_separated_two q entries multipliers hodd S hSR hamp,
    recoh_selected_bank_card_eq_fibre_budget q entries S hS hSR, ?_⟩
  intro k hk bank
  exact recoh_selected_bank_minimal q entries S hS hSR k hk bank

/-- The strict unit-error uniqueness contract for the stable bank.
The errors may vary independently from coordinate to coordinate. -/
theorem recoh_stable_bank_noisy_unit_unique
    (entries : List (((i : Fin d) → ZMod (q i)) × ℕ))
    (multipliers : RecohEvenCoordinate q → ℕ) (hodd : ∀ i, Odd (multipliers i))
    (S : Finset ((i : Fin d) → ZMod (q i)))
    (hSR : orderedSquare S = recohTypedSquareValue entries)
    (hamp : ∀ T ∈ squareFibre S, ∀ i, 1 ≤ ‖recohSupportProbe
      (recohStableBinaryBank q multipliers i) T‖)
    (observed : RecohSelectedBankIndex q entries → ℂ)
    (B C : Finset ((i : Fin d) → ZMod (q i)))
    (hB : B ∈ squareFibre S) (hC : C ∈ squareFibre S)
    (hBerr : ∀ i, ‖observed i - recohSupportProbe
      (recohStableObservedBank q entries multipliers i) B‖ < 1)
    (hCerr : ∀ i, ‖observed i - recohSupportProbe
      (recohStableObservedBank q entries multipliers i) C‖ < 1) : B = C := by
  exact recoh_noisy_unit_reading_unique
    (fun T i => recohSupportProbe (recohStableObservedBank q entries multipliers i) T)
    (squareFibre S) (recoh_stable_bank_separated_two q entries multipliers hodd S hSR hamp)
    observed B C hB hC hBerr hCerr

/-- The rational decoder rejects all but at most one supplied candidate
when radius plus prediction error is strictly less than one. -/
theorem recoh_stable_rational_noisy_decoder_card_le_one
    (entries : List (((i : Fin d) → ZMod (q i)) × ℕ))
    (multipliers : RecohEvenCoordinate q → ℕ) (hodd : ∀ i, Odd (multipliers i))
    (S : Finset ((i : Fin d) → ZMod (q i)))
    (hSR : orderedSquare S = recohTypedSquareValue entries)
    (hamp : ∀ T ∈ squareFibre S, ∀ i, 1 ≤ ‖recohSupportProbe
      (recohStableBinaryBank q multipliers i) T‖)
    (candidates : Finset (Finset ((i : Fin d) → ZMod (q i))))
    (hsub : candidates ⊆ squareFibre S)
    (predicted : Finset ((i : Fin d) → ZMod (q i)) →
      RecohSelectedBankIndex q entries → RecohRationalComplex)
    (observed : RecohSelectedBankIndex q entries → RecohRationalComplex)
    (radius : ℚ) (η : ℝ)
    (hpred : ∀ T ∈ candidates, ∀ i, ‖recohRationalComplexValue (predicted T i) -
      recohSupportProbe (recohStableObservedBank q entries multipliers i) T‖ ≤ η)
    (hbudget : (radius : ℝ) + η < 1) :
    (recohRationalNoisyDecoder candidates predicted observed radius).card ≤ 1 := by
  have hsep := recoh_stable_bank_separated_two q entries multipliers hodd S hSR hamp
  apply recoh_rational_noisy_decoder_card_le_one
    (fun T i => recohSupportProbe (recohStableObservedBank q entries multipliers i) T)
    candidates predicted observed radius η 2 ?_ hpred (by linarith)
  intro B hB C hC hBC
  exact hsep B (hsub hB) C (hsub hC) hBC

/-- Including the true candidate and budgeting both measurement and
prediction error upgrades the executable rational output to a singleton. -/
theorem recoh_stable_rational_noisy_decoder_singleton
    (entries : List (((i : Fin d) → ZMod (q i)) × ℕ))
    (multipliers : RecohEvenCoordinate q → ℕ) (hodd : ∀ i, Odd (multipliers i))
    (S : Finset ((i : Fin d) → ZMod (q i)))
    (hSR : orderedSquare S = recohTypedSquareValue entries)
    (hamp : ∀ T ∈ squareFibre S, ∀ i, 1 ≤ ‖recohSupportProbe
      (recohStableBinaryBank q multipliers i) T‖)
    (candidates : Finset (Finset ((i : Fin d) → ZMod (q i))))
    (hsub : candidates ⊆ squareFibre S)
    (predicted : Finset ((i : Fin d) → ZMod (q i)) →
      RecohSelectedBankIndex q entries → RecohRationalComplex)
    (observed : RecohSelectedBankIndex q entries → RecohRationalComplex)
    (radius : ℚ) (ε η : ℝ) (hradius : 0 ≤ radius)
    (B : Finset ((i : Fin d) → ZMod (q i))) (hB : B ∈ candidates)
    (hpred : ∀ T ∈ candidates, ∀ i, ‖recohRationalComplexValue (predicted T i) -
      recohSupportProbe (recohStableObservedBank q entries multipliers i) T‖ ≤ η)
    (hobs : ∀ i, ‖recohRationalComplexValue (observed i) -
      recohSupportProbe (recohStableObservedBank q entries multipliers i) B‖ ≤ ε)
    (hcomplete : ε + η ≤ (radius : ℝ)) (hunique : (radius : ℝ) + η < 1) :
    recohRationalNoisyDecoder candidates predicted observed radius = {B} := by
  have hsep := recoh_stable_bank_separated_two q entries multipliers hodd S hSR hamp
  apply recoh_rational_noisy_decoder_singleton
    (fun T i => recohSupportProbe (recohStableObservedBank q entries multipliers i) T)
    candidates predicted observed radius ε η 2 hradius B hB ?_ hpred hobs hcomplete (by linarith)
  intro T hT U hU hTU
  exact hsep T (hsub hT) U (hsub hU) hTU

end Couret.STROBO2TORS

#print axioms Couret.STROBO2TORS.recoh_character_odd_power_on_two
#print axioms Couret.STROBO2TORS.recoh_stable_binary_bank_apply
#print axioms Couret.STROBO2TORS.recoh_stable_binary_bank_pow
#print axioms Couret.STROBO2TORS.recoh_stable_binary_root_primitive
#print axioms Couret.STROBO2TORS.recoh_stable_binary_bank_on_two
#print axioms Couret.STROBO2TORS.recoh_stable_binary_bank_sign_coordinates
#print axioms Couret.STROBO2TORS.recoh_stable_binary_bank_separates
#print axioms Couret.STROBO2TORS.recoh_stable_observed_bank_binary
#print axioms Couret.STROBO2TORS.recoh_stable_observed_bank_ternary
#print axioms Couret.STROBO2TORS.recoh_stable_bank_separated
#print axioms Couret.STROBO2TORS.recoh_stable_bank_separated_one
#print axioms Couret.STROBO2TORS.recoh_stable_bank_separated_two
#print axioms Couret.STROBO2TORS.recoh_stable_bank_optimal
#print axioms Couret.STROBO2TORS.recoh_stable_bank_noisy_unit_unique
#print axioms Couret.STROBO2TORS.recoh_stable_rational_noisy_decoder_card_le_one
#print axioms Couret.STROBO2TORS.recoh_stable_rational_noisy_decoder_singleton
