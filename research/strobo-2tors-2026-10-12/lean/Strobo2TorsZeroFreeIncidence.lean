import Strobo2TorsDeltaCount
import Mathlib.Algebra.BigOperators.Group.Finset.Piecewise

set_option autoImplicit false

open scoped BigOperators symmDiff

/-!
Translation and incidence transfer from unrestricted collision pairs to pairs
whose two supports avoid zero. The incidence argument does not assume that
translation acts freely. This module adds to the historical certificates.
-/

namespace Couret.STROBO2TORS

variable {G : Type*} [AddCommGroup G] [DecidableEq G]

@[simp] theorem translateSupport_zero (S : Finset G) : translateSupport S 0 = S := by
  simp [translateSupport]

@[simp] theorem translateSupport_neg_cancel (S : Finset G) (a : G) :
    translateSupport (translateSupport S a) (-a) = S := by
  rw [translateSupport_add, add_neg_cancel, translateSupport_zero]

@[simp] theorem add_mem_translateSupport_iff (S : Finset G) (x a : G) :
    x + a ∈ translateSupport S a ↔ x ∈ S := by
  simp [translateSupport]

theorem translateSupport_union (S T : Finset G) (a : G) :
    translateSupport (S ∪ T) a = translateSupport S a ∪ translateSupport T a := by
  exact Finset.image_union _ _

theorem translateSupport_symmDiff (S T : Finset G) (a : G) :
    translateSupport (S ∆ T) a = translateSupport S a ∆ translateSupport T a := by
  exact Finset.image_symmDiff S T (fun _ _ h => add_right_cancel h)

theorem translateSupport_symmDiff_card (S T : Finset G) (a : G) :
    (translateSupport S a ∆ translateSupport T a).card = (S ∆ T).card := by
  rw [← translateSupport_symmDiff, translateSupport_card]

theorem translateSupport_injective (a : G) :
    Function.Injective (fun S : Finset G => translateSupport S a) := by
  intro S T h
  have := congrArg (fun U => translateSupport U (-a)) h
  simpa using this

/-- Arbitrary translations shift the argument of the ordered square by 2a. -/
theorem orderedSquare_translate_covariant (S : Finset G) (a z : G) :
    orderedSquare (translateSupport S a) (z + (a + a)) = orderedSquare S z := by
  unfold orderedSquare translateSupport
  rw [Finset.sum_image (fun _ _ _ _ h => add_right_cancel h)]
  apply Finset.sum_congr rfl
  intro x hx
  rw [Finset.sum_image (fun _ _ _ _ h => add_right_cancel h)]
  apply Finset.sum_congr rfl
  intro y hy
  have hsum : (x + a) + (y + a) = (x + y) + (a + a) := by abel
  simp only [hsum, add_left_inj]

theorem orderedSquare_eq_translate_iff (S T : Finset G) (a : G) :
    (∀ z : G, orderedSquare (translateSupport S a) z =
      orderedSquare (translateSupport T a) z) ↔
    (∀ z : G, orderedSquare S z = orderedSquare T z) := by
  constructor
  · intro h z
    simpa only [orderedSquare_translate_covariant] using h (z + (a + a))
  · intro h z
    have hz : (z - (a + a)) + (a + a) = z := by abel
    simpa only [hz, orderedSquare_translate_covariant] using
      (orderedSquare_translate_covariant S a (z - (a + a))).trans
        ((h (z - (a + a))).trans
          (orderedSquare_translate_covariant T a (z - (a + a))).symm)

section Finite

variable [Fintype G]

