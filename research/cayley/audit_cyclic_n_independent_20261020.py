#!/usr/bin/env python3
"""Finite adversarial audit of the C_n draft. Python >=3.10, stdlib only.

Independent of the earlier SymPy character-spectrum implementation:
cospectrality is decided by integer closed-walk counts through |H|*n.
Newton identities then determine the characteristic polynomial, including
algebraic multiplicities. No random seed, floating point, or external imports.
This program is finite evidence, not the proof of the universal statement.
"""
import argparse
from collections import Counter, defaultdict
from functools import lru_cache
from hashlib import sha256
from itertools import permutations, product
import json
from math import comb, gcd
from pathlib import Path
import platform


def require(condition, detail):
    if not condition:
        raise RuntimeError(detail)


@lru_cache(None)
def phi(n):
    """Ascending coefficients, from X^n-1 = product_{d|n} Phi_d."""
    value = [-1] + [0] * (n - 1) + [1]
    for d in range(1, n):
        if n % d == 0:
            divisor = phi(d)
            quotient = [0] * (len(value) - len(divisor) + 1)
            while len(value) >= len(divisor):
                shift, coefficient = len(value) - len(divisor), value[-1]
                quotient[shift] = coefficient
                for j, c in enumerate(divisor):
                    value[shift+j] -= coefficient*c
                while value and value[-1] == 0:
                    value.pop()
            require(not value, ('nonexact_cyclotomic_division', n, d))
            value = quotient
    return tuple(value)


def roots(n):
    polynomial = phi(n)
    degree = len(polynomial) - 1
    vector = (1,) + (0,) * (degree-1)
    result = []
    for _ in range(n):
        result.append(vector)
        leading = vector[-1]
        shifted = (0,) + vector[:-1]
        vector = tuple(shifted[j]-leading*polynomial[j] for j in range(degree))
    require(vector == result[0], ('root_period', n))
    require(len(set(result)) == n, ('roots_not_distinct', n))
    return result


def vadd(a, b):
    return tuple(x+y for x, y in zip(a, b))


def root_audit():
    orders = list(range(1, 61)) + [64, 72, 90, 96, 120, 180, 210]
    counts, boundaries = Counter(), []
    for n in orders:
        r = roots(n)
        pairs = defaultdict(list)
        for b in range(n):
            for c in range(b, n):
                pairs[vadd(r[b], r[c])].append((b, c))
        for z in range(n):
            if n//gcd(n, z) <= 3:
                continue
            counts['targets'] += 1
            for multiplicity in (1, 2):
                target = vadd(r[0], vadd(r[0], r[z])) if multiplicity == 1 else vadd(r[0], vadd(r[z], r[z]))
                solutions = set()
                for a in range(n):
                    remainder = tuple(x-y for x, y in zip(target, r[a]))
                    for b, c in pairs.get(remainder, ()):
                        solutions.add(tuple(sorted((a,b,c))))
                prescribed = tuple(sorted((0,0,z) if multiplicity == 1 else (0,z,z)))
                require(solutions == {prescribed}, ('root_counterexample', n,z,multiplicity,sorted(solutions)))
                counts['identities_checked'] += 1
    # Negative controls: exceptions must actually be detected outside ord(z)>3.
    for n, z, triple in ((12,6,(0,1,7)), (6,2,(5,1,1))):
        r = roots(n)
        value = vadd(r[triple[0]], vadd(r[triple[1]],r[triple[2]]))
        require(value == vadd(r[0],vadd(r[0],r[z])), ('bad_boundary',n))
        require(tuple(sorted(triple)) != tuple(sorted((0,0,z))), 'canonical_boundary')
        boundaries.append({'ambient_order':n,'z_exponent':z,'noncanonical_triple':list(triple)})
    return {'ambient_orders':orders, **counts,
            'unordered_ambient_triples':sum(comb(n+2,3) for n in orders),
            'counterexamples_in_scope':0,'out_of_scope_root_controls':boundaries}


def table_audit():
    for n in range(4,257):
        for multiset, expected in (
            ((0,0,1), {(1,-1,-1),(-1,2,1),(0,0,1)}),
            ((0,1,1), {(0,1,0),(-1,2,2),(1,-1,0)})):
            actual = set()
            for A,B,C in set(permutations(multiset)):
                q = (B-A)%n
                actual.add((q,(A-q)%n,(C-q)%n))
            require(actual == {tuple(t%n for t in row) for row in expected}, ('table',n,multiset))
        require(((2-0)%n,(2-1)%n)==(2,1),('middle_branch',n))
        require(((-2*(-1))%n,1)==(2,1),('third_branch',n))
    return {'orders':list(range(4,257)), 'tables':506,'placements':1518,'disagreements':0}


