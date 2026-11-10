#!/usr/bin/env python3
"""Replay a numerical external decimal comparison; never certify zeros.

Reads the three original gzip archives, checks their recorded SHA256 hashes,
identifies characters from all eight exact header phases, and compares the
positive ordinates below 25 against the unchanged local catalogue.
Python 3.12 standard library only. No network access or root calculation.
"""
import argparse
import csv
import gzip
import hashlib
import io
import json
import re
import sys
from decimal import Decimal, localcontext, ROUND_HALF_EVEN
from fractions import Fraction
from pathlib import Path

HERE = Path(__file__).resolve().parent
UNITS = (1, 2, 4, 7, 8, 11, 13, 14)
LOG5 = {1: 0, 2: 1, 4: 2, 3: 3}
LABELS = {1: ('15.2', 12), 2: ('15.14', 13), 3: ('15.8', 12)}
LOCAL_SHA256 = 'a71da95c1d29452651734b53c5830098d67a9abc7b062a8f18623f46ff7aa3b2'
CUTOFF = Decimal('25')
QUANTUM = Decimal('1e-20')
TOLERANCE = Decimal('5e-21')


def require(ok, message):
    if not ok:
        raise ValueError(message)


def expected_phase(b, n):
    return (Fraction(n % 3 == 2, 2) + Fraction(b * LOG5[n % 5], 4)) % 1


def parse_archive(data):
    text = gzip.decompress(data).decode('utf-8')
    require(re.search(r'^# character modulus: 15$', text, re.M), 'source modulus is not 15')
    phases = {}
    values = []
    for line in text.splitlines():
        if line.startswith('#'):
            m = re.fullmatch(r'#\s+(\d+)\s+(-?\d+(?:/\d+)?)\s*', line)
            if m:
                n = int(m[1])
                require(n not in phases, 'duplicate header unit')
                phases[n] = Fraction(m[2])
        elif line.strip():
            token = line.strip()
            require(re.fullmatch(r'\d+\.\d{20}', token) is not None, 'source decimal format changed')
            values.append(Decimal(token))
    require(set(phases) == set(UNITS), 'header must give exactly all eight units')
    matches = [b for b in LABELS if all(phases[n] % 1 == expected_phase(b, n) for n in UNITS)]
    require(len(matches) == 1, 'header character identity is not unique')
    require(len(values) == 10000, 'source must retain its 10000 rows')
    require(values == sorted(set(values)) and values[0] > 0, 'source ordinates must be strictly increasing and positive')
    require(not any(v == CUTOFF for v in values), 'source has a cutoff-boundary ordinate requiring separate handling')
    b = matches[0]
    require(phases[14] % 1 == Fraction((1 + b) % 2, 2), 'source character parity mismatch')
    return b, phases, values


