# CU-BRUIT-02: conditional sign-density exploration (not certified)

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


## Refined analytic K bounds — 13 Oct 2026 (experimental, source branch)

[New exact double-Abel instrument](certify_refined_K_20261013.py) uses the
periodic character's first and second partial sums for the tails of
L(1,chi) and L'(1,chi), plus elementary convexity bounds on Euler's
constant. It **preserves** the original pinned analytic-K receipt and,
for each of the five K constants, computes an enclosure strictly
contained in the existing one with >100x smaller width. The dedicated
[CI workflow 38388561716](https://github.com/alexcour/couret-finite-verifications/actions/runs/38388561716)
executed this new checker and its input-sha safeguards successfully.
**No tightened Q5 probability interval is claimed yet.** The new
intervals have not been substituted into the full-tail replacement bound
or into Q5 Fourier inversion. The script relies on the old dyadic
interval/log arithmetic; it is not a backend-independent review.
GRH/LI, the true prime density, human review and priority remain open.
[Drive research note](https://docs.google.com/document/d/1FKwUK02YAK4pRgGCAuTKQ0pmUn0HdhQUdQNhrsaShQs/edit)
records the model interval and continuation. The PR stays draft.

## Q5 conditional sign probability — 13 Oct 2026 (internal interval replay)

[Full rational Fourier/Simpson argument and error budget](Q5_CONDITIONAL_PROBABILITY_20261013.md),
[deterministic verifier](certify_q5_probability.py) and
[fail-closed tests](test_certify_q5_probability.py) now enclose the probability
of the **specified GRH/independent-uniform-phase Q5 model** in
**[0.286450, 0.292650]**, conditional on the earlier 67-root, five-K and
full-tail certificates and on successful replay. The Gaussian-replaced sign
probability is bounded at both endpoints of W in [0.747557,0.842503].
A rigorous derivative enclosure proves positivity throughout that interval,
allowing endpoint monotonicity. All Fourier evaluations, Simpson remainders,
integral tails, parameter intervals and rounding errors are accounted for.
The separate full-tail replacement error <=0.001714 is included exactly once.
The result remains an **internal conditional probability enclosure**, not an
unconditional logarithmic prime density, global GRH/LI proof, independent
Arb implementation, external peer review or originality assertion.
PR #27 remains a DRAFT, without merge or publication.

## Full zero and tail continuation — 13 Oct 2026

[Full proof and commands](ALL_TAIL_BOUNDS_20261013.md): the thirty q3/q5 candidates now have internal Arb isolations and finite counts 6/8/8/8. Together with the unchanged q15 certificate, all **67** positive roots below 25 are isolated as simple critical-line roots and matched by completed-L contour counts, under the trusted backend and written argument. The q3/q5 recalculation at 320 bits agrees with the 256-bit intervals/signs/counts. [New root instrument](certify_q3_q5_root_intervals.py), [receipt](q3_q5_root_interval_certificate_20261013.json), [controls](test_q3_q5_root_intervals.py). Old decimals are search seeds; Newton iterates are not proofs.

The [full-tail exact checker](verify_all_tail_bounds.py) and [receipt](all_tail_bounds_20261013.json) enclose five positive Hadamard residuals without GRH. Under GRH and independent uniform phases, replacing **all** seven-character phases above ordinate 25 with a matched-variance Gaussian changes any threshold probability by at most **0.001714 (Q5), 0.001998 (Q3), 0.000915 (Q15), 0.000933 (C5), 0.000556 (C15)**. These are exact rational witness bounds using a global Bessel envelope and no numerical quadrature. They apply to all thirteen bias/profile categories in that model. The Q5 tail variance lower bound is >29/40.

The dedicated `zero-intervals-and-tail-bounds` workflow replays all root and K prerequisites before aggregation. At the earlier full-tail stage, Gaussian probability evaluation was still open; the subsequent Q5-specific rational inversion is documented above. The historical 0.2894389 was exploratory and is not itself a certified point value. Global GRH/LI, identification with the actual prime race, independent human review and originality remain open. Earlier dated q3/q5-pending statements below describe their former scope, now superseded by this finite continuation. PR #27 remains a research draft.

**Current integration:** PR #4 merged into main on 12 Oct 2026, commit 3b6d6e75; its post-merge CI passed. Earlier DRAFT/branch-only annotations below are historical, as explained by [the integration decision](INTEGRATION_DECISION_20261012.md). Analytic and independent-review gates remain open.

## Independent-phase law classification — continuation 12 Oct 2026

[Autonomous model theorem and full proof](PHASE_LAW_CLASSIFICATION_20261012.md): for square-summable independent circular amplitudes, the law determines exactly its mean and its multiset of nonzero amplitudes. Equal finite (bias,labelled profile) gives equal laws in a fixed independent-phase model; thirteen categories give at most thirteen laws. Five distinct signed variance constants suffice to separate all thirteen. Their [analytic enclosures are now certified](CERTIFIED_SPECTRAL_CONSTANTS_20261012.md): under GRH and the declared independent-phase spectral model, the thirteen laws are distinct. The proof includes a qualitative sign rule, exact failures of variance-only reconstruction and correlated-phase invariance, and a synthetic model in which the thirteen categories collapse to five laws.

[Exact rational checks](verify_phase_law_identities.py) verify Bessel logarithm coefficients through order 32, independent moments, finite Newton reconstruction and signed-conjugate variance aggregation; compare all 56 existing census rows with `--check`. [Local receipt](phase_law_identities_20261012.json). No zero data, GRH/LI, actual prime limiting law or sign-density value is certified. This continuation is proposed in a new research PR.

The [integer dyadic certificate](spectral_constants_certificate_20261012.json) uses period-sum bounds at N=15000 and explicit log/arctan/harmonic remainders, with no floating-point or zero catalogue. Run `certify_spectral_constants.py --check`. It proves five analytic constants Kχ are pairwise distinct. The classical completed-L Hadamard identity and Kχ<4 also exclude real nontrivial zeros, including central zeros, for these seven characters without GRH; no nonreal ordinate or zero completeness is certified. Under GRH, Kχ equals the signed zero-sum Bχ. Remaining analytic/independent-review gates are not promoted as a whole.

Drive worklog: https://docs.google.com/document/d/1gzH_yp1lUV_BZP4l6ErginfNVKYyEzNBM8I_wiWGBPY/edit

## q15 zero certificate and tail comparison — continuation 12 Oct 2026

[Written tail proof](Q15_TAIL_BOUNDS_20261012.md) combines the analytic K intervals with the [finite q15 certificate from PR #28](https://github.com/alexcour/couret-finite-verifications/pull/28), pinned at `04fbd2f56de679bb1b8d5c7dc56354b20d3c9ccd`. Its unmodified root verifier, receipt and controls are included here for replay. The 37 simple roots and 12/13/12 positive counts up to 25 are certified internally with Arb, subject to the stated trust base and independent review. PR #28 separately records 37/37 external approximate decimal matches; these do not certify the third-party decimals. Earlier 0/37 statements below are dated observations or an empty-input rejection test.

Without GRH, the positive Hadamard residuals beyond |Im(s)|=25 lie in [0.062912,0.067673] for the quartic pair and [0.061899,0.067092] for the real character. Under GRH and independent phases, replacing only the q15 tail by a matched-variance Gaussian changes any threshold probability by at most **0.000589** for Q5/Q3/C5, **0.001524** for Q15 and **0.000880** for C15. The proof uses Taylor replacement, a global Bessel envelope and exact integrals, with no numerical quadrature. [Rational checker](verify_q15_tail_bounds.py), [receipt](q15_tail_bounds_20261012.json) and [ten controls](test_q15_tail_bounds.py).

These are partial replacement-error bounds, not an error bar on the old full Gaussian-tail density estimate. The q3/q5 root isolation/counts, their Gaussian replacement, numerical density evaluation, global GRH/LI and identification with a prime race remain open. CI separately replays the q15 interval certificate before checking the tail aggregation. No human review, originality or merge is claimed for this research continuation.

**Scope**: frozen CU-BRUIT-01 weights `S={1,11,29}`, `D=5A-3B`, `E_D=(log x/sqrt x)D`; no modification of the first-run protocol or prime counts.

## Finite structural classification — 12 Oct 2026

[Written proof of the five labelled profiles and thirteen bias/profile categories](STRUCTURAL_TRIPLET_CLASSIFICATION_20261012.md): the quotient G/G² ≃ F2² separates 24 quadratic-coset triples from 32 transversals. Profile sizes are 8,8,8,16,16; the joint-count table and 28 partner pairs are proved, along with seven translation orbits and the role of inversion. The [independent exact checker](verify_triplet_structure.py) agrees with all 56 committed CSV rows and tests false stronger generalizations. Run it with `--check`.

This finite proof does not establish distinctness of thirteen prime limiting laws, certify zeros or promote analytic gates. It awaits independent human review; no Lean formalization or novelty claim. PR #4 remains DRAFT.

An additional [integer/autocorrelation cross-check](verify_triplet_structure_crosscheck.py) agrees with every field of all 56 CSV rows, tests the C5/C15 bias-preserving automorphism, fixed subsets under 19, and 560 finite 30→15 reduction cases. See [proof section 8](STRUCTURAL_TRIPLET_CLASSIFICATION_20261012.md) and [local output](triplet_structure_crosscheck_20261012.json). CI [38249227759](https://github.com/alexcour/couret-finite-verifications/actions/runs/38249227759) passed for the prior structural-proof commit 07b7a22; the complementary checker requires its own run. Local checks are algorithmically separate, not an external review.

- Under GRH and suitable LI, standard Rubinstein–Sarnak limiting law has mean **-1**, variance **3.203007082327546** and Bessel-product characteristic function
  `exp(-i t)*prod_{chi != chi0,gamma>0} J0(2*abs(c_chi)*t/sqrt(.25+gamma^2))`.
- Numerical fraction of variance attributable to quadratic chi5: **0.4399030503937205**. It is *not* a sign density.
- With low critical-line zeros from a Hardy-function sign-change scan and a matched-variance Gaussian approximation for the omitted zero tail: sign density P(X>0) approximately **0.2893985** at T=15 (31 detected roots) and **0.2894389** at T=25 (67 detected roots).
- The 67 roots at T=25 were reproduced with a denser grid (step .2 vs .4), maximum coordinate disagreement below 5e-9; **this is not a complete-zero certificate**.
- Indicative difference envelope from the *modeled* Gaussian tail to the true Bessel tail at T=25 ≈ 6.7e-5 **assuming** completeness of zeros below T, appropriate GRH/LI and numerical quadrature. Do not present as rigorous error bar.
- Finite occupancy in the frozen first prime run to 1e9: +0.20764, -0.70628, zero 0.08608. This is not an asymptotic density or an independent pointwise sample.

## Replay

An independent setup needs `numpy`, `scipy`, `mpmath`; version references from local run: SciPy 1.17.0, mpmath 1.3.0, SymPy 1.14.0 (original audit). Keep exploratory dependencies separate from the existing release `requirements.txt`.

```bash
python research/audits/liouville_grothendieck_20261008/rs_density_exploratory.py --T 15 --step 0.5 --dps 18 --out rs_t15.json
python research/audits/liouville_grothendieck_20261008/rs_density_exploratory.py --T 25 --step 0.4 --dps 18 --out rs_t25.json
python research/audits/liouville_grothendieck_20261008/rs_density_tail_envelope.py --catalog rs_t25.json
```

GitHub scripts were transcribed and saved for external replay; no GitHub CI PASS is represented by their creation. Historic local replay SHA256: rs_density.py bc0aa88613b699d71aa2e7bdc93bf9fe82a1e2875b48608907ec340593b5eaf1; rs_density_T25.json 9d860f46796cd1c08d04fa66eb5387e885e0a93dfe9044037c3fa38c3ea8f0c3. Those hashes are for local work products, not necessarily byte-identical to the transcribed GitHub script.

## Gates

1. independently certify zero completeness below cutoff (including multiple zeros), as well as error-controlled quadrature and tail bound;
2. audit complex-character multiplicities and sign conventions in limiting law;
3. compare the pathwise finite occupancy with a properly correlated modeled process, not a naive binomial test;
4. independent review + bibliography before any promotion, merge or release.

**N=ANTERIEUR for the general mechanism. D=STAGING. PR remains DRAFT.**


## Update 10 Oct 2026 — Gate A3 (still unresolved) and Gate B1 (independent replay)

- [Detailed source search and 37-row signed-ordinate audit](GATE_A3_PRIMARY_SOURCES_20261010.md). Bennett–Martin–O'Bryant–Rechnitzer (2021) provide a published rigorous-zero result covering q=15 and T=25, but their signed-zero data archive has **not been downloaded/compared** here. A targeted request was sent to a coauthor; awaiting any archive response. Counts **30/67 prior externally matched decimals, 37/67 q15 still local**.
- [Fail-closed q15 comparison script](gate_q15_external_compare_20261010.py): requires explicit independent source provenance, archived original-file SHA256, Conrey labels, coverage claim and bounded decimal error. Refuses missing source and incomplete data. Even full decimal compatibility is NOT mathematical certification; explicit review of source proof/coverage remains mandatory.
- [Gate B1 independent mathematical control](GATE_B1_INDEPENDENT_REVIEW_20261010.md) and [B1 replay script](gate_b1_independent_check_20261010.py): finite exact U(30) Fourier coefficients + square-bias yield mu=-1 and Parseval=960. An independent symmetric numerical difference for L'(1)/L(1) reproduces the older variance to ~9e-9 but is NOT interval arithmetic. The seven-character sign-density formula, signed zero multiplicities and complete Gaussian-tail error still need independent review.
- No numerical CI run of the new scripts has been confirmed. A local analogous replay and synthetic comparator tests passed. Stable main unchanged; PR #4 intentionally **DRAFT**; no theorem of density/GRH, no priority claim, no release.
