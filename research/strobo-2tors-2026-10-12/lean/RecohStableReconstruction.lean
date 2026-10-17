import RecohStableSquareSelection
import RecohStableBank
import RecohNoisySignRecovery
import RecohStablePrecision

set_option autoImplicit false

/-!
End-to-end stable reconstruction on explicit cyclic products.  The square
determines the bank, rational series determine the prediction centres, and
the decoder generates at most one candidate per square representative.
Precision is supplied by two natural numbers and checked by rational guards.
No complex comparison occurs in the executable definitions.
-/

namespace Couret.STROBO2TORS

open scoped BigOperators

variable {d : ℕ} (q : Fin d → ℕ) [∀ i, NeZero (q i)]

noncomputable def recohComputedStableBank
    (entries : List (((i : Fin d) → ZMod (q i)) × ℕ)) :
    RecohSelectedBankIndex q entries → AddChar ((i : Fin d) → ZMod (q i)) ℂ :=
  recohStableObservedBank q entries (recohStableBinaryMultiplier q entries)

/-- The fully specified square-only bank has uniform separation two. -/
theorem recoh_computed_stable_bank_separated
    (entries : List (((i : Fin d) → ZMod (q i)) × ℕ))
    (S : Finset ((i : Fin d) → ZMod (q i)))
    (hR : orderedSquare S = recohTypedSquareValue entries) :
    RecohProbeSeparated (recohComputedStableBank q entries) (squareFibre S) 2 := by
  apply recoh_stable_bank_separated_two q entries (recohStableBinaryMultiplier q entries)
    (recoh_stable_binary_multiplier_odd q entries) S hR
  intro T hT i
  have hTdata := (mem_squareFibre S T).mp hT
  apply recoh_stable_binary_amplitude q entries T hTdata.1
  funext z
  exact (hTdata.2 z).symm.trans (congrFun hR z)

/-- Separation and the exact minimum measurement budget hold together. -/
theorem recoh_computed_stable_bank_optimal
    (entries : List (((i : Fin d) → ZMod (q i)) × ℕ))
    (S : Finset ((i : Fin d) → ZMod (q i))) (hS : S.card = 3)
    (hR : orderedSquare S = recohTypedSquareValue entries) :
    RecohProbeSeparated (recohComputedStableBank q entries) (squareFibre S) 2 ∧
      Fintype.card (RecohSelectedBankIndex q entries) = recohFibreBudget S ∧
      ∀ (k : ℕ), k < Fintype.card (RecohSelectedBankIndex q entries) →
        ∀ bank : Fin k → AddChar ((i : Fin d) → ZMod (q i)) ℂ,
          ¬ Set.InjOn (fun T : Finset ((i : Fin d) → ZMod (q i)) =>
            fun i => recohSupportProbe (bank i) T) (squareFibre S) := by
  refine ⟨recoh_computed_stable_bank_separated q entries S hR,
    recoh_selected_bank_card_eq_fibre_budget q entries S hS hR, ?_⟩
  exact recoh_selected_bank_minimal q entries S hS hR

def recohSupportPhaseCenter (S : Finset ((i : Fin d) → ZMod (q i)))
    (coordinate : Fin d) (N multiplier machinTerms taylorTerms : ℕ) : RecohRationalComplex :=
  ∑ x ∈ S, recohRationalRootPower N ((x coordinate).val * multiplier) machinTerms taylorTerms

