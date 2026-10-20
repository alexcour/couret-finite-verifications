import Strobo2TorsZeroFreeIncidence

set_option autoImplicit false

open scoped BigOperators symmDiff

/-!
Exact unordered collision counts by symmetric difference after excluding zero
from both three-element supports. The proof transfers each translation-stable
branch by incidence counting. All subtractions and divisions are in Nat.
Historical unrestricted counts remain unchanged.
-/

namespace Couret.STROBO2TORS

private theorem zeroFreeDelta_cancel_formula (n u d c z p : ℕ)
    (hn : 0 < n) (hcount : d * c = n * p)
    (htransfer : n * z = (n - u) * c) :
    d * z = (n - u) * p := by
  apply Nat.eq_of_mul_eq_mul_left hn
  calc
    n * (d * z) = d * (n * z) := by ring
    _ = d * ((n - u) * c) := by rw [htransfer]
    _ = (n - u) * (d * c) := by ring
    _ = (n - u) * (n * p) := by rw [hcount]
    _ = n * ((n - u) * p) := by ring

/-- The size of the union is determined by the symmetric difference. -/
theorem triple_union_card_of_symmDiff {α : Type*} [DecidableEq α]
    (S T : Finset α) (hS : S.card = 3) (hT : T.card = 3)
    (k : ℕ) (hk : (S ∆ T).card = k) :
    (S ∪ T).card = 3 + k / 2 := by
  have hbalance := triple_symmDiff_card_balance S T hS hT
  have hunion := Finset.card_union_add_card_inter S T
  omega

variable {G : Type*} [AddCommGroup G] [DecidableEq G]

theorem translateSupport_eq_iff (S T : Finset G) (a : G) :
    translateSupport S a = translateSupport T a ↔ S = T :=
  (translateSupport_injective a).eq_iff

/-- A common arbitrary translation preserves the ordinary partner relation. -/
theorem ordinaryPartner_translate_iff (S T : Finset G) (a : G) :
    OrdinaryPartner (translateSupport S a) (translateSupport T a) ↔
      OrdinaryPartner S T := by
  constructor
  · rintro ⟨u, hu, heq⟩
    refine ⟨u, hu, (translateSupport_injective a) ?_⟩
    change translateSupport T a = translateSupport (translateSupport S u) a
    rw [heq, translateSupport_add, translateSupport_add, add_comm a u]
  · rintro ⟨u, hu, heq⟩
    refine ⟨u, hu, ?_⟩
    rw [heq, translateSupport_add, translateSupport_add, add_comm a u]

/-- Exclusion of every translation is preserved under a common translation. -/
theorem anyTranslation_translate_iff (S T : Finset G) (a : G) :
    (∃ v : G, translateSupport T a = translateSupport (translateSupport S a) v) ↔
      (∃ v : G, T = translateSupport S v) := by
  constructor
  · rintro ⟨v, heq⟩
    refine ⟨v, (translateSupport_injective a) ?_⟩
    change translateSupport T a = translateSupport (translateSupport S v) a
    rw [heq, translateSupport_add, translateSupport_add, add_comm a v]
  · rintro ⟨v, heq⟩
    refine ⟨v, ?_⟩
    rw [heq, translateSupport_add, translateSupport_add, add_comm a v]

section Finite

variable [Fintype G]

theorem squareDeltaGraph_translate_iff (S T : Finset G) (a : G) (k : ℕ) :
    (squareDeltaGraph (G := G) k).Adj (translateSupport S a) (translateSupport T a) ↔
      (squareDeltaGraph (G := G) k).Adj S T := by
  simp only [squareDeltaGraph_adj_iff, translateSupport_card, ne_eq,
    translateSupport_eq_iff, orderedSquare_eq_translate_iff,
    translateSupport_symmDiff_card]

theorem ordinaryDeltaGraph_translate_iff (S T : Finset G) (a : G) (k : ℕ) :
    (ordinaryDeltaGraph (G := G) k).Adj (translateSupport S a) (translateSupport T a) ↔
      (ordinaryDeltaGraph (G := G) k).Adj S T := by
  simp only [ordinaryDeltaGraph, ordinaryGraph, translateSupport_card, ne_eq,
    translateSupport_eq_iff, ordinaryPartner_translate_iff,
    translateSupport_symmDiff_card]

