# BRIDGE-08C — cyclotomic obstruction and spectral-rank audit (frozen before numerical checks)

**Status:** deterministic algebraic counterexample to a *generic* uniform T89 inequality; not an arithmetical counterexample for Möbius. Classical ingredients only; no priority, RH, zero-free region, or power-saving claim.

This study follows T81–T93 and the already existing T86–T89 uniformity no-go. It was designed after earlier empirical outcomes; not a prospective or inferential test of a Möbius claim.

## Exact objects and theorem target

For integer Q >= 7, F*_Q = {a/q mod1: 2 <= q <= Q, gcd(q,30)=1, gcd(a,q)=1}, M_Q = #F*_Q = sum phi(q), and K_Q(d) = sum_{alpha in F*_Q} exp(-2pi*i*alpha*d). For a real nonzero vector b on N consecutive shift coordinates h=1,...,N (h=0 excluded), let E=sum_h b_h^2, D_Q(b)=[sum_{alpha in F*_Q}|sum_h b_h exp(-2pi*i*alpha*h)|^2]/(M_Q E).

**T94 candidate, algebraic [D]:** if N>=M_Q+1, C_Q(z)=prod_{2<=q<=Q,(q,30)=1} Phi_q(z) in Z[z], deg(C_Q)=M_Q and C_Q has all F*_Q roots. For k=N-M_Q-1>=0, choose B(z)=z*C_Q(z) for k=0, and z*C_Q(z)*(1+z^k) for k>0. Its nonzero integral coefficients b_h occupy [1,N] with both endpoints nonzero and satisfy D_Q(b)=0 exactly.

**T95 candidate, algebraic [D]:** The real symmetric Gram matrix G=[K_Q(h-k)]_{h,k=1..N} is PSD, has rank <=M_Q and trace N*M_Q. Thus its normalized Rayleigh quotient D_Q has a zero eigendirection when N>M_Q, and a real positive eigendirection D_Q>=N/M_Q when rank<=M_Q. For Q²<=N, M_Q<=Q(Q-1)/2 < N/2, hence the generic D_Q can be exactly zero OR exceed 2. This does not imply that Möbius-generated b has either behavior.

**T96 candidate, algebraic [D]:** Q=7 gives M=6 and K_7(d)=6 if 7|d, -1 otherwise. For any N divisible by 7, b_h=K_7(h) for h=1..N attains D=N/6 exactly. For N=49, D=49/6, and cyclotomic null vector b_h from z*(1+...+z^6)*(1+z^42) has D=0 exactly with endpoints nonzero.

**T97, methodological [M]:** The T89 estimate with epsilon->0 cannot follow from Fourier geometry and large sieve alone for arbitrary real sequences at Q²~N; the required information must be special to the Möbius-generated vectors or stronger declared structural hypotheses. The existing T89 remains [O] for those vectors. These null directions are classical cyclotomic and rank facts, not a novel theorem.

## Frozen finite validation

Choose Q=[7,11,13,17,23,29,49] and N=Q² (also confirm N>=M_Q+1). Build integer cyclotomic polynomials recursively by *exact monic polynomial division* from x^n-1 = prod_{d|n} Phi_d(x). Construct B(z), and for every allowed q verify B(z) divisible by Phi_q(z) over integers. Independently compute the *integer* Ramanujan Gram quadratic form sum_{h,k} b_h b_k K_Q(h-k): require exactly 0, and exact offdiagonal sum exactly -M_Q*E.

Verify K_Q(0)=M_Q, max-supported degree and nonzero boundary coefficients, M_Q < N/2. For Q=7,N=49, verify explicit positive comparator b_h=K_7(h), energy 6N, quadratic energy M_Q N², and D=N/M_Q exactly using rational arithmetic. Optional float Fourier evaluations are diagnostics only and do not supersede integer identities.

Retain all failures, print per-Q M,N, nonzero coefficient count, E, exact null, SHA256 of the script/result, and mark results separately from theory. No adjustment of Q after inspection, no re-running a prior EXP as a new positive result.
