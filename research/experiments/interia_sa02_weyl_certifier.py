#!/usr/bin/env python3
"""INTERIA-SA-02: auditable, deliberately *restricted* Weyl endpoint verifier.

This is NOT a general Sturm-Liouville decision procedure or a formal proof
assistant. It checks exact rational parameter thresholds against a small catalog
of classical analytic lemmas. An unrecognized operator or ambiguous domain is
REJECTED rather than assigned a guess. In particular, integral operators are
not classified by Weyl's differential-operator endpoint criterion here.

Supported models use the MINIMAL operator initially defined on C_c^infty(I).
Their closure has equal deficiency indices (number of LC endpoints).

Run: python3 interia_sa02_weyl_certifier.py
     python3 interia_sa02_weyl_certifier.py --json
     python3 interia_sa02_weyl_certifier.py --model bessel_weight_x --parameter 1/2 --claim LC LP
"""
from __future__ import annotations

import argparse
from dataclasses import asdict, dataclass
from fractions import Fraction
import json
from typing import Optional

LC = "LC"
LP = "LP"
MINIMAL = "C_c^infty(I)"


class UnsupportedOperator(ValueError):
    """No classification is authorized for this input."""


class ClaimRejected(AssertionError):
    """A claimed endpoint classification conflicts with a supported lemma."""


@dataclass(frozen=True)
class OperatorSpec:
    model: str
    parameter: Optional[Fraction] = None
    domain: str = MINIMAL


@dataclass(frozen=True)
class Certificate:
    model: str
    parameter: Optional[str]
    expression: str
    interval: str
    hilbert_space: str
    initial_domain: str
    left_endpoint: str
    right_endpoint: str
    left_class: str
    right_class: str
    deficiency_plus: int
    deficiency_minus: int
    essential_self_adjoint: bool
    lemmas: tuple[str, ...]
    scope: str

    def as_json(self) -> dict:
        item = asdict(self)
        item["lemmas"] = list(self.lemmas)
        return item


SUPPORTED = (
    "legendre", "regular_schrodinger", "bessel_weight_x",
    "inverse_square_interval", "harmonic_oscillator",
)


def _parameter(spec: OperatorSpec, *, required: bool, default: Optional[Fraction] = None) -> Fraction:
    raw = spec.parameter
    if raw is None:
        if required:
            raise UnsupportedOperator(f"{spec.model}: an explicit rational parameter is required")
        if default is None:
            raise UnsupportedOperator(f"{spec.model}: invalid unspecified parameter")
        return default
    if not isinstance(raw, Fraction):
        raise UnsupportedOperator("parameters must be exact fractions.Fraction, not floating point")
    return raw


def certify(spec: OperatorSpec) -> Certificate:
    """Check a template-specific analytical rule; refuse unknown/misaligned domains."""
    if spec.model not in SUPPORTED:
        raise UnsupportedOperator(f"unsupported operator {spec.model!r}; no extrapolation authorized")
    if spec.domain != MINIMAL:
        raise UnsupportedOperator(
            f"only minimal domain {MINIMAL} is supported, got {spec.domain!r}"
        )

    param: Optional[str] = None
    if spec.model == "legendre":
        if spec.parameter is not None:
            raise UnsupportedOperator("legendre template has no free parameter")
        expression = "-d/dx[(1-x^2) u']"
        interval, hilbert = "(-1,1)", "L^2((-1,1), dx)"
        left, right = LC, LC
        lemmas = (
            "At zero spectral parameter, fundamental solutions are 1 and atanh(x).",
            "At both endpoints, atanh(x)=O(|log(distance)|): log^2 integrable in dx.",
            "Both solutions L^2 locally -> LC at each endpoint (Weyl alternative).",
        )
    elif spec.model == "regular_schrodinger":
        beta = _parameter(spec, required=True)
        param = str(beta)
        expression = f"-u'' + ({beta})u"
        interval, hilbert = "(-1,1)", "L^2((-1,1), dx)"
        left, right = LC, LC
        lemmas = (
            "p=1, weight=1, bounded q=beta on the closed finite interval.",
            "Both endpoints regular; every local ODE solution is L^2 near each.",
            "Regular endpoints are LC; this rule is NOT about all bounded intervals.",
        )
    elif spec.model == "bessel_weight_x":
        nu = _parameter(spec, required=True)
        param = str(nu)
        expression = f"(1/x)[-(x u')' + ({nu})^2 u/x]"
        interval, hilbert = "(0,infinity)", "L^2((0,infinity), x dx)"
        # Near 0: zero-energy solutions x^{+/-nu} (or 1,log x for nu=0).
        # x^{-|nu|} is L^2(x dx) iff 1-2|nu|>-1.
        left, right = (LC if abs(nu) < 1 else LP), LP
        lemmas = (
            "At z=0, local solutions are x^(+/-nu); at nu=0, 1 and log(x).",
            "With weight x dx, x^(-abs(nu)) is L^2 near zero iff abs(nu)<1.",
            "At infinity, x^(abs(nu)) (or 1 for nu=0) is not L^2(x dx): LP.",
            "Deficiency equation: x^2 u''+x u'+(z x^2-nu^2)u=0.",
        )
    elif spec.model == "inverse_square_interval":
        c = _parameter(spec, required=True)
        param = str(c)
        expression = f"-u'' + ({c})[1/x^2 + 1/(1-x)^2]u"
        interval, hilbert = "(0,1)", "L^2((0,1), dx)"
        # c may be < -1/4: both Frobenius exponents have real part 1/2.
        # For c >= -1/4, r_- = 1/2 - sqrt(c+1/4) lies in L^2 iff r_->-1/2.
        # Therefore both LC when c<3/4, while c>=3/4 is LP (including border).
        left = right = LC if c < Fraction(3, 4) else LP
        lemmas = (
            "Each endpoint has dominant c/t^2 with bounded lower-order remainder.",
            "Indicial roots: r=1/2+/-sqrt(c+1/4) (complex if c<-1/4).",
            "For c<-1/4 both oscillatory modes have |u|=O(t^1/2) -> LC.",
            "For c=-1/4 the log mode is L^2 -> LC.",
            "For c>-1/4, smaller exponent square integrable iff c<3/4.",
            "At c=3/4, smaller exponent = -1/2 is NOT in L^2 (log divergence).",
        )
    else:
        # Independent reference lemma: -u''+x^2 u on R is LP at each infinity.
        if spec.parameter is not None:
            raise UnsupportedOperator("harmonic oscillator template has no free parameter")
        expression = "-u'' + x^2 u"
        interval, hilbert = "(-infinity,infinity)", "L^2(R, dx)"
        left, right = LP, LP
        lemmas = (
            "Classical Weyl limit-point theorem for the harmonic oscillator at +/-infinity.",
            "The theorem is a cited mathematical input, NOT derived from numeric truncation.",
        )

    n = int(left == LC) + int(right == LC)
    return Certificate(
        model=spec.model, parameter=param, expression=expression,
        interval=interval, hilbert_space=hilbert, initial_domain=MINIMAL,
        left_endpoint=interval.split(",")[0][1:],
        right_endpoint=interval.split(",", 1)[1][:-1],
        left_class=left, right_class=right, deficiency_plus=n,
        deficiency_minus=n, essential_self_adjoint=(n == 0),
        lemmas=lemmas,
        scope="CLASSICAL TEMPLATE CHECK / MINIMAL DOMAIN; not a general analytic proof or Lean certification",
    )


