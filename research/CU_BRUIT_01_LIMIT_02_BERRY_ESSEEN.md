# CU-BRUIT-01 LIMIT-02 | 2026-10-09

Status: research working note; conditional mathematics under GRH and LI-type assumptions; numerical experiments not certified; classical prior art; no RH claim. The frozen CU-BRUIT-01 protocol and its data remain unchanged.

## Model and analytic bound

The signed count is D(x)=5A(x)-3B(x) with S={1,11,29} among U(30). Its limiting random model under GRH+LI is X=-1+sum_i a_i cos(U_i), where the phases are independent uniform angles, a_i=2|h_i|/sqrt(1/4+gamma_i^2), |h_i|=3 for chi5 and 1 for six other characters. Variance V=3.203007082327546; chi5 accounts for 43.990305% of variance, not the probability of a positive sign.

For zeros above height T, write R_T=sum_{gamma>T} a_i cos(U_i), variance v_T, and replace R_T with a centered Gaussian having variance v_T. Since E|cos U|^3=4/(3*pi) and Var(cos U)=1/2, Berry-Esseen with constant 0.56 yields

sup_x |P(R_T<=x)-Phi(x/sqrt(v_T))| <= 0.56*8/(3*pi)*(6/sqrt(T*T+0.25))/sqrt(v_T).

The same bound applies after convolution with the low-zero sum and hence to the positive-sign probability. This assertion assumes the independent-phase model and an exhaustive split of zeros at T.

## Independent numerical replay

T=25, grid steps 0.25 and 0.10: 67 sign-crossing roots each, maximum paired-root difference 2.4e-12.
T=25: v_T=0.79089255265; Gaussian-tail proxy p_T=0.28943887839; Berry-Esseen penalty <=0.128255; conditional approximate band [0.16118,0.41770].
T=40, step 0.25: 128 sign-crossing roots; v_T=0.54923686057; p_T=0.28944687184; penalty <=0.096203; conditional approximate band [0.19324,0.38565].
The T=40 grid-step 0.10 check timed out and was NOT completed.

These are NOT rigorous numerical confidence intervals: neither completeness of zeros nor quadrature rounding has been certified. The quoted quadrature diagnostic is not an analytic error guarantee. The method is classical. Compare with historical finite-window delta+ approximately 0.20764 at x=1e9 only as an exploratory diagnostic, not a hypothesis test.

## Required next gates

Certify zeros through a valid counting argument, audit the complex conjugate character conventions, obtain interval-certified integration, and independently validate the B(chi) constants. Keep the frozen source intact; no public release or claim promotion.

References: Rubinstein-Sarnak (1994); Lamzouri arXiv:1101.0836; Shevtsova (2013), general Berry-Esseen bound 0.5583. Source Drive protocol ID 1g6VWcKMFUE0CN0OH-ZAVf6KwgwVE8LG8PQbLdFq4NUg.
