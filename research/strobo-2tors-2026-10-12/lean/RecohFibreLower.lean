import RecohSquareFourier
import RecohPrimaryCharacters
import Mathlib.Data.Fintype.BigOperators

set_option autoImplicit false

/-!
Information lower bound for a bank chosen after the labelled ordered
square is known.  Reconstructing means actual injectivity on the existing
finite square fibre.  The result applies to arbitrary complex characters,
including probes which vanish on that fibre.
-/

namespace Couret.STROBO2TORS

variable {G : Type*} [AddCommGroup G] [DecidableEq G] [Fintype G]

/-- The finite-set two-torsion used by STROBO and the actual subgroup used
by RECOH have the same cardinality. -/
theorem recoh_two_torsion_card_eq_nat_card :
    (twoTorsion : Finset G).card =
      Nat.card (recohTorsionSubgroup (G := G) 2) := by
  classical
  let e : {u : G // u ∈ (twoTorsion : Finset G)} ≃
      recohTorsionSubgroup (G := G) 2 :=
    { toFun := fun u => ⟨u.1, by
        simpa only [recoh_mem_torsion_subgroup, two_nsmul] using
          (mem_twoTorsion u.1).mp u.2⟩
      invFun := fun u => ⟨u.1, (mem_twoTorsion u.1).mpr (by
        simpa only [recoh_mem_torsion_subgroup, two_nsmul] using u.2)⟩
      left_inv := fun u => Subtype.ext rfl
      right_inv := fun u => Subtype.ext rfl }
  calc
    (twoTorsion : Finset G).card =
        Nat.card {u : G // u ∈ (twoTorsion : Finset G)} := by
      simp only [Nat.card_eq_fintype_card, Fintype.card_coe]
    _ = Nat.card (recohTorsionSubgroup (G := G) 2) := Nat.card_congr e

/-- `k` fixed character slots distinguish at most `2^k` members of any
square fibre.  The bank may depend on this fibre, but not on the unknown
member within it.  This theorem does not assert an adaptive-tree bound. -/
theorem recoh_fibre_card_le_two_pow_of_separating_bank
    (S : Finset G) {k : ℕ} (bank : Fin k → AddChar G ℂ)
    (hsep : Set.InjOn
      (fun T : Finset G => fun i => recohSupportProbe (bank i) T)
      (squareFibre S)) :
    (squareFibre S).card ≤ 2 ^ k := by
  classical
  let bits : {T : Finset G // T ∈ squareFibre S} → (Fin k → Bool) :=
    fun T i => decide (recohSupportProbe (bank i) T.1 = recohSupportProbe (bank i) S)
  have hbits : Function.Injective bits := by
    intro A B hAB
    apply Subtype.ext
    apply hsep A.2 B.2
    funext i
    have hi := congrFun hAB i
    have hA := recoh_support_probe_eq_or_neg_of_square_eq (bank i) A.1 S
      (fun z => (((mem_squareFibre S A.1).mp A.2).2 z).symm)
    have hB := recoh_support_probe_eq_or_neg_of_square_eq (bank i) B.1 S
      (fun z => (((mem_squareFibre S B.1).mp B.2).2 z).symm)
    by_cases ha : recohSupportProbe (bank i) A.1 = recohSupportProbe (bank i) S
    · have hb : recohSupportProbe (bank i) B.1 = recohSupportProbe (bank i) S := by
        simpa [bits, ha] using hi.symm
      exact ha.trans hb.symm
    · have hb : recohSupportProbe (bank i) B.1 ≠ recohSupportProbe (bank i) S := by
        intro hb
        have hfalse : false = true := by simpa [bits, ha, hb] using hi
        cases hfalse
      exact (hA.resolve_left ha).trans (hB.resolve_left hb).symm
  have hcard := Fintype.card_le_of_injective bits hbits
  simpa only [Fintype.card_coe, Fintype.card_fun, Fintype.card_bool,
    Fintype.card_fin] using hcard

/-- On a fibre of cardinality `2^r`, every separating bank contains at
least `r` character slots. -/
theorem recoh_fibre_rank_le_of_separating_bank
    (S : Finset G) (r : ℕ) (hcard : (squareFibre S).card = 2 ^ r)
    {k : ℕ} (bank : Fin k → AddChar G ℂ)
    (hsep : Set.InjOn
      (fun T : Finset G => fun i => recohSupportProbe (bank i) T)
      (squareFibre S)) : r ≤ k := by
  have hpow := recoh_fibre_card_le_two_pow_of_separating_bank S bank hsep
  rw [hcard] at hpow
  by_contra h
  have hk : k < r := by omega
  have hlt := Nat.pow_lt_pow_right (by decide : 1 < 2) hk
  omega

/-- A fibre of size `2 * 2^r` requires at least `r+1` character slots. -/
theorem recoh_double_fibre_rank_succ_le_of_separating_bank
    (S : Finset G) (r : ℕ) (hcard : (squareFibre S).card = 2 * 2 ^ r)
    {k : ℕ} (bank : Fin k → AddChar G ℂ)
    (hsep : Set.InjOn
      (fun T : Finset G => fun i => recohSupportProbe (bank i) T)
      (squareFibre S)) : r + 1 ≤ k := by
  apply recoh_fibre_rank_le_of_separating_bank S (r + 1) _ bank hsep
  simpa only [pow_succ, Nat.mul_comm] using hcard

end Couret.STROBO2TORS

#print axioms Couret.STROBO2TORS.recoh_fibre_card_le_two_pow_of_separating_bank
#print axioms Couret.STROBO2TORS.recoh_two_torsion_card_eq_nat_card
#print axioms Couret.STROBO2TORS.recoh_fibre_rank_le_of_separating_bank
#print axioms Couret.STROBO2TORS.recoh_double_fibre_rank_succ_le_of_separating_bank
