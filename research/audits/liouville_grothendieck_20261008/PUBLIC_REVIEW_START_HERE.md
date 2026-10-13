# Open review / Relecture publique — Couret–Unification (9 October 2026)

## Quantitative convergence audit — 13 Oct 2026

[Quantitative specialization and proof boundaries](WASSERSTEIN_SPECIALIZATION_20261013.md),
[stdlib verifier](verify_quantitative_specialization_20261013.py),
[exact receipt](quantitative_specialization_20261013.json) and
[eleven adversarial controls](test_quantitative_specialization_20261013.py)
add **H<0.553** for the independent-phase Q5 density and a finite certificate
**Delta(4,64)>0.011839**, covering all **16,640** modes of the two-frequency
height-4 truncation. They also establish why the existing width-2e-30
root boxes cannot certify every mode for **Delta(25,67)** by direct
interval propagation: a centre combination must have magnitude <1.88e-118.
The hypotheses and constants of Bailleul–Hayani–Untrau 5.13/5.17 are
specialized explicitly. **No finite-horizon arithmetic error is certified**;
GRH/LI/ELI remain hypotheses. The original Q5 probability interval and
pinned inputs are preserved. New arithmetic checks are added to both
workflows; execution status must be read from the corresponding CI runs.


**Current integration decision — 12 October 2026:** the maintainer authorized merging PR #4 into main. See [integration status and remaining scientific gates](INTEGRATION_DECISION_20261012.md). Earlier draft/unmerged/no-merge annotations below are historical workflow status; external mathematical review, originality and analytic certification remain outstanding.

**Your disagreement is welcome.** This is a public *research record*, not a refereed paper, proof of the Riemann hypothesis, or a claim of mathematical priority.

**GitHub is the complete public entry point for this review packet.** Some linked Google Drive originals are still private and may return "Access denied". All essential claims, equations, data snapshots, limitations and runnable source files used in this specific audit have GitHub equivalents. If an essential dependency is missing, please report it: absence is a reproducibility failure.

## Five-minute review / Lecture rapide

