import Mathlib.RingTheory.Polynomial.Cyclotomic.Roots
import Mathlib.Tactic

set_option autoImplicit false

/-!
Exact integer-polynomial normalization for primary character sums.

The parameter `k` is one less than the positive primary exponent: the order
is `p ^ (k + 1)` and the stride is `p ^ k`.  Executable reduction uses lists
of integer monomials.  Mathlib's noncomputable integer-polynomial operations
provide their semantics; complex evaluation occurs in correctness theorems.
The separate Python `cyclotomic_sum` implementation is not extracted from,
or certified by, this module.
-/

namespace Couret.STROBO2TORS

open Polynomial
open scoped BigOperators

/-- Explicit prime-power cyclotomic polynomial, used as algebraic semantics. -/
noncomputable def recohPrimaryPolynomial (p k : ℕ) : ℤ[X] :=
  ∑ j ∈ Finset.range p, X ^ (j * p ^ k)

theorem recoh_primary_polynomial_eq_cyclotomic {p : ℕ} (hp : p.Prime) (k : ℕ) :
    recohPrimaryPolynomial p k = cyclotomic (p ^ (k + 1)) ℤ := by
  rw [recohPrimaryPolynomial, cyclotomic_prime_pow_eq_geom_sum hp]
  apply Finset.sum_congr rfl
  intro j _
  simp only [← pow_mul, Nat.mul_comm]

/-- The integer power basis of a primitive root is faithful below the
cyclotomic degree.  This is an unconditional injectivity theorem, with the
order and primitivity hypotheses displayed explicitly. -/
theorem recoh_cyclotomic_eval_eq_iff {n : ℕ} (hn : 0 < n) {ζ : ℂ}
    (hζ : IsPrimitiveRoot ζ n) (P Q : ℤ[X])
    (hP : P.degree < (n.totient : WithBot ℕ))
    (hQ : Q.degree < (n.totient : WithBot ℕ)) :
    aeval ζ P = aeval ζ Q ↔ P = Q := by
  constructor
  · intro he
    apply sub_eq_zero.mp
    apply Polynomial.eq_zero_of_dvd_of_degree_lt
      (minpoly.isIntegrallyClosed_dvd (hζ.isIntegral hn) (by
        rw [map_sub, he, sub_self]))
    rw [← cyclotomic_eq_minpoly hζ hn, degree_cyclotomic]
    exact lt_of_le_of_lt (degree_sub_le P Q) (max_lt hP hQ)
  · rintro rfl
    rfl

theorem recoh_primary_polynomial_aeval {p : ℕ} (hp : p.Prime) (k : ℕ)
    {ζ : ℂ} (hζ : IsPrimitiveRoot ζ (p ^ (k + 1))) :
    aeval ζ (recohPrimaryPolynomial p k) = 0 := by
  rw [recoh_primary_polynomial_eq_cyclotomic hp,
    cyclotomic_eq_minpoly hζ (pow_pos hp.pos _)]
  exact minpoly.aeval ℤ ζ

theorem recoh_primary_top_power {p : ℕ} (hp : p.Prime) (k : ℕ)
    {ζ : ℂ} (hζ : IsPrimitiveRoot ζ (p ^ (k + 1))) :
    ζ ^ ((p - 1) * p ^ k) = -(∑ j ∈ Finset.range (p - 1), ζ ^ (j * p ^ k)) := by
  have hz := recoh_primary_polynomial_aeval hp k hζ
  simp only [recohPrimaryPolynomial, map_sum, map_pow, aeval_X] at hz
  have hs := Finset.sum_range_succ (fun j : ℕ => ζ ^ (j * p ^ k)) (p - 1)
  rw [Nat.sub_add_cancel hp.one_le] at hs
  rw [hs] at hz
  linear_combination hz

/-- Algebraic form of the two reduction branches in `cyclotomic_sum`. -/
noncomputable def recohRootPolynomial (p k e : ℕ) : ℤ[X] :=
  let r := e % p ^ (k + 1)
  if r < (p - 1) * p ^ k then X ^ r
  else -(∑ j ∈ Finset.range (p - 1), X ^ (j * p ^ k + r % p ^ k))

