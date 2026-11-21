# NTK-OBS-05 — Exact conditional minimax risks and the cost of observation

**11 October 2026 · Internal research derivation · External scientific review OPEN · NO NOVELTY OR PRIORITY CLAIM**

## Executive scientific conclusion

There are **two distinct inverse problems**. (A) In each of the four positive-radius four-parameter boxes of NTK-OBS-04, *if the family label is known*, adversarial noise `epsilon=1/100` makes every additional scalar loss observation **useless in the global minimax sense** for parameter estimation in coordinatewise max norm: the exact minimax error is `delta=1/1000`, equal to the prior half-width and attainable with **zero queries**, even if infinitely many observation times are allowed. This applies both to all four parameters `(q0,w0,q1,w1)` and to the two ordered node coordinates `(q0,q1)` alone.

(B) To exhibit a nondegenerate noise-accuracy tradeoff, consider a *different* one-dimensional spectral family with just one unknown mode `q in [89/100,91/100]` and all other mode/weight parameters known. In this subproblem, the **exact minimax risk for any finite time horizon**, even against adaptive policies with arbitrarily many measurements, is attained with **one appropriately chosen scalar sample** or (when the prior alone suffices) with none. A polynomial inequality yields exact rational brackets, and all later times after 11 are minimax-dominated by time 11. A target-accuracy and time-penalty theorem gives exact optimal measurement costs for this restricted subproblem.

This is an elementary bounded-noise specialization of classical optimal-recovery, moment, Prony and active-observation ideas. It is **not** a general neural-tangent-kernel training theorem or a new universal minimax result.

## 1. Assumptions, metrics and adversary

We observe a fixed positive-semidefinite (PSD) kernel's two-mode scalar loss curve

    m_t = 2 L_t = w0 q0^t + w1 q1^t,  t in Z_{>=0},
    0 < q0 < q1 < 1,  w0,w1>0,
    y_t = m_t + e_t,  |e_t| <= epsilon.

The bounded error is **adversarial**, not independent random noise. The adversary may choose consistent but coordinated errors for all times (including arbitrarily many queried times). An estimator chooses its integer sampling times, possibly adaptively, and returns ordered nodes/weights. It may also output the prior center without any observation. Full-parameter error is

    ||theta_hat - theta||_infty,
    theta = (q0,w0,q1,w1).

Node-only error is `max(|q0hat-q0|,|q1hat-q1|)`. We make no assertion that q and weight errors are physically equivalent units: the max metric is merely an explicitly defined mathematical loss. The loss observation `L_t` has half the scale of `m_t`; a noise bound on `L` must be multiplied by two to compare with epsilon here.

Realizability: choose `eta=1`, `K=diag(1-sqrt(q0),1-sqrt(q1))` and initial residual `e_init=(sqrt(w0),sqrt(w1))`. Then K is fixed and PSD and the discrete squared-gradient dynamics yield the moments stated above. The injective eigenvalue branch is imposed. These are *synthetic fixed-kernel examples*, not trained networks.

## 2. Exact minimax negative result inside each box of NTK-OBS-04

The four centers, inherited without changing their definitions, are

| Box | `(q0,w0)` | `(q1,w1)` |
|---|---|---|
| A | `(1/4,1/2)` | `(3/4,1/2)` |
| B | `(3/52,1/2)` | `(41/52,1/2)` |
| C | `(1/20,275/108)` | `(23/28,49/108)` |
| D | `(1/10,5/2)` | `(1/2,1/2)` |

Each of the four parameters varies *independently* by at most `delta=1/1000`, with order, positivity, and strict unit-interval bounds maintained throughout. Suppose the box label is given **in advance**. Fix `epsilon=1/100`.

**Theorem A (exact all-horizon minimax risk in these four boxes).** For each box,

    inf_{any estimator/any adaptive integer sampling policy}
      sup_{theta in box, |e_t|<=1/100} ||theta_hat-theta||_infty
    = 1/1000.

The same equality holds when the target is just the *two nodes* in `L_infty`. The estimator may use arbitrarily many queried times, but zero queries already attain the optimum.

