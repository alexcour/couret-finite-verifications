#!/usr/bin/env python3
"""Emit entire-segment interval enclosures for a separate rational verifier."""
import argparse,json
from fractions import Fraction as Q
import flint
from flint import ctx
from certify_q15_root_intervals import CONTOUR,ROWS,CompletedL,primitive_character,segment_box
from verify_q15_contour_polygon import verify,EXPECTED
def enc(x):
 m,e=x.man_exp()
 return [str(m),int(e)]
def main():
 p=argparse.ArgumentParser()
 p.add_argument('--output',required=True)
 a=p.parse_args()
 assert flint.__version__=='0.9.0' and flint.__FLINT_VERSION__=='3.6.0'
 ctx.prec=256
 d={'schema':'q15-convex-chart-polygon-v1',
    'contour_vertices':[[str(x),str(y)] for x,y in CONTOUR], 'characters':[]}
 for number,b,expected in ROWS.values():
  fun=CompletedL(primitive_character(number,b))
  charts=[]
  def subdiv(side,a,c,depth):
   v=fun(segment_box(a,c))
   if v.is_finite() and (v.real>0 or v.real<0 or v.imag>0 or v.imag<0):
    charts.append({'side':side,'a':list(map(str,a)),'b':list(map(str,c)),
      'image':{'re':[enc(v.real.lower()),enc(v.real.upper())],
               'im':[enc(v.imag.lower()),enc(v.imag.upper())]}})
    return
   if depth>=16:raise ValueError('unresolved segment at depth 16')
   m=tuple((x+y)/2 for x,y in zip(a,c))
   subdiv(side,a,m,depth+1)
   subdiv(side,m,c,depth+1)
  for side,(start,end) in enumerate(zip(CONTOUR,CONTOUR[1:])):
   n=max(1,(max(abs(end[j]-start[j]) for j in range(2))*8).__ceil__())
   for i in range(n):
    x=tuple(start[j]+(end[j]-start[j])*Q(i,n) for j in range(2))
    y=tuple(start[j]+(end[j]-start[j])*Q(i+1,n) for j in range(2))
    subdiv(side,x,y,0)
  d['characters'].append({'label':'15.'+str(number),'charts':charts})
  print('charts for',number,len(charts),flush=True)
 results=verify(d)
 if not all(results[k]['winding']==v for k,v in EXPECTED.items()):
  raise ValueError('incorrect independently computed polygon winding')
 with open(a.output,'w') as f: json.dump(d,f,separators=(',',':'))
 print('EXACT POLYGON CHECK PASSED',results,flush=True)
if __name__=='__main__':main()
