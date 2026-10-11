# NTK-OBS-04 -- Continuous spectral families and limits of adaptive observation

Date: 2026-10-11. Status: internal exact mathematical derivations and deterministic local checks. No external review. No novelty or priority claim. This is a companion to `NTK_OBS_01/ROBUSTNESS_01`, `SAMPLING_02`, and `ADAPTIVE_03`, not a replacement.

## 1. Scope and observation model

The fixed positive-semidefinite kernel model is

    e[k+1] = (I - eta*K)e[k],  m_k = 2*L[k] = sum_{i=1}^2 w_i*q_i^k,
    0 < q_0 < q_1 < 1, w_0,w_1>0, q_i=(1-eta*lambda_i)^2.

Take `eta=1` and use the injective branch `lambda_i=1-sqrt(q_i) in (0,1)`; every permitted `(q,w)` is realized by the diagonal PSD kernel `K=diag(1-sqrt(q_0),1-sqrt(q_1))` and initial residual `e_0=(sqrt(w_0),sqrt(w_1))`. This is not evidence about a trained network or a time-varying kernel. Measurements are `y_t=m_t+e_t`, `|e_t|<=eps` for each queried nonnegative integer time, with no statistical independence assumption.

The decision problem in Sections 2-3 is **identify which of four continuous families contains the true parameters**, not recover their exact 4-dimensional parameter vector. Decision times are deliberately restricted to `{0,1,2}` for the cost comparison. Sections 4-5 state a different, unrestricted-in-time lower bound for exact recovery.

## 2. Four continuous boxes: a verified positive-radius extension

Let `delta=1/1000`; each family `B_X` is the product of the four closed intervals `[q_{X,i}-delta,q_{X,i}+delta]` and `[w_{X,i}-delta,w_{X,i}+delta]` about its center, preserving the order of its two nodes. The boxes are genuinely 4-dimensional and have strictly positive weights, `0<q_0<q_1<1` throughout:

| Family | (q_0,w_0) | (q_1,w_1) | m_0 | m_1 | m_2 |
|---|---|---|---|---|---|
| A | (1/4,1/2) | (3/4,1/2) | 1 | 1/2 | 5/16 |
| B | (3/52,1/2) | (41/52,1/2) | 1 | 11/26 | 5/16 |
| C | (1/20,275/108) | (23/28,49/108) | 3 | 1/2 | 5/16 |
| D | (1/10,5/2) | (1/2,1/2) | 3 | 1/2 | 3/20 |

For every nonnegative integer `t`, `m_t` increases with each positive coordinate `q_i,w_i`. Hence the exact moment range on each box is

    M_X^-(t)=sum_i (w_Xi-delta)*(q_Xi-delta)^t,
    M_X^+(t)=sum_i (w_Xi+delta)*(q_Xi+delta)^t.

Every noisy measurement from family X belongs to the *closed* interval `[M_X^-(t)-eps,M_X^+(t)+eps]`. These are exact interval endpoints, not sample-based confidence intervals. They are implemented using `Fraction` and independently verified by enumerating all 16 vertices of each box.

At the three relevant tests the exact separation gaps, before noise, are:

    G0  = min(M_C^-(0),M_D^-(0)) - max(M_A^+(0),M_B^+(0)) = 499/250,
    GAB = M_A^-(1) - M_B^+(1) = 19/260,
    GCD = M_C^-(2) - M_D^+(2) = 1954650351/12250000000.

All are positive. The smallest is `GAB=19/260`. Therefore, whenever

    eps < GAB/2 = 19/520,

the deterministic policy **query t=0; if it lies in the A/B interval then query t=1, otherwise query t=2** identifies the correct family for *every* possible continuous parameter vector in the boxes and *every* allowed adversarial noise vector. In particular, `eps=1/100` satisfies the strict inequalities. The policy uses two scalar observations and has worst-case horizon 2. The threshold `19/520` is a *sufficient separation threshold for this interval-based policy*; it is not claimed to be the optimal possible noise threshold over all estimators or alternative query times.

