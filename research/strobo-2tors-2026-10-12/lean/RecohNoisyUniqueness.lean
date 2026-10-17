import RecohProbeStability
import RecohRationalComplex
import Mathlib.Tactic.Positivity

set_option autoImplicit false

/-!
Noise tolerance with explicit prediction error.  The executable decoder
below compares rational squared distances.  Its correctness theorem relates
those comparisons to the complex readings, accounting separately for the
measurement error, the prediction error, and the acceptance radius.

The candidate set is supplied explicitly.  Completeness requires the true
support to occur in that set; this module makes no ambient enumeration claim.
-/

namespace Couret.STROBO2TORS

/-- Two candidates inside coordinatewise error balls whose radii sum to
less than the bank separation must coincide. -/
theorem recoh_noisy_reading_unique {X I : Type*}
    (reading : X → I → ℂ) (candidates : Finset X) (δ : ℝ)
    (hsep : RecohReadingSeparated reading candidates δ)
    (observed : I → ℂ) (S T : X) (hS : S ∈ candidates) (hT : T ∈ candidates)
    (εS εT : ℝ) (hbudget : εS + εT < δ)
    (hSerr : ∀ i, ‖observed i - reading S i‖ ≤ εS)
    (hTerr : ∀ i, ‖observed i - reading T i‖ ≤ εT) : S = T := by
  by_contra hST
  obtain ⟨i, hi⟩ := hsep S hS T hT hST
  have hbound : ‖reading S i - reading T i‖ ≤ εS + εT := by
    calc
      ‖reading S i - reading T i‖ =
          ‖(reading S i - observed i) + (observed i - reading T i)‖ := by
        congr 1
        ring
      _ ≤ ‖reading S i - observed i‖ + ‖observed i - reading T i‖ := norm_add_le _ _
      _ ≤ εS + εT := add_le_add (by simpa only [norm_sub_rev] using hSerr i) (hTerr i)
  exact (not_lt_of_ge (hi.trans hbound)) hbudget

/-- Approximate predictions consume part of the geometric error budget. -/
theorem recoh_noisy_prediction_sound (truth prediction observed : ℂ)
    (η τ : ℝ) (hpred : ‖prediction - truth‖ ≤ η)
    (hfit : ‖observed - prediction‖ ≤ τ) :
    ‖observed - truth‖ ≤ τ + η := by
  calc
    ‖observed - truth‖ = ‖(observed - prediction) + (prediction - truth)‖ := by
      congr 1
      ring
    _ ≤ ‖observed - prediction‖ + ‖prediction - truth‖ := norm_add_le _ _
    _ ≤ τ + η := add_le_add hfit hpred

/-- The sharp open unit-error contract does not require the bank to be
finite or a common error maximum to be attained. -/
theorem recoh_noisy_unit_reading_unique {X I : Type*}
    (reading : X → I → ℂ) (candidates : Finset X)
    (hsep : RecohReadingSeparated reading candidates 2)
    (observed : I → ℂ) (S T : X) (hS : S ∈ candidates) (hT : T ∈ candidates)
    (hSerr : ∀ i, ‖observed i - reading S i‖ < 1)
    (hTerr : ∀ i, ‖observed i - reading T i‖ < 1) : S = T := by
  by_contra hST
  obtain ⟨i, hi⟩ := hsep S hS T hT hST
  have htriangle : ‖reading S i - reading T i‖ ≤
      ‖observed i - reading S i‖ + ‖observed i - reading T i‖ := by
    calc
      ‖reading S i - reading T i‖ =
          ‖(reading S i - observed i) + (observed i - reading T i)‖ := by
        congr 1
        ring
      _ ≤ ‖reading S i - observed i‖ + ‖observed i - reading T i‖ := norm_add_le _ _
      _ = _ := by rw [norm_sub_rev (reading S i) (observed i)]
  linarith [hSerr i, hTerr i]

/-- The planned choice of prediction tolerance leaves a strict uniqueness
budget for every measurement tolerance below one. -/
theorem recoh_noisy_unit_budget (ε : ℝ) (hε : ε < 1) :
    let η := (1 - ε) / 4
    let τ := ε + η
    2 * (τ + η) < 2 := by
  dsimp
  linarith

/-- A finite, executable decoder.  Negative radii reject every candidate.
No equality or order comparison of real or complex numbers is performed. -/
def recohRationalNoisyDecoder {X I : Type*} [DecidableEq X] [Fintype I]
    (candidates : Finset X) (predicted : X → I → RecohRationalComplex)
    (observed : I → RecohRationalComplex) (radius : ℚ) : Finset X :=
  candidates.filter fun S => 0 ≤ radius ∧
    ∀ i, recohRationalSquaredDistance (observed i) (predicted S i) ≤ radius ^ 2

