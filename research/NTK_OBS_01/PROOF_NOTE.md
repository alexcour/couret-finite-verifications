# NTK-OBS-01 — Mathematical note and proof obligations

## Statement and scope

Let `K` be a real symmetric positive semidefinite `n x n` matrix, `e0` a fixed real vector, and `P_lambda` the orthogonal spectral projector onto the eigenspace of eigenvalue `lambda`. Put `w_lambda = ||P_lambda e0||^2 >= 0`. All sums below run over **distinct** eigenvalues and have finite support.

### Proposition A — Continuous loss observability (classical)

For `e'(t)=-K e(t)` and `L(t)=||e(t)||^2/2`, spectral calculus gives

`2L(t) = sum_lambda w_lambda exp(-2 lambda t)`.

Consequently, the loss depends on the pair `(K,e0)` only through the **weighted spectral measure** `mu = sum_lambda w_lambda delta_lambda`. In finite dimension two such curves agree for all `t>=0` iff their weighted spectral measures agree (linear independence of distinct exponentials; also uniqueness of finite Laplace transforms).

**Important:** the multiset of eigenvalues without `w_lambda` is not sufficient to determine a task-conditioned loss curve. Example: `K1=diag(1,4)`, `K2=diag(4,1)`, both with `e0=(1,0)` have `L1(t)=exp(-2t)/2`, `L2(t)=exp(-8t)/2`, though their unweighted spectra coincide. If `e0` is also swapped to `(0,1)` for `K2`, the curves agree.

### Proposition B — Discrete loss and observation alias (classical)

With `e[k+1]=(I-eta K)e[k]` and `eta>0`, spectral calculus yields

`2L[k] = sum_lambda w_lambda (1-eta lambda)^(2k) = sum_q v_q q^k`,

where `q=(1-eta lambda)^2` and `v_q` aggregates the weights for all eigenvalues mapping to `q`. Thus the full scalar loss sequence identifies at most the pushforward measure `nu=(q_eta)_* mu`, not necessarily `mu` itself. In finite dimensions equality of all moments `sum v_q q^k` is equivalent to equality of the discrete pushforward measures (subtract and use a Vandermonde system for the finite union of nodes).

The reflection `lambda -> 2/eta - lambda` leaves `q` unchanged. For `eta=1`, `lambda_A=1/2` and `lambda_B=3/2` both produce `q=1/4`. With `e0=1`, their losses are the same for every `k>=0`, namely `L[k]=(1/2)(1/4)^k`, yet their states after one step are `+1/2` and `-1/2`. Both scalar updates are stable in magnitude. **This is an information-theoretic obstruction under the scalar observation map, not a claim about two trained neural networks.**

### Proposition C — Two-atom exact identification (classical Prony)

Suppose `m_k = w1*q1^k + w2*q2^k`, where `w1,w2>0`, `q1 != q2`, and all four samples `m_0,...,m_3` are given exactly. Then the Hankel determinant satisfies

`m0*m2-m1^2 = w1*w2*(q1-q2)^2 > 0`.

Solve the two equations `m2=s1*m1-s2*m0`, `m3=s1*m2-s2*m1` uniquely for `(s1,s2)`, and recover `q1,q2` as the distinct roots of `z^2-s1*z+s2`. The two weights follow from the invertible Vandermonde system `[1,1; q1,q2] [w1,w2]^T = [m0,m1]^T`.

For `eta=1/2`, `K=diag(1/2,1)`, `e0=(1,2)`, one gets:

- `q1=9/16`, `q2=1/4`, `w1=1`, `w2=4`;
- `m0=5`, `m1=25/16`, `m2=145/256`, `m3=985/4096`;
- `s1=13/16`, `s2=9/64`.

One may recover the underlying eigenvalues as `lambda=(1-sqrt(q))/eta` **only if the positive branch `0<eta*lambda<1` is known a priori**. Without this branch restriction, the reflection ambiguity of Proposition B remains.

Three samples alone do not determine this particular positive two-node model: an alternative with nodes `(1/2,11/48)` and weights `(20/13,45/13)` has exactly the same `m0,m1,m2`, but `m3=2875/12288`, different from `985/4096`.

### What this does *not* establish

These statements follow classical spectral calculus and Prony's method. They are not presented as new. They are **not** a result about time-varying kernels, nonlinear networks, adversarial observation errors, robustness to noisy samples, or a minimax optimal sampling policy. The required next theorem must state an additional restricted observation model before any originality question is meaningful.