#!/usr/bin/env python3
"""Verify the autonomous N=2310 Barning--Hall Rayleigh certificate.

The verifier uses only the Python standard library.  It reconstructs the
69,120-state CRT model, the Klein orbits, H = 4 Pi U Pi, and the archived
integer vector.  Floating-point arithmetic is used only for human-readable
display after every decisive check has been performed with integers.
"""

from __future__ import annotations

import argparse
import hashlib
import json
import math
from collections import Counter, deque
from dataclasses import dataclass
from pathlib import Path
from typing import Iterable, Sequence


PRIMES = (3, 5, 7, 11)  # the mod-2 layer is rigid at squarefree level 2310
MATRICES = {
    "I": ((1, 0), (0, 1)),
    "U": ((1, 2), (0, 1)),
    "UINV": ((1, -2), (0, 1)),
    "S": ((0, -1), (1, 0)),
    "R": ((0, 1), (1, 0)),
    "K": ((-1, 0), (0, 1)),
}
EXPECTED_LOCAL_SIZES = (4, 12, 24, 60)
EXPECTED_STATE_COUNT = 69_120
EXPECTED_ORBIT_COUNT = 17_520
EXPECTED_ORBIT_SIZE_COUNTS = {2: 480, 4: 17_040}
EXPECTED_RAW_NUMERATOR = 3_488_080
EXPECTED_RAW_DENOMINATOR = 1_005_300
EXPECTED_REDUCED_NUMERATOR = 174_404
EXPECTED_REDUCED_DENOMINATOR = 50_265
EXPECTED_SQUARE_GAP = 97_912_516
EXPECTED_SUPPORT = 15_850
EXPECTED_MIN_VALUE = -19
EXPECTED_MAX_VALUE = 19
EXPECTED_VECTOR_SHA256 = "ae3c5dfc7c6a3515af537e6ce232de7be37d3bde58ccc2562407c4f6c6f79d69"


def require(condition: bool, message: str) -> None:
    if not condition:
        raise AssertionError(message)


def canonical_pair(p: int, m: int, n: int) -> tuple[int, int]:
    pair = (m % p, n % p)
    negative = ((-m) % p, (-n) % p)
    return min(pair, negative)


def local_states(p: int) -> tuple[list[tuple[int, int]], dict[tuple[int, int], int]]:
    states: list[tuple[int, int]] = []
    index: dict[tuple[int, int], int] = {}
    for m in range(p):
        for n in range(p):
            if m == 0 and n == 0:
                continue
            state = canonical_pair(p, m, n)
            if state not in index:
                index[state] = len(states)
                states.append(state)
    return states, index


def local_permutation(
    p: int,
    states: Sequence[tuple[int, int]],
    index: dict[tuple[int, int], int],
    matrix: tuple[tuple[int, int], tuple[int, int]],
) -> list[int]:
    (a, b), (c, d) = matrix
    result: list[int] = []
    for m, n in states:
        image = canonical_pair(p, a * m + b * n, c * m + d * n)
        result.append(index[image])
    return result


def encode(coords: Sequence[int], radices: Sequence[int]) -> int:
    value = 0
    for coordinate, radix in zip(coords, radices):
        value = value * radix + coordinate
    return value


def decode(value: int, radices: Sequence[int]) -> tuple[int, ...]:
    coords = [0] * len(radices)
    for position in range(len(radices) - 1, -1, -1):
        coords[position] = value % radices[position]
        value //= radices[position]
    return tuple(coords)


def global_permutation(local_perms: Sequence[Sequence[int]], radices: Sequence[int]) -> list[int]:
    total = math.prod(radices)
    result = [0] * total
    for state in range(total):
        coords = decode(state, radices)
        image = tuple(local_perms[k][coords[k]] for k in range(len(radices)))
        result[state] = encode(image, radices)
    return result


@dataclass(frozen=True)
class Model:
    radices: tuple[int, ...]
    local: tuple[tuple[list[tuple[int, int]], dict[tuple[int, int], int]], ...]
    permutations: dict[str, list[int]]
    orbit_id: list[int]
    orbits: list[tuple[int, ...]]
    orbit_sizes: list[int]


def compose(left: Sequence[int], right: Sequence[int]) -> list[int]:
    """State map left o right."""
    return [left[right[x]] for x in range(len(left))]


