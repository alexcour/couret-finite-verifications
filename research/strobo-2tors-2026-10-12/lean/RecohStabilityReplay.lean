import RecohStableReconstruction
import Lean.Data.Json

set_option autoImplicit false

/-!
Execute the actual rational phase producer, odd-power selector, square-selected
stable bank and noisy sign decoder.  This JSON adapter is a differential-test
harness; parsing, serialization and Python equivalence are outside the
mathematical correctness statements.  Differential cases compare parsed JSON
trees.  Raw JSON lexical behavior (including duplicate object keys and number
normalization) is not an equivalence claim of this adapter.

Coordinates, canonical rational pairs and selected-bank descriptors are checked
before constructing typed observations.  Selection also accepts reordered,
repeated and zero-count typed square entries, to exercise extensional dependence
on the square.  Decoding uses the actual typed format and precision guards.
-/

namespace Couret.STROBO2TORS.StabilityReplay

open Lean

private def natField (j : Json) (name : String) : Except String ℕ := do
  (← j.getObjVal? name).getNat?

private def natList (j : Json) : Except String (List ℕ) := do
  (← j.getArr?).toList.mapM Json.getNat?

private def exactFields (j : Json) (names : List String) : Except String Unit := do
  let fields ← j.getObj?
  if fields.size != names.length then throw "unexpected object field count"
  for name in names do
    discard (j.getObjVal? name)

private def rational (j : Json) : Except String ℚ := do
  let pair ← j.getArr?
  if pair.size != 2 then throw "rational pair must have two entries"
  let numerator ← (← j.getArrVal? 0).getInt?
  let denominator ← (← j.getArrVal? 1).getInt?
  if denominator ≤ 0 then throw "rational denominator must be positive"
  if numerator.natAbs.gcd denominator.toNat != 1 then throw "rational pair must be reduced"
  pure (mkRat numerator denominator.toNat)

private def rationalComplex (j : Json) : Except String RecohRationalComplex := do
  let pair ← j.getArr?
  if pair.size != 2 then throw "complex pair must have two entries"
  let re ← rational (← j.getArrVal? 0)
  let im ← rational (← j.getArrVal? 1)
  pure (re, im)

private def rationalJson (x : ℚ) : Json :=
  Json.arr #[toJson x.num, toJson x.den]

private def rationalComplexJson (z : RecohRationalComplex) : Json :=
  Json.arr #[rationalJson z.1, rationalJson z.2]

private def phaseCase (j : Json) : Except String (List (String × Json)) := do
  let order ← natField j "order"
  let exponent ← natField j "exponent"
  let machinTerms ← natField j "machin_terms"
  let taylorTerms ← natField j "taylor_terms"
  if order == 0 then throw "phase requires a positive order"
  if machinTerms == 0 || taylorTerms < 15 || 4 < |recohPiPartial machinTerms| then
    throw "phase precision does not satisfy the proved Taylor guard"
  pure [("center", rationalComplexJson
      (recohRationalRootPower order exponent machinTerms taylorTerms)),
    ("error_bound", rationalJson (recohRationalPhaseError machinTerms taylorTerms))]

private def oddChoiceCase (j : Json) : Except String (List (String × Json)) := do
  let values ← (← (← j.getObjVal? "sq_norms").getArr?).toList.mapM rational
  let choice := recohOddSquaredChoice values.length (fun i => values[i]?.getD 0)
  pure [("choice", toJson choice), ("exponent", toJson (2 * choice + 1))]

private def precisionCase (j : Json) : Except String (List (String × Json)) := do
  let epsilon ← rational (← j.getObjVal? "epsilon")
  let machinTerms ← natField j "machin_terms"
  let taylorTerms ← natField j "taylor_terms"
  pure [("valid", toJson (recohStablePrecisionCheck epsilon machinTerms taylorTerms)),
    ("phase_error", rationalJson (recohRationalPhaseError machinTerms taylorTerms)),
    ("pi_partial", rationalJson (recohPiPartial machinTerms))]

