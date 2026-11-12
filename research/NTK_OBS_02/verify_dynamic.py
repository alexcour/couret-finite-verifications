#!/usr/bin/env python3
"""NTK-OBS-02, deterministic exact-rational computations; no external dependency.

Mathematical objects: 2x2 orthogonal projectors, switched linear kernel flows,
loss-only observability under RESET experiments.
No claim is made about trained neural networks or mathematical novelty.
"""
import argparse
import json
from fractions import Fraction as F
from pathlib import Path

Z, O = F(0), F(1)
P_PLUS = ((F(1, 5), F(2, 5)), (F(2, 5), F(4, 5)))
P_MINUS = ((F(1, 5), -F(2, 5)), (-F(2, 5), F(4, 5)))
P_X = ((O, Z), (Z, Z))
P_DIAG = ((F(1, 2), F(1, 2)), (F(1, 2), F(1, 2)))
REFLECTION = ((O, Z), (Z, -O))
I = ((O, Z), (Z, O))


def matmul(A, B):
    return tuple(tuple(sum((A[i][k] * B[k][j] for k in range(len(B))), Z)
                       for j in range(len(B[0]))) for i in range(len(A)))


def add(A, B):
    return tuple(tuple(a + b for a, b in zip(row_a, row_b)) for row_a, row_b in zip(A, B))


def scale(c, A):
    return tuple(tuple(c * a for a in row) for row in A)


def transpose(A):
    return tuple(zip(*A))


def mv(A, v):
    return tuple(sum((a * b for a, b in zip(row, v)), Z) for row in A)


def outer(v):
    return tuple(tuple(x * y for y in v) for x in v)


def dot(v, w):
    return sum((x * y for x, y in zip(v, w)), Z)


def loss(v):
    return dot(v, v) / 2


def tr(A):
    return sum((A[i][i] for i in range(len(A))), Z)


def step(e, P, contraction=Z):
    """Projector update exp(-tau P) for exp(-tau) = contraction in [0,1]."""
    return mv(add(I, scale(contraction - 1, P)), e)


def evolve(e0, schedule, contraction=Z):
    e = e0
    states = [e]
    for P in schedule:
        e = step(e, P, contraction)
        states.append(e)
    return states


def serialize(v):
    if isinstance(v, F):
        return str(v.numerator) if v.denominator == 1 else f"{v.numerator}/{v.denominator}"
    if isinstance(v, dict):
        return {k: serialize(x) for k, x in v.items()}
    if isinstance(v, (tuple, list)):
        return [serialize(x) for x in v]
    if isinstance(v, bool) or isinstance(v, (str, int)):
        return v
    raise TypeError(type(v))


def verify_projectors():
    for P in [P_PLUS, P_MINUS, P_X, P_DIAG]:
        assert matmul(P, P) == P
        assert transpose(P) == P
        assert tr(P) == O
    assert matmul(REFLECTION, REFLECTION) == I
    assert matmul(matmul(REFLECTION, P_PLUS), REFLECTION) == P_MINUS
    assert matmul(matmul(REFLECTION, P_MINUS), REFLECTION) == P_PLUS
    return True


def reconstruction(loss_0, loss_x, loss_diag):
    """2 reset projectors plus L0 uniquely recover X=ee^T in R^2."""
    x2 = 2 * (loss_0 - loss_x)
    y2 = 2 * loss_x
    xy = loss_0 - 2 * loss_diag
    return ((x2, xy), (xy, y2))


def lifted_states(e0, schedule, contraction=Z):
    X = outer(e0)
    Xs = [X]
    for P in schedule:
        G = add(I, scale(contraction - 1, P))
        X = matmul(matmul(G, X), transpose(G))
        Xs.append(X)
    return Xs


