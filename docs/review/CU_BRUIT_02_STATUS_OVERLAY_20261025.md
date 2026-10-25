# CU-BRUIT-02 — Additive scientific-status metadata overlay

**25 October 2026 — private review / NOT a proof promotion**

Source scientific checkout: `69e82895522e00a3be2024682318ce49b8e779f5`, PR #92 (OPEN/DRAFT). Original file hashes are pinned by `research/cu-bruit-02-2026-10-21/MANIFEST_SHA256.json`. This document is **additive only**: it does not amend the source, numerical receipts, certified zero intervals, or the manifest. It must not be read as a replacement for the original source certificate.

## Effective scope of the consolidated conditional claim

The theorem in `NOTE_CONSOLIDEE_CU_BRUIT_02_20261021.txt` asserts an upper bound `delta_plus < 0.468` for the specified weighted prime race on `T={1,11,29}` modulo 30. The global assumptions are:

- **G:** GRH for the seven specified primitive Dirichlet L-functions with conductors 3, 5, and 15.
- **L:** joint rational independence of the 67 *positive* zero ordinates in the isolated low block (`0 < gamma <= 25`).
- **S:** zero intersection between the rational span of those 67 ordinates and the rational span of the **remaining active spectrum, after coefficient aggregation**.

**Do not add as effective global hypotheses:** an upper bound of 9 on high-zero multiplicities; global simplicity; absence of shared high ordinates; global symmetry; or joint LI throughout the high tail. Their absence from the theorem is part of what the consolidated argument intends to establish. G, L and S are **not proved** by any numerical experiment.

Finite inputs to review separately: direct Arb enclosures of the seven central L-values, finite zero isolation and contour counts through height 200, the quadratic majorant and its interpolation bound, and the explicit zero-counting estimate above 200. An independent reconstruction of these inputs and mathematical review remain outstanding.

## Legacy metadata identified in the pinned packet

| Pinned file | Historical metadata as emitted | Correct reading for the consolidated proof |
| --- | --- | --- |
| `audit_quadratic_majorant.py` | `sufficient_hypotheses` contains “central nonvanishing, supported by pinned internal K certificate” | Central nonvanishing is established *within the declared computation trust base* by direct Arb enclosures from `audit_center_and_characters.py` at 256/320 bits; the older K route does not govern this proof. |
| `audit_quadratic_majorant.py` | `sufficient_hypotheses` includes “total multiplicity at each tail positive ordinate at most 9” | This entry applies to historical `sign_probability_upper_by_total_tail_multiplicity` tables only, not to the final `delta_plus<0.468` proof using `audit_variance_counting.py`. |
| `audit_variance_counting.py` | `sufficient_hypotheses` cites “central nonvanishing supported by internal K certificate” | Replace that interpretation with the direct seven-character central L-value enclosure, independently reviewable as a finite numerical claim. |

The old table and legacy metadata are retained for provenance, **not silently edited**, because changing the pinned Python file bytes without regenerating the manifests and affected receipts would destroy historical SHA-256 correspondence. This overlay is authoritative only as a *review clarification*; a future version may migrate the metadata into the executable output after a fresh full replay and manifest update.

## Numerical cross-checks completed separately on 25 October

1. The BMOR/Stieltjes upper-tail arithmetic was recomputed from the published formulas rather than by importing the project's Python code. Reported agreement: `Var(R200) < 5.390185770657` and total remainder variance `< 6.031536364085`; the finite-band interval remains a dependency on the original certified roots.
2. A floating-point (non-rigorous) cross-check of the global quadratic majorant reproduced a positive margin, with the tight point around `r=1.625`; this does not substitute for the original Arb enclosure.
3. **Second arithmetic backend, limited sample:** the Dirichlet-character values were independently reconstructed from generators of `U(30)` and `L(s,chi)` evaluated with mpmath's Hurwitz zeta formula (DLMF §25.15.3), not FLINT/Arb. Fourteen rounded ordinates (two from each of the seven characters) gave absolute residuals at most `9.09e-13` with 45-digit working precision. This independently **spot-checks** the listed approximate zeros. It does *not* certify their uniqueness, multiplicities, completeness or enclosure radii, and does not verify all 995 roots.

## Independent validation still required

- **Z1:** For each of the seven primitive characters, independently reproduce a rigorous argument-principle or Turing-style zero count through height 200, including boundary nonvanishing and correct signed/positive zero conventions.
- **Z2:** Use a genuinely separate evaluator / rigorous enclosure strategy for every zero interval; distinguish numerical agreement from formal containment and simple-root verification. Compare character/conjugate mapping and count vectors `114, 130, 129, 129, 165, 164, 164`. Do **not** claim a full independent certification from the 14-point mpmath spot-check.
- **A1:** External mathematical review of the application of Devin / Akbary–Ng–Shahabi, low/high phase factorization under G/L/S, conjugate and shared-zero bookkeeping, and the switch from distributional convergence to the sign event.
- **A2:** Independent review of the globally valid quadratic majorant (`g(r)<=Q(r)`), Fourier inversion, Simpson derivative estimates, interpolation loss and both exterior regions.
- **A3:** Verify the BMOR theorem hypotheses and `N_chi(H)` signed counts, the step `n_gamma <= B(gamma)`, Stieltjes boundary signs, and the infinite-tail integration.
- **B:** Separate prior-art comparison and an independent specialist's mathematical opinion. These are not supplied by a successful CI run.

## Status and boundaries

`PROVEN_GLOBAL_HYPOTHESES=false`; `NEW_INDEPENDENT_995_ZERO_CERTIFICATE=false`; `HUMAN_REFEREE_COMPLETE=false`; `PR92=DRAFT`; `PUBLICATION=HOLD`.

No `main` change, source-script modification, merge, release, DOI, email, deployment, sharing change, or scientific certificate promotion is authorized by this overlay.

Review sources: [PR #92](https://github.com/alexcour/couret-finite-verifications/pull/92); [original scientific commit](https://github.com/alexcour/couret-finite-verifications/commit/69e82895522e00a3be2024682318ce49b8e779f5); [BMOR 2021](https://personal.math.ubc.ca/~bennett/BeMaObRe-MathComp-2021.pdf); [NIST DLMF 25.15](https://dlmf.nist.gov/25.15).
