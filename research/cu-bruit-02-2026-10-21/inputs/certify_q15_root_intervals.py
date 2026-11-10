#!/usr/bin/env python3
"""Internal ball-arithmetic certificate for q15 roots and a finite zero count.

Requires python-flint 0.9.0 / FLINT 3.6.0. The implementation and written
argument remain proposed for independent review. No global GRH/LI or density
claim is made. A failed enclosure is never replaced by a floating-point test.
"""
import argparse
import hashlib
import json
import sys
from decimal import Decimal, localcontext
from fractions import Fraction as Q
from pathlib import Path
import flint
from flint import arb, acb, acb_series, dirichlet_char, fmpq, ctx

HERE = Path(__file__).resolve().parent
PRECISION = 256
TAYLOR_TERMS = 20
RADIUS = Q(1, 10**30)
LOCAL_SHA = 'a71da95c1d29452651734b53c5830098d67a9abc7b062a8f18623f46ff7aa3b2'
UNITS = (1, 2, 4, 7, 8, 11, 13, 14)
LOG5 = {1: 0, 2: 1, 4: 2, 3: 3}
ROWS = {'1,1': (2, 1, 12), '1,2': (14, 2, 13), '1,3': (8, 3, 12)}
CONTOUR = [(Q(-1,8),Q(0)), (Q(9,8),Q(0)), (Q(9,8),Q(25)),
           (Q(-1,8),Q(25)), (Q(-1,8),Q(0))]


def require(ok, message):
    if not ok:
        raise ValueError(message)


def A(x):
    x = Q(x)
    return arb(fmpq(x.numerator, x.denominator))


def point(z):
    return acb(A(z[0]), A(z[1]))


def segment_box(a, b):
    return acb(A(a[0]).union(A(b[0])), A(a[1]).union(A(b[1])))


def sign(x):
    return 1 if x > 0 else -1 if x < 0 else 0


def dyadic(x):
    m, e = x.man_exp()
    return [str(m), int(e)]


def enclosure(x):
    require(x.is_finite(), 'non-finite ball')
    return {'lower_dyadic': dyadic(x.lower()), 'upper_dyadic': dyadic(x.upper())}


def decimal_rational(x):
    with localcontext() as c:
        c.prec = 100
        return format(Decimal(x.numerator) / Decimal(x.denominator), 'f')


def primitive_character(number, b):
    chi = dirichlet_char(15, number)
    require(chi.conductor() == 15 and chi.is_primitive() and not chi.is_principal(), 'wrong primitive character')
    require(chi.number() == number and chi.parity() == (1+b)%2, 'character label/parity mismatch')
    ipowers = (acb(1), acb(0,1), acb(-1), acb(0,-1))
    for n in range(15):
        expected = acb(0) if n not in UNITS else (-1 if n%3==2 else 1)*ipowers[(b*LOG5[n%5])%4]
        require(chi(n) == expected, 'exact character value mismatch')
    require(sum((chi(n) for n in range(15)), acb(0)) == acb(0), 'character is not zero-mean')
    return chi


def isolate_root(chi, seed, radius=RADIUS):
    require(radius > 0, 'root radius must be positive')
    center = Q(seed)
    left, right = center-radius, center+radius
    require(0 < left < right < 25, 'local root interval outside cutoff')
    zl, zr = chi.hardy_z(A(left)), chi.hardy_z(A(right))
    require(zl.imag.is_zero() and zr.imag.is_zero(), 'Hardy Z result is not real')
    require(sign(zl.real)*sign(zr.real) == -1, 'endpoint signs unresolved or not opposite')
    rectangle = acb(A(Q(1,2)-radius).union(A(Q(1,2)+radius)), A(left).union(A(right)))
    previous = ctx.cap
    try:
        ctx.cap = 2
        derivative = acb_series([rectangle,1],prec=2).dirichlet_l(chi)[1]
    finally:
        ctx.cap = previous
    re_sign, im_sign = sign(derivative.real), sign(derivative.imag)
    require(re_sign or im_sign, 'derivative component unresolved: uniqueness not certified')
    return {'seed': seed, 'imaginary_lower_exact': decimal_rational(left),
            'imaginary_upper_exact': decimal_rational(right), 'interval_width_exact': decimal_rational(2*radius),
            'left_hardy_sign': sign(zl.real), 'right_hardy_sign': sign(zr.real),
            'left_hardy_enclosure': enclosure(zl.real), 'right_hardy_enclosure': enclosure(zr.real),
            'derivative_real_enclosure_over_rectangle': enclosure(derivative.real),
            'derivative_imag_enclosure_over_rectangle': enclosure(derivative.imag),
            'nonzero_derivative_component': 'real' if re_sign else 'imaginary',
            'existence_on_critical_line': True, 'unique_simple_zero_in_rectangle': True}


