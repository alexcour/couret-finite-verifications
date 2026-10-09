# AGENT-CERT-01 — Pre-registered synthetic verification budget comparison

Date 2026-10-09. This is a **new synthetic benchmark**, separate from the frozen A.30 / A.31 / TRUST-LIFE-06 datasets and costing systems. No actual GPT, CATTS implementation, browser agent, or private dataset is used. Research status: E-protocol; E-exact-finite only for future results after independent replay; N-not audited; no physical timing or industrial claim.

## Research question

Does a paid decision policy based on calibrated **certificate value** outperform (a) a fixed extra-sampling policy and (b) a vote-uncertainty-triggered sampling policy under the same aggregate extra-compute allowance, particularly when correlated wrong votes make confidence misleading?

## Fixed generator and constraints

The exact implementation is `run_agent_cert_01.py`; check its SHA-256 before execution. All pseudorandomness derives from SHA-256 domain-separated deterministic inputs and seed `AGENT-CERT-01-2026-10-09-v1`. Truth is the exact predicate `(n*n+11*n+7) mod 101 < 48`, where n is derived from the fixed SHA-256 key. Seven binary simulated votes share the truth only with the data generator and independent offline scorer, never the policy. Each task starts with three votes; four additional votes may be purchased. Panel-specific correlated wrong votes are generated using a common latent switch. The initial vote margin (1 or 3) is the sole selector feature. Regime labels and truth are invisible to policies, except truth paid for by a verifier.

Calibration: 4096 tasks from STABLE, not used for reporting the holdouts; the two conditional error frequencies `risk_initial` and `risk_extra_votes` by margin are calibrated once. Holdout: 2048 fresh tasks per panel STABLE (15% shared latent), IID_CONTROL (0%), CORRELATED_SHIFT (60%). No feature selection or retuning on holdout. Shared latent correct probability 17%. Independent votes have one of three reliability levels 93%,76%,61%, chosen deterministically. These are synthetic generator parameters, not measurements of actual models.

Four policies: NO_EXTRA always uses initial 3-vote majority; UNIFORM pays for four more votes whenever the token balance allows; UNCERTAINTY pays for four additional votes only if initial 3-vote margin equals 1; CERT_VALUE considers NONE, SAMPLE and exact CERTIFY. It computes expected net benefits from calibrated conditional risks: `LOSS*(risk3-risk7)-4` for SAMPLE and `LOSS*risk3-6` for CERTIFY; chooses positive maximum, tie preference NONE then SAMPLE. A certificate is **exact** only by calculating the reference truth after charging 6 units. Merely sampling more votes is not a certificate.

Costs: common initial votes cost 3, four extra votes cost 4, an exact certificate costs 6, each wrong final decision incurs loss 30; total `J = 3*N + extra_cost + 30*wrong`. These are arbitrary abstract cost units, not dollars, tokens, GPU, latency or energy. Budget per task b in {0,2,4,6} is minted into an online unbounded nonnegative balance of b units at each task, thus allowing spend after accrual and guaranteeing sum extra <=b*N. Policies see only current balance and margin. Unused balance is not penalized; the objective already charges spending. They cannot borrow against future budget. Results with b=0 are the negative control.

Primary comparisons: paired J, number wrong, extra expenditure and certificates for each of 3 panels by 4 budgets; report all cases, including losses. Primary question is whether CERT_VALUE yields lower J than UNCERTAINTY in STABLE, and whether the outcome transfers to CORRELATED_SHIFT. No universal superiority inferred; multiple subpanels are descriptive, not p-values. If no advantage, record negative result.

## Acceptance, negative controls, falsification

1. All policies must respect online budgets and produce an action for each query. Every certified action must agree with the exact oracle. Unauthorized access to truth is a critical failure.
2. Independent deterministic replay should reproduce `results.json` and `summary.csv` byte-identically; SHA-256 manifest must identify exact files.
3. Results on STABLE are not reused to retune thresholds. Failures under shift must be reported even if the baseline is positive.
4. The exact certificates are built into the toy oracle; zero certification error has NO evidentiary force about real AI agents.
5. A positive result merely identifies a cost advantage in this synthetic data-generating process; no claims about CATTS implementation, OpenAI internal architecture, current A.30/A.31 or general optimality.

## Relation to sources

CONT-05A.30, CONT-05A.31 and TRUST-LIFE-06 on Drive supply the discipline: separate calibration/validation, pay costs, verify each issued certificate, and report negative instances. The CATTS paper (Lee et al., arXiv:2602.12276) provides a conceptual vote-uncertainty comparison; this implementation is NOT CATTS itself. Snell et al., arXiv:2408.03314 shows compute-optimal allocation depends on task difficulty. No claims of importing their numerical results.