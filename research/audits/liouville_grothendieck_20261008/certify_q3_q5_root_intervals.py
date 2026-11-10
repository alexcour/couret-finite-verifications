#!/usr/bin/env python3
"""Extend the pinned q15 Arb method to the thirty q3/q5 roots below 25.

Search iterates and old decimal seeds are not existence proofs. Each refined
interval is separately isolated by strict Hardy signs and a derivative enclosure,
then compared with an entire completed-L winding count. Same trusted Arb backend
and counting algorithm as q15; no independent implementation, GRH or LI claim.
"""
import argparse
import hashlib
import json
import sys
from math import gcd
from fractions import Fraction as Q
from pathlib import Path
import flint
from flint import arb, acb, acb_series, dirichlet_char, ctx
from certify_q15_root_intervals import (HERE, PRECISION, CONTOUR, RADIUS, A, point,
    decimal_rational, isolate_root, CompletedL, count_contour, require)

SOURCE_SHA = 'e53127a4aa5859c92ab397b28c29aa09fa84bce8c51d02ceac1e01e3ef216092'
ROWS = {'1,0': (3,2,1,0,6), '0,1': (5,2,0,1,8),
        '0,2': (5,4,0,2,8), '0,3': (5,3,0,3,8)}
LOG5 = {1:0,2:1,4:2,3:3}


def small_character(q, number, a, b):
    require((q,number,a,b) in [r[:4] for r in ROWS.values()], 'unknown character tuple')
    chi = dirichlet_char(q,number)
    require(chi.modulus()==q and chi.conductor()==q and chi.is_primitive() and
            not chi.is_principal() and chi.parity()==(a+b)%2, 'primitive metadata mismatch')
    powers = (acb(1),acb(0,1),acb(-1),acb(0,-1))
    for n in range(q):
        value = acb(0) if gcd(n,q)>1 else (
            (-1 if a and n%3==2 else 1)*powers[b*LOG5[n%5]%4] if b else
            acb(-1 if n%3==2 else 1))
        require(chi(n)==value, 'exact small-conductor character mismatch')
    require(sum((chi(n) for n in range(q)),acb(0))==acb(0), 'nonzero character mean')
    return chi


def rational_mid(x):
    m,e = x.mid().man_exp()
    return Q(int(m))*Q(2)**int(e)


