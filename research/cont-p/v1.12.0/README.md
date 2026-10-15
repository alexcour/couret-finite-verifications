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

## Experimental replay

The [experimental subfolder](experimental/README.md) now contains the scientific
tables, source results and programs formerly retained only in the Drive working
package. It preserves the failed v1.10 criterion and the successful descriptive
v1.11 criterion separately. The v1.12 computations are post-hoc diagnostics,
without new prime windows, parameter fitting or a general prime-number claim.
