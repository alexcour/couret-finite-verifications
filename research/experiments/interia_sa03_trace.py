#!/usr/bin/env python3
"""INTERIA-SA-03: deterministic replay of classical, restricted Weyl templates.

This is a dependency/consistency checker, NOT a formal proof or a generic
Sturm-Liouville oracle. The analytic classification lemmas are external inputs.
No inference about integral operators, Hilbert-Polya, zeta, or RH is authorized.

Usage:
  python3 interia_sa03_trace.py --model bessel_weight_x --parameter 1/2
  python3 interia_sa03_trace.py --model legendre --out /tmp/sa03.json
  python3 interia_sa03_trace.py --verify /tmp/sa03.json
  python3 interia_sa03_trace.py --all --out /tmp/sa03_all.json
"""
from __future__ import annotations

import argparse
from fractions import Fraction
from hashlib import sha256
import json
from pathlib import Path
import re
from typing import Any

from interia_sa02_weyl_certifier import (
    LC, LP, MINIMAL, OperatorSpec, UnsupportedOperator,
    certify as sa02_certify, default_cases,
)

VERSION = "INTERIA-SA-03/0.1"
REFERENCE_STATUS = "CLASSICAL_LEMMA_ASSUMED_NOT_FORMALIZED"
SCHEMA_KEYS = frozenset({
    "schema", "input", "operator", "hypotheses", "trace",
    "conclusion", "proof_boundary", "digest",
})
MODEL_INFO = {
    "legendre": ("-d/dx[(1-x^2) u']", "(-1,1)", "L^2((-1,1), dx)", False),
    "regular_schrodinger": ("-u'' + beta*u", "(-1,1)", "L^2((-1,1), dx)", True),
    "bessel_weight_x": ("x^-1[-(x*u')' + nu^2*u/x]", "(0,infinity)",
                        "L^2((0,infinity), x dx)", True),
    "inverse_square_interval": ("-u''+c*[x^-2+(1-x)^-2]*u", "(0,1)",
                                "L^2((0,1), dx)", True),
    "harmonic_oscillator": ("-u'' + x^2*u", "(-infinity,infinity)",
                            "L^2(R, dx)", False),
}
RATIONAL = re.compile(r"-?(?:0|[1-9][0-9]*)(?:/[1-9][0-9]*)?\Z")


class TraceRejected(ValueError):
    """Typed rejection, including missing or altered proof dependencies."""


def normalized_fraction(value: str) -> Fraction:
    if not isinstance(value, str) or RATIONAL.fullmatch(value) is None:
        raise TraceRejected("parameter must be a canonical exact rational string")
    try:
        result = Fraction(value)
    except (ValueError, ZeroDivisionError) as exc:
        raise TraceRejected("invalid rational") from exc
    if str(result) != value:
        raise TraceRejected("parameter must be normalized (e.g. 1/2, not 2/4)")
    return result


def parse_input(inp: dict[str, Any]) -> OperatorSpec:
    if not isinstance(inp, dict) or set(inp) != {"model", "parameter", "domain"}:
        raise TraceRejected("input fields missing or unexpected")
    model = inp["model"]
    if not isinstance(model, str) or model not in MODEL_INFO:
        raise TraceRejected("unknown model; integral operators are not supported")
    if inp["domain"] != MINIMAL:
        raise TraceRejected("only the minimal C_c^infty(I) domain is supported")
    has_p = MODEL_INFO[model][3]
    if (inp["parameter"] is None) == has_p:
        raise TraceRejected("parameter required exactly for parameterized templates")
    p = normalized_fraction(inp["parameter"]) if has_p else None
    return OperatorSpec(model, p, MINIMAL)


