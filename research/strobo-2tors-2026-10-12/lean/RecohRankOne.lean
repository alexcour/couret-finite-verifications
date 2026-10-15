import RecohPivotCollision

set_option autoImplicit false

/-!
RECOH rank-one information-set base case.
A genuinely injective binary bank on ZMod 2 must contain
at least one coordinate detecting the unique nonzero element.
This does NOT prove the higher-rank information-set lemma.
-/

namespace Couret.STROBO2TORS

theorem recoh_rank_one_has_detecting_coordinate
    (k : ℕ)
    (bank : Fin k → ZMod 2 →+ ZMod 2)
    (hinj : Function.Injective
      (fun x : ZMod 2 => fun i : Fin k => bank i x)) :
    ∃ i : Fin k, bank i (1 : ZMod 2) ≠ 0 := by
  by_contra h
  have hz : ∀ i : Fin k, bank i (1 : ZMod 2) = 0 := by
    intro i
    by_contra hi
    exact h ⟨i, hi⟩
  have heq :
      (fun i : Fin k => bank i (1 : ZMod 2)) =
        (fun i : Fin k => bank i (0 : ZMod 2)) := by
    funext i
    simpa using hz i
  have h10 : (1 : ZMod 2) = 0 := hinj heq
  exact (by decide : (1 : ZMod 2) ≠ 0) h10

end Couret.STROBO2TORS

#print axioms Couret.STROBO2TORS.recoh_rank_one_has_detecting_coordinate