An easy (weaker) human-checkable bound is

    |m_t(theta)-m_t(center)| <= 2*delta+t*W*delta <= (2+3*t)*delta

for `t=0,1,2`, since `W=sum_i w_i<=3`, `0<q_i<1`, and `|(q+v)^t-q^t|<=t*|v|`. The corresponding conservative sufficient noise threshold is `87/2600`, still much greater than `1/100`.

### Matching fixed-design lower bound (restricted calendar)

Any fixed schedule of two times among `{0,1,2}` fails even *without* noise, using the centers of the families, which themselves belong to the boxes:

- `(0,1)` leaves C and D exactly identical;
- `(0,2)` leaves A and B exactly identical;
- `(1,2)` leaves A and C exactly identical.

Every one-time schedule similarly has at least one center collision. Conversely, `(0,1,2)` robustly distinguishes all family labels because every pair is separated by one of the certified tests above. Hence the fixed unconditional minimum is three observations, and the adaptive minimum is two observations under this time set. With nonnegative query cost `c>0` and horizon price `beta>=0`, the respective worst-case observation/horizon costs are

    J_fixed=3*c+2*beta; J_adaptive=2*c+2*beta.

For the concrete benchmark `c=1`, `beta=1/4` these are `7/2` and `5/2`. Even if an ordered, fixed full schedule is permitted to stop upon identification, its worst-case cost remains `7/2`. No claim is made for calendars involving observation times beyond `{0,1,2}`.

**Preparation-cost gate.** If producing/checking an adaptive decision tree costs `P_A`, and the fixed schedule costs `P_F`, its full cost advantage exists precisely when `P_A-P_F<c`, with equality yielding a tie. This is an *algebraic break-even condition*. No actual preparation times or monetary costs have been empirically measured here.

## 3. Why class identification is not full spectral reconstruction

The four boxes each contain an open subset of the four-dimensional parameter space `(w_0,w_1,q_0,q_1)` with distinct nodes and positive weights. Consider any **deterministic** sequential reconstruction algorithm which queries at most three times `t_1,t_2,t_3` chosen adaptively from all nonnegative integers, with noiseless, exact scalar moment responses. Fix any interior parameter theta and follow that algorithm's path.

If all queried times are distinct, the 3-row Jacobian of the observation map, viewed as a function of `(w_0,w_1,q_1)`, has entries

    [ q_0^t, q_1^t, w_1*t*q_1^(t-1) ],   t in {t_1,t_2,t_3}.

The determinant is nonzero for any `0<q_0<q_1` and `w_1>0`. Indeed, otherwise a nonzero linear combination `p(x)=sum_{j=1}^3 a_j*x^(t_j)` would satisfy `p(q_0)=p(q_1)=p'(q_1)=0`, i.e. at least three positive zeros counting multiplicity. A nonzero **three-term generalized monomial polynomial** with distinct nonnegative integer exponents has at most two positive roots counting multiplicity. To prove this elementary classical zero-count statement, divide by its lowest monomial: `g(x)=a+b*x^r+c*x^s` with `0<r<s`; then `g'(x)=x^(r-1)[r*b+s*c*x^(s-r)]` has at most one positive zero. Rolle's theorem with multiplicities gives at most two positive zeros of `g`. Contradiction.

The implicit function theorem thus supplies, by varying the fourth parameter `q_0`, a **nontrivial local one-parameter family** of distinct parameters which gives exactly the same observations at these three times. Since the chosen parameters can be arbitrarily close to theta, they remain in the same interior box. If the algorithm asks fewer distinct times, add unused auxiliary times to reach three; the same construction matches the actual transcript. Both models follow the same adaptive choices because the prior answers are identical. Thus **no algorithm using at most three exact scalar observations can reconstruct every point in any open box**, even if it selects arbitrary integer times adaptively.