def replay(manifest_path, local_path, raw_dir):
    manifest = json.loads(Path(manifest_path).read_text(encoding='utf-8'))
    require(manifest.get('schema') == 'cu-bruit-q15-aveiro-numerical-v1', 'unsupported manifest')
    require(manifest.get('source_math_certificate_verified') is False, 'numerical source manifest cannot assert mathematical certification')
    sources = manifest.get('sources', [])
    require(len(sources) == 3, 'need three separate external source archives')
    local_bytes = Path(local_path).read_bytes()
    require(hashlib.sha256(local_bytes).hexdigest() == LOCAL_SHA256, 'local catalogue bytes changed')
    local = json.loads(local_bytes)
    require(local.get('dps') == 40 and set(local.get('results', {})) == {'1,1', '1,2', '1,3'}, 'local catalogue metadata changed')
    detail = []
    rows = []
    seen = set()
    with localcontext() as ctx:
        ctx.prec = 80
        for source in sources:
            data = (Path(raw_dir) / source['filename']).read_bytes()
            digest = hashlib.sha256(data).hexdigest()
            require(digest == source['sha256'], 'source SHA256 mismatch: ' + source['filename'])
            require(len(data) == source['size_bytes'], 'source byte count mismatch')
            b, phases, values = parse_archive(data)
            label, count = LABELS[b]
            require(label == source['conrey_label'], 'source character differs from manifest label')
            require(label not in seen, 'duplicate external character')
            seen.add(label)
            require({str(n): str(phases[n]) for n in UNITS} == source['header_phases'], 'recorded header phases changed')
            source_below = [v for v in values if v < CUTOFF]
            require(len(source_below) == count, 'external sub-25 count differs from local catalogue')
            candidate = local['results']['1,' + str(b)]
            require(candidate['conrey_label'] == label and candidate['count'] == count, 'local character/count mismatch')
            local_values = [Decimal(v) for v in candidate['zeros']]
            require(len(local_values) == count and local_values == sorted(set(local_values)), 'local ordinate sequence changed')
            require(all(0 < v < CUTOFF for v in local_values), 'local ordinate outside open cutoff range')
            deltas = []
            for i, (outside, inside) in enumerate(zip(source_below, local_values), 1):
                delta = abs(outside - inside)
                require(delta <= TOLERANCE and inside.quantize(QUANTUM, rounding=ROUND_HALF_EVEN) == outside,
                        'external decimal disagreement for ' + label + ' row ' + str(i))
                deltas.append(delta)
                rows.append({'character': label, 'index_1based': i,
                             'external': format(outside, 'f'), 'local': format(inside, 'f'),
                             'abs_difference': str(delta)})
            detail.append({'filename': source['filename'], 'source_url': source['url'],
                           'conrey_label': label, 'raw_sha256_verified': digest,
                           'header_phases': {str(n): str(phases[n]) for n in UNITS},
                           'source_positive_rows_parsed': len(values),
                           'source_rows_below_25': len(source_below), 'local_rows_below_25': count,
                           'decimal_matches': count, 'unmatched_local_in_supplied_table': 0,
                           'extra_external_in_supplied_table_below_25': 0,
                           'first_supplied_ordinate_above_25': format(values[count], 'f'),
                           'max_abs_difference': str(max(deltas))})
        require(seen == {x[0] for x in LABELS.values()} and len(rows) == 37, 'incomplete three-character comparison')
        rows.sort(key=lambda r: (r['character'], r['index_1based']))
        detail.sort(key=lambda r: r['conrey_label'])
        return {'id': 'CU-BRUIT-02-Q15-AVEIRO-20261012',
                'status': '37_EXTERNAL_NUMERICAL_MATCHES_COMPLETENESS_UNCERTIFIED',
                'access_date': manifest['access_date'], 'source_author': manifest['source_author'],
                'q15_local_count': 37, 'q15_external_decimal_matches': len(rows),
                'prior_q3_q5_external_matches_recorded_not_rerun': 30,
                'cumulative_recorded_decimal_matches': 67,
                'local_catalogue_sha256_verified': LOCAL_SHA256,
                'raw_archive_hashes_verified': True,
                'character_identity_checked_from_all_unit_phases': True,
                'external_display_decimal_places': 20,
                'comparison_threshold_not_certified_error_bound': str(TOLERANCE),
                'all_local_candidates_round_to_external_display': True,
                'max_abs_difference': str(max(Decimal(r['abs_difference']) for r in rows)),
                'source_math_certificate_verified': False,
                'local_root_intervals_certified': False,
                'completeness_proved_by_this_script': False,
                'GRH_or_LI_proved': False,
                'prime_race_density_certified': False,
                'external_human_mathematical_review_claimed': False,
                'by_character': detail, 'matched_rows': rows,
                'limitation': 'Agreement of displayed approximate decimals is not an error enclosure, a complete-zero count, a proof of GRH/LI or a certified prime-race density.'}


def csv_text(report):
    stream = io.StringIO(newline='')
    writer = csv.DictWriter(stream, fieldnames=['character', 'index_1based', 'external', 'local', 'abs_difference'], lineterminator='\n')
    writer.writeheader()
    writer.writerows(report['matched_rows'])
    return stream.getvalue()


def main(argv=None):
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--manifest', type=Path, default=HERE / 'q15_aveiro_sources_20261012.json')
    parser.add_argument('--local', type=Path, default=HERE / 'q15_roots_refined_20261009.json')
    parser.add_argument('--raw-dir', type=Path, default=HERE / 'external_data/aveiro_20261012')
    parser.add_argument('--out', type=Path)
    parser.add_argument('--csv', type=Path)
    parser.add_argument('--check', action='store_true')
    args = parser.parse_args(argv)
    report = replay(args.manifest, args.local, args.raw_dir)
    table = csv_text(report)
    if args.check:
        stored = json.loads((HERE / 'q15_aveiro_comparison_20261012.json').read_text(encoding='utf-8'))
        require(report == stored, 'recorded comparison report changed')
        require(table == (HERE / 'q15_aveiro_matched_37_20261012.csv').read_text(encoding='utf-8'), 'recorded 37-row comparison CSV changed')
    if args.out:
        args.out.write_text(json.dumps(report, indent=2, ensure_ascii=False) + '\n', encoding='utf-8')
    if args.csv:
        args.csv.write_text(table, encoding='utf-8')
    print(json.dumps({k: report[k] for k in ('status', 'q15_external_decimal_matches', 'max_abs_difference', 'completeness_proved_by_this_script', 'prime_race_density_certified')}, indent=2))
    return 0


if __name__ == '__main__':
    try:
        sys.exit(main())
    except (ValueError, OSError, KeyError, gzip.BadGzipFile) as exc:
        print('FAIL CLOSED: ' + str(exc), file=sys.stderr)
        sys.exit(2)
