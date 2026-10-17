# COU-20 — Ablation et certification des deux couleurs, groupes abéliens finis

Date: 16 Oct 2026. **RESEARCH CANDIDATE / NOT UNIVERSALLY LEAN-PROVED / NOT PEER REVIEWED.**

## Formal scope of this branch
`lean/CayleyTwoColourAbelian.lean` is a small Lean bridge importing the previously compiled `CayleyDoubletCore` and `CayleyTwoColourFamily`. It introduces `AbelianSource` and `AbelianTarget` for a given abelian group, and gives *conditional / elementary* results describing support membership, existence of the half-turn mate, and characterization of singleton and shared outgoing arcs.

**It does not yet prove:**
1. The universal ordered convolution-square identity as an unconditional Lean theorem.
2. Uniqueness of the mate for every admissible order-three quotient (the cyclic core offers related lemmas under explicit hypotheses).
3. The full iff dichotomy: non-isomorphic iff `a+<h>` generates `G/<h>`.
4. The group automorphism that fixes `a,h` and reverses `d` in the complementary case.
5. Any uniform claim about adjacency cospectrality without the additional parity condition.

No claim of novelty. The relevant prior-art review remains open in COU-18.

## Exact finite replay performed independently
A stand-alone Python 3 enumerator in the working conversation (not part of this branch yet) was run again against all admissible connected configurations in finite abelian groups of order at most 36. It reproduced:
- **12** admissible abelian group isomorphism types;
- **1,560** labelled connected parameter choices;
- **480** cases satisfying the proposed full-singleton-cycle obstruction;
- **1,080** cases with an explicitly constructed graph isomorphism.

It verified all nine ordered sums and intrinsic-mate uniqueness for each instance; the non-full-cycle case directly checks a bijection and its action on generators. No exhaustive graph-isomorphism search is claimed for all 480 obstruction instances. Finite replay is not a universal proof and does not validate originality.

## Exact theorem boundary and falsification
Let finite abelian `G`, `h` of order exactly two, `H=<h>`, `d+H` of order three, and `G=<a,d,h>`. Define
`S={a,a+d,a+d+h}`, `T={a,a-d,a-d+h}`.
The written proof proposes `1_S*1_S=1_T*1_T` and non-isomorphism of directed Cayley digraphs iff `a+H` generates `G/H`, subject to independent mathematical review. Merely asserting `G/H` cyclic is insufficient (counterexample `G=C2×C6`, `a=(0,3)`, `d=(0,2)`, `h=(1,0)`). Likewise equal adjacency squares do not imply equal spectra without additional parity (counterexample `G=C2×C9`).

The original PR #30 certificate remains at SHA `ff3d9db23f4e79fecded496f4bfea0b96fe0c5e9` and covers its **cyclic** directed non-isomorphism theorem; this candidate branch does not replace or enlarge that certificate.

## Gates
- [ ] The isolated `cou20-abelian-lean-candidate` workflow must pass for this branch at its exact SHA.
- [ ] Independently audit the finite replay and mathematical iff argument.
- [ ] Add generic, hole-free Lean proofs for the missing claims; keep each statement's proof dependencies visible using `#print axioms`.
- [ ] Compare with CI/CCA and graph-covering prior art.
- [ ] External human review and release decision required.

**NO MERGE / NO PUBLICATION / NO PRIORITY CLAIM**. Related issues: COU-20 (formalization), COU-18 (Gate C), COU-8 (Cayley).
