#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
sha256sum -c SHA256SUMS
python -m unittest -v test_dynamic.py
python verify_dynamic.py --check results.json
python independent_audit.py --check independent_audit.json
