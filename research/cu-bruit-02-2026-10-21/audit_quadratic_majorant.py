"""Validated quadratic majorant for a prime-race low-block sign function.

Independent low phases and block/tail independence remain hypotheses.
The tail need not be symmetric or internally independent.
"""
import argparse
import hashlib
import json
from pathlib import Path
from fractions import Fraction as Q
import time
import flint
from flint import arb, acb, ctx
import audit_density as prior
from audit_density import A, ball, bounds


def compute(data, constants, precision=128, denominator=128, grid_denominator=8):
    assert precision >= 96 and denominator >= 64 and grid_denominator >= 4
    assert flint.__version__ == '0.9.0' and flint.__FLINT_VERSION__ == '3.6.0'
    ctx.prec = precision
    prior.BASE = data
    roots, wlo, whi, _, hashes = prior.inputs(constants)
    amps = []
    labelled = []
    for lo, hi, label in roots:
        gamma = ball(lo, hi)
        weight = 3 if label == '5.4' else 1
        amp = 2*weight/(A(Q(1, 4))+gamma*gamma).sqrt()
        amps.append(amp)
        labelled.append((Q(4*weight*weight)/(Q(1, 4)+hi*hi), amp))
    envelope_C = arb(1)
    for _, amp in sorted(labelled, key=lambda z: z[0], reverse=True)[:12]:
        envelope_C *= (2/(arb.pi()*amp)).sqrt()
    assert envelope_C < 6
    C, T = Q(6), 12
    # Split int t|P(t)| at tau=3/2, using |P|<=min(1,6*t^-6).
    tau = Q(3, 2)
    derivative_upper = (A(tau*tau/2+C/(4*tau**4))/arb.pi()).upper()
    assert derivative_upper < A(Q(1, 2))
    L = Q(1, 2)  # Deliberately coarser analytic bound; no old numeric receipt required.

    # Candidate selected in an exploratory moment-problem calculation, then frozen.
    alpha, beta, eta = Q(67, 200), Q(83, 500), Q(11, 500)
    def quadratic(r):
        return alpha+beta*r+eta*r*r

    left, right = Q(-5), Q(3)
    assert beta+2*eta*left < 0 and quadratic(left) > 0
    assert beta+2*eta*right > 0 and quadratic(right) > 1
    count = T*denominator
    step = Q(1, denominator)
    nodes = []
    for k in range(count+1):
        t = A(k*step)
        p = arb(1)
        for amp in amps:
            p *= (amp*t).bessel_j(0)
        nodes.append((t, p*(1 if k in (0, count) else 4 if k % 2 else 2)))
    var_u = sum((a*a/2 for a in amps), arb(0))
    tail_error = (A(C)/(6*arb.pi()*T**6)).upper()
    rows = []
    samples = int((right-left)*grid_denominator)
    for i in range(samples+1):
        r = left+Q(i, grid_denominator)
        a = 1-r
        integral = arb(0)
        for t, weighted_p in nodes:
            integral += A(a)*(A(a)*t).sinc()*weighted_p
        integral *= A(step/3)
        # a*sinc(at)*P(t) is a times the characteristic function of
        # Uniform[-|a|,|a|]+U. Its fourth derivative is bounded by
        # |a| E Z^4 <= |a|*3*Var(Z)^2, since all fourth cumulants are nonpositive.
        var_z = var_u+A(a*a/3)
        fourth = 3*A(abs(a))*var_z*var_z
        error = (A(Q(T, 180)*step**4)*fourth/arb.pi()).upper()
        g = arb(1)/2-integral/arb.pi()+arb(0, error+tail_error)
        gap = A(quadratic(r))-g
        rows.append(dict(r_exact=str(r), g_interval=bounds(g),
                         gap_interval=bounds(gap), simpson_error_upper=bounds(error)))
    # Cross-check selected endpoints with a different validated quadrature.
    cross_checks = []
    for r in [Q(-5), Q(0), Q(13, 8), Q(3)]:
        if (r-left)*grid_denominator != int((r-left)*grid_denominator):
            continue
        a = 1-r
        def fun(z, _):
            p = acb(1)
            for amp in amps:
                p *= (z*amp).bessel_j(0)
            return A(a)*(A(a)*z).sinc()*p
        integral = acb(0)
        for t in range(0, T, 2):
            integral += acb.integral(fun, t, t+2, abs_tol=A(Q(1, 10**13)),
                rel_tol=A(Q(1, 10**13)), eval_limit=100000, deg_limit=100)
        g_acb = arb(1)/2-integral.real/arb.pi()+arb(0, tail_error)
        row = rows[int((r-left)*grid_denominator)]
        simpson_ball = ball(Q(row['g_interval']['lower_exact']), Q(row['g_interval']['upper_exact']))
        assert simpson_ball.contains(g_acb), 'validated quadratures disagree'
        cross_checks.append(dict(r_exact=str(r), g_by_acb=bounds(g_acb),
            contained_in_simpson=True))
    # If H=Q-g, |H''| <= 2*eta+L. Linear-interpolation remainder on a cell
    # gives H >= min(H(left),H(right))-(2*eta+L)*cell_width^2/8.
    interpolation_loss = (2*eta+L)/(8*grid_denominator**2)
    minimum_gap = min(Q(r['gap_interval']['lower_exact']) for r in rows)
    global_interior_margin = minimum_gap-interpolation_loss
    assert global_interior_margin > 0
    # Left exterior: g is increasing and Q is decreasing up to -5,
    # hence g(r)<=g(-5)<Q(-5)<=Q(r) for r<=-5.
    assert Q(rows[0]['gap_interval']['lower_exact']) > 0
    # Right exterior: Q(r)>=Q(3)>1>=g(r), r>=3 (checked above).
    probability_upper = {}
    for multiplicity in range(1, 11):
        v = multiplicity*whi
        upper = alpha+eta*v
        probability_upper[str(multiplicity)] = dict(
            exact=str(upper), decimal=str(A(upper)), below_half=upper < Q(1, 2))
    assert alpha+eta*9*whi < Q(493, 1000)
    assert alpha+eta*7*whi < Q(458, 1000)
    return dict(status='INTERNAL_CONDITIONAL_GLOBAL_QUADRATIC_MAJORANT',
        precision_bits=precision, simpson_denominator=denominator,
        grid_denominator=grid_denominator, cutoff=T, positive_low_roots=67,
        input_sha256=hashes, quadratic=dict(alpha=str(alpha), beta=str(beta), eta=str(eta)),
        low_characteristic_envelope=dict(C_exact=str(C), power=6, computed_C=bounds(envelope_C)),
        analytic_density_derivative_bound=bounds(derivative_upper),
        reporting_derivative_bound_exact=str(L),
        low_variance=bounds(var_u), low_sign_tail_error=bounds(tail_error),
        left_exterior=dict(endpoint=str(left), quadratic_exact=str(quadratic(left)),
            derivative_exact=str(beta+2*eta*left)),
        right_exterior=dict(endpoint=str(right), quadratic_exact=str(quadratic(right)),
            derivative_exact=str(beta+2*eta*right)),
        sampled_gaps_minimum_lower_exact=str(minimum_gap),
        interpolation_loss_exact=str(interpolation_loss),
        certified_interior_margin_lower_exact=str(global_interior_margin),
        endpoint_samples=rows,
        acb_quadrature_cross_checks=cross_checks,
        linear_tail_mass_interval=[str(wlo), str(whi)],
        sign_probability_upper_by_total_tail_multiplicity=probability_upper,
        sufficient_hypotheses=['GRH for seven primitive L functions',
            'central nonvanishing, supported by pinned internal K certificate',
            'joint rational independence of 67 low positive ordinates',
            'rational spans of low ordinates and active tail have zero intersection',
            'total multiplicity at each tail positive ordinate at most 9'],
        global_parity_required=False, internal_tail_LI_required=False,
        global_hypotheses_proved=False, independent_review=False, originality_claimed=False,
        trust='Python-FLINT 0.9.0 / FLINT 3.6.0 and pinned internal spectral certificates')


if __name__ == '__main__':
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument('--data', type=Path, required=True)
    p.add_argument('--constants', type=Path, required=True)
    p.add_argument('--precision', type=int, default=128)
    p.add_argument('--denominator', type=int, default=128)
    p.add_argument('--grid', type=int, default=8)
    p.add_argument('--out', type=Path, required=True)
    args = p.parse_args()
    start = time.monotonic()
    result = compute(args.data, args.constants, args.precision, args.denominator, args.grid)
    result['seconds'] = round(time.monotonic()-start, 2)
    result['script_sha256'] = hashlib.sha256(Path(__file__).read_bytes()).hexdigest()
    args.out.write_text(json.dumps(result, indent=2)+'\n')
    print(json.dumps(dict(status=result['status'], precision=result['precision_bits'],
        interior_margin=float(Q(result['certified_interior_margin_lower_exact'])),
        bounds={k:v for k,v in result['sign_probability_upper_by_total_tail_multiplicity'].items() if k in ['7','8','9','10']},
        seconds=result['seconds']), indent=2))
