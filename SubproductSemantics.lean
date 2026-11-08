module

public import MaskSemantics

@[expose] public section
set_option maxRecDepth 100000
set_option maxHeartbeats 4000000
namespace Couret
namespace S5


def selectedSupport (w : Word Code30) (u : Code30) : Prop :=
  ∃ s : Choice w, s.picked ∧ Choice.eval mod30Product s = u

def subStep (m : Nat) (g : Code30) : Nat :=
  m ||| shiftMask g m ||| singletonMask g

def subRun : Word Code30 → Nat
  | .empty => 0
  | .snoc w g => subStep (subRun w) g

theorem subStep_bound (m : Nat) (hm : m < 256) (g : Code30) : subStep m g < 256 := by
  change (m ||| shiftMask g m ||| singletonMask g) < 2^8
  exact Nat.or_lt_two_pow (Nat.or_lt_two_pow hm (shiftMaskOn_lt_256 g m pythonAlphabet)) (singletonMask_lt_256 g)

theorem subRun_bound (w : Word Code30) : subRun w < 256 := by
  induction w with
  | empty => change 0 < 256; decide
  | snoc w g ih => exact subStep_bound _ ih g

theorem subStep_support (m : Nat) (g u : Code30) :
    maskSupport (subStep m g) u ↔
      maskSupport m u ∨ (∃ v, maskSupport m v ∧ mul30 g v = u) ∨ u = g := by
  simp only [subStep, maskSupport_or, shiftMask_support, maskSupport_singleton]
  exact or_assoc

theorem selectedSupport_snoc (w : Word Code30) (g u : Code30) :
    selectedSupport (.snoc w g) u ↔
      selectedSupport w u ∨ (∃ v, selectedSupport w v ∧ mul30 g v = u) ∨ u = g := by
  constructor
  · rintro ⟨s,hp,he⟩
    cases s with
    | skip s => exact Or.inl ⟨s,hp,he⟩
    | take s =>
      by_cases hs : s.picked
      · exact Or.inr (Or.inl ⟨Choice.eval mod30Product s,⟨s,hs,rfl⟩,
          (mod30Product.comm _ _).trans he⟩)
      · have h0 := Choice.eval_of_not_picked mod30Product s hs
        have hg : Choice.eval mod30Product (.take s g) = g := by
          change mod30Product.mul (Choice.eval mod30Product s) g = g
          rw [h0]; exact mod30Product.one_mul g
        exact Or.inr (Or.inr (he.symm.trans hg))
  · intro h
    rcases h with ⟨s,hp,he⟩ | ⟨v,⟨s,hp,he⟩,hprod⟩ | h
    · exact ⟨.skip s g,hp,he⟩
    · refine ⟨.take s g,True.intro,?_⟩
      change mod30Product.mul (Choice.eval mod30Product s) g = u
      rw [he,mod30Product.comm]; exact hprod
    · refine ⟨.take (Choice.allSkip w) g,True.intro,?_⟩
      change mod30Product.mul (Choice.eval mod30Product (Choice.allSkip w)) g = u
      rw [Choice.eval_allSkip,mod30Product.one_mul]; exact h.symm

theorem subRun_exact (w : Word Code30) (u : Code30) :
    maskSupport (subRun w) u ↔ selectedSupport w u := by
  induction w generalizing u with
  | empty =>
    constructor
    · exact fun h => False.elim (maskSupport_zero u h)
    · rintro ⟨s,h,_⟩; cases s; exact False.elim h
  | snoc w g ih =>
    rw [subRun,subStep_support,selectedSupport_snoc]
    simp only [ih]

end S5
end Couret
