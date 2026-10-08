import cmath, csv, hashlib, json, math, random, statistics
from collections import defaultdict

P_WINDOWS = [100, 200, 400, 800, 1600]
X_RATIOS = [8, 16]
KINDS = ['plain', 'squarefree', 'inverse']
BOOTSTRAP_REPS = 512
SEED = 20261008
FIT_WINDOWS = [400, 800, 1600]

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
            mu[i * p] = 0 if p == lp[i] else -mu[i]
    return mu

def primes_upto(n):
    sieve = bytearray(b'\x01') * (n + 1)
    if n >= 0: sieve[0] = 0
    if n >= 1: sieve[1] = 0
    for i in range(2, int(n ** 0.5) + 1):
        if sieve[i]:
            sieve[i * i:n + 1:i] = b'\x00' * (((n - i * i) // i) + 1)
    return [i for i in range(2, n + 1) if sieve[i]]

def coeff(n, kind, mu):
    if n < 1 or math.gcd(n, 30) != 1:
        return 0
    if kind == 'plain':
        return 1
    if kind == 'squarefree':
        return abs(mu[n])
    if kind == 'inverse':
        return mu[n]
    raise ValueError(kind)

def b_sequence(X, p, kind, mu):
    out = defaultdict(float)
    mlo = max(1, math.floor(X / p) - 2)
    mhi = math.ceil(2 * X / p) + 2
    for m in range(mlo, mhi + 1):
        cm = coeff(m, kind, mu)
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
            cn = coeff(n, kind, mu)
            if cn == 0:
                continue
            wn = W(n / X)
            if wn == 0:
                continue
            out[h] += cn * cm * wn * wm
    return {h: v for h, v in out.items() if v != 0.0}

def choose_Q_from_X(X):
    href = 2.0 * X / 30.0
    target = math.sqrt(href)
    lo = max(7, int(math.floor(target)) - 3)
    hi = int(math.ceil(target)) + 4
    candidates = [q for q in range(lo, hi + 1) if math.gcd(q, 30) == 1]
    if not candidates:
        q = 7
        while math.gcd(q, 30) != 1:
            q += 1
        return q
    return min(candidates, key=lambda q: (abs(q - target), q))

def packet_dft_energy(b, q):
    H = [0j] * q
    for h, v in b.items():
        H[h % q] += v
    vals = []
    for a in range(q):
        s = 0j
        for r, x in enumerate(H):
            if x:
                s += x * cmath.exp(-2j * math.pi * a * r / q)
        vals.append(s)
    lhs = sum(abs(z) ** 2 for z in vals)
    rhs = q * sum(abs(x) ** 2 for x in H)
    rel = abs(lhs - rhs) / max(1.0, abs(rhs))
    if rel > 1e-10:
        raise AssertionError(('parseval', q, lhs, rhs, rel))
    return vals

def reduced_freq_energy(b, Q):
    zero = abs(sum(b.values())) ** 2
    family = zero
    count = 1
    seen = {(0, 1)}
    for q in range(2, Q + 1):
        if math.gcd(q, 30) != 1:
            continue
        vals = packet_dft_energy(b, q)
        for a in range(1, q):
            if math.gcd(a, q) != 1:
                continue
            key = (a, q)
            if key in seen:
                raise AssertionError(('duplicate-frequency', key))
            seen.add(key)
            family += abs(vals[a]) ** 2
            count += 1
    return family, family - zero, zero, count

def quantile(xs, p):
    ys = sorted(xs)
    if not ys:
        return None
    if len(ys) == 1:
        return ys[0]
    k = (len(ys) - 1) * p
    f = math.floor(k); c = math.ceil(k)
    if f == c:
        return ys[int(k)]
    return ys[f] * (c - k) + ys[c] * (k - f)

def linear_slope(xs, ys):
    mx = sum(xs) / len(xs); my = sum(ys) / len(ys)
    den = sum((x - mx) ** 2 for x in xs)
    if den == 0:
        return 0.0
    return sum((x - mx) * (y - my) for x, y in zip(xs, ys)) / den

def tiny_checks(mu):
    X = 180
    p = 11
    for kind in KINDS:
        b = b_sequence(X, p, kind, mu)
        for q in [7, 11]:
            vals = packet_dft_energy(b, q)
            for a in range(q):
                direct = sum(v * cmath.exp(-2j * math.pi * a * h / q) for h, v in b.items())
                if abs(direct - vals[a]) > 1e-9:
                    raise AssertionError(('direct-vs-packet', kind, q, a, direct, vals[a]))

def summarize_rows(rows):
    summaries = []
    for P in P_WINDOWS:
        for ratio in X_RATIOS:
            for kind in KINDS:
                sub = [r for r in rows if r['P'] == P and r['ratio'] == ratio and r['kind'] == kind]
                vals = [r['sat_nonzero'] for r in sub]
                summaries.append({
                    'P': P, 'ratio': ratio, 'kind': kind, 'nprimes': len(sub),
                    'mean_sat_nonzero': sum(vals)/len(vals),
                    'median_sat_nonzero': statistics.median(vals),
                    'q1_sat_nonzero': quantile(vals, 0.25),
                    'q3_sat_nonzero': quantile(vals, 0.75),
                    'min_sat_nonzero': min(vals),
                    'max_sat_nonzero': max(vals),
                    'mean_lambda': sum(r['lambda_actual'] for r in sub)/len(sub),
                    'median_Ngeom': statistics.median(r['Ngeom'] for r in sub),
                    'zero_energy_count': sum(1 for r in sub if r['energy'] == 0),
                    'mean_zero_share_family': sum(r['zero_share_family'] for r in sub)/len(sub),
                })
    return summaries

def slope_from_summary(summaries, ratio, kind):
    sub = [s for s in summaries if s['ratio'] == ratio and s['kind'] == kind and s['P'] in FIT_WINDOWS]
    sub.sort(key=lambda x: x['P'])
    ys = [s['mean_sat_nonzero'] for s in sub]
    if any(y <= 0 for y in ys):
        return None
    return linear_slope([math.log(s['P']) for s in sub], [math.log(y) for y in ys])

def bootstrap_slopes(rows, ratio, kind):
    rng = random.Random(SEED + ratio * 100 + KINDS.index(kind))
    groups = {}
    for P in FIT_WINDOWS:
        groups[P] = [r['sat_nonzero'] for r in rows if r['P'] == P and r['ratio'] == ratio and r['kind'] == kind]
    slopes = []
    for _ in range(BOOTSTRAP_REPS):
        means = []
        valid = True
        for P in FIT_WINDOWS:
            g = groups[P]
            sample = [g[rng.randrange(len(g))] for _ in range(len(g))]
            m = sum(sample) / len(sample)
            if m <= 0:
                valid = False
                break
            means.append(m)
        if valid:
            slopes.append(linear_slope([math.log(P) for P in FIT_WINDOWS], [math.log(x) for x in means]))
    return {'n': len(slopes), 'p05': quantile(slopes, 0.05), 'p50': quantile(slopes, 0.50), 'p95': quantile(slopes, 0.95)}

maxX = max(P_WINDOWS) * max(X_RATIOS)
maxn = int(2 * maxX + 5000)
mu = mobius_sieve(maxn)
primes = primes_upto(2 * max(P_WINDOWS) + 100)
tiny_checks(mu)

rows = []
for P in P_WINDOWS:
    ps = [p for p in primes if P < p <= 2 * P and math.gcd(p, 30) == 1]
    for ratio in X_RATIOS:
        X = P * ratio
        Q = choose_Q_from_X(X)
        if math.gcd(Q, 30) != 1:
            raise AssertionError(('bad-Q', X, Q))
        for p in ps:
            b_plain = b_sequence(X, p, 'plain', mu)
            if not b_plain:
                raise AssertionError(('empty-plain', P, ratio, p))
            hmin = min(b_plain); hmax = max(b_plain)
            Ngeom = hmax - hmin + 1
            if Ngeom <= 0:
                raise AssertionError(('bad-Ngeom', P, ratio, p, Ngeom))
            for kind in KINDS:
                b = b_plain if kind == 'plain' else b_sequence(X, p, kind, mu)
                Nobserved = (max(b) - min(b) + 1) if b else 0
                if Nobserved > Ngeom:
                    raise AssertionError(('support-overflow', P, ratio, p, kind, Nobserved, Ngeom))
                energy = sum(v * v for v in b.values())
                if energy <= 0:
                    fam = nonzero = zero = 0.0; count = 1
                    sat_full = sat_nonzero = zero_share = 0.0
                else:
                    fam, nonzero, zero, count = reduced_freq_energy(b, Q)
                    bound = (Ngeom - 1 + Q * Q) * energy
                    sat_full = fam / bound
                    sat_nonzero = nonzero / bound
                    zero_share = zero / fam if fam > 0 else 0.0
                    if sat_full < -1e-12 or sat_full > 1 + 1e-8:
                        raise AssertionError(('large-sieve', P, ratio, p, kind, Q, Ngeom, sat_full))
                    if sat_nonzero < -1e-12 or sat_nonzero > 1 + 1e-8:
                        raise AssertionError(('large-sieve-nz', P, ratio, p, kind, Q, Ngeom, sat_nonzero))
                rows.append({
                    'P': P, 'ratio': ratio, 'X': X, 'p': p, 'kind': kind,
                    'Q': Q, 'Ngeom': Ngeom, 'Nobserved': Nobserved,
                    'lambda_actual': Q * Q / Ngeom,
                    'energy': energy, 'freq_count': count,
                    'sat_full': sat_full, 'sat_nonzero': sat_nonzero,
                    'zero_share_family': zero_share,
                })

with open('bridge_exp04b_rows.csv', 'w', newline='') as f:
    w = csv.DictWriter(f, fieldnames=list(rows[0].keys()))
    w.writeheader(); w.writerows(rows)

summaries = summarize_rows(rows)
slopes = []
for ratio in X_RATIOS:
    for kind in KINDS:
        beta = slope_from_summary(summaries, ratio, kind)
        boot = bootstrap_slopes(rows, ratio, kind)
        slopes.append({'ratio': ratio, 'kind': kind, 'slope': beta, 'bootstrap': boot})

strong_decay = True
for ratio in X_RATIOS:
    s = next(x for x in slopes if x['kind'] == 'inverse' and x['ratio'] == ratio)
    means = [next(z for z in summaries if z['P'] == P and z['ratio'] == ratio and z['kind'] == 'inverse')['mean_sat_nonzero'] for P in FIT_WINDOWS]
    if not (means[0] > means[1] > means[2] and s['slope'] <= -0.25 and s['bootstrap']['p95'] < 0):
        strong_decay = False

sign_effect = True
signs = []
for ratio in X_RATIOS:
    for P in FIT_WINDOWS:
        inv = next(z for z in summaries if z['P'] == P and z['ratio'] == ratio and z['kind'] == 'inverse')['mean_sat_nonzero']
        sqf = next(z for z in summaries if z['P'] == P and z['ratio'] == ratio and z['kind'] == 'squarefree')['mean_sat_nonzero']
        d = inv - sqf
        if abs(d) < 0.01:
            sign_effect = False
        signs.append(1 if d > 0 else (-1 if d < 0 else 0))
if len(set(signs)) != 1:
    sign_effect = False

out = {
    'protocol': {
        'P_WINDOWS': P_WINDOWS, 'X_RATIOS': X_RATIOS, 'KINDS': KINDS,
        'Q_rule': 'nearest q>=7 coprime to 30 to sqrt(2X/30), ties smaller',
        'Ngeom': 'plain nonzero h support interval length, reused across channels',
        'FIT_WINDOWS': FIT_WINDOWS, 'BOOTSTRAP_REPS': BOOTSTRAP_REPS, 'SEED': SEED,
        'strong_decay_rule': 'both ratios: means(400)>means(800)>means(1600), slope<=-0.25, bootstrap p95<0',
        'sign_effect_rule': 'inverse-squarefree same sign and abs diff>=0.01 for P=400,800,1600 at both ratios',
    },
    'summaries': summaries, 'slopes': slopes,
    'strong_finite_decay_pattern': strong_decay,
    'sign_specific_effect': sign_effect,
    'max_sat_full': max(r['sat_full'] for r in rows),
    'row_count': len(rows),
}

with open('bridge_exp04b_results.json', 'w') as f:
    json.dump(out, f, indent=2)
with open('bridge_exp04b_summary.csv', 'w', newline='') as f:
    w = csv.DictWriter(f, fieldnames=list(summaries[0].keys()))
    w.writeheader(); w.writerows(summaries)

with open(__file__, 'rb') as f:
    script_hash = hashlib.sha256(f.read()).hexdigest()
with open('bridge_exp04b_results.json', 'rb') as f:
    json_hash = hashlib.sha256(f.read()).hexdigest()

print(json.dumps({
    'row_count': len(rows),
    'max_sat_full': out['max_sat_full'],
    'strong_finite_decay_pattern': strong_decay,
    'sign_specific_effect': sign_effect,
    'slopes': slopes,
    'script_sha256': script_hash,
    'json_sha256': json_hash,
}, indent=2))