**Proof, upper bound.** Return the known box center. Every coordinate differs by at most `delta`, so the error is at most `delta`.

**Proof, full-vector lower bound.** Consider the two parameters obtained by replacing the first weight `w0` with `w0-delta` and `w0+delta`, keeping all other coordinates fixed. Both are in the box. Take the *same entire observation sequence* `y_t = m_t(center)` for every `t>=0`. Against either parameter, its required error is exactly `delta*q0^t <= delta < epsilon`. Therefore, even an infinitely adaptive observer sees identical data from two parameters separated by `2 delta` in max norm. Its single output has worst-case error at least `delta`.

**Proof, nodes-only lower bound.** Instead perturb `q0` to `q0-delta` and `q0+delta` while retaining all other coordinates. For `r=q0+delta<1`, the mean value theorem yields for any `t>=1`,

    |m_t(shifted)-m_t(center)| <= w0 * delta * t * r^(t-1)
                                  <= w0 * delta / (1-r).

The last inequality follows from `t*r^(t-1) <= sum_{j=0}^{t-1} r^j <= 1/(1-r)`. For `t=0` the difference is zero. The exact upper bounds for boxes A/B/C/D respectively are

    A: 1/1498;  B: 13/24474;  C: 275/102492;  D: 5/1798.

All four are strictly smaller than `1/100`. The same central observation stream is thus valid for both endpoint node choices. Those nodes differ by `2delta`, forcing worst-case error at least `delta`. Combined with the center estimator, the exact minimax node-only risk is `delta`. QED.

**Interpretation.** This does not contradict NTK-OBS-04's 2-query *family-label classifier*. The answer to “which box?” is a different property from “which point in that box?”. It does not imply that a particular observation sequence cannot shrink an ex-post feasible region. It proves a *worst-case* lower bound under the stipulated adversarial noise.

## 3. A separate positive one-dimensional slow-mode experiment

Define

    q in [a,b] = [89/100, 91/100],
    m_t(q) = q^t + (1/4)^t,
    y_t = m_t(q) + e_t,  |e_t| <= epsilon.

Here only the slow node `q` is unknown. The other node `1/4` and both weights `1` are **KNOWN**. This is a distinct restricted family, not one of NTK-OBS-04's four-dimensional boxes. We estimate q in absolute error, and all query times are nonnegative integers.

For `d in [0,b-a]`, set

    Delta_t(d) = (a+d)^t - a^t   (t>=1),   Delta_0(d)=0.

Let `H>=0` be the maximal permitted sampling time. Define

    d_H(epsilon) = max { d in [0,b-a]: Delta_t(d) <= 2*epsilon
                        for every integer t in [1,H] }.

The set is a compact interval because the differences are continuous and increasing. At H=0, `d_0=b-a`. Let `R_H(epsilon)` be the worst-case minimax absolute q error among **all deterministic sequential policies** using any number of observations at times not exceeding H. Coordinatewise adversarial errors can differ from observation to observation without probabilistic restrictions.

**Theorem B (exact minimax recovery of the one-dimensional family).**

    R_H(epsilon) = d_H(epsilon)/2.

If `d_H=b-a`, returning the prior midpoint `(a+b)/2` with zero observations is optimal. Otherwise there exists a time `t* in {1,...,H}` such that **one observation at t***, followed by the midpoint of its exact bounded-noise feasible q interval, attains `R_H`.

**Proof: adversarial lower bound.** The parameters `a` and `a+d_H` have moment differences at most `2 epsilon` at *every allowed time*. The adversary gives the same responses `y_t = [m_t(a)+m_t(a+d_H)]/2` under either parameter. Any adaptive policy follows the same sequence of queries and produces the same estimate under both. At least one parameter suffers error at least `d_H/2`.