def check_claim(spec: OperatorSpec, left: str, right: str) -> Certificate:
    if left not in (LC, LP) or right not in (LC, LP):
        raise ClaimRejected("endpoint labels must be exactly LC or LP")
    cert = certify(spec)
    if (left, right) != (cert.left_class, cert.right_class):
        raise ClaimRejected(
            f"{spec.model} ({cert.parameter}) on {cert.interval}, {cert.initial_domain}: "
            f"REJECT claimed ({left},{right}); computed ({cert.left_class},{cert.right_class}), "
            f"indices ({cert.deficiency_plus},{cert.deficiency_minus})"
        )
    return cert


def default_cases() -> list[OperatorSpec]:
    return [
        OperatorSpec("legendre"),
        OperatorSpec("regular_schrodinger", Fraction(0)),
        OperatorSpec("regular_schrodinger", Fraction(7, 3)),
        OperatorSpec("bessel_weight_x", Fraction(0)),
        OperatorSpec("bessel_weight_x", Fraction(1, 2)),
        OperatorSpec("bessel_weight_x", Fraction(1)),
        OperatorSpec("bessel_weight_x", Fraction(-2)),
        OperatorSpec("inverse_square_interval", Fraction(-1)),
        OperatorSpec("inverse_square_interval", Fraction(-1, 4)),
        OperatorSpec("inverse_square_interval", Fraction(0)),
        OperatorSpec("inverse_square_interval", Fraction(3, 4)),
        OperatorSpec("inverse_square_interval", Fraction(1)),
        OperatorSpec("harmonic_oscillator"),
    ]


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--json", action="store_true", help="emit machine-readable cases and evidence")
    parser.add_argument("--model", choices=SUPPORTED, help="classify a single supported model")
    parser.add_argument("--parameter", help="exact rational parameter, e.g. 3/4")
    parser.add_argument("--domain", default=MINIMAL,
                        help="operator initial domain; only C_c^infty(I) is supported")
    parser.add_argument("--claim", nargs=2, metavar=("LEFT", "RIGHT"),
                        help="check a claimed endpoint classification for --model")
    args = parser.parse_args()
    if args.model or args.claim or args.parameter:
        try:
            if not args.model:
                raise UnsupportedOperator("--model is required with --claim or --parameter")
            parameter = Fraction(args.parameter) if args.parameter is not None else None
            spec = OperatorSpec(args.model, parameter, args.domain)
            result = check_claim(spec, *args.claim) if args.claim else certify(spec)
        except (ClaimRejected, UnsupportedOperator, ValueError, ZeroDivisionError) as error:
            print(f"REJECT: {error}")
            return 2
        print(json.dumps(result.as_json(), ensure_ascii=False, indent=2))
        return 0
    results = [certify(spec) for spec in default_cases()]
    if args.json:
        print(json.dumps({"version": "INTERIA-SA-02-0.1", "certificates": [x.as_json() for x in results]},
                         ensure_ascii=False, indent=2))
    else:
        for item in results:
            print(f"{item.model:25s} parameter={str(item.parameter):6s} "
                  f"({item.left_class},{item.right_class}) "
                  f"indices=({item.deficiency_plus},{item.deficiency_minus})")
        print(f"PASS {len(results)} model cases; domain & operator scope strictly restricted")
        print("STATUS: classical lemma instantiations; NOT a generic Weyl solver or RH claim")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
