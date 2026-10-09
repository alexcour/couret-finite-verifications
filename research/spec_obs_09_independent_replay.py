#!/usr/bin/env python3
"""Independent implementation for SPEC-OBS-09 on D9 only.

A fresh code path using 18-bit adjacency rows and permutation orbits of
12-bit induced adjacency masks. Needs Python 3 and NetworkX for the VF2
cross-check only. Independent-set certificates require only the stdlib.
This is not an archival copy of the earlier independent audit program.
"""
import argparse
import json
from collections import Counter, defaultdict
from itertools import combinations, permutations

N = 18
ARCS4 = tuple((a, b) for a in range(4) for b in range(4) if a != b)
ARC_INDEX4 = {edge: i for i, edge in enumerate(ARCS4)}
QUADS = tuple(combinations(range(N), 4))


def mul(i, j):
    a, b = i % 9, i // 9
    c, d = j % 9, j // 9
    return ((a + c) if b == 0 else (a - c)) % 9 + 9 * (b ^ d)


def spans_group(support):
    reachable = {0}
    pending = [0]
    for x in pending:
        for g in support:
            y = mul(x, g)
            if y not in reachable:
                reachable.add(y)
                pending.append(y)
    return len(reachable) == N


def row_bitsets(support):
    return tuple(sum(1 << mul(x, s) for s in support) for x in range(N))


def masks_to_orbits():
    perms = tuple(permutations(range(4)))
    rename = [tuple(ARC_INDEX4[(p[i], p[j])] for i, j in ARCS4) for p in perms]
    result = [0] * (1 << 12)
    for mask in range(1 << 12):
        orbit = []
        bits = [i for i in range(12) if mask & (1 << i)]
        for mapping in rename:
            orbit.append(sum(1 << mapping[i] for i in bits))
        result[mask] = min(orbit)
    assert all(result[result[mask]] == result[mask] for mask in range(1 << 12))
    return tuple(result)


def motif_histogram(rows, canonical):
    frequencies = Counter()
    for vertices in QUADS:
        mask = 0
        for bit, (a, b) in enumerate(ARCS4):
            if (rows[vertices[a]] >> vertices[b]) & 1:
                mask |= 1 << bit
        frequencies[canonical[mask]] += 1
    assert sum(frequencies.values()) == 3060
    return tuple(sorted(frequencies.items()))


def independent_count(rows, size, include_sets=False):
    total = 0
    examples = []
    # Independent means no arrow in EITHER direction.
    neighbors = tuple(rows[x] | sum((1 << y) for y in range(N) if (rows[y] >> x) & 1) for x in range(N))
    for subset in combinations(range(N), size):
        subset_mask = sum(1 << i for i in subset)
        if all((neighbors[x] & subset_mask) == 0 for x in subset):
            total += 1
            if include_sets:
                examples.append(list(subset))
    return (total, examples) if include_sets else total


def to_graph(rows):
    import networkx as nx
    g = nx.DiGraph()
    g.add_nodes_from(range(N))
    for i, adj in enumerate(rows):
        g.add_edges_from((i, j) for j in range(N) if adj & (1 << j))
    return g


