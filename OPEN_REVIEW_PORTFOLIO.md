# Independent review wanted — Couret finite research portfolio

**Status: open call for criticism, counterexamples, prior art and replication.**  
**Updated: 9 October 2026.**  
Author: Alexandre Couret (independent researcher, France).

> **FR — Objet de cette page :** solliciter des objections vérifiables, y compris des contre-exemples et des antériorités qui invalident les revendications. Aucun résultat ci-dessous n'est présenté comme une découverte reconnue. La critique négative et les corrections publiques sont recherchées.

This page is a **review-routing index**, not a new release of the [v1.0.0 finite-verifications archive](README.md). It deliberately separates already public material from *prospective* review packages. No repository, CI pass or DOI is evidence of independent mathematical peer review or novelty. The absence of a prior-art hit is not evidence of priority.

## Four narrowly scoped mathematical objects

| Work | Precise review target | Public evidence at this point | Unresolved gate |
| --- | --- | --- | --- |
| **Cayley support translation (10A6 / 10C3 / 10B1)** | Check the proposed classification of cospectral supports `T={(κ,0),(κ,c),(κ',0)}` and `T+=T+(0,c)` on `H×C_p`, and cyclic spectral injectivity. Find proof gaps, counterexamples or earlier equivalent theorems. | [Public manuscript/proofs/code](https://github.com/alexcour/cayley-prime-translation-cospectrality) · [specific public review invitation](https://github.com/alexcour/cayley-prime-translation-cospectrality/issues/7) · [known prior art](https://github.com/alexcour/cayley-prime-translation-cospectrality/blob/main/PRIOR_ART.md). The reported CI scan covers 13,019 *finite configurations*, with no discrepancies in the cited run. | Independent proof review; detailed primary-source comparison with Meng (1998). Brown/Mönius overlap with subfamilies. |
| **Barning–Hall finite spectral certificates (17 / 330 / 2310)** | Independently reconstruct a precisely defined compressed operator and check rational/integer Rayleigh threshold witnesses, including positive and negative witnesses at 2310; test whether these finite instances are already in the literature. | **Not yet a verified standalone public review package.** The internal dossier records exact witnesses and separately implemented checkers. Do not infer availability of witness files from this index. | Assemble code/witnesses into a clean public package, repair release metadata and checksums, rerun CI, and check operator-specific prior art. No general Ramanujan, property-(τ), or Hecke claim. |
| **C4×C2 ≅ U(30) three-subset classification (56 cases)** | Independently enumerate all 56 three-element supports and their complex unlabelled spectra; check the reported ten spectral classes, the 24/32 power-spectrum partition and the five-element spectral fibre of `{1,11,29}`. Determine if these instance tables are known or immediate from classical results. | **Source tables / full independent public reproducer not yet linked or confirmed here.** These are finite internal computations, not a new general theory of Cayley graphs. | Publish frozen input convention, exact enumeration script, full table, and comparison with prior work; verify group-versus-graph-isomorphism distinctions. |
| **SPEC-OBS-08 — directed Cayley graph motifs** | Check the reported finite corpus of 1,068 connected loopless three-generator Cayley digraphs on specified small nonabelian groups; in particular reproduce the pair with identical spectral/walk/three-vertex motif invariants but 30 vs 33 independent four-vertex subsets. | **Public code/branch not yet verified**: the branch identifier recorded in the internal report was not resolvable on GitHub during the 9 October check. The findings remain unreviewed internal computational reports. | Recover the actual script, canonical group/support indexing and frozen results; reproduce independently with graph-isomorphism checking before claiming public reproducibility or depositing a DOI. |

### Review checklist (every item)

1. **Definitions:** Is the mathematical object exactly stated, including operator, graph orientation, supports, multiplicities and finite search domain?
2. **Correctness:** Can you reproduce the explicit witness? If a general proof is asserted, which step fails or succeeds?
3. **Prior art:** Provide author, exact theorem/page, hypotheses and the implication (same example / overlapping subcase / complete antecedent).
4. **Computational provenance:** Give repository, commit SHA, command, environment, expected outputs and any mismatch.
5. **Scientific value:** Even if correct and not previously recorded verbatim, is the claim nontrivial, informative, or a useful benchmark?
6. **Correction:** A refutation, narrowed claim, withdrawn statement or negative replication should be linked publicly and preserved in a dated changelog.

**Reviewers do not need to confirm the work.** A detailed counterexample or exact earlier reference is an excellent outcome. Positive comments should specify precisely which steps were checked, never imply a global review by implication.

## Additional, separate publication channels

- **Already public:** [HOL-01 finite p=7 certificate](https://github.com/alexcour/hol01-monodromy-p7), [v1.0.0 finite verifications](README.md), and the [human–AI claim-state dataset](https://github.com/alexcour/qui-repond-mathematiques-ia). These should not be reissued under new DOIs merely because documentation or CI later changed.
- **Prospective software publication:** CONT-USAGE (stateful-system diagnostic and replay) and a claim-register/linter. Require installable public code, licensing, tests, a non-trivial external use case and comparisons with available tools before software-journal submission.
- **Excluded from this public index:** FCI patent-sensitive technical claims, unpublished private source material, and any claim of a solution to RH or a unified theory.

## Recommended response format

Please open a [GitHub issue in this repository](https://github.com/alexcour/couret-finite-verifications/issues/new) for the review-portfolio items, or [reply to the existing Cayley review issue](https://github.com/alexcour/cayley-prime-translation-cospectrality/issues/7).

Suggested title: `[REVIEW] <work> — proof / prior art / reproduction / counterexample`.

Please include the **exact claim**, source/commit, your reasoning or computation, and whether it **refutes, narrows, reproduces or potentially confirms** that limited claim. If evidence is not yet public, requesting the missing source is a valid review issue. Any possible external reviewer's identity and scope must be recorded only after they actually respond.

## Publication/archiving boundary

GitHub public-review material is preliminary and may change. A Zenodo archive should correspond to a **fixed, traceable set of source files**, with accurate license, citation metadata, checksum manifest and scope label such as *unreviewed computational note / invitation to independent verification*. A new DOI is not a certification. Do not archive incomplete or inaccessible review packages as if independently reproduced. Preserve existing published versions.

**Goal:** make it easy for an outsider to falsify, reproduce, identify antecedents or assess usefulness — *not* to count publications or solicit praise.
