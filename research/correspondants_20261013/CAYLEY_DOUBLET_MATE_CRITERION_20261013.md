# CAYLEY-DOUBLET-MATE-02 — exact criterion and proof boundary (2026-10-13)

Research-only addition to draft PR #30, no merge, priority or outside review claim.

## Mathematical statement (written proof, not yet certified by Lean)

Let G = Z/(2m), h=m (m>=2), and S={a,b,b+h} with a-b nonzero modulo m. Set d=b-a modulo 2m. For a directed Cayley graph E(x,y) iff y-x in S, define IsMate(x,y) to mean x != y and at least two distinct common out-neighbors.

**Theorem (written):** For every x, IsMate(x,x+h) holds. Its partner is unique iff 2d != h modulo 2m. If 2d=h, each x has exactly the three mates x+h, x+d, x-d.

**Proof by ordered differences:** A second common successor of x,y corresponds to two distinct ordered pairs (u,v),(u',v') in S x S with u-v=u'-v'=y-x, nonzero. The six nonzero ordered differences are h (twice), d, -d, d-h, h-d. Since 2h=0, these are h (twice), d (twice iff 2d=h), and -d (twice iff 2d=h), with all other equalities forcing d=0 or d=h, excluded by a != b (mod m). Thus the only repeated nonzero difference is h unless 2d=h; and the h-mate has precisely the two common successors x+b and x+b+h. (The equivalence of difference repetitions is an ordinary finite combinatorial argument and must be audited in Lean.)

**Exceptionality excludes failure:** if 3d=0 mod m and d != 0 mod m, then 2d=h mod 2m is impossible: reduction modulo m gives 2d=0 mod m, hence d=0 mod m by combining with 3d=0. Thus the four-member convolution fibres have unique intrinsic partners.

**Quotient:** The two h-mate classes are [x] in Z/m. The two common successors project to one class [x+b]. Therefore the marked doublet relation defines the translation q_b([x])=[x+b], an explicit permutation. It has gcd(m,b) cycles of equal length m/gcd(m,b). These are graph-isomorphism invariants provided both sides satisfy intrinsic mate uniqueness; they need not determine isomorphism when equal.

## Lean proof status

The extension in `lean/CayleyDoubletCore.lean` introduces `CayleyArc`, `DifferenceRigid`, `TripleSupport`, `halfTurn_isMate`, `halfTurn_unique_of_rigid`, `markedArc_quotient_formula`, `quotientShift`, and `shiftSteps_fixed_iff`. **NEW declarations are candidate only until a fresh, matching-SHA GitHub Actions success is inspected.** `DifferenceRigid` remains an **explicit hypothesis**, not a proved consequence of 3d=0 in Z/(2m). In particular the fully unconditional exceptional cyclic theorem and cycle-count formalisation are still open.

## Exact finite verification

Independent Python enumeration on all even n from 4 to 160 (341,280 parameterisations a in Z/n and b in [0,m), a not equal b mod m) found 338,000 unique cases, 3,280 non-unique cases, and 4,212 exceptional parameterisations satisfying 3(b-a)=0 modulo m; all exceptional parameterisations were unique. For every case, difference multiplicities were checked exactly; sampled shared-successor sets were compared to {x+b,x+b+h}. For every exceptional case the translation cycle formula was independently verified. These counts are parametric support presentations, **not counts of distinct three-subsets or graph isomorphism classes**.

Counterexample: n=8, a=0, b=2, S={0,2,6} has mates 2,4,6 at x=0. These are not exceptional four-member convolution fibres.

## Prior art and separation

This does not claim novelty for n=24 (Mönius thesis example 3.1.20). Brown (2009), Mönius, existing PR #25 classification, and PR #30 exact checks remain separate contributions. No global graph-isomorphism classification is asserted.

Next proof gate: compile the extension on pinned Lean/mathlib v4.29.1, prove DifferenceRigid for 3(b-a)=0 mod m and distinct classes, use quotient map Z/(2m)->Z/m, formalise the cyclic order and cycle multiplicity; then request independent review.
