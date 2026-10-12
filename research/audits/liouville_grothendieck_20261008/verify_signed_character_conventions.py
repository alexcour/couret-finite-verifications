#!/usr/bin/env python3
"""CU-BRUIT-02: exact primitive q=15 character and conjugation sanity checks.

LMFDB table anchors:
https://www.lmfdb.org/Character/Dirichlet/15/2
https://www.lmfdb.org/Character/Dirichlet/15/8
https://www.lmfdb.org/Character/Dirichlet/15/14

Checks only finite algebra and metadata of local, uncertified candidates.
No independent verification of zero ordinates, GRH, LI, prime-race
limiting law, tail estimates or sign probabilities is performed.
"""
import argparse
import json
from pathlib import Path

UNIT15 = (1, 2, 4, 7, 8, 11, 13, 14)
UNIT30 = (1, 7, 11, 13, 17, 19, 23, 29)
DISCRETE_LOG5 = {1: 0, 2: 1, 4: 2, 3: 3}
CONREY = {"15.2": (1, 1), "15.14": (1, 2), "15.8": (1, 3)}
# LMFDB values in UNIT15 order, encoded as (real,imaginary) Gaussian integers.
EXTERNAL_VALUE_ANCHORS = {
    "15.2": ((1,0),(-0,-1),(-1,0),(0,1),(0,1),(-1,0),(0,-1),(1,0)),
    "15.14": ((1,0),(1,0),(1,0),(-1,0),(1,0),(-1,0),(-1,0),(-1,0)),
    "15.8": ((1,0),(0,1),(-1,0),(0,-1),(0,-1),(-1,0),(0,1),(1,0)),
}
LOCAL_LABELS = {"1,1": ("15.2",12), "1,2": ("15.14",13), "1,3": ("15.8",12)}
I_POWERS = ((1,0),(0,1),(-1,0),(0,-1))


def character(n, a, b):
    if n % 3 == 0 or n % 5 == 0:
        return (0,0)
    sign = -1 if a and n % 3 == 2 else 1
    u = I_POWERS[(b * DISCRETE_LOG5[n % 5]) % 4]
    return (sign * u[0], sign * u[1])


def conjugate(z):
    return (z[0], -z[1])


def audit(check_local=False):
    assert len(UNIT15) == len(UNIT30) == 8
    verified_rows = {}
    for label, (a,b) in CONREY.items():
        row = tuple(character(n,a,b) for n in UNIT15)
        assert row == EXTERNAL_VALUE_ANCHORS[label], (label,row)
        even = (a+b)%2 == 0
        assert character(-1,a,b) == ((1,0) if even else (-1,0))
        assert all(character(n,a,b) == character(n % 15,a,b) for n in UNIT30)
        verified_rows[label] = [list(z) for z in row]

    assert CONREY["15.2"] == (1,1)
    assert CONREY["15.8"] == (1,3)
    assert CONREY["15.14"] == (1,2)
    for n in UNIT15:
        assert character(n,1,3) == conjugate(character(n,1,1))
        assert character(n,1,2)[1] == 0
    # Under the Dirichlet-series coefficient conjugacy,
    # L(s,conj(chi)) = conjugate(L(conjugate(s),chi)).
    # Hence critical-line zero ordinate gamma for chi maps to -gamma for conj chi.
    # This exact symmetry does NOT independently certify any candidate zero.

    c = {n: (5 if n in (1,11,29) else -3) for n in UNIT30}
    assert sum(c.values()) == 0
    hats = {}
    for label,(a,b) in CONREY.items():
        re = sum(c[n] * character(n,a,b)[0] for n in UNIT30)
        im = -sum(c[n] * character(n,a,b)[1] for n in UNIT30)
        assert re % 8 == im % 8 == 0
        hats[label] = (re//8, im//8)
    assert hats == {"15.2":(1,0),"15.14":(-1,0),"15.8":(1,0)}

    # The following is metadata about local inputs, not an external decimal match.
    local_count = None
    if check_local:
        path = Path(__file__).with_name("q15_roots_refined_20261009.json")
        data = json.loads(path.read_text(encoding="utf-8"))["results"]
        assert set(data) == set(LOCAL_LABELS)
        local_count = 0
        for key,(label,count) in LOCAL_LABELS.items():
            item=data[key]
            assert item["conrey_label"] == label
            assert item["count"] == count == len(item["zeros"])
            from decimal import Decimal
            vals = [Decimal(s) for s in item["zeros"]]
            assert vals == sorted(set(vals))
            assert all(Decimal(0)<z<Decimal(25) for z in vals)
            local_count += count
        assert local_count == 37
        # Positives for the nonreal conjugates are empirically different
        # in the local, uncertified candidate lists.
        assert data["1,1"]["zeros"] != data["1,3"]["zeros"]

    return {
        "exact_character_value_tables": "PASS for Conrey 15.2, 15.14, 15.8",
        "primitive_character_metadata": "Conrey labels anchored to LMFDB, not proved by this script",
        "conjugacy_15_2_and_15_8": "PASS (finite character values)",
        "parities": {"15.2":"even","15.14":"odd","15.8":"even"},
        "conrey_coefficients_for_T_1_11_29": hats,
        "local_candidate_count_if_requested": local_count,
        "q15_new_external_decimal_matches": 0,
        "status": "B1-SIGNED-FINITE-CHECK; A3 ZERO-DATA HOLD; analytic law not certified",
    }


def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--check-local-metadata",action="store_true",
                        help="check only the stored local q15 candidate labels and counts")
    args=parser.parse_args()
    print(json.dumps(audit(args.check_local_metadata),indent=2,sort_keys=True))


if __name__=="__main__":
    main()