/-- The three rational root centres approximate the actual support reading. -/
theorem recoh_support_phase_center_error
    (S : Finset ((i : Fin d) → ZMod (q i))) (hS : S.card = 3)
    (coordinate : Fin d) (N : ℕ) [NeZero N] (hN : N ∣ q coordinate)
    (multiplier machinTerms taylorTerms : ℕ)
    (hpi : |recohPiPartial machinTerms| ≤ 4) (htaylor : 15 ≤ taylorTerms) :
    ‖recohRationalComplexValue
        (recohSupportPhaseCenter q S coordinate N multiplier machinTerms taylorTerms) -
      recohSupportProbe ((recohCyclicCoordinateCharacter q coordinate N hN) ^ multiplier) S‖ ≤
        3 * (recohRationalPhaseError machinTerms taylorTerms : ℝ) := by
  have hvalue : recohRationalComplexValue
      (recohSupportPhaseCenter q S coordinate N multiplier machinTerms taylorTerms) =
      ∑ x ∈ S, recohRationalComplexValue
        (recohRationalRootPower N ((x coordinate).val * multiplier) machinTerms taylorTerms) := by
    change recohRationalComplexAddHom _ = _
    rw [recohSupportPhaseCenter, map_sum]
    rfl
  rw [hvalue, recohSupportProbe, ← Finset.sum_sub_distrib]
  calc
    _ ≤ ∑ x ∈ S, ‖recohRationalComplexValue
        (recohRationalRootPower N ((x coordinate).val * multiplier) machinTerms taylorTerms) -
        ((recohCyclicCoordinateCharacter q coordinate N hN) ^ multiplier) x‖ := norm_sum_le _ _
    _ ≤ ∑ _x ∈ S, (recohRationalPhaseError machinTerms taylorTerms : ℝ) := by
      apply Finset.sum_le_sum
      intro x hx
      rw [AddChar.pow_apply, recoh_cyclic_coordinate_character_apply, ← pow_mul]
      exact recoh_rational_root_power_error N _ machinTerms taylorTerms hpi htaylor
    _ = _ := by simp [hS]

def recohStablePredictionTolerance (epsilon : ℚ) : ℚ := (1 - epsilon) / 4

def recohStableAcceptanceRadius (epsilon : ℚ) : ℚ :=
  epsilon + recohStablePredictionTolerance epsilon

def RecohStablePrecisionValid (epsilon : ℚ) (machinTerms taylorTerms : ℕ) : Prop :=
  0 ≤ epsilon ∧ epsilon < 1 ∧ |recohPiPartial machinTerms| ≤ 4 ∧
    15 ≤ taylorTerms ∧
      3 * recohRationalPhaseError machinTerms taylorTerms ≤ recohStablePredictionTolerance epsilon

instance (epsilon : ℚ) (machinTerms taylorTerms : ℕ) :
    Decidable (RecohStablePrecisionValid epsilon machinTerms taylorTerms) := by
  unfold RecohStablePrecisionValid
  infer_instance

def recohStablePrecisionCheck (epsilon : ℚ) (machinTerms taylorTerms : ℕ) : Bool :=
  decide (RecohStablePrecisionValid epsilon machinTerms taylorTerms)

theorem recoh_stable_precision_check_iff (epsilon : ℚ) (machinTerms taylorTerms : ℕ) :
    recohStablePrecisionCheck epsilon machinTerms taylorTerms = true ↔
      RecohStablePrecisionValid epsilon machinTerms taylorTerms := by
  simp [recohStablePrecisionCheck]

/-- Valid finite approximation parameters exist for every admissible noise
budget, including budgets arbitrarily close to one. -/
theorem recoh_stable_precision_exists (epsilon : ℚ)
    (he0 : 0 ≤ epsilon) (he1 : epsilon < 1) :
    ∃ machinTerms taylorTerms, RecohStablePrecisionValid epsilon machinTerms taylorTerms := by
  obtain ⟨m, n, _hm, hpi, hn, herr⟩ := recoh_stable_precision_parameters_exist epsilon he1
  exact ⟨m, n, he0, he1, hpi, hn, herr⟩

