# COURET–OAI–BRIDGE–01 — EXP-02C confirmatory growing-q shift spectrum

> **CONFIRMATORY PRE-SPECIFIED PROTOCOL — NO RESULTS YET — RESEARCH BRANCH — NO RH CLAIM**
>
> This protocol is distinct from the smaller EXP-02-PILOT already executed on fixed q={7,11,13,17}. It is the confirmatory follow-up and must not inherit or tune parameters from the pilot.

## Question

Does the lift (30 \to 30q), with (q) growing with the natural shift scale, expose nontrivial frequency structure in the residual shift variable (h) that is absent from the fixed mod-30 model?

## Frozen corpus

Retain the EXP-01 design:

- prime windows (500<p\le1000), (1000<p\le2000), (2000<p\le4000), (4000<p\le8000);
- (X/P\in\{32,64,128\});
- fixed tent window on ([1,2]), peak 1 at (3/2);
- exact removal of the structural diagonal (L_p);
- plain and inverse/Möbius cases analyzed separately.

## Residual shift sequence

For each regime ((P,X,\mathrm{kind})), construct the signed residual contribution (b_h) after summation in (m) and diagonal removal.

Publish the effective support ([h_{\min},h_{\max}]) and

[
H=h_{\max}-h_{\min}+1.
]

Do not replace (b_h) by (|b_h|) before the transform.

## Frozen growing-q family

For

[
\alpha\in\{1/4,1/3,1/2\},
]

define (q_\alpha(H)) as the smallest prime

[
q\ge\max(7,\lceil H^\alpha\rceil)
]

with ((q,30)=1).

Drop duplicate q-values if two alpha levels coincide. Do not replace them after looking at results.

The alpha=1/2 regime is primary because (q^2\asymp H) is the natural large-sieve transition scale.

## Shift packets and spectrum

For each q,

[
H_q(r)=\sum_{h\equiv r\pmod q}b_h,
qquad
\widehat H_q(j)=\sum_h b_h e(-jh/q).
]

Verify Parseval numerically with relative error at most (10^{-10}). A Parseval failure blocks that regime.

Report:

- DC share (S_0=|\widehat H_q(0)|^2/\sum_j|\widehat H_q(j)|^2);
- largest nonzero-frequency share M1;
- top-five nonzero-frequency share M5;
- normalized spectral entropy on nonzero frequencies.

## Deterministic permutation controls

For every regime and q, generate 128 deterministic permutations of h-positions. The seed may depend only on

[
(P,X/P,\mathrm{kind},q,\mathrm{replicate}),
]

never on observed metrics.

Each control preserves the multiset of b_h values and destroys their location in h.

Define

[
p_{\mathrm{emp}}(M5)
=
\frac{1+\#\{\mathrm{controls}:M5_c\ge M5_{\mathrm{obs}}\}}{129}.
]

## Primary continuation criterion

EXP-02C is mechanically interesting only if, in the inverse/Möbius case:

1. (p_{\mathrm{emp}}(M5)\le0.05) in at least 8 of the 12 regimes at alpha=1/2; and
2. the median of
   (M5_{\mathrm{obs}}-\mathrm{median}(M5_{\mathrm{control}}))
   is strictly positive at both alpha=1/3 and alpha=1/2.

This is a continuation threshold, not a proof of power saving.

## Negative criteria

- If the primary criterion fails, demote this version of the growing-q mechanism.
- DC-only concentration does not count as nontrivial frequency structure.
- An effect equally present in plain and inverse cases is classified as structural/numerical rather than specifically arithmetic.
- A single-regime effect is not generalized.

## Large-sieve benchmark

Publish H, q, q^2/H, and total frequency energy for each regime.

Use the classical H+Q^2 scale only as a benchmark. Do not infer an asymptotic large-sieve constant from this finite panel.

## Secondary Couret controls

As a secondary analysis only, aggregate b_h over chi5=±1 prime classes and compare with chi3 and chi15 gates.

Do not call a growing-q effect “Couret-specific” unless chi5 reproducibly exceeds the two quadratic controls under a pre-specified metric.

## Required outputs

- frozen script;
- raw JSON;
- summary CSV;
- q-values by regime;
- observed metrics;
- 128 controls per regime/q;
- Parseval checks;
- SHA-256 manifest;
- verdict report.

## Claim boundary

A positive result would show only that the growing-modulus lift exposes finite shift-frequency concentration beyond permutation controls.

It would not imply RH, a zero-free region, asymptotic power saving, or superiority of the fixed Couret chi5 gate.
