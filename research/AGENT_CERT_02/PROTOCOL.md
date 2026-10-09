# AGENT-CERT-02 - Equal actions, fallible verification, local budgets

Date: 2026-10-09. Status before execution: prospectively specified **exact finite synthetic model**, not a statistical holdout, not a real LLM study, not TRUST-TTC-01. New synthetic inputs only. No private Drive information or datasets are published. Existing AGENT-CERT-01 remains unchanged.

## Motivation

AGENT-CERT-01 gave a perfect truth-returning oracle only to CERT_VALUE and allowed budget carry-over. Its report explicitly identified these limitations. This study removes that oracle, grants the same action menu to every family, and enforces a per-query spending limit. It studies price, checker fallibility, and distribution shift, not an OpenAI implementation or CATTS reproduction.

## Model and pre-specified grid

Binary label-symmetric tasks: fix truth=1 for scoring without loss of generality. Seven simulated votes: with probability rho a shared component makes all votes correct with probability 1/5 or all wrong with probability 4/5; otherwise seven independent votes have correctness 3/4. A policy sees only the absolute initial 3-vote margin, either 1 or 3. It never sees truth, rho, future votes or checker outcomes before choosing an action.

Common actions: STOP (emit 3-vote majority), SAMPLE (buy 4 votes and emit 7-vote majority), VERIFY (check 3-vote majority), SAMPLE_VERIFY (check 7-vote majority after sampling), ABSTAIN. A checker accepts a correct candidate with probability 19/20 and a wrong one with probability alpha. Rejection means abstention, never returning the correct answer. Checker errors are conditionally independent of other features given candidate correctness by model assumption. A checker acceptance is **fallible validation**, never a formal proof.

Nominal analytic calibration: rho=3/20, alpha=1/20. No finite training sample. Evaluation grid: rho in {0,3/20,3/5}, alpha in {0,1/20,1/5}; checker price c in {1,3,6,12}, budget b in {0,4,8,16}. Base cost 3, sampling 4, wrong emitted answer loss 30, abstention loss 6. Verification costs c. No carry-over or borrowing. Extra spending must be <=b on every possible margin.

J=3+E(extra)+30 P(wrong emitted)+6 P(abstain). Publish all components, correct emitted probability, coverage, validation mass and false-accept mass separately. Correct+wrong+abstain=1. A target coverage of 4/5 constrains nominal selection; evaluate it afresh under shift. Zero false acceptance is a separate diagnostic and is not established by minimizing J.

## Four families using identical available operations

RAW: STOP for both margins, diagnostic reference.
FIXED: choose the cheapest-in-J nominal feasible constant action.
UNCERT: keep STOP when margin=3; choose the nominal optimal feasible action at margin=1.
ADAPT: choose the nominal optimal feasible pair of actions for the two margins.
All families have the same per-query prices and action menu; fixed/restricted families intentionally ignore some observable routing opportunities. Policies remain frozen under rho/alpha shift. Deterministic ties use the action order STOP, SAMPLE, VERIFY, SAMPLE_VERIFY, ABSTAIN.

Because ADAPT contains the other families, nominal J dominance follows from set inclusion and is **not evidence of a new algorithm**. Report transferred losses, coverage failures and false validations without selecting only favorable configurations. Exactly 9 panels x 16 price/budget settings x 4 families = 576 expectation rows; these are NOT 576 independent tasks or statistical trials.

## Verification and boundaries

Producer: enumerate 128 bit trajectories and 20 equally weighted checker tickets, with rational weights. Auditor: separate 20 grouped binomial outcomes, analytic verifier likelihoods; no import of producer. Compare 8 exact metrics per row and independently reconstruct all 64 price/budget/family choices. Re-run producer in a separate process for byte equality and perturb outputs to check auditor rejection. Separate code written in the same session is not independent external review.

No Monte Carlo standard errors, p-values, real token prices, physical energy claims, universal safety, or novelty claim. Code and protocol are committed before first full evaluation; this is a time-ordered computational record, not a blinded trial. Any post-freeze correction must be separately identified.

## Mathematical companion

For prior candidate error p, false-accept probability alpha and correct-accept sensitivity s, the error among accepted candidates is p*alpha/((1-p)*s+p*alpha), whenever the denominator is nonzero. Positive p and alpha preclude treating acceptance as a sound proof.

For a fixed wrong candidate and k independent retries with false-accept probability alpha, accepting any pass has error probability 1-(1-alpha)^k. An append-only archive does not repair a fallible admission rule.

For a sound verifier and a fixed statement/context, adding only verified candidates to an append-only set preserves both set inclusion and validity by induction. If context changes, validity must be re-established. For adaptive fallible tests, a conditional per-step risk bound epsilon_t with pathwise sum <=delta yields P(any false admission)<=delta by conditional expectation and the union bound. Marginal calibration alone does not imply the required conditional guarantee.

## Literature (scope only)

Snell et al., arXiv:2408.03314v1: allocation depends on task difficulty. Lee et al., arXiv:2602.12276v1: vote-derived uncertainty for web-agent compute allocation. These primary abstracts were consulted on 2026-10-09; no numerical gains or proprietary architecture details are imported. This benchmark is not their implementation.
