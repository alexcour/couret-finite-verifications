import RecohNoisyUniqueness
import RecohIndexedSignRecovery

set_option autoImplicit false

/-!
Noisy sign recovery from a list of square-fibre representatives.  Each
binary sign is recovered by one rational ball test, then transported through
the existing two-torsion coordinate equivalence.  At most one candidate is
created per representative, without enumerating the two-torsion subgroup.
The rational decoder in RecohNoisyUniqueness supplies the final tolerance
filter and uniqueness contract.
-/

namespace Couret.STROBO2TORS

/-- Positive sign test, using only rational arithmetic. -/
def recohRationalSignSame (base observed : RecohRationalComplex) (radius : ℚ) : Bool :=
  decide (0 ≤ radius ∧ recohRationalSquaredDistance observed base ≤ radius ^ 2)

theorem recoh_rational_sign_same_iff (base observed : RecohRationalComplex)
    (radius : ℚ) :
    recohRationalSignSame base observed radius = true ↔
      0 ≤ radius ∧ ‖recohRationalComplexValue observed -
        recohRationalComplexValue base‖ ≤ (radius : ℝ) := by
  rw [recohRationalSignSame, decide_eq_true_eq]
  constructor
  · rintro ⟨hr, h⟩
    exact ⟨hr, (recoh_rational_ball_iff observed base radius hr).mp h⟩
  · rintro ⟨hr, h⟩
    exact ⟨hr, (recoh_rational_ball_iff observed base radius hr).mpr h⟩

/-- A true sign is recovered despite errors in both measurement and base
prediction.  The sufficient budget is explicit and asymmetric. -/
theorem recoh_rational_sign_same_correct
    (truth : ℂ) (base observed : RecohRationalComplex) (radius : ℚ)
    (ε η : ℝ) (positive : Bool) (hradius : 0 ≤ radius)
    (hamplitude : 1 ≤ ‖truth‖)
    (hpred : ‖recohRationalComplexValue base - truth‖ ≤ η)
    (hobs : ‖recohRationalComplexValue observed - (if positive then truth else -truth)‖ ≤ ε)
    (hcomplete : ε + η ≤ (radius : ℝ))
    (hunique : ε + ((radius : ℝ) + η) < 2) :
    recohRationalSignSame base observed radius = positive := by
  cases positive with
  | true =>
    apply (recoh_rational_sign_same_iff base observed radius).mpr
    refine ⟨hradius, le_trans ?_ hcomplete⟩
    exact recoh_noisy_prediction_sound _ _ _ η ε
      (by simpa only [norm_sub_rev] using hpred) (by simpa using hobs)
  | false =>
    apply Bool.eq_false_iff.mpr
    intro hsame
    have hfit := ((recoh_rational_sign_same_iff base observed radius).mp hsame).2
    have hplus := recoh_noisy_prediction_sound _ _ _ η (radius : ℝ) hpred hfit
    have hminus : ‖recohRationalComplexValue observed - -truth‖ ≤ ε := by simpa using hobs
    have htriangle : ‖truth - -truth‖ ≤ (radius : ℝ) + η + ε := by
      calc
        ‖truth - -truth‖ = ‖(truth - recohRationalComplexValue observed) +
            (recohRationalComplexValue observed - -truth)‖ := by congr 1; ring
        _ ≤ ‖truth - recohRationalComplexValue observed‖ +
            ‖recohRationalComplexValue observed - -truth‖ := norm_add_le _ _
        _ ≤ (radius : ℝ) + η + ε :=
          add_le_add (by simpa only [norm_sub_rev] using hplus) hminus
    rw [recoh_opposite_probe_distance] at htriangle
    linarith

variable {G J : Type*} [AddCommGroup G] [DecidableEq G]

local notation "H₂" => recohTorsionSubgroup (G := G) 2

/-- Recover a candidate support from its predicted representative and
the rational noisy readings.  The coordinate inverse is supplied as data. -/
def recohNoisyRecoverSupport (e : H₂ ≃+ (J → ZMod 2))
    (predicted : Finset G → J → RecohRationalComplex)
    (observed : J → RecohRationalComplex) (radius : ℚ) (B : Finset G) : Finset G :=
  recohIndexedRecoverSupport e
    (fun T i => recohRationalSignSame (predicted T i) (observed i) radius) B

