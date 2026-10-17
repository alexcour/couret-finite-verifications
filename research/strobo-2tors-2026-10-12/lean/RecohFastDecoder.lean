import RecohDecoderBounds
import RecohCyclicHalves
import RecohSignRecovery

set_option autoImplicit false

/-!
One-representative RECOH decoder on an explicitly supplied finite support.

The construction visits only the three-element subsets of U.  A supplied
doubling solver chooses one half-sum for each feasible edge set, and a
translation-recovery function turns the corresponding representative into
one candidate.  The final filter uses the complete labelled observation.
No enumeration of the ambient group or its two-torsion subgroup occurs in
these definitions.  Their construction needs no Fintype instance on G.

The refinement theorem proves equality with recohExactDecoder, provided U
covers the observed square support and the half-sum and recovery contracts
hold.  Sign recovery supplies the recovery contract for binary coordinates
inside any larger labelled character bank.  Complex equality remains
noncomputable here: this is a Lean refinement of the mathematical decoder,
not a verification of the external Python parser or arithmetic runtime.
-/

namespace Couret.STROBO2TORS

open scoped BigOperators

variable {G : Type*} [AddCommGroup G] [DecidableEq G]

/-- Only edge sets whose total has a half-sum are retained. -/
def recohFeasibleEdgeSets (U : Finset G) (half : G → Option G) : Finset (Finset G) :=
  (U.powersetCard 3).filter (fun E => (half (E.sum id)).isSome)

/-- One representative for an edge set.  The default is ignored by the
decoder because infeasible edge sets have already been removed. -/
def recohEdgeRepresentative (half : G → Option G) (E : Finset G) : Finset G :=
  recohEdgeDecode E ((half (E.sum id)).getD 0)

/-- One recovered support per feasible edge set, with duplicate supports
identified by the finite-set image. -/
def recohFastCandidates (U : Finset G) (half : G → Option G)
    (recover : Finset G → Finset G) : Finset (Finset G) :=
  (recohFeasibleEdgeSets U half).image
    (fun E => recover (recohEdgeRepresentative half E))

/-- Complete observation filtering after the one-representative construction. -/
noncomputable def recohFastDecoder {I : Type*}
    (U : Finset G) (half : G → Option G) (recover : Finset G → Finset G)
    (bank : I → AddChar G ℂ) (obs : (G → ℕ) × (I → ℂ)) : Finset (Finset G) := by
  classical
  exact (recohFastCandidates U half recover).filter
    (fun S => recohObservation bank S = obs)

/-- Executable filtering interface: an exact arithmetic backend supplies
the Boolean checker, independently of the mathematical complex filter. -/
def recohCheckedFastDecoder
    (U : Finset G) (half : G → Option G) (recover : Finset G → Finset G)
    (check : Finset G → Bool) : Finset (Finset G) :=
  (recohFastCandidates U half recover).filter (fun S => check S = true)

/-- Recovery preserves triple cardinality and reconstructs every
two-torsion translate compatible with the target observation. -/
def RecohTranslationRecoverySpec {I : Type*}
    (bank : I → AddChar G ℂ) (obs : (G → ℕ) × (I → ℂ))
    (recover : Finset G → Finset G) : Prop :=
  (∀ B : Finset G, B.card = 3 → (recover B).card = 3) ∧
  (∀ B : Finset G, B.card = 3 → ∀ u : G, u + u = 0 →
    recohObservation bank (translateSupport B u) = obs →
      recover B = translateSupport B u)

omit [DecidableEq G] in
@[simp]
theorem recoh_mem_feasible_edge_sets (U E : Finset G) (half : G → Option G) :
    E ∈ recohFeasibleEdgeSets U half ↔
      E ⊆ U ∧ E.card = 3 ∧ (half (E.sum id)).isSome := by
  simp [recohFeasibleEdgeSets, and_assoc]

theorem recoh_edge_representative_card (half : G → Option G) (E : Finset G) :
    (recohEdgeRepresentative half E).card = E.card :=
  recoh_edge_decode_card E _

