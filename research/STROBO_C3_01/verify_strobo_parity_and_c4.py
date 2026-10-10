#!/usr/bin/env python3
"""STROBO-C3: independent finite parity/fibre checks and bounded |S|=4 stress test.

Integer-only, Python standard library. Does not import historic STROBO code,
nauty, labelg, pynauty, NetworkX or data from the earlier audit. No novelty
or external-validation claim. Companion to a written proof, not a proof by scan.

Run: python verify_strobo_parity_and_c4.py --max-triple 60 --max-four 30 \
     --output AUDIT_PARITY_AND_C4_RESULTS.json
"""
import argparse
import json
from collections import Counter, defaultdict
from itertools import combinations
from pathlib import Path


def squared_signature(support, n):
    coefficients = [0] * n
    for i, x in enumerate(support):
        coefficients[(2 * x) % n] += 1
        for y in support[i + 1:]:
            coefficients[(x + y) % n] += 2
    return tuple(coefficients)


def cyclic_walks(support, n, exponent):
    dist = [0] * n
    dist[0] = 1
    for _ in range(exponent):
        new = [0] * n
        for x, count in enumerate(dist):
            if count:
                for jump in support:
                    new[(x + jump) % n] += count
        dist = new
    return dist


def trace(support, n, exponent):
    return n * cyclic_walks(support, n, exponent)[0]


def arc_signature(support, n, length):
    count = cyclic_walks(support, n, length - 1)
    return tuple(sorted(count[(-step) % n] for step in support))


