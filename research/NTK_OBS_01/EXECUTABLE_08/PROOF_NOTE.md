# NTK-OBS-08 — Constructive rational inverse with a-posteriori error certification

**11 October 2026 | COURET internal research | Retrospective, no claim of novelty or priority | Outside peer review OPEN**

## 1. Inherited model and precise objective

NTK-OBS-08 inherits *unchanged* the four known four-parameter boxes A/B/C/D and the certified Jacobian estimates of NTK-OBS-07. It addresses the implementation gap of that report, which defined an estimator using the four coordinate extrema of the full nonlinear feasible parameter set without computing them. It does **not** solve that full global optimization problem. Instead it constructs a different, executable projected fixed-point estimator, rigorously encloses the *whole* feasible set and computes the coordinate midpoint of this outer enclosure.

For ordered `theta=(q0,w0,q1,w1)` in the known product box `B` of half-width `delta=1/1000` about its known center `theta*`, let

    F_t(theta) = w0*q0**t + w1*q1**t = 2 L_t,
    y_t = F_t(theta_true) + e_t, |e_t|<=epsilon, epsilon=1/10^7.

The unknown kernel is fixed and positive semidefinite on the injective lambda branch. The two nodes lie in `(0,1)`, remain ordered, and both weights are positive throughout every box. Noise is **adversarial bounded**, not independently random. All errors are on `m=2L`, not `L`; the estimation metric is unscaled coordinatewise `L_infinity`. The family label is given before the four measurements.

The boxes are centered at

| Box | `(q0,w0)` | `(q1,w1)` |
|---|---|---|
| A | `(1/4,1/2)` | `(3/4,1/2)` |
| B | `(3/52,1/2)` | `(41/52,1/2)` |
| C | `(1/20,275/108)` | `(23/28,49/108)` |
| D | `(1/10,5/2)` | `(1/2,1/2)` |

The primary projected calendar is `S=(0,1,2,5)` (four measurements); the comparison uses Prony's consecutive calendar `S0=(0,1,2,3)` (also four). Thus the main two-method comparison uses the *same ground truth and noise signs at corresponding query positions*, but **different last observation times**, not literally the same four observations. To isolate the algorithmic effect, a projected control also uses `S0` and exactly the same data as Prony.

## 2. Constructive theorem (projected contraction)

For any calendar S for which the NTK-OBS-07 rational Neumann certificate is valid, let `J*=J_S(theta*)`, `A=(J*)^-1`, `C=||A||_infinity`, and choose rational `kappa<1` such that **for all theta in B**

    ||A (J_S(theta) - J*)||_infinity <= kappa.

The certified derivative row envelopes and an exact matrix inverse establish this hypothesis; they are recomputed from scratch by two independent *internal* programs using Gauss-Jordan and adjugates respectively. All points in B lie in the physically admissible parameter regime.

With componentwise clamping `P_B` to the prior box, define

    T_y(x) = P_B[x + A (y-F_S(x))], x in B.

Because the box is convex, the mean value identity and matrix bound show

    ||T_y(x)-T_y(z)||_infinity <= kappa ||x-z||_infinity,

for every x,z in B. Projection to a closed axis-aligned box is 1-Lipschitz in the infinity norm. Banach's fixed-point theorem yields one and only one `x_inf(y)` in B for every finite y (even if the data are inconsistent with the prior).

For any **feasible** truth theta in B with `||y-F_S(theta)||_infinity<=epsilon`, the projection property gives

    ||T_y(theta)-theta||_infinity <= ||A(y-F_S(theta))||_infinity <= C epsilon,

and hence

    ||x_inf(y)-theta||_infinity <= C*epsilon/(1-kappa) = Q*epsilon.

This is the same theoretical `Q` bound obtained in NTK-OBS-07 for the different, nonconstructively defined true-feasible-set coordinate midrange. **There is no claim that the two estimators coincide.**

