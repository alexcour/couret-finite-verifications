# T106–T109 — Exact prime-parity covariance; failure of second-moment shortcut

**Status: [D] elementary exact identities, [N] finite data, [M] negative methodological conclusion. Branch research only, no claim of novelty, RH, or power saving.**

## T106 [D] — prime-parity signatures
For squarefree m,n let `t=mn/gcd(m,n)^2`. If prime signs ε_l are independent Rademacher and `f(n)=mu(n)^2∏_{l|n} ε_l`, then `f(n)f(m)=ε(t)`. Since μ is itself a product of -1 over distinct prime factors of a squarefree integer, `μ(n)μ(m)=μ(t)`. Both statements hold only when both m,n are squarefree; otherwise coefficients are zero.

## T107 [D] — exact covariance packets
Group all admissible weighted pairs n=pm+30h by t, defining the integer nonnegative packet weights `c[h,t]`. Then `B_h(f)=Σ_t c[h,t]ε(t)`, and exact orthogonality gives `E[B_h(f)B_k(f)]=Σ_t c[h,t] c[k,t]`. Consequently `Ebar=Σ_{h,t}c[h,t]^2`, `Nbar=Σ_{h,k,t}K_Q(h-k)c[h,t]c[k,t]`. The surrogate ratio of quadratic expectations is `ρ=Nbar/(M Ebar)`; this is **not** the expectation of `D=quadratic numerator/(M energy)`.

## T108 [D] — exact decomposition of deterministic Möbius discrepancy
For true μ, define `Etrue=Σ_h (Σ_t c[h,t]μ(t))²` and `Ntrue=Σ_{h,k}K_Q(h-k)(Σ_t c[h,t]μ(t))(Σ_u c[k,u]μ(u))`. The differences `Etrue-Ebar` and `Ntrue-Nbar` are sums of cross-products for **distinct** prime-parity labels `t≠u`, signed by μ(t)μ(u). Exact control of these correlations, not only reuse of identical labels, is the remaining deterministic ingredient. A bound `Dtrue-ρ→0` would still require denominator control and explicit uniformity in p,Q,X.

## T109 [N/M] — finite audit and verdict
EXP-11 frozen protocol on GitHub commit `94fda41a`. 678 prime/scale configurations, 12 regime summaries. All four new ratio=32 means rho are 0.999407, 0.997158, 0.997204, 0.997957, whereas true Möbius means D are 0.959979, 0.923503, 0.964869, 0.994715. Both pre-frozen screens fail: `NO_STRONG_STRUCTURAL_SHIFT` and `NO_ROBUST_DETERMINISTIC_RESIDUAL`. Exact tests 300 naive Möbius, 100 Ramanujan vs Fourier, eight synthetic exhaustive sign models PASS. This *negative result* is not evidence for asymptotic cancellation, no Couret χ5 effect is claimed, and T89 remains [O].

## Files
`research/experiments/BRIDGE_EXP11_PRIME_PARITY_PROTOCOL.md`; `research/experiments/bridge_exp11.py`; `research/experiments/BRIDGE_EXP11_REPORT.md`. Machine-readable rows, summaries and SHA256 manifest in Drive experiment folder.
