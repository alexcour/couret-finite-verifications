#!/usr/bin/env python3
"""Exact finite regression for STROBO exceptional fibres and Fourier banks.

Uses only integer group arithmetic and formal cyclotomic coefficient tuples.
No floating point, no external datasets, no analytic or originality claims.
"""
from collections import Counter, defaultdict
from itertools import combinations, product
from hashlib import sha256
from pathlib import Path
import json

CASES = {
    'C3xC3': (3, 3), 'C2xC3': (2, 3),
    'C2xC3xC3': (2, 3, 3), 'C2xC2xC3': (2, 2, 3),
    'C2xC2xC3xC3': (2, 2, 3, 3),
    'C2xC2xC2xC3': (2, 2, 2, 3),
    'C2xC2xC2xC3xC3': (2, 2, 2, 3, 3),
    'C4xC3': (4, 3), 'C4xC3xC3': (4, 3, 3),
    'C8xC3': (8, 3), 'C2xC2xC2': (2, 2, 2),
    'C2xC5': (2, 5),
}
OM = ((1, 0), (0, 1), (-1, -1))


def add(a, b, mods):
    return tuple((x+y) % m for x, y, m in zip(a, b, mods))


def neg(a, mods):
    return tuple((-x) % m for x, m in zip(a, mods))


def charsum(T, c, mods):
    """Pair-of-basis-vectors in Z[zeta_2^k] tensor Z[omega_3]."""
    L = max((m for m in mods if m in (2, 4, 8)), default=1)
    half = max(1, L // 2)
    vec = [0] * (2 * half)
    for x in T:
        exp2, exp3 = 0, 0
        for a, b, m in zip(c, x, mods):
            if m in (2, 4, 8):
                exp2 += (L // m) * a * b
            elif m == 3:
                exp3 += a * b
            else:
                assert m == 5 and a == 0
        exp2 %= L
        j = exp2 % half
        sg = 1 if exp2 < half else -1
        vec[2*j] += sg * OM[exp3 % 3][0]
        vec[2*j+1] += sg * OM[exp3 % 3][1]
    return tuple(vec)


def params(T, mods, H, V):
    zero = (0,) * len(mods)
    found = []
    for a in T:
        b, c = tuple(y for y in T if y != a)
        d = add(c, neg(b, mods), mods)
        if d == zero or d not in H:
            continue
        for u in (b, c):
            v = add(u, neg(a, mods), mods)
            if v == zero or v not in V:
                continue
            av = add(a, v, mods)
            if tuple(sorted((a, av, add(av, d, mods)))) != T:
                continue
            av_inv = add(a, neg(v, mods), mods)
            refl = tuple(sorted((a, av_inv, add(av_inv, d, mods))))
            found.append((a, d, v, refl))
    assert len(found) == 1, (T, found)
    return found[0]


def check(name, mods):
    G = tuple(product(*(range(m) for m in mods)))
    N = len(G)
    H = tuple(x for x in G if all(2*a % m == 0 for a, m in zip(x, mods)))
    V = tuple(x for x in G if all(3*a % m == 0 for a, m in zip(x, mods)))
    r = sum(m in (2, 4, 8) for m in mods)
    s = sum(m == 3 for m in mods)
    h, v3 = len(H), len(V)
    assert h == 2**r and v3 == 3**s
    chars = tuple(tuple(int(i == j) for i in range(len(mods))) for j in range(len(mods)))
    primary2 = tuple(chars[i] for i, m in enumerate(mods) if m in (2, 4, 8))
    primary3 = tuple(chars[i] for i, m in enumerate(mods) if m == 3)
    bank = primary2 + primary3 if r else ()
    fibres = defaultdict(list)
    for T in combinations(G, 3):
        square = Counter(add(a, b, mods) for a in T for b in T)
        fibres[tuple(sorted(square.items()))].append(T)
    exc = [f for f in fibres.values() if len(f) == 2*h]
    ord_f = [f for f in fibres.values() if len(f) == h]
    predicted = (N // h) * (h-1) * ((v3-1) // 2)
    assert len(exc) == predicted
    assert len(exc) + len(ord_f) == len(fibres)
    triples = sum(map(len, fibres.values()))
    assert triples == N*(N-1)*(N-2)//6
    for f in fibres.values():
        assert len({tuple(charsum(T,c,mods) for c in bank) for T in f}) == len(f)
        T = f[0]
        orbit = {tuple(sorted(add(x, d, mods) for x in T)) for d in H}
        assert len(orbit) == h and orbit.issubset(set(f))
        if len(f) == 2*h:
            a,d,v,refl = params(T,mods,H,V)
            assert refl in f and refl not in orbit
            other = {tuple(sorted(add(x,z,mods) for x in refl)) for z in H}
            assert len(other) == h and not (other & orbit) and other | orbit == set(f)
            assert {tuple(charsum(x,c,mods) for c in primary2) for x in orbit} == {
                tuple(charsum(x,c,mods) for c in primary2) for x in other}
            assert any(len({tuple(charsum(x,c,mods) for c in primary2+(z,))
                            for x in f}) == len(f) for z in primary3)
        else:
            assert orbit == set(f)
    optimum = None
    if N <= 36 and all(m in (2, 3, 4, 8) for m in mods) and r:
        probes = G[1:]
        conflicts = [(T,U) for f in fibres.values() for T,U in combinations(f,2)]
        freq = {T: tuple(charsum(T,c,mods) for c in probes)
                for f in fibres.values() for T in f}
        masks = [sum(1 << i for i,(T,U) in enumerate(conflicts)
                     if freq[T][j] != freq[U][j]) for j in range(len(probes))]
        full = (1 << len(conflicts))-1
        k = r+s-1
        assert not any(all_mask == full for all_mask in
                       (sum_masks(masks, subset) for subset in combinations(range(len(probes)), k)))
        optimum = r+s
    return {
        'group':name, 'order':N, 'r':r, 's':s, 'triplets':triples,
        'ordinary_fibres':len(ord_f), 'exceptional_fibres':len(exc),
        'formula_exceptional':predicted,
        'constructive_universal_bank':len(bank),
        'exact_minimum_all_character_banks_checked':optimum,
    }


def sum_masks(masks, indices):
    value = 0
    for i in indices:
        value |= masks[i]
    return value


def main():
    res=[check(k,v) for k,v in CASES.items()]
    assert sum(x['triplets'] for x in res) == 79504
    assert next(x for x in res if x['group']=='C2xC2xC3xC3')['exact_minimum_all_character_banks_checked']==4
    cert = {'protocol':'RECOH-STROBO-PROBE-20261014',
            'scope':'labelled ordered square of all 3-subsets of abelian product groups',
            'status':'finite exact checks, no Lean or independent mathematical review',
            'groups':res, 'triplets_tested':sum(x['triplets'] for x in res),
            'theorem_candidate':'B(G)=0 if G[2] trivial, else rank_2 G[2]+rank_3 G[3]',
            'reused':'STROBO-2TORS PR25 h/2h fibre and exceptional normal form',
            'publication':'draft only, no merge or stable release'}
    p=Path(__file__).with_name('recoh_strobo_probe_20261014.json')
    p.write_text(json.dumps(cert,sort_keys=True,indent=2)+'\n',encoding='utf8')
    print('RECOH/STROBO EXACT PASS',len(res),'groups',cert['triplets_tested'],'triplets')
    for a in res:
        print(a['group'],a['ordinary_fibres'],a['exceptional_fibres'],
              a['constructive_universal_bank'],a['exact_minimum_all_character_banks_checked'])
    print('SHA256',sha256(p.read_bytes()).hexdigest())


if __name__=='__main__':main()
