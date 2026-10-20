import CayleyTwoColourClassification

/-!
COU-20: the first differing characteristic-polynomial coefficient.

The original spectral equivalence and first-trace certificates are imported
unchanged. We reuse the previously proved finite Newton prefix identities,
the generic single-matrix Newton theorem, and the canonical odd quotient
return. All statements refer to the actual rational directed adjacency
matrices (including their loops).

The numerical absolute-gap formula remains a documented mathematical
corollary, not a claim of formalization in this file.
-/

set_option autoImplicit false
noncomputable section

namespace Couret.CayleyDoublet

open Couret.CayleyNewton

variable {G : Type*} [AddCommGroup G] [DecidableEq G] [Fintype G]

/-- In the generated odd-quotient case, the coefficient of X^(|G|-k)
with k=|G/<h>|/3 is the first *non-leading* characteristic-polynomial
coefficient that differs. The leading coefficient (index zero) is 1
for both monic characteristic polynomials.
No extra global-generation premise is used. -/
theorem abelianThree_first_charpoly_coefficient_at_quotient_third
    (a d h : G)
    (hhalf : h + h = 0) (hne : h ≠ 0)
    (horder : addOrderOf (d : G ⧸ AddSubgroup.zmultiples h) = 3)
    (hpair : AddSubgroup.closure ({a, h} : Set G) = ⊤)
    (hodd : Odd (Nat.card (G ⧸ AddSubgroup.zmultiples h))) :
    (∀ j : ℕ, 0 < j →
      j < Nat.card (G ⧸ AddSubgroup.zmultiples h) / 3 →
      reverseCharpolyCoeff (abelianCayleyMatrix (AbelianSource a d h)) j =
        reverseCharpolyCoeff (abelianCayleyMatrix (AbelianTarget a d h)) j) ∧
    reverseCharpolyCoeff (abelianCayleyMatrix (AbelianSource a d h))
      (Nat.card (G ⧸ AddSubgroup.zmultiples h) / 3) ≠
    reverseCharpolyCoeff (abelianCayleyMatrix (AbelianTarget a d h))
      (Nat.card (G ⧸ AddSubgroup.zmultiples h) / 3) := by
  let k : ℕ := Nat.card (G ⧸ AddSubgroup.zmultiples h) / 3
  let A : Matrix G G ℚ := abelianCayleyMatrix (AbelianSource a d h)
  let B : Matrix G G ℚ := abelianCayleyMatrix (AbelianTarget a d h)
  have hfirst : 0 < k ∧ Odd k ∧
      (∀ j : ℕ, j < k → Matrix.trace (A ^ j) = Matrix.trace (B ^ j)) ∧
      Matrix.trace (A ^ k) ≠ Matrix.trace (B ^ k) :=
    abelianThree_first_trace_difference_at_quotient_third
      a d h hhalf hne horder hpair hodd
  obtain ⟨hk, _, hprev, hdiff⟩ := hfirst
  have hprevPos : ∀ j : ℕ, 0 < j → j < k →
      Matrix.trace (A ^ j) = Matrix.trace (B ^ j) := by
    intro j _ hj
    exact hprev j hj
  have hS : SatisfiesMatrixNewton A := satisfiesMatrixNewton A
  have hT : SatisfiesMatrixNewton B := satisfiesMatrixNewton B
  have hprefix : ∀ j : ℕ, 0 < j → j < k →
      reverseCharpolyCoeff A j = reverseCharpolyCoeff B j :=
    newton_coefficient_prefix_eq
      (reverseCharpolyCoeff A) (reverseCharpolyCoeff B)
      (fun j => Matrix.trace (A ^ j)) (fun j => Matrix.trace (B ^ j)) k
      (fun j hj _ => hS j hj) (fun j hj _ => hT j hj) hprevPos
  have hgap : reverseCharpolyCoeff A k ≠ reverseCharpolyCoeff B k :=
    newton_first_coefficient_ne_of_trace_prefix
      (reverseCharpolyCoeff A) (reverseCharpolyCoeff B)
      (fun j => Matrix.trace (A ^ j)) (fun j => Matrix.trace (B ^ j))
      k hk (fun j hj _ => hS j hj) (fun j hj _ => hT j hj)
      hprevPos hdiff
  exact ⟨hprefix, hgap⟩