/-- Changing the chosen half-sum translates the reflected edge set by
the difference of the two half-sums.  The identity holds for every edge set. -/
theorem recoh_edge_decode_change_half (E : Finset G) (sigma sigma0 : G) :
    recohEdgeDecode E sigma =
      translateSupport (recohEdgeDecode E sigma0) (sigma - sigma0) := by
  unfold recohEdgeDecode translateSupport
  rw [Finset.image_image]
  apply Finset.image_congr
  intro e _
  change sigma - e = (sigma0 - e) + (sigma - sigma0)
  abel

theorem recoh_mem_fast_candidates_iff
    (U : Finset G) (half : G → Option G) (recover : Finset G → Finset G)
    (S : Finset G) :
    S ∈ recohFastCandidates U half recover ↔
      ∃ E : Finset G, E ⊆ U ∧ E.card = 3 ∧ (half (E.sum id)).isSome ∧
        recover (recohEdgeRepresentative half E) = S := by
  simp [recohFastCandidates, and_assoc]

theorem recoh_fast_candidates_card_three
    (U : Finset G) (half : G → Option G) (recover : Finset G → Finset G)
    (hcard : ∀ B : Finset G, B.card = 3 → (recover B).card = 3)
    (S : Finset G) (hS : S ∈ recohFastCandidates U half recover) : S.card = 3 := by
  obtain ⟨E, _, hE, _, rfl⟩ := (recoh_mem_fast_candidates_iff U half recover S).mp hS
  apply hcard
  rw [recoh_edge_representative_card, hE]

omit [AddCommGroup G] [DecidableEq G] in
/-- The twenty-set bound depends only on the supplied sparse support. -/
theorem recoh_sparse_edge_sets_card_le_twenty (U : Finset G) (hU : U.card ≤ 6) :
    (U.powersetCard 3).card ≤ 20 := by
  rw [Finset.card_powersetCard]
  calc
    U.card.choose 3 ≤ Nat.choose 6 3 := Nat.choose_le_choose 3 hU
    _ = 20 := by decide

omit [DecidableEq G] in
/-- There are at most twenty representatives before recovery. -/
theorem recoh_feasible_edge_sets_card_le_twenty
    (U : Finset G) (half : G → Option G) (hU : U.card ≤ 6) :
    (recohFeasibleEdgeSets U half).card ≤ 20 := by
  exact (Finset.card_filter_le _ _).trans (recoh_sparse_edge_sets_card_le_twenty U hU)

theorem recoh_fast_candidates_card_le
    (U : Finset G) (half : G → Option G) (recover : Finset G → Finset G) :
    (recohFastCandidates U half recover).card ≤ (U.powersetCard 3).card := by
  exact Finset.card_image_le.trans (Finset.card_filter_le _ _)

/-- The number of recovered candidates is at most twenty, independently
of the cardinality of the ambient group and of its two-torsion subgroup. -/
theorem recoh_fast_candidates_card_le_twenty
    (U : Finset G) (half : G → Option G) (recover : Finset G → Finset G)
    (hU : U.card ≤ 6) : (recohFastCandidates U half recover).card ≤ 20 := by
  exact (recoh_fast_candidates_card_le U half recover).trans
    (recoh_sparse_edge_sets_card_le_twenty U hU)

theorem recoh_fast_decoder_card_le_twenty {I : Type*}
    (U : Finset G) (half : G → Option G) (recover : Finset G → Finset G)
    (bank : I → AddChar G ℂ) (obs : (G → ℕ) × (I → ℂ))
    (hU : U.card ≤ 6) : (recohFastDecoder U half recover bank obs).card ≤ 20 := by
  classical
  exact (Finset.card_filter_le _ _).trans
    (recoh_fast_candidates_card_le_twenty U half recover hU)

/-- The Boolean-checker variant has the same unconditional candidate bound. -/
theorem recoh_checked_fast_decoder_card_le_twenty
    (U : Finset G) (half : G → Option G) (recover : Finset G → Finset G)
    (check : Finset G → Bool) (hU : U.card ≤ 6) :
    (recohCheckedFastDecoder U half recover check).card ≤ 20 := by
  exact (Finset.card_filter_le _ _).trans
    (recoh_fast_candidates_card_le_twenty U half recover hU)

