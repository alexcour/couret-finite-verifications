#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/../lean"
out="${HOMOMETRY_LOG_DIR:-../homometry-verification}"
mkdir -p "$out" .lake/build/lib/lean
lake env lean --version | tee "$out/toolchain.log"
for module in Strobo2TorsCore Strobo2TorsCardinality RecohFourierBridge StroboHomometry; do
  lake env lean -o ".lake/build/lib/lean/$module.olean" "$module.lean" \
    2>&1 | tee "$out/$module.log"
done
python3 - "$out" <<'PY'
import json
import re
import sys
from pathlib import Path

out = Path(sys.argv[1])
source = Path('StroboHomometry.lean').read_text()
public = re.findall(r'^theorem (\w+)', source, re.M)
requested = re.findall(r'^#print axioms Couret\.STROBO2TORS\.(\w+)', source, re.M)
assert set(public) == set(requested), (public, requested)
log = (out / 'StroboHomometry.log').read_text()
allowed = {'propext', 'Classical.choice', 'Quot.sound'}
audit = {}
for name in public:
    full = 'Couret.STROBO2TORS.' + name
    match = re.search(r"'" + re.escape(full) + r"' depends on axioms:\s*\[([^]]*)\]", log)
    if match:
        axioms = [x.strip() for x in match.group(1).split(',') if x.strip()]
    else:
        assert f"'{full}' does not depend on any axioms" in log, full
        axioms = []
    assert set(axioms) <= allowed, (full, axioms)
    audit[full] = axioms
(out / 'axioms.json').write_text(json.dumps(audit, indent=2) + '\n')
print(f'PASS: {len(audit)} public declarations compiled; only standard axioms.')
PY