def build_model() -> Model:
    local = tuple(local_states(p) for p in PRIMES)
    radices = tuple(len(states) for states, _ in local)
    require(radices == EXPECTED_LOCAL_SIZES, f"local sizes {radices}")

    permutations: dict[str, list[int]] = {}
    for name, matrix in MATRICES.items():
        local_perms = [
            local_permutation(p, states, index, matrix)
            for p, (states, index) in zip(PRIMES, local)
        ]
        permutations[name] = global_permutation(local_perms, radices)

    total = math.prod(radices)
    require(total == EXPECTED_STATE_COUNT, f"state count {total}")
    identity = list(range(total))
    for name, permutation in permutations.items():
        require(sorted(permutation) == identity, f"{name} is not a permutation")
    for name in ("S", "R", "K"):
        require(compose(permutations[name], permutations[name]) == identity, f"{name}^2")
    require(compose(permutations["S"], permutations["R"]) == permutations["K"], "SR=K")
    require(compose(permutations["R"], permutations["S"]) == permutations["K"], "RS=K")
    require(
        compose(permutations["K"], compose(permutations["U"], permutations["K"]))
        == permutations["UINV"],
        "K U K = U^-1",
    )

    # The explicit CRT product is the single orbit of the Barning--Hall root
    # (m,n)=(2,1) under L1=US, L2=UR, L3=U.
    root_coords = tuple(
        index[canonical_pair(p, 2, 1)] for p, (_, index) in zip(PRIMES, local)
    )
    root = encode(root_coords, radices)
    generators = (
        compose(permutations["U"], permutations["S"]),
        compose(permutations["U"], permutations["R"]),
        permutations["U"],
    )
    reached = bytearray(total)
    reached[root] = 1
    queue: deque[int] = deque([root])
    while queue:
        state = queue.popleft()
        for generator in generators:
            image = generator[state]
            if not reached[image]:
                reached[image] = 1
                queue.append(image)
    require(sum(reached) == total, f"reachable states {sum(reached)}")

    orbit_id = [-1] * total
    orbits: list[tuple[int, ...]] = []
    for state in range(total):
        if orbit_id[state] >= 0:
            continue
        orbit = tuple(
            sorted(
                {
                    state,
                    permutations["S"][state],
                    permutations["R"][state],
                    permutations["K"][state],
                }
            )
        )
        oid = len(orbits)
        for member in orbit:
            require(orbit_id[member] in (-1, oid), "overlapping Klein orbits")
            orbit_id[member] = oid
        orbits.append(orbit)
    require(all(oid >= 0 for oid in orbit_id), "unassigned state")
    orbit_sizes = [len(orbit) for orbit in orbits]
    require(len(orbits) == EXPECTED_ORBIT_COUNT, f"orbit count {len(orbits)}")
    require(dict(Counter(orbit_sizes)) == EXPECTED_ORBIT_SIZE_COUNTS, "orbit-size profile")

    # Exact detailed balance for the compressed U action.  This is also a
    # finite verification of self-adjointness on the Klein-invariant space.
    transitions = Counter(
        (orbit_id[state], orbit_id[permutations["U"][state]]) for state in range(total)
    )
    require(
        all(count == transitions[(target, source)] for (source, target), count in transitions.items()),
        "compressed U transition counts are not symmetric",
    )

    return Model(radices, local, permutations, orbit_id, orbits, orbit_sizes)


def load_vector(path: Path, model: Model) -> list[int]:
    rows: list[tuple[int, int, int, int]] = []
    with path.open("r", encoding="utf-8") as handle:
        for line_number, line in enumerate(handle, start=1):
            line = line.strip()
            if not line or line.startswith("#"):
                continue
            fields = line.split("\t")
            require(len(fields) == 4, f"bad vector row {line_number}")
            rows.append(tuple(int(field) for field in fields))
    require(len(rows) == EXPECTED_ORBIT_COUNT, f"vector rows {len(rows)}")

    values = [0] * EXPECTED_ORBIT_COUNT
    for expected_oid, (oid, size, representative, value) in enumerate(rows):
        require(oid == expected_oid, f"orbit id at row {expected_oid}")
        require(size == model.orbit_sizes[oid], f"orbit size at row {expected_oid}")
        require(representative == model.orbits[oid][0], f"orbit representative at row {expected_oid}")
        values[oid] = value
    return values


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        for block in iter(lambda: handle.read(1024 * 1024), b""):
            digest.update(block)
    return digest.hexdigest()