def main_result():
    verify_projectors()
    e0 = (O, Z)
    same_schedule = [P_PLUS, P_PLUS]
    switched_schedule = [P_PLUS, P_MINUS]

    # eta=1, orthogonal projection update: e_next=(I-P)e.
    ss = evolve(e0, same_schedule)
    sv = evolve(e0, switched_schedule)
    assert ss == [(O, Z), (F(4, 5), -F(2, 5)), (F(4, 5), -F(2, 5))]
    assert sv == [(O, Z), (F(4, 5), -F(2, 5)), (F(12, 25), F(6, 25))]
    ls = [loss(e) for e in ss]
    lv = [loss(e) for e in sv]
    assert ls == [F(1, 2), F(2, 5), F(2, 5)]
    assert lv == [F(1, 2), F(2, 5), F(18, 125)]

    # Each kernel has the SAME two eigenvalues and SAME e0-weighted spectral measure.
    # Weight on eigenvalue 1 is <e0,P e0>; on eigenvalue 0 is ||e0||^2 minus it.
    weights = [(dot(e0, mv(P, e0)), dot(e0, e0) - dot(e0, mv(P, e0)))
               for P in (P_PLUS, P_MINUS)]
    assert weights == [(F(1, 5), F(4, 5))] * 2

    # Exact loss recursion with state-dependent moments; P^2=P and eta=1.
    e1 = sv[1]
    a_plus = dot(e1, mv(P_PLUS, e1))
    a_minus = dot(e1, mv(P_MINUS, e1))
    assert a_plus == Z and a_minus == F(64, 125)
    assert lv[2] == lv[1] - a_minus / 2
    assert ls[2] == ls[1] - a_plus / 2

    # Nonzero commutator, but swapped order cannot be distinguished by LOSS for e0.
    comm = add(matmul(P_PLUS, P_MINUS), scale(-O, matmul(P_MINUS, P_PLUS)))
    assert comm == ((Z, F(12, 25)), (-F(12, 25), Z))
    swapped = evolve(e0, [P_MINUS, P_PLUS])
    assert swapped[2] == (F(12, 25), -F(6, 25))
    assert loss(swapped[2]) == loss(sv[2]) == F(18, 125)
    assert swapped[2] != sv[2]

    # Global orthogonal symmetry fixes e0 and preserves whole loss sequence.
    sched_a = [P_PLUS, P_MINUS, P_PLUS, P_MINUS, P_PLUS, P_MINUS]
    sched_b = [P_MINUS, P_PLUS, P_MINUS, P_PLUS, P_MINUS, P_PLUS]
    ga = evolve(e0, sched_a)
    gb = evolve(e0, sched_b)
    assert all(mv(REFLECTION, ga[t]) == gb[t] for t in range(7))
    assert all(loss(ga[t]) == loss(gb[t]) for t in range(7))
    assert any(ga[t] != gb[t] for t in range(1, 7))

    # Continuous ODE de/dt=-P_t e, piecewise constant P: exp(-(ln 2)P)=I-P/2.
    # sampling times 0, ln(2), 2ln(2): exact rational despite logarithmic times.
    continuous_a = evolve(e0, same_schedule, F(1, 2))
    continuous_b = evolve(e0, switched_schedule, F(1, 2))
    cla = [loss(e) for e in continuous_a]
    clb = [loss(e) for e in continuous_b]
    assert continuous_a[1] == continuous_b[1] == (F(9, 10), -F(1, 5))
    assert cla == [F(1, 2), F(17, 40), F(13, 32)]
    assert clb == [F(1, 2), F(17, 40), F(1193, 4000)]
    assert cla[2] - clb[2] == F(27, 250)
    assert all(cla[t + 1] <= cla[t] and clb[t + 1] <= clb[t] for t in range(2))

    # Matrix state X=ee^T closes under arbitrary prescribed time-varying kernels.
    lifted = lifted_states(e0, sched_a)
    assert all(X == outer(e) for X, e in zip(lifted, ga))
    assert all(tr(X) / 2 == loss(e) for X, e in zip(lifted, ga))

    # Phase retrieval with RESET oracle; eta=1 and two rank-one projectors.
    probe_e = (F(2), O)
    L0 = loss(probe_e)
    Lx = loss(step(probe_e, P_X))
    Ldiag = loss(step(probe_e, P_DIAG))
    X = reconstruction(L0, Lx, Ldiag)
    assert (L0, Lx, Ldiag) == (F(5, 2), F(1, 2), F(1, 4))
    assert X == ((F(4), F(2)), (F(2), O))
    for x in range(-3, 4):
        for y in range(-3, 4):
            v = (F(x), F(y))
            assert reconstruction(loss(v), loss(step(v, P_X)),
                                  loss(step(v, P_DIAG))) == outer(v)
    # One rank-one probe plus known L0 does NOT distinguish these states.
    ambiguity_a, ambiguity_b = (O, O), (O, -O)
    assert loss(ambiguity_a) == loss(ambiguity_b)
    assert loss(step(ambiguity_a, P_X)) == loss(step(ambiguity_b, P_X))
    assert outer(ambiguity_a) != outer(ambiguity_b)

    # Conservative cumulative perturbation bound; ||Pplus - Pminus||_2=4/5.
    delta_kernel_norm = F(4, 5)
    delta_loss = ls[2] - lv[2]
    assert delta_loss == F(32, 125)
    assert delta_loss <= delta_kernel_norm * dot(e0, e0)

    return serialize({
        "project": "NTK-OBS-02", "date": "2026-10-11",
        "status": "bounded exact rational verification; classical; external review open",
        "projectors": {"P_plus": P_PLUS, "P_minus": P_MINUS,
                       "commutator_Pplus_Pminus": comm,
                       "e0_weight_on_lambda_1_and_0": weights},
        "discrete_counterexample": {
            "eta": O, "e0": e0,
            "losses_repeated_Pplus": ls, "losses_switched_Pplus_Pminus": lv,
            "second_step_gap": delta_loss,
            "current_state_quadratic_Pplus_Pminus": [a_plus, a_minus]},
        "order_and_gauge": {
            "swapped_final_states": [sv[2], swapped[2]],
            "swapped_final_losses_equal": loss(sv[2]) == loss(swapped[2]),
            "gauge_loss_trace_length_seven": [loss(v) for v in ga],
            "gauge_states_different_but_losses_equal": True},
        "continuous_piecewise": {
            "sample_times": ["0", "ln(2)", "2ln(2)"],
            "contraction_exp_minus_ln2": F(1, 2),
            "losses_repeated_Pplus": cla,
            "losses_switched_Pplus_Pminus": clb,
            "final_gap": cla[2] - clb[2]},
        "reset_reconstruction_R2": {
            "probe_state": probe_e, "L0": L0, "L_after_Px": Lx,
            "L_after_Pdiag": Ldiag, "reconstructed_outer": X,
            "grid_exact_checks": 49,
            "one_probe_counterexample_states": [ambiguity_a, ambiguity_b]},
        "stability_bound": {"kernel_operator_norm_gap": delta_kernel_norm,
                            "loss_difference": delta_loss, "bound_holds": True},
    })


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", type=Path, help="Compare bytewise to results.json")
    parser.add_argument("--write", type=Path, help="Write deterministic JSON")
    args = parser.parse_args()
    content = json.dumps(main_result(), ensure_ascii=False, sort_keys=True, indent=2) + "\n"
    if args.check:
        assert args.check.read_text(encoding="utf-8") == content, "results.json mismatch"
        print("PASS exact model and exact archived results")
    if args.write:
        args.write.write_text(content, encoding="utf-8")
    if not (args.check or args.write):
        print(content)


if __name__ == "__main__":
    main()
