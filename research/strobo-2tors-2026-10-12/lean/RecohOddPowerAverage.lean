import Mathlib.Analysis.Complex.Basic
import Mathlib.Data.Complex.BigOperators
import Mathlib.Tactic.LinearCombination
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Ring

set_option autoImplicit false

/-!
# Averaging odd powers of three roots of even order

The order is written `2 * m`, with `0 < m`.  This includes the entire
2-primary case and keeps the geometric-sum argument independent of a
particular presentation of the order.  Repeated complex phases are allowed.

The energy at index `j` is the squared norm of the reading at exponent
`2 * j + 1`.  An opposite pair makes every such energy equal to one.
Otherwise their sum is at least `3 * m`, and some energy is at least three.
-/

namespace Couret.STROBO2TORS

open scoped BigOperators

/-- The squared magnitude of the three-phase reading at the `j`th odd
exponent.  It is an analytic quantity, not a floating-point calculation. -/
noncomputable def recohOddPowerEnergy (a b c : ℂ) (j : ℕ) : ℝ :=
  ‖a ^ (2 * j + 1) + b ^ (2 * j + 1) + c ^ (2 * j + 1)‖ ^ 2

/-- An opposite pair among the three labelled phases. -/
def RecohHasOppositePair (a b c : ℂ) : Prop :=
  a = -b ∨ a = -c ∨ b = -c

/-- The contribution of a pair to odd-power orthogonality. -/
noncomputable def recohOddPairCorrelation (a b : ℂ) : ℝ := by
  classical
  exact (if a = b then 1 else 0) - (if a = -b then 1 else 0)

/-- Number of equal unordered pairs of labelled phases, retaining multiplicity. -/
noncomputable def recohEqualPhasePairs (a b c : ℂ) : ℕ := by
  classical
  exact (if a = b then 1 else 0) + (if a = c then 1 else 0) +
    (if b = c then 1 else 0)

/-- Number of opposite unordered pairs of labelled phases, retaining multiplicity. -/
noncomputable def recohOppositePhasePairs (a b c : ℂ) : ℕ := by
  classical
  exact (if a = -b then 1 else 0) + (if a = -c then 1 else 0) +
    (if b = -c then 1 else 0)

/-- Telescoping identity for the unnormalized odd-power sum. -/
theorem recoh_odd_power_sum_mul (m : ℕ) (z : ℂ) :
    (∑ j ∈ Finset.range m, z ^ (2 * j + 1)) * (z ^ 2 - 1) =
      z ^ (2 * m + 1) - z := by
  induction m with
  | zero => simp
  | succ m ih =>
      rw [Finset.sum_range_succ, add_mul, ih]
      rw [show 2 * (m + 1) + 1 = (2 * m + 1) + 2 by omega, pow_add]
      ring

/-- The odd-power geometric sum is nonzero only at the two real roots. -/
theorem recoh_odd_power_sum (m : ℕ) (z : ℂ)
    (hz : z ^ (2 * m) = 1) :
    (∑ j ∈ Finset.range m, z ^ (2 * j + 1)) =
      if z = 1 then (m : ℂ) else if z = -1 then -(m : ℂ) else 0 := by
  classical
  by_cases h1 : z = 1
  · simp [h1]
  by_cases hn : z = -1
  · rw [if_neg h1, if_pos hn, hn]
    simp [pow_add, pow_mul]
  simp only [h1, hn, if_false]
  have hfactor : z ^ 2 - 1 ≠ 0 := by
    intro h
    have hprod : (z - 1) * (z + 1) = 0 := by linear_combination h
    rcases mul_eq_zero.mp hprod with hleft | hright
    · exact h1 (sub_eq_zero.mp hleft)
    · exact hn (eq_neg_of_add_eq_zero_left hright)
  have htel := recoh_odd_power_sum_mul m z
  rw [pow_add, hz, pow_one, one_mul, sub_self] at htel
  exact (mul_eq_zero.mp htel).resolve_right hfactor

