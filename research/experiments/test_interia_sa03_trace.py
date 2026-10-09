"""Mutation and replay gates for INTERIA-SA-03; no analytic proof claim."""
import copy
from fractions import Fraction
import json
import pathlib
import sys
import unittest

sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
from interia_sa02_weyl_certifier import OperatorSpec, default_cases
from interia_sa03_trace import TraceRejected, produce, replay, parse_input


class Replays(unittest.TestCase):
    def test_all_default_cases(self):
        cases = default_cases()
        self.assertEqual(len(cases), 13)
        for spec in cases:
            with self.subTest(spec=spec):
                cert = produce(spec)
                self.assertEqual(replay(json.loads(json.dumps(cert))), cert["conclusion"])

    def test_threshold_oracles(self):
        for parameter, left, right in [
            ("0", "LC", "LP"), ("1/2", "LC", "LP"), ("-1", "LP", "LP"),
            ("1", "LP", "LP"), ("1001/1000", "LP", "LP"),
        ]:
            with self.subTest(parameter=parameter):
                x = produce(OperatorSpec("bessel_weight_x", Fraction(parameter)))
                self.assertEqual((x["conclusion"]["left"], x["conclusion"]["right"]), (left, right))
        for parameter, expected in [
            ("-1", "LC"), ("-1/4", "LC"), ("749/1000", "LC"),
            ("3/4", "LP"), ("751/1000", "LP")
        ]:
            with self.subTest(parameter=parameter):
                x = produce(OperatorSpec("inverse_square_interval", Fraction(parameter)))
                self.assertEqual(x["conclusion"]["left"], expected)

    def test_required_fields_are_rejected(self):
        base = produce(OperatorSpec("legendre"))
        for field in ["operator", "hypotheses", "trace", "proof_boundary", "digest"]:
            wrong = copy.deepcopy(base)
            del wrong[field]
            with self.subTest(field=field), self.assertRaises(TraceRejected):
                replay(wrong)

    def test_each_dependency_mutation_is_rejected(self):
        base = produce(OperatorSpec("bessel_weight_x", Fraction(1, 2)))
        changes = [
            lambda x: x["input"].update(parameter="1"),
            lambda x: x["operator"].update(hilbert_space="L^2(dx)"),
            lambda x: x["operator"].update(initial_domain="Friedrichs"),
            lambda x: x["hypotheses"].update(analytic_lemmas="PROVED_BY_LEAN"),
            lambda x: x["trace"][0]["rule"].update(integrability="NOT_BOTH"),
            lambda x: x["trace"][1].update(value="LP"),
            lambda x: x["trace"][3].update(depends_on=[]),
            lambda x: x["trace"][4].update(value=[0, 0]),
            lambda x: x["conclusion"].update(essential_self_adjoint_minimal=True),
            lambda x: x["proof_boundary"].update(no_rh_claim=False),
            lambda x: x.update(digest="sha256:fake"),
            lambda x: x["trace"].pop(),
            lambda x: x["trace"].reverse(),
        ]
        for i, change in enumerate(changes):
            wrong = copy.deepcopy(base)
            change(wrong)
            with self.subTest(i=i), self.assertRaises(TraceRejected):
                replay(wrong)

    def test_recomputed_digest_cannot_bypass_semantics(self):
        from interia_sa03_trace import digest
        x = produce(OperatorSpec("legendre"))
        x["conclusion"]["left"] = "LP"
        body = {k: v for k, v in x.items() if k != "digest"}
        x["digest"] = "sha256:" + digest(body)
        with self.assertRaises(TraceRejected):
            replay(x)

    def test_unsupported_scope(self):
        bad = [
            {"model": "integral_S_1_2_30", "parameter": None, "domain": "C_c^infty(I)"},
            {"model": "legendre", "parameter": None, "domain": "bounded_extension"},
            {"model": "bessel_weight_x", "parameter": None, "domain": "C_c^infty(I)"},
            {"model": "bessel_weight_x", "parameter": "2/4", "domain": "C_c^infty(I)"},
            {"model": "bessel_weight_x", "parameter": "0.5", "domain": "C_c^infty(I)"},
        ]
        for x in bad:
            with self.subTest(x=x), self.assertRaises(TraceRejected):
                parse_input(x)


if __name__ == "__main__":
    unittest.main()
