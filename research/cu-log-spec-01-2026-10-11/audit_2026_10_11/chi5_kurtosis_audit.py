#!/usr/bin/env python3
"""Numerical audit of 25 positive zeros of the primitive quadratic L(s,chi_5).

Data: https://www.lmfdb.org/L/1/5/5.4/r0/0/0
LMFDB states that its precomputed Dirichlet L-zero lists are interval-verified.
The independent check here uses 57-digit mpmath Hurwitz zeta, NOT interval
arithmetic. No claims of an independent proof of zero completeness, GRH, LI,
or an arithmetical anomaly. No prime counts are computed.
Run: python chi5_kurtosis_audit.py > chi5_kurtosis_result.json
Dependency: mpmath
"""
import json
import mpmath as mp

LMFDB_GAMMAS = (
    "6.64845334472771471612327845997",
    "9.831444432886669616348321347458",
    "11.95884562608351453026565868826",
    "16.03382112838423567459325378224",
    "17.566994292325555202701595268144",
    "19.54073262278475025037869002299",
    "22.227405454459410911877624963081",
    "24.58846621740819520765626997608",
    "26.77609594800414011652357496527",
    "28.46103510017752247518697827232",
    "29.70790935048096556923098651865",
    "33.00045600687051436794975917721",
    "34.728812978904808674143729833981",
    "35.86863837181227459459504863887",
    "38.12918472143653185015141827037",
    "39.56057294640318170505509505995",
    "41.84243854579169430850930688531",
    "44.03129006144169504470090805842",
    "45.4273000827822893888415619096",
    "46.49272715949140534533919935167",
    "48.34566182106784617654820130449",
    "51.08775192674649135525825720413",
    "52.1259022313169741886041306959",
    "53.83044519544216335105426902233",
    "55.58928033540481015096458899849",
)

def run():
    mp.mp.dps = 57

    def l5(s):
        return (
            mp.zeta(s, mp.mpf(1)/5)
            - mp.zeta(s, mp.mpf(2)/5)
            - mp.zeta(s, mp.mpf(3)/5)
            + mp.zeta(s, mp.mpf(4)/5)
        ) / mp.power(5, s)

    def hardy_z(t):
        s = mp.mpf("0.5") + 1j * t
        return mp.re(mp.power(5/mp.pi, s/2) * mp.gamma(s/2) * l5(s))

    alpha = mp.mpf(1)/3
    h = mp.log(3)
    # Filtered full zero-sum under GRH, via classical Guinand-Weil identity.
    # chi_5 is even, primitive of conductor 5, chi_5(2)=-1.
    V = mp.mpf(2)/3 * (mp.log(5/mp.pi) - mp.euler) + mp.log(2)/3

    roots, a_terms = [], []
    max_l_residual, max_rounding_gap = mp.mpf(0), mp.mpf(0)
    for entry in LMFDB_GAMMAS:
        candidate = mp.mpf(entry)
        root = mp.findroot(
            hardy_z,
            (candidate-mp.mpf("0.0002"), candidate+mp.mpf("0.0002")),
        )
        residual = abs(l5(mp.mpf("0.5") + 1j*root))
        gap = abs(root-candidate)
        assert residual < mp.mpf("1e-42")
        assert gap < mp.mpf("2e-25")
        roots.append(root)
        max_l_residual = max(max_l_residual, residual)
        max_rounding_gap = max(max_rounding_gap, gap)
        a = (1+alpha-2*mp.sqrt(alpha)*mp.cos(root*h)) / (mp.mpf(".25")+root**2)
        a_terms.append(a)

    assert len(roots) == 25
    assert all(roots[i] < roots[i+1] for i in range(24))
    observed_half = sum(a_terms)
    tail_half = V/2-observed_half
    assert tail_half > 0
    quartic_partial = sum(a*a for a in a_terms)

    # Under GRH+LI, for the bias-centered signed real chi_5 score:
    # X = sum_{gamma>0} 2*sqrt(a_gamma)*cos(U_gamma).
    # variance(X)=V, kappa4(X)=-6*sum(a_gamma^2).
    # Unknown nonnegative tail a_j has sum tail_half; its square sum
    # cannot exceed tail_half**2. No zero-exhaustivity assumption needed
    # for this *conditional* inequality.
    kappa_upper = -6*quartic_partial/V**2
    kappa_lower = -6*(quartic_partial+tail_half**2)/V**2
    assert -1.5 < kappa_lower < kappa_upper < 0
    return {
        "date": "2026-10-11",
        "source": "https://www.lmfdb.org/L/1/5/5.4/r0/0/0",
        "analysis": "quadratic primitive Dirichlet character conductor 5; window alpha=1/3",
        "numeric_method": "Hurwitz zeta re-evaluation of each source zero with mpmath at 57 dps",
        "number_of_zeros": 25,
        "max_root_modulus_residual": mp.nstr(max_l_residual, 12),
        "max_source_rounding_gap": mp.nstr(max_rounding_gap, 12),
        "conditional_total_variance": mp.nstr(V, 24),
        "positive_half_variance_from_25": mp.nstr(observed_half, 24),
        "positive_half_variance_unaccounted": mp.nstr(tail_half, 24),
        "variance_fraction_accounted": mp.nstr(2*observed_half/V, 18),
        "conditional_excess_kurtosis_interval": [
            mp.nstr(kappa_lower, 17), mp.nstr(kappa_upper, 17)
        ],
        "formula": "kappa4=-6*sum(gamma>0, |c_gamma|^4), variance=2*sum(gamma>0, |c_gamma|^2)",
        "refined_positive_ordinates": [mp.nstr(x, 39) for x in roots],
        "limitations": [
            "source LMFDB reports rigorous completeness, not independently certified here",
            "numerical roots are not verified by interval arithmetic here",
            "interpretation of full variance formula as positive zero sum requires GRH",
            "independent Haar phases and fourth cumulant require LI",
            "applies to signed centered chi5 mode, NOT directly to the energy ratio Gchi5",
            "not an original arithmetic discovery or a valid p-value for one prime window"
        ]
    }

if __name__ == "__main__":
    print(json.dumps(run(), ensure_ascii=False, indent=2))
