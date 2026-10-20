#!/usr/bin/env python3
# Independent bit-packed polynomial square and literal dihedral-action test
from itertools import combinations
from collections import defaultdict
from math import comb
def sig(S,n):
 p=sum(1<<(8*x) for x in S)
 v=p*p
 return tuple(((v>>(8*i))&255)+((v>>(8*(i+n)))&255) for i in range(n))
def related(S,T,n,reflect):
 U=set(T)
 for sign in ((1,-1) if reflect else (1,)):
  for a in range(n):
   if {((sign*x+a)%n) for x in S}==U:return True
 return False
def scan(n):
 d=defaultdict(list)
 for S in combinations(range(1,n),3):d[sig(S,n)].append(S)
 total=notrans=nodih=0
 for v in d.values():
  total+=len(v)*(len(v)-1)//2
  for S,T in combinations(v,2):
   if not related(S,T,n,False):notrans+=1
   if not related(S,T,n,True):nodih+=1
 return total,notrans,nodih
if __name__=="__main__":
 import json
 rows=[]
 for n in range(5,61):
  a,b,c=scan(n)
  assert b==(2*n-11 if n%6==0 else 0) and c==0
  rows.append({"n":n,"collision_pairs":a,"nontranslation":b,"nondihedral":c})
 assert sum(r["collision_pairs"] for r in rows)==118290
 print(json.dumps({"independent":True,"by_n":rows},indent=2))