**Proof: fixed one-query upper bound.** When `d_H<b-a`, compactness and continuity give a time `t*<=H` at which `Delta_t*(d_H)=2 epsilon`. For all `q2>q1>=a`, the difference `q2^t-q1^t` is nondecreasing with `q1` at fixed span `q2-q1` (strict for t>1, and equal for t=1), by convexity of `x^t`. Therefore two candidate q values separated by *more* than `d_H` must produce samples at t* separated by more than `2 epsilon`, and cannot both fit the observed error interval. The feasible q set is an interval with diameter at most `d_H`. Its midpoint has error at most `d_H/2`. QED.

A useful restatement is that **the extra observations do not improve the global minimax risk beyond the best single observation** in this one-parameter family, even if their times and count can be selected adaptively. This special conclusion cannot be extrapolated to arbitrary multi-parameter spectral families.

## 4. An all-integer-time finite cutoff for this slow slice

For `x in [a,b]` and every integer `t>=11`,

    (t+1) x^t <= t x^(t-1)

because `(t+1)*x/t <= (12/11)*(91/100) = 1092/1100 < 1`.

Integrate over `[a,a+d]` to obtain

    Delta_{t+1}(d) <= Delta_t(d),  t>=11.

Thus times 12,13,... are **never stronger than time 11 for any of the two-point tests** defining `d_H`, and

    R_infinity(epsilon) = R_11(epsilon) = R_H(epsilon), H>=11.

This is an exact mathematical cutoff for the present one-dimensional example. It concerns minimax performance, **not** the informational value of late observations for a particular noise realization. It does **not** extend unchanged to time-varying kernels, stochastic errors, or multiple unknown modes.

## 5. Certified rational risk bounds and the best observation time

`verify_minimax.py` searches the exact monotone inequalities with `fractions.Fraction`, on a distance grid of step `10^-12`. For each noise and H it publishes fractions `D_lo,D_hi` with

    D_lo <= d_H <= D_hi,    D_hi-D_lo <= 10^-12,
    R_H in [D_lo/2,D_hi/2].

Unless the prior diameter is exactly optimal, `D_hi=D_lo+10^-12`, `Delta_t(D_lo)<=2eps` for every allowed t and `Delta_t(D_hi)>2eps` for at least one. These are **certificates** evaluated with exact integer arithmetic, not floating-point convergence criteria. When the selected single best time has a uniquely smallest distance bracket, its optimality is likewise certified by disjoint rational brackets. Complete values for 8 noise levels and 25 horizons each are in `results.json`.

| epsilon on `m` | certified `R_infinity`, approximately | one best time | observation count attaining minimax |
|---|---:|---:|---:|
| `1/25` | 0.010000000 | no observation | 0 |
| `19/500` | 0.009812834 | 10 | 1 |
| `7/200` | 0.009098163 | 9 | 1 |
| `3/100` | 0.007884980 | 9 | 1 |
| `1/100` | 0.002753385 | 9 | 1 |
| `1/1000` | 0.000281539 | 9 | 1 |
| `1/10000` | 0.0000282181 | 9 | 1 |
| `1/100000` | 0.00000282245 | 9 | 1 |

These decimal renderings are approximations only. The exact rational interval endpoints, truncated independently of this table, govern every claim. The identity of the optimal single query can itself depend on the noise level: here 9 versus 10. At noise `1/25` the prior q interval is entirely compatible with a common noisy transcript and observations cannot improve the worst-case risk.

## 6. Exact target-error and cost theorem

Suppose each queried scalar observation costs `c>0`, the last selected observation time incurs horizon cost `beta*T`, with `beta>=0`, and the preparation cost is excluded (or is equal across methods). The goal is an **error at most tau for every q and every bounded noise**. Assume `0<tau<(b-a)/2=1/100`.

Define

    t_min(tau,eps) = min{t>=1 integer: Delta_t(2*tau) >= 2*eps}.

If the set is empty, that target error is impossible by any deterministic adaptive method even with arbitrarily many scalar observations over all integer times. For the present slice, it suffices to search `t=1,...,11`. Otherwise the **exact minimum worst-case observation/horizon cost** is

    J_min(tau,eps) = c + beta*t_min(tau,eps),

achieved by querying only at t_min and returning the midpoint of the compatible q interval. For `tau>=1/100`, the prior estimator costs zero and suffices.