1. Read [claims and falsification register](CLAIMS_AND_FAILURES.md), with what was disproved, what is classical and what remains undecided.
2. Inspect the [frozen experiment and precise equations](FROZEN_METHOD_AND_DENSITY.md).
3. Browse the [recorded low-zero catalogue](lmfdb_zero_comparison_20261009.json), [q15 certificate](q15_root_interval_certificate_20261012.json) and [new q3/q5 certificate](q3_q5_root_interval_certificate_20261013.json). **13 Oct update:** all 67 roots are internally isolated and matched by finite counts up to 25; [PR #28](https://github.com/alexcour/couret-finite-verifications/pull/28) separately records 37/37 external q15 decimal matches. Third-party decimal agreement and internal interval certificates are distinct evidence layers.
4. Audit the source: [exact checks](REVIEW_SELF_CHECK.py), [spectral calculation](verify.py), [initial zero scan](rs_density_exploratory.py), [numerical argument-principle cross-check](winding_zero_count.py), [q=5 published comparison](verify_lmfdb_q5.py), [q=3 decimal consistency](verify_published_zero_matches.py), [q=15 high-precision root replay](verify_q15_catalog_20261009.py), [truncation envelope](rs_density_tail_envelope.py) and [quasi-Monte Carlo numerical comparison](qmc_density_replay_20261009.py).
5. Please challenge the **four open gates** in [open review questions](OPEN_REVIEW_QUESTIONS.md).

## Scientific boundary

**13 Oct Q5 probability inversion — internal conditional bound:** The
[Q5 rational Fourier/Simpson proof](Q5_CONDITIONAL_PROBABILITY_20261013.md),
[standalone fraction-only checker](certify_q5_probability.py) and
[seven fail-closed controls](test_certify_q5_probability.py) bound the
sign probability of the specified GRH/independent-phase Q5 model by
**[0.286450, 0.292650]**, conditional on the pinned 67-root, analytic-K
and full-tail certificates and their written arguments. The whole
interval of Gaussian-tail variance is covered through a rigorously
positive probability derivative; numerical Fourier nodes, Simpson error,
integral truncation and root enclosures are explicitly bounded.
[Dedicated replay](https://github.com/alexcour/couret-finite-verifications/actions/runs/38355681524)
and [general checks](https://github.com/alexcour/couret-finite-verifications/actions/runs/38355681498)
passed at `456ff042`. This is **not an unconditional prime-race
density, a global GRH/LI verification, an independent root computation,
or external mathematical review**. The former wording that inversion
remained outstanding described the preceding dated stage.

**13 Oct full 67-root and tail continuation:** [proof](ALL_TAIL_BOUNDS_20261013.md), [q3/q5 root instrument](certify_q3_q5_root_intervals.py) and [receipt](q3_q5_root_interval_certificate_20261013.json) add the remaining thirty isolations and counts, including a 320-bit check. Together with the preserved q15 instrument there are 67 simple roots and matching counts within the finite region up to 25. Under GRH and independent uniform phases, [full-tail aggregation](verify_all_tail_bounds.py) bounds any threshold-probability change from replacing all high phases by a Gaussian by <0.002 for all five profiles, hence all thirteen categories. These trusted-backend computations are not global GRH, independent peer review or a numerical prime-density certificate. The Gaussian-replaced probability still needs interval quadrature.

**12 Oct q15 tail comparison:** [autonomous tail proof](Q15_TAIL_BOUNDS_20261012.md) derives strictly positive Hadamard residuals without GRH from the pinned q15 finite certificate and analytic K bounds. Under GRH and independent uniform phases, a rigorously bounded Gaussian replacement of only the q15 tail changes every threshold probability by at most 0.000589 (Q5/Q3/C5), 0.001524 (Q15) or 0.000880 (C15). No numerical quadrature is used. The [exact aggregation checker](verify_q15_tail_bounds.py) consumes receipts; the separate `q15-root-intervals` workflow reexecutes their Arb and analytic prerequisites. This does not certify a prime-race density or the q3/q5 Gaussian replacements. Independent mathematical review remains open.

**12 Oct model continuation:** [independent-phase law classification](PHASE_LAW_CLASSIFICATION_20261012.md) separates finite support invariants from a defined stochastic model and its conditional prime-race interpretation. It proves a complete amplitude-multiset criterion for model-law equality, derives five signed variance formulas and a sufficient criterion for thirteen distinct model laws, and gives exact counterexamples. [Rational replay](verify_phase_law_identities.py) checks finite identities only. No actual zero list, prime law, originality or numerical sign-density certification is added.

**12 Oct rigorous constants:** [analytic enclosure proof](CERTIFIED_SPECTRAL_CONSTANTS_20261012.md), [integer outward-rounding instrument](certify_spectral_constants.py) and [deterministic certificate](spectral_constants_certificate_20261012.json) separate the five Kχ constants unconditionally. Under GRH and the specified independent-phase zero model this verifies thirteen distinct laws. The classical positive completed-L zero sum plus Kχ<4 excludes real nontrivial zeros for these characters without GRH. This does not certify the 37 q15 ordinate candidates, completeness, GRH/LI or any numerical sign density.

**12 Oct finite classification:** [autonomous proof of 56/5/13/28](STRUCTURAL_TRIPLET_CLASSIFICATION_20261012.md), with the complete bias/profile table and negative examples. The proof uses G/G² ≅ C2², character cancellation, Parseval and group actions. [Structural exact replay](verify_triplet_structure.py) agrees with the original [56-row fixture](census_56.csv); [complementary integer/autocorrelation check](verify_triplet_structure_crosscheck.py) and [local output](triplet_structure_crosscheck_20261012.json). External peer review is not claimed. Five amplitude profiles are also five orbits under translations and inversion, whereas translations alone give seven orbits. Thirteen finite invariant classes are not thirteen independently established prime-race laws.

- **Exact elementary facts:** U(30) ≅ C2×C4; G²={1,19}; G[2]={1,11,19,29}; Fourier amplitudes 24 and 8; Parseval 960; frozen D(x)=5A(x)−3B(x).
- **Finite data:** prior RUN-01 to 10^9 reports A=19,067,732; B=31,779,799; D=−737; finite positive log-occupation ≈0.20764. The 10^9 sieve/first-run zip is referred to in the frozen Drive protocol and is **NOT included in this GitHub packet**, therefore these values are quoted from prior work, not independently rerun by this packet.
- **Conditional classical model:** under GRH and suitable linear independence of Dirichlet zero ordinates, the relevant Rubinstein–Sarnak law has modeled mean −1 and variance ≈3.20300708.
- **Exploratory numerical estimates:** χ5 accounts for ≈43.9903% of modeled variance, not a probability of winning. Numerical P(X>0)≈0.2894 after truncating at positive ordinate T=25 and replacing higher zeros with an independent Gaussian matching the residual variance. Not rigorously certified.
- **Zero evidence, 13 Oct update:** internal isolations and counts now cover all 67 positive roots up to 25 (8,8,8,6,12,13,12), with finite-region and trusted-backend scope. Earlier external decimal comparisons are separate from these certificates. No global GRH/LI or independent human review follows.
- **Originality:** no priority claim; general Galois/Dirichlet and Rubinstein–Sarnak mechanism is classical. Whether any atomically stated new subresult is original has not been established.

## Reproduction without Google Drive

Requires Python 3.12, SymPy 1.14, mpmath 1.3, SciPy 1.17 and NumPy 2.x for the respective scripts. From repository root, start with a no-dependency check:

```bash
python research/audits/liouville_grothendieck_20261008/REVIEW_SELF_CHECK.py
python research/audits/liouville_grothendieck_20261008/verify_triplet_census.py --check
python research/audits/liouville_grothendieck_20261008/verify_triplet_structure.py --check
python research/audits/liouville_grothendieck_20261008/verify_triplet_structure_crosscheck.py --check
```

Then optionally install into a virtual environment (not the stable release environment):

```bash
python -m venv .venv-review
. .venv-review/bin/activate
python -m pip install 'sympy==1.14.0' 'mpmath==1.3.0' 'scipy==1.17.0' 'numpy>=2,<3'
python research/audits/liouville_grothendieck_20261008/verify.py
python research/audits/liouville_grothendieck_20261008/verify_published_zero_matches.py
python research/audits/liouville_grothendieck_20261008/verify_q15_catalog_20261009.py
```

The longer zero-scan and simulated-density scripts are exploratory, not release-gating; may require substantial compute. Some historic outputs are not byte-identical to transcribed GitHub scripts, as disclosed in [CU_BRUIT_02_README.md](CU_BRUIT_02_README.md). The existing repository-wide CI is for the **public v1.0.0 finite release**; it does not run the spectrum programs above. A green CI badge cannot be cited as a certification of this packet.

## How to criticize

Open a GitHub issue or comment on [research PR #4](https://github.com/alexcour/couret-finite-verifications/pull/4). An ideal counterexample names the exact file/path/line, claim and convention, provides inputs, outputs, and the smallest reproducer. Positive comments and negative tests are treated symmetrically. Corrections will be preserved with the original error and dated replacement, not silently edited away.

**Do not infer that submitting, starring, commenting, or a Zenodo DOI means endorsement or peer review.** The reviewed research branch is publicly readable and the PR remains DRAFT; publication of a stable release is on hold.
