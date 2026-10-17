import RecohCoefficientDecoder

set_option autoImplicit false

/-!
Move the square test before sign recovery, as in Python `_prepare_square`.

The generic prepared decoder filters the chosen representatives before
recovery and retains the complete final checker after recovery.  The two
orders give the same answer whenever a final acceptance implies acceptance
of the representative by the precheck.  For the square test, this implication
follows from invariance under every two-torsion translation, for all finite
supports.  The resulting coefficient backend is therefore equal to the
previously certified backend, under the same support-coverage contract.

This module certifies an order of mathematical operations.  It does not
certify the separate Python cache, parser, or runtime.
-/

namespace Couret.STROBO2TORS

variable {G : Type*} [AddCommGroup G] [DecidableEq G]

/-- Feasible edge sets whose chosen representative passes the early test. -/
def recohPreparedEdgeSets (U : Finset G) (half : G → Option G)
    (precheck : Finset G → Bool) : Finset (Finset G) :=
  (recohFeasibleEdgeSets U half).filter
    (fun E => precheck (recohEdgeRepresentative half E) = true)

/-- Recover only representatives retained by the early test. -/
def recohPreparedFastCandidates (U : Finset G) (half : G → Option G)
    (recover : Finset G → Finset G) (precheck : Finset G → Bool) :
    Finset (Finset G) :=
  (recohPreparedEdgeSets U half precheck).image
    (fun E => recover (recohEdgeRepresentative half E))

/-- Early representative filtering followed by recovery and the full final
check.  The decoder still constructs at most one support per edge set. -/
def recohPreparedFastDecoder (U : Finset G) (half : G → Option G)
    (recover : Finset G → Finset G) (precheck check : Finset G → Bool) :
    Finset (Finset G) :=
  (recohPreparedFastCandidates U half recover precheck).filter
    (fun S => check S = true)

/-- The early test loses no accepted support if every final acceptance
already implies that the associated representative passes the early test. -/
theorem recoh_prepared_fast_decoder_eq_checked
    (U : Finset G) (half : G → Option G) (recover : Finset G → Finset G)
    (precheck check : Finset G → Bool)
    (hpre : ∀ B, check (recover B) = true → precheck B = true) :
    recohPreparedFastDecoder U half recover precheck check =
      recohCheckedFastDecoder U half recover check := by
  ext S
  simp only [recohPreparedFastDecoder, recohPreparedFastCandidates,
    recohPreparedEdgeSets, recohCheckedFastDecoder, recohFastCandidates,
    Finset.mem_filter, Finset.mem_image]
  constructor
  · rintro ⟨⟨E, ⟨hE, _⟩, hrec⟩, hcheck⟩
    exact ⟨⟨E, hE, hrec⟩, hcheck⟩
  · rintro ⟨⟨E, hE, hrec⟩, hcheck⟩
    refine ⟨⟨E, ⟨hE, hpre _ ?_⟩, hrec⟩, hcheck⟩
    rwa [hrec]

theorem recoh_prepared_edge_sets_card_le_twenty
    (U : Finset G) (half : G → Option G) (precheck : Finset G → Bool)
    (hU : U.card ≤ 6) : (recohPreparedEdgeSets U half precheck).card ≤ 20 := by
  exact (Finset.card_filter_le _ _).trans
    (recoh_feasible_edge_sets_card_le_twenty U half hU)

theorem recoh_prepared_fast_candidates_card_le_twenty
    (U : Finset G) (half : G → Option G) (recover : Finset G → Finset G)
    (precheck : Finset G → Bool) (hU : U.card ≤ 6) :
    (recohPreparedFastCandidates U half recover precheck).card ≤ 20 := by
  exact Finset.card_image_le.trans
    (recoh_prepared_edge_sets_card_le_twenty U half precheck hU)

theorem recoh_prepared_fast_decoder_card_le_twenty
    (U : Finset G) (half : G → Option G) (recover : Finset G → Finset G)
    (precheck check : Finset G → Bool) (hU : U.card ≤ 6) :
    (recohPreparedFastDecoder U half recover precheck check).card ≤ 20 := by
  exact (Finset.card_filter_le _ _).trans
    (recoh_prepared_fast_candidates_card_le_twenty U half recover precheck hU)

/-- Translating any finite support by two-torsion preserves its full
ordered square, without any cardinality-three assumption. -/
theorem recoh_ordered_square_two_torsion_translate (B : Finset G) (u : G)
    (hu : u + u = 0) : orderedSquare (translateSupport B u) = orderedSquare B := by
  funext z
  have hinj : ∀ x ∈ B, ∀ y ∈ B, (fun a : G => a + u) x =
      (fun a : G => a + u) y → x = y :=
    fun _ _ _ _ h => add_right_cancel h
  unfold orderedSquare translateSupport
  rw [Finset.sum_image hinj]
  apply Finset.sum_congr rfl
  intro x _
  rw [Finset.sum_image hinj]
  apply Finset.sum_congr rfl
  intro y _
  rw [pair_sum_translate x y u hu]

