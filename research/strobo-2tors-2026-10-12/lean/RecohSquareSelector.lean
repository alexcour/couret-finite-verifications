import RecohCyclicPreparedDecoder
import RecohTernaryFibreSelector

set_option autoImplicit false

/-!
Selection from the labelled ordered square using at most twenty explicit
representatives. All runtime checks use finite supports, cyclic coordinates
and integer cyclotomic coefficients. No ambient-group search occurs.
-/

namespace Couret.STROBO2TORS

variable {G : Type*} [AddCommGroup G] [DecidableEq G]

/-- Decide two-torsion translation using differences of points already in
the two supports. For triples there are at most nine such differences. -/
def recohTorsionOrbitCheck (B C : Finset G) : Bool :=
  decide (∃ x ∈ B, ∃ y ∈ C,
    (y - x) + (y - x) = 0 ∧ C = translateSupport B (y - x))

theorem recoh_torsion_orbit_check_iff (B C : Finset G) (hB : B.Nonempty) :
    recohTorsionOrbitCheck B C = true ↔ OrdinaryPartner B C := by
  simp only [recohTorsionOrbitCheck, decide_eq_true_eq]
  constructor
  · rintro ⟨x, _, y, _, hu, hC⟩
    exact ⟨y - x, hu, hC⟩
  · rintro ⟨u, hu, hC⟩
    obtain ⟨x, hx⟩ := hB
    have hxu : x + u ∈ C := by
      rw [hC]
      exact Finset.mem_image.mpr ⟨x, hx, rfl⟩
    refine ⟨x, hx, x + u, hxu, ?_, ?_⟩
    · simpa only [add_sub_cancel_left] using hu
    · simpa only [add_sub_cancel_left] using hC

theorem recoh_ordinary_partner_refl (B : Finset G) : OrdinaryPartner B B := by
  exact ⟨0, by simp, by simp [translateSupport]⟩

theorem recoh_ordinary_partner_symm {B C : Finset G}
    (h : OrdinaryPartner B C) : OrdinaryPartner C B := by
  obtain ⟨u, hu, rfl⟩ := h
  exact ⟨u, hu, (translateSupport_twice B u hu).symm⟩

theorem recoh_ordinary_partner_trans {A B C : Finset G}
    (hAB : OrdinaryPartner A B) (hBC : OrdinaryPartner B C) : OrdinaryPartner A C := by
  obtain ⟨u, hu, rfl⟩ := hAB
  obtain ⟨v, hv, hC⟩ := hBC
  refine ⟨u + v, ?_, ?_⟩
  · calc
      (u + v) + (u + v) = (u + u) + (v + v) := by abel
      _ = 0 := by simp [hu, hv]
  · exact hC.trans (translateSupport_add A u v)

/-- Chosen half-sums followed by the exact square check; the resulting
set contains representatives of every compatible two-torsion orbit. -/
def recohSquareRepresentatives (U : Finset G) (R : G → ℕ)
    (half : G → Option G) : Finset (Finset G) :=
  (recohPreparedEdgeSets U half (fun B => recohSparseSquareCheck U B R)).image
    (recohEdgeRepresentative half)

theorem recoh_square_representatives_sound (U : Finset G) (R : G → ℕ)
    (half : G → Option G) (hR : ∀ z, R z ≠ 0 → z ∈ U)
    (B : Finset G) (hB : B ∈ recohSquareRepresentatives U R half) :
    B.card = 3 ∧ orderedSquare B = R := by
  obtain ⟨E, hE, rfl⟩ := Finset.mem_image.mp hB
  obtain ⟨hE, hsquare⟩ := Finset.mem_filter.mp hE
  have hcard := ((recoh_mem_feasible_edge_sets U E half).mp hE).2.1
  exact ⟨(recoh_edge_representative_card half E).trans hcard,
    (recoh_sparse_square_check_iff U _ R hR).mp hsquare⟩

theorem recoh_square_representatives_card_le_twenty
    (U : Finset G) (R : G → ℕ) (half : G → Option G) (hU : U.card ≤ 6) :
    (recohSquareRepresentatives U R half).card ≤ 20 := by
  exact Finset.card_image_le.trans
    (recoh_prepared_edge_sets_card_le_twenty U half _ hU)

