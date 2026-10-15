# NTK-OBS-05 — Bounded-noise minimax risk and observation economics

**Internal research, 2026-10-11. No external peer review or novelty claim.**

Continuation of NTK-OBS-01/04. Two new sharply scoped findings with exact elementary proofs and rational certificates:

1. For each of the four continuous 4D positive two-mode spectral boxes from NTK-OBS-04 (known family label), under bounded noise `|e_t|<=1/100`, the **exact all-horizon worst-case `L_infty` minimax error** on the whole four-parameter vector, and separately on both nodes, is `1/1000`. The box center (zero measurements) is minimax optimal. This is a *negative* guarantee about reconstruction **within** the known box, not about identifying the box label.
2. In a **different** single-unknown-node positive two-mode slice with `q in [0.89,0.91]`, all other parameters known, the **exact** bounded-noise minimax error at horizon H is given by a one-dimensional diameter formula. A single optimally timed query (or none) achieves the error; times `>=12` are minimax-dominated by time 11. A target-precision/worst-case-cost theorem is given. This is **not** a theorem for recovering all four unknown parameters from one observation.

`PROOF_NOTE.md` contains full statements, proof logic, definitions and limitations. `PROTOCOL.md` defines reproducibility. `CLAIM_BOUNDARY.md` identifies safe claims. `REFERENCES.md` cites classical work.

`verify_minimax.py` creates a canonical exact rational `results.json`. `independent_audit.py` independently verifies its mathematical bracket inequalities. To reproduce in a clean extracted directory:

```sh
sh verify.sh
```

Requires standard-library Python 3.9+, POSIX sh and sha256sum. No network, random, floats or third-party dependencies. Every result is either an exact mathematical identity or an explicitly bounded rational interval. No general NTK training or external peer review is claimed.

The repository branch should remain **research-only**. Conditional public **unreviewed** Zenodo archiving is a separate controlled decision, not disallowed merely because peer review has not yet occurred. No DOI or merge is claimed here.
