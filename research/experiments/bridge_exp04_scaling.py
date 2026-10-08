import cmath, json, math, statistics
from collections import defaultdict

P_WINDOWS=[400,800,1600,3200]
X_RATIO=16
LAMBDA_TARGETS=[0.5,1.0,2.0]
KINDS=['plain','inverse']

def W(t):
    if t < 1.0 or t > 2.0:
        return 0.0
    return max(0.0, 1.0 - 2.0*abs(t-1.5))

def mobius_sieve(n):
    mu=[0]*(n+1); mu[1]=1; lp=[0]*(n+1); primes=[]
    for i in range(2,n+1):
        if lp[i]==0:
            lp[i]=i; primes.append(i); mu[i]=-1
        for p in primes:
            if p>lp[i] or i*p>n: break
            lp[i*p]=p
            mu[i*p]=0 if p==lp[i] else -mu[i]
    return mu

def primes_upto(n):
    sieve=bytearray(b'\x01')*(n+1)
    if n>=0: sieve[0]=0
    if n>=1: sieve[1]=0
    for i in range(2,int(n**0.5)+1):
        if sieve[i]:
            sieve[i*i:n+1:i]=b'\x00'*(((n-i*i)//i)+1)
    return [i for i in range(2,n+1) if sieve[i]]

def b_sequence(X,p,kind,mu):
    out=defaultdict(float)
    mlo=max(1,math.floor(X/p)-2); mhi=math.ceil(2*X/p)+2
    for m in range(mlo,mhi+1):
        if math.gcd(m,30)!=1: continue
        cm=1 if kind=='plain' else mu[m]
        if cm==0: continue
        wm=W((p*m)/X)
        if wm==0: continue
        hlo=math.ceil((X-p*m)/30)
        hhi=math.floor((2*X-p*m)/30)
        for h in range(hlo,hhi+1):
            if h==0: continue
            n=p*m+30*h
            if n<1 or n>=len(mu): continue
            cn=1 if kind=='plain' else mu[n]
            if cn==0: continue
            wn=W(n/X)
            if wn==0: continue
            out[h]+=cn*cm*wn*wm
    return dict(out)

def admissible_qs(Q):
    return [q for q in range(2,Q+1) if math.gcd(q,30)==1]

def q_family_energy(b,Q):
    if not b:
        return 0.0,0.0,0.0,0,0
    zero=abs(sum(b.values()))**2
    fam=zero
    count=1
    for q in admissible_qs(Q):
        H=[0j]*q
        for h,v in b.items():
            H[h%q]+=v
        F=[]
        for a in range(q):
            s=0j
            for r,x in enumerate(H):
                if x:
                    s += x*cmath.exp(-2j*math.pi*a*r/q)
            F.append(s)
        for a in range(1,q):
            if math.gcd(a,q)==1:
                fam += abs(F[a])**2
                count += 1
    nonzero=fam-zero
    return fam,nonzero,zero,count,len(b)

def choose_Q(N,lam):
    return max(2,int(math.floor(math.sqrt(lam*N)+0.5)))

def linear_slope(xs,ys):
    mx=sum(xs)/len(xs); my=sum(ys)/len(ys)
    den=sum((x-mx)**2 for x in xs)
    return sum((x-mx)*(y-my) for x,y in zip(xs,ys))/den if den else 0.0

maxX=max(P_WINDOWS)*X_RATIO
maxn=int(2*maxX+2000)
mu=mobius_sieve(maxn)
primes=primes_upto(2*max(P_WINDOWS)+200)
rows=[]

for P in P_WINDOWS:
    X=P*X_RATIO
    ps=[p for p in primes if P<p<=2*P and math.gcd(p,30)==1]
    for kind in KINDS:
        for p in ps:
            b=b_sequence(X,p,kind,mu)
            if not b: continue
            hmin=min(b); hmax=max(b); N=hmax-hmin+1
            energy=sum(v*v for v in b.values())
            if energy<=0: continue
            for lam in LAMBDA_TARGETS:
                Q=choose_Q(N,lam)
                fam,nonzero,zero,count,nnz=q_family_energy(b,Q)
                bound=(N-1+Q*Q)*energy
                rows.append({
                    'P':P,'X':X,'p':p,'kind':kind,'lambda_target':lam,
                    'N':N,'Q':Q,'lambda_actual':Q*Q/N,
                    'energy':energy,'freq_count':count,'nnz_h':nnz,
                    'sat_full':fam/bound,'sat_nonzero':nonzero/bound,
                    'zero_share_family':zero/fam if fam>0 else 0.0,
                })

max_sat=max(r['sat_full'] for r in rows)
if max_sat>1.00000001:
    raise AssertionError(('large sieve bound exceeded',max_sat))

summaries=[]
for kind in KINDS:
  for lam in LAMBDA_TARGETS:
    for P in P_WINDOWS:
      sub=[r for r in rows if r['kind']==kind and r['lambda_target']==lam and r['P']==P]
      summaries.append({
        'kind':kind,'lambda_target':lam,'P':P,'X':P*X_RATIO,'nprimes':len(sub),
        'mean_N':sum(r['N'] for r in sub)/len(sub),
        'mean_Q':sum(r['Q'] for r in sub)/len(sub),
        'mean_lambda_actual':sum(r['lambda_actual'] for r in sub)/len(sub),
        'mean_sat_nonzero':sum(r['sat_nonzero'] for r in sub)/len(sub),
        'median_sat_nonzero':statistics.median(r['sat_nonzero'] for r in sub),
        'mean_sat_full':sum(r['sat_full'] for r in sub)/len(sub),
        'mean_zero_share_family':sum(r['zero_share_family'] for r in sub)/len(sub),
        'max_sat_nonzero':max(r['sat_nonzero'] for r in sub),
      })

slopes=[]
for kind in KINDS:
  for lam in LAMBDA_TARGETS:
    sub=sorted([s for s in summaries if s['kind']==kind and s['lambda_target']==lam],key=lambda x:x['P'])
    x=[math.log(s['mean_N']) for s in sub]
    y_mean=[math.log(s['mean_sat_nonzero']) for s in sub]
    y_med=[math.log(s['median_sat_nonzero']) for s in sub]
    slopes.append({
      'kind':kind,'lambda_target':lam,
      'loglog_slope_mean':linear_slope(x,y_mean),
      'loglog_slope_median':linear_slope(x,y_med),
      'first_mean_sat':sub[0]['mean_sat_nonzero'],
      'last_mean_sat':sub[-1]['mean_sat_nonzero'],
      'scale_ratio_N':sub[-1]['mean_N']/sub[0]['mean_N'],
    })

out={'protocol':{
    'P_WINDOWS':P_WINDOWS,'X_RATIO':X_RATIO,'LAMBDA_TARGETS':LAMBDA_TARGETS,
    'Q_rule':'nearest integer to sqrt(lambda_target*N), minimum 2',
    'window':'tent support [1,2], peak 1 at 1.5',
    'primary_metric':'sat_nonzero',
    'frequency_family':'zero plus all reduced a/q with q<=Q, gcd(q,30)=1',
    'claim_rule':'descriptive scaling only; no exponent claim from finite slopes',
  },'summaries':summaries,'slopes':slopes,'max_observed_sat_full':max_sat}

with open('bridge_exp04_results.json','w') as f:
    json.dump(out,f,indent=2)
print(json.dumps(out,indent=2))
