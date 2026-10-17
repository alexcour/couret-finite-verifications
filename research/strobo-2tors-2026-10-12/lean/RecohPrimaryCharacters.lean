import Mathlib.Algebra.Module.ZMod
import Mathlib.Analysis.SpecialFunctions.Complex.CircleAddChar
import Mathlib.Data.Nat.Factorization.Basic
import Mathlib.FieldTheory.Finiteness
import Mathlib.GroupTheory.FiniteAbelian.Duality

set_option autoImplicit false

/-!
Primary complex character banks for finite abelian groups.

The construction takes coordinates on the subgroup killed by a prime p,
extends their standard complex characters to G, then raises each extension
to the factor of |G| coprime to p.  This gives p-primary characters without
assuming that G itself has exponent p.  All existence statements below are
proved from group structure and cardinality; separation is a conclusion.
-/

namespace Couret.STROBO2TORS

variable {G : Type*} [AddCommGroup G]

/-- The subgroup of elements killed by `p`; for prime `p` this is `G[p]`. -/
def recohTorsionSubgroup (p : ℕ) : AddSubgroup G where
  carrier := {x | p • x = 0}
  zero_mem' := by simp
  add_mem' := by
    intro x y hx hy
    change p • x = 0 at hx
    change p • y = 0 at hy
    change p • (x + y) = 0
    rw [nsmul_add, hx, hy, add_zero]
  neg_mem' := by
    intro x hx
    change p • x = 0 at hx
    change p • (-x) = 0
    rw [smul_neg, hx, neg_zero]

@[simp]
theorem recoh_mem_torsion_subgroup (p : ℕ) (x : G) :
    x ∈ recohTorsionSubgroup (G := G) p ↔ p • x = 0 := Iff.rfl

/-- The subgroup is itself killed by `p`. -/
theorem recoh_torsion_subgroup_nsmul (p : ℕ)
    (x : recohTorsionSubgroup (G := G) p) : p • x = 0 :=
  Subtype.ext x.property

/-- An elementary abelian group of cardinality `p^r` has `r` coordinates
over `ZMod p`; its module structure is constructed from the exponent. -/
theorem recoh_prime_coordinates_of_card
    {H : Type*} [AddCommGroup H] [Fintype H]
    (p r : ℕ) [Fact p.Prime]
    (hpH : ∀ x : H, p • x = 0)
    (hcard : Fintype.card H = p ^ r) :
    Nonempty (H ≃+ (Fin r → ZMod p)) := by
  classical
  letI : Module (ZMod p) H := AddCommGroup.zmodModule (n := p) hpH
  have hdim : Module.finrank (ZMod p) H = r := by
    apply Nat.pow_right_injective (Fact.out : p.Prime).two_le
    calc
      p ^ Module.finrank (ZMod p) H = Fintype.card H := by
        simpa only [ZMod.card] using
          (Module.card_eq_pow_finrank (K := ZMod p) (V := H)).symm
      _ = p ^ r := hcard
  exact ⟨(Module.finBasisOfFinrankEq (ZMod p) H hdim).equivFun.toAddEquiv⟩

variable [Fintype G]

