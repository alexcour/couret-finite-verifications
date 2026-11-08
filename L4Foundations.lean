module

public import Mathlib.Data.ZMod.Basic
public import Mathlib.Data.Finset.Insert
public import Mathlib.Tactic.Abel
public import Mathlib.Tactic.Ring
public import Mathlib.Tactic.Tauto

@[expose] public section

set_option autoImplicit false

namespace Couret.InterIA.L4

section Cyclic

theorem half_ne_zero (m : ℕ) (hm : 0 < m) :
    (m : ZMod (2*m)) ≠ 0 := by
  intro h
  have hv := congrArg ZMod.val h
  rw [ZMod.val_natCast_of_lt (by omega), ZMod.val_zero] at hv
  omega

theorem half_add_half (m : ℕ) :
    (m : ZMod (2*m)) + m = 0 := by
  rw [← Nat.cast_add]
  convert ZMod.natCast_self (2*m) using 1 <;> congr 1 <;> omega

theorem doubling_kernel (m : ℕ) (hm : 0 < m) (x : ZMod (2*m))
    (hx : x+x=0) : x=0 ∨ x=(m : ZMod (2*m)) := by
  letI : NeZero (2*m) := ⟨by omega⟩
  have hv : x.val < 2*m := ZMod.val_lt x
  by_cases hsmall : x.val+x.val < 2*m
  · left
    have he := ZMod.val_add_of_lt hsmall
    rw [hx, ZMod.val_zero] at he
    have hz : x.val=0 := by omega
    exact ZMod.val_injective (2*m) (by simpa using hz)
  · right
    have he := ZMod.val_add_of_le (by omega : 2*m ≤ x.val+x.val)
    rw [hx, ZMod.val_zero] at he
    have heq : x.val=m := by omega
    apply ZMod.val_injective (2*m)
    simpa only [ZMod.val_natCast_of_lt (by omega : m < 2*m)] using heq

end Cyclic

section Rectangle
variable {G : Type*} [AddCommGroup G] [DecidableEq G]

