# COURET–OAI–BRIDGE–01 — EXP-03 large-sieve benchmark

> **RESEARCH BRANCH — NOT PART OF v1.0.0 — NO RH CLAIM — NOT PEER REVIEWED**
>
> EXP-03 benchmarks the growing-modulus shift-frequency mechanism against the classical analytic large-sieve envelope. It deliberately removes the Couret-vs-complement residue gate from the primary endpoint.

## Frozen protocol

Prime windows:
- 100 < p <= 200
- 200 < p <= 400
- 400 < p <= 800

Length ratios:
- X/P = 8
- X/P = 16

Frequency caps:
- Q = 7, 13, 19, 23

Frequency family:
- zero frequency;
- all reduced fractions a/q with q <= Q and gcd(q,30)=1.

Window:
- fixed tent window on [1,2], peak 1 at 3/2.

For each residual shift sequence b_h, define S_b(alpha)=sum_h b_h e(-alpha h). Let N be the length of the integer support interval of b_h.

EXP-03 records full saturation and nonzero-frequency saturation against the classical denominator (N-1+Q^2) sum_h |b_h|^2.

Primary endpoint: nonzero-frequency saturation.

## Aggregate results

### Plain residual

Across all 912 plain rows:
- mean full saturation: 0.2774233;
- mean nonzero saturation: 0.00261415;
- median nonzero saturation: 0.00144616;
- maximum full saturation: 0.6457684;
- maximum nonzero saturation: 0.0184911;
- mean zero-frequency share of family energy: 0.9758984.

### Inverse/Mobius residual

Across all 912 inverse rows:
- mean full saturation: 0.0946048;
- mean nonzero saturation: 0.0916139;
- median nonzero saturation: 0.0946860;
- maximum full saturation: 0.1920845;
- maximum nonzero saturation: 0.1917927;
- mean zero-frequency share of family energy: 0.0469447.

## Interpretation

The plain residual looks superficially closer to saturating the large-sieve envelope only because almost all family energy sits at the zero frequency.

Once the zero mode is removed, its oscillatory saturation is tiny.

The inverse/Mobius residual behaves very differently: most of its family energy is genuinely on nonzero frequencies.

However it still remains comfortably below the large-sieve envelope. The mean nonzero saturation is about 9.16%, and the largest observed value is about 19.18%.

There is therefore no evidence here of saturation, violation, or a new power-saving theorem.

## Dependence on Q

Mean inverse nonzero saturation by Q:
- Q=7: 0.0351489
- Q=13: 0.0888689
- Q=19: 0.1209163
- Q=23: 0.1215217

Corresponding mean zero-frequency shares:
- Q=7: 0.130081
- Q=13: 0.032230
- Q=19: 0.014527
- Q=23: 0.010942

Thus the richer Mobius spectrum is not an artifact of the zero mode.

## Critical regime check

The dimensionless parameter is lambda=Q^2/N.

Around lambda≈1, inverse nonzero saturation remains at the level of several percent to roughly 10%, depending on the finite window.

No monotone decay with scale is visible on this small corpus. Therefore EXP-03 does not provide empirical evidence for a new exponent.

## Verdict

Mechanism verdict: INVERSE/MOBIUS RESIDUAL HAS A GENUINELY NONZERO SHIFT-FREQUENCY SPECTRUM.

Analytic-gain verdict: NO LARGE-SIEVE-BEATING OR POWER-SAVING EFFECT DETECTED.

Couret verdict: no Couret-specific claim is tested or supported by the primary endpoint of EXP-03.

After the negative EXP-01 and EXP-02 gate tests, the current research object is the growing-modulus mechanism itself.

## Reproducibility

Script: research/experiments/bridge_exp03_large_sieve.py

Frozen local-run hashes:
- script SHA-256: a1630b7c9b9caffd4487b3759120bf5e02f34d77def433ee34a9733df419c941
- JSON results SHA-256: 1e8d622822c2dcc1ab06fda43ac46ee59793680ea4d2681c2f4a1e5a4b26dc52

## Next decision

Do not search for a favorable Q after inspection.

The next useful step is to enlarge scale while keeping the critical ratio Q^2/N approximately fixed, and test whether the nonzero saturation ratio decays, stabilizes, or grows.

Only a reproducible scaling law could motivate a stronger analytic conjecture.

Until then the correct status is:
- frequency structure: detected;
- generic large-sieve control: respected;
- extra power saving: open;
- Couret-specific gain: unsupported.