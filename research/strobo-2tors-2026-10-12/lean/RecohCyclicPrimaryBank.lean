import RecohOptimalBank
import RecohSignRecovery
import RecohCyclicCoordinates
import Mathlib.Data.Multiset.Sort
import Mathlib.GroupTheory.SpecificGroups.Cyclic
import Mathlib.RingTheory.RootsOfUnity.Complex

set_option autoImplicit false

/-!
Coordinate primary characters and executable exponent encodings for finite
products of cyclic groups. The encoding sorts the multiset of coordinate
values, so multiplicities are retained and no enumeration of the ambient
group is used. Complex roots and characters are semantic objects; exponent
lists and primary-factor data are the inputs used by the exact backend.
-/

namespace Couret.STROBO2TORS

/-- The canonical complex root used to interpret a cyclic coordinate. -/
noncomputable def recohCyclicRoot (N : ℕ) [NeZero N] : ℂ :=
  ZMod.stdAddChar (1 : ZMod N)

theorem recoh_cyclic_root_primitive (N : ℕ) [NeZero N] :
    IsPrimitiveRoot (recohCyclicRoot N) N := by
  have he : recohCyclicRoot N = Complex.exp (2 * Real.pi * Complex.I / N) := by
    simpa only [recohCyclicRoot, Int.cast_one, mul_one] using
      (ZMod.stdAddChar_coe (N := N) (1 : ℤ))
  rw [he]
  exact Complex.isPrimitiveRoot_exp N (NeZero.ne N)

variable {d : ℕ} (q : Fin d → ℕ) [∀ i, NeZero (q i)]

/-- Reduce one actual cyclic coordinate modulo a divisor of its modulus. -/
def recohCyclicCoordinateReduction (i : Fin d) (N : ℕ) (hN : N ∣ q i) :
    ((j : Fin d) → ZMod (q j)) →+ ZMod N where
  toFun := fun x => ZMod.castHom hN (ZMod N) (x i)
  map_zero' := by simp
  map_add' := by
    intro x y
    exact (ZMod.castHom hN (ZMod N)).map_add (x i) (y i)

/-- The labelled coordinate character, of order dividing `N`. -/
noncomputable def recohCyclicCoordinateCharacter
    (i : Fin d) (N : ℕ) [NeZero N] (hN : N ∣ q i) :
    AddChar ((j : Fin d) → ZMod (q j)) ℂ :=
  (ZMod.stdAddChar (N := N)).compAddMonoidHom
    (recohCyclicCoordinateReduction q i N hN)

theorem recoh_cyclic_coordinate_character_apply
    (i : Fin d) (N : ℕ) [NeZero N] (hN : N ∣ q i)
    (x : (j : Fin d) → ZMod (q j)) :
    recohCyclicCoordinateCharacter q i N hN x =
      recohCyclicRoot N ^ (x i).val := by
  change ZMod.stdAddChar (ZMod.castHom hN (ZMod N) (x i)) = _
  rw [ZMod.castHom_apply, ZMod.cast_eq_val]
  have h := (ZMod.stdAddChar (N := N)).map_nsmul_eq_pow (x i).val (1 : ZMod N)
  simpa only [nsmul_one, recohCyclicRoot] using h

theorem recoh_cyclic_coordinate_character_pow
    (i : Fin d) (N : ℕ) [NeZero N] (hN : N ∣ q i)
    (x : (j : Fin d) → ZMod (q j)) :
    (recohCyclicCoordinateCharacter q i N hN x) ^ N = 1 := by
  rw [recoh_cyclic_coordinate_character_apply, ← pow_mul, Nat.mul_comm, pow_mul,
    (recoh_cyclic_root_primitive N).pow_eq_one, one_pow]

/-- Sorted coordinate values, with one entry for every point of `S`.
The map is on multisets, not on finite sets: repeated exponents are kept. -/
def recohCyclicExponents (i : Fin d)
    (S : Finset ((j : Fin d) → ZMod (q j))) : List ℕ :=
  (S.val.map (fun x => (x i).val)).sort (· ≤ ·)

