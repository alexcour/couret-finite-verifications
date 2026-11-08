module

public import EmbeddingTransport
public import ReverseMatching

@[expose] public section

set_option autoImplicit false
namespace Couret.InterIA.SingletonNecessity
open Couret.InterIA.AbelianBoundary
variable {G : Type*} [AddCommGroup G]

def fourthMap (a : G) (ha : (4:ℤ) • a = 0) : ZMod 4 →+ G :=
  ZMod.lift 4 ⟨{
    toFun := fun n => n • a
    map_zero' := by simp
    map_add' := by intro m n; exact add_zsmul a m n
  }, ha⟩

theorem fourthMap_two (a : G) (ha : (4:ℤ) • a = 0) :
    fourthMap a ha 2 = a+a := by
  change ZMod.lift 4 _ ((2:ℤ) : ZMod 4) = a+a
  rw [ZMod.lift_coe]
  exact two_zsmul a

theorem fourthMap_zero (a : G) (ha : (4:ℤ) • a = 0) :
    fourthMap a ha 0 = 0 := map_zero _

theorem fourth_square_kernel_cases : ∀ z : G4, z ≠ 0 →
    z=(2,0) ∨ z=(0,2) ∨ z=(2,2) ∨
    z+z=(2,0) ∨ z+z=(0,2) ∨ z+z=(2,2) := by decide

theorem injective_of_double_images (f : G4 →+ G)
    (ha : f (2,0) ≠ 0) (hb : f (0,2) ≠ 0)
    (hab : f (2,0) ≠ f (0,2)) : Function.Injective f := by
  have hb2 : f (0,2) + f (0,2) = 0 := by
    rw [← map_add]
    have hz : ((0,2) + (0,2) : G4) = 0 := by decide
    rw [hz,map_zero]
  have hc : f (2,2) ≠ 0 := by
    intro h
    have hsum : f (2,0) + f (0,2) = 0 := by
      rw [← map_add]
      exact h
    apply hab
    calc
      f (2,0) = f (2,0) + (f (0,2) + f (0,2)) := by rw [hb2,add_zero]
      _ = (f (2,0) + f (0,2)) + f (0,2) := by abel
      _ = f (0,2) := by rw [hsum,zero_add]
  have hker : ∀ z : G4, f z = 0 → z = 0 := by
    intro z hz
    by_contra hne
    have hd : f (z+z) = 0 := by rw [map_add,hz,zero_add]
    rcases fourth_square_kernel_cases z hne with h|h|h|h|h|h
    · exact ha (by simpa only [h] using hz)
    · exact hb (by simpa only [h] using hz)
    · exact hc (by simpa only [h] using hz)
    · exact ha (by simpa only [h] using hd)
    · exact hb (by simpa only [h] using hd)
    · exact hc (by simpa only [h] using hd)
  intro x y h
  apply sub_eq_zero.mp
  apply hker
  rw [map_sub,h,sub_self]

theorem contains_c4_square_of_four_torsion (a b : G)
    (ha : (4:ℤ) • a = 0) (hb : (4:ℤ) • b = 0)
    (ha2 : a+a ≠ 0) (hb2 : b+b ≠ 0) (hab2 : a+a ≠ b+b) :
    ∃ f : G4 →+ G, Function.Injective f := by
  let f := (fourthMap a ha).coprod (fourthMap b hb)
  have hfa : f (2,0) = a+a := by
    change fourthMap a ha 2 + fourthMap b hb 0 = a+a
    rw [fourthMap_two,fourthMap_zero,add_zero]
  have hfb : f (0,2) = b+b := by
    change fourthMap a ha 0 + fourthMap b hb 2 = b+b
    rw [fourthMap_zero,fourthMap_two,zero_add]
  refine ⟨f, injective_of_double_images f ?_ ?_ ?_⟩
  · rwa [hfa]
  · rwa [hfb]
  · rwa [hfa,hfb]

theorem reverse_matching_contains_c4_square (a b c d e f : G)
    (ha : a = e+f) (hab : a+b = f) (hac : a+c = e) (hbc : b+c = d)
    (hda : a+a = d+d) (hdb : b+b = e+e)
    (had : a ≠ d) (hbe : b ≠ e) (hcf : c ≠ f) :
    ∃ φ : G4 →+ G, Function.Injective φ := by
  have hs : a+b+c=0 := by
    calc
      a+b+c = ((a+c)+(a+b))-a := by abel
      _ = (e+f)-a := by rw [hac,hab]
      _ = 0 := by rw [← ha,sub_self]
  have hd : d = -a := by
    calc d = (a+b+c)-a := by rw [← hbc]; abel
         _ = -a := by rw [hs]; simp
  have he : e = -b := by
    calc e = (a+b+c)-b := by rw [← hac]; abel
         _ = -b := by rw [hs]; simp
  have hf : f = -c := by
    calc f = (a+b+c)-c := by rw [← hab]; abel
         _ = -c := by rw [hs]; simp
  have ha4 : (4:ℤ) • a = 0 := by
    have h := double_equals_opposite_double a d hd hda
    simpa only [show (4:ℤ) = 2+2 from rfl,add_zsmul,two_zsmul] using h
  have hb4 : (4:ℤ) • b = 0 := by
    have h := double_equals_opposite_double b e he hdb
    simpa only [show (4:ℤ) = 2+2 from rfl,add_zsmul,two_zsmul] using h
  have ha2 : a+a ≠ 0 := by
    intro h
    apply had
    rw [hd]
    exact eq_neg_iff_add_eq_zero.mpr h
  have hb2 : b+b ≠ 0 := by
    intro h
    apply hbe
    rw [he]
    exact eq_neg_iff_add_eq_zero.mpr h
  have hab2 : a+a ≠ b+b := by
    intro h
    have hc2 : c+c = 0 := by
      have hsum : (a+a)+(b+b)+(c+c)=0 := by
        calc (a+a)+(b+b)+(c+c) = (a+b+c)+(a+b+c) := by abel
             _ = 0 := by rw [hs,zero_add]
      rw [← h] at hsum
      have hzero : (a+a)+(a+a)=0 :=
        double_equals_opposite_double a d hd hda
      rw [hzero,zero_add] at hsum
      exact hsum
    apply hcf
    rw [hf]
    exact eq_neg_iff_add_eq_zero.mpr hc2
  exact contains_c4_square_of_four_torsion a b ha4 hb4 ha2 hb2 hab2

end Couret.InterIA.SingletonNecessity
#print axioms Couret.InterIA.SingletonNecessity.fourthMap_two
#print axioms Couret.InterIA.SingletonNecessity.fourthMap_zero
#print axioms Couret.InterIA.SingletonNecessity.fourth_square_kernel_cases
#print axioms Couret.InterIA.SingletonNecessity.injective_of_double_images
#print axioms Couret.InterIA.SingletonNecessity.contains_c4_square_of_four_torsion
#print axioms Couret.InterIA.SingletonNecessity.reverse_matching_contains_c4_square
