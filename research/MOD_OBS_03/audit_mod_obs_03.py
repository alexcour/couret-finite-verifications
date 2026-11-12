#!/usr/bin/env python3
"""MOD-OBS-03: exact finite audit of observation costs for cyclic triples.

No dependency beyond Python standard library. No import from previous STROBO
or OBS-SEQ checkers. This is an INTERNAL second implementation, not external
human validation. No numerical prime calculations.
"""
from __future__ import annotations
import argparse
from collections import Counter, defaultdict
from itertools import combinations
import json
import math
from pathlib import Path


def exact_square(s: tuple[int, ...], n: int) -> tuple[int, ...]:
    """Combinatorial diagonal terms (1) and unordered offdiagonal terms (2)."""
    ans = [0] * n
    for x in s:
        ans[(2*x) % n] += 1
    for i, j in combinations(s, 2):
        ans[(i+j) % n] += 2
    return tuple(ans)


def exact_cube(s: tuple[int, ...], n: int) -> tuple[int, ...]:
    """Integer ordered 3-step displacement counts, independently of squares."""
    ans = [0] * n
    for x in s:
        for y in s:
            for z in s:
                ans[(x+y+z) % n] += 1
    return tuple(ans)


def convolution(x: tuple[int, ...], s: tuple[int, ...]) -> tuple[int, ...]:
    ans=[0]*len(x)
    for i,v in enumerate(x):
        if v:
            for y in s:
                ans[(i+y)%len(x)] += v
    return tuple(ans)


def bank22(s: tuple[int, ...], n: int) -> tuple[int, ...]:
    a2=exact_square(s,n)
    a3=convolution(a2,s)
    a4=convolution(a3,s)
    a5=convolution(a4,s)
    a6=convolution(a5,s)
    assert a3==exact_cube(s,n)
    return (n*a3[0],n*a4[0],n*a5[0],n*a6[0])+a3


def groups(n: int, zero_allowed: bool):
    low=0 if zero_allowed else 1
    f=defaultdict(list)
    for s in combinations(range(low,n),3):
        f[exact_square(s,n)].append(s)
    return f