/-- An invariant square and an exact final square requirement discharge
the early sparse-square condition. -/
theorem recoh_prepared_square_decoder_eq_checked
    (U : Finset G) (R : G → ℕ) (half : G → Option G)
    (recover : Finset G → Finset G) (check : Finset G → Bool)
    (hR : ∀ z, R z ≠ 0 → z ∈ U)
    (hinvariant : ∀ B, orderedSquare (recover B) = orderedSquare B)
    (hcheck : ∀ S, check S = true → orderedSquare S = R) :
    recohPreparedFastDecoder U half recover (fun B => recohSparseSquareCheck U B R)
        check = recohCheckedFastDecoder U half recover check := by
  apply recoh_prepared_fast_decoder_eq_checked
  intro B hB
  apply (recoh_sparse_square_check_iff U B R hR).mpr
  exact (hinvariant B).symm.trans (hcheck _ hB)

variable {J : Type*}

local notation "H₂" => recohTorsionSubgroup (G := G) 2

/-- Boolean sign recovery always translates by an element of G[2], even
when the supplied observations will ultimately be rejected. -/
theorem recoh_indexed_recover_support_square
    (e : H₂ ≃+ (J → ZMod 2)) (same : Finset G → J → Bool) (B : Finset G) :
    orderedSquare (recohIndexedRecoverSupport e same B) = orderedSquare B := by
  apply recoh_ordered_square_two_torsion_translate
  simpa only [recoh_mem_torsion_subgroup, two_nsmul] using
    (recohIndexedRecoverTranslation e (same B)).property

/-- For indexed sign recovery, the early square test is redundant with
the final checker whenever that checker enforces the square. -/
theorem recoh_prepared_indexed_square_decoder_eq_checked
    (U : Finset G) (R : G → ℕ) (half : G → Option G)
    (e : H₂ ≃+ (J → ZMod 2)) (same : Finset G → J → Bool)
    (check : Finset G → Bool) (hR : ∀ z, R z ≠ 0 → z ∈ U)
    (hcheck : ∀ S, check S = true → orderedSquare S = R) :
    recohPreparedFastDecoder U half (recohIndexedRecoverSupport e same)
        (fun B => recohSparseSquareCheck U B R) check =
      recohCheckedFastDecoder U half (recohIndexedRecoverSupport e same) check := by
  exact recoh_prepared_square_decoder_eq_checked U R half _ check hR
    (recoh_indexed_recover_support_square e same) hcheck

variable {I : Type*} [Fintype I]

/-- The coefficient decoder with the square checked before recovery, and
with the complete observation checked again after recovery. -/
def recohPreparedCoefficientBackendDecoder
    (U : Finset G) (R : G → ℕ) (half : G → Option G)
    (index : J → I) (e : H₂ ≃+ (J → ZMod 2))
    (p k : I → ℕ) (enc : I → Finset G → List ℕ)
    (obsTerms : I → RecohSparseTerms) : Finset (Finset G) :=
  recohPreparedFastDecoder U half
    (recohIndexedRecoverSupport e (recohCoefficientSignBools index p k enc obsTerms))
    (fun B => recohSparseSquareCheck U B R)
    (recohCoefficientObservationCheck U R p k enc obsTerms)

/-- The early-square backend is equal to the previous coefficient backend.
This order-of-filters theorem needs no primary-character or encoding
contracts beyond support coverage of the square. -/
theorem recoh_prepared_coefficient_backend_decoder_eq_backend
    (U : Finset G) (R : G → ℕ) (half : G → Option G)
    (index : J → I) (e : H₂ ≃+ (J → ZMod 2))
    (p k : I → ℕ) (enc : I → Finset G → List ℕ)
    (obsTerms : I → RecohSparseTerms) (hR : ∀ z, R z ≠ 0 → z ∈ U) :
    recohPreparedCoefficientBackendDecoder U R half index e p k enc obsTerms =
      recohCoefficientBackendDecoder U R half index e p k enc obsTerms := by
  apply recoh_prepared_indexed_square_decoder_eq_checked U R half e _ _ hR
  intro S hS
  rw [recohCoefficientObservationCheck, Bool.and_eq_true] at hS
  exact (recoh_sparse_square_check_iff U S R hR).mp hS.1

theorem recoh_prepared_coefficient_backend_decoder_card_le_twenty
    (U : Finset G) (R : G → ℕ) (half : G → Option G)
    (index : J → I) (e : H₂ ≃+ (J → ZMod 2))
    (p k : I → ℕ) (enc : I → Finset G → List ℕ)
    (obsTerms : I → RecohSparseTerms) (hU : U.card ≤ 6) :
    (recohPreparedCoefficientBackendDecoder U R half index e p k enc obsTerms).card ≤ 20 :=
  recoh_prepared_fast_decoder_card_le_twenty U half _ _ _ hU

end Couret.STROBO2TORS

#print axioms Couret.STROBO2TORS.recoh_prepared_fast_decoder_eq_checked
#print axioms Couret.STROBO2TORS.recoh_prepared_edge_sets_card_le_twenty
#print axioms Couret.STROBO2TORS.recoh_prepared_fast_candidates_card_le_twenty
#print axioms Couret.STROBO2TORS.recoh_prepared_fast_decoder_card_le_twenty
#print axioms Couret.STROBO2TORS.recoh_ordered_square_two_torsion_translate
#print axioms Couret.STROBO2TORS.recoh_prepared_square_decoder_eq_checked
#print axioms Couret.STROBO2TORS.recoh_indexed_recover_support_square
#print axioms Couret.STROBO2TORS.recoh_prepared_indexed_square_decoder_eq_checked
#print axioms Couret.STROBO2TORS.recoh_prepared_coefficient_backend_decoder_eq_backend
#print axioms Couret.STROBO2TORS.recoh_prepared_coefficient_backend_decoder_card_le_twenty