/-- One recovered candidate per representative; this definition never
enumerates the ambient group or its two-torsion subgroup. -/
def recohNoisyRecoveredCandidates (representatives : Finset (Finset G))
    (e : H₂ ≃+ (J → ZMod 2))
    (predicted : Finset G → J → RecohRationalComplex)
    (observed : J → RecohRationalComplex) (radius : ℚ) : Finset (Finset G) :=
  representatives.image (recohNoisyRecoverSupport e predicted observed radius)

theorem recoh_noisy_recovered_candidates_card_le
    (representatives : Finset (Finset G)) (e : H₂ ≃+ (J → ZMod 2))
    (predicted : Finset G → J → RecohRationalComplex)
    (observed : J → RecohRationalComplex) (radius : ℚ) :
    (recohNoisyRecoveredCandidates representatives e predicted observed radius).card ≤
      representatives.card := Finset.card_image_le

/-- Correct noisy signs recover the true two-torsion translation of a
representative through the previously verified coordinate inverse. -/
theorem recoh_noisy_recover_support_eq
    (bank : J → AddChar G ℂ) (e : H₂ ≃+ (J → ZMod 2))
    (hcoord : ∀ (u : H₂) (i : J), bank i (u : G) = if e u i = 0 then 1 else -1)
    (predicted : Finset G → J → RecohRationalComplex)
    (observed : J → RecohRationalComplex) (radius : ℚ) (ε η : ℝ)
    (hradius : 0 ≤ radius) (B : Finset G) (u : H₂)
    (hamplitude : ∀ i, 1 ≤ ‖recohSupportProbe (bank i) B‖)
    (hpred : ∀ i, ‖recohRationalComplexValue (predicted B i) -
      recohSupportProbe (bank i) B‖ ≤ η)
    (hobs : ∀ i, ‖recohRationalComplexValue (observed i) -
      recohSupportProbe (bank i) (translateSupport B (u : G))‖ ≤ ε)
    (hcomplete : ε + η ≤ (radius : ℝ))
    (hunique : ε + ((radius : ℝ) + η) < 2) :
    recohNoisyRecoverSupport e predicted observed radius B = translateSupport B (u : G) := by
  have hnz : ∀ i, recohSupportProbe (bank i) B ≠ 0 := by
    intro i hz
    have h := hamplitude i
    rw [hz, norm_zero] at h
    norm_num at h
  have hrec : recohIndexedRecoverTranslation e
      (fun i => recohRationalSignSame (predicted B i) (observed i) radius) = u := by
    apply recoh_indexed_boolean_recovery_eq_translation bank e hcoord B hnz u
    intro i
    have hactual : recohSupportProbe (bank i) (translateSupport B (u : G)) =
        (if e u i = 0 then recohSupportProbe (bank i) B else -recohSupportProbe (bank i) B) := by
      rw [recoh_support_probe_translate, hcoord u i]
      split_ifs <;> simp
    have hsign := recoh_rational_sign_same_correct
      (recohSupportProbe (bank i) B) (predicted B i) (observed i) radius ε η
      (decide (e u i = 0)) hradius (hamplitude i) (hpred i)
      (by simpa [hactual] using hobs i) hcomplete hunique
    rw [hsign, hactual]
    by_cases hbit : e u i = 0
    · simp [hbit]
    · have hneg : -recohSupportProbe (bank i) B ≠ recohSupportProbe (bank i) B :=
        fun h => hnz i (CharZero.neg_eq_self_iff.mp h)
      simp [hbit, hneg]
  unfold recohNoisyRecoverSupport recohIndexedRecoverSupport
  rw [hrec]

/-- Any true support represented by the list survives the candidate
generation stage under the stated measurement and prediction budgets. -/
theorem recoh_noisy_recovered_candidates_complete
    (representatives : Finset (Finset G)) (bank : J → AddChar G ℂ)
    (e : H₂ ≃+ (J → ZMod 2))
    (hcoord : ∀ (u : H₂) (i : J), bank i (u : G) = if e u i = 0 then 1 else -1)
    (predicted : Finset G → J → RecohRationalComplex)
    (observed : J → RecohRationalComplex) (radius : ℚ) (ε η : ℝ)
    (hradius : 0 ≤ radius) (B : Finset G) (hB : B ∈ representatives) (u : H₂)
    (hamplitude : ∀ i, 1 ≤ ‖recohSupportProbe (bank i) B‖)
    (hpred : ∀ i, ‖recohRationalComplexValue (predicted B i) -
      recohSupportProbe (bank i) B‖ ≤ η)
    (hobs : ∀ i, ‖recohRationalComplexValue (observed i) -
      recohSupportProbe (bank i) (translateSupport B (u : G))‖ ≤ ε)
    (hcomplete : ε + η ≤ (radius : ℝ))
    (hunique : ε + ((radius : ℝ) + η) < 2) :
    translateSupport B (u : G) ∈
      recohNoisyRecoveredCandidates representatives e predicted observed radius := by
  apply Finset.mem_image.mpr
  exact ⟨B, hB, recoh_noisy_recover_support_eq bank e hcoord predicted observed
    radius ε η hradius B u hamplitude hpred hobs hcomplete hunique⟩

