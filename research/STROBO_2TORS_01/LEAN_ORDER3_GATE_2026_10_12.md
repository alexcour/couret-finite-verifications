# STROBO-2TORS — crossed-order-three Lean gate (2026-10-12)

Previously verified: workflow 38269926810 SUCCESS for RectangleMatching.lean.

New module `STROBO2Tors/CrossedOrderThree.lean` states:
Given a finite abelian G, u with u+u=0, and two crossed equalities of pairSet in the normalized setting (singleton b aligned), three times (b-a) is 0 or u.
It also states the reverse existence, choosing c=2a-b.

**Scope warning:** normalizing the singleton of two general supports to b and deriving the rectangle equalities from `SameSquare` remain separate formal obligations. This is not a full Lean certification of the classification or of counts.

The module has been committed, imported, and added to the GitHub Actions build on PR #24. Until a green action is read back, status is SOURCE SUBMITTED / COMPILE UNCONFIRMED.
No external peer review, publication priority or merge.