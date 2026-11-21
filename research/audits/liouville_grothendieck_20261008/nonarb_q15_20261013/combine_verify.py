#!/usr/bin/env python3
"""Pure Fraction checker of completely covered contour images, no Arb or mpmath."""
import argparse, glob, json, hashlib
from pathlib import Path
from fractions import Fraction as Q

L=Q(-1,8);R=Q(9,8);BOT=Q(-1,2)
def corners(top):return [(L,BOT),(R,BOT),(R,top),(L,top),(L,BOT)]
def dyd(t):
    a,e=t
    return Q(int(a))*Q(2)**int(e)
def decode(box):
    if not isinstance(box,dict) or set(box)!={'re','im'}:raise ValueError('invalid image enclosure')
    if any(not isinstance(box[k],list) or len(box[k])!=2 for k in ('re','im')):raise ValueError('invalid image bounds')
    re=[dyd(x) for x in box['re']];im=[dyd(x) for x in box['im']]
    if re[0]>re[1] or im[0]>im[1]:raise ValueError('inverted image bounds')
    return (re,im)
def point(x):return tuple(Q(u) for u in x)
def winding(boxes):
    if not boxes:raise ValueError('no boxes')
    vertices=[]
    for j in range(len(boxes)):
        A=boxes[(j-1)%len(boxes)];B=boxes[j]
        xx=(max(A[0][0],B[0][0]),min(A[0][1],B[0][1]))
        yy=(max(A[1][0],B[1][0]),min(A[1][1],B[1][1]))
        if xx[0]>xx[1] or yy[0]>yy[1]:raise ValueError('images of consecutive arcs do not overlap')
        vertices.append(((xx[0]+xx[1])/2,(yy[0]+yy[1])/2))
    for i in range(200):
        m=Q(i,97)
        if all(y-m*x!=0 for x,y in vertices):break
    else:raise ValueError('no transverse ray')
    w=0
    for (x,y),(xx,yy) in zip(vertices,vertices[1:]+vertices[:1]):
        a=y-m*x; b=yy-m*xx
        if (a<0<b) or (b<0<a):
            crossing=x-a*(xx-x)/(b-a)
            if crossing>0:w+=1 if a<0 else -1
    return w,len(vertices)
def verify(files,b,top):
    C=corners(top)
    records=[]
    for name in files:
        d=json.loads(Path(name).read_text())
        if d['character_b']!=b or Q(d['top'])!=top:raise ValueError('wrong character or top '+name)
        records.append(d)
    records.sort(key=lambda d:(d['side'],d['start']))
    boxes=[];segments=[]
    for side in range(4):
        chunks=[d for d in records if d['side']==side]
        if not chunks:raise ValueError('missing side '+str(side))
        begin=0
        prev=C[side]
        last=C[side+1]
        for chunk in chunks:
            if chunk['start']!=begin:raise ValueError('missing batch '+str(side))
            begin=chunk['end']
            for chart in chunk['segments']:
                a,c=point(chart['a']),point(chart['b'])
                if int(chart['side'])!=side or a!=prev:raise ValueError('gap, overlap or wrong side')
                # Directed single-side boundary segment with fixed coordinate.
                if side==0 and not(a[1]==c[1]==C[side][1] and a[0]<c[0]):raise ValueError('wrong bottom')
                if side==1 and not(a[0]==c[0]==C[side][0] and a[1]<c[1]):raise ValueError('wrong right')
                if side==2 and not(a[1]==c[1]==C[side][1] and a[0]>c[0]):raise ValueError('wrong top')
                if side==3 and not(a[0]==c[0]==C[side][0] and a[1]>c[1]):raise ValueError('wrong left')
                prev=c
                bbox=decode(chart['image'])
                if all(z[0]<=0<=z[1] for z in bbox):raise ValueError('zero lies in a chart box')
                boxes.append(bbox);segments.append(chart)
        if prev!=last:raise ValueError('side end mismatch')
    val,n=winding(boxes)
    return {'character':b,'contour_top':str(top),'winding':val,'charts':n,'batches':len(records),'conditional_on_valid_source_enclosures':True}

if __name__=='__main__':
    ap=argparse.ArgumentParser();ap.add_argument('--b',type=int,required=True);ap.add_argument('--top',type=str,required=True);ap.add_argument('files',nargs='+');a=ap.parse_args()
    print(json.dumps(verify(a.files,a.b,Q(a.top)),indent=2))