def characteristic_coefficients(support, n):
    """Newton identities; coefficients ordered from z^n down to constant."""
    c = [1]
    for k in range(1, n + 1):
        accum = sum(c[k-j] * trace(support, n, j) for j in range(1,k+1))
        assert accum % k == 0
        c.append(-accum // k)
    return c


def poly_product_ascending(p, q):
    product = [0] * (len(p)+len(q)-1)
    for i, a in enumerate(p):
        for j, b in enumerate(q):
            product[i+j] += a*b
    return product


def expected_degree16_poly():
    # z*(z-4)*(z^2+4)^2*(z^8+16)*(z^2+4z+8)
    factors = [[0,1],[-4,1],[4,0,1],[4,0,1],[16]+[0]*7+[1],[8,4,1]]
    p = [1]
    for factor in factors:
        p = poly_product_ascending(p, factor)
    return list(reversed(p))


def pair(s, t):
    return tuple(sorted((tuple(s), tuple(t))))


def predicted_partners_of_triple(s, n):
    s = tuple(s)
    if n % 2:
        return {s}
    m = n // 2
    classes = defaultdict(list)
    for step in s:
        classes[step % m].append(step)
    if len(classes) == 3:
        return {s, tuple(sorted((x + m) % n for x in s))}
    assert sorted(map(len, classes.values())) == [1, 2]
    a = next(r for r in classes if len(classes[r]) == 2)
    b = next(r for r in classes if len(classes[r]) == 1)
    cchoices = {a}
    if (3 * (a - b)) % m == 0:
        cchoices.add((2 * a - b) % m)
    return {tuple(sorted((c, c + m, b + t * m)))
            for c in cchoices for t in (0, 1)}


def family_exceptional_pairs(n, allow_zero):
    if n % 6:
        return set()
    m = n // 2
    d = n // 6
    result = set()
    for b in range(m):
        a = (b + d) % m
        c = (b + 2 * d) % m
        for sigma in (0, 1):
            for tau in (0, 1):
                s = tuple(sorted((a, a + m, b + sigma * m)))
                t = tuple(sorted((c, c + m, b + tau * m)))
                if allow_zero or (0 not in s and 0 not in t):
                    result.add(pair(s, t))
    return result


def scan_triples(n, allow_zero):
    support_start = 0 if allow_zero else 1
    groups = defaultdict(list)
    for s in combinations(range(support_start, n), 3):
        groups[squared_signature(s, n)].append(s)
    exceptions = family_exceptional_pairs(n, allow_zero)
    collisions = set()
    all_supports = 0
    for group in groups.values():
        all_supports += len(group)
        group_set = set(group)
        for s in group:
            partners = predicted_partners_of_triple(s, n)
            if not allow_zero:
                partners = {v for v in partners if 0 not in v}
            if partners != group_set:
                raise AssertionError(('unexpected square-root class', n, allow_zero, s,
                                      sorted(partners), sorted(group_set)))
        for s, t in combinations(group, 2):
            collisions.add(pair(s, t))
    halves = set()
    if n % 2 == 0:
        m = n // 2
        for group in groups.values():
            group_set = set(group)
            for s in group:
                t = tuple(sorted((x + m) % n for x in s))
                if s != t and t in group_set:
                    halves.add(pair(s, t))
    if collisions != halves | exceptions:
        raise AssertionError(('unexpected collision pair', n, allow_zero,
                              sorted(collisions - (halves | exceptions))[:3],
                              sorted((halves | exceptions) - collisions)[:3]))
    for s, t in exceptions:
        target = set(t)
        if any({(x + shift) % n for x in s} == target
               for shift in range(n)):
            raise AssertionError(('exceptional pair is a translate', n, allow_zero, s, t))
    if halves & exceptions:
        raise AssertionError(('half-turn conflated with exception', n, allow_zero))
    expected = ((2 * n) if allow_zero else (2 * n - 11)) if n % 6 == 0 else 0
    if len(exceptions) != expected:
        raise AssertionError(('exception count mismatch', n, allow_zero,
                              len(exceptions), expected))
    return {'n': n, 'zero_allowed': allow_zero, 'supports': all_supports,
            'square_equal_unordered_pairs': len(collisions),
            'half_turn_pairs': len(halves),
            'exceptional_non_half_turn_pairs': len(exceptions),
            'partner_sets_match': True}


def scan_four(n):
    groups = defaultdict(list)
    for support in combinations(range(1, n), 4):
        groups[squared_signature(support, n)].append(support)
    half = other = 0
    example = None
    for group in groups.values():
        for s, t in combinations(group, 2):
            if n % 2 == 0 and set((x + n // 2) % n for x in s) == set(t):
                half += 1
            else:
                other += 1
                if example is None:
                    example = {'S': list(s), 'T': list(t)}
    return {'n': n, 'square_equal_pairs': half + other,
            'half_turn_pairs': half, 'not_half_turn_pairs': other,
            'first_non_half_turn': example}


def exact_witnesses():
    examples = [
      ('triple_12_cospectral_nonisomorphic', 12, (1,3,9), (1,5,11), 4),
      ('triple_18_odd_trace', 18, (1,4,13), (1,7,16), 3),
      ('four_8_not_half_turn', 8, (1,2,4,6), (1,3,4,7), 3),
      ('four_16_cospectral_nonisomorphic', 16, (1,2,5,10), (1,5,6,14), 3),
    ]
    result = {}
    for name, n, S, T, length in examples:
        sqs, sqt = squared_signature(S,n), squared_signature(T,n)
        assert sqs == sqt
        tr = {str(k): [trace(S,n,k),trace(T,n,k)]
              for k in (1,3,5)}
        result[name]={'n':n,'S':list(S),'T':list(T),
                      'ordered_square_coefficients':list(sqs),
                      'trace1_3_5':tr,
                      'arc_length':length,
                      'arc_signature_S':list(arc_signature(S,n,length)),
                      'arc_signature_T':list(arc_signature(T,n,length)),
                      'half_turn':(n%2==0 and set((x+n//2)%n for x in S)==set(T))}
    assert result['triple_12_cospectral_nonisomorphic']['arc_signature_S'] == [3,4,5]
    assert result['triple_12_cospectral_nonisomorphic']['arc_signature_T'] == [3,3,6]
    assert result['triple_18_odd_trace']['trace1_3_5']['3'] == [108,54]
    assert result['four_8_not_half_turn']['trace1_3_5']['3'] == [72,48]
    assert result['four_16_cospectral_nonisomorphic']['arc_signature_S'] == [0,2,2,2]
    assert result['four_16_cospectral_nonisomorphic']['arc_signature_T'] == [1,1,2,2]
    for key in ('triple_12_cospectral_nonisomorphic', 'four_16_cospectral_nonisomorphic'):
        x=result[key]
        assert all(trace(x['S'],x['n'],k)==trace(x['T'],x['n'],k)
                   for k in range(1,x['n']+1))
        x['same_traces_through_degree_n']=True
        charS = characteristic_coefficients(x['S'], x['n'])
        charT = characteristic_coefficients(x['T'], x['n'])
        assert charS == charT
        x['characteristic_coefficients_high_to_low'] = charS
    assert result['four_16_cospectral_nonisomorphic']['characteristic_coefficients_high_to_low'] == expected_degree16_poly()
    return result


def run(max_triple=60, max_four=30):
    rows3=[scan_triples(n,z) for n in range(3,max_triple+1)
           for z in (False,True)]
    rows4=[scan_four(n) for n in range(5,max_four+1)]
    assert all(x['not_half_turn_pairs']==0 for x in rows4 if x['n'] % 4)
    witnesses=exact_witnesses()
    return {'status':'INTERNAL_INTEGER_ONLY_BOUNDED_CHECK',
            'triple_bound':max_triple,'four_bound':max_four,
            'triple_total_supports':sum(x['supports'] for x in rows3),
            'triple_total_scans':len(rows3),
            'triple_rows':rows3,
            'four_rows':rows4,
            'witnesses':witnesses,
            'caveats':['The general proof is in a separate human-readable note.',
                       'Four-support observations do not prove a general classification.',
                       'No third-party proof review or novelty audit.']}

if __name__ == '__main__':
    ap=argparse.ArgumentParser()
    ap.add_argument('--max-triple',type=int,default=60)
    ap.add_argument('--max-four',type=int,default=30)
    ap.add_argument('--output',type=Path,default=Path('AUDIT_PARITY_AND_C4_RESULTS.json'))
    x=ap.parse_args()
    obj=run(x.max_triple,x.max_four)
    x.output.parent.mkdir(parents=True,exist_ok=True)
    x.output.write_text(json.dumps(obj,indent=2,ensure_ascii=False)+'\n')
    print('PASS triple scans:',obj['triple_total_scans'],
          'supports:',obj['triple_total_supports'],
          'up to n=',x.max_triple)
    print('PASS quadruple scans: 5..',x.max_four)
    print('non-half-turn quadruple cases:',
          {q['n']:q['not_half_turn_pairs'] for q in obj['four_rows'] if q['not_half_turn_pairs']})
    print('PASS four exact witnesses')