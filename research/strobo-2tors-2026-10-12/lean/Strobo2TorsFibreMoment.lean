import Strobo2TorsZeroFreeCompatibility
import Strobo2TorsClosedHistogram
import Strobo2TorsHistogram
import Mathlib.Data.Sym.Card

set_option autoImplicit false

open scoped BigOperators symmDiff

/-!
M002.4: a combinatorial, rather than numerical, bridge between the second
binomial moment of the nonempty zero-free square fibres and the three
symmetric-difference collision edge counts.

The common object is an ordered pair of distinct supports in a single
restricted fibre. Each undirected graph edge has exactly two orientations.
No translation orbit is divided out, and no division of any numerical
closed-form count is used.
-/

namespace Couret.STROBO2TORS

variable {G : Type*} [AddCommGroup G] [DecidableEq G] [Fintype G]

/-- Ordered pairs of distinct zero-free three-element supports with exactly
the same labelled ordered convolution square. -/
noncomputable def zeroFreeCollisionDarts : Finset (Finset G × Finset G) :=
  (Finset.univ : Finset (Finset G × Finset G)).filter
    (fun p => p.1.card = 3 ∧ p.2.card = 3 ∧ p.1 ≠ p.2 ∧
      (∀ z : G, orderedSquare p.1 z = orderedSquare p.2 z) ∧
      0 ∉ p.1 ∧ 0 ∉ p.2)

/-- The restricted square fibre of a zero-free triple belongs to the
existing collection of nonempty, distinct restricted fibres. -/
private theorem zeroFreeFibre_of_support (S : Finset G)
    (hS : S.card = 3) (h0 : 0 ∉ S) :
    withoutZero (squareFibre S) ∈
      (zeroFreeFullFibres : Finset (Finset (Finset G))) := by
  change withoutZero (squareFibre S) ∈
    (nonemptyFullFibres (G := G)).image (withoutZero (G := G))
  apply Finset.mem_image.mpr
  refine ⟨squareFibre S, ?_, rfl⟩
  apply Finset.mem_filter.mpr
  constructor
  · apply Finset.mem_image.mpr
    exact ⟨S, (mem_tripleSupports S).mpr hS, rfl⟩
  · exact ⟨S, Finset.mem_filter.mpr
      ⟨(mem_squareFibre S S).mpr ⟨hS, fun _ => rfl⟩, h0⟩⟩

/-- A support in a surviving restricted fibre uniquely determines the
whole restricted fibre, even in small groups. -/
private theorem zeroFreeFibre_eq_of_mem
    (F : Finset (Finset G))
    (hF : F ∈ (zeroFreeFullFibres : Finset (Finset (Finset G))))
    (S : Finset G) (hSF : S ∈ F) :
    S.card = 3 ∧ 0 ∉ S ∧ F = withoutZero (squareFibre S) := by
  change F ∈ (nonemptyFullFibres (G := G)).image (withoutZero (G := G)) at hF
  obtain ⟨K, hK, hKF⟩ := Finset.mem_image.mp hF
  obtain ⟨hKall, _⟩ := Finset.mem_filter.mp hK
  have hSrest : S ∈ withoutZero K := by
    rw [hKF]
    exact hSF
  have hSK : S ∈ K := (Finset.mem_filter.mp hSrest).1
  have hS0 : 0 ∉ S := (Finset.mem_filter.mp hSrest).2
  obtain ⟨U, hU, hUK⟩ := Finset.mem_image.mp hKall
  have hSU : S ∈ squareFibre U := by
    rw [hUK]
    exact hSK
  have hS3 : S.card = 3 := ((mem_squareFibre U S).mp hSU).1
  have hKS : squareFibre S = K :=
    allSquareFibres_squareFibre_member K hKall S hSK
  refine ⟨hS3, hS0, ?_⟩
  simpa only [hKS] using hKF.symm

