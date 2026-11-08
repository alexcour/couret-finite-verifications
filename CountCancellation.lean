module

public import SquareExpansion

@[expose] public section

set_option autoImplicit false
namespace Couret.InterIA.SingletonNecessity
open Couret.InterIA.Parity
variable {G : Type*} [AddCommGroup G] [DecidableEq G]

theorem cross_count_cancellation (x : Fin 6 → G) (hd : SevenDistinct x)
    (hx : CrossDoubles x)
    (hs : ∀ z, orderedSquare (supportLeft x) z=orderedSquare (supportRight x) z) :
    (sumTermsLeft x).Perm (sumTermsRight x) := by
  apply List.perm_iff_count.mpr
  intro z
  have h := hs z
  rw [square_supportLeft x hd,square_supportRight x hd] at h
  rcases hx with ⟨h0,h1,h2⟩
  rw [h0,h1,h2] at h
  omega

theorem mixed_count_cancellation (x : Fin 6 → G) (hd : SevenDistinct x)
    (hx : MixedDoubles x)
    (hs : ∀ z, orderedSquare (supportLeft x) z=orderedSquare (supportRight x) z) :
    (sumTermsLeft x ++ [x 0+x 0]).Perm (sumTermsRight x ++ [x 3+x 3]) := by
  apply List.perm_iff_count.mpr
  intro z
  have h := hs z
  rw [square_supportLeft x hd,square_supportRight x hd] at h
  rcases hx with ⟨h0,h1,h2⟩
  rw [← h0,← h1,h2] at h
  simp only [List.count_cons,List.count_nil,beq_iff_eq,add_zero] at h
  simp only [List.count_append,List.count_cons,List.count_nil,beq_iff_eq,add_zero]
  omega

end Couret.InterIA.SingletonNecessity
