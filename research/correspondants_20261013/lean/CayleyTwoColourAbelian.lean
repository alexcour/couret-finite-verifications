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

#print axioms Couret.CayleyDoublet.abelianSource_singleton_iff
#print axioms Couret.CayleyDoublet.abelianSource_doublet_iff

end AbelianTwoColour

end Couret.CayleyDoublet
