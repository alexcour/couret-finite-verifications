module
public import Solution
@[expose] public section
namespace Couret
namespace Certificate
/-- On a supplied prime factorization of n > 1 coprime to 30, the actual
101-state run has the table presence-count output; the represented ordered
residue pairs are exactly the nontrivial factor-pair residue types of n.
Repeated prime occurrences are allowed. No factorization algorithm is claimed. -/
theorem factorization_quotient_observation (w : Word Nat) (hp : w.primeFactors)
    (n : Nat) (hn : total natProduct w = n) (hc : Nat.gcd n 30 = 1) (h1 : 1 < n) :
    let symbols := (w.map encode30).map codeSymbol
    let i := tableRun 0 symbols
    quotientMachine.output (machineRun quotientMachine quotientMachine.initial symbols) =
      presenceCount (entry i) ∧
    ∀ a b : Symbol, pairPresent (entry i) a b = true ↔ factorPair n a b
 := by
  let symbols := (w.map encode30).map codeSymbol
  let i := tableRun 0 symbols
  have hi : decoded i = run mod30Product (w.map encode30) := by
    change decoded (tableRun 0 ((w.map encode30).map codeSymbol)) = _
    rw [tableRun_sound, word_codes_symbols]
  have hs : decoded i = State.active (encode30 n) (strictDivisorResidue n) :=
    hi.trans (mod30_run_for_factorization w hp n hn hc h1)
  refine ⟨(quotientMachine_correct symbols).trans (table_T_is_presence_count i), ?_⟩
  intro a b
  apply Iff.trans _ (arithmeticPair_iff_factorPair n hc a b)
  rw [pairPresent_decoded]
  change decode (entry i) = State.active (encode30 n) (strictDivisorResidue n) at hs
  rw [hs]
  change (strictDivisorResidue n (symbolCode a) ∧ strictDivisorResidue n (symbolCode b) ∧
    a.val ≤ b.val ∧ mul30 (symbolCode a) (symbolCode b) = encode30 n) ↔ arithmeticPair n a b
  simp only [arithmeticPair, coded_product_iff n hc a b]

end Certificate
end Couret
