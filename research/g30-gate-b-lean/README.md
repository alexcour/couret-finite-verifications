# G30 Gate B — research validation branch

This directory is **not part of the cited public v1.0.0 release scope** of `couret-finite-verifications`.
It exists to close the formal-validation subgate B-L for the finite G30 complex spectral classification.

Current trust and source inventory: [LEAN_AUDIT.md](../../LEAN_AUDIT.md).
The compiled source uses `native_decide` for 14 finite checks; the historical
Drive copy repeats the same obligations. Under Lean 4.29.1 these native
computations introduce individually generated axioms and include the compiler
and runtime in the trusted computation. Their historical successful CI receipt
is recorded in the linked inventory. Human review and originality remain
separate; the historical source comments below are not a new status decision.

Pinned environment:

- Lean: `v4.29.1`
- Mathlib: `v4.29.1`

Canonical source artifact before GitHub import:

- Drive: `G30ComplexSpectrum.lean`
- exact Python replay: `verify_g30_gate_b.py`
- source status before CI: `P-SCAFFOLD / UNCOMPILED`

Promotion rule:

- B-L may become `CLOSED / D-Lean` only after a green pinned build of `G30ComplexSpectrum.lean`;
- the Python exact replay must also pass on the same PR;
- the cited v1.0.0 tag and DOI are not modified by this research branch;
- no RH, Hilbert–Pólya, prime-distribution or asymptotic claim is implied.