theorem recoh_mem_rational_noisy_decoder_iff {X I : Type*}
    [DecidableEq X] [Fintype I]
    (candidates : Finset X) (predicted : X → I → RecohRationalComplex)
    (observed : I → RecohRationalComplex) (radius : ℚ) (S : X) :
    S ∈ recohRationalNoisyDecoder candidates predicted observed radius ↔
      S ∈ candidates ∧ 0 ≤ radius ∧
        ∀ i, ‖recohRationalComplexValue (observed i) -
          recohRationalComplexValue (predicted S i)‖ ≤ (radius : ℝ) := by
  rw [recohRationalNoisyDecoder, Finset.mem_filter]
  constructor
  · rintro ⟨hS, hr, h⟩
    exact ⟨hS, hr, fun i => (recoh_rational_ball_iff _ _ radius hr).mp (h i)⟩
  · rintro ⟨hS, hr, h⟩
    exact ⟨hS, hr, fun i => (recoh_rational_ball_iff _ _ radius hr).mpr (h i)⟩

/-- Every accepted rational candidate is within radius plus prediction
error of the exact complex reading. -/
theorem recoh_rational_noisy_decoder_sound {X I : Type*}
    [DecidableEq X] [Fintype I]
    (reading : X → I → ℂ) (candidates : Finset X)
    (predicted : X → I → RecohRationalComplex)
    (observed : I → RecohRationalComplex) (radius : ℚ) (η : ℝ)
    (hpred : ∀ S ∈ candidates, ∀ i,
      ‖recohRationalComplexValue (predicted S i) - reading S i‖ ≤ η)
    (S : X) (hS : S ∈ recohRationalNoisyDecoder candidates predicted observed radius) :
    ∀ i, ‖recohRationalComplexValue (observed i) - reading S i‖ ≤ (radius : ℝ) + η := by
  obtain ⟨hSmem, _, hfit⟩ :=
    (recoh_mem_rational_noisy_decoder_iff candidates predicted observed radius S).mp hS
  intro i
  exact recoh_noisy_prediction_sound _ _ _ η (radius : ℝ) (hpred S hSmem i) (hfit i)

/-- The rational decoder has at most one result under the full error
budget, including prediction approximation. -/
theorem recoh_rational_noisy_decoder_card_le_one {X I : Type*}
    [DecidableEq X] [Fintype I]
    (reading : X → I → ℂ) (candidates : Finset X)
    (predicted : X → I → RecohRationalComplex)
    (observed : I → RecohRationalComplex) (radius : ℚ) (η δ : ℝ)
    (hsep : RecohReadingSeparated reading candidates δ)
    (hpred : ∀ S ∈ candidates, ∀ i,
      ‖recohRationalComplexValue (predicted S i) - reading S i‖ ≤ η)
    (hbudget : 2 * ((radius : ℝ) + η) < δ) :
    (recohRationalNoisyDecoder candidates predicted observed radius).card ≤ 1 := by
  apply Finset.card_le_one.mpr
  intro S hS T hT
  have hSmem := ((recoh_mem_rational_noisy_decoder_iff candidates predicted observed radius S).mp hS).1
  have hTmem := ((recoh_mem_rational_noisy_decoder_iff candidates predicted observed radius T).mp hT).1
  apply recoh_noisy_reading_unique reading candidates δ hsep
    (fun i => recohRationalComplexValue (observed i)) S T hSmem hTmem
    ((radius : ℝ) + η) ((radius : ℝ) + η) (by linarith)
  · exact recoh_rational_noisy_decoder_sound reading candidates predicted observed radius η hpred S hS
  · exact recoh_rational_noisy_decoder_sound reading candidates predicted observed radius η hpred T hT

/-- Completeness requires both an included true candidate and enough
acceptance radius for measurement error plus prediction error. -/
theorem recoh_rational_noisy_decoder_complete {X I : Type*}
    [DecidableEq X] [Fintype I]
    (reading : X → I → ℂ) (candidates : Finset X)
    (predicted : X → I → RecohRationalComplex)
    (observed : I → RecohRationalComplex) (radius : ℚ) (ε η : ℝ)
    (hradius : 0 ≤ radius) (S : X) (hS : S ∈ candidates)
    (hpred : ∀ i, ‖recohRationalComplexValue (predicted S i) - reading S i‖ ≤ η)
    (hobs : ∀ i, ‖recohRationalComplexValue (observed i) - reading S i‖ ≤ ε)
    (hbudget : ε + η ≤ (radius : ℝ)) :
    S ∈ recohRationalNoisyDecoder candidates predicted observed radius := by
  apply (recoh_mem_rational_noisy_decoder_iff candidates predicted observed radius S).mpr
  refine ⟨hS, hradius, ?_⟩
  intro i
  apply le_trans ?_ hbudget
  exact recoh_noisy_prediction_sound _ _ _ η ε
    (by simpa only [norm_sub_rev] using hpred i) (hobs i)