/-- Only support closure is needed; equality of positive rectangle multisets is stronger. -/
theorem rectangle_side (h : G) (hh : h ≠ 0) (hh2 : h+h=0)
    (hkernel : ∀ x : G, x+x=0 → x=0 ∨ x=h)
    (w d e : G)
    (hclosed : ∀ x ∈ ({w,w+d,w+e,w+d+e} : Finset G),
      x+h ∈ ({w,w+d,w+e,w+d+e} : Finset G)) :
    d=0 ∨ d=h ∨ e=0 ∨ e=h := by
  by_contra hn
  have hd0 : d ≠ 0 := by tauto
  have hdh : d ≠ h := by tauto
  have he0 : e ≠ 0 := by tauto
  have heh : e ≠ h := by tauto
  have hp := hclosed w (by simp)
  simp only [Finset.mem_insert, Finset.mem_singleton] at hp
  have hsum : d+e=h := by
    rcases hp with hp|hp|hp|hp
    · exact False.elim (hh (add_left_cancel (by simpa using hp : w+h=w+0)))
    · exact False.elim (hdh (add_left_cancel hp).symm)
    · exact False.elim (heh (add_left_cancel hp).symm)
    · have hp' : w+h=w+(d+e) := by simpa only [add_assoc] using hp
      exact (add_left_cancel hp').symm
  have hq := hclosed (w+d) (by simp)
  simp only [Finset.mem_insert, Finset.mem_singleton] at hq
  have hdiff : e-d=h := by
    rcases hq with hq|hq|hq|hq
    · have hq' : d+h=0 := add_left_cancel (by simpa only [add_assoc, add_zero] using hq : w+(d+h)=w+0)
      exact False.elim (hdh (by
        calc d = d+(h+h) := by rw [hh2,add_zero]
             _ = (d+h)+h := by abel
             _ = h := by rw [hq',zero_add]))
    · exact False.elim (hh (add_left_cancel (by simpa using hq : (w+d)+h=(w+d)+0)))
    · have hq' : d+h=e := add_left_cancel (by simpa only [add_assoc] using hq)
      calc e-d = (d+h)-d := by rw [hq']
           _ = h := by abel
    · exact False.elim (heh (add_left_cancel hq).symm)
  have hd2 : d+d=0 := by
    calc d+d = (d+e)-(e-d) := by abel
         _ = h-h := by rw [hsum,hdiff]
         _ = 0 := sub_self h
  exact (hkernel d hd2).elim hd0 hdh

end Rectangle

theorem cyclic_rectangle_side (m : ℕ) (hm : 0 < m)
    (w d e : ZMod (2*m))
    (hclosed : ∀ x ∈ ({w,w+d,w+e,w+d+e} : Finset (ZMod (2*m))),
      x+m ∈ ({w,w+d,w+e,w+d+e} : Finset (ZMod (2*m)))) :
    d=0 ∨ d=m ∨ e=0 ∨ e=m :=
  rectangle_side (m : ZMod (2*m)) (half_ne_zero m hm) (half_add_half m)
    (doubling_kernel m hm) w d e hclosed

section Algebra
variable {R : Type*} [CommRing R]

theorem antipodal_square (H : R) (hH : H*H=1) :
    (1+H)*(1+H)=2*(1+H) := by
  calc (1+H)*(1+H) = 1+2*H+H*H := by ring
       _ = 2*(1+H) := by rw [hH]; ring

theorem antipodal_cross (H : R) (hH : H*H=1) :
    (1+H)*(1-H)=0 := by
  calc (1+H)*(1-H)=1-H*H := by ring
       _=0 := by rw [hH]; ring

theorem mixed_case_identity (H a b c q : R) (hH : H*H=1) :
    ((1+H)*(a-b)+(1-H)*q)*(2*c+(1+H)*(a+b+q)) =
      2*((1+H)*(a-b)*(c+a+b+q)+(1-H)*q*c) := by
  have hs := antipodal_square H hH
  have hc := antipodal_cross H hH
  calc
    _ = 2*(1+H)*(a-b)*c + ((1+H)*(1+H))*(a-b)*(a+b+q) +
      2*(1-H)*q*c + ((1+H)*(1-H))*q*(a+b+q) := by ring
    _ = _ := by rw [hs,hc]; ring

theorem normal_form_identity (H a b c : R) (hH : H*H=1) :
    (c+(1+H)*a)^2-(c+(1+H)*b)^2 =
      2*(1+H)*(a-b)*(c+a+b) := by
  have hs := antipodal_square H hH
  calc
    _ = 2*c*(1+H)*(a-b) + ((1+H)*(1+H))*(a*a-b*b) := by ring
    _ = _ := by rw [hs]; ring

end Algebra

section IntegerCoefficients
variable {α : Type*}

theorem invariant_anti_intersection (τ : α → α) (f : α → ℤ)
    (hinv : ∀ x, f (τ x)=f x) (hanti : ∀ x, f (τ x)= -f x) : f=0 := by
  funext x
  have hi := hinv x
  have ha := hanti x
  change f x=0
  omega

theorem invariant_anti_sum_zero (τ : α → α) (f g : α → ℤ)
    (hinv : ∀ x, f (τ x)=f x) (hanti : ∀ x, g (τ x)= -g x)
    (hsum : ∀ x, f x+g x=0) : f=0 ∧ g=0 := by
  have hg : g=0 := invariant_anti_intersection τ g (by
    intro x
    have h1 := hsum x
    have h2 := hsum (τ x)
    rw [hinv x] at h2
    omega) hanti
  refine ⟨?_,hg⟩
  funext x
  have hx := hsum x
  rw [hg] at hx
  simpa using hx

end IntegerCoefficients

end Couret.InterIA.L4
