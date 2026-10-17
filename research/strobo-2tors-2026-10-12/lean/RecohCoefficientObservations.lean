import RecohSparseObservation

set_option autoImplicit false

/-!
Exact observation checking from integer cyclotomic coefficients.

Observed readings are supplied directly as lists of pairs `(exponent,
integer coefficient)`.  No conversion from coefficients back to root lists
is used.  Complex values occur only in the interpretation and correctness
theorems; all checkers compare natural numbers and integer coefficients.

The range contract is sufficient for faithful evaluation.  The stronger
typed-format contract also excludes zero coefficients and repeated
exponents, matching the conditions inspected by Python `_read_coefficients`.
It does not certify JSON parsing, Python execution or sorting.
-/

namespace Couret.STROBO2TORS

open Polynomial
open scoped BigOperators

/-- The complex value represented by integer coefficients in the power
basis of a supplied root.  This is semantic, not a runtime computation. -/
noncomputable def recohCoefficientValue (ζ : ℂ) (terms : RecohSparseTerms) : ℂ :=
  (terms.map (fun t => (t.2 : ℂ) * ζ ^ t.1)).sum

/-- Every stored exponent lies strictly below the primary cyclotomic degree.
Repeated exponents and zero coefficients do not invalidate this contract. -/
def RecohCoefficientsReduced (p k : ℕ) (terms : RecohSparseTerms) : Prop :=
  ∀ t ∈ terms, t.1 < (p - 1) * p ^ k

/-- Conditions on already typed coefficient terms corresponding to the
range, nonzero and nonrepetition checks in `_read_coefficients`.  Input order
is arbitrary, as it is in the Python input format. -/
def RecohCoefficientFormat (p k : ℕ) (terms : RecohSparseTerms) : Prop :=
  RecohCoefficientsReduced p k terms ∧
    (terms.map Prod.fst).Nodup ∧ ∀ t ∈ terms, t.2 ≠ 0

/-- Executable validation of the typed coefficient-format conditions. -/
def recohCoefficientFormatCheck (p k : ℕ) (terms : RecohSparseTerms) : Bool := by
  letI : Decidable (RecohCoefficientFormat p k terms) := by
    unfold RecohCoefficientFormat RecohCoefficientsReduced
    infer_instance
  exact decide (RecohCoefficientFormat p k terms)

theorem recoh_coefficient_format_check_iff (p k : ℕ) (terms : RecohSparseTerms) :
    recohCoefficientFormatCheck p k terms = true ↔ RecohCoefficientFormat p k terms := by
  simp only [recohCoefficientFormatCheck, decide_eq_true_eq]

theorem recoh_coefficient_format_reduced (p k : ℕ) (terms : RecohSparseTerms)
    (h : RecohCoefficientFormat p k terms) : RecohCoefficientsReduced p k terms :=
  h.1

/-- Agreement between the explicit weighted sum and polynomial semantics. -/
theorem recoh_terms_polynomial_aeval (ζ : ℂ) (terms : RecohSparseTerms) :
    aeval ζ (recohTermsPolynomial terms) = recohCoefficientValue ζ terms := by
  induction terms with
  | nil => simp [recohTermsPolynomial, recohCoefficientValue]
  | cons t terms ih =>
    simp only [recohTermsPolynomial, map_add, aeval_monomial,
      recohCoefficientValue, List.map_cons, List.sum_cons]
    rw [show aeval ζ (recohTermsPolynomial terms) =
      (terms.map (fun t => (t.2 : ℂ) * ζ ^ t.1)).sum from ih]
    rfl

/-- The exponent-range contract implies the required strict degree bound,
even when coefficients cancel or vanish. -/
theorem recoh_coefficients_degree_lt (p k : ℕ) (terms : RecohSparseTerms)
    (h : RecohCoefficientsReduced p k terms) :
    (recohTermsPolynomial terms).degree < ((p - 1) * p ^ k : ℕ) := by
  revert h
  induction terms with
  | nil =>
    intro _
    simpa only [recohTermsPolynomial, degree_zero] using
      (WithBot.bot_lt_coe ((p - 1) * p ^ k))
  | cons t terms ih =>
    intro h
    have ht : t.1 < (p - 1) * p ^ k := h t (by simp)
    have htail : RecohCoefficientsReduced p k terms := by
      intro u hu
      exact h u (List.mem_cons_of_mem _ hu)
    change (monomial t.1 t.2 + recohTermsPolynomial terms).degree < _
    exact lt_of_le_of_lt (degree_add_le _ _) (max_lt
      (lt_of_le_of_lt (degree_monomial_le t.1 t.2) (WithBot.coe_lt_coe.mpr ht))
      (ih htail))