def taylor_coefficients(chi):
    previous = ctx.cap
    try:
        ctx.cap = TAYLOR_TERMS
        result = acb_series([1,1],prec=TAYLOR_TERMS).dirichlet_l(chi,deflate=True)
        coefficients = result.coeffs()
    finally:
        ctx.cap = previous
    require(result.prec == TAYLOR_TERMS and len(coefficients) == TAYLOR_TERMS,
            'Taylor coefficient count does not match remainder order')
    return coefficients


class CompletedL:
    """Entire completed primitive L function, with explicit removable-pole handling."""
    def __init__(self, chi):
        self.chi = chi
        self.bar = dirichlet_char(15, pow(int(chi.number()),-1,15))
        self.parity = int(chi.parity())
        require(self.bar.is_primitive() and self.bar.parity() == self.parity, 'conjugate metadata mismatch')
        require(all(self.bar(n) == chi(n).conjugate() for n in range(15)), 'conjugate values mismatch')
        tau = sum((chi(n)*acb(0,2*arb.pi()*n/15).exp() for n in range(15)), acb(0))
        self.epsilon = tau*(acb(0,-1)**self.parity)/arb(15).sqrt()
        require(self.epsilon.is_finite() and not self.epsilon.contains(0), 'unresolved root number')
        self.logq = (arb(15)/arb.pi()).log()
        self.taylor = {}
        for z in [point((Q(1,4),Q(3,2))), point((Q(3,4),Q(7,3)))]:
            require(self.direct(z,chi).overlaps(self.epsilon*self.direct(1-z,self.bar)), 'functional-equation normalization mismatch')

    def regular_l(self, s, chi):
        w = s-1
        bound = w.abs_upper()
        if bound < arb('0.25'):
            key = int(chi.number())
            if key not in self.taylor:
                self.taylor[key] = taylor_coefficients(chi)
            result = acb(0)
            for coefficient in reversed(self.taylor[key]):
                result = result*w + coefficient
            # |L(z)| <= 45 on |z-1|=1/2, by zero-mean periodic sums.
            # Cauchy: tail from degree m is <= 45*(2|w|)^m/(1-2|w|).
            error = (45*(2*bound)**TAYLOR_TERMS/(1-2*bound)).abs_upper()
            return result + acb(arb(0,error),arb(0,error))
        return chi.l_function(s)

    def direct(self, s, chi):
        v = (s+self.parity)/2
        return (self.logq*v).exp()*v.gamma()*self.regular_l(s,chi)

    def __call__(self, s):
        # The two expressions are the same entire function by its FE.
        # Reflection avoids gamma poles at the left/bottom corner.
        if s.real.mid() < A(Q(1,2)):
            return self.epsilon*self.direct(1-s,self.bar)
        return self.direct(s,self.chi)


def count_contour(function, corners=CONTOUR, max_depth=12):
    require(len(corners)>=4 and corners[0]==corners[-1], 'contour must be closed')
    cache = {}
    accepted = 0
    deepest = 0
    min_margin = None
    def value(z):
        if z not in cache:
            cache[z] = function(point(z))
        require(cache[z].is_finite(), 'non-finite endpoint value')
        return cache[z]
    def cover(a,b,depth=0):
        nonlocal accepted,deepest,min_margin
        mid = tuple((a[j]+b[j])/2 for j in range(2))
        vm = value(mid)
        anchor = acb(vm.real.mid(),vm.imag.mid())
        image = function(segment_box(a,b))
        rotated = image/anchor
        if rotated.is_finite() and rotated.real > 0:
            angle = (value(b)/value(a)).arg()
            if angle.is_finite() and angle.abs_upper() < arb.pi():
                accepted += 1
                deepest = max(deepest,depth)
                margin = rotated.real.lower()
                if min_margin is None or margin < min_margin:
                    min_margin = margin
                return angle
        require(depth < max_depth, 'contour chart unresolved at maximum subdivision depth')
        return cover(a,mid,depth+1)+cover(mid,b,depth+1)
    total = arb(0)
    for a,b in zip(corners,corners[1:]):
        length = max(abs(b[0]-a[0]),abs(b[1]-a[1]))
        n = max(1,(length*8).__ceil__())
        for k in range(n):
            x = tuple(a[j]+(b[j]-a[j])*Q(k,n) for j in range(2))
            y = tuple(a[j]+(b[j]-a[j])*Q(k+1,n) for j in range(2))
            total += cover(x,y)
    winding = total/(2*arb.pi())
    integer = winding.unique_fmpz()
    require(integer is not None, 'winding enclosure does not determine one integer')
    require(min_margin is not None and min_margin > 0, 'missing strict contour nonvanishing witness')
    return {'zero_count_with_multiplicity': int(integer), 'winding_enclosure': enclosure(winding),
            'accepted_interval_charts': accepted, 'maximum_subdivision_depth': deepest,
            'minimum_rotated_real_lower_dyadic': dyadic(min_margin),
            'boundary_proved_nonzero_by_interval_charts': True,
            'integer_isolated': True}


