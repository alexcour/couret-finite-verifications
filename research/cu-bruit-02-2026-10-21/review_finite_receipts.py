"""Cross-check exact witnesses in existing receipts; no new root isolation.

This is intentionally weaker than regenerating the finite root certificate.
It catches count, sign, conjugation, multiplicity and formula transcription
errors, and compares two recorded precision runs. It proves no GRH or LI.
"""
import argparse
import hashlib
import json
from fractions import Fraction as Q
from pathlib import Path


def load(path):
    return json.loads(path.read_text())


def audit(base):
    hi = [load(base/f'roots_height200_{p}.json') for p in (256,320)]
    fixed = ['character','imaginary_lower_exact','imaginary_upper_exact',
             'left_hardy_sign','right_hardy_sign','simple_zero_on_critical_line']
    for a,b in zip(hi[0]['root_intervals'],hi[1]['root_intervals']):
        assert all(a[k]==b[k] for k in fixed)
    for d in hi:
        assert len(d['root_intervals'])==995
        assert sum(r['zero_count_with_multiplicity'] for r in d['by_character'])==995
        for row in d['root_intervals']:
            assert row['left_hardy_sign']*row['right_hardy_sign']==-1
            assert 0<Q(row['imaginary_lower_exact'])<Q(row['imaginary_upper_exact'])<200
            for side in ['left','right']:
                enc=row[f'{side}_hardy_enclosure']
                sign=row[f'{side}_hardy_sign']
                assert Q(enc['lower_exact'])>0 if sign==1 else Q(enc['upper_exact'])<0
            re,im=row['derivative_real_enclosure'],row['derivative_imag_enclosure']
            assert any(Q(v['lower_exact'])>0 or Q(v['upper_exact'])<0 for v in [re,im])
        ordered=sorted(d['root_intervals'],key=lambda r:Q(r['imaginary_lower_exact']))
        assert all(Q(x['imaginary_upper_exact'])<Q(y['imaginary_lower_exact'])
                   for x,y in zip(ordered,ordered[1:]))
        for r in d['by_character']:
            assert r['boundary_proved_nonzero_by_interval_charts'] and r['integer_isolated']
            assert r['isolated_simple_roots']==r['zero_count_with_multiplicity']
    for p in (256,320):
        c=load(base/f'center_characters_{p}.json')
        assert len(c['characters'])==7 and c['conventional_mean']==-1
        for r in c['characters']:
            assert Q(r['central_modulus_lower']['lower_exact'])>Q(1,10)
    v=load(base/'review_variance_192.json')
    count=v['positive_counts']
    conj={'5.2':'5.3','5.3':'5.2','15.2':'15.8','15.8':'15.2',
          '3.2':'3.2','5.4':'5.4','15.14':'15.14'}
    for lab,r in v['signed_character_contributions'].items():
        assert r['signed_zero_count_to_H']==count[lab]+count[conj[lab]]
    band=Q(v['finite_band_variance']['upper_exact'])
    tail=Q(v['high_tail_variance_upper']['upper_exact'])
    # Rational outer endpoints, independent of Arb printing/rounding conventions.
    assert band+tail<Q(754,125)
    assert Q(67,200)+Q(11,500)*(band+tail)<Q(117,250)
    m=load(base/'review_majorant_192.json')
    assert Q(m['certified_interior_margin_lower_exact'])>Q(8,1000)
    assert m['quadratic']=={'alpha':'67/200','beta':'83/500','eta':'11/500'}
    return dict(status='INTERNAL_EXACT_RECEIPT_CROSSCHECK',positive_roots=995,
        signed_conjugate_counts_checked=True,central_nonzero=7,
        sign_upper_less_than='117/250',GRH_proved=False,LI_proved=False,
        roots_regenerated_by_this_check=False,independent_review=False)


if __name__=='__main__':
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument('--base',type=Path,required=True)
    p.add_argument('--out',type=Path,required=True)
    a=p.parse_args();r=audit(a.base)
    r['script_sha256']=hashlib.sha256(Path(__file__).read_bytes()).hexdigest()
    a.out.write_text(json.dumps(r,indent=2)+'\n');print(json.dumps(r,indent=2))