def closure(elements, add, identity, generators):
    seen, queue = {identity}, [identity]
    while queue:
        point = queue.pop()
        for g in generators:
            q = add(point,g)
            if q not in seen:
                seen.add(q)
                queue.append(q)
    return len(seen) == len(elements)


def walk_compare(elements, add, identity, k, kp, n):
    """Return exact equality or the first differing return-count witness."""
    vertices = [(x,y) for x in elements for y in range(n)]
    index = {v:j for j,v in enumerate(vertices)}
    zero = index[(identity,0)]
    matrices = []
    for translated in (0,1):
        support = ((k,translated),(k,1+translated),(kp,translated))
        neighbors = [tuple(index[(add(x,g),(y+t)%n)] for g,t in support) for x,y in vertices]
        matrices.append(neighbors)
    a, b = [0]*len(vertices), [0]*len(vertices)
    a[zero] = b[zero] = 1
    for length in range(1,len(vertices)+1):
        new = []
        for previous, neighbors in zip((a,b),matrices):
            current = [0]*len(vertices)
            for source, count in enumerate(previous):
                if count:
                    for destination in neighbors[source]:
                        current[destination] += count
            new.append(current)
        a,b = new
        if a[zero] != b[zero]:
            return False, length, a[zero]-b[zero]
    return True, len(vertices), None


def check_automorphism(elements, add, identity, k, kp, n, h, s):
    vertices = [(x,y) for x in elements for y in range(n)]
    sign = 1 if s == 1 else -1
    f = lambda x,y: (x,(sign*y+h(x))%n)
    require(len({f(x,y) for x,y in vertices}) == len(vertices), ('nonbijective',n,s))
    source = ((k,0),(k,1),(kp,0))
    target = {(k,1),(k,2%n),(kp,1)}
    require({f(x,y) for x,y in source} == target, ('support_map',n,s))
    for x,y in vertices:
        lhs = {f(add(x,g),(y+t)%n) for g,t in source}
        fx,fy = f(x,y)
        rhs = {(add(fx,g),(fy+t)%n) for g,t in target}
        require(lhs == rhs, ('edge_map',n,s,x,y))


def legacy_walk_audit():
    groups = [(m,1) for m in range(2,11)] + [(a,b) for a in range(2,6) for b in range(a,6) if a*b<=10]
    orders = (4,5,6,7,8,9,10,11,12,14,15)
    rows, by_n = [], Counter()
    for a,b in groups:
        elements = list(product(range(a),range(b)))
        add = lambda x,y: ((x[0]+y[0])%a,(x[1]+y[1])%b)
        pairs = [(k,kp) for k in elements for kp in elements if k!=kp and closure(elements,add,(0,0),(k,kp))]
        for n in orders:
            homs = [(alpha,beta) for alpha in range(n) for beta in range(n) if a*alpha%n==b*beta%n==0]
            for k,kp in pairs:
                witnesses = [(alpha,beta) for alpha,beta in homs
                             if (alpha*kp[0]+beta*kp[1])%n==1
                             and (alpha*k[0]+beta*k[1])%n in (1,2)]
                actual, length, delta = walk_compare(elements,add,(0,0),k,kp,n)
                require(actual == bool(witnesses), ('legacy_counterexample',a,b,n,k,kp,length,delta))
                by_n[n] += actual
                rows.append([a,b,n,list(k),list(kp),actual,length,delta])
    require(len(rows)==4928 and sum(by_n.values())==102,('legacy_counts',len(rows),dict(by_n)))
    return {'method':'integer adjacency closed walks and Newton identities',
            'presentations':len(rows),'cospectral':sum(by_n.values()),
            'cospectral_by_n':dict(sorted(by_n.items())),'disagreements':0,'rows':rows}


def hnf_audit(bound):
    orders = list(range(4,25)) + [25,27,28,30,32,36]
    rows, by_n, maps = [], Counter(), Counter()
    for m in range(2,bound+1):
        for a in range(1,m+1):
            if m%a:
                continue
            c = m//a
            for b in range(a):
                def norm(x,y):
                    q,r = divmod(y,c)
                    return ((x-b*q)%a,r)
                elements = list(product(range(a),range(c)))
                add = lambda x,y: norm(x[0]+y[0],x[1]+y[1])
                k,kp = norm(1,0),norm(0,1)
                if k==kp:
                    continue
                for n in orders:
                    ss = [s for s in (1,2) if a*s%n==0 and (b*s+c)%n==0]
                    actual,length,delta = walk_compare(elements,add,(0,0),k,kp,n)
                    require(actual==bool(ss),('hnf_counterexample',a,b,c,n,length,delta))
                    for s in ss:
                        h = lambda p:(s*p[0]+p[1])%n
                        check_automorphism(elements,add,(0,0),k,kp,n,h,s)
                        maps[s] += 1
                    by_n[n] += actual
                    rows.append([a,b,c,n,ss,actual,length,delta])
    return {'index_bound':bound,'n':orders,'presentations':len(rows),
            'cospectral':sum(by_n.values()),'cospectral_by_n':dict(sorted(by_n.items())),
            'automorphisms_checked_by_s':dict(sorted(maps.items())),
            'disagreements':0,'rows':rows}