/-- Test whether every pair of retained representatives lies in one orbit.
Defined before any ambient finiteness instance, so bounded quantification
is implemented directly over the supplied finite set. -/
def recohOneOrbitCheck (reps : Finset (Finset G)) : Bool :=
  decide (∀ B ∈ reps, ∀ C ∈ reps, recohTorsionOrbitCheck B C = true)

theorem recoh_one_orbit_check_iff (reps : Finset (Finset G))
    (hnonempty : ∀ B ∈ reps, B.Nonempty) :
    recohOneOrbitCheck reps = true ↔
      ∀ B ∈ reps, ∀ C ∈ reps, OrdinaryPartner B C := by
  simp only [recohOneOrbitCheck, decide_eq_true_eq]
  constructor
  · intro h B hB C hC
    exact (recoh_torsion_orbit_check_iff B C (hnonempty B hB)).mp (h B hB C hC)
  · intro h B hB C hC
    exact (recoh_torsion_orbit_check_iff B C (hnonempty B hB)).mpr (h B hB C hC)

/-- A bounded representative-pair test, without an ambient finiteness
instance. The equality backend is supplied as an executable Boolean. -/
def recohOrbitSeparatorCheck (reps : Finset (Finset G))
    (equal : Finset G → Finset G → Bool) : Bool :=
  decide (∀ B ∈ reps, ∀ C ∈ reps,
    recohTorsionOrbitCheck B C = true ∨ ¬ equal B C = true)

variable [Fintype G]

/-- Every triple with the observed square belongs to an orbit represented
by the sparse construction. This proof does not enumerate that orbit. -/
theorem recoh_square_representatives_complete
    (U : Finset G) (R : G → ℕ) (half : G → Option G)
    (hhalf : RecohHalfSolverSpec half) (hR : ∀ z, R z ≠ 0 → z ∈ U)
    (S : Finset G) (hS : S.card = 3) (hsquare : orderedSquare S = R) :
    ∃ B ∈ recohSquareRepresentatives U R half, OrdinaryPartner B S := by
  obtain ⟨E, sigma, hE, hcard, hsigma, hdecode⟩ :=
    (recoh_mem_candidates_iff (orderedSquare S) S).mp (recoh_candidates_complete S hS)
  obtain ⟨sigma0, hsigma0⟩ := hhalf.2 (E.sum id) ⟨sigma, hsigma⟩
  have hdouble0 : sigma0 + sigma0 = E.sum id := hhalf.1 _ _ hsigma0
  have hu : (sigma - sigma0) + (sigma - sigma0) = 0 :=
    (double_eq_iff_two_torsion sigma0 sigma).mp (hdouble0.trans hsigma.symm)
  have hshift : translateSupport (recohEdgeDecode E sigma0) (sigma - sigma0) = S :=
    (recoh_edge_decode_change_half E sigma sigma0).symm.trans hdecode
  have hrep : recohEdgeRepresentative half E = recohEdgeDecode E sigma0 := by
    simp only [recohEdgeRepresentative, hsigma0, Option.getD_some]
  have hEs : E ⊆ U := by
    intro z hz
    have hp := (recoh_mem_square_support (orderedSquare S) z).mp (hE hz)
    exact hR z (by rw [← hsquare]; exact Nat.ne_of_gt hp)
  have hfeasible : E ∈ recohFeasibleEdgeSets U half :=
    (recoh_mem_feasible_edge_sets U E half).mpr
      ⟨hEs, hcard, by simp only [hsigma0, Option.isSome_some]⟩
  have hsquareB : orderedSquare (recohEdgeRepresentative half E) = R := by
    rw [hrep]
    calc
      orderedSquare (recohEdgeDecode E sigma0) =
          orderedSquare (translateSupport (recohEdgeDecode E sigma0) (sigma - sigma0)) :=
        (recoh_ordered_square_two_torsion_translate _ _ hu).symm
      _ = R := by rw [hshift]; exact hsquare
  refine ⟨recohEdgeRepresentative half E, ?_, sigma - sigma0, hu, ?_⟩
  · apply Finset.mem_image.mpr
    refine ⟨E, Finset.mem_filter.mpr ⟨hfeasible, ?_⟩, rfl⟩
    exact (recoh_sparse_square_check_iff U _ R hR).mpr hsquareB
  · rw [hrep]
    exact hshift.symm

