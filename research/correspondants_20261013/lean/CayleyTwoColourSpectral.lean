import CayleyTwoColourAbelian

/-!
COU-20 — finite directed spectral bridge (17 October 2026).

This file connects finite-support convolution to the actual rational adjacency
matrices, proves cospectrality for a supplied additive parity and for the
already certified nongeneration branch, and proves exact odd-power and trace
difference formulas. Translation sums are identified with Finset adjacency
only after distinctness has been derived from the exact quotient order.

The construction of parity from quotient cardinality and the full spectral
classification are not asserted by these conditional spectral corollaries.
No undirected-graph extension, independent human review, release or priority
claim is made here. The preceding isomorphism dichotomy is imported unchanged.
-/

set_option autoImplicit false
noncomputable section
open Matrix Polynomial
open scoped BigOperators
namespace Couret.CayleySpectral

variable {ι : Type*} [Fintype ι] [DecidableEq ι]
variable {R : Type*} [CommRing R]

/-- A sign symmetry gives invariance of the characteristic polynomial under negation. -/
theorem charpoly_neg_of_involution (A D : Matrix ι ι R)
    (hD : D * D = 1) (hA : D * A * D = -A) :
    (-A).charpoly = A.charpoly := by
  rw [← hA, Matrix.charpoly_mul_comm, ← mul_assoc, hD, one_mul]