def verify(vector_path: Path) -> dict[str, object]:
    vector_hash = sha256(vector_path)
    require(vector_hash == EXPECTED_VECTOR_SHA256, f"vector SHA-256 {vector_hash}")
    model = build_model()
    orbit_values = load_vector(vector_path, model)
    total = EXPECTED_STATE_COUNT
    vector = [orbit_values[model.orbit_id[state]] for state in range(total)]

    require(min(orbit_values) == EXPECTED_MIN_VALUE, "minimum vector entry")
    require(max(orbit_values) == EXPECTED_MAX_VALUE, "maximum vector entry")
    require(sum(value != 0 for value in orbit_values) == EXPECTED_SUPPORT, "orbit support")
    for name in ("S", "R", "K"):
        permutation = model.permutations[name]
        require(all(vector[state] == vector[permutation[state]] for state in range(total)), f"V-invariance: {name}")

    weighted_mean = sum(size * value for size, value in zip(model.orbit_sizes, orbit_values))
    require(weighted_mean == 0, f"not orthogonal to constants: {weighted_mean}")

    u = model.permutations["U"]
    s = model.permutations["S"]
    r = model.permutations["R"]
    k = model.permutations["K"]
    u_vector = [vector[u[state]] for state in range(total)]
    h_vector = [
        u_vector[state] + u_vector[s[state]] + u_vector[r[state]] + u_vector[k[state]]
        for state in range(total)
    ]
    for name in ("S", "R", "K"):
        permutation = model.permutations[name]
        require(all(h_vector[state] == h_vector[permutation[state]] for state in range(total)), f"H(v) invariance: {name}")
    require(sum(h_vector) == 0, "H does not preserve constant-orthogonality")

    denominator = sum(value * value for value in vector)
    numerator = sum(value * image for value, image in zip(vector, h_vector))
    numerator_shortcut = 4 * sum(vector[state] * vector[u[state]] for state in range(total))
    require(numerator == numerator_shortcut, "H=4 Pi U Pi quadratic-form identity")
    require(numerator == EXPECTED_RAW_NUMERATOR, f"raw numerator {numerator}")
    require(denominator == EXPECTED_RAW_DENOMINATOR, f"raw denominator {denominator}")

    divisor = math.gcd(numerator, denominator)
    reduced_numerator = numerator // divisor
    reduced_denominator = denominator // divisor
    require(reduced_numerator == EXPECTED_REDUCED_NUMERATOR, "reduced numerator")
    require(reduced_denominator == EXPECTED_REDUCED_DENOMINATOR, "reduced denominator")
    square_gap = reduced_numerator**2 - 12 * reduced_denominator**2
    require(square_gap == EXPECTED_SQUARE_GAP, f"square gap {square_gap}")
    require(square_gap > 0 and reduced_numerator > 0 and reduced_denominator > 0, "strict threshold")

    # H(1)=4*1 is checked directly.  Along with exact self-adjointness above
    # and <v,1>=0, Rayleigh--Ritz applies on the nonconstant invariant space.
    ones = [1] * total
    u_ones = [ones[u[state]] for state in range(total)]
    h_ones = [
        u_ones[state] + u_ones[s[state]] + u_ones[r[state]] + u_ones[k[state]]
        for state in range(total)
    ]
    require(all(value == 4 for value in h_ones), "H(1)=4*1")

    return {
        "status": "PASS",
        "model": "X_2310 = product_{p in {3,5,7,11}} ((F_p^2 minus {0})/{+-1})",
        "local_state_counts": list(model.radices),
        "state_count": total,
        "klein_orbit_count": len(model.orbits),
        "klein_orbit_size_counts": {str(key): value for key, value in EXPECTED_ORBIT_SIZE_COUNTS.items()},
        "barning_hall_reachable_states": total,
        "vector_sha256": vector_hash,
        "vector_orbit_support": EXPECTED_SUPPORT,
        "vector_value_range": [EXPECTED_MIN_VALUE, EXPECTED_MAX_VALUE],
        "constant_inner_product": weighted_mean,
        "raw_numerator": numerator,
        "raw_denominator": denominator,
        "gcd": divisor,
        "reduced_numerator": reduced_numerator,
        "reduced_denominator": reduced_denominator,
        "square_gap": square_gap,
        "rayleigh_decimal": numerator / denominator,
        "threshold_decimal": 2.0 * math.sqrt(3.0),
        "margin_decimal": numerator / denominator - 2.0 * math.sqrt(3.0),
        "four_eigenspace": "constants only, by transitivity and the equality case for ||4*Pi*U*Pi|| <= 4",
        "conclusion": "a nonconstant eigenvalue of H_2310 lies strictly between 2*sqrt(3) and 4",
    }


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "vector",
        nargs="?",
        type=Path,
        default=Path(__file__).with_name("rayleigh_vector_2310.tsv"),
    )
    parser.add_argument("--json", action="store_true", help="emit JSON only")
    args = parser.parse_args()
    result = verify(args.vector)
    if args.json:
        print(json.dumps(result, ensure_ascii=False, sort_keys=True, indent=2))
        return
    print("BH2310 AUTONOMOUS CERTIFICATE: PASS")
    print(f"states/orbits: {result['state_count']} / {result['klein_orbit_count']}")
    print(f"<v,1>: {result['constant_inner_product']}")
    print(f"v^T H v / v^T v: {result['raw_numerator']} / {result['raw_denominator']}")
    print(f"reduced quotient: {result['reduced_numerator']} / {result['reduced_denominator']}")
    print(f"p^2 - 12 q^2: {result['square_gap']} > 0")
    print(f"decimal: {result['rayleigh_decimal']:.15f}")
    print(f"2*sqrt(3): {result['threshold_decimal']:.15f}")
    print(f"margin: {result['margin_decimal']:.15f}")
    print("4-eigenspace: constants only")
    print(result["conclusion"])


if __name__ == "__main__":
    main()
