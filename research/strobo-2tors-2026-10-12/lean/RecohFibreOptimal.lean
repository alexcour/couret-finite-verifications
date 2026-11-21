import RecohFibreLower
import RecohFibreUpper
import Mathlib.Data.Nat.Log

set_option autoImplicit false

/-!
Optimal character banks selected from the observed labelled ordered square.
The selected bank is fixed on its entire fibre. Selection is existential;
this module does not implement selection from raw or typed decoder input.
-/

namespace Couret.STROBO2TORS

variable {G : Type*} [AddCommGroup G] [DecidableEq G] [Fintype G]

/-- The integer information budget of a complete square fibre. For a triple
the fibre size is a power of two, so the logarithm is exact. -/
def recohFibreBudget (S : Finset G) : ℕ := Nat.log 2 (squareFibre S).card

/-- The information budget of an ordinary fibre is the two-torsion rank. -/
theorem recoh_fibre_budget_ordinary (r : ℕ)
    (hcard2 : Nat.card (recohTorsionSubgroup (G := G) 2) = 2 ^ r)
    (S : Finset G)
    (hordinary : (squareFibre S).card = (twoTorsion : Finset G).card) :
    recohFibreBudget S = r := by
  rw [recohFibreBudget, hordinary, recoh_two_torsion_card_eq_nat_card, hcard2]
  exact Nat.log_pow (by decide) r

