#!/usr/bin/env python3
from itertools import combinations
from collections import Counter, defaultdict
from math import comb
def sig(S,n):
 c=Counter((a+b)%n for a in S for b in S)
 return tuple(sorted(c.items()))
def key(S,n,reflect=False):
 return min(tuple(sorted(((sign*x-t)%n for x in S))) for sign in ((1,-1) if reflect else (1,)) for t in range(n))
def scan(n):
 d=defaultdict(list)
 for S in combinations(range(1,n),3): d[sig(S,n)].append((S,key(S,n),key(S,n,True)))
 collisions=nontrans=nondihedral=0
 for v in d.values():
  collisions+=len(v)*(len(v)-1)//2
  for a,b in combinations(v,2):
   if a[1]!=b[1]:nontrans+=1
   if a[2]!=b[2]:nondihedral+=1
 return {"n":n,"supports":comb(n-1,3),"collisions":collisions,"nontranslation":nontrans,"nondihedral":nondihedral}
if __name__=="__main__":
 import json
 rows=[scan(n) for n in range(5,61)]
 assert sum(x["supports"] for x in rows)==487634
 assert sum(x["collisions"] for x in rows)==118290
 assert sum(x["nontranslation"] for x in rows)==550
 assert all(x["nondihedral"]==0 and x["nontranslation"]==(2*x["n"]-11 if x["n"]%6==0 else 0) for x in rows)
 print(json.dumps({"totals":{k:sum(r[k] for r in rows) for k in ("supports","collisions","nontranslation","nondihedral")},"by_n":rows},indent=2))