/-- The incidence identity for a finite translation-invariant collection.
Only bijectivity of each shift is needed; stabilizers are unrestricted. -/
theorem translation_incidence_card
    {X : Type*} [Fintype X] [DecidableEq X]
    (carrier : X → Finset G) (shift : G → X ≃ X)
    (hshift : ∀ a x, carrier (shift a x) = translateSupport (carrier x) a)
    (u : ℕ) (hcard : ∀ x, (carrier x).card = u) :
    Fintype.card G * ((Finset.univ : Finset X).filter
      (fun x => 0 ∉ carrier x)).card =
      (Fintype.card G - u) * Fintype.card X := by
  classical
  have hpoint (a : G) :
      ((Finset.univ : Finset X).filter (fun x => a ∉ carrier x)).card =
        ((Finset.univ : Finset X).filter (fun x => 0 ∉ carrier x)).card := by
    apply Finset.card_bijective (shift a).symm (shift a).symm.bijective
    intro x
    simp only [Finset.mem_filter, Finset.mem_univ, true_and]
    have hx := hshift a ((shift a).symm x)
    rw [(shift a).apply_symm_apply] at hx
    rw [hx]
    simpa only [zero_add] using
      (not_congr (add_mem_translateSupport_iff (carrier ((shift a).symm x)) 0 a))
  have hrow (x : X) :
      ((Finset.univ : Finset G).filter (fun a => a ∉ carrier x)).card =
        Fintype.card G - u := by
    have heq : (Finset.univ : Finset G).filter (fun a => a ∈ carrier x) =
        carrier x := by ext a; simp
    have h := Finset.card_filter_add_card_filter_not
      (s := (Finset.univ : Finset G)) (fun a => a ∈ carrier x)
    rw [heq, hcard x, Finset.card_univ] at h
    omega
  calc
    _ = ∑ a : G, ((Finset.univ : Finset X).filter
        (fun x => a ∉ carrier x)).card := by simp [hpoint]
    _ = ∑ x : X, ((Finset.univ : Finset G).filter
        (fun a => a ∉ carrier x)).card := by
      simp only [Finset.card_filter]
      exact Finset.sum_comm
    _ = _ := by simp [hrow, Nat.mul_comm]

/-- The same double-counting identity without subtraction or a size hypothesis. -/
theorem translation_incidence_card_balance
    {X : Type*} [Fintype X] [DecidableEq X]
    (carrier : X → Finset G) (shift : G → X ≃ X)
    (hshift : ∀ a x, carrier (shift a x) = translateSupport (carrier x) a)
    (u : ℕ) (hcard : ∀ x, (carrier x).card = u) :
    Fintype.card G * ((Finset.univ : Finset X).filter
      (fun x => 0 ∉ carrier x)).card + u * Fintype.card X =
      Fintype.card G * Fintype.card X := by
  classical
  have h := translation_incidence_card carrier shift hshift u hcard
  rw [h]
  cases isEmpty_or_nonempty X with
  | inl hx =>
      letI := hx
      simp
  | inr hx =>
      obtain ⟨x⟩ := hx
      have hu : u ≤ Fintype.card G := by
        rw [← hcard x]
        exact Finset.card_le_univ _
      rw [← Nat.add_mul, Nat.sub_add_cancel hu]

/-- Induced restriction to zero-free vertices, keeping the ambient vertex type. -/
def zeroFreeGraph (Γ : SimpleGraph (Finset G)) : SimpleGraph (Finset G) where
  Adj S T := Γ.Adj S T ∧ 0 ∉ S ∧ 0 ∉ T
  symm := by
    intro S T h
    exact ⟨h.1.symm, h.2.2, h.2.1⟩
  loopless := by
    constructor
    intro S h
    exact Γ.irrefl h.1

noncomputable instance zeroFreeGraph_decidableRel (Γ : SimpleGraph (Finset G)) :
    DecidableRel (zeroFreeGraph Γ).Adj := Classical.decRel _

/-- Simultaneous translation gives an equivalence of oriented edges. -/
def dartTranslateEquiv (Γ : SimpleGraph (Finset G))
    (htrans : ∀ S T a, Γ.Adj (translateSupport S a) (translateSupport T a) ↔
      Γ.Adj S T) (a : G) : Γ.Dart ≃ Γ.Dart where
  toFun d := ⟨(translateSupport d.fst a, translateSupport d.snd a),
    (htrans d.fst d.snd a).mpr d.adj⟩
  invFun d := ⟨(translateSupport d.fst (-a), translateSupport d.snd (-a)),
    (htrans d.fst d.snd (-a)).mpr d.adj⟩
  left_inv d := by
    apply SimpleGraph.Dart.ext
    apply Prod.ext <;> simp
  right_inv d := by
    apply SimpleGraph.Dart.ext
    apply Prod.ext <;> simp [translateSupport_add]

