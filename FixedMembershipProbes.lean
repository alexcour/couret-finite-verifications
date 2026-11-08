module

public import BinaryAffineFibre
public import Mathlib.Data.Fin.Tuple.Basic
public import Mathlib.Data.Fintype.EquivFin

@[expose] public section

set_option autoImplicit false
namespace Couret.InterIA.Fibres
open Finset Couret.InterIA.Parity

/-- A fixed list of labelled positions separates every pair of candidates. -/
def ProbeSeparates {α : Type*} [DecidableEq α] {d : ℕ}
    (P : Set (Finset α)) (q : Fin d → α) : Prop :=
  ∀ T ∈ P, ∀ U ∈ P, (∀ i, q i ∈ T ↔ q i ∈ U) → T=U

theorem exists_membership_difference {α : Type*} [DecidableEq α]
    (A B : Finset α) (hne : A ≠ B) : ∃ x, ¬ (x ∈ A ↔ x ∈ B) := by
  classical
  by_contra hn
  apply hne
  ext x
  by_contra hx
  exact hn ⟨x,hx⟩

theorem xor_member_eq_middle {α : Type*} [DecidableEq α] (A B C : Finset α) (x : α)
    (hc : x ∈ A ↔ x ∈ C) : x ∈ symmDiff (symmDiff A B) C ↔ x ∈ B := by
  simp only [Finset.mem_symmDiff]
  tauto

theorem xor_member_ne_middle {α : Type*} [DecidableEq α] (A B C : Finset α) (x : α)
    (hc : ¬ (x ∈ A ↔ x ∈ C)) : ¬ (x ∈ B ↔ x ∈ symmDiff (symmDiff A B) C) := by
  simp only [Finset.mem_symmDiff]
  tauto

theorem xor_member_eq_first_of_two_differences {α : Type*} [DecidableEq α]
    (A B C : Finset α) (x : α) (hb : ¬ (x ∈ A ↔ x ∈ B)) (hc : ¬ (x ∈ A ↔ x ∈ C)) :
    x ∈ A ↔ x ∈ symmDiff (symmDiff A B) C := by
  simp only [Finset.mem_symmDiff]
  tauto

theorem xor_four_coordinate_separates {α : Type*} [DecidableEq α]
    (A B C : Finset α) (x y : α)
    (hx : ¬ (x ∈ A ↔ x ∈ B)) (hc : x ∈ A ↔ x ∈ C)
    (hy : ¬ (y ∈ A ↔ y ∈ C)) :
    ProbeSeparates ({A,B,C,symmDiff (symmDiff A B) C} : Set (Finset α))
      (fun i : Fin 2 => if i=0 then x else y) := by
  let D := symmDiff (symmDiff A B) C
  have hDx : x ∈ D ↔ x ∈ B := xor_member_eq_middle A B C x hc
  have hDy : ¬ (y ∈ B ↔ y ∈ D) := xor_member_ne_middle A B C y hy
  have hAD : ¬ (x ∈ A ↔ x ∈ D) := fun h => hx (h.trans hDx)
  have hBC : ¬ (x ∈ B ↔ x ∈ C) := fun h => hx (hc.trans h.symm)
  have hCD : ¬ (x ∈ C ↔ x ∈ D) := fun h => hx (hc.trans (h.trans hDx))
  intro T hT U hU he
  have he0 := he 0
  have he1 := he 1
  change x ∈ T ↔ x ∈ U at he0
  change y ∈ T ↔ y ∈ U at he1
  clear he
  change T ∈ ({A,B,C,D} : Set (Finset α)) at hT
  change U ∈ ({A,B,C,D} : Set (Finset α)) at hU
  simp only [Set.mem_insert_iff,Set.mem_singleton_iff] at hT hU
  rcases hT with rfl|rfl|rfl|rfl <;> rcases hU with rfl|rfl|rfl|rfl
  all_goals first
    | rfl
    | exact False.elim (hx he0)
    | exact False.elim (hx he0.symm)
    | exact False.elim (hAD he0)
    | exact False.elim (hAD he0.symm)
    | exact False.elim (hBC he0)
    | exact False.elim (hBC he0.symm)
    | exact False.elim (hCD he0)
    | exact False.elim (hCD he0.symm)
    | exact False.elim (hy he1)
    | exact False.elim (hy he1.symm)
    | exact False.elim (hDy he1)
    | exact False.elim (hDy he1.symm)