For four distinct times, a corresponding 4x4 Jacobian is nonsingular: a hypothetical row dependency would yield a nontrivial four-term monomial polynomial having *double* positive zeros at both distinct nodes (four counting multiplicity), contradicting the same classical zero-count principle (maximum three). This establishes **local**, not necessarily globally unique, inversion from four chosen distinct exact moments. Standard consecutive four-moment Prony gives global reconstruction in the positive ordered two-atom class. Noise stability still requires node separation, weight bounds, and quantitative conditioning, as in `ROBUSTNESS_01`.

This structural distinction is the main interpretation: **certify one of four known continuous families** (2 queries) versus **reconstruct any continuous two-node spectrum** (at least 4 exact queries, and infinitely precise recovery is impossible under positive adversarial noise).

## 4. Explicit infinite-horizon no-go under bounded adversarial error

The *first mode* in the A center has `q_0=1/4`, `w_0=1/2`; the second has `q_1=3/4`, `w_1=1/2`. Choose two spectra inside the same box:

    theta_- : q_0 = 249/1000, remaining coordinates unchanged;
    theta_+ : q_0 = 251/1000, remaining coordinates unchanged.

Supply the identical observation sequence `y_k=m_k(center A)` for **every** `k>=0`. Let `b=251/1000<1`. For each sign and integer `k>=1`, the mean-value theorem gives

    |m_k(theta_+/-)-y_k| <= w_0*delta*k*b^(k-1)
        <= w_0*delta/(1-b)^2 = 500/561001 < 1/100.

At `k=0` the difference is zero. The second inequality uses the elementary nonnegative series `sum_{j>=1} j*b^(j-1)=1/(1-b)^2`. Thus **even all integer-time scalar observations**, with adversarial absolute errors at most `1/100`, admit these two physically realizable PSD models. Their first discrete nodes differ by `2*delta`; an estimator sees the same data and must make an error of at least `delta=1/1000` on that node for at least one of them. This holds even if time selection is adaptive and the observer makes arbitrarily many queries: answering with this sequence remains admissible under both models.

This no-go concerns exact/overprecise **parameter estimation**, not correct **family-label certification**. Nor does it preclude stable approximate recovery to a looser tolerance, multiple independent physical readouts, or the use of additional prior information.

## 5. Reproduction, dependencies, and limitations

`verify_continuous.py` checks positive boxes, exact moment endpoints, safe interval routing, the 7 fixed schedules, rational Jacobian examples, an all-time analytic bound with 101 finite sanity checks, and the preparation break-even model. `independent_audit.py` shares no imports with the first verifier and uses an **independent in-package implementation**: 16 vertices per box, permutation-determinants of 224 generalized 3x3 minors and 60 4x4 minors, and 301 finite checks of the all-time witness. These finite checks supplement, but do not replace, the complete mathematical arguments above.

The entire report is deterministic, rational, and self-contained; use `sh verify.sh`. Code and proof have **not** undergone any external independent review. The selected four centers were already known from NTK-OBS-03; this is a retrospective extension, not an independently preregistered experiment.

Classical context: finite moment/Prony inverse problems, Chebyshev systems and generalized Vandermonde determinants, implicit function theorem, finite active identification decision trees. Refer to `REFERENCES.md`. All exact statements here are restricted internal specializations; **no novelty or priority claim**.

Open: continuous-parameter approximate minimax risk; optimal time design beyond `{0,1,2}`; stochastic vs adversarial errors; preparation costs measured empirically; higher-rank/unknown-rank models; kernel drift; network training; independent replication.

**Claim gates:** E = exact elementary argument and local computational corroboration; Q = deterministic local replay; N = NO CLAIM; R = external review OPEN. **No merge to main or claim of a reviewed/original theorem. Pre-review Zenodo archiving is conditionally allowed only after the separate integrity, rights, licence and metadata gate passes; currently HOLD. This package makes no publishing action.**