### Finite, rationally rounded implementation and a-posteriori certificate

Start from the known center and compute exact rational updates `T_y(x_n)`. For numerical tractability, each new coordinate is quantized on the rational lattice `center + integer/10^12` and clamped to B. The quantization deliberately changes the iteration but is **not discarded** or approximated in the proof. After every iteration compute the exact rational residual

    rho_n=||T_y(x_n)-x_n||_infinity.

From contractivity, irrespective of rounding history,

    ||x_n-x_inf||_infinity <= rho_n/(1-kappa).

Consequently, the **computed and output** bound

    E_n = Q*epsilon + rho_n/(1-kappa)

satisfies `||x_n-theta_true||_infinity<=E_n` for *every feasible truth* in B. Stop when `rho_n/(1-kappa)<=epsilon/10`, implying

    E_n <= (Q+1/10)*epsilon < 58.1*epsilon

for the common calendar, all four inherited families and epsilon=1/10^7. The code has a fail-closed cap and tests the residual before returning. Beyond the empirical 3-iteration maximum, we obtain a **uniform rational termination theorem** for the frozen noise and time choices. Since the exact projected map is a `kappa`-contraction, the initial center is within `delta` of its fixed point and each rational-grid-quantized update differs from the exact projection by at most `zeta=1/(2*10^12)`. Hence at iteration n,

    ||x_n-x_inf|| <= kappa**n*delta + zeta/(1-kappa),
    rho_n/(1-kappa) <= (1+kappa)/(1-kappa)*(kappa**n*delta+zeta/(1-kappa)).

All four common-calendar contractions satisfy `kappa<1/5`. Thus after **at most 8 quantized updates** the last expression is less than `3.841*10^-9`, below `epsilon/10=10^-8`, independently of y. For the consecutive control `(0,1,2,3)`, all four `kappa<2/5` and **14 updates** yield a rational bound below `6.266*10^-9`, also below `epsilon/10`. The script checks these inequalities exactly and returns no uncertified output.

## 3. Explicit outer enclosure of the nonlinear feasible set

For observations y define the compact, nonempty under the stated true-parameter hypothesis, set

    S(y)={theta in B: ||F_S(theta)-y||_infinity <= epsilon}.

For any returned exact rational x_n with a-posteriori bound E_n, the preceding argument applies to *every* theta in S(y), so

    S(y) subset of B intersect product_i [x_{n,i}-E_n, x_{n,i}+E_n].

This defines a **fully rational outer enclosure** `I_i=[max(center_i-delta,x_{n,i}-E_n), min(center_i+delta,x_{n,i}+E_n)]`. Its computed coordinate midpoints `mu_i` form a second executable estimator. Every theta in S(y) satisfies the certified coordinatewise bound

    ||mu-theta||_infinity <= max_i (upper(I_i)-lower(I_i))/2 <= E_n.

**Critical distinction:** the endpoints of I are *outer* bounds on the unknown exact feasible-set extrema, NOT those extrema themselves. The point mu may be outside the nonlinear feasible set S(y); it is a certified parameter estimate but not necessarily a data-consistent solution. The first x_n itself also need not be in S(y). On the 160 frozen examples, the outer-midrange belongs to S(y) in 120 and fails one or more data constraints in 40. The true parameters are contained in all 160 certified outer intervals. Computing exact feasible-set extrema or a guaranteed feasible point with optimal worst-case cost remains OPEN.

## 4. Reproducible deterministic experiment

Eight true-parameter offsets per family (center, half-radius and full-radius patterns) times five fixed error sign patterns gives `4*8*5=160` synthetic cases. This corpus was selected *after* NTK-OBS-07, is **not preregistered or an unseen holdout**. The noise signs, applied in query order, are zero, all positive, all negative and two alternating patterns. All truths are in their specified boxes. Entire input, computing, interpolation, projection, clamping, stopping decisions and outputs are evaluated using `fractions.Fraction`; only timing instruments and illustrative decimal renderings are non-rational.