theorem zeroFreeGraph_dart_filter_card (Γ : SimpleGraph (Finset G))
    [DecidableRel Γ.Adj] :
    ((Finset.univ : Finset Γ.Dart).filter
      (fun d => 0 ∉ d.fst ∪ d.snd)).card =
      Fintype.card (zeroFreeGraph Γ).Dart := by
  classical
  rw [← Finset.card_univ]
  let f : ∀ d ∈ ((Finset.univ : Finset Γ.Dart).filter
      (fun d => 0 ∉ d.fst ∪ d.snd)), (zeroFreeGraph Γ).Dart := by
    intro d hd
    have hzero : 0 ∉ d.fst ∧ 0 ∉ d.snd := by
      simpa only [Finset.mem_union, not_or] using (Finset.mem_filter.mp hd).2
    exact ⟨d.toProd, d.adj, hzero⟩
  apply Finset.card_bij f
  · intro d hd
    exact Finset.mem_univ _
  · intro d hd e he h
    exact SimpleGraph.Dart.ext _ _
      (congrArg (fun x : (zeroFreeGraph Γ).Dart => x.toProd) h)
  · intro d hd
    refine ⟨⟨d.toProd, d.adj.1⟩, ?_, ?_⟩
    · simp only [Finset.mem_filter, Finset.mem_univ, true_and,
        Finset.mem_union, not_or]
      exact d.adj.2
    · apply SimpleGraph.Dart.ext
      rfl

/-- Universal zero-free transfer for any translation-invariant edge family.
Natural subtraction makes the statement valid even when no such edge fits in G. -/
theorem zeroFreeGraph_mul_edges (Γ : SimpleGraph (Finset G))
    [DecidableRel Γ.Adj] (u : ℕ)
    (htrans : ∀ S T a, Γ.Adj (translateSupport S a) (translateSupport T a) ↔
      Γ.Adj S T)
    (hunion : ∀ S T, Γ.Adj S T → (S ∪ T).card = u) :
    Fintype.card G * (zeroFreeGraph Γ).edgeFinset.card =
      (Fintype.card G - u) * Γ.edgeFinset.card := by
  classical
  have h := translation_incidence_card
    (fun d : Γ.Dart => d.fst ∪ d.snd) (dartTranslateEquiv Γ htrans)
    (by intro a d; exact (translateSupport_union d.fst d.snd a).symm)
    u (fun d => hunion d.fst d.snd d.adj)
  rw [zeroFreeGraph_dart_filter_card, (zeroFreeGraph Γ).dart_card_eq_twice_card_edges,
    Γ.dart_card_eq_twice_card_edges] at h
  apply Nat.eq_of_mul_eq_mul_left (by decide : 0 < 2)
  calc
    2 * (Fintype.card G * (zeroFreeGraph Γ).edgeFinset.card) =
        Fintype.card G * (2 * (zeroFreeGraph Γ).edgeFinset.card) := by ring
    _ = (Fintype.card G - u) * (2 * Γ.edgeFinset.card) := h
    _ = 2 * ((Fintype.card G - u) * Γ.edgeFinset.card) := by ring

/-- The balanced incidence equation is valid for every finite abelian group. -/
theorem zeroFreeGraph_balance_edges (Γ : SimpleGraph (Finset G))
    [DecidableRel Γ.Adj] (u : ℕ)
    (htrans : ∀ S T a, Γ.Adj (translateSupport S a) (translateSupport T a) ↔
      Γ.Adj S T)
    (hunion : ∀ S T, Γ.Adj S T → (S ∪ T).card = u) :
    Fintype.card G * (zeroFreeGraph Γ).edgeFinset.card + u * Γ.edgeFinset.card =
      Fintype.card G * Γ.edgeFinset.card := by
  classical
  have h := translation_incidence_card_balance
    (fun d : Γ.Dart => d.fst ∪ d.snd) (dartTranslateEquiv Γ htrans)
    (by intro a d; exact (translateSupport_union d.fst d.snd a).symm)
    u (fun d => hunion d.fst d.snd d.adj)
  rw [zeroFreeGraph_dart_filter_card, (zeroFreeGraph Γ).dart_card_eq_twice_card_edges,
    Γ.dart_card_eq_twice_card_edges] at h
  apply Nat.eq_of_mul_eq_mul_left (by decide : 0 < 2)
  calc
    2 * (Fintype.card G * (zeroFreeGraph Γ).edgeFinset.card +
        u * Γ.edgeFinset.card) =
      Fintype.card G * (2 * (zeroFreeGraph Γ).edgeFinset.card) +
        u * (2 * Γ.edgeFinset.card) := by ring
    _ = Fintype.card G * (2 * Γ.edgeFinset.card) := h
    _ = 2 * (Fintype.card G * Γ.edgeFinset.card) := by ring

