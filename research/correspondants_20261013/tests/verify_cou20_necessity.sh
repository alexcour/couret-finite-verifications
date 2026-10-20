#!/usr/bin/env bash
# COU-20: original modules, odd witness, matrix bridge and full classification.
set -euo pipefail
cd "$(dirname "$0")/../lean"
command -v lake >/dev/null 2>&1 || {
  echo "ERROR: lake is missing; no Lean certificate produced" >&2
  exit 2
}
test "$(cat lean-toolchain)" = "leanprover/lean4:v4.29.1"
if grep -nE '^[[:space:]]*(sorry|admit|axiom)([[:space:]]|$)' \
    CayleyTwoColourNecessity.lean CayleyTwoColourNewton.lean \
    CayleyTwoColourFirstReturn.lean CayleyTwoColourCanonicalReturn.lean \
    CayleyTwoColourThirdFactor.lean PolynomialJacobi.lean \
    CayleyCharpolyTrace.lean CayleyTwoColourMatrixNewton.lean \
    CayleyTwoColourClassification.lean CayleyTwoColourFirstCoeff.lean; then
  echo "ERROR: unfinished proof or introduced axiom" >&2
  exit 3
fi
lake resolve-deps
lake exe cache get
mkdir -p .lake/build/lib/lean .lake/cou20-audit
[[ -v LEAN_PATH ]] || LEAN_PATH=""
export LEAN_PATH="$(pwd)/.lake/build/lib/lean:$LEAN_PATH"
log_file=".lake/cou20-audit/lean.log"
: > "$log_file"
git rev-parse HEAD | tee -a "$log_file"
lake env lean --version | tee -a "$log_file"
for module in \
  CayleyDoubletCore CayleyTwoColourFamily CayleyTwoColourAbelian \
  CayleyTwoColourSpectral CayleyTwoColourParity CayleyTwoColourNecessity \
  CayleyTwoColourNewton CayleyTwoColourFirstReturn \
  CayleyTwoColourCanonicalReturn CayleyTwoColourThirdFactor CayleyNewtonAPISmoke \
  PolynomialJacobi CayleyCharpolyTrace CayleyTwoColourMatrixNewton \
  CayleyTwoColourClassification CayleyTwoColourFirstCoeff; do
  lake env lean -o ".lake/build/lib/lean/$module.olean" "$module.lean" 2>&1 | tee -a "$log_file"
done
python3 ../tests/check_cou20_axioms.py "$log_file" --lean-dir .
python3 ../tests/check_cou20_classification_axioms.py "$log_file" \
  --receipt .lake/cou20-audit/receipt.json
cp lean-toolchain lake-manifest.json .lake/cou20-audit/
echo "SUCCESS: complete COU-20 classification compiled and axiom audit passed."