/-- Exact *signed* Newton relation at the first differing coefficient.
The coefficient gap multiplied by k is the negative power-trace gap.
This uses no absolute-value arithmetic and no unverified formula. -/
theorem abelianThree_first_charpoly_coefficient_gap_at_quotient_third
    (a d h : G)
    (hhalf : h + h = 0) (hne : h ≠ 0)
    (horder : addOrderOf (d : G ⧸ AddSubgroup.zmultiples h) = 3)
    (hpair : AddSubgroup.closure ({a, h} : Set G) = ⊤)
    (hodd : Odd (Nat.card (G ⧸ AddSubgroup.zmultiples h))) :
    let k := Nat.card (G ⧸ AddSubgroup.zmultiples h) / 3
    (k : ℚ) * (
      reverseCharpolyCoeff (abelianCayleyMatrix (AbelianSource a d h)) k -
      reverseCharpolyCoeff (abelianCayleyMatrix (AbelianTarget a d h)) k) =
      -(Matrix.trace (abelianCayleyMatrix (AbelianSource a d h) ^ k) -
        Matrix.trace (abelianCayleyMatrix (AbelianTarget a d h) ^ k)) := by
  let k : ℕ := Nat.card (G ⧸ AddSubgroup.zmultiples h) / 3
  let A : Matrix G G ℚ := abelianCayleyMatrix (AbelianSource a d h)
  let B : Matrix G G ℚ := abelianCayleyMatrix (AbelianTarget a d h)
  have hfirst : 0 < k ∧ Odd k ∧
      (∀ j : ℕ, j < k → Matrix.trace (A ^ j) = Matrix.trace (B ^ j)) ∧
      Matrix.trace (A ^ k) ≠ Matrix.trace (B ^ k) :=
    abelianThree_first_trace_difference_at_quotient_third
      a d h hhalf hne horder hpair hodd
  obtain ⟨hk, _, hprev, _⟩ := hfirst
  have hprevPos : ∀ j : ℕ, 0 < j → j < k →
      Matrix.trace (A ^ j) = Matrix.trace (B ^ j) := by
    intro j _ hj
    exact hprev j hj
  have hS : SatisfiesMatrixNewton A := satisfiesMatrixNewton A
  have hT : SatisfiesMatrixNewton B := satisfiesMatrixNewton B
  exact newton_first_gap_of_trace_prefix
    (reverseCharpolyCoeff A) (reverseCharpolyCoeff B)
    (fun j => Matrix.trace (A ^ j)) (fun j => Matrix.trace (B ^ j))
    k hk (fun j hj _ => hS j hj) (fun j hj _ => hT j hj) hprevPos


