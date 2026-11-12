# NTK-OBS-01 — Loss observability under fixed kernels (11 October 2026)

**Status: bounded exact rational check PASS; classical mathematics; external review OPEN; novelty NOT claimed; publication gate CLOSED.**

This archive follows the critical synthesis on formal proofs, Hilbert–Pólya, and mathematical theory of artificial intelligence. It addresses a precise, **fixed positive-semidefinite kernel** model, not general adaptive neural networks or nonlinear training. The model is

- continuous gradient flow: `e'(t) = -K e(t)`, `L(t) = ||e(t)||²/2`;
- discrete gradient descent: `e[k+1] = (I-eta*K) e[k]`, `L[k] = ||e[k]||²/2`.

## Four verified claims (within the stated model)

1. **Cospectral kernels need not have equal loss curves for a fixed task.** `K1=diag(1,4)` and `K2=diag(4,1)` share eigenvalues, but for `e0=(1,0)` the continuous losses are `e^(-2t)/2` and `e^(-8t)/2`. For rational `eta=1/8`, the discrete losses also differ for every step `k>=1`. Rotating `e0` along with the kernel restores equality.
2. **Discrete scalar loss can be permanently blind to distinct eigenvalues.** At `eta=1`, scalar `K_A=[1/2]`, `K_B=[3/2]`, `e0=[1]`, the losses coincide for **all** integer `k>=0`: `L[k]=(1/2)(1/4)^k`. At odd steps the states have opposite signs. This is not an NTK-specific discovery: it follows directly from squaring the gradient update.
3. **A weighted spectral measure is the sufficient observable for loss.** For symmetric `K`, the continuous loss is one-half of the Laplace transform of the spectral measure of `(K,e0)`. In discrete time, the loss depends only on its pushforward by `q_eta(lambda)=(1-eta*lambda)^2`.
4. **Four exact scalar samples recover a two-active-mode discrete loss model.** Given exactly two distinct nodes `q_j` with positive weights and exact samples `m_k=2L[k]`, `k=0,1,2,3`, the classical Prony/Hankel method recovers the two `q` values and weights. Here `q=(9/16,1/4)` and `w=(1,4)`. Three samples do not uniquely identify this example: a second positive two-node measure yields the same first three moments but a different fourth.

## Replay

Requirements: Python 3.10+ standard library; optionally `sha256sum` for manifest verification.

```sh
bash verify.sh
```

Manual verification:

```sh
sha256sum -c SHA256SUMS
python3 -m unittest discover -s . -p 'test_*.py' -v
python3 verify_ntk_obs_01.py --check results.json
```

All computed quantities are exact `fractions.Fraction`. The recorded scripts execute bounded checks (`k=0..12`, plus an independent test family). Algebraic proofs covering all `k` are supplied in `PROOF_NOTE.md`; execution of finitely many cases is not itself a proof of a universal identity. Tests and generator were written in the same working session; **this is internal cross-checking, not an independent external audit.**

## Scientific boundaries

- No claim of new theorem, novelty, or precedence. Classical mechanisms: spectral theorem, Laplace sums, moment problem, Prony's method, and fixed-NTK dynamics.
- Does not address stochastic gradients, dynamic NTK, nonlinear feature learning, generalization, or full model observability.
- No Lean or other proof-assistant formalization has been performed.
- Relative status: Q (local exact replay) PASS; E (elementary proof with no independent referee) INTERNAL; N (novelty) NONE CLAIMED; R (external review) OPEN.

See `PROOF_NOTE.md`, `PROTOCOL.md`, `CLAIM_BOUNDARY.md`, and `REFERENCES.md`.