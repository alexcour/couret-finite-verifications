# Run and correction log

2026-10-11. Existing MOD-OBS-03 bundle at /mnt/data/CU_MOD_OBS_03_2026-10-11:
- All six SHA-256 checks passed.
- `python audit_mod_obs_03.py --max-n 60 --max-d 130 --out replay.json` returned PASS.
- Replay JSON was byte-for-byte identical to the recorded results.json.
- `python verify_alt.py` returned PASS.

New independent-from-code (but same-research-context) checker:
- An initial version of `odd_primes(n)` failed to remove factors of 2 before inspecting remaining odd factors. The test correctly found the bug at n=20, S=(5,10,15). This was a CHECKER ERROR, not a mathematical counterexample.
- The factor enumeration was corrected before producing any declared results.
- Corrected `referee_adversarial.py --max-n 60 --max-d 130` returned PASS: 112 modulus/zero-convention scans, 102180 explicit exceptional family supports checked, and first cubic-trace connectivity counterexample at n=22.
- SHA-256 hashes capture the FINAL corrected source and archived results. No earlier file was silently rewritten; this supplemental audit explicitly records the checker correction.
- All work was local integer arithmetic; no new prime counts or statistical data were generated.

STATUS: INTERNAL Q PASS; independent external reviewer R OPEN; original STROBO-C3 general classification E pending independent proof check; novelty N UNKNOWN.
