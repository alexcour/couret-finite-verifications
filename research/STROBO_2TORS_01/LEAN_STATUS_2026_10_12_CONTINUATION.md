# STROBO Lean status -- 12 October 2026

Confirmed: GitHub Actions run 38245919630, commit c7b0518, success. Steps including pinned package build and explicit elaboration of Prelude.lean and Rectangle.lean succeeded. This certifies only definitions, elementary 2-torsion statements and pair_coset_eq_iff; not the general classification.

Added in this continuation:
- RectangleFibres.lean: intrinsic filter recovery of pairs by doubling, doubled image computation, equality-of-rectangles implies equality of two doubled values.
- Root module imports added; GitHub workflow explicitly elaborates RectangleFibres.lean.
- Workflow run 38248071930 for commit fc588b1 initially queued. Do not claim successful elaboration without a green CI result.

Important distinction: identifying the two doubled-value fibres is only a local ingredient. The complete type-II matching, mod-2 case split, reflection classification and fibre counting are still unformalized.

Referee condition: clean CI, zero placeholders and no untrusted axioms; additionally independent mathematical review required. PR #24 stays draft and unmerged.