theorem recoh_stable_precision_budgets (epsilon : ℚ) (machinTerms taylorTerms : ℕ)
    (h : RecohStablePrecisionValid epsilon machinTerms taylorTerms) :
    0 ≤ recohStableAcceptanceRadius epsilon ∧
      0 ≤ (recohStablePredictionTolerance epsilon : ℝ) ∧
      (epsilon : ℝ) + (recohStablePredictionTolerance epsilon : ℝ) =
        (recohStableAcceptanceRadius epsilon : ℝ) ∧
      2 * ((recohStableAcceptanceRadius epsilon : ℝ) +
        (recohStablePredictionTolerance epsilon : ℝ)) < 2 := by
  have he0 : (0 : ℝ) ≤ epsilon := by exact_mod_cast h.1
  have he1 : (epsilon : ℝ) < 1 := by exact_mod_cast h.2.1
  dsimp [recohStableAcceptanceRadius, recohStablePredictionTolerance]
  push_cast
  refine ⟨by dsimp [RecohStablePrecisionValid] at h; linarith [h.1, h.2.1], ?_, rfl, ?_⟩ <;> linarith

def recohStablePredictedReading
    (entries : List (((i : Fin d) → ZMod (q i)) × ℕ))
    (machinTerms taylorTerms : ℕ) (S : Finset ((i : Fin d) → ZMod (q i))) :
    RecohSelectedBankIndex q entries → RecohRationalComplex :=
  Sum.elim
    (fun i => recohSupportPhaseCenter q S i.val
      (2 ^ ((recohCanonicalPrimaryData q 2).exponent i + 1))
      (recohStableBinaryMultiplier q entries i) machinTerms taylorTerms)
    (fun i => recohSupportPhaseCenter q S i.val.val
      (3 ^ ((recohCanonicalPrimaryData q 3).exponent i.val + 1)) 1 machinTerms taylorTerms)

/-- Every predicted slot, binary or selected ternary, carries its error bound. -/
theorem recoh_stable_predicted_reading_error
    (entries : List (((i : Fin d) → ZMod (q i)) × ℕ))
    (epsilon : ℚ) (machinTerms taylorTerms : ℕ)
    (hprecision : RecohStablePrecisionValid epsilon machinTerms taylorTerms)
    (S : Finset ((i : Fin d) → ZMod (q i))) (hS : S.card = 3)
    (i : RecohSelectedBankIndex q entries) :
    ‖recohRationalComplexValue (recohStablePredictedReading q entries machinTerms taylorTerms S i) -
      recohSupportProbe (recohComputedStableBank q entries i) S‖ ≤
        (recohStablePredictionTolerance epsilon : ℝ) := by
  have hbound : 3 * (recohRationalPhaseError machinTerms taylorTerms : ℝ) ≤
      (recohStablePredictionTolerance epsilon : ℝ) := by exact_mod_cast hprecision.2.2.2.2
  cases i with
  | inl j =>
    exact (recoh_support_phase_center_error q S hS j.val
      (2 ^ ((recohCanonicalPrimaryData q 2).exponent j + 1))
      (recoh_primary_factor_dvd q 2 (recohCanonicalPrimaryData q 2) j)
      (recohStableBinaryMultiplier q entries j) machinTerms taylorTerms
      hprecision.2.2.1 hprecision.2.2.2.1).trans hbound
  | inr j =>
    have h := recoh_support_phase_center_error q S hS j.val.val
      (3 ^ ((recohCanonicalPrimaryData q 3).exponent j.val + 1))
      (recoh_primary_factor_dvd q 3 (recohCanonicalPrimaryData q 3) j.val)
      1 machinTerms taylorTerms hprecision.2.2.1 hprecision.2.2.2.1
    simpa [recohStablePredictedReading, recohComputedStableBank,
      recohStableObservedBank, recohCyclicPrimaryBank] using h.trans hbound

def recohStableNoisyCore
    (entries : List (((i : Fin d) → ZMod (q i)) × ℕ))
    (observed : RecohSelectedBankIndex q entries → RecohRationalComplex)
    (epsilon : ℚ) (machinTerms taylorTerms : ℕ) : Finset (Finset ((i : Fin d) → ZMod (q i))) :=
  recohNoisySignDecoder (recohCyclicSquareRepresentatives q entries)
    (recohProductTwoCoordinates q) Sum.inl
    (recohStablePredictedReading q entries machinTerms taylorTerms) observed
    (recohStableAcceptanceRadius epsilon)

