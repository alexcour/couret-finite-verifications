import RecohCoefficientObservations

set_option autoImplicit false

/-!
Typed sparse input for the labelled ordered convolution square.

The coefficient function and its covering finite set are constructed from
the same list of position/count entries.  Their consistency is proved,
rather than supplied to the decoder.  The format validator expresses the
numeric checks performed by the Python square reader after coordinates and
integers have been parsed.  Syntactic JSON parsing is not part of this file.
-/

namespace Couret.STROBO2TORS

variable {G : Type*} [DecidableEq G]

/-- Nonzero values can occur only at a position explicitly supplied. -/
def recohTypedSquareSupport (entries : List (G × ℕ)) : Finset G :=
  (entries.map Prod.fst).toFinset

/-- Interpretation of a sparse labelled square, also defined for duplicate
positions by adding their counts.  The external format disallows duplicates. -/
def recohTypedSquareValue (entries : List (G × ℕ)) (z : G) : ℕ :=
  ((entries.filter (fun t => t.1 = z)).map Prod.snd).sum

theorem recoh_typed_square_zero_outside
    (entries : List (G × ℕ)) (z : G)
    (hz : z ∉ recohTypedSquareSupport entries) : recohTypedSquareValue entries z = 0 := by
  have hf : entries.filter (fun t => t.1 = z) = [] := by
    apply List.eq_nil_iff_forall_not_mem.mpr
    intro t ht
    have ht' := List.mem_filter.mp ht
    have he : t.1 = z := by simpa using ht'.2
    apply hz
    simp only [recohTypedSquareSupport, List.mem_toFinset, List.mem_map]
    exact ⟨t, ht'.1, he⟩
  simp [recohTypedSquareValue, hf]

theorem recoh_typed_square_covered
    (entries : List (G × ℕ)) (z : G)
    (hz : recohTypedSquareValue entries z ≠ 0) : z ∈ recohTypedSquareSupport entries := by
  by_contra hn
  exact hz (recoh_typed_square_zero_outside entries z hn)

/-- The scalar constraints of the Python square parser on typed entries.
The position order is unrestricted, and the full ordered mass is nine. -/
def RecohTypedSquareFormat (entries : List (G × ℕ)) : Prop :=
  3 ≤ entries.length ∧ entries.length ≤ 6 ∧
    (entries.map Prod.fst).Nodup ∧
    (∀ t ∈ entries, 1 ≤ t.2 ∧ t.2 ≤ 3) ∧
    (entries.map Prod.snd).sum = 9 ∧
    (((entries.map (fun t => t.2 % 2)).sum = 1) ∨
      ((entries.map (fun t => t.2 % 2)).sum = 3))

instance recohTypedSquareFormatDecidable (entries : List (G × ℕ)) :
    Decidable (RecohTypedSquareFormat entries) := by
  unfold RecohTypedSquareFormat
  infer_instance

/-- Executable validation of the typed sparse square. -/
def recohTypedSquareFormatCheck (entries : List (G × ℕ)) : Bool :=
  decide (RecohTypedSquareFormat entries)

theorem recoh_typed_square_format_check_iff (entries : List (G × ℕ)) :
    recohTypedSquareFormatCheck entries = true ↔ RecohTypedSquareFormat entries := by
  simp [recohTypedSquareFormatCheck]

theorem recoh_typed_square_support_card_le_six
    (entries : List (G × ℕ)) (h : RecohTypedSquareFormat entries) :
    (recohTypedSquareSupport entries).card ≤ 6 := by
  exact (List.toFinset_card_le (entries.map Prod.fst)).trans
    (by simpa only [List.length_map] using h.2.1)

/-- A single runtime guard for all typed coefficient lists. -/
def recohAllCoefficientFormats {I : Type*} [Fintype I]
    (p k : I → ℕ) (terms : I → RecohSparseTerms) : Bool :=
  decide (∀ i, recohCoefficientFormatCheck (p i) (k i) (terms i) = true)

theorem recoh_all_coefficient_formats_iff {I : Type*} [Fintype I]
    (p k : I → ℕ) (terms : I → RecohSparseTerms) :
    recohAllCoefficientFormats p k terms = true ↔
      ∀ i, RecohCoefficientFormat (p i) (k i) (terms i) := by
  simp [recohAllCoefficientFormats, recoh_coefficient_format_check_iff]

end Couret.STROBO2TORS

#print axioms Couret.STROBO2TORS.recoh_typed_square_zero_outside
#print axioms Couret.STROBO2TORS.recoh_typed_square_covered
#print axioms Couret.STROBO2TORS.recoh_typed_square_format_check_iff
#print axioms Couret.STROBO2TORS.recoh_typed_square_support_card_le_six
#print axioms Couret.STROBO2TORS.recoh_all_coefficient_formats_iff
