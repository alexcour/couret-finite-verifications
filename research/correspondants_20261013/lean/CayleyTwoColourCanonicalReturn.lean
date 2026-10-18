import CayleyTwoColourFirstReturn

/-!
COU-20 -- canonical order-three return in the odd cyclic quotient.
Research source, **UNCOMPILED** with pinned Lean 4.29.1.
No existing certified theorem has been modified.

The first lemma needs only the order of alpha and a bounded coordinate,
and is independent of any representation of a directed graph. The last
lemma translates its canonical witness back to the quotient G/<h>.
-/

set_option autoImplicit false
noncomputable section

namespace Couret.CayleyCanonical

/-- For alpha of order 3*ell, a nonzero three-torsion element represented
by a bounded natural multiple k<3*ell must equal +/-ell*alpha. -/
theorem canonical_of_bounded_coordinate
    {Q : Type*} [AddCommGroup Q]
    (alpha delta : Q) (ell k : ℕ)
    (hell : 0 < ell)
    (hord : addOrderOf alpha = 3 * ell)
    (hk : k < 3 * ell)
    (hcoordinate : k • alpha = delta)
    (hthree : (3 : ℕ) • delta = 0)
    (hne : delta ≠ 0) :
    ell • alpha = delta ∨ ell • alpha = -delta := by
  have hzero : (3 * k) • alpha = 0 := by
    rw [mul_nsmul, hcoordinate, hthree]
  have hdiv : 3 * ell ∣ 3 * k := by
    rw [← hord]
    exact (addOrderOf_dvd_iff_nsmul_eq_zero).mpr hzero
  have hdivell : ell ∣ k := by
    exact (Nat.mul_dvd_mul_iff_left (by decide : 0 < 3)).mp hdiv
  obtain ⟨m, hm⟩ := hdivell
  have hmlt : m < 3 := by
    have hmul : ell * m < ell * 3 := by
      simpa [hm, Nat.mul_comm] using hk
    exact (Nat.mul_lt_mul_left hell).mp hmul
  have hcases : m = 0 ∨ m = 1 ∨ m = 2 := by omega
  rcases hcases with h0 | h1 | h2
  · have hd0 : delta = 0 := by
      have h := hcoordinate
      simp [hm, h0] at h
      exact h.symm
    exact (hne hd0).elim
  · left
    simpa [hm, h1] using hcoordinate
  · right
    have hbeta : (3 : ℕ) • (ell • alpha) = 0 := by
      rw [← mul_nsmul, ← hord]
      exact addOrderOf_nsmul_eq_zero alpha
    have hdouble : (2 : ℕ) • (ell • alpha) = -(ell • alpha) := by
      have hh : (2 : ℕ) • (ell • alpha) + (ell • alpha) = 0 := by
        simpa [three_nsmul, two_nsmul, add_assoc] using hbeta
      exact eq_neg_of_add_eq_zero_left hh
    have hd : delta = -(ell • alpha) := by
      have h := hcoordinate
      rw [hm, h2, mul_nsmul] at h
      exact h.symm.trans hdouble
    simp [hd]

/-- Normalize an arbitrary coordinate modulo 3*ell using the group
element's additive order. The return conclusion is unchanged. -/
theorem canonical_of_natural_coordinate
    {Q : Type*} [AddCommGroup Q]
    (alpha delta : Q) (ell n : ℕ)
    (hell : 0 < ell)
    (hord : addOrderOf alpha = 3 * ell)
    (hcoordinate : n • alpha = delta)
    (hthree : (3 : ℕ) • delta = 0)
    (hne : delta ≠ 0) :
    ell • alpha = delta ∨ ell • alpha = -delta := by
  let k := n % (3 * ell)
  have hpositive : 0 < 3 * ell := by omega
  have hk : k < 3 * ell := Nat.mod_lt _ hpositive
  have hcoordinate' : k • alpha = delta := by
    dsimp [k]
    calc
      (n % (3 * ell)) • alpha =
          (n % addOrderOf alpha) • alpha := by rw [hord]
      _ = n • alpha := mod_addOrderOf_nsmul alpha n
      _ = delta := hcoordinate
  exact canonical_of_bounded_coordinate alpha delta ell k
    hell hord hk hcoordinate' hthree hne

