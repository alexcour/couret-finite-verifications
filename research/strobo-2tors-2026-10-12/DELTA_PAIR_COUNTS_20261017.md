# STROBO — exact unordered pair counts by symmetric difference

Date: 17 October 2026.

## Counted objects and formulas

Let G be a finite abelian group, n=|G|, h=|G[2]| and t=|G[3]|.
For a three-element subset S, the observable is the labelled ordered
convolution square

R_S(z) = #{(x,y) in S × S : x+y=z},

including diagonal pairs. Zero is permitted in both supports. Let C_k
count unordered pairs {S,T} of distinct three-element subsets such that
R_S(z)=R_T(z) for every z in G and |S △ T|=k. The ambient elements remain
labelled: the count is not taken modulo translations or automorphisms.

| Symmetric difference | Exact unordered pair count |
| --- | --- |
| 2 | C_2 = n(n−2)(h−1)/4 |
| 4 | C_4 = n(h−1)(t−1)/2 |
| 6 | C_6 = n(n−2)(n−4)(h−1)/12 + n(h−1)²(t−1)/2 |

The final Lean theorem is
`Couret.STROBO2TORS.squareDeltaPairCount_numeric`.
The graph-adjacency theorem `squareDeltaGraph_adj_iff` identifies its
vertices and edges with the exact definition above. All other finite
subsets are isolated vertices and do not contribute to the count.

The two summands in C_6 count ordinary and exceptional edges,
respectively. They may vanish. The theorem does not assert that each
branch occurs in every group. Natural-number subtraction and division
are used in Lean. Multiplicative identities establish exact division;
the cases n<4 are included explicitly in the arithmetic proof.

## Ordinary edges and the factor four

An ordinary partner is T=S+u with u in G[2]. The existing free-action
theorem for three-element supports shows that each triple has exactly
h−1 distinct ordinary neighbours. If E_ord is the number of all ordinary
unordered edges, the graph degree-sum identity gives

2 E_ord = binomial(n,3)(h−1).

This includes ordinary edges lying inside exceptional square fibres.
The number of ordinary fibres alone would not count all these edges.

The previously proved intersection classification allows ordinary edges
only at Δ=2 or Δ=6. In the first case their common two-element subset is
a two-torsion pair. An explicit parametrization is

S={a,a+u,b}, T={a,a+u,b+u},

where u is a nonzero element of G[2] and b lies outside {a,a+u}.
There are n(h−1)(n−2) admissible parameters. Every ordered pair (S,T)
has exactly two parameters, corresponding to the two choices a and a+u
for the common pair's initial point. Reversing the ordered pair gives
the second factor two. Thus

4 E_ord,2 = n(n−2)(h−1).

The formal proof constructs the realization map, proves its image is
exactly the ordered Δ=2 collisions, and identifies every fibre with its
two distinct parameter values. It then uses the graph identity relating
ordered adjacent pairs to twice the number of unordered edges.

Partitioning the ordinary graph gives

E_ord = E_ord,2 + E_ord,6.

Combining this with the preceding identities and
6 binomial(n,3)=n(n−1)(n−2) yields

12 E_ord,6 = n(n−2)(n−4)(h−1).

No division by a possibly zero group parameter is used.

## Exceptional edges

The existing classification and enumeration give exactly
n(h−1)(t−1) exceptional source supports. Fix one such source and use the
certified normalization

S={a,b,b+d}, R={a,2b−a,2b−a+d},

where 2d=0, d≠0, 2a≠2b and 3(b−a) is either 0 or d.
Its nontranslation partners are the h distinct supports R+u with u in
G[2]. The established intersection theorem gives

S ∩ (R+u) = {a} when u=0, and the empty set when u≠0.

Consequently each exceptional source has exactly one exceptional
neighbour at Δ=4 and h−1 exceptional neighbours at Δ=6. Every other
source has none. Summing degrees and dividing by two gives

2 E_exc,4 = n(h−1)(t−1),

2 E_exc,6 = n(h−1)²(t−1).

The normalization preserves both cases 3(b−a)=0 and 3(b−a)=d.
The proof requires neither h>1 nor t>1 as an extra hypothesis: the
exceptional-support set is empty when the corresponding factor vanishes.

## Combining the branches

The ordinary and nontranslation graphs have disjoint neighbour sets.
An ordinary edge supplies a translation; an exceptional edge is excluded
from every translation by the existing Core theorem. Their union has
adjacency precisely

|S|=|T|=3, S≠T, R_S=R_T, |S △ T|=k.

The edge-count partition is proved by adding degrees and applying the
degree-sum identity. There are no nontranslation edges at Δ=2 and no
ordinary edges at Δ=4. At Δ=6 both branch counts add. This gives all
three formulas in the first table.

## Formal inventory and independent finite replay

This extension adds four modules to the qualitative subdivision at
commit `be971f18d3d7fad54ac9df28a096799818e21afb`:

| Module | Public theorems | Purpose |
| --- | --- | --- |
| Strobo2TorsDeltaOrdinaryCount | 9 | All ordinary edges and their Δ partition |
| Strobo2TorsDeltaTwoCount | 10 | Explicit parameters, fibres of size two, and Δ=2 count |
| Strobo2TorsDeltaExceptionalCount | 11 | Exceptional degrees and Δ=4/6 counts |
| Strobo2TorsDeltaCount | 13 | Exact collision graph, addition of branches, and closed formulas |

All modules are roots of the same Lake library and imports of
`Strobo2TorsConsolidated`. The consolidated source inventory has 27 roots
(26 proof modules and the aggregate) and 385 public theorem declarations.
Each public theorem has a fully qualified axiom-trace command in the
aggregate. Lean and mathlib remain pinned to v4.29.1.

`verify_delta_pair_counts_20261017.py` independently enumerates triples
in small products of cyclic groups, builds the nine-term ordered-sum
signature directly, and counts unordered pairs inside each equal-signature
fibre. It compares these observations with the formulas and records
deterministic results in `delta_pair_counts_results_20261017.json`.
The retained replay covers 33 group presentations of order at most 36,
enumerating 28,450 supports and 103,276 colliding unordered pairs:
10,232 at Δ=2, 774 at Δ=4 and 92,270 at Δ=6. All formula, divisibility
and branch-partition checks pass. These totals aggregate the selected
presentations; they are not a census of distinct group isomorphism types.
This finite replay checks examples and conventions; the universal result
is provided by the Lean proof, not extrapolated from the examples.

## Reproduction and certificate boundary

From this directory:

```sh
python verify_delta_pair_counts_20261017.py > delta_pair_counts_results_20261017.json
python check_consolidation.py
cd lean
lake resolve-deps
lake exe cache get
set -o pipefail
lake build 2>&1 | tee lean-build.log
python ../check_consolidation.py --log lean-build.log
```

The repository workflow replays the finite verifier, checks its committed
JSON for drift, compiles all roots together, and inspects all 385 requested
axiom traces. The permitted dependencies are `propext`, `Classical.choice`
and `Quot.sound`. A certificate for the earlier qualitative classification
does not certify this extension. The exact successful source SHA, workflow
run and inspected log are recorded in draft PR #25 and the reference
documents after those checks complete.

These counts permit zero in the supports. Counts separately conditioned
on excluding zero are a different extension and are not asserted here.
Independent human mathematical review and theorem-by-theorem comparison
with the literature remain separate tasks. Formal verification alone
does not establish originality.