def recohStableNoisyDecoder
    (entries : List (((i : Fin d) → ZMod (q i)) × ℕ))
    (observed : RecohSelectedBankIndex q entries → RecohRationalComplex)
    (epsilon : ℚ) (machinTerms taylorTerms : ℕ) : Finset (Finset ((i : Fin d) → ZMod (q i))) :=
  if recohTypedSquareFormatCheck entries && recohStablePrecisionCheck epsilon machinTerms taylorTerms then
    recohStableNoisyCore q entries observed epsilon machinTerms taylorTerms
  else ∅

theorem recoh_stable_representatives_subset
    (entries : List (((i : Fin d) → ZMod (q i)) × ℕ))
    (S : Finset ((i : Fin d) → ZMod (q i)))
    (hR : orderedSquare S = recohTypedSquareValue entries) :
    recohCyclicSquareRepresentatives q entries ⊆ squareFibre S := by
  intro B hB
  have hb := recoh_cyclic_square_representatives_sound q entries B hB
  apply (mem_squareFibre S B).mpr
  refine ⟨hb.1, ?_⟩
  intro z
  exact (congrFun hR z).trans (congrFun hb.2 z).symm

/-- The concrete decoder recovers the unknown support from its exact square
and rational observations within any certified absolute error below one. -/
theorem recoh_stable_noisy_core_singleton
    (entries : List (((i : Fin d) → ZMod (q i)) × ℕ))
    (S : Finset ((i : Fin d) → ZMod (q i))) (hS : S.card = 3)
    (hR : orderedSquare S = recohTypedSquareValue entries)
    (observed : RecohSelectedBankIndex q entries → RecohRationalComplex)
    (epsilon : ℚ) (machinTerms taylorTerms : ℕ)
    (hprecision : RecohStablePrecisionValid epsilon machinTerms taylorTerms)
    (hobs : ∀ i, ‖recohRationalComplexValue (observed i) -
      recohSupportProbe (recohComputedStableBank q entries i) S‖ ≤ (epsilon : ℝ)) :
    recohStableNoisyCore q entries observed epsilon machinTerms taylorTerms = {S} := by
  have hb := recoh_stable_precision_budgets epsilon machinTerms taylorTerms hprecision
  apply recoh_noisy_sign_decoder_singleton
    (recohComputedStableBank q entries) S (recohCyclicSquareRepresentatives q entries)
    (recoh_stable_representatives_subset q entries S hR)
    (recoh_cyclic_square_representatives_complete q entries S hS hR)
    (recohProductTwoCoordinates q) Sum.inl
    (fun u j => recoh_stable_binary_bank_sign_coordinates q
      (recohStableBinaryMultiplier q entries) (recoh_stable_binary_multiplier_odd q entries) u j)
    (recohStablePredictedReading q entries machinTerms taylorTerms) observed
    (recohStableAcceptanceRadius epsilon) (epsilon : ℝ)
    (recohStablePredictionTolerance epsilon : ℝ) hb.1 hb.2.1
    (recoh_computed_stable_bank_separated q entries S hR)
  · intro B hB j
    have hBdata := recoh_cyclic_square_representatives_sound q entries B hB
    exact recoh_stable_binary_amplitude q entries B hBdata.1 hBdata.2 j
  · intro T hT i
    exact recoh_stable_predicted_reading_error q entries epsilon machinTerms taylorTerms
      hprecision T ((mem_squareFibre S T).mp hT).1 i
  · exact hobs
  · exact le_of_eq hb.2.2.1
  · exact hb.2.2.2

