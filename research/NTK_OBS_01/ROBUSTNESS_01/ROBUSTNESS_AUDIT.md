# NTK-OBS-01 / ROBUSTNESS-01 - Exact perturbation bounds for two-mode Prony recovery

**Date:** 2026-10-11. **Status:** INTERNAL MATHEMATICAL AUDIT / NOT EXTERNALLY REVIEWED.
**Parent project:** NTK-OBS-01 (fixed symmetric PSD kernel, scalar loss observations).
**Scope:** real nodes `0<q2<q1<1`, strictly positive weights, four scalar moments, deterministic absolute observation error. No stochastic, time-varying, nonlinear-network, or general-learning claim.

## 1. Observation model, inherited from NTK-OBS-01

For the *fixed-kernel* discrete dynamics `e[k+1]=(I-eta*K)e[k]`, let `m_k=2L[k]`. In the two-active-mode case,

    m_k = w1*q1^k + w2*q2^k,  k=0,1,2,3,
    q_i=(1-eta*lambda_i)^2,  w_i>0.

Measurements are `y_k=m_k+e_k` with `|e_k|<=epsilon` independently for `k=0,...,3`. This is a **worst-case** absolute error model. A noise bound `epsilon_L` on each loss `L[k]` corresponds to `epsilon=2*epsilon_L` for `m_k`.

We distinguish the **observable nodes** `q_i` from the physical kernel eigenvalues `lambda_i`. The latter are recovered as `(1-sqrt(q_i))/eta` only with the *a priori* branch restriction `0<eta*lambda_i<1`. Otherwise the exact reflection alias `lambda -> 2/eta-lambda` remains even without noise.

## 2. Exact Hankel inverse and perturbation

Define

    H = [[m0,m1],[m1,m2]],   b = [m2,m3]^T,
    c = [-s2,s1]^T,          H*c=b,
    s1=q1+q2, s2=q1*q2,
    D=det(H)=m0*m2-m1^2=w1*w2*(q1-q2)^2>0.

Thus

    s1=(m0*m3-m1*m2)/D,
    s2=(m1*m3-m2^2)/D.

For `y=m+e`, let `Htilde=H+E`, `btilde=b+f`. Then

    E = [[e0,e1],[e1,e2]], f=[e2,e3]^T,
    ||E||_2 <= 2*epsilon, ||f||_2 <= sqrt(2)*epsilon <= 2*epsilon.

The exact determinant perturbation is

    Dtilde-D = m0*e2+m2*e0-2*m1*e1+e0*e2-e1^2,
    |Dtilde-D| <= (m0+m2+2*m1)*epsilon+2*epsilon^2,

because `m0,m1,m2>=0` for positive weights and nodes. Also `H=V*diag(w1,w2)*V^T` with `V=[[1,1],[q1,q2]]` is positive definite. Since `lambda_max(H)<=tr(H)`, the rational quantity

    h0 := D/(m0+m2) <= lambda_min(H)

is a positive lower bound. If `2*epsilon<h0`, Weyl's inequality gives `lambda_min(Htilde)>=h0-2*epsilon>0`.

Put `C=|s1|+|s2|` and

    rho = (2+2*C)*epsilon/(h0-2*epsilon).

Since `||c||_2<=C`, solving the perturbed system gives the certified bound

    ||ctilde-c||_2 <= rho,
    |s1tilde-s1|<=rho, |s2tilde-s2|<=rho.                 (A)

*Proof:* `Htilde*(ctilde-c)=f-E*c` and `||Htilde^(-1)||_2<=1/(h0-2*epsilon)`. The terms above are bounded by `2*epsilon` and `2*epsilon*C`, respectively. All constants here are conservative; no optimality claim.

## 3. Sufficient recovery/stability certificate (elementary internal specialization)

Let `d=q1-q2>0`, `W=w1+w2=m0`, `wmin=min(w1,w2)`, and define

    gamma = (2*|s1|+4)*rho + rho^2,
    R = (rho + gamma/d)/2,
    B = (2*epsilon+W*R)/(d-2*R).

