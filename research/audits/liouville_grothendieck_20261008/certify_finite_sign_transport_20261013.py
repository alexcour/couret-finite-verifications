#!/usr/bin/env python3
"""Direct certified sign comparison on a finite prime-race trajectory.

Adaptive interval cover; every unresolved cell is charged to the error.
No inference about global LI/ELI or independent-phase mixing is made.
"""
import argparse
from bisect import bisect_right
import hashlib
import json
from fractions import Fraction as Q
from pathlib import Path
from certify_finite_arithmetic_truncation_20261013 import (
    I, SCALE, log_q, prime_sieve, prime_weight, grid_cells,
    spectral_parameters, spectral_at, finite_occupation,
    pinned_inputs, root_boxes, require)

HERE = Path(__file__).resolve().parent
LIBRARY_SHA = {
    'certify_finite_arithmetic_truncation_20261013.py':
        'a8cd8402a5d6a6d227cd98eef984e54bb2b4f74d8896ea21cf1fe03193b63958',
    'verify_quantitative_specialization_20261013.py':
        '9b72f82919352431f936e142753e69e87c7731f7ea174f7e5ba2f1ce5a505dc6',
}
FIXTURE = 'finite_sign_transport_20261013.json'


def check_libraries():
    for name,digest in LIBRARY_SHA.items():
        require(hashlib.sha256((HERE/name).read_bytes()).hexdigest()==digest,
                'pinned elementary library changed: '+name)


def clipped_mass(value, total):
    """Intersect a measure enclosure with the known physical range [0,M_hi]."""
    return I(max(0,value.lo),min(total.hi,value.hi))


class PositiveLogMeasure:
    """Exact logarithmic occupation of disjoint positive arithmetic intervals."""
    def __init__(self, intervals, bound):
        self.bound = Q(bound)
        self.intervals = [(Q(a),Q(b)) for a,b in intervals]
        previous = Q(2)
        for a,b in self.intervals:
            require(previous <= a < b <= self.bound, 'invalid positive interval cover')
            previous = b
        self.ends = [b for a,b in self.intervals]
        self.prefix = [I.of(0)]
        for a,b in self.intervals:
            self.prefix.append(self.prefix[-1]+log_q(b/a))

    def cumulative(self, x):
        x = Q(x)
        require(2 <= x <= self.bound, 'positive measure argument outside horizon')
        n = bisect_right(self.ends,x)
        value = self.prefix[n]
        if n < len(self.intervals):
            a,b = self.intervals[n]
            if x > a:
                value += log_q(x/a)
        return value

    def on_cell(self, a, b, total):
        require(2 <= a < b <= self.bound, 'invalid measure cell')
        return clipped_mass(self.cumulative(b)-self.cumulative(a),total)


def positive_prime_intervals(flags):
    last, value, intervals = Q(2), 0, []
    for p in range(2,len(flags)):
        if not flags[p] or not prime_weight(p):
            continue
        if value > 0:
            intervals.append((last,Q(p)))
        value += prime_weight(p)
        last = Q(p)
    bound = Q(len(flags)-1)
    if value > 0:
        intervals.append((last,bound))
    return intervals


def classify_sign(box):
    if box.lo > 0:
        return 'positive'
    if box.hi <= 0:
        return 'nonpositive'
    return 'unresolved'


def measure_comparison(cells, bound, positive_measure, signal_box,
                       log_width_limit=Q(1,32768), max_depth=16, max_nodes=100000):
    """Enclose occupations and both directions of disagreement.

    signal_box(a,b) must cover the signal at every x in [a,b]. Its validity
    is proved by the supplied analytic enclosure, not by this control logic.
    """
    require(isinstance(log_width_limit,Q) and log_width_limit>0,
            'invalid unresolved width limit')
    require(isinstance(max_depth,int) and not isinstance(max_depth,bool) and max_depth>=0,
            'invalid maximum depth')
    require(isinstance(max_nodes,int) and not isinstance(max_nodes,bool) and max_nodes>0,
            'invalid node budget')
    norm = log_q(Q(bound,2))
    spectral_positive = I.of(0)
    false_positive, false_negative = I.of(0),I.of(0)
    unknown_total, unknown_arithmetic_positive, unknown_arithmetic_nonpositive = (
        I.of(0),I.of(0),I.of(0))
    covered = I.of(0)
    counts = {'positive':0,'nonpositive':0,'unresolved':0}
    visited, deepest, previous = 0,0,Q(2)
    trace = hashlib.sha256()
    for left,right in cells:
        require(left==previous and left<right<=bound, 'initial cell cover incomplete')
        previous = right
        stack = [(left,right,0)]
        while stack:
            a,b,depth = stack.pop()
            visited += 1
            require(visited<=max_nodes, 'node budget exceeded; incomplete computation refused')
            deepest = max(deepest,depth)
            mass = log_q(b/a)
            box = signal_box(a,b)
            state = classify_sign(box)
            if state=='unresolved' and depth<max_depth and Q(mass.hi,SCALE)>log_width_limit:
                mid = (a+b)/2
                require(a<mid<b, 'adaptive split failed')
                stack.append((mid,b,depth+1))
                stack.append((a,mid,depth+1))
                continue
            pos = positive_measure.on_cell(a,b,mass)
            neg = clipped_mass(mass-pos,mass)
            covered += mass
            counts[state] += 1
            if state=='positive':
                spectral_positive += mass
                false_positive += neg
            elif state=='nonpositive':
                false_negative += pos
            else:
                unknown_total += mass
                unknown_arithmetic_positive += pos
                unknown_arithmetic_nonpositive += neg
            trace.update((str(a)+'|'+str(b)+'|'+state+'|'+
                          '|'.join(box.exact())+'\n').encode())
    require(previous==bound, 'initial cover stopped before horizon')
    require(covered.lo<=norm.hi and covered.hi>=norm.lo, 'terminal mass failed coverage check')
    spectral = I(spectral_positive.lo,spectral_positive.hi+unknown_total.hi)/norm
    fp = I(false_positive.lo,false_positive.hi+unknown_arithmetic_nonpositive.hi)/norm
    fn = I(false_negative.lo,false_negative.hi+unknown_arithmetic_positive.hi)/norm
    known_disagreement = false_positive+false_negative
    mismatch = I(known_disagreement.lo,known_disagreement.hi+unknown_total.hi)/norm
    arithmetic = positive_measure.on_cell(Q(2),Q(bound),norm)/norm
    signed_difference = spectral-arithmetic
    results = {'spectral_positive_occupation':spectral,
               'arithmetic_positive_occupation':arithmetic,
               'arithmetic_nonpositive_spectral_positive':fp,
               'arithmetic_positive_spectral_nonpositive':fn,
               'sign_disagreement_occupation':mismatch,
               'spectral_minus_arithmetic_occupation':signed_difference,
               'unresolved_occupation':unknown_total/norm}
    for key in ('spectral_positive_occupation','arithmetic_positive_occupation',
                'arithmetic_nonpositive_spectral_positive','arithmetic_positive_spectral_nonpositive',
                'sign_disagreement_occupation','unresolved_occupation'):
        # Final intersection with the probability range remains an outward bound.
        results[key] = I(max(0,results[key].lo),min(SCALE,results[key].hi))
    require(results['sign_disagreement_occupation'].lo>=0, 'negative disagreement')
    return dict(measures={k:dict(exact=v.exact(),decimal_outer=v.decimal())
                          for k,v in results.items()},
                cells=counts,visited_nodes=visited,maximum_depth_used=deepest,
                covered_log_mass_exact=covered.exact(),trace_sha256=trace.hexdigest())


