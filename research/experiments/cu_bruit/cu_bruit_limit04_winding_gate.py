#!/usr/bin/env python3
"""LIMIT-04: adversarial test and explicit sufficient winding certificate gate.

Only the monomial unit-polygon fixtures admit a proven derivative bound here.
For Dirichlet L contour samples from LIMIT-03 the output is NOT_CERTIFIED:
no rigorous segmentwise derivative upper bounds or zero-free enclosures exist.
"""
from __future__ import annotations

import argparse
import cmath
import hashlib
import json
import math
from pathlib import Path


BASE = Path(__file__).resolve().parent


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def sampled_monomial_winding(degree: int, samples: int) -> dict:
    if degree < 1 or samples < 3:
        raise ValueError('degree >= 1 and samples >= 3 required')
    points = [cmath.exp(2j * math.pi * k / samples) for k in range(samples)]
    values = [z ** degree for z in points]
    steps = [cmath.phase(values[(k + 1) % samples] / values[k]) for k in range(samples)]
    observed = round(math.fsum(steps) / (2 * math.pi))
    # Each polygon edge is inside the closed unit disk, so
    # |(z^degree)'| <= degree. All starting values have modulus 1.
    # Edge length <= 2*pi/samples < 44/(7*samples); pi < 22/7.
    # Thus the following INTEGER inequality is a rigorously sufficient
    # no-zero disk condition on each edge (not a numerical assertion).
    proven_segment_bound = 44 * degree < 7 * samples
    result = {
        'degree': degree,
        'samples': samples,
        'true_winding_by_argument_principle': degree,
        'sampled_winding': observed,
        'max_sampled_phase_jump': max(abs(x) for x in steps),
        'bound_proven_by_rational_inequality': proven_segment_bound,
        'certificate_condition': '44*degree < 7*samples',
        'gated_winding': observed if proven_segment_bound else None,
        'gate_status': 'CERTIFIED_BY_ANALYTIC_DERIVATIVE_BOUND' if proven_segment_bound
                       else 'NOT_CERTIFIED',
    }
    assert not proven_segment_bound or observed == degree, result
    return result


def audit_prior_contours() -> dict:
    out = {}
    for height in (25, 40):
        p = BASE / f'cu_bruit_limit03_contour{height}_fine.json'
        d = json.loads(p.read_text())
        counts = {r['character']: r['contour_integer'] for r in d['results']}
        total = sum(counts.values())
        assert total == (67 if height == 25 else 128)
        out[str(height)] = {
            'source_file': p.name,
            'sha256': sha256(p),
            'counts_by_character': counts,
            'sampled_total': total,
            'maximum_observed_phase_increment': max(r['max_single_phase_jump'] for r in d['results']),
            'rigorous_L_derivative_bounds_supplied': False,
            'certified_zero_count': None,
            'gate_status': 'NOT_CERTIFIED',
            'reason': 'No segment-wise rigorous derivative bound or interval enclosure; sampled increments alone are insufficient',
        }
    return out


def main():
    p = argparse.ArgumentParser()
    p.add_argument('--output', default=str(BASE / 'cu_bruit_limit04_results.json'))
    args = p.parse_args()
    cases = [
        sampled_monomial_winding(8, 9),
        sampled_monomial_winding(100, 101),
        sampled_monomial_winding(8, 101),
        sampled_monomial_winding(100, 2048),
    ]
    assert cases[0]['sampled_winding'] == -1 and cases[0]['gate_status'] == 'NOT_CERTIFIED'
    assert cases[1]['sampled_winding'] == -1 and cases[1]['max_sampled_phase_jump'] < 0.1
    assert cases[2]['gated_winding'] == 8
    assert cases[3]['gated_winding'] == 100
    output = {
        'status': 'MATHEMATICAL_INSTRUMENT_AUDIT_NOT_L_ZERO_CERTIFICATE',
        'rigorous_sufficient_condition': ('If on each contour edge from z_i to z_(i+1), '
            'a certified M_i bounds |f_prime| and a certified m_i <= |f(z_i)| '
            'satisfies M_i*edge_length < m_i, then the image stays in a disk '
            'avoiding 0 and the principal sampled phase increments are exact.'),
        'counterexample': ('f(z)=z^(N-1) sampled at N-th roots of unity has sampled '
            'winding -1 but true winding N-1; max observed jump = 2*pi/N.'),
        'adversarial_fixtures': cases,
        'previous_L_contour_audit': audit_prior_contours(),
        'prohibited_promotion': 'Small sampled phase jumps do not imply rigorous zero completeness.',
    }
    Path(args.output).write_text(json.dumps(output, ensure_ascii=False, indent=2) + '\n')
    print('Monomial adversarial and positive controls: PASS')
    for item in cases:
        print('degree=%d samples=%d sampled=%d true=%d jump=%.6f gate=%s' % (
            item['degree'], item['samples'], item['sampled_winding'],
            item['true_winding_by_argument_principle'], item['max_sampled_phase_jump'], item['gate_status']))
    for T, data in output['previous_L_contour_audit'].items():
        print('Dirichlet T=%s previously sampled=%d certified=no' % (T, data['sampled_total']))
    print('LIMIT-04 status: rigorous gate for polynomial fixtures, Dirichlet count OPEN')


if __name__ == '__main__':
    main()