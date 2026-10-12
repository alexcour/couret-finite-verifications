#!/usr/bin/env python3
"""CU-BRUIT-02: elementary Fourier/Bessel split bound for phase tails.

The analytical inequality is conditional on independent uniform phases, and the
NUMERIC illustration is NOT certified: q15 values and residual variance are not
interval-validated. Does not certify GRH, LI, zero completeness, or sign density.
"""
import argparse
import json
import math
from pathlib import Path

J01_SAFE_LOWER = 2.4048   # Strict rational lower bound on first positive J0 zero.


def bessel_split_bound(cutoff_T, tail_variance_lower, low_amplitudes, H=4.5,
                       max_abs_fourier_coefficient=3.0):
    """Analytical bound with numeric evaluation in ordinary floats (not intervals).

    b_k values are the COEFFICIENTS of 2*b_k*cos(U), not the full 2*b_k.
    Low amplitudes may be ANY positive subset of the true low-phase factors.
    V_lower must be an independently certified lower bound for full tail variance
    before interpreting a returned number as a certified probability bound.
    """
    T, v, w = float(cutoff_T), float(tail_variance_lower), float(max_abs_fourier_coefficient)
    if not (math.isfinite(T) and T > 0 and math.isfinite(v) and v > 0 and
            math.isfinite(w) and w > 0 and math.isfinite(H) and H > 0):
        raise ValueError("Positive finite T, V lower bound, H and weight required")
    if not low_amplitudes or any(b <= 0 or not math.isfinite(b) for b in low_amplitudes):
        raise ValueError("At least one strictly positive finite low-phase amplitude needed")
    M = w/math.hypot(T, 0.5)
    q = (2*M*H/J01_SAFE_LOWER)**2
    if q >= 1:
        raise ValueError("Require 2*M*H < strict lower bound for first J0 root")
    small = M*M/(4*math.pi*v*(1-q))
    ordered = sorted(low_amplitudes, reverse=True)
    choices = []
    sum_logs = 0.0
    for m, b in enumerate(ordered, 1):
        sum_logs += math.log(math.pi*b*H)
        high = 4/(m*math.pi)*math.exp(-0.5*sum_logs)
        choices.append((small + high, m, high))
    total, m, high = min(choices)
    return {"T": T, "H": H, "tail_variance_lower_bound_given": v,
            "max_omitted_phase_b": M, "q_ratio_squared": q,
            "selected_low_factors": m, "available_low_factors": len(ordered),
            "small_frequency_term": small, "large_frequency_term": high,
            "total_bound_floating_point": min(1.0, total),
            "BEWARE": "Float evaluation only; NOT certified unless inputs/rounding and tail variance lower bound are rigorously established"}


def amplitude_subset_from_partial_catalog(filename):
    obj = json.loads(Path(filename).read_text(encoding="utf-8"))
    entries = obj["entries"]
    selected = [e for e in entries if e["conductor"] in (3, 5)]
    assert len(selected) == 4
    amps = []
    for e in selected:
        weight = 3.0 if e["ab"] == "0,2" else 1.0
        assert e["status"] in {"LMFDB_ORDINATES_MATCHED", "NUMBERDB_ORDINATES_MATCHED"}
        amps.extend(weight/math.hypot(float(g), 0.5)
                    for g in e["positive_zero_ordinates_under_25"])
    assert len(amps) == 30
    return amps


def main():
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument("--self-test", action="store_true")
    p.add_argument("--illustrative", action="store_true")
    p.add_argument("--catalog", default=str(Path(__file__).with_name("lmfdb_zero_comparison_20261009.json")))
    a = p.parse_args()
    out = {"status": "THEOREM-SYMBOLIC-ONLY; NUMERICAL-ILLUSTRATIONS-UNCERTIFIED"}
    if a.self_test:
        test = bessel_split_bound(25, 0.8, [0.45, 0.30, 0.25, 0.20], H=4.5)
        assert test["total_bound_floating_point"] >= test["small_frequency_term"]
        assert test["selected_low_factors"] >= 1
        assert bessel_split_bound(25, 0.9, [0.45, 0.30, 0.25, 0.20], H=4.5)["small_frequency_term"] < test["small_frequency_term"]
        try:
            bessel_split_bound(25, 0.8, [0.2], H=11)
        except ValueError:
            pass
        else:
            raise AssertionError("Expected invalid H to be rejected")
        out["self_test"] = "PASS: finite algebra, argument guards; no validation of Bessel inequality"
    if a.illustrative:
        low = amplitude_subset_from_partial_catalog(a.catalog)
        out["illustrative_only"] = bessel_split_bound(25, 0.7908925527, low, H=4.5)
        out["source"] = "30 positive candidate ordinates matched to decimal lists for conductor 3/5; no interval guarantee"
        out["warning"] = "V=0.7908925527 is exploratory and depends on 37 unverified q15 roots. The number above is NOT a certified error bound."
    print(json.dumps(out, indent=2, sort_keys=True))


if __name__ == "__main__":
    main()