def main():
    canonical = masks_to_orbits()
    # Algebraic and adversarial checks independently recomputed here.
    assert all(mul(mul(x, y), z) == mul(x, mul(y, z))
               for x in range(N) for y in range(N) for z in range(N))
    check_rows = row_bitsets((1, 9, 12))
    relabel = tuple((5 * v + 3) % N for v in range(N))
    renamed = [0] * N
    for x in range(N):
        for y in range(N):
            if check_rows[x] & (1 << y):
                renamed[relabel[x]] |= 1 << relabel[y]
    assert motif_histogram(check_rows, canonical) == motif_histogram(tuple(renamed), canonical)
    changed = list(check_rows)
    changed[0] ^= (1 << 1)
    assert motif_histogram(check_rows, canonical) != motif_histogram(tuple(changed), canonical)
    buckets = defaultdict(list)
    for triples in combinations(range(1, N), 3):
        if spans_group(triples):
            rows = row_bitsets(triples)
            assert all(row.bit_count() == 3 and not (row & (1 << v)) for v, row in enumerate(rows))
            buckets[motif_histogram(rows, canonical)].append((triples, rows))

    assert len(QUADS) == 3060
    assert sum(len(items) for items in buckets.values()) == 594
    assert len(buckets) == 10

    import networkx as nx
    class_sizes = []
    ambiguous_fibers = []
    comparisons = 0
    for key in sorted(buckets):
        representatives = []
        for triple, rows in buckets[key]:
            digraph = to_graph(rows)
            for group in representatives:
                comparisons += 1
                if nx.is_isomorphic(digraph, group['graph']):
                    group['count'] += 1
                    break
            else:
                representatives.append({'triple': list(triple), 'graph': digraph, 'count': 1})
        class_sizes += [group['count'] for group in representatives]
        if len(representatives) > 1:
            ambiguous_fibers.append({'fiber_size': len(buckets[key]),
                                     'class_sizes': [part['count'] for part in representatives],
                                     'representatives': [part['triple'] for part in representatives]})

    witness_specs = [((1, 9, 12), (1, 9, 13), [5, 6]),
                     ((1, 8, 9), (9, 10, 11), [5, 6, 7, 8, 9])]
    witnesses = []
    for s, t, sizes in witness_specs:
        a, b = row_bitsets(s), row_bitsets(t)
        same = motif_histogram(a, canonical) == motif_histogram(b, canonical)
        assert same
        counts = {str(k): [independent_count(a, k), independent_count(b, k)] for k in sizes}
        w = {'S': list(s), 'T': list(t), 'same_four_motifs': same,
             'independent_counts': counts, 'different_counts': any(v[0] != v[1] for v in counts.values())}
        if 9 in sizes:
            count, examples = independent_count(b, 9, True)
            assert count == counts['9'][1]
            w['independent_nines_T'] = examples
        assert w['different_counts']
        witnesses.append(w)

    out = {'experiment': 'SPEC-OBS-09', 'implementation': 'fresh-bitset-2026-10-09',
           'scope': 'D9 ONLY', 'candidate_supports': 680,
           'connected_supports': sum(len(v) for v in buckets.values()),
           'motifs_per_graph': len(QUADS), 'four_motif_classes': len(buckets),
           'isomorphism_classes': len(class_sizes), 'vf2_comparisons': comparisons,
           'class_sizes_sorted': sorted(class_sizes),
           'ambiguous_fibers': sorted(ambiguous_fibers, key=lambda f: f['fiber_size']),
           'witnesses': witnesses,
           'untested': ['D10', 'D11', 'D12', 'S4'],
           'scientific_scope': 'motif-4 insufficiency only, NOT a cospectral pair',
           'adversarial_checks': ['associativity_5832', 'canonicalization_4096', 'relabel_invariant', 'one_arc_changed_detected'],
           'novelty': 'NOT AUDITED'}
    assert len(class_sizes) == 12 and comparisons == 663
    assert sorted(class_sizes) == [27] * 2 + [54] * 10
    assert sorted((f['fiber_size'], sorted(f['class_sizes'])) for f in ambiguous_fibers) == [(54, [27, 27]), (108, [54, 54])]
    assert witnesses[0]['independent_counts'] == {'5': [342, 360], '6': [87, 129]}
    assert witnesses[1]['independent_counts'] == {'5': [810, 810], '6': [438, 438], '7': [126, 126], '8': [18, 18], '9': [0, 2]}
    assert witnesses[1]['independent_nines_T'] == [list(range(9)), list(range(9, 18))]
    print(json.dumps(out, indent=2, ensure_ascii=False))
    return out


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--json-out', default='')
    args = parser.parse_args()
    result = main()
    if args.json_out:
        with open(args.json_out, 'w', encoding='utf-8') as f:
            json.dump(result, f, indent=2, ensure_ascii=False)
            f.write('\n')