private theorem recoh_high_residue {p k r : ℕ} (hp : p.Prime)
    (hr : r < p ^ (k + 1)) (hh : (p - 1) * p ^ k ≤ r) :
    r = (p - 1) * p ^ k + r % p ^ k := by
  have hdiv : r / p ^ k = p - 1 := Nat.div_eq_of_lt_le hh (by
    simpa only [Nat.sub_add_cancel hp.one_le, pow_succ, Nat.mul_comm] using hr)
  have hparts := Nat.mod_add_div r (p ^ k)
  rw [hdiv] at hparts
  simpa only [Nat.mul_comm, Nat.add_comm] using hparts.symm

theorem recoh_root_polynomial_aeval {p : ℕ} (hp : p.Prime) (k e : ℕ)
    {ζ : ℂ} (hζ : IsPrimitiveRoot ζ (p ^ (k + 1))) :
    aeval ζ (recohRootPolynomial p k e) = ζ ^ e := by
  have hmod : ζ ^ (e % p ^ (k + 1)) = ζ ^ e := by
    rw [hζ.eq_orderOf]
    exact pow_mod_orderOf ζ e
  unfold recohRootPolynomial
  dsimp only
  split_ifs with h
  · simpa only [map_pow, aeval_X] using hmod
  · simp only [map_neg, map_sum, map_pow, aeval_X]
    have hr := recoh_high_residue hp
      (Nat.mod_lt e (pow_pos hp.pos _)) (Nat.le_of_not_gt h)
    have hsum :
        (∑ j ∈ Finset.range (p - 1),
          ζ ^ (j * p ^ k + e % p ^ (k + 1) % p ^ k)) =
        (∑ j ∈ Finset.range (p - 1), ζ ^ (j * p ^ k)) *
          ζ ^ (e % p ^ (k + 1) % p ^ k) := by
      rw [Finset.sum_mul]
      apply Finset.sum_congr rfl
      intro j _
      exact pow_add ζ _ _
    rw [hsum, ← neg_mul, ← recoh_primary_top_power hp k hζ,
      ← pow_add, ← hr]
    exact hmod

theorem recoh_root_polynomial_degree {p : ℕ} (hp : p.Prime) (k e : ℕ) :
    (recohRootPolynomial p k e).degree < ((p - 1) * p ^ k : ℕ) := by
  unfold recohRootPolynomial
  dsimp only
  split_ifs with h
  · rw [degree_X_pow]
    exact WithBot.coe_lt_coe.mpr h
  · rw [degree_neg]
    apply lt_of_le_of_lt (degree_sum_le _ _)
    apply (Finset.sup_lt_iff (WithBot.bot_lt_coe _)).mpr
    intro j hj
    rw [degree_X_pow]
    apply WithBot.coe_lt_coe.mpr
    have ht := Nat.mod_lt (e % p ^ (k + 1)) (pow_pos hp.pos k)
    calc
      j * p ^ k + e % p ^ (k + 1) % p ^ k < j * p ^ k + p ^ k :=
        Nat.add_lt_add_left ht _
      _ = (j + 1) * p ^ k := by rw [Nat.add_mul, Nat.one_mul]
      _ ≤ (p - 1) * p ^ k :=
        Nat.mul_le_mul_right _ (Nat.succ_le_of_lt (Finset.mem_range.mp hj))

/-- The reduced polynomial for a list of roots; multiplicities are retained. -/
noncomputable def recohRootSumPolynomial (p k : ℕ) (es : List ℕ) : ℤ[X] :=
  (es.map (recohRootPolynomial p k)).sum

theorem recoh_root_sum_polynomial_aeval {p : ℕ} (hp : p.Prime) (k : ℕ)
    {ζ : ℂ} (hζ : IsPrimitiveRoot ζ (p ^ (k + 1))) (es : List ℕ) :
    aeval ζ (recohRootSumPolynomial p k es) = (es.map (ζ ^ ·)).sum := by
  induction es with
  | nil => simp [recohRootSumPolynomial]
  | cons e es ih =>
    simp only [recohRootSumPolynomial, List.map_cons, List.sum_cons, map_add]
    rw [recoh_root_polynomial_aeval hp k e hζ]
    exact congrArg (ζ ^ e + ·) ih

