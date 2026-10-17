# Referee falsification checklist

## Exact invariant

Prove equality of labelled adjacency squares is identical to equality of ordered representation functions including diagonal on all group elements. Be alert to reflection of generators not necessarily implying directed Cayley graph isomorphism.

## Algebraic tests

1. Is the mod-2 parity argument valid for H of arbitrary 2-rank?
2. Can the type-II and type-III cases ever collide despite identical mod-2 occupancy? Check separation via two distinct H-cosets in the positive four-term remainder.
3. Does type-I offdiagonal multiset equality force a global H-translation without silently dividing by 2?
4. Does type-III give a 2-dimensional F2-subspace and precisely one H-translation orbit?
5. Is the type-II four-term rectangle always exactly four *distinct* points in two distinct H-cosets? Verify that its internal u is intrinsic even with elements of order four or eight.
6. Do direct and crossed matchings of the two cosets exhaust all possibilities? Is the condition `3(b-a) in {0,u}` both necessary and sufficient?
7. Do the reflected H-orbits remain distinct? Can any non-H translation preserve the unique singleton coset and exchange double cosets?

## Counting

Check injectivity of indexing `(B, L, u)` modulo generator orientation; `m*(h-1)*r3` exceptional square fibres, cross-orbit count h², truncation 3 singleton cases of losses `2h-1`, `2h`, `2h`. Verify the small `h=2` corner where one orbit disappears on excluding zero.

## Other gates

Independent human mathematical proof review, fresh checkout and independent code audit, primary theorem-level literature comparison, Lean4 proof with pinned mathlib, all remain OPEN. An appreciative reply from a researcher is not formal validation.