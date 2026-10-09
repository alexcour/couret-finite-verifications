#!/usr/bin/env python3
"""Generate the archived N=2310 integer Rayleigh witness.

This is a provenance tool, not part of the trusted verification base.  It uses
NumPy/SciPy only to find a candidate.  The companion standard-library verifier
reconstructs the model and checks the frozen candidate with exact integers.
"""

from __future__ import annotations

import argparse
import math
import platform
from pathlib import Path

import numpy as np
import scipy
from scipy.sparse import coo_matrix
from scipy.sparse.linalg import eigsh

from verify_bh2310_certificate import (
    EXPECTED_ORBIT_COUNT,
    EXPECTED_STATE_COUNT,
    build_model,
    verify,
)


SCALE = 1000


def generate(output: Path) -> None:
    model = build_model()
    source_orbit = np.asarray(model.orbit_id, dtype=np.int64)
    target_orbit = source_orbit[np.asarray(model.permutations["U"], dtype=np.int64)]
    sizes = np.asarray(model.orbit_sizes, dtype=np.int64)

    # Matrix of H=4 Pi U Pi in the orthonormal orbit-indicator basis.
    weights = 4.0 / np.sqrt(sizes[source_orbit] * sizes[target_orbit])
    h_matrix = coo_matrix(
        (weights, (source_orbit, target_orbit)),
        shape=(EXPECTED_ORBIT_COUNT, EXPECTED_ORBIT_COUNT),
    ).tocsr()
    asymmetry = h_matrix - h_matrix.T
    if asymmetry.nnz:
        if float(np.max(np.abs(asymmetry.data))) != 0.0:
            raise AssertionError("compressed matrix is not symmetric")

    seed = np.sin(np.arange(EXPECTED_ORBIT_COUNT, dtype=np.float64) + 1.0)
    eigenvalues, eigenvectors = eigsh(
        h_matrix,
        k=10,
        which="LA",
        tol=1e-13,
        maxiter=200_000,
        v0=seed,
    )
    nonconstant = eigenvalues[eigenvalues < 4.0 - 1e-8]
    target = float(nonconstant[-1])
    target_mask = np.isclose(eigenvalues, target, rtol=0.0, atol=1e-10)
    target_basis = eigenvectors[:, target_mask]
    if target_basis.shape[1] != 3:
        raise AssertionError(f"expected multiplicity 3, got {target_basis.shape[1]}")

    # Projection onto the complete multiplicity-three eigenspace avoids any
    # dependence on ARPACK's arbitrary basis inside that eigenspace.
    orbit_coefficients = target_basis @ (target_basis.T @ seed)
    orbit_coefficients /= np.linalg.norm(orbit_coefficients)
    first = int(np.flatnonzero(np.abs(orbit_coefficients) > 1e-12)[0])
    if orbit_coefficients[first] < 0:
        orbit_coefficients = -orbit_coefficients
    full_state_values = orbit_coefficients / np.sqrt(sizes)
    witness = np.rint(SCALE * full_state_values).astype(np.int64)

    # Exact projection away from the constant vector if rounding introduces a
    # nonzero weighted sum.  Size-2 orbits make the correction integral.
    weighted_sum = int(sizes @ witness)
    if weighted_sum:
        if weighted_sum % 2:
            raise AssertionError("weighted sum is unexpectedly odd")
        correction_orbit = int(np.flatnonzero(sizes == 2)[0])
        witness[correction_orbit] -= weighted_sum // 2
    if int(sizes @ witness) != 0:
        raise AssertionError("failed to enforce exact constant-orthogonality")

    output.parent.mkdir(parents=True, exist_ok=True)
    with output.open("w", encoding="utf-8", newline="\n") as handle:
        handle.write("# orbit_id\torbit_size\trepresentative_state_index\tvalue\n")
        for oid, value in enumerate(witness.tolist()):
            handle.write(f"{oid}\t{model.orbit_sizes[oid]}\t{model.orbits[oid][0]}\t{value}\n")

    result = verify(output)
    print(f"python={platform.python_version()} numpy={np.__version__} scipy={scipy.__version__}")
    print("largest eigenvalues:", " ".join(f"{value:.15f}" for value in eigenvalues))
    print(f"target={target:.15f}; multiplicity={target_basis.shape[1]}; scale={SCALE}")
    print(f"wrote {output} ({EXPECTED_ORBIT_COUNT} orbit values; {EXPECTED_STATE_COUNT} states)")
    print(
        "exact quotient="
        f"{result['reduced_numerator']}/{result['reduced_denominator']}; "
        f"square gap={result['square_gap']}"
    )
    print("PASS")


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--output",
        type=Path,
        default=Path(__file__).with_name("rayleigh_vector_2310.tsv"),
    )
    args = parser.parse_args()
    generate(args.output)


if __name__ == "__main__":
    main()