theorem nontranslationDeltaGraph_translate_iff
    (S T : Finset G) (a : G) (k : ℕ) :
    (nontranslationDeltaGraph (G := G) k).Adj
        (translateSupport S a) (translateSupport T a) ↔
      (nontranslationDeltaGraph (G := G) k).Adj S T := by
  simp only [nontranslationDeltaGraph_adj_iff, translateSupport_card,
    orderedSquare_eq_translate_iff, anyTranslation_translate_iff,
    translateSupport_symmDiff_card]

/-- All unordered zero-free equal-square pairs, with labelled group elements. -/
noncomputable def zeroFreeSquareDeltaPairCount (k : ℕ) : ℕ :=
  (zeroFreeGraph (squareDeltaGraph (G := G) k)).edgeFinset.card

noncomputable def zeroFreeOrdinaryDeltaPairCount (k : ℕ) : ℕ :=
  (zeroFreeGraph (ordinaryDeltaGraph (G := G) k)).edgeFinset.card

noncomputable def zeroFreeNontranslationDeltaPairCount (k : ℕ) : ℕ :=
  (zeroFreeGraph (nontranslationDeltaGraph (G := G) k)).edgeFinset.card

/-- The zero-free graph has exactly the intended adjacency. -/
theorem zeroFreeSquareDeltaGraph_adj_iff (S T : Finset G) (k : ℕ) :
    (zeroFreeGraph (squareDeltaGraph (G := G) k)).Adj S T ↔
      S.card = 3 ∧ T.card = 3 ∧ S ≠ T ∧
        (∀ z : G, orderedSquare S z = orderedSquare T z) ∧
        (S ∆ T).card = k ∧ 0 ∉ S ∧ 0 ∉ T := by
  change ((squareDeltaGraph (G := G) k).Adj S T ∧ 0 ∉ S ∧ 0 ∉ T) ↔ _
  rw [squareDeltaGraph_adj_iff]
  tauto

/-- Uniform incidence transfer, including empty small-group cases. -/
theorem zeroFreeSquareDeltaPairCount_transfer (k : ℕ) :
    Fintype.card G * zeroFreeSquareDeltaPairCount (G := G) k =
      (Fintype.card G - (3 + k / 2)) * squareDeltaPairCount (G := G) k := by
  apply zeroFreeGraph_mul_edges (squareDeltaGraph (G := G) k) (3 + k / 2)
  · exact fun S T a => squareDeltaGraph_translate_iff S T a k
  · intro S T h
    obtain ⟨hS, hT, _, _, hk⟩ := (squareDeltaGraph_adj_iff S T k).mp h
    exact triple_union_card_of_symmDiff S T hS hT k hk

/-- A subtraction-free version of the universal incidence identity. -/
theorem zeroFreeSquareDeltaPairCount_balance (k : ℕ) :
    Fintype.card G * zeroFreeSquareDeltaPairCount (G := G) k +
        (3 + k / 2) * squareDeltaPairCount (G := G) k =
      Fintype.card G * squareDeltaPairCount (G := G) k := by
  apply zeroFreeGraph_balance_edges (squareDeltaGraph (G := G) k) (3 + k / 2)
  · exact fun S T a => squareDeltaGraph_translate_iff S T a k
  · intro S T h
    obtain ⟨hS, hT, _, _, hk⟩ := (squareDeltaGraph_adj_iff S T k).mp h
    exact triple_union_card_of_symmDiff S T hS hT k hk

theorem zeroFreeOrdinaryDeltaPairCount_transfer (k : ℕ) :
    Fintype.card G * zeroFreeOrdinaryDeltaPairCount (G := G) k =
      (Fintype.card G - (3 + k / 2)) *
        (ordinaryDeltaGraph (G := G) k).edgeFinset.card := by
  apply zeroFreeGraph_mul_edges (ordinaryDeltaGraph (G := G) k) (3 + k / 2)
  · exact fun S T a => ordinaryDeltaGraph_translate_iff S T a k
  · rintro S T ⟨⟨hS, hT, _, _⟩, hk⟩
    exact triple_union_card_of_symmDiff S T hS hT k hk