/-- Every raw monomial emitted by the root normalizer satisfies the exponent
range contract; this assertion does not require canonical coefficient lists. -/
theorem recoh_root_terms_reduced {p : ℕ} (hp : p.Prime) (k e : ℕ) :
    RecohCoefficientsReduced p k (recohRootTerms p k e) := by
  unfold RecohCoefficientsReduced recohRootTerms
  dsimp only
  split_ifs with h
  · intro t ht
    obtain rfl := List.mem_singleton.mp ht
    exact h
  · intro t ht
    obtain ⟨j, hj, rfl⟩ := List.mem_map.mp ht
    change j * p ^ k + e % p ^ (k + 1) % p ^ k < (p - 1) * p ^ k
    have hr := Nat.mod_lt (e % p ^ (k + 1)) (pow_pos hp.pos k)
    calc
      j * p ^ k + e % p ^ (k + 1) % p ^ k < j * p ^ k + p ^ k :=
        Nat.add_lt_add_left hr _
      _ = (j + 1) * p ^ k := by rw [Nat.add_mul, Nat.one_mul]
      _ ≤ (p - 1) * p ^ k :=
        Nat.mul_le_mul_right _ (Nat.succ_le_of_lt (List.mem_range.mp hj))

theorem recoh_reduced_terms_reduced {p : ℕ} (hp : p.Prime) (k : ℕ) (es : List ℕ) :
    RecohCoefficientsReduced p k (recohReducedTerms p k es) := by
  intro t ht
  obtain ⟨e, _, he⟩ := List.mem_flatMap.mp ht
  exact recoh_root_terms_reduced hp k e t he

theorem recoh_reduced_terms_value {p : ℕ} (hp : p.Prime) (k : ℕ)
    {ζ : ℂ} (hζ : IsPrimitiveRoot ζ (p ^ (k + 1))) (es : List ℕ) :
    recohCoefficientValue ζ (recohReducedTerms p k es) = (es.map (ζ ^ ·)).sum := by
  rw [← recoh_terms_polynomial_aeval, recoh_reduced_terms_polynomial]
  exact recoh_root_sum_polynomial_aeval hp k hζ es

/-- Faithfulness of the sparse integer comparator for any two coefficient
lists whose exponents lie in the primary power basis. -/
theorem recoh_reduced_coefficients_equal_iff {p : ℕ} (hp : p.Prime) (k : ℕ)
    {ζ : ℂ} (hζ : IsPrimitiveRoot ζ (p ^ (k + 1))) (xs ys : RecohSparseTerms)
    (hx : RecohCoefficientsReduced p k xs) (hy : RecohCoefficientsReduced p k ys) :
    recohSparseEqual xs ys = true ↔ recohCoefficientValue ζ xs = recohCoefficientValue ζ ys := by
  rw [recoh_sparse_equal_iff]
  have degree_bound (terms : RecohSparseTerms) (ht : RecohCoefficientsReduced p k terms) :
      (recohTermsPolynomial terms).degree < ((p ^ (k + 1)).totient : WithBot ℕ) := by
    simpa only [Nat.totient_prime_pow_succ hp, Nat.mul_comm] using
      recoh_coefficients_degree_lt p k terms ht
  have h := (recoh_cyclotomic_eval_eq_iff (pow_pos hp.pos _) hζ
    (recohTermsPolynomial xs) (recohTermsPolynomial ys)
    (degree_bound xs hx) (degree_bound ys hy)).symm
  simpa only [recoh_terms_polynomial_aeval] using h

/-- Compare a candidate root sum directly to observed integer coefficients. -/
def recohCoefficientMatch (p k : ℕ) (es : List ℕ) (terms : RecohSparseTerms) : Bool :=
  recohSparseEqual (recohReducedTerms p k es) terms

theorem recoh_coefficient_match_iff {p : ℕ} (hp : p.Prime) (k : ℕ)
    {ζ : ℂ} (hζ : IsPrimitiveRoot ζ (p ^ (k + 1)))
    (es : List ℕ) (terms : RecohSparseTerms) (ht : RecohCoefficientsReduced p k terms) :
    recohCoefficientMatch p k es terms = true ↔
      (es.map (ζ ^ ·)).sum = recohCoefficientValue ζ terms := by
  rw [recohCoefficientMatch, recoh_reduced_coefficients_equal_iff hp k hζ _ _
    (recoh_reduced_terms_reduced hp k es) ht, recoh_reduced_terms_value hp k hζ es]