theorem xor_family_four_probes {α : Type*} [DecidableEq α]
    (P : Set (Finset α)) (hc : P.ncard=4) (hxor : XorClosed P) :
    ∃ q : Fin 2 → α, ProbeSeparates P q := by
  classical
  obtain ⟨A,B,C,E,hAB,hAC,_hAE,hBC,_hBE,_hCE,hP⟩ := Set.ncard_eq_four.mp hc
  let D := symmDiff (symmDiff A B) C
  have hDA : D ≠ A := by
    intro h
    apply hBC
    ext x
    have he : x ∈ D ↔ x ∈ A := by rw [h]
    dsimp only [D] at he
    simp only [Finset.mem_symmDiff] at he
    tauto
  have hDB : D ≠ B := by
    intro h
    apply hAC
    ext x
    have he : x ∈ D ↔ x ∈ B := by rw [h]
    dsimp only [D] at he
    simp only [Finset.mem_symmDiff] at he
    tauto
  have hDC : D ≠ C := by
    intro h
    apply hAB
    ext x
    have he : x ∈ D ↔ x ∈ C := by rw [h]
    dsimp only [D] at he
    simp only [Finset.mem_symmDiff] at he
    tauto
  have hD : D ∈ P := hxor A (by rw [hP]; simp) B (by rw [hP]; simp) C (by rw [hP]; simp)
  have hDE : D=E := by
    rw [hP] at hD
    simp only [Set.mem_insert_iff,Set.mem_singleton_iff] at hD
    tauto
  have hPD : P={A,B,C,D} := by rw [hDE,hP]
  obtain ⟨x,hx⟩ := exists_membership_difference A B hAB
  by_cases hsame : x ∈ A ↔ x ∈ C
  · obtain ⟨y,hy⟩ := exists_membership_difference A C hAC
    rw [hPD]
    exact ⟨_,xor_four_coordinate_separates A B C x y hx hsame hy⟩
  · have hsameD : x ∈ A ↔ x ∈ D := xor_member_eq_first_of_two_differences A B C x hx hsame
    obtain ⟨y,hy⟩ := exists_membership_difference A D hDA.symm
    have hback : symmDiff (symmDiff A B) D=C := symmDiff_symmDiff_cancel_left _ _
    have hswap : P={A,B,D,symmDiff (symmDiff A B) D} := by
      rw [hback,hPD]
      ext T
      simp only [Set.mem_insert_iff,Set.mem_singleton_iff]
      exact or_congr Iff.rfl (or_congr Iff.rfl or_comm)
    rw [hswap]
    exact ⟨_,xor_four_coordinate_separates A B D x y hx hsameD hy⟩

