module

public import MatchingCertificateCore
public import ConvolutionParity

@[expose] public section

set_option autoImplicit false
namespace Couret.InterIA.SingletonNecessity
open Finset
variable {G : Type*} [AddCommGroup G]

def evaluation (x : Fin 6 → G) : Vec →+ G where
  toFun v := ∑ k, v k • x k
  map_zero' := by simp
  map_add' := by
    intro v w
    simp only [Pi.add_apply, add_zsmul, Finset.sum_add_distrib]

theorem evaluation_basis (x : Fin 6 → G) (n : Fin 6) :
    evaluation x (basis n.val) = x n := by
  change (∑ k : Fin 6, (if k.val=n.val then (1:ℤ) else 0) • x k) = x n
  have h : ∀ k : Fin 6, k.val=n.val ↔ k=n := fun _ => Fin.val_inj
  simp only [h,ite_smul,one_zsmul,zero_zsmul]
  rw [Finset.sum_ite_eq']
  simp

theorem evaluation_combination_zero (x : Fin 6 → G) (rows : List Vec)
    (coeff : List ℤ) (hr : ∀ v ∈ rows, evaluation x v = 0) :
    evaluation x (combination rows coeff) = 0 := by
  induction rows generalizing coeff with
  | nil => simp [combination]
  | cons v vs ih =>
    cases coeff with
    | nil => simp [combination]
    | cons c cs =>
      have hv := hr v (by simp)
      have ht : ∀ w ∈ vs, evaluation x w = 0 := by
        intro w hw
        exact hr w (by simp [hw])
      change evaluation x (c • v + combination vs cs) = 0
      rw [map_add, map_zsmul, hv, ih cs ht]
      simpa only [add_zero] using (zsmul_zero (α := G) c)

theorem certificate_sound (mixed : Bool) (c : Certificate)
    (hc : valid mixed c = true) (x : Fin 6 → G)
    (hr : ∀ v ∈ relations mixed c.perm, evaluation x v = 0) :
    c.i < c.j ∧ c.j < 7 ∧ evaluation x (label c.i) = evaluation x (label c.j) := by
  have h : c.i < c.j ∧ c.j < 7 ∧
      c.coeff.length = (relations mixed c.perm).length ∧
      combination (relations mixed c.perm) c.coeff = label c.i - label c.j := by
    simpa only [valid, decide_eq_true_eq] using hc
  refine ⟨h.1, h.2.1, ?_⟩
  have hz := evaluation_combination_zero x (relations mixed c.perm) c.coeff hr
  rw [h.2.2.2, map_sub] at hz
  exact sub_eq_zero.mp hz

end Couret.InterIA.SingletonNecessity
#print axioms Couret.InterIA.SingletonNecessity.evaluation_combination_zero
#print axioms Couret.InterIA.SingletonNecessity.evaluation_basis
#print axioms Couret.InterIA.SingletonNecessity.certificate_sound