theorem zeroFreeNontranslationDeltaPairCount_transfer (k : ℕ) :
    Fintype.card G * zeroFreeNontranslationDeltaPairCount (G := G) k =
      (Fintype.card G - (3 + k / 2)) *
        (nontranslationDeltaGraph (G := G) k).edgeFinset.card := by
  apply zeroFreeGraph_mul_edges (nontranslationDeltaGraph (G := G) k) (3 + k / 2)
  · exact fun S T a => nontranslationDeltaGraph_translate_iff S T a k
  · intro S T h
    obtain ⟨hS, hT, _, _, hk⟩ := (nontranslationDeltaGraph_adj_iff S T k).mp h
    exact triple_union_card_of_symmDiff S T hS hT k hk

/-- Excluding zero preserves the disjoint ordinary/exceptional partition. -/
theorem zeroFreeSquareDeltaPairCount_partition (k : ℕ) :
    zeroFreeSquareDeltaPairCount (G := G) k =
      zeroFreeOrdinaryDeltaPairCount (G := G) k +
        zeroFreeNontranslationDeltaPairCount (G := G) k := by
  apply Nat.eq_of_mul_eq_mul_left (Fintype.card_pos (α := G))
  rw [Nat.mul_add, zeroFreeSquareDeltaPairCount_transfer,
    zeroFreeOrdinaryDeltaPairCount_transfer,
    zeroFreeNontranslationDeltaPairCount_transfer]
  unfold squareDeltaPairCount
  rw [squareDeltaGraph_edges_partition, Nat.mul_add]

/-- There is no zero-free pair when its union would occupy the entire group. -/
theorem zeroFreeSquareDeltaPairCount_eq_zero_of_card_le_union (k : ℕ)
    (hn : Fintype.card G ≤ 3 + k / 2) :
    zeroFreeSquareDeltaPairCount (G := G) k = 0 := by
  apply Nat.eq_of_mul_eq_mul_left (Fintype.card_pos (α := G))
  simpa [Nat.sub_eq_zero_of_le hn] using
    zeroFreeSquareDeltaPairCount_transfer (G := G) k

/-- Below the union-size threshold even the unrestricted family is empty. -/
theorem squareDeltaPairCount_eq_zero_of_card_lt_union (k : ℕ)
    (hn : Fintype.card G < 3 + k / 2) :
    squareDeltaPairCount (G := G) k = 0 := by
  have hg : squareDeltaGraph (G := G) k = ⊥ := by
    apply graph_eq_bot_of_union_card_gt _ (3 + k / 2) _ hn
    intro S T h
    obtain ⟨hS, hT, _, _, hk⟩ := (squareDeltaGraph_adj_iff S T k).mp h
    exact triple_union_card_of_symmDiff S T hS hT k hk
  unfold squareDeltaPairCount
  rw [SimpleGraph.edgeFinset_eq_empty.mpr hg]
  rfl

theorem zeroFreeNontranslationDeltaPairCount_two_eq_zero :
    zeroFreeNontranslationDeltaPairCount (G := G) 2 = 0 := by
  have ht := zeroFreeNontranslationDeltaPairCount_transfer (G := G) 2
  rw [SimpleGraph.edgeFinset_eq_empty.mpr nontranslationDeltaGraph_two_eq_bot] at ht
  apply Nat.eq_of_mul_eq_mul_left (Fintype.card_pos (α := G))
  simpa using ht

theorem zeroFreeOrdinaryDeltaPairCount_four_eq_zero :
    zeroFreeOrdinaryDeltaPairCount (G := G) 4 = 0 := by
  have ht := zeroFreeOrdinaryDeltaPairCount_transfer (G := G) 4
  rw [SimpleGraph.edgeFinset_eq_empty.mpr ordinaryDeltaGraph_four_eq_bot] at ht
  apply Nat.eq_of_mul_eq_mul_left (Fintype.card_pos (α := G))
  simpa using ht

/-- Weighted identity proving exact division by four. -/
theorem zeroFreeSquareDeltaPairCount_two_four_mul :
    4 * zeroFreeSquareDeltaPairCount (G := G) 2 =
      (Fintype.card G - 4) * (Fintype.card G - 2) *
        ((twoTorsion : Finset G).card - 1) := by
  have ht := zeroFreeSquareDeltaPairCount_transfer (G := G) 2
  norm_num at ht
  have hc := squareDeltaGraph_two_four_mul_edges (G := G)
  change 4 * squareDeltaPairCount (G := G) 2 = _ at hc
  have hc' : 4 * squareDeltaPairCount (G := G) 2 =
      Fintype.card G * ((Fintype.card G - 2) *
        ((twoTorsion : Finset G).card - 1)) := by simpa [Nat.mul_assoc] using hc
  simpa [Nat.mul_assoc] using zeroFreeDelta_cancel_formula
    (Fintype.card G) 4 4 _ _ _ Fintype.card_pos hc' ht

