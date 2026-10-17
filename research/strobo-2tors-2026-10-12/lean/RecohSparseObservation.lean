import RecohCyclotomicNormalization
import RecohCandidateDecoder

set_option autoImplicit false

/-!
Executable sparse checking of a full RECOH observation.

The ordered square is checked only on the supplied support of the observed
square together with sums of pairs in the proposed support.  Character
readings are checked by the certified integer-term comparator.  Neither
checker enumerates the ambient group or requires `Fintype G`.

The encodings of proposed and observed readings are input data.  Their
interpretation contracts, the primary orders, primitive roots and support
coverage are explicit hypotheses of correctness.  This module does not
certify a parser or construct those encodings from complex numbers.
-/

namespace Couret.STROBO2TORS

open scoped BigOperators

variable {G : Type*} [AddCommGroup G] [DecidableEq G]

/-- All group elements at which a proposed support can have a nonzero
ordered-square coefficient; no ambient enumeration is used. -/
def recohPairSumPositions (S : Finset G) : Finset G :=
  (S ×ˢ S).image (fun xy => xy.1 + xy.2)

theorem recoh_ordered_square_zero_outside_pair_sums (S : Finset G) (z : G)
    (hz : z ∉ recohPairSumPositions S) : orderedSquare S z = 0 := by
  unfold orderedSquare
  apply Finset.sum_eq_zero
  intro x hx
  apply Finset.sum_eq_zero
  intro y hy
  have hne : x + y ≠ z := by
    intro he
    exact hz (Finset.mem_image.mpr
      ⟨(x, y), Finset.mem_product.mpr ⟨hx, hy⟩, he⟩)
  simp only [if_neg hne]

/-- An executable bounded decision on the union of observed and proposed
square positions.  The supplied function `R` is evaluated only there. -/
def recohSparseSquareCheck (U S : Finset G) (R : G → ℕ) : Bool :=
  decide (∀ z ∈ U ∪ recohPairSumPositions S, orderedSquare S z = R z)

/-- Under the explicit support-coverage contract, the sparse test is
equivalent to equality of the full ordered-square functions. -/
theorem recoh_sparse_square_check_iff (U S : Finset G) (R : G → ℕ)
    (hR : ∀ z, R z ≠ 0 → z ∈ U) :
    recohSparseSquareCheck U S R = true ↔ orderedSquare S = R := by
  simp only [recohSparseSquareCheck, decide_eq_true_eq]
  constructor
  · intro h
    funext z
    by_cases hz : z ∈ U ∪ recohPairSumPositions S
    · exact h z hz
    · have hpair : z ∉ recohPairSumPositions S := by
        intro hm
        exact hz (Finset.mem_union.mpr (Or.inr hm))
      have hrzero : R z = 0 := by
        by_contra hr
        exact hz (Finset.mem_union.mpr (Or.inl (hR z hr)))
      rw [recoh_ordered_square_zero_outside_pair_sums S z hpair, hrzero]
  · intro h z _
    exact congrFun h z

/-- All readings are checked by bounded quantification over the finite bank
index.  Its runtime data contain natural exponents, not complex numbers. -/
def recohSparseReadingsCheck {m : ℕ} (p k : Fin m → ℕ)
    (enc : Fin m → Finset G → List ℕ) (obsExp : Fin m → List ℕ)
    (S : Finset G) : Bool :=
  decide (∀ i : Fin m, recohSparseEqual
    (recohReducedTerms (p i) (k i) (enc i S))
    (recohReducedTerms (p i) (k i) (obsExp i)) = true)

omit [DecidableEq G] in
/-- Exactness of the reading test with explicit interpretation contracts
for both the proposed support and the observed readings. -/
theorem recoh_sparse_readings_check_iff {m : ℕ} (p k : Fin m → ℕ)
    (enc : Fin m → Finset G → List ℕ) (obsExp : Fin m → List ℕ)
    (S : Finset G) (bank : Fin m → AddChar G ℂ) (ζ obs : Fin m → ℂ)
    (hp : ∀ i, (p i).Prime)
    (hζ : ∀ i, IsPrimitiveRoot (ζ i) ((p i) ^ (k i + 1)))
    (henc : ∀ i, ((enc i S).map (ζ i ^ ·)).sum = recohSupportProbe (bank i) S)
    (hobs : ∀ i, ((obsExp i).map (ζ i ^ ·)).sum = obs i) :
    recohSparseReadingsCheck p k enc obsExp S = true ↔
      (fun i => recohSupportProbe (bank i) S) = obs := by
  simp only [recohSparseReadingsCheck, decide_eq_true_eq]
  constructor
  · intro h
    funext i
    have hi := (recoh_normalized_sparse_equal_iff (hp i) (k i) (hζ i)
      (enc i S) (obsExp i)).mp (h i)
    simpa only [henc i, hobs i] using hi
  · intro h i
    apply (recoh_normalized_sparse_equal_iff (hp i) (k i) (hζ i)
      (enc i S) (obsExp i)).mpr
    rw [henc i, hobs i]
    exact congrFun h i

/-- Executable complete observation test.  Only the finite supports, the
group operations, natural coefficients and exponent encodings are used. -/
def recohSparseObservationCheck {m : ℕ} (U : Finset G) (R : G → ℕ)
    (p k : Fin m → ℕ) (enc : Fin m → Finset G → List ℕ)
    (obsExp : Fin m → List ℕ) (S : Finset G) : Bool :=
  recohSparseSquareCheck U S R && recohSparseReadingsCheck p k enc obsExp S

/-- The sparse executable checker is exactly the full labelled observation
filter.  It neither assumes finiteness of the ambient group nor certifies
the separately supplied encoding and support-coverage contracts. -/
theorem recoh_sparse_observation_check_iff {m : ℕ} (U : Finset G) (R : G → ℕ)
    (p k : Fin m → ℕ) (enc : Fin m → Finset G → List ℕ)
    (obsExp : Fin m → List ℕ) (S : Finset G)
    (bank : Fin m → AddChar G ℂ) (ζ obs : Fin m → ℂ)
    (hR : ∀ z, R z ≠ 0 → z ∈ U)
    (hp : ∀ i, (p i).Prime)
    (hζ : ∀ i, IsPrimitiveRoot (ζ i) ((p i) ^ (k i + 1)))
    (henc : ∀ i, ((enc i S).map (ζ i ^ ·)).sum = recohSupportProbe (bank i) S)
    (hobs : ∀ i, ((obsExp i).map (ζ i ^ ·)).sum = obs i) :
    recohSparseObservationCheck U R p k enc obsExp S = true ↔
      recohObservation bank S = (R, obs) := by
  rw [recohSparseObservationCheck, Bool.and_eq_true,
    recoh_sparse_square_check_iff U S R hR,
    recoh_sparse_readings_check_iff p k enc obsExp S bank ζ obs hp hζ henc hobs]
  simp only [recohObservation, Prod.mk.injEq]

#print axioms recoh_ordered_square_zero_outside_pair_sums
#print axioms recoh_sparse_square_check_iff
#print axioms recoh_sparse_readings_check_iff
#print axioms recoh_sparse_observation_check_iff

end Couret.STROBO2TORS
