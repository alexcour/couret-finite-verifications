import RecohCoefficientObservations
import RecohCyclicHalves
import RecohCyclicCoefficientDecoder
import RecohCyclicPreparedDecoder
import Lean.Data.Json

set_option autoImplicit false

/-!
Executable differential-test runner.  This file calls the actual computable
Lean definitions; it is not a proof of its JSON adapter or of Python code.

Nonnegative root exponents are passed unchanged to the Lean normalizer.
Negative root exponents are explicitly adapted by integer remainder modulo
the order before entering its natural-exponent interface.  Negative basis
exponents are rejected by the adapter as outside the typed Nat domain.

The small canonical-output adapter only sorts present exponents and reads
their coefficients with the already certified `recohSparseCoeff` function.
It does not implement cyclotomic reduction a second time.
-/

namespace Couret.STROBO2TORS.DataBridgeReplay

open Lean

private def natField (j : Json) (name : String) : Except String ℕ := do
  (← j.getObjVal? name).getNat?

private def intList (j : Json) : Except String (List ℤ) := do
  (← j.getArr?).toList.mapM Json.getInt?

private def natList (j : Json) : Except String (List ℕ) := do
  (← j.getArr?).toList.mapM Json.getNat?

private def exactFields (j : Json) (names : List String) : Except String Unit := do
  let fields ← j.getObj?
  if fields.size != names.length then throw "unexpected object field count"
  for name in names do
    discard (j.getObjVal? name)

private def coefficientTerms (j : Json) : Except String RecohSparseTerms := do
  (← j.getArr?).toList.mapM fun entry => do
    let pair ← entry.getArr?
    if pair.size != 2 then throw "coefficient pair must have two entries"
    let e ← (← entry.getArrVal? 0).getNat?
    let c ← (← entry.getArrVal? 1).getInt?
    pure (e, c)

private def rootExponents (j : Json) (p k : ℕ) : Except String (List ℕ × Bool) := do
  let es ← intList (← j.getObjVal? "exponents")
  let order := p ^ (k + 1)
  let negative := es.any (fun e => decide (e < 0))
  let adapted := es.map fun e =>
    if e < 0 then (e % (order : ℤ)).toNat else e.toNat
  pure (adapted, negative)

private def canonicalTerms (terms : RecohSparseTerms) : RecohSparseTerms :=
  let exponents := (terms.map Prod.fst).eraseDups.mergeSort (fun a b => decide (a ≤ b))
  exponents.filterMap fun e =>
    let c := recohSparseCoeff terms e
    if c = 0 then none else some (e, c)

private def arithmetic (j : Json) (kind : String) : Except String (List (String × Json)) := do
  let p ← natField j "p"
  let k ← natField j "k"
  if p != 2 && p != 3 then throw "replay accepts prime 2 or 3"
  if kind = "normalize" then
    let (es, adapted) ← rootExponents j p k
    let raw := recohReducedTerms p k es
    let canonical := canonicalTerms raw
    pure [
      ("coefficients", toJson canonical),
      ("raw_terms", toJson raw),
      ("format_ok", toJson (recohCoefficientFormatCheck p k canonical)),
      ("match", toJson (recohCoefficientMatch p k es canonical)),
      ("match_neg", toJson (recohCoefficientMatchNeg p k es canonical)),
      ("negative_exponent_adapter", toJson adapted)]
  else
    let terms ← coefficientTerms (← j.getObjVal? "terms")
    let valid := recohCoefficientFormatCheck p k terms
    if kind = "format" then
      pure [("format_ok", toJson valid)]
    else if kind = "match" then
      let (es, adapted) ← rootExponents j p k
      pure [
        ("format_ok", toJson valid),
        ("match", toJson (recohCoefficientMatch p k es terms)),
        ("match_neg", toJson (recohCoefficientMatchNeg p k es terms)),
        ("negative_exponent_adapter", toJson adapted)]
    else throw "unknown arithmetic replay kind"

private def halfCase (j : Json) : Except String (List (String × Json)) := do
  let q ← natField j "q"
  if q < 2 then throw "Python cyclic-factor domain requires q at least two"
  let t ← (← j.getObjVal? "t").getInt?
  let value : ZMod q := (t : ZMod q)
  let result := (recohCyclicHalf q value).map (fun x => x.val)
  pure [("half", toJson result), ("canonical_t", toJson value.val)]

private def decodePoint {d : ℕ} (q : Fin d → ℕ) (j : Json) :
    Except String ((i : Fin d) → ZMod (q i)) := do
  let values ← natList j
  if values.length != d then throw "coordinate vector has wrong dimension"
  let coords : Fin d → ℕ := fun i => values[i.val]?.getD 0
  if ∀ i, coords i < q i then
    pure (fun i => (coords i : ZMod (q i)))
  else throw "coordinate is not canonical: expected zero through q_i minus one"

private def bankCoordinate {d : ℕ} (q : Fin d → ℕ) (i : RecohCyclicBankIndex q) : ℕ :=
  match i with
  | .inl j => j.val.val
  | .inr j => j.val.val

private def orderedBankIndices {d : ℕ} (q : Fin d → ℕ) : List (RecohCyclicBankIndex q) :=
  let binary := (List.finRange d).filterMap fun i =>
    if h : 2 ∣ q i then some (Sum.inl ⟨i, h⟩ : RecohCyclicBankIndex q) else none
  let ternary := (List.finRange d).filterMap fun i =>
    if h : 3 ∣ q i ∧ ∃ j : Fin d, 2 ∣ q j then
      some (Sum.inr ⟨i, h⟩ : RecohCyclicBankIndex q)
    else none
  binary ++ ternary

