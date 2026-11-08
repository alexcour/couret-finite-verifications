module

public import MatchingElimination
public import C4SquareAlgebra

@[expose] public section

set_option autoImplicit false
namespace Couret.InterIA.SingletonNecessity
open Couret.InterIA.AbelianBoundary
variable {G : Type*} [AddCommGroup G]

theorem distinct_values (x : Fin 6 → G) (hd : DistinctLabels x) :
    Function.Injective x := by
  intro i j hij
  have hi : i.val+1<7 := by omega
  have hj : j.val+1<7 := by omega
  have hei : evaluation x (label (i.val+1))=x i := by
    rw [label,if_neg (by omega),Nat.add_sub_cancel]
    exact evaluation_basis x i
  have hej : evaluation x (label (j.val+1))=x j := by
    rw [label,if_neg (by omega),Nat.add_sub_cancel]
    exact evaluation_basis x j
  have he : (⟨i.val+1,hi⟩ : Fin 7) = ⟨j.val+1,hj⟩ := by
    apply hd
    change evaluation x (label (i.val+1))=evaluation x (label (j.val+1))
    rw [hei,hej,hij]
  apply Fin.ext
  have hv : i.val+1=j.val+1 := congrArg Fin.val he
  exact Nat.add_right_cancel hv

theorem reverse_relations_contains_c4_square (x : Fin 6 → G)
    (hd : DistinctLabels x) (hr : RelationsHold x false reversePerm) :
    ∃ φ : G4 →+ G, Function.Injective φ := by
  have ev0 : evaluation x (basis 0) = x 0 := evaluation_basis x (0:Fin 6)
  have ev1 : evaluation x (basis 1) = x 1 := evaluation_basis x (1:Fin 6)
  have ev2 : evaluation x (basis 2) = x 2 := evaluation_basis x (2:Fin 6)
  have ev3 : evaluation x (basis 3) = x 3 := evaluation_basis x (3:Fin 6)
  have ev4 : evaluation x (basis 4) = x 4 := evaluation_basis x (4:Fin 6)
  have ev5 : evaluation x (basis 5) = x 5 := evaluation_basis x (5:Fin 6)
  have hda : x 0+x 0=x 3+x 3 := by
    have h := hr ((2:ℤ) • (basis 0-basis 3)) (by simp [relations])
    simp only [map_add,map_sub,ev0,ev3,two_zsmul] at h
    exact sub_eq_zero.mp (by calc
      (x 0+x 0)-(x 3+x 3) = (x 0-x 3)+(x 0-x 3) := by abel
      _ = 0 := h)
  have hdb : x 1+x 1=x 4+x 4 := by
    have h := hr ((2:ℤ) • (basis 1-basis 4)) (by simp [relations])
    simp only [map_add,map_sub,ev1,ev4,two_zsmul] at h
    exact sub_eq_zero.mp (by calc
      (x 1+x 1)-(x 4+x 4) = (x 1-x 4)+(x 1-x 4) := by abel
      _ = 0 := h)
  have ha : x 0=x 4+x 5 := by
    have h := hr (basis 0-(basis 4+basis 5)) (by
      simp [relations,leftTerms,rightTerms,reversePerm])
    simpa only [map_sub,map_add,ev0,ev4,
      ev5,sub_eq_zero] using h
  have hab : x 0+x 1=x 5 := by
    have h := hr ((basis 0+basis 1)-basis 5) (by
      simp [relations,leftTerms,rightTerms,reversePerm])
    simpa only [map_sub,map_add,ev0,ev1,
      ev5,sub_eq_zero] using h
  have hac : x 0+x 2=x 4 := by
    have h := hr ((basis 0+basis 2)-basis 4) (by
      simp [relations,leftTerms,rightTerms,reversePerm])
    simpa only [map_sub,map_add,ev0,ev2,
      ev4,sub_eq_zero] using h
  have hbc : x 1+x 2=x 3 := by
    have h := hr ((basis 1+basis 2)-basis 3) (by
      simp [relations,leftTerms,rightTerms,reversePerm])
    simpa only [map_sub,map_add,ev1,ev2,
      ev3,sub_eq_zero] using h
  have hinj := distinct_values x hd
  exact reverse_matching_contains_c4_square (x 0) (x 1) (x 2) (x 3) (x 4) (x 5)
    ha hab hac hbc hda hdb
    (fun h => (by decide : (0:Fin 6) ≠ 3) (hinj h))
    (fun h => (by decide : (1:Fin 6) ≠ 4) (hinj h))
    (fun h => (by decide : (2:Fin 6) ≠ 5) (hinj h))

/-- Conditional algebraic step; FullNecessity discharges the matching hypothesis. -/
theorem contains_c4_square_of_matching (x : Fin 6 → G) (hd : DistinctLabels x)
    (hm : (∃ p : List ℕ, p.Perm (List.range 6) ∧ RelationsHold x false p) ∨
      (∃ p : List ℕ, p.Perm (List.range 7) ∧ RelationsHold x true p)) :
    ∃ φ : G4 →+ G, Function.Injective φ := by
  rcases hm with ⟨p,hp,hr⟩|⟨p,hp,hr⟩
  · have he := cross_matching_is_reverse x hd p hp hr
    exact reverse_relations_contains_c4_square x hd (he ▸ hr)
  · exact False.elim (mixed_matching_impossible x hd p hp hr)

end Couret.InterIA.SingletonNecessity
#print axioms Couret.InterIA.SingletonNecessity.distinct_values
#print axioms Couret.InterIA.SingletonNecessity.reverse_relations_contains_c4_square
#print axioms Couret.InterIA.SingletonNecessity.contains_c4_square_of_matching