/-- A nonzero odd-power trace discrepancy has the exact unsigned size
card(G)*3^n, for the actual directed adjacency matrices. -/
theorem abelianThree_odd_trace_gap_abs_of_ne
    (a d h : G)
    (hhalf : h + h = 0) (hne : h ≠ 0)
    (horder : addOrderOf (d : G ⧸ AddSubgroup.zmultiples h) = 3)
    (n : ℕ)
    (hdiff : Matrix.trace
      (abelianCayleyMatrix (AbelianSource a d h) ^ (2 * n + 1)) ≠
      Matrix.trace (abelianCayleyMatrix (AbelianTarget a d h) ^ (2 * n + 1))) :
    |Matrix.trace (abelianCayleyMatrix (AbelianSource a d h) ^ (2 * n + 1)) -
      Matrix.trace (abelianCayleyMatrix (AbelianTarget a d h) ^ (2 * n + 1))| =
      (Fintype.card G : ℚ) * (3 : ℚ) ^ n := by
  let A : Matrix G G ℚ := abelianCayleyMatrix (AbelianSource a d h)
  let B : Matrix G G ℚ := abelianCayleyMatrix (AbelianTarget a d h)
  have hformula := abelianThree_odd_trace_sub a d h hhalf hne horder n
  let hp : Prop := (2 * n + 1) • a + d ∈ AddSubgroup.zmultiples h
  let hm : Prop := (2 * n + 1) • a - d ∈ AddSubgroup.zmultiples h
  have hcard : (0 : ℚ) ≤ (Fintype.card G : ℚ) := by positivity
  have hpow : |(-3 : ℚ) ^ n| = (3 : ℚ) ^ n := by
    simp [abs_pow]
  by_cases hplus : hp
  · by_cases hminus : hm
    · have hz :
          Matrix.trace (A ^ (2 * n + 1)) -
            Matrix.trace (B ^ (2 * n + 1)) = 0 := by
        simpa [hp, hm, hplus, hminus] using hformula
      exact (hdiff (sub_eq_zero.mp hz)).elim
    · have he :
          Matrix.trace (A ^ (2 * n + 1)) -
            Matrix.trace (B ^ (2 * n + 1)) =
              (-3 : ℚ) ^ n * (Fintype.card G : ℚ) := by
        simpa [hp, hm, hplus, hminus] using hformula
      rw [he, abs_mul, hpow, abs_of_nonneg hcard]
      ring
  · by_cases hminus : hm
    · have he :
          Matrix.trace (A ^ (2 * n + 1)) -
            Matrix.trace (B ^ (2 * n + 1)) =
              -((-3 : ℚ) ^ n * (Fintype.card G : ℚ)) := by
        simpa [hp, hm, hplus, hminus, mul_neg] using hformula
      rw [he, abs_neg, abs_mul, hpow, abs_of_nonneg hcard]
      ring
    · have hz :
          Matrix.trace (A ^ (2 * n + 1)) -
            Matrix.trace (B ^ (2 * n + 1)) = 0 := by
        simpa [hp, hm, hplus, hminus] using hformula
      exact (hdiff (sub_eq_zero.mp hz)).elim

/-- A nonzero half-turn generates a subgroup of cardinal 2. Combined
with odd quotient size 3*k this gives the exact ambient size 6*k. -/
theorem abelianThree_card_eq_six_quotient_third
    (h : G) (hhalf : h + h = 0) (hne : h ≠ 0)
    (k : ℕ)
    (hsize : Nat.card (G ⧸ AddSubgroup.zmultiples h) = 3 * k) :
    Fintype.card G = 6 * k := by
  have htwo : addOrderOf h = 2 := by
    have hsmul : (2 : ℕ) • h = 0 := by simpa [two_nsmul] using hhalf
    have hdiv : addOrderOf h ∣ 2 :=
      (addOrderOf_dvd_iff_nsmul_eq_zero).mpr hsmul
    have hnotone : addOrderOf h ≠ 1 := by
      intro horder
      have hz := addOrderOf_nsmul_eq_zero h
      rw [horder] at hz
      exact hne (by simpa using hz)
    have hle : addOrderOf h ≤ 2 :=
      Nat.le_of_dvd (by decide : 0 < 2) hdiv
    have hnonzero : addOrderOf h ≠ 0 := by
      intro hz
      simp [hz] at hdiv
    omega
  have hsub : Nat.card (AddSubgroup.zmultiples h) = 2 := by
    simpa only [Nat.card_zmultiples] using htwo
  calc
    Fintype.card G = Nat.card G := Nat.card_eq_fintype_card.symm
    _ = Nat.card (G ⧸ AddSubgroup.zmultiples h) *
        Nat.card (AddSubgroup.zmultiples h) :=
      AddSubgroup.card_eq_card_quotient_mul_card_addSubgroup _
    _ = 6 * k := by rw [hsub, hsize]; omega

