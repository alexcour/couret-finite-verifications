# COURET–OAI–BRIDGE–01 — EXP-09-SUPPORT-MASK (protocol frozen before new arithmetic computation)

**Status:** deterministic finite linear-algebra audit; research branch, no RH/novelty/power-saving claim. Prior EXP-05/07 outcomes and T81–T97 are known. Not an independent experimental validation.

## Mathematical question

T94–T97 show D_Q(b) need not approach 1 for *arbitrary* sequences. Does simply imposing the EXACT set S of nonzero shifts of the genuine Möbius residual remove that generic obstruction? The scope is specifically *support-only information*: all amplitudes/coefficients on S are allowed to vary. This does not test a bound for the actual Möbius amplitudes.

## Definitions frozen

Use the EXP-05 geometric construction: dyadic prime windows P<p<=2P, P in [100,200,400,800,1600], ratios X/P in [8,16]; tent window W(t)=max(0,1-2*abs(t-1.5)) on [1,2]; a_n=mu(n) for gcd(n,30)=1 and zero otherwise, with plain a_n=1 on units and squarefree a_n=abs(mu(n)) as geometry controls. Only nonzero shifts h are allowed: n=p*m+30*h, h!=0, both W(n/X) and W(p*m/X) positive.

Use INTEGER weight T_X(n)=2*min(n-X,2*X-n) for X<n<2X, else zero. Then b_h = B_h / X^2, where B_h=sum_m a_n*a_m*T_X(n)*T_X(p*m) is exactly integral. Determine S={h:B_h !=0} without floating error; s=|S|; Ngeom=max(h)-min(h)+1 from the PLAIN geometric support, shared across kinds. Q=integer >=7 coprime to 30 nearest sqrt(Ngeom), tie toward smaller. F*_Q and M=cardinality as in T81. No result-dependent Q or mask filtering.

**Primary fixed endpoint:** among all original (p,X) cells, fraction with s>M; report minimum and median s/M, all failures, including zero-vector cases, grouped by P, ratio. **Second endpoint:** fraction s>2M, for which elementary positive Rayleigh direction yields D>2. Record s_squarefree, s_plain, cancellations (s_squarefree-s_mobius), and mean ratio s/M. Do NOT treat prime cells as independent random trials, or report an inferential p-value.

## Exact support-mask lemma, derived before inspecting results

For every *fixed* nonempty set S of s integer shift positions and G_S=[K_Q(h-k)]_{h,k in S} with K from T81, G_S is real symmetric PSD, tr G_S=s*M, rank<=M. Hence if s>M there is a nonzero **REAL** vector supported INSIDE S with D_Q=0; also a real vector supported inside S with D_Q>=s/M. If s>2M, positive vector has D_Q>2. These vectors need not have the exact support S (some coefficients on S may vanish); nevertheless support-zero restrictions alone cannot rule them out. No claim that true mu vector is near either direction.

For Q=7, a concrete exact-null vector e_h-e_k exists whenever h,k in S and h congruent k mod7; the sampled pair is selected deterministically (lexicographically first). Its Fourier energy is EXACTLY zero. Check with integer K7(d)=6 if 7|d else -1. For Q>7 rely on the general rank lemma, not a fabricated numeric vector.

## Verification before data read

(1) independently verify mu up to n=300 against naive squarefree prime-factor counts; (2) verify integer tent W=T/X for small n; (3) 30 direct n,m exhaustive samples against batched h reconstruction, exact equality; (4) 100 direct c_q(d) Ramanujan checks against divisor expression; (5) confirm K(0)=M and integer PSD via sum-of-squares proof, no false numeric PSD claim; (6) verify Q selection, all prime windows and h!=0; (7) for every cell compare S_mobius subset S_squarefree subset S_plain as shift sets (note S_squarefree positivity for each eligible pair), and s<=Ngeom; (8) for Q=7 and s>7 find exact null pair certificate and check quadratic form equals 0.

## Verdict criterion frozen

If all sampled cells s>M, verdict "SUPPORT-ONLY NO-GO ON ENTIRE FROZEN PANEL"; otherwise "SUPPORT-ONLY NO-GO ON X/Y CELLS" with explicit failures. This is strictly a support-only statement; do not promote to T89 being false for mu or to any asymptotic proposition.

## Reproducibility and dissemination

Preserve script, tests, JSON and CSV rows, per-regime summaries, hashes and negative findings. Keep all documents in research branch and Drive experiment folder, append journal with explicit chronology, retain T89 [O].