/-- The quantifier order fixes the probes before any unknown candidate or answer. -/
theorem xor_family_fixed_probes {α : Type*} [DecidableEq α]
    (P : Set (Finset α)) (hc : P.ncard=1 ∨ P.ncard=2 ∨ P.ncard=4) (hxor : XorClosed P) :
    ∃ d : ℕ, d ≤ 2 ∧ P.ncard=2^d ∧ ∃ q : Fin d → α, ProbeSeparates P q := by
  classical
  rcases hc with h|h|h
  · obtain ⟨A,hP⟩ := Set.ncard_eq_one.mp h
    refine ⟨0,by omega,by simpa using h,Fin.elim0,?_⟩
    intro T hT U hU _
    rw [hP] at hT hU
    exact (Set.mem_singleton_iff.mp hT).trans (Set.mem_singleton_iff.mp hU).symm
  · obtain ⟨A,B,hAB,hP⟩ := Set.ncard_eq_two.mp h
    obtain ⟨x,hx⟩ := exists_membership_difference A B hAB
    refine ⟨1,by omega,by simpa using h,(fun _ => x),?_⟩
    intro T hT U hU he
    have he0 := he 0
    change x ∈ T ↔ x ∈ U at he0
    rw [hP] at hT hU
    simp only [Set.mem_insert_iff,Set.mem_singleton_iff] at hT hU
    rcases hT with rfl|rfl <;> rcases hU with rfl|rfl
    all_goals first | rfl | (exfalso; tauto)
  · obtain ⟨q,hq⟩ := xor_family_four_probes P h hxor
    exact ⟨2,by omega,by simpa using h,q,hq⟩

def probeAnswers {α : Type*} [DecidableEq α] {d : ℕ} (q : Fin d → α) (T : Finset α) : Fin d → Bool :=
  fun i => decide (q i ∈ T)

theorem probeAnswers_eq_iff {α : Type*} [DecidableEq α] {d : ℕ}
    (q : Fin d → α) (T U : Finset α) :
    probeAnswers q T=probeAnswers q U ↔ ∀ i, q i ∈ T ↔ q i ∈ U := by
  simp only [funext_iff,probeAnswers,decide_eq_decide]

theorem probeAnswers_bijective {α : Type*} [DecidableEq α] {d : ℕ}
    (P : Set (Finset α)) (q : Fin d → α) (hc : P.ncard=2^d) (hq : ProbeSeparates P q) :
    Function.Bijective (fun T : P => probeAnswers q T.val) := by
  classical
  have hnonzero : P.ncard ≠ 0 := by rw [hc]; exact pow_ne_zero _ (by omega)
  letI : Fintype P := (Set.finite_of_ncard_ne_zero hnonzero).fintype
  apply (Fintype.bijective_iff_injective_and_card _).mpr
  constructor
  · intro T U he
    exact Subtype.ext (hq T.val T.property U.val U.property ((probeAnswers_eq_iff q _ _).mp he))
  · have he : Nat.card P=2^d := hc
    rw [Nat.card_eq_fintype_card] at he
    simpa using he

noncomputable def probeDecode {α : Type*} [DecidableEq α] {d : ℕ}
    (P : Set (Finset α)) (q : Fin d → α) (fallback : Finset α) (b : Fin d → Bool) : Finset α :=
  by
    classical
    exact if h : ∃ T ∈ P, probeAnswers q T=b then Classical.choose h else fallback

theorem probeDecode_correct {α : Type*} [DecidableEq α] {d : ℕ}
    (P : Set (Finset α)) (q : Fin d → α) (fallback : Finset α) (hq : ProbeSeparates P q)
    (T : Finset α) (hT : T ∈ P) : probeDecode P q fallback (probeAnswers q T)=T := by
  classical
  have he : ∃ U ∈ P, probeAnswers q U=probeAnswers q T := ⟨T,hT,rfl⟩
  unfold probeDecode
  rw [dif_pos he]
  exact hq _ (Classical.choose_spec he).1 T hT
    ((probeAnswers_eq_iff q _ T).mp (Classical.choose_spec he).2)

theorem cyclic_four_fixed_probes (n : ℕ) (hn : 0 < n)
    (S : Finset (ZMod n)) (hS : S.card=4) :
    ∃ d : ℕ, d ≤ 2 ∧ (cyclicFourFibre n S).ncard=2^d ∧
      ∃ q : Fin d → ZMod n, ProbeSeparates (cyclicFourFibre n S) q :=
  xor_family_fixed_probes _ (cyclic_four_fibre_ncard n hn S hS)
    (cyclic_four_fibre_xor_closed n hn S hS)

end Couret.InterIA.Fibres