/-- Unit-modulus conjugation gives the inverse without division. -/
theorem recoh_unit_conj_mul (z : ℂ) (hz : ‖z‖ = 1) :
    star z * z = 1 := by
  simpa [hz, mul_comm] using Complex.mul_conj' z

/-- A pair ratio equals one exactly for equal phases. -/
theorem recoh_unit_pair_eq_one_iff (a b : ℂ) (hb : ‖b‖ = 1) :
    a * star b = 1 ↔ a = b := by
  have hbb := recoh_unit_conj_mul b hb
  constructor
  · intro h
    calc
      a = (a * star b) * b := by rw [mul_assoc, hbb, mul_one]
      _ = b := by rw [h, one_mul]
  · rintro rfl
    simpa [mul_comm] using hbb

/-- A pair ratio equals minus one exactly for opposite phases. -/
theorem recoh_unit_pair_eq_neg_one_iff (a b : ℂ) (hb : ‖b‖ = 1) :
    a * star b = -1 ↔ a = -b := by
  have hbb := recoh_unit_conj_mul b hb
  constructor
  · intro h
    calc
      a = (a * star b) * b := by rw [mul_assoc, hbb, mul_one]
      _ = -b := by rw [h, neg_one_mul]
  · rintro rfl
    rw [neg_mul, mul_comm b, hbb]

/-- Odd-power orthogonality for a pair of roots of the same even order. -/
theorem recoh_odd_pair_sum (m : ℕ) (a b : ℂ)
    (ha : a ^ (2 * m) = 1) (hb : b ^ (2 * m) = 1)
    (hbn : ‖b‖ = 1) :
    (∑ j ∈ Finset.range m, ((a * star b) ^ (2 * j + 1)).re) =
      (m : ℝ) * recohOddPairCorrelation a b := by
  classical
  have hstar : (star b) ^ (2 * m) = 1 := by
    simpa only [map_pow, map_one] using congrArg (starRingEnd ℂ) hb
  have hroot : (a * star b) ^ (2 * m) = 1 := by
    rw [mul_pow, ha, hstar, one_mul]
  have hsum := congrArg Complex.re (recoh_odd_power_sum m (a * star b) hroot)
  have hzero : b ≠ 0 := by
    intro h
    simp [h] at hbn
  have hnotboth : a = b → a ≠ -b := by
    intro hab hop
    have h : b = -b := hab.symm.trans hop
    have htwo : (2 : ℂ) * b = 0 := by linear_combination h
    exact hzero ((mul_eq_zero.mp htwo).resolve_left (by norm_num))
  simp only [recoh_unit_pair_eq_one_iff a b hbn,
    recoh_unit_pair_eq_neg_one_iff a b hbn] at hsum
  by_cases hab : a = b
  · rw [if_pos hab] at hsum
    rw [recohOddPairCorrelation, if_pos hab, if_neg (hnotboth hab)]
    simpa using hsum
  by_cases hop : a = -b
  · rw [if_neg hab, if_pos hop] at hsum
    rw [recohOddPairCorrelation, if_neg hab, if_pos hop]
    simpa using hsum
  · rw [if_neg hab, if_neg hop] at hsum
    rw [recohOddPairCorrelation, if_neg hab, if_neg hop]
    simpa using hsum

