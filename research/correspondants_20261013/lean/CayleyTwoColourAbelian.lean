import CayleyDoubletCore
import CayleyTwoColourFamily

set_option autoImplicit false

/-!
COU-20 — finite abelian two-colour bridge (candidate, 16 Oct 2026).

This is a small proof layer for the generalized exceptional triple pair.
The universal dichotomy ("non-isomorphic iff the singleton step generates
the h-quotient") is NOT a theorem of this file. No release/priority claim.
-/

namespace Couret.CayleyDoublet

section AbelianTwoColour

variable {G : Type*} [AddCommGroup G] [DecidableEq G]

/-- The exceptional pair consists of two triples with shared singleton a. -/
def AbelianSource (a d h : G) : Finset G :=
  TripleSupport a (a + d) h

def AbelianTarget (a d h : G) : Finset G :=
  TripleSupport a (a - d) h

/-- By definition, the source has the expected three generators. -/
theorem abelianSource_members (a d h : G) :
    a ∈ AbelianSource a d h ∧
    a + d ∈ AbelianSource a d h ∧
    (a + d) + h ∈ AbelianSource a d h := by
  simp [AbelianSource, TripleSupport]

/-- Likewise the reflected target triple. -/
theorem abelianTarget_members (a d h : G) :
    a ∈ AbelianTarget a d h ∧
    a - d ∈ AbelianTarget a d h ∧
    (a - d) + h ∈ AbelianTarget a d h := by
  simp [AbelianTarget, TripleSupport]

/-- The marked half-turn exists for the source, without finiteness. -/
theorem abelianSource_halfTurn_isMate
    (a d h : G) (hhalf : h + h = 0) (hne : h ≠ 0) (x : G) :
    IsMate (CayleyArc (AbelianSource a d h)) x (x + h) := by
  exact halfTurn_isMate a (a + d) h hhalf hne x

/-- The marked half-turn exists for the target, without finiteness. -/
theorem abelianTarget_halfTurn_isMate
    (a d h : G) (hhalf : h + h = 0) (hne : h ≠ 0) (x : G) :
    IsMate (CayleyArc (AbelianTarget a d h)) x (x + h) := by
  exact halfTurn_isMate a (a - d) h hhalf hne x

/-- Singleton and doublet membership of the source are intrinsically defined
once the mate x+h is identified. -/
theorem abelianSource_singleton_iff
    (a d h : G) (hhalf : h + h = 0) (hne : h ≠ 0)
    (had : a ≠ a + d) (hadh : a ≠ (a + d) + h)
    (x y : G) :
    SingletonArc (CayleyArc (AbelianSource a d h))
      (fun z => z + h) x y ↔ y = x + a := by
  exact singletonArc_iff_point a (a + d) h hhalf hne had hadh x y

/-- The marked pair of source arcs is exactly the d, d+h pair. -/
theorem abelianSource_doublet_iff
    (a d h : G) (hhalf : h + h = 0) (hne : h ≠ 0)
    (had : a ≠ a + d) (hadh : a ≠ (a + d) + h)
    (x y : G) :
    DoubletArc (CayleyArc (AbelianSource a d h))
      (fun z => z + h) x y ↔
      y = x + (a + d) ∨ y = x + ((a + d) + h) := by
  exact markedArc_iff_pair a (a + d) h hhalf hne had hadh x y


/-- Strengthening of the existing two-colour obstruction: it is enough that
the source doublet increment is a natural iterate of the singleton increment
*modulo the intrinsic half-turn*.  The quotient cyclicity is NOT assumed.

The extra hypotheses are precisely those used by noIso_of_two_colours.
In particular this theorem does not claim that arbitrary abelian Cayley
graphs have intrinsic two-colour structure. -/
theorem noIso_of_two_colours_mod_halfTurn
    (a b c h : G)
    (hhalf : h + h = 0) (hne : h ≠ 0)
    (hab : a ≠ b) (habh : a ≠ b + h)
    (hac : a ≠ c) (hach : a ≠ c + h)
    (hthreeT : (a - c) + (a - c) + (a - c) = 0 ∨
      (a - c) + (a - c) + (a - c) = h)
    (k : ℕ) (hbkm : b = k • a ∨ b + h = k • a)
    (hbc : b ≠ c) (hbch : b ≠ c + h)
    (f : G ≃ G)
    (hf : ∀ x y, CayleyArc (TripleSupport a b h) x y ↔
      CayleyArc (TripleSupport a c h) (f x) (f y)) : False := by
  rcases hbkm with hbk | hbk
  · exact noIso_of_two_colours a b c h hhalf hne
      hab habh hac hach hthreeT k hbk hbc hbch f hf
  · have hh : (b + h) + h = b := by
      calc
        (b + h) + h = b + (h + h) := by abel
        _ = b := by simp [hhalf]
    have hswap : TripleSupport a (b + h) h = TripleSupport a b h := by
      apply Finset.ext
      intro x
      simp only [TripleSupport, Finset.mem_insert, Finset.mem_singleton, hh]
      tauto
    have hab' : a ≠ b + h := habh
    have habh' : a ≠ (b + h) + h := by
      simpa only [hh] using hab
    have hbc' : b + h ≠ c := by
      intro he
      apply hbch
      calc
        b = (b + h) + h := hh.symm
        _ = c + h := by rw [he]
    have hbch' : b + h ≠ c + h := by
      intro he
      apply hbc
      calc
        b = (b + h) + h := hh.symm
        _ = (c + h) + h := by rw [he]
        _ = c := by
          calc
            (c + h) + h = c + (h + h) := by abel
            _ = c := by simp [hhalf]
    have hf' : ∀ x y, CayleyArc (TripleSupport a (b + h) h) x y ↔
        CayleyArc (TripleSupport a c h) (f x) (f y) := by
      intro x y
      rw [hswap]
      exact hf x y
    exact noIso_of_two_colours a (b + h) c h hhalf hne
      hab' habh' hac hach hthreeT k hbk hbc' hbch' f hf'


/-!
COU-20: ordered-square algebra ported from the STROBO proof (PR #25,
Strobo2TorsCore.lean at d4a1f9718).  This internal dependency is intentionally
copied with provenance rather than merging separate research branches.
-/

def abelianDiagCoeff (a b c z : G) : ℕ :=
  (if a + a = z then 1 else 0) +
  (if b + b = z then 1 else 0) +
  (if c + c = z then 1 else 0)

/-- The three unordered off-diagonal pairs. -/
def abelianOffCoeff (a b c z : G) : ℕ :=
  (if a + b = z then 1 else 0) +
  (if a + c = z then 1 else 0) +
  (if b + c = z then 1 else 0)

/-- The explicit nine-ordered-pair coefficient; valid for distinct a,b,c. -/
def abelianTripleSquareCoeff (a b c z : G) : ℕ :=
  abelianDiagCoeff a b c z + 2 * abelianOffCoeff a b c z


theorem abelian_paired_expansion (a b d z : G) (hd : d + d = 0) :
    abelianTripleSquareCoeff a b (b + d) z =
      (if a + a = z then 1 else 0) +
      2 * ((if b + b = z then 1 else 0) +
           (if b + b + d = z then 1 else 0) +
           (if a + b = z then 1 else 0) +
           (if a + b + d = z then 1 else 0)) := by
  have hdouble : (b + d) + (b + d) = b + b := by
    calc
      (b + d) + (b + d) = (b + b) + (d + d) := by abel
      _ = b + b := by simp [hd]
  have hsingle : a + (b + d) = a + b + d := by abel
  have hpaired : b + (b + d) = b + b + d := by abel
  simp only [abelianTripleSquareCoeff, abelianDiagCoeff, abelianOffCoeff,
    hdouble, hsingle, hpaired]
  omega

/--
The exceptional partner reflects the doublet about the singleton.
This establishes the SUFFICIENT condition for equal labelled squares;
it does NOT assert the necessity or the complete fibre classification.
The condition 3(b-a)=d permits order-six differences, not merely order three.
-/
theorem abelian_exceptional_reflection_same_square
    (a b d z : G) (hd : d + d = 0)
    (h3 : ((b - a) + (b - a)) + (b - a) = 0 ∨
          ((b - a) + (b - a)) + (b - a) = d) :
    abelianTripleSquareCoeff a b (b + d) z =
      abelianTripleSquareCoeff a (b + b - a) ((b + b - a) + d) z := by
  let e : G := b + b - a
  have hae : a + e = b + b := by dsimp [e]; abel
  have hee : e + e =
      (a + b) + (((b - a) + (b - a)) + (b - a)) := by
    dsimp [e]
    abel
  change abelianTripleSquareCoeff a b (b + d) z =
    abelianTripleSquareCoeff a e (e + d) z
  rcases h3 with hzero | hdifference
  · have hee0 : e + e = a + b := by
      rw [hee, hzero]
      simp
    rw [abelian_paired_expansion a b d z hd, abelian_paired_expansion a e d z hd]
    rw [hee0, hae]
    omega
  · have heed : e + e = a + b + d := by
      rw [hee, hdifference]
    have hflip : (e + e) + d = a + b := by
      calc
        (e + e) + d = (a + b + d) + d := by rw [heed]
        _ = (a + b) + (d + d) := by abel
        _ = a + b := by simp [hd]
    rw [abelian_paired_expansion a b d z hd, abelian_paired_expansion a e d z hd]
    rw [heed, hae]
    have hflip' : (a + b + d) + d = a + b := by
      calc
        (a + b + d) + d = (a + b) + (d + d) := by abel
        _ = a + b := by simp [hd]
    rw [hflip']
    omega




/-- Swapping the two members of a doublet leaves its nine-sum polynomial. -/
theorem abelianTripleSquareCoeff_swap (a b c z : G) :
    abelianTripleSquareCoeff a b c z =
      abelianTripleSquareCoeff a c b z := by
  unfold abelianTripleSquareCoeff abelianDiagCoeff abelianOffCoeff
  rw [add_comm b c]
  omega

/-- The exceptional source/target have identical ordered nine-pair
coefficient functions in every additive commutative group.

Distinct support elements are needed when interpreting this expression as
the actual ordered convolution square of three-element Finsets.
Here, no cyclicity or finiteness hypothesis is required. -/
theorem abelianTripleSquareCoeff_source_target
    (a d h z : G) (hh : h + h = 0)
    (hthree : (d + d) + d = 0 ∨ (d + d) + d = h) :
    abelianTripleSquareCoeff a (a + d) ((a + d) + h) z =
    abelianTripleSquareCoeff a (a - d) ((a - d) + h) z := by
  have hdelta : (a + d) - a = d := by abel
  have hthree' :
      (((a + d) - a) + ((a + d) - a)) + ((a + d) - a) = 0 ∨
      (((a + d) - a) + ((a + d) - a)) + ((a + d) - a) = h := by
    simpa only [hdelta] using hthree
  have href :=
    abelian_exceptional_reflection_same_square
      a (a + d) h z hh hthree'
  rcases hthree with hzero | hturn
  · have heq : (a + d) + (a + d) - a = a - d := by
      calc
        (a + d) + (a + d) - a = (a - d) + ((d + d) + d) := by abel
        _ = a - d := by rw [hzero]; simp
    simpa only [heq] using href
  · have heq : (a + d) + (a + d) - a = (a - d) + h := by
      calc
        (a + d) + (a + d) - a = (a - d) + ((d + d) + d) := by abel
        _ = (a - d) + h := by rw [hturn]
    have htwice : ((a - d) + h) + h = a - d := by
      calc
        ((a - d) + h) + h = (a - d) + (h + h) := by abel
        _ = a - d := by rw [hh]; simp
    rw [heq, htwice] at href
    exact href.trans
      (abelianTripleSquareCoeff_swap a ((a - d) + h) (a - d) z)



/-- Count ordered pairs in a *finite support* with prescribed sum.
Unlike the nine-term expression, duplicates in a Finset are removed. -/
def abelianOrderedSquare (S : Finset G) (z : G) : ℕ :=
  S.sum (fun x => S.sum (fun y => if x + y = z then 1 else 0))

/-- For genuinely distinct vertices the actual Finset convolution-square
coefficient expands to precisely the nine ordered sums. -/
theorem abelianOrderedSquare_triple
    (a b c z : G) (hab : a ≠ b) (hac : a ≠ c) (hbc : b ≠ c) :
    abelianOrderedSquare ({a, b, c} : Finset G) z =
      abelianTripleSquareCoeff a b c z := by
  have ha : a ∉ ({b, c} : Finset G) := by simp [hab, hac]
  have hb : b ∉ ({c} : Finset G) := by simp [hbc]
  have hsum (f : G → ℕ) :
      Finset.sum ({a, b, c} : Finset G) f = f a + f b + f c := by
    rw [Finset.sum_insert ha, Finset.sum_insert hb, Finset.sum_singleton]
    omega
  unfold abelianOrderedSquare
  rw [hsum (fun x => Finset.sum ({a, b, c} : Finset G)
    (fun y => if x + y = z then 1 else 0))]
  rw [hsum (fun y => if a + y = z then 1 else 0),
      hsum (fun y => if b + y = z then 1 else 0),
      hsum (fun y => if c + y = z then 1 else 0)]
  simp only [abelianTripleSquareCoeff, abelianDiagCoeff,
    abelianOffCoeff]
  have hba : (if b + a = z then (1 : ℕ) else 0) =
      (if a + b = z then 1 else 0) := by rw [add_comm b a]
  have hca : (if c + a = z then (1 : ℕ) else 0) =
      (if a + c = z then 1 else 0) := by rw [add_comm c a]
  have hcb : (if c + b = z then (1 : ℕ) else 0) =
      (if b + c = z then 1 else 0) := by rw [add_comm c b]
  rw [hba, hca, hcb]
  omega

/-- Under explicit three-distinct-generator premises, the two finite supports
have *equal labelled ordered convolution squares*, coefficient by coefficient.
The proof does not assume finite G or cyclic G. -/
theorem abelianOrderedSquare_source_target
    (a d h z : G) (hh : h + h = 0)
    (hthree : (d + d) + d = 0 ∨ (d + d) + d = h)
    (hs1 : a ≠ a + d)
    (hs2 : a ≠ (a + d) + h)
    (hs3 : a + d ≠ (a + d) + h)
    (ht1 : a ≠ a - d)
    (ht2 : a ≠ (a - d) + h)
    (ht3 : a - d ≠ (a - d) + h) :
    abelianOrderedSquare (AbelianSource a d h) z =
      abelianOrderedSquare (AbelianTarget a d h) z := by
  change abelianOrderedSquare ({a, a + d, (a + d) + h} : Finset G) z =
    abelianOrderedSquare ({a, a - d, (a - d) + h} : Finset G) z
  rw [abelianOrderedSquare_triple a (a + d) ((a + d) + h) z hs1 hs2 hs3,
      abelianOrderedSquare_triple a (a - d) ((a - d) + h) z ht1 ht2 ht3]
  exact abelianTripleSquareCoeff_source_target a d h z hh hthree


/-!
COU-20: a CONDITIONAL construction of the d -> -d reflection.

A 3-torsion idempotent projection is additional mathematical structure.
Its existence from just "a mod <h> does not generate G/<h>" is NOT yet
constructed in Lean. The results below never assert that existence.
-/

/-- On an additive commutative group, an idempotent additive endomorphism
with image of exponent three gives an additive involution x -> x + p(x). -/
def abelianThreeReflection
    (p : G →+ G)
    (hp : ∀ x : G, p (p x) = p x)
    (h3 : ∀ x : G, p x + p x + p x = 0) : G ≃+ G where
  toFun := fun x => x + p x
  invFun := fun x => x + p x
  left_inv := by
    intro x
    change (x + p x) + p (x + p x) = x
    rw [map_add, hp x]
    calc
      (x + p x) + (p x + p x) = x + (p x + p x + p x) := by abel
      _ = x := by rw [h3 x]; simp
  right_inv := by
    intro x
    change (x + p x) + p (x + p x) = x
    rw [map_add, hp x]
    calc
      (x + p x) + (p x + p x) = x + (p x + p x + p x) := by abel
      _ = x := by rw [h3 x]; simp
  map_add' := by
    intro x y
    change (x + y) + p (x + y) = (x + p x) + (y + p y)
    rw [map_add]
    abel

/-- If the projection fixes the singleton and half-turn and sends d to
-2*d, the involution transports the entire source support to the target. -/
theorem abelianThreeReflection_support
    (p : G →+ G)
    (hp : ∀ x : G, p (p x) = p x)
    (h3 : ∀ x : G, p x + p x + p x = 0)
    (a d h : G) (ha : p a = 0) (hh : p h = 0)
    (hd : p d = -(d + d)) :
    (AbelianSource a d h).image
      (fun x => abelianThreeReflection p hp h3 x) =
      AbelianTarget a d h := by
  let φ : G ≃+ G := abelianThreeReflection p hp h3
  have ha' : φ a = a := by
    change a + p a = a
    simp [ha]
  have hb' : φ (a + d) = a - d := by
    change (a + d) + p (a + d) = a - d
    rw [map_add, ha, hd]
    abel
  have hc' : φ ((a + d) + h) = (a - d) + h := by
    change ((a + d) + h) + p ((a + d) + h) = (a - d) + h
    rw [map_add, map_add, ha, hd, hh]
    abel
  change ({a, a + d, (a + d) + h} : Finset G).image (fun x => φ x) =
    ({a, a - d, (a - d) + h} : Finset G)
  simp only [Finset.image_insert, Finset.image_singleton]
  rw [ha', hb', hc']

/-- Under the explicitly supplied projection, the reflection is a genuine
uncoloured directed Cayley digraph isomorphism. This is NOT the unconditional
non-generation -> existence direction of the proposed dichotomy. -/
theorem abelianThreeReflection_arc_iff
    (p : G →+ G)
    (hp : ∀ x : G, p (p x) = p x)
    (h3 : ∀ x : G, p x + p x + p x = 0)
    (a d h : G) (ha : p a = 0) (hh : p h = 0)
    (hd : p d = -(d + d)) (x y : G) :
    CayleyArc (AbelianSource a d h) x y ↔
      CayleyArc (AbelianTarget a d h)
        (abelianThreeReflection p hp h3 x)
        (abelianThreeReflection p hp h3 y) := by
  let φ : G ≃+ G := abelianThreeReflection p hp h3
  have himage :
      (AbelianSource a d h).image (fun t => φ t) =
      AbelianTarget a d h :=
    abelianThreeReflection_support p hp h3 a d h ha hh hd
  constructor
  · rintro ⟨s, hs, hys⟩
    refine ⟨φ s, ?_, ?_⟩
    · rw [← himage]
      exact Finset.mem_image.mpr ⟨s, hs, rfl⟩
    · rw [hys]
      exact map_add φ x s
  · rintro ⟨t, ht, hyt⟩
    have ht' : t ∈ (AbelianSource a d h).image (fun u => φ u) := by
      rw [himage]
      exact ht
    rcases Finset.mem_image.mp ht' with ⟨s, hs, hst⟩
    refine ⟨s, hs, ?_⟩
    apply φ.injective
    calc
      φ y = φ x + t := hyt
      _ = φ x + φ s := by rw [hst]
      _ = φ (x + s) := (map_add φ x s).symm


/-!
## COU-20: Three-valued quotient character as a constructive intermediary

If the index-three quotient provides a character χ : G →+ ZMod 3 with
χ(a)=χ(h)=0 and χ(d)=1, the required additive projection can be
constructed explicitly. Existence of χ from the original generation
hypotheses is a separate proof obligation and is NOT asserted here.
-/

/-- A three-torsion element determines an additive homomorphism from ZMod 3. -/
def abelianZModThreeLift (e : G) (he : e + e + e = 0) : ZMod 3 →+ G :=
  ZMod.lift 3
    ⟨{ toFun := fun n : ℤ => n • e
       map_zero' := by simp
       map_add' := by intro m n; simp only [add_zsmul] },
     by
       change (3 : ℤ) • e = 0
       simpa [three_nsmul, add_assoc] using he⟩

theorem abelianZModThreeLift_one
    (e : G) (he : e + e + e = 0) :
    abelianZModThreeLift e he 1 = e := by
  simp [abelianZModThreeLift, ZMod.lift_coe]

/-- The image of the canonical ZMod 3 homomorphism has exponent three. -/
theorem abelianZModThreeLift_three
    (e : G) (he : e + e + e = 0) (t : ZMod 3) :
    abelianZModThreeLift e he t +
      abelianZModThreeLift e he t +
      abelianZModThreeLift e he t = 0 := by
  let j := abelianZModThreeLift e he
  have hz : (3 : ℕ) • t = 0 := by
    fin_cases t <;> decide
  calc
    j t + j t + j t = (3 : ℕ) • j t := by rw [three_nsmul]; abel
    _ = j ((3 : ℕ) • t) := (map_nsmul j 3 t).symm
    _ = 0 := by rw [hz]; simp

/-- A ZMod-three quotient character yields a projection p with precisely
the axioms consumed by the previously certified reflection theorem.
The character is an explicit premise, not derived from non-generation. -/
theorem abelianThreeProjection_of_character
    (χ : G →+ ZMod 3)
    (a d h : G)
    (hh : h + h = 0)
    (hthree : (d + d) + d = 0 ∨ (d + d) + d = h)
    (hχa : χ a = 0) (hχh : χ h = 0) (hχd : χ d = 1) :
    ∃ p : G →+ G,
      (∀ x : G, p (p x) = p x) ∧
      (∀ x : G, p x + p x + p x = 0) ∧
      p a = 0 ∧ p h = 0 ∧ p d = -(d + d) := by
  let e : G := -(d + d)
  have he : e + e + e = 0 := by
    dsimp [e]
    calc
      -(d + d) + -(d + d) + -(d + d) =
          -(((d + d) + d) + ((d + d) + d)) := by abel
      _ = 0 := by
        rcases hthree with hz | ht
        · rw [hz]; simp
        · rw [ht, hh]; simp
  let j : ZMod 3 →+ G := abelianZModThreeLift e he
  have hj1 : j 1 = e := abelianZModThreeLift_one e he
  have hχe : χ e = 1 := by
    dsimp [e]
    simp only [map_neg, map_add, hχd]
    decide
  have hleft : ∀ t : ZMod 3, χ (j t) = t := by
    intro t
    have hnat : ∀ n : ℕ, χ (j (n : ZMod 3)) = (n : ZMod 3) := by
      intro n
      induction n with
      | zero => simp
      | succ n ih =>
          rw [Nat.cast_succ, map_add, map_add, ih, hj1, hχe]
    simpa using hnat t.val
  let p : G →+ G := j.comp χ
  have hp : ∀ x : G, p (p x) = p x := by
    intro x
    change j (χ (j (χ x))) = j (χ x)
    rw [hleft (χ x)]
  have h3p : ∀ x : G, p x + p x + p x = 0 := by
    intro x
    change j (χ x) + j (χ x) + j (χ x) = 0
    exact abelianZModThreeLift_three e he (χ x)
  have hpa : p a = 0 := by simp [p, hχa]
  have hph : p h = 0 := by simp [p, hχh]
  have hpd : p d = -(d + d) := by
    change j (χ d) = -(d + d)
    rw [hχd, hj1]
    rfl
  exact ⟨p, hp, h3p, hpa, hph, hpd⟩

/-- A character separating the exceptional d-coset gives an explicit
isomorphism of the two directed Cayley digraphs, via the proven reflection. -/
theorem abelianThreeReflection_of_character_arc_iff
    (χ : G →+ ZMod 3) (a d h : G)
    (hh : h + h = 0)
    (hthree : (d + d) + d = 0 ∨ (d + d) + d = h)
    (hχa : χ a = 0) (hχh : χ h = 0) (hχd : χ d = 1) :
    ∃ φ : G ≃+ G,
      ∀ x y : G,
        CayleyArc (AbelianSource a d h) x y ↔
          CayleyArc (AbelianTarget a d h) (φ x) (φ y) := by
  obtain ⟨p, hp, h3p, hpa, hph, hpd⟩ :=
    abelianThreeProjection_of_character χ a d h hh hthree hχa hχh hχd
  refine ⟨abelianThreeReflection p hp h3p, ?_⟩
  intro x y
  exact abelianThreeReflection_arc_iff p hp h3p a d h hpa hph hpd x y

#print axioms Couret.CayleyDoublet.abelianThreeProjection_of_character
#print axioms Couret.CayleyDoublet.abelianThreeReflection_of_character_arc_iff

#print axioms Couret.CayleyDoublet.abelianThreeReflection_arc_iff

#print axioms Couret.CayleyDoublet.abelianOrderedSquare_source_target

#print axioms Couret.CayleyDoublet.abelianTripleSquareCoeff_source_target

#print axioms Couret.CayleyDoublet.noIso_of_two_colours_mod_halfTurn

#print axioms Couret.CayleyDoublet.abelianSource_singleton_iff
#print axioms Couret.CayleyDoublet.abelianSource_doublet_iff

end AbelianTwoColour

end Couret.CayleyDoublet
