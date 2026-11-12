# CU-MOD-OBS-05 — dynamical observability and freshness

**11 October 2026. Internal pilot v0.1, draft / review invited.**

This research note separates observation noise, target mutations, version freshness, and atomic use. Nothing here validates a real-world AI system or asserts mathematical priority. The pilot is retrospective, not preregistered. A future v0.2 experiment must be frozen before execution.

## Files

- `PROTOCOL.md`: definitions, retrospective pilot, prospective extension and gates.
- `THEORY_AUDIT.md`: proofs, counterexample, freshness contract, bibliography and limitations.
- `pilot.py`: exact Bellman recurrence and separately represented finite feasibility search; replay of all admissible adversarial transcripts; Poisson two-policy calculation.
- `test_pilot.py`: targeted regression and negative tests.
- `results.json`: deterministic output from `pilot.py`.
- `SHA256SUMS.txt`: manifest covering the preceding five files.

## Reproduce

```sh
cd research/CU_MOD_OBS_05
python3 pilot.py > results.json
python3 -m unittest -v test_pilot.py
sha256sum -c SHA256SUMS.txt
```

Requires Python 3 standard library only, plus `sha256sum` for checksum verification. Do not regenerate the manifest before checking the downloaded archive.

## Important boundaries

Same `A_S^2` does not mean same state or same history. The no-go applies when mutation can happen after the last unprotected observation and before use. The versioned upper bound only applies to a reliable non-reusable version counter and atomic coupling between validation and use. Expected Poisson costs use entirely hypothetical parameter values. Static minima corroborate prior internal results; no peer review or novelty claim.

**GATES: E=internal; Q=finite exact code; N=NOT AUDITED; R=external review pending. Do not merge into main before critical review.**
