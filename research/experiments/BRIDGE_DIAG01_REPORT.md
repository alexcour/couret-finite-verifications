# DIAG-01 — Spectral diagonal-removal audit — VERIFIED FINITE RESULTS

Status: finite descriptive diagnostic only. No RH/zero-free claim; no Couret-specific advantage confirmed. Frozen source protocol committed at de056171de5f8bce88a47bc8a777637cd875cc94 before run. Unique DIAG-01 naming preserves existing EXP-03.

## Corpus and QA
P=100,200,400; X/P=8,16; q=7,11,13,17; both Möbius and plain; tent W on [1,2]. 1,824 spectral records (912 each), 48 comparison cells (24 each). 576 independently evaluated sentinel Fourier identities, Parseval, B=F-L and full spectral energy split all PASS.

## Main diagnosis
For each p,q, let F be the FFT of the shift sum *including* h=0, let L=b_0, let B=FFT of the offdiagonal shift sum. Exactly B_j=F_j-L. In Möbius L=-D<=0 (D>=0); in plain L>=0.
The nonzero-frequency energy obeys:
E_nz(B)=E_nz(F)+(q-1)|L|²-2 Re(conjugate(L)*sum_{j=1}^{q-1}F_j).
The interference term is essential; diagonal contribution cannot be interpreted as purely additive power.

## Descriptive averages over 24 cells of each kind
Möbius: average M1_off=0.2038461986; M1_full=0.2074657065; delta=-0.0036195079; diag_amp_ratio=0.2045241385. 613/912 individual |delta|>0.01.
Plain: average M1_off=0.00115940367; M1_full=0.00026027862; delta=0.00089912506; diag_amp_ratio=0.9827697922.
Möbius M1_off mean absolute quadratic family contrast:
chi3=0.0206154485, chi5=0.0176712930, chi15=0.0207266500.
Möbius delta_M1 mean absolute family contrast:
chi3=0.0099596993, chi5=0.0094293660, chi15=0.0106683349.
Möbius chi5 beats BOTH quadratic controls in 9/24 cells for M1_off and 7/24 for delta_M1. No stable advantage.

## Reproduction of EXP-02 pilot
Pooled Möbius chi5 selected-minus-complement M1_off contrast by q:
7 +0.007537428, 11 -0.015123007, 13 -0.002000903, 17 +0.006715734. These agree with the prior pilot, validating comparability.

## Machine artefacts and hashes
Full exact script, raw JSON, cell CSV, row CSV and manifest packaged in the canonical Google Drive folder SCHEMAS & PROTOCOLES as BRIDGE_DIAG01_REPRODUCIBLE_2026-10-08.zip, file ID 1QwU5P77m9-Ibf5KilRAfxTzSX4P6wBWn.
Script SHA-256 f46ea0f8d2a9b94e69befb65ea3f162629fa968e65984a76e8ac320df68af304
Raw JSON SHA-256 a20734f1238bf3503c470e615271524e979a9792767614b90a3bcc386cf2bb8a
Manifest: 1,824 rows, 48 cells, 576 sentinel checks. Historical EXP-02 and EXP-02C untouched.

## Verdict
DIAGONAL REMOVAL MATTERS BUT DOES NOT EXPLAIN ALL THE MÖBIUS SPECTRAL STRUCTURE. There is no empirically stable chi5 advantage versus chi3 and chi15 on the frozen panel. Distinguish full h-sum (factorizes into one-point sums) from restricted shift sums (possible true two-point question). The next prospective experiment needs a separate preregistered window in h. No post-hoc retuning.