omit [∀ i, NeZero (q i)] in
theorem recoh_cyclic_exponents_length (i : Fin d)
    (S : Finset ((j : Fin d) → ZMod (q j))) :
    (recohCyclicExponents q i S).length = S.card := by
  simp only [recohCyclicExponents, Multiset.length_sort, Multiset.card_map]
  rfl

theorem recoh_cyclic_exponents_interpret
    (i : Fin d) (N : ℕ) [NeZero N] (hN : N ∣ q i)
    (S : Finset ((j : Fin d) → ZMod (q j))) :
    ((recohCyclicExponents q i S).map (recohCyclicRoot N ^ ·)).sum =
      recohSupportProbe (recohCyclicCoordinateCharacter q i N hN) S := by
  have hm :
      (↑((recohCyclicExponents q i S).map (recohCyclicRoot N ^ ·)) : Multiset ℂ) =
        S.val.map (fun x => recohCyclicRoot N ^ (x i).val) := by
    rw [← Multiset.map_coe, recohCyclicExponents, Multiset.sort_eq,
      Multiset.map_map]
    rfl
  have hs := congrArg Multiset.sum hm
  simpa only [Multiset.sum_coe, recohSupportProbe, Finset.sum,
    recoh_cyclic_coordinate_character_apply] using hs

theorem recoh_cyclic_exponents_lt (i : Fin d)
    (S : Finset ((j : Fin d) → ZMod (q j))) (n : ℕ)
    (hn : n ∈ recohCyclicExponents q i S) : n < q i := by
  have hm : n ∈ S.val.map (fun x => (x i).val) := by
    simpa only [recohCyclicExponents, Multiset.mem_sort] using hn
  obtain ⟨x, _, rfl⟩ := Multiset.mem_map.mp hm
  exact ZMod.val_lt (x i)