/-- Arbitrary observations also yield at most one candidate on a realizable
square; no assertion that such observations come from a true support is used. -/
theorem recoh_stable_noisy_core_card_le_one
    (entries : List (((i : Fin d) → ZMod (q i)) × ℕ))
    (S : Finset ((i : Fin d) → ZMod (q i)))
    (hR : orderedSquare S = recohTypedSquareValue entries)
    (observed : RecohSelectedBankIndex q entries → RecohRationalComplex)
    (epsilon : ℚ) (machinTerms taylorTerms : ℕ)
    (hprecision : RecohStablePrecisionValid epsilon machinTerms taylorTerms) :
    (recohStableNoisyCore q entries observed epsilon machinTerms taylorTerms).card ≤ 1 := by
  apply recoh_noisy_sign_decoder_card_le_one
    (recohComputedStableBank q entries) S (recohCyclicSquareRepresentatives q entries)
    (recoh_stable_representatives_subset q entries S hR)
    (recohProductTwoCoordinates q) Sum.inl
    (recohStablePredictedReading q entries machinTerms taylorTerms) observed
    (recohStableAcceptanceRadius epsilon) (recohStablePredictionTolerance epsilon : ℝ)
    (recoh_computed_stable_bank_separated q entries S hR)
  · intro T hT i
    exact recoh_stable_predicted_reading_error q entries epsilon machinTerms taylorTerms
      hprecision T ((mem_squareFibre S T).mp hT).1 i
  · exact (recoh_stable_precision_budgets epsilon machinTerms taylorTerms hprecision).2.2.2

/-- All format and approximation guards are part of the executable contract. -/
theorem recoh_stable_noisy_decoder_singleton
    (entries : List (((i : Fin d) → ZMod (q i)) × ℕ))
    (hformat : RecohTypedSquareFormat entries)
    (S : Finset ((i : Fin d) → ZMod (q i))) (hS : S.card = 3)
    (hR : orderedSquare S = recohTypedSquareValue entries)
    (observed : RecohSelectedBankIndex q entries → RecohRationalComplex)
    (epsilon : ℚ) (machinTerms taylorTerms : ℕ)
    (hprecision : RecohStablePrecisionValid epsilon machinTerms taylorTerms)
    (hobs : ∀ i, ‖recohRationalComplexValue (observed i) -
      recohSupportProbe (recohComputedStableBank q entries i) S‖ ≤ (epsilon : ℝ)) :
    recohStableNoisyDecoder q entries observed epsilon machinTerms taylorTerms = {S} := by
  rw [recohStableNoisyDecoder,
    (recoh_typed_square_format_check_iff entries).mpr hformat,
    (recoh_stable_precision_check_iff epsilon machinTerms taylorTerms).mpr hprecision]
  exact recoh_stable_noisy_core_singleton q entries S hS hR observed epsilon
    machinTerms taylorTerms hprecision hobs

/-- The guarded executable has at most one answer on every typed input,
including an unrealizable square or arbitrarily corrupted readings. -/
theorem recoh_stable_noisy_decoder_card_le_one
    (entries : List (((i : Fin d) → ZMod (q i)) × ℕ))
    (observed : RecohSelectedBankIndex q entries → RecohRationalComplex)
    (epsilon : ℚ) (machinTerms taylorTerms : ℕ) :
    (recohStableNoisyDecoder q entries observed epsilon machinTerms taylorTerms).card ≤ 1 := by
  unfold recohStableNoisyDecoder
  split_ifs with hguard
  · have hchecks : recohTypedSquareFormatCheck entries = true ∧
        recohStablePrecisionCheck epsilon machinTerms taylorTerms = true := by
      simpa only [Bool.and_eq_true] using hguard
    have hprecision := (recoh_stable_precision_check_iff epsilon machinTerms taylorTerms).mp hchecks.2
    by_cases hex : (recohCyclicSquareRepresentatives q entries).Nonempty
    · obtain ⟨S, hS⟩ := hex
      exact recoh_stable_noisy_core_card_le_one q entries S
        (recoh_cyclic_square_representatives_sound q entries S hS).2
        observed epsilon machinTerms taylorTerms hprecision
    · have hempty : recohCyclicSquareRepresentatives q entries = ∅ :=
        Finset.not_nonempty_iff_eq_empty.mp hex
      exact (recoh_noisy_sign_decoder_card_le_representatives
        (recohCyclicSquareRepresentatives q entries) (recohProductTwoCoordinates q) Sum.inl
        (recohStablePredictedReading q entries machinTerms taylorTerms)
        observed (recohStableAcceptanceRadius epsilon)).trans (by simp [hempty])
  · simp