/-- In an odd cyclic group, any element of exact order 3 is one of
the two nonzero third-period multiples of the specified generator.
Unlike an abstract existential odd witness, this identifies the
*canonical* exponent ell, independent of the element delta. -/
theorem canonical_of_odd_cyclic
    {Q : Type*} [AddCommGroup Q] [Finite Q]
    (alpha delta : Q) (ell : ℕ)
    (hgen : AddSubgroup.zmultiples alpha = ⊤)
    (hodd : Odd (Nat.card Q))
    (hell : 0 < ell)
    (hord : addOrderOf alpha = 3 * ell)
    (hdorder : addOrderOf delta = 3) :
    ell • alpha = delta ∨ ell • alpha = -delta := by
  have hthree : (3 : ℕ) • delta = 0 := by
    simpa [hdorder] using addOrderOf_nsmul_eq_zero delta
  have hne : delta ≠ 0 := by
    intro hz
    have ho : addOrderOf delta = 1 := by simp [hz]
    omega
  obtain ⟨n, _, hn | hn⟩ :=
    Couret.CayleyNecessity.odd_multiple_or_neg_of_cyclic
      alpha delta hgen hodd
  · exact canonical_of_natural_coordinate alpha delta ell n
      hell hord hn hthree hne
  · have hthreeNeg : (3 : ℕ) • (-delta) = 0 := by
      simpa only [nsmul_neg, neg_zero] using congrArg Neg.neg hthree
    have hneNeg : -delta ≠ 0 := neg_ne_zero.mpr hne
    rcases canonical_of_natural_coordinate alpha (-delta) ell n
        hell hord hn hthreeNeg hneNeg with hneg | hpos
    · exact Or.inr hneg
    · exact Or.inl (by simpa only [neg_neg] using hpos)

end Couret.CayleyCanonical

namespace Couret.CayleyDoublet

open Couret.CayleyCanonical

variable {G : Type*} [AddCommGroup G] [DecidableEq G] [Fintype G]

/-- Canonical witness modulo H; keeps the original group hypotheses and
the quotient's exact size 3*ell explicit. The independent arithmetic
obligations 3|card Q and odd ell can later discharge hcard and hell. -/
theorem abelianThree_canonical_odd_quotient_return
    (a d h : G) (ell : ℕ)
    (hpair : AddSubgroup.closure ({a, h} : Set G) = ⊤)
    (hodd : Odd (Nat.card (G ⧸ AddSubgroup.zmultiples h)))
    (hell : 0 < ell)
    (hsize : Nat.card (G ⧸ AddSubgroup.zmultiples h) = 3 * ell)
    (hdorder : addOrderOf (d : G ⧸ AddSubgroup.zmultiples h) = 3) :
    (ell • a + d ∈ AddSubgroup.zmultiples h ∨
     ell • a - d ∈ AddSubgroup.zmultiples h) := by
  classical
  let H : AddSubgroup G := AddSubgroup.zmultiples h
  have hgen : AddSubgroup.zmultiples (a : G ⧸ H) = ⊤ :=
    abelian_quotient_zmultiples_generator_of_pair a h hpair
  have hord : addOrderOf (a : G ⧸ H) = 3 * ell := by
    rw [quotient_alpha_order_of_pair_generation a h hpair, hsize]
  rcases canonical_of_odd_cyclic (a : G ⧸ H) (d : G ⧸ H) ell
      hgen hodd hell hord hdorder with hplus | hminus
  · right
    apply (QuotientAddGroup.eq_zero_iff (ell • a - d)).mp
    change ell • (a : G ⧸ H) - (d : G ⧸ H) = 0
    rw [hplus]
    exact sub_self _
  · left
    apply (QuotientAddGroup.eq_zero_iff (ell • a + d)).mp
    change ell • (a : G ⧸ H) + (d : G ⧸ H) = 0
    rw [hminus]
    exact neg_add_cancel _

end Couret.CayleyDoublet

#print axioms Couret.CayleyCanonical.canonical_of_bounded_coordinate
#print axioms Couret.CayleyCanonical.canonical_of_natural_coordinate
#print axioms Couret.CayleyCanonical.canonical_of_odd_cyclic
#print axioms Couret.CayleyDoublet.abelianThree_canonical_odd_quotient_return
