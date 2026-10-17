# Independent-review brief — two-colour cyclic Cayley digraphs

**14 October 2026 · Research-only draft · Not peer reviewed · No novelty or priority claim**

## Precise statement

For every integer `r ≥ 1`, put `n = 12r` and let `D_S`, `D_T` be the **directed** Cayley graphs on `Z/nZ` with arcs `x → x+s` for, respectively,

- `S_r = {1, 1+2r, 1+8r}`,
- `T_r = {1, 1+4r, 1+10r}`.

The internal argument establishes (a) cospectrality of the directed adjacency matrices, including algebraic multiplicities, and (b) non-isomorphism of the digraphs for every `r ≥ 1`, including `3 | r`.

**Scope warning:** this does not assert cospectrality of the underlying *undirected* simple graphs for every `r`.

## Sketch of the two arguments

**Cospectrality.** Both ordered convolution squares have the same coefficients in the integral group algebra of `Z/(12r)`:

`[2] + 2[2+2r] + 2[2+4r] + 2[2+8r] + 2[2+10r]`.

Thus `A_S² = A_T²`. Every increment is odd, so both digraphs are bipartite and the trace of every odd power vanishes. Their traces of all positive powers coincide; Newton identities give the same characteristic polynomial.

**Non-isomorphism.** For any vertex `x`, the unique *different* vertex with at least two common outgoing neighbours is `j(x)=x+6r`. On the intrinsic pairs `{x,x+6r}`, the two outgoing-neighbour types yield two intrinsic operations:

- `Q`: the **unshared singleton** successor, which is translation by `+1` on `Z/(6r)`;
- `P`: the **shared doublet** successor, translation by `+(1+2r)` for `S_r` and by `+(1+4r)` for `T_r`.

An arbitrary graph isomorphism must conjugate **both** operations. Because `Q` is a single `6r`-cycle, the exponent `k` in `P=Q^k` is invariant under simultaneous conjugacy. The exponents `1+2r` and `1+4r` are distinct modulo `6r`, so no isomorphism exists. The uniqueness of the mate requires checking all repeated nonzero differences; it is not true for arbitrary 3-element supports.

## Reproducibility and certification boundary

- [Detailed internal mathematical note](https://github.com/alexcour/couret-finite-verifications/blob/4dd81b38a7f17eb223737e8dffb9c3c4340c5b5a/research/correspondants_20261013/NOTE_TWO_COLOUR_QUOTIENT_20261013.md) (French).
- [Lean theorem for all positive r](https://github.com/alexcour/couret-finite-verifications/blob/4dd81b38a7f17eb223737e8dffb9c3c4340c5b5a/research/correspondants_20261013/lean/CayleyTwoColourZMod.lean), `cayley_twelve_mul_nonisomorphic`. This formalizes the **non-isomorphism** direction.
- [Lean CI run 38612787838 — SUCCESS](https://github.com/alexcour/couret-finite-verifications/actions/runs/38612787838) at `4dd81b38a7f17eb223737e8dffb9c3c4340c5b5a` (Lean/mathlib 4.29.1); [other exact finite replays](https://github.com/alexcour/couret-finite-verifications/blob/4dd81b38a7f17eb223737e8dffb9c3c4340c5b5a/research/correspondants_20261013/verify_two_colour_quotient.py) cover `r=1..120`, including 40 multiples of 3. Finite tests alone are not a universal proof.
- The **cospectrality** argument is written algebraically and finitely tested, **not claimed to be formalized by the theorem named above**.
- [Draft PR #30](https://github.com/alexcour/couret-finite-verifications/pull/30) remains **DRAFT**; no stable release, peer review, or originality claim.

## Specific independent-review questions

1. Is the repeated-difference/common-neighbour reconstruction of the unique intrinsic mate valid for every `r ≥ 1`, with no hidden exceptional cases?
2. Are both quotient relations intrinsically defined and necessarily preserved by an arbitrary directed-graph isomorphism?
3. Does the written argument from equality of squared adjacency matrices to equality of characteristic polynomials require additional hypotheses?
4. Is there published prior art giving this exact infinite oriented family, a stronger classification, or an equivalent construction? The undirected `n=24` phenomenon has prior art in Katja Mönius's thesis and related publications.
5. Does the Lean formal statement faithfully encode the intended digraph-isomorphism claim? A successful kernel check alone cannot replace independent mathematical scrutiny.

The project uses AI assistance, and the authors seek correction, failed cases, references and proof criticism rather than endorsement. Nothing here represents a claim to academic priority.
