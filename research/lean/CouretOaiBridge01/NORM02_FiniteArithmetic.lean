import Mathlib

/-!
# NORM-02 — finite arithmetic certification layer

This file formalizes elementary, reusable sublemmas of NORM-01:
* exact coverage of the middle tent window by fixed anchor indices;
* primality and coprimality of those anchor indices;
* unique prime label for small-index centers;
* finite bad-square counting budget;
* the rational constant 3/50 in the mass lower bound.

Not formalized here: the 2026 Matomäki–Radziwill–Shao–Tao–Teräväinen
short-interval theorem, the asymptotic exceptional-set estimate, the full
squarefree sieve or the normalized Möbius correlation asymptotics.

RESEARCH ONLY. No sorry, no axioms added, no RH claim, no novelty claim.
-/

namespace CouretOaiBridge01
namespace NORM02

/-- For X=24*P and P <= p <= 2*P, one of three fixed, squarefree
indices places p*m inside [6X/5, 9X/5]. -/
theorem anchor_cover_24 (P p : ℕ)
    (hl : P ≤ p) (hu : p ≤ 2 * P) :
    (6 * (24 * P) ≤ 5 * (p * 19) ∧ 5 * (p * 19) ≤ 9 * (24 * P)) ∨
    (6 * (24 * P) ≤ 5 * (p * 23) ∧ 5 * (p * 23) ≤ 9 * (24 * P)) ∨
    (6 * (24 * P) ≤ 5 * (p * 29) ∧ 5 * (p * 29) ≤ 9 * (24 * P)) := by
  omega

/-- The analogous anchor cover when X=48*P. -/
theorem anchor_cover_48 (P p : ℕ)
    (hl : P ≤ p) (hu : p ≤ 2 * P) :
    (6 * (48 * P) ≤ 5 * (p * 37) ∧ 5 * (p * 37) ≤ 9 * (48 * P)) ∨
    (6 * (48 * P) ≤ 5 * (p * 47) ∧ 5 * (p * 47) ≤ 9 * (48 * P)) ∨
    (6 * (48 * P) ≤ 5 * (p * 59) ∧ 5 * (p * 59) ≤ 9 * (48 * P)) := by
  omega

/-- Every selected anchor is a prime, hence squarefree and a unit modulo 30. -/
theorem anchors_24_arithmetic :
    Nat.Prime 19 ∧ Nat.Prime 23 ∧ Nat.Prime 29 ∧
    Nat.Coprime 19 30 ∧ Nat.Coprime 23 30 ∧ Nat.Coprime 29 30 := by
  norm_num

theorem anchors_48_arithmetic :
    Nat.Prime 37 ∧ Nat.Prime 47 ∧ Nat.Prime 59 ∧
    Nat.Coprime 37 30 ∧ Nat.Coprime 47 30 ∧ Nat.Coprime 59 30 := by
  norm_num

/-- A prime > P dividing one center cannot also divide its small index.
The proof uses only the prime-divides-a-product lemma. -/
theorem prime_center_label_unique
    (P p q m n : ℕ)
    (hp : Nat.Prime p) (hq : Nat.Prime q)
    (hpP : P < p) (hqP : P < q)
    (hm : 0 < m) (hn : 0 < n)
    (hmP : m < P) (hnP : n < P)
    (heq : p * m = q * n) :
    p = q := by
  have hpdvd : p ∣ q * n := by
    rw [← heq]
    exact ⟨m, rfl⟩
  have hqdvd : q ∣ p * m := by
    rw [heq]
    exact ⟨n, rfl⟩
  have hpnotn : ¬ p ∣ n := by
    intro h
    have hle := Nat.le_of_dvd hn h
    omega
  have hqnotm : ¬ q ∣ m := by
    intro h
    have hle := Nat.le_of_dvd hm h
    omega
  have hpq : p ∣ q := by
    rcases (Nat.Prime.dvd_mul hp).mp hpdvd with hpq | hpn
    · exact hpq
    · exact False.elim (hpnotn hpn)
  have hqp : q ∣ p := by
    rcases (Nat.Prime.dvd_mul hq).mp hqdvd with hqp | hqm
    · exact hqp
    · exact False.elim (hqnotm hqm)
  exact Nat.le_antisymm (Nat.le_of_dvd hq.pos hpq)
    (Nat.le_of_dvd hp.pos hqp)

/-- An elementary budget used in the two-tier prime-square sieve:
the small and large bad sets may occupy at most one sixth
and one fourth of the full count, respectively. -/
theorem sieve_remaining_half
    (H small large : ℕ)
    (hs : 6 * small ≤ H)
    (hl : 4 * large ≤ H) :
    H ≤ 2 * (H - (small + large)) := by
  omega

/-- Multiplying the two tent-weight lower bounds and the good-shift
count gives the precise rational factor 3/50. -/
theorem tent_mass_constant
    (H V : ℚ)
    (hV : (2 / 5 : ℚ) * (3 / 10) * (H / 2) ≤ V) :
    (3 / 50 : ℚ) * H ≤ V := by
  linarith

end NORM02
end CouretOaiBridge01