def refine_search_seed(chi, original):
    """Four midpoint Newton search steps; subsequently proved by isolate_root."""
    t = Q(str(original))
    previous = ctx.cap
    try:
        ctx.cap = 2
        for _ in range(4):
            z = point((Q(1,2),t))
            series = acb_series([z,1],prec=2).dirichlet_l(chi)
            require(series.prec==2 and len(series.coeffs())==2, 'Newton series order mismatch')
            correction = series[0]/series[1]
            require(correction.is_finite(), 'Newton search unresolved')
            t = rational_mid((z-correction).imag)
    finally:
        ctx.cap = previous
    scale = 10**36
    # This rounding defines a search center, not an enclosure of a root.
    rounded = Q((t.numerator*scale+t.denominator//2)//t.denominator,scale)
    return decimal_rational(rounded)


class SmallCompletedL(CompletedL):
    """Inherited twenty-term near-one bound 45 remains valid for q<=15."""
    def __init__(self, chi):
        q = int(chi.modulus())
        require(q in (3,5), 'small completed-L modulus outside proof')
        self.chi = chi
        self.bar = dirichlet_char(q,pow(int(chi.number()),-1,q))
        self.parity = int(chi.parity())
        require(self.bar.is_primitive() and self.bar.parity()==self.parity and
                all(self.bar(n)==chi(n).conjugate() for n in range(q)), 'conjugate mismatch')
        tau = sum((chi(n)*acb(0,2*arb.pi()*n/q).exp() for n in range(q)),acb(0))
        self.epsilon = tau*(acb(0,-1)**self.parity)/arb(q).sqrt()
        require(self.epsilon.is_finite() and not self.epsilon.contains(0), 'root number unresolved')
        self.logq = (arb(q)/arb.pi()).log()
        self.taylor = {}
        for z in [point((Q(1,4),Q(3,2))),point((Q(3,4),Q(7,3)))]:
            require(self.direct(z,chi).overlaps(self.epsilon*self.direct(1-z,self.bar)),
                    'functional equation normalization mismatch')


def certificate(precision=PRECISION):
    require(flint.__version__=='0.9.0' and flint.__FLINT_VERSION__=='3.6.0', 'unreviewed backend')
    require(precision>=64, 'invalid precision')
    ctx.prec = precision
    raw = (HERE/'lmfdb_zero_comparison_20261009.json').read_bytes()
    require(hashlib.sha256(raw).hexdigest()==SOURCE_SHA, 'historical seed bytes changed')
    source = json.loads(raw)
    entries = {r['ab']:r for r in source['entries']}
    roots, counts = [], []
    for ab,(q,number,a,b,expected) in ROWS.items():
        row = entries[ab]
        label = f'{q}.{number}'
        require(row['conrey_label']==label and row['conductor']==q and
                len(row['positive_zero_ordinates_under_25'])==expected, 'seed metadata mismatch')
        chi = small_character(q,number,a,b)
        previous = Q(0)
        for rank,old in enumerate(row['positive_zero_ordinates_under_25'],1):
            center = refine_search_seed(chi,old)
            result = isolate_root(chi,center)
            require(Q(result['imaginary_lower_exact'])>previous, 'root intervals overlap')
            previous = Q(result['imaginary_upper_exact'])
            roots.append(dict(character=label,ab=ab,index_1based=rank,
                              historical_search_seed=str(old),**result))
        count = count_contour(SmallCompletedL(chi))
        require(count['zero_count_with_multiplicity']==expected, 'finite count differs from isolations')
        counts.append(dict(character=label,ab=ab,isolated_simple_roots=expected,**count))
    require(len(roots)==30 and sum(r['zero_count_with_multiplicity'] for r in counts)==30,
            'thirty-root accounting failed')
    return dict(id='CU-BRUIT-Q3-Q5-INTERVALS-20261013',
        status='INTERNAL_INTERVAL_CERTIFICATE_30_ROOTS_AND_FINITE_COMPLETENESS',
        python_flint_version=flint.__version__,FLINT_version=flint.__FLINT_VERSION__,
        working_precision_bits=precision,taylor_terms_near_one=20,
        historical_seed_sha256=SOURCE_SHA,refinement_is_search_not_proof=True,
        root_interval_width_exact=decimal_rational(2*RADIUS),
        contour_vertices_exact=[[str(x),str(y)] for x,y in CONTOUR],
        isolated_simple_critical_line_roots=30,total_nontrivial_positive_zeros_counted=30,
        finite_positive_catalogue_complete_within_declared_region=True,
        conditional_on_trusted_Arb_backend_and_written_argument=True,
        global_GRH_or_LI_proved=False,prime_race_density_certified=False,
        independent_human_review_claimed=False,independent_counting_algorithm_claimed=False,
        by_character=counts,root_intervals=roots)


def main():
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument('--precision',type=int,default=PRECISION)
    g = p.add_mutually_exclusive_group()
    g.add_argument('--check',action='store_true')
    g.add_argument('--write',action='store_true')
    args = p.parse_args()
    result = certificate(args.precision)
    rendered = json.dumps(result,indent=2,sort_keys=True)+'\n'
    path = HERE/'q3_q5_root_interval_certificate_20261013.json'
    if args.write:
        require(args.precision==PRECISION, 'canonical receipt requires 256 bits')
        path.write_text(rendered,encoding='utf-8',newline='')
    if args.check:
        require(path.read_bytes()==rendered.encode(), 'root receipt differs from fresh replay')
    print(json.dumps(dict(status=result['status'],isolated_roots=30,
        counts={r['character']:r['zero_count_with_multiplicity'] for r in result['by_character']},
        precision=args.precision,global_GRH_or_LI=False,prime_density_certified=False),indent=2))


if __name__=='__main__':
    try:
        main()
    except (ValueError,KeyError,OSError,TypeError) as e:
        raise SystemExit('FAIL CLOSED: '+str(e))