section FiniteSelection

variable {α : Type*}

/-- Retain the first passing index in the supplied finite order. -/
def recohFirstPassing (test : α → Bool) : List α → Option α
  | [] => none
  | a :: rest => if test a then some a else recohFirstPassing test rest

theorem recoh_first_passing_sound (test : α → Bool) (xs : List α) (a : α)
    (h : recohFirstPassing test xs = some a) : test a = true := by
  induction xs with
  | nil => simp [recohFirstPassing] at h
  | cons b xs ih =>
    by_cases hb : test b = true
    · simp only [recohFirstPassing, hb, if_true, Option.some.injEq] at h
      simpa only [← h] using hb
    · simp only [recohFirstPassing, if_neg hb] at h
      exact ih h

theorem recoh_first_passing_exists (test : α → Bool) (xs : List α)
    (h : ∃ a ∈ xs, test a = true) : ∃ a, recohFirstPassing test xs = some a := by
  induction xs with
  | nil => simp at h
  | cons b xs ih =>
    by_cases hb : test b = true
    · exact ⟨b, by simp only [recohFirstPassing, hb, if_true]⟩
    · have hex : ∃ a ∈ xs, test a = true := by
        obtain ⟨a, ha, ht⟩ := h
        rcases List.mem_cons.mp ha with rfl | ha
        · exact (hb ht).elim
        · exact ⟨a, ha, ht⟩
      obtain ⟨a, ha⟩ := ih hex
      exact ⟨a, by simp only [recohFirstPassing, if_neg hb, ha]⟩

end FiniteSelection

section Cyclic

variable {d : ℕ} (q : Fin d → ℕ) [∀ i, NeZero (q i)]

/-- Canonical support of the square function, including on arbitrary typed
inputs: zero-count entries cannot affect selection. -/
def recohSelectedSquareSupport
    (entries : List (((i : Fin d) → ZMod (q i)) × ℕ)) :
    Finset ((i : Fin d) → ZMod (q i)) :=
  (recohTypedSquareSupport entries).filter (fun z => recohTypedSquareValue entries z ≠ 0)

omit [∀ i, NeZero (q i)] in
theorem recoh_mem_selected_square_support
    (entries : List (((i : Fin d) → ZMod (q i)) × ℕ))
    (z : (i : Fin d) → ZMod (q i)) :
    z ∈ recohSelectedSquareSupport q entries ↔ recohTypedSquareValue entries z ≠ 0 := by
  simp only [recohSelectedSquareSupport, Finset.mem_filter]
  exact and_iff_right_of_imp (recoh_typed_square_covered entries z)

theorem recoh_selected_square_support_covered
    (entries : List (((i : Fin d) → ZMod (q i)) × ℕ))
    (z : (i : Fin d) → ZMod (q i)) (hz : recohTypedSquareValue entries z ≠ 0) :
    z ∈ recohSelectedSquareSupport q entries :=
  (recoh_mem_selected_square_support q entries z).mpr hz

/-- The square-only representative construction for the cyclic presentation. -/
def recohCyclicSquareRepresentatives
    (entries : List (((i : Fin d) → ZMod (q i)) × ℕ)) :
    Finset (Finset ((i : Fin d) → ZMod (q i))) :=
  recohSquareRepresentatives (recohSelectedSquareSupport q entries)
    (recohTypedSquareValue entries) (recohProductHalf q)

/-- Exact equality of two prospective ternary readings; neither reading
needs to have been measured. -/
def recohTernaryReadingEqual (j : RecohPrimaryCoordinate q 3)
    (B C : Finset ((i : Fin d) → ZMod (q i))) : Bool :=
  recohSparseEqual
    (recohReducedTerms 3 ((recohCanonicalPrimaryData q 3).exponent j)
      (recohCyclicExponents q j.val B))
    (recohReducedTerms 3 ((recohCanonicalPrimaryData q 3).exponent j)
      (recohCyclicExponents q j.val C))

