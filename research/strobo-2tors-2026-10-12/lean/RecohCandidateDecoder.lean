import RecohOptimalBank

set_option autoImplicit false

/-!
Structured candidates for exact RECOH reconstruction.

For a genuine triple S = {a,b,c}, its three distinct off-diagonal sums
E = {a+b,a+c,b+c} belong to the support of the ordered square.  With
sigma = a+b+c, they satisfy sum E = sigma+sigma and S = sigma-E.
This supplies a complete candidate generator using only the input square.

The finite candidate generator uses decidable group operations.  The exact
complex-character filter below is explicitly noncomputable: this module
certifies its mathematical result, not an executable representation of
complex numbers or a refinement of a separate Python implementation.
-/

namespace Couret.STROBO2TORS

open scoped BigOperators

variable {G : Type*} [AddCommGroup G] [DecidableEq G]

/-- Reflect the three proposed edge sums about their proposed total. -/
def recohEdgeDecode (E : Finset G) (sigma : G) : Finset G :=
  E.image (fun e => sigma - e)

theorem recoh_edge_decode_card (E : Finset G) (sigma : G) :
    (recohEdgeDecode E sigma).card = E.card := by
  apply Finset.card_image_of_injective
  intro x y h
  exact sub_right_injective h

/-- Every sum of two support elements has a positive square coefficient. -/
theorem recoh_ordered_square_pos_of_mem (S : Finset G) (a b : G)
    (ha : a ∈ S) (hb : b ∈ S) : 0 < orderedSquare S (a + b) := by
  unfold orderedSquare
  apply Finset.sum_pos_iff.mpr
  refine ⟨a, ha, ?_⟩
  apply Finset.sum_pos_iff.mpr
  exact ⟨b, hb, by simp⟩

variable [Fintype G]

/-- The known labelled support of an input square. -/
def recohSquareSupport (R : G → ℕ) : Finset G :=
  Finset.univ.filter (fun z => 0 < R z)

omit [AddCommGroup G] [DecidableEq G] in
@[simp] theorem recoh_mem_square_support (R : G → ℕ) (z : G) :
    z ∈ recohSquareSupport R ↔ 0 < R z := by
  simp [recohSquareSupport]

/-- A genuine triple square has at most three diagonal values and three
off-diagonal values. -/
theorem recoh_square_support_card_le_six (S : Finset G) (hS : S.card = 3) :
    (recohSquareSupport (orderedSquare S)).card ≤ 6 := by
  obtain ⟨a, b, c, hab, hac, hbc, rfl⟩ := Finset.card_eq_three.mp hS
  have hsub : recohSquareSupport (orderedSquare ({a, b, c} : Finset G)) ⊆
      {a + a, b + b, c + c, a + b, a + c, b + c} := by
    intro z hz
    have hp := (recoh_mem_square_support _ _).mp hz
    rw [orderedSquare_three a b c z hab hac hbc] at hp
    simpa only [Finset.mem_insert, Finset.mem_singleton] using
      square_positive_cases a b c z hp
  exact (Finset.card_le_card hsub).trans Finset.card_le_six

/-- Enumerate edge triples together with all solutions of their doubling
equation.  Both the finite enumeration and its test are decidable. -/
def recohCandidatePairs (R : G → ℕ) : Finset (Finset G × G) :=
  (((recohSquareSupport R).powersetCard 3) ×ˢ Finset.univ).filter
    (fun p => p.2 + p.2 = p.1.sum id)

/-- Proposed support triples, prior to checking the complete observation. -/
def recohCandidates (R : G → ℕ) : Finset (Finset G) :=
  (recohCandidatePairs R).image (fun p => recohEdgeDecode p.1 p.2)

theorem recoh_mem_candidates_iff (R : G → ℕ) (S : Finset G) :
    S ∈ recohCandidates R ↔
      ∃ E : Finset G, ∃ sigma : G,
        E ⊆ recohSquareSupport R ∧ E.card = 3 ∧
        sigma + sigma = E.sum id ∧ recohEdgeDecode E sigma = S := by
  simp only [recohCandidates, recohCandidatePairs, Finset.mem_image,
    Finset.mem_filter, Finset.mem_product, Finset.mem_powersetCard,
    Finset.mem_univ, and_true, Prod.exists]
  constructor
  · rintro ⟨E, sigma, ⟨⟨hsub, hcard⟩, hsum⟩, hS⟩
    exact ⟨E, sigma, hsub, hcard, hsum, hS⟩
  · rintro ⟨E, sigma, hsub, hcard, hsum, hS⟩
    exact ⟨E, sigma, ⟨⟨hsub, hcard⟩, hsum⟩, hS⟩

theorem recoh_candidate_card_three (R : G → ℕ) (S : Finset G)
    (hS : S ∈ recohCandidates R) : S.card = 3 := by
  obtain ⟨E, sigma, _, hcard, _, rfl⟩ := (recoh_mem_candidates_iff R S).mp hS
  rw [recoh_edge_decode_card, hcard]

