module

public import CertificateSoundness

@[expose] public section

set_option autoImplicit false
namespace Couret.InterIA.SingletonNecessity

theorem map_range_getElem_bang {α : Type*} [Inhabited α] (l : List α) :
    (List.range l.length).map (fun j => l[j]!)=l := by
  apply List.ext_getElem
  · simp
  · intro i hi hj
    simp only [List.getElem_map,List.getElem_range]
    exact getElem!_pos l i hj

theorem permutation_indices {α : Type*} [Inhabited α] (L R : List α)
    (h : L.Perm R) :
    ∃ p : List ℕ, p.Perm (List.range R.length) ∧ L=p.map (fun j => R[j]!) := by
  let f : ℕ → α := fun j => R[j]!
  have h' : L.Perm ((List.range R.length).map f) := by
    rw [map_range_getElem_bang]
    exact h
  have hc : Relation.Comp (fun a b => a=b.map f) List.Perm L (List.range R.length) := by
    rw [List.eq_map_comp_perm f]
    exact h'
  obtain ⟨p,hp1,hp2⟩ := hc
  exact ⟨p,hp2,hp1⟩

theorem zip_mapped_eq {α β γ : Type*} (L : List α) (R : List β)
    (f : α → γ) (g : β → γ) (h : L.map f=R.map g) :
    ∀ a b, (a,b)∈L.zip R → f a=g b := by
  induction L generalizing R with
  | nil => simp
  | cons a as ih =>
    cases R with
    | nil => simp
    | cons b bs =>
      have hs : f a=g b ∧ as.map f=bs.map g := List.cons.inj h
      intro c d hm
      simp only [List.zip_cons_cons,List.mem_cons] at hm
      rcases hm with he|he
      · cases he
        exact hs.1
      · exact ih bs hs.2 c d he

end Couret.InterIA.SingletonNecessity