/-- A correct Boolean checker gives exactly the mathematical complex filter. -/
theorem recoh_checked_fast_decoder_eq_fast {I : Type*}
    (U : Finset G) (half : G → Option G) (recover : Finset G → Finset G)
    (check : Finset G → Bool) (bank : I → AddChar G ℂ)
    (obs : (G → ℕ) × (I → ℂ))
    (hcheck : ∀ S : Finset G, check S = true ↔ recohObservation bank S = obs) :
    recohCheckedFastDecoder U half recover check =
      recohFastDecoder U half recover bank obs := by
  classical
  ext S
  simp only [recohCheckedFastDecoder, recohFastDecoder, Finset.mem_filter, hcheck]

section FiniteRefinement

variable [Fintype G]

/-- Every valid triple is recovered from the single chosen half-sum of
its true edge set.  The difference from the true half-sum belongs to G[2]. -/
theorem recoh_fast_candidates_complete {I : Type*}
    (U : Finset G) (half : G → Option G) (recover : Finset G → Finset G)
    (bank : I → AddChar G ℂ) (obs : (G → ℕ) × (I → ℂ))
    (hhalf : RecohHalfSolverSpec half)
    (hrecover : RecohTranslationRecoverySpec bank obs recover)
    (hU : recohSquareSupport obs.1 ⊆ U)
    (S : Finset G) (hS : S.card = 3) (hobs : recohObservation bank S = obs) :
    S ∈ recohFastCandidates U half recover := by
  obtain ⟨E, sigma, hE, hcard, hsigma, hdecode⟩ :=
    (recoh_mem_candidates_iff (orderedSquare S) S).mp (recoh_candidates_complete S hS)
  have hR : orderedSquare S = obs.1 := congrArg Prod.fst hobs
  rw [hR] at hE
  obtain ⟨sigma0, hsigma0⟩ := hhalf.2 (E.sum id) ⟨sigma, hsigma⟩
  have hdouble0 : sigma0 + sigma0 = E.sum id := hhalf.1 _ _ hsigma0
  have hu : (sigma - sigma0) + (sigma - sigma0) = 0 :=
    (double_eq_iff_two_torsion sigma0 sigma).mp (hdouble0.trans hsigma.symm)
  have hB : (recohEdgeDecode E sigma0).card = 3 := by
    rw [recoh_edge_decode_card, hcard]
  have hshift : translateSupport (recohEdgeDecode E sigma0) (sigma - sigma0) = S :=
    (recoh_edge_decode_change_half E sigma sigma0).symm.trans hdecode
  have hrec := hrecover.2 (recohEdgeDecode E sigma0) hB (sigma - sigma0) hu
    (by simpa only [hshift] using hobs)
  apply (recoh_mem_fast_candidates_iff U half recover S).mpr
  refine ⟨E, hE.trans hU, hcard, ?_, ?_⟩
  · simp only [hsigma0, Option.isSome_some]
  · change recover (recohEdgeDecode E ((half (E.sum id)).getD 0)) = S
    rw [hsigma0]
    exact hrec.trans hshift

/-- The fast decoder accepts exactly the three-element supports with
the supplied complete observation. -/
theorem recoh_mem_fast_decoder_iff {I : Type*}
    (U : Finset G) (half : G → Option G) (recover : Finset G → Finset G)
    (bank : I → AddChar G ℂ) (obs : (G → ℕ) × (I → ℂ))
    (hhalf : RecohHalfSolverSpec half)
    (hrecover : RecohTranslationRecoverySpec bank obs recover)
    (hU : recohSquareSupport obs.1 ⊆ U) (S : Finset G) :
    S ∈ recohFastDecoder U half recover bank obs ↔
      S.card = 3 ∧ recohObservation bank S = obs := by
  classical
  simp only [recohFastDecoder, Finset.mem_filter]
  constructor
  · rintro ⟨hS, hobs⟩
    exact ⟨recoh_fast_candidates_card_three U half recover hrecover.1 S hS, hobs⟩
  · rintro ⟨hS, hobs⟩
    exact ⟨recoh_fast_candidates_complete U half recover bank obs hhalf hrecover hU
      S hS hobs, hobs⟩