def certificate(local_path, precision=PRECISION):
    require(flint.__version__=='0.9.0' and flint.__FLINT_VERSION__=='3.6.0', 'unreviewed backend version')
    require(precision>=64, 'invalid precision')
    ctx.prec = precision
    data = Path(local_path).read_bytes()
    require(hashlib.sha256(data).hexdigest()==LOCAL_SHA, 'local catalogue bytes changed')
    local = json.loads(data)
    require(set(local['results'])==set(ROWS) and local['dps']==40, 'catalogue schema changed')
    roots = []
    counts = []
    for key,(number,b,expected) in ROWS.items():
        row = local['results'][key]
        label = '15.'+str(number)
        require(row['conrey_label']==label and row['count']==expected and len(row['zeros'])==expected, 'local character count changed')
        chi = primitive_character(number,b)
        previous_upper = Q(0)
        for rank,seed in enumerate(row['zeros'],1):
            result = isolate_root(chi,seed)
            require(Q(result['imaginary_lower_exact'])>previous_upper, 'local isolation intervals overlap')
            previous_upper = Q(result['imaginary_upper_exact'])
            roots.append(dict(character=label,index_1based=rank,**result))
        total = count_contour(CompletedL(chi))
        require(total['zero_count_with_multiplicity']==expected, 'total contour count differs from simple isolated roots')
        counts.append(dict(character=label,isolated_simple_roots=expected,**total))
    require(len(roots)==37 and sum(x['zero_count_with_multiplicity'] for x in counts)==37, 'incomplete finite count')
    return {'id':'CU-BRUIT-Q15-INTERVALS-20261012','status':'INTERNAL_INTERVAL_CERTIFICATE_37_ROOTS_AND_FINITE_COMPLETENESS',
            'python_flint_version':flint.__version__,'FLINT_version':flint.__FLINT_VERSION__,
            'working_precision_bits':precision,'taylor_terms_near_one':TAYLOR_TERMS,
            'local_catalogue_sha256':LOCAL_SHA,'root_interval_width_exact':'0.000000000000000000000000000002',
            'contour_vertices_exact':[[str(x),str(y)] for x,y in CONTOUR],
            'positive_height_region':'0 < Im(s) < 25; critical strip inside Re(s) in [-1/8,9/8]',
            'isolated_simple_critical_line_roots':37,'total_nontrivial_positive_zeros_counted':37,
            'finite_positive_q15_catalogue_complete_within_declared_region':True,
            'conditional_on_trusted_Arb_backend_and_written_argument':True,
            'independent_human_review_claimed':False,'Lean_formalization_claimed':False,
            'global_GRH_or_LI_proved':False,'prime_race_density_certified':False,
            'by_character':counts,'root_intervals':roots}


def verify_receipt(recomputed,recorded):
    require(recomputed==recorded,'recorded interval certificate differs from fresh replay')


def main():
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument('--local',type=Path,default=HERE/'q15_roots_refined_20261009.json')
    p.add_argument('--precision',type=int,default=PRECISION)
    p.add_argument('--out',type=Path)
    p.add_argument('--check',action='store_true')
    a=p.parse_args()
    result=certificate(a.local,a.precision)
    if a.check:
        recorded=json.loads((HERE/'q15_root_interval_certificate_20261012.json').read_text())
        verify_receipt(result,recorded)
    if a.out:
        a.out.write_text(json.dumps(result,indent=2,ensure_ascii=False)+'\n')
    print(json.dumps({'status':result['status'],'isolated_roots':37,
                      'contour_counts':[x['zero_count_with_multiplicity'] for x in result['by_character']],
                      'finite_completeness':True,'global_GRH_or_LI':False,'density_certified':False},indent=2))


if __name__=='__main__':
    try:
        main()
    except (ValueError,OSError,KeyError,TypeError) as e:
        print('FAIL CLOSED: '+str(e),file=sys.stderr)
        sys.exit(2)