omit [AddCommGroup G] in
/-- If the prescribed union does not fit in the group, the entire family is empty. -/
theorem graph_eq_bot_of_union_card_gt (Γ : SimpleGraph (Finset G)) (u : ℕ)
    (hunion : ∀ S T, Γ.Adj S T → (S ∪ T).card = u)
    (hn : Fintype.card G < u) : Γ = ⊥ := by
  ext S T
  change Γ.Adj S T ↔ False
  constructor
  · intro h
    have hc := Finset.card_le_univ (S ∪ T)
    rw [hunion S T h] at hc
    omega
  · exact False.elim

/-- If the union exhausts the group, no edge survives avoidance of zero. -/
theorem zeroFreeGraph_edges_eq_zero_of_card_le (Γ : SimpleGraph (Finset G))
    [DecidableRel Γ.Adj] (u : ℕ)
    (htrans : ∀ S T a, Γ.Adj (translateSupport S a) (translateSupport T a) ↔
      Γ.Adj S T)
    (hunion : ∀ S T, Γ.Adj S T → (S ∪ T).card = u)
    (hn : Fintype.card G ≤ u) : (zeroFreeGraph Γ).edgeFinset.card = 0 := by
  have h := zeroFreeGraph_mul_edges Γ u htrans hunion
  rw [Nat.sub_eq_zero_of_le hn, Nat.zero_mul] at h
  exact (Nat.mul_eq_zero.mp h).resolve_left (Fintype.card_ne_zero)

/-- Exact divisibility of the numerator in the universal incidence quotient. -/
theorem zeroFreeGraph_transfer_dvd (Γ : SimpleGraph (Finset G))
    [DecidableRel Γ.Adj] (u : ℕ)
    (htrans : ∀ S T a, Γ.Adj (translateSupport S a) (translateSupport T a) ↔
      Γ.Adj S T)
    (hunion : ∀ S T, Γ.Adj S T → (S ∪ T).card = u) :
    Fintype.card G ∣ (Fintype.card G - u) * Γ.edgeFinset.card := by
  exact ⟨(zeroFreeGraph Γ).edgeFinset.card,
    (zeroFreeGraph_mul_edges Γ u htrans hunion).symm⟩

/-- The universal quotient is exact, including its natural-number boundary cases. -/
theorem zeroFreeGraph_edges_numeric (Γ : SimpleGraph (Finset G))
    [DecidableRel Γ.Adj] (u : ℕ)
    (htrans : ∀ S T a, Γ.Adj (translateSupport S a) (translateSupport T a) ↔
      Γ.Adj S T)
    (hunion : ∀ S T, Γ.Adj S T → (S ∪ T).card = u) :
    (zeroFreeGraph Γ).edgeFinset.card =
      (Fintype.card G - u) * Γ.edgeFinset.card / Fintype.card G := by
  rw [← zeroFreeGraph_mul_edges Γ u htrans hunion]
  simp

#print axioms Couret.STROBO2TORS.translateSupport_zero
#print axioms Couret.STROBO2TORS.translateSupport_neg_cancel
#print axioms Couret.STROBO2TORS.add_mem_translateSupport_iff
#print axioms Couret.STROBO2TORS.translateSupport_union
#print axioms Couret.STROBO2TORS.translateSupport_symmDiff
#print axioms Couret.STROBO2TORS.translateSupport_symmDiff_card
#print axioms Couret.STROBO2TORS.translateSupport_injective
#print axioms Couret.STROBO2TORS.orderedSquare_translate_covariant
#print axioms Couret.STROBO2TORS.orderedSquare_eq_translate_iff
#print axioms Couret.STROBO2TORS.translation_incidence_card
#print axioms Couret.STROBO2TORS.translation_incidence_card_balance
#print axioms Couret.STROBO2TORS.zeroFreeGraph_dart_filter_card
#print axioms Couret.STROBO2TORS.zeroFreeGraph_mul_edges
#print axioms Couret.STROBO2TORS.zeroFreeGraph_balance_edges
#print axioms Couret.STROBO2TORS.graph_eq_bot_of_union_card_gt
#print axioms Couret.STROBO2TORS.zeroFreeGraph_edges_eq_zero_of_card_le
#print axioms Couret.STROBO2TORS.zeroFreeGraph_transfer_dvd
#print axioms Couret.STROBO2TORS.zeroFreeGraph_edges_numeric

end Finite

end Couret.STROBO2TORS