/-- Exact membership equivalence: two supports lie in one existing
restricted fibre iff they have the required square and avoid zero. -/
private theorem commonZeroFreeFibre_iff (S T : Finset G) :
    (∃ F ∈ (zeroFreeFullFibres : Finset (Finset (Finset G))),
      S ∈ F ∧ T ∈ F) ↔
    S.card = 3 ∧ T.card = 3 ∧ 0 ∉ S ∧ 0 ∉ T ∧
      (∀ z : G, orderedSquare S z = orderedSquare T z) := by
  constructor
  · rintro ⟨F, hF, hSF, hTF⟩
    obtain ⟨hS3, hS0, hFS⟩ := zeroFreeFibre_eq_of_mem F hF S hSF
    obtain ⟨hT3, hT0, _⟩ := zeroFreeFibre_eq_of_mem F hF T hTF
    have hTrest : T ∈ withoutZero (squareFibre S) := by
      rw [← hFS]
      exact hTF
    have hsq := ((mem_squareFibre S T).mp (Finset.mem_filter.mp hTrest).1).2
    exact ⟨hS3, hT3, hS0, hT0, hsq⟩
  · rintro ⟨hS3, hT3, hS0, hT0, hsq⟩
    refine ⟨withoutZero (squareFibre S), zeroFreeFibre_of_support S hS3 hS0,
      ?_, ?_⟩
    · exact Finset.mem_filter.mpr
        ⟨(mem_squareFibre S S).mpr ⟨hS3, fun _ => rfl⟩, hS0⟩
    · exact Finset.mem_filter.mpr
        ⟨(mem_squareFibre S T).mpr ⟨hT3, hsq⟩, hT0⟩

/-- The fibre-indexed oriented pairs are exactly the collision darts.
This is an equality of finsets, not just their cardinalities. -/
theorem zeroFreeCollisionDarts_eq_fibre_biUnion :
    (zeroFreeCollisionDarts (G := G)) =
      (zeroFreeFullFibres : Finset (Finset (Finset G))).biUnion
        (fun F => F.offDiag) := by
  classical
  ext p
  simp only [zeroFreeCollisionDarts, Finset.mem_filter, Finset.mem_univ,
    true_and, Finset.mem_biUnion, Finset.mem_offDiag]
  constructor
  · rintro ⟨hS3, hT3, hST, hsq, hS0, hT0⟩
    obtain ⟨F, hF, hSF, hTF⟩ :=
      (commonZeroFreeFibre_iff p.1 p.2).mpr ⟨hS3, hT3, hS0, hT0, hsq⟩
    exact ⟨F, hF, hSF, hTF, hST⟩
  · rintro ⟨F, hF, hSF, hTF, hST⟩
    obtain ⟨hS3, hT3, hS0, hT0, hsq⟩ :=
      (commonZeroFreeFibre_iff p.1 p.2).mp ⟨F, hF, hSF, hTF⟩
    exact ⟨hS3, hT3, hST, hsq, hS0, hT0⟩

/-- No ordered pair belongs to two distinct restricted fibres. -/
private theorem zeroFreeFibre_offDiag_pairwiseDisjoint :
    ((zeroFreeFullFibres : Finset (Finset (Finset G))) : Set _).PairwiseDisjoint
      (fun F : Finset (Finset G) => F.offDiag) := by
  intro F hF K hK hne
  apply Finset.disjoint_left.mpr
  intro p hpF hpK
  have hSF : p.1 ∈ F := (Finset.mem_offDiag.mp hpF).1
  have hSK : p.1 ∈ K := (Finset.mem_offDiag.mp hpK).1
  have hFE := (zeroFreeFibre_eq_of_mem F hF p.1 hSF).2.2
  have hKE := (zeroFreeFibre_eq_of_mem K hK p.1 hSK).2.2
  exact hne (hFE.trans hKE.symm)

/-- Each restricted fibre contributes twice its number of unordered
two-subsets, including the zero contribution of fibres of size 0 or 1. -/
private theorem offDiag_card_eq_twice_choose
    (F : Finset (Finset G)) :
    F.offDiag.card = 2 * F.card.choose 2 := by
  calc
    F.offDiag.card =
        2 * (F.offDiag.image (Function.uncurry Sym2.mk)).card :=
      (Sym2.two_mul_card_image_offDiag F).symm
    _ = 2 * F.card.choose 2 :=
      congrArg (fun n : ℕ => 2 * n) (Sym2.card_image_offDiag F)

