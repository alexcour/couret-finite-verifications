import CayleyDoubletCore
import CayleyTwoColourFamily

set_option autoImplicit false

/-!
COU-20 — finite abelian two-colour bridge (candidate, 16 Oct 2026).

This is a small proof layer for the generalized exceptional triple pair.
The universal dichotomy ("non-isomorphic iff the singleton step generates
the h-quotient") is NOT a theorem of this file. No release/priority claim.
-/

namespace Couret.CayleyDoublet

section AbelianTwoColour

variable {G : Type*} [AddCommGroup G] [DecidableEq G]

/-- The exceptional pair consists of two triples with shared singleton a. -/
def AbelianSource (a d h : G) : Finset G :=
  TripleSupport a (a + d) h

def AbelianTarget (a d h : G) : Finset G :=
  TripleSupport a (a - d) h

/-- By definition, the source has the expected three generators. -/
theorem abelianSource_members (a d h : G) :
    a ∈ AbelianSource a d h ∧
    a + d ∈ AbelianSource a d h ∧
    (a + d) + h ∈ AbelianSource a d h := by
  simp [AbelianSource, TripleSupport]

/-- Likewise the reflected target triple. -/
theorem abelianTarget_members (a d h : G) :
    a ∈ AbelianTarget a d h ∧
    a - d ∈ AbelianTarget a d h ∧
    (a - d) + h ∈ AbelianTarget a d h := by
  simp [AbelianTarget, TripleSupport]

/-- The marked half-turn exists for the source, without finiteness. -/
theorem abelianSource_halfTurn_isMate
    (a d h : G) (hhalf : h + h = 0) (hne : h ≠ 0) (x : G) :
    IsMate (CayleyArc (AbelianSource a d h)) x (x + h) := by
  exact halfTurn_isMate a (a + d) h hhalf hne x

/-- The marked half-turn exists for the target, without finiteness. -/
theorem abelianTarget_halfTurn_isMate
    (a d h : G) (hhalf : h + h = 0) (hne : h ≠ 0) (x : G) :
    IsMate (CayleyArc (AbelianTarget a d h)) x (x + h) := by
  exact halfTurn_isMate a (a - d) h hhalf hne x

/-- Singleton and doublet membership of the source are intrinsically defined
once the mate x+h is identified. -/
theorem abelianSource_singleton_iff
    (a d h : G) (hhalf : h + h = 0) (hne : h ≠ 0)
    (had : a ≠ a + d) (hadh : a ≠ (a + d) + h)
    (x y : G) :
    SingletonArc (CayleyArc (AbelianSource a d h))
      (fun z => z + h) x y ↔ y = x + a := by
  exact singletonArc_iff_point a (a + d) h hhalf hne had hadh x y

/-- The marked pair of source arcs is exactly the d, d+h pair. -/
theorem abelianSource_doublet_iff
    (a d h : G) (hhalf : h + h = 0) (hne : h ≠ 0)
    (had : a ≠ a + d) (hadh : a ≠ (a + d) + h)
    (x y : G) :
    DoubletArc (CayleyArc (AbelianSource a d h))
      (fun z => z + h) x y ↔
      y = x + (a + d) ∨ y = x + ((a + d) + h) := by
  exact markedArc_iff_pair a (a + d) h hhalf hne had hadh x y


/-- Strengthening of the existing two-colour obstruction: it is enough that
the source doublet increment is a natural iterate of the singleton increment
*modulo the intrinsic half-turn*.  The quotient cyclicity is NOT assumed.

The extra hypotheses are precisely those used by noIso_of_two_colours.
In particular this theorem does not claim that arbitrary abelian Cayley
graphs have intrinsic two-colour structure. -/
theorem noIso_of_two_colours_mod_halfTurn
    (a b c h : G)
    (hhalf : h + h = 0) (hne : h ≠ 0)
    (hab : a ≠ b) (habh : a ≠ b + h)
    (hac : a ≠ c) (hach : a ≠ c + h)
    (hthreeT : (a - c) + (a - c) + (a - c) = 0 ∨
      (a - c) + (a - c) + (a - c) = h)
    (k : ℕ) (hbkm : b = k • a ∨ b + h = k • a)
    (hbc : b ≠ c) (hbch : b ≠ c + h)
    (f : G ≃ G)
    (hf : ∀ x y, CayleyArc (TripleSupport a b h) x y ↔
      CayleyArc (TripleSupport a c h) (f x) (f y)) : False := by
  rcases hbkm with hbk | hbk
  · exact noIso_of_two_colours a b c h hhalf hne
      hab habh hac hach hthreeT k hbk hbc hbch f hf
  · have hh : (b + h) + h = b := by
      calc
        (b + h) + h = b + (h + h) := by abel
        _ = b := by simp [hhalf]
    have hswap : TripleSupport a (b + h) h = TripleSupport a b h := by
      apply Finset.ext
      intro x
      simp only [TripleSupport, Finset.mem_insert, Finset.mem_singleton, hh]
      tauto
    have hab' : a ≠ b + h := habh
    have habh' : a ≠ (b + h) + h := by
      simpa only [hh] using hab
    have hbc' : b + h ≠ c := by
      intro he
      apply hbch
      calc
        b = (b + h) + h := hh.symm
        _ = c + h := by rw [he]
    have hbch' : b + h ≠ c + h := by
      intro he
      apply hbc
      calc
        b = (b + h) + h := hh.symm
        _ = (c + h) + h := by rw [he]
        _ = c := by
          calc
            (c + h) + h = c + (h + h) := by abel
            _ = c := by simp [hhalf]
    have hf' : ∀ x y, CayleyArc (TripleSupport a (b + h) h) x y ↔
        CayleyArc (TripleSupport a c h) (f x) (f y) := by
      intro x y
      rw [hswap]
      exact hf x y
    exact noIso_of_two_colours a (b + h) c h hhalf hne
      hab' habh' hac hach hthreeT k hbk hbc' hbch' f hf'

#print axioms Couret.CayleyDoublet.noIso_of_two_colours_mod_halfTurn

#print axioms Couret.CayleyDoublet.abelianSource_singleton_iff
#print axioms Couret.CayleyDoublet.abelianSource_doublet_iff

end AbelianTwoColour

end Couret.CayleyDoublet