/-- Fully numerical first coefficient discrepancy in the odd quotient
branch: the magnitude is 6*3^((k-1)/2), k=card(G/<h>)/3. -/
theorem abelianThree_first_charpoly_coefficient_abs_gap
    (a d h : G)
    (hhalf : h + h = 0) (hne : h ≠ 0)
    (horder : addOrderOf (d : G ⧸ AddSubgroup.zmultiples h) = 3)
    (hpair : AddSubgroup.closure ({a, h} : Set G) = ⊤)
    (hodd : Odd (Nat.card (G ⧸ AddSubgroup.zmultiples h))) :
    let k := Nat.card (G ⧸ AddSubgroup.zmultiples h) / 3
    |reverseCharpolyCoeff (abelianCayleyMatrix (AbelianSource a d h)) k -
      reverseCharpolyCoeff (abelianCayleyMatrix (AbelianTarget a d h)) k| =
      6 * (3 : ℚ) ^ ((k - 1) / 2) := by
  let k : ℕ := Nat.card (G ⧸ AddSubgroup.zmultiples h) / 3
  let A : Matrix G G ℚ := abelianCayleyMatrix (AbelianSource a d h)
  let B : Matrix G G ℚ := abelianCayleyMatrix (AbelianTarget a d h)
  have hfirst := abelianThree_first_trace_difference_at_quotient_third
    a d h hhalf hne horder hpair hodd
  dsimp only at hfirst
  obtain ⟨hk, hkodd, _, hdiff⟩ := hfirst
  obtain ⟨n, hn⟩ := hkodd
  have hncalc : (k - 1) / 2 = n := by omega
  have hsize : Nat.card (G ⧸ AddSubgroup.zmultiples h) = 3 * k := by
    obtain ⟨ell, _, _, hcard, _⟩ :=
      abelianThree_exists_canonical_odd_return a d h hpair hodd horder
    dsimp only [k]
    omega
  have hcNat : Fintype.card G = 6 * k :=
    abelianThree_card_eq_six_quotient_third h hhalf hne k hsize
  have hc : (Fintype.card G : ℚ) = 6 * (k : ℚ) := by
    exact_mod_cast hcNat
  have hk' : k = 2 * n + 1 := hn
  have htrace :
      |Matrix.trace (A ^ k) - Matrix.trace (B ^ k)| =
        (Fintype.card G : ℚ) * (3 : ℚ) ^ n := by
    have hdiffK : Matrix.trace (A ^ k) ≠ Matrix.trace (B ^ k) := by
      exact hdiff
    have hdiffN : Matrix.trace (A ^ (2 * n + 1)) ≠
        Matrix.trace (B ^ (2 * n + 1)) := by
      simpa only [hk'] using hdiffK
    rw [hk']
    exact abelianThree_odd_trace_gap_abs_of_ne a d h
      hhalf hne horder n hdiffN
  have hnewton :
      (k : ℚ) * (reverseCharpolyCoeff A k - reverseCharpolyCoeff B k) =
       -(Matrix.trace (A ^ k) - Matrix.trace (B ^ k)) :=
    abelianThree_first_charpoly_coefficient_gap_at_quotient_third
      a d h hhalf hne horder hpair hodd
  have habs := congrArg abs hnewton
  rw [abs_mul, abs_of_nonneg (by positivity : (0 : ℚ) ≤ (k : ℚ)),
    abs_neg, htrace, hc] at habs
  have hk0 : (k : ℚ) ≠ 0 := by exact_mod_cast (Nat.ne_of_gt hk)
  have hmul :
      (k : ℚ) * |reverseCharpolyCoeff A k - reverseCharpolyCoeff B k| =
        (k : ℚ) * (6 * (3 : ℚ) ^ n) := by
    calc
      _ = 6 * (k : ℚ) * (3 : ℚ) ^ n := habs
      _ = _ := by ring
  have hcoeff : |reverseCharpolyCoeff A k - reverseCharpolyCoeff B k| =
      6 * (3 : ℚ) ^ n :=
    (mul_left_cancel₀ hk0) hmul
  change |reverseCharpolyCoeff A k - reverseCharpolyCoeff B k| =
    6 * (3 : ℚ) ^ ((k - 1) / 2)
  simpa only [hncalc] using hcoeff


end Couret.CayleyDoublet

#print axioms Couret.CayleyDoublet.abelianThree_first_charpoly_coefficient_at_quotient_third
#print axioms Couret.CayleyDoublet.abelianThree_first_charpoly_coefficient_gap_at_quotient_third
#print axioms Couret.CayleyDoublet.abelianThree_odd_trace_gap_abs_of_ne
#print axioms Couret.CayleyDoublet.abelianThree_card_eq_six_quotient_third
#print axioms Couret.CayleyDoublet.abelianThree_first_charpoly_coefficient_abs_gap
