#!/usr/bin/env python3
"""Exact, standalone n=24 directed/undirected Cayley cospectrality certificate.

Source status: finite exhaustive check and elementary trace/graph invariant argument.
Only Python standard library. No originality or external-audit claim.
Run: python3 verify_cayley_n24.py > CAYLEY_N24_RESULTS.json
"""
import json
from collections import Counter
from itertools import combinations

N = 24
S = (1, 5, 17)
T = (1, 9, 21)


def normalize(values):
    return tuple(sorted(x % N for x in values))


def shift(support, delta):
    return normalize(x + delta for x in support)


def multiply(support, unit):
    return normalize(x * unit for x in support)


def undirected_generators(support):
    return normalize(set(support) | {(-x) % N for x in support})


def convolution(support1, support2):
    counts = Counter((x+y) % N for x in support1 for y in support2)
    return tuple(counts[i] for i in range(N))


def autocorrelation(support):
    counts = Counter((x-y) % N for x in support for y in support)
    return tuple(counts[i] for i in range(N))


def positive_coefficients(vec):
    return {str(i): v for i, v in enumerate(vec) if v}


def neighbor_sets(generators):
    return [{(x+g) % N for g in generators} for x in range(N)]


def common_neighbor_histogram(generators):
    neigh = neighbor_sets(generators)
    hist = Counter()
    max_size = 0
    witnesses = []
    for triple in combinations(range(N), 3):
        common = set.intersection(*(neigh[i] for i in triple))
        size = len(common)
        hist[size] += 1
        if size > max_size:
            max_size = size
            witnesses = [(triple, common)]
        elif size == max_size:
            witnesses.append((triple, common))
    assert sum(hist.values()) == 2024
    return {str(k): hist[k] for k in sorted(hist)}, max_size, witnesses


def anchored_even_check(generators):
    """For a triple with a common neighbor, parity forces all three vertices
    to have the same parity; translating a vertex to 0 reduces to 55 pairs.
    """
    neigh = neighbor_sets(generators)
    vertices = range(2, N, 2)
    hist = Counter(len(neigh[0] & neigh[a] & neigh[b])
                   for a,b in combinations(vertices,2))
    assert sum(hist.values()) == 55
    return {str(k): hist[k] for k in sorted(hist)}


def adjacency_matrix(generators):
    """Explicit 24x24 0/1 adjacency matrix, independent of convolution."""
    return [[int((j-i) % N in generators) for j in range(N)] for i in range(N)]


def square_matrix(A):
    return [[sum(A[i][k]*A[k][j] for k in range(N))
             for j in range(N)] for i in range(N)]


