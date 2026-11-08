module

public import CubicFourier
public import ConvolutionParity

@[expose] public section

set_option autoImplicit false
namespace Couret.InterIA.Cubic
open Finset Couret.InterIA.Parity

def orderedCube {G : Type*} [AddCommGroup G] [DecidableEq G]
    (S : Finset G) (z : G) : ℕ :=
  ∑ x ∈ S, orderedSquare S (z-x)

noncomputable def complexIndicator {G : Type*} [DecidableEq G] (S : Finset G) : G → ℂ :=
  fun x => if x ∈ S then 1 else 0

theorem cconv_comm {G : Type*} [AddCommGroup G] [Fintype G] [DecidableEq G]
    (f g : G → ℂ) : cconv f g = cconv g f := by
  funext z
  unfold cconv
  rw [Finset.sum_comm]
  apply Finset.sum_congr rfl
  intro x hx
  apply Finset.sum_congr rfl
  intro y hy
  simp only [add_comm,mul_comm]

theorem cconv_indicator_left {G : Type*} [AddCommGroup G] [Fintype G] [DecidableEq G]
    (S : Finset G) (g : G → ℂ) (z : G) :
    cconv (complexIndicator S) g z = ∑ x ∈ S, g (z-x) := by
  classical
  have hxy (x y : G) : x+y=z ↔ y=z-x := by
    simp only [eq_sub_iff_add_eq,add_comm]
  calc
    _ = ∑ x : G, if x ∈ S then g (z-x) else 0 := by
      apply Finset.sum_congr rfl
      intro x hx
      by_cases hs : x ∈ S
      · simp [complexIndicator,hs,hxy,Finset.sum_ite_eq']
      · simp [complexIndicator,hs]
    _ = ∑ x ∈ S, if x ∈ S then g (z-x) else 0 := by
      symm
      apply Finset.sum_subset (Finset.subset_univ S)
      intro x hx hn
      simp [hn]
    _ = _ := by
      apply Finset.sum_congr rfl
      intro x hx
      simp [hx]

theorem complex_square_coefficient {G : Type*} [AddCommGroup G] [Fintype G] [DecidableEq G]
    (S : Finset G) (z : G) :
    cconv (complexIndicator S) (complexIndicator S) z = (orderedSquare S z : ℂ) := by
  rw [cconv_indicator_left]
  simp only [orderedSquare,Nat.cast_sum]
  apply Finset.sum_congr rfl
  intro x hx
  have hxy (y : G) : x+y=z ↔ y=z-x := by
    simp only [eq_sub_iff_add_eq,add_comm]
  simp [complexIndicator,hxy,Finset.sum_ite_eq']

theorem complex_cube_coefficient {G : Type*} [AddCommGroup G] [Fintype G] [DecidableEq G]
    (S : Finset G) (z : G) :
    cconv (cconv (complexIndicator S) (complexIndicator S)) (complexIndicator S) z =
      (orderedCube S z : ℂ) := by
  rw [cconv_comm,cconv_indicator_left]
  simp only [complex_square_coefficient,orderedCube,Nat.cast_sum]

theorem square_cube_support_injective (n : ℕ) (hn : 0<n)
    (S T : Finset (ZMod n))
    (hs : ∀ z, orderedSquare S z=orderedSquare T z)
    (hc : ∀ z, orderedCube S z=orderedCube T z) : S=T := by
  letI : NeZero n := ⟨by omega⟩
  have hsq : cconv (complexIndicator S) (complexIndicator S) =
      cconv (complexIndicator T) (complexIndicator T) := by
    funext z
    simp only [complex_square_coefficient,hs z]
  have hcu : cconv (cconv (complexIndicator S) (complexIndicator S)) (complexIndicator S) =
      cconv (cconv (complexIndicator T) (complexIndicator T)) (complexIndicator T) := by
    funext z
    simp only [complex_cube_coefficient,hc z]
  have he := square_cube_injective (complexIndicator S) (complexIndicator T) hsq hcu
  ext x
  have h := congrFun he x
  by_cases hS : x ∈ S <;> by_cases hT : x ∈ T <;> simp_all [complexIndicator]

noncomputable def probe {G : Type*} [AddCommGroup G] [DecidableEq G]
    (r : G → ℝ) (S : Finset G) : G → ℝ :=
  fun z => ∑ x ∈ S, r (z-x)

theorem probe_union {G : Type*} [AddCommGroup G] [DecidableEq G]
    (r : G → ℝ) (S T : Finset G) (hd : Disjoint S T) :
    probe r (S ∪ T)=probe r S+probe r T := by
  funext z
  exact Finset.sum_union hd

theorem cube_eq_probe {G : Type*} [AddCommGroup G] [DecidableEq G]
    (S T : Finset G) (hs : ∀ z, orderedSquare S z=orderedSquare T z) :
    (fun z => (orderedCube T z : ℝ)) = probe (fun z => (orderedSquare S z : ℝ)) T := by
  funext z
  simp only [orderedCube,probe,Nat.cast_sum,hs]

end Couret.InterIA.Cubic