/-- Equal matrix squares and sign-symmetric characteristic polynomials imply equal
characteristic polynomials. This uses determinants, without eigenvalue approximations. -/
theorem charpoly_eq_of_sq_eq_of_neg [NoZeroDivisors R] (A B : Matrix ι ι R)
    (hsq : A ^ 2 = B ^ 2)
    (hA : (-A).charpoly = A.charpoly)
    (hB : (-B).charpoly = B.charpoly) :
    A.charpoly = B.charpoly := by
  have hm : A.charmatrix * (-A).charmatrix =
      B.charmatrix * (-B).charmatrix := by
    apply matPolyEquiv.injective
    simp only [map_mul, Matrix.matPolyEquiv_charmatrix, map_neg, sub_neg_eq_add]
    rw [← (Polynomial.commute_X (C A)).mul_self_sub_mul_self_eq',
      ← (Polynomial.commute_X (C B)).mul_self_sub_mul_self_eq']
    simpa only [← pow_two, map_pow] using
      congrArg (fun M : Matrix ι ι R => (X : (Matrix ι ι R)[X]) ^ 2 - C M) hsq
  have hp : A.charpoly ^ 2 = B.charpoly ^ 2 := by
    have hd := congrArg Matrix.det hm
    simp only [Matrix.det_mul] at hd
    change A.charpoly * (-A).charpoly = B.charpoly * (-B).charpoly at hd
    simpa only [hA, hB, pow_two] using hd
  rcases (eq_or_eq_neg_of_sq_eq_sq _ _ hp) with h | h
  · exact h
  · have hh := congrArg Polynomial.leadingCoeff h
    rw [Polynomial.leadingCoeff_neg, A.charpoly_monic.leadingCoeff,
      B.charpoly_monic.leadingCoeff] at hh
    calc
      A.charpoly = -B.charpoly := h
      _ = (-1 : R) • B.charpoly := (neg_one_smul R _).symm
      _ = (1 : R) • B.charpoly := by rw [← hh]
      _ = B.charpoly := one_smul _ _

/-- The two involutions may differ. Only the two matrix squares must agree. -/
theorem charpoly_eq_of_sq_eq_of_involutions [NoZeroDivisors R] (A B D E : Matrix ι ι R)
    (hsq : A ^ 2 = B ^ 2) (hD : D * D = 1) (hE : E * E = 1)
    (hA : D * A * D = -A) (hB : E * B * E = -B) :
    A.charpoly = B.charpoly :=
  charpoly_eq_of_sq_eq_of_neg A B hsq
    (charpoly_neg_of_involution A D hD hA)
    (charpoly_neg_of_involution B E hE hB)

/-- A bipartition is encoded by a sign at each index. -/
theorem diagonal_sign_involution (s : ι → R) (hs : ∀ i, s i * s i = 1) :
    diagonal s * diagonal s = 1 := by
  rw [Matrix.diagonal_mul_diagonal]
  simp only [hs, Matrix.diagonal_one]

theorem diagonal_sign_conj (A : Matrix ι ι R) (s : ι → R)
    (hs : ∀ i, s i * s i = 1)
    (hA : ∀ i j, A i j ≠ 0 → s i = -s j) :
    diagonal s * A * diagonal s = -A := by
  ext i j
  simp only [Matrix.mul_diagonal, Matrix.diagonal_mul, Matrix.neg_apply]
  by_cases hz : A i j = 0
  · simp [hz]
  · rw [hA i j hz]
    calc
      -s j * A i j * s j = -(s j * s j) * A i j := by ring
      _ = -A i j := by rw [hs]; ring

theorem charpoly_eq_of_sq_eq_of_signs [NoZeroDivisors R] (A B : Matrix ι ι R)
    (s t : ι → R) (hs : ∀ i, s i * s i = 1) (ht : ∀ i, t i * t i = 1)
    (hA : ∀ i j, A i j ≠ 0 → s i = -s j)
    (hB : ∀ i j, B i j ≠ 0 → t i = -t j)
    (hsq : A ^ 2 = B ^ 2) : A.charpoly = B.charpoly :=
  charpoly_eq_of_sq_eq_of_involutions A B (diagonal s) (diagonal t) hsq
    (diagonal_sign_involution s hs) (diagonal_sign_involution t ht)
    (diagonal_sign_conj A s hs hA) (diagonal_sign_conj B t ht hB)

/-- The same sign symmetry kills every odd closed-walk trace. -/
theorem trace_pow_eq_zero_of_odd_of_involution (A D : Matrix ι ι ℚ)
    (hD : D * D = 1) (hA : D * A * D = -A) (n : ℕ) (hn : Odd n) :
    Matrix.trace (A ^ n) = 0 := by
  have hanti : SemiconjBy D A (-A) := by
    change D * A = -A * D
    calc
      D * A = (D * A * D) * D := by rw [mul_assoc, mul_assoc, hD, mul_one]
      _ = -A * D := by rw [hA]
  have hconj : D * A ^ n * D = (-A) ^ n := by
    rw [(hanti.pow_right n).eq, mul_assoc, hD, mul_one]
  have ht : Matrix.trace (A ^ n) = -Matrix.trace (A ^ n) := by
    calc
      Matrix.trace (A ^ n) = Matrix.trace (D * A ^ n * D) := by
        rw [Matrix.trace_mul_cycle, hD, one_mul]
      _ = -Matrix.trace (A ^ n) := by rw [hconj, hn.neg_pow, Matrix.trace_neg]
  exact eq_zero_of_neg_eq ht.symm

theorem trace_pow_eq_zero_of_odd_of_signs (A : Matrix ι ι ℚ)
    (s : ι → ℚ) (hs : ∀ i, s i * s i = 1)
    (hA : ∀ i j, A i j ≠ 0 → s i = -s j) (n : ℕ) (hn : Odd n) :
    Matrix.trace (A ^ n) = 0 :=
  trace_pow_eq_zero_of_odd_of_involution A (diagonal s)
    (diagonal_sign_involution s hs) (diagonal_sign_conj A s hs hA) n hn

end Couret.CayleySpectral
namespace Couret.CayleySpectral
/-! An exact odd-power identity, valid in every unital associative ring. -/

theorem odd_pow_sub_of_sq_eq
    {R : Type*} [Ring R] (x y c : R)
    (hsq : x ^ 2 = y ^ 2)
    (heigen : x ^ 2 * (x - y) = c * (x - y)) (n : ℕ) :
    x ^ (2 * n + 1) - y ^ (2 * n + 1) = c ^ n * (x - y) := by
  have hy : Commute y (x ^ 2) := by
    rw [hsq]
    exact Commute.self_pow y 2
  have hcomm : Commute (x - y) (x ^ 2) :=
    (Commute.self_pow x 2).sub_left hy
  have hsemi : SemiconjBy (x - y) (x ^ 2) c := hcomm.eq.trans heigen
  calc
    x ^ (2 * n + 1) - y ^ (2 * n + 1) = (x - y) * (x ^ 2) ^ n := by
      rw [pow_succ', pow_succ', pow_mul, pow_mul, ← hsq, sub_mul]
    _ = c ^ n * (x - y) := hsemi.pow_right n


theorem two_colour_common_sq
    {R : Type*} [Ring R] (u v : R)
    (hu : u ^ 2 = 2 * v) (hv : v ^ 2 = 2 * u) :
    (1 + u) ^ 2 = (1 + v) ^ 2 := by
  have hu' : u * u = 2 * v := by simpa only [sq] using hu
  have hv' : v * v = 2 * u := by simpa only [sq] using hv
  noncomm_ring [hu', hv']

theorem two_colour_common_sq_mul_sub
    {R : Type*} [Ring R] (u v : R)
    (huv : Commute u v)
    (hu : u ^ 2 = 2 * v) (hv : v ^ 2 = 2 * u) :
    (1 + u) ^ 2 * ((1 + u) - (1 + v)) =
      (-3) * ((1 + u) - (1 + v)) := by
  have hexp : (1 + u) ^ 2 = 1 + 2 * u + 2 * v := by
    calc
      (1 + u) ^ 2 = 1 + 2 * u + u ^ 2 := by noncomm_ring
      _ = 1 + 2 * u + 2 * v := by rw [hu]
  calc
    (1 + u) ^ 2 * ((1 + u) - (1 + v)) =
        (u - v) + 2 * (u ^ 2 - v ^ 2) := by
      rw [hexp]
      noncomm_ring [huv.eq]
    _ = (-3) * ((1 + u) - (1 + v)) := by
      rw [hu, hv]
      noncomm_ring

theorem two_colour_odd_pow_sub
    {R : Type*} [Ring R] (u v : R)
    (huv : Commute u v)
    (hu : u ^ 2 = 2 * v) (hv : v ^ 2 = 2 * u) (n : ℕ) :
    (1 + u) ^ (2 * n + 1) - (1 + v) ^ (2 * n + 1) =
      (-3) ^ n * (u - v) := by
  have h := odd_pow_sub_of_sq_eq (1 + u) (1 + v) (-3)
    (two_colour_common_sq u v hu hv)
    (two_colour_common_sq_mul_sub u v huv hu hv) n
  simpa only [add_sub_add_left_eq_sub] using h


theorem even_pow_eq_of_sq_eq
    {M : Type*} [Monoid M] (x y : M)
    (hsq : x ^ 2 = y ^ 2) (n : ℕ) : x ^ (2 * n) = y ^ (2 * n) := by
  rw [pow_mul, pow_mul, hsq]

theorem two_colour_mul_common_sq
    {R : Type*} [Ring R] (t u v : R)
    (htu : Commute t u) (htv : Commute t v)
    (hu : u ^ 2 = 2 * v) (hv : v ^ 2 = 2 * u) :
    (t * (1 + u)) ^ 2 = (t * (1 + v)) ^ 2 := by
  rw [((Commute.one_right t).add_right htu).mul_pow,
    ((Commute.one_right t).add_right htv).mul_pow,
    two_colour_common_sq u v hu hv]

theorem two_colour_mul_odd_pow_sub
    {R : Type*} [Ring R] (t u v : R)
    (htu : Commute t u) (htv : Commute t v) (huv : Commute u v)
    (hu : u ^ 2 = 2 * v) (hv : v ^ 2 = 2 * u) (n : ℕ) :
    (t * (1 + u)) ^ (2 * n + 1) - (t * (1 + v)) ^ (2 * n + 1) =
      t ^ (2 * n + 1) * ((-3) ^ n * (u - v)) := by
  rw [((Commute.one_right t).add_right htu).mul_pow,
    ((Commute.one_right t).add_right htv).mul_pow,
    ← mul_sub, two_colour_odd_pow_sub u v huv hu hv]


theorem two_colour_mul_odd_pow_sub_scalar_first
    {R : Type*} [Ring R] (t u v : R)
    (htu : Commute t u) (htv : Commute t v) (huv : Commute u v)
    (hu : u ^ 2 = 2 * v) (hv : v ^ 2 = 2 * u) (n : ℕ) :
    (t * (1 + u)) ^ (2 * n + 1) - (t * (1 + v)) ^ (2 * n + 1) =
      (-3) ^ n * t ^ (2 * n + 1) * (u - v) := by
  rw [two_colour_mul_odd_pow_sub t u v htu htv huv hu hv,
    ← mul_assoc,
    (((Commute.ofNat_right t 3).neg_right).pow_pow (2 * n + 1) n).eq]



end Couret.CayleySpectral

namespace Couret.CayleyDoublet

variable {G : Type*} [AddCommGroup G] [DecidableEq G] [Fintype G]

/-- Rational adjacency matrix of a directed Cayley relation, including loops. -/
def abelianCayleyMatrix (S : Finset G) : Matrix G G ℚ :=
  fun x y => if y - x ∈ S then 1 else 0

/-- The permutation matrix for the directed translation by t. -/
def abelianTranslationMatrix (t : G) : Matrix G G ℚ :=
  fun x y => if y = x + t then 1 else 0

theorem abelianTranslationMatrix_mul (s t : G) :
    abelianTranslationMatrix s * abelianTranslationMatrix t =
      abelianTranslationMatrix (s + t) := by
  ext x y
  simp only [abelianTranslationMatrix, Matrix.mul_apply, ite_mul, one_mul, zero_mul]
  simp [add_assoc]

theorem abelianTranslationMatrix_zero :
    abelianTranslationMatrix (0 : G) = 1 := by
  ext x y
  simp [abelianTranslationMatrix, Matrix.one_apply, eq_comm]

theorem abelianTranslationMatrix_commute (s t : G) :
    Commute (abelianTranslationMatrix s) (abelianTranslationMatrix t) := by
  show abelianTranslationMatrix s * abelianTranslationMatrix t =
    abelianTranslationMatrix t * abelianTranslationMatrix s
  simp [abelianTranslationMatrix_mul, add_comm]

theorem abelianCayleyMatrix_eq_sum (S : Finset G) :
    abelianCayleyMatrix S = ∑ s ∈ S, abelianTranslationMatrix s := by
  ext x y
  have he (s : G) : y = x + s ↔ s = y - x := by
    constructor <;> intro h <;> rw [h] <;> abel
  simp [Matrix.sum_apply, abelianCayleyMatrix, abelianTranslationMatrix, he]

theorem abelianCayleyMatrix_sq_apply (S : Finset G) (x y : G) :
    (abelianCayleyMatrix S ^ 2) x y =
      (abelianOrderedSquare S (y - x) : ℚ) := by
  rw [abelianCayleyMatrix_eq_sum, pow_two, Finset.sum_mul]
  simp_rw [Finset.mul_sum, abelianTranslationMatrix_mul]
  have he (s t : G) : y = x + (s + t) ↔ s + t = y - x := by
    constructor <;> intro h <;> rw [h] <;> abel
  simp [Matrix.sum_apply, abelianOrderedSquare, abelianTranslationMatrix, he]

/-- Signs associated with a supplied additive parity. -/
def abelianParitySign (ε : G →+ ZMod 2) (x : G) : ℚ :=
  if ε x = 0 then 1 else -1

theorem abelianParitySign_sq (ε : G →+ ZMod 2) (x : G) :
    abelianParitySign ε x * abelianParitySign ε x = 1 := by
  simp only [abelianParitySign]
  split_ifs <;> norm_num

theorem abelianCayleyMatrix_parity_sign (S : Finset G) (ε : G →+ ZMod 2)
    (hS : ∀ s ∈ S, ε s = 1) (x y : G)
    (hne : abelianCayleyMatrix S x y ≠ 0) :
    abelianParitySign ε x = -abelianParitySign ε y := by
  have hm : y - x ∈ S := by
    by_contra h
    exact hne (by simp [abelianCayleyMatrix, h])
  have he : ε y = ε x + 1 := by
    calc
      ε y = ε (x + (y - x)) := congrArg ε (by abel)
      _ = ε x + ε (y - x) := map_add ε _ _
      _ = ε x + 1 := by rw [hS _ hm]
  have hf : ∀ t : ZMod 2,
      (if t = 0 then (1 : ℚ) else -1) =
        -(if t + 1 = 0 then (1 : ℚ) else -1) := by decide
  simpa only [abelianParitySign, he] using hf (ε x)

end Couret.CayleyDoublet

namespace Couret.CayleyDoublet
open Couret.CayleySpectral
variable {G : Type*} [AddCommGroup G] [DecidableEq G] [Fintype G]
/-- The sum of the two translation matrices in the doublet. -/
def abelianDoubletMatrix (d h : G) : Matrix G G ℚ :=
  abelianTranslationMatrix d + abelianTranslationMatrix (d + h)

theorem abelianDoubletMatrix_sq_halfTurn (d h : G) (hhalf : h + h = 0) :
    abelianDoubletMatrix d h ^ 2 = 2 * abelianDoubletMatrix (d + d) h := by
  have hcross₁ : d + (d + h) = (d + d) + h := by abel
  have hcross₂ : (d + h) + d = (d + d) + h := by abel
  have hsum : (d + h) + (d + h) = d + d := by
    calc
      (d + h) + (d + h) = (d + d) + (h + h) := by abel
      _ = d + d := by rw [hhalf, add_zero]
  simp only [abelianDoubletMatrix, sq, add_mul, mul_add,
    abelianTranslationMatrix_mul, hcross₁, hcross₂, hsum, two_mul]
  abel

theorem abelianDoubletMatrix_sq_orderThree (d h : G)
    (hhalf : h + h = 0)
    (hthree : (d + d) + d = 0 ∨ (d + d) + d = h) :
    abelianDoubletMatrix d h ^ 2 = 2 * abelianDoubletMatrix (-d) h := by
  rw [abelianDoubletMatrix_sq_halfTurn d h hhalf]
  congr 1
  rcases hthree with hthree | hthree
  · have hd : d + d = -d := by
      apply eq_neg_iff_add_eq_zero.mpr
      exact hthree
    rw [hd]
  · have hd : d + d = -d + h := by
      calc
        d + d = ((d + d) + d) - d := by abel
        _ = -d + h := by rw [hthree]; abel
    have hdh : (d + d) + h = -d := by
      calc
        (d + d) + h = -d + (h + h) := by rw [hd]; abel
        _ = -d := by rw [hhalf, add_zero]
    show abelianTranslationMatrix (d + d) + abelianTranslationMatrix ((d + d) + h) =
      abelianTranslationMatrix (-d) + abelianTranslationMatrix (-d + h)
    rw [hdh, hd, add_comm]

omit [DecidableEq G] [Fintype G] in
theorem abelian_neg_three_mem_halfTurn (d h : G)
    (hhalf : h + h = 0)
    (hthree : (d + d) + d = 0 ∨ (d + d) + d = h) :
    ((-d) + (-d)) + (-d) = 0 ∨ ((-d) + (-d)) + (-d) = h := by
  have hn : -h = h := neg_eq_iff_add_eq_zero.mpr hhalf
  have he : ((-d) + (-d)) + (-d) = -((d + d) + d) := by abel
  rcases hthree with hthree | hthree
  · exact Or.inl (by rw [he, hthree, neg_zero])
  · exact Or.inr (by rw [he, hthree, hn])

theorem abelianDoubletMatrix_neg_sq_orderThree (d h : G)
    (hhalf : h + h = 0)
    (hthree : (d + d) + d = 0 ∨ (d + d) + d = h) :
    abelianDoubletMatrix (-d) h ^ 2 = 2 * abelianDoubletMatrix d h := by
  simpa only [neg_neg] using abelianDoubletMatrix_sq_orderThree (-d) h hhalf
    (abelian_neg_three_mem_halfTurn d h hhalf hthree)

theorem abelianTranslationMatrix_commute_doublet (a d h : G) :
    Commute (abelianTranslationMatrix a) (abelianDoubletMatrix d h) :=
  (abelianTranslationMatrix_commute a d).add_right
    (abelianTranslationMatrix_commute a (d + h))

theorem abelianDoubletMatrix_commute (d e h : G) :
    Commute (abelianDoubletMatrix d h) (abelianDoubletMatrix e h) :=
  (abelianTranslationMatrix_commute_doublet d e h).add_left
    (abelianTranslationMatrix_commute_doublet (d + h) e h)

theorem abelianTranslationMatrix_pow (a : G) (n : ℕ) :
    abelianTranslationMatrix a ^ n = abelianTranslationMatrix (n • a) := by
  induction n with
  | zero => rw [pow_zero, zero_nsmul, abelianTranslationMatrix_zero]
  | succ n ih => rw [pow_succ, ih, abelianTranslationMatrix_mul, succ_nsmul]

/-- A sum of three translations; equality with Finset adjacency needs distinct supports. -/
def abelianTranslationTriple (a d h : G) : Matrix G G ℚ :=
  abelianTranslationMatrix a + abelianTranslationMatrix (a + d) +
    abelianTranslationMatrix ((a + d) + h)

theorem abelianTranslationTriple_eq_mul (a d h : G) :
    abelianTranslationTriple a d h =
      abelianTranslationMatrix a * (1 + abelianDoubletMatrix d h) := by
  simp [abelianTranslationTriple, abelianDoubletMatrix, mul_add,
    abelianTranslationMatrix_mul, add_assoc]

theorem abelianTranslationTriple_sq (a d h : G)
    (hhalf : h + h = 0)
    (hthree : (d + d) + d = 0 ∨ (d + d) + d = h) :
    abelianTranslationTriple a d h ^ 2 = abelianTranslationTriple a (-d) h ^ 2 := by
  rw [abelianTranslationTriple_eq_mul, abelianTranslationTriple_eq_mul]
  exact two_colour_mul_common_sq _ _ _
    (abelianTranslationMatrix_commute_doublet a d h)
    (abelianTranslationMatrix_commute_doublet a (-d) h)
    (abelianDoubletMatrix_sq_orderThree d h hhalf hthree)
    (abelianDoubletMatrix_neg_sq_orderThree d h hhalf hthree)

theorem abelianTranslationTriple_odd_pow_sub (a d h : G)
    (hhalf : h + h = 0)
    (hthree : (d + d) + d = 0 ∨ (d + d) + d = h) (n : ℕ) :
    abelianTranslationTriple a d h ^ (2 * n + 1) -
      abelianTranslationTriple a (-d) h ^ (2 * n + 1) =
        (-3) ^ n * abelianTranslationMatrix ((2 * n + 1) • a) *
          (abelianDoubletMatrix d h - abelianDoubletMatrix (-d) h) := by
  rw [abelianTranslationTriple_eq_mul, abelianTranslationTriple_eq_mul]
  rw [← abelianTranslationMatrix_pow]
  exact two_colour_mul_odd_pow_sub_scalar_first _ _ _
    (abelianTranslationMatrix_commute_doublet a d h)
    (abelianTranslationMatrix_commute_doublet a (-d) h)
    (abelianDoubletMatrix_commute d (-d) h)
    (abelianDoubletMatrix_sq_orderThree d h hhalf hthree)
    (abelianDoubletMatrix_neg_sq_orderThree d h hhalf hthree) n


theorem abelianTranslationMatrix_trace (t : G) :
    Matrix.trace (abelianTranslationMatrix t) =
      if t = 0 then (Fintype.card G : ℚ) else 0 := by
  have he (x : G) : x = x + t ↔ t = 0 := by
    constructor
    · intro hx
      have hz : (0 : G) = t := add_left_cancel (by simpa only [add_zero] using hx)
      exact hz.symm
    · rintro rfl
      exact (add_zero x).symm
  simp [Matrix.trace, Matrix.diag, abelianTranslationMatrix, he]

omit [AddCommGroup G] in
theorem abelianMatrix_intCast_mul (z : ℤ) (M : Matrix G G ℚ) :
    (z : Matrix G G ℚ) * M = (z : ℚ) • M := by
  rw [← Matrix.diagonal_intCast, ← Matrix.smul_eq_diagonal_mul]

omit [AddCommGroup G] in
theorem abelianMatrix_negThree_pow_mul (n : ℕ) (M : Matrix G G ℚ) :
    (-3 : Matrix G G ℚ) ^ n * M = (-3 : ℚ) ^ n • M := by
  simpa only [Int.cast_pow, Int.cast_neg, Int.cast_ofNat] using
    abelianMatrix_intCast_mul ((-3 : ℤ) ^ n) M

theorem abelianTranslationTriple_odd_trace_sub (a d h : G)
    (hhalf : h + h = 0)
    (hthree : (d + d) + d = 0 ∨ (d + d) + d = h) (n : ℕ) :
    Matrix.trace (abelianTranslationTriple a d h ^ (2 * n + 1)) -
      Matrix.trace (abelianTranslationTriple a (-d) h ^ (2 * n + 1)) =
      (-3 : ℚ) ^ n *
        ((if (2 * n + 1) • a + d = 0 then (Fintype.card G : ℚ) else 0) +
          (if (2 * n + 1) • a + (d + h) = 0 then (Fintype.card G : ℚ) else 0) -
          ((if (2 * n + 1) • a + (-d) = 0 then (Fintype.card G : ℚ) else 0) +
          (if (2 * n + 1) • a + (-d + h) = 0 then (Fintype.card G : ℚ) else 0))) := by
  rw [← Matrix.trace_sub, abelianTranslationTriple_odd_pow_sub a d h hhalf hthree n,
    mul_assoc, abelianMatrix_negThree_pow_mul, Matrix.trace_smul]
  simp only [abelianDoubletMatrix, mul_sub, mul_add, abelianTranslationMatrix_mul,
    Matrix.trace_sub, Matrix.trace_add, abelianTranslationMatrix_trace, smul_eq_mul]


omit [Fintype G] in
theorem abelian_halfTurn_return_pair (z h : G) (N : ℚ)
    (hhalf : h + h = 0) (hne : h ≠ 0) :
    (if z = 0 then N else 0) + (if z + h = 0 then N else 0) =
      if z = 0 ∨ z = h then N else 0 := by
  have he : z + h = 0 ↔ z = h := by
    constructor
    · intro hz
      calc
        z = (z + h) + h := by rw [add_assoc, hhalf, add_zero]
        _ = h := by rw [hz, zero_add]
    · rintro rfl
      exact hhalf
  simp only [he]
  by_cases hz : z = 0
  · subst z
    simp [Ne.symm hne]
  · simp [hz]

theorem abelianTranslationTriple_odd_trace_sub_halfTurn (a d h : G)
    (hhalf : h + h = 0) (hne : h ≠ 0)
    (hthree : (d + d) + d = 0 ∨ (d + d) + d = h) (n : ℕ) :
    Matrix.trace (abelianTranslationTriple a d h ^ (2 * n + 1)) -
      Matrix.trace (abelianTranslationTriple a (-d) h ^ (2 * n + 1)) =
      (-3 : ℚ) ^ n *
        ((if (2 * n + 1) • a + d = 0 ∨ (2 * n + 1) • a + d = h
            then (Fintype.card G : ℚ) else 0) -
          (if (2 * n + 1) • a + (-d) = 0 ∨ (2 * n + 1) • a + (-d) = h
            then (Fintype.card G : ℚ) else 0)) := by
  rw [abelianTranslationTriple_odd_trace_sub a d h hhalf hthree n]
  rw [← add_assoc ((2 * n + 1) • a) d h,
    ← add_assoc ((2 * n + 1) • a) (-d) h,
    abelian_halfTurn_return_pair _ h _ hhalf hne,
    abelian_halfTurn_return_pair _ h _ hhalf hne]



end Couret.CayleyDoublet

namespace Couret.CayleyDoublet

open Classical

variable {G : Type*} [AddCommGroup G] [DecidableEq G] [Fintype G]

/-- The matrix uses precisely the directed Cayley relation, with its loops. -/
theorem abelianCayleyMatrix_apply (S : Finset G) (x y : G) :
    abelianCayleyMatrix S x y = if CayleyArc S x y then 1 else 0 := by
  have he : CayleyArc S x y ↔ y - x ∈ S := by
    constructor
    · rintro ⟨s, hs, rfl⟩
      simpa using hs
    · intro hs
      exact ⟨y - x, hs, by abel⟩
  simp only [abelianCayleyMatrix, he]

/-- The certified finite-support convolution is the square of the actual
directed adjacency matrix. No global generation hypothesis is needed. -/
theorem abelianCayleyMatrix_sq_eq_of_quotient_order_three
    (a d h : G) (hhalf : h + h = 0) (hne : h ≠ 0)
    (horder : addOrderOf (d : G ⧸ AddSubgroup.zmultiples h) = 3) :
    abelianCayleyMatrix (AbelianSource a d h) ^ 2 =
      abelianCayleyMatrix (AbelianTarget a d h) ^ 2 := by
  obtain ⟨hthree, hd0, hdh⟩ :=
    (abelian_quotient_addOrderOf_three_iff d h hhalf).mp horder
  obtain ⟨hd2, hdh2⟩ :=
    no_cross_collision_of_order_three d h hhalf hd0 hdh hthree
  obtain ⟨hs1, hs2, ht1, ht2, _, _⟩ :=
    abelianSixSeparations_of_double_ne a d h hhalf hd2 hdh2
  have hhsep (b : G) : b ≠ b + h := by
    intro he
    apply hne
    exact add_left_cancel (show b + h = b + 0 by simpa using he.symm)
  ext x y
  rw [abelianCayleyMatrix_sq_apply, abelianCayleyMatrix_sq_apply,
    abelianOrderedSquare_source_target a d h (y - x) hhalf hthree
      hs1 hs2 (hhsep _) ht1 ht2 (hhsep _)]

/-- A supplied parity changes on every source and target arc. -/
theorem abelianThree_support_parity (a d h : G) (ε : G →+ ZMod 2)
    (ha : ε a = 1) (hd : ε d = 0) (hh : ε h = 0) :
    (∀ s ∈ AbelianSource a d h, ε s = 1) ∧
      (∀ s ∈ AbelianTarget a d h, ε s = 1) := by
  constructor
  · intro s hs
    simp only [AbelianSource, TripleSupport, Finset.mem_insert,
      Finset.mem_singleton] at hs
    rcases hs with rfl | rfl | rfl <;> simp [ha, hd, hh]
  · intro s hs
    simp only [AbelianTarget, TripleSupport, Finset.mem_insert,
      Finset.mem_singleton] at hs
    rcases hs with rfl | rfl | rfl <;> simp [ha, hd, hh]

/-- A parity killing h automatically kills d under the three-torsion premise. -/
theorem abelianThree_parity_d_zero (d h : G) (ε : G →+ ZMod 2)
    (hthree : (d + d) + d = 0 ∨ (d + d) + d = h) (hh : ε h = 0) :
    ε d = 0 := by
  have he : ε ((d + d) + d) = 0 := by
    rcases hthree with he | he <;> simp [he, hh]
  have ht : ε d + ε d = 0 := (by decide : ∀ x : ZMod 2, x + x = 0) (ε d)
  simpa only [map_add, ht, zero_add] using he

/-- Conditional spectral sufficiency for the actual finite directed graphs.
The parity is explicit; neither existence from quotient cardinality nor the
necessity of parity is assumed or asserted here. Its value at d is derived. -/
theorem abelianThreeCospectral_of_parity
    (a d h : G) (hhalf : h + h = 0) (hne : h ≠ 0)
    (horder : addOrderOf (d : G ⧸ AddSubgroup.zmultiples h) = 3)
    (ε : G →+ ZMod 2) (ha : ε a = 1) (hh : ε h = 0) :
    (abelianCayleyMatrix (AbelianSource a d h)).charpoly =
      (abelianCayleyMatrix (AbelianTarget a d h)).charpoly := by
  have hd : ε d = 0 := abelianThree_parity_d_zero d h ε
    ((abelian_quotient_addOrderOf_three_iff d h hhalf).mp horder).1 hh
  obtain ⟨hS, hT⟩ := abelianThree_support_parity a d h ε ha hd hh
  exact Couret.CayleySpectral.charpoly_eq_of_sq_eq_of_signs _ _
    (abelianParitySign ε) (abelianParitySign ε)
    (abelianParitySign_sq ε) (abelianParitySign_sq ε)
    (abelianCayleyMatrix_parity_sign _ ε hS)
    (abelianCayleyMatrix_parity_sign _ ε hT)
    (abelianCayleyMatrix_sq_eq_of_quotient_order_three a d h hhalf hne horder)

/-- Directed graph isomorphisms give equal characteristic polynomials. -/
theorem abelianCayleyMatrix_charpoly_of_iso (S T : Finset G)
    (f : G ≃ G) (hf : ∀ x y, CayleyArc S x y ↔ CayleyArc T (f x) (f y)) :
    (abelianCayleyMatrix S).charpoly = (abelianCayleyMatrix T).charpoly := by
  have hm : abelianCayleyMatrix S =
      Matrix.reindex f.symm f.symm (abelianCayleyMatrix T) := by
    ext x y
    simp only [Matrix.reindex_apply, Matrix.submatrix_apply,
      Equiv.symm_symm, abelianCayleyMatrix_apply, hf]
  rw [hm, Matrix.charpoly_reindex]

/-- The already certified nongeneration branch is cospectral, independently
of any parity witness. The generation hypothesis of that branch is retained. -/
theorem abelianThreeCospectral_of_nongeneration
    (a d h : G) (hhalf : h + h = 0) (hne : h ≠ 0)
    (horder : addOrderOf (d : G ⧸ AddSubgroup.zmultiples h) = 3)
    (hgen : AddSubgroup.closure ({a, d, h} : Set G) = ⊤)
    (hproper : AddSubgroup.closure ({a, h} : Set G) ≠ ⊤) :
    (abelianCayleyMatrix (AbelianSource a d h)).charpoly =
      (abelianCayleyMatrix (AbelianTarget a d h)).charpoly := by
  obtain ⟨f, hf⟩ :=
    (abelianThreeIso_iff_nongeneration_of_quotient_order_three
      a d h hhalf hne horder hgen).mpr hproper
  exact abelianCayleyMatrix_charpoly_of_iso _ _ f hf

/-- Finset adjacency agrees with the three translation sum when all three
increments are distinct. This is the required protection against multiplicities. -/
theorem abelianCayleyMatrix_triple (a b c : G)
    (hab : a ≠ b) (hac : a ≠ c) (hbc : b ≠ c) :
    abelianCayleyMatrix ({a, b, c} : Finset G) =
      abelianTranslationMatrix a + abelianTranslationMatrix b +
        abelianTranslationMatrix c := by
  rw [abelianCayleyMatrix_eq_sum]
  have ha : a ∉ ({b, c} : Finset G) := by simp [hab, hac]
  have hb : b ∉ ({c} : Finset G) := by simp [hbc]
  rw [Finset.sum_insert ha, Finset.sum_insert hb, Finset.sum_singleton, add_assoc]

theorem abelianCayleyMatrix_source_target_eq_translationTriple
    (a d h : G) (hhalf : h + h = 0) (hne : h ≠ 0)
    (horder : addOrderOf (d : G ⧸ AddSubgroup.zmultiples h) = 3) :
    abelianCayleyMatrix (AbelianSource a d h) = abelianTranslationTriple a d h ∧
      abelianCayleyMatrix (AbelianTarget a d h) = abelianTranslationTriple a (-d) h := by
  obtain ⟨hthree, hd0, hdh⟩ :=
    (abelian_quotient_addOrderOf_three_iff d h hhalf).mp horder
  obtain ⟨hd2, hdh2⟩ :=
    no_cross_collision_of_order_three d h hhalf hd0 hdh hthree
  obtain ⟨hs1, hs2, ht1, ht2, _, _⟩ :=
    abelianSixSeparations_of_double_ne a d h hhalf hd2 hdh2
  have hhsep (b : G) : b ≠ b + h := by
    intro he
    apply hne
    exact add_left_cancel (show b + h = b + 0 by simpa using he.symm)
  constructor
  · exact abelianCayleyMatrix_triple a (a + d) ((a + d) + h) hs1 hs2 (hhsep _)
  · simpa only [AbelianTarget, TripleSupport, abelianTranslationTriple, sub_eq_add_neg]
      using abelianCayleyMatrix_triple a (a - d) ((a - d) + h) ht1 ht2 (hhsep _)

/-- Exact difference of every odd power of the actual directed adjacency
matrices. Finiteness is used for matrix multiplication, not generation. -/
theorem abelianThree_odd_pow_sub
    (a d h : G) (hhalf : h + h = 0) (hne : h ≠ 0)
    (horder : addOrderOf (d : G ⧸ AddSubgroup.zmultiples h) = 3) (n : ℕ) :
    abelianCayleyMatrix (AbelianSource a d h) ^ (2 * n + 1) -
      abelianCayleyMatrix (AbelianTarget a d h) ^ (2 * n + 1) =
        (-3) ^ n * abelianTranslationMatrix ((2 * n + 1) • a) *
          (abelianDoubletMatrix d h - abelianDoubletMatrix (-d) h) := by
  obtain ⟨hthree, _, _⟩ :=
    (abelian_quotient_addOrderOf_three_iff d h hhalf).mp horder
  obtain ⟨hS, hT⟩ :=
    abelianCayleyMatrix_source_target_eq_translationTriple a d h hhalf hne horder
  rw [hS, hT]
  exact abelianTranslationTriple_odd_pow_sub a d h hhalf hthree n

/-- Under the supplied parity, all odd closed-walk traces vanish separately. -/
theorem abelianThree_odd_traces_zero_of_parity
    (a d h : G) (ε : G →+ ZMod 2)
    (ha : ε a = 1) (hd : ε d = 0) (hh : ε h = 0) (n : ℕ) (hn : Odd n) :
    Matrix.trace (abelianCayleyMatrix (AbelianSource a d h) ^ n) = 0 ∧
      Matrix.trace (abelianCayleyMatrix (AbelianTarget a d h) ^ n) = 0 := by
  obtain ⟨hS, hT⟩ := abelianThree_support_parity a d h ε ha hd hh
  constructor
  · exact Couret.CayleySpectral.trace_pow_eq_zero_of_odd_of_signs _
      (abelianParitySign ε) (abelianParitySign_sq ε)
      (abelianCayleyMatrix_parity_sign _ ε hS) n hn
  · exact Couret.CayleySpectral.trace_pow_eq_zero_of_odd_of_signs _
      (abelianParitySign ε) (abelianParitySign_sq ε)
      (abelianCayleyMatrix_parity_sign _ ε hT) n hn

/-- Exact odd-trace difference in terms of return to the half-turn subgroup. -/
theorem abelianThree_odd_trace_sub
    (a d h : G) (hhalf : h + h = 0) (hne : h ≠ 0)
    (horder : addOrderOf (d : G ⧸ AddSubgroup.zmultiples h) = 3) (n : ℕ) :
    Matrix.trace (abelianCayleyMatrix (AbelianSource a d h) ^ (2 * n + 1)) -
      Matrix.trace (abelianCayleyMatrix (AbelianTarget a d h) ^ (2 * n + 1)) =
      (-3 : ℚ) ^ n *
        ((if (2 * n + 1) • a + d ∈ AddSubgroup.zmultiples h
          then (Fintype.card G : ℚ) else 0) -
         (if (2 * n + 1) • a - d ∈ AddSubgroup.zmultiples h
          then (Fintype.card G : ℚ) else 0)) := by
  obtain ⟨hthree, _, _⟩ :=
    (abelian_quotient_addOrderOf_three_iff d h hhalf).mp horder
  obtain ⟨hS, hT⟩ :=
    abelianCayleyMatrix_source_target_eq_translationTriple a d h hhalf hne horder
  rw [hS, hT]
  simp only [abelian_mem_zmultiples_halfTurn_iff h ((2 * n + 1) • a + d) hhalf,
    abelian_mem_zmultiples_halfTurn_iff h ((2 * n + 1) • a - d) hhalf]
  simpa only [sub_eq_add_neg] using
    abelianTranslationTriple_odd_trace_sub_halfTurn a d h hhalf hne hthree n

/-- An odd trace differs exactly when the corresponding odd multiple of a
returns to one of the two quotient classes d+H and -d+H. -/
theorem abelianThree_odd_trace_ne_iff
    (a d h : G) (hhalf : h + h = 0) (hne : h ≠ 0)
    (horder : addOrderOf (d : G ⧸ AddSubgroup.zmultiples h) = 3) (n : ℕ) :
    Matrix.trace (abelianCayleyMatrix (AbelianSource a d h) ^ (2 * n + 1)) ≠
      Matrix.trace (abelianCayleyMatrix (AbelianTarget a d h) ^ (2 * n + 1)) ↔
        (2 * n + 1) • a + d ∈ AddSubgroup.zmultiples h ∨
          (2 * n + 1) • a - d ∈ AddSubgroup.zmultiples h := by
  obtain ⟨hthree, hd0, hdh⟩ :=
    (abelian_quotient_addOrderOf_three_iff d h hhalf).mp horder
  obtain ⟨hd2, hdh2⟩ :=
    no_cross_collision_of_order_three d h hhalf hd0 hdh hthree
  have hdisjoint : ¬ ((2 * n + 1) • a + d ∈ AddSubgroup.zmultiples h ∧
      (2 * n + 1) • a - d ∈ AddSubgroup.zmultiples h) := by
    rintro ⟨hp, hm⟩
    have he : d + d ∈ AddSubgroup.zmultiples h := by
      have ht := (AddSubgroup.zmultiples h).sub_mem hp hm
      convert ht using 1 <;> abel
    rcases (abelian_mem_zmultiples_halfTurn_iff h (d + d) hhalf).mp he with he | he
    · exact hd2 he
    · exact hdh2 he
  have hcard : (Fintype.card G : ℚ) ≠ 0 := by
    exact_mod_cast Fintype.card_ne_zero (α := G)
  have hpow : (-3 : ℚ) ^ n ≠ 0 := pow_ne_zero n (by norm_num)
  rw [← sub_ne_zero, abelianThree_odd_trace_sub a d h hhalf hne horder n]
  by_cases hp : (2 * n + 1) • a + d ∈ AddSubgroup.zmultiples h <;>
    by_cases hm : (2 * n + 1) • a - d ∈ AddSubgroup.zmultiples h <;>
      simp_all

end Couret.CayleyDoublet

#print axioms Couret.CayleySpectral.charpoly_eq_of_sq_eq_of_signs
#print axioms Couret.CayleySpectral.trace_pow_eq_zero_of_odd_of_signs
#print axioms Couret.CayleySpectral.odd_pow_sub_of_sq_eq
#print axioms Couret.CayleyDoublet.abelianCayleyMatrix_apply
#print axioms Couret.CayleyDoublet.abelianCayleyMatrix_sq_apply
#print axioms Couret.CayleyDoublet.abelianCayleyMatrix_sq_eq_of_quotient_order_three
#print axioms Couret.CayleyDoublet.abelianThreeCospectral_of_parity
#print axioms Couret.CayleyDoublet.abelianThree_parity_d_zero
#print axioms Couret.CayleyDoublet.abelianCayleyMatrix_charpoly_of_iso
#print axioms Couret.CayleyDoublet.abelianThreeCospectral_of_nongeneration
#print axioms Couret.CayleyDoublet.abelianThree_odd_pow_sub
#print axioms Couret.CayleyDoublet.abelianThree_odd_traces_zero_of_parity
#print axioms Couret.CayleyDoublet.abelianThree_odd_trace_sub
#print axioms Couret.CayleyDoublet.abelianThree_odd_trace_ne_iff
