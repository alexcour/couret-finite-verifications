# A minimal 101-state observation machine for the certified modulo 30 table

Any deterministic observation machine reproducing every word output of the explicit certified modulo 30 transition table has at least 101 distinct reachable states. The archived proofs also construct a correct 101-state quotient machine. Minimality is relative to the stated table and output semantics, with no general integer-factorization or cryptographic claim.

This is a Palomar preparation snapshot. Compilation of earlier migration closures is not an official Comparator result. Package compilation, official checking and registration are separate stages.

## Licence and provenance

MIT applies to these author-authorized adaptations. It does not relicense the original archive ZIP or third-party dependencies. Archive SHA256, exact paths and migration hashes are in SOURCE_PROVENANCE.json. Mathlib retains its upstream licence.

## Reproduce

`lake build`

`lake env lean AuditSelected.lean`
