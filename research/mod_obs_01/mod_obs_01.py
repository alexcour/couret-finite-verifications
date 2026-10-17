#!/usr/bin/env python3
"""MOD-OBS-01: finite exact fiber audit and decision complexities. Stdlib only."""
import argparse
import collections
import functools
import hashlib
import itertools
import json
import math
import pathlib
from typing import Tuple


def convolution_ordered(S, n):
    counts = [0] * n
    for a in S:
        for b in S:
            counts[(a + b) % n] += 1
    return tuple(counts)


def convolution_unordered(S, n):
    counts = [0] * n
    for a in S:
        counts[(2 * a) % n] += 1
    for a, b in itertools.combinations(S, 2):
        counts[(a + b) % n] += 2
    return tuple(counts)


def fibers(n, allow_zero=False):
    src = range(n) if allow_zero else range(1, n)
    classes = collections.defaultdict(list)
    for support in itertools.combinations(src, 3):
        key = convolution_ordered(support, n)
        assert convolution_unordered(support, n) == key, (n, support)
        classes[key].append(support)
    return list(classes.values())


def decision_depth(fiber, n, target=None, return_tree=False):
    """Minimax depth of adaptive exact membership queries. target=None -> full reconstruction."""
    length = len(fiber)
    Q = [int(target(support)) for support in fiber] if target else None
    probe_masks = []
    for x in range(1, n):
        yesmask = sum((1 << i) for i, S in enumerate(fiber) if x in S)
        if yesmask not in (0, (1 << length) - 1):
            probe_masks.append((x, yesmask))
    FULL = (1 << length) - 1
    @functools.lru_cache(None)
    def rec(M):
        if M.bit_count() == 1:
            return (0, None)
        if Q is not None:
            values = {Q[i] for i in range(length) if (M >> i) & 1}
            if len(values) == 1:
                return (0, None)
        possible = []
        for x, qmask in probe_masks:
            yes = M & qmask
            no = M & ~qmask
            if yes and no:
                possible.append((1 + max(rec(yes)[0], rec(no)[0]), x))
        if not possible:
            return (math.inf, None)
        return min(possible)
    depth, x = rec(FULL)
    return (depth, x) if return_tree else depth


def trace3(S, n):
    return n * sum(1 for a in S for b in S for c in S if (a + b + c) % n == 0)


def properties(n):
    h = n // 2
    d = {
        "contains_1": lambda S: 1 in S,
        "connected": lambda S: math.gcd(n, *S) == 1,
        "closed_walk_length_3": lambda S: trace3(S, n) != 0,
        "symmetric": lambda S: all(((-x) % n) in S for x in S),
        "majority_lower_half": lambda S: sum(1 for x in S if x < h) >= 2,
    }
    if n % 2 == 0:
        d["contains_halfturn"] = lambda S: h in S
    return d


def analytic_formula(n):
    if n % 2:
        return {1: math.comb(n-1, 3)}
    if n % 6 == 0:
        return {
            1: math.comb(n - 2, 2) - 2,
            2: math.comb(n - 2, 3) // 2 - n + 7,
            4: n // 2 - 3,
        }
    return {1: math.comb(n - 2, 2), 2: math.comb(n - 2, 3) // 2}


def fixed_suite_minimum(n, F, allowed_probes):
    # Each pair S,T with same observation must be separated by at least one query.
    pairs = [(S, T) for fiber in F for S, T in itertools.combinations(fiber, 2)]
    covered = [0] * len(allowed_probes)
    for k, q in enumerate(allowed_probes):
        covered[k] = sum((1 << i) for i, (S, T) in enumerate(pairs) if (q in S) != (q in T))
    full = (1 << len(pairs)) - 1
    # Recursive subset enumeration using bitsets. For n=18, 2^17 masks.
    best = (len(allowed_probes) + 1, None)
    nsub = 1 << len(allowed_probes)
    cumulative = [0] * nsub
    for mask in range(1, nsub):
        bit = mask & (-mask)
        idx = bit.bit_length() - 1
        cumulative[mask] = cumulative[mask ^ bit] | covered[idx]
        c = mask.bit_count()
        if c < best[0] and cumulative[mask] == full:
            best = (c, mask)
    assert best[1] is not None
    sample = [allowed_probes[i] for i in range(len(allowed_probes)) if best[1] & (1 << i)]
    return {"minimum":best[0], "witness":sample, "pairs":len(pairs), "searched_subsets":nsub-1,
            "full_coverage_sha256": hashlib.sha256(str(full).encode()).hexdigest()}


def run(n, allow_zero=False, do_fixed=False):
    F = fibers(n, allow_zero)
    hist = collections.Counter(map(len, F))
    n_s = sum(len(x) for x in F)
    n_pairs = sum(k * (k - 1) // 2 * v for k, v in hist.items())
    result = {"n":n,"zero_allowed":allow_zero,"supports":n_s,"fibers":len(F),
              "fiber_counts":{str(k):hist[k] for k in sorted(hist)},"collision_pairs":n_pairs}
    if not allow_zero:
        f = analytic_formula(n)
        result["predicted_fiber_counts"] = {str(k):v for k, v in f.items() if v}
        result["formula_agrees"] = {str(k):v for k,v in f.items() if v} == {str(k):hist[k] for k in sorted(hist)}
        assert result["formula_agrees"], (n,result)
    d_recon = collections.Counter(decision_depth(fib,n) for fib in F)
    result["reconstruction_depth_histogram"] = {str(k):d_recon[k] for k in sorted(d_recon)}
    if not allow_zero:
        pr = {}
        for name, f in properties(n).items():
            depths = collections.Counter(decision_depth(fib,n,f) for fib in F)
            pr[name] = {"depth_histogram":{str(k):depths[k] for k in sorted(depths)}, "worst":max(depths)}
        result["properties"] = pr
        if n%2==0:
            assert all((convolution_ordered(S,n)[0]%2 == (n//2 in S)) for fib in F for S in fib)
    if do_fixed:
        result["global_fixed_membership_suite"] = fixed_suite_minimum(n,F,list(range(n) if allow_zero else range(1,n)))
    return result


def main():
    parser=argparse.ArgumentParser()
    parser.add_argument('--output',default=None)
    a=parser.parse_args()
    tests=[6,7,8,9,12,18,24,30,36]
    allres = [run(n, False, n==18) for n in tests]
    allres.append(run(18,True,True))
    out={"protocol":"MOD-OBS-01 v1, 2026-10-11","scope":"Finite exact exhaustive, no novelty audit",
         "experiments":allres}
    dest=pathlib.Path(a.output) if a.output else pathlib.Path(__file__).with_name('results.json')
    dest.write_text(json.dumps(out,ensure_ascii=False,indent=2),encoding='utf-8')
    for r in allres:
        print(f"n={r['n']:2} zero={r['zero_allowed']} N={r['supports']:5} fibers={r['fibers']:5} hist={r['fiber_counts']} pairs={r['collision_pairs']} reconstruction={r['reconstruction_depth_histogram']}")
        if 'global_fixed_membership_suite' in r:
            print('  fixed:',r['global_fixed_membership_suite'])
        if r['n']==18 and not r['zero_allowed']:
            for name, q in r['properties'].items():print('  ',name,q)
    print('Output:',dest)

if __name__=='__main__':main()