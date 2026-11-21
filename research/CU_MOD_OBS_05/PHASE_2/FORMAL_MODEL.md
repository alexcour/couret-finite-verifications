# Phase 2 mathematical model and exact minimax decision problem

## Universe and square observation

For n in {18,22}, `S` is a three-element subset of `Z/nZ \ {0}`. Membership query `q_x(S) = 1[x in S]`. Initial `A_S^2` is known **correctly, without acquisition cost**. We restrict to the FULL fibers of the specified squares within the 3-element nonzero-support universe:

- n=18: `F18 = {(1,4,13), (1,7,16), (4,10,13), (7,10,16)}`; admissible queries `q_1,q_4` only.
- n=22: `F22 = {(1,3,13), (2,12,14)}`; admissible query `q_1` only.

The n=22 claim of a full fiber is checked by enumerating all `C(21,3)=1330` possible supports. It is NOT a classification of all fibers of all n. All supports in each selected fiber share the same full integer `A^2`.

## Hidden dynamic state and adversary

An underlying *world* is `(s, u, l, d)` where:

- `s`: current support index in the chosen fiber.
- `u`: total true support changes so far, `0<=u<=m`.
- `l`: total false membership responses so far, `0<=l<=e`.
- `d`: whether at least one true support change happened since the last version read (binary dirty flag).

The adversary may perform any number `k in {0,...,m-u}` of true changes **before each atomic operation**. One true change always moves from a candidate support to a different candidate support in that same fiber. All paths of exact length k are permitted; thus n=22 two changes can return to the initial support. Mutation can happen immediately before the final compare-and-act. Initial world can contain any candidate, but `u=l=d=0` immediately after the initial baseline version read.

A membership operation `q_x` returns its bit for the *current* support, optionally inverted at global cost one false reply. This budget `e` is for the whole session, not per retry. Queries can be repeated. Each query costs one abstract unit.

A **version operation** atomically compares the current monotone, nonreused version to the baseline. Its observation is 0 (same) iff no true change has happened since that baseline, 1 (changed) otherwise. A version read costs one abstract unit. After EITHER outcome the returned version becomes the new baseline; on changed, earlier transcripts are not falsely presumed simultaneous, although posterior constraints remain available through the world belief. Crucially, if output is SAME and the target is uniquely determined, the verifier immediately performs its target-specific action AT THE SAME atomic linearization point. This is a stipulated compare-and-act primitive, not implied by ordinary `read; then act` code.

The initial baseline version read costs one additional unit; the DP minimizes all later membership/version actions. A^2 acquisition costs and real-world transaction/verification costs are excluded.

## Goals

The static target function is `g(s)` and applies to the support at the instant of successful compare-and-act:

1. `reconstruction`: return the entire labelled candidate index in F18.
2. `contains_1`: return `[1 in S]` in F18.
3. `connected`: return `[gcd(22,S)=1]` in F22 (strong connectivity of the oriented Cayley digraph).

The terminal action is allowed only after a SAME version observation whose possible current supports all have the same target. There is no claim that the answer remains correct after the atomic action.

## Belief transition and exact recurrence

Given a belief `B` (set of possible worlds compatible with the complete observed transcript), action `a` and observation `o`, let `T(B,a,o)` be the union of all successor worlds allowed by the mutation and error budgets. It is computed by full finite enumeration; answers impossible under all worlds are omitted.

Define `Known_g(B)` iff all worlds in B give the same `g(s)`. For an integer budget of remaining actions d, the winning predicate is

```
Win(B,0) = False
Win(B,d) = exists action a in {queries, version}: for all nonempty replies o,
             (a == version and o == SAME and Known_g(T(B,a,o)))
             OR Win(T(B,a,o),d-1)
```

The exact optimal worst-case action count after the initial baseline is `D* = min{d: Win(B0,d)}`. The total stated cost is `1 + D*`. This is a finite minimax reachability calculation, not a statistical or asymptotic estimate. The `D*-1` infeasibility claim is replayed by a second implementation of the same stated model. Certifying the underlying monotone-version contract is a separate unproved engineering obligation.

## Logic of freshness

Within this oracle model, a SAME version outcome proves no intervening mutation since its baseline. If all membership observations used in the conclusion were collected in that unchanged epoch, and `Known_g` holds in the world belief, the atomic compare-and-act uses the valid current property. A stale version leads to a new baseline and additional questions. This does NOT imply correctness with stale caches, non-atomic state updates, version reuse (ABA), unchecked implementation bugs, or an unprotected gap between validation and action.

If the adversary has an UNBOUNDED mutation budget, it can change the state immediately before each final validation and prevent eventual acceptance. A safety guarantee alone is not a bounded termination guarantee.