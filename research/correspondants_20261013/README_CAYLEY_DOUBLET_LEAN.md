# CAYLEY-DOUBLET-LEAN-01: intrinsic-mate transport

Date: 2026-10-13. Status: Lean **candidate** until the remote CI run on the exact
commit reports success; no external mathematical validation or originality claim.

`lean/CayleyDoubletCore.lean` proves, for arbitrary types of vertices and
arbitrary directed edge relations with a bijective adjacency-preserving map:

1. A pair of vertices with two distinct common successors is preserved.
2. The relation "distinct vertices with two common successors" is preserved.
3. If each source vertex has a chosen mate and the target has uniqueness,
   the intrinsic mate function is transported by every digraph isomorphism.
4. The marked relation of having a successor shared with one's mate is
   preserved. This is the naturality needed to define a directed quotient.

**Precisely not yet proved in Lean:** for Cayley supports
`S={a,b,b+m} subset Z/(2m)`, the unique mate is `x+m`; existence of a
well-defined quotient permutation on `Z/m`; the permutation's cycle lengths;
and the global `n=12r` non-isomorphism construction. They have internal
written arguments and exact Python verification in CAYLEY-N48-A2, not a
complete Lean theorem.

Local build, if Lean/mathlib 4.29.1 is installed:

```
cd lean
lake resolve-deps
lake exe cache get
lake env lean CayleyDoubletCore.lean
```

PR #25 is a separate STROBO-2TORS convolution classification branch. PR #30
provides graph-specific Python checks and the present independent Lean gate.
Both must remain draft pending outside review and priority audit.