theorem recoh_ternary_reading_equal_iff (j : RecohPrimaryCoordinate q 3)
    (B C : Finset ((i : Fin d) → ZMod (q i))) :
    recohTernaryReadingEqual q j B C = true ↔
      recohSupportProbe (recohCyclicPrimaryBank q 3 (recohCanonicalPrimaryData q 3) j) B =
        recohSupportProbe (recohCyclicPrimaryBank q 3 (recohCanonicalPrimaryData q 3) j) C := by
  let k := (recohCanonicalPrimaryData q 3).exponent j
  let ζ := recohCyclicRoot (3 ^ (k + 1))
  have hζ : IsPrimitiveRoot ζ (3 ^ (k + 1)) := recoh_cyclic_root_primitive _
  rw [recohTernaryReadingEqual,
    recoh_reduced_coefficients_equal_iff Nat.prime_three k hζ _ _
      (recoh_reduced_terms_reduced Nat.prime_three k _)
      (recoh_reduced_terms_reduced Nat.prime_three k _),
    recoh_reduced_terms_value Nat.prime_three k hζ,
    recoh_reduced_terms_value Nat.prime_three k hζ]
  rw [recoh_cyclic_primary_bank_interpret q 3 (recohCanonicalPrimaryData q 3) j B,
    recoh_cyclic_primary_bank_interpret q 3 (recohCanonicalPrimaryData q 3) j C]

/-- A coordinate passes if it distinguishes every pair of distinct orbits
represented in the square-only candidate set. -/
def recohTernaryOrbitCheck
    (reps : Finset (Finset ((i : Fin d) → ZMod (q i))))
    (j : RecohPrimaryCoordinate q 3) : Bool :=
  recohOrbitSeparatorCheck reps (recohTernaryReadingEqual q j)

theorem recoh_ternary_orbit_check_iff
    (reps : Finset (Finset ((i : Fin d) → ZMod (q i))))
    (hnonempty : ∀ B ∈ reps, B.Nonempty) (j : RecohPrimaryCoordinate q 3) :
    recohTernaryOrbitCheck q reps j = true ↔
      ∀ B ∈ reps, ∀ C ∈ reps,
        recohSupportProbe (recohCyclicPrimaryBank q 3 (recohCanonicalPrimaryData q 3) j) B =
          recohSupportProbe (recohCyclicPrimaryBank q 3 (recohCanonicalPrimaryData q 3) j) C →
            OrdinaryPartner B C := by
  simp only [recohTernaryOrbitCheck, recohOrbitSeparatorCheck, decide_eq_true_eq]
  constructor
  · intro h B hB C hC heq
    rcases h B hB C hC with ho | hn
    · exact (recoh_torsion_orbit_check_iff B C (hnonempty B hB)).mp ho
    · exact (hn ((recoh_ternary_reading_equal_iff q j B C).mpr heq)).elim
  · intro h B hB C hC
    by_cases heq : recohTernaryReadingEqual q j B C = true
    · exact Or.inl ((recoh_torsion_orbit_check_iff B C (hnonempty B hB)).mpr
        (h B hB C hC ((recoh_ternary_reading_equal_iff q j B C).mp heq)))
    · exact Or.inr heq

/-- The optional extra coordinate depends only on the labelled square.
Its finite scan follows the increasing order of presentation coordinates. -/
def recohSquareTernaryChoice
    (entries : List (((i : Fin d) → ZMod (q i)) × ℕ)) :
    Option (RecohPrimaryCoordinate q 3) :=
  let reps := recohCyclicSquareRepresentatives q entries
  if recohOneOrbitCheck reps then none
  else recohFirstPassing (recohTernaryOrbitCheck q reps) (Finset.univ.sort (· ≤ ·))

theorem recoh_square_ternary_choice_some
    (entries : List (((i : Fin d) → ZMod (q i)) × ℕ))
    (j : RecohPrimaryCoordinate q 3) (h : recohSquareTernaryChoice q entries = some j) :
    recohTernaryOrbitCheck q (recohCyclicSquareRepresentatives q entries) j = true := by
  unfold recohSquareTernaryChoice at h
  dsimp only at h
  by_cases ho : recohOneOrbitCheck (recohCyclicSquareRepresentatives q entries) = true
  · simp only [if_pos ho, reduceCtorEq] at h
  · rw [if_neg ho] at h
    exact recoh_first_passing_sound _ _ j h

