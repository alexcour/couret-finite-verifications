# CONT-P v1.12.0 — finite gain geometry

Read [FORMALISATION_PUBLIC.md](FORMALISATION_PUBLIC.md) for the elementary
proofs. This research working draft is outside the immutable v1.0.0 release.
No novelty or general prime-number claim is made.

Run the exact synthetic checks with Python 3.12:

```bash
python3 verify_gain_geometry.py
```

The verifier uses only Python's standard library, contains no experimental
data and fails with a nonzero status on any failed assertion. Mathematical
arguments are provided in the note; this is not a Lean proof certificate.
See the repository's AI_ASSISTANCE.md and PROVENANCE.md for general policy.