private def decodePoint {d : ℕ} (q : Fin d → ℕ) (j : Json) :
    Except String ((i : Fin d) → ZMod (q i)) := do
  let values ← natList j
  if values.length != d then throw "coordinate vector has wrong dimension"
  let coords : Fin d → ℕ := fun i => values[i.val]?.getD 0
  if ∀ i, coords i < q i then pure (fun i => (coords i : ZMod (q i)))
  else throw "coordinate is not canonical"

private def pointValues {d : ℕ} (q : Fin d → ℕ)
    (x : (i : Fin d) → ZMod (q i)) : List ℕ :=
  (List.finRange d).map (fun i => (x i).val)

private def supportValues {d : ℕ} (q : Fin d → ℕ)
    (S : Finset ((i : Fin d) → ZMod (q i))) : List (List ℕ) :=
  (S.val.map (pointValues q)).sort (· ≤ ·)

private def bankCoordinate {d : ℕ} (q : Fin d → ℕ) [∀ i, NeZero (q i)]
    (entries : List (((i : Fin d) → ZMod (q i)) × ℕ))
    (i : RecohSelectedBankIndex q entries) : ℕ :=
  match i with
  | .inl j => j.val.val
  | .inr j => j.val.val.val

private def bankMultiplier {d : ℕ} (q : Fin d → ℕ) [∀ i, NeZero (q i)]
    (entries : List (((i : Fin d) → ZMod (q i)) × ℕ))
    (i : RecohSelectedBankIndex q entries) : ℕ :=
  match i with
  | .inl j => recohStableBinaryMultiplier q entries j
  | .inr _ => 1

private def bankDescriptor {d : ℕ} (q : Fin d → ℕ) [∀ i, NeZero (q i)]
    (entries : List (((i : Fin d) → ZMod (q i)) × ℕ))
    (i : RecohSelectedBankIndex q entries) : Json :=
  Json.mkObj [("coordinate", toJson (bankCoordinate q entries i)),
    ("prime", toJson (recohSelectedBankPrime q entries i)),
    ("order", toJson ((recohSelectedBankPrime q entries i) ^
      (recohSelectedBankDepth q entries i + 1))),
    ("multiplier", toJson (bankMultiplier q entries i))]

private def orderedBankIndices {d : ℕ} (q : Fin d → ℕ) [∀ i, NeZero (q i)]
    (entries : List (((i : Fin d) → ZMod (q i)) × ℕ)) :
    List (RecohSelectedBankIndex q entries) :=
  let binary := (List.finRange d).filterMap fun i =>
    if h : 2 ∣ q i then some (Sum.inl ⟨i, h⟩ : RecohSelectedBankIndex q entries) else none
  let ternary : List (RecohSelectedBankIndex q entries) :=
    match h : recohSquareTernaryChoice q entries with
    | none => []
    | some i => [Sum.inr ⟨i, h⟩]
  binary ++ ternary

