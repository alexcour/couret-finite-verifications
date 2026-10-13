#!/usr/bin/env python3
"""Exact arithmetic/topological checker for q15 contour charts.

No python-flint, floating point, complex math, or special functions are used.
Given segment boxes that REALLY enclose Lambda_chi(segment), this checker
proves a winding number by homotopy to a rational polygon. The correctness
of the supplied analytic enclosures is an explicit external assumption.
"""
import argparse
import hashlib
import json
from fractions import Fraction as F
from pathlib import Path

MAX_CHARTS = 100000
EXPECTED = {'15.2': 12, '15.14': 13, '15.8': 12}
CORNERS = [(F(-1,8), F(0)), (F(9,8), F(0)), (F(9,8), F(25)),
           (F(-1,8), F(25)), (F(-1,8), F(0))]

class InvalidCertificate(ValueError):
    pass

def require(test, msg):
    if not test:
        raise InvalidCertificate(msg)

def rat(x):
    """Exact integer/fraction string; disallow float JSON inputs."""
    require(isinstance(x, str) and len(x) < 120, 'rational must be a short string')
    try:
        q = F(x)
    except (ValueError, ZeroDivisionError):
        raise InvalidCertificate('malformed rational') from None
    require(q.denominator <= 10**80, 'excessive rational denominator')
    return q

def dyad(x):
    require(isinstance(x,list) and len(x)==2, 'invalid dyadic shape')
    m,e=x
    require(isinstance(m,str) and isinstance(e,int) and len(m)<1000 and abs(e)<=4096,
            'invalid dyadic mantissa/exponent')
    try:
        n=int(m)
    except ValueError:
        raise InvalidCertificate('invalid dyadic integer') from None
    return F(n*2**e,1) if e>=0 else F(n,2**(-e))

def point(x):
    require(isinstance(x,list) and len(x)==2,'point shape')
    return (rat(x[0]),rat(x[1]))

def box(x):
    require(isinstance(x,dict) and set(x)=={'re','im'},'box keys')
    require(all(isinstance(x[k],list) and len(x[k])==2 for k in ('re','im')),'bounds shape')
    a,b=map(dyad,x['re']); c,d=map(dyad,x['im'])
    require(a<=b and c<=d,'reversed box')
    require(b<0 or a>0 or d<0 or c>0,'box may include zero')
    return ((a,b),(c,d))

def intersection_box(B,C):
    x=(max(B[0][0],C[0][0]),min(B[0][1],C[0][1]))
    y=(max(B[1][0],C[1][0]),min(B[1][1],C[1][1]))
    require(x[0]<=x[1] and y[0]<=y[1],'adjacent boxes do not meet')
    return ((x[0]+x[1])/2,(y[0]+y[1])/2)

def in_box(p,B):
    return B[0][0]<=p[0]<=B[0][1] and B[1][0]<=p[1]<=B[1][1]

def edge_ok(start,end,side):
    a,b=CORNERS[side],CORNERS[side+1]
    if side==0:
        return start[1]==end[1]==a[1] and a[0]<=start[0]<end[0]<=b[0]
    if side==1:
        return start[0]==end[0]==a[0] and a[1]<=start[1]<end[1]<=b[1]
    if side==2:
        return start[1]==end[1]==a[1] and b[0]<=end[0]<start[0]<=a[0]
    return start[0]==end[0]==a[0] and b[1]<=end[1]<start[1]<=a[1]

def ray_winding(vertices):
    """Exact signed crossings of a ray with rational positive direction."""
    slopes=[F(k,97) for k in range(100)]
    chosen=None
    for m in slopes:
        if all(y-m*x != 0 for x,y in vertices):
            chosen=m;break
    require(chosen is not None,'cannot select a ray avoiding vertices')
    crossings=0
    for (x,y),(xx,yy) in zip(vertices,vertices[1:]+vertices[:1]):
        va=y-chosen*x; vb=yy-chosen*xx
        if (va<0<vb) or (vb<0<va):
            xcross=x + (-va)*(xx-x)/(vb-va)
            if xcross>0:
                crossings += 1 if va<0 else -1
    return crossings,str(chosen)

def verify(data):
    require(isinstance(data,dict) and data.get('schema')=='q15-convex-chart-polygon-v1','schema')
    require(data.get('contour_vertices')==[[str(a),str(b)] for a,b in CORNERS],
            'contour corners differ from frozen geometry')
    chars=data.get('characters')
    require(isinstance(chars,list) and len(chars)==3,'characters count')
    results={}
    for character in chars:
        require(isinstance(character,dict) and set(character)=={'label','charts'}, 'character fields')
        label=character['label']
        require(isinstance(label,str) and label in EXPECTED and label not in results,'duplicate or foreign character')
        charts=character['charts']
        require(isinstance(charts,list) and 4<=len(charts)<=MAX_CHARTS,'chart count')
        boxes=[]
        prior=CORNERS[0]; side=0; used=[0,0,0,0]
        for i,ch in enumerate(charts):
            require(isinstance(ch,dict) and set(ch)=={'side','a','b','image'}, 'chart fields')
            s=ch['side']; require(type(s) is int and s in range(4),'side')
            require(side==s or (s==side+1 and prior==CORNERS[s]),'nonmonotone contour side')
            side=s
            a,b=point(ch['a']),point(ch['b'])
            require(a==prior, 'gap or overlap in contour coverage')
            require(edge_ok(a,b,s),'segment not positive within its side')
            prior=b;used[s]+=1
            boxes.append(box(ch['image']))
        require(all(used) and prior==CORNERS[0] and side==3,'contour not fully traversed once')
        v=[intersection_box(boxes[(j-1)%len(boxes)],boxes[j]) for j in range(len(boxes))]
        require(all(in_box(v[j],boxes[j]) and in_box(v[(j+1)%len(v)],boxes[j])
                    for j in range(len(v))),'polygon edge escapes chart')
        w,ray=ray_winding(v)
        results[label]={'winding':w,'charts':len(boxes),'ray_slope':ray,
                        'enclosure_trust_required':True}
    require(set(results)==set(EXPECTED),'incomplete character set')
    return results

def main():
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument('certificate',type=Path)
    p.add_argument('--expect',action='store_true',help='require the known 12/13/12 counts')
    args=p.parse_args()
    raw=args.certificate.read_bytes()
    require(len(raw) < 40000000,'oversized certificate')
    data=json.loads(raw)
    result=verify(data)
    if args.expect:
        require(all(result[k]['winding']==n for k,n in EXPECTED.items()),'wrong winding counts')
    print(json.dumps({'status':'EXACT_COMBINATORIAL_WINDING_CHECK_PASS',
                      'conditional_on_valid_segment_enclosures':True,
                      'not_independent_function_evaluation':True,
                      'sha256':hashlib.sha256(raw).hexdigest(),
                      'results':result},indent=2,sort_keys=True))

if __name__=='__main__':
    main()
