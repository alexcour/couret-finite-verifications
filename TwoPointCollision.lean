module

public import ConvolutionParity

@[expose] public section

set_option autoImplicit false
namespace Couret.InterIA.TwoPoint
open Finset Couret.InterIA.Parity
variable {G : Type*} [AddCommGroup G] [DecidableEq G]

def pairCoeff (a b z : G) : ℕ :=
  (if a+a=z then 1 else 0)+(if b+b=z then 1 else 0)+
    2*(if a+b=z then 1 else 0)

theorem pair_coeff_comm (a b z : G) : pairCoeff a b z=pairCoeff b a z := by
  simp [pairCoeff,add_comm,add_left_comm]

theorem pair_sum_ne_left_double (a b : G) (hab : a ≠ b) : a+b ≠ a+a := by
  intro he
  exact hab (add_left_cancel he).symm

theorem pair_sum_ne_right_double (a b : G) (hab : a ≠ b) : a+b ≠ b+b := by
  intro he
  exact hab (add_right_cancel he)

theorem actual_pair_coefficient (a b z : G) (hab : a ≠ b) :
    orderedSquare ({a,b} : Finset G) z=pairCoeff a b z := by
  simp only [orderedSquare,Finset.sum_pair hab]
  unfold pairCoeff
  rw [add_comm b a]
  split_ifs <;> omega

theorem pair_coeff_at_sum (a b : G) (hab : a ≠ b) : pairCoeff a b (a+b)=2 := by
  simp [pairCoeff,(pair_sum_ne_left_double a b hab).symm,
    (pair_sum_ne_right_double a b hab).symm]

theorem pair_coeff_at_double_distinct (a b : G) (hab : a ≠ b)
    (hd : a+a ≠ b+b) : pairCoeff a b (a+a)=1 := by
  simp [pairCoeff,hd.symm,pair_sum_ne_left_double a b hab]

theorem pair_coeff_at_double_equal (a b : G) (hab : a ≠ b)
    (hd : a+a=b+b) : pairCoeff a b (a+a)=2 := by
  simp [pairCoeff,hd.symm,pair_sum_ne_left_double a b hab]

theorem matched_double_forces_center (a b c d : G) (hab : a ≠ b)
    (hd : a+a ≠ b+b)
    (heq : ∀ z, pairCoeff a b z=pairCoeff c d z)
    (hc : c+c=a+a) : c+d=a+b := by
  have hp := heq (a+b)
  rw [pair_coeff_at_sum a b hab] at hp
  have hc0 : c+c ≠ a+b := by
    rw [hc]
    exact (pair_sum_ne_left_double a b hab).symm
  by_contra hcenter
  simp only [pairCoeff,if_neg hc0,if_neg hcenter,zero_add,mul_zero,add_zero] at hp
  split_ifs at hp <;> omega