Assume the **explicit inequalities**

    (i)   2*epsilon < h0,
    (ii)  gamma < d^2,
    (iii) R < min(q2,1-q1,d/2),
    (iv)  B < wmin.

Then the four noisy measurements, inverted by ordinary two-node Prony, determine **two distinct real nodes** `qtilde1>qtilde2` in `(0,1)`, with **positive** weights. Labelled errors obey

    |qtilde_i-q_i| <= R,    |wtilde_i-w_i| <= B.          (B)

If also the positive branch for `lambda_i` is known, `eta>0` is known and `q2>R`, then

    |lambdatilde_i-lambda_i|
      <= R/(2*eta*sqrt(q2-R)).                             (C)

**Proof of (B):** The discriminant of `z^2-s1*z+s2` is `d^2`. From (A),

    |Delta_tilde-d^2| <= 2*|s1|*rho + rho^2 + 4*rho = gamma.

Assumption (ii) ensures `Delta_tilde>0`, and

    |sqrt(Delta_tilde)-d| <= gamma/d.

The quadratic formula gives `|qtilde_i-q_i|<=(rho+gamma/d)/2=R`. Assumption (iii) keeps nodes strictly ordered within `(0,1)`. To bound weights, set `u_i=wtilde_i-w_i`; the two Vandermonde equations yield

    u1+u2=e0,
    qtilde1*u1+qtilde2*u2=e1-sum_i(w_i*(qtilde_i-q_i)).

Since `|qtilde_i|<1`, `|u_i| <= (2*epsilon+W*R)/(d-2*R)=B`. Assumption (iv) ensures positive weights. Formula (C) follows from `|sqrt(x)-sqrt(y)|=|x-y|/(sqrt(x)+sqrt(y))` and both arguments at least `q2-R`.

**Meaning:** This is a sufficient bound for *all* real error vectors within the cube `|e_k|<=epsilon`, not a claim of necessity, sharpness, or universal stability. Proof is elementary matrix perturbation plus quadratic algebra, situated within classical Prony conditioning theory.

### Uniform restricted-class corollary

Suppose `a<=q2<q1<=b<1`, `q1-q2>=delta>0`, `w_i>=w_*>0`, `W<=W_*`, with `a>0`. Then

    h0 >= H_* := w_*^2*delta^2/(2*W_*),   |s1|+|s2|<=3.

A fully class-uniform sufficient certificate is obtained by replacing `h0` by `H_*`, `C` by `3`, `d` by `delta`, `W` by `W_*`, `q2` by `a`, and `1-q1` by `1-b` in (i)-(iv):

    rho_* = 8*epsilon/(H_*-2*epsilon),
    gamma_* = 8*rho_* + rho_*^2,
    R_* = (rho_*+gamma_*/delta)/2,
    B_* = (2*epsilon+W_*R_*)/(delta-2*R_*).

If `2epsilon<H_*`, `gamma_*<delta^2`, `R_*<min(a,1-b,delta/2)` and `B_*<w_*`, errors in (B) are bounded by `R_*` and `B_*`, uniformly over that class. Branch-restricted eigenvalues satisfy (C) with `q2-R` replaced by `a-R_*`. This demonstrates how **node separation, minimum weights, total mass control, and a branch gap** provide sufficient stability; it does not quantify optimal noise tolerance.

## 4. Exact certificate for the original NTK-OBS-01 instance

Original: `eta=1/2`, `(q1,q2)=(9/16,1/4)`, `(w1,w2)=(1,4)`, with

    (m0,m1,m2,m3)=(5,25/16,145/256,985/4096),
    D=25/64, d=5/16, s1=13/16, s2=9/64,
    h0=D/(m0+m2)=4/57.

At **epsilon=1/1,000,000** on *each* `m_k`, the pure-rational script verifies all four sufficient inequalities with exact `Fraction` operations. The exact certificate includes

    rho  = 7125/127996352,
    R    = 1082979287625/2047883265663488,
    R < 1/1000,
    B < 1/50,
    |lambdatilde_i-lambda_i| < 3/1000  (positive branch).