theorem recoh_coefficients_reduced_negate (p k : ℕ) (terms : RecohSparseTerms)
    (ht : RecohCoefficientsReduced p k terms) :
    RecohCoefficientsReduced p k (recohNegateTerms terms) := by
  intro t hmem
  obtain ⟨u, hu, rfl⟩ := List.mem_map.mp hmem
  exact ht u hu

theorem recoh_coefficient_value_negate (ζ : ℂ) (terms : RecohSparseTerms) :
    recohCoefficientValue ζ (recohNegateTerms terms) = -recohCoefficientValue ζ terms := by
  rw [← recoh_terms_polynomial_aeval, recoh_negate_terms_polynomial, map_neg,
    recoh_terms_polynomial_aeval]

/-- Direct integer comparison of the negative candidate reading against the
observed coefficients, for the executable sign-recovery backend. -/
def recohCoefficientMatchNeg (p k : ℕ) (es : List ℕ) (terms : RecohSparseTerms) : Bool :=
  recohSparseEqual (recohNegateTerms (recohReducedTerms p k es)) terms

theorem recoh_coefficient_match_neg_iff {p : ℕ} (hp : p.Prime) (k : ℕ)
    {ζ : ℂ} (hζ : IsPrimitiveRoot ζ (p ^ (k + 1)))
    (es : List ℕ) (terms : RecohSparseTerms) (ht : RecohCoefficientsReduced p k terms) :
    recohCoefficientMatchNeg p k es terms = true ↔
      -(es.map (ζ ^ ·)).sum = recohCoefficientValue ζ terms := by
  rw [recohCoefficientMatchNeg, recoh_reduced_coefficients_equal_iff hp k hζ _ _
    (recoh_coefficients_reduced_negate p k _ (recoh_reduced_terms_reduced hp k es)) ht,
    recoh_coefficient_value_negate, recoh_reduced_terms_value hp k hζ es]

variable {G : Type*} [AddCommGroup G] [DecidableEq G]

/-- Check a finite, arbitrarily indexed bank of observed coefficient lists.
No enumeration of the ambient group and no complex arithmetic occur. -/
def recohCoefficientReadingsCheck {I : Type*} [Fintype I]
    (p k : I → ℕ) (enc : I → Finset G → List ℕ) (obsTerms : I → RecohSparseTerms)
    (S : Finset G) : Bool :=
  decide (∀ i : I, recohCoefficientMatch (p i) (k i) (enc i S) (obsTerms i) = true)

omit [DecidableEq G] in
theorem recoh_coefficient_readings_check_iff {I : Type*} [Fintype I]
    (p k : I → ℕ) (enc : I → Finset G → List ℕ) (obsTerms : I → RecohSparseTerms)
    (S : Finset G) (bank : I → AddChar G ℂ) (ζ obs : I → ℂ)
    (hp : ∀ i, (p i).Prime)
    (hζ : ∀ i, IsPrimitiveRoot (ζ i) ((p i) ^ (k i + 1)))
    (hterms : ∀ i, RecohCoefficientsReduced (p i) (k i) (obsTerms i))
    (henc : ∀ i, ((enc i S).map (ζ i ^ ·)).sum = recohSupportProbe (bank i) S)
    (hobs : ∀ i, recohCoefficientValue (ζ i) (obsTerms i) = obs i) :
    recohCoefficientReadingsCheck p k enc obsTerms S = true ↔
      (fun i => recohSupportProbe (bank i) S) = obs := by
  simp only [recohCoefficientReadingsCheck, decide_eq_true_eq]
  constructor
  · intro h
    funext i
    have hi := (recoh_coefficient_match_iff (hp i) (k i) (hζ i)
      (enc i S) (obsTerms i) (hterms i)).mp (h i)
    simpa only [henc i, hobs i] using hi
  · intro h i
    apply (recoh_coefficient_match_iff (hp i) (k i) (hζ i)
      (enc i S) (obsTerms i) (hterms i)).mpr
    rw [henc i, hobs i]
    exact congrFun h i

