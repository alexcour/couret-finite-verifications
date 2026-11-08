module

public import CertificateChecks

@[expose] public section

/-! Universal consequences of the finite certificate checks. -/
set_option maxRecDepth 16384
set_option maxHeartbeats 8000000

namespace Couret
namespace Certificate

def decoded (i : StateId) : State Code30 := decode (entry i)

theorem decoded_injective {i j : StateId} (h : decoded i = decoded j) : i = j :=
  entry_injective i j (decode_injective h)

theorem tableNext_semantic (i : StateId) (g : Symbol) :
    decoded (tableNext i g) = step mod30Product (decoded i) (symbolCode g) :=
  StepValid_sound (transitions_checked i g)

theorem tableRun_sound (w : Word Symbol) :
    decoded (tableRun 0 w) = run mod30Product (w.map symbolCode) := by
  induction w with
  | empty => change decode (entry 0) = State.initial; rw [initial_encoding]; rfl
  | snoc w g ih =>
    change decoded (tableNext (tableRun 0 w) g) =
      step mod30Product (run mod30Product (w.map symbolCode)) (symbolCode g)
    rw [tableNext_semantic, ih]

theorem word_codes_symbols (w : Word Code30) :
    (w.map codeSymbol).map symbolCode = w := by
  induction w with
  | empty => rfl
  | snoc w g ih =>
    change Word.snoc ((w.map codeSymbol).map symbolCode) (symbolCode (codeSymbol g)) = .snoc w g
    rw [ih, symbol_code]

theorem map_nonempty {α β : Type} (f : α → β) (w : Word α) :
    (w.map f).nonempty ↔ w.nonempty := by cases w <;> rfl

theorem every_run_in_table (w : Word Code30) :
    ∃ i : StateId, decoded i = run mod30Product w := by
  refine ⟨tableRun 0 (w.map codeSymbol), ?_⟩
  rw [tableRun_sound, word_codes_symbols]

theorem every_table_state_reachable (i : StateId) :
    ∃ w : Word Code30, run mod30Product w = decoded i := by
  refine ⟨(reachWord i).map symbolCode, ?_⟩
  rw [← tableRun_sound, reachability_checked]

theorem exactly_147_reachable :
    (∀ i j : Fin 147, decoded i = decoded j → i = j) ∧
    (∀ s : State Code30, (∃ w : Word Code30, run mod30Product w = s) ↔
      ∃ i : Fin 147, decoded i = s) := by
  constructor
  · exact fun _ _ => decoded_injective
  · intro s
    constructor
    · rintro ⟨w, rfl⟩; exact every_run_in_table w
    · rintro ⟨i, rfl⟩; exact every_table_state_reachable i

theorem tableNext_noninitial (i : StateId) (g : Symbol) : tableNext i g ≠ 0 := by
  intro h
  have hc := transitions_checked i g
  rw [h, initial_encoding] at hc
  cases he : entry i <;> simp [he, StepValid] at hc

theorem nonempty_run_noninitial (w : Word Symbol) (hw : w.nonempty) :
    tableRun 0 w ≠ 0 := by
  cases w with
  | empty => exact False.elim hw
  | snoc w g => exact tableNext_noninitial (tableRun 0 w) g

def noninitialDecoded (i : Fin 146) : State Code30 := decoded i.succ

theorem exactly_146_nonempty_reachable :
    (∀ i j : Fin 146, noninitialDecoded i = noninitialDecoded j → i = j) ∧
    (∀ s : State Code30,
      (∃ w : Word Code30, w.nonempty ∧ run mod30Product w = s) ↔
        ∃ i : Fin 146, noninitialDecoded i = s) := by
  constructor
  · intro i j h
    have he : i.succ = j.succ := decoded_injective h
    exact Fin.succ_inj.mp he
  · intro s
    constructor
    · rintro ⟨w, hw, hr⟩
      let i := tableRun 0 (w.map codeSymbol)
      have hi : i ≠ 0 := nonempty_run_noninitial _ ((map_nonempty codeSymbol w).mpr hw)
      have hs : decoded i = s := by
        change decoded (tableRun 0 (w.map codeSymbol)) = s
        rw [tableRun_sound, word_codes_symbols, hr]
      have hpos : 0 < i.val := by
        have hz : i.val ≠ 0 := fun h => hi (Fin.ext h)
        omega
      let j : Fin 146 := ⟨i.val - 1, by have := i.isLt; omega⟩
      have hj : j.succ = i := by
        apply Fin.ext
        change (i.val - 1) + 1 = i.val
        omega
      refine ⟨j, ?_⟩
      change decoded j.succ = s
      rw [hj]
      exact hs
    · rintro ⟨i, rfl⟩
      refine ⟨(reachWord i.succ).map symbolCode, ?_, ?_⟩
      · apply (map_nonempty symbolCode _).mpr
        exact nonempty_witness_checked i.succ (Fin.succ_ne_zero i)
      · rw [← tableRun_sound, reachability_checked]; rfl

