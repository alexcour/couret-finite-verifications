# AUDIT-05 — Independent adversarial supplement (2026-10-11)

**Status:** internal exact integer audit and elementary algebra; external mathematical review still open; originality NOT audited. No PR merge.

This directory is an **addendum**. It does not modify the historical MOD-OBS-03 results, AUDIT_04 files, SHA256SUMS, or STROBO-C3 source claims.

## Reproduce from clean checkout

```bash
python3 research/MOD_OBS_03/AUDIT_05/replay_integer_independent.py
python3 research/MOD_OBS_03/AUDIT_05/check_probe_bank.py
```

The first command emits `RESULTS_INDEPENDENT.json` next to the script and prints PASS after exact-integer assertions. It scans three-generator supports for n=5..45 under both zero conventions (312,174 supports), tests the n=22 witness, the cardinal-parity boundary, 48 values of h for family B, 3,384 explicit (d,b) cases of family D, and 80 values of h for the infinite trace-failure family. The second independently constructs all n=18 square fibres and checks probe-cover minima 90/24/0 for the full 22-query bank, the 18 cubic coefficients alone, and a reduced 19-query bank.

**Run environment:** standard Python 3, no dependencies. To preserve a clean historical archive, the generated replay JSON is not checked in. The human-readable proofs and exact witness counts are in [REPORT.md](REPORT.md). For transparent verification, report any failed assertion and the complete Python version to PR #15; do not retroactively rewrite previous results.

**Important:** an independent implementation written within the same research process is not independent external peer review. Gates E/Q internal; N/R open.