/-- The squared norm of a three-phase sum expands into three pair terms. -/
theorem recoh_unit_three_energy (a b c : ℂ)
    (ha : ‖a‖ = 1) (hb : ‖b‖ = 1) (hc : ‖c‖ = 1) :
    ‖a + b + c‖ ^ 2 =
      3 + 2 * ((a * star b).re + (a * star c).re + (b * star c).re) := by
  have han : a.re * a.re + a.im * a.im = 1 := by
    rw [← Complex.normSq_apply, Complex.normSq_eq_norm_sq, ha]
    norm_num
  have hbn : b.re * b.re + b.im * b.im = 1 := by
    rw [← Complex.normSq_apply, Complex.normSq_eq_norm_sq, hb]
    norm_num
  have hcn : c.re * c.re + c.im * c.im = 1 := by
    rw [← Complex.normSq_apply, Complex.normSq_eq_norm_sq, hc]
    norm_num
  rw [← Complex.normSq_eq_norm_sq]
  simp only [Complex.normSq_apply, Complex.add_re, Complex.add_im,
    Complex.mul_re, Complex.star_def, Complex.conj_re, Complex.conj_im]
  nlinarith

/-- Complete odd-power average identity.  Each correlation is one for an
equal pair, minus one for an opposite pair, and zero otherwise. -/
theorem recoh_odd_power_energy_sum (m : ℕ) (hm : 0 < m) (a b c : ℂ)
    (ha : a ^ (2 * m) = 1) (hb : b ^ (2 * m) = 1)
    (hc : c ^ (2 * m) = 1) :
    (∑ j ∈ Finset.range m, recohOddPowerEnergy a b c j) =
      (m : ℝ) * (3 + 2 * (recohOddPairCorrelation a b +
        recohOddPairCorrelation a c + recohOddPairCorrelation b c)) := by
  have horder : 2 * m ≠ 0 := by omega
  have han := Complex.norm_eq_one_of_pow_eq_one ha horder
  have hbn := Complex.norm_eq_one_of_pow_eq_one hb horder
  have hcn := Complex.norm_eq_one_of_pow_eq_one hc horder
  have hexpand (j : ℕ) : recohOddPowerEnergy a b c j =
      3 + 2 * (((a * star b) ^ (2 * j + 1)).re +
        ((a * star c) ^ (2 * j + 1)).re + ((b * star c) ^ (2 * j + 1)).re) := by
    simpa only [recohOddPowerEnergy, mul_pow, star_pow] using
      recoh_unit_three_energy (a ^ (2 * j + 1)) (b ^ (2 * j + 1))
        (c ^ (2 * j + 1)) (by simp [norm_pow, han])
        (by simp [norm_pow, hbn]) (by simp [norm_pow, hcn])
  simp_rw [hexpand]
  simp only [Finset.sum_add_distrib, ← Finset.mul_sum]
  rw [recoh_odd_pair_sum m a b ha hb hbn,
    recoh_odd_pair_sum m a c ha hc hcn,
    recoh_odd_pair_sum m b c hb hc hcn]
  simp
  ring

/-- Pair correlations are exactly the equal-pair count minus the
opposite-pair count; the subtraction takes place in the reals. -/
theorem recoh_odd_pair_correlation_sum (a b c : ℂ) :
    recohOddPairCorrelation a b + recohOddPairCorrelation a c +
      recohOddPairCorrelation b c =
      (recohEqualPhasePairs a b c : ℝ) - (recohOppositePhasePairs a b c : ℝ) := by
  classical
  simp only [recohOddPairCorrelation, recohEqualPhasePairs, recohOppositePhasePairs,
    Nat.cast_add, Nat.cast_ite, Nat.cast_one, Nat.cast_zero]
  ring

/-- The normalized mean is exactly `3 + 2*(E-O)`, including repeated
phases and the order-two case. -/
theorem recoh_odd_power_energy_average (m : ℕ) (hm : 0 < m) (a b c : ℂ)
    (ha : a ^ (2 * m) = 1) (hb : b ^ (2 * m) = 1)
    (hc : c ^ (2 * m) = 1) :
    (∑ j ∈ Finset.range m, recohOddPowerEnergy a b c j) / (m : ℝ) =
      3 + 2 * ((recohEqualPhasePairs a b c : ℝ) -
        (recohOppositePhasePairs a b c : ℝ)) := by
  rw [recoh_odd_power_energy_sum m hm a b c ha hb hc,
    recoh_odd_pair_correlation_sum]
  have hmreal : (m : ℝ) ≠ 0 := by exact_mod_cast (Nat.ne_of_gt hm)
  exact mul_div_cancel_left₀ _ hmreal

