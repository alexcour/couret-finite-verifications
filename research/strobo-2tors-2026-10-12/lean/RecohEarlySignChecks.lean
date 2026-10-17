import RecohPreparedDecoder

set_option autoImplicit false

/-!
Early rejection of incompatible binary and ternary readings.

The bank index is J ⊕ K.  The intended cyclic bank uses prime two on J and
prime three on K.  The executable tests retain the supplied prime parameters;
their correctness uses explicit primary-representation contracts and the two
roles on G[2]: signs on J, trivial character values on K.

Binary observations must equal the representative reading or its negative;
ternary observations must equal the representative reading.  These are exact
integer-coefficient comparisons.  A final accepted recovered support always
passes these early tests, without nonvanishing or cardinality assumptions.
Combining them with the early square check therefore preserves the answer of
the full coefficient backend.  This proves an order of typed mathematical
operations, not the external Python parser, cache, or runtime.
-/

namespace Couret.STROBO2TORS

variable {G J K : Type*} [AddCommGroup G] [DecidableEq G]
variable [Fintype J] [Fintype K]

local notation "H₂" => recohTorsionSubgroup (G := G) 2

/-- The binary block accepts the base reading or its negative.  The
ternary block accepts exactly the base reading. -/
def recohEarlyReadingsCheck (p k : J ⊕ K → ℕ)
    (enc : J ⊕ K → Finset G → List ℕ) (obsTerms : J ⊕ K → RecohSparseTerms)
    (B : Finset G) : Bool :=
  decide (∀ j : J,
    recohCoefficientMatch (p (Sum.inl j)) (k (Sum.inl j))
      (enc (Sum.inl j) B) (obsTerms (Sum.inl j)) = true ∨
    recohCoefficientMatchNeg (p (Sum.inl j)) (k (Sum.inl j))
      (enc (Sum.inl j) B) (obsTerms (Sum.inl j)) = true) &&
  decide (∀ j : K,
    recohCoefficientMatch (p (Sum.inr j)) (k (Sum.inr j))
      (enc (Sum.inr j) B) (obsTerms (Sum.inr j)) = true)

omit [DecidableEq G] in
/-- Exact semantics of the two early reading tests. -/
theorem recoh_early_readings_check_iff
    (p k : J ⊕ K → ℕ) (enc : J ⊕ K → Finset G → List ℕ)
    (obsTerms : J ⊕ K → RecohSparseTerms) (B : Finset G)
    (bank : J ⊕ K → AddChar G ℂ) (ζ obs : J ⊕ K → ℂ)
    (hp : ∀ i, (p i).Prime)
    (hζ : ∀ i, IsPrimitiveRoot (ζ i) ((p i) ^ (k i + 1)))
    (hred : ∀ i, RecohCoefficientsReduced (p i) (k i) (obsTerms i))
    (henc : ∀ i, ((enc i B).map ((ζ i) ^ ·)).sum = recohSupportProbe (bank i) B)
    (hobs : ∀ i, recohCoefficientValue (ζ i) (obsTerms i) = obs i) :
    recohEarlyReadingsCheck p k enc obsTerms B = true ↔
      (∀ j : J, obs (Sum.inl j) = recohSupportProbe (bank (Sum.inl j)) B ∨
        obs (Sum.inl j) = -recohSupportProbe (bank (Sum.inl j)) B) ∧
      (∀ j : K, obs (Sum.inr j) = recohSupportProbe (bank (Sum.inr j)) B) := by
  have hpos (i : J ⊕ K) :
      recohCoefficientMatch (p i) (k i) (enc i B) (obsTerms i) = true ↔
        obs i = recohSupportProbe (bank i) B := by
    rw [recoh_coefficient_match_iff (hp i) (k i) (hζ i) _ _ (hred i), henc, hobs]
    exact eq_comm
  have hneg (i : J ⊕ K) :
      recohCoefficientMatchNeg (p i) (k i) (enc i B) (obsTerms i) = true ↔
        obs i = -recohSupportProbe (bank i) B := by
    rw [recoh_coefficient_match_neg_iff (hp i) (k i) (hζ i) _ _ (hred i), henc, hobs]
    exact eq_comm
  simp only [recohEarlyReadingsCheck, Bool.and_eq_true, decide_eq_true_eq, hpos, hneg]

