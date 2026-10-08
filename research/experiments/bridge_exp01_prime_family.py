import math, json, csv
from itertools import combinations
from statistics import mean

RES=[1,7,11,13,17,19,23,29]
RIDX={r:i for i,r in enumerate(RES)}
P_WINDOWS=[500,1000,2000,4000]
X_RATIOS=[32,64,128]

# Pre-specified tent window: support [1,2], peak 1 at 3/2.
def W(t):
    if t < 1.0 or t > 2.0:
        return 0.0
    return max(0.0, 1.0 - 2.0*abs(t-1.5))

def mobius_sieve(n):
    mu=[1]*(n+1)
    isprime=[True]*(n+1)
    isprime[0]=isprime[1]=False
    primes=[]
    mu=[0]*(n+1); mu[1]=1
    lp=[0]*(n+1)
    for i in range(2,n+1):
        if lp[i]==0:
            lp[i]=i; primes.append(i); mu[i]=-1
        for p in primes:
            if p>lp[i] or i*p>n: break
            lp[i*p]=p
            if p==lp[i]:
                mu[i*p]=0
            else:
                mu[i*p]=-mu[i]
    return mu

def primes_upto(n):
    sieve=bytearray(b'\x01')*(n+1)
    if n>=0: sieve[0]=0
    if n>=1: sieve[1]=0
    for i in range(2,int(n**0.5)+1):
        if sieve[i]:
            sieve[i*i:n+1:i]=b'\x00'*(((n-i*i)//i)+1)
    return [i for i in range(2,n+1) if sieve[i]]

def chi3_res(r):
    return 1 if r%3==1 else -1

def chi5_res(r):
    return 1 if r%5 in (1,4) else -1

def chi15_res(r):
    return chi3_res(r)*chi5_res(r)

QUADS={"chi3":chi3_res,"chi5":chi5_res,"chi15":chi15_res}

# 35 balanced 4/4 partitions up to complement: canonical + set contains residue 1.
BAL=[]
for plus in combinations(RES,4):
    if 1 not in plus: continue
    plus=set(plus)
    label={r:(1 if r in plus else -1) for r in RES}
    BAL.append((tuple(sorted(plus)),label))
assert len(BAL)==35

def covariance(xs,ys):
    mx=sum(xs)/len(xs); my=sum(ys)/len(ys)
    return sum((x-mx)*(y-my) for x,y in zip(xs,ys))/len(xs)

def arrays_for_scale(X, coeff, maxn):
    A=[0.0]*8
    lo=max(1, math.floor(X)-2)
    hi=min(maxn, math.ceil(2*X)+2)
    for n in range(lo,hi+1):
        r=n%30
        if r not in RIDX: continue
        wt=W(n/X)
        if wt:
            A[RIDX[r]] += coeff[n]*wt
    return A

def calc_for_kind(kind, X, p, A_X, coeff, maxn):
    xp=X/p
    A_p=arrays_for_scale(xp, coeff, maxn)
    a=p%30
    C=0.0
    for r in RES:
        ar=(a*r)%30
        C += A_X[RIDX[ar]] * A_p[RIDX[r]]
    # exact structural diagonal n=pm with the same smooth weight on both slots
    L=0.0
    lo=max(1, math.floor(xp)-2)
    hi=min(maxn//p if p else 0, math.ceil(2*xp)+2)
    for m in range(lo,hi+1):
        if m%30 not in RIDX: continue
        wt=W((p*m)/X)
        if not wt: continue
        L += coeff[p*m]*coeff[m]*wt*wt
    R=C-L
    EX=sum(v*v for v in A_X)
    Ep=sum(v*v for v in A_p)
    denE=math.sqrt(EX*Ep)
    zE=R/denE if denE>0 else 0.0
    # T51 baseline with A=1,B=2,M=1,W_inf=1
    denC=((X/p)+1.0)*((X/30.0)+1.0)
    zC=R/denC
    return {"p":p,"res":a,"C":C,"L":L,"R":R,"E":EX,"Ep":Ep,"zE":zE,"zC":zC}

maxX=max(P_WINDOWS)*max(X_RATIOS)
MAXN=int(math.ceil(2*maxX))+100
mu=mobius_sieve(MAXN)
coeff_plain=[0]*(MAXN+1)
coeff_inv=[0]*(MAXN+1)
for n in range(1,MAXN+1):
    if math.gcd(n,30)==1:
        coeff_plain[n]=1
        coeff_inv[n]=mu[n]

primes=primes_upto(2*max(P_WINDOWS)+100)
rows=[]; summaries=[]
for P in P_WINDOWS:
    ps=[p for p in primes if P < p <= 2*P and math.gcd(p,30)==1]
    for ratio in X_RATIOS:
        X=P*ratio
        for kind,coeff in [("plain",coeff_plain),("inverse",coeff_inv)]:
            A_X=arrays_for_scale(X, coeff, MAXN)
            rr=[calc_for_kind(kind,X,p,A_X,coeff,MAXN) for p in ps]
            for r in rr:
                row={"P":P,"ratio":ratio,"X":X,"kind":kind,**r}
                rows.append(row)
            for metric in ["zE","zC"]:
                zs=[r[metric] for r in rr]
                rec={"P":P,"ratio":ratio,"X":X,"kind":kind,"metric":metric,"nprimes":len(ps),"mean":sum(zs)/len(zs)}
                for name,fn in QUADS.items():
                    labs=[fn(r["res"]) for r in rr]
                    rec[f"cov_{name}"]=covariance(zs,labs)
                    plus=[z for z,l in zip(zs,labs) if l==1]
                    minus=[z for z,l in zip(zs,labs) if l==-1]
                    rec[f"diff_{name}"]=(sum(plus)/len(plus)-sum(minus)/len(minus))
                    rec[f"nplus_{name}"]=len(plus); rec[f"nminus_{name}"]=len(minus)
                covs=[]
                for plus,label in BAL:
                    labs=[label[r["res"]] for r in rr]
                    cv=covariance(zs,labs)
                    covs.append((abs(cv),cv,plus))
                covs.sort(reverse=True,key=lambda x:x[0])
                chi5_abs=abs(rec["cov_chi5"])
                rank=1+sum(1 for v,_,_ in covs if v>chi5_abs+1e-15)
                rec["chi5_rank35"]=rank
                rec["max_bal_abs_cov"]=covs[0][0]
                rec["max_bal_plus"]=' '.join(map(str,covs[0][2]))
                rec["chi5_to_max_abs_ratio"]=(chi5_abs/covs[0][0] if covs[0][0]>0 else 0.0)
                summaries.append(rec)

aggregates=[]
for kind in ["plain","inverse"]:
  for metric in ["zE","zC"]:
    sub=[r for r in summaries if r['kind']==kind and r['metric']==metric]
    agg={"kind":kind,"metric":metric,"nregimes":len(sub)}
    for name in QUADS:
        vals=[r[f"cov_{name}"] for r in sub]
        agg[f"mean_cov_{name}"]=sum(vals)/len(vals)
        agg[f"mean_abs_cov_{name}"]=sum(abs(v) for v in vals)/len(vals)
        agg[f"positive_{name}"]=sum(v>0 for v in vals)
        agg[f"negative_{name}"]=sum(v<0 for v in vals)
    agg["chi5_mean_rank35"]=sum(r["chi5_rank35"] for r in sub)/len(sub)
    agg["chi5_top5_count"]=sum(r["chi5_rank35"]<=5 for r in sub)
    aggregates.append(agg)

out={"manifest":{
    "P_windows":P_WINDOWS,"X_ratios":X_RATIOS,
    "window":"tent support [1,2], peak 1 at 1.5",
    "primary_metric":"zE=R/sqrt(E(X)E(X/p))",
    "secondary_metric":"zC=R/(((X/p)+1)*((X/30)+1))",
    "prime_condition":"P<p<=2P, p coprime to 30",
    "controls":"chi3, chi5, chi15, plus exhaustive 35 balanced 4/4 residue partitions up to complement",
    "diagonal":"L_p removed exactly before all contrasts"
},"summaries":summaries,"aggregates":aggregates}
with open('bridge_exp01_results.json','w') as f: json.dump(out,f,indent=2)
with open('bridge_exp01_summary.csv','w',newline='') as f:
    w=csv.DictWriter(f,fieldnames=list(summaries[0].keys())); w.writeheader(); w.writerows(summaries)
print(json.dumps(out['manifest'],indent=2))
print('AGGREGATES')
print(json.dumps(aggregates,indent=2))
