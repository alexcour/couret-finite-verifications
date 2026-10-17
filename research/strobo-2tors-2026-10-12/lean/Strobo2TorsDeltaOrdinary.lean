import Strobo2TorsCore

set_option autoImplicit false

/-!
Ordinary partners and the intersection of distinct three-element supports.

The intersection of a support with its translate by a two-torsion element
is stable under that translation. A nonzero translation therefore cannot
leave exactly one point in the intersection. For distinct three-element
supports, the intersection has cardinality zero or two.
-/

namespace Couret.STROBO2TORS

variable {G : Type*} [AddCommGroup G] [DecidableEq G]

/-- Translation by a two-torsion element preserves the intersection with
the translated support. -/
theorem inter_translateSupport_add_mem
    (S : Finset G) (u : G) (hu : u + u = 0) (x : G)
    (hx : x ∈ S ∩ translateSupport S u) :
    x + u ∈ S ∩ translateSupport S u := by
  obtain ⟨hxS, hxT⟩ := Finset.mem_inter.mp hx
  apply Finset.mem_inter.mpr
  constructor
  · obtain ⟨y, hy, hyx⟩ := Finset.mem_image.mp hxT
    have hxu : x + u = y := by
      rw [← hyx, add_assoc, hu, add_zero]
    rw [hxu]
    exact hy
  · exact Finset.mem_image.mpr ⟨x, hxS, rfl⟩

/-- Two distinct ordinary partners of cardinality three share either no
point or exactly two points. In particular, an ordinary partner cannot
have intersection of cardinality one with the original support. -/
theorem ordinaryPartner_inter_card_eq_zero_or_two
    (S T : Finset G) (hS : S.card = 3) (hT : T.card = 3)
    (hST : S ≠ T) (hOrd : OrdinaryPartner S T) :
    (S ∩ T).card = 0 ∨ (S ∩ T).card = 2 := by
  obtain ⟨u, hu, hTu⟩ := hOrd
  have hu0 : u ≠ 0 := by
    intro hz
    apply hST
    simpa [hz, translateSupport] using hTu.symm
  have hle : (S ∩ T).card ≤ 3 := by
    calc
      (S ∩ T).card ≤ S.card := Finset.card_le_card Finset.inter_subset_left
      _ = 3 := hS
  have hne1 : (S ∩ T).card ≠ 1 := by
    intro h1
    obtain ⟨x, hx⟩ := Finset.card_eq_one.mp h1
    have hxmem : x ∈ S ∩ T := by rw [hx]; simp
    have hxumem : x + u ∈ S ∩ T := by
      rw [hTu] at hxmem ⊢
      exact inter_translateSupport_add_mem S u hu x hxmem
    have hxu : x + u = x := by
      simpa only [hx, Finset.mem_singleton] using hxumem
    apply hu0
    exact add_left_cancel (show x + u = x + 0 by simpa using hxu)
  have hne3 : (S ∩ T).card ≠ 3 := by
    intro h3
    have hIS : S ∩ T = S :=
      Finset.eq_of_subset_of_card_le Finset.inter_subset_left (by omega)
    have hIT : S ∩ T = T :=
      Finset.eq_of_subset_of_card_le Finset.inter_subset_right (by omega)
    exact hST (hIS.symm.trans hIT)
  omega

#print axioms Couret.STROBO2TORS.inter_translateSupport_add_mem
#print axioms Couret.STROBO2TORS.ordinaryPartner_inter_card_eq_zero_or_two

end Couret.STROBO2TORS