/-- Weighted identity proving exact division by two. -/
theorem zeroFreeSquareDeltaPairCount_four_two_mul :
    2 * zeroFreeSquareDeltaPairCount (G := G) 4 =
      (Fintype.card G - 5) * ((twoTorsion : Finset G).card - 1) *
        ((threeTorsion : Finset G).card - 1) := by
  have ht := zeroFreeSquareDeltaPairCount_transfer (G := G) 4
  norm_num at ht
  have hc := squareDeltaGraph_four_twice_edges_numeric (G := G)
  change 2 * squareDeltaPairCount (G := G) 4 = _ at hc
  have hc' : 2 * squareDeltaPairCount (G := G) 4 =
      Fintype.card G * (((twoTorsion : Finset G).card - 1) *
        ((threeTorsion : Finset G).card - 1)) := by simpa [Nat.mul_assoc] using hc
  simpa [Nat.mul_assoc] using zeroFreeDelta_cancel_formula
    (Fintype.card G) 5 2 _ _ _ Fintype.card_pos hc' ht

/-- The ordinary disjoint contribution, with exact division by twelve. -/
theorem zeroFreeOrdinaryDeltaPairCount_six_twelve_mul :
    12 * zeroFreeOrdinaryDeltaPairCount (G := G) 6 =
      (Fintype.card G - 6) * (Fintype.card G - 2) * (Fintype.card G - 4) *
        ((twoTorsion : Finset G).card - 1) := by
  have ht := zeroFreeOrdinaryDeltaPairCount_transfer (G := G) 6
  norm_num at ht
  have hc := ordinaryDeltaGraph_six_twelve_mul_edges (G := G)
  have hc' : 12 * (ordinaryDeltaGraph (G := G) 6).edgeFinset.card =
      Fintype.card G * ((Fintype.card G - 2) * (Fintype.card G - 4) *
        ((twoTorsion : Finset G).card - 1)) := by simpa [Nat.mul_assoc] using hc
  simpa [Nat.mul_assoc] using zeroFreeDelta_cancel_formula
    (Fintype.card G) 6 12 _ _ _ Fintype.card_pos hc' ht

/-- The exceptional disjoint contribution, with exact division by two. -/
theorem zeroFreeNontranslationDeltaPairCount_six_two_mul :
    2 * zeroFreeNontranslationDeltaPairCount (G := G) 6 =
      (Fintype.card G - 6) * ((twoTorsion : Finset G).card - 1) ^ 2 *
        ((threeTorsion : Finset G).card - 1) := by
  have ht := zeroFreeNontranslationDeltaPairCount_transfer (G := G) 6
  norm_num at ht
  have hc := nontranslationDeltaGraph_six_twice_edges_numeric (G := G)
  have hc' : 2 * (nontranslationDeltaGraph (G := G) 6).edgeFinset.card =
      Fintype.card G * (((twoTorsion : Finset G).card - 1) ^ 2 *
        ((threeTorsion : Finset G).card - 1)) := by simpa [Nat.mul_assoc] using hc
  simpa [Nat.mul_assoc] using zeroFreeDelta_cancel_formula
    (Fintype.card G) 6 2 _ _ _ Fintype.card_pos hc' ht

theorem zeroFreeSquareDeltaPairCount_two :
    zeroFreeSquareDeltaPairCount (G := G) 2 =
      (Fintype.card G - 4) * (Fintype.card G - 2) *
        ((twoTorsion : Finset G).card - 1) / 4 := by
  have h := zeroFreeSquareDeltaPairCount_two_four_mul (G := G)
  omega

theorem zeroFreeSquareDeltaPairCount_four :
    zeroFreeSquareDeltaPairCount (G := G) 4 =
      (Fintype.card G - 5) * ((twoTorsion : Finset G).card - 1) *
        ((threeTorsion : Finset G).card - 1) / 2 := by
  have h := zeroFreeSquareDeltaPairCount_four_two_mul (G := G)
  omega

