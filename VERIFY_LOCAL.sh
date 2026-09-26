#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")" && pwd)"
cd "$ROOT"
python -m compileall -q 03-consecutive-squares 05-chebyshev-mod30 09-closed-routes
(
  cd 03-consecutive-squares
  python verify_consecutive_squares.py
)
(
  cd 05-chebyshev-mod30
  python verify_chebyshev.py
)
(
  cd 09-closed-routes
  python verify_closed_routes.py
  python defaut_general.py
  python defaut_sousgroupe.py
  python deux_tiers.py
  python triangles_chi5.py
)
echo "PUBLIC RELEASE: ALL VERIFIERS PASSED"