/-- Every complex character of an additive subgroup extends to the finite
abelian ambient group. -/
theorem recoh_complex_character_extension
    (A : AddSubgroup G) (χ : AddChar A ℂ) :
    ∃ ψ : AddChar G ℂ, ∀ a : A, ψ (a : G) = χ a := by
  classical
  let f : A.toSubgroup →* ℂ :=
    { toFun := fun a => χ ⟨Multiplicative.toAdd a.val, a.property⟩
      map_one' := χ.map_zero_eq_one
      map_mul' := fun a b => χ.map_add_eq_mul _ _ }
  obtain ⟨ψ, hψ⟩ :=
    (MonoidHom.restrict_surjective (M := ℂ) A.toSubgroup) f.toHomUnits
  refine ⟨AddChar.toMonoidHomEquiv.symm ((Units.coeHom ℂ).comp ψ), ?_⟩
  intro a
  exact congrArg (fun z : ℂˣ => (z : ℂ))
    (DFunLike.congr_fun hψ
      (⟨Multiplicative.ofAdd (a : G), a.property⟩ : A.toSubgroup))

/-- Coprime powers can both equal one only at one. -/
theorem recoh_eq_one_of_coprime_powers
    {M : Type*} [Monoid M] (z : M) (p q : ℕ)
    (hpq : Nat.Coprime p q) (hp : z ^ p = 1) (hq : z ^ q = 1) :
    z = 1 := by
  apply orderOf_eq_one_iff.mp
  apply Nat.dvd_one.mp
  rw [← hpq.gcd_eq_one]
  exact Nat.dvd_gcd (orderOf_dvd_of_pow_eq_one hp)
    (orderOf_dvd_of_pow_eq_one hq)

/-- Raising a character to the prime-to-`p` cofactor of `|G|` makes
every value a root of unity of uniformly bounded `p`-power order. -/
theorem recoh_character_primary_projection_pow
    (p : ℕ) (χ : AddChar G ℂ) (x : G) :
    ((χ ^ (Fintype.card G / p ^ (Fintype.card G).factorization p)) x) ^
      (p ^ (Fintype.card G).factorization p) = 1 := by
  rw [AddChar.pow_apply, ← pow_mul, Nat.mul_comm,
    Nat.ordProj_mul_ordCompl_eq_self]
  rw [← χ.map_nsmul_eq_pow, card_nsmul_eq_zero, χ.map_zero_eq_one]

/-- A bank of `r` primary characters separates an elementary abelian
subgroup of cardinality `p^r`.  The ambient group may have higher
`p`-power torsion and arbitrary other primary factors. -/
theorem recoh_primary_characters_of_subgroup_card
    (p r : ℕ) [Fact p.Prime] (A : AddSubgroup G)
    (hpA : ∀ a : A, p • a = 0)
    (hcard : Nat.card A = p ^ r) :
    ∃ bank : Fin r → AddChar G ℂ,
      (∀ i x, (bank i x) ^ (p ^ (Fintype.card G).factorization p) = 1) ∧
      (∀ a : A, (∀ i, bank i (a : G) = 1) → a = 0) := by
  classical
  letI : Fintype A := Fintype.ofFinite A
  have hcard' : Fintype.card A = p ^ r := by
    simpa only [Nat.card_eq_fintype_card] using hcard
  obtain ⟨e⟩ := recoh_prime_coordinates_of_card p r hpA hcard'
  let coord : Fin r → A →+ ZMod p := fun i =>
    { toFun := fun a => e a i
      map_zero' := by simp
      map_add' := fun a b => by simp }
  let restriction : Fin r → AddChar A ℂ := fun i =>
    ZMod.stdAddChar.compAddMonoidHom (coord i)
  choose χ hχ using fun i : Fin r =>
    recoh_complex_character_extension A (restriction i)
  let q : ℕ := Fintype.card G / p ^ (Fintype.card G).factorization p
  let bank : Fin r → AddChar G ℂ := fun i => χ i ^ q
  refine ⟨bank, ?_, ?_⟩
  · intro i x
    exact recoh_character_primary_projection_pow p (χ i) x
  · intro a ha
    apply e.injective
    funext i
    have hpa : p • (a : G) = 0 := congrArg (fun y : A => (y : G)) (hpA a)
    have hχp : (χ i (a : G)) ^ p = 1 := by
      rw [← (χ i).map_nsmul_eq_pow, hpa, (χ i).map_zero_eq_one]
    have hχq : (χ i (a : G)) ^ q = 1 := by
      exact ha i
    have hχone : χ i (a : G) = 1 :=
      recoh_eq_one_of_coprime_powers _ p q
        (Nat.coprime_ordCompl (Fact.out : p.Prime) Fintype.card_ne_zero)
        hχp hχq
    have hstd : ZMod.stdAddChar (e a i) = 1 := (hχ i a).symm.trans hχone
    have hcoord : e a i = 0 := ZMod.injective_stdAddChar
      (hstd.trans (ZMod.stdAddChar (N := p)).map_zero_eq_one.symm)
    simpa only [map_zero, Pi.zero_apply] using hcoord

/-- The primary bank exists for the actual subgroup `G[p]`, with no
separation or extension hypotheses. -/
theorem recoh_primary_characters_of_card
    (p r : ℕ) [Fact p.Prime]
    (hcard : Nat.card (recohTorsionSubgroup (G := G) p) = p ^ r) :
    ∃ bank : Fin r → AddChar G ℂ,
      (∀ i x, (bank i x) ^ (p ^ (Fintype.card G).factorization p) = 1) ∧
      (∀ x : G, p • x = 0 → (∀ i, bank i x = 1) → x = 0) := by
  obtain ⟨bank, hprimary, hsep⟩ :=
    recoh_primary_characters_of_subgroup_card p r
      (recohTorsionSubgroup (G := G) p)
      (recoh_torsion_subgroup_nsmul p) hcard
  refine ⟨bank, hprimary, ?_⟩
  intro x hx hbank
  exact congrArg (fun a : recohTorsionSubgroup (G := G) p => (a : G))
    (hsep ⟨x, hx⟩ hbank)

omit [Fintype G] in
/-- A `p`-primary complex character vanishes on torsion of order coprime
to `p`, in the multiplicative sense of having value one. -/
theorem recoh_primary_character_trivial_of_coprime
    (p q n : ℕ) (hpq : Nat.Coprime p q) (χ : AddChar G ℂ)
    (hprimary : ∀ x, (χ x) ^ (p ^ n) = 1)
    (x : G) (hx : q • x = 0) : χ x = 1 := by
  apply recoh_eq_one_of_coprime_powers (χ x) (p ^ n) q
    (hpq.pow_left n) (hprimary x)
  rw [← χ.map_nsmul_eq_pow, hx, χ.map_zero_eq_one]

/-- The binary primary bank in the format used by the reconstruction
criterion.  Higher-order characters are allowed and may be necessary. -/
theorem recoh_two_primary_characters_of_card
    (r : ℕ)
    (hcard : Nat.card (recohTorsionSubgroup (G := G) 2) = 2 ^ r) :
    ∃ bank : Fin r → AddChar G ℂ,
      (∀ i x, ∃ n : ℕ, (bank i x) ^ (2 ^ n) = 1) ∧
      (∀ x : G, x + x = 0 → (∀ i, bank i x = 1) → x = 0) := by
  obtain ⟨bank, hprimary, hsep⟩ := recoh_primary_characters_of_card 2 r hcard
  refine ⟨bank, ?_, ?_⟩
  · intro i x
    exact ⟨(Fintype.card G).factorization 2, hprimary i x⟩
  · intro x hx hbank
    exact hsep x (by simpa only [two_nsmul] using hx) hbank

/-- The ternary primary bank separates `G[3]` and is trivial on `G[2]`.
Both properties are consequences of the constructed characters. -/
theorem recoh_three_primary_characters_of_card
    (s : ℕ)
    (hcard : Nat.card (recohTorsionSubgroup (G := G) 3) = 3 ^ s) :
    ∃ bank : Fin s → AddChar G ℂ,
      (∀ i x, ∃ n : ℕ, (bank i x) ^ (3 ^ n) = 1) ∧
      (∀ i x, x + x = 0 → bank i x = 1) ∧
      (∀ x : G, (x + x) + x = 0 → (∀ i, bank i x = 1) → x = 0) := by
  obtain ⟨bank, hprimary, hsep⟩ := recoh_primary_characters_of_card 3 s hcard
  refine ⟨bank, ?_, ?_, ?_⟩
  · intro i x
    exact ⟨(Fintype.card G).factorization 3, hprimary i x⟩
  · intro i x hx
    exact recoh_primary_character_trivial_of_coprime 3 2
      ((Fintype.card G).factorization 3) (by decide) (bank i) (hprimary i) x
      (by simpa only [two_nsmul] using hx)
  · intro x hx hbank
    exact hsep x (by simpa only [succ_nsmul, zero_nsmul, zero_add] using hx) hbank

end Couret.STROBO2TORS

#print axioms Couret.STROBO2TORS.recoh_mem_torsion_subgroup
#print axioms Couret.STROBO2TORS.recoh_torsion_subgroup_nsmul
#print axioms Couret.STROBO2TORS.recoh_prime_coordinates_of_card
#print axioms Couret.STROBO2TORS.recoh_complex_character_extension
#print axioms Couret.STROBO2TORS.recoh_eq_one_of_coprime_powers
#print axioms Couret.STROBO2TORS.recoh_character_primary_projection_pow
#print axioms Couret.STROBO2TORS.recoh_primary_characters_of_subgroup_card
#print axioms Couret.STROBO2TORS.recoh_primary_characters_of_card
#print axioms Couret.STROBO2TORS.recoh_primary_character_trivial_of_coprime
#print axioms Couret.STROBO2TORS.recoh_two_primary_characters_of_card
#print axioms Couret.STROBO2TORS.recoh_three_primary_characters_of_card
