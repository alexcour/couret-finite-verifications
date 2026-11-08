module

public import Mathlib

@[expose] public section

set_option autoImplicit false

namespace Couret.PalomarCayley

variable {G : Type*} [AddCommGroup G] [DecidableEq G]

/-- Directed arc with an increment from the specified finite support. -/
def CayleyArc (S : Finset G) (x y : G) : Prop :=
  ∃ s ∈ S, y = x + s

/-- A singleton increment and a translated half-turn pair. -/
def TripleSupport (a b h : G) : Finset G := {a, b, b + h}

/-- Source increment support for the reflected exceptional pair. -/
def AbelianSource (a d h : G) : Finset G :=
  TripleSupport a (a + d) h

/-- Reflected target increment support. -/
def AbelianTarget (a d h : G) : Finset G :=
  TripleSupport a (a - d) h

/-- Under the explicit torsion and generation assumptions, the two directed Cayley
graphs are isomorphic exactly when a and h do not generate the ambient group. -/
theorem abelian_isomorphism_iff
    (a d h : G)
    (hhalf : h + h = 0) (hne : h ≠ 0)
    (hthree : (d + d) + d = 0 ∨ (d + d) + d = h)
    (hgen : AddSubgroup.closure ({a, d, h} : Set G) = ⊤)
    (hd2 : d + d ≠ 0) :
    (∃ f : G ≃ G, ∀ x y : G,
      CayleyArc (AbelianSource a d h) x y ↔
      CayleyArc (AbelianTarget a d h) (f x) (f y)) ↔
        AddSubgroup.closure ({a, h} : Set G) ≠ ⊤ := by
  sorry

/-- For every positive r, these explicit directed Cayley graphs on Z/(12r)Z
are not isomorphic. The quantifier ranges over all vertex equivalences,
without an affineness assumption. -/
theorem cyclic_nonisomorphism
    (r : ℕ) (hr : 0 < r)
    (f : ZMod (12 * r) ≃ ZMod (12 * r))
    (hf : ∀ x y : ZMod (12 * r),
      CayleyArc (TripleSupport (1 : ZMod (12 * r))
        ((1 + 2 * r : ℕ) : ZMod (12 * r))
        ((6 * r : ℕ) : ZMod (12 * r))) x y ↔
      CayleyArc (TripleSupport (1 : ZMod (12 * r))
        ((1 + 4 * r : ℕ) : ZMod (12 * r))
        ((6 * r : ℕ) : ZMod (12 * r))) (f x) (f y)) :
    False := by
  sorry

end Couret.PalomarCayley
