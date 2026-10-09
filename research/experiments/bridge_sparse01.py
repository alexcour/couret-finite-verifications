#!/usr/bin/env python3
"""SPARSE-01: exact integer-weight verification of sparse prime-center energy transfer.

This is a finite test of an elementary Cauchy/occupancy bound, NOT a proof of
MÃ¶bius cancellation, a novel theorem, or an independent confirmation of DIAG-02.
"""
import csv
import hashlib
import json
import math
from pathlib import Path

OUT = Path(__file__).resolve().parent
PS = (150, 300, 600)
RATIOS = (24, 48)


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
            if i * p > n or p > lp[i]:
                break
            lp[i * p] = p
            mu[i * p] = 0 if p == lp[i] else -mu[i]
    return mu, primes


def w(n, X):
    if n <= X or n >= 2 * X:
        return 0
    return 2 * min(n - X, 2 * X - n)  # exact X * W(n/X)


def floor_frac_power_two_thirds(X):
    # floor(X^(2/3)/4) without floating-point rounding
    z = X * X
    lo, hi = 0, X
    while lo + 1 < hi:
        mid = (lo + hi) // 2
        if 64 * mid ** 3 <= z:
            lo = mid
        else:
            hi = mid
    return max(1, lo)


def widths(X):
    narrow = max(1, math.isqrt(X) // 3)
    broad = floor_frac_power_two_thirds(X)
    return narrow, broad


def compute(P, ratio, H, mu, primes):
    X = P * ratio
    pp = [p for p in primes if P < p <= 2 * P and math.gcd(p, 30) == 1]
    assert 2 * X < P * P, (P, ratio)
    upper = 2 * X + 30 * H
    v = [0] * (upper + 1)
    for n in range(X + 1, 2 * X):
        if math.gcd(n, 30) == 1:
            v[n] = mu[n] * w(n, X)
    pref = [0] * (upper + 1)
    for n in range(upper + 1):
        pref[n] = v[n] + (pref[n - 30] if n >= 30 else 0)

    def g(x):
        right = x + 30 * H
        left = x - 30 * (H + 1)
        return pref[right] - (pref[left] if left >= 0 else 0) - v[x]

    E = sum(g(x) ** 2 for x in range(X, 2 * X + 1))
    A, K, exact_geo, Sabs, Ssigned, Vtotal, centers_sqs = (0,) * 7
    group_rows = []
    x_seen = set()
    for p in pp:
        Sp = 0
        Vp = 0
        mcount = 0
        for m in range(max(1, X // p), 2 * X // p + 2):
            x = p * m
            if not (X <= x <= 2 * X) or math.gcd(m, 30) != 1:
                continue
            if x in x_seen:
                raise AssertionError(('duplicate center', x, P, ratio))
            x_seen.add(x)
            u = mu[m] * w(x, X)
            mcount += 1
            K += 1
            A += u * u
            gx = g(x)
            centers_sqs += gx * gx
            Sp += u * gx
            for h in range(-H, H + 1):
                if h == 0:
                    continue
                n = x + 30 * h
                if 0 < n < 2 * X and math.gcd(n, 30) == 1:
                    Vp += abs(u) * abs(mu[n]) * w(n, X)
                    exact_geo += int(bool(w(x, X) and w(n, X)))
        Sabs += abs(Sp)
        Ssigned += Sp
        Vtotal += Vp
        group_rows.append({'p': p, 'S_scaled': Sp, 'V_scaled': Vp,
                           'Z': (Sp/Vp if Vp else None), 'm_count': mcount})
    L = math.floor(math.log(2 * X) / math.log(P))
    assert L == 1 and centers_sqs <= L * E
    assert Sabs ** 2 <= A * L * E
    assert Ssigned ** 2 <= A * L * E

    # Selected direct pair check avoids silently validating convolution by itself.
    for entry in group_rows[:2] + group_rows[-2:]:
        p = entry['p']
        brute = 0
        for m in range(1, 2 * X // p + 2):
            x = p * m
            if math.gcd(m, 30) != 1:
                continue
            wm = w(x, X)
            if wm == 0:
                continue
            for h in range(-H, H + 1):
                if h == 0:
                    continue
                n = x + 30*h
                if 0 < n < 2 * X:
                    brute += mu[m] * mu[n] * wm * w(n, X)
        assert brute == entry['S_scaled'], (P, ratio, H, p, brute, entry['S_scaled'])

    b = math.sqrt(A * L * E)
    row = {'P':P,'ratio':ratio,'X':X,'H':H,'nprimes':len(pp),
           'K_centers':K,'distinct_centers':len(x_seen),
           'occupancy_L':L,'A_weighted':A,'E_short':E,
           'sum_abs_S':Sabs,'sum_S':Ssigned,'sum_V':Vtotal,
           'nontrivial_bound_ratio':b/Vtotal if Vtotal else None,
           'observed_ratio':Sabs/Vtotal if Vtotal else None,
           'E_normalized':E / ((X+1)*(2*H)**2*X*X),
           'geometric_weighted_pairs':exact_geo,
           'Cauchy_valid':True, 'independent_direct_checks':min(4,len(pp))}
    return row, group_rows


def main():
    mu, primes = mobius_sieve(2*max(PS)*max(RATIOS)+1)
    rows=[]
    prime_rows=[]
    for P in PS:
        for ratio in RATIOS:
            X=P*ratio
            nar,broad=widths(X)
            assert 1 <= nar < broad < X//30, (P,ratio,nar,broad)
            for tag,H in (('narrow',nar),('broad',broad)):
                row, detail = compute(P,ratio,H,mu,primes)
                row['width']=tag
                rows.append(row)
                for d in detail:
                    prime_rows.append({'P':P,'ratio':ratio,'width':tag,'H':H,**d})
                print(f"PASS P={P}, ratio={ratio}, H={H}, primes={row['nprimes']}, "
                      f"bound/V={row['nontrivial_bound_ratio']:.3f}, "
                      f"observed/V={row['observed_ratio']:.3f}, "
                      f"E={row['E_normalized']:.5f}")
    with (OUT/'bridge_sparse01_cells.csv').open('w',newline='') as f:
        writer=csv.DictWriter(f,fieldnames=list(rows[0])); writer.writeheader();writer.writerows(rows)
    with (OUT/'bridge_sparse01_primes.csv').open('w',newline='') as f:
        writer=csv.DictWriter(f,fieldnames=list(prime_rows[0]));writer.writeheader();writer.writerows(prime_rows)
    with (OUT/'bridge_sparse01_results.json').open('w') as f:
        json.dump({'status':'finite exact checks only','rows':rows,
            'headline':{'total_cells':len(rows),'total_prime_rows':len(prime_rows),
                        'all_occupancy_one':all(x['occupancy_L']==1 for x in rows),
                        'nontrivial_cells':sum(x['nontrivial_bound_ratio']<1 for x in rows),
                        'max_ratio':max(x['nontrivial_bound_ratio'] for x in rows)}},f,indent=2)
    paths=['bridge_sparse01.py','bridge_sparse01_cells.csv','bridge_sparse01_primes.csv','bridge_sparse01_results.json']
    with (OUT/'SHA256SUMS.txt').open('w') as f:
        for p in paths:
            f.write(hashlib.sha256((OUT/p).read_bytes()).hexdigest()+'  '+p+'\n')
    print('TOTAL',len(rows),'cells',len(prime_rows),'prime rows; nontrivial bound cells',
          sum(x['nontrivial_bound_ratio']<1 for x in rows))

if __name__=='__main__':
    main()