/-- Formal refinement: one representative plus recovery has exactly
the same result as the complete candidate specification. -/
theorem recoh_fast_decoder_eq_exact {I : Type*}
    (U : Finset G) (half : G → Option G) (recover : Finset G → Finset G)
    (bank : I → AddChar G ℂ) (obs : (G → ℕ) × (I → ℂ))
    (hhalf : RecohHalfSolverSpec half)
    (hrecover : RecohTranslationRecoverySpec bank obs recover)
    (hU : recohSquareSupport obs.1 ⊆ U) :
    recohFastDecoder U half recover bank obs = recohExactDecoder bank obs := by
  ext S
  rw [recoh_mem_fast_decoder_iff U half recover bank obs hhalf hrecover hU,
    recoh_mem_exact_decoder_iff]

/-- A verified exact-arithmetic Boolean backend preserves the full
refinement theorem without changing the candidate construction. -/
theorem recoh_checked_fast_decoder_eq_exact {I : Type*}
    (U : Finset G) (half : G → Option G) (recover : Finset G → Finset G)
    (check : Finset G → Bool) (bank : I → AddChar G ℂ)
    (obs : (G → ℕ) × (I → ℂ))
    (hhalf : RecohHalfSolverSpec half)
    (hrecover : RecohTranslationRecoverySpec bank obs recover)
    (hU : recohSquareSupport obs.1 ⊆ U)
    (hcheck : ∀ S : Finset G, check S = true ↔ recohObservation bank S = obs) :
    recohCheckedFastDecoder U half recover check = recohExactDecoder bank obs := by
  rw [recoh_checked_fast_decoder_eq_fast U half recover check bank obs hcheck]
  exact recoh_fast_decoder_eq_exact U half recover bank obs hhalf hrecover hU

end FiniteRefinement

variable {r : ℕ}

local notation "H₂" => recohTorsionSubgroup (G := G) 2

/-- Recover a support by comparing binary readings and translating by
the explicitly recovered two-torsion coordinate vector. -/
noncomputable def recohSignRecoverSupport
    (bank : Fin r → AddChar G ℂ) (e : H₂ ≃+ (Fin r → ZMod 2))
    (obs : Fin r → ℂ) (B : Finset G) : Finset G :=
  translateSupport B
    (recohRecoverTranslation e (fun i => recohSupportProbe (bank i) B) obs : G)

theorem recoh_sign_recover_support_card
    (bank : Fin r → AddChar G ℂ) (e : H₂ ≃+ (Fin r → ZMod 2))
    (obs : Fin r → ℂ) (B : Finset G) :
    (recohSignRecoverSupport bank e obs B).card = B.card :=
  translateSupport_card B _

theorem recoh_sign_recover_support_of_readings
    (bank : Fin r → AddChar G ℂ) (e : H₂ ≃+ (Fin r → ZMod 2))
    (hcoord : ∀ (u : H₂) (i : Fin r),
      bank i (u : G) = if e u i = 0 then 1 else -1)
    (B : Finset G) (hnonzero : ∀ i, recohSupportProbe (bank i) B ≠ 0)
    (u : H₂) (obs : Fin r → ℂ)
    (hobs : ∀ i, recohSupportProbe (bank i) (translateSupport B (u : G)) = obs i) :
    recohSignRecoverSupport bank e obs B = translateSupport B (u : G) := by
  have hfun : obs =
      (fun i => recohSupportProbe (bank i) (translateSupport B (u : G))) :=
    funext (fun i => (hobs i).symm)
  unfold recohSignRecoverSupport
  rw [hfun, recoh_recover_translation_eq bank e hcoord B hnonzero u]