theorem recoh_root_sum_polynomial_degree {p : ℕ} (hp : p.Prime) (k : ℕ)
    (es : List ℕ) :
    (recohRootSumPolynomial p k es).degree < ((p - 1) * p ^ k : ℕ) := by
  induction es with
  | nil =>
    simpa only [recohRootSumPolynomial, List.map_nil, List.sum_nil, degree_zero]
      using (WithBot.bot_lt_coe ((p - 1) * p ^ k))
  | cons e es ih =>
    simp only [recohRootSumPolynomial, List.map_cons, List.sum_cons]
    exact lt_of_le_of_lt (degree_add_le _ _)
      (max_lt (recoh_root_polynomial_degree hp k e) ih)

/-- Equality of reduced polynomial forms is equivalent to exact complex
equality.  It is not an injectivity statement about raw lists of terms. -/
theorem recoh_root_sum_polynomial_eq_iff {p : ℕ} (hp : p.Prime) (k : ℕ)
    {ζ : ℂ} (hζ : IsPrimitiveRoot ζ (p ^ (k + 1))) (es fs : List ℕ) :
    recohRootSumPolynomial p k es = recohRootSumPolynomial p k fs ↔
      (es.map (ζ ^ ·)).sum = (fs.map (ζ ^ ·)).sum := by
  have degree_bound (xs : List ℕ) :
      (recohRootSumPolynomial p k xs).degree < ((p ^ (k + 1)).totient : WithBot ℕ) := by
    simpa only [Nat.totient_prime_pow_succ hp, Nat.mul_comm] using
      recoh_root_sum_polynomial_degree hp k xs
  rw [← recoh_root_sum_polynomial_aeval hp k hζ es,
    ← recoh_root_sum_polynomial_aeval hp k hζ fs]
  exact (recoh_cyclotomic_eval_eq_iff (pow_pos hp.pos _) hζ _ _
    (degree_bound es) (degree_bound fs)).symm

/-! ## Executable sparse terms and their polynomial interpretation -/

/-- A raw list of monomials.  Repeated exponents and zero coefficients are
allowed; syntactic equality of these lists is not the comparison primitive. -/
abbrev RecohSparseTerms := List (ℕ × ℤ)

/-- Executable reduction of a single root.  This uses exactly the two
branches of the integer-polynomial reduction above. -/
def recohRootTerms (p k e : ℕ) : RecohSparseTerms :=
  let r := e % p ^ (k + 1)
  if r < (p - 1) * p ^ k then [(r, 1)]
  else (List.range (p - 1)).map (fun j => (j * p ^ k + r % p ^ k, -1))

/-- Executable reduction of a list of roots before combining equal powers. -/
def recohReducedTerms (p k : ℕ) (es : List ℕ) : RecohSparseTerms :=
  es.flatMap (recohRootTerms p k)

/-- Semantic interpretation; the polynomial implementation itself is
noncomputable in Mathlib, while the term-list operations are executable. -/
noncomputable def recohTermsPolynomial : RecohSparseTerms → ℤ[X]
  | [] => 0
  | t :: ts => monomial t.1 t.2 + recohTermsPolynomial ts

theorem recoh_terms_polynomial_append (xs ys : RecohSparseTerms) :
    recohTermsPolynomial (xs ++ ys) = recohTermsPolynomial xs + recohTermsPolynomial ys := by
  induction xs with
  | nil => simp [recohTermsPolynomial]
  | cons t ts ih => simp [recohTermsPolynomial, ih, add_assoc]

private theorem recoh_terms_polynomial_range (m : ℕ) (f : ℕ → ℕ) (c : ℤ) :
    recohTermsPolynomial ((List.range m).map (fun j => (f j, c))) =
      ∑ j ∈ Finset.range m, monomial (f j) c := by
  induction m with
  | zero => simp [recohTermsPolynomial]
  | succ m ih =>
    rw [List.range_succ, List.map_append, recoh_terms_polynomial_append,
      Finset.sum_range_succ, ih]
    simp [recohTermsPolynomial]

theorem recoh_root_terms_polynomial (p k e : ℕ) :
    recohTermsPolynomial (recohRootTerms p k e) = recohRootPolynomial p k e := by
  unfold recohRootTerms recohRootPolynomial
  dsimp only
  split_ifs
  · simp [recohTermsPolynomial, X_pow_eq_monomial]
  · rw [recoh_terms_polynomial_range]
    simp only [monomial_neg, ← X_pow_eq_monomial, Finset.sum_neg_distrib]