def predicted_fibres(n: int, zero_allowed: bool):
    if n%2: return {1:math.comb(n if zero_allowed else n-1,3)}
    if zero_allowed:
        if n%6: return {2:math.comb(n,3)//2}
        return {2:math.comb(n,3)//2-n,4:n//2}
    if n%6:return {1:math.comb(n-2,2),2:math.comb(n-2,3)//2}
    return {1:math.comb(n-2,2)-2,2:math.comb(n-2,3)//2-n+7,4:n//2-3}


def finite_sweep(max_n: int):
    summary=[]
    for n in range(5,max_n+1):
        for allow_zero in (False,True):
            f=groups(n,allow_zero)
            shape=dict(sorted(Counter(map(len,f.values())).items()))
            expectation={k:v for k,v in predicted_fibres(n,allow_zero).items() if v}
            assert shape==expectation,(n,allow_zero,shape,expectation)
            total=sum(v*size for size,v in shape.items())
            collisions=sum(v*size*(size-1)//2 for size,v in shape.items())
            assert total==math.comb(n if allow_zero else n-1,3)
            if not allow_zero:
                predicted=(math.comb(n-2,3)//2 if n%2==0 else 0) + (2*n-11 if n%6==0 else 0)
                assert collisions==predicted,(n,collisions,predicted)
            summary.append({"n":n,"zero_allowed":allow_zero,"fibres_by_size":{str(k):v for k,v in shape.items()},"supports":total,"equal_square_pairs":collisions})
    return summary


def exceptional_family(b: int,d: int) -> list[tuple[int,...]]:
    h=3*d
    a=(b+d)%h;c=(b+2*d)%h
    return [tuple(sorted((a,a+h,b))),tuple(sorted((a,a+h,b+h))),
            tuple(sorted((c,c+h,b))),tuple(sorted((c,c+h,b+h)))]


def test_explicit_cubic_queries(max_d: int):
    families=0
    for d in range(1,max_d+1):
        n=6*d
        for b in range(3*d):
            fam=exceptional_family(b,d)
            assert len(set(fam))==4
            assert len({exact_square(s,n) for s in fam})==1
            q0=(3*b)%n
            q1=(3*b+d)%n
            observed=[(exact_cube(s,n)[q0],exact_cube(s,n)[q1]) for s in fam]
            assert observed==[(5,3),(4,3),(5,6),(4,6)],(d,b,observed)
            # No coordinate among the n scalar cubic coefficients separates all 4.
            cubes=[exact_cube(s,n) for s in fam]
            assert max(len({vec[r] for vec in cubes}) for r in range(n))<=2
            families+=1
    return families


def n18_diagnostics():
    n=18
    f=groups(n,True)
    assert len(f)==399
    assert Counter(map(len,f.values()))==Counter({2:390,4:9})
    signatures={s:bank22(s,n) for grp in f.values() for s in grp}
    collision_pairs=[p for grp in f.values() for p in combinations(grp,2)]
    assert len(collision_pairs)==444
    coverage=[]
    for q in range(22):
        mask=0
        for i,(s,t) in enumerate(collision_pairs):
            if signatures[s][q]!=signatures[t][q]: mask |= 1<<i
        coverage.append(mask)
    target=(1<<len(collision_pairs))-1
    best1=min((len(collision_pairs)-(v.bit_count()),i) for i,v in enumerate(coverage))
    best2=min((len(collision_pairs)-(coverage[i]|coverage[j]).bit_count(),i,j) for i,j in combinations(range(22),2))
    best3=min((len(collision_pairs)-(coverage[i]|coverage[j]|coverage[k]).bit_count(),i,j,k) for i,j,k in combinations(range(22),3))
    assert best1[0]==90 and best2[0]==24 and best3[0]==0,(best1,best2,best3)
    assert (coverage[4]|coverage[7]|coverage[10])==target
    outcome=Counter()
    names={1:"one",2:"two",4:"four"}
    examples={}
    for key,grp in f.items():
        probes_needed =0 if len(grp)==1 else 3
        if len(grp)>1:
            if any(len({signatures[s][q] for s in grp})==len(grp) for q in range(22)):
                probes_needed=1
            elif any(len({(signatures[s][i],signatures[s][j]) for s in grp})==len(grp) for i,j in combinations(range(22),2)):
                probes_needed=2
        assert probes_needed==(2 if len(grp)==4 else 1)
        outcome[f"{names[len(grp)]}_member_{probes_needed}_probes"]+=1
        if len(grp)==4:examples.setdefault("four_member",grp)
    assert outcome==Counter({"two_member_1_probes":390,"four_member_2_probes":9})
    # Now a PROPERTY, not full identification: strong connectivity iff gcd=1.
    stable, undecided, trace_distinguishes=0,0,0
    uncertain_example=None
    for grp in f.values():
        g={s:(math.gcd(n,*s)==1) for s in grp}
        if len(set(g.values()))==1:
            stable+=1
        else:
            undecided+=1
            if all(signatures[s][0]!=signatures[t][0] for s,t in combinations(grp,2) if g[s]!=g[t]):
                trace_distinguishes+=1
            else:
                raise AssertionError('trace A^3 insufficient for strong connectivity within a fibre')
            if uncertain_example is None:
                uncertain_example=[{"support":list(s),"connected":g[s],"trace_cube":signatures[s][0]} for s in grp]
    assert (stable,undecided,trace_distinguishes)==(316,83,83)
    # Restricted universe from STROBO, independently grouped.
    f0=groups(n,False)
    assert Counter(map(len,f0.values()))==Counter({1:118,2:269,4:6})
    return {
        "n":18,"zero_allowed":True,"supports":816,"square_fibres":399,
        "fibre_size_distribution":{"2":390,"4":9},"square_equal_support_pairs":444,
        "fixed_bank":{"description":"4 traces tr(A^k), k=3..6; 18 cubic coefficients (A^3)_{0,r}, r=0..17","num_probes":22,
          "best_one_remaining_pairs":best1[0],"best_two_remaining_pairs":best2[0],"best_three_remaining_pairs":best3[0],
          "fixed_triplet_cubic_displacements":[0,3,6]},
        "conditioned_on_observed_full_square":{"double_fibres_with_one_scalar_probe":390,
          "quadruple_fibres_with_two_scalar_probes":9,"worst_case":2,
          "explanation":"Choose the scalar cubic coordinates per known square fibre, without inspecting their answer first."},
        "connectivity_property":{"known_without_new_probes_fibres":stable,
          "uncertain_after_square_fibres":undecided,
          "all_uncertain_fibres_resolved_by_trace_cube":trace_distinguishes,
          "example_fibre":uncertain_example,
          "status":"exact FINITE n=18, post-hoc descriptive property; not a general theorem"},
        "zero_forbidden_distribution":{"1":118,"2":269,"4":6},
        "four_fibre_example":[list(s) for s in exceptional_family(1,3)],
        "four_fibre_explicit_probes":{"singleton_residue_b":1,"d":3,"cubic_displacements":[3,6],"responses":[[5,3],[4,3],[5,6],[4,6]]}
    }


def run(max_n:int=60,max_d:int=130):
    scans=finite_sweep(max_n)
    n18=n18_diagnostics()
    cubes=test_explicit_cubic_queries(max_d)
    return {"id":"MOD-OBS-03","date":"2026-10-11","status":"INTERNAL_EXACT_FINITE_AND_ALGEBRAIC_PROPOSAL; NO_EXTERNAL_REVIEW; NOVELTY_NOT_AUDITED",
        "universe":"3-element supports on Z/nZ, with or without the zero generator, same-label A_S^2 equality",
        "finite_sweep":{"max_n":max_n,"scans":len(scans),"support_instances":sum(row['supports'] for row in scans),
          "all_predictions_match":True,"by_order":scans},
        "n18":n18,
        "explicit_cubic_fibre_lemma":{"max_d":max_d,"complete_four_fibres_checked":cubes,
          "target_response_vectors":[[5,3],[4,3],[5,6],[4,6]],
          "no_single_scalar_cubic_coefficient_injective":True,
          "analytical_proof_required":True},
        "boundaries":{"initial_square_observation_free_in_cost_model":True,
           "per_fibre_pair_chosen_using_square_before_any_extra_answer":True,
           "external_human_reviewer":False,"priority_or_novelty":False}}


def main():
    a=argparse.ArgumentParser()
    a.add_argument('--max-n',type=int,default=60)
    a.add_argument('--max-d',type=int,default=130)
    a.add_argument('--out',default='results.json')
    ns=a.parse_args()
    if ns.max_n<18 or ns.max_d<3:raise ValueError('minimum supported horizon: n>=18, d>=3')
    r=run(ns.max_n,ns.max_d)
    Path(ns.out).write_text(json.dumps(r,sort_keys=True,indent=2,ensure_ascii=False)+'\n',encoding='utf-8')
    print('PASS:',r['finite_sweep']['scans'],'order/convention scans,',r['finite_sweep']['support_instances'],'supports; 4-fibres:',r['explicit_cubic_fibre_lemma']['complete_four_fibres_checked'])
    print('n18:',r['n18']['fixed_bank'],'conditioned:',r['n18']['conditioned_on_observed_full_square'])

if __name__=='__main__':main()