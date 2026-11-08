module

public import MembershipDecisionTree

@[expose] public section

set_option autoImplicit false
namespace Couret.InterIA.Fibres
open Finset Couret.InterIA.Parity

/-- Full reconstruction, with all probes fixed before the unknown member is supplied. -/
theorem cyclic_four_fixed_reconstruction (n : ℕ) (hn : 0 < n)
    (S : Finset (ZMod n)) (hS : S.card=4) :
    ∃ d : ℕ, d ≤ 2 ∧ (cyclicFourFibre n S).ncard=2^d ∧
      ∃ (q : Fin d → ZMod n) (decode : (Fin d → Bool) → Finset (ZMod n)),
        Function.Bijective (fun T : cyclicFourFibre n S => probeAnswers q T.val) ∧
        ∀ T ∈ cyclicFourFibre n S, decode (probeAnswers q T)=T := by
  obtain ⟨d,hd,hcard,q,hq⟩ := cyclic_four_fixed_probes n hn S hS
  exact ⟨d,hd,hcard,q,probeDecode (cyclicFourFibre n S) q ∅,
    probeAnswers_bijective _ q hcard hq,fun T hT => probeDecode_correct _ q ∅ hq T hT⟩

/-- Equality with the genuine affine dimension, not an auxiliary cardinal code. -/
theorem fixed_probe_count_eq_finrank (n : ℕ) (hn : 0 < n)
    (S : Finset (ZMod n)) (hS : S.card=4) (d : ℕ)
    (hd : (cyclicFourFibre n S).ncard=2^d) :
    d=Module.finrank (ZMod 2) (cyclicFibreAffine n hn S hS).direction := by
  have he := cyclic_four_fibre_card_pow_finrank n hn S hS
  rw [hd] at he
  by_contra h
  rcases lt_or_gt_of_ne h with hlt|hgt
  · have ht := Nat.pow_lt_pow_right (by omega : 1 < 2) hlt
    omega
  · have ht := Nat.pow_lt_pow_right (by omega : 1 < 2) hgt
    omega

/-- The upper and lower bounds hold in the same explicit adaptive decision-tree model. -/
theorem cyclic_four_optimal_reconstruction (n : ℕ) (hn : 0 < n)
    (S : Finset (ZMod n)) (hS : S.card=4) :
    ∃ d : ℕ, d ≤ 2 ∧
      d=Module.finrank (ZMod 2) (cyclicFibreAffine n hn S hS).direction ∧
      (cyclicFourFibre n S).ncard=2^d ∧
      (∃ (q : Fin d → ZMod n) (decode : (Fin d → Bool) → Finset (ZMod n)),
        Function.Bijective (fun T : cyclicFourFibre n S => probeAnswers q T.val) ∧
        (∀ T ∈ cyclicFourFibre n S, decode (probeAnswers q T)=T) ∧
        (MembershipTree.fixed d q decode).depth=d ∧
        (MembershipTree.fixed d q decode).CorrectOn (cyclicFourFibre n S)) ∧
      (∀ tree : MembershipTree (ZMod n), tree.CorrectOn (cyclicFourFibre n S) → d ≤ tree.depth) := by
  obtain ⟨d,hd,hcard,q,decode,hbij,hdecode⟩ := cyclic_four_fixed_reconstruction n hn S hS
  refine ⟨d,hd,fixed_probe_count_eq_finrank n hn S hS d hcard,hcard,?_,?_⟩
  · refine ⟨q,decode,hbij,hdecode,MembershipTree.fixed_depth d q decode,?_⟩
    intro T hT
    rw [MembershipTree.fixed_run]
    exact hdecode T hT
  · intro tree ht
    exact tree.depth_lower_bound _ d hcard ht

end Couret.InterIA.Fibres