/-- Complete observation checker whose observed readings are already
integer coefficients in the primary power bases. -/
def recohCoefficientObservationCheck {I : Type*} [Fintype I]
    (U : Finset G) (R : G → ℕ) (p k : I → ℕ)
    (enc : I → Finset G → List ℕ) (obsTerms : I → RecohSparseTerms) (S : Finset G) : Bool :=
  recohSparseSquareCheck U S R && recohCoefficientReadingsCheck p k enc obsTerms S

theorem recoh_coefficient_observation_check_iff {I : Type*} [Fintype I]
    (U : Finset G) (R : G → ℕ) (p k : I → ℕ)
    (enc : I → Finset G → List ℕ) (obsTerms : I → RecohSparseTerms) (S : Finset G)
    (bank : I → AddChar G ℂ) (ζ obs : I → ℂ)
    (hR : ∀ z, R z ≠ 0 → z ∈ U)
    (hp : ∀ i, (p i).Prime)
    (hζ : ∀ i, IsPrimitiveRoot (ζ i) ((p i) ^ (k i + 1)))
    (hterms : ∀ i, RecohCoefficientsReduced (p i) (k i) (obsTerms i))
    (henc : ∀ i, ((enc i S).map (ζ i ^ ·)).sum = recohSupportProbe (bank i) S)
    (hobs : ∀ i, recohCoefficientValue (ζ i) (obsTerms i) = obs i) :
    recohCoefficientObservationCheck U R p k enc obsTerms S = true ↔
      recohObservation bank S = (R, obs) := by
  rw [recohCoefficientObservationCheck, Bool.and_eq_true,
    recoh_sparse_square_check_iff U S R hR,
    recoh_coefficient_readings_check_iff p k enc obsTerms S bank ζ obs hp hζ hterms henc hobs]
  simp only [recohObservation, Prod.mk.injEq]

omit [AddCommGroup G] [DecidableEq G] in
/-- The coefficient checker specializes exactly to the previous
root-list checker when the observed coefficients are their raw reduction. -/
theorem recoh_coefficient_readings_check_reduced {m : ℕ} (p k : Fin m → ℕ)
    (enc : Fin m → Finset G → List ℕ) (obsExp : Fin m → List ℕ) (S : Finset G) :
    recohCoefficientReadingsCheck p k enc
      (fun i => recohReducedTerms (p i) (k i) (obsExp i)) S =
      recohSparseReadingsCheck p k enc obsExp S := by
  apply Bool.eq_iff_iff.mpr
  simp only [recohCoefficientReadingsCheck, recohCoefficientMatch,
    recohSparseReadingsCheck, decide_eq_true_eq]

theorem recoh_coefficient_observation_check_reduced {m : ℕ}
    (U : Finset G) (R : G → ℕ) (p k : Fin m → ℕ)
    (enc : Fin m → Finset G → List ℕ) (obsExp : Fin m → List ℕ) (S : Finset G) :
    recohCoefficientObservationCheck U R p k enc
      (fun i => recohReducedTerms (p i) (k i) (obsExp i)) S =
      recohSparseObservationCheck U R p k enc obsExp S := by
  unfold recohCoefficientObservationCheck recohSparseObservationCheck
  rw [recoh_coefficient_readings_check_reduced]

/-!
The coefficient checkers do not themselves establish support coverage,
primality, primitive-root identities or the interpretation of candidate
encodings.  Their correctness theorems display these contracts explicitly.
The observed coefficient values require no witness as a sum of three roots.
Such a representation, if it exists, is supplied by a successfully checked
candidate rather than assumed as an input encoding.

Typed lists may be arbitrarily long.  No constant or bit-complexity bound
for reading or checking observed input is asserted here.  In particular,
the twelve-position bound for comparing two normalized triples is not a
bound on arbitrary externally supplied coefficient lists.
-/

#print axioms recoh_coefficient_format_check_iff
#print axioms recoh_coefficient_format_reduced
#print axioms recoh_terms_polynomial_aeval
#print axioms recoh_coefficients_degree_lt
#print axioms recoh_root_terms_reduced
#print axioms recoh_reduced_terms_reduced
#print axioms recoh_reduced_terms_value
#print axioms recoh_reduced_coefficients_equal_iff
#print axioms recoh_coefficient_match_iff
#print axioms recoh_coefficients_reduced_negate
#print axioms recoh_coefficient_value_negate
#print axioms recoh_coefficient_match_neg_iff
#print axioms recoh_coefficient_readings_check_iff
#print axioms recoh_coefficient_observation_check_iff
#print axioms recoh_coefficient_readings_check_reduced
#print axioms recoh_coefficient_observation_check_reduced

end Couret.STROBO2TORS
