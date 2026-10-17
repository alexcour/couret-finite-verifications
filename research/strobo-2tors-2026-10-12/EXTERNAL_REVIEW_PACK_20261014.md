# STROBO-2TORS — external referee packet (14 October 2026)

**Status: PRIVATE MATHEMATICAL REVIEW / DRAFT.** No journal submission, claim of originality, GitHub merge or public release is authorized by this packet. No private correspondent's email is reproduced.

## Current science and validation

Let G be a finite abelian group, H=G[2], h=|H|, n=|G|, q=n/h, and r3=(|G[3]|-1)/2. For every support S of exactly three elements, R_S(z) counts the nine ordered representations x+y=z (including x=y). The exact full-fibre classification is formalized via `orderedSquare_classification_iff` in `Strobo2TorsCore.lean`; a second translation orbit arises exactly in an exceptional order-six configuration. Each complete fibre has size h or 2h, and the finite global counts are E=q(h-1)r3, O=binom(n,3)/h-2E.

Lean toolchain/mathlib v4.29.1, branch `research/strobo-2tors-global-classification-2026-10-12`. Latest repaired HEAD at handoff: `8fa1f804eaa37a4eecd159c22261d1ebd758f78e`: GitHub Actions `strobo-2tors-lean` run 38572322791 SUCCESS and `verify` run 38572323171 SUCCESS (read back on 14 October 2026). The fifth module `Strobo2TorsZeroFreeAll.lean` compiles a positive-size aggregation of actual ordinary and exceptional zero-free fibres, an injectivity statement, and an exceptional two-atom formula. **It does not yet provide a Lean proof of the explicit ordinary binomial-orbit histogram, profile/pair totals or sharp maxima.** The bounded internal enumerators are not independent expert review.

## Required corrections to the October 14 eight-page working note

1. The final uniqueness clause in Theorem 1.3 needs `|G| >= 3`: in the group of order two the universal statement about three-element subsets is vacuously true.
2. Remark 3.2's converse needs a second case. For S={a,b,b+d} of doubling profile (1,2), with d nonzero and 2d=0, symmetry of R_S about 2a holds iff **2(b-a)=d OR 3(b-a) belongs to {0,d}**. The two cases are disjoint; in the first case 2a-S=S, in the second case a genuine exceptional reflection occurs. Counterexample to the old converse: G=Z/4, S={0,1,3}, a=0,b=1,d=2.
3. Break the overlong display on page 5 and repository path on page 7.

An eight-page *corrected reader copy*, preserving the paper's structure and mathematics, and the independent technical audit have been uploaded to the **private Google Drive review folder**:

- [Corrected manuscript](https://drive.google.com/file/d/16GJ-aDzAa54bjYOgU2SoYINesvCHynzF/view)
- [Audit (secondary mathematical review, not referee report)](https://drive.google.com/file/d/1UhwEZGPm7FcGI_b6Nixf6--xwp8R-SG9/view)

The corrected reader copy was edited directly as a PDF because the original .tex source was not present in the received files. The original source-controlled manuscript should eventually be amended and recompiled from LaTeX for submission-quality reproducibility.

## Literature and boundary of novelty

The local Z/6 example is **not new**: Chen and Yan, *Partitions of Z_m with identical representation function*, Bull. Austral. Math. Soc. 103 (2021), Theorem 1.2, DOI:10.1017/S0004972720000945. For disjoint-set partitions compare Yang and Chen (2012), Theorem 2. The wider general classification and exact finite abelian fibre counts still require detailed prior-art comparison; also consult V. F. Lev (2004), Problem 2. Do not present a 2021 example as an original construction.

**No automatic Cayley implication:** equality of labelled convolution squares does not alone imply cospectrality of arbitrary Cayley adjacency matrices; the directed family in Proposition 1.4 has extra parity structure. The general graph proposition remains a manuscript proof, not a kernel-checked Lean declaration.

The RECOH-30/24 Fourier probe budgets concern **unlabelled spectral ambiguity and labelled Fourier probes**, a distinct inverse problem. They should not be silently identified with equality of R_S.

## Questions for an expert reader

1. Is the casewise classification for **all finite abelian groups** complete? In particular, does the normal form from the labelled ordered square introduce any missed order-six/2-torsion degeneracies?
2. Are the fibre counts E and O already explicit in prior literature? Is the classification an existing special case of an earlier theorem?
3. Are there alternative explanations or counterexamples to the claimed implication for the specific directed Cayley family (not for arbitrary equal-square triples)?

No obligation to conduct a full review is implied. A positive CI result is not an expert endorsement. Keep PR #25 DRAFT.
