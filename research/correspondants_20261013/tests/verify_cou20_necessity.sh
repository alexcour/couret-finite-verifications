#!/usr/bin/env bash
# COU-20 isolated Lean 4.29.1 research check.
# Run after GitHub runner availability is restored (or in a checkout with lake).
set -euo pipefail
cd "$(dirname "$0")/../lean"
if ! command -v lake >/dev/null 2>&1; then
  echo "ERROR: lake is missing; no Lean certificate produced" >&2
  exit 2
fi
test "$(cat lean-toolchain)" = "leanprover/lean4:v4.29.1"
if grep -nE '^[[:space:]]*(sorry|admit|axiom)([[:space:]]|$)' \
    CayleyTwoColourNecessity.lean CayleyTwoColourNewton.lean CayleyTwoColourFirstReturn.lean CayleyTwoColourCanonicalReturn.lean; then
  echo "ERROR: placeholders or introduced axioms in research source" >&2
  exit 3
fi
lake resolve-deps
lake exe cache get
mkdir -p .lake/build/lib/lean
lake env lean -o .lake/build/lib/lean/CayleyDoubletCore.olean CayleyDoubletCore.lean
lake env lean -o .lake/build/lib/lean/CayleyTwoColourFamily.olean CayleyTwoColourFamily.lean
lake env lean -o .lake/build/lib/lean/CayleyTwoColourAbelian.olean CayleyTwoColourAbelian.lean
lake env lean -o .lake/build/lib/lean/CayleyTwoColourSpectral.olean CayleyTwoColourSpectral.lean
lake env lean -o .lake/build/lib/lean/CayleyTwoColourParity.olean CayleyTwoColourParity.lean
lake env lean -o .lake/build/lib/lean/CayleyTwoColourNecessity.olean CayleyTwoColourNecessity.lean
lake env lean -o .lake/build/lib/lean/CayleyTwoColourNewton.olean CayleyTwoColourNewton.lean
lake env lean -o .lake/build/lib/lean/CayleyTwoColourFirstReturn.olean CayleyTwoColourFirstReturn.lean
lake env lean CayleyTwoColourCanonicalReturn.lean
echo "SUCCESS: all four research modules compiled; inspect #print axioms logs."