theorem recoh_reduced_terms_polynomial (p k : ℕ) (es : List ℕ) :
    recohTermsPolynomial (recohReducedTerms p k es) = recohRootSumPolynomial p k es := by
  induction es with
  | nil => simp [recohReducedTerms, recohTermsPolynomial, recohRootSumPolynomial]
  | cons e es ih =>
    simp only [recohReducedTerms, List.flatMap_cons,
      recoh_terms_polynomial_append, recoh_root_terms_polynomial]
    rw [show recohTermsPolynomial (List.flatMap (recohRootTerms p k) es) =
        recohRootSumPolynomial p k es from ih]
    simp [recohRootSumPolynomial]

theorem recoh_root_terms_length_le {p : ℕ} (hp : p.Prime) (k e : ℕ) :
    (recohRootTerms p k e).length ≤ p - 1 := by
  unfold recohRootTerms
  dsimp only
  split_ifs
  · simp only [List.length_cons, List.length_nil]
    have := hp.two_le
    omega
  · simp only [List.length_map, List.length_range, le_refl]

theorem recoh_reduced_terms_length_le {p : ℕ} (hp : p.Prime) (k : ℕ) (es : List ℕ) :
    (recohReducedTerms p k es).length ≤ es.length * (p - 1) := by
  induction es with
  | nil => simp [recohReducedTerms]
  | cons e es ih =>
    simp only [recohReducedTerms, List.flatMap_cons, List.length_append]
    calc
      _ ≤ (p - 1) + es.length * (p - 1) :=
        Nat.add_le_add (recoh_root_terms_length_le hp k e) ih
      _ = (e :: es).length * (p - 1) := by
        simp only [List.length_cons, Nat.add_mul, Nat.one_mul, Nat.add_comm]

/-- Three roots of a two-primary order emit at most three raw monomials. -/
theorem recoh_two_primary_triple_length (k a b c : ℕ) :
    (recohReducedTerms 2 k [a, b, c]).length ≤ 3 := by
  simpa using recoh_reduced_terms_length_le Nat.prime_two k [a, b, c]

/-- Three roots of a three-primary order emit at most six raw monomials. -/
theorem recoh_three_primary_triple_length (k a b c : ℕ) :
    (recohReducedTerms 3 k [a, b, c]).length ≤ 6 := by
  simpa using recoh_reduced_terms_length_le Nat.prime_three k [a, b, c]

/-! ## Executable equality by summing coefficients at present exponents -/

/-- Sum all coefficients at a given exponent, including repetitions. -/
def recohSparseCoeff (ts : RecohSparseTerms) (n : ℕ) : ℤ :=
  (ts.map (fun t => if t.1 = n then t.2 else 0)).sum

/-- Compare only exponents present in either raw list.  Duplicated tests are
harmless; no dense vector of cyclotomic-degree length is constructed. -/
def recohSparseEqual (xs ys : RecohSparseTerms) : Bool :=
  ((xs.map Prod.fst) ++ (ys.map Prod.fst)).all
    (fun n => decide (recohSparseCoeff xs n = recohSparseCoeff ys n))

theorem recoh_terms_polynomial_coeff (ts : RecohSparseTerms) (n : ℕ) :
    (recohTermsPolynomial ts).coeff n = recohSparseCoeff ts n := by
  induction ts with
  | nil => simp [recohTermsPolynomial, recohSparseCoeff]
  | cons t ts ih =>
    simp [recohTermsPolynomial, recohSparseCoeff, coeff_monomial] at ih ⊢
    exact ih

theorem recoh_sparse_coeff_zero_of_not_mem (ts : RecohSparseTerms) (n : ℕ)
    (hn : n ∉ ts.map Prod.fst) : recohSparseCoeff ts n = 0 := by
  induction ts with
  | nil => simp [recohSparseCoeff]
  | cons t ts ih =>
    have hne : t.1 ≠ n := by
      intro he
      exact hn (by simp [he])
    have htail : n ∉ ts.map Prod.fst := by
      intro hm
      exact hn (by simp only [List.map_cons, List.mem_cons]; exact Or.inr hm)
    simp only [recohSparseCoeff, List.map_cons, List.sum_cons, if_neg hne,
      zero_add]
    exact ih htail

