# Scientific dependency boundaries — 14 October 2026

Documentation-only research audit. This document is not a mathematical proof, a novelty claim, or release authorization.

## Distinguish five edge types

- Mathematical implication: a target theorem truly requires a stated lemma or hypothesis.
- Finite counterexample: a reproducible witness refutes an over-strong inference, not necessarily the narrower theorem.
- Proof obligation: a computation or Lean lemma still missing from a proposed extension.
- Independent validation gate: external mathematical or prior-art audit distinct from internal CI.
- Publication gate: separate decisions about authorship, rights, frozen artifact and release.
- Workflow ordering: convenient order of work, not a mathematical implication.

## Audited examples

F-006: U(30) is isomorphic to C2 x C4, not C2 cubed. This correction does not negate all MOD30 finite computations.
F-008 and F-009 reject historical Frobenius-trace / novelty interpretations of an elementary class-density ratio; preserve distinct finite claims.
Gate B: Python exact replay and the scoped Lean compilation are closed (PR #2); do not call the exhaustive Python partition comparison a Lean theorem.
STROBO PR #25: at inspection the newest HEAD 345481de87a43df5ccf0cae10ffd8e44b932e944 had verify SUCCESS while Lean remained in progress. Earlier SHA 46f3f6b6e10ade58d2d2fb043cce148d4f99cdb1 had both checks successful. Do not promote the newer HEAD until its Lean CI succeeds.
STROBO zero-free histogram: ordinary contributions and coincident-size aggregation remain open. In Z/12Z the ordinary fibre of {1,2,3} has full/restricted sizes 2/2; the exceptional fibre of {4,6,10} has full/restricted sizes 4/2. Restricted size 2 occurs in both and cannot classify by itself.
Cayley: internal theorem correctness, independent review, primary-source antecedence, and release Gate Z are separate. PR #9 is documentary maintenance; Gate Z remains HOLD.
CRT: exact local tests do not imply global integrality. Q5: matching decimals do not replace certified original intervals.

## Operational controls

Preserve stable ACT, RES and F identifiers and superseded evidence. Do not create cross-branch logical edges on thematic similarity alone.
Keep status E (proof), N (novelty), Q (reproducibility/CI), and publication gates independent.
Private Notion graph is a pilot index; Drive is the canonical documentation store and GitHub stores versioned code and public-safe audit notes.
Never publish private correspondence, embargoed FCI/CONT materials, or other sensitive research details without authorization.
Current publication state: no merge, stable release, DOI or public novelty promotion authorized.

Canonical pilot: https://docs.google.com/spreadsheets/d/1Ix4BTo9Am_4IpDfTWmnTxiVPtd5rrxgHq50Vauu_MHE/edit
STROBO draft: https://github.com/alexcour/couret-finite-verifications/pull/25