theorem recoh_cyclic_square_representatives_sound
    (entries : List (((i : Fin d) → ZMod (q i)) × ℕ))
    (B : Finset ((i : Fin d) → ZMod (q i)))
    (hB : B ∈ recohCyclicSquareRepresentatives q entries) :
    B.card = 3 ∧ orderedSquare B = recohTypedSquareValue entries :=
  recoh_square_representatives_sound _ _ _ (recoh_selected_square_support_covered q entries) B hB

theorem recoh_cyclic_square_representatives_nonempty
    (entries : List (((i : Fin d) → ZMod (q i)) × ℕ))
    (B : Finset ((i : Fin d) → ZMod (q i)))
    (hB : B ∈ recohCyclicSquareRepresentatives q entries) : B.Nonempty := by
  apply Finset.card_pos.mp
  rw [(recoh_cyclic_square_representatives_sound q entries B hB).1]
  decide

theorem recoh_cyclic_square_representatives_complete
    (entries : List (((i : Fin d) → ZMod (q i)) × ℕ))
    (S : Finset ((i : Fin d) → ZMod (q i))) (hS : S.card = 3)
    (hsquare : orderedSquare S = recohTypedSquareValue entries) :
    ∃ B ∈ recohCyclicSquareRepresentatives q entries, OrdinaryPartner B S :=
  recoh_square_representatives_complete _ _ _ (recoh_product_half_spec q)
    (recoh_selected_square_support_covered q entries) S hS hsquare

omit [∀ i, NeZero (q i)] in
theorem recoh_cyclic_square_representatives_card_le_twenty
    (entries : List (((i : Fin d) → ZMod (q i)) × ℕ))
    (hformat : RecohTypedSquareFormat entries) :
    (recohCyclicSquareRepresentatives q entries).card ≤ 20 :=
  recoh_square_representatives_card_le_twenty _ _ _
    ((Finset.card_filter_le _ _).trans
      (recoh_typed_square_support_card_le_six entries hformat))

/-- Selection depends on the square function alone, even if the typed list
is reordered, split into duplicate entries, or padded by zero entries. -/
theorem recoh_square_ternary_choice_eq_of_square_eq
    (entries other : List (((i : Fin d) → ZMod (q i)) × ℕ))
    (hR : recohTypedSquareValue entries = recohTypedSquareValue other) :
    recohSquareTernaryChoice q entries = recohSquareTernaryChoice q other := by
  have hU : recohSelectedSquareSupport q entries = recohSelectedSquareSupport q other := by
    ext z
    rw [recoh_mem_selected_square_support, recoh_mem_selected_square_support, hR]
  simp only [recohSquareTernaryChoice, recohCyclicSquareRepresentatives, hU, hR]

