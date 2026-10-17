import Strobo2TorsCore

set_option autoImplicit false

/-!
Intersection sizes for the exceptional branch of the triple-square
classification. The parameters below use the same coordinates as
ExceptionalPartner: the reflected doublet is based at b + b - a.
No finiteness assumption on the ambient abelian group is needed.
-/

namespace Couret.STROBO2TORS

variable {G : Type*} [AddCommGroup G] [DecidableEq G]

private theorem deltaExceptional_pair_double_ne_reflected_double
    (a b : G) (hab : a + a ≠ b + b) :
    b + b ≠ (b + b - a) + (b + b - a) := by
  intro h
  apply hab
  apply sub_eq_zero.mp
  calc
    (a + a) - (b + b) =
        (b + b) - ((b + b - a) + (b + b - a)) := by abel
    _ = 0 := by rw [← h]; simp

private theorem deltaExceptional_singleton_double_ne_reflected_double
    (a b d : G) (hd : d + d = 0) (hab : a + a ≠ b + b)
    (h3 : ((b - a) + (b - a)) + (b - a) = 0 ∨
      ((b - a) + (b - a)) + (b - a) = d) :
    a + a ≠ (b + b - a) + (b + b - a) := by
  intro h
  have hee : (b + b - a) + (b + b - a) =
      (a + b) + (((b - a) + (b - a)) + (b - a)) := by abel
  rcases h3 with hzero | hdiff
  · have hbase : a + a = a + b := by
      calc
        a + a = (b + b - a) + (b + b - a) := h
        _ = a + b := by rw [hee, hzero]; simp
    have habase : a = b := add_left_cancel hbase
    exact hab (by rw [habase])
  · have hbase : a + a = a + (b + d) := by
      calc
        a + a = (b + b - a) + (b + b - a) := h
        _ = (a + b) + d := by rw [hee, hdiff]
        _ = a + (b + d) := by abel
    have habase : a = b + d := add_left_cancel hbase
    apply hab
    calc
      a + a = (b + d) + (b + d) := by rw [habase]
      _ = b + b := pair_sum_translate b b d hd

private theorem deltaExceptional_common_mem
    (a b d u z : G) (hd : d + d = 0) (hab : a + a ≠ b + b)
    (hu : u + u = 0)
    (h3 : ((b - a) + (b - a)) + (b - a) = 0 ∨
      ((b - a) + (b - a)) + (b - a) = d)
    (hzS : z ∈ ({a, b, b + d} : Finset G))
    (hzT : z ∈ translateSupport
      ({a, b + b - a, (b + b - a) + d} : Finset G) u) :
    z = a ∧ z = a + u := by
  let e : G := b + b - a
  have hae : a + a ≠ e + e :=
    deltaExceptional_singleton_double_ne_reflected_double a b d hd hab h3
  have hbe : b + b ≠ e + e :=
    deltaExceptional_pair_double_ne_reflected_double a b hab
  change z ∈ translateSupport ({a, e, e + d} : Finset G) u at hzT
  rw [translateSupport_three] at hzT
  simp only [Finset.mem_insert, Finset.mem_singleton] at hzS hzT
  have hs2 : z + z = a + a ∨ z + z = b + b := by
    rcases hzS with hz | hz | hz
    · exact Or.inl (congrArg (fun w : G => w + w) hz)
    · exact Or.inr (congrArg (fun w : G => w + w) hz)
    · exact Or.inr ((congrArg (fun w : G => w + w) hz).trans
        (pair_sum_translate b b d hd))
  have ht2 : z + z = a + a ∨ z + z = e + e := by
    rcases hzT with hz | hz | hz
    · exact Or.inl ((congrArg (fun w : G => w + w) hz).trans
        (pair_sum_translate a a u hu))
    · exact Or.inr ((congrArg (fun w : G => w + w) hz).trans
        (pair_sum_translate e e u hu))
    · exact Or.inr (((congrArg (fun w : G => w + w) hz).trans
        (pair_sum_translate (e + d) (e + d) u hu)).trans
        (pair_sum_translate e e d hd))
  have hzaa : z + z = a + a := by
    rcases hs2 with ha | hb
    · exact ha
    · rcases ht2 with ha | he
      · exact (hab (ha.symm.trans hb)).elim
      · exact (hbe (hb.symm.trans he)).elim
  constructor
  · rcases hzS with hz | hz | hz
    · exact hz
    · exact (hab (hzaa.symm.trans
        (congrArg (fun w : G => w + w) hz))).elim
    · exact (hab (hzaa.symm.trans
        ((congrArg (fun w : G => w + w) hz).trans
          (pair_sum_translate b b d hd)))).elim
  · rcases hzT with hz | hz | hz
    · exact hz
    · exact (hae (hzaa.symm.trans
        ((congrArg (fun w : G => w + w) hz).trans
          (pair_sum_translate e e u hu)))).elim
    · exact (hae (hzaa.symm.trans
        (((congrArg (fun w : G => w + w) hz).trans
          (pair_sum_translate (e + d) (e + d) u hu)).trans
          (pair_sum_translate e e d hd)))).elim

