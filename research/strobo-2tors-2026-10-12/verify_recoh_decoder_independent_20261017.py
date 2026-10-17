"""Independent finite check of the mathematical E/sigma decoder, not production code."""
from collections import Counter
from itertools import combinations, product
import json


def add(x, y, moduli):
    return tuple((a + b) % q for a, b, q in zip(x, y, moduli))


def sub(x, y, moduli):
    return tuple((a - b) % q for a, b, q in zip(x, y, moduli))


def square(support, moduli):
    return Counter(add(x, y, moduli) for x in support for y in support)


def primary_part(q, p):
    result = 1
    while q % p == 0:
        result *= p
        q //= p
    return result


def bank(moduli):
    binary = [(i, 2, primary_part(q, 2)) for i, q in enumerate(moduli) if q % 2 == 0]
    ternary = [(i, 3, primary_part(q, 3)) for i, q in enumerate(moduli) if q % 3 == 0]
    return binary, ternary if binary else []


def coefficient(support, character):
    coordinate, prime, order = character
    stride = order // prime
    result = Counter()
    for x in support:
        exponent = x[coordinate] % order
        if exponent < (prime - 1) * stride:
            result[exponent] += 1
        else:
            remainder = exponent - (prime - 1) * stride
            for j in range(prime - 1):
                result[remainder + j * stride] -= 1
    return tuple(sorted((e, c) for e, c in result.items() if c))


def negate(value):
    return tuple((e, -c) for e, c in value)


def half(target, moduli):
    out = []
    for t, q in zip(target, moduli):
        if q % 2:
            out.append((t + (t % 2) * q) // 2)
        elif t % 2:
            return None
        else:
            out.append(t // 2)
    return tuple(out)


def reconstruct(moduli, observation, measurements):
    binary, ternary = bank(moduli)
    found = []
    checked = 0
    for edges in combinations(sorted(observation), 3):
        checked += 1
        total = add(add(edges[0], edges[1], moduli), edges[2], moduli)
        sigma = half(total, moduli)
        if sigma is None:
            continue
        base = tuple(sorted(sub(sigma, e, moduli) for e in edges))
        assert len(set(base)) == 3
        assert add(add(base[0], base[1], moduli), base[2], moduli) == sigma
        intrinsic_square = Counter({e: 2 for e in edges})
        intrinsic_square.update(sub(total, add(e, e, moduli), moduli) for e in edges)
        assert intrinsic_square == square(base, moduli)
        if intrinsic_square != observation:
            continue
        if any(coefficient(base, chi) != measurements[len(binary) + j] for j, chi in enumerate(ternary)):
            continue
        translation = [0] * len(moduli)
        for j, chi in enumerate(binary):
            value = coefficient(base, chi)
            assert value, "A binary-primary triple coefficient vanished"
            if measurements[j] == value:
                continue
            if measurements[j] == negate(value):
                translation[chi[0]] = moduli[chi[0]] // 2
            else:
                break
        else:
            support = tuple(sorted(add(x, translation, moduli) for x in base))
            assert square(support, moduli) == observation
            assert tuple(coefficient(support, chi) for chi in binary + ternary) == measurements
            found.append(support)
    assert checked <= 20
    assert len(found) == len(set(found)), "Duplicate E/sigma encodings"
    return found, checked


def main():
    groups = [
        (1,), (2,), (3,), (4,), (5,), (6,), (8,), (9,), (12,),
        (2, 2), (2, 4), (2, 6), (3, 3), (4, 4), (2, 2, 2),
        (2, 2, 3), (2, 9), (3, 6), (2, 3, 3), (2, 2, 2, 2),
        (4, 6), (2, 2, 2, 3), (1, 6), (2, 2, 2, 2, 2),
    ]
    results = []
    for moduli in groups:
        elements = tuple(product(*(range(q) for q in moduli)))
        binary, ternary = bank(moduli)
        total = 0
        max_edges = 0
        for support in combinations(elements, 3):
            observation = square(support, moduli)
            assert sum(observation.values()) == 9
            assert max(observation.values()) <= 3
            assert 3 <= len(observation) <= 6
            measured = tuple(coefficient(support, chi) for chi in binary + ternary)
            found, checked = reconstruct(moduli, observation, measured)
            assert found == [support], (moduli, support, found)
            total += 1
            max_edges = max(max_edges, checked)
        results.append({"moduli": moduli, "order": len(elements), "triples": total,
                        "bank_size": len(binary) + len(ternary), "max_edge_sets": max_edges})
    report = {"status": "PASS", "presentations": len(groups),
              "triples": sum(r["triples"] for r in results), "results": results,
              "scope": "Independent exact exhaustive finite validation; no Lean certificate of executable code."}
    print(json.dumps(report, indent=2))


if __name__ == "__main__":
    main()