/-- Recovered candidates stay in the exact square fibre regardless of
the observations, because recovery always translates by two-torsion. -/
theorem recoh_noisy_recovered_candidates_square_sound [Fintype G]
    (S : Finset G) (representatives : Finset (Finset G))
    (hrepresentatives : representatives ⊆ squareFibre S)
    (e : H₂ ≃+ (J → ZMod 2))
    (predicted : Finset G → J → RecohRationalComplex)
    (observed : J → RecohRationalComplex) (radius : ℚ) :
    recohNoisyRecoveredCandidates representatives e predicted observed radius ⊆ squareFibre S := by
  intro T hT
  obtain ⟨B, hB, rfl⟩ := Finset.mem_image.mp hT
  obtain ⟨hBcard, hBsq⟩ := (mem_squareFibre S B).mp (hrepresentatives hB)
  let u := recohIndexedRecoverTranslation e
    (fun i => recohRationalSignSame (predicted B i) (observed i) radius)
  have hu : (u : G) + (u : G) = 0 := by
    simpa only [recoh_mem_torsion_subgroup, two_nsmul] using u.property
  change translateSupport B (u : G) ∈ squareFibre S
  apply (mem_squareFibre S _).mpr
  refine ⟨by rw [translateSupport_card]; exact hBcard, ?_⟩
  intro z
  exact (hBsq z).trans (orderedSquare_translate_of_card_three B hBcard (u : G) z hu).symm

/-- The complete executable decoder: generate one translation per supplied
representative, deduplicate, then check every full-bank reading using exact
rational squared-distance comparisons.  `index` selects the binary slots. -/
def recohNoisySignDecoder {I : Type*} [Fintype I]
    (representatives : Finset (Finset G)) (e : H₂ ≃+ (J → ZMod 2))
    (index : J → I) (predicted : Finset G → I → RecohRationalComplex)
    (observed : I → RecohRationalComplex) (radius : ℚ) : Finset (Finset G) :=
  recohRationalNoisyDecoder
    (recohNoisyRecoveredCandidates representatives e
      (fun B j => predicted B (index j)) (fun j => observed (index j)) radius)
    predicted observed radius

theorem recoh_noisy_sign_decoder_card_le_representatives {I : Type*} [Fintype I]
    (representatives : Finset (Finset G)) (e : H₂ ≃+ (J → ZMod 2))
    (index : J → I) (predicted : Finset G → I → RecohRationalComplex)
    (observed : I → RecohRationalComplex) (radius : ℚ) :
    (recohNoisySignDecoder representatives e index predicted observed radius).card ≤
      representatives.card := by
  unfold recohNoisySignDecoder recohRationalNoisyDecoder
  apply le_trans (Finset.card_le_card (Finset.filter_subset _ _))
  exact recoh_noisy_recovered_candidates_card_le representatives e _ _ radius

/-- Uniqueness of the actual finite decoder, including arbitrary noisy
inputs for which no support is accepted. -/
theorem recoh_noisy_sign_decoder_card_le_one [Fintype G]
    {I : Type*} [Fintype I]
    (bank : I → AddChar G ℂ) (S : Finset G) (representatives : Finset (Finset G))
    (hrepresentatives : representatives ⊆ squareFibre S)
    (e : H₂ ≃+ (J → ZMod 2)) (index : J → I)
    (predicted : Finset G → I → RecohRationalComplex)
    (observed : I → RecohRationalComplex) (radius : ℚ) (η : ℝ)
    (hsep : RecohProbeSeparated bank (squareFibre S) 2)
    (hpred : ∀ T ∈ squareFibre S, ∀ i,
      ‖recohRationalComplexValue (predicted T i) - recohSupportProbe (bank i) T‖ ≤ η)
    (hbudget : 2 * ((radius : ℝ) + η) < 2) :
    (recohNoisySignDecoder representatives e index predicted observed radius).card ≤ 1 := by
  let candidates := recohNoisyRecoveredCandidates representatives e
    (fun B j => predicted B (index j)) (fun j => observed (index j)) radius
  have hsubset : candidates ⊆ squareFibre S :=
    recoh_noisy_recovered_candidates_square_sound S representatives hrepresentatives e _ _ radius
  apply recoh_rational_noisy_decoder_card_le_one
    (fun T i => recohSupportProbe (bank i) T) candidates predicted observed radius η 2
  · intro B hB C hC hBC
    exact hsep B (hsubset hB) C (hsubset hC) hBC
  · intro T hT i
    exact hpred T (hsubset hT) i
  · exact hbudget

