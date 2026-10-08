# CGL-01 — Connes / Grothendieck / Liouville: cross-audit and research gate (2026-10-08)

> Research branch, not part of the finite-verifications v1.0.0 release. Classical mechanisms; no RH result, no priority claim, no stable release. Source-level historical code not rerun here. Private Drive audit held separately.

## Exact / independently checked

- (U(30)=\{1,7,11,13,17,19,23,29\}\cong C_4\times C_2); squares \(\{1,19\}\); 2-torsion \(\{1,11,19,29\}\).
- (T_C=\{1,11,29\}\), an arbitrary union of 3 Frobenius classes in (\operatorname{Gal}(\mathbb Q(\zeta_{15})/\mathbb Q)\), has natural density (3/8\) by classical Dirichlet/Chebotarev theory. No link to (1/\sqrt 7\).
- Fourier squared magnitudes of \(1_{T_C}\) on U(30): 9,1,9,1,1,1,1,1; Parseval sum 24. For CU-BRUIT-01 weights \(c=5\) on T_C and \(-3\) on the complement: trivial coefficient 0, nontrivial magnitudes 24 (quadratic character mod 5) and 8 (six remaining characters), Parseval \(576+6\cdot64=960\).
- Classical (B(\chi)\) factors numerically evaluated from generalized Stieltjes constants: chi5 = 0.15655695399428649; quartics conductor 5 = 0.20322143257953434 each; quadratic conductor 3 = 0.11322996985747234; conductor 15 = 0.40747843517714794, 0.459364791008131, 0.40747843517714794. Weighted chi5 variance fraction = **0.4399030503937205**. This is **not** a prime-race sign density.
- Combinatorial mean parameter for this race: \(-1\) in the standard normalization; interpreting as a limiting-law mean requires the stated hypotheses.
- Restricted Bost–Connes partition series for integers coprime to 30 (β>1): \(\zeta(\beta)\prod_{p=2,3,5}(1-p^{-\beta})\), with pole residue \(4/15\).
- \(\int_0^1\operatorname{atanh}(x)^2 dx=\pi^2/12\), confirming LC/LC endpoints of the Legendre minimal differential expression. For regular (-u''+\beta u\) on a bounded interval, minimal deficiency indices (2,2). No general claim for **singular** finite endpoints.

## Claims explicitly not established

- No valid operator/traces/positivity map from finite U(30) to the zeros of the Riemann zeta function.
- No derived equality between geometry \(1/7\), a Bost–Connes modular fluctuation, or the proposed time \(\tfrac12\log(7/6)\).
- A defective historical proof for integral operator \(S_{1/2,30}\) does **not** negate or certify essential self-adjointness of a fully defined operator. Old InterIA-SA source has not been independently rerun.
- Connes 2026 (arXiv:2602.04022) describes approximations of zeros using places 2,3,5,7,11; this is an external result, not a Couret achievement or RH proof.
- No theoretical sign density δ+ has been computed in this package. Existing finite-window results of CU-BRUIT-01 are not recomputed.

## Falsifiable priorities

1. **Prime race (P1):** Keep the pre-registered CU-BRUIT-01 statistic D=5A-3B, normalisation, signs and data frozen. Under explicitly stated GRH/LI-type assumptions derive the limiting characteristic function, mean, variance, and δ+ with numerical error; compare without tuning. Stop if the classical Rubinstein–Sarnak model accounts for the data.
2. **Connes baseline (P2):** Reproduce numerics with places S={2,3,5,7,11} before reducing to {2,3,5}; compare to unrelated three-place controls. Stop if baseline fails or no mod-30-specific difference remains.
3. **Lean (P3):** Prove square/torsion facts and \(\chi_5(p)=1 \iff p\equiv\pm1\pmod5\) for primes p>5, without sorry; compile before asserting formalization. Theorems are classical.
4. **Spectral adversarial testing (P4):** Legendre minimal (2,2), regular finite Schrödinger (2,2), Bessel ν=0 and ν=1, and singular finite LP examples; historical false assertions must fail. H1 remains open until operator and domains are specified.
5. **Function-field controls (P5):** Treat matching finite group structures as instrumentation tests, not evidence for integer RH.

## Governance

- Do not change frozen CU-BRUIT-01 artifacts or its original protocol.
- Journal F already includes F-002…F-009; proposed Connes F-014…F-017 labels are **not** assigned until reconciliation.
- E (claim truth), N (novelty), Q (witness), scope and publication status remain separate.
- No claim of novelty or generalization, no release; formal CI and independent review not yet completed for this audit.
- Internal Drive cross-audit and historical documentation remain in Drive; this file intentionally contains no nonpublic datasets.

Related historical research path: `research/LIOU_MOB_01_AUDIT_PROTOCOL.md` on branch `research/liouville-audit-2026-10-08`.
