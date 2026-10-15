"""CONT-P v1.12: post-hoc finite calculus, no sieve and no parameter selection."""
from pathlib import Path
from math import gcd, log, expm1
import argparse, hashlib, json
import numpy as np

ROOT = Path(__file__).resolve().parent
UNITS = (1, 7, 11, 13, 17, 19, 23, 29)
X = np.array([x for x in range(2310) if gcd(x, 2310) == 1])
Y = np.array([y for y in range(30030) if gcd(y, 30030) == 1])
XI = {int(x): i for i, x in enumerate(X)}
PARENT = np.array([XI[int(y % 2310)] for y in Y])
AI = np.array([UNITS.index(int(x % 30)) for x in X])
COEF_HASH = 'db4523b9610fd0c54f3334ecdf4af2bc197cee2e8c28677807cebf698955bfa9'

def coefficients():
    path = ROOT / 'data/C2_FULL_Q30_NUMERICAL_v1.6.json'
    assert hashlib.sha256(path.read_bytes()).hexdigest() == COEF_HASH
    raw = json.loads(path.read_text())
    c = np.array([[raw['matrix'][str(a)][str(z)] for z in UNITS] for a in UNITS])
    a = (c-c.T)/2
    k = np.array([[0 if u == v else (15-(v-u)%30)/15 for v in UNITS] for u in UNITS])
    theta = (a*k).sum()/(k*k).sum()
    residual = a-theta*k
    return c, k, residual, float(theta)

def wheel(q, y, t):
    rho = q / ((480 if q == 2310 else 5760)*log(t))
    assert 0 < rho < 1
    alpha = 1-rho
    out = np.zeros(8)
    h = used = 0
    weight = rho
    while used < 160:
        h += 1
        if gcd(y+h, q) != 1:
            continue
        out[UNITS.index((y+h) % 30)] += weight
        weight *= alpha
        used += 1
    out /= -expm1(160*log(alpha))
    assert np.all(out > 0)
    return out

def setup(training, window, k, residual):
    t = sum(window)/2
    lt = log(t)
    c1 = np.array([[.5-4*(u == v) for v in UNITS] for u in UNITS])
    f1t = 1+c1*log(lt)/lt
    components = []
    for item in training:
        s = sum(item['window'])/2
        ls = log(s)
        counts = np.array(item['parent_counts'], dtype=float)
        assert counts.shape == (480, 8) and np.all(counts >= 0)
        n = counts.sum(axis=1)
        assert np.all(n > 0)
        f1s = 1+c1*log(ls)/ls
        delta = 1/lt-1/ls
        u0 = counts*(f1t/f1s*np.exp(16*k*delta))[AI]
        u0 /= u0.sum(axis=1)[:, None]
        components.append((u0, residual[AI]*delta, n))
    mass = sum(x[2] for x in components)
    wq = np.array([wheel(2310, int(x), t) for x in X])
    wQ = np.array([wheel(30030, int(y), t) for y in Y])
    lift = wQ/wq[PARENT]
    return components, mass, lift

def curve(beta, state):
    components, mass, lift = state
    v = np.zeros((480, 8)); v1 = np.zeros_like(v); v2 = np.zeros_like(v)
    for u0, h, n in components:
        u = u0*np.exp(beta*h)
        u /= u.sum(axis=1)[:, None]
        centered = h-(u*h).sum(axis=1)[:, None]
        variance = (u*centered**2).sum(axis=1)[:, None]
        u1 = u*centered
        u2 = u*(centered**2-variance)
        weights = (n/mass)[:, None]
        v += weights*u; v1 += weights*u1; v2 += weights*u2
    b = lift*v[PARENT]; b1 = lift*v1[PARENT]; b2 = lift*v2[PARENT]
    z = b.sum(axis=1)[:, None]
    z1 = b1.sum(axis=1)[:, None]; z2 = b2.sum(axis=1)[:, None]
    q = b/z
    q1 = b1/z-q*z1/z
    q2 = b2/z-2*b1*z1/z**2-q*z2/z+2*q*(z1/z)**2
    assert np.all(q >= 0) and np.max(abs(q.sum(axis=1)-1)) < 2e-14
    assert np.max(abs(q1.sum(axis=1))) < 2e-14
    assert np.max(abs(q2.sum(axis=1))) < 2e-14
    return q, q1, q2

