# CU-REGISTRY-01 — Canonical index of research claims (11 October 2026)

**Draft / reconciliation only.** Unique identifiers below distinguish different theorem-and-experiment contracts. Historical STROBO and MOD-OBS filenames remain unchanged; this index does not reclassify their scientific status or assert priority.

| Canonical ID | Precise result | Principal source | Boundary |
|---|---|---|---|
| CU-R-STROBO-001 | STROBO-C3 complete classification: ordered labelled triple-square collisions | [source](https://github.com/alexcour/couret-finite-verifications/pull/8) | Internal candidate proof and finite replay; order-six examples have prior art; full exhaustiveness/novelty unreviewed. |
| CU-R-MOD-FIX-001 | Fixed universal versus conditioned exact membership queries | [source](https://github.com/alexcour/couret-finite-verifications/pull/14) | Universal n/2-1 internal proof; <=2 after full square conditioned on STROBO. Square acquisition cost excluded. |
| CU-R-MOD-ERR-001 | Bounded adversarial lies / adaptive versus fixed questions | [source](https://github.com/alexcour/couret-finite-verifications/pull/16) | Finite four-support fibre: fixed vs adaptive 2/2, 6/5, 10/8 at 0,1,2 global lie budgets. Source errors not necessarily independent. |
| CU-R-MOD-CUB-001 | Cubic probes; connectivity property from A^2; STROBO-MOD-OBS-04 proof note | [source](https://github.com/alexcour/couret-finite-verifications/pull/15) | When n odd or 4|n, internal theorem A says labelled A^2 decides strong connectivity. New independent finite check 192654 triples on n=5..40 with/without zero; no external referee. |
| CU-R-MOD-PROB-001 | Two noisy oracles, conditional error bounds, KL cost lower bound | [source](https://github.com/alexcour/couret-finite-verifications/pull/17) | One four-support fibre; q1/q4 only, costs 2/1, nominal IID noise .1/.2. Property mean cost 4.878; lower bound on full reconstruction mean cost 6.201. These are not unconditional physical-system guarantees. |
| CU-R-OBS-SEQ-001 | OBS-SEQ-04; 22 scalar cubic/trace probes, corpus audit | [source](https://drive.google.com/file/d/1aRB22ytoflsIgOKlrSS4nQSAuvcrvbks/view) | n=18 zero INCLUDED: 816 supports, 444 square-colliding unordered pairs. Optimal fixed 22-bank cover needs 3 probes. Historic manifest checker defect unresolved. |
| CU-R-LOG-SPEC-001 | CU-LOG-SPEC-01 initial prime windows | [source](https://github.com/alexcour/couret-finite-verifications/pull/10) | Finite checks / no general prime theorem. |
| CU-R-LOG-SPEC-002 | CU-LOG-SPEC-02 four prime windows through 90M | [source](https://github.com/alexcour/couret-finite-verifications/pull/11) | Two of four windows exceed preliminary 5% projection threshold; no new prime law; covariance trace ratio not a direct linear-window prediction. |
| CU-R-BRUIT-002 | Dirichlet-zero external verification gate | [source](https://docs.google.com/document/d/1CRxb0PpyyaVdtqLh8IvCyncivC6k-ZJ-oNrJ0zcrJKE/edit) | 37 conductor-15 ordinates still need external individual/exhaustiveness checking. |

## Corrections mandatory for reviews

1. "MOD-OBS-03" is used in **different** contexts: cubic probes and connectivity in [PR #15](https://github.com/alexcour/couret-finite-verifications/pull/15), and probabilistic noisy oracles/KL in [PR #17](https://github.com/alexcour/couret-finite-verifications/pull/17). Separate [PR #13](https://github.com/alexcour/couret-finite-verifications/pull/13) has its own CU-MOD-OBS-03 finite audit and CU-MOD-OBS-04 adversarial-lie study. Never cite only the short project number.
2. At n=18, including zero means 816 supports and 444 square-colliding PAIRS; excluding zero means 680 supports, 393 square fibres and 305 colliding pairs. The 444 nonisomorphic PAIRS from an aggregate over multiple moduli are yet another population.
3. Distinguish full labelled A^2 from its parity, a cubic coefficient, cubic trace, full A^3, and a Fourier-linear measurement. Each has a different acquisition and query-cost model.
4. Mathematical proof, exact-replay scripts, SHA-256 agreement, outside mathematical expert review, and bibliographic novelty are separate gates.
5. The known order-six collision mechanism is prior art: Chen and Yan [2021, DOI:10.1017/S0004972720000945](https://doi.org/10.1017/S0004972720000945) directly cover the example {0,1,4} versus {0,2,5} in Z/6Z. Yang and Chen [2012, PDF](https://ajc.maths.uq.edu.au/pdf/53/ajc_v53_p257.pdf) study complementary representations. Neither citation, on its own, settles full STROBO triple-square exhaustiveness.
6. No conclusion of real-world AI safety or current-state freshness follows from repeated queries if persistent correlated errors or unverified state version changes remain possible.

## Independent finite referee challenge, not a claim of publication

New small independent Python audit checked the proposed **connectivity-from-labelled-square** theorem on n=5..40, with and without a zero generator: **72 cases, 192654 triple supports**. No mixed-connectivity square fibre occurs when n is odd or n is divisible by 4. At n=18 with zero allowed it finds 399 square fibres and exactly 83 whose members disagree on connectivity. At n=10, {2,4,6} and {1,7,9} share A^2 but differ on connectivity. At n=22, {1,3,13} and {2,12,14} share A^2 and each has zero cubic trace, yet differ on connectivity. The **general theorem still requires human mathematical review**.

The full independent note, source code, JSON results, SHA-256 manifest and replay log are archived on [Drive (CU-REGISTRY-01)](https://drive.google.com/drive/folders/1Ofoon5Bo94qoyKjwRPLWqzgml9P9A-_M) as an immutable ZIP. [Download the ZIP on Drive](https://drive.google.com/file/d/1WtZcc3B3_LbPn2IgIiR1FIPKTGzboSf_/view).

## Reviewer priorities

- First: attempt to refute the isolated connectivity theorem, including the mod-4 parity argument and n=10/n=22 boundary examples.
- Second: attack full STROBO-C3 classification and its ordered-representation-function novelty boundary.
- Third: clean-checkout reproductions; repair OBS-SEQ manifest verifier as versioned derivative, not silent overwrite; finish CU-BRUIT external data gate.
- Fourth: design a *new, separately pre-registered* model for query acquisition, freshness checks and source independence if those costs matter.

**Gates:** external referee OPEN; novelty NOT ESTABLISHED; no merge to main, DOI, HAL, arXiv or stable publication authorized by this index.