def build_report():
    check_libraries()
    rows = root_boxes(pinned_inputs())
    bound,parts = 65536,128
    flags = prime_sieve(bound)
    positive = PositiveLogMeasure(positive_prime_intervals(flags),bound)
    direct = finite_occupation(flags)
    profiles = {}
    for cutoff in (4,25):
        phases,derivative = spectral_parameters(rows,Q(cutoff))
        def signal_box(a,b):
            centre = log_q((a+b)/2)
            lo,hi = log_q(a),log_q(b)
            radius = max(centre.hi-lo.lo,hi.hi-centre.lo)
            return spectral_at(centre,phases).widened(derivative*radius)
        profile = measure_comparison(grid_cells(16,parts),Q(bound),positive,signal_box)
        computed = profile['measures']['arithmetic_positive_occupation']['exact']
        require(Q(computed[0])<=Q(direct.hi,SCALE)
                and Q(computed[1])>=Q(direct.lo,SCALE), 'arithmetic occupation disagrees')
        profile.update(phases=len(phases),time_derivative_upper=derivative)
        profiles[str(cutoff)] = profile
    return dict(id='CU-BRUIT-FINITE-DIRECT-SIGN-TRANSPORT-20261013',
        status='INTERNAL_FINITE_TRAJECTORY_SIGN_ENCLOSURE',prime_argument_upper=bound,
        logarithmic_horizon_symbolic='log(65536)',
        library_sha256=LIBRARY_SHA,
        grid_initial_parts_per_doubling=parts,
        refinement=dict(log_width_limit_exact='1/32768',maximum_depth=16,node_budget=100000),
        profiles=profiles,
        root_enclosures_trusted=True,
        elementary_interval_implementation_reused=True,
        GRH_LI_ELI_or_random_phase_independence_needed_for_this_finite_comparison=False,
        unresolved_cells_counted_in_all_upper_bounds=True,
        global_independence_proved=False,
        time_occupation_identified_with_Haar_or_independent_phase_law=False,
        limiting_arithmetic_density_certified=False,
        uniform_in_horizon_rate_certified=False,
        independent_human_review_claimed=False)


def render(report):
    return json.dumps(report,indent=2,sort_keys=True)+'\n'


def main():
    p = argparse.ArgumentParser(description=__doc__)
    g = p.add_mutually_exclusive_group()
    g.add_argument('--check',action='store_true')
    g.add_argument('--write',action='store_true')
    args = p.parse_args()
    report = build_report()
    target = HERE/FIXTURE
    if args.write:
        target.write_text(render(report),encoding='utf-8',newline='')
    if args.check:
        require(target.read_bytes()==render(report).encode(), 'finite sign receipt differs')
    print(json.dumps(dict(status=report['status'],profiles={k:{
        'spectral_positive':v['measures']['spectral_positive_occupation']['decimal_outer'],
        'disagreement':v['measures']['sign_disagreement_occupation']['decimal_outer'],
        'spectral_minus_arithmetic':v['measures']['spectral_minus_arithmetic_occupation']['decimal_outer'],
        'unresolved':v['measures']['unresolved_occupation']['decimal_outer'],
        'visited_nodes':v['visited_nodes']} for k,v in report['profiles'].items()},
        independent_phase_mixing_certified=False),indent=2))


if __name__=='__main__':
    try:
        main()
    except (ValueError,KeyError,TypeError,OSError) as e:
        raise SystemExit('FAIL CLOSED: '+str(e))
