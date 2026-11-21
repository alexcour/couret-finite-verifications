# CU-MOD-OBS-03 -- replay pack

Scope: 3 distinct nonzero generators in Z/nZ, n even, n=6,8,...,30.

Contents:
- `verify_mod_obs_03.py`: direct exact enumeration, elementary matrix check, witness lower bounds, optimal binary decision trees and coding-distance checks.
- `test_mod_obs_03.py`: five separate adversarial boundary tests.
- `MOD_OBS_03_RESULTS.json`: complete checks and witness pairs.
- `CU_MOD_OBS_03_REPORT_2026_10_11.md`: formal statements, proofs, literature and scientific limits.
- `SHA256SUMS.txt`: content checksums for these four files.

Replay commands:

```bash
python3 verify_mod_obs_03.py --max-n 30 --output MOD_OBS_03_RESULTS.json
python3 -m unittest discover -s . -p 'test_*.py' -v
sha256sum -c SHA256SUMS.txt
```

Status: internal finite calculation, source code provided; theoretical claims need external referee review. Distinct from STROBO-C3 originality review. No public release gate opened.
