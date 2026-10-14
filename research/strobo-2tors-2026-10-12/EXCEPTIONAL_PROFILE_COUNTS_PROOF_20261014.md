# STROBO-3 - Exceptional support counts by profile (2026-10-14)

STATUS: INTERNAL WRITTEN MATHEMATICAL ARGUMENT. Not yet a new Lean compilation certificate or independent external review. PR #25 remains DRAFT.

Let G be a finite abelian group; H=G[2], K=G[3], n=|G|, h=|H|, t=|K|. The already formalized injective exceptional parameter representation is S(a,d,v)={a,a+v,a+v+d} with a in G, nonzero d in H, and nonzero v in K.

A nonzero v of 3-torsion does not belong to H. Hence the two cosets H and H-v are disjoint, each of size h. For each fixed admissible (d,v), exactly h parameters a in H give a triple with ONE point in H; exactly h parameters a in H-v give TWO points in H; the remaining n-2h values give ZERO points in H; THREE points are impossible. The three cases are exhaustive and mutually exclusive.

The exceptional SUPPORT counts by profile are:
X0 = (n-2h)(h-1)(t-1)
X1 = h(h-1)(t-1)
X2 = h(h-1)(t-1)
X3 = 0.

Do not confuse support counts Xj with counts of exceptional fibres. The bridge Pj = h*Oj + Xj, where Pj=choose(h,j)*choose(n-h,3-j), then implies:
h*Oj = choose(h,j)*choose(n-h,3-j)-Xj.
The subtraction is mathematically sound because the support partition is disjoint. Explicit ordinary fibre count Oj requires the compiled cardinality calculation for every exceptional parameter stratum. The profile j=1 and j=3 computations already have specialized Lean declarations, while j=0 and j=2 remain the immediate closure targets.

Boundary cases: h=1 or t=1 implies Xj=0. An exception forces h>=2 and t>=3, hence n>=3h, so n-2h is nonnegative. For h=2 a reduced exceptional fibre can have the same size as an ordinary fibre; histogram contributions ADD rather than overwrite. Empty restrictions are not observed fibres of size zero.

Formalization plan: count a in H-v via translation bijection from H; count the complement by removing two disjoint h-element cosets; use uniqueness of paramSupport and the already formalized Pj=h*Oj+Xj bridge to obtain all Oj. No novelty or publication claim.