/-- Exact semantic equality for arbitrary raw term lists; this deliberately
does not assert syntactic injectivity of raw lists. -/
theorem recoh_sparse_equal_iff (xs ys : RecohSparseTerms) :
    recohSparseEqual xs ys = true ↔
      recohTermsPolynomial xs = recohTermsPolynomial ys := by
  unfold recohSparseEqual
  rw [List.all_eq_true]
  constructor
  · intro h
    apply Polynomial.ext
    intro n
    rw [recoh_terms_polynomial_coeff, recoh_terms_polynomial_coeff]
    by_cases hn : n ∈ xs.map Prod.fst ++ ys.map Prod.fst
    · exact of_decide_eq_true (h n hn)
    · have hx : n ∉ xs.map Prod.fst := by
        intro hm
        exact hn (List.mem_append_left _ hm)
      have hy : n ∉ ys.map Prod.fst := by
        intro hm
        exact hn (List.mem_append_right _ hm)
      rw [recoh_sparse_coeff_zero_of_not_mem xs n hx,
        recoh_sparse_coeff_zero_of_not_mem ys n hy]
  · intro h n _
    apply decide_eq_true
    rw [← recoh_terms_polynomial_coeff, ← recoh_terms_polynomial_coeff, h]

/-- The executable sparse test decides equality of the original complex
root sums exactly.  Its proof applies to every prime, including 2 and 3. -/
theorem recoh_normalized_sparse_equal_iff {p : ℕ} (hp : p.Prime) (k : ℕ)
    {ζ : ℂ} (hζ : IsPrimitiveRoot ζ (p ^ (k + 1))) (es fs : List ℕ) :
    recohSparseEqual (recohReducedTerms p k es) (recohReducedTerms p k fs) = true ↔
      (es.map (ζ ^ ·)).sum = (fs.map (ζ ^ ·)).sum := by
  rw [recoh_sparse_equal_iff, recoh_reduced_terms_polynomial,
    recoh_reduced_terms_polynomial]
  exact recoh_root_sum_polynomial_eq_iff hp k hζ es fs

/-- The number of exponent positions tested by the raw-list comparator is
bounded by the total number of emitted terms, without deduplication. -/
theorem recoh_normalized_comparison_positions_le {p : ℕ} (hp : p.Prime) (k : ℕ)
    (es fs : List ℕ) :
    (((recohReducedTerms p k es).map Prod.fst) ++
      ((recohReducedTerms p k fs).map Prod.fst)).length ≤
      (es.length + fs.length) * (p - 1) := by
  simp only [List.length_append, List.length_map, Nat.add_mul]
  exact Nat.add_le_add (recoh_reduced_terms_length_le hp k es)
    (recoh_reduced_terms_length_le hp k fs)

/-- At most twelve exponent positions are tested for two triples when
the prime is 2 or 3.  This counts tests, not bit operations. -/
theorem recoh_primary_triple_comparison_positions_le {p : ℕ} (hp : p = 2 ∨ p = 3)
    (k a b c d e f : ℕ) :
    (((recohReducedTerms p k [a, b, c]).map Prod.fst) ++
      ((recohReducedTerms p k [d, e, f]).map Prod.fst)).length ≤ 12 := by
  rcases hp with rfl | rfl
  · have h := recoh_normalized_comparison_positions_le Nat.prime_two k [a, b, c] [d, e, f]
    exact le_trans (by simpa using h) (by norm_num : 6 ≤ 12)
  · simpa using
      recoh_normalized_comparison_positions_le Nat.prime_three k [a, b, c] [d, e, f]

/-- Executable coefficient negation for the sign comparison in the decoder. -/
def recohNegateTerms (ts : RecohSparseTerms) : RecohSparseTerms :=
  ts.map (fun t => (t.1, -t.2))

