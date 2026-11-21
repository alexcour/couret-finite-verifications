# STROBO Lean gate — 12 October 2026, matching step

Verified before this update: Actions run 38248071930 completed SUCCESS on commit fc588b12. It compiled Prelude.lean, Rectangle.lean, RectangleFibres.lean.

New file RectangleMatching.lean gives a local direct-or-cross dichotomy for equality of four-point rectangles made from two distinct doubled fibres. It uses the already checked fibre-filter lemmas. This is *not* the type-II square classification: it does not yet derive 3delta in {0,u}, nor the counting formula.

The changed CI workflow compiles RectangleMatching.lean explicitly. The new run must finish green before marking the lemma compiled. No merge, external review, Lean proof of whole theorem, or originality claim.