/-- On every realizable square the finite search either certifies one
orbit or finds a common separating ternary coordinate. -/
theorem recoh_square_ternary_choice_complete
    (entries : List (((i : Fin d) → ZMod (q i)) × ℕ))
    (S : Finset ((i : Fin d) → ZMod (q i))) (hS : S.card = 3)
    (hsquare : orderedSquare S = recohTypedSquareValue entries) :
    recohOneOrbitCheck (recohCyclicSquareRepresentatives q entries) = true ∨
      ∃ j, recohSquareTernaryChoice q entries = some j ∧
        recohTernaryOrbitCheck q (recohCyclicSquareRepresentatives q entries) j = true := by
  let reps := recohCyclicSquareRepresentatives q entries
  have hnonempty : ∀ B ∈ reps, B.Nonempty :=
    recoh_cyclic_square_representatives_nonempty q entries
  have hfibre : ∀ B ∈ reps, B ∈ squareFibre S := by
    intro B hB
    obtain ⟨hB3, hBR⟩ := recoh_cyclic_square_representatives_sound q entries B hB
    exact (mem_squareFibre S B).mpr
      ⟨hB3, fun z => congrFun (hsquare.trans hBR.symm) z⟩
  by_cases ho : recohOneOrbitCheck reps = true
  · exact Or.inl ho
  · obtain ⟨j, hj⟩ : ∃ j, recohTernaryOrbitCheck q reps j = true := by
      rcases recoh_cyclic_fibre_orbit_separator q (recohCanonicalPrimaryData q 3) S hS with
        hall | ⟨j, hj⟩
      · exact (ho ((recoh_one_orbit_check_iff reps hnonempty).mpr
          (fun B hB C hC => hall B (hfibre B hB) C (hfibre C hC)))).elim
      · exact ⟨j, (recoh_ternary_orbit_check_iff q reps hnonempty j).mpr
          (fun B hB C hC => hj B (hfibre B hB) C (hfibre C hC))⟩
    obtain ⟨i, hi⟩ := recoh_first_passing_exists (recohTernaryOrbitCheck q reps)
      (Finset.univ.sort (· ≤ ·)) ⟨j, by simp, hj⟩
    have hchoice : recohSquareTernaryChoice q entries = some i := by
      change (if recohOneOrbitCheck reps then none else
        recohFirstPassing (recohTernaryOrbitCheck q reps) (Finset.univ.sort (· ≤ ·))) = some i
      rw [if_neg ho]
      exact hi
    exact Or.inr ⟨i, hchoice, recoh_first_passing_sound _ _ i hi⟩

/-- Equality of the selected ternary reading forces two supports with the
observed square into the same two-torsion orbit. In the ordinary case the
premise has no measurement slots. -/
theorem recoh_square_selected_orbits
    (entries : List (((i : Fin d) → ZMod (q i)) × ℕ))
    (S T : Finset ((i : Fin d) → ZMod (q i))) (hS : S.card = 3) (hT : T.card = 3)
    (hSR : orderedSquare S = recohTypedSquareValue entries)
    (hTR : orderedSquare T = recohTypedSquareValue entries)
    (hread : ∀ j, recohSquareTernaryChoice q entries = some j →
      recohSupportProbe (recohCyclicPrimaryBank q 3 (recohCanonicalPrimaryData q 3) j) S =
        recohSupportProbe (recohCyclicPrimaryBank q 3 (recohCanonicalPrimaryData q 3) j) T) :
    OrdinaryPartner S T := by
  obtain ⟨B, hB, hBS⟩ := recoh_cyclic_square_representatives_complete q entries S hS hSR
  obtain ⟨C, hC, hCT⟩ := recoh_cyclic_square_representatives_complete q entries T hT hTR
  have hBC : OrdinaryPartner B C := by
    have hnonempty := recoh_cyclic_square_representatives_nonempty q entries
    rcases recoh_square_ternary_choice_complete q entries S hS hSR with ho | ⟨j, hj, hp⟩
    · exact ((recoh_one_orbit_check_iff _ hnonempty).mp ho) B hB C hC
    · apply ((recoh_ternary_orbit_check_iff q _ hnonempty j).mp hp) B hB C hC
      calc
        recohSupportProbe (recohCyclicPrimaryBank q 3 (recohCanonicalPrimaryData q 3) j) B =
            recohSupportProbe (recohCyclicPrimaryBank q 3 (recohCanonicalPrimaryData q 3) j) S :=
          recoh_cyclic_ternary_constant_on_ordinary q _ j B S hBS
        _ = recohSupportProbe (recohCyclicPrimaryBank q 3 (recohCanonicalPrimaryData q 3) j) T :=
          hread j hj
        _ = recohSupportProbe (recohCyclicPrimaryBank q 3 (recohCanonicalPrimaryData q 3) j) C :=
          (recoh_cyclic_ternary_constant_on_ordinary q _ j C T hCT).symm
  exact recoh_ordinary_partner_trans
    (recoh_ordinary_partner_trans (recoh_ordinary_partner_symm hBS) hBC) hCT

