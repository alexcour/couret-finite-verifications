module

public import MatchingCertificateData
public import CertificateSoundness

@[expose] public section

set_option autoImplicit false
namespace Couret.InterIA.SingletonNecessity
variable {G : Type*} [AddCommGroup G]

theorem cross_certificate_exists (p : List ℕ) (hp : p.Perm (List.range 6)) :
    p=reversePerm ∨ ∃ c : Certificate, c.perm=p ∧ valid false c=true := by
  have hm : p ∈ crossData.map Certificate.perm := by
    rw [crossData_coverage]
    exact List.mem_permutations'.mpr hp
  obtain ⟨c,hc,hcp⟩ := List.mem_map.mp hm
  have hv := List.all_eq_true.mp crossData_valid c hc
  simp only [crossValid,Bool.or_eq_true,decide_eq_true_eq] at hv
  rcases hv with hv|hv
  · exact Or.inl (hcp.symm.trans hv)
  · exact Or.inr ⟨c,hcp,hv⟩

theorem mixed_certificate_exists (p : List ℕ) (hp : p.Perm (List.range 7)) :
    ∃ c : Certificate, c.perm=p ∧ valid true c=true := by
  have hm : p ∈ mixedData.map Certificate.perm := by
    rw [mixedData_coverage]
    exact List.mem_permutations'.mpr hp
  obtain ⟨c,hc,hcp⟩ := List.mem_map.mp hm
  exact ⟨c,hcp,List.all_eq_true.mp mixedData_valid c hc⟩

def DistinctLabels (x : Fin 6 → G) : Prop :=
  Function.Injective (fun i : Fin 7 => evaluation x (label i.val))

def RelationsHold (x : Fin 6 → G) (mixed : Bool) (p : List ℕ) : Prop :=
  ∀ v ∈ relations mixed p, evaluation x v = 0

theorem valid_certificate_contradicts_distinct (mixed : Bool) (c : Certificate)
    (hc : valid mixed c=true) (x : Fin 6 → G) (hd : DistinctLabels x)
    (hr : RelationsHold x mixed c.perm) : False := by
  obtain ⟨hij,hj,heq⟩ := certificate_sound mixed c hc x hr
  have hi : c.i<7 := lt_trans hij hj
  have h : (⟨c.i,hi⟩ : Fin 7) = ⟨c.j,hj⟩ := hd heq
  have he : c.i=c.j := congrArg Fin.val h
  exact (Nat.ne_of_lt hij) he

theorem cross_matching_is_reverse (x : Fin 6 → G) (hd : DistinctLabels x)
    (p : List ℕ) (hp : p.Perm (List.range 6))
    (hr : RelationsHold x false p) : p=reversePerm := by
  rcases cross_certificate_exists p hp with h|⟨c,hp,hc⟩
  · exact h
  · exact False.elim (valid_certificate_contradicts_distinct false c hc x hd (hp ▸ hr))

theorem mixed_matching_impossible (x : Fin 6 → G) (hd : DistinctLabels x)
    (p : List ℕ) (hp : p.Perm (List.range 7))
    (hr : RelationsHold x true p) : False := by
  obtain ⟨c,hp,hc⟩ := mixed_certificate_exists p hp
  exact valid_certificate_contradicts_distinct true c hc x hd (hp ▸ hr)

end Couret.InterIA.SingletonNecessity
#print axioms Couret.InterIA.SingletonNecessity.cross_certificate_exists
#print axioms Couret.InterIA.SingletonNecessity.mixed_certificate_exists
#print axioms Couret.InterIA.SingletonNecessity.valid_certificate_contradicts_distinct
#print axioms Couret.InterIA.SingletonNecessity.cross_matching_is_reverse
#print axioms Couret.InterIA.SingletonNecessity.mixed_matching_impossible