/-- Without an opposite pair, every pair contribution is nonnegative. -/
theorem recoh_odd_pair_correlation_nonneg (a b : ℂ) (h : a ≠ -b) :
    0 ≤ recohOddPairCorrelation a b := by
  classical
  simp only [recohOddPairCorrelation, h, if_false, sub_zero]
  split_ifs <;> norm_num

/-- No opposite pair forces average squared magnitude at least three. -/
theorem recoh_odd_power_energy_sum_ge (m : ℕ) (hm : 0 < m) (a b c : ℂ)
    (ha : a ^ (2 * m) = 1) (hb : b ^ (2 * m) = 1)
    (hc : c ^ (2 * m) = 1) (hop : ¬ RecohHasOppositePair a b c) :
    3 * (m : ℝ) ≤ ∑ j ∈ Finset.range m, recohOddPowerEnergy a b c j := by
  have hab : a ≠ -b := fun h => hop (Or.inl h)
  have hac : a ≠ -c := fun h => hop (Or.inr (Or.inl h))
  have hbc : b ≠ -c := fun h => hop (Or.inr (Or.inr h))
  rw [recoh_odd_power_energy_sum m hm a b c ha hb hc]
  have hcorr : 0 ≤ recohOddPairCorrelation a b + recohOddPairCorrelation a c +
      recohOddPairCorrelation b c := by
    linarith [recoh_odd_pair_correlation_nonneg a b hab,
      recoh_odd_pair_correlation_nonneg a c hac,
      recoh_odd_pair_correlation_nonneg b c hbc]
  have hmreal : 0 ≤ (m : ℝ) := Nat.cast_nonneg m
  nlinarith

/-- An opposite pair cancels at every odd exponent, leaving energy one. -/
theorem recoh_odd_power_energy_eq_one_of_opposite (a b c : ℂ)
    (ha : ‖a‖ = 1) (hb : ‖b‖ = 1) (hc : ‖c‖ = 1)
    (hop : RecohHasOppositePair a b c) (j : ℕ) :
    recohOddPowerEnergy a b c j = 1 := by
  have hneg (z : ℂ) : (-z) ^ (2 * j + 1) = -(z ^ (2 * j + 1)) := by
    rw [neg_pow]
    have hone : (-1 : ℂ) ^ (2 * j + 1) = -1 := by simp [pow_add, pow_mul]
    rw [hone, neg_one_mul]
  rcases hop with hab | hac | hbc
  · rw [recohOddPowerEnergy, hab, hneg]
    simp [norm_pow, hc]
  · rw [recohOddPowerEnergy, hac, hneg]
    have hcancel : -(c ^ (2 * j + 1)) + b ^ (2 * j + 1) + c ^ (2 * j + 1) =
        b ^ (2 * j + 1) := by ring
    rw [hcancel]
    simp [norm_pow, hb]
  · rw [recohOddPowerEnergy, hbc, hneg]
    have hcancel : a ^ (2 * j + 1) + -(c ^ (2 * j + 1)) + c ^ (2 * j + 1) =
        a ^ (2 * j + 1) := by ring
    rw [hcancel]
    simp [norm_pow, ha]

/-- A nonempty finite family with mean at least three has a member at
least three.  This is the exact finite averaging step used below. -/
theorem recoh_exists_energy_ge_three (m : ℕ) (hm : 0 < m) (energy : ℕ → ℝ)
    (hsum : 3 * (m : ℝ) ≤ ∑ j ∈ Finset.range m, energy j) :
    ∃ j < m, 3 ≤ energy j := by
  by_contra! h
  have hlt : (∑ j ∈ Finset.range m, energy j) < ∑ _j ∈ Finset.range m, (3 : ℝ) := by
    apply Finset.sum_lt_sum
    · intro j hj
      exact le_of_lt (h j (Finset.mem_range.mp hj))
    · exact ⟨0, Finset.mem_range.mpr hm, h 0 hm⟩
  have hconst : (∑ _j ∈ Finset.range m, (3 : ℝ)) = 3 * (m : ℝ) := by simp; ring
  linarith

