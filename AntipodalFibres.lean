module

public import ConvolutionParity

@[expose] public section

set_option autoImplicit false
namespace Couret.InterIA.Fibres
open Finset
variable {G : Type*} [AddCommGroup G] [DecidableEq G]

def fibre (h x : G) : Finset G := {x, x+h}

def fibres (h : G) (D : Finset G) : Finset (Finset G) :=
  D.image (fibre h)

theorem fibre_card (h x : G) (hh : h ≠ 0) : (fibre h x).card = 2 := by
  apply Finset.card_pair
  intro he
  exact hh (add_left_cancel (by simpa using he.symm : x+h=x+0))

theorem fibre_partner (h x : G) (hh2 : h+h=0) : fibre h (x+h)=fibre h x := by
  have he : (x+h)+h=x := by rw [add_assoc,hh2,add_zero]
  simp [fibre,he,Finset.pair_comm]

theorem fibre_eq_of_mem (h x y : G) (hh2 : h+h=0)
    (hy : y ∈ fibre h x) : fibre h y=fibre h x := by
  simp only [fibre,mem_insert,mem_singleton] at hy
  rcases hy with rfl|rfl
  · rfl
  · exact fibre_partner h x hh2

theorem fibres_pairwise_disjoint (h : G) (hh2 : h+h=0) (D : Finset G) :
    (fibres h D : Set (Finset G)).PairwiseDisjoint id := by
  intro A hA B hB hne
  obtain ⟨x,hx,rfl⟩ := Finset.mem_image.mp hA
  obtain ⟨y,hy,rfl⟩ := Finset.mem_image.mp hB
  apply Finset.disjoint_left.mpr
  intro z hz hzy
  exact hne ((fibre_eq_of_mem h x z hh2 hz).symm.trans
    (fibre_eq_of_mem h y z hh2 hzy))

theorem fibres_union (h : G) (D : Finset G)
    (hstable : ∀ x ∈ D, x+h ∈ D) : (fibres h D).biUnion id = D := by
  ext z
  constructor
  · intro hz
    obtain ⟨A,hA,hzA⟩ := Finset.mem_biUnion.mp hz
    obtain ⟨x,hx,rfl⟩ := Finset.mem_image.mp hA
    simp only [id_eq,fibre,mem_insert,mem_singleton] at hzA
    rcases hzA with rfl|rfl
    · exact hx
    · exact hstable x hx
  · intro hz
    exact Finset.mem_biUnion.mpr ⟨fibre h z, Finset.mem_image.mpr ⟨z,hz,rfl⟩,
      by simp [fibre]⟩

theorem twice_fibres_card (h : G) (hh : h ≠ 0) (hh2 : h+h=0)
    (D : Finset G) (hstable : ∀ x ∈ D, x+h ∈ D) :
    2*(fibres h D).card = D.card := by
  have hc := Finset.card_biUnion (fibres_pairwise_disjoint h hh2 D)
  rw [fibres_union h D hstable] at hc
  have hs : ∑ A ∈ fibres h D, A.card = ∑ _A ∈ fibres h D, 2 := by
    apply Finset.sum_congr rfl
    intro A hA
    obtain ⟨x,hx,rfl⟩ := Finset.mem_image.mp hA
    exact fibre_card h x hh
  simp only [id_eq] at hc
  rw [hs] at hc
  simpa [Nat.mul_comm] using hc.symm

theorem four_support_fibres_count (h : G) (hh : h ≠ 0) (hh2 : h+h=0)
    (S T : Finset G) (hS : S.card=4) (hT : T.card=4)
    (hstable : ∀ x ∈ symmDiff S T, x+h ∈ symmDiff S T) :
    (fibres h (symmDiff S T)).card = 4-(S ∩ T).card := by
  have hc := twice_fibres_card h hh hh2 (symmDiff S T) hstable
  have h1 := Finset.card_sdiff_add_card_inter S T
  have h2 := Finset.card_sdiff_add_card_inter T S
  have hd : Disjoint (S \ T) (T \ S) := by
    apply Finset.disjoint_left.mpr
    intro x hx hy
    exact (Finset.mem_sdiff.mp hx).2 (Finset.mem_sdiff.mp hy).1
  have he : symmDiff S T = (S \ T) ∪ (T \ S) := by
    ext x
    simp only [Finset.mem_symmDiff, Finset.mem_union, Finset.mem_sdiff]
  have hD : (symmDiff S T).card = (S \ T).card+(T \ S).card := by
    rw [he,Finset.card_union_of_disjoint hd]
  rw [hD] at hc
  rw [Finset.inter_comm T S] at h2
  omega

theorem cyclic_collision_fibres_count (m : ℕ) (hm : 0 < m)
    (S T : Finset (ZMod (2*m))) (hS : S.card=4) (hT : T.card=4)
    (hsquare : ∀ z, Couret.InterIA.Parity.orderedSquare S z =
      Couret.InterIA.Parity.orderedSquare T z) :
    (fibres (m : ZMod (2*m)) (symmDiff S T)).card = 4-(S ∩ T).card := by
  apply four_support_fibres_count (m : ZMod (2*m))
    (Couret.InterIA.L4.half_ne_zero m hm) (Couret.InterIA.L4.half_add_half m) S T hS hT
  intro x hx
  exact (Couret.InterIA.Parity.even_symmetric_difference_stable m hm S T hsquare x).mp hx

end Couret.InterIA.Fibres
