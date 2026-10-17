import RecohReconstruction
import RecohTwoPowerTripleNonzero
import RecohPrimaryCharacters
import RecohLowerBound

set_option autoImplicit false

/-!
The optimal size of a fixed bank of individual, labelled complex
Fourier coefficients, given the labelled ordered convolution square of a
three-element support.  Zero is allowed in the support.
-/

namespace Couret.STROBO2TORS

variable {G : Type*} [AddCommGroup G] [DecidableEq G]

/-- Every triple coefficient of a two-primary character is nonzero. -/
theorem recoh_two_primary_support_probe_nonzero
    (chi : AddChar G ℂ)
    (hprimary : ∀ x : G, ∃ n : ℕ, (chi x) ^ (2 ^ n) = 1)
    (S : Finset G) (hS : S.card = 3) :
    recohSupportProbe chi S ≠ 0 := by
  obtain ⟨a, b, c, hab, hac, hbc, rfl⟩ := Finset.card_eq_three.mp hS
  rw [recoh_support_probe_three chi a b c hab hac hbc]
  exact recoh_two_primary_triple_nonzero (chi a) (chi b) (chi c)
    (hprimary a) (hprimary b) (hprimary c)

/-- With trivial two-torsion, the square itself reconstructs every triple. -/
theorem recoh_square_injective_of_trivial_two_torsion
    (h2 : ∀ u : G, u + u = 0 → u = 0) :
    Function.Injective (fun S : {S : Finset G // S.card = 3} => orderedSquare S.1) := by
  intro S T h
  apply Subtype.ext
  rcases orderedSquare_classification_necessary S.1 T.1 S.2 T.2 (congrFun h) with ho | he
  · obtain ⟨u, hu, ht⟩ := ho
    have hu0 := h2 u hu
    simpa [hu0, translateSupport] using ht.symm
  · obtain ⟨a, b, d, u, hd, hd0, _⟩ := he
    exact (hd0 (h2 d hd)).elim

variable [Fintype G]

/-- Construction of a fixed bank of exactly `r+s` character slots from the
cardinalities of the actual two- and three-torsion subgroups. -/
theorem recoh_exists_reconstructing_bank_rank_sum
    (r s : ℕ)
    (hcard2 : Nat.card (recohTorsionSubgroup (G := G) 2) = 2 ^ r)
    (hcard3 : Nat.card (recohTorsionSubgroup (G := G) 3) = 3 ^ s) :
    ∃ bank : Fin (r + s) → AddChar G ℂ,
      Function.Injective (fun S : {S : Finset G // S.card = 3} =>
        recohObservation bank S.1) := by
  classical
  obtain ⟨bank2, hprimary2, hsep2⟩ := recoh_two_primary_characters_of_card r hcard2
  obtain ⟨bank3, hprimary3, htrivial2, hsep3⟩ := recoh_three_primary_characters_of_card s hcard3
  let bank : Fin (r + s) → AddChar G ℂ := Fin.addCases bank2 bank3
  refine ⟨bank, ?_⟩
  intro S T h
  apply Subtype.ext
  apply recoh_reconstruction_of_separating_banks bank2 bank3
    (fun i => recoh_two_primary_support_probe_nonzero (bank2 i) (hprimary2 i))
    hsep2 htrivial2 hsep3 S.1 T.1 S.2 T.2
  · exact congrFun (congrArg Prod.fst h)
  · intro i
    have hp := congrFun (congrArg Prod.snd h) (Fin.castAdd s i)
    simpa only [recohObservation, bank, Fin.addCases_left] using hp
  · intro j
    have hp := congrFun (congrArg Prod.snd h) (Fin.natAdd r j)
    simpa only [recohObservation, bank, Fin.addCases_right] using hp

/-- Rank zero in two-torsion needs no additional character coefficient. -/
theorem recoh_exists_reconstructing_empty_bank
    (hcard2 : Nat.card (recohTorsionSubgroup (G := G) 2) = 2 ^ 0) :
    ∃ bank : Fin 0 → AddChar G ℂ,
      Function.Injective (fun S : {S : Finset G // S.card = 3} =>
        recohObservation bank S.1) := by
  obtain ⟨bank2, _, hsep2⟩ := recoh_two_primary_characters_of_card 0 hcard2
  refine ⟨Fin.elim0, ?_⟩
  intro S T h
  apply recoh_square_injective_of_trivial_two_torsion
    (fun u hu => hsep2 u hu (fun i => Fin.elim0 i))
  exact congrArg Prod.fst h

/-- The budget is zero without two-torsion, and the sum of the two- and
three-torsion ranks otherwise. -/
def recohOptimalBudget (r s : ℕ) : ℕ := if r = 0 then 0 else r + s

/-- Exact optimality in the fixed labelled-character model: a bank with the
stated budget exists, and every smaller bank fails on actual triple supports.
The classification, primary character construction, nonvanishing and lower
bound are all invoked as proved theorems. -/
theorem recoh_optimal_bank_size
    (r s : ℕ)
    (hcard2 : Nat.card (recohTorsionSubgroup (G := G) 2) = 2 ^ r)
    (hcard3 : Nat.card (recohTorsionSubgroup (G := G) 3) = 3 ^ s)
    (hG3 : 3 ≤ Fintype.card G) :
    (∃ bank : Fin (recohOptimalBudget r s) → AddChar G ℂ,
      Function.Injective (fun S : {S : Finset G // S.card = 3} =>
        recohObservation bank S.1)) ∧
    (∀ k : ℕ, k < recohOptimalBudget r s →
      ∀ bank : Fin k → AddChar G ℂ,
        ¬ Function.Injective (fun S : {S : Finset G // S.card = 3} =>
          recohObservation bank S.1)) := by
  by_cases hr : r = 0
  · have hbudget : recohOptimalBudget r s = 0 := if_pos hr
    rw [hbudget]
    subst r
    refine ⟨recoh_exists_reconstructing_empty_bank hcard2, ?_⟩
    intro k hk
    exact (Nat.not_lt_zero k hk).elim
  · have hbudget : recohOptimalBudget r s = r + s := if_neg hr
    rw [hbudget]
    refine ⟨recoh_exists_reconstructing_bank_rank_sum r s hcard2 hcard3, ?_⟩
    intro k hk bank
    exact recoh_no_short_reconstructing_bank r s k (Nat.pos_of_ne_zero hr)
      hk hcard2 hcard3 hG3 bank

end Couret.STROBO2TORS

#print axioms Couret.STROBO2TORS.recoh_two_primary_support_probe_nonzero
#print axioms Couret.STROBO2TORS.recoh_square_injective_of_trivial_two_torsion
#print axioms Couret.STROBO2TORS.recoh_exists_reconstructing_bank_rank_sum
#print axioms Couret.STROBO2TORS.recoh_exists_reconstructing_empty_bank
#print axioms Couret.STROBO2TORS.recoh_optimal_bank_size