def risk(counts, q, q1, q2):
    n = counts.sum(axis=1)
    total = n.sum()
    loss = ((1-2*q)*counts).sum() + (n*(q*q).sum(axis=1)).sum()
    residual = n[:, None]*q-counts
    first = 2*(residual*q1).sum()/total
    second = 2*((n*(q1*q1).sum(axis=1)).sum()+(residual*q2).sum())/total
    return float(loss/total), float(first), float(second)

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--output')
    parser.add_argument('--source-v1-11', type=Path)
    args = parser.parse_args()
    data = json.loads((ROOT/'data/finite_inputs.json').read_text())
    c, k, residual, theta = coefficients()
    rows = []; all_equiv = 0; source_seen = args.source_v1_11 is not None
    names = {0: 'Bgap16', .5: 'Bgap16_Rhalf', 1: 'Bgap16_Rplus'}
    total_n = sum(w['pairs'] for w in data['windows'])
    pooled = {beta: np.zeros(3) for beta in names}
    for w in data['windows']:
        counts = np.array(w['counts'], dtype=np.int64)
        assert counts.shape == (5760, 8) and int(counts.sum()) == w['pairs']
        state = setup(data['training'], w['window'], k, residual)
        gauge = setup(data['training'], w['window'], k, residual+np.arange(8)[:,None]/10)
        source = None
        if source_seen:
            with np.load(args.source_v1_11/f"run/pred_{w['window'][0]}.npz") as z:
                source = {key: z[key] for key in names.values()}
        for beta, name in names.items():
            q, q1, q2 = curve(beta, state)
            metrics = risk(counts, q, q1, q2)
            assert abs(metrics[0]-w['expected_brier'][name]) < 1e-12
            # Finite differences of the full curve, including pooling and lift.
            step = .001
            plus = curve(beta+step, state)[0]; minus = curve(beta-step, state)[0]
            d1_error = float(np.max(abs((plus-minus)/(2*step)-q1)))
            d2_error = float(np.max(abs((plus-2*q+minus)/step**2-q2)))
            assert d1_error < 1e-9 and d2_error < 3e-9
            fplus = risk(counts, plus, q1, q2)[0]
            fminus = risk(counts, minus, q1, q2)[0]
            risk_d1_error = abs((fplus-fminus)/(2*step)-metrics[1])
            risk_d2_error = abs((fplus-2*metrics[0]+fminus)/step**2-metrics[2])
            assert risk_d1_error < 1e-9 and risk_d2_error < 3e-9
            gauge_error = float(np.max(abs(curve(beta,gauge)[0]-q)))
            assert gauge_error < 2e-14
            equivalence = None if source is None else float(np.max(abs(source[name]-q)))
            if equivalence is not None:
                assert equivalence < 1e-12
                all_equiv = max(all_equiv, equivalence)
            pooled[beta] += w['pairs']/total_n*np.array(metrics)
            rows.append({'window': w['window'], 'beta': beta, 'brier': metrics[0],
                         'brier_derivative': metrics[1], 'brier_second_derivative':metrics[2],
                         'forecast_d1_fd_error': d1_error, 'forecast_d2_fd_error': d2_error,
                         'risk_d1_fd_error':risk_d1_error,'risk_d2_fd_error':risk_d2_error,
                         'row_gauge_error':gauge_error,'source_forecast_error':equivalence})
    report = {'status':'PASS', 'role':'POSTHOC_FINITE_CALCULUS_NO_SELECTION',
              'new_prime_windows':0,'new_fitted_parameters':0,'beta_deployed':.5,
              'theta_geo':theta,'pairs':total_n,'windows':rows,
              'pooled':{str(beta): {'brier':float(x[0]),'derivative':float(x[1]),
                                   'second_derivative':float(x[2])} for beta,x in pooled.items()},
              'source_forecasts_checked_all_states':source_seen,
              'max_source_forecast_error':all_equiv if source_seen else None,
              'finite_difference_step':.001}
    if args.output:
        Path(args.output).write_text(json.dumps(report,indent=2)+'\n')
    print(json.dumps(report,indent=2))

if __name__ == '__main__':
    main()