/-- Completeness: the true support occurs in the finite candidate generator. -/
theorem recoh_candidates_complete (S : Finset G) (hS : S.card = 3) :
    S ∈ recohCandidates (orderedSquare S) := by
  obtain ⟨a, b, c, hab, hac, hbc, rfl⟩ := Finset.card_eq_three.mp hS
  have he12 : a + b ≠ a + c := fun h => hbc (add_left_cancel h)
  have he13 : a + b ≠ b + c := by
    intro h
    apply hac
    have h' : a + b = c + b := by simpa only [add_comm b c] using h
    exact add_right_cancel h'
  have he23 : a + c ≠ b + c := fun h => hab (add_right_cancel h)
  apply (recoh_mem_candidates_iff _ _).mpr
  refine ⟨{a + b, a + c, b + c}, a + b + c, ?_, ?_, ?_, ?_⟩
  · intro e he
    rw [recoh_mem_square_support]
    simp only [Finset.mem_insert, Finset.mem_singleton] at he
    rcases he with rfl | rfl | rfl
    · exact recoh_ordered_square_pos_of_mem _ a b (by simp) (by simp)
    · exact recoh_ordered_square_pos_of_mem _ a c (by simp) (by simp)
    · exact recoh_ordered_square_pos_of_mem _ b c (by simp) (by simp)
  · simp [he12, he13, he23]
  · simp only [Finset.sum_insert, Finset.mem_insert, Finset.mem_singleton,
      not_or, he12, he13, he23, not_false_eq_true, and_self,
      Finset.sum_singleton, id_eq]
    abel
  · have ha : (a + b + c) - (a + b) = c := by abel
    have hb : (a + b + c) - (a + c) = b := by abel
    have hc : (a + b + c) - (b + c) = a := by abel
    ext x
    simp only [recohEdgeDecode, Finset.image_insert, Finset.image_singleton,
      ha, hb, hc, Finset.mem_insert, Finset.mem_singleton]
    tauto

/-- Exact observation filtering.  Deciding equality in C is not claimed to
be an executable operation; an exact cyclotomic implementation is separate. -/
noncomputable def recohExactDecoder {I : Type*}
    (bank : I → AddChar G ℂ) (obs : (G → ℕ) × (I → ℂ)) : Finset (Finset G) := by
  classical
  exact (recohCandidates obs.1).filter (fun S => recohObservation bank S = obs)

theorem recoh_mem_exact_decoder_iff {I : Type*}
    (bank : I → AddChar G ℂ) (obs : (G → ℕ) × (I → ℂ)) (S : Finset G) :
    S ∈ recohExactDecoder bank obs ↔
      S.card = 3 ∧ recohObservation bank S = obs := by
  classical
  constructor
  · intro h
    obtain ⟨hc, ho⟩ := Finset.mem_filter.mp h
    exact ⟨recoh_candidate_card_three obs.1 S hc, ho⟩
  · rintro ⟨hS, ho⟩
    apply Finset.mem_filter.mpr
    refine ⟨?_, ho⟩
    have hsquare : orderedSquare S = obs.1 := congrArg Prod.fst ho
    rw [← hsquare]
    exact recoh_candidates_complete S hS

/-- A reconstructing bank leaves precisely the actual support in the exact
decoder.  The bank hypothesis is discharged by the optimal-bank theorem. -/
theorem recoh_exact_decoder_singleton {I : Type*}
    (bank : I → AddChar G ℂ)
    (hinj : Function.Injective (fun S : {S : Finset G // S.card = 3} =>
      recohObservation bank S.1))
    (S : Finset G) (hS : S.card = 3) :
    recohExactDecoder bank (recohObservation bank S) = {S} := by
  classical
  ext T
  rw [recoh_mem_exact_decoder_iff, Finset.mem_singleton]
  constructor
  · rintro ⟨hT, hobs⟩
    exact congrArg Subtype.val (hinj (show
      recohObservation bank (⟨T, hT⟩ : {T : Finset G // T.card = 3}).1 =
        recohObservation bank (⟨S, hS⟩ : {S : Finset G // S.card = 3}).1 from hobs))
  · rintro rfl
    exact ⟨hS, rfl⟩

/-- The previously certified optimum admits the exact candidate decoder,
for every triple, with no additional character-separation hypothesis. -/
theorem recoh_optimal_bank_exact_decoder
    (r s : ℕ)
    (hcard2 : Nat.card (recohTorsionSubgroup (G := G) 2) = 2 ^ r)
    (hcard3 : Nat.card (recohTorsionSubgroup (G := G) 3) = 3 ^ s)
    (hG3 : 3 ≤ Fintype.card G) :
    ∃ bank : Fin (recohOptimalBudget r s) → AddChar G ℂ,
      ∀ S : Finset G, S.card = 3 →
        recohExactDecoder bank (recohObservation bank S) = {S} := by
  obtain ⟨⟨bank, hinj⟩, _⟩ := recoh_optimal_bank_size r s hcard2 hcard3 hG3
  exact ⟨bank, fun S hS => recoh_exact_decoder_singleton bank hinj S hS⟩

end Couret.STROBO2TORS

#print axioms Couret.STROBO2TORS.recoh_edge_decode_card
#print axioms Couret.STROBO2TORS.recoh_ordered_square_pos_of_mem
#print axioms Couret.STROBO2TORS.recoh_mem_square_support
#print axioms Couret.STROBO2TORS.recoh_square_support_card_le_six
#print axioms Couret.STROBO2TORS.recoh_mem_candidates_iff
#print axioms Couret.STROBO2TORS.recoh_candidate_card_three
#print axioms Couret.STROBO2TORS.recoh_candidates_complete
#print axioms Couret.STROBO2TORS.recoh_mem_exact_decoder_iff
#print axioms Couret.STROBO2TORS.recoh_exact_decoder_singleton
#print axioms Couret.STROBO2TORS.recoh_optimal_bank_exact_decoder
