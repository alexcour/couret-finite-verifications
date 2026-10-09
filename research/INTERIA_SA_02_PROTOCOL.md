# INTERIA-SA-02 — bounded classical Weyl checker — 2026-10-08

Status: **[D classical reference lemmas] [Q local Python tests PASS] [O independent CI review]**.
Research only; NO RH CLAIM, NO Hilbert–Pólya theorem, NO novel spectral theorem.

## Scope
This program is deliberately not a symbolic algorithm for arbitrary Sturm–Liouville operators. It instantiates five explicitly named classical model families on the minimal domain C_c^infty(I), computes the endpoint limit-circle/limit-point labels from established analytic threshold lemmas, and derives deficiency indices n_+=n_-=number of LC endpoints. The certified statement is conditional on the model matching the template exactly. Arbitrary input operators, other domains, floats, missing rational parameters, and integral operators are rejected. The program does not produce Lean proofs.

1. Legendre -( (1-x²)u')' on (-1,1), L²(dx): LC/LC, indices (2,2); fundamental solutions 1 and atanh(x).
2. Regular Schrödinger -u''+βu on (-1,1), β rational: LC/LC (2,2).
3. Bessel x^-1[-(xu')'+ν²u/x] on (0,∞), L²(x dx): 0 is LC iff |ν|<1, infinity LP; threshold ±1 included in LP.
4. Singular Schrödinger -u''+c[x^-2+(1-x)^-2]u on (0,1): both ends LC iff c<3/4, LP iff c>=3/4. For c<-1/4 use oscillatory Frobenius exponents with real part 1/2; c=-1/4 has a log solution; at c=3/4 the smaller exponent is -1/2 (divergence). This is the counterexample to “all finite intervals are LC”.
5. Harmonic oscillator -u''+x²u on the real line: LP/LP (0,0), a classical external input, not established here numerically.

## Reproduce
```sh
python3 research/experiments/interia_sa02_weyl_certifier.py
python3 research/experiments/interia_sa02_weyl_certifier.py --json
python3 research/experiments/interia_sa02_weyl_certifier.py --model bessel_weight_x --parameter 1 --claim LP LP
python3 -m unittest discover -s research/experiments -p 'test_interia_sa02_weyl_certifier.py' -v
```

The intentionally WRONG claim `--model bessel_weight_x --parameter 1 --claim LC LP` must terminate with exit status 2 and a REJECT message, not a false positive. Reference output includes 13 default certificates. Initial local replay: 20 unit tests passed, including false-label rejection, threshold c=3/4 and |ν|=1, wrong domains, missing parameters, float exclusion, and prohibition of integral S_{1/2,30}.

## Provenance & limitations
- Earlier historical paper: Drive Liouville report ID 1IsWCWpUHsMa5D0yOzcHTC_8FUlAFzg5mTj3uC3vl3_8.
- Corrections canonical: Journal F ID 1Cln8aCg1p76nkk54Ng7Yj6IeRMiYVNl14DeAAeBvJIE.
- This tool does not independently validate the historical InterIA-SA code or Phase 2 original.
- Here [D] refers to application of accepted classical endpoint lemmas on *exactly these models*. A deterministic code path and tests do not replace proofs of those lemmas. [Q local] not [Q CI] until workflow passes on GitHub.
- Do not transport any result to an integral operator, zeta zeros or Hilbert–Pólya.

## Next gate
An independent reviewer should inspect every template expression and Hilbert space, verify the cited lemmas against a primary reference, and audit the target domain. Only then extend to a general solver or Lean formalization.
