module

public import SingleSwap

@[expose] public section

set_option autoImplicit false
namespace Couret.InterIA.IntersectionTwo
open Finset Couret.InterIA.Parity Couret.InterIA.GroupRing
variable {G : Type*} [AddCommGroup G] [DecidableEq G]

noncomputable def atom (a : G) : AddMonoidAlgebra ℤ G :=
  AddMonoidAlgebra.single a 1

theorem atom_mul (a b : G) : atom a * atom b = atom (a+b) := by
  simp [atom, AddMonoidAlgebra.single_mul_single]

theorem indicator_pair (a b : G) (hab : a ≠ b) :
    indicator ({a,b} : Finset G) = atom a + atom b := by
  simp [indicator, Finset.sum_pair hab, atom]

theorem indicator_union_disjoint (C U : Finset G) (hd : Disjoint C U) :
    indicator (C ∪ U) = indicator C + indicator U := by
  exact Finset.sum_union hd

/-- Cancellation is of the integer 2 only. No group-ring factor is cancelled. -/
theorem translated_difference_cross (C U : Finset G) (h : G) (hh2 : h+h=0)
    (hCU : Disjoint C U) (hCV : Disjoint C (U.image (fun x => x+h)))
    (hsquare : ∀ z, orderedSquare (C ∪ U) z =
      orderedSquare (C ∪ U.image (fun x => x+h)) z) :
    indicator U * indicator C = atom h * (indicator U * indicator C) := by
  have he := (square_equality_iff _ _).mpr hsquare
  rw [indicator_union_disjoint C U hCU,
    indicator_union_disjoint C _ hCV] at he
  have hu := (square_equality_iff (U.image (fun x => x+h)) U).mpr
    (Couret.InterIA.Translation.two_torsion_translation_preserves_square U h hh2)
  have hz : (2 : AddMonoidAlgebra ℤ G) *
      (indicator U * indicator C - indicator (U.image (fun x => x+h)) * indicator C)=0 := by
    calc
      _ = ((indicator C + indicator U)*(indicator C + indicator U) -
        (indicator C + indicator (U.image (fun x => x+h))) *
        (indicator C + indicator (U.image (fun x => x+h)))) -
        (indicator U*indicator U - indicator (U.image (fun x => x+h)) *
          indicator (U.image (fun x => x+h))) := by ring
      _ = 0 := by rw [he, hu]; simp
  have hc := sub_eq_zero.mp (integer_coefficient_no_two_torsion _ hz)
  rw [indicator_translate] at hc
  simpa only [atom, mul_assoc] using hc

/-- Positive coefficients recover the support, even if rectangle sums coincide. -/
theorem pair_product_support (q₁ q₂ c₁ c₂ z : G) (hq : q₁ ≠ q₂) (hc : c₁ ≠ c₂) :
    (indicator ({q₁,q₂} : Finset G) * indicator ({c₁,c₂} : Finset G)).coeff z ≠ 0 ↔
      z ∈ ({q₁+c₁,q₁+c₂,q₂+c₁,q₂+c₂} : Finset G) := by
  rw [indicator_mul_coefficient]
  simp only [Finset.sum_pair hq, Finset.sum_pair hc, mem_insert, mem_singleton]
  by_cases h1 : q₁+c₁=z <;> by_cases h2 : q₁+c₂=z <;>
    by_cases h3 : q₂+c₁=z <;> by_cases h4 : q₂+c₂=z <;>
    simp_all [eq_comm]

theorem invariant_pair_product_closed (q₁ q₂ c₁ c₂ h : G)
    (hq : q₁ ≠ q₂) (hc : c₁ ≠ c₂)
    (he : indicator ({q₁,q₂} : Finset G) * indicator ({c₁,c₂} : Finset G) =
      atom h * (indicator ({q₁,q₂} : Finset G) * indicator ({c₁,c₂} : Finset G))) :
    ∀ z ∈ ({q₁+c₁,q₁+c₂,q₂+c₁,q₂+c₂} : Finset G),
      z+h ∈ ({q₁+c₁,q₁+c₂,q₂+c₁,q₂+c₂} : Finset G) := by
  intro z hz
  apply (pair_product_support q₁ q₂ c₁ c₂ (z+h) hq hc).mp
  have hz' := (pair_product_support q₁ q₂ c₁ c₂ z hq hc).mpr hz
  have ht := congrArg (fun f : AddMonoidAlgebra ℤ G => f.coeff (z+h)) he
  change _ = (AddMonoidAlgebra.single h 1 * _).coeff (z+h) at ht
  rw [monomial_translate_coefficient] at ht
  rw [add_sub_cancel_right] at ht
  exact ht.trans_ne hz'

