module

public import ConvolutionParity

@[expose] public section
set_option autoImplicit false
set_option linter.unusedSimpArgs false
set_option maxRecDepth 10000
set_option maxHeartbeats 4000000
namespace Couret.InterIA.SingletonNecessity
def FibreParity {α : Type*} [DecidableEq α] (d : Fin 6 → α) : Prop :=
  ∀ z, ((if d 0=z then 1 else 0)+(if d 1=z then 1 else 0)+(if d 2=z then 1 else 0) : ℕ)%2 =
    ((if d 3=z then 1 else 0)+(if d 4=z then 1 else 0)+(if d 5=z then 1 else 0) : ℕ)%2
def HasPairing {α : Type*} (d : Fin 6 → α) : Prop :=
  (d 0=d 1 ∧ d 2=d 3 ∧ d 4=d 5) ∨
  (d 0=d 1 ∧ d 2=d 4 ∧ d 3=d 5) ∨
  (d 0=d 1 ∧ d 2=d 5 ∧ d 3=d 4) ∨
  (d 0=d 2 ∧ d 1=d 3 ∧ d 4=d 5) ∨
  (d 0=d 2 ∧ d 1=d 4 ∧ d 3=d 5) ∨
  (d 0=d 2 ∧ d 1=d 5 ∧ d 3=d 4) ∨
  (d 0=d 3 ∧ d 1=d 2 ∧ d 4=d 5) ∨
  (d 0=d 3 ∧ d 1=d 4 ∧ d 2=d 5) ∨
  (d 0=d 3 ∧ d 1=d 5 ∧ d 2=d 4) ∨
  (d 0=d 4 ∧ d 1=d 2 ∧ d 3=d 5) ∨
  (d 0=d 4 ∧ d 1=d 3 ∧ d 2=d 5) ∨
  (d 0=d 4 ∧ d 1=d 5 ∧ d 2=d 3) ∨
  (d 0=d 5 ∧ d 1=d 2 ∧ d 3=d 4) ∨
  (d 0=d 5 ∧ d 1=d 3 ∧ d 2=d 4) ∨
  (d 0=d 5 ∧ d 1=d 4 ∧ d 2=d 3)
