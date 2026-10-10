#!/usr/bin/env python3
"""Fail-closed comparison of CU-BRUIT q=15 ordinates against external decimals.

This verifies *decimal compatibility* and checks the SHA256 of an archived raw
source file. It does NOT authenticate a claimed certification of that source,
prove local root isolation, or prove zero completeness. External data must be
audited and converted to DIRECT Conrey-positive lists before using this tool.

Example external JSON:
{"schema":"cu-bruit-q15-external-v1","provenance":
 {"title":"publication and archive","url":"https://example.org/data",
  "access_date":"YYYY-MM-DD","raw_sha256":"64 lowercase hex digits",
  "conventions":"direct Conrey positive ordinates"},
 "characters":{"15.2":{"positive_zeros":["2.7346..."],"complete_to":"25",
 "claimed_complete":true,"max_abs_error":"1e-12","certification_reference":"doi/section"},
 "15.14":{...},"15.8":{...}}}

For complex conjugates 15.2 and 15.8, positive zeros of one are negatives
of NEGATIVE ordinates of the other. Do not pair positive lists by conjugation.
"""
import argparse
import hashlib
import json
import re
import sys
from decimal import Decimal, InvalidOperation
from pathlib import Path

HERE = Path(__file__).resolve().parent
LABELS = {'1,1':'15.2','1,2':'15.14','1,3':'15.8'}
COUNTS = {'15.2':12,'15.14':13,'15.8':12}
T = Decimal('25')

def fail(message):
    raise ValueError(message)

def dec(value):
    if not isinstance(value,str):
        fail('Expected quoted decimal string for ordinate or bound')
    try:
        v=Decimal(value)
    except InvalidOperation as exc:
        raise ValueError('Invalid decimal: '+value) from exc
    if not v.is_finite():
        fail('Non-finite decimal')
    return v

def increasing(values,caption):
    if not isinstance(values,list):
        fail(caption+': expected array')
    vv=[dec(v) for v in values]
    if any(not Decimal(0)<v<T for v in vv):
        fail(caption+': outside 0 < ordinate < 25')
    if vv!=sorted(set(vv)):
        fail(caption+': ordinates must be strictly increasing')
    return vv

def local_catalog(path):
    obj=json.loads(path.read_text(encoding='utf-8'))
    if obj.get('dps')!=40 or set(obj.get('results',{}))!=set(LABELS):
        fail('Local catalog metadata changed')
    out={}
    for ab,label in LABELS.items():
        row=obj['results'][ab]
        if row.get('conrey_label')!=label:
            fail('Local character mapping changed: '+ab)
        zz=increasing(row['zeros'],label+' local')
        if len(zz)!=row.get('count') or len(zz)!=COUNTS[label]:
            fail('Local count changed: '+label)
        out[label]=zz
    return out

def external_catalog(path,raw_path):
    if raw_path is None:
        fail('--raw-source mandatory for external matching')
    obj=json.loads(path.read_text(encoding='utf-8'))
    if obj.get('schema')!='cu-bruit-q15-external-v1':
        fail('Unsupported external schema')
    prov=obj.get('provenance',{})
    for k in ('title','url','access_date','conventions','raw_sha256'):
        if not isinstance(prov.get(k),str) or not prov[k].strip():
            fail('Missing provenance field '+k)
    sha=prov['raw_sha256'].lower()
    if not re.fullmatch('[0-9a-f]{64}',sha):
        fail('Invalid 64-character SHA256')
    actual=hashlib.sha256(raw_path.read_bytes()).hexdigest()
    if actual!=sha:
        fail('Archived source SHA256 mismatch')
    if prov['conventions']!='direct Conrey positive ordinates':
        fail('External source must be normalized with reviewed signed-zero mapping')
    rows=obj.get('characters',{})
    if set(rows)!=set(COUNTS):
        fail('External file must describe exactly Conrey 15.2, 15.14 and 15.8')
    out={};coverage={}
    for label,row in rows.items():
        for k in ('complete_to','claimed_complete','max_abs_error','certification_reference'):
            if k not in row:
                fail(label+': missing '+k)
        if not isinstance(row['certification_reference'],str) or not row['certification_reference'].strip():
            fail(label+': missing certification reference')
        h=dec(row['complete_to']);err=dec(row['max_abs_error'])
        if h<T or row['claimed_complete'] is not True:
            fail(label+': cannot claim full comparison without stated T>=25 coverage')
        if not Decimal(0)<=err<=Decimal('1e-8'):
            fail(label+': precision bound invalid')
        out[label]=increasing(row['positive_zeros'],label+' external')
        coverage[label]={'completeness_claimed_to':str(h),
                        'max_abs_error_claimed':str(err),
                        'certification_reference':row['certification_reference']}
    return out,coverage,prov

