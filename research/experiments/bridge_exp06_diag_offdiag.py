import cmath, csv, hashlib, json, math
from collections import defaultdict

P_WINDOWS=[100,200,400]
RATIOS=[8,16]
QS=[7,11,13,17]
KINDS=['plain','inverse']
RES=[1,7,11,13,17,19,23,29]

def W(t):
    if t<1.0 or t>2.0: return 0.0
    return max(0.0,1.0-2.0*abs(t-1.5))

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
    sieve=bytearray(b'\x01')*(n+1); sieve[0:2]=b'\x00\x00'
    for i in range(2,int(n**0.5)+1):
        if sieve[i]: sieve[i*i:n+1:i]=b'\x00'*(((n-i*i)//i)+1)
    return [i for i in range(2,n+1) if sieve[i]]

def coeff(n,kind,mu):
    if n<1 or math.gcd(n,30)!=1: return 0
    return 1 if kind=='plain' else mu[n]

def b_sequence_full(X,p,kind,mu):
    out=defaultdict(float)
    mlo=max(1,math.floor(X/p)-2); mhi=math.ceil(2*X/p)+2
    for m in range(mlo,mhi+1):
        cm=coeff(m,kind,mu)
        if cm==0: continue
        wm=W(p*m/X)
        if wm==0: continue
        hlo=math.ceil((X-p*m)/30); hhi=math.floor((2*X-p*m)/30)
        for h in range(hlo,hhi+1):
            n=p*m+30*h
            if n<1 or n>=len(mu): continue
            cn=coeff(n,kind,mu)
            if cn==0: continue
            wn=W(n/X)
            if wn: out[h]+=cn*cm*wn*wm
    return dict(out)

def packet_fft(b,q):
    H=[0j]*q
    for h,v in b.items(): H[h%q]+=v
    F=[sum(H[r]*cmath.exp(-2j*math.pi*j*r/q) for r in range(q)) for j in range(q)]
    lhs=sum(abs(z)**2 for z in F); rhs=q*sum(abs(x)**2 for x in H)
    rel=abs(lhs-rhs)/max(1.0,abs(rhs))
    if rel>1e-10: raise AssertionError(('parseval',q,rel))
    return H,F

def m1_and_zero(F):
    allE=sum(abs(z)**2 for z in F)
    if allE<=0: return 0.0,0.0
    nz=[abs(F[j])**2 for j in range(1,len(F))]
    return (max(nz)/allE if nz else 0.0, abs(F[0])**2/allE)

def chi3(p): return 1 if p%3==1 else -1
def chi5(p): return 1 if p%5 in (1,4) else -1
def chi15(p): return chi3(p)*chi5(p)

def residue_sums(X,p,kind,mu,q=None,j=None):
    if q is None:
        A={a:0.0 for a in RES}; B={a:0.0 for a in RES}
        nhi=min(len(mu)-1,math.floor(2*X)+2)
        for n in range(1,nhi+1):
            c=coeff(n,kind,mu); w=W(n/X)
            if c and w: A[n%30]+=c*w
        mhi=min(len(mu)-1,math.ceil(2*X/p)+2)
        for m in range(1,mhi+1):
            c=coeff(m,kind,mu); w=W(p*m/X)
            if c and w: B[m%30]+=c*w
        return sum(A[(p*a)%30]*B[a] for a in RES)
    u=pow(30,-1,q)
    A={a:0j for a in RES}; B={a:0j for a in RES}
    nhi=min(len(mu)-1,math.floor(2*X)+2)
    for n in range(1,nhi+1):
        c=coeff(n,kind,mu); w=W(n/X)
        if c and w:
            A[n%30]+=c*w*cmath.exp(-2j*math.pi*j*u*n/q)
    mhi=min(len(mu)-1,math.ceil(2*X/p)+2)
    for m in range(1,mhi+1):
        c=coeff(m,kind,mu); w=W(p*m/X)
        if c and w:
            B[m%30]+=c*w*cmath.exp(+2j*math.pi*j*u*p*m/q)
    return sum(A[(p*a)%30]*B[a] for a in RES)

def mean(xs): return sum(xs)/len(xs) if xs else None

maxX=max(P_WINDOWS)*max(RATIOS); maxn=int(2*maxX+2000)
mu=mobius_sieve(maxn); primes=primes_upto(2*max(P_WINDOWS)+20)
rows=[]; checks=[]
for P in P_WINDOWS:
    ps=[p for p in primes if P<p<=2*P and math.gcd(p,30)==1]
    for ratio in RATIOS:
        X=P*ratio; firstp=ps[0]
        for kind in KINDS:
            b0=b_sequence_full(X,firstp,kind,mu)
            L=b0.get(0,0.0)
            C_direct=sum(b0.values()); C_fact=residue_sums(X,firstp,kind,mu)
            relC=abs(C_direct-C_fact)/max(1.0,abs(C_direct),abs(C_fact))
            if relC>1e-10: raise AssertionError(('Cfactor',P,ratio,kind,relC))
            if kind=='inverse' and L>1e-12: raise AssertionError(('inverse diagonal sign',P,ratio,L))
            if kind=='plain' and L<-1e-12: raise AssertionError(('plain diagonal sign',P,ratio,L))
            for q in QS:
                _,F=packet_fft(b0,q)
                boff=dict(b0); boff.pop(0,None)
                _,B=packet_fft(boff,q)
                scale=max(1.0,max(abs(z) for z in B))
                ident=max(abs(B[j]-(F[j]-L)) for j in range(q))/scale
                if ident>1e-8: raise AssertionError(('B=F-L',P,ratio,kind,q,ident))
                fferr=0.0
                for j in range(q):
                    fact=residue_sums(X,firstp,kind,mu,q,j)
                    fferr=max(fferr,abs(fact-F[j])/max(1.0,abs(F[j]),abs(fact)))
                if fferr>1e-8: raise AssertionError(('T79factor',P,ratio,kind,q,fferr))
                checks.append({'P':P,'ratio':ratio,'kind':kind,'p':firstp,'q':q,'C_factor_relerr':relC,'B_identity_relerr':ident,'T79_max_relerr':fferr,'L':L})
        for kind in KINDS:
            for p in ps:
                b=b_sequence_full(X,p,kind,mu); L=b.get(0,0.0)
                boff=dict(b); boff.pop(0,None)
                for q in QS:
                    _,F=packet_fft(b,q); _,B=packet_fft(boff,q)
                    qnzB=sum(abs(B[j])**2 for j in range(1,q))
                    qnzF=sum(abs(F[j])**2 for j in range(1,q))
                    interf=-2.0*(L*sum(F[j] for j in range(1,q))).real
                    rhs=qnzF+(q-1)*abs(L)**2+interf
                    relE=abs(qnzB-rhs)/max(1.0,abs(qnzB),abs(rhs))
                    if relE>1e-10: raise AssertionError(('energy identity',P,ratio,kind,p,q,relE))
                    m1off,zoff=m1_and_zero(B); m1full,zfull=m1_and_zero(F)
                    diag_amp=(math.sqrt(q-1)*abs(L)/math.sqrt(qnzB)) if qnzB>0 else None
                    rel_l2=(math.sqrt(q-1)*abs(L)/math.sqrt(qnzF)) if qnzF>0 else None
                    rows.append({'P':P,'ratio':ratio,'X':X,'kind':kind,'p':p,'q':q,'L':L,'M1_off':m1off,'M1_full':m1full,'delta_M1':m1off-m1full,'zero_share_off':zoff,'zero_share_full':zfull,'diag_amp_ratio':diag_amp,'relative_L2_change':rel_l2,'Q_nonzero_off':qnzB,'Q_nonzero_full':qnzF,'diag_energy_term':(q-1)*abs(L)**2,'interference_term':interf,'energy_identity_relerr':relE,'chi3':chi3(p),'chi5':chi5(p),'chi15':chi15(p)})

contrasts=[]
metrics=['M1_off','M1_full','delta_M1','diag_amp_ratio']
for P in P_WINDOWS:
  for ratio in RATIOS:
    for q in QS:
      for kind in KINDS:
        sub=[r for r in rows if r['P']==P and r['ratio']==ratio and r['q']==q and r['kind']==kind]
        for char in ['chi3','chi5','chi15']:
          plus=[r for r in sub if r[char]==1]; minus=[r for r in sub if r[char]==-1]
          for metric in metrics:
            pp=[r[metric] for r in plus if r[metric] is not None]; mm=[r[metric] for r in minus if r[metric] is not None]
            val=(mean(pp)-mean(mm)) if pp and mm else None
            contrasts.append({'P':P,'ratio':ratio,'q':q,'kind':kind,'char':char,'metric':metric,'contrast':val,'nplus':len(pp),'nminus':len(mm)})

aggregates=[]
for kind in KINDS:
  for metric in ['M1_off','delta_M1']:
    block={ch:[c['contrast'] for c in contrasts if c['kind']==kind and c['metric']==metric and c['char']==ch and c['contrast'] is not None] for ch in ['chi3','chi5','chi15']}
    mean_abs={ch:mean([abs(x) for x in vals]) for ch,vals in block.items()}
    top=0; signpos=0; signneg=0; total=0
    keys=sorted({(c['P'],c['ratio'],c['q']) for c in contrasts if c['kind']==kind and c['metric']==metric})
    for key in keys:
      vals={ch:next((c['contrast'] for c in contrasts if c['kind']==kind and c['metric']==metric and c['char']==ch and (c['P'],c['ratio'],c['q'])==key),None) for ch in ['chi3','chi5','chi15']}
      if all(v is not None for v in vals.values()):
        total+=1
        if abs(vals['chi5'])>abs(vals['chi3']) and abs(vals['chi5'])>abs(vals['chi15']): top+=1
        if vals['chi5']>0: signpos+=1
        elif vals['chi5']<0: signneg+=1
    aggregates.append({'kind':kind,'metric':metric,'mean_abs_chi3':mean_abs['chi3'],'mean_abs_chi5':mean_abs['chi5'],'mean_abs_chi15':mean_abs['chi15'],'chi5_top_count':top,'total_cases':total,'chi5_positive':signpos,'chi5_negative':signneg})

summaries=[]
for kind in KINDS:
  for ratio in RATIOS:
    for q in QS:
      sub=[r for r in rows if r['kind']==kind and r['ratio']==ratio and r['q']==q]
      summaries.append({'kind':kind,'ratio':ratio,'q':q,'n':len(sub),'mean_M1_off':mean([r['M1_off'] for r in sub]),'mean_M1_full':mean([r['M1_full'] for r in sub]),'mean_delta_M1':mean([r['delta_M1'] for r in sub]),'mean_diag_amp_ratio':mean([r['diag_amp_ratio'] for r in sub if r['diag_amp_ratio'] is not None]),'mean_zero_share_off':mean([r['zero_share_off'] for r in sub]),'mean_zero_share_full':mean([r['zero_share_full'] for r in sub])})

out={'protocol':{'P_WINDOWS':P_WINDOWS,'RATIOS':RATIOS,'QS':QS,'KINDS':KINDS},'checks':checks,'summaries':summaries,'character_aggregates':aggregates,'row_count':len(rows),'contrast_count':len(contrasts),'max_energy_identity_relerr':max(r['energy_identity_relerr'] for r in rows),'max_factorization_relerr':max(c['T79_max_relerr'] for c in checks),'max_B_identity_relerr':max(c['B_identity_relerr'] for c in checks)}
with open('bridge_exp06_results.json','w') as f: json.dump(out,f,indent=2)
for name,data in [('bridge_exp06_rows.csv',rows),('bridge_exp06_contrasts.csv',contrasts),('bridge_exp06_summary.csv',summaries)]:
    with open(name,'w',newline='') as f:
        w=csv.DictWriter(f,fieldnames=list(data[0].keys()));w.writeheader();w.writerows(data)
with open(__file__,'rb') as f: sh=hashlib.sha256(f.read()).hexdigest()
with open('bridge_exp06_results.json','rb') as f: jh=hashlib.sha256(f.read()).hexdigest()
print(json.dumps({'row_count':len(rows),'contrast_count':len(contrasts),'max_energy_identity_relerr':out['max_energy_identity_relerr'],'max_factorization_relerr':out['max_factorization_relerr'],'max_B_identity_relerr':out['max_B_identity_relerr'],'summaries':summaries,'character_aggregates':aggregates,'script_sha256':sh,'json_sha256':jh},indent=2))
