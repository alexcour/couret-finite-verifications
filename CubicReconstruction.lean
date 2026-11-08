module

public import CubicSupport
public import FamilyProbes
public import XorFibreClosure

@[expose] public section

set_option autoImplicit false
namespace Couret.InterIA.Cubic
open Finset Couret.InterIA.Parity Couret.InterIA.Fibres

noncomputable def realCube {G : Type*} [AddCommGroup G] [DecidableEq G]
    (S : Finset G) : G → ℝ := fun z => (orderedCube S z : ℝ)

theorem realCube_injOn_fibre (n : ℕ) (hn : 0<n) (S : Finset (ZMod n)) :
    Set.InjOn realCube (cyclicFourFibre n S) := by
  intro A hA B hB he
  apply square_cube_support_injective n hn A B
  · intro z
    exact (hA.2 z).symm.trans (hB.2 z)
  · intro z
    have h := congrFun he z
    change (orderedCube A z : ℝ)=(orderedCube B z : ℝ) at h
    exact_mod_cast h

theorem two_simple_cubic_probes (m : ℕ) (hm : 0<m)
    (C : Finset (ZMod (2*m))) (a : ZMod (2*m)) (hC : C.card=2)
    (hfree : AntipodalFree m C) (ha : Disjoint C (fibre (m : ZMod (2*m)) a)) :
    ∃ Q : Finset (ZMod (2*m)), Q.card≤2 ∧
      Separates realCube (originalFibre m (C ∪ fibre (m : ZMod (2*m)) a)) Q := by
  classical
  let D0 := fibre (m : ZMod (2*m)) a
  let F := originalFibre m (C ∪ D0)
  have hi : Set.InjOn realCube F := realCube_injOn_fibre (2*m) (by omega) (C ∪ D0)
  have hD0 : D0 ∈ admissibleFullPairs m C a := admissible_full_pair_base m C a ha
  rcases admissible_full_pairs_one_or_two m hm C hC a ha with hP|⟨D,hDne,hP⟩
  · have hF : F={C ∪ D0,halfShift m C ∪ D0} := by
      dsimp [F,D0]
      rw [two_simple_fibre_rectangle m hm C a hC hfree ha,hP]
      simp [Set.pair_comm]
    apply small_family_probes realCube F hi
    right
    rw [hF]
    exact Set.ncard_pair (admissible_orientation_distinct m C a hC hfree D0 D0 hD0 hD0)
  · have hD : D ∈ admissibleFullPairs m C a := by rw [hP]; simp
    let pick (b : Bool) : {D : Finset (ZMod (2*m)) // D ∈ admissibleFullPairs m C a} :=
      if b then ⟨D,hD⟩ else ⟨D0,hD0⟩
    let g (p : Bool × Bool) := orientationCode m C a (p.1,pick p.2)
    have hg : Function.Injective g := by
      rintro ⟨p,q⟩ ⟨r,s⟩ he
      have h := orientationCode_injective m C a hC hfree he
      have h1 : p=r := congrArg Prod.fst h
      have h2 : (pick q).1=(pick s).1 := congrArg (fun t => t.2.1) h
      have hb : q=s := by
        cases q <;> cases s <;> simp_all [pick,D0]
      exact Prod.ext h1 hb
    have hmem (p : Bool × Bool) : g p ∈ F :=
      (two_simple_fibre_code_iff m hm C a hC hfree ha (g p)).mpr ⟨(p.1,pick p.2),rfl⟩
    have hcover : ∀ T ∈ F, ∃ p, g p=T := by
      intro T hT
      obtain ⟨⟨e,⟨E,hE⟩⟩,he⟩ := (two_simple_fibre_code_iff m hm C a hC hfree ha T).mp hT
      have hE' : E=D0 ∨ E=D := by simpa only [hP,Set.mem_insert_iff,Set.mem_singleton_iff] using hE
      rcases hE' with rfl|rfl
      · exact ⟨(e,false),by simpa [g,pick] using he⟩
      · exact ⟨(e,true),by simpa [g,pick] using he⟩
    let r : ZMod (2*m) → ℝ := fun z => (orderedSquare (C ∪ D0) z : ℝ)
    let H := probe r C+probe r D0
    let U := probe r (halfShift m C)-probe r C
    let V := probe r D-probe r D0
    have hCD : Disjoint C D := by obtain ⟨b,hb,hd,hs⟩ := hD; exact hd
    have hHD0 : Disjoint (halfShift m C) D0 := halfShift_disjoint_full m C a ha
    have hHD : Disjoint (halfShift m C) D :=
      orientation_disjoint_admissible m C a (halfShift m C) D (Or.inr (Set.mem_singleton _)) hD
    have hlin (p : Bool × Bool) : realCube (g p)=probe r (g p) :=
      cube_eq_probe (C ∪ D0) (g p) (hmem p).2
    have hrect : ∀ p, realCube (g p)=rectangle H U V p := by
      rintro ⟨i,j⟩
      rw [hlin]
      funext z
      cases i <;> cases j <;>
        simp only [g,pick,orientationCode,Bool.false_eq_true,↓reduceIte,
          probe_union r C D0 ha,probe_union r C D hCD,
          probe_union r (halfShift m C) D0 hHD0,probe_union r (halfShift m C) D hHD,
          rectangle,H,U,V,Pi.add_apply,Pi.sub_apply,add_zero] <;> ring
    exact parameterized_rectangle_probes realCube F g hg hmem hcover hi H U V hrect

theorem cyclic_four_two_cubic_probes (n : ℕ) (hn : 0<n)
    (S : Finset (ZMod n)) (hS : S.card=4) :
    ∃ Q : Finset (ZMod n), Q.card≤2 ∧ Separates realCube (cyclicFourFibre n S) Q := by
  classical
  have hi := realCube_injOn_fibre n hn S
  rcases Nat.even_or_odd n with he|ho
  · obtain ⟨m,hm⟩ := he
    have hn2 : n=2*m := by omega
    clear hm
    subst n
    have hm : 0<m := by omega
    rcases even_four_support_cases m hm S hS with hf|hs|⟨C,a,hC,hf,hd,hSe⟩
    · apply small_family_probes realCube (cyclicFourFibre (2*m) S) hi
      right
      rw [show cyclicFourFibre (2*m) S={S,halfShift m S} from
        antipodal_free_four_fibre_eq_pair m hm S hS hf]
      exact Set.ncard_pair (antipodal_free_four_ne_half_translate m S hS hf)
    · exact small_family_probes realCube _ hi (stable_four_fibre_ncard m hm S hS hs)
    · rw [hSe]
      exact two_simple_cubic_probes m hm C a hC hf hd
  · apply small_family_probes realCube (cyclicFourFibre n S) hi
    left
    rw [odd_four_fibre_singleton n ho S hS,Set.ncard_singleton]

end Couret.InterIA.Cubic
