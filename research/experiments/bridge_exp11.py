import math,csv,json,hashlib,statistics
from collections import defaultdict,Counter
from pathlib import Path
OUT=Path(__file__).parent
PS=[100,200,400,800];RS=[8,16,32]; U={1,7,11,13,17,19,23,29}
def sieve(n):
 mu=[0]*(n+1);mu[1]=1;lp=[0]*(n+1);pr=[]
 for x in range(2,n+1):
  if not lp[x]:lp[x]=x;pr.append(x);mu[x]=-1
  for p in pr:
   if p>lp[x] or x*p>n:break
   lp[x*p]=p;mu[x*p]=0 if p==lp[x] else -mu[x]
 return mu,lp,pr
def w(v,X):return 2*min(v-X,2*X-v) if X<v<2*X else 0
def factor(n,lp):
 a=[]
 while n>1:
  p=lp[n];a.append(p);n//=p
 return a
def radpar(a,b,lp):
 return (a*b)//(math.gcd(a,b)**2)
def phi(n):return sum(math.gcd(k,n)==1 for k in range(1,n+1))
def choose(N):return min((q for q in range(7,int(math.sqrt(N))+9) if math.gcd(q,30)==1),key=lambda q:(abs(q-math.sqrt(N)),q))
def mu_num(n):
 z=0;p=2
 while p*p<=n:
  if n%p==0:
   n//=p;z+=1
   if n%p==0:return 0
  p+=1
 if n>1:z+=1
 return (-1)**z