theorem parity_has_pairing {α : Type*} [DecidableEq α] (d : Fin 6 → α)
    (hp : FibreParity d) : HasPairing d := by
  unfold HasPairing
  by_cases h1_0 : d 1=d 0
  ·
    by_cases h2_0 : d 2=d 0
    ·
      by_cases h3_0 : d 3=d 0
      ·
        by_cases h4_0 : d 4=d 0
        ·
          by_cases h5_0 : d 5=d 0
          ·
            exact Or.inl (⟨by simp only [h1_0, h2_0, h3_0, h4_0, h5_0],by simp only [h1_0, h2_0, h3_0, h4_0, h5_0],by simp only [h1_0, h2_0, h3_0, h4_0, h5_0]⟩)
          ·
            have h := hp (d 0)
            simp [FibreParity, h1_0, h2_0, h3_0, h4_0, h5_0, Ne.symm h5_0] at h
        ·
          by_cases h5_0 : d 5=d 0
          ·
            have h := hp (d 0)
            simp [FibreParity, h1_0, h2_0, h3_0, h5_0, h4_0, Ne.symm h4_0] at h
          ·
            by_cases h5_4 : d 5=d 4
            ·
              exact Or.inl (⟨by simp only [h1_0, h2_0, h3_0, h5_4],by simp only [h1_0, h2_0, h3_0, h5_4],by simp only [h1_0, h2_0, h3_0, h5_4]⟩)
            ·
              have h := hp (d 4)
              simp [FibreParity, h1_0, h2_0, h3_0, h4_0, h5_0, h5_4, Ne.symm h4_0, Ne.symm h5_0, Ne.symm h5_4] at h
      ·
        by_cases h4_0 : d 4=d 0
        ·
          by_cases h5_0 : d 5=d 0
          ·
            have h := hp (d 0)
            simp [FibreParity, h1_0, h2_0, h4_0, h5_0, h3_0, Ne.symm h3_0] at h
          ·
            by_cases h5_3 : d 5=d 3
            ·
              exact Or.inr (Or.inl (⟨by simp only [h1_0, h2_0, h4_0, h5_3],by simp only [h1_0, h2_0, h4_0, h5_3],by simp only [h1_0, h2_0, h4_0, h5_3]⟩))
            ·
              have h := hp (d 3)
              simp [FibreParity, h1_0, h2_0, h4_0, h3_0, h5_0, h5_3, Ne.symm h3_0, Ne.symm h5_0, Ne.symm h5_3] at h
        ·
          by_cases h4_3 : d 4=d 3
          ·
            by_cases h5_0 : d 5=d 0
            ·
              exact Or.inr (Or.inr (Or.inl (⟨by simp only [h1_0, h2_0, h4_3, h5_0],by simp only [h1_0, h2_0, h4_3, h5_0],by simp only [h1_0, h2_0, h4_3, h5_0]⟩)))
            ·
              by_cases h5_3 : d 5=d 3
              ·
                have h := hp (d 0)
                simp [FibreParity, h1_0, h2_0, h4_3, h5_3, h3_0, h4_0, h5_0, Ne.symm h3_0, Ne.symm h4_0, Ne.symm h5_0] at h
              ·
                have h := hp (d 0)
                simp [FibreParity, h1_0, h2_0, h4_3, h3_0, h4_0, h5_0, h5_3, Ne.symm h3_0, Ne.symm h4_0, Ne.symm h5_0, Ne.symm h5_3] at h
          ·
            by_cases h5_0 : d 5=d 0
            ·
              have h := hp (d 3)
              simp [FibreParity, h1_0, h2_0, h5_0, h3_0, h4_0, h4_3, Ne.symm h3_0, Ne.symm h4_0, Ne.symm h4_3] at h
            ·
              by_cases h5_3 : d 5=d 3
              ·
                have h := hp (d 0)
                simp [FibreParity, h1_0, h2_0, h5_3, h3_0, h4_0, h4_3, h5_0, Ne.symm h3_0, Ne.symm h4_0, Ne.symm h4_3, Ne.symm h5_0] at h
              ·
                by_cases h5_4 : d 5=d 4
                ·
                  have h := hp (d 0)
                  simp [FibreParity, h1_0, h2_0, h5_4, h3_0, h4_0, h4_3, h5_0, h5_3, Ne.symm h3_0, Ne.symm h4_0, Ne.symm h4_3, Ne.symm h5_0, Ne.symm h5_3] at h
                ·
                  have h := hp (d 0)
                  simp [FibreParity, h1_0, h2_0, h3_0, h4_0, h4_3, h5_0, h5_3, h5_4, Ne.symm h3_0, Ne.symm h4_0, Ne.symm h4_3, Ne.symm h5_0, Ne.symm h5_3, Ne.symm h5_4] at h
    ·
      by_cases h3_0 : d 3=d 0
      ·
        by_cases h4_0 : d 4=d 0
        ·
          by_cases h5_0 : d 5=d 0
          ·
            have h := hp (d 0)
            simp [FibreParity, h1_0, h3_0, h4_0, h5_0, h2_0, Ne.symm h2_0] at h
          ·
            by_cases h5_2 : d 5=d 2
            ·
              exact Or.inr (Or.inr (Or.inl (⟨by simp only [h1_0, h3_0, h4_0, h5_2],by simp only [h1_0, h3_0, h4_0, h5_2],by simp only [h1_0, h3_0, h4_0, h5_2]⟩)))
            ·
              have h := hp (d 2)
              simp [FibreParity, h1_0, h3_0, h4_0, h2_0, h5_0, h5_2, Ne.symm h2_0, Ne.symm h5_0, Ne.symm h5_2] at h
        ·
          by_cases h4_2 : d 4=d 2
          ·
            by_cases h5_0 : d 5=d 0
            ·
              exact Or.inr (Or.inl (⟨by simp only [h1_0, h3_0, h4_2, h5_0],by simp only [h1_0, h3_0, h4_2, h5_0],by simp only [h1_0, h3_0, h4_2, h5_0]⟩))
            ·
              by_cases h5_2 : d 5=d 2
              ·
                have h := hp (d 0)
                simp [FibreParity, h1_0, h3_0, h4_2, h5_2, h2_0, h4_0, h5_0, Ne.symm h2_0, Ne.symm h4_0, Ne.symm h5_0] at h
              ·
                have h := hp (d 0)
                simp [FibreParity, h1_0, h3_0, h4_2, h2_0, h4_0, h5_0, h5_2, Ne.symm h2_0, Ne.symm h4_0, Ne.symm h5_0, Ne.symm h5_2] at h
          ·
            by_cases h5_0 : d 5=d 0
            ·
              have h := hp (d 2)
              simp [FibreParity, h1_0, h3_0, h5_0, h2_0, h4_0, h4_2, Ne.symm h2_0, Ne.symm h4_0, Ne.symm h4_2] at h
            ·
              by_cases h5_2 : d 5=d 2
              ·
                have h := hp (d 0)
                simp [FibreParity, h1_0, h3_0, h5_2, h2_0, h4_0, h4_2, h5_0, Ne.symm h2_0, Ne.symm h4_0, Ne.symm h4_2, Ne.symm h5_0] at h
              ·
                by_cases h5_4 : d 5=d 4
                ·
                  have h := hp (d 0)
                  simp [FibreParity, h1_0, h3_0, h5_4, h2_0, h4_0, h4_2, h5_0, h5_2, Ne.symm h2_0, Ne.symm h4_0, Ne.symm h4_2, Ne.symm h5_0, Ne.symm h5_2] at h
                ·
                  have h := hp (d 0)
                  simp [FibreParity, h1_0, h3_0, h2_0, h4_0, h4_2, h5_0, h5_2, h5_4, Ne.symm h2_0, Ne.symm h4_0, Ne.symm h4_2, Ne.symm h5_0, Ne.symm h5_2, Ne.symm h5_4] at h
      ·
        by_cases h3_2 : d 3=d 2
        ·
          by_cases h4_0 : d 4=d 0
          ·
            by_cases h5_0 : d 5=d 0
            ·
              exact Or.inl (⟨by simp only [h1_0, h3_2, h4_0, h5_0],by simp only [h1_0, h3_2, h4_0, h5_0],by simp only [h1_0, h3_2, h4_0, h5_0]⟩)
            ·
              by_cases h5_2 : d 5=d 2
              ·
                have h := hp (d 0)
                simp [FibreParity, h1_0, h3_2, h4_0, h5_2, h2_0, h3_0, h5_0, Ne.symm h2_0, Ne.symm h3_0, Ne.symm h5_0] at h
              ·
                have h := hp (d 0)
                simp [FibreParity, h1_0, h3_2, h4_0, h2_0, h3_0, h5_0, h5_2, Ne.symm h2_0, Ne.symm h3_0, Ne.symm h5_0, Ne.symm h5_2] at h
          ·
            by_cases h4_2 : d 4=d 2
            ·
              by_cases h5_0 : d 5=d 0
              ·
                have h := hp (d 0)
                simp [FibreParity, h1_0, h3_2, h4_2, h5_0, h2_0, h3_0, h4_0, Ne.symm h2_0, Ne.symm h3_0, Ne.symm h4_0] at h
              ·
                by_cases h5_2 : d 5=d 2
                ·
                  exact Or.inl (⟨by simp only [h1_0, h3_2, h4_2, h5_2],by simp only [h1_0, h3_2, h4_2, h5_2],by simp only [h1_0, h3_2, h4_2, h5_2]⟩)
                ·
                  have h := hp (d 2)
                  simp [FibreParity, h1_0, h3_2, h4_2, h2_0, h3_0, h4_0, h5_0, h5_2, Ne.symm h2_0, Ne.symm h3_0, Ne.symm h4_0, Ne.symm h5_0, Ne.symm h5_2] at h
            ·
              by_cases h5_0 : d 5=d 0
              ·
                have h := hp (d 0)
                simp [FibreParity, h1_0, h3_2, h5_0, h2_0, h3_0, h4_0, h4_2, Ne.symm h2_0, Ne.symm h3_0, Ne.symm h4_0, Ne.symm h4_2] at h
              ·
                by_cases h5_2 : d 5=d 2
                ·
                  have h := hp (d 2)
                  simp [FibreParity, h1_0, h3_2, h5_2, h2_0, h3_0, h4_0, h4_2, h5_0, Ne.symm h2_0, Ne.symm h3_0, Ne.symm h4_0, Ne.symm h4_2, Ne.symm h5_0] at h
                ·
                  by_cases h5_4 : d 5=d 4
                  ·
                    exact Or.inl (⟨by simp only [h1_0, h3_2, h5_4],by simp only [h1_0, h3_2, h5_4],by simp only [h1_0, h3_2, h5_4]⟩)
                  ·
                    have h := hp (d 4)
                    simp [FibreParity, h1_0, h3_2, h2_0, h3_0, h4_0, h4_2, h5_0, h5_2, h5_4, Ne.symm h2_0, Ne.symm h3_0, Ne.symm h4_0, Ne.symm h4_2, Ne.symm h5_0, Ne.symm h5_2, Ne.symm h5_4] at h
        ·
          by_cases h4_0 : d 4=d 0
          ·
            by_cases h5_0 : d 5=d 0
            ·
              have h := hp (d 2)
              simp [FibreParity, h1_0, h4_0, h5_0, h2_0, h3_0, h3_2, Ne.symm h2_0, Ne.symm h3_0, Ne.symm h3_2] at h
            ·
              by_cases h5_2 : d 5=d 2
              ·
                have h := hp (d 0)
                simp [FibreParity, h1_0, h4_0, h5_2, h2_0, h3_0, h3_2, h5_0, Ne.symm h2_0, Ne.symm h3_0, Ne.symm h3_2, Ne.symm h5_0] at h
              ·
                by_cases h5_3 : d 5=d 3
                ·
                  have h := hp (d 0)
                  simp [FibreParity, h1_0, h4_0, h5_3, h2_0, h3_0, h3_2, h5_0, h5_2, Ne.symm h2_0, Ne.symm h3_0, Ne.symm h3_2, Ne.symm h5_0, Ne.symm h5_2] at h
                ·
                  have h := hp (d 0)
                  simp [FibreParity, h1_0, h4_0, h2_0, h3_0, h3_2, h5_0, h5_2, h5_3, Ne.symm h2_0, Ne.symm h3_0, Ne.symm h3_2, Ne.symm h5_0, Ne.symm h5_2, Ne.symm h5_3] at h
          ·
            by_cases h4_2 : d 4=d 2
            ·
              by_cases h5_0 : d 5=d 0
              ·
                have h := hp (d 0)
                simp [FibreParity, h1_0, h4_2, h5_0, h2_0, h3_0, h3_2, h4_0, Ne.symm h2_0, Ne.symm h3_0, Ne.symm h3_2, Ne.symm h4_0] at h
              ·
                by_cases h5_2 : d 5=d 2
                ·
                  have h := hp (d 2)
                  simp [FibreParity, h1_0, h4_2, h5_2, h2_0, h3_0, h3_2, h4_0, h5_0, Ne.symm h2_0, Ne.symm h3_0, Ne.symm h3_2, Ne.symm h4_0, Ne.symm h5_0] at h
                ·
                  by_cases h5_3 : d 5=d 3
                  ·
                    exact Or.inr (Or.inl (⟨by simp only [h1_0, h4_2, h5_3],by simp only [h1_0, h4_2, h5_3],by simp only [h1_0, h4_2, h5_3]⟩))
                  ·
                    have h := hp (d 3)
                    simp [FibreParity, h1_0, h4_2, h2_0, h3_0, h3_2, h4_0, h5_0, h5_2, h5_3, Ne.symm h2_0, Ne.symm h3_0, Ne.symm h3_2, Ne.symm h4_0, Ne.symm h5_0, Ne.symm h5_2, Ne.symm h5_3] at h
            ·
              by_cases h4_3 : d 4=d 3
              ·
                by_cases h5_0 : d 5=d 0
                ·
                  have h := hp (d 0)
                  simp [FibreParity, h1_0, h4_3, h5_0, h2_0, h3_0, h3_2, h4_0, h4_2, Ne.symm h2_0, Ne.symm h3_0, Ne.symm h3_2, Ne.symm h4_0, Ne.symm h4_2] at h
                ·
                  by_cases h5_2 : d 5=d 2
                  ·
                    exact Or.inr (Or.inr (Or.inl (⟨by simp only [h1_0, h4_3, h5_2],by simp only [h1_0, h4_3, h5_2],by simp only [h1_0, h4_3, h5_2]⟩)))
                  ·
                    by_cases h5_3 : d 5=d 3
                    ·
                      have h := hp (d 2)
                      simp [FibreParity, h1_0, h4_3, h5_3, h2_0, h3_0, h3_2, h4_0, h4_2, h5_0, h5_2, Ne.symm h2_0, Ne.symm h3_0, Ne.symm h3_2, Ne.symm h4_0, Ne.symm h4_2, Ne.symm h5_0, Ne.symm h5_2] at h
                    ·
                      have h := hp (d 2)
                      simp [FibreParity, h1_0, h4_3, h2_0, h3_0, h3_2, h4_0, h4_2, h5_0, h5_2, h5_3, Ne.symm h2_0, Ne.symm h3_0, Ne.symm h3_2, Ne.symm h4_0, Ne.symm h4_2, Ne.symm h5_0, Ne.symm h5_2, Ne.symm h5_3] at h
              ·
                by_cases h5_0 : d 5=d 0
                ·
                  have h := hp (d 0)
                  simp [FibreParity, h1_0, h5_0, h2_0, h3_0, h3_2, h4_0, h4_2, h4_3, Ne.symm h2_0, Ne.symm h3_0, Ne.symm h3_2, Ne.symm h4_0, Ne.symm h4_2, Ne.symm h4_3] at h
                ·
                  by_cases h5_2 : d 5=d 2
                  ·
                    have h := hp (d 3)
                    simp [FibreParity, h1_0, h5_2, h2_0, h3_0, h3_2, h4_0, h4_2, h4_3, h5_0, Ne.symm h2_0, Ne.symm h3_0, Ne.symm h3_2, Ne.symm h4_0, Ne.symm h4_2, Ne.symm h4_3, Ne.symm h5_0] at h
                  ·
                    by_cases h5_3 : d 5=d 3
                    ·
                      have h := hp (d 2)
                      simp [FibreParity, h1_0, h5_3, h2_0, h3_0, h3_2, h4_0, h4_2, h4_3, h5_0, h5_2, Ne.symm h2_0, Ne.symm h3_0, Ne.symm h3_2, Ne.symm h4_0, Ne.symm h4_2, Ne.symm h4_3, Ne.symm h5_0, Ne.symm h5_2] at h
                    ·
                      by_cases h5_4 : d 5=d 4
                      ·
                        have h := hp (d 2)
                        simp [FibreParity, h1_0, h5_4, h2_0, h3_0, h3_2, h4_0, h4_2, h4_3, h5_0, h5_2, h5_3, Ne.symm h2_0, Ne.symm h3_0, Ne.symm h3_2, Ne.symm h4_0, Ne.symm h4_2, Ne.symm h4_3, Ne.symm h5_0, Ne.symm h5_2, Ne.symm h5_3] at h
                      ·
                        have h := hp (d 2)
                        simp [FibreParity, h1_0, h2_0, h3_0, h3_2, h4_0, h4_2, h4_3, h5_0, h5_2, h5_3, h5_4, Ne.symm h2_0, Ne.symm h3_0, Ne.symm h3_2, Ne.symm h4_0, Ne.symm h4_2, Ne.symm h4_3, Ne.symm h5_0, Ne.symm h5_2, Ne.symm h5_3, Ne.symm h5_4] at h
  ·
    by_cases h2_0 : d 2=d 0
    ·
      by_cases h3_0 : d 3=d 0
      ·
        by_cases h4_0 : d 4=d 0
        ·
          by_cases h5_0 : d 5=d 0
          ·
            have h := hp (d 0)
            simp [FibreParity, h2_0, h3_0, h4_0, h5_0, h1_0, Ne.symm h1_0] at h
          ·
            by_cases h5_1 : d 5=d 1
            ·
              exact Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inl (⟨by simp only [h2_0, h3_0, h4_0, h5_1],by simp only [h2_0, h3_0, h4_0, h5_1],by simp only [h2_0, h3_0, h4_0, h5_1]⟩))))))
            ·
              have h := hp (d 1)
              simp [FibreParity, h2_0, h3_0, h4_0, h1_0, h5_0, h5_1, Ne.symm h1_0, Ne.symm h5_0, Ne.symm h5_1] at h
        ·
          by_cases h4_1 : d 4=d 1
          ·
            by_cases h5_0 : d 5=d 0
            ·
              exact Or.inr (Or.inr (Or.inr (Or.inr (Or.inl (⟨by simp only [h2_0, h3_0, h4_1, h5_0],by simp only [h2_0, h3_0, h4_1, h5_0],by simp only [h2_0, h3_0, h4_1, h5_0]⟩)))))
            ·
              by_cases h5_1 : d 5=d 1
              ·
                have h := hp (d 0)
                simp [FibreParity, h2_0, h3_0, h4_1, h5_1, h1_0, h4_0, h5_0, Ne.symm h1_0, Ne.symm h4_0, Ne.symm h5_0] at h
              ·
                have h := hp (d 0)
                simp [FibreParity, h2_0, h3_0, h4_1, h1_0, h4_0, h5_0, h5_1, Ne.symm h1_0, Ne.symm h4_0, Ne.symm h5_0, Ne.symm h5_1] at h
          ·
            by_cases h5_0 : d 5=d 0
            ·
              have h := hp (d 1)
              simp [FibreParity, h2_0, h3_0, h5_0, h1_0, h4_0, h4_1, Ne.symm h1_0, Ne.symm h4_0, Ne.symm h4_1] at h
            ·
              by_cases h5_1 : d 5=d 1
              ·
                have h := hp (d 0)
                simp [FibreParity, h2_0, h3_0, h5_1, h1_0, h4_0, h4_1, h5_0, Ne.symm h1_0, Ne.symm h4_0, Ne.symm h4_1, Ne.symm h5_0] at h
              ·
                by_cases h5_4 : d 5=d 4
                ·
                  have h := hp (d 0)
                  simp [FibreParity, h2_0, h3_0, h5_4, h1_0, h4_0, h4_1, h5_0, h5_1, Ne.symm h1_0, Ne.symm h4_0, Ne.symm h4_1, Ne.symm h5_0, Ne.symm h5_1] at h
                ·
                  have h := hp (d 0)
                  simp [FibreParity, h2_0, h3_0, h1_0, h4_0, h4_1, h5_0, h5_1, h5_4, Ne.symm h1_0, Ne.symm h4_0, Ne.symm h4_1, Ne.symm h5_0, Ne.symm h5_1, Ne.symm h5_4] at h
      ·
        by_cases h3_1 : d 3=d 1
        ·
          by_cases h4_0 : d 4=d 0
          ·
            by_cases h5_0 : d 5=d 0
            ·
              exact Or.inr (Or.inr (Or.inr (Or.inl (⟨by simp only [h2_0, h3_1, h4_0, h5_0],by simp only [h2_0, h3_1, h4_0, h5_0],by simp only [h2_0, h3_1, h4_0, h5_0]⟩))))
            ·
              by_cases h5_1 : d 5=d 1
              ·
                have h := hp (d 0)
                simp [FibreParity, h2_0, h3_1, h4_0, h5_1, h1_0, h3_0, h5_0, Ne.symm h1_0, Ne.symm h3_0, Ne.symm h5_0] at h
              ·
                have h := hp (d 0)
                simp [FibreParity, h2_0, h3_1, h4_0, h1_0, h3_0, h5_0, h5_1, Ne.symm h1_0, Ne.symm h3_0, Ne.symm h5_0, Ne.symm h5_1] at h
          ·
            by_cases h4_1 : d 4=d 1
            ·
              by_cases h5_0 : d 5=d 0
              ·
                have h := hp (d 0)
                simp [FibreParity, h2_0, h3_1, h4_1, h5_0, h1_0, h3_0, h4_0, Ne.symm h1_0, Ne.symm h3_0, Ne.symm h4_0] at h
              ·
                by_cases h5_1 : d 5=d 1
                ·
                  exact Or.inr (Or.inr (Or.inr (Or.inl (⟨by simp only [h2_0, h3_1, h4_1, h5_1],by simp only [h2_0, h3_1, h4_1, h5_1],by simp only [h2_0, h3_1, h4_1, h5_1]⟩))))
                ·
                  have h := hp (d 1)
                  simp [FibreParity, h2_0, h3_1, h4_1, h1_0, h3_0, h4_0, h5_0, h5_1, Ne.symm h1_0, Ne.symm h3_0, Ne.symm h4_0, Ne.symm h5_0, Ne.symm h5_1] at h
            ·
              by_cases h5_0 : d 5=d 0
              ·
                have h := hp (d 0)
                simp [FibreParity, h2_0, h3_1, h5_0, h1_0, h3_0, h4_0, h4_1, Ne.symm h1_0, Ne.symm h3_0, Ne.symm h4_0, Ne.symm h4_1] at h
              ·
                by_cases h5_1 : d 5=d 1
                ·
                  have h := hp (d 1)
                  simp [FibreParity, h2_0, h3_1, h5_1, h1_0, h3_0, h4_0, h4_1, h5_0, Ne.symm h1_0, Ne.symm h3_0, Ne.symm h4_0, Ne.symm h4_1, Ne.symm h5_0] at h
                ·
                  by_cases h5_4 : d 5=d 4
                  ·
                    exact Or.inr (Or.inr (Or.inr (Or.inl (⟨by simp only [h2_0, h3_1, h5_4],by simp only [h2_0, h3_1, h5_4],by simp only [h2_0, h3_1, h5_4]⟩))))
                  ·
                    have h := hp (d 4)
                    simp [FibreParity, h2_0, h3_1, h1_0, h3_0, h4_0, h4_1, h5_0, h5_1, h5_4, Ne.symm h1_0, Ne.symm h3_0, Ne.symm h4_0, Ne.symm h4_1, Ne.symm h5_0, Ne.symm h5_1, Ne.symm h5_4] at h
        ·
          by_cases h4_0 : d 4=d 0
          ·
            by_cases h5_0 : d 5=d 0
            ·
              have h := hp (d 1)
              simp [FibreParity, h2_0, h4_0, h5_0, h1_0, h3_0, h3_1, Ne.symm h1_0, Ne.symm h3_0, Ne.symm h3_1] at h
            ·
              by_cases h5_1 : d 5=d 1
              ·
                have h := hp (d 0)
                simp [FibreParity, h2_0, h4_0, h5_1, h1_0, h3_0, h3_1, h5_0, Ne.symm h1_0, Ne.symm h3_0, Ne.symm h3_1, Ne.symm h5_0] at h
              ·
                by_cases h5_3 : d 5=d 3
                ·
                  have h := hp (d 0)
                  simp [FibreParity, h2_0, h4_0, h5_3, h1_0, h3_0, h3_1, h5_0, h5_1, Ne.symm h1_0, Ne.symm h3_0, Ne.symm h3_1, Ne.symm h5_0, Ne.symm h5_1] at h
                ·
                  have h := hp (d 0)
                  simp [FibreParity, h2_0, h4_0, h1_0, h3_0, h3_1, h5_0, h5_1, h5_3, Ne.symm h1_0, Ne.symm h3_0, Ne.symm h3_1, Ne.symm h5_0, Ne.symm h5_1, Ne.symm h5_3] at h
          ·
            by_cases h4_1 : d 4=d 1
            ·
              by_cases h5_0 : d 5=d 0
              ·
                have h := hp (d 0)
                simp [FibreParity, h2_0, h4_1, h5_0, h1_0, h3_0, h3_1, h4_0, Ne.symm h1_0, Ne.symm h3_0, Ne.symm h3_1, Ne.symm h4_0] at h
              ·
                by_cases h5_1 : d 5=d 1
                ·
                  have h := hp (d 1)
                  simp [FibreParity, h2_0, h4_1, h5_1, h1_0, h3_0, h3_1, h4_0, h5_0, Ne.symm h1_0, Ne.symm h3_0, Ne.symm h3_1, Ne.symm h4_0, Ne.symm h5_0] at h
                ·
                  by_cases h5_3 : d 5=d 3
                  ·
                    exact Or.inr (Or.inr (Or.inr (Or.inr (Or.inl (⟨by simp only [h2_0, h4_1, h5_3],by simp only [h2_0, h4_1, h5_3],by simp only [h2_0, h4_1, h5_3]⟩)))))
                  ·
                    have h := hp (d 3)
                    simp [FibreParity, h2_0, h4_1, h1_0, h3_0, h3_1, h4_0, h5_0, h5_1, h5_3, Ne.symm h1_0, Ne.symm h3_0, Ne.symm h3_1, Ne.symm h4_0, Ne.symm h5_0, Ne.symm h5_1, Ne.symm h5_3] at h
            ·
              by_cases h4_3 : d 4=d 3
              ·
                by_cases h5_0 : d 5=d 0
                ·
                  have h := hp (d 0)
                  simp [FibreParity, h2_0, h4_3, h5_0, h1_0, h3_0, h3_1, h4_0, h4_1, Ne.symm h1_0, Ne.symm h3_0, Ne.symm h3_1, Ne.symm h4_0, Ne.symm h4_1] at h
                ·
                  by_cases h5_1 : d 5=d 1
                  ·
                    exact Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inl (⟨by simp only [h2_0, h4_3, h5_1],by simp only [h2_0, h4_3, h5_1],by simp only [h2_0, h4_3, h5_1]⟩))))))
                  ·
                    by_cases h5_3 : d 5=d 3
                    ·
                      have h := hp (d 1)
                      simp [FibreParity, h2_0, h4_3, h5_3, h1_0, h3_0, h3_1, h4_0, h4_1, h5_0, h5_1, Ne.symm h1_0, Ne.symm h3_0, Ne.symm h3_1, Ne.symm h4_0, Ne.symm h4_1, Ne.symm h5_0, Ne.symm h5_1] at h
                    ·
                      have h := hp (d 1)
                      simp [FibreParity, h2_0, h4_3, h1_0, h3_0, h3_1, h4_0, h4_1, h5_0, h5_1, h5_3, Ne.symm h1_0, Ne.symm h3_0, Ne.symm h3_1, Ne.symm h4_0, Ne.symm h4_1, Ne.symm h5_0, Ne.symm h5_1, Ne.symm h5_3] at h
              ·
                by_cases h5_0 : d 5=d 0
                ·
                  have h := hp (d 0)
                  simp [FibreParity, h2_0, h5_0, h1_0, h3_0, h3_1, h4_0, h4_1, h4_3, Ne.symm h1_0, Ne.symm h3_0, Ne.symm h3_1, Ne.symm h4_0, Ne.symm h4_1, Ne.symm h4_3] at h
                ·
                  by_cases h5_1 : d 5=d 1
                  ·
                    have h := hp (d 3)
                    simp [FibreParity, h2_0, h5_1, h1_0, h3_0, h3_1, h4_0, h4_1, h4_3, h5_0, Ne.symm h1_0, Ne.symm h3_0, Ne.symm h3_1, Ne.symm h4_0, Ne.symm h4_1, Ne.symm h4_3, Ne.symm h5_0] at h
                  ·
                    by_cases h5_3 : d 5=d 3
                    ·
                      have h := hp (d 1)
                      simp [FibreParity, h2_0, h5_3, h1_0, h3_0, h3_1, h4_0, h4_1, h4_3, h5_0, h5_1, Ne.symm h1_0, Ne.symm h3_0, Ne.symm h3_1, Ne.symm h4_0, Ne.symm h4_1, Ne.symm h4_3, Ne.symm h5_0, Ne.symm h5_1] at h
                    ·
                      by_cases h5_4 : d 5=d 4
                      ·
                        have h := hp (d 1)
                        simp [FibreParity, h2_0, h5_4, h1_0, h3_0, h3_1, h4_0, h4_1, h4_3, h5_0, h5_1, h5_3, Ne.symm h1_0, Ne.symm h3_0, Ne.symm h3_1, Ne.symm h4_0, Ne.symm h4_1, Ne.symm h4_3, Ne.symm h5_0, Ne.symm h5_1, Ne.symm h5_3] at h
                      ·
                        have h := hp (d 1)
                        simp [FibreParity, h2_0, h1_0, h3_0, h3_1, h4_0, h4_1, h4_3, h5_0, h5_1, h5_3, h5_4, Ne.symm h1_0, Ne.symm h3_0, Ne.symm h3_1, Ne.symm h4_0, Ne.symm h4_1, Ne.symm h4_3, Ne.symm h5_0, Ne.symm h5_1, Ne.symm h5_3, Ne.symm h5_4] at h
    ·
      by_cases h2_1 : d 2=d 1
      ·
        by_cases h3_0 : d 3=d 0
        ·
          by_cases h4_0 : d 4=d 0
          ·
            by_cases h5_0 : d 5=d 0
            ·
              exact Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inl (⟨by simp only [h2_1, h3_0, h4_0, h5_0],by simp only [h2_1, h3_0, h4_0, h5_0],by simp only [h2_1, h3_0, h4_0, h5_0]⟩)))))))
            ·
              by_cases h5_1 : d 5=d 1
              ·
                have h := hp (d 0)
                simp [FibreParity, h2_1, h3_0, h4_0, h5_1, h1_0, h2_0, h5_0, Ne.symm h1_0, Ne.symm h2_0, Ne.symm h5_0] at h
              ·
                have h := hp (d 0)
                simp [FibreParity, h2_1, h3_0, h4_0, h1_0, h2_0, h5_0, h5_1, Ne.symm h1_0, Ne.symm h2_0, Ne.symm h5_0, Ne.symm h5_1] at h
          ·
            by_cases h4_1 : d 4=d 1
            ·
              by_cases h5_0 : d 5=d 0
              ·
                have h := hp (d 0)
                simp [FibreParity, h2_1, h3_0, h4_1, h5_0, h1_0, h2_0, h4_0, Ne.symm h1_0, Ne.symm h2_0, Ne.symm h4_0] at h
              ·
                by_cases h5_1 : d 5=d 1
                ·
                  exact Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inl (⟨by simp only [h2_1, h3_0, h4_1, h5_1],by simp only [h2_1, h3_0, h4_1, h5_1],by simp only [h2_1, h3_0, h4_1, h5_1]⟩)))))))
                ·
                  have h := hp (d 1)
                  simp [FibreParity, h2_1, h3_0, h4_1, h1_0, h2_0, h4_0, h5_0, h5_1, Ne.symm h1_0, Ne.symm h2_0, Ne.symm h4_0, Ne.symm h5_0, Ne.symm h5_1] at h
            ·
              by_cases h5_0 : d 5=d 0
              ·
                have h := hp (d 0)
                simp [FibreParity, h2_1, h3_0, h5_0, h1_0, h2_0, h4_0, h4_1, Ne.symm h1_0, Ne.symm h2_0, Ne.symm h4_0, Ne.symm h4_1] at h
              ·
                by_cases h5_1 : d 5=d 1
                ·
                  have h := hp (d 1)
                  simp [FibreParity, h2_1, h3_0, h5_1, h1_0, h2_0, h4_0, h4_1, h5_0, Ne.symm h1_0, Ne.symm h2_0, Ne.symm h4_0, Ne.symm h4_1, Ne.symm h5_0] at h
                ·
                  by_cases h5_4 : d 5=d 4
                  ·
                    exact Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inl (⟨by simp only [h2_1, h3_0, h5_4],by simp only [h2_1, h3_0, h5_4],by simp only [h2_1, h3_0, h5_4]⟩)))))))
                  ·
                    have h := hp (d 4)
                    simp [FibreParity, h2_1, h3_0, h1_0, h2_0, h4_0, h4_1, h5_0, h5_1, h5_4, Ne.symm h1_0, Ne.symm h2_0, Ne.symm h4_0, Ne.symm h4_1, Ne.symm h5_0, Ne.symm h5_1, Ne.symm h5_4] at h
        ·
          by_cases h3_1 : d 3=d 1
          ·
            by_cases h4_0 : d 4=d 0
            ·
              by_cases h5_0 : d 5=d 0
              ·
                have h := hp (d 0)
                simp [FibreParity, h2_1, h3_1, h4_0, h5_0, h1_0, h2_0, h3_0, Ne.symm h1_0, Ne.symm h2_0, Ne.symm h3_0] at h
              ·
                by_cases h5_1 : d 5=d 1
                ·
                  exact Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inl (⟨by simp only [h2_1, h3_1, h4_0, h5_1],by simp only [h2_1, h3_1, h4_0, h5_1],by simp only [h2_1, h3_1, h4_0, h5_1]⟩))))))))))
                ·
                  have h := hp (d 1)
                  simp [FibreParity, h2_1, h3_1, h4_0, h1_0, h2_0, h3_0, h5_0, h5_1, Ne.symm h1_0, Ne.symm h2_0, Ne.symm h3_0, Ne.symm h5_0, Ne.symm h5_1] at h
            ·
              by_cases h4_1 : d 4=d 1
              ·
                by_cases h5_0 : d 5=d 0
                ·
                  exact Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inl (⟨by simp only [h2_1, h3_1, h4_1, h5_0],by simp only [h2_1, h3_1, h4_1, h5_0],by simp only [h2_1, h3_1, h4_1, h5_0]⟩)))))))))))))
                ·
                  by_cases h5_1 : d 5=d 1
                  ·
                    have h := hp (d 0)
                    simp [FibreParity, h2_1, h3_1, h4_1, h5_1, h1_0, h2_0, h3_0, h4_0, h5_0, Ne.symm h1_0, Ne.symm h2_0, Ne.symm h3_0, Ne.symm h4_0, Ne.symm h5_0] at h
                  ·
                    have h := hp (d 0)
                    simp [FibreParity, h2_1, h3_1, h4_1, h1_0, h2_0, h3_0, h4_0, h5_0, h5_1, Ne.symm h1_0, Ne.symm h2_0, Ne.symm h3_0, Ne.symm h4_0, Ne.symm h5_0, Ne.symm h5_1] at h
              ·
                by_cases h5_0 : d 5=d 0
                ·
                  have h := hp (d 1)
                  simp [FibreParity, h2_1, h3_1, h5_0, h1_0, h2_0, h3_0, h4_0, h4_1, Ne.symm h1_0, Ne.symm h2_0, Ne.symm h3_0, Ne.symm h4_0, Ne.symm h4_1] at h
                ·
                  by_cases h5_1 : d 5=d 1
                  ·
                    have h := hp (d 0)
                    simp [FibreParity, h2_1, h3_1, h5_1, h1_0, h2_0, h3_0, h4_0, h4_1, h5_0, Ne.symm h1_0, Ne.symm h2_0, Ne.symm h3_0, Ne.symm h4_0, Ne.symm h4_1, Ne.symm h5_0] at h
                  ·
                    by_cases h5_4 : d 5=d 4
                    ·
                      have h := hp (d 0)
                      simp [FibreParity, h2_1, h3_1, h5_4, h1_0, h2_0, h3_0, h4_0, h4_1, h5_0, h5_1, Ne.symm h1_0, Ne.symm h2_0, Ne.symm h3_0, Ne.symm h4_0, Ne.symm h4_1, Ne.symm h5_0, Ne.symm h5_1] at h
                    ·
                      have h := hp (d 0)
                      simp [FibreParity, h2_1, h3_1, h1_0, h2_0, h3_0, h4_0, h4_1, h5_0, h5_1, h5_4, Ne.symm h1_0, Ne.symm h2_0, Ne.symm h3_0, Ne.symm h4_0, Ne.symm h4_1, Ne.symm h5_0, Ne.symm h5_1, Ne.symm h5_4] at h
          ·
            by_cases h4_0 : d 4=d 0
            ·
              by_cases h5_0 : d 5=d 0
              ·
                have h := hp (d 0)
                simp [FibreParity, h2_1, h4_0, h5_0, h1_0, h2_0, h3_0, h3_1, Ne.symm h1_0, Ne.symm h2_0, Ne.symm h3_0, Ne.symm h3_1] at h
              ·
                by_cases h5_1 : d 5=d 1
                ·
                  have h := hp (d 1)
                  simp [FibreParity, h2_1, h4_0, h5_1, h1_0, h2_0, h3_0, h3_1, h5_0, Ne.symm h1_0, Ne.symm h2_0, Ne.symm h3_0, Ne.symm h3_1, Ne.symm h5_0] at h
                ·
                  by_cases h5_3 : d 5=d 3
                  ·
                    exact Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inl (⟨by simp only [h2_1, h4_0, h5_3],by simp only [h2_1, h4_0, h5_3],by simp only [h2_1, h4_0, h5_3]⟩))))))))))
                  ·
                    have h := hp (d 3)
                    simp [FibreParity, h2_1, h4_0, h1_0, h2_0, h3_0, h3_1, h5_0, h5_1, h5_3, Ne.symm h1_0, Ne.symm h2_0, Ne.symm h3_0, Ne.symm h3_1, Ne.symm h5_0, Ne.symm h5_1, Ne.symm h5_3] at h
            ·
              by_cases h4_1 : d 4=d 1
              ·
                by_cases h5_0 : d 5=d 0
                ·
                  have h := hp (d 1)
                  simp [FibreParity, h2_1, h4_1, h5_0, h1_0, h2_0, h3_0, h3_1, h4_0, Ne.symm h1_0, Ne.symm h2_0, Ne.symm h3_0, Ne.symm h3_1, Ne.symm h4_0] at h
                ·
                  by_cases h5_1 : d 5=d 1
                  ·
                    have h := hp (d 0)
                    simp [FibreParity, h2_1, h4_1, h5_1, h1_0, h2_0, h3_0, h3_1, h4_0, h5_0, Ne.symm h1_0, Ne.symm h2_0, Ne.symm h3_0, Ne.symm h3_1, Ne.symm h4_0, Ne.symm h5_0] at h
                  ·
                    by_cases h5_3 : d 5=d 3
                    ·
                      have h := hp (d 0)
                      simp [FibreParity, h2_1, h4_1, h5_3, h1_0, h2_0, h3_0, h3_1, h4_0, h5_0, h5_1, Ne.symm h1_0, Ne.symm h2_0, Ne.symm h3_0, Ne.symm h3_1, Ne.symm h4_0, Ne.symm h5_0, Ne.symm h5_1] at h
                    ·
                      have h := hp (d 0)
                      simp [FibreParity, h2_1, h4_1, h1_0, h2_0, h3_0, h3_1, h4_0, h5_0, h5_1, h5_3, Ne.symm h1_0, Ne.symm h2_0, Ne.symm h3_0, Ne.symm h3_1, Ne.symm h4_0, Ne.symm h5_0, Ne.symm h5_1, Ne.symm h5_3] at h
              ·
                by_cases h4_3 : d 4=d 3
                ·
                  by_cases h5_0 : d 5=d 0
                  ·
                    exact Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inl (⟨by simp only [h2_1, h4_3, h5_0],by simp only [h2_1, h4_3, h5_0],by simp only [h2_1, h4_3, h5_0]⟩)))))))))))))
                  ·
                    by_cases h5_1 : d 5=d 1
                    ·
                      have h := hp (d 0)
                      simp [FibreParity, h2_1, h4_3, h5_1, h1_0, h2_0, h3_0, h3_1, h4_0, h4_1, h5_0, Ne.symm h1_0, Ne.symm h2_0, Ne.symm h3_0, Ne.symm h3_1, Ne.symm h4_0, Ne.symm h4_1, Ne.symm h5_0] at h
                    ·
                      by_cases h5_3 : d 5=d 3
                      ·
                        have h := hp (d 0)
                        simp [FibreParity, h2_1, h4_3, h5_3, h1_0, h2_0, h3_0, h3_1, h4_0, h4_1, h5_0, h5_1, Ne.symm h1_0, Ne.symm h2_0, Ne.symm h3_0, Ne.symm h3_1, Ne.symm h4_0, Ne.symm h4_1, Ne.symm h5_0, Ne.symm h5_1] at h
                      ·
                        have h := hp (d 0)
                        simp [FibreParity, h2_1, h4_3, h1_0, h2_0, h3_0, h3_1, h4_0, h4_1, h5_0, h5_1, h5_3, Ne.symm h1_0, Ne.symm h2_0, Ne.symm h3_0, Ne.symm h3_1, Ne.symm h4_0, Ne.symm h4_1, Ne.symm h5_0, Ne.symm h5_1, Ne.symm h5_3] at h
                ·
                  by_cases h5_0 : d 5=d 0
                  ·
                    have h := hp (d 3)
                    simp [FibreParity, h2_1, h5_0, h1_0, h2_0, h3_0, h3_1, h4_0, h4_1, h4_3, Ne.symm h1_0, Ne.symm h2_0, Ne.symm h3_0, Ne.symm h3_1, Ne.symm h4_0, Ne.symm h4_1, Ne.symm h4_3] at h
                  ·
                    by_cases h5_1 : d 5=d 1
                    ·
                      have h := hp (d 0)
                      simp [FibreParity, h2_1, h5_1, h1_0, h2_0, h3_0, h3_1, h4_0, h4_1, h4_3, h5_0, Ne.symm h1_0, Ne.symm h2_0, Ne.symm h3_0, Ne.symm h3_1, Ne.symm h4_0, Ne.symm h4_1, Ne.symm h4_3, Ne.symm h5_0] at h
                    ·
                      by_cases h5_3 : d 5=d 3
                      ·
                        have h := hp (d 0)
                        simp [FibreParity, h2_1, h5_3, h1_0, h2_0, h3_0, h3_1, h4_0, h4_1, h4_3, h5_0, h5_1, Ne.symm h1_0, Ne.symm h2_0, Ne.symm h3_0, Ne.symm h3_1, Ne.symm h4_0, Ne.symm h4_1, Ne.symm h4_3, Ne.symm h5_0, Ne.symm h5_1] at h
                      ·
                        by_cases h5_4 : d 5=d 4
                        ·
                          have h := hp (d 0)
                          simp [FibreParity, h2_1, h5_4, h1_0, h2_0, h3_0, h3_1, h4_0, h4_1, h4_3, h5_0, h5_1, h5_3, Ne.symm h1_0, Ne.symm h2_0, Ne.symm h3_0, Ne.symm h3_1, Ne.symm h4_0, Ne.symm h4_1, Ne.symm h4_3, Ne.symm h5_0, Ne.symm h5_1, Ne.symm h5_3] at h
                        ·
                          have h := hp (d 0)
                          simp [FibreParity, h2_1, h1_0, h2_0, h3_0, h3_1, h4_0, h4_1, h4_3, h5_0, h5_1, h5_3, h5_4, Ne.symm h1_0, Ne.symm h2_0, Ne.symm h3_0, Ne.symm h3_1, Ne.symm h4_0, Ne.symm h4_1, Ne.symm h4_3, Ne.symm h5_0, Ne.symm h5_1, Ne.symm h5_3, Ne.symm h5_4] at h
      ·
        by_cases h3_0 : d 3=d 0
        ·
          by_cases h4_0 : d 4=d 0
          ·
            by_cases h5_0 : d 5=d 0
            ·
              have h := hp (d 1)
              simp [FibreParity, h3_0, h4_0, h5_0, h1_0, h2_0, h2_1, Ne.symm h1_0, Ne.symm h2_0, Ne.symm h2_1] at h
            ·
              by_cases h5_1 : d 5=d 1
              ·
                have h := hp (d 0)
                simp [FibreParity, h3_0, h4_0, h5_1, h1_0, h2_0, h2_1, h5_0, Ne.symm h1_0, Ne.symm h2_0, Ne.symm h2_1, Ne.symm h5_0] at h
              ·
                by_cases h5_2 : d 5=d 2
                ·
                  have h := hp (d 0)
                  simp [FibreParity, h3_0, h4_0, h5_2, h1_0, h2_0, h2_1, h5_0, h5_1, Ne.symm h1_0, Ne.symm h2_0, Ne.symm h2_1, Ne.symm h5_0, Ne.symm h5_1] at h
                ·
                  have h := hp (d 0)
                  simp [FibreParity, h3_0, h4_0, h1_0, h2_0, h2_1, h5_0, h5_1, h5_2, Ne.symm h1_0, Ne.symm h2_0, Ne.symm h2_1, Ne.symm h5_0, Ne.symm h5_1, Ne.symm h5_2] at h
          ·
            by_cases h4_1 : d 4=d 1
            ·
              by_cases h5_0 : d 5=d 0
              ·
                have h := hp (d 0)
                simp [FibreParity, h3_0, h4_1, h5_0, h1_0, h2_0, h2_1, h4_0, Ne.symm h1_0, Ne.symm h2_0, Ne.symm h2_1, Ne.symm h4_0] at h
              ·
                by_cases h5_1 : d 5=d 1
                ·
                  have h := hp (d 1)
                  simp [FibreParity, h3_0, h4_1, h5_1, h1_0, h2_0, h2_1, h4_0, h5_0, Ne.symm h1_0, Ne.symm h2_0, Ne.symm h2_1, Ne.symm h4_0, Ne.symm h5_0] at h
                ·
                  by_cases h5_2 : d 5=d 2
                  ·
                    exact Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inl (⟨by simp only [h3_0, h4_1, h5_2],by simp only [h3_0, h4_1, h5_2],by simp only [h3_0, h4_1, h5_2]⟩))))))))
                  ·
                    have h := hp (d 2)
                    simp [FibreParity, h3_0, h4_1, h1_0, h2_0, h2_1, h4_0, h5_0, h5_1, h5_2, Ne.symm h1_0, Ne.symm h2_0, Ne.symm h2_1, Ne.symm h4_0, Ne.symm h5_0, Ne.symm h5_1, Ne.symm h5_2] at h
            ·
              by_cases h4_2 : d 4=d 2
              ·
                by_cases h5_0 : d 5=d 0
                ·
                  have h := hp (d 0)
                  simp [FibreParity, h3_0, h4_2, h5_0, h1_0, h2_0, h2_1, h4_0, h4_1, Ne.symm h1_0, Ne.symm h2_0, Ne.symm h2_1, Ne.symm h4_0, Ne.symm h4_1] at h
                ·
                  by_cases h5_1 : d 5=d 1
                  ·
                    exact Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inl (⟨by simp only [h3_0, h4_2, h5_1],by simp only [h3_0, h4_2, h5_1],by simp only [h3_0, h4_2, h5_1]⟩)))))))))
                  ·
                    by_cases h5_2 : d 5=d 2
                    ·
                      have h := hp (d 1)
                      simp [FibreParity, h3_0, h4_2, h5_2, h1_0, h2_0, h2_1, h4_0, h4_1, h5_0, h5_1, Ne.symm h1_0, Ne.symm h2_0, Ne.symm h2_1, Ne.symm h4_0, Ne.symm h4_1, Ne.symm h5_0, Ne.symm h5_1] at h
                    ·
                      have h := hp (d 1)
                      simp [FibreParity, h3_0, h4_2, h1_0, h2_0, h2_1, h4_0, h4_1, h5_0, h5_1, h5_2, Ne.symm h1_0, Ne.symm h2_0, Ne.symm h2_1, Ne.symm h4_0, Ne.symm h4_1, Ne.symm h5_0, Ne.symm h5_1, Ne.symm h5_2] at h
              ·
                by_cases h5_0 : d 5=d 0
                ·
                  have h := hp (d 0)
                  simp [FibreParity, h3_0, h5_0, h1_0, h2_0, h2_1, h4_0, h4_1, h4_2, Ne.symm h1_0, Ne.symm h2_0, Ne.symm h2_1, Ne.symm h4_0, Ne.symm h4_1, Ne.symm h4_2] at h
                ·
                  by_cases h5_1 : d 5=d 1
                  ·
                    have h := hp (d 2)
                    simp [FibreParity, h3_0, h5_1, h1_0, h2_0, h2_1, h4_0, h4_1, h4_2, h5_0, Ne.symm h1_0, Ne.symm h2_0, Ne.symm h2_1, Ne.symm h4_0, Ne.symm h4_1, Ne.symm h4_2, Ne.symm h5_0] at h
                  ·
                    by_cases h5_2 : d 5=d 2
                    ·
                      have h := hp (d 1)
                      simp [FibreParity, h3_0, h5_2, h1_0, h2_0, h2_1, h4_0, h4_1, h4_2, h5_0, h5_1, Ne.symm h1_0, Ne.symm h2_0, Ne.symm h2_1, Ne.symm h4_0, Ne.symm h4_1, Ne.symm h4_2, Ne.symm h5_0, Ne.symm h5_1] at h
                    ·
                      by_cases h5_4 : d 5=d 4
                      ·
                        have h := hp (d 1)
                        simp [FibreParity, h3_0, h5_4, h1_0, h2_0, h2_1, h4_0, h4_1, h4_2, h5_0, h5_1, h5_2, Ne.symm h1_0, Ne.symm h2_0, Ne.symm h2_1, Ne.symm h4_0, Ne.symm h4_1, Ne.symm h4_2, Ne.symm h5_0, Ne.symm h5_1, Ne.symm h5_2] at h
                      ·
                        have h := hp (d 1)
                        simp [FibreParity, h3_0, h1_0, h2_0, h2_1, h4_0, h4_1, h4_2, h5_0, h5_1, h5_2, h5_4, Ne.symm h1_0, Ne.symm h2_0, Ne.symm h2_1, Ne.symm h4_0, Ne.symm h4_1, Ne.symm h4_2, Ne.symm h5_0, Ne.symm h5_1, Ne.symm h5_2, Ne.symm h5_4] at h
        ·
          by_cases h3_1 : d 3=d 1
          ·
            by_cases h4_0 : d 4=d 0
            ·
              by_cases h5_0 : d 5=d 0
              ·
                have h := hp (d 0)
                simp [FibreParity, h3_1, h4_0, h5_0, h1_0, h2_0, h2_1, h3_0, Ne.symm h1_0, Ne.symm h2_0, Ne.symm h2_1, Ne.symm h3_0] at h
              ·
                by_cases h5_1 : d 5=d 1
                ·
                  have h := hp (d 1)
                  simp [FibreParity, h3_1, h4_0, h5_1, h1_0, h2_0, h2_1, h3_0, h5_0, Ne.symm h1_0, Ne.symm h2_0, Ne.symm h2_1, Ne.symm h3_0, Ne.symm h5_0] at h
                ·
                  by_cases h5_2 : d 5=d 2
                  ·
                    exact Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inl (⟨by simp only [h3_1, h4_0, h5_2],by simp only [h3_1, h4_0, h5_2],by simp only [h3_1, h4_0, h5_2]⟩)))))))))))
                  ·
                    have h := hp (d 2)
                    simp [FibreParity, h3_1, h4_0, h1_0, h2_0, h2_1, h3_0, h5_0, h5_1, h5_2, Ne.symm h1_0, Ne.symm h2_0, Ne.symm h2_1, Ne.symm h3_0, Ne.symm h5_0, Ne.symm h5_1, Ne.symm h5_2] at h
            ·
              by_cases h4_1 : d 4=d 1
              ·
                by_cases h5_0 : d 5=d 0
                ·
                  have h := hp (d 1)
                  simp [FibreParity, h3_1, h4_1, h5_0, h1_0, h2_0, h2_1, h3_0, h4_0, Ne.symm h1_0, Ne.symm h2_0, Ne.symm h2_1, Ne.symm h3_0, Ne.symm h4_0] at h
                ·
                  by_cases h5_1 : d 5=d 1
                  ·
                    have h := hp (d 0)
                    simp [FibreParity, h3_1, h4_1, h5_1, h1_0, h2_0, h2_1, h3_0, h4_0, h5_0, Ne.symm h1_0, Ne.symm h2_0, Ne.symm h2_1, Ne.symm h3_0, Ne.symm h4_0, Ne.symm h5_0] at h
                  ·
                    by_cases h5_2 : d 5=d 2
                    ·
                      have h := hp (d 0)
                      simp [FibreParity, h3_1, h4_1, h5_2, h1_0, h2_0, h2_1, h3_0, h4_0, h5_0, h5_1, Ne.symm h1_0, Ne.symm h2_0, Ne.symm h2_1, Ne.symm h3_0, Ne.symm h4_0, Ne.symm h5_0, Ne.symm h5_1] at h
                    ·
                      have h := hp (d 0)
                      simp [FibreParity, h3_1, h4_1, h1_0, h2_0, h2_1, h3_0, h4_0, h5_0, h5_1, h5_2, Ne.symm h1_0, Ne.symm h2_0, Ne.symm h2_1, Ne.symm h3_0, Ne.symm h4_0, Ne.symm h5_0, Ne.symm h5_1, Ne.symm h5_2] at h
              ·
                by_cases h4_2 : d 4=d 2
                ·
                  by_cases h5_0 : d 5=d 0
                  ·
                    exact Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inl (⟨by simp only [h3_1, h4_2, h5_0],by simp only [h3_1, h4_2, h5_0],by simp only [h3_1, h4_2, h5_0]⟩))))))))))))))
                  ·
                    by_cases h5_1 : d 5=d 1
                    ·
                      have h := hp (d 0)
                      simp [FibreParity, h3_1, h4_2, h5_1, h1_0, h2_0, h2_1, h3_0, h4_0, h4_1, h5_0, Ne.symm h1_0, Ne.symm h2_0, Ne.symm h2_1, Ne.symm h3_0, Ne.symm h4_0, Ne.symm h4_1, Ne.symm h5_0] at h
                    ·
                      by_cases h5_2 : d 5=d 2
                      ·
                        have h := hp (d 0)
                        simp [FibreParity, h3_1, h4_2, h5_2, h1_0, h2_0, h2_1, h3_0, h4_0, h4_1, h5_0, h5_1, Ne.symm h1_0, Ne.symm h2_0, Ne.symm h2_1, Ne.symm h3_0, Ne.symm h4_0, Ne.symm h4_1, Ne.symm h5_0, Ne.symm h5_1] at h
                      ·
                        have h := hp (d 0)
                        simp [FibreParity, h3_1, h4_2, h1_0, h2_0, h2_1, h3_0, h4_0, h4_1, h5_0, h5_1, h5_2, Ne.symm h1_0, Ne.symm h2_0, Ne.symm h2_1, Ne.symm h3_0, Ne.symm h4_0, Ne.symm h4_1, Ne.symm h5_0, Ne.symm h5_1, Ne.symm h5_2] at h
                ·
                  by_cases h5_0 : d 5=d 0
                  ·
                    have h := hp (d 2)
                    simp [FibreParity, h3_1, h5_0, h1_0, h2_0, h2_1, h3_0, h4_0, h4_1, h4_2, Ne.symm h1_0, Ne.symm h2_0, Ne.symm h2_1, Ne.symm h3_0, Ne.symm h4_0, Ne.symm h4_1, Ne.symm h4_2] at h
                  ·
                    by_cases h5_1 : d 5=d 1
                    ·
                      have h := hp (d 0)
                      simp [FibreParity, h3_1, h5_1, h1_0, h2_0, h2_1, h3_0, h4_0, h4_1, h4_2, h5_0, Ne.symm h1_0, Ne.symm h2_0, Ne.symm h2_1, Ne.symm h3_0, Ne.symm h4_0, Ne.symm h4_1, Ne.symm h4_2, Ne.symm h5_0] at h
                    ·
                      by_cases h5_2 : d 5=d 2
                      ·
                        have h := hp (d 0)
                        simp [FibreParity, h3_1, h5_2, h1_0, h2_0, h2_1, h3_0, h4_0, h4_1, h4_2, h5_0, h5_1, Ne.symm h1_0, Ne.symm h2_0, Ne.symm h2_1, Ne.symm h3_0, Ne.symm h4_0, Ne.symm h4_1, Ne.symm h4_2, Ne.symm h5_0, Ne.symm h5_1] at h
                      ·
                        by_cases h5_4 : d 5=d 4
                        ·
                          have h := hp (d 0)
                          simp [FibreParity, h3_1, h5_4, h1_0, h2_0, h2_1, h3_0, h4_0, h4_1, h4_2, h5_0, h5_1, h5_2, Ne.symm h1_0, Ne.symm h2_0, Ne.symm h2_1, Ne.symm h3_0, Ne.symm h4_0, Ne.symm h4_1, Ne.symm h4_2, Ne.symm h5_0, Ne.symm h5_1, Ne.symm h5_2] at h
                        ·
                          have h := hp (d 0)
                          simp [FibreParity, h3_1, h1_0, h2_0, h2_1, h3_0, h4_0, h4_1, h4_2, h5_0, h5_1, h5_2, h5_4, Ne.symm h1_0, Ne.symm h2_0, Ne.symm h2_1, Ne.symm h3_0, Ne.symm h4_0, Ne.symm h4_1, Ne.symm h4_2, Ne.symm h5_0, Ne.symm h5_1, Ne.symm h5_2, Ne.symm h5_4] at h
          ·
            by_cases h3_2 : d 3=d 2
            ·
              by_cases h4_0 : d 4=d 0
              ·
                by_cases h5_0 : d 5=d 0
                ·
                  have h := hp (d 0)
                  simp [FibreParity, h3_2, h4_0, h5_0, h1_0, h2_0, h2_1, h3_0, h3_1, Ne.symm h1_0, Ne.symm h2_0, Ne.symm h2_1, Ne.symm h3_0, Ne.symm h3_1] at h
                ·
                  by_cases h5_1 : d 5=d 1
                  ·
                    exact Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inl (⟨by simp only [h3_2, h4_0, h5_1],by simp only [h3_2, h4_0, h5_1],by simp only [h3_2, h4_0, h5_1]⟩))))))))))))
                  ·
                    by_cases h5_2 : d 5=d 2
                    ·
                      have h := hp (d 1)
                      simp [FibreParity, h3_2, h4_0, h5_2, h1_0, h2_0, h2_1, h3_0, h3_1, h5_0, h5_1, Ne.symm h1_0, Ne.symm h2_0, Ne.symm h2_1, Ne.symm h3_0, Ne.symm h3_1, Ne.symm h5_0, Ne.symm h5_1] at h
                    ·
                      have h := hp (d 1)
                      simp [FibreParity, h3_2, h4_0, h1_0, h2_0, h2_1, h3_0, h3_1, h5_0, h5_1, h5_2, Ne.symm h1_0, Ne.symm h2_0, Ne.symm h2_1, Ne.symm h3_0, Ne.symm h3_1, Ne.symm h5_0, Ne.symm h5_1, Ne.symm h5_2] at h
              ·
                by_cases h4_1 : d 4=d 1
                ·
                  by_cases h5_0 : d 5=d 0
                  ·
                    exact Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (⟨by simp only [h3_2, h4_1, h5_0],by simp only [h3_2, h4_1, h5_0],by simp only [h3_2, h4_1, h5_0]⟩))))))))))))))
                  ·
                    by_cases h5_1 : d 5=d 1
                    ·
                      have h := hp (d 0)
                      simp [FibreParity, h3_2, h4_1, h5_1, h1_0, h2_0, h2_1, h3_0, h3_1, h4_0, h5_0, Ne.symm h1_0, Ne.symm h2_0, Ne.symm h2_1, Ne.symm h3_0, Ne.symm h3_1, Ne.symm h4_0, Ne.symm h5_0] at h
                    ·
                      by_cases h5_2 : d 5=d 2
                      ·
                        have h := hp (d 0)
                        simp [FibreParity, h3_2, h4_1, h5_2, h1_0, h2_0, h2_1, h3_0, h3_1, h4_0, h5_0, h5_1, Ne.symm h1_0, Ne.symm h2_0, Ne.symm h2_1, Ne.symm h3_0, Ne.symm h3_1, Ne.symm h4_0, Ne.symm h5_0, Ne.symm h5_1] at h
                      ·
                        have h := hp (d 0)
                        simp [FibreParity, h3_2, h4_1, h1_0, h2_0, h2_1, h3_0, h3_1, h4_0, h5_0, h5_1, h5_2, Ne.symm h1_0, Ne.symm h2_0, Ne.symm h2_1, Ne.symm h3_0, Ne.symm h3_1, Ne.symm h4_0, Ne.symm h5_0, Ne.symm h5_1, Ne.symm h5_2] at h
                ·
                  by_cases h4_2 : d 4=d 2
                  ·
                    by_cases h5_0 : d 5=d 0
                    ·
                      have h := hp (d 1)
                      simp [FibreParity, h3_2, h4_2, h5_0, h1_0, h2_0, h2_1, h3_0, h3_1, h4_0, h4_1, Ne.symm h1_0, Ne.symm h2_0, Ne.symm h2_1, Ne.symm h3_0, Ne.symm h3_1, Ne.symm h4_0, Ne.symm h4_1] at h
                    ·
                      by_cases h5_1 : d 5=d 1
                      ·
                        have h := hp (d 0)
                        simp [FibreParity, h3_2, h4_2, h5_1, h1_0, h2_0, h2_1, h3_0, h3_1, h4_0, h4_1, h5_0, Ne.symm h1_0, Ne.symm h2_0, Ne.symm h2_1, Ne.symm h3_0, Ne.symm h3_1, Ne.symm h4_0, Ne.symm h4_1, Ne.symm h5_0] at h
                      ·
                        by_cases h5_2 : d 5=d 2
                        ·
                          have h := hp (d 0)
                          simp [FibreParity, h3_2, h4_2, h5_2, h1_0, h2_0, h2_1, h3_0, h3_1, h4_0, h4_1, h5_0, h5_1, Ne.symm h1_0, Ne.symm h2_0, Ne.symm h2_1, Ne.symm h3_0, Ne.symm h3_1, Ne.symm h4_0, Ne.symm h4_1, Ne.symm h5_0, Ne.symm h5_1] at h
                        ·
                          have h := hp (d 0)
                          simp [FibreParity, h3_2, h4_2, h1_0, h2_0, h2_1, h3_0, h3_1, h4_0, h4_1, h5_0, h5_1, h5_2, Ne.symm h1_0, Ne.symm h2_0, Ne.symm h2_1, Ne.symm h3_0, Ne.symm h3_1, Ne.symm h4_0, Ne.symm h4_1, Ne.symm h5_0, Ne.symm h5_1, Ne.symm h5_2] at h
                  ·
                    by_cases h5_0 : d 5=d 0
                    ·
                      have h := hp (d 1)
                      simp [FibreParity, h3_2, h5_0, h1_0, h2_0, h2_1, h3_0, h3_1, h4_0, h4_1, h4_2, Ne.symm h1_0, Ne.symm h2_0, Ne.symm h2_1, Ne.symm h3_0, Ne.symm h3_1, Ne.symm h4_0, Ne.symm h4_1, Ne.symm h4_2] at h
                    ·
                      by_cases h5_1 : d 5=d 1
                      ·
                        have h := hp (d 0)
                        simp [FibreParity, h3_2, h5_1, h1_0, h2_0, h2_1, h3_0, h3_1, h4_0, h4_1, h4_2, h5_0, Ne.symm h1_0, Ne.symm h2_0, Ne.symm h2_1, Ne.symm h3_0, Ne.symm h3_1, Ne.symm h4_0, Ne.symm h4_1, Ne.symm h4_2, Ne.symm h5_0] at h
                      ·
                        by_cases h5_2 : d 5=d 2
                        ·
                          have h := hp (d 0)
                          simp [FibreParity, h3_2, h5_2, h1_0, h2_0, h2_1, h3_0, h3_1, h4_0, h4_1, h4_2, h5_0, h5_1, Ne.symm h1_0, Ne.symm h2_0, Ne.symm h2_1, Ne.symm h3_0, Ne.symm h3_1, Ne.symm h4_0, Ne.symm h4_1, Ne.symm h4_2, Ne.symm h5_0, Ne.symm h5_1] at h
                        ·
                          by_cases h5_4 : d 5=d 4
                          ·
                            have h := hp (d 0)
                            simp [FibreParity, h3_2, h5_4, h1_0, h2_0, h2_1, h3_0, h3_1, h4_0, h4_1, h4_2, h5_0, h5_1, h5_2, Ne.symm h1_0, Ne.symm h2_0, Ne.symm h2_1, Ne.symm h3_0, Ne.symm h3_1, Ne.symm h4_0, Ne.symm h4_1, Ne.symm h4_2, Ne.symm h5_0, Ne.symm h5_1, Ne.symm h5_2] at h
                          ·
                            have h := hp (d 0)
                            simp [FibreParity, h3_2, h1_0, h2_0, h2_1, h3_0, h3_1, h4_0, h4_1, h4_2, h5_0, h5_1, h5_2, h5_4, Ne.symm h1_0, Ne.symm h2_0, Ne.symm h2_1, Ne.symm h3_0, Ne.symm h3_1, Ne.symm h4_0, Ne.symm h4_1, Ne.symm h4_2, Ne.symm h5_0, Ne.symm h5_1, Ne.symm h5_2, Ne.symm h5_4] at h
            ·
              by_cases h4_0 : d 4=d 0
              ·
                by_cases h5_0 : d 5=d 0
                ·
                  have h := hp (d 0)
                  simp [FibreParity, h4_0, h5_0, h1_0, h2_0, h2_1, h3_0, h3_1, h3_2, Ne.symm h1_0, Ne.symm h2_0, Ne.symm h2_1, Ne.symm h3_0, Ne.symm h3_1, Ne.symm h3_2] at h
                ·
                  by_cases h5_1 : d 5=d 1
                  ·
                    have h := hp (d 2)
                    simp [FibreParity, h4_0, h5_1, h1_0, h2_0, h2_1, h3_0, h3_1, h3_2, h5_0, Ne.symm h1_0, Ne.symm h2_0, Ne.symm h2_1, Ne.symm h3_0, Ne.symm h3_1, Ne.symm h3_2, Ne.symm h5_0] at h
                  ·
                    by_cases h5_2 : d 5=d 2
                    ·
                      have h := hp (d 1)
                      simp [FibreParity, h4_0, h5_2, h1_0, h2_0, h2_1, h3_0, h3_1, h3_2, h5_0, h5_1, Ne.symm h1_0, Ne.symm h2_0, Ne.symm h2_1, Ne.symm h3_0, Ne.symm h3_1, Ne.symm h3_2, Ne.symm h5_0, Ne.symm h5_1] at h
                    ·
                      by_cases h5_3 : d 5=d 3
                      ·
                        have h := hp (d 1)
                        simp [FibreParity, h4_0, h5_3, h1_0, h2_0, h2_1, h3_0, h3_1, h3_2, h5_0, h5_1, h5_2, Ne.symm h1_0, Ne.symm h2_0, Ne.symm h2_1, Ne.symm h3_0, Ne.symm h3_1, Ne.symm h3_2, Ne.symm h5_0, Ne.symm h5_1, Ne.symm h5_2] at h
                      ·
                        have h := hp (d 1)
                        simp [FibreParity, h4_0, h1_0, h2_0, h2_1, h3_0, h3_1, h3_2, h5_0, h5_1, h5_2, h5_3, Ne.symm h1_0, Ne.symm h2_0, Ne.symm h2_1, Ne.symm h3_0, Ne.symm h3_1, Ne.symm h3_2, Ne.symm h5_0, Ne.symm h5_1, Ne.symm h5_2, Ne.symm h5_3] at h
              ·
                by_cases h4_1 : d 4=d 1
                ·
                  by_cases h5_0 : d 5=d 0
                  ·
                    have h := hp (d 2)
                    simp [FibreParity, h4_1, h5_0, h1_0, h2_0, h2_1, h3_0, h3_1, h3_2, h4_0, Ne.symm h1_0, Ne.symm h2_0, Ne.symm h2_1, Ne.symm h3_0, Ne.symm h3_1, Ne.symm h3_2, Ne.symm h4_0] at h
                  ·
                    by_cases h5_1 : d 5=d 1
                    ·
                      have h := hp (d 0)
                      simp [FibreParity, h4_1, h5_1, h1_0, h2_0, h2_1, h3_0, h3_1, h3_2, h4_0, h5_0, Ne.symm h1_0, Ne.symm h2_0, Ne.symm h2_1, Ne.symm h3_0, Ne.symm h3_1, Ne.symm h3_2, Ne.symm h4_0, Ne.symm h5_0] at h
                    ·
                      by_cases h5_2 : d 5=d 2
                      ·
                        have h := hp (d 0)
                        simp [FibreParity, h4_1, h5_2, h1_0, h2_0, h2_1, h3_0, h3_1, h3_2, h4_0, h5_0, h5_1, Ne.symm h1_0, Ne.symm h2_0, Ne.symm h2_1, Ne.symm h3_0, Ne.symm h3_1, Ne.symm h3_2, Ne.symm h4_0, Ne.symm h5_0, Ne.symm h5_1] at h
                      ·
                        by_cases h5_3 : d 5=d 3
                        ·
                          have h := hp (d 0)
                          simp [FibreParity, h4_1, h5_3, h1_0, h2_0, h2_1, h3_0, h3_1, h3_2, h4_0, h5_0, h5_1, h5_2, Ne.symm h1_0, Ne.symm h2_0, Ne.symm h2_1, Ne.symm h3_0, Ne.symm h3_1, Ne.symm h3_2, Ne.symm h4_0, Ne.symm h5_0, Ne.symm h5_1, Ne.symm h5_2] at h
                        ·
                          have h := hp (d 0)
                          simp [FibreParity, h4_1, h1_0, h2_0, h2_1, h3_0, h3_1, h3_2, h4_0, h5_0, h5_1, h5_2, h5_3, Ne.symm h1_0, Ne.symm h2_0, Ne.symm h2_1, Ne.symm h3_0, Ne.symm h3_1, Ne.symm h3_2, Ne.symm h4_0, Ne.symm h5_0, Ne.symm h5_1, Ne.symm h5_2, Ne.symm h5_3] at h
                ·
                  by_cases h4_2 : d 4=d 2
                  ·
                    by_cases h5_0 : d 5=d 0
                    ·
                      have h := hp (d 1)
                      simp [FibreParity, h4_2, h5_0, h1_0, h2_0, h2_1, h3_0, h3_1, h3_2, h4_0, h4_1, Ne.symm h1_0, Ne.symm h2_0, Ne.symm h2_1, Ne.symm h3_0, Ne.symm h3_1, Ne.symm h3_2, Ne.symm h4_0, Ne.symm h4_1] at h
                    ·
                      by_cases h5_1 : d 5=d 1
                      ·
                        have h := hp (d 0)
                        simp [FibreParity, h4_2, h5_1, h1_0, h2_0, h2_1, h3_0, h3_1, h3_2, h4_0, h4_1, h5_0, Ne.symm h1_0, Ne.symm h2_0, Ne.symm h2_1, Ne.symm h3_0, Ne.symm h3_1, Ne.symm h3_2, Ne.symm h4_0, Ne.symm h4_1, Ne.symm h5_0] at h
                      ·
                        by_cases h5_2 : d 5=d 2
                        ·
                          have h := hp (d 0)
                          simp [FibreParity, h4_2, h5_2, h1_0, h2_0, h2_1, h3_0, h3_1, h3_2, h4_0, h4_1, h5_0, h5_1, Ne.symm h1_0, Ne.symm h2_0, Ne.symm h2_1, Ne.symm h3_0, Ne.symm h3_1, Ne.symm h3_2, Ne.symm h4_0, Ne.symm h4_1, Ne.symm h5_0, Ne.symm h5_1] at h
                        ·
                          by_cases h5_3 : d 5=d 3
                          ·
                            have h := hp (d 0)
                            simp [FibreParity, h4_2, h5_3, h1_0, h2_0, h2_1, h3_0, h3_1, h3_2, h4_0, h4_1, h5_0, h5_1, h5_2, Ne.symm h1_0, Ne.symm h2_0, Ne.symm h2_1, Ne.symm h3_0, Ne.symm h3_1, Ne.symm h3_2, Ne.symm h4_0, Ne.symm h4_1, Ne.symm h5_0, Ne.symm h5_1, Ne.symm h5_2] at h
                          ·
                            have h := hp (d 0)
                            simp [FibreParity, h4_2, h1_0, h2_0, h2_1, h3_0, h3_1, h3_2, h4_0, h4_1, h5_0, h5_1, h5_2, h5_3, Ne.symm h1_0, Ne.symm h2_0, Ne.symm h2_1, Ne.symm h3_0, Ne.symm h3_1, Ne.symm h3_2, Ne.symm h4_0, Ne.symm h4_1, Ne.symm h5_0, Ne.symm h5_1, Ne.symm h5_2, Ne.symm h5_3] at h
                  ·
                    by_cases h4_3 : d 4=d 3
                    ·
                      by_cases h5_0 : d 5=d 0
                      ·
                        have h := hp (d 1)
                        simp [FibreParity, h4_3, h5_0, h1_0, h2_0, h2_1, h3_0, h3_1, h3_2, h4_0, h4_1, h4_2, Ne.symm h1_0, Ne.symm h2_0, Ne.symm h2_1, Ne.symm h3_0, Ne.symm h3_1, Ne.symm h3_2, Ne.symm h4_0, Ne.symm h4_1, Ne.symm h4_2] at h
                      ·
                        by_cases h5_1 : d 5=d 1
                        ·
                          have h := hp (d 0)
                          simp [FibreParity, h4_3, h5_1, h1_0, h2_0, h2_1, h3_0, h3_1, h3_2, h4_0, h4_1, h4_2, h5_0, Ne.symm h1_0, Ne.symm h2_0, Ne.symm h2_1, Ne.symm h3_0, Ne.symm h3_1, Ne.symm h3_2, Ne.symm h4_0, Ne.symm h4_1, Ne.symm h4_2, Ne.symm h5_0] at h
                        ·
                          by_cases h5_2 : d 5=d 2
                          ·
                            have h := hp (d 0)
                            simp [FibreParity, h4_3, h5_2, h1_0, h2_0, h2_1, h3_0, h3_1, h3_2, h4_0, h4_1, h4_2, h5_0, h5_1, Ne.symm h1_0, Ne.symm h2_0, Ne.symm h2_1, Ne.symm h3_0, Ne.symm h3_1, Ne.symm h3_2, Ne.symm h4_0, Ne.symm h4_1, Ne.symm h4_2, Ne.symm h5_0, Ne.symm h5_1] at h
                          ·
                            by_cases h5_3 : d 5=d 3
                            ·
                              have h := hp (d 0)
                              simp [FibreParity, h4_3, h5_3, h1_0, h2_0, h2_1, h3_0, h3_1, h3_2, h4_0, h4_1, h4_2, h5_0, h5_1, h5_2, Ne.symm h1_0, Ne.symm h2_0, Ne.symm h2_1, Ne.symm h3_0, Ne.symm h3_1, Ne.symm h3_2, Ne.symm h4_0, Ne.symm h4_1, Ne.symm h4_2, Ne.symm h5_0, Ne.symm h5_1, Ne.symm h5_2] at h
                            ·
                              have h := hp (d 0)
                              simp [FibreParity, h4_3, h1_0, h2_0, h2_1, h3_0, h3_1, h3_2, h4_0, h4_1, h4_2, h5_0, h5_1, h5_2, h5_3, Ne.symm h1_0, Ne.symm h2_0, Ne.symm h2_1, Ne.symm h3_0, Ne.symm h3_1, Ne.symm h3_2, Ne.symm h4_0, Ne.symm h4_1, Ne.symm h4_2, Ne.symm h5_0, Ne.symm h5_1, Ne.symm h5_2, Ne.symm h5_3] at h
                    ·
                      by_cases h5_0 : d 5=d 0
                      ·
                        have h := hp (d 1)
                        simp [FibreParity, h5_0, h1_0, h2_0, h2_1, h3_0, h3_1, h3_2, h4_0, h4_1, h4_2, h4_3, Ne.symm h1_0, Ne.symm h2_0, Ne.symm h2_1, Ne.symm h3_0, Ne.symm h3_1, Ne.symm h3_2, Ne.symm h4_0, Ne.symm h4_1, Ne.symm h4_2, Ne.symm h4_3] at h
                      ·
                        by_cases h5_1 : d 5=d 1
                        ·
                          have h := hp (d 0)
                          simp [FibreParity, h5_1, h1_0, h2_0, h2_1, h3_0, h3_1, h3_2, h4_0, h4_1, h4_2, h4_3, h5_0, Ne.symm h1_0, Ne.symm h2_0, Ne.symm h2_1, Ne.symm h3_0, Ne.symm h3_1, Ne.symm h3_2, Ne.symm h4_0, Ne.symm h4_1, Ne.symm h4_2, Ne.symm h4_3, Ne.symm h5_0] at h
                        ·
                          by_cases h5_2 : d 5=d 2
                          ·
                            have h := hp (d 0)
                            simp [FibreParity, h5_2, h1_0, h2_0, h2_1, h3_0, h3_1, h3_2, h4_0, h4_1, h4_2, h4_3, h5_0, h5_1, Ne.symm h1_0, Ne.symm h2_0, Ne.symm h2_1, Ne.symm h3_0, Ne.symm h3_1, Ne.symm h3_2, Ne.symm h4_0, Ne.symm h4_1, Ne.symm h4_2, Ne.symm h4_3, Ne.symm h5_0, Ne.symm h5_1] at h
                          ·
                            by_cases h5_3 : d 5=d 3
                            ·
                              have h := hp (d 0)
                              simp [FibreParity, h5_3, h1_0, h2_0, h2_1, h3_0, h3_1, h3_2, h4_0, h4_1, h4_2, h4_3, h5_0, h5_1, h5_2, Ne.symm h1_0, Ne.symm h2_0, Ne.symm h2_1, Ne.symm h3_0, Ne.symm h3_1, Ne.symm h3_2, Ne.symm h4_0, Ne.symm h4_1, Ne.symm h4_2, Ne.symm h4_3, Ne.symm h5_0, Ne.symm h5_1, Ne.symm h5_2] at h
                            ·
                              by_cases h5_4 : d 5=d 4
                              ·
                                have h := hp (d 0)
                                simp [FibreParity, h5_4, h1_0, h2_0, h2_1, h3_0, h3_1, h3_2, h4_0, h4_1, h4_2, h4_3, h5_0, h5_1, h5_2, h5_3, Ne.symm h1_0, Ne.symm h2_0, Ne.symm h2_1, Ne.symm h3_0, Ne.symm h3_1, Ne.symm h3_2, Ne.symm h4_0, Ne.symm h4_1, Ne.symm h4_2, Ne.symm h4_3, Ne.symm h5_0, Ne.symm h5_1, Ne.symm h5_2, Ne.symm h5_3] at h
                              ·
                                have h := hp (d 0)
                                simp [FibreParity, h1_0, h2_0, h2_1, h3_0, h3_1, h3_2, h4_0, h4_1, h4_2, h4_3, h5_0, h5_1, h5_2, h5_3, h5_4, Ne.symm h1_0, Ne.symm h2_0, Ne.symm h2_1, Ne.symm h3_0, Ne.symm h3_1, Ne.symm h3_2, Ne.symm h4_0, Ne.symm h4_1, Ne.symm h4_2, Ne.symm h4_3, Ne.symm h5_0, Ne.symm h5_1, Ne.symm h5_2, Ne.symm h5_3, Ne.symm h5_4] at h
end Couret.InterIA.SingletonNecessity
#print axioms Couret.InterIA.SingletonNecessity.parity_has_pairing