/-- Any observation coming from a two-torsion translate satisfies the
early reading tests.  No reading is assumed nonzero. -/
theorem recoh_early_readings_of_translated_observation
    (p k : J ⊕ K → ℕ) (enc : J ⊕ K → Finset G → List ℕ)
    (obsTerms : J ⊕ K → RecohSparseTerms)
    (bank : J ⊕ K → AddChar G ℂ) (ζ obs : J ⊕ K → ℂ)
    (e : H₂ ≃+ (J → ZMod 2))
    (hp : ∀ i, (p i).Prime)
    (hζ : ∀ i, IsPrimitiveRoot (ζ i) ((p i) ^ (k i + 1)))
    (hred : ∀ i, RecohCoefficientsReduced (p i) (k i) (obsTerms i))
    (B : Finset G)
    (henc : ∀ i, ((enc i B).map ((ζ i) ^ ·)).sum = recohSupportProbe (bank i) B)
    (hobs : ∀ i, recohCoefficientValue (ζ i) (obsTerms i) = obs i)
    (hcoord : ∀ (u : H₂) (j : J),
      bank (Sum.inl j) (u : G) = if e u j = 0 then 1 else -1)
    (hternary : ∀ (u : H₂) (j : K), bank (Sum.inr j) (u : G) = 1)
    (u : H₂)
    (hreadings : ∀ i, recohSupportProbe (bank i) (translateSupport B (u : G)) = obs i) :
    recohEarlyReadingsCheck p k enc obsTerms B = true := by
  apply (recoh_early_readings_check_iff p k enc obsTerms B bank ζ obs
    hp hζ hred henc hobs).mpr
  constructor
  · intro j
    have h := hreadings (Sum.inl j)
    rw [recoh_support_probe_translate, hcoord] at h
    by_cases hbit : e u j = 0
    · exact Or.inl (by simpa only [if_pos hbit, one_mul] using h.symm)
    · exact Or.inr (by simpa only [if_neg hbit, neg_one_mul] using h.symm)
  · intro j
    have h := hreadings (Sum.inr j)
    rw [recoh_support_probe_translate, hternary, one_mul] at h
    exact h.symm

/-- Final acceptance after any indexed recovery implies that the early
reading test accepts the original representative.  The equality-bit function
may be arbitrary: neither its correctness nor nonvanishing is needed here. -/
theorem recoh_early_readings_of_final_check
    (U : Finset G) (R : G → ℕ)
    (p k : J ⊕ K → ℕ) (enc : J ⊕ K → Finset G → List ℕ)
    (obsTerms : J ⊕ K → RecohSparseTerms)
    (bank : J ⊕ K → AddChar G ℂ) (ζ obs : J ⊕ K → ℂ)
    (e : H₂ ≃+ (J → ZMod 2)) (same : Finset G → J → Bool)
    (hp : ∀ i, (p i).Prime)
    (hζ : ∀ i, IsPrimitiveRoot (ζ i) ((p i) ^ (k i + 1)))
    (hred : ∀ i, RecohCoefficientsReduced (p i) (k i) (obsTerms i))
    (henc : ∀ i S, ((enc i S).map ((ζ i) ^ ·)).sum = recohSupportProbe (bank i) S)
    (hobs : ∀ i, recohCoefficientValue (ζ i) (obsTerms i) = obs i)
    (hcoord : ∀ (u : H₂) (j : J),
      bank (Sum.inl j) (u : G) = if e u j = 0 then 1 else -1)
    (hternary : ∀ (u : H₂) (j : K), bank (Sum.inr j) (u : G) = 1)
    (B : Finset G)
    (hfinal : recohCoefficientObservationCheck U R p k enc obsTerms
      (recohIndexedRecoverSupport e same B) = true) :
    recohEarlyReadingsCheck p k enc obsTerms B = true := by
  rw [recohCoefficientObservationCheck, Bool.and_eq_true] at hfinal
  have hreadings := (recoh_coefficient_readings_check_iff p k enc obsTerms
    (recohIndexedRecoverSupport e same B) bank ζ obs hp hζ hred
    (fun i => henc i _) hobs).mp hfinal.2
  apply recoh_early_readings_of_translated_observation p k enc obsTerms bank ζ obs e
    hp hζ hred B (fun i => henc i B) hobs hcoord hternary
    (recohIndexedRecoverTranslation e (same B))
  intro i
  exact congrFun hreadings i

/-- Square and reading checks performed on the representative, before
constructing its recovered translation. -/
def recohEarlyCandidateCheck (U : Finset G) (R : G → ℕ)
    (p k : J ⊕ K → ℕ) (enc : J ⊕ K → Finset G → List ℕ)
    (obsTerms : J ⊕ K → RecohSparseTerms) (B : Finset G) : Bool :=
  recohSparseSquareCheck U B R && recohEarlyReadingsCheck p k enc obsTerms B