/-- The labelled factors whose moduli are divisible by the chosen prime. -/
abbrev RecohPrimaryCoordinate (p : ℕ) := {i : Fin d // p ∣ q i}

/-- Supplied prime-power/cofactor data. These arithmetic hypotheses, rather
than an abstract character or encoding contract, tie the bank to `q`. -/
structure RecohPrimaryFactorData (p : ℕ) where
  exponent : RecohPrimaryCoordinate q p → ℕ
  cofactor : RecohPrimaryCoordinate q p → ℕ
  factor : ∀ i, q i.val = p ^ (exponent i + 1) * cofactor i
  coprime : ∀ i, Nat.Coprime p (cofactor i)

omit [∀ i, NeZero (q i)] in
theorem recoh_primary_factor_dvd (p : ℕ) (data : RecohPrimaryFactorData q p)
    (i : RecohPrimaryCoordinate q p) : p ^ (data.exponent i + 1) ∣ q i.val := by
  rw [data.factor i]
  exact dvd_mul_right _ _

/-- A coordinate prime-power bank, without an abstract extension choice. -/
noncomputable def recohCyclicPrimaryBank (p : ℕ) [Fact p.Prime]
    (data : RecohPrimaryFactorData q p)
    (i : RecohPrimaryCoordinate q p) :
    AddChar ((j : Fin d) → ZMod (q j)) ℂ := by
  letI : NeZero (p ^ (data.exponent i + 1)) :=
    ⟨pow_ne_zero _ (Fact.out : p.Prime).ne_zero⟩
  exact recohCyclicCoordinateCharacter q i.val (p ^ (data.exponent i + 1))
    (recoh_primary_factor_dvd q p data i)

theorem recoh_cyclic_primary_bank_pow (p : ℕ) [Fact p.Prime]
    (data : RecohPrimaryFactorData q p) (i : RecohPrimaryCoordinate q p)
    (x : (j : Fin d) → ZMod (q j)) :
    (recohCyclicPrimaryBank q p data i x) ^ (p ^ (data.exponent i + 1)) = 1 := by
  exact recoh_cyclic_coordinate_character_pow q i.val _ _ x

theorem recoh_cyclic_primary_bank_interpret (p : ℕ) [Fact p.Prime]
    (data : RecohPrimaryFactorData q p) (i : RecohPrimaryCoordinate q p)
    (S : Finset ((j : Fin d) → ZMod (q j))) :
    letI : NeZero (p ^ (data.exponent i + 1)) :=
      ⟨pow_ne_zero _ (Fact.out : p.Prime).ne_zero⟩
    ((recohCyclicExponents q i.val S).map
      (recohCyclicRoot (p ^ (data.exponent i + 1)) ^ ·)).sum =
      recohSupportProbe (recohCyclicPrimaryBank q p data i) S := by
  exact recoh_cyclic_exponents_interpret q i.val _ _ S

theorem recoh_cyclic_binary_probe_nonzero
    (data : RecohPrimaryFactorData q 2) (i : RecohPrimaryCoordinate q 2)
    (S : Finset ((j : Fin d) → ZMod (q j))) (hS : S.card = 3) :
    recohSupportProbe (recohCyclicPrimaryBank q 2 data i) S ≠ 0 := by
  apply recoh_two_primary_support_probe_nonzero _ _ S hS
  intro x
  exact ⟨data.exponent i + 1, recoh_cyclic_primary_bank_pow q 2 data i x⟩

/-- The arithmetic data can themselves be computed from the natural
moduli. The factorization algorithm need not be the Python division loop. -/
def recohCanonicalPrimaryData (p : ℕ) [Fact p.Prime] :
    RecohPrimaryFactorData q p where
  exponent i := (q i.val).factorization p - 1
  cofactor i := q i.val / p ^ (q i.val).factorization p
  factor i := by
    have hpos := (Fact.out : p.Prime).factorization_pos_of_dvd
      (NeZero.ne (q i.val)) i.property
    rw [Nat.sub_add_cancel (Nat.succ_le_of_lt hpos)]
    exact (Nat.ordProj_mul_ordCompl_eq_self (q i.val) p).symm
  coprime i := Nat.coprime_ordCompl (Fact.out : p.Prime) (NeZero.ne (q i.val))

theorem recoh_canonical_primary_exponent_succ (p : ℕ) [Fact p.Prime]
    (i : RecohPrimaryCoordinate q p) :
    (recohCanonicalPrimaryData q p).exponent i + 1 = (q i.val).factorization p := by
  exact Nat.sub_add_cancel (Nat.succ_le_of_lt
    ((Fact.out : p.Prime).factorization_pos_of_dvd (NeZero.ne (q i.val)) i.property))

/-- A zero `p`-multiple gives the corresponding natural divisibility. -/
theorem recoh_cyclic_nsmul_zero_dvd (p n : ℕ) [NeZero n]
    (x : ZMod n) (hx : p • x = 0) : n ∣ p * x.val := by
  apply (ZMod.natCast_eq_zero_iff (p * x.val) n).mp
  simpa only [Nat.cast_mul, ZMod.natCast_zmod_val, nsmul_eq_mul] using hx

/-- On `p`-torsion a full `p`-primary coordinate character has trivial
kernel, although it may have a nontrivial kernel on the full cyclic group. -/
theorem recoh_cyclic_primary_coordinate_kernel (p : ℕ) [Fact p.Prime]
    (data : RecohPrimaryFactorData q p) (i : RecohPrimaryCoordinate q p)
    (x : (j : Fin d) → ZMod (q j)) (hx : p • x i.val = 0) :
    recohCyclicPrimaryBank q p data i x = 1 ↔ x i.val = 0 := by
  let N := p ^ (data.exponent i + 1)
  letI : NeZero N := ⟨pow_ne_zero _ (Fact.out : p.Prime).ne_zero⟩
  change recohCyclicCoordinateCharacter q i.val N _ x = 1 ↔ _
  rw [recoh_cyclic_coordinate_character_apply,
    (recoh_cyclic_root_primitive N).pow_eq_one_iff_dvd]
  constructor
  · intro hN
    have hq := recoh_cyclic_nsmul_zero_dvd p (q i.val) (x i.val) hx
    have hc : data.cofactor i ∣ p * (x i.val).val := by
      apply dvd_trans (show data.cofactor i ∣ q i.val from ?_) hq
      rw [data.factor i]
      exact dvd_mul_left _ _
    have hc' : data.cofactor i ∣ (x i.val).val :=
      (data.coprime i).symm.dvd_of_dvd_mul_left hc
    have hq' : q i.val ∣ (x i.val).val := by
      have hprod := ((data.coprime i).pow_left (data.exponent i + 1)).mul_dvd_of_dvd_of_dvd hN hc'
      exact dvd_trans (dvd_of_eq (data.factor i)) hprod
    exact (ZMod.natCast_zmod_val (x i.val)).symm.trans
      ((ZMod.natCast_eq_zero_iff _ _).mpr hq')
  · intro hzero
    simp only [hzero, ZMod.val_zero, dvd_zero]

/-- A coordinate with modulus coprime to `p` has no nonzero `p`-torsion. -/
theorem recoh_cyclic_torsion_zero_of_coprime (p n : ℕ) [NeZero n]
    (hcop : Nat.Coprime p n) (x : ZMod n) (hx : p • x = 0) : x = 0 := by
  have hn : n ∣ x.val := hcop.symm.dvd_of_dvd_mul_left
    (recoh_cyclic_nsmul_zero_dvd p n x hx)
  exact (ZMod.natCast_zmod_val x).symm.trans
    ((ZMod.natCast_eq_zero_iff _ _).mpr hn)

/-- The bank has one labelled slot for every factor divisible by `p`, and
these slots separate the actual subgroup killed by `p`. -/
theorem recoh_cyclic_primary_bank_separates (p : ℕ) [Fact p.Prime]
    (data : RecohPrimaryFactorData q p)
    (x : (j : Fin d) → ZMod (q j)) (hx : p • x = 0)
    (hbank : ∀ i, recohCyclicPrimaryBank q p data i x = 1) : x = 0 := by
  funext i
  have hxi : p • x i = 0 := by
    simpa only [Pi.smul_apply, Pi.zero_apply] using congrFun hx i
  by_cases hi : p ∣ q i
  · exact (recoh_cyclic_primary_coordinate_kernel q p data ⟨i, hi⟩ x hxi).mp
      (hbank ⟨i, hi⟩)
  · exact recoh_cyclic_torsion_zero_of_coprime p (q i)
      ((Fact.out : p.Prime).coprime_iff_not_dvd.mpr hi) (x i) hxi

/-- The coordinate bank agrees with the explicitly computed binary
equivalence, so the recovery compatibility contract is discharged. -/
theorem recoh_cyclic_binary_bank_sign_coordinates
    (data : RecohPrimaryFactorData q 2)
    (u : recohTorsionSubgroup (G := (j : Fin d) → ZMod (q j)) 2)
    (i : RecohEvenCoordinate q) :
    recohCyclicPrimaryBank q 2 data i u.val =
      if recohProductTwoCoordinates q u i = 0 then 1 else -1 := by
  have hui : 2 • u.val i.val = 0 := by
    simpa only [Pi.smul_apply, Pi.zero_apply] using congrFun u.property i.val
  have hker := recoh_cyclic_primary_coordinate_kernel q 2 data i u.val hui
  by_cases hbit : recohProductTwoCoordinates q u i = 0
  · rw [if_pos hbit]
    exact hker.mpr ((recoh_product_two_coordinates_eq_zero_iff q u i).mp hbit)
  · rw [if_neg hbit]
    have hne : recohCyclicPrimaryBank q 2 data i u.val ≠ 1 := by
      intro hone
      exact hbit ((recoh_product_two_coordinates_eq_zero_iff q u i).mpr (hker.mp hone))
    have htwo : (recohCyclicPrimaryBank q 2 data i u.val) ^ 2 = 1 := by
      rw [← AddChar.map_nsmul_eq_pow, u.property, AddChar.map_zero_eq_one]
    exact (sq_eq_one_iff.mp htwo).resolve_left hne

/-- The ternary coordinate bank is trivial on all two-torsion. -/
theorem recoh_cyclic_ternary_bank_trivial_on_two
    (data : RecohPrimaryFactorData q 3) (i : RecohPrimaryCoordinate q 3)
    (u : (j : Fin d) → ZMod (q j)) (hu : u + u = 0) :
    recohCyclicPrimaryBank q 3 data i u = 1 := by
  apply recoh_primary_character_trivial_of_coprime 3 2 (data.exponent i + 1)
    (by decide) (recohCyclicPrimaryBank q 3 data i)
  · exact recoh_cyclic_primary_bank_pow q 3 data i
  · simpa only [two_nsmul] using hu

/-- The explicit binary and ternary coordinate bank reconstructs triples.
No abstract separation, nonvanishing or encoding hypothesis is needed. -/
theorem recoh_cyclic_primary_observation_injective
    (data2 : RecohPrimaryFactorData q 2) (data3 : RecohPrimaryFactorData q 3) :
    Function.Injective (fun S : {S : Finset ((j : Fin d) → ZMod (q j)) // S.card = 3} =>
      recohObservation
        (Sum.elim (recohCyclicPrimaryBank q 2 data2) (recohCyclicPrimaryBank q 3 data3)) S.1) := by
  apply recoh_observation_injective_of_separating_banks
  · exact recoh_cyclic_binary_probe_nonzero q data2
  · intro u hu hbank
    apply recoh_cyclic_primary_bank_separates q 2 data2 u _ hbank
    simpa only [two_nsmul] using hu
  · exact recoh_cyclic_ternary_bank_trivial_on_two q data3
  · intro v hv hbank
    apply recoh_cyclic_primary_bank_separates q 3 data3 v _ hbank
    simpa only [succ_nsmul, zero_nsmul, zero_add] using hv

omit [∀ i, NeZero (q i)] in
/-- Torsion in a product is exactly the product of coordinate torsions.
This equivalence is given by coordinate projections and assembly. -/
def recohProductTorsionEquiv (p : ℕ) :
    recohTorsionSubgroup (G := (i : Fin d) → ZMod (q i)) p ≃
      ((i : Fin d) → recohTorsionSubgroup (G := ZMod (q i)) p) where
  toFun x i := ⟨x.val i, by
    simpa only [Pi.smul_apply, Pi.zero_apply] using congrFun x.property i⟩
  invFun x := ⟨fun i => (x i).val, by
    funext i
    exact (x i).property⟩
  left_inv x := by apply Subtype.ext; rfl
  right_inv x := by funext i; apply Subtype.ext; rfl

/-- A cyclic group has `gcd(n,p)` elements killed by `p`. -/
theorem recoh_cyclic_torsion_card (n p : ℕ) [NeZero n] :
    Nat.card (recohTorsionSubgroup (G := ZMod n) p) = n.gcd p := by
  change Nat.card (nsmulAddMonoidHom p : ZMod n →+ ZMod n).ker = _
  simpa only [Nat.card_eq_fintype_card, ZMod.card] using
    IsAddCyclic.card_nsmulAddMonoidHom_ker (ZMod n) p

/-- The actual `p`-torsion rank is the number of cyclic factors divisible
by `p`; no rank or cardinality hypothesis is supplied to this theorem. -/
theorem recoh_cyclic_product_torsion_card (p : ℕ) [Fact p.Prime] :
    Nat.card (recohTorsionSubgroup (G := (i : Fin d) → ZMod (q i)) p) =
      p ^ Fintype.card (RecohPrimaryCoordinate q p) := by
  rw [Nat.card_congr (recohProductTorsionEquiv q p), Nat.card_pi]
  simp_rw [recoh_cyclic_torsion_card]
  have hgcd : ∀ i : Fin d, (q i).gcd p = if p ∣ q i then p else 1 := by
    intro i
    by_cases hi : p ∣ q i
    · simpa only [if_pos hi] using (Nat.gcd_eq_right_iff_dvd.mpr hi)
    · rw [if_neg hi, Nat.gcd_comm]
      exact ((Fact.out : p.Prime).coprime_iff_not_dvd.mpr hi).gcd_eq_one
  simp_rw [hgcd]
  simp [Finset.prod_ite, Fintype.card_subtype]

/-- On the branch with an even factor and at least three group elements,
the constructed coordinate bank has exactly the optimal slot count. -/
theorem recoh_cyclic_canonical_bank_optimal
    (heven : ∃ i : Fin d, 2 ∣ q i)
    (hG3 : 3 ≤ Fintype.card ((i : Fin d) → ZMod (q i))) :
    Function.Injective
      (fun S : {S : Finset ((j : Fin d) → ZMod (q j)) // S.card = 3} =>
        recohObservation (Sum.elim
          (recohCyclicPrimaryBank q 2 (recohCanonicalPrimaryData q 2))
          (recohCyclicPrimaryBank q 3 (recohCanonicalPrimaryData q 3))) S.1) ∧
    (∀ k : ℕ,
      k < Fintype.card (RecohPrimaryCoordinate q 2) +
        Fintype.card (RecohPrimaryCoordinate q 3) →
      ∀ bank : Fin k → AddChar ((j : Fin d) → ZMod (q j)) ℂ,
        ¬ Function.Injective
          (fun S : {S : Finset ((j : Fin d) → ZMod (q j)) // S.card = 3} =>
            recohObservation bank S.1)) := by
  refine ⟨recoh_cyclic_primary_observation_injective q
    (recohCanonicalPrimaryData q 2) (recohCanonicalPrimaryData q 3), ?_⟩
  intro k hk bank
  have hr : 0 < Fintype.card (RecohPrimaryCoordinate q 2) := by
    apply Fintype.card_pos_iff.mpr
    obtain ⟨i, hi⟩ := heven
    exact ⟨⟨i, hi⟩⟩
  exact recoh_no_short_reconstructing_bank _ _ k hr hk
    (recoh_cyclic_product_torsion_card q 2)
    (recoh_cyclic_product_torsion_card q 3) hG3 bank

/-- Without an even cyclic factor the labelled square alone is injective
on triple supports, so no ternary slots are necessary. -/
theorem recoh_cyclic_square_injective_of_no_even
    (hodd : ∀ i : Fin d, ¬ 2 ∣ q i) :
    Function.Injective
      (fun S : {S : Finset ((j : Fin d) → ZMod (q j)) // S.card = 3} =>
        orderedSquare S.1) := by
  apply recoh_square_injective_of_trivial_two_torsion
  intro u hu
  apply recoh_cyclic_primary_bank_separates q 2 (recohCanonicalPrimaryData q 2) u
  · simpa only [two_nsmul] using hu
  · intro i
    exact (hodd i.val i.property).elim

end Couret.STROBO2TORS

#print axioms Couret.STROBO2TORS.recoh_cyclic_root_primitive
#print axioms Couret.STROBO2TORS.recoh_cyclic_coordinate_character_apply
#print axioms Couret.STROBO2TORS.recoh_cyclic_coordinate_character_pow
#print axioms Couret.STROBO2TORS.recoh_cyclic_exponents_length
#print axioms Couret.STROBO2TORS.recoh_cyclic_exponents_interpret
#print axioms Couret.STROBO2TORS.recoh_cyclic_exponents_lt
#print axioms Couret.STROBO2TORS.recoh_primary_factor_dvd
#print axioms Couret.STROBO2TORS.recoh_cyclic_primary_bank_pow
#print axioms Couret.STROBO2TORS.recoh_cyclic_primary_bank_interpret
#print axioms Couret.STROBO2TORS.recoh_cyclic_binary_probe_nonzero
#print axioms Couret.STROBO2TORS.recoh_canonical_primary_exponent_succ
#print axioms Couret.STROBO2TORS.recoh_cyclic_nsmul_zero_dvd
#print axioms Couret.STROBO2TORS.recoh_cyclic_primary_coordinate_kernel
#print axioms Couret.STROBO2TORS.recoh_cyclic_torsion_zero_of_coprime
#print axioms Couret.STROBO2TORS.recoh_cyclic_primary_bank_separates
#print axioms Couret.STROBO2TORS.recoh_cyclic_binary_bank_sign_coordinates
#print axioms Couret.STROBO2TORS.recoh_cyclic_ternary_bank_trivial_on_two
#print axioms Couret.STROBO2TORS.recoh_cyclic_primary_observation_injective
#print axioms Couret.STROBO2TORS.recoh_cyclic_torsion_card
#print axioms Couret.STROBO2TORS.recoh_cyclic_product_torsion_card
#print axioms Couret.STROBO2TORS.recoh_cyclic_canonical_bank_optimal
#print axioms Couret.STROBO2TORS.recoh_cyclic_square_injective_of_no_even
