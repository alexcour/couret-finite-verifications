import Strobo2TorsNontranslationDegree

set_option autoImplicit false

namespace Couret.STROBO2TORS

variable {G : Type*} [AddCommGroup G] [DecidableEq G] [Fintype G]

/-- The nontranslation collision relation is symmetric: all ambient
translations are excluded, not just those in the two-torsion subgroup. -/
theorem nontranslatedNeighbours_symm
    (S T : Finset G) (hS : S.card = 3)
    (hT : T ∈ nontranslatedNeighbours S) :
    S ∈ nontranslatedNeighbours T := by
  obtain ⟨hTcard, hSq, hNo⟩ :=
    (mem_nontranslatedNeighbours S T hS).mp hT
  apply (mem_nontranslatedNeighbours T S hTcard).mpr
  refine ⟨hS, (fun z => (hSq z).symm), ?_⟩
  rintro ⟨v, hv⟩
  apply hNo
  refine ⟨-v, ?_⟩
  have hh := congrArg (fun X : Finset G => translateSupport X (-v)) hv
  rw [translateSupport_add] at hh
  simpa using hh.symm

/-- No support is its own nontranslated collision partner. -/
theorem nontranslatedNeighbours_irrefl (S : Finset G)
    (hS : S.card = 3) : S ∉ nontranslatedNeighbours S := by
  intro h
  have hNo := ((mem_nontranslatedNeighbours S S hS).mp h).2.2
  apply hNo
  refine ⟨0, ?_⟩
  simp [translateSupport]

end Couret.STROBO2TORS

#print axioms Couret.STROBO2TORS.nontranslatedNeighbours_symm
#print axioms Couret.STROBO2TORS.nontranslatedNeighbours_irrefl
