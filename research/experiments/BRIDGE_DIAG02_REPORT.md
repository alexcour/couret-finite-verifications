# DIAG-02 — Restricted-shift Möbius pilot: frozen-protocol result

Research branch only, not peer reviewed, no RH claim, no power saving and no Couret novelty claim. The original protocol was committed to research/experiments/BRIDGE_DIAG02_PROTOCOL.md BEFORE execution.

## Design
Prime windows P={150,300,600}; X/P={24,48}; 322 (P,X,p) instances; 2 truly restricted nonzero shift widths H_narrow=floor(sqrt(X)/3) and H_broad=floor(X^(2/3)/4); 644 normalized signed Möbius observations; 32 coefficient-level deterministic global random-sign surrogate arrays reused across all conditions, with fixed seeds.
Each signed sum is divided by the exact positive weighted squarefree pair mass V. No posthoc changes.

## Frozen decision rules
General continuation requires the observed absolute cell mean to exceed the 90th-percentile absolute surrogate mean in >=10/12 cells and coherent narrow/broad signs for each P,ratio.
Specific chi5 requires chi5 absolute contrast to exceed both chi3 and chi15 AND its own 90th-percentile surrogate contrast in >=10/12 cells.
These are pilot heuristics, NOT p-values or asymptotic statements; data are dependent and past work already informed this design.

## Results
- General surrogate threshold excess 8/12, coherent signs 6/6: NOT PASS.
- Simultaneous chi5 superiority and surrogate threshold excess 0/12: NOT PASS.
- Exact assertions: 322 nested window support checks, 644 |Z|<=1 checks, 12 independent full-shift factorization checks, 12 independent negative Möbius diagonal checks: PASS.
- Full prime-level table (including 32 surrogate z per condition), summary cells, script and SHA256 manifest are archived in the reproducible ZIP.

## Interpretation
There is modest finite signed correlation in some restricted shift windows, but the preregistered general continuation threshold is not met. There is NO evidence of an exceptional Couret chi5 signal in the prespecified controlled comparison. Unlike the unrestricted sum, restricted-h windows cannot collapse to a single product of eight residue sums; however they still have an exact Fourier-kernel representation in terms of twisted one-point sums. No new uniform affine theorem is established.

## Reproduction and provenance
Drive canonical program folder SCHEMAS & PROTOCOLES: BRIDGE_DIAG02_REPRODUCIBLE_2026-10-08.zip, Drive file id 1KT1CUR9GVDrhk3Mln6aoHNbVHpA7sgHu.
Run: python bridge_diag02.py, using Python standard library only.
SHA256 script: 0d8f7b759ab0cbbedab5a4a9c927e60d97ea4fc1fa3139d49556cd477badea1d
SHA256 compact JSON: 622f489230c04de07b9e61194b1036b854142423824875794581f6cb2acccb6a
SHA256 cell CSV: a6a37cb94690980b20321cbf80664830066eff921a8080c76d592c72d7fc4a12
SHA256 prime CSV: 7e52a70a547951d57c9f222d1ed9d76f65e1fb4213308ebf82fbc5da5692e757

## Decision
Do not retune or advertise positive Couret evidence. Future work should derive an explicit analytic kernel inequality with p and H dependence, independent from this finite diagnostic, and audit prior art before novelty claims.