/-- Typed control flow with early square, binary-sign and ternary tests,
followed by direct recovery and the independent full final check. -/
def recohEarlyCoefficientBackendDecoder
    (U : Finset G) (R : G → ℕ) (half : G → Option G)
    (e : H₂ ≃+ (J → ZMod 2)) (p k : J ⊕ K → ℕ)
    (enc : J ⊕ K → Finset G → List ℕ) (obsTerms : J ⊕ K → RecohSparseTerms) :
    Finset (Finset G) :=
  recohPreparedFastDecoder U half
    (recohIndexedRecoverSupport e (recohCoefficientSignBools Sum.inl p k enc obsTerms))
    (recohEarlyCandidateCheck U R p k enc obsTerms)
    (recohCoefficientObservationCheck U R p k enc obsTerms)

/-- The early-rejection control flow accepts exactly the same supports
as the full coefficient backend.  The role contracts, rather than a
nonvanishing hypothesis, justify these necessary early conditions. -/
theorem recoh_early_coefficient_backend_decoder_eq_backend
    (U : Finset G) (R : G → ℕ) (half : G → Option G)
    (e : H₂ ≃+ (J → ZMod 2)) (p k : J ⊕ K → ℕ)
    (enc : J ⊕ K → Finset G → List ℕ) (obsTerms : J ⊕ K → RecohSparseTerms)
    (bank : J ⊕ K → AddChar G ℂ) (ζ obs : J ⊕ K → ℂ)
    (hR : ∀ z, R z ≠ 0 → z ∈ U)
    (hp : ∀ i, (p i).Prime)
    (hζ : ∀ i, IsPrimitiveRoot (ζ i) ((p i) ^ (k i + 1)))
    (hred : ∀ i, RecohCoefficientsReduced (p i) (k i) (obsTerms i))
    (henc : ∀ i S, ((enc i S).map ((ζ i) ^ ·)).sum = recohSupportProbe (bank i) S)
    (hobs : ∀ i, recohCoefficientValue (ζ i) (obsTerms i) = obs i)
    (hcoord : ∀ (u : H₂) (j : J),
      bank (Sum.inl j) (u : G) = if e u j = 0 then 1 else -1)
    (hternary : ∀ (u : H₂) (j : K), bank (Sum.inr j) (u : G) = 1) :
    recohEarlyCoefficientBackendDecoder U R half e p k enc obsTerms =
      recohCoefficientBackendDecoder U R half Sum.inl e p k enc obsTerms := by
  apply recoh_prepared_fast_decoder_eq_checked
  intro B hB
  rw [recohEarlyCandidateCheck, Bool.and_eq_true]
  constructor
  · have hsquare := hB
    rw [recohCoefficientObservationCheck, Bool.and_eq_true] at hsquare
    apply (recoh_sparse_square_check_iff U B R hR).mpr
    exact (recoh_indexed_recover_support_square e _ B).symm.trans
      ((recoh_sparse_square_check_iff U _ R hR).mp hsquare.1)
  · exact recoh_early_readings_of_final_check U R p k enc obsTerms bank ζ obs e _
      hp hζ hred henc hobs hcoord hternary B hB

theorem recoh_early_coefficient_backend_decoder_card_le_twenty
    (U : Finset G) (R : G → ℕ) (half : G → Option G)
    (e : H₂ ≃+ (J → ZMod 2)) (p k : J ⊕ K → ℕ)
    (enc : J ⊕ K → Finset G → List ℕ) (obsTerms : J ⊕ K → RecohSparseTerms)
    (hU : U.card ≤ 6) :
    (recohEarlyCoefficientBackendDecoder U R half e p k enc obsTerms).card ≤ 20 :=
  recoh_prepared_fast_decoder_card_le_twenty U half _ _ _ hU

end Couret.STROBO2TORS

#print axioms Couret.STROBO2TORS.recoh_early_readings_check_iff
#print axioms Couret.STROBO2TORS.recoh_early_readings_of_translated_observation
#print axioms Couret.STROBO2TORS.recoh_early_readings_of_final_check
#print axioms Couret.STROBO2TORS.recoh_early_coefficient_backend_decoder_eq_backend
#print axioms Couret.STROBO2TORS.recoh_early_coefficient_backend_decoder_card_le_twenty