/-- Candidate generation uses at most twenty square representatives and
never enumerates the ambient group or all two-torsion translations. -/
theorem recoh_stable_noisy_generated_candidates_le_twenty
    (entries : List (((i : Fin d) → ZMod (q i)) × ℕ))
    (hformat : RecohTypedSquareFormat entries)
    (observed : RecohSelectedBankIndex q entries → RecohRationalComplex)
    (epsilon : ℚ) (machinTerms taylorTerms : ℕ) :
    (recohNoisyRecoveredCandidates (recohCyclicSquareRepresentatives q entries)
      (recohProductTwoCoordinates q)
      (fun B j => recohStablePredictedReading q entries machinTerms taylorTerms B (Sum.inl j))
      (fun j => observed (Sum.inl j)) (recohStableAcceptanceRadius epsilon)).card ≤ 20 :=
  (recoh_noisy_recovered_candidates_card_le _ _ _ _ _).trans
    (recoh_cyclic_square_representatives_card_le_twenty q entries hformat)

/-- Full existence contract: every absolute noise budget below one admits
finite checked parameters for which the concrete typed decoder returns
exactly the true support, using the bank computed from the square. -/
theorem recoh_stable_noisy_reconstruction
    (entries : List (((i : Fin d) → ZMod (q i)) × ℕ))
    (hformat : RecohTypedSquareFormat entries)
    (S : Finset ((i : Fin d) → ZMod (q i))) (hS : S.card = 3)
    (hR : orderedSquare S = recohTypedSquareValue entries)
    (observed : RecohSelectedBankIndex q entries → RecohRationalComplex)
    (epsilon : ℚ) (he0 : 0 ≤ epsilon) (he1 : epsilon < 1)
    (hobs : ∀ i, ‖recohRationalComplexValue (observed i) -
      recohSupportProbe (recohComputedStableBank q entries i) S‖ ≤ (epsilon : ℝ)) :
    ∃ machinTerms taylorTerms,
      RecohStablePrecisionValid epsilon machinTerms taylorTerms ∧
      recohStableNoisyDecoder q entries observed epsilon machinTerms taylorTerms = {S} := by
  obtain ⟨m, n, hprecision⟩ := recoh_stable_precision_exists epsilon he0 he1
  exact ⟨m, n, hprecision, recoh_stable_noisy_decoder_singleton q entries hformat S hS hR
    observed epsilon m n hprecision hobs⟩

end Couret.STROBO2TORS

#print axioms Couret.STROBO2TORS.recoh_computed_stable_bank_separated
#print axioms Couret.STROBO2TORS.recoh_computed_stable_bank_optimal
#print axioms Couret.STROBO2TORS.recoh_support_phase_center_error
#print axioms Couret.STROBO2TORS.recoh_stable_precision_check_iff
#print axioms Couret.STROBO2TORS.recoh_stable_precision_exists
#print axioms Couret.STROBO2TORS.recoh_stable_precision_budgets
#print axioms Couret.STROBO2TORS.recoh_stable_predicted_reading_error
#print axioms Couret.STROBO2TORS.recoh_stable_representatives_subset
#print axioms Couret.STROBO2TORS.recoh_stable_noisy_core_singleton
#print axioms Couret.STROBO2TORS.recoh_stable_noisy_core_card_le_one
#print axioms Couret.STROBO2TORS.recoh_stable_noisy_decoder_singleton
#print axioms Couret.STROBO2TORS.recoh_stable_noisy_decoder_card_le_one
#print axioms Couret.STROBO2TORS.recoh_stable_noisy_generated_candidates_le_twenty
#print axioms Couret.STROBO2TORS.recoh_stable_noisy_reconstruction
