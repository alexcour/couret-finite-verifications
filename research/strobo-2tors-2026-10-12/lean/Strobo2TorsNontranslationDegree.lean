import Strobo2TorsNontranslationBridge
import Strobo2TorsEnumeration

set_option autoImplicit false

open scoped BigOperators

namespace Couret.STROBO2TORS

variable {G : Type*} [AddCommGroup G] [DecidableEq G] [Fintype G]

/-- For one source triple S, retain precisely its partners in the labelled
ordered-square fibre which are not in its two-torsion translation orbit. -/
def nontranslatedNeighbours (S : Finset G) : Finset (Finset G) :=
  squareFibre S \ torsionOrbit S

/-- The complement of the ordinary orbit really excludes every ambient
translation, not just translations from G[2]. -/
theorem mem_nontranslatedNeighbours (S T : Finset G) (hS : S.card = 3) :
    T ∈ nontranslatedNeighbours S ↔
      T.card = 3 ∧
      (∀ z : G, orderedSquare S z = orderedSquare T z) ∧
      ¬ ∃ v : G, T = translateSupport S v := by
  constructor
  · intro hT
    obtain ⟨hFib, hNotOrb⟩ := Finset.mem_sdiff.mp hT
    obtain ⟨hTcard, hSq⟩ := (mem_squareFibre S T).mp hFib
    refine ⟨hTcard, hSq, ?_⟩
    intro hTranslate
    have hOrd : OrdinaryPartner S T :=
      (orderedSquare_translation_iff_ordinary S T hS hTcard).mp
        ⟨hSq, hTranslate⟩
    exact hNotOrb ((mem_torsionOrbit S T).mpr hOrd)
  · rintro ⟨hTcard, hSq, hNotTranslate⟩
    apply Finset.mem_sdiff.mpr
    refine ⟨(mem_squareFibre S T).mpr ⟨hTcard, hSq⟩, ?_⟩
    intro hOrd
    obtain ⟨u, _, hTranslate⟩ := (mem_torsionOrbit S T).mp hOrd
    exact hNotTranslate ⟨u, hTranslate⟩

/-- Every source triple has square-fibre size minus its ordinary orbit size
nontranslated partners. This is the first counting reduction. -/
theorem nontranslatedNeighbours_card (S : Finset G) (hS : S.card = 3) :
    (nontranslatedNeighbours S).card =
      (squareFibre S).card - (twoTorsion : Finset G).card := by
  rw [nontranslatedNeighbours,
    Finset.card_sdiff_of_subset (torsionOrbit_subset_fibre S hS),
    torsionOrbit_card S hS]

/-- Exceptional supports have exactly h exceptional partners. -/
theorem nontranslatedNeighbours_card_exceptional (S : Finset G)
    (hExc : S ∈ (exceptionalSupports : Finset (Finset G))) :
    (nontranslatedNeighbours S).card = (twoTorsion : Finset G).card := by
  obtain ⟨hS, hCard⟩ := (mem_exceptionalSupports_card S).mp hExc
  rw [nontranslatedNeighbours_card S hS, hCard]
  have hPos := twoTorsion_card_pos (G := G)
  omega

/-- An ordinary support has no nontranslated partners. -/
theorem nontranslatedNeighbours_card_ordinary (S : Finset G)
    (hS : S.card = 3)
    (hNotExc : S ∉ (exceptionalSupports : Finset (Finset G))) :
    (nontranslatedNeighbours S).card = 0 := by
  rcases squareFibre_card_h_or_two_h S hS with hOrd | hExc
  · rw [nontranslatedNeighbours_card S hS, hOrd, Nat.sub_self]
  · exact (hNotExc ((mem_exceptionalSupports_card S).mpr ⟨hS, hExc⟩)).elim

/-- All source triples contribute h or zero according to the existing
exceptional-support classification. -/
theorem nontranslatedNeighbours_card_ite (S : Finset G)
    (hS : S.card = 3) :
    (nontranslatedNeighbours S).card =
      if S ∈ (exceptionalSupports : Finset (Finset G))
      then (twoTorsion : Finset G).card else 0 := by
  by_cases hExc : S ∈ (exceptionalSupports : Finset (Finset G))
  · rw [if_pos hExc]
    exact nontranslatedNeighbours_card_exceptional S hExc
  · rw [if_neg hExc]
    exact nontranslatedNeighbours_card_ordinary S hS hExc

/-- Total number of directed incidences (source triple, nontranslated
partner) is the number of exceptional supports times h. -/
theorem directed_nontranslation_degree_sum :
    (∑ S ∈ (tripleSupports : Finset (Finset G)),
        (nontranslatedNeighbours S).card) =
      (exceptionalSupports : Finset (Finset G)).card *
        (twoTorsion : Finset G).card := by
  have hSubset :
      (exceptionalSupports : Finset (Finset G)) ⊆ tripleSupports := by
    intro S hExc
    exact (mem_tripleSupports S).mpr
      ((mem_exceptionalSupports_card S).mp hExc).1
  have hFilter :
      (tripleSupports : Finset (Finset G)).filter
        (fun S => S ∈ (exceptionalSupports : Finset (Finset G))) =
          exceptionalSupports := by
    ext S
    constructor
    · intro h
      exact (Finset.mem_filter.mp h).2
    · intro h
      exact Finset.mem_filter.mpr ⟨hSubset h, h⟩
  calc
    (∑ S ∈ (tripleSupports : Finset (Finset G)),
        (nontranslatedNeighbours S).card) =
      ∑ S ∈ (tripleSupports : Finset (Finset G)),
        (if S ∈ (exceptionalSupports : Finset (Finset G))
          then (twoTorsion : Finset G).card else 0) := by
            apply Finset.sum_congr rfl
            intro S hS
            exact nontranslatedNeighbours_card_ite S
              ((mem_tripleSupports S).mp hS)
    _ = ∑ S ∈ ((tripleSupports : Finset (Finset G)).filter
          (fun S => S ∈ (exceptionalSupports : Finset (Finset G)))),
          (twoTorsion : Finset G).card := by
            rw [Finset.sum_filter]
    _ = (exceptionalSupports : Finset (Finset G)).card *
          (twoTorsion : Finset G).card := by
            rw [hFilter]
            simp

/-- Fully numerical DIRECTED partner incidence count.
Obtaining an unordered-pair count requires a separate symmetry/2-to-1 lemma. -/
theorem directed_nontranslation_degree_sum_numeric :
    (∑ S ∈ (tripleSupports : Finset (Finset G)),
        (nontranslatedNeighbours S).card) =
      (Fintype.card G * ((twoTorsion : Finset G).card - 1) *
        ((threeTorsion : Finset G).card - 1)) *
        (twoTorsion : Finset G).card := by
  rw [directed_nontranslation_degree_sum, exceptionalSupports_card]

end Couret.STROBO2TORS

#print axioms Couret.STROBO2TORS.mem_nontranslatedNeighbours
#print axioms Couret.STROBO2TORS.nontranslatedNeighbours_card
#print axioms Couret.STROBO2TORS.nontranslatedNeighbours_card_exceptional
#print axioms Couret.STROBO2TORS.nontranslatedNeighbours_card_ordinary
#print axioms Couret.STROBO2TORS.directed_nontranslation_degree_sum
#print axioms Couret.STROBO2TORS.directed_nontranslation_degree_sum_numeric