def comparison(local,external,tol):
    rows=[];detail={};total=0
    for label in COUNTS:
        aa=local[label];bb=external[label]
        i=j=0;matched=[];missing=[];extra=[]
        while i<len(aa) and j<len(bb):
            diff=bb[j]-aa[i]
            if abs(diff)<=tol:
                matched.append({'local_index_1based':i+1,'external_index_1based':j+1,
                                'local':str(aa[i]),'external':str(bb[j]),
                                'abs_difference':str(abs(diff))})
                i+=1;j+=1
            elif bb[j]<aa[i]-tol:
                extra.append(str(bb[j]));j+=1
            else:
                missing.append(str(aa[i]));i+=1
        missing += [str(z) for z in aa[i:]]
        extra += [str(z) for z in bb[j:]]
        detail[label]={'local_count':len(aa),'external_count':len(bb),
                       'decimal_matches':len(matched),'unmatched_local':missing,
                       'extra_external_ordinates':extra,
                       'max_abs_difference':str(max((dec(x['abs_difference']) for x in matched),default=Decimal(0)))
                       if matched else None}
        rows += [dict(character=label,**m) for m in matched]
        total+=len(matched)
    return rows,detail,total

def main(argv=None):
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument('--local',type=Path,default=HERE/'q15_roots_refined_20261009.json')
    p.add_argument('--external',type=Path)
    p.add_argument('--raw-source',type=Path)
    p.add_argument('--tolerance',default='3e-11',help='numeric threshold only, NOT root error proof')
    p.add_argument('--out',type=Path)
    a=p.parse_args(argv)
    local=local_catalog(a.local);tol=dec(a.tolerance)
    if not Decimal(0)<tol<=Decimal('1e-8'):
        fail('Comparison tolerance outside (0,1e-8]')
    if a.external:
        external,covers,provenance=external_catalog(a.external,a.raw_source)
        rows,detail,total=comparison(local,external,tol)
        complete=(total==37 and all(not v['unmatched_local'] and not v['extra_external_ordinates']
                                     for v in detail.values()))
        status=('ALL_DECIMALS_COMPATIBLE_CERTIFICATION_UNCHECKED'
                if complete else 'EXTERNAL_DISAGREEMENT_OR_MISSING_ZEROS')
    else:
        if a.raw_source:
            fail('--raw-source requires --external')
        total=0;rows=[];covers={};provenance=None;complete=False
        status='NO_EXTERNAL_SOURCE_37_PENDING'
        detail={label:{'local_count':n,'external_count':None,'decimal_matches':0,
                      'unmatched_local':'NO EXTERNAL LIST',
                      'extra_external_ordinates':'UNKNOWN','max_abs_difference':None}
                for label,n in COUNTS.items()}
    report={'id':'CU-BRUIT-02-GATE-A3','status':status,
            'raw_source_sha256_verified':bool(a.external),
            'source_math_certificate_verified':False,
            'local_root_intervals_certified':False,
            'completeness_proved_by_this_script':False,
            'q15_local_count':37,'q15_external_decimal_matches':total,
            'older_q3_q5_external_matches_recorded':30,
            'numeric_tolerance':str(tol),
            'raw_provenance':provenance,'external_coverage_claims_unaudited':covers,
            'by_character':detail,'matched_rows':rows,
            'disclaimer':'Decimal match is not rigorous completeness, root isolation or proof of GRH.'}
    if a.out:
        a.out.write_text(json.dumps(report,indent=2,ensure_ascii=False)+'\n',encoding='utf-8')
    print(json.dumps({'status':status,'q15_matched':total,
                      'completeness_proved':False},indent=2))
    return 0 if not a.external or complete else 2

if __name__=='__main__':
    try:
        sys.exit(main())
    except (ValueError,OSError,KeyError) as e:
        print('FAIL CLOSED: '+str(e),file=sys.stderr)
        sys.exit(2)