/-- The second binomial moment counts exactly half the common-fibre
collision darts. No numerical STROBO formula is involved. -/
theorem zeroFreeCollisionDarts_card_eq_twice_moment :
    (zeroFreeCollisionDarts (G := G)).card =
      2 * ∑ F ∈ (zeroFreeFullFibres : Finset (Finset (Finset G))),
        F.card.choose 2 := by
  classical
  calc
    (zeroFreeCollisionDarts (G := G)).card =
        ((zeroFreeFullFibres : Finset (Finset (Finset G))).biUnion
          (fun F => F.offDiag)).card :=
      congrArg Finset.card zeroFreeCollisionDarts_eq_fibre_biUnion
    _ = ∑ F ∈ (zeroFreeFullFibres : Finset (Finset (Finset G))),
        F.offDiag.card :=
      Finset.card_biUnion zeroFreeFibre_offDiag_pairwiseDisjoint
    _ = ∑ F ∈ (zeroFreeFullFibres : Finset (Finset (Finset G))),
        2 * F.card.choose 2 := by
      apply Finset.sum_congr rfl
      intro F _
      exact offDiag_card_eq_twice_choose F
    _ = 2 * ∑ F ∈ (zeroFreeFullFibres : Finset (Finset (Finset G))),
        F.card.choose 2 := by
      rw [Finset.mul_sum]

/-- At each prescribed symmetric difference, the existing graph's
unordered edges are exactly half of the directly defined oriented
collision darts. -/
theorem zeroFreeSquareDeltaPairCount_twice_eq_collisionDarts (k : ℕ) :
    2 * zeroFreeSquareDeltaPairCount (G := G) k =
      ((zeroFreeCollisionDarts (G := G)).filter
        (fun p => (p.1 ∆ p.2).card = k)).card := by
  classical
  unfold zeroFreeSquareDeltaPairCount
  rw [SimpleGraph.two_mul_card_edgeFinset]
  congr 1
  ext ⟨S, T⟩
  simp only [Finset.mem_filter, zeroFreeCollisionDarts, Finset.mem_univ,
    true_and, zeroFreeSquareDeltaGraph_adj_iff]
  tauto

/-- A true disjoint partition of all oriented collisions into the only
possible symmetric-difference cardinalities. -/
theorem zeroFreeCollisionDarts_delta_partition :
    (zeroFreeCollisionDarts (G := G)).card =
      ((zeroFreeCollisionDarts (G := G)).filter
        (fun p => (p.1 ∆ p.2).card = 2)).card +
      ((zeroFreeCollisionDarts (G := G)).filter
        (fun p => (p.1 ∆ p.2).card = 4)).card +
      ((zeroFreeCollisionDarts (G := G)).filter
        (fun p => (p.1 ∆ p.2).card = 6)).card := by
  classical
  let D := zeroFreeCollisionDarts (G := G)
  let A := D.filter (fun p => (p.1 ∆ p.2).card = 2)
  let B := D.filter (fun p => (p.1 ∆ p.2).card = 4)
  let C := D.filter (fun p => (p.1 ∆ p.2).card = 6)
  have hab : Disjoint A B := by
    apply Finset.disjoint_left.mpr
    intro p hpA hpB
    have ha := (Finset.mem_filter.mp hpA).2
    have hb := (Finset.mem_filter.mp hpB).2
    omega
  have hac : Disjoint A C := by
    apply Finset.disjoint_left.mpr
    intro p hpA hpC
    have ha := (Finset.mem_filter.mp hpA).2
    have hc := (Finset.mem_filter.mp hpC).2
    omega
  have hbc : Disjoint B C := by
    apply Finset.disjoint_left.mpr
    intro p hpB hpC
    have hb := (Finset.mem_filter.mp hpB).2
    have hc := (Finset.mem_filter.mp hpC).2
    omega
  have habc : Disjoint (A ∪ B) C := by
    apply Finset.disjoint_left.mpr
    intro p hpAB hpC
    rcases Finset.mem_union.mp hpAB with hpA | hpB
    · exact (Finset.disjoint_left.mp hac) hpA hpC
    · exact (Finset.disjoint_left.mp hbc) hpB hpC
  have hunion : (A ∪ B) ∪ C = D := by
    ext p
    simp only [Finset.mem_union]
    constructor
    · rintro ((hpA | hpB) | hpC)
      · exact (Finset.mem_filter.mp hpA).1
      · exact (Finset.mem_filter.mp hpB).1
      · exact (Finset.mem_filter.mp hpC).1
    · intro hp
      have hd : p.1.card = 3 ∧ p.2.card = 3 ∧ p.1 ≠ p.2 ∧
          (∀ z : G, orderedSquare p.1 z = orderedSquare p.2 z) ∧
          0 ∉ p.1 ∧ 0 ∉ p.2 := (Finset.mem_filter.mp hp).2
      rcases triple_symmDiff_card_cases p.1 p.2 hd.1 hd.2.1 hd.2.2.1 with
        h2 | h4 | h6
      · exact Or.inl (Or.inl (Finset.mem_filter.mpr ⟨hp, h2⟩))
      · exact Or.inl (Or.inr (Finset.mem_filter.mpr ⟨hp, h4⟩))
      · exact Or.inr (Finset.mem_filter.mpr ⟨hp, h6⟩)
  change D.card = A.card + B.card + C.card
  calc
    D.card = ((A ∪ B) ∪ C).card := congrArg Finset.card hunion.symm
    _ = A.card + B.card + C.card := by
      rw [Finset.card_union_of_disjoint habc,
        Finset.card_union_of_disjoint hab]

