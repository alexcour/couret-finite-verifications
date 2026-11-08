module

public import StableFibreLift

@[expose] public section

set_option autoImplicit false
namespace Couret.InterIA.Fibres
open Finset Couret.InterIA.Parity Couret.InterIA.Projection

/-- The original labelled four-point fibre, with a modulus-independent interface. -/
def cyclicFourFibre (n : ℕ) (S : Finset (ZMod n)) : Set (Finset (ZMod n)) :=
  {T | T.card=4 ∧ ∀ z, orderedSquare S z=orderedSquare T z}

/-- Exhaustiveness at the support level: no assumption about a collision partner. -/
theorem even_four_support_cases (m : ℕ) (hm : 0 < m) (S : Finset (ZMod (2*m)))
    (hS : S.card=4) :
    AntipodalFree m S ∨ (∀ x ∈ S, x+m ∈ S) ∨
      ∃ (C : Finset (ZMod (2*m))) (a : ZMod (2*m)),
        C.card=2 ∧ AntipodalFree m C ∧ Disjoint C (fibre (m : ZMod (2*m)) a) ∧
          S=C ∪ fibre (m : ZMod (2*m)) a := by
  classical
  by_cases hf : AntipodalFree m S
  · exact Or.inl hf
  · have hex : ∃ a ∈ S, a+(m : ZMod (2*m)) ∈ S := by
      by_contra hn
      apply hf
      intro x hx hxm
      exact hn ⟨x,hx,hxm⟩
    obtain ⟨a,ha,ham⟩ := hex
    let D := fibre (m : ZMod (2*m)) a
    let C := S \ D
    have hD : D ⊆ S := by
      intro x hx
      rcases Finset.mem_insert.mp hx with rfl|hx
      · exact ha
      · exact Finset.mem_singleton.mp hx ▸ ham
    have hd : Disjoint C D := Finset.sdiff_disjoint
    have hSe : S=C ∪ D := (Finset.sdiff_union_of_subset hD).symm
    have hC : C.card=2 := by
      have hc := Finset.card_union_of_disjoint hd
      rw [← hSe,hS,fibre_card _ a (Couret.InterIA.L4.half_ne_zero m hm)] at hc
      omega
    by_cases hc : AntipodalFree m C
    · exact Or.inr (Or.inr ⟨C,a,hC,hc,hd,hSe⟩)
    · have hexC : ∃ b ∈ C, b+(m : ZMod (2*m)) ∈ C := by
        by_contra hn
        apply hc
        intro x hx hxm
        exact hn ⟨x,hx,hxm⟩
      obtain ⟨b,hb,hbm⟩ := hexC
      have hB : fibre (m : ZMod (2*m)) b ⊆ C := by
        intro x hx
        rcases Finset.mem_insert.mp hx with rfl|hx
        · exact hb
        · exact Finset.mem_singleton.mp hx ▸ hbm
      have hCe : C=fibre (m : ZMod (2*m)) b :=
        (Finset.eq_of_subset_of_card_le hB (by rw [hC,fibre_card _ b (Couret.InterIA.L4.half_ne_zero m hm)])).symm
      refine Or.inr (Or.inl ?_)
      rw [hSe,hCe]
      intro x hx
      rcases Finset.mem_union.mp hx with hx|hx
      · exact Finset.mem_union.mpr (Or.inl (Couret.InterIA.IntersectionTwo.stable_pair_of_antipodal b m
          (Couret.InterIA.L4.half_add_half m) x hx))
      · exact Finset.mem_union.mpr (Or.inr (Couret.InterIA.IntersectionTwo.stable_pair_of_antipodal a m
          (Couret.InterIA.L4.half_add_half m) x hx))

theorem odd_four_fibre_singleton (n : ℕ) (hn : Odd n) (S : Finset (ZMod n)) (hS : S.card=4) :
    cyclicFourFibre n S={S} := by
  ext T
  constructor
  · intro hT
    exact Set.mem_singleton_iff.mpr (odd_cyclic_square_injective n hn S T hT.2).symm
  · intro hT
    rw [Set.mem_singleton_iff.mp hT]
    exact ⟨hS,fun _ => rfl⟩

theorem even_four_fibre_ncard (m : ℕ) (hm : 0 < m) (S : Finset (ZMod (2*m))) (hS : S.card=4) :
    (cyclicFourFibre (2*m) S).ncard=1 ∨ (cyclicFourFibre (2*m) S).ncard=2 ∨
      (cyclicFourFibre (2*m) S).ncard=4 := by
  change (originalFibre m S).ncard=1 ∨ (originalFibre m S).ncard=2 ∨ (originalFibre m S).ncard=4
  rcases even_four_support_cases m hm S hS with hf|hs|⟨C,a,hC,hf,hd,hSe⟩
  · right; left
    change (cyclicFourFibre (2*m) S).ncard=2
    have he := antipodal_free_four_fibre_eq_pair m hm S hS hf
    change cyclicFourFibre (2*m) S=_ at he
    rw [he,Set.ncard_pair (antipodal_free_four_ne_half_translate m S hS hf)]
  · rcases stable_four_fibre_ncard m hm S hS hs with h|h
    · exact Or.inl h
    · exact Or.inr (Or.inl h)
  · rw [hSe]
    exact Or.inr (two_simple_fibre_ncard m hm C a hC hf hd)

theorem cyclic_four_fibre_ncard (n : ℕ) (hn : 0 < n) (S : Finset (ZMod n)) (hS : S.card=4) :
    (cyclicFourFibre n S).ncard=1 ∨ (cyclicFourFibre n S).ncard=2 ∨ (cyclicFourFibre n S).ncard=4 := by
  rcases Nat.even_or_odd n with he|ho
  · obtain ⟨m,hm⟩ := he
    have hn2 : n=2*m := by omega
    clear hm
    subst n
    exact even_four_fibre_ncard m (by omega) S hS
  · exact Or.inl (by rw [odd_four_fibre_singleton n ho S hS,Set.ncard_singleton])

end Couret.InterIA.Fibres
