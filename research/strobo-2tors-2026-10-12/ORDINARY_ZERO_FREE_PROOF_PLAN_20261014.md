# STROBO-2TORS — ordinary zero-free orbit counting and proof obligations (14 October 2026)

**Status:** mathematical reduction and adversarial checks, **not** a compiled universal proof of the binomial formula. PR #25 remains DRAFT. This file supplements, and does not replace, existing proof notes.

## Setup and precise counting units

Let G be finite abelian, H=G[2], n=|G|, h=|H|, q=n/h, t=|G[3]| and r3=(t-1)/2. All square fibres use the **labelled nine ordered sums**, including diagonal pairs, and all supports have exactly three distinct elements. An H-*orbit* consists of translates of a support by H, while an exceptional square *fibre* consists of **two** disjoint H-orbits. Keep these units separate.

For j in {0,1,2,3}, define P_j={S subset G: |S|=3 and |S intersect H|=j}. The action of H by translation preserves P_j (since H is a subgroup) and is free on supports of odd size 3 (already established in Strobo2TorsCardinality.lean). Therefore each P_j decomposes into orbits of length h.

Selecting j points from H and 3-j from G\\H counts P_j with size binom(h,j)*binom(n-h,3-j). Accordingly

  T_j := |P_j|/h = binom(h,j)*binom(n-h,3-j)/h

is an *integer*, not a heuristic real quotient. Binomial coefficients outside admissible ranges are zero.

## Exceptional *orbit* contribution

Define E_j as the number of H-orbits lying inside exceptional square fibres and having j points in H (equivalently, belonging to the corresponding P_j). The finite-check candidate is:

  E_0 = 2*(q-2)*(h-1)*r3
  E_1 = 2*(h-1)*r3
  E_2 = 2*(h-1)*r3
  E_3 = 0.

In groups where exceptions cannot exist the right sides must be interpreted as zero (using Nat subtraction, and the structural fact that q<3 forces (h-1)*r3=0). **These equalities still require Lean proofs**, including distinguishing the two orbits inside each exceptional fibre. The parameters of exceptional supports and their unique normal form already exist in Strobo2TorsEnumeration.lean; the exceptional hit/miss enumeration exists in Strobo2TorsZeroFree.lean.

## Ordinary fibres and zero-free aggregation

Each ordinary fibre is exactly one H-orbit and has zero-free size h-j if its support has j points in H. Translation preserves j, so its orbit has well-defined j. The resulting candidate count is

  O_j = T_j - E_j.

This is a count of **ordinary full fibres** of profile j, not necessarily surviving zero removal. In the zero-free histogram, omit any j for which h-j=0. Empty restrictions must not be counted as a size-zero observed fibre.

For k>0, the full observed histogram is

  F_k = sum_{j=0..3, h-j=k} O_j
      + (if k=2h-2 then 3*(h-1)*r3 else 0)
      + (if k=2h then (q-3)*(h-1)*r3 else 0).

The two exceptional sizes above are distinct when h>0, but either can coincide with an *ordinary* size (notably h=2). Counts must be **added**, not inferred by size classification alone. Existing Strobo2TorsZeroFreeAll.lean proves the disjoint partition and the actual-fibre aggregation before the ordinary closed-form substitution, subject to green CI for the current HEAD.

## Proposed Lean proof decomposition

1. Define P_j and prove cardinality via Finset.filter / choose-card identities.
2. Prove H translation invariance of j and that each orbit contained in P_j has cardinal h.
3. Use disjoint orbit partition to obtain h*T_j=binom(h,j)*binom(n-h,3-j), avoiding premature Nat division.
4. Count exceptional orbits by j from normalized parameters (a,d,v), controlling duplicate (a,d,v) descriptions by the existing uniqueness lemmas. Distinguish exceptional *orbits* from exceptional *fibres*.
5. Subtract exceptional orbits from P_j's orbit count and show resulting ordinary fibres are in bijection with these remaining orbits.
6. Substitute O_j into the existing positive-size aggregate theorem, guarding h-j>0. Prove a separate zero-size exclusion.
7. Check #print axioms on every new theorem and the remote Lean CI at the exact commit SHA.

## Counterexample guards and certification gate

- Z/6: counting exceptional *fibres* in place of their component H-*orbits* gives an incorrect subtraction.
- Z/12: ordinary size-2 and exceptional size-2 restrictions coexist and must be added.
- Small h=1,2 and n<4: size-zero restrictions and degenerate binomial ranges.
- The previous independent Python replay covers 102 group types, 908895 supports and 518778 full fibres, but only as a **bounded finite check**.

Never claim compiled ordinary formula, full maxima table, independently reviewed mathematics, Cayley cospectrality from equal convolution squares, or academic novelty without additional proof. Do not merge PR #25.