/-- One additional information bit is required on an exceptional fibre. -/
theorem recoh_fibre_budget_exceptional (r : ℕ)
    (hcard2 : Nat.card (recohTorsionSubgroup (G := G) 2) = 2 ^ r)
    (S : Finset G)
    (hexceptional : (squareFibre S).card = 2 * (twoTorsion : Finset G).card) :
    recohFibreBudget S = r + 1 := by
  rw [recohFibreBudget, hexceptional, recoh_two_torsion_card_eq_nat_card, hcard2]
  rw [← pow_succ']
  exact Nat.log_pow (by decide) (r + 1)

/-- The information budget represents the complete fibre cardinality exactly. -/
theorem recoh_two_pow_fibre_budget (r : ℕ)
    (hcard2 : Nat.card (recohTorsionSubgroup (G := G) 2) = 2 ^ r)
    (S : Finset G) (hS : S.card = 3) :
    2 ^ recohFibreBudget S = (squareFibre S).card := by
  rcases squareFibre_card_h_or_two_h S hS with ho | he
  · rw [recoh_fibre_budget_ordinary r hcard2 S ho, ho,
      recoh_two_torsion_card_eq_nat_card, hcard2]
  · rw [recoh_fibre_budget_exceptional r hcard2 S he, he,
      recoh_two_torsion_card_eq_nat_card, hcard2, pow_succ']

/-- Exact optimality on each full triple fibre. The lower bound covers every
bank of complex characters, including repeated or vanishing probes. -/
theorem recoh_optimal_fibre_bank_size (r : ℕ)
    (hcard2 : Nat.card (recohTorsionSubgroup (G := G) 2) = 2 ^ r)
    (S : Finset G) (hS : S.card = 3) :
    (∃ bank : Fin (recohFibreBudget S) → AddChar G ℂ,
      Set.InjOn (fun T : Finset G => fun i => recohSupportProbe (bank i) T)
        (squareFibre S)) ∧
    (∀ k : ℕ, k < recohFibreBudget S → ∀ bank : Fin k → AddChar G ℂ,
      ¬ Set.InjOn (fun T : Finset G => fun i => recohSupportProbe (bank i) T)
        (squareFibre S)) := by
  rcases squareFibre_card_h_or_two_h S hS with ho | he
  · rw [recoh_fibre_budget_ordinary r hcard2 S ho]
    refine ⟨recoh_exists_bank_on_ordinary_fibre r hcard2 S hS ho, ?_⟩
    intro k hk bank hsep
    have hpow : (squareFibre S).card = 2 ^ r := by
      rw [ho, recoh_two_torsion_card_eq_nat_card, hcard2]
    exact (Nat.not_lt_of_ge (recoh_fibre_rank_le_of_separating_bank
      S r hpow bank hsep)) hk
  · rw [recoh_fibre_budget_exceptional r hcard2 S he]
    refine ⟨recoh_exists_bank_on_exceptional_fibre r hcard2 S hS he, ?_⟩
    intro k hk bank hsep
    have hpow : (squareFibre S).card = 2 * 2 ^ r := by
      rw [he, recoh_two_torsion_card_eq_nat_card, hcard2]
    exact (Nat.not_lt_of_ge (recoh_double_fibre_rank_succ_le_of_separating_bank
      S r hpow bank hsep)) hk

/-- A globally reconstructing fixed bank separates every complete fibre. -/
theorem recoh_fixed_bank_injective_on_fibre {k : ℕ}
    (bank : Fin k → AddChar G ℂ)
    (hinj : Function.Injective (fun S : {S : Finset G // S.card = 3} =>
      recohObservation bank S.1)) (S : Finset G) :
    Set.InjOn (fun T : Finset G => fun i => recohSupportProbe (bank i) T)
      (squareFibre S) := by
  intro T hT U hU heq
  obtain ⟨hT3, hsT⟩ := (mem_squareFibre S T).mp hT
  obtain ⟨hU3, hsU⟩ := (mem_squareFibre S U).mp hU
  have hobs : recohObservation bank T = recohObservation bank U := by
    apply Prod.ext
    · funext z
      exact (hsT z).symm.trans (hsU z)
    · exact heq
  exact congrArg Subtype.val (hinj (a₁ := ⟨T, hT3⟩) (a₂ := ⟨U, hU3⟩) hobs)

/-- A bank can be padded with trivial characters without losing separation. -/
theorem recoh_fibre_bank_mono (S : Finset G) {k l : ℕ} (hkl : k ≤ l)
    (bank : Fin k → AddChar G ℂ)
    (hsep : Set.InjOn
      (fun T : Finset G => fun i => recohSupportProbe (bank i) T) (squareFibre S)) :
    ∃ larger : Fin l → AddChar G ℂ,
      Set.InjOn (fun T : Finset G => fun i => recohSupportProbe (larger i) T)
        (squareFibre S) := by
  classical
  let larger : Fin l → AddChar G ℂ :=
    fun i => if hi : i.val < k then bank ⟨i.val, hi⟩ else 1
  refine ⟨larger, ?_⟩
  intro T hT U hU heq
  apply hsep hT hU
  funext i
  have h := congrFun heq (Fin.castLE hkl i)
  simpa [larger, i.isLt] using h

/-- Worst-case budget when the bank can be selected from the observed square. -/
def recohAfterSquareBudget (r s : ℕ) : ℕ :=
  if r = 0 then 0 else r + min 1 s

/-- Every fibre admits a bank bounded by the stated worst-case budget. -/
theorem recoh_exists_after_square_fibre_bank (r s : ℕ)
    (hcard2 : Nat.card (recohTorsionSubgroup (G := G) 2) = 2 ^ r)
    (hcard3 : Nat.card (recohTorsionSubgroup (G := G) 3) = 3 ^ s)
    (S : Finset G) (hS : S.card = 3) :
    ∃ bank : Fin (recohAfterSquareBudget r s) → AddChar G ℂ,
      Set.InjOn (fun T : Finset G => fun i => recohSupportProbe (bank i) T)
        (squareFibre S) := by
  by_cases hr : r = 0
  · subst r
    rw [show recohAfterSquareBudget 0 s = 0 by simp [recohAfterSquareBudget]]
    obtain ⟨bank, hinj⟩ := recoh_exists_reconstructing_empty_bank hcard2
    exact ⟨bank, recoh_fixed_bank_injective_on_fibre bank hinj S⟩
  · by_cases hs : s = 0
    · subst s
      rw [show recohAfterSquareBudget r 0 = r by simp [recohAfterSquareBudget, hr]]
      obtain ⟨bank, hinj⟩ := recoh_exists_reconstructing_bank_rank_sum r 0 hcard2 hcard3
      exact ⟨bank, recoh_fixed_bank_injective_on_fibre bank hinj S⟩
    · have hs1 : 1 ≤ s := by omega
      rw [show recohAfterSquareBudget r s = r + 1 by
        simp [recohAfterSquareBudget, hr, Nat.min_eq_left hs1]]
      rcases squareFibre_card_h_or_two_h S hS with ho | he
      · obtain ⟨bank, hsep⟩ := recoh_exists_bank_on_ordinary_fibre r hcard2 S hS ho
        exact recoh_fibre_bank_mono S (by omega : r ≤ r + 1) bank hsep
      · exact recoh_exists_bank_on_exceptional_fibre r hcard2 S hS he

/-- A square-selected bank together with the square itself is the complete
observation. Equal squares select exactly the same bank. -/
def recohSquareSelectedObservation {k : ℕ}
    (select : (G → ℕ) → (Fin k → AddChar G ℂ)) (S : Finset G) :
    (G → ℕ) × (Fin k → ℂ) :=
  (orderedSquare S, fun i => recohSupportProbe (select (orderedSquare S) i) S)

/-- Fibrewise existence yields one selection rule depending only on the
observed square, not on the unknown support. This is a classical existence
result, not an executable selection algorithm. -/
theorem recoh_exists_square_selection_of_fibre_banks (k : ℕ)
    (hbank : ∀ S : Finset G, S.card = 3 → ∃ bank : Fin k → AddChar G ℂ,
      Set.InjOn (fun T : Finset G => fun i => recohSupportProbe (bank i) T)
        (squareFibre S)) :
    ∃ select : (G → ℕ) → (Fin k → AddChar G ℂ),
      Function.Injective (fun S : {S : Finset G // S.card = 3} =>
        recohSquareSelectedObservation select S.1) := by
  classical
  have hR : ∀ R : G → ℕ, ∃ bank : Fin k → AddChar G ℂ,
      ∀ S T : Finset G, S.card = 3 → T.card = 3 →
        orderedSquare S = R → orderedSquare T = R →
        (fun i => recohSupportProbe (bank i) S) =
          (fun i => recohSupportProbe (bank i) T) → S = T := by
    intro R
    by_cases hreal : ∃ S : Finset G, S.card = 3 ∧ orderedSquare S = R
    · obtain ⟨U, hU, hUR⟩ := hreal
      obtain ⟨bank, hsep⟩ := hbank U hU
      refine ⟨bank, ?_⟩
      intro S T hS hT hSR hTR heq
      apply hsep ((mem_squareFibre U S).mpr ⟨hS, ?_⟩)
        ((mem_squareFibre U T).mpr ⟨hT, ?_⟩) heq
      · intro z
        exact congrFun (hUR.trans hSR.symm) z
      · intro z
        exact congrFun (hUR.trans hTR.symm) z
    · refine ⟨fun _ => 1, ?_⟩
      intro S T hS _ hSR _ _
      exact (hreal ⟨S, hS, hSR⟩).elim
  let select : (G → ℕ) → (Fin k → AddChar G ℂ) :=
    fun R => Classical.choose (hR R)
  refine ⟨select, ?_⟩
  intro S T heq
  apply Subtype.ext
  have hsquare : orderedSquare S.1 = orderedSquare T.1 := congrArg Prod.fst heq
  have hprobe := congrArg Prod.snd heq
  apply (Classical.choose_spec (hR (orderedSquare S.1))) S.1 T.1 S.2 T.2
    rfl hsquare.symm
  change (fun i => recohSupportProbe (select (orderedSquare S.1) i) S.1) =
    (fun i => recohSupportProbe (select (orderedSquare T.1) i) T.1) at hprobe
  change (fun i => recohSupportProbe (select (orderedSquare S.1) i) S.1) =
    (fun i => recohSupportProbe (select (orderedSquare S.1) i) T.1)
  rw [← hsquare] at hprobe
  exact hprobe

/-- Any reconstructing square-selection rule restricts to an ordinary fixed
bank on each full fibre, so the information lower bounds still apply. -/
theorem recoh_square_selection_injective_on_fibre {k : ℕ}
    (select : (G → ℕ) → (Fin k → AddChar G ℂ))
    (hinj : Function.Injective (fun S : {S : Finset G // S.card = 3} =>
      recohSquareSelectedObservation select S.1)) (S : Finset G) :
    Set.InjOn (fun T : Finset G => fun i =>
      recohSupportProbe (select (orderedSquare S) i) T) (squareFibre S) := by
  intro T hT U hU heq
  obtain ⟨hT3, hsT⟩ := (mem_squareFibre S T).mp hT
  obtain ⟨hU3, hsU⟩ := (mem_squareFibre S U).mp hU
  have hST : orderedSquare S = orderedSquare T := funext hsT
  have hSU : orderedSquare S = orderedSquare U := funext hsU
  have hobs : recohSquareSelectedObservation select T =
      recohSquareSelectedObservation select U := by
    apply Prod.ext
    · exact hST.symm.trans hSU
    · change (fun i => recohSupportProbe (select (orderedSquare T) i) T) =
        (fun i => recohSupportProbe (select (orderedSquare U) i) U)
      simpa only [← hST, ← hSU] using heq
  exact congrArg Subtype.val (hinj (a₁ := ⟨T, hT3⟩) (a₂ := ⟨U, hU3⟩) hobs)

/-- The bank can be chosen as a function of the observed square with the
claimed worst-case number of character slots. -/
theorem recoh_exists_reconstructing_square_selection (r s : ℕ)
    (hcard2 : Nat.card (recohTorsionSubgroup (G := G) 2) = 2 ^ r)
    (hcard3 : Nat.card (recohTorsionSubgroup (G := G) 3) = 3 ^ s) :
    ∃ select : (G → ℕ) → (Fin (recohAfterSquareBudget r s) → AddChar G ℂ),
      Function.Injective (fun S : {S : Finset G // S.card = 3} =>
        recohSquareSelectedObservation select S.1) := by
  apply recoh_exists_square_selection_of_fibre_banks
  exact recoh_exists_after_square_fibre_bank r s hcard2 hcard3

/-- A shorter square-selection rule fails on a genuine triple whenever the
domain is nonempty. In positive binary and ternary rank, one exceptional
fibre alone forces the additional character slot. -/
theorem recoh_no_short_square_selection (r s : ℕ)
    (hcard2 : Nat.card (recohTorsionSubgroup (G := G) 2) = 2 ^ r)
    (hcard3 : Nat.card (recohTorsionSubgroup (G := G) 3) = 3 ^ s)
    (hG3 : 3 ≤ Fintype.card G) (k : ℕ)
    (hk : k < recohAfterSquareBudget r s)
    (select : (G → ℕ) → (Fin k → AddChar G ℂ)) :
    ¬ Function.Injective (fun S : {S : Finset G // S.card = 3} =>
      recohSquareSelectedObservation select S.1) := by
  intro hinj
  by_cases hr : r = 0
  · simp [recohAfterSquareBudget, hr] at hk
  · have hrpos : 0 < r := by omega
    by_cases hs : s = 0
    · have hkr : k < r := by simpa [recohAfterSquareBudget, hr, hs] using hk
      obtain ⟨S, _, hS⟩ := Finset.exists_subset_card_eq
        (s := (Finset.univ : Finset G)) (n := 3) (by simpa using hG3)
      have hsep := recoh_square_selection_injective_on_fibre select hinj S
      have hupper := recoh_fibre_card_le_two_pow_of_separating_bank S
        (select (orderedSquare S)) hsep
      have hlower : 2 ^ r ≤ (squareFibre S).card := by
        calc
          2 ^ r = (torsionOrbit S).card := by
            rw [torsionOrbit_card S hS, recoh_two_torsion_card_eq_nat_card, hcard2]
          _ ≤ (squareFibre S).card := Finset.card_le_card (torsionOrbit_subset_fibre S hS)
      have hlt := Nat.pow_lt_pow_right (by decide : 1 < 2) hkr
      omega
    · have hspos : 0 < s := by omega
      have hs1 : 1 ≤ s := hspos
      have hkr : k < r + 1 := by
        simpa only [recohAfterSquareBudget, if_neg hr, Nat.min_eq_left hs1] using hk
      obtain ⟨S, _, hF⟩ :=
        recoh_exists_exceptional_fibre_of_positive_ranks r s hrpos hspos hcard2 hcard3
      have hFpow : (squareFibre S).card = 2 * 2 ^ r := by
        rw [hF, recoh_two_torsion_card_eq_nat_card, hcard2]
      have hsep := recoh_square_selection_injective_on_fibre select hinj S
      have hmin := recoh_double_fibre_rank_succ_le_of_separating_bank S r hFpow
        (select (orderedSquare S)) hsep
      omega

/-- Exact worst-case optimum for banks chosen from the observed square.
The upper and lower bounds both quantify over one rule whose sole input is
the labelled ordered square, with a fixed number of character slots. -/
theorem recoh_optimal_after_square_bank_size (r s : ℕ)
    (hcard2 : Nat.card (recohTorsionSubgroup (G := G) 2) = 2 ^ r)
    (hcard3 : Nat.card (recohTorsionSubgroup (G := G) 3) = 3 ^ s)
    (hG3 : 3 ≤ Fintype.card G) :
    (∃ select : (G → ℕ) → (Fin (recohAfterSquareBudget r s) → AddChar G ℂ),
      Function.Injective (fun S : {S : Finset G // S.card = 3} =>
        recohSquareSelectedObservation select S.1)) ∧
    (∀ k : ℕ, k < recohAfterSquareBudget r s →
      ∀ select : (G → ℕ) → (Fin k → AddChar G ℂ),
        ¬ Function.Injective (fun S : {S : Finset G // S.card = 3} =>
          recohSquareSelectedObservation select S.1)) := by
  exact ⟨recoh_exists_reconstructing_square_selection r s hcard2 hcard3,
    recoh_no_short_square_selection r s hcard2 hcard3 hG3⟩

/-- Groups smaller than three have no admissible triple, so a zero-slot
selection rule is sufficient on their empty domain. -/
theorem recoh_empty_triple_domain_zero_selection (hG : Fintype.card G < 3) :
    ∃ select : (G → ℕ) → (Fin 0 → AddChar G ℂ),
      Function.Injective (fun S : {S : Finset G // S.card = 3} =>
        recohSquareSelectedObservation select S.1) := by
  refine ⟨fun _ => Fin.elim0, ?_⟩
  intro S T _
  have hle := Finset.card_le_univ S.1
  rw [S.2] at hle
  omega

/-- A fixed universal bank pays `s-1` extra slots when both torsion ranks
are positive. Both budgets refer to exact labelled complex coefficients. -/
theorem recoh_universal_choice_cost (r s : ℕ) (hr : 0 < r) (hs : 0 < s) :
    recohOptimalBudget r s - recohAfterSquareBudget r s = s - 1 := by
  have hr0 : r ≠ 0 := by omega
  have hs1 : 1 ≤ s := hs
  simp only [recohOptimalBudget, recohAfterSquareBudget, if_neg hr0,
    Nat.min_eq_left hs1]
  omega

end Couret.STROBO2TORS

#print axioms Couret.STROBO2TORS.recoh_fibre_budget_ordinary
#print axioms Couret.STROBO2TORS.recoh_fibre_budget_exceptional
#print axioms Couret.STROBO2TORS.recoh_two_pow_fibre_budget
#print axioms Couret.STROBO2TORS.recoh_optimal_fibre_bank_size
#print axioms Couret.STROBO2TORS.recoh_fixed_bank_injective_on_fibre
#print axioms Couret.STROBO2TORS.recoh_fibre_bank_mono
#print axioms Couret.STROBO2TORS.recoh_exists_after_square_fibre_bank
#print axioms Couret.STROBO2TORS.recoh_exists_square_selection_of_fibre_banks
#print axioms Couret.STROBO2TORS.recoh_square_selection_injective_on_fibre
#print axioms Couret.STROBO2TORS.recoh_exists_reconstructing_square_selection
#print axioms Couret.STROBO2TORS.recoh_no_short_square_selection
#print axioms Couret.STROBO2TORS.recoh_optimal_after_square_bank_size
#print axioms Couret.STROBO2TORS.recoh_empty_triple_domain_zero_selection
#print axioms Couret.STROBO2TORS.recoh_universal_choice_cost