/-- The normalized exceptional pair shares exactly its singleton when the
additional 2-torsion shift is zero; otherwise its supports are disjoint.
The intersection statement itself does not require d ≠ 0. -/
theorem exceptionalPartner_normalized_inter
    (a b d u : G) (hd : d + d = 0) (hab : a + a ≠ b + b)
    (hu : u + u = 0)
    (h3 : ((b - a) + (b - a)) + (b - a) = 0 ∨
      ((b - a) + (b - a)) + (b - a) = d) :
    ({a, b, b + d} : Finset G) ∩
        translateSupport ({a, b + b - a, (b + b - a) + d} : Finset G) u =
      if u = 0 then {a} else ∅ := by
  by_cases hu0 : u = 0
  · rw [if_pos hu0]
    ext z
    constructor
    · intro hz
      obtain ⟨hzS, hzT⟩ := Finset.mem_inter.mp hz
      exact Finset.mem_singleton.mpr
        (deltaExceptional_common_mem a b d u z hd hab hu h3 hzS hzT).1
    · intro hz
      have hza : z = a := Finset.mem_singleton.mp hz
      subst z
      apply Finset.mem_inter.mpr
      constructor
      · simp
      · rw [translateSupport_three, hu0]
        simp
  · rw [if_neg hu0]
    ext z
    constructor
    · intro hz
      obtain ⟨hzS, hzT⟩ := Finset.mem_inter.mp hz
      obtain ⟨hza, hzu⟩ :=
        deltaExceptional_common_mem a b d u z hd hab hu h3 hzS hzT
      have hau : a + u = a + 0 := by
        rw [add_zero]
        exact hzu.symm.trans hza
      exact (hu0 (add_left_cancel hau)).elim
    · intro hz
      have hfalse : False := by simpa using hz
      exact hfalse.elim

/-- Zero additional shift gives the common singleton of an exceptional pair. -/
theorem exceptionalPartner_normalized_inter_singleton
    (a b d u : G) (hd : d + d = 0) (hab : a + a ≠ b + b)
    (hu : u + u = 0)
    (h3 : ((b - a) + (b - a)) + (b - a) = 0 ∨
      ((b - a) + (b - a)) + (b - a) = d) (hu0 : u = 0) :
    ({a, b, b + d} : Finset G) ∩
        translateSupport ({a, b + b - a, (b + b - a) + d} : Finset G) u =
      {a} := by
  rw [exceptionalPartner_normalized_inter a b d u hd hab hu h3, if_pos hu0]

/-- A nonzero additional 2-torsion shift makes an exceptional pair disjoint. -/
theorem exceptionalPartner_normalized_inter_empty
    (a b d u : G) (hd : d + d = 0) (hab : a + a ≠ b + b)
    (hu : u + u = 0)
    (h3 : ((b - a) + (b - a)) + (b - a) = 0 ∨
      ((b - a) + (b - a)) + (b - a) = d) (hu0 : u ≠ 0) :
    ({a, b, b + d} : Finset G) ∩
        translateSupport ({a, b + b - a, (b + b - a) + d} : Finset G) u =
      ∅ := by
  rw [exceptionalPartner_normalized_inter a b d u hd hab hu h3, if_neg hu0]

/-- Exceptional partners have an intersection of cardinality zero or one. -/
theorem exceptionalPartner_inter_card_zero_or_one (S T : Finset G)
    (he : ExceptionalPartner S T) :
    (S ∩ T).card = 0 ∨ (S ∩ T).card = 1 := by
  obtain ⟨a, b, d, u, hd, _, hab, hu, h3, hs, ht⟩ := he
  rw [hs, ht, exceptionalPartner_normalized_inter a b d u hd hab hu h3]
  by_cases hu0 : u = 0 <;> simp [hu0]

/-- An exceptional pair cannot share two support elements. -/
theorem exceptionalPartner_inter_card_ne_two (S T : Finset G)
    (he : ExceptionalPartner S T) : (S ∩ T).card ≠ 2 := by
  have hcard := exceptionalPartner_inter_card_zero_or_one S T he
  omega

#print axioms Couret.STROBO2TORS.exceptionalPartner_normalized_inter
#print axioms Couret.STROBO2TORS.exceptionalPartner_normalized_inter_singleton
#print axioms Couret.STROBO2TORS.exceptionalPartner_normalized_inter_empty
#print axioms Couret.STROBO2TORS.exceptionalPartner_inter_card_zero_or_one
#print axioms Couret.STROBO2TORS.exceptionalPartner_inter_card_ne_two

end Couret.STROBO2TORS
