import RecohCandidateDecoder

set_option autoImplicit false

/-!
Finite combinatorial bounds for the RECOH candidate decoder.

Each possible three-element edge set E contributes either no half-sum or a
coset of the actual subgroup G[2].  The general counting bound is the number
of edge sets times |G[2]|.  The numerical factor twenty is used only when
the observed square has support of cardinality at most six; this hypothesis
is proved for the ordered square of an actual three-element support.

These are cardinality statements about the finite candidate specification.
They do not by themselves assert a running-time bound for its implementation.
-/

namespace Couret.STROBO2TORS

open scoped BigOperators

variable {G : Type*} [AddCommGroup G] [DecidableEq G] [Fintype G]

/-- The finite fibre of doubling over `t`. -/
def recohDoubleFibre (t : G) : Finset G :=
  Finset.univ.filter (fun sigma => sigma + sigma = t)

@[simp]
theorem recoh_mem_double_fibre (t sigma : G) :
    sigma ∈ recohDoubleFibre t ↔ sigma + sigma = t := by
  simp [recohDoubleFibre]

/-- A nonempty doubling fibre is a translate of its zero fibre, hence a
coset of `G[2]`.  The chosen base point is any solution of the half-sum. -/
theorem recoh_double_fibre_eq_translate (t sigma : G)
    (hsigma : sigma + sigma = t) :
    recohDoubleFibre t = translateSupport (recohDoubleFibre (0 : G)) sigma := by
  ext x
  constructor
  · intro hx
    rw [translateSupport, Finset.mem_image]
    refine ⟨x - sigma, ?_, sub_add_cancel x sigma⟩
    apply (recoh_mem_double_fibre _ _).mpr
    exact (double_eq_iff_two_torsion sigma x).mp
      (hsigma.trans ((recoh_mem_double_fibre _ _).mp hx).symm)
  · intro hx
    rw [translateSupport, Finset.mem_image] at hx
    obtain ⟨u, hu, rfl⟩ := hx
    apply (recoh_mem_double_fibre _ _).mpr
    calc
      (u + sigma) + (u + sigma) = (sigma + sigma) + (u + u) := by abel
      _ = t := by rw [hsigma, (recoh_mem_double_fibre _ _).mp hu, add_zero]

