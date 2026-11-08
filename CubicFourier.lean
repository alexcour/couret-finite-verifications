module

public import Mathlib.Analysis.Fourier.ZMod
public import Mathlib.Tactic.Ring

@[expose] public section

set_option autoImplicit false
namespace Couret.InterIA.Cubic
open Finset

noncomputable def cconv {G : Type*} [AddCommGroup G] [Fintype G] [DecidableEq G]
    (f g : G → ℂ) (z : G) : ℂ :=
  ∑ x, ∑ y, if x+y=z then f x*g y else 0

theorem dft_cconv {n : ℕ} [NeZero n] (f g : ZMod n → ℂ) (k : ZMod n) :
    ZMod.dft (cconv f g) k = ZMod.dft f k * ZMod.dft g k := by
  classical
  calc
    _ = ∑ x : ZMod n, ∑ y : ZMod n, ∑ z : ZMod n,
        ZMod.stdAddChar (-(z*k)) * (if x+y=z then f x*g y else 0) := by
      simp only [ZMod.dft_apply,cconv,smul_eq_mul,Finset.mul_sum]
      rw [Finset.sum_comm]
      apply Finset.sum_congr rfl
      intro x hx
      rw [Finset.sum_comm]
    _ = ∑ x : ZMod n, ∑ y : ZMod n,
        ZMod.stdAddChar (-((x+y)*k)) * (f x*g y) := by
      apply Finset.sum_congr rfl
      intro x hx
      apply Finset.sum_congr rfl
      intro y hy
      simp [mul_ite,eq_comm]
    _ = _ := by
      simp only [ZMod.dft_apply,smul_eq_mul,Finset.sum_mul,Finset.mul_sum]
      rw [Finset.sum_comm]
      apply Finset.sum_congr rfl
      intro x hx
      apply Finset.sum_congr rfl
      intro y hy
      rw [add_mul,neg_add,AddChar.map_add_eq_mul]
      ring

theorem square_cube_scalar_injective {R : Type*} [CommRing R] [NoZeroDivisors R]
    (a b : R) (hs : a^2=b^2) (hc : a^3=b^3) : a=b := by
  by_cases hb : b^2=0
  · have ha0 : a=0 := eq_zero_of_pow_eq_zero (hs.trans hb)
    have hb0 : b=0 := eq_zero_of_pow_eq_zero hb
    simp [ha0,hb0]
  · apply mul_right_cancel₀ hb
    calc a*b^2 = a*a^2 := by rw [hs]
         _ = a^3 := by ring
         _ = b^3 := hc
         _ = b*b^2 := by ring

theorem square_cube_injective {n : ℕ} [NeZero n] (f g : ZMod n → ℂ)
    (hs : cconv f f = cconv g g)
    (hc : cconv (cconv f f) f = cconv (cconv g g) g) : f=g := by
  apply ZMod.dft.injective
  funext k
  apply square_cube_scalar_injective
  · have h := congrFun (congrArg ZMod.dft hs) k
    simpa only [dft_cconv,pow_two] using h
  · have h := congrFun (congrArg ZMod.dft hc) k
    simp only [dft_cconv] at h
    simpa only [pow_succ,pow_two,pow_zero,one_mul] using h

end Couret.InterIA.Cubic