theorem distinct_doubles_gap (a b c d : G) (hab : a ≠ b)
    (hd : a+a ≠ b+b)
    (heq : ∀ z, pairCoeff a b z=pairCoeff c d z) :
    d-c=b-a ∨ c-d=b-a := by
  have hp := heq (a+a)
  rw [pair_coeff_at_double_distinct a b hab hd] at hp
  have hc : c+c=a+a ∨ d+d=a+a := by
    by_contra hn
    have hnc : c+c ≠ a+a := by tauto
    have hnd : d+d ≠ a+a := by tauto
    simp only [pairCoeff,if_neg hnc,if_neg hnd,zero_add] at hp
    split_ifs at hp <;> omega
  rcases hc with hc|hd'
  · have hs := matched_double_forces_center a b c d hab hd heq hc
    left
    calc d-c=(c+d)-(c+c) := by abel
         _=(a+b)-(a+a) := by rw [hs,hc]
         _=b-a := by abel
  · have heq' : ∀ z, pairCoeff a b z=pairCoeff d c z := by
      intro z
      exact (heq z).trans (pair_coeff_comm c d z)
    have hs := matched_double_forces_center a b d c hab hd heq' hd'
    right
    calc c-d=(d+c)-(d+d) := by abel
         _=(a+b)-(a+a) := by rw [hs,hd']
         _=b-a := by abel

theorem equal_doubles_transfer (a b c d : G) (hcd : c ≠ d)
    (hd : a+a=b+b)
    (heq : ∀ z, pairCoeff a b z=pairCoeff c d z) : c+c=d+d := by
  by_contra hne
  have hp := heq (c+c)
  rw [pair_coeff_at_double_distinct c d hcd hne] at hp
  have hba : b+b=a+a := hd.symm
  simp only [pairCoeff,hba] at hp
  split_ifs at hp <;> omega

theorem equal_doubles_positions (a b z : G) (hd : a+a=b+b)
    (hp : pairCoeff a b z=2) : a+a=z ∨ a+b=z := by
  by_contra hn
  have h1 : a+a ≠ z := by tauto
  have h2 : a+b ≠ z := by tauto
  have h3 : b+b ≠ z := by rw [← hd]; exact h1
  simp [pairCoeff,h1,h2,h3] at hp

theorem equal_doubles_gap (a b c d : G) (hab : a ≠ b) (hcd : c ≠ d)
    (hd : a+a=b+b)
    (heq : ∀ z, pairCoeff a b z=pairCoeff c d z) :
    d-c=b-a ∨ c-d=b-a := by
  have hD := equal_doubles_transfer a b c d hcd hd heq
  have hp1 : pairCoeff a b (c+c)=2 := by
    rw [heq,pair_coeff_at_double_equal c d hcd hD]
  have hp2 : pairCoeff a b (c+d)=2 := by rw [heq,pair_coeff_at_sum c d hcd]
  rcases equal_doubles_positions a b (c+c) hd hp1 with hc|hc <;>
    rcases equal_doubles_positions a b (c+d) hd hp2 with hs|hs
  · exact False.elim (pair_sum_ne_left_double c d hcd (hs.symm.trans hc))
  · left
    calc d-c=(c+d)-(c+c) := by abel
         _=(a+b)-(a+a) := by rw [← hs,← hc]
         _=b-a := by abel
  · right
    calc c-d=(c+c)-(c+d) := by abel
         _=(a+b)-(a+a) := by rw [← hc,← hs]
         _=b-a := by abel
  · exact False.elim (pair_sum_ne_left_double c d hcd (hs.symm.trans hc))

theorem pair_profiles_force_gap (a b c d : G) (hab : a ≠ b) (hcd : c ≠ d)
    (heq : ∀ z, pairCoeff a b z=pairCoeff c d z) :
    d-c=b-a ∨ c-d=b-a := by
  by_cases hd : a+a=b+b
  · exact equal_doubles_gap a b c d hab hcd hd heq
  · exact distinct_doubles_gap a b c d hab hd heq

theorem gap_produces_translation (a b c d : G)
    (hgap : d-c=b-a ∨ c-d=b-a) :
    ∃ t : G, ({a,b} : Finset G).image (fun x => x+t)=({c,d} : Finset G) := by
  rcases hgap with hgap|hgap
  · refine ⟨c-a,?_⟩
    have ha : a+(c-a)=c := by abel
    have hb : b+(c-a)=d := by
      calc b+(c-a)=(b-a)+c := by abel
           _=(d-c)+c := by rw [hgap]
           _=d := by abel
    simp [ha,hb]
  · refine ⟨d-a,?_⟩
    have ha : a+(d-a)=d := by abel
    have hb : b+(d-a)=c := by
      calc b+(d-a)=(b-a)+d := by abel
           _=(c-d)+d := by rw [hgap]
           _=c := by abel
    simp [ha,hb,Finset.pair_comm]

/-- Equality of actual ordered squares of two distinct-point pairs forces translation. -/
theorem two_point_collision_is_translation (a b c d : G)
    (hab : a ≠ b) (hcd : c ≠ d)
    (hsquare : ∀ z, orderedSquare ({a,b} : Finset G) z=
      orderedSquare ({c,d} : Finset G) z) :
    ∃ t : G, ({a,b} : Finset G).image (fun x => x+t)=({c,d} : Finset G) := by
  apply gap_produces_translation a b c d
  apply pair_profiles_force_gap a b c d hab hcd
  intro z
  simpa only [actual_pair_coefficient a b z hab,actual_pair_coefficient c d z hcd] using hsquare z

/-- Intrinsic support formulation; no enumeration or bound on the ambient group. -/
theorem cardinal_two_collision_is_translation (S T : Finset G)
    (hS : S.card=2) (hT : T.card=2)
    (hsquare : ∀ z, orderedSquare S z=orderedSquare T z) :
    ∃ t : G, S.image (fun x => x+t)=T := by
  obtain ⟨a,b,hab,rfl⟩ := Finset.card_eq_two.mp hS
  obtain ⟨c,d,hcd,rfl⟩ := Finset.card_eq_two.mp hT
  exact two_point_collision_is_translation a b c d hab hcd hsquare

end Couret.InterIA.TwoPoint