/-- The root equations themselves imply the dichotomy needed by the
certified rational selector: all energies are one, or some is at least three. -/
theorem recoh_odd_power_energy_dichotomy (m : ℕ) (hm : 0 < m) (a b c : ℂ)
    (ha : a ^ (2 * m) = 1) (hb : b ^ (2 * m) = 1)
    (hc : c ^ (2 * m) = 1) :
    (∀ j : ℕ, recohOddPowerEnergy a b c j = 1) ∨
      ∃ j < m, 3 ≤ recohOddPowerEnergy a b c j := by
  by_cases hop : RecohHasOppositePair a b c
  · left
    have horder : 2 * m ≠ 0 := by omega
    exact recoh_odd_power_energy_eq_one_of_opposite a b c
      (Complex.norm_eq_one_of_pow_eq_one ha horder)
      (Complex.norm_eq_one_of_pow_eq_one hb horder)
      (Complex.norm_eq_one_of_pow_eq_one hc horder) hop
  · right
    exact recoh_exists_energy_ge_three m hm (recohOddPowerEnergy a b c)
      (recoh_odd_power_energy_sum_ge m hm a b c ha hb hc hop)

/-- Specialization to order `2^(depth+1)`, matching binary-primary
character descriptors.  The search contains exactly `2^depth` odd powers. -/
theorem recoh_two_primary_odd_power_energy_dichotomy
    (depth : ℕ) (a b c : ℂ)
    (ha : a ^ (2 ^ (depth + 1)) = 1)
    (hb : b ^ (2 ^ (depth + 1)) = 1)
    (hc : c ^ (2 ^ (depth + 1)) = 1) :
    (∀ j : ℕ, recohOddPowerEnergy a b c j = 1) ∨
      ∃ j < 2 ^ depth, 3 ≤ recohOddPowerEnergy a b c j := by
  apply recoh_odd_power_energy_dichotomy (2 ^ depth) (by positivity) a b c
  · simpa [pow_succ, Nat.mul_comm] using ha
  · simpa [pow_succ, Nat.mul_comm] using hb
  · simpa [pow_succ, Nat.mul_comm] using hc

end Couret.STROBO2TORS

#print axioms Couret.STROBO2TORS.recoh_odd_power_sum_mul
#print axioms Couret.STROBO2TORS.recoh_odd_power_sum
#print axioms Couret.STROBO2TORS.recoh_unit_conj_mul
#print axioms Couret.STROBO2TORS.recoh_unit_pair_eq_one_iff
#print axioms Couret.STROBO2TORS.recoh_unit_pair_eq_neg_one_iff
#print axioms Couret.STROBO2TORS.recoh_odd_pair_sum
#print axioms Couret.STROBO2TORS.recoh_unit_three_energy
#print axioms Couret.STROBO2TORS.recoh_odd_power_energy_sum
#print axioms Couret.STROBO2TORS.recoh_odd_pair_correlation_sum
#print axioms Couret.STROBO2TORS.recoh_odd_power_energy_average
#print axioms Couret.STROBO2TORS.recoh_odd_pair_correlation_nonneg
#print axioms Couret.STROBO2TORS.recoh_odd_power_energy_sum_ge
#print axioms Couret.STROBO2TORS.recoh_odd_power_energy_eq_one_of_opposite
#print axioms Couret.STROBO2TORS.recoh_exists_energy_ge_three
#print axioms Couret.STROBO2TORS.recoh_odd_power_energy_dichotomy
#print axioms Couret.STROBO2TORS.recoh_two_primary_odd_power_energy_dichotomy
