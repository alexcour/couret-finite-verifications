module

public import PureExchange

@[expose] public section

set_option autoImplicit false
namespace Couret.InterIA.Mixed
open Finset Couret.InterIA.Parity Couret.InterIA.GroupRing Couret.InterIA.Fibres
variable {G : Type*} [AddCommGroup G] [DecidableEq G]

noncomputable def X (a : G) : AddMonoidAlgebra ℤ G := AddMonoidAlgebra.single a 1

theorem X_mul (a b : G) : X a * X b = X (a+b) := by
  simp [X,AddMonoidAlgebra.single_mul_single]

theorem invariant_anti_sum_cancel (H f g : AddMonoidAlgebra ℤ G)
    (hf : H*f=f) (hg : H*g= -g) (he : f+g=0) : g=0 := by
  have ht : H*(f+g)=0 := by rw [he,mul_zero]
  rw [mul_add,hf,hg] at ht
  apply integer_coefficient_no_two_torsion
  calc
    2*g = (f+g)-(f+ -g) := by ring
    _ = 0 := by rw [he,ht]; simp

theorem plus_invariant (H f : AddMonoidAlgebra ℤ G) (hH : H*H=1) :
    H*((1+H)*f)=(1+H)*f := by
  calc H*((1+H)*f)=(H+H*H)*f := by ring
       _=(1+H)*f := by rw [hH]; ring

theorem minus_anti_invariant (H g : AddMonoidAlgebra ℤ G) (hH : H*H=1) :
    H*((1-H)*g)= -((1-H)*g) := by
  calc H*((1-H)*g)=(H-H*H)*g := by ring
       _= -((1-H)*g) := by rw [hH]; ring

theorem antipodal_monomial_difference_nonzero (h z : G) (hh : h ≠ 0) :
    (1-X h)*X z ≠ (0 : AddMonoidAlgebra ℤ G) := by
  intro he
  have hz := congrArg (fun f : AddMonoidAlgebra ℤ G => f.coeff z) he
  have hn : h+z ≠ z := by
    intro ht
    exact hh (add_right_cancel (by simpa using ht : h+z=0+z))
  rw [sub_mul,one_mul,X_mul] at hz
  simp [X,hn,hn.symm] at hz

/-- Purely integral obstruction; the four monomials need not be distinct. -/
theorem mixed_polynomial_squares_ne (a b c q h : G)
    (hh : h ≠ 0) (hh2 : h+h=0) :
    (X c+(1+X h)*X a+X q)*(X c+(1+X h)*X a+X q) ≠
    (X c+(1+X h)*X b+X h*X q)*(X c+(1+X h)*X b+X h*X q) := by
  intro he
  have hH : X h*X h=(1 : AddMonoidAlgebra ℤ G) :=
    antipodal_monomial_square h hh2
  have hd : (X c+(1+X h)*X a+X q)-(X c+(1+X h)*X b+X h*X q) =
      (1+X h)*(X a-X b)+(1-X h)*X q := by ring
  have hs : (X c+(1+X h)*X a+X q)+(X c+(1+X h)*X b+X h*X q) =
      2*X c+(1+X h)*(X a+X b+X q) := by ring
  have hz : ((1+X h)*(X a-X b)+(1-X h)*X q)*
      (2*X c+(1+X h)*(X a+X b+X q))=0 := by
    rw [← hd,← hs]
    calc _ = (X c+(1+X h)*X a+X q)*(X c+(1+X h)*X a+X q) -
      (X c+(1+X h)*X b+X h*X q)*(X c+(1+X h)*X b+X h*X q) := by ring
         _ = 0 := by rw [he]; simp
  rw [Couret.InterIA.L4.mixed_case_identity (X h) (X a) (X b) (X c) (X q) hH] at hz
  have hz' := integer_coefficient_no_two_torsion _ hz
  have hg : (1-X h)*(X q*X c)=0 := by
    apply invariant_anti_sum_cancel (X h)
      ((1+X h)*((X a-X b)*(X c+X a+X b+X q)))
      ((1-X h)*(X q*X c))
    · exact plus_invariant (X h) _ hH
    · exact minus_anti_invariant (X h) _ hH
    · simpa only [mul_assoc] using hz'
  rw [X_mul] at hg
  exact antipodal_monomial_difference_nonzero h (q+c) hh hg

theorem indicator_fibre (a h : G) (hh : h ≠ 0) :
    indicator (fibre h a)=(1+X h)*X a := by
  have hn : a ≠ a+h := by
    intro he
    exact hh (add_left_cancel (by simpa using he.symm : a+h=a+0))
  simp only [indicator,fibre,Finset.sum_pair hn]
  change X a+X (a+h)=(1+X h)*X a
  rw [add_mul,one_mul,X_mul,add_comm h a]

theorem indicator_mixed_support (a c q h : G) (hh : h ≠ 0)
    (hq : q ∉ fibre h a) (hc : c ∉ insert q (fibre h a)) :
    indicator (insert c (insert q (fibre h a)))=X c+(1+X h)*X a+X q := by
  rw [Couret.InterIA.IntersectionThree.indicator_insert _ c hc,
    Couret.InterIA.IntersectionThree.indicator_insert _ q hq,indicator_fibre a h hh]
  change X c+(X q+(1+X h)*X a)=_
  ring

/-- Actual ordered convolution obstruction for the two-P/one-Q configuration. -/
theorem mixed_supports_cannot_collide (a b c q h : G)
    (hh : h ≠ 0) (hh2 : h+h=0)
    (haq : q ∉ fibre h a) (hac : c ∉ insert q (fibre h a))
    (hbq : q+h ∉ fibre h b) (hbc : c ∉ insert (q+h) (fibre h b)) :
    ¬ (∀ z, orderedSquare (insert c (insert q (fibre h a))) z=
      orderedSquare (insert c (insert (q+h) (fibre h b))) z) := by
  intro hsquare
  have he := (square_equality_iff _ _).mpr hsquare
  rw [indicator_mixed_support a c q h hh haq hac,
    indicator_mixed_support b c (q+h) h hh hbq hbc] at he
  have hq : X (q+h)=X h*X q := by rw [X_mul,add_comm h q]
  rw [hq] at he
  exact mixed_polynomial_squares_ne a b c q h hh hh2 he

end Couret.InterIA.Mixed