private def pointValues {d : ℕ} (q : Fin d → ℕ) (x : (i : Fin d) → ZMod (q i)) : List ℕ :=
  (List.finRange d).map (fun i => (x i).val)

private def supportValues {d : ℕ} (q : Fin d → ℕ)
    (S : Finset ((i : Fin d) → ZMod (q i))) : List (List ℕ) :=
  (S.val.map (pointValues q)).sort (· ≤ ·)

/-- Experimental adapter only: bounds are checked before ZMod conversion,
and descriptors are checked in the actual fixed bank order before lookup. -/
private def decodeCase (j : Json) : Except String (List (String × Json)) := do
  let observation ← j.getObjVal? "observation"
  exactFields observation ["format", "cyclic_factors", "square", "measurements"]
  let format ← (← observation.getObjVal? "format").getStr?
  if format != "recoh-exact-observation-v1" then throw "unsupported observation format"
  let moduli ← natList (← observation.getObjVal? "cyclic_factors")
  let q : Fin moduli.length → ℕ := fun i => moduli.get i
  if hq : ∀ i, 2 ≤ q i then
    letI : ∀ i, NeZero (q i) := fun i => ⟨by have hi := hq i; omega⟩
    do
      if moduli.prod < 3 then throw "group has fewer than three elements"
      let squareRaw ← (← observation.getObjVal? "square").getArr?
      let entries ← squareRaw.toList.mapM fun entry => do
        exactFields entry ["point", "count"]
        let point ← decodePoint q (← entry.getObjVal? "point")
        let count ← natField entry "count"
        pure (point, count)
      let indices := orderedBankIndices q
      let measurements ← (← observation.getObjVal? "measurements").getArr?
      if measurements.size != indices.length then throw "wrong fixed-bank measurement count"
      let parsed ← (indices.zip measurements.toList).mapM fun (i, measurement) => do
        exactFields measurement ["coordinate", "prime", "order", "coefficients"]
        let coordinate ← natField measurement "coordinate"
        let prime ← natField measurement "prime"
        let order ← natField measurement "order"
        if coordinate != bankCoordinate q i || prime != recohCyclicBankPrime q i ||
            order != (recohCyclicBankPrime q i) ^ (recohCyclicBankDepth q i + 1) then
          throw "measurement descriptor or order differs from fixed bank"
        let coefficients ← coefficientTerms (← measurement.getObjVal? "coefficients")
        pure ((coordinate, prime), coefficients)
      let terms : RecohCyclicBankIndex q → RecohSparseTerms := fun i =>
        ((parsed.find? (fun entry =>
          entry.1 == (bankCoordinate q i, recohCyclicBankPrime q i))).map Prod.snd).getD []
      let inputOk := recohCyclicInputCheck q entries terms
      let decoded := recohCyclicCoefficientDecoder q entries terms
      let prepared := recohCyclicPreparedDecoder q entries terms
      let preparedSupports := (prepared.val.map (supportValues q)).sort (· ≤ ·)
      let supports := (decoded.val.map (supportValues q)).sort (· ≤ ·)
      pure [
        ("accepted", toJson (decoded.card == 1)),
        ("support_count", toJson decoded.card),
        ("supports", toJson supports),
        ("prepared_supports", toJson preparedSupports),
        ("prepared_support_count", toJson prepared.card),
        ("prepared_equals_core", toJson (prepared == decoded)),
        ("typed_input_ok", toJson inputOk),
        ("rejection_stage", toJson (if decoded.card == 1 then "none" else
          if inputOk then "no_candidate" else "typed_guard")),
        ("group_order", toJson moduli.prod),
        ("bank_size", toJson indices.length)]
  else throw "cyclic factors must be at least two"

private def runCase (j : Json) : Json :=
  let id := j.getObjValD "id"
  let kind := (j.getObjValD "kind").getStr?.toOption.getD ""
  let result : Except String (List (String × Json)) := do
    if kind = "decode" then decodeCase j
    else if kind = "half" then halfCase j else arithmetic j kind
  match result with
  | .ok fields => Json.mkObj (("id", id) :: ("status", toJson "ok") :: fields)
  | .error message =>
    if kind = "decode" then Json.mkObj [
      ("id", id), ("status", toJson "ok"), ("accepted", toJson false),
      ("support_count", toJson (0 : ℕ)), ("supports", toJson ([] : List (List (List ℕ)))),
      ("prepared_support_count", toJson (0 : ℕ)),
      ("prepared_supports", toJson ([] : List (List (List ℕ)))),
      ("rejection_stage", toJson "adapter"), ("error", toJson message)]
    else Json.mkObj [
      ("id", id), ("status", toJson "typed_domain_error"), ("error", toJson message)]

def replay (input : String) : Except String String := do
  let cases ← (← Json.parse input).getArr?
  pure (toJson (cases.map runCase)).compress

end Couret.STROBO2TORS.DataBridgeReplay

def main (args : List String) : IO UInt32 := do
  match args with
  | [path] =>
    let input ← IO.FS.readFile path
    match Couret.STROBO2TORS.DataBridgeReplay.replay input with
    | .ok output => IO.println output; pure 0
    | .error message =>
      (← IO.getStderr).putStrLn message
      pure 1
  | _ =>
    (← IO.getStderr).putStrLn "usage: lean --run RecohDataBridgeReplay.lean cases.json"
    pure 2
