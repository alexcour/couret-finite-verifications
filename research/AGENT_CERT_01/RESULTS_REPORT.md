# AGENT-CERT-01 — Prospective synthetic certification-value benchmark

**Date:** 2026-10-09. **Status:** R-RECHERCHE, E-EXACT-FINI for scripted counts in the finite synthetic corpus, Q-REEXECUTED (same implementation, separate clean replay; NOT independent code), N-NON-AUDITEE for the designed benchmark, D-PRIVE/RESEARCH, L-WORKING. No claim about OpenAI internals, actual language models, FCI transfer, or physical compute savings.

## Frozen design and provenance

The exact protocol and producer script were uploaded to Drive and committed to GitHub **before holdout execution**. The generator, costs, calibration, policies, seeds, and dataset split were not changed after the first run. This is a prospective *internal* design, not a public preregistration. The deterministic SHA-256 generator is a reproducibility mechanism, not a cryptographic or statistical independence proof.

3,072? NO. This experiment has 3 panels x 2,048 tasks = **6,144 distinct held-out tasks**, each scored under 4 policies and 4 per-task budget allowances: **98,304 policy-task evaluations**. Calibration uses 4,096 distinct STABLE tasks. Each evaluation begins with 3 simulated binary votes. NO_EXTRA, UNIFORM (four more votes), UNCERTAINTY (more votes only for margin=1), and CERT_VALUE (compare marginal value of no action, extra sample, and paid exact certificate) face the same aggregate extra-compute cap b per task across b=0,2,4,6. The balance may carry over between successive queries. An exact certificate costs 6 units and directly evaluates the synthetic truth; the alternatives do not have access to this oracle. Base cost=3, four extra votes=4, penalty per wrong answer=30, total J=3N+extra+30*wrong. Units are abstract, not tokens or time.

Calibration risk by initial margin: margin 1, n=1723, p(error with 3 votes)=0.282066, p(error with 7 votes)=0.179338; margin 3, n=2373, p(error with 3 votes)=0.243152, p(error with 7 votes)=0.241045. Under these costs, on the calibration distribution extra votes do not have positive expected net value, whereas exact certificates do. This makes the benchmark **favorable to CERT_VALUE by construction whenever the oracle is cheap enough**; the observed result must not be framed as broad superiority over uncertainty-aware policies. In particular b=6 allows exact oracle certification on every request, giving zero mistakes mechanically.

## Main results (lower J is better; 2,048 tasks per panel)

| Panel | b | NO_EXTRA J / wrong | UNIFORM J / wrong | UNCERTAINTY J / wrong | CERT_VALUE J / wrong / exact certs |
|---|---:|---:|---:|---:|---:|
| STABLE | 2 | 23604 / 582 | 26410 / 539 | 24292 / 490 | **21546 / 377 / 682** |
| STABLE | 4 | 23604 / 582 | 29066 / 491 | 24300 / 490 | **20034 / 190 / 1365** |
| STABLE | 6 | 23604 / 582 | 29066 / 491 | 24300 / 490 | **18432 / 0 / 2048** |
| IID_CONTROL | 2 | **16014 / 329** | 18580 / 278 | 17132 / 238 | 17046 / 227 / 682 |
| IID_CONTROL | 4 | **16014 / 329** | 21326 / 233 | 17140 / 238 | 18024 / 123 / 1365 |
| IID_CONTROL | 6 | **16014 / 329** | 21326 / 233 | 17140 / 238 | 18432 / 0 / 2048 |
| CORRELATED_SHIFT | 2 | 41274 / 1171 | 44740 / 1150 | 41808 / 1136 | **33756 / 784 / 682** |
| CORRELATED_SHIFT | 4 | 41274 / 1171 | 48446 / 1137 | 41808 / 1136 | **25974 / 388 / 1365** |
| CORRELATED_SHIFT | 6 | 41274 / 1171 | 48446 / 1137 | 41808 / 1136 | **18432 / 0 / 2048** |

b=0: all four policies are identical within each panel: J_STABLE=23604, J_IID=16014, J_SHIFT=41274. Correlated latent switches observed: STABLE=328/2048, IID=0, SHIFT=1248/2048.

**Interpretation:** At b=2 in STABLE, CERT_VALUE lowers total J by (24292-21546)/24292 = **11.30%** compared to UNCERTAINTY. In SHIFT at b=2, the reduction is (41808-33756)/41808 = **19.26%**. But in IID_CONTROL the cheaper strategy is **NO_EXTRA**, which is **6.05% cheaper than CERT_VALUE** at b=2 (17046 versus 16014), and at b=6 even a zero-error oracle policy is 15.10% more expensive than NO_EXTRA. There is no general dominance. These are exact finite descriptive comparisons, not inferential significance tests.

## Verification, limits, and required next study

A clean re-execution of the same script reproduced results.json and summary.csv **byte-identically**. Asserted: every action counted, aggregate allowed budget not exceeded, every oracle-certified prediction equals deterministic truth, no truth passed to selector except through the costed oracle. No independent implementation, cryptographic audit of inputs, or external review is claimed. The event rates, losses, and oracle cost are intentionally synthetic; any economic inference about real agentic test-time compute is **unsupported**. Also, a policy that can directly buy exact truth is fundamentally different from an uncertainty-triggered sampler and does not constitute a like-for-like comparison of two LLM inference methods.

Next: provide all strategies equal action spaces, replace the perfect oracle by fallible and priced certificates with separately audited false-accept cost, introduce local-budget per-query variants (no carry-over), and execute on real task outputs with documented evaluation costs. Do not claim this is a test of CATTS or proof of a novel optimal decision policy.

## Pointers

Frozen sources: CONT-05A.30 and A.31, TRUST-LIFE-06 (separate experiments). Conceptual literature: Snell et al. arXiv:2408.03314; Lee et al. arXiv:2602.12276 (CATTS). No data combined with these projects.