theorem table_T_is_presence_count (i : StateId) :
    tableOutput i = presenceCount (entry i) := (observation_checked i).2

theorem table_T_is_mask_formula (i : StateId) :
    tableOutput i = outputMask (entry i) := (observation_checked i).1

theorem pairPresent_decoded (s : EncodedState) (a b : Symbol) :
    pairPresent s a b = true ↔ match decode s with
      | .initial => False
      | .active r U => U (symbolCode a) ∧ U (symbolCode b) ∧ a.val ≤ b.val ∧
          mul30 (symbolCode a) (symbolCode b) = r := by
  cases s with
  | none => simp [pairPresent, decode]
  | some s => exact pairPresent_semantics s.1 s.2 a b

def strictDivisorResidue (n : Nat) (u : Code30) : Prop :=
  ∃ d : Nat, d ∣ n ∧ 1 < d ∧ d < n ∧ d % 30 = residue30 u

def arithmeticPair (n : Nat) (a b : Symbol) : Prop :=
  strictDivisorResidue n (symbolCode a) ∧ strictDivisorResidue n (symbolCode b) ∧
  a.val ≤ b.val ∧ (residue30 (symbolCode a) * residue30 (symbolCode b)) % 30 = n % 30

theorem coded_product_iff (n : Nat) (hc : Nat.gcd n 30 = 1) (a b : Symbol) :
    mul30 (symbolCode a) (symbolCode b) = encode30 n ↔
      (residue30 (symbolCode a) * residue30 (symbolCode b)) % 30 = n % 30 := by
  constructor
  · intro h
    have he := congrArg residue30 h
    simpa only [mul30_residue, decode_encode30 n hc] using he
  · intro h
    apply residue30_injective
    rw [mul30_residue, decode_encode30 n hc]
    exact h

def factorPair (n : Nat) (a b : Symbol) : Prop :=
  ∃ d e : Nat, 1 < d ∧ 1 < e ∧ d * e = n ∧
    d % 30 = residue30 (symbolCode a) ∧ e % 30 = residue30 (symbolCode b) ∧ a.val ≤ b.val

theorem code_left_cancel : ∀ a b c : Code30, mul30 a b = mul30 a c → b = c := by decide