The `1/1000`, `1/50`, `3/1000` are valid **universal upper bounds** for this baseline and noise radius, not observed errors. For illustration, the code also runs `3^4=81` deterministic corner/center perturbation patterns `e_k in {-epsilon,0,+epsilon}` using **outward rational square-root intervals** with grid precision `10^-18`. It verifies positive reconstructed nodes and weights for those 81 patterns, and reports their interval-enclosed maxima. This finite sweep does **not** replace the all-errors analytic proof.

## 5. Counterexample: positive two-mode models become observationally indistinguishable

Fix `a=1/2`, `0<d<1/4`, and equal weights `1/2,1/2`. Set

    A_d: q=(a+d,a-d),
    B_d: q=(a+2d,a-2d).

Both have strictly positive weights and two distinct nodes in `(0,1)`. Direct binomial expansion yields

    m0^A=m0^B=1, m1^A=m1^B=a,
    m2^B-m2^A=3*d^2,
    m3^B-m3^A=9*a*d^2=(9/2)*d^2,
    D_A=d^2, D_B=4*d^2.

Their ordered-node matching distance is exactly `d`, while their `l_infinity` four-moment distance is `(9/2)*d^2`. The midpoint observation vector lies within an `epsilon_d=(9/4)*d^2` error ball of both models. Therefore **any deterministic estimator**, given only those four observations and that noise bound, has an error of at least `d/2` for at least one of the two possible models. The lower bound divided by `epsilon_d` is `2/(9d)` and tends to infinity as `d->0`. There is no Lipschitz constant uniform in separation over all positive two-mode models. More strongly, this construction gives an inverse-problem lower modulus of order `sqrt(epsilon)` along the family (not a statement of its global minimax rate).

For `d=1/1000`, `epsilon_d=9/4,000,000=0.00000225`, matching node distance `0.001`, and at least one estimator-model error `>=0.0005`.

### Rank-collapse example

For `a=1/2`, weights `(1/2,1/2)` and nodes `(a+d,a-d)`, the exact moments are

    (1, a, a^2+d^2, a^3+3*a*d^2).

Perturbing only the last two entries by `-d^2` and `-3*a*d^2`, with maximum error `(3/2)*d^2`, produces the *one-node* moments `(1,a,a^2,a^3)`. The perturbed Hankel determinant is **zero**, so unmodified two-node Prony divides by zero. At `d=1/1000`, the noise needed is `3/2,000,000`. This demonstrates failure of the raw inversion; it is not a claim that all regularized or constrained estimators fail equally.

## 6. Reproduction and status

From this folder, run `sh verify_robustness.sh`. The standard-library-only Python script uses exact rational moment arithmetic, exact rational inequalities and integer-square-root *outward* enclosures for radical roots; it regenerates `robustness_results.json`. The wrapper checks output identity using SHA-256. Archive and manifest make inputs self-contained. The 81 perturbations and the six collision cases are deterministic examples, not random evidence nor an external replication.

**CLASSICAL / PRIOR ART:** spectral representation of fixed-kernel losses; the two-node Prony/Hankel inversion; the mathematical ill-conditioning as nodes coalesce; standard inverse matrix perturbation estimates. For context see D. Potts & M. Tasche (2013), DOI `10.1016/j.laa.2012.10.036`, and D. Batenkov & Y. Yomdin (2013), DOI `10.1137/110836584`.

**INTERNAL RESTRICTED DERIVATIONS:** explicit sufficient constants (A)-(C) for this observation map; uniform-class specialization; the simple symmetric two-model and rank-collapse examples; exact checks and interval implementation. No claim of originality or priority; these are independently auditable derivations, not independently audited results.

**OPEN:** optimal minimax noise rate/constant and methods; more than two modes; unequal observation times; statistically structured or correlated errors; optimal measurements/adaptivity; floating-point implementation with verified rounding; kernel drift/nonlinearity; external replication and independent proof review.

**GATE:** E = elementary mathematical argument + local exact checks; Q = local deterministic replay; N = no novelty claim; R = external review OPEN. **NO-GO** for theorem priority, release claims, DOI, or merge to main until separate review.