For the four boxes on calendar (0,1,2,5):

| Box | Q (approx) | Max projection iterations | Max observed error x_n | Max observed error outer midrange | Max observed Prony error (different calendar) |
|---|---:|---:|---:|---:|---:|
| A | 23.7361 | 3 | 2.104e-6 | 2.230e-6 | 5.032e-6 |
| B | 8.5549 | 3 | 8.202e-7 | 8.374e-7 | 1.273e-6 |
| C | 6.5093 | 3 | 5.260e-7 | 5.866e-7 | 1.065e-6 |
| D | 57.8859 | 3 | 4.729e-6 | 5.248e-6 | 6.479e-6 |

These are **maximum observed errors over 40 synthetic test cases per box**, not probability bounds. The theorem's `E_n` bounds are validated on each case and do not depend on these finite tests. An additional projected-estimator control at the consecutive Prony calendar uses **the identical four measurements** as Prony (see `results.json`), allowing algorithm-dependent differences to be distinguished from time-calendar differences. Neither method is shown to attain the best four-parameter minimax constant.

## 5. Runtime measurement and the price of certification

`benchmark.py` performs five local passes over the same 160 frozen cases, with method order rotated. It uses `time.perf_counter_ns` and records environmental metadata in `benchmark.json`. One indicative run on the current container reported medians around:

| Method | Median per case |
|---|---:|
| Prony consecutive (exact Fraction + square-root isqrt bracket midpoint) | 0.0309 ms |
| Projected consecutive, preparation cached | 0.2316 ms |
| Projected (0,1,2,5), preparation cached | 0.2504 ms |
| Projected (0,1,2,5), recomputed preparation each call | 0.6245 ms |

These values are **not certified, not portable, not an independent performance benchmark, and not complexity estimates**. The projected estimator is slower in this implementation even with the four inverse matrices precomputed, but delivers a smaller sufficient error bound on the examined boxes. An explicit Prony root is approximated with rational midpoint of an isqrt-enclosed square root; such rounding is distinct from the ideal exact Prony theorem in NTK-OBS-06. Both algorithms have four moments, different horizon unless using the consecutive projected control.

For the abstract previously used score `J=N+T/4` (excluding coding, solver preparation, wall-clock and other costs), the consecutive four-query calendar costs 19/4 and (0,1,2,5) costs 21/4. No economics-of-certification improvement is proved. Better error constants alone are *not* better all-in cost.

## 6. Prior art, negative findings and open questions

**Classical**: Banach contraction and a-posteriori residual inequalities, nonlinear sensitivity via Jacobian inverse and Neumann estimates, projection onto closed convex boxes, Prony and Hankel reconstruction, interval and set-membership inverse problems. The related work of Batenkov and Yomdin already analyzes local accuracy of Prony-type systems and emphasizes the possible gap between classical algorithms and optimal local recovery; see `REFERENCES.md`. This internal combination and concrete benchmark does not claim new general theory.

**Precisely established here** (conditional internal mathematical argument + rational replay): an executable quantized projected estimator with full-output a-posteriori certificate `Q epsilon + rho/(1-kappa)`; exact rational outer enclosure of every feasible parameter; a distinct midpoint-of-outer-enclosure estimate; 160 deterministic cases independently recomputed in-package; host-specific timing. **Not established**: exact feasible extrema, guaranteed feasible projected point or midpoint, optimal or lower-complexity nonlinear solver, general NTK training accuracy, four-node/higher rank, machine floating point behavior, unknown box, unknown rank, drift, randomized measurement noise, third-party review or novelty.

**Release boundaries**: research-only; no main merge; public unreviewed Zenodo archive only subject to separately verified licence, authorship, private-content, integrity, metadata and frozen-version gates. Outside referee OPEN. No DOI created.
