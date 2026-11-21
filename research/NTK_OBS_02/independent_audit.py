#!/usr/bin/env python3
"""Second, separately written exact scalar calculation: no import from primary implementation."""
import argparse
import json
from fractions import Fraction
from pathlib import Path

Q = Fraction


def simplify(x):
    return str(x.numerator) if x.denominator == 1 else str(x)


def scalar_projection_step(x, y, sign, alpha):
    """e <- e-alpha * projector_{(1,sign*2)} e, sign=+1 or -1."""
    inner = (x + 2 * sign * y) / 5
    return x - alpha * inner, y - alpha * 2 * sign * inner


def normloss(v):
    x, y = v
    return (x * x + y * y) / 2


def losses(signs, alpha):
    xy = Q(1), Q(0)
    out = [normloss(xy)]
    states = [xy]
    for sign in signs:
        xy = scalar_projection_step(*xy, sign, alpha)
        states.append(xy)
        out.append(normloss(xy))
    return states, out


def audit():
    # Scalar formulas for P(+), P(-), each projector with rank one, trace one.
    repeated_states, repeated_losses = losses([1, 1], Q(1))
    switched_states, switched_losses = losses([1, -1], Q(1))
    reverse_states, reverse_losses = losses([-1, 1], Q(1))
    assert repeated_losses == [Q(1, 2), Q(2, 5), Q(2, 5)]
    assert switched_losses == [Q(1, 2), Q(2, 5), Q(18, 125)]
    assert switched_states[-1] == (Q(12, 25), Q(6, 25))
    assert reverse_states[-1] == (Q(12, 25), Q(-6, 25))
    assert switched_losses == reverse_losses

    # Continuous sample e^(-tau P) with tau=ln2: attenuation=1/2.
    _, continuous_same = losses([1, 1], Q(1, 2))
    _, continuous_switch = losses([1, -1], Q(1, 2))
    assert continuous_same == [Q(1, 2), Q(17, 40), Q(13, 32)]
    assert continuous_switch == [Q(1, 2), Q(17, 40), Q(1193, 4000)]
    assert continuous_same[-1] - continuous_switch[-1] == Q(27, 250)

    # Two RESET measurements: P_x projects onto (1,0), P_d projects onto (1,1).
    x, y = Q(2), Q(1)
    L0 = (x*x + y*y)/2
    Lx = y*y/2
    Ld = (x-y)**2 / 4
    X11 = 2 * (L0 - Lx)
    X22 = 2 * Lx
    X12 = L0 - 2 * Ld
    assert [L0, Lx, Ld] == [Q(5, 2), Q(1, 2), Q(1, 4)]
    assert [X11, X12, X22] == [Q(4), Q(2), Q(1)]
    for i in range(-3,4):
        for j in range(-3,4):
            q1, q2 = Q(i), Q(j)
            n = (q1*q1 + q2*q2)/2
            xloss = q2*q2/2
            dloss = (q1-q2)**2/4
            assert (2*(n-xloss), n-2*dloss, 2*xloss) == (q1*q1, q1*q2, q2*q2)

    # Simple commutator closed form from rank-one formulas: 12/25.
    comm_upper = Q(12, 25)
    assert comm_upper != 0
    assert switched_states[-1][1] - reverse_states[-1][1] == comm_upper
    # Contraction/operator-norm bound for a 1-step projector substitution.
    gap = repeated_losses[-1] - switched_losses[-1]
    assert gap == Q(32, 125) and gap <= Q(4, 5)

    # Some invariants that are checked separately from the primary script.
    assert Q(1, 5)+Q(4, 5) == 1
    for s in (1, -1):
        assert scalar_projection_step(Q(1), Q(0), s, Q(1)) == (Q(4,5),-s*Q(2,5))

    return {
        "audit_kind": "independently implemented scalar rational formulas, same investigation session",
        "case_discrete_repeated": [simplify(z) for z in repeated_losses],
        "case_discrete_switch": [simplify(z) for z in switched_losses],
        "case_continuous_repeated": [simplify(z) for z in continuous_same],
        "case_continuous_switch": [simplify(z) for z in continuous_switch],
        "two_probe_reconstructed_outer_entries": [simplify(z) for z in (X11, X12, X22)],
        "commutator_upper_right": simplify(comm_upper),
        "max_error": "0", "status": "PASS (finite exact checks only)",
    }


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--check', type=Path)
    parser.add_argument('--write', type=Path)
    a = parser.parse_args()
    text = json.dumps(audit(), ensure_ascii=False, sort_keys=True, indent=2) + '\n'
    if a.check:
        assert a.check.read_text(encoding='utf-8') == text
        print('PASS independent scalar audit and JSON match')
    if a.write:
        a.write.write_text(text, encoding='utf-8')
    if not(a.check or a.write):
        print(text)

if __name__ == '__main__':
    main()
