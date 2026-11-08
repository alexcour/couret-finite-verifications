module

public import PermutationIndices
public import ExtractionBasics

@[expose] public section

set_option autoImplicit false
namespace Couret.InterIA.SingletonNecessity
variable {G : Type*} [AddCommGroup G] [DecidableEq G]

theorem evaluated_terms (x : Fin 6 → G) :
    leftTerms.map (evaluation x)=sumTermsLeft x ∧
    rightTerms.map (evaluation x)=sumTermsRight x := by
  have e0 : evaluation x (basis 0)=x 0 := evaluation_basis x (0:Fin 6)
  have e1 : evaluation x (basis 1)=x 1 := evaluation_basis x (1:Fin 6)
  have e2 : evaluation x (basis 2)=x 2 := evaluation_basis x (2:Fin 6)
  have e3 : evaluation x (basis 3)=x 3 := evaluation_basis x (3:Fin 6)
  have e4 : evaluation x (basis 4)=x 4 := evaluation_basis x (4:Fin 6)
  have e5 : evaluation x (basis 5)=x 5 := evaluation_basis x (5:Fin 6)
  constructor <;> simp only [leftTerms,rightTerms,sumTermsLeft,sumTermsRight,
    List.map_cons,List.map_nil,map_add,e0,e1,e2,e3,e4,e5]

theorem matching_rows_zero (x : Fin 6 → G) (L R : List Vec)
    (hp : (L.map (evaluation x)).Perm (R.map (evaluation x))) :
    ∃ p : List ℕ, p.Perm (List.range R.length) ∧
      ∀ v ∈ ((L.zip p).map fun (v,j) => v-R[j]!), evaluation x v=0 := by
  letI : Inhabited G := ⟨0⟩
  obtain ⟨p,hp,he⟩ := permutation_indices (L.map (evaluation x)) (R.map (evaluation x)) hp
  have hpr : p.Perm (List.range R.length) := by simpa only [List.length_map] using hp
  refine ⟨p,hpr,?_⟩
  intro v hv
  obtain ⟨⟨w,j⟩,hm,rfl⟩ := List.mem_map.mp hv
  have hj : j<R.length := List.mem_range.mp (hpr.mem_iff.mp (List.of_mem_zip hm).2)
  have h := zip_mapped_eq L p (evaluation x) (fun j => (R.map (evaluation x))[j]!) he w j hm
  have hg : (R.map (evaluation x))[j]! = evaluation x R[j]! := by
    rw [getElem!_pos (R.map (evaluation x)) j (by simpa using hj),
      getElem!_pos R j hj,List.getElem_map]
  change evaluation x w=(R.map (evaluation x))[j]! at h
  rw [hg] at h
  simpa only [map_sub,sub_eq_zero] using h

theorem cross_encoding (x : Fin 6 → G) (hx : CrossDoubles x)
    (hp : (sumTermsLeft x).Perm (sumTermsRight x)) :
    ∃ p : List ℕ, p.Perm (List.range 6) ∧
      ∀ v ∈ relations false p, evaluation x v=0 := by
  have he := evaluated_terms x
  obtain ⟨p,hp,hr⟩ := matching_rows_zero x leftTerms rightTerms (by rwa [he.1,he.2])
  refine ⟨p,by simpa [rightTerms] using hp,?_⟩
  have e0 : evaluation x (basis 0)=x 0 := evaluation_basis x (0:Fin 6)
  have e1 : evaluation x (basis 1)=x 1 := evaluation_basis x (1:Fin 6)
  have e2 : evaluation x (basis 2)=x 2 := evaluation_basis x (2:Fin 6)
  have e3 : evaluation x (basis 3)=x 3 := evaluation_basis x (3:Fin 6)
  have e4 : evaluation x (basis 4)=x 4 := evaluation_basis x (4:Fin 6)
  have e5 : evaluation x (basis 5)=x 5 := evaluation_basis x (5:Fin 6)
  rcases hx with ⟨h0,h1,h2⟩
  intro v hv
  simp only [relations,Bool.false_eq_true,if_false,List.mem_append,List.mem_cons,
    List.not_mem_nil,or_false] at hv
  rcases hv with (rfl|rfl|rfl)|hv
  · simp only [map_add,map_sub,e0,e3,two_zsmul]
    calc
      (x 0-x 3)+(x 0-x 3)=(x 0+x 0)-(x 3+x 3) := by abel
      _ = 0 := sub_eq_zero.mpr h0
  · simp only [map_add,map_sub,e1,e4,two_zsmul]
    calc
      (x 1-x 4)+(x 1-x 4)=(x 1+x 1)-(x 4+x 4) := by abel
      _ = 0 := sub_eq_zero.mpr h1
  · simp only [map_add,map_sub,e2,e5,two_zsmul]
    calc
      (x 2-x 5)+(x 2-x 5)=(x 2+x 2)-(x 5+x 5) := by abel
      _ = 0 := sub_eq_zero.mpr h2
  · exact hr v hv

theorem mixed_encoding (x : Fin 6 → G) (hx : MixedDoubles x)
    (hp : (sumTermsLeft x ++ [x 0+x 0]).Perm (sumTermsRight x ++ [x 3+x 3])) :
    ∃ p : List ℕ, p.Perm (List.range 7) ∧
      ∀ v ∈ relations true p, evaluation x v=0 := by
  have he := evaluated_terms x
  have e0 : evaluation x (basis 0)=x 0 := evaluation_basis x (0:Fin 6)
  have e1 : evaluation x (basis 1)=x 1 := evaluation_basis x (1:Fin 6)
  have e2 : evaluation x (basis 2)=x 2 := evaluation_basis x (2:Fin 6)
  have e3 : evaluation x (basis 3)=x 3 := evaluation_basis x (3:Fin 6)
  have e4 : evaluation x (basis 4)=x 4 := evaluation_basis x (4:Fin 6)
  have e5 : evaluation x (basis 5)=x 5 := evaluation_basis x (5:Fin 6)
  obtain ⟨p,hp,hr⟩ := matching_rows_zero x
    (leftTerms++[(2:ℤ) • basis 0]) (rightTerms++[(2:ℤ) • basis 3]) (by
      simpa only [List.map_append,List.map_cons,List.map_nil,map_zsmul,map_add,
        e0,e3,two_zsmul,he.1,he.2] using hp)
  refine ⟨p,by simpa [rightTerms] using hp,?_⟩
  rcases hx with ⟨h0,h1,h2⟩
  intro v hv
  simp only [relations,if_true,List.mem_append,List.mem_cons,List.not_mem_nil,or_false] at hv
  rcases hv with (rfl|rfl|rfl)|hv
  · simp only [map_add,map_sub,e0,e1,two_zsmul]
    calc
      (x 0-x 1)+(x 0-x 1)=(x 0+x 0)-(x 1+x 1) := by abel
      _ = 0 := sub_eq_zero.mpr h0
  · simp only [map_add,map_sub,e3,e4,two_zsmul]
    calc
      (x 3-x 4)+(x 3-x 4)=(x 3+x 3)-(x 4+x 4) := by abel
      _ = 0 := sub_eq_zero.mpr h1
  · simp only [map_add,map_sub,e2,e5,two_zsmul]
    calc
      (x 2-x 5)+(x 2-x 5)=(x 2+x 2)-(x 5+x 5) := by abel
      _ = 0 := sub_eq_zero.mpr h2
  · exact hr v hv

end Couret.InterIA.SingletonNecessity
