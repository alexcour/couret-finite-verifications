# EXP-06 — Frozen audit of full, diagonal and off-diagonal spectral contributions

**Pre-registered 2026-10-08, BEFORE executing EXP-06.** Research branch only; no RH claim. EXP-06 is a diagnostic, not a confirmatory significance test.

## Fixed corpus
- Exactly EXP-02 pilot windows P=100,200,400 with P<p<=2P and gcd(p,30)=1; X/P=8,16.
- q=7,11,13,17, all fixed, coprime with 30.
- Both inverse (a_n=mu(n) for gcd(n,30)=1) and plain (a_n=1 for gcd(n,30)=1), zero otherwise.
- Fixed tent W(t)=max(0,1-2*abs(t-1.5)) for t in [1,2], 0 otherwise.
- For each p,X, and h with n=pm+30h>0, b_h=sum_m a_n*a_m W(n/X) W(pm/X).
- The diagonal L=b_0; the complete sequence includes h=0; the offdiagonal excludes h=0.

## Fourier diagnosis, equations frozen
For q, packet H_r=sum_{h==r (mod q)}b_h; FFT F_j=sum_r H_r exp(-2pi i j r/q). Let B_j=F_j-L for all j. Independently calculate B by FFT of offdiagonal packets; check max absolute identity error <=1e-8*max(1,max|B|) and Parseval relative error <=1e-10.
For inverse, L<=0 and D=-L>=0; for plain, L>=0.
Let Q_nonzero(Z)=sum_{j=1}^{q-1}|Z_j|^2 and Q_all(Z)=sum_{j=0}^{q-1}|Z_j|^2. Exact energy audit:
 Q_nonzero(B) = Q_nonzero(F)+(q-1)|L|^2-2 Re(conj(L)*sum_{j=1}^{q-1} F_j).
Report all terms including the interference term, which may have either sign.
diag_amp_ratio=sqrt(q-1)*abs(L)/sqrt(Q_nonzero(B)) (null when denominator zero).
Primary M1_off=max_{j>0}|B_j|^2/Q_all(B); M1_full=max_{j>0}|F_j|^2/Q_all(F), defined zero when denominator zero. Primary paired delta_M1=M1_off-M1_full. Secondary zero_share_off, zero_share_full, relative_L2_change=sqrt(q-1)*abs(L)/sqrt(Q_nonzero(F)) (null on zero denominator), diag_amp_ratio, energy contributions. Descriptive only.

## Character controls
For every P, X/P, q and kind, compute unweighted mean(plus)-mean(minus) for chi3, chi5, chi15 applied separately to M1_off, M1_full, delta_M1 and diag_amp_ratio. Report the 24 regime/q contrasts per kind and aggregate mean absolute contrast and number of cases where |chi5 contrast| exceeds both others for M1_off and delta_M1, as well as sign count. Plain and inverse separate. No changing windows, q, metrics or controls after seeing data. No p-values or inference of causality.

## Quality and interpretation
- Independently verify factorized Fourier T79 for the first p in each prime window, both ratios and kinds, each q and all j, with relative tolerance 1e-8. Verify the exact C_p product over 8 residue classes and L=b0 for the same cases.
- Abort interpretation on failed checks. Save raw JSON, CSV, source and result SHA-256, report. Results must be reproducible.
- Historical EXP-02 and separate frozen EXP-02C remain unchanged.
- A material diagonal effect is a spectral bookkeeping finding, not a power-saving theorem. A chi5 contrast in the diagonal term is not a Couret-specific cancellation theorem. Truly restricted h-windows belong to a future experiment.

## Claim boundary
Exact spectral identities [D]. EXP-06 finite diagnostics [E]. Growing-q uniform cancellation [O]. Couret-specific advantage [O/non-confirmed]. RH/zero-free: NO CLAIM.