/-- QQ: two distinct changed fibres force an antipodal common pair.
The kernel assumption is essential; it is not valid for arbitrary 2-torsion. -/
theorem qq_common_antipodal (h : G) (hh : h ≠ 0) (hh2 : h+h=0)
    (hkernel : ∀ x : G, x+x=0 → x=0 ∨ x=h)
    (q₁ q₂ c₁ c₂ : G) (hq : q₁ ≠ q₂) (hqh : q₂ ≠ q₁+h) (hc : c₁ ≠ c₂)
    (he : indicator ({q₁,q₂} : Finset G) * indicator ({c₁,c₂} : Finset G) =
      atom h * (indicator ({q₁,q₂} : Finset G) * indicator ({c₁,c₂} : Finset G))) :
    c₂ = c₁+h := by
  have hrect : ({q₁+c₁, q₁+c₁+(q₂-q₁), q₁+c₁+(c₂-c₁),
      q₁+c₁+(q₂-q₁)+(c₂-c₁)} : Finset G) =
      {q₁+c₁,q₁+c₂,q₂+c₁,q₂+c₂} := by
    have h1 : q₁+c₁+(q₂-q₁)=q₂+c₁ := by abel
    have h2 : q₁+c₁+(c₂-c₁)=q₁+c₂ := by abel
    have h3 : q₁+c₁+(q₂-q₁)+(c₂-c₁)=q₂+c₂ := by abel
    rw [h3,h1,h2]
    ext z
    simp only [mem_insert,mem_singleton]
    tauto
  have hclosed := invariant_pair_product_closed q₁ q₂ c₁ c₂ h hq hc he
  have hr := Couret.InterIA.L4.rectangle_side h hh hh2 hkernel
    (q₁+c₁) (q₂-q₁) (c₂-c₁) (by simpa only [hrect] using hclosed)
  rcases hr with hr|hr|hr|hr
  · exact False.elim (hq (sub_eq_zero.mp hr).symm)
  · exact False.elim (hqh (by calc q₂=(q₂-q₁)+q₁ := by abel
                                                _=q₁+h := by rw [hr]; abel))
  · exact False.elim (hc (sub_eq_zero.mp hr).symm)
  · calc c₂=(c₂-c₁)+c₁ := by abel
         _=c₁+h := by rw [hr]; abel

/-- The exact P/P residual equation; a necessary and sufficient condition. -/
theorem pp_square_iff (h : G) (hh2 : h+h=0) (c : AddMonoidAlgebra ℤ G) (a b : G) :
    (c+(1+atom h)*atom a)^2 = (c+(1+atom h)*atom b)^2 ↔
      (1+atom h)*(atom a-atom b)*(c+atom a+atom b)=0 := by
  have hH : atom h * atom h = (1 : AddMonoidAlgebra ℤ G) :=
    antipodal_monomial_square h hh2
  have hi : (c+(1+atom h)*atom a)^2-(c+(1+atom h)*atom b)^2 =
      2*((1+atom h)*(atom a-atom b)*(c+atom a+atom b)) := by
    calc
      _ = 2*(1+atom h)*(atom a-atom b)*(c+atom a+atom b) :=
        Couret.InterIA.L4.normal_form_identity (atom h) (atom a) (atom b) c hH
      _ = _ := by ring
  constructor
  · intro he
    apply integer_coefficient_no_two_torsion
    rw [← hi, he, sub_self]
  · intro he
    apply sub_eq_zero.mp
    rw [hi, he, mul_zero]

theorem indicator_fibre (h a : G) (hh : h ≠ 0) :
    indicator (Couret.InterIA.Fibres.fibre h a)=(1+atom h)*atom a := by
  have ha : a ≠ a+h := by
    intro he
    exact hh (add_left_cancel (by simpa using he.symm : a+h=a+0))
  rw [Couret.InterIA.Fibres.fibre,indicator_pair a (a+h) ha,add_mul,one_mul,atom_mul]
  rw [add_comm h a]

theorem pp_actual_square_iff (C : Finset G) (h : G) (hh : h ≠ 0) (hh2 : h+h=0)
    (a b : G) (ha : Disjoint C (Couret.InterIA.Fibres.fibre h a))
    (hb : Disjoint C (Couret.InterIA.Fibres.fibre h b)) :
    (∀ z, orderedSquare (C ∪ Couret.InterIA.Fibres.fibre h a) z =
      orderedSquare (C ∪ Couret.InterIA.Fibres.fibre h b) z) ↔
      (1+atom h)*(atom a-atom b)*(indicator C+atom a+atom b)=0 := by
  rw [← square_equality_iff,indicator_union_disjoint C _ ha,
    indicator_union_disjoint C _ hb,indicator_fibre h a hh,indicator_fibre h b hh]
  simpa only [pow_two] using pp_square_iff h hh2 (indicator C) a b

end Couret.InterIA.IntersectionTwo
