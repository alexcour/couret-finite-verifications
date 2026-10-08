import math, json
import numpy as np

RES=[1,7,11,13,17,19,23,29]
P_WINDOWS=[100,200,400]
X_RATIOS=[8,16]
Q_LIST=[7,11,13,17]

def W(t):
    if t < 1.0 or t > 2.0: return 0.0
    return max(0.0,1.0-2.0*abs(t-1.5))

def mobius_sieve(n):
    mu=[0]*(n+1); mu[1]=1; lp=[0]*(n+1); primes=[]
    for i in range(2,n+1):
        if lp[i]==0: lp[i]=i; primes.append(i); mu[i]=-1
        for p in primes:
            if p>lp[i] or i*p>n: break
            lp[i*p]=p
            mu[i*p]=0 if p==lp[i] else -mu[i]
    return mu

def primes_upto(n):
    s=bytearray(b'\\x01')*(n+1); s[0:2]=b'\\x00\\x00'
    for i in range(2,int(n**0.5)+1):
        if s[i]: s[i*i:n+1:i]=b'\\x00'*(((n-i*i)//i)+1)
    return [i for i in range(2,n+1) if s[i]]

def chi5(p): return 1 if p%5 in (1,4) else -1

def b_sequence(X,p,kind,mu):
    out={}
    mlo=max(1,math.floor(X/p)-2); mhi=math.ceil(2*X/p)+2
    for m in range(mlo,mhi+1):
        if math.gcd(m,30)!=1: continue
        cm = 1 if kind=='plain' else mu[m]
        if cm==0: continue
        wm=W((p*m)/X)
        if wm==0: continue
        hlo=math.ceil((X-p*m)/30)
        hhi=math.floor((2*X-p*m)/30)
        for h in range(hlo,hhi+1):
            if h==0: continue
            n=p*m+30*h
            if n<1 or n>=len(mu): continue
            cn = 1 if kind=='plain' else mu[n]
            if cn==0: continue
            wn=W(n/X)
            if wn==0: continue
            out[h]=out.get(h,0.0)+cn*cm*wn*wm
    return out

def spec_metrics(b,q):
    H=np.zeros(q,dtype=np.complex128)
    for h,v in b.items(): H[h%q]+=v
    F=np.fft.fft(H)
    power=np.abs(F)**2
    total=power.sum()
    if total==0: return {'packet_energy':0.0,'freq_total':0.0,'zero_share':0.0,'max_nonzero_share':0.0,'entropy':0.0}
    shares=power/total
    nz=shares[1:] if q>1 else np.array([0.0])
    entropy=float(-(shares[shares>0]*np.log(shares[shares>0])).sum()/math.log(q)) if q>1 else 0.0
    return {'packet_energy':float(np.sum(np.abs(H)**2)),'freq_total':float(total),'zero_share':float(shares[0]),'max_nonzero_share':float(np.max(nz)),'entropy':entropy}

maxX=max(P_WINDOWS)*max(X_RATIOS)
maxn=int(2*maxX+1000)
mu=mobius_sieve(maxn)
primes=primes_upto(2*max(P_WINDOWS)+100)
rows=[]
for P in P_WINDOWS:
  ps=[p for p in primes if P<p<=2*P and math.gcd(p,30)==1]
  for ratio in X_RATIOS:
    X=P*ratio
    for kind in ['plain','inverse']:
      for p in ps:
        b=b_sequence(X,p,kind,mu)
        base=sum(v*v for v in b.values())
        for q in Q_LIST:
          met=spec_metrics(b,q)
          rows.append({'P':P,'ratio':ratio,'X':X,'kind':kind,'p':p,'gate':chi5(p),'q':q,'h_energy':base,**met})

summary=[]
for kind in ['plain','inverse']:
  for q in Q_LIST:
    sub=[r for r in rows if r['kind']==kind and r['q']==q]
    for metric in ['max_nonzero_share','zero_share','entropy']:
      plus=[r[metric] for r in sub if r['gate']==1]
      minus=[r[metric] for r in sub if r['gate']==-1]
      summary.append({'kind':kind,'q':q,'metric':metric,'nplus':len(plus),'nminus':len(minus),'mean_plus':sum(plus)/len(plus),'mean_minus':sum(minus)/len(minus),'diff':sum(plus)/len(plus)-sum(minus)/len(minus)})

agg={}
for kind in ['plain','inverse']:
  sub=[s for s in summary if s['kind']==kind and s['metric']=='max_nonzero_share']
  agg[kind]={
    'mean_abs_gate_diff_max_nonzero_share':sum(abs(s['diff']) for s in sub)/len(sub),
    'mean_signed_gate_diff_max_nonzero_share':sum(s['diff'] for s in sub)/len(sub),
    'positive_q_count':sum(s['diff']>0 for s in sub),
    'negative_q_count':sum(s['diff']<0 for s in sub),
  }
print(json.dumps({'protocol':{'P_WINDOWS':P_WINDOWS,'X_RATIOS':X_RATIOS,'Q_LIST':Q_LIST,'window':'tent[1,2]','metrics':['max_nonzero_share','zero_share','entropy']},'agg':agg,'summary':summary},indent=2))