theorem recoh_negate_terms_polynomial (ts : RecohSparseTerms) :
    recohTermsPolynomial (recohNegateTerms ts) = -recohTermsPolynomial ts := by
  induction ts with
  | nil => simp [recohNegateTerms, recohTermsPolynomial]
  | cons t ts ih =>
    simp only [recohNegateTerms, List.map_cons, recohTermsPolynomial, monomial_neg]
    rw [show recohTermsPolynomial (ts.map (fun t => (t.1, -t.2))) =
        -recohTermsPolynomial ts from ih]
    exact (neg_add _ _).symm

/-- Exact comparison with the negative of a character sum.  The use of
negative raw coefficients does not introduce a canonical-list hypothesis. -/
theorem recoh_normalized_sparse_equal_neg_iff {p : ℕ} (hp : p.Prime) (k : ℕ)
    {ζ : ℂ} (hζ : IsPrimitiveRoot ζ (p ^ (k + 1))) (es fs : List ℕ) :
    recohSparseEqual (recohReducedTerms p k es)
      (recohNegateTerms (recohReducedTerms p k fs)) = true ↔
      (es.map (ζ ^ ·)).sum = -(fs.map (ζ ^ ·)).sum := by
  rw [recoh_sparse_equal_iff, recoh_negate_terms_polynomial,
    recoh_reduced_terms_polynomial, recoh_reduced_terms_polynomial]
  have degree_bound (xs : List ℕ) :
      (recohRootSumPolynomial p k xs).degree < ((p ^ (k + 1)).totient : WithBot ℕ) := by
    simpa only [Nat.totient_prime_pow_succ hp, Nat.mul_comm] using
      recoh_root_sum_polynomial_degree hp k xs
  have hneg : (-recohRootSumPolynomial p k fs).degree <
      ((p ^ (k + 1)).totient : WithBot ℕ) := by
    rw [degree_neg]
    exact degree_bound fs
  have h := (recoh_cyclotomic_eval_eq_iff (pow_pos hp.pos _) hζ
    (recohRootSumPolynomial p k es) (-recohRootSumPolynomial p k fs)
    (degree_bound es) hneg).symm
  simpa only [map_neg, recoh_root_sum_polynomial_aeval hp k hζ] using h

/-!
## Boundary with the separate Python implementation

`recohRootTerms` uses the same exponent reduction and the same emitted
integer monomials as `cyclotomic_sum` in `../recoh_exact_decoder.py`, with
`order = p ^ (k + 1)` and `stride = p ^ k`.  The Python code subsequently
combines coefficients with `Counter`, omits zeros and sorts by exponent.

The theorems in this module certify the Lean term-list reduction and its
coefficient-summing comparator.  They identify exact equality with equality
of the interpreted integer polynomials and then with complex equality.
They do not certify Python execution, its container operations, parsing,
the extraction of primary orders, or a canonical sorted-list representation.
There is no theorem asserting injectivity of raw monomial lists.

For two normalized triples with prime 2 or 3, the comparator visits at most
twelve exponent positions.  Each test scans both finite term lists.  The
length bounds above do not constitute a bit-complexity theorem: exponent
reduction, integer arithmetic and input reading retain their own costs.
-/

#print axioms recoh_primary_polynomial_eq_cyclotomic
#print axioms recoh_cyclotomic_eval_eq_iff
#print axioms recoh_primary_polynomial_aeval
#print axioms recoh_primary_top_power
#print axioms recoh_root_polynomial_aeval
#print axioms recoh_root_polynomial_degree
#print axioms recoh_root_sum_polynomial_aeval
#print axioms recoh_root_sum_polynomial_degree
#print axioms recoh_root_sum_polynomial_eq_iff
#print axioms recoh_terms_polynomial_append
#print axioms recoh_root_terms_polynomial
#print axioms recoh_reduced_terms_polynomial
#print axioms recoh_root_terms_length_le
#print axioms recoh_reduced_terms_length_le
#print axioms recoh_two_primary_triple_length
#print axioms recoh_three_primary_triple_length
#print axioms recoh_terms_polynomial_coeff
#print axioms recoh_sparse_coeff_zero_of_not_mem
#print axioms recoh_sparse_equal_iff
#print axioms recoh_normalized_sparse_equal_iff
#print axioms recoh_normalized_comparison_positions_le
#print axioms recoh_primary_triple_comparison_positions_le
#print axioms recoh_negate_terms_polynomial
#print axioms recoh_normalized_sparse_equal_neg_iff

end Couret.STROBO2TORS