/-- End-to-end singleton contract from a covering list of representatives.
The proof includes noisy sign recovery, exact square preservation, the
rational final filter, and the strict total error budget. -/
theorem recoh_noisy_sign_decoder_singleton [Fintype G]
    {I : Type*} [Fintype I]
    (bank : I → AddChar G ℂ) (S : Finset G) (representatives : Finset (Finset G))
    (hrepresentatives : representatives ⊆ squareFibre S)
    (hcover : ∃ B ∈ representatives, OrdinaryPartner B S)
    (e : H₂ ≃+ (J → ZMod 2)) (index : J → I)
    (hcoord : ∀ (u : H₂) (j : J), bank (index j) (u : G) = if e u j = 0 then 1 else -1)
    (predicted : Finset G → I → RecohRationalComplex)
    (observed : I → RecohRationalComplex) (radius : ℚ) (ε η : ℝ)
    (hradius : 0 ≤ radius) (hη : 0 ≤ η)
    (hsep : RecohProbeSeparated bank (squareFibre S) 2)
    (hamplitude : ∀ B ∈ representatives, ∀ j, 1 ≤ ‖recohSupportProbe (bank (index j)) B‖)
    (hpred : ∀ T ∈ squareFibre S, ∀ i,
      ‖recohRationalComplexValue (predicted T i) - recohSupportProbe (bank i) T‖ ≤ η)
    (hobs : ∀ i, ‖recohRationalComplexValue (observed i) - recohSupportProbe (bank i) S‖ ≤ ε)
    (hcomplete : ε + η ≤ (radius : ℝ))
    (hunique : 2 * ((radius : ℝ) + η) < 2) :
    recohNoisySignDecoder representatives e index predicted observed radius = {S} := by
  let candidates := recohNoisyRecoveredCandidates representatives e
    (fun B j => predicted B (index j)) (fun j => observed (index j)) radius
  have hsubset : candidates ⊆ squareFibre S :=
    recoh_noisy_recovered_candidates_square_sound S representatives hrepresentatives e _ _ radius
  have hSmem : S ∈ candidates := by
    obtain ⟨B, hB, u, hu, hS⟩ := hcover
    let u2 : H₂ := ⟨u, by simpa only [recoh_mem_torsion_subgroup, two_nsmul] using hu⟩
    have hmem := recoh_noisy_recovered_candidates_complete representatives
      (fun j => bank (index j)) e hcoord
      (fun B j => predicted B (index j)) (fun j => observed (index j)) radius ε η
      hradius B hB u2 (hamplitude B hB)
      (fun j => hpred B (hrepresentatives hB) (index j))
      (fun j => by simpa [u2, ← hS] using hobs (index j)) hcomplete
      (by linarith)
    simpa [candidates, u2, ← hS] using hmem
  apply recoh_rational_noisy_decoder_singleton
    (fun T i => recohSupportProbe (bank i) T) candidates predicted observed
    radius ε η 2 hradius S hSmem
  · intro B hB C hC hBC
    exact hsep B (hsubset hB) C (hsubset hC) hBC
  · intro T hT i
    exact hpred T (hsubset hT) i
  · exact hobs
  · exact hcomplete
  · exact hunique

end Couret.STROBO2TORS

#print axioms Couret.STROBO2TORS.recoh_rational_sign_same_iff
#print axioms Couret.STROBO2TORS.recoh_rational_sign_same_correct
#print axioms Couret.STROBO2TORS.recoh_noisy_recovered_candidates_card_le
#print axioms Couret.STROBO2TORS.recoh_noisy_recover_support_eq
#print axioms Couret.STROBO2TORS.recoh_noisy_recovered_candidates_complete
#print axioms Couret.STROBO2TORS.recoh_noisy_recovered_candidates_square_sound
#print axioms Couret.STROBO2TORS.recoh_noisy_sign_decoder_card_le_representatives
#print axioms Couret.STROBO2TORS.recoh_noisy_sign_decoder_card_le_one
#print axioms Couret.STROBO2TORS.recoh_noisy_sign_decoder_singleton