def analytic_gate(spec: OperatorSpec, side: str) -> dict[str, str]:
    """Derive exact comparison data; each rule relies on named classical lemmas."""
    if side not in ("left", "right"):
        raise TraceRejected("invalid endpoint")
    m, p = spec.model, spec.parameter
    if m == "legendre":
        return {"rule": "LEGENDRE_LOG_L2", "side": side, "integrability": "BOTH",
                "argument": "1 and atanh(x) behave as 1 and log(distance); log^2 in L2"}
    if m == "regular_schrodinger":
        return {"rule": "REGULAR_FINITE_ENDPOINT", "side": side, "integrability": "BOTH",
                "argument": "p=1,w=1,q=constant bounded; all local solutions bounded"}
    if m == "bessel_weight_x":
        assert p is not None
        if side == "right":
            return {"rule": "BESSEL_INFTY_LP", "side": side, "integrability": "NOT_BOTH",
                    "argument": "nonintegrable x^abs(nu) under x*dx at infinity"}
        exponent = Fraction(1) - 2 * abs(p)
        both = exponent > -1
        return {"rule": "BESSEL_ZERO_POWER_XDX", "side": side,
                "integrability": "BOTH" if both else "NOT_BOTH",
                "argument": f"power=1-2*abs(nu)={exponent}; x^power integrable at 0 iff power>-1; nu=0 log branch"}
    if m == "inverse_square_interval":
        assert p is not None
        threshold = Fraction(3, 4)
        if p < Fraction(-1, 4):
            case = "complex Frobenius roots Re(r)=1/2; both local modes L2"
        elif p == Fraction(-1, 4):
            case = "repeated Frobenius root r=1/2; t^1/2*log(t) L2"
        else:
            case = f"smaller Frobenius root L2 iff c<3/4; c={p}"
        return {"rule": "INVSQ_FROBENIUS_GATE", "side": side,
                "integrability": "BOTH" if p < threshold else "NOT_BOTH",
                "argument": case}
    if m == "harmonic_oscillator":
        return {"rule": "HARMONIC_LP_EXTERNAL", "side": side,
                "integrability": "NOT_BOTH",
                "argument": "external classical limit-point theorem at infinity"}
    raise TraceRejected("unsupported model")


def _payload(spec: OperatorSpec) -> dict[str, Any]:
    m = spec.model
    if m not in MODEL_INFO:
        raise TraceRejected("model not allowed")
    # Validate parameter and minimal domain *before* using templates.
    raw = {"model": m, "parameter": str(spec.parameter) if spec.parameter is not None else None,
           "domain": spec.domain}
    spec = parse_input(raw)
    expression, interval, hilbert, _ = MODEL_INFO[m]
    trace = []
    for side in ("left", "right"):
        gate = analytic_gate(spec, side)
        label = LC if gate["integrability"] == "BOTH" else LP
        trace.append({"node": f"gate.{side}", "depends_on": ["operator", "hypotheses"],
                      "rule": gate})
        trace.append({"node": f"class.{side}", "depends_on": [f"gate.{side}"],
                      "rule": "WEYL_LC_IF_TWO_LOCAL_L2_SOLUTIONS", "value": label})
    left = trace[1]["value"]
    right = trace[3]["value"]
    deficiency = int(left == LC) + int(right == LC)
    trace.append({"node": "deficiency", "depends_on": ["class.left", "class.right"],
                  "rule": "SECOND_ORDER_REAL_MINIMAL_STURM_LIOUVILLE",
                  "value": [deficiency, deficiency]})
    return {
        "schema": VERSION,
        "input": raw,
        "operator": {"expression": expression, "interval": interval, "hilbert_space": hilbert,
                     "initial_domain": MINIMAL, "kind": "second_order_real_differential"},
        "hypotheses": {"parameter_type": "exact_rational_or_none",
                       "differential_template_exact": True,
                       "minimal_domain_only": True,
                       "analytic_lemmas": REFERENCE_STATUS},
        "trace": trace,
        "conclusion": {"left": left, "right": right,
                       "deficiency_plus": deficiency, "deficiency_minus": deficiency,
                       "essential_self_adjoint_minimal": deficiency == 0},
        "proof_boundary": {
            "verdict": "DETERMINISTIC_CLASSICAL_TEMPLATE_REPLAY",
            "is_lean_formalized": False,
            "is_general_sturm_liouville_solver": False,
            "is_new_analytic_proof": False,
            "supports_integral_operators": False,
            "no_rh_claim": True,
        },
    }


