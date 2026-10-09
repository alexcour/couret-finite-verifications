# CU-BRUIT-01 LIMIT-03 — independent numerical contour audit

Date: 2026-10-09. R=RESEARCH, L=WORKING, N=CLASSICAL PRIOR ART, E=CONDITIONAL (GRH and LI-type random model) for mathematical law; E=NUMERICAL for all numerical outputs. No claim of RH, novelty, rigorous zero completeness, or certified density. Leave original CU-BRUIT-01 protocol and RUN-01 unchanged.

## New independent checks

For each of the seven non-principal Dirichlet characters underlying modulus 30, sample L(s,chi) along a counterclockwise rectangle Re(s) in [0.10,1.45], Im(s) in [0.15,T]. A phase-unwrapped argument-principle numerical winding number gives the following counts:

| character j,k | T=25 (step 0.10) | T=40 (step 0.16) |
|---|---:|---:|
| 01 | 8 | 15 |
| 02 (chi5) | 8 | 16 |
| 03 | 8 | 16 |
| 10 | 6 | 13 |
| 11 | 12 | 23 |
| 12 | 13 | 23 |
| 13 | 12 | 22 |
| TOTAL | 67 | 128 |

The totals match the previous critical-line Hardy-Z sign-scan lists: 67 at T=25 and 128 at T=40. The maximal single sampled phase change on the finer contours was 0.8541 radians (T=25) and 0.9248 radians (T=40). A second numerical contour grid at T=40 step 0.55 gave the same integer counts, although its largest phase jump approached pi and is not independently persuasive. Original root lists also satisfy |L(1/2+i gamma,chi)| < 1e-11 using a separate mpmath.dirichlet evaluation.

CRITICAL LIMITATION: sampled winding is not a mathematical certificate of the argument principle because rapid unobserved phase rotations may occur between points. The independent scans increase confidence but cannot rule out missed zeros or noncritical zeros rigorously. Use a Turing method, interval-arithmetic argument principle, or another theorem-backed count for Q=CERTIFIED.

## Numerical inversion and analytical cutoff

The exploratory model has mean -1, variance V=3.203007082327546; the quadratic character chi5 accounts for 43.990305% of variance. Conditional on exact zero lists, replace the tail beyond T by a normal variable of variance v_T. Two independent numerical integrations (scipy adaptive quad and Simpson on 30,001 equally spaced samples over t in [0,30]) agree:

T=25: p_T=0.2894388783947715, v_T=0.7908925526496242, numerical quadrature agreement 1.2e-16, Berry-Esseen tail approximation bound 0.12825448, indicative band [0.1611844, 0.4176934].
T=40: p_T=0.2894468718426135, v_T=0.5492368605721154, numerical quadrature agreement 5.6e-17, Berry-Esseen bound 0.09620206, indicative band [0.1932448, 0.3856489].

For the Gaussian-tail **proxy integrand**, |prod_i J0(a_i t)| <= 1 and the omitted inversion-integral segment after Q=30 is bounded by exp(-v_T*Q^2/2)/(pi*v_T*Q^2), giving approx 1.22e-158 at T25 and 2.96e-111 at T40 based on numerical v_T. This only controls the analytic integration cutoff for the proxy; not floating point quadrature rounding, missed zeros, errors in B(chi), or Berry-Esseen error.

Bug audit: LIMIT-02 local derive.py uses min(0.5,p+be) instead of the generally correct min(1,p+be) in the probability-range clip; not binding for T25/T40. Future code should use min(1,...).

Finite observed RUN-01 delta+≈0.20764 up to 10^9 remains a finite-window occupation rate; it must not be used as the asymptotic density. There is no newly established Couret-specific arithmetic effect.

## Reproduction gate and files

Place supporting scripts and machine-readable counts under research/experiments/cu_bruit/. Reproducibility prerequisites: Python 3.12, mpmath, NumPy, SciPy. Run independent contour scans using fixed heights and steps, compare to historical critical-line roots, then integrate using two methods. The checker is numerical and is explicitly not a root completeness certificate.

Next gate: rigorous zero count by Turing/interval technique; enclose B(chi) and the quadrature interval using certified arithmetic; only then claim a conditional numerical *interval* for delta+. No changes to the frozen protocol, no merge or stable release implied.

Sources: CU-BRUIT-01 frozen Drive doc 1g6VWcKMFUE0CN0OH-ZAVf6KwgwVE8LG8PQbLdFq4NUg ; LIMIT-02 Drive 1QK6xTqYwGD2eMFTyGKkmWVAH4udXZkDcTyelsGaYhPo ; Rubinstein-Sarnak (1994); Berry-Esseen (classical).
