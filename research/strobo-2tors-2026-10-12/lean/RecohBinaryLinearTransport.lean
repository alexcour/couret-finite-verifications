import RecohInformationSet

set_option autoImplicit false

/-!
RECOH: transport of binary additive characters to linear probes.
Research candidate. No global B(G) claim. The additive equivalence
assumption is essential: do not apply this to C2 × C4 as a whole.
-/

namespace Couret.STROBO2TORS

/-- Every additive map between F₂-vector spaces is F₂-linear. -/
def recoh_binary_character_linear
    {V : Type*} [AddCommGroup V] [Module (ZMod 2) V]
    (f : V →+ ZMod 2) : V →ₗ[ZMod 2] ZMod 2 :=
  { f with
    map_smul' := by
      intro c x
      have hc : c = 0 ∨ c = 1 := by
        fin_cases c <;> simp [eq_comm]
      rcases hc with rfl | rfl
      · simp
      · simp }

/-- Transport binary additive characters through a specified additive
equivalence to canonical coordinates. -/
def recoh_binary_bank_linear
    {H : Type*} [AddCommGroup H]
    (r k : ℕ)
    (e : H ≃+ (Fin r → ZMod 2))
    (binary : Fin k → H →+ ZMod 2) :
    Fin k → Module.Dual (ZMod 2) (Fin r → ZMod 2) :=
  fun i => recoh_binary_character_linear (binary i |>.comp e.symm.toAddMonoidHom)

/-- The binary information-set theorem transports back to any
elementary abelian 2-group with an explicit coordinate equivalence. -/
theorem recoh_binary_information_set_additive
    {H : Type*} [AddCommGroup H]
    (r k : ℕ)
    (e : H ≃+ (Fin r → ZMod 2))
    (binary : Fin k → H →+ ZMod 2)
    (hinj : Function.Injective
      (fun a : H => fun i : Fin k => binary i a)) :
    ∃ pivot : Fin r → Fin k,
      Function.Injective pivot ∧
      Function.Surjective
        (fun a : H => fun j : Fin r => binary (pivot j) a) := by
  classical
  let bank := recoh_binary_bank_linear r k e binary
  have hlin : Function.Injective
      (fun x : Fin r → ZMod 2 => fun i : Fin k => bank i x) := by
    intro x y hxy
    have h : e.symm x = e.symm y := hinj (by
      funext i
      have hi := congrArg (fun f : Fin k → ZMod 2 => f i) hxy
      exact hi)
    exact e.symm.injective h
  obtain ⟨pivot, hpiv, hsurj⟩ :=
    recoh_binary_information_set_linear r k bank hlin
  refine ⟨pivot, hpiv, ?_⟩
  intro target
  obtain ⟨x, hx⟩ := hsurj target
  refine ⟨e.symm x, ?_⟩
  exact hx

end Couret.STROBO2TORS

#print axioms Couret.STROBO2TORS.recoh_binary_information_set_additive
