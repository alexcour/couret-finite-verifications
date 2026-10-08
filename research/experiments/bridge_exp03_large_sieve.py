import cmath
import json
import math
import statistics

RES = [1, 7, 11, 13, 17, 19, 23, 29]
P_WINDOWS = [100, 200, 400]
X_RATIOS = [8, 16]
Q_CAPS = [7, 13, 19, 23]

def W(t):
    if t < 1.0 or t > 2.0:
        return 0.0
    return max(0.0, 1.0 - 2.0 * abs(t - 1.5))

def mobius_sieve(n):
    mu = [0] * (n + 1)
    mu[1] = 1
    lp = [0] * (n + 1)
    primes = []
    for i in range(2, n + 1):
        if lp[i] == 0:
            lp[i] = i
            primes.append(i)
            mu[i] = -1
        for p in primes:
            if p > lp[i] or i * p > n:
                break
            lp[i * p] = p
            if p == lp[i]:
                mu[i * p] = 0
            else:
                mu[i * p] = -mu[i]
    return mu

def primes_upto(n):
    sieve = bytearray(b'\x01') * (n + 1)
    if n >= 0:
        sieve[0] = 0
    if n >= 1:
        sieve[1] = 0
    for i in range(2, int(n ** 0.5) + 1):
        if sieve[i]:
            sieve[i * i:n + 1:i] = b'\x00' * (((n - i * i) // i) + 1)
    return [i for i in range(2, n + 1) if sieve[i]]

def b_sequence(X, p, kind, mu):
    out = {}
    mlo = max(1, math.floor(X / p) - 2)
    mhi = math.ceil(2 * X / p) + 2
    for m in range(mlo, mhi + 1):
        if math.gcd(m, 30) != 1:
            continue
        cm = 1 if kind == 'plain' else mu[m]
        if cm == 0:
            continue
        wm = W((p * m) / X)
        if wm == 0:
            continue
        hlo = math.ceil((X - p * m) / 30)
        hhi = math.floor((2 * X - p * m) / 30)
        for h in range(hlo, hhi + 1):
            if h == 0:
                continue
            n = p * m + 30 * h
            if n < 1 or n >= len(mu):
                continue
            cn = 1 if kind == 'plain' else mu[n]
            if cn == 0:
                continue
            wn = W(n / X)
            if wn == 0:
                continue
            out[h] = out.get(h, 0.0) + cn * cm * wn * wm
    return out

def freq_family(Q):
    freqs = [(0, 1)]
    seen = {(0, 1)}
    for q in range(2, Q + 1):
        if math.gcd(q, 30) != 1:
            continue
        for a in range(1, q):
            if math.gcd(a, q) != 1:
                continue
            key = (a, q)
            if key not in seen:
                seen.add(key)
                freqs.append(key)
    return freqs

def fourier_sum(b, a, q):
    total = 0j
    for h, v in b.items():
        total += v * cmath.exp(-2j * math.pi * a * h / q)
    return total

def sieve_metrics(b, Q):
    if not b:
        return {'N': 0, 'energy': 0.0, 'freq_count': 0, 'family_energy': 0.0, 'nonzero_family_energy': 0.0, 'bound': 0.0, 'sat_full': 0.0, 'sat_nonzero': 0.0, 'lambda': 0.0, 'zero_share_family': 0.0}
    hmin = min(b)
    hmax = max(b)
    N = hmax - hmin + 1
    energy = sum(v * v for v in b.values())
    freqs = freq_family(Q)
    vals = []
    for a, q in freqs:
        s = fourier_sum(b, a, q)
        vals.append((a, q, abs(s) ** 2))
    family_energy = sum(v for _, _, v in vals)
    zero_energy = next(v for a, q, v in vals if a == 0 and q == 1)
    nonzero_family_energy = family_energy - zero_energy
    bound = (N - 1 + Q * Q) * energy if energy > 0 else 0.0
    return {
        'N': N,
        'energy': energy,
        'freq_count': len(freqs),
        'family_energy': family_energy,
        'nonzero_family_energy': nonzero_family_energy,
        'bound': bound,
        'sat_full': family_energy / bound if bound > 0 else 0.0,
        'sat_nonzero': nonzero_family_energy / bound if bound > 0 else 0.0,
        'lambda': (Q * Q) / N,
        'zero_share_family': zero_energy / family_energy if family_energy > 0 else 0.0,
    }

def mean(xs):
    return sum(xs) / len(xs) if xs else 0.0

maxX = max(P_WINDOWS) * max(X_RATIOS)
maxn = int(2 * maxX + 1000)
mu = mobius_sieve(maxn)
primes = primes_upto(2 * max(P_WINDOWS) + 100)
rows = []
for P in P_WINDOWS:
    ps = [p for p in primes if P < p <= 2 * P and math.gcd(p, 30) == 1]
    for ratio in X_RATIOS:
        X = P * ratio
        for kind in ['plain', 'inverse']:
            for p in ps:
                b = b_sequence(X, p, kind, mu)
                for Q in Q_CAPS:
                    rows.append({'P': P, 'ratio': ratio, 'X': X, 'kind': kind, 'p': p, 'Q': Q, **sieve_metrics(b, Q)})

max_sat = max(r['sat_full'] for r in rows)
if max_sat > 1.000000001:
    raise AssertionError('large-sieve ratio exceeded 1: %r' % max_sat)

summaries = []
for kind in ['plain', 'inverse']:
    for P in P_WINDOWS:
        for ratio in X_RATIOS:
            for Q in Q_CAPS:
                sub = [r for r in rows if r['kind'] == kind and r['P'] == P and r['ratio'] == ratio and r['Q'] == Q]
                summaries.append({
                    'kind': kind,
                    'P': P,
                    'ratio': ratio,
                    'Q': Q,
                    'nprimes': len(sub),
                    'mean_N': mean([r['N'] for r in sub]),
                    'mean_lambda': mean([r['lambda'] for r in sub]),
                    'mean_sat_full': mean([r['sat_full'] for r in sub]),
                    'mean_sat_nonzero': mean([r['sat_nonzero'] for r in sub]),
                    'mean_zero_share_family': mean([r['zero_share_family'] for r in sub]),
                    'max_sat_full': max(r['sat_full'] for r in sub),
                    'max_sat_nonzero': max(r['sat_nonzero'] for r in sub),
                })

aggregates = []
for kind in ['plain', 'inverse']:
    sub = [r for r in rows if r['kind'] == kind]
    aggregates.append({
        'kind': kind,
        'nrows': len(sub),
        'mean_sat_full': mean([r['sat_full'] for r in sub]),
        'mean_sat_nonzero': mean([r['sat_nonzero'] for r in sub]),
        'median_sat_nonzero': statistics.median([r['sat_nonzero'] for r in sub]),
        'max_sat_full': max(r['sat_full'] for r in sub),
        'max_sat_nonzero': max(r['sat_nonzero'] for r in sub),
        'mean_zero_share_family': mean([r['zero_share_family'] for r in sub]),
    })

by_q = []
for kind in ['plain', 'inverse']:
    for Q in Q_CAPS:
        sub = [r for r in rows if r['kind'] == kind and r['Q'] == Q]
        by_q.append({
            'kind': kind,
            'Q': Q,
            'mean_lambda': mean([r['lambda'] for r in sub]),
            'mean_sat_full': mean([r['sat_full'] for r in sub]),
            'mean_sat_nonzero': mean([r['sat_nonzero'] for r in sub]),
            'mean_zero_share_family': mean([r['zero_share_family'] for r in sub]),
        })

out = {
    'protocol': {
        'P_WINDOWS': P_WINDOWS,
        'X_RATIOS': X_RATIOS,
        'Q_CAPS': Q_CAPS,
        'window': 'tent support [1,2], peak 1 at 1.5',
        'frequency_family': 'reduced a/q with q<=Q, gcd(q,30)=1, plus zero frequency',
        'large_sieve_bound': '(N-1+Q^2)*sum_h |b_h|^2',
        'primary_metric': 'sat_nonzero',
        'secondary_metric': 'sat_full',
    },
    'aggregates': aggregates,
    'by_q': by_q,
    'summaries': summaries,
    'max_observed_sat_full': max_sat,
}

with open('bridge_exp03_results.json', 'w') as f:
    json.dump(out, f, indent=2)

print(json.dumps({'protocol': out['protocol'], 'aggregates': aggregates, 'by_q': by_q, 'max_observed_sat_full': max_sat}, indent=2))