**Proof of optimality.** At time t_min the difference between `a` and `a+2tau` is at least `2eps`, and larger separations produce strictly larger difference, so the feasible diameter is at most `2tau`. Conversely, for each earlier time `t<t_min`, `Delta_t(2tau)<2eps`. By continuity choose `d>2tau` sufficiently close to `2tau` so *all* earlier times satisfy `Delta_t(d)<=2eps`; `d<=b-a` is possible since `2tau<b-a`. Then q=a and q=a+d admit a common noisy transcript at all those earlier times. No adaptive method restricted to times earlier than t_min can certify the required accuracy. Every valid method must query at least once, and some admissible run reaches horizon `>= t_min`; hence worst-case cost is at least `c+beta*t_min`. An optimal one-shot schedule attains equality. QED.

For the benchmark `c=1,beta=1/4`, a few exact examples are:

| epsilon | required tau | exact least time | minimum worst-case J |
|---|---|---:|---:|
| `1/100` | `1/200` | 3 | `7/4` |
| `1/100` | `1/1000` | impossible | — |
| `1/1000` | `1/1000` | 1 | `5/4` |
| `1/1000` | `1/2000` | 3 | `7/4` |
| `1/1000` | `1/4000` | impossible | — |

All 40 noise/target combinations are rechecked in `independent_audit.py`. The `c+beta*T` model is abstract: it omits hardware, measurement latency, computation, program construction and certificate preparation. If preprocessing differs, its measured cost must be added **before** concluding that any method is economically superior.

## 7. Precise relation to previous NTK-OBS stages

- **NTK-OBS-01 / ROBUSTNESS-01:** four noiseless moments generically identify two distinct unknown nodes and two positive unknown weights by Prony, but bounded-noise inverse conditioning degenerates as the separation vanishes. NTK-OBS-05 does **not** replace that four-parameter theorem with a one-query reconstruction theorem.
- **SAMPLING-02:** choosing better spacings can improve certified *sufficient* reconstruction bounds. The present one-parameter slice instead admits an **exact minimax** calculation, because three of four parameters are known.
- **ADAPTIVE-03:** adaptive identification among four *known isolated models* can save an observation relative to a fixed precommitted schedule.
- **CONTINUOUS-04:** the family-label advantage survives small four-dimensional boxes, yet reconstruction within a box has an all-horizon noise obstruction. Here NTK-OBS-05 closes the gap by quantifying the within-box conditional minimax radius and by analyzing a lower-noise one-dimensional case.

The contrast is substantive, not contradictory: **property certification**, **family-label classification** and **full/partial parameter estimation** are distinct decision objectives with different minimax limits.

## 8. What is classical, internal and still open

**Classical foundations:** minimax optimal recovery under deterministic bounded errors, monotone inverse problems, two-point indistinguishability bounds, finite exponential/moment systems, Prony recovery, and optimal experimental design. References include Batenkov–Yomdin (2013), Batenkov (2013), and Katz–Diab–Batenkov (2024). No claim of mathematical novelty or priority.

**Internal specializations proved here:** the exact `1/1000` within-box worst-case risk for four specified boxes and `eps=1/100`; the exact explicit `d_H/2` formula and one-query minimax property for a separate one-parameter positive two-atom slice; the all-integer-time cutoff at 11; and its conditional target-accuracy cost formula. All are conditional on precisely stated assumptions. Two local programs corroborate finite parts; these are **not** external reviewers.

**Open:** approximate minimax risk in the full four-parameter positive two-mode class under smaller epsilon; truly unrestricted multi-parameter adaptive design; unknown rank; stochastic independent errors and repeated measurements; empirical cost measurement; floating-point finite precision; kernel drift; trained networks and real datasets. The current study has no test of these extensions.

**Release boundary:** mathematical local `E`; deterministic replay local `Q`; novelty `N=NO CLAIM`; outside review `R=OPEN`. A pre-review, explicitly unreviewed Zenodo archive is possible **only** after the separate rights, metadata, licensing and integrity release gate already defined in the repository. Nothing here requests a DOI, merge into main, or journal publication.
