#!/usr/bin/env python3
"""Produce contour image charts with independent interval Euler-Maclaurin evaluations."""
import argparse, json, math, time
from fractions import Fraction as Q
from pathlib import Path
from independent_hurwitz import TaylorEvaluator,box

L=Q(-1,8);R=Q(9,8);BOT=Q(-1,2)
def corners(top):return [(L,BOT),(R,BOT),(R,top),(L,top),(L,BOT)]

def dyad(v):
    sign,man,e,nbits=v
    return [str(-man if sign else man),e]
def toq(v):
    sign,man,e,nbits=v
    return Q(-man if sign else man)*Q(2)**e

def nonzero(z):
    re=list(map(toq,z.real._mpi_));im=list(map(toq,z.imag._mpi_))
    return re[0]>0 or re[1]<0 or im[0]>0 or im[1]<0

def calc_part(b,top,side,start,end,dps=40,max_depth=14):
    E=TaylorEvaluator(dps=dps)
    C=corners(top)
    a,c=C[side],C[side+1]
    n=math.ceil(max(abs(c[i]-a[i]) for i in range(2))*4)
    if end<0:end=n
    if not (0<=start<end<=n):raise ValueError('invalid slice')
    charts=[];tried=0;fallbacks=0
    def process(a,c,d=0):
        nonlocal tried,fallbacks
        tried+=1
        s=box(min(a[0],c[0]),max(a[0],c[0]),min(a[1],c[1]),max(a[1],c[1]))
        v=E.evaluate(s,b)
        if not nonzero(v):
            fallbacks+=1
            m=tuple((a[i]+c[i])/2 for i in range(2))
            at=box(m[0],m[0],m[1],m[1])
            v=E.tight(at,s,b)
        if nonzero(v):
            charts.append({'side':side,'a':[str(x) for x in a],'b':[str(x) for x in c],
                'image':{'re':[dyad(q) for q in v.real._mpi_],
                         'im':[dyad(q) for q in v.imag._mpi_]}})
            return
        if d>=max_depth:raise RuntimeError(f'unresolved chart b{b}, side{side}, from {a} to {c}, depth{d}')
        m=tuple((a[i]+c[i])/2 for i in range(2))
        process(a,m,d+1);process(m,c,d+1)
    t=time.monotonic()
    for k in range(start,end):
        aa=tuple(a[j]+(c[j]-a[j])*Q(k,n) for j in range(2))
        cc=tuple(a[j]+(c[j]-a[j])*Q(k+1,n) for j in range(2))
        process(aa,cc)
    result={'character_b':b,'top':str(top),'side':side,'start':start,'end':end,
            'segments':charts,'evaluations':tried,'taylor_fallbacks':fallbacks,
            'dps':dps,'method':'mpmath.iv-EulerMaclaurin-N20-P28-M50'}
    print(f'PART b={b} top={top} side={side} [{start},{end}) charts={len(charts)} attempts={tried} fallbacks={fallbacks} duration={time.monotonic()-t:.1f}s',flush=True)
    return result

def main():
    p=argparse.ArgumentParser();p.add_argument('--b',type=int,required=True,choices=[1,2,3]);p.add_argument('--top',type=str,required=True);p.add_argument('--side',type=int,required=True,choices=range(4));p.add_argument('--start',type=int,default=0);p.add_argument('--end',type=int,default=-1);p.add_argument('--dps',type=int,default=40);p.add_argument('--out',required=True)
    a=p.parse_args()
    result=calc_part(a.b,Q(a.top),a.side,a.start,a.end,a.dps)
    Path(a.out).write_text(json.dumps(result,separators=(',',':')))
if __name__=='__main__':main()