def digest(body: dict[str, Any]) -> str:
    canonical = json.dumps(body, sort_keys=True, ensure_ascii=True,
                           separators=(",", ":"), allow_nan=False)
    return sha256(canonical.encode("utf-8")).hexdigest()


def produce(spec: OperatorSpec) -> dict[str, Any]:
    body = _payload(spec)
    return {**body, "digest": "sha256:" + digest(body)}


def replay(cert: dict[str, Any]) -> dict[str, Any]:
    """Reject missing, extra, reordered, altered or mismatched proof elements.

    The digest is an integrity hint only, *not* a cryptographic proof of origin.
    The independent model-classification comparison remains a separate test.
    """
    if not isinstance(cert, dict) or set(cert) != SCHEMA_KEYS:
        raise TraceRejected("certificate schema fields missing or extra")
    if cert["schema"] != VERSION:
        raise TraceRejected("wrong schema version")
    spec = parse_input(cert["input"])
    expected = produce(spec)
    if cert != expected:
        for k in expected:
            if cert.get(k) != expected[k]:
                raise TraceRejected(f"invalid or incomplete proof dependency: {k}")
        raise TraceRejected("certificate mismatch")
    # A second implementation, SA02, must agree on all public endpoint labels.
    try:
        oracle = sa02_certify(spec)
    except UnsupportedOperator as exc:
        raise TraceRejected(f"SA02 rejected input: {exc}") from exc
    conclusion = expected["conclusion"]
    if (oracle.left_class != conclusion["left"] or
        oracle.right_class != conclusion["right"] or
        oracle.deficiency_plus != conclusion["deficiency_plus"] or
        oracle.deficiency_minus != conclusion["deficiency_minus"]):
        raise TraceRejected("SA02 and SA03 classification disagree")
    return conclusion


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    g = parser.add_mutually_exclusive_group(required=True)
    g.add_argument("--model", choices=tuple(MODEL_INFO))
    g.add_argument("--all", action="store_true")
    g.add_argument("--verify", metavar="JSON_FILE")
    parser.add_argument("--parameter", help="canonical rational, e.g. 3/4")
    parser.add_argument("--out", metavar="JSON_FILE", help="write certificate JSON")
    args = parser.parse_args()
    try:
        if args.verify:
            if args.parameter or args.out:
                raise TraceRejected("--verify may not be combined with --parameter/--out")
            source = json.loads(Path(args.verify).read_text(encoding="utf-8"))
            certs = source["certificates"] if isinstance(source, dict) and set(source) == {"certificates"} else [source]
            if not isinstance(certs, list) or not certs:
                raise TraceRejected("no certificates to verify")
            for cert in certs:
                replay(cert)
            print(f"PASS replay: {len(certs)} certificate(s); no formal proof claim")
            return 0
        if args.all:
            if args.parameter:
                raise TraceRejected("--all does not accept --parameter")
            result = {"certificates": [produce(spec) for spec in default_cases()]}
        else:
            inp = {"model": args.model, "domain": MINIMAL, "parameter": args.parameter}
            result = produce(parse_input(inp))
        if args.out:
            Path(args.out).write_text(json.dumps(result, indent=2, ensure_ascii=False) + "\n",
                                      encoding="utf-8")
        else:
            print(json.dumps(result, indent=2, ensure_ascii=False))
        return 0
    except (ValueError, TypeError, OSError, KeyError, json.JSONDecodeError) as exc:
        print(f"REJECT: {exc}")
        return 2


if __name__ == "__main__":
    raise SystemExit(main())