theorem zeroFreeOrdinaryDeltaPairCount_two :
    zeroFreeOrdinaryDeltaPairCount (G := G) 2 =
      (Fintype.card G - 4) * (Fintype.card G - 2) *
        ((twoTorsion : Finset G).card - 1) / 4 := by
  have hp := zeroFreeSquareDeltaPairCount_partition (G := G) 2
  rw [zeroFreeNontranslationDeltaPairCount_two_eq_zero, Nat.add_zero] at hp
  rw [← hp, zeroFreeSquareDeltaPairCount_two]

theorem zeroFreeNontranslationDeltaPairCount_four :
    zeroFreeNontranslationDeltaPairCount (G := G) 4 =
      (Fintype.card G - 5) * ((twoTorsion : Finset G).card - 1) *
        ((threeTorsion : Finset G).card - 1) / 2 := by
  have hp := zeroFreeSquareDeltaPairCount_partition (G := G) 4
  rw [zeroFreeOrdinaryDeltaPairCount_four_eq_zero, Nat.zero_add] at hp
  rw [← hp, zeroFreeSquareDeltaPairCount_four]

theorem zeroFreeOrdinaryDeltaPairCount_six :
    zeroFreeOrdinaryDeltaPairCount (G := G) 6 =
      (Fintype.card G - 6) * (Fintype.card G - 2) * (Fintype.card G - 4) *
        ((twoTorsion : Finset G).card - 1) / 12 := by
  have h := zeroFreeOrdinaryDeltaPairCount_six_twelve_mul (G := G)
  omega

theorem zeroFreeNontranslationDeltaPairCount_six :
    zeroFreeNontranslationDeltaPairCount (G := G) 6 =
      (Fintype.card G - 6) * ((twoTorsion : Finset G).card - 1) ^ 2 *
        ((threeTorsion : Finset G).card - 1) / 2 := by
  have h := zeroFreeNontranslationDeltaPairCount_six_two_mul (G := G)
  omega

theorem zeroFreeSquareDeltaPairCount_six :
    zeroFreeSquareDeltaPairCount (G := G) 6 =
      (Fintype.card G - 6) * (Fintype.card G - 2) * (Fintype.card G - 4) *
        ((twoTorsion : Finset G).card - 1) / 12 +
      (Fintype.card G - 6) * ((twoTorsion : Finset G).card - 1) ^ 2 *
        ((threeTorsion : Finset G).card - 1) / 2 := by
  rw [zeroFreeSquareDeltaPairCount_partition,
    zeroFreeOrdinaryDeltaPairCount_six, zeroFreeNontranslationDeltaPairCount_six]

theorem zeroFreeSquareDeltaPairCount_six_twelve_mul :
    12 * zeroFreeSquareDeltaPairCount (G := G) 6 =
      (Fintype.card G - 6) * (Fintype.card G - 2) * (Fintype.card G - 4) *
        ((twoTorsion : Finset G).card - 1) +
      6 * ((Fintype.card G - 6) * ((twoTorsion : Finset G).card - 1) ^ 2 *
        ((threeTorsion : Finset G).card - 1)) := by
  rw [zeroFreeSquareDeltaPairCount_partition, Nat.mul_add,
    zeroFreeOrdinaryDeltaPairCount_six_twelve_mul]
  congr 1
  calc
    _ = 6 * (2 * zeroFreeNontranslationDeltaPairCount (G := G) 6) := by ring
    _ = _ := by rw [zeroFreeNontranslationDeltaPairCount_six_two_mul]

/-- Complete numerical subdivision with zero excluded from both supports. -/
theorem zeroFreeSquareDeltaPairCount_numeric :
    let n := Fintype.card G
    let h := (twoTorsion : Finset G).card
    let t := (threeTorsion : Finset G).card
    zeroFreeSquareDeltaPairCount (G := G) 2 = (n - 4) * (n - 2) * (h - 1) / 4 ∧
    zeroFreeSquareDeltaPairCount (G := G) 4 = (n - 5) * (h - 1) * (t - 1) / 2 ∧
    zeroFreeSquareDeltaPairCount (G := G) 6 =
      (n - 6) * (n - 2) * (n - 4) * (h - 1) / 12 +
        (n - 6) * (h - 1) ^ 2 * (t - 1) / 2 := by
  exact ⟨zeroFreeSquareDeltaPairCount_two, zeroFreeSquareDeltaPairCount_four,
    zeroFreeSquareDeltaPairCount_six⟩

