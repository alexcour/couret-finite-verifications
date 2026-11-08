module

public import ConditionalNecessity
public import ExclusiveEnumeration
public import ParityRelabel
public import CountCancellation
public import MatchingEncoding

@[expose] public section

set_option autoImplicit false
namespace Couret.InterIA.SingletonNecessity
open Couret.InterIA.Parity Couret.InterIA.AbelianBoundary
variable {G : Type*} [AddCommGroup G] [DecidableEq G]

theorem collision_matching_extraction (x : Fin 6 → G) (hd : SevenDistinct x)
    (hs : ∀ z, orderedSquare (supportLeft x) z=orderedSquare (supportRight x) z) :
    ∃ y : Fin 6 → G, SevenDistinct y ∧ supportLeft y=supportLeft x ∧
      supportRight y=supportRight x ∧
      ((∃ p : List ℕ, p.Perm (List.range 6) ∧ RelationsHold y false p) ∨
       (∃ p : List ℕ, p.Perm (List.range 7) ∧ RelationsHold y true p)) := by
  obtain ⟨y,hy,hyl,hyr,hc|hm⟩ := parity_relabel x hd (fibreParity_of_collision x hd hs)
  · refine ⟨y,hy,hyl,hyr,Or.inl ?_⟩
    exact cross_encoding y hc (cross_count_cancellation y hy hc (by
      simpa only [hyl,hyr] using hs))
  · refine ⟨y,hy,hyl,hyr,Or.inr ?_⟩
    exact mixed_encoding y hm (mixed_count_cancellation y hy hm (by
      simpa only [hyl,hyr] using hs))

theorem contains_c4_square_necessary (A B : Finset G)
    (ha : A.card=4) (hb : B.card=4) (hi : (A ∩ B).card=1)
    (hs : ∀ z, orderedSquare A z=orderedSquare B z) :
    ∃ φ : G4 →+ G, Function.Injective φ := by
  obtain ⟨A₀,B₀,ha₀,hb₀,hi₀,hs₀⟩ := normalize_singleton_collision A B ha hb hi hs
  obtain ⟨x,hd,hl,hr⟩ := exclusive_enumeration A₀ B₀ ha₀ hb₀ hi₀
  have hx : ∀ z, orderedSquare (supportLeft x) z=orderedSquare (supportRight x) z := by
    simpa only [hl,hr] using hs₀
  obtain ⟨y,hy,_,_,hm⟩ := collision_matching_extraction x hd hx
  exact contains_c4_square_of_matching y hy hm

theorem singleton_collision_iff_contains_c4_square :
    (∃ A B : Finset G, A.card=4 ∧ B.card=4 ∧ (A ∩ B).card=1 ∧
      ∀ z, orderedSquare A z=orderedSquare B z) ↔
    (∃ φ : G4 →+ G, Function.Injective φ) := by
  constructor
  · rintro ⟨A,B,ha,hb,hi,hs⟩
    exact contains_c4_square_necessary A B ha hb hi hs
  · rintro ⟨φ,hφ⟩
    exact contains_c4_square_sufficient φ hφ

end Couret.InterIA.SingletonNecessity