def characteristic_coefficients(generators):
    """Exact Newton identities applied to p_k=tr(A^k): each trace equals
    N times the number of length-k cyclic walks with increment sum 0.
    Return c_0..c_N for det(lambda*I-A).
    """
    vec = [0] * N
    vec[0] = 1
    traces = [0]
    for k in range(1, N+1):
        new = [0] * N
        for i, mult in enumerate(vec):
            if mult:
                for delta in generators:
                    new[(i+delta)%N] += mult
        vec = new
        traces.append(N * vec[0])
    c = [1]
    for k in range(1, N+1):
        num = sum(c[k-j] * traces[j] for j in range(1,k+1))
        assert num % k == 0, (k,num)
        c.append(-num // k)
    return c, traces


def polynomial_terms(coeffs):
    return {str(N-i): coef for i,coef in enumerate(coeffs) if coef}


def verify():
    assert normalize(S) == S and normalize(T) == T
    assert normalize(2-x for x in S) == T
    assert all(x%2==1 for x in S+T)
    assert not(set(S)&{(-x)%N for x in S})
    assert not(set(T)&{(-x)%N for x in T})

    square_s = convolution(S,S)
    square_t = convolution(T,T)
    assert square_s == square_t
    assert positive_coefficients(square_s) == {'2':1,'6':2,'10':2,'18':2,'22':2}
    corr_s = autocorrelation(S)
    corr_t = autocorrelation(T)
    assert corr_s == corr_t

    us, ut = undirected_generators(S), undirected_generators(T)
    assert us == (1,5,7,17,19,23)
    assert ut == (1,3,9,15,21,23)
    assert convolution(us,us) == convolution(ut,ut)
    assert square_matrix(adjacency_matrix(S)) == square_matrix(adjacency_matrix(T))
    assert square_matrix(adjacency_matrix(us)) == square_matrix(adjacency_matrix(ut))

    # Mönius, thesis Example 3.1.20: these undirected connection sets
    # become the published example after the group automorphism x -> 11x.
    monius_s = (5,7,11,13,17,19)
    monius_t = (3,9,11,13,15,21)
    assert multiply(us,11) == monius_s
    assert multiply(ut,11) == monius_t

    hs, ms, witnesses_s = common_neighbor_histogram(us)
    ht, mt, witnesses_t = common_neighbor_histogram(ut)
    assert hs == {'0':1712,'1':144,'2':168}
    assert ht == {'0':1640,'1':336,'2':24,'4':24}
    assert ms == 2 and mt == 4
    assert len(witnesses_t) == 24
    anchored_s, anchored_t = anchored_even_check(us),anchored_even_check(ut)
    assert not any(int(k)>2 for k in anchored_s)
    assert anchored_t.get('4') == 3
    w_left=(0,6,12,18)
    w_right=(3,9,15,21)
    nt=neighbor_sets(ut)
    assert all(y in nt[x] for x in w_left for y in w_right)
    assert set.intersection(*(nt[x] for x in w_left)) == set(w_right)
    assert sum(1 for a,b,c in combinations(range(N),3)
               if len(nt[a]&nt[b]&nt[c])==4) == 24

    # Exactly two isomorphism classes for the four supports in the
    # previously enumerated convolution-square fiber.
    s2 = shift(S,12)
    t2 = shift(T,12)
    assert multiply(S,13) == s2
    assert multiply(T,13) == t2
    assert {S,T,s2,t2} == {(1,5,17),(1,9,21),(5,13,17),(9,13,21)}
    for q in [s2,t2]:
        assert convolution(q,q)==square_s

    # This calculation is independent of the parity+equal-square proof:
    # exact characteristic polynomials by trace/Newton arithmetic.
    c_s, tr_s = characteristic_coefficients(S)
    c_t, tr_t = characteristic_coefficients(T)
    c_us, tr_us = characteristic_coefficients(us)
    c_ut, tr_ut = characteristic_coefficients(ut)
    assert c_s == c_t and c_us == c_ut
    assert tr_s == tr_t and tr_us == tr_ut
    assert all(tr_s[k] == 0 and tr_us[k] == 0 for k in range(1,N+1,2))
    assert polynomial_terms(c_s) == {
        '24':1,'20':-72,'16':-648,'12':-6560,'8':-72,'4':-648,'0':-6561
    }
    return {
        'date':'2026-10-13',
        'status':'EXACT_FINITE_CHECK_INTERNAL_NOT_EXTERNALLY_AUDITED',
        'n':N,
        'support_s': list(S),
        'support_t': list(T),
        'symmetric_reflection_t':'2-S (mod 24)',
        'convolution_square_equal':True,
        'convolution_square_nonzero':positive_coefficients(square_s),
        'autocorrelation_equal':True,
        'underlying_s_generators': list(us),
        'underlying_t_generators': list(ut),
        'underlying_adjacency_squares_equal':True,
        'independent_24x24_matrix_squares_checked':True,
        'monius_example_3_1_20_multiplier':11,
        'monius_support_s':list(monius_s),
        'monius_support_t':list(monius_t),
        'underlying_common_neighbors_three_vertex_histogram': {'S':hs,'T':ht},
        'anchored_even_pair_histogram':{'S':anchored_s,'T':anchored_t},
        'max_three_vertex_common_neighbors':{'S':ms,'T':mt},
        'underlying_t_K4_4_vertices': {'left':list(w_left),'right':list(w_right)},
        'underlying_s_K3_3_free':True,
        'supports_two_isomorphism_classes': {
            'class_S':[list(S),list(s2)],
            'class_T':[list(T),list(t2)],
            'unit_isomorphism_multiplier':13,
            'cross_class_nonisomorphism_witness':'K3,3-free versus containing K4,4 in undirected skeleton'
        },
        'directed_charpoly_sparse':polynomial_terms(c_s),
        'undirected_charpoly_sparse':polynomial_terms(c_us),
        'directed_and_undirected_cospectral_by_exact_polynomials':True,
        'triple_count':2024,
        'test_status':'PASS',
        'scope_limit':'Single n=24 fiber only, no originality claim or external review.'
    }


if __name__ == '__main__':
    print(json.dumps(verify(),indent=2,sort_keys=True,ensure_ascii=False))
