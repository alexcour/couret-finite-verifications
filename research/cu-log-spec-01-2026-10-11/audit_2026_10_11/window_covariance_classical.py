#!/usr/bin/env python3
"""Classical conditional covariance for fixed-ratio prime-count windows.

Here alpha=1/3, characters of U(210)=U(105), conductors f|105.
Under GRH the variance of a primitive Dirichlet character is the sum over
zeros gamma of [4/3 - (2/sqrt(3))*cos(gamma*log 3)]/(1/4+gamma^2).
The Guinand-Weil explicit formula gives the finite expression below.
No new primes and no numerical L-zeros are used. These are trace ratios,
NOT expected energy ratios, confidence intervals or p-values.
"""
import itertools
import json
import math
from collections import defaultdict

EULER_GAMMA = 0.577215664901532860606512090082402431
PRIMES = (3, 5, 7)
ORDERS = (2, 4, 6)

def modes():
    """Real Fourier modes, including both members of complex character pairs."""
    result = []
    for k3, k5, k7 in itertools.product(range(2), range(4), range(6)):
        if (k3, k5, k7) == (0, 0, 0):
            continue
        k = (k3, k5, k7)
        f = math.prod(p for p, exponent in zip(PRIMES, k) if exponent)
        odd = (sum(k) % 2) == 1
        real_chi2 = math.cos(2*math.pi*(k3/2 + k5/4 + k7/3))
        v = (2/3)*(math.log(f/math.pi)-EULER_GAMMA)
        v += odd*(math.log(2)/3 + math.log(9/8))
        v -= math.log(2)/3*real_chi2
        quadratic = all(a in (0, b//2) for a, b in zip(k, ORDERS))
        result.append((k, f, odd, real_chi2, v, quadratic))
    assert len(result) == 47 and all(row[4] > 0 for row in result)
    return result

def result():
    rows = modes()
    by_conductor = defaultdict(list)
    for row in rows:
        by_conductor[row[1]].append(row)
    total = sum(row[4] for row in rows)
    grouped = {}
    for f, subset in sorted(by_conductor.items()):
        omega = sum(f % p == 0 for p in PRIMES)
        n = math.prod(p-2 for p in PRIMES if f % p == 0)
        odd_count = (n-(-1)**omega)//2
        assert len(subset) == n
        assert sum(row[2] for row in subset) == odd_count
        assert abs(sum(row[3] for row in subset)-(-1)**omega) < 1e-12
        direct = sum(row[4] for row in subset)
        alternative = n*(2/3)*(math.log(f/math.pi)-EULER_GAMMA)
        alternative += odd_count*(math.log(2)/3+math.log(9/8))
        alternative -= math.log(2)/3 *(-1)**omega
        assert abs(direct - alternative) < 1e-11
        grouped[str(f)] = {'dimension': n, 'odd_characters':odd_count,
                           'trace_variance':direct}
    fractions = {str(q):sum(row[4] for row in rows if q % row[1] == 0)/total
                 for q in (15,21,35)}
    chi5 = next(row[4] for row in rows if row[0] == (0,2,0))
    return {'alpha':1/3,'prime_counts_computed':False,
            'condition':'GRH, classical Guinand-Weil formula, normalized prime-race logarithmic covariance',
            'conductors':grouped,'total_trace':total,
            'trace_fractions':fractions,'chi5_unit_fraction_of_trace':chi5/total,
            'interpretation':'Trace fractions are not expectations of ratios or finite-window probabilities.'}

if __name__ == '__main__':
    print(json.dumps(result(),indent=2))