/-- Binary coordinates may occur at any specified indices of the full
labelled bank.  Their sign recovery satisfies the generic recovery contract;
all remaining readings are retained in the decoder's final exact filter. -/
theorem recoh_sign_recovery_spec {I : Type*}
    (bank : I → AddChar G ℂ) (obs : (G → ℕ) × (I → ℂ))
    (index : Fin r → I) (e : H₂ ≃+ (Fin r → ZMod 2))
    (hcoord : ∀ (u : H₂) (i : Fin r),
      bank (index i) (u : G) = if e u i = 0 then 1 else -1)
    (hnonzero : ∀ i (B : Finset G), B.card = 3 →
      recohSupportProbe (bank (index i)) B ≠ 0) :
    RecohTranslationRecoverySpec bank obs
      (recohSignRecoverSupport (fun i => bank (index i)) e (fun i => obs.2 (index i))) := by
  constructor
  · intro B hB
    rw [recoh_sign_recover_support_card, hB]
  · intro B hB u hu hobs
    let u2 : H₂ := ⟨u, by simpa only [recoh_mem_torsion_subgroup, two_nsmul] using hu⟩
    apply recoh_sign_recover_support_of_readings (fun i => bank (index i)) e hcoord B
      (fun i => hnonzero i B hB) u2 (fun i => obs.2 (index i))
    intro i
    exact congrFun (congrArg Prod.snd hobs) (index i)

/-- The sign-based one-representative decoder refines the exact decoder
for a bank with compatible, nonvanishing binary coordinates. -/
theorem recoh_sign_fast_decoder_eq_exact [Fintype G] {I : Type*}
    (U : Finset G) (half : G → Option G)
    (bank : I → AddChar G ℂ) (obs : (G → ℕ) × (I → ℂ))
    (index : Fin r → I) (e : H₂ ≃+ (Fin r → ZMod 2))
    (hhalf : RecohHalfSolverSpec half)
    (hcoord : ∀ (u : H₂) (i : Fin r),
      bank (index i) (u : G) = if e u i = 0 then 1 else -1)
    (hnonzero : ∀ i (B : Finset G), B.card = 3 →
      recohSupportProbe (bank (index i)) B ≠ 0)
    (hU : recohSquareSupport obs.1 ⊆ U) :
    recohFastDecoder U half
      (recohSignRecoverSupport (fun i => bank (index i)) e (fun i => obs.2 (index i)))
      bank obs = recohExactDecoder bank obs := by
  exact recoh_fast_decoder_eq_exact U half _ bank obs hhalf
    (recoh_sign_recovery_spec bank obs index e hcoord hnonzero) hU

end Couret.STROBO2TORS

#print axioms Couret.STROBO2TORS.recoh_mem_feasible_edge_sets
#print axioms Couret.STROBO2TORS.recoh_edge_representative_card
#print axioms Couret.STROBO2TORS.recoh_edge_decode_change_half
#print axioms Couret.STROBO2TORS.recoh_mem_fast_candidates_iff
#print axioms Couret.STROBO2TORS.recoh_fast_candidates_card_three
#print axioms Couret.STROBO2TORS.recoh_sparse_edge_sets_card_le_twenty
#print axioms Couret.STROBO2TORS.recoh_feasible_edge_sets_card_le_twenty
#print axioms Couret.STROBO2TORS.recoh_fast_candidates_card_le
#print axioms Couret.STROBO2TORS.recoh_fast_candidates_card_le_twenty
#print axioms Couret.STROBO2TORS.recoh_fast_decoder_card_le_twenty
#print axioms Couret.STROBO2TORS.recoh_checked_fast_decoder_card_le_twenty
#print axioms Couret.STROBO2TORS.recoh_checked_fast_decoder_eq_fast
#print axioms Couret.STROBO2TORS.recoh_fast_candidates_complete
#print axioms Couret.STROBO2TORS.recoh_mem_fast_decoder_iff
#print axioms Couret.STROBO2TORS.recoh_fast_decoder_eq_exact
#print axioms Couret.STROBO2TORS.recoh_checked_fast_decoder_eq_exact
#print axioms Couret.STROBO2TORS.recoh_sign_recover_support_card
#print axioms Couret.STROBO2TORS.recoh_sign_recover_support_of_readings
#print axioms Couret.STROBO2TORS.recoh_sign_recovery_spec
#print axioms Couret.STROBO2TORS.recoh_sign_fast_decoder_eq_exact
