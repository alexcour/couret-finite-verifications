#!/bin/sh
set -eu
cd "$(dirname "$0")"
python3 -m unittest -q test_connectivite
TMP_RESULTS="$(mktemp)"
TMP_REGISTRY="$(mktemp)"
trap 'rm -f "$TMP_RESULTS" "$TMP_REGISTRY"' EXIT INT TERM
cp RESULTATS_CONTROLES.json "$TMP_RESULTS"
cp REGISTRE_CANONIQUE.json "$TMP_REGISTRY"
python3 verify_connectivite.py > /dev/null
python3 build_registry_json.py > /dev/null
cmp RESULTATS_CONTROLES.json "$TMP_RESULTS"
cmp REGISTRE_CANONIQUE.json "$TMP_REGISTRY"
printf 'PASS: 6 tests, 64 finite scans, deterministic JSON and registry.\n'