/-- M002.4: the general fibre-pair second moment, for every finite abelian
group, is the sum of the three actual zero-free unordered collision-edge
counts. This follows from exact incidence correspondence and a disjoint
delta partition, not from comparing closed count formulas. -/
theorem zeroFreeFullFibres_secondMoment_eq_deltaCounts :
    (∑ F ∈ (zeroFreeFullFibres : Finset (Finset (Finset G))),
      F.card.choose 2) =
    zeroFreeSquareDeltaPairCount (G := G) 2 +
      zeroFreeSquareDeltaPairCount (G := G) 4 +
      zeroFreeSquareDeltaPairCount (G := G) 6 := by
  have hm := zeroFreeCollisionDarts_card_eq_twice_moment (G := G)
  have hp := zeroFreeCollisionDarts_delta_partition (G := G)
  have h2 := zeroFreeSquareDeltaPairCount_twice_eq_collisionDarts (G := G) 2
  have h4 := zeroFreeSquareDeltaPairCount_twice_eq_collisionDarts (G := G) 4
  have h6 := zeroFreeSquareDeltaPairCount_twice_eq_collisionDarts (G := G) 6
  omega

/-- The moment vanishes precisely when every delta edge family is empty.
In particular, vanishing branches never require division or cancellation
by a purportedly positive count. -/
theorem zeroFreeFullFibres_secondMoment_eq_zero_iff :
    (∑ F ∈ (zeroFreeFullFibres : Finset (Finset (Finset G))),
      F.card.choose 2) = 0 ↔
    zeroFreeSquareDeltaPairCount (G := G) 2 = 0 ∧
    zeroFreeSquareDeltaPairCount (G := G) 4 = 0 ∧
    zeroFreeSquareDeltaPairCount (G := G) 6 = 0 := by
  rw [zeroFreeFullFibres_secondMoment_eq_deltaCounts]
  omega

/-- The small ambient-cardinality case: at most four elements means
that no two distinct zero-free triples can collide. -/
theorem zeroFreeFullFibres_secondMoment_zero_of_card_le_four
    (hn : Fintype.card G ≤ 4) :
    (∑ F ∈ (zeroFreeFullFibres : Finset (Finset (Finset G))),
      F.card.choose 2) = 0 := by
  rw [zeroFreeFullFibres_secondMoment_eq_deltaCounts,
    zeroFreeSquareDeltaPairCount_eq_zero_of_card_le_union (G := G) 2 (by omega),
    zeroFreeSquareDeltaPairCount_eq_zero_of_card_le_union (G := G) 4 (by omega),
    zeroFreeSquareDeltaPairCount_eq_zero_of_card_le_union (G := G) 6 (by omega)]

/-- Explicitly includes an empty collection of surviving fibres. -/
theorem zeroFreeFullFibres_secondMoment_zero_of_empty
    (h : (zeroFreeFullFibres : Finset (Finset (Finset G))) = ∅) :
    (∑ F ∈ (zeroFreeFullFibres : Finset (Finset (Finset G))),
      F.card.choose 2) = 0 := by
  simp [h]

end Couret.STROBO2TORS

#print axioms Couret.STROBO2TORS.zeroFreeCollisionDarts_eq_fibre_biUnion
#print axioms Couret.STROBO2TORS.zeroFreeCollisionDarts_card_eq_twice_moment
#print axioms Couret.STROBO2TORS.zeroFreeSquareDeltaPairCount_twice_eq_collisionDarts
#print axioms Couret.STROBO2TORS.zeroFreeCollisionDarts_delta_partition
#print axioms Couret.STROBO2TORS.zeroFreeFullFibres_secondMoment_eq_deltaCounts
#print axioms Couret.STROBO2TORS.zeroFreeFullFibres_secondMoment_eq_zero_iff
#print axioms Couret.STROBO2TORS.zeroFreeFullFibres_secondMoment_zero_of_card_le_four
#print axioms Couret.STROBO2TORS.zeroFreeFullFibres_secondMoment_zero_of_empty