def boundary_audit():
    # Missing generation: H=C8, K=<4,2>=2*C8. h on K does not extend to H.
    elements = list(range(8))
    add = lambda x,y:(x+y)%8
    actual,length,delta = walk_compare(elements,add,0,4,2,4)
    require(actual,'missing_generation_spectrum')
    homs = [alpha for alpha in range(4) if 8*alpha%4==0 and 2*alpha%4==1 and 4*alpha%4 in (1,2)]
    require(not homs,'missing_generation_hom')
    # Piecewise reflection on the two H/K cosets, verified on every edge.
    f = lambda x,y: (x,((x-x%2)//2-y)%4)
    vertices = list(product(range(8),range(4)))
    require(len({f(x,y) for x,y in vertices})==32,'boundary_bijection')
    for x,y in vertices:
        fx,fy = f(x,y)
        require({f((x+g)%8,(y+t)%4) for g,t in ((4,0),(4,1),(2,0))}
                == {((fx+g)%8,(fy+t)%4) for g,t in ((4,1),(4,2),(2,1))},'boundary_edges')
    # n=3: connected C4 example has cospectrality without any H->C3 onto.
    actual3,length3,delta3 = walk_compare(list(range(4)),lambda x,y:(x+y)%4,0,1,3,3)
    require(actual3,'n3_control')
    actual2,length2,delta2 = walk_compare(list(range(4)),lambda x,y:(x+y)%4,0,1,2,2)
    require(actual2,'n2_control')
    # Even-n positive reflection: h(k)=2 cannot be replaced by 1.
    actual4,length4,delta4 = walk_compare(list(range(4)),lambda x,y:(x+y)%4,0,2,1,4)
    require(actual4,'even_reflection_control')
    high_order = []
    for n in (26,29,31,33,34,35,36):
        actualn,lengthn,deltan = walk_compare(list(range(n)),lambda x,y:(x+y)%n,0,2,1,n)
        require(actualn,('high_order_reflection',n))
        check_automorphism(list(range(n)),lambda x,y:(x+y)%n,0,2,1,n,lambda x:x,2)
        high_order.append({'H_order':n,'n':n,'k':2,'kp':1,'powers_checked':lengthn,'automorphism_checked':True})
    return {'missing_generation':{'H':'C8','n':4,'k':4,'kp':2,'cospectral':actual,
              'global_h_exists':False,'powers_checked':length,'graph_isomorphism_checked':True},
            'excluded_n3':{'H':'C4','n':3,'k':1,'kp':3,'cospectral':actual3,'global_h_exists':False,'powers_checked':length3},
            'excluded_n2':{'H':'C4','n':2,'k':1,'kp':2,'cospectral':actual2,'global_h_exists':False,'powers_checked':length2},
            'even_reflection':{'H':'C4','n':4,'k':2,'kp':1,'cospectral':actual4,'only_s':2,'powers_checked':length4},
            'additional_reflection_presentations':high_order}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--section',choices=['all','roots','tables','legacy','hnf','boundaries'],default='all')
    parser.add_argument('--bound',type=int,default=32)
    parser.add_argument('--output',type=Path,required=True)
    args = parser.parse_args()
    require(2<=args.bound<=100,'bound must be between 2 and 100')
    result = {'status':'DRAFT / finite exact audit, not universal proof or external review',
              'python':platform.python_version(),'dependencies':'Python >=3.10 standard library only',
              'script_sha256':sha256(Path(__file__).read_bytes()).hexdigest()}
    for name,function in [('tables',table_audit),('boundaries',boundary_audit),('roots',root_audit),
                          ('legacy',legacy_walk_audit),('hnf',lambda:hnf_audit(args.bound))]:
        if args.section in ('all',name):
            result[name] = function()
            print(json.dumps({name:{k:v for k,v in result[name].items() if k!='rows'}},sort_keys=True),flush=True)
    args.output.parent.mkdir(parents=True,exist_ok=True)
    args.output.write_text(json.dumps(result,indent=2,sort_keys=True)+'\n',encoding='utf-8')


if __name__=='__main__':
    main()