private def squareCase (j : Json) (decode : Bool) : Except String (List (String × Json)) := do
  let observation ← if decode then j.getObjVal? "observation" else pure j
  if decode then
    exactFields observation ["format", "cyclic_factors", "square", "error_bound", "measurements"]
    let format ← (← observation.getObjVal? "format").getStr?
    if format != "recoh-stable-observation-v1" then throw "unsupported observation format"
  let moduli ← natList (← observation.getObjVal? "cyclic_factors")
  let q : Fin moduli.length → ℕ := fun i => moduli.get i
  if hq : ∀ i, 2 ≤ q i then
    letI : ∀ i, NeZero (q i) := fun i => ⟨by have hi := hq i; omega⟩
    do
      if moduli.prod < 3 then throw "group has no support triple"
      let squareRaw ← (← observation.getObjVal? "square").getArr?
      let entries ← squareRaw.toList.mapM fun entry => do
        exactFields entry ["point", "count"]
        let point ← decodePoint q (← entry.getObjVal? "point")
        let count ← natField entry "count"
        pure (point, count)
      let indices := orderedBankIndices q entries
      if !decode then
        let representatives := recohCyclicSquareRepresentatives q entries
        let reps := (representatives.val.map (supportValues q)).sort (· ≤ ·)
        pure [("bank", toJson (indices.map (bankDescriptor q entries))),
          ("representatives", toJson reps), ("bank_size", toJson indices.length)]
      else
        let epsilon ← rational (← observation.getObjVal? "error_bound")
        let machinTerms ← natField j "machin_terms"
        let taylorTerms ← natField j "taylor_terms"
        let measurements ← (← observation.getObjVal? "measurements").getArr?
        if measurements.size != indices.length then throw "wrong selected-bank measurement count"
        let parsed ← (indices.zip measurements.toList).mapM fun (i, measurement) => do
          exactFields measurement ["coordinate", "prime", "order", "multiplier", "value"]
          let coordinate ← natField measurement "coordinate"
          let prime ← natField measurement "prime"
          let order ← natField measurement "order"
          let multiplier ← natField measurement "multiplier"
          if coordinate != bankCoordinate q entries i || prime != recohSelectedBankPrime q entries i ||
              order != (recohSelectedBankPrime q entries i) ^ (recohSelectedBankDepth q entries i + 1) ||
              multiplier != bankMultiplier q entries i then
            throw "measurement descriptor differs from selected bank"
          let value ← rationalComplex (← measurement.getObjVal? "value")
          pure ((coordinate, prime), value)
        let observed : RecohSelectedBankIndex q entries → RecohRationalComplex := fun i =>
          ((parsed.find? (fun entry =>
            entry.1 == (bankCoordinate q entries i, recohSelectedBankPrime q entries i))).map
              Prod.snd).getD (0, 0)
        let inputOk := recohTypedSquareFormatCheck entries &&
          recohStablePrecisionCheck epsilon machinTerms taylorTerms
        let decoded := recohStableNoisyDecoder q entries observed epsilon machinTerms taylorTerms
        let supports := (decoded.val.map (supportValues q)).sort (· ≤ ·)
        pure [("accepted", toJson (decoded.card == 1)), ("supports", toJson supports),
          ("support_count", toJson decoded.card), ("bank_size", toJson indices.length),
          ("typed_input_ok", toJson inputOk),
          ("rejection_stage", toJson (if decoded.card == 1 then "none" else
            if inputOk then "no_candidate" else "typed_guard"))]
  else throw "cyclic factors must be at least two"

private def runCase (j : Json) : Json :=
  let id := j.getObjValD "id"
  let kind := (j.getObjValD "kind").getStr?.toOption.getD ""
  let result :=
    if kind == "phase" then phaseCase j
    else if kind == "odd_choice" then oddChoiceCase j
    else if kind == "precision" then precisionCase j
    else if kind == "select" then squareCase j false
    else if kind == "decode" then squareCase j true
    else .error "unsupported case kind"
  match result with
  | .ok fields => Json.mkObj (("id", id) :: ("status", toJson "ok") :: fields)
  | .error message =>
    if kind == "decode" then Json.mkObj [
      ("id", id), ("status", toJson "ok"), ("accepted", toJson false),
      ("support_count", toJson (0 : ℕ)), ("supports", toJson ([] : List (List (List ℕ)))),
      ("bank_size", toJson (0 : ℕ)), ("typed_input_ok", toJson false),
      ("rejection_stage", toJson "adapter"), ("error", toJson message)]
    else Json.mkObj [("id", id), ("status", toJson "typed_domain_error"), ("error", toJson message)]

def replay (input : String) : Except String String := do
  let cases ← (← Json.parse input).getArr?
  pure (toJson (cases.map runCase)).compress

end Couret.STROBO2TORS.StabilityReplay

def main (args : List String) : IO UInt32 := do
  match args with
  | [path] =>
    let input ← IO.FS.readFile path
    match Couret.STROBO2TORS.StabilityReplay.replay input with
    | .ok output => IO.println output; pure 0
    | .error message => (← IO.getStderr).putStrLn message; pure 1
  | _ =>
    (← IO.getStderr).putStrLn "usage: lean --run RecohStabilityReplay.lean cases.json"
    pure 2