/-- The selector requests no ternary measurement exactly on the ordinary
fibres. Hence no redundant ternary measurement is requested there. -/
theorem recoh_square_ternary_choice_none_iff
    (entries : List (((i : Fin d) → ZMod (q i)) × ℕ))
    (S : Finset ((i : Fin d) → ZMod (q i))) (hS : S.card = 3)
    (hsquare : orderedSquare S = recohTypedSquareValue entries) :
    recohSquareTernaryChoice q entries = none ↔
      (squareFibre S).card = (twoTorsion : Finset ((i : Fin d) → ZMod (q i))).card := by
  constructor
  · intro hnone
    have hsub : squareFibre S ⊆ torsionOrbit S := by
      intro T hT
      obtain ⟨hT3, hST⟩ := (mem_squareFibre S T).mp hT
      apply (mem_torsionOrbit S T).mpr
      apply recoh_square_selected_orbits q entries S T hS hT3 hsquare
        ((funext hST).symm.trans hsquare)
      intro j hj
      rw [hnone] at hj
      cases hj
    have heq := Finset.Subset.antisymm hsub (torsionOrbit_subset_fibre S hS)
    rw [heq, torsionOrbit_card S hS]
  · intro hcard
    have hfibre : squareFibre S = torsionOrbit S := by
      apply (Finset.eq_of_subset_of_card_le (torsionOrbit_subset_fibre S hS) ?_).symm
      rw [hcard, torsionOrbit_card S hS]
    have hrep : ∀ B ∈ recohCyclicSquareRepresentatives q entries, B ∈ torsionOrbit S := by
      intro B hB
      obtain ⟨hB3, hBR⟩ := recoh_cyclic_square_representatives_sound q entries B hB
      rw [← hfibre]
      exact (mem_squareFibre S B).mpr
        ⟨hB3, fun z => congrFun (hsquare.trans hBR.symm) z⟩
    have hone : recohOneOrbitCheck (recohCyclicSquareRepresentatives q entries) = true := by
      apply (recoh_one_orbit_check_iff _
        (recoh_cyclic_square_representatives_nonempty q entries)).mpr
      intro B hB C hC
      exact recoh_ordinary_partner_of_common_torsion_orbit S B C (hrep B hB) (hrep C hC)
    simp only [recohSquareTernaryChoice, hone, if_true]

end Cyclic

end Couret.STROBO2TORS

#print axioms Couret.STROBO2TORS.recoh_torsion_orbit_check_iff
#print axioms Couret.STROBO2TORS.recoh_ordinary_partner_refl
#print axioms Couret.STROBO2TORS.recoh_ordinary_partner_symm
#print axioms Couret.STROBO2TORS.recoh_ordinary_partner_trans
#print axioms Couret.STROBO2TORS.recoh_square_representatives_sound
#print axioms Couret.STROBO2TORS.recoh_square_representatives_card_le_twenty
#print axioms Couret.STROBO2TORS.recoh_one_orbit_check_iff
#print axioms Couret.STROBO2TORS.recoh_square_representatives_complete
#print axioms Couret.STROBO2TORS.recoh_first_passing_sound
#print axioms Couret.STROBO2TORS.recoh_first_passing_exists
#print axioms Couret.STROBO2TORS.recoh_mem_selected_square_support
#print axioms Couret.STROBO2TORS.recoh_selected_square_support_covered
#print axioms Couret.STROBO2TORS.recoh_ternary_reading_equal_iff
#print axioms Couret.STROBO2TORS.recoh_ternary_orbit_check_iff
#print axioms Couret.STROBO2TORS.recoh_square_ternary_choice_some
#print axioms Couret.STROBO2TORS.recoh_cyclic_square_representatives_sound
#print axioms Couret.STROBO2TORS.recoh_cyclic_square_representatives_nonempty
#print axioms Couret.STROBO2TORS.recoh_cyclic_square_representatives_complete
#print axioms Couret.STROBO2TORS.recoh_cyclic_square_representatives_card_le_twenty
#print axioms Couret.STROBO2TORS.recoh_square_ternary_choice_eq_of_square_eq
#print axioms Couret.STROBO2TORS.recoh_square_ternary_choice_complete
#print axioms Couret.STROBO2TORS.recoh_square_selected_orbits
#print axioms Couret.STROBO2TORS.recoh_square_ternary_choice_none_iff