/-- The zero fibre counts the actual two-torsion subgroup used in the
optimal-bank statements. -/
theorem recoh_double_fibre_zero_card :
    (recohDoubleFibre (0 : G)).card =
      Nat.card (recohTorsionSubgroup (G := G) 2) := by
  classical
  letI : Fintype (recohTorsionSubgroup (G := G) 2) := Fintype.ofFinite _
  rw [Nat.card_eq_fintype_card]
  change (Finset.univ.filter (fun x : G => x + x = 0)).card =
    Fintype.card {x : G // x ∈ recohTorsionSubgroup (G := G) 2}
  rw [Fintype.card_subtype]
  simp only [recoh_mem_torsion_subgroup, two_nsmul]

/-- Every nonempty doubling fibre has exactly `|G[2]|` elements. -/
theorem recoh_double_fibre_card_of_nonempty (t : G)
    (ht : (recohDoubleFibre t).Nonempty) :
    (recohDoubleFibre t).card =
      Nat.card (recohTorsionSubgroup (G := G) 2) := by
  obtain ⟨sigma, hsigma⟩ := ht
  rw [recoh_double_fibre_eq_translate t sigma
    ((recoh_mem_double_fibre _ _).mp hsigma), translateSupport_card,
    recoh_double_fibre_zero_card]

/-- A doubling fibre has cardinality either zero or `|G[2]|`. -/
theorem recoh_double_fibre_card_zero_or_torsion (t : G) :
    (recohDoubleFibre t).card = 0 ∨
      (recohDoubleFibre t).card =
        Nat.card (recohTorsionSubgroup (G := G) 2) := by
  by_cases ht : (recohDoubleFibre t).Nonempty
  · exact Or.inr (recoh_double_fibre_card_of_nonempty t ht)
  · exact Or.inl (Finset.card_eq_zero.mpr (Finset.not_nonempty_iff_eq_empty.mp ht))

/-- The bound applies to every doubling fibre, including empty ones. -/
theorem recoh_double_fibre_card_le (t : G) :
    (recohDoubleFibre t).card ≤
      Nat.card (recohTorsionSubgroup (G := G) 2) := by
  rcases recoh_double_fibre_card_zero_or_torsion t with hzero | hcard
  · rw [hzero]
    exact Nat.zero_le _
  · exact hcard.le

omit [AddCommGroup G] [DecidableEq G] in
/-- At most twenty edge sets are considered when the observed square has
support of cardinality at most six.  No validity of `R` is otherwise assumed. -/
theorem recoh_edge_sets_card_le_twenty (R : G → ℕ)
    (hR : (recohSquareSupport R).card ≤ 6) :
    ((recohSquareSupport R).powersetCard 3).card ≤ 20 := by
  rw [Finset.card_powersetCard]
  calc
    (recohSquareSupport R).card.choose 3 ≤ Nat.choose 6 3 :=
      Nat.choose_le_choose 3 hR
    _ = 20 := by decide

/-- Exact fibrewise count of the edge-set/half-sum pairs. -/
theorem recoh_candidate_pairs_card_eq_sum (R : G → ℕ) :
    (recohCandidatePairs R).card =
      ∑ E ∈ (recohSquareSupport R).powersetCard 3,
        (recohDoubleFibre (E.sum id)).card := by
  simp only [recohCandidatePairs, recohDoubleFibre, Finset.card_eq_sum_ones,
    Finset.sum_filter, Finset.sum_product]

/-- General bound for arbitrary observations: each edge set contributes
at most `|G[2]|` candidate pairs. -/
theorem recoh_candidate_pairs_card_le_edges_mul_torsion (R : G → ℕ) :
    (recohCandidatePairs R).card ≤
      ((recohSquareSupport R).powersetCard 3).card *
        Nat.card (recohTorsionSubgroup (G := G) 2) := by
  rw [recoh_candidate_pairs_card_eq_sum]
  calc
    (∑ E ∈ (recohSquareSupport R).powersetCard 3,
        (recohDoubleFibre (E.sum id)).card) ≤
      ∑ _E ∈ (recohSquareSupport R).powersetCard 3,
        Nat.card (recohTorsionSubgroup (G := G) 2) := by
          exact Finset.sum_le_sum (fun E _ => recoh_double_fibre_card_le (E.sum id))
    _ = ((recohSquareSupport R).powersetCard 3).card *
        Nat.card (recohTorsionSubgroup (G := G) 2) := by simp

/-- With at most six observed square positions there are at most
`20 * |G[2]|` candidate pairs. -/
theorem recoh_candidate_pairs_card_le_twenty_mul_torsion (R : G → ℕ)
    (hR : (recohSquareSupport R).card ≤ 6) :
    (recohCandidatePairs R).card ≤
      20 * Nat.card (recohTorsionSubgroup (G := G) 2) := by
  exact (recoh_candidate_pairs_card_le_edges_mul_torsion R).trans
    (Nat.mul_le_mul_right _ (recoh_edge_sets_card_le_twenty R hR))

/-- Passing from candidate pairs to their decoded supports cannot increase
cardinality; the same numerical bound therefore holds for candidates. -/
theorem recoh_candidates_card_le_twenty_mul_torsion (R : G → ℕ)
    (hR : (recohSquareSupport R).card ≤ 6) :
    (recohCandidates R).card ≤
      20 * Nat.card (recohTorsionSubgroup (G := G) 2) := by
  exact Finset.card_image_le.trans
    (recoh_candidate_pairs_card_le_twenty_mul_torsion R hR)

/-- The numerical bound applies unconditionally to candidate pairs formed
from the ordered square of a genuine three-element support. -/
theorem recoh_ordered_square_candidate_pairs_card_le (S : Finset G)
    (hS : S.card = 3) :
    (recohCandidatePairs (orderedSquare S)).card ≤
      20 * Nat.card (recohTorsionSubgroup (G := G) 2) := by
  exact recoh_candidate_pairs_card_le_twenty_mul_torsion (orderedSquare S)
    (recoh_square_support_card_le_six S hS)

/-- The corresponding bound for decoded supports of a genuine observation. -/
theorem recoh_ordered_square_candidates_card_le (S : Finset G)
    (hS : S.card = 3) :
    (recohCandidates (orderedSquare S)).card ≤
      20 * Nat.card (recohTorsionSubgroup (G := G) 2) := by
  exact recoh_candidates_card_le_twenty_mul_torsion (orderedSquare S)
    (recoh_square_support_card_le_six S hS)

end Couret.STROBO2TORS

#print axioms Couret.STROBO2TORS.recoh_mem_double_fibre
#print axioms Couret.STROBO2TORS.recoh_double_fibre_eq_translate
#print axioms Couret.STROBO2TORS.recoh_double_fibre_zero_card
#print axioms Couret.STROBO2TORS.recoh_double_fibre_card_of_nonempty
#print axioms Couret.STROBO2TORS.recoh_double_fibre_card_zero_or_torsion
#print axioms Couret.STROBO2TORS.recoh_double_fibre_card_le
#print axioms Couret.STROBO2TORS.recoh_edge_sets_card_le_twenty
#print axioms Couret.STROBO2TORS.recoh_candidate_pairs_card_eq_sum
#print axioms Couret.STROBO2TORS.recoh_candidate_pairs_card_le_edges_mul_torsion
#print axioms Couret.STROBO2TORS.recoh_candidate_pairs_card_le_twenty_mul_torsion
#print axioms Couret.STROBO2TORS.recoh_candidates_card_le_twenty_mul_torsion
#print axioms Couret.STROBO2TORS.recoh_ordered_square_candidate_pairs_card_le
#print axioms Couret.STROBO2TORS.recoh_ordered_square_candidates_card_le