/-- With a true included candidate, soundness and the strict separation
budget strengthen the output contract from at-most-one to exactly-one. -/
theorem recoh_rational_noisy_decoder_singleton {X I : Type*}
    [DecidableEq X] [Fintype I]
    (reading : X → I → ℂ) (candidates : Finset X)
    (predicted : X → I → RecohRationalComplex)
    (observed : I → RecohRationalComplex) (radius : ℚ) (ε η δ : ℝ)
    (hradius : 0 ≤ radius) (S : X) (hS : S ∈ candidates)
    (hsep : RecohReadingSeparated reading candidates δ)
    (hpred : ∀ T ∈ candidates, ∀ i,
      ‖recohRationalComplexValue (predicted T i) - reading T i‖ ≤ η)
    (hobs : ∀ i, ‖recohRationalComplexValue (observed i) - reading S i‖ ≤ ε)
    (hcomplete : ε + η ≤ (radius : ℝ))
    (hunique : 2 * ((radius : ℝ) + η) < δ) :
    recohRationalNoisyDecoder candidates predicted observed radius = {S} := by
  have hmem := recoh_rational_noisy_decoder_complete reading candidates predicted observed
    radius ε η hradius S hS (hpred S hS) hobs hcomplete
  have hcard := recoh_rational_noisy_decoder_card_le_one reading candidates predicted observed
    radius η δ hsep hpred hunique
  ext T
  constructor
  · intro hT
    exact Finset.mem_singleton.mpr (Finset.card_le_one.mp hcard T hT S hmem)
  · intro hT
    simpa only [Finset.mem_singleton.mp hT] using hmem

/-- The midpoint of readings separated by at most two lies in both
closed unit balls; the strict error threshold cannot be relaxed. -/
theorem recoh_midpoint_unit_balls (z w : ℂ) (h : ‖z - w‖ ≤ 2) :
    ‖(z + w) / 2 - z‖ ≤ 1 ∧ ‖(z + w) / 2 - w‖ ≤ 1 := by
  have hz : (z + w) / 2 - z = (w - z) / 2 := by ring
  have hw : (z + w) / 2 - w = (z - w) / 2 := by ring
  have htwo : ‖(2 : ℂ)‖ = (2 : ℝ) := by norm_num
  constructor
  · rw [hz, norm_div, htwo, norm_sub_rev]
    linarith
  · rw [hw, norm_div, htwo]
    linarith

/-- The explicit C4 collision gives ambiguity at error at most one for
every bank, including banks with more than the minimum number of slots. -/
theorem recoh_stability_c4_midpoint_ambiguous
    {I : Type*} (bank : I → AddChar (ZMod 4) ℂ) :
    ∃ observed : I → ℂ, ∀ i,
      ‖observed i - recohSupportProbe (bank i) recohStabilityC4Left‖ ≤ 1 ∧
      ‖observed i - recohSupportProbe (bank i) recohStabilityC4Right‖ ≤ 1 := by
  refine ⟨fun i => (recohSupportProbe (bank i) recohStabilityC4Left +
    recohSupportProbe (bank i) recohStabilityC4Right) / 2, ?_⟩
  intro i
  exact recoh_midpoint_unit_balls _ _ (recoh_stability_c4_probe_upper (bank i))

end Couret.STROBO2TORS

#print axioms Couret.STROBO2TORS.recoh_noisy_reading_unique
#print axioms Couret.STROBO2TORS.recoh_noisy_prediction_sound
#print axioms Couret.STROBO2TORS.recoh_noisy_unit_reading_unique
#print axioms Couret.STROBO2TORS.recoh_noisy_unit_budget
#print axioms Couret.STROBO2TORS.recoh_mem_rational_noisy_decoder_iff
#print axioms Couret.STROBO2TORS.recoh_rational_noisy_decoder_sound
#print axioms Couret.STROBO2TORS.recoh_rational_noisy_decoder_card_le_one
#print axioms Couret.STROBO2TORS.recoh_rational_noisy_decoder_complete
#print axioms Couret.STROBO2TORS.recoh_rational_noisy_decoder_singleton
#print axioms Couret.STROBO2TORS.recoh_midpoint_unit_balls
#print axioms Couret.STROBO2TORS.recoh_stability_c4_midpoint_ambiguous