theorem arithmeticPair_iff_factorPair (n : Nat) (hc : Nat.gcd n 30 = 1) (a b : Symbol) :
    arithmeticPair n a b ↔ factorPair n a b := by
  constructor
  · rintro ⟨⟨d, hdiv, hd1, hdlt, hdres⟩, _, hab, hprod⟩
    rcases hdiv with ⟨e, hden⟩
    have he0 : e ≠ 0 := by intro he; rw [he, Nat.mul_zero] at hden; omega
    have he1 : e ≠ 1 := by intro he; rw [he, Nat.mul_one] at hden; omega
    have he2 : 1 < e := by omega
    have hed : e ∣ n := ⟨d, hden.trans (Nat.mul_comm _ _)⟩
    have hce := coprime30_of_dvd hed hc
    have hmul : mul30 (symbolCode a) (encode30 e) = encode30 n := by
      apply residue30_injective
      rw [mul30_residue, decode_encode30 e hce, decode_encode30 n hc, ← hdres]
      exact (Nat.mul_mod d e 30).symm.trans (congrArg (fun x => x % 30) hden.symm)
    have hmul' := (coded_product_iff n hc a b).mpr hprod
    have heb : encode30 e = symbolCode b := code_left_cancel _ _ _ (hmul.trans hmul'.symm)
    have heres : e % 30 = residue30 (symbolCode b) := by
      have hh := congrArg residue30 heb
      simpa only [decode_encode30 e hce] using hh
    exact ⟨d,e,hd1,he2,hden.symm,hdres,heres,hab⟩
  · rintro ⟨d,e,hd1,he1,hden,hdres,heres,hab⟩
    have hdlt : d < n := by
      have hh : d * 2 ≤ n := by
        calc
          d * 2 ≤ d * e := Nat.mul_le_mul_left d (by omega)
          _ = n := hden
      omega
    have helt : e < n := by
      have hh : e * 2 ≤ n := by
        calc
          e * 2 ≤ e * d := Nat.mul_le_mul_left e (by omega)
          _ = n := (Nat.mul_comm _ _).trans hden
      omega
    have hdiv : d ∣ n := ⟨e,hden.symm⟩
    have hediv : e ∣ n := ⟨d,hden.symm.trans (Nat.mul_comm _ _)⟩
    have hprod : (residue30 (symbolCode a) * residue30 (symbolCode b)) % 30 = n % 30 := by
      rw [← hdres, ← heres, ← Nat.mul_mod, hden]
    exact ⟨⟨d,hdiv,hd1,hdlt,hdres⟩,⟨e,hediv,he1,helt,heres⟩,hab,hprod⟩

theorem factorization_T_certificate (w : Word Nat) (hp : w.primeFactors)
    (n : Nat) (hn : total natProduct w = n) (hc : Nat.gcd n 30 = 1) (h1 : 1 < n) :
    ∃ i : StateId,
      decoded i = State.active (encode30 n) (strictDivisorResidue n) ∧
      tableOutput i = presenceCount (entry i) ∧
      tableOutput i = outputMask (entry i) ∧
      ∀ a b : Symbol, pairPresent (entry i) a b = true ↔ arithmeticPair n a b := by
  rcases every_run_in_table (w.map encode30) with ⟨i, hi⟩
  have he := mod30_run_for_factorization w hp n hn hc h1
  have hs : decoded i = State.active (encode30 n) (strictDivisorResidue n) := hi.trans he
  refine ⟨i, hs, table_T_is_presence_count i, table_T_is_mask_formula i, ?_⟩
  intro a b
  rw [pairPresent_decoded]
  change decode (entry i) = State.active (encode30 n) (strictDivisorResidue n) at hs
  rw [hs]
  change (strictDivisorResidue n (symbolCode a) ∧ strictDivisorResidue n (symbolCode b) ∧
    a.val ≤ b.val ∧ mul30 (symbolCode a) (symbolCode b) = encode30 n) ↔ arithmeticPair n a b
  simp only [arithmeticPair, coded_product_iff n hc a b]

theorem factorization_T_factor_pairs (w : Word Nat) (hp : w.primeFactors)
    (n : Nat) (hn : total natProduct w = n) (hc : Nat.gcd n 30 = 1) (h1 : 1 < n) :
    ∃ i : StateId, tableOutput i = presenceCount (entry i) ∧
      ∀ a b : Symbol, pairPresent (entry i) a b = true ↔ factorPair n a b := by
  rcases factorization_T_certificate w hp n hn hc h1 with ⟨i,_,hT,_,hpair⟩
  exact ⟨i,hT,fun a b => (hpair a b).trans (arithmeticPair_iff_factorPair n hc a b)⟩

theorem quotientRun_congruence (i : StateId) (w : Word Symbol) :
    classOf (tableRun i w) = quotientRun (classOf i) w := by
  induction w with
  | empty => rfl
  | snoc w g ih =>
    change classOf (tableNext (tableRun i w) g) = quotientNext (quotientRun (classOf i) w) g
    rw [quotient_congruence_checked, ih]

theorem future_output (i : StateId) (w : Word Symbol) :
    tableOutput (tableRun i w) = quotientOutput (quotientRun (classOf i) w) := by
  rw [quotient_output_checked, quotientRun_congruence]

theorem classes_iff_all_future_outputs (i j : StateId) :
    classOf i = classOf j ↔
      ∀ w : Word Symbol, tableOutput (tableRun i w) = tableOutput (tableRun j w) := by
  constructor
  · intro h w
    rw [future_output, future_output, h]
  · intro h
    by_cases he : classOf i = classOf j
    · exact he
    · have hd := separating_words_checked (classOf i) (classOf j) he
      exact False.elim (hd (by simpa only [future_output] using h (separatingWord (classOf i) (classOf j))))

theorem every_quotient_class_reachable (c : ClassId) :
    ∃ w : Word Symbol, quotientRun 0 w = c := by
  refine ⟨reachWord (representative c), ?_⟩
  have he := quotientRun_congruence 0 (reachWord (representative c))
  rw [reachability_checked, representatives_checked, quotient_initial] at he
  exact he.symm

theorem quotient_preserves_T (w : Word Symbol) :
    quotientOutput (quotientRun 0 w) = presenceCount (entry (tableRun 0 w)) := by
  have he := future_output 0 w
  rw [quotient_initial] at he
  exact he.symm.trans (table_T_is_presence_count _)

def appendWord (u : Word Symbol) : Word Symbol → Word Symbol
  | .empty => u
  | .snoc v g => .snoc (appendWord u v) g

theorem tableRun_append (i : StateId) (u v : Word Symbol) :
    tableRun i (appendWord u v) = tableRun (tableRun i u) v := by
  induction v with
  | empty => rfl
  | snoc v g ih => change tableNext (tableRun i (appendWord u v)) g = _; rw [ih]; rfl

structure ObservationMachine (β : Type) where
  initial : β
  next : β → Symbol → β
  output : β → Nat

def machineRun {β : Type} (M : ObservationMachine β) (b : β) : Word Symbol → β
  | .empty => b
  | .snoc w g => M.next (machineRun M b w) g

theorem machineRun_append {β : Type} (M : ObservationMachine β) (b : β)
    (u v : Word Symbol) :
    machineRun M b (appendWord u v) = machineRun M (machineRun M b u) v := by
  induction v with
  | empty => rfl
  | snoc v g ih => change M.next (machineRun M b (appendWord u v)) g = _; rw [ih]; rfl

theorem same_machine_state_future_equal {β : Type} (M : ObservationMachine β)
    (hM : ∀ w : Word Symbol, M.output (machineRun M M.initial w) = tableOutput (tableRun 0 w))
    (i j : StateId)
    (he : machineRun M M.initial (reachWord i) = machineRun M M.initial (reachWord j))
    (w : Word Symbol) : tableOutput (tableRun i w) = tableOutput (tableRun j w) := by
  calc
    tableOutput (tableRun i w) = tableOutput (tableRun 0 (appendWord (reachWord i) w)) := by
      rw [tableRun_append, reachability_checked]
    _ = M.output (machineRun M M.initial (appendWord (reachWord i) w)) := (hM _).symm
    _ = M.output (machineRun M M.initial (appendWord (reachWord j) w)) := by
      rw [machineRun_append, machineRun_append, he]
    _ = tableOutput (tableRun 0 (appendWord (reachWord j) w)) := hM _
    _ = tableOutput (tableRun j w) := by rw [tableRun_append, reachability_checked]

theorem minimal_101_states {β : Type} (M : ObservationMachine β)
    (hM : ∀ w : Word Symbol, M.output (machineRun M M.initial w) = tableOutput (tableRun 0 w)) :
    ∃ f : Fin 101 → β,
      (∀ c d : Fin 101, f c = f d → c = d) ∧
      ∀ c : Fin 101, ∃ w : Word Symbol, f c = machineRun M M.initial w := by
  sorry

def quotientMachine : ObservationMachine ClassId where
  initial := 0
  next := quotientNext
  output := quotientOutput

theorem quotientMachine_run (c : ClassId) (w : Word Symbol) :
    machineRun quotientMachine c w = quotientRun c w := by
  induction w with
  | empty => rfl
  | snoc w g ih => change quotientNext (machineRun quotientMachine c w) g = _; rw [ih]; rfl

theorem quotientMachine_correct (w : Word Symbol) :
    quotientMachine.output (machineRun quotientMachine quotientMachine.initial w) =
      tableOutput (tableRun 0 w) := by
  change quotientOutput (machineRun quotientMachine 0 w) = _
  rw [quotientMachine_run]
  have he := future_output 0 w
  rw [quotient_initial] at he
  exact he.symm

end Certificate
end Couret
