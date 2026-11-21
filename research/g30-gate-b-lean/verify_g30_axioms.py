"""Check the pinned G30 theorem trust inventory from actual Lean output."""
import hashlib
import json
from pathlib import Path
import re
import sys

NS = 'CouretUnification.G30ComplexSpectrum.'
KERNEL = {'triplet_count', 'spectral_rep_count', 'tc_iso_target2'}
NATIVE = {'spectrum_grid_covers_all_56', 'spectral_reps_pairwise_distinct',
          'spectral_reps_complete', 'spectral_class_sizes', 'power_class_sizes',
          'tc_fiber_size', 'tc_fiber_members', 'tc_iso_target0', 'tc_iso_target1',
          'tc_iso_target3', 'tc_iso_target4'}
MARKER = 'RHClaimed_false_G30ComplexSpectrum'

def check(text):
    if 'sorryAx' in text:
        raise ValueError('Unresolved proof placeholder')
    pattern = r"'([^']+)' (does not depend on any axioms|depends on axioms: \[[^\]]*\])"
    found = re.findall(pattern, text)
    expected = {NS + n for n in KERNEL | NATIVE | {MARKER}}
    names = [name for name, _ in found]
    if len(names) != 15 or len(set(names)) != 15 or set(names) != expected:
        raise ValueError('Missing, duplicated or unexpected theorem axiom record')
    result = {}
    for name, description in found:
        deps = [] if description.startswith('does not') else [a.strip() for a in description.split('[', 1)[1][:-1].split(',')]
        short = name.removeprefix(NS)
        wanted = [] if short == MARKER else ['propext']
        if short in NATIVE:
            wanted += [name + '._native.native_decide.ax_1_1']
        if set(deps) != set(wanted) or len(deps) != len(wanted):
            raise ValueError('Unexpected axioms for ' + name + ': ' + repr(deps))
        result[name] = deps
    return {'accepted': True, 'theorem_roots': 15, 'kernel_proofs': 3,
            'native_proofs': 11, 'scope_marker': 1, 'axioms': result,
            'log_sha256': hashlib.sha256(text.encode()).hexdigest(),
            'scope': 'Pinned Lean 4.29.1 inventory, not a new scientific or RH claim'}

if __name__ == '__main__':
    try:
        receipt = check(Path(sys.argv[1]).read_text(encoding='utf-8'))
        Path(sys.argv[2] if len(sys.argv) > 2 else 'G30_AXIOM_CHECK.json').write_text(
            json.dumps(receipt, indent=2) + '\n', encoding='utf-8')
        print('PASS: 3 kernel proofs, 11 native proofs, 1 scope marker')
    except (ValueError, OSError, IndexError) as error:
        raise SystemExit(str(error))
