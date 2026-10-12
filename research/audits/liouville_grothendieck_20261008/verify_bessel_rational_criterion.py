#!/usr/bin/env python3
"""Exact-rational hypothetical numerical criterion for CU-BRUIT-02 B2.

This is NOT a certified bound for the prime race. The following inputs
are assumptions, not conclusions of the public data:
(A) the real T=25 phase-tail variance V_T >= 3/4;
(B) for each of the eighteen DISTINCT selected conductor-3/5 factors,
    its positive zero ordinate gamma satisfies 1 <= gamma <= the tabulated U;
(C) a Rubinstein--Sarnak independent-phase law with correct indexing applies.

Under (A)--(C), pure integer/rational arithmetic shows that the sign-
probability change from replacing the entire phase tail by N(0,V_T)
is strictly less than 3/1250 = 0.0024.

The 18 ordinate U values were rounded upward from a non-certified public
decimal-match catalogue. This script checks the transcription against
that catalogue but does NOT prove the enclosures, V_T, GRH or LI.
"""
import argparse
import json
from decimal import Decimal, ROUND_CEILING, getcontext
from fractions import Fraction as F
from math import isqrt
from pathlib import Path

# Each row is (Conrey label, ASSUMED rational upper bound on gamma, |c_chi|).
# This list is a distinct subset of 30 previously decimal-matched local
# conductor-3/5 candidates, not certified root isolation.
LOW_FACTORS = (
    ("5.4", "6.648455", 3),
    ("5.4", "9.831446", 3),
    ("5.4", "11.958847", 3),
    ("5.3", "4.132905", 1),
    ("5.4", "16.033823", 3),
    ("5.4", "17.566996", 3),
    ("5.2", "6.183580", 1),
    ("5.4", "19.540734", 3),
    ("5.4", "22.227407", 3),
    ("3.2", "8.039739", 1),
    ("5.4", "24.588468", 3),
    ("5.2", "8.457231", 1),
    ("5.3", "9.442933", 1),
    ("3.2", "11.249208", 1),
    ("5.3", "11.282898", 1),
    ("5.2", "12.674948", 1),
    ("5.3", "14.115466", 1),
    ("5.2", "14.825027", 1),
)
PI_LOWER = F(314, 100)  # Known strict inequality pi > 3.14.
J01_LOWER = F(2)         # The first positive zero of J_0 is > 2.
T = F(25)
H = F(9, 2)
M_UPPER = F(3, 25)       # |c_chi|/sqrt(gamma^2+1/4) <= 3/25 if gamma > 25.
V_LOWER_ASSUMED = F(3, 4)
TARGET = F(3, 1250)    # 0.0024 (NOT a certified observed error).
SCALE = 10**12


def sqrt_strict_upper(q):
    """Conservative rational sqrt bound, using only integer arithmetic."""
    if q <= 0:
        raise ValueError("positive rational argument required")
    floor_square = (q.numerator * SCALE * SCALE) // q.denominator
    upper = F(isqrt(floor_square) + 1, SCALE)
    assert upper**2 > q
    return upper


def pure_rational_certificate():
    assert len(LOW_FACTORS) == 18
    assert F(0) < V_LOWER_ASSUMED < 1
    assert T == 25 and H > 0
    q = (2*M_UPPER*H / J01_LOWER)**2
    assert q == F(729, 2500) and q < 1
    # On 0<=t<=H use J0 Hadamard product and
    # sum_k (j_{0,k})^-4=1/32; J0(y)>0 for |y|<=2MH<2.
    small = M_UPPER**2 / (4 * PI_LOWER * V_LOWER_ASSUMED * (1-q))

    # For gamma>=1, sqrt(gamma^2+1/4)<=gamma+1/8. Hence
    # b_j >= |c_chi|/(U_j+1/8) for each assumed gamma<=U_j.
    # Standard |J0(z)|<=sqrt(2/(pi*z)), z>0.
    # Apply m known low factors at t>=H and integrate t^(-1-m/2).
    factor_product = F(1)
    for label, upper_str, weight in LOW_FACTORS:
        assert label in ("3.2", "5.2", "5.3", "5.4")
        assert weight == (3 if label == "5.4" else 1)
        upper_gamma = F(Decimal(upper_str))
        assert 1 < upper_gamma < T
        factor_product *= sqrt_strict_upper(
            (upper_gamma + F(1, 8))/(PI_LOWER * weight * H)
        )
    m = len(LOW_FACTORS)
    large = F(4, m) / PI_LOWER * factor_product
    total = small + large
    assert 0 < small < total < TARGET
    assert sqrt_strict_upper(F(2))**2 > 2
    assert sqrt_strict_upper(F(1, 4))**2 > F(1, 4)
    return {"small": small, "large": large, "total": total, "m": m,
            "j0_ratio_sq_upper": q}


def check_source_transcription(path):
    """Check labels/U against existing decimal corpus; NOT root certification."""
    records = json.loads(Path(path).read_text(encoding="utf-8"))["entries"]
    records = [r for r in records if r["conductor"] in (3, 5)]
    assert len(records) == 4 and sum(
        len(r["positive_zero_ordinates_under_25"]) for r in records
    ) == 30
    available = []
    for r in records:
        assert r["status"] in ("LMFDB_ORDINATES_MATCHED",
                               "NUMBERDB_ORDINATES_MATCHED")
        for value in r["positive_zero_ordinates_under_25"]:
            available.append((r["conrey_label"], F(Decimal(str(value)))))
    assert len(available) == 30
    used = set()
    for label, upper_str, weight in LOW_FACTORS:
        U = F(Decimal(upper_str))
        matches = [(i, g) for i, (lab, g) in enumerate(available)
                   if lab == label and 0 < U-g < F(1, 100000) and i not in used]
        assert len(matches) == 1, (label, upper_str, matches)
        used.add(matches[0][0])
    assert len(used) == 18
    return "18/18 source-decimal transcriptions checked; 0 certified zero intervals"


def upper_decimal(frac, digits=10):
    getcontext().prec = 60
    val = Decimal(frac.numerator)/Decimal(frac.denominator)
    return str(val.quantize(Decimal(1).scaleb(-digits), rounding=ROUND_CEILING))


def main():
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument("--check", action="store_true",
                   help="check the 18 source transcriptions and rational inequality")
    p.add_argument("--catalog", default=str(Path(__file__).with_name(
                   "lmfdb_zero_comparison_20261009.json")))
    args = p.parse_args()
    c = pure_rational_certificate()
    res = {
        "kind": "HYPOTHETICAL_CONDITIONAL_BOUND_NOT_A_PRIME_RACE_CERTIFICATE",
        "m": c["m"],
        "T": str(T),
        "H": str(H),
        "assumed_V_T_lower_bound": str(V_LOWER_ASSUMED),
        "assumed_positive_zero_upper_bounds": len(LOW_FACTORS),
        "small_frequency_rational_upper": upper_decimal(c["small"]),
        "large_frequency_rational_upper": upper_decimal(c["large"]),
        "total_rational_upper": upper_decimal(c["total"]),
        "proved_rational_implication": "IF the listed root enclosures and V_T>=0.75 hold under the independent-phase law, THEN the Gaussian-tail replacement changes the model sign probability by < 0.0024.",
        "not_proved": ["18 root enclosures", "V_T >= 0.75", "GRH/LI",
                       "q15 zero completeness", "certified sign density"],
    }
    if args.check:
        res["decimals_from_repository"] = check_source_transcription(args.catalog)
    print(json.dumps(res, indent=2, sort_keys=True))


if __name__ == "__main__":
    main()