/-- Each separate numerator is divisible by its stated denominator. -/
theorem zeroFreeSquareDeltaPairCount_divisibility :
    let n := Fintype.card G
    let h := (twoTorsion : Finset G).card
    let t := (threeTorsion : Finset G).card
    4 ∣ (n - 4) * (n - 2) * (h - 1) ∧
    2 ∣ (n - 5) * (h - 1) * (t - 1) ∧
    12 ∣ (n - 6) * (n - 2) * (n - 4) * (h - 1) ∧
    2 ∣ (n - 6) * (h - 1) ^ 2 * (t - 1) := by
  refine ⟨⟨_, (zeroFreeSquareDeltaPairCount_two_four_mul (G := G)).symm⟩,
    ⟨_, (zeroFreeSquareDeltaPairCount_four_two_mul (G := G)).symm⟩,
    ⟨_, (zeroFreeOrdinaryDeltaPairCount_six_twelve_mul (G := G)).symm⟩,
    ⟨_, (zeroFreeNontranslationDeltaPairCount_six_two_mul (G := G)).symm⟩⟩

end Finite

end Couret.STROBO2TORS

#print axioms Couret.STROBO2TORS.triple_union_card_of_symmDiff
#print axioms Couret.STROBO2TORS.translateSupport_eq_iff
#print axioms Couret.STROBO2TORS.ordinaryPartner_translate_iff
#print axioms Couret.STROBO2TORS.anyTranslation_translate_iff
#print axioms Couret.STROBO2TORS.squareDeltaGraph_translate_iff
#print axioms Couret.STROBO2TORS.ordinaryDeltaGraph_translate_iff
#print axioms Couret.STROBO2TORS.nontranslationDeltaGraph_translate_iff
#print axioms Couret.STROBO2TORS.zeroFreeSquareDeltaGraph_adj_iff
#print axioms Couret.STROBO2TORS.zeroFreeSquareDeltaPairCount_transfer
#print axioms Couret.STROBO2TORS.zeroFreeSquareDeltaPairCount_balance
#print axioms Couret.STROBO2TORS.zeroFreeOrdinaryDeltaPairCount_transfer
#print axioms Couret.STROBO2TORS.zeroFreeNontranslationDeltaPairCount_transfer
#print axioms Couret.STROBO2TORS.zeroFreeSquareDeltaPairCount_partition
#print axioms Couret.STROBO2TORS.zeroFreeSquareDeltaPairCount_eq_zero_of_card_le_union
#print axioms Couret.STROBO2TORS.squareDeltaPairCount_eq_zero_of_card_lt_union
#print axioms Couret.STROBO2TORS.zeroFreeNontranslationDeltaPairCount_two_eq_zero
#print axioms Couret.STROBO2TORS.zeroFreeOrdinaryDeltaPairCount_four_eq_zero
#print axioms Couret.STROBO2TORS.zeroFreeSquareDeltaPairCount_two_four_mul
#print axioms Couret.STROBO2TORS.zeroFreeSquareDeltaPairCount_four_two_mul
#print axioms Couret.STROBO2TORS.zeroFreeOrdinaryDeltaPairCount_six_twelve_mul
#print axioms Couret.STROBO2TORS.zeroFreeNontranslationDeltaPairCount_six_two_mul
#print axioms Couret.STROBO2TORS.zeroFreeSquareDeltaPairCount_two
#print axioms Couret.STROBO2TORS.zeroFreeSquareDeltaPairCount_four
#print axioms Couret.STROBO2TORS.zeroFreeOrdinaryDeltaPairCount_two
#print axioms Couret.STROBO2TORS.zeroFreeNontranslationDeltaPairCount_four
#print axioms Couret.STROBO2TORS.zeroFreeOrdinaryDeltaPairCount_six
#print axioms Couret.STROBO2TORS.zeroFreeNontranslationDeltaPairCount_six
#print axioms Couret.STROBO2TORS.zeroFreeSquareDeltaPairCount_six
#print axioms Couret.STROBO2TORS.zeroFreeSquareDeltaPairCount_six_twelve_mul
#print axioms Couret.STROBO2TORS.zeroFreeSquareDeltaPairCount_numeric
#print axioms Couret.STROBO2TORS.zeroFreeSquareDeltaPairCount_divisibility