def K(Q,d):return sum(sum(r*mu_num(q//r) for r in range(1,q+1) if q%r==0 and d%r==0) for q in range(2,Q+1) if math.gcd(q,30)==1)
def pairs(p,X,mu,lp):
 labels=defaultdict(lambda:defaultdict(int));true=defaultdict(int);plain=set();cnt=0
 for m in range(max(1,X//p-2),2*X//p+3):
  if m%30 not in U or not w(p*m,X):continue
  n0=X+1+(p*m-(X+1))%30
  for n in range(n0,2*X,30):
   if n==p*m:continue
   h=(n-p*m)//30;weight=w(n,X)*w(p*m,X);plain.add(h)
   if mu[m] and mu[n]:
    t=radpar(n,m,lp);labels[t][h]+=weight;true[h]+=mu[m]*mu[n]*weight;cnt+=1
 return labels,true,plain,cnt

def calc(p,X,mu,lp):
 labels,b,plain,cnt=pairs(p,X,mu,lp);N=max(plain)-min(plain)+1;Q=choose(N);M=sum(phi(q) for q in range(2,Q+1) if math.gcd(q,30)==1)
 ks={d:K(Q,d) for d in range(N)}
 assert ks[0]==M
 Ebar=0;Nbar=0;reuse=0;cov_off=0
 for t,hm in labels.items():
  hlist=list(hm.items())
  if len(hlist)>1:reuse+=1
  for i,(h,v) in enumerate(hlist):
   Ebar+=v*v;Nbar+=M*v*v
   for k,u in hlist[:i]:
    z=2*v*u*ks[abs(k-h)];Nbar+=z;cov_off+=z
 Etrue=sum(v*v for v in b.values());Ntrue=M*Etrue
 hl=list(b.items())
 for i,(h,v) in enumerate(hl):
  for k,u in hl[:i]:Ntrue+=2*v*u*ks[abs(h-k)]
 assert Ntrue>=0 and Ebar>0 and Etrue>0
 # exact identity between mu(n)mu(m) and mu(rad(nm))
 for t,hm in labels.items():pass
 rho=Nbar/(M*Ebar);D=Ntrue/(M*Etrue)
 return dict(P=pwindow(p),p=p,X=X,ratio=X//pwindow(p),Q=Q,M=M,N=N,pairs=cnt,labels=len(labels),reused_labels=reuse,Ebar=Ebar,Nbar=Nbar,offshift=cov_off,rho=rho,Etrue=Etrue,Ntrue=Ntrue,Dtrue=D)
def pwindow(p):return next(P for P in PS if P<p<=2*P)
def tests(mu,lp):
 for n in range(1,301):assert mu[n]==mu_num(n)
 for n in range(1,31):
  for m in range(1,31):
   if mu[n]*mu[m]:
    t=radpar(n,m,lp);assert mu_num(t)!=0 and mu[n]*mu[m]==mu[t]
 for Q in [7,11,13,17]:
  for d in range(-12,13):
   import cmath
   exact=K(Q,d);trig=sum(cmath.exp(-2j*math.pi*a*d/q) for q in range(2,Q+1) if math.gcd(q,30)==1 for a in range(1,q) if math.gcd(a,q)==1)
   assert abs(exact-trig)<1e-9
 # synthetic exact enumeration over all signs, compare moments for repeated labels and distinct labels
 from itertools import product
 scenarios=[[(0,1,2),(1,1,3),(2,2,5)],[(0,1,2),(1,2,3)],[(0,1,1),(1,1,1),(2,1,4)],[(0,1,2),(0,2,2),(1,2,3)],[(0,1,4),(0,2,3),(1,1,5),(2,2,2)],[(0,1,1)],[(0,1,1),(1,1,1)],[(0,1,2),(2,2,1),(1,2,1)]]
 for edges in scenarios:
  labs=sorted(set(t for _,t,_ in edges));Q=7;M=6;Ebar=sum(sum(w for h2,t2,w in edges if h2==h and t2==t)**2 for h,t,_ in edges if sum(1 for h2,t2,_ in edges if h2==h and t2==t)==1)
  z=defaultdict(lambda:defaultdict(int))
  for h,t,wgt in edges:z[t][h]+=wgt
  expectE=sum(v*v for hm in z.values() for v in hm.values());expectN=sum(v*u*K(Q,h-k) for hm in z.values() for h,v in hm.items() for k,u in hm.items())
  energies=[];powers=[]
  for ss in product([-1,1],repeat=len(labs)):
   emap=dict(zip(labs,ss));b=defaultdict(int)
   for t,hm in z.items():
    for h,v in hm.items():b[h]+=emap[t]*v
   energies.append(sum(v*v for v in b.values()))
   powers.append(sum(v*u*K(Q,h-k) for h,v in b.items() for k,u in b.items()))
  assert sum(energies)==expectE*len(energies) and sum(powers)==expectN*len(powers)
 return {'mobius_naive':300,'ramanujan_fourier':100,'synthetic_exact_sign_enumerations':len(scenarios)}
def main():
 mu,lp,pr=sieve(2*max(PS)*max(RS)+50);checks=tests(mu,lp);rows=[]
 for P in PS:
  for ratio in RS:
   for p in pr:
    if P<p<=2*P and p%30 in U:rows.append(calc(p,P*ratio,mu,lp))
 sm=[]
 for P in PS:
  for ratio in RS:
   v=[r for r in rows if r['P']==P and r['ratio']==ratio]
   sm.append(dict(P=P,ratio=ratio,primes=len(v),mean_rho=statistics.mean(x['rho'] for x in v),mean_Dtrue=statistics.mean(x['Dtrue'] for x in v),mean_abs_rho_minus_1=statistics.mean(abs(x['rho']-1) for x in v),fraction_rho_not_1=sum(x['offshift']!=0 for x in v)/len(v),mean_label_reuse_fraction=statistics.mean(x['reused_labels']/x['labels'] for x in v),mean_D_minus_rho=statistics.mean(x['Dtrue']-x['rho'] for x in v),min_rho=min(x['rho'] for x in v),max_rho=max(x['rho'] for x in v)))
 ext=[x for x in sm if x['ratio']==32]
 sg=[1 if x['mean_rho']>1 else -1 for x in ext]
 gate1=all(abs(x['mean_rho']-1)>=.05 for x in ext) and len(set(sg))==1
 sg2=[1 if x['mean_D_minus_rho']>0 else -1 for x in ext]
 gate2=all(abs(x['mean_D_minus_rho'])>=.10 for x in ext) and len(set(sg2))==1
 for fn,data in [('EXP11_prime_rows.csv',rows),('EXP11_regimes.csv',sm)]:
  with (OUT/fn).open('w',newline='') as f:
   wr=csv.DictWriter(f,fieldnames=list(data[0]));wr.writeheader();wr.writerows(data)
 report={'protocol_commit':'94fda41a106a07420bc7cbe453939a7020012686','checks':checks,'total_cells':len(rows),'screen_structural':'STRONG_STRUCTURAL_SHIFT' if gate1 else 'NO_STRONG_STRUCTURAL_SHIFT','screen_residual':'ROBUST_DETERMINISTIC_RESIDUAL' if gate2 else 'NO_ROBUST_DETERMINISTIC_RESIDUAL','extension':ext,'regimes':sm}
 (OUT/'EXP11_results.json').write_text(json.dumps(report,indent=2)+'\n')
 print('TESTS',checks);print('ROWS',len(rows),'STRUCT',report['screen_structural'],'RESID',report['screen_residual'])
 for s in sm:print('REGIME',json.dumps(s))
 for fn in ['bridge_exp11.py','EXP11_prime_rows.csv','EXP11_regimes.csv','EXP11_results.json']:print('SHA256',fn,hashlib.sha256((OUT/fn).read_bytes()).hexdigest())
if __name__=='__main__':main()
