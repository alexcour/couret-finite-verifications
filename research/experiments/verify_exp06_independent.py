"""Independent EXP-06 audit. No import from the canonical runner.

Usage: python verify_exp06_independent.py REPLAY_DIR OUTPUT_DIR
Same frozen corpus/metrics. Exact integer tent numerators, trial division
Mobius, direct (n,m) enumeration, exact residue products and packet energies.
Assertions use the frozen Fourier 1e-8 and energy/Parseval 1e-10 tolerances.
"""
import argparse, cmath, csv, json, math
from collections import defaultdict
from pathlib import Path

def mu_trial(n):
    sign = 1
    d = 2
    while d*d <= n:
        if n % d == 0:
            n //= d
            sign = -sign
            if n % d == 0:
                return 0
        d += 1
    return -sign if n > 1 else sign

def prime(n):
    return n > 1 and all(n % d for d in range(2, math.isqrt(n)+1))

def tent_num(n, X):
    return max(0, X-abs(2*n-3*X))

def csum(xs):
    xs = list(xs)
    return complex(math.fsum(z.real for z in xs), math.fsum(z.imag for z in xs))

def dft(H, q, den):
    return [csum(v/den*cmath.exp(-2j*math.pi*j*r/q)
                 for r,v in enumerate(H)) for j in range(q)]

def near(a, b, tol):
    err = abs(a-b)/max(1.,abs(a),abs(b))
    assert err <= tol, (a,b,err,tol)
    return err

def main():
    ap=argparse.ArgumentParser(); ap.add_argument('replay'); ap.add_argument('output')
    args=ap.parse_args(); src=Path(args.replay); dst=Path(args.output); dst.mkdir(parents=True,exist_ok=True)
    canonical=list(csv.DictReader((src/'bridge_exp06_rows.csv').open()))
    expected={(int(r['P']),int(r['ratio']),r['kind'],int(r['p']),int(r['q'])):r for r in canonical}
    assert len(expected)==1824
    maxima=defaultdict(float); counts=defaultdict(int); rows=[]; spectra=[]; sequences=[]; discrepancies=[]
    mus={n:mu_trial(n) for n in range(1,12801) if math.gcd(n,30)==1}
    for P in (100,200,400):
      ps=[p for p in range(P+1,2*P+1) if prime(p) and math.gcd(p,30)==1]
      for ratio in (8,16):
       X=P*ratio; den=X*X
       for kind in ('plain','inverse'):
        ns=[(n,tent_num(n,X)*(1 if kind=='plain' else mus[n]))
            for n in range(X,2*X+1) if math.gcd(n,30)==1]
        ns=[(n,v) for n,v in ns if v]
        for p in ps:
         ms=[(m,tent_num(p*m,X)*(1 if kind=='plain' else mus[m]))
             for m in range(1,2*X//p+1) if math.gcd(m,30)==1]
         ms=[(m,v) for m,v in ms if v]
         b=defaultdict(int); A=defaultdict(int); T=defaultdict(int)
         for n,v in ns: A[n%30]+=v
         for m,v in ms: T[m%30]+=v
         for n,vn in ns:
          for m,vm in ms:
           diff=n-p*m
           if diff%30==0: b[diff//30]+=vn*vm
         C=sum(b.values()); product=sum(A[p*a%30]*T[a] for a in (1,7,11,13,17,19,23,29))
         assert C==product; counts['exact_C_product']+=1
         if kind=='inverse':
          Ldirect=-sum(tent_num(p*m,X)**2*mus[m]**2 for m,_ in ms if m%p)
         else: Ldirect=sum(tent_num(p*m,X)**2 for m,_ in ms)
         L=b.get(0,0); assert L==Ldirect; counts['exact_L_direct']+=1
         assert L<=0 if kind=='inverse' else L>=0
         for h,v in sorted(b.items()):
          sequences.append({'P':P,'ratio':ratio,'kind':kind,'p':p,'h':h,'b_numerator':v,'denominator':den})
         for q in (7,11,13,17):
          H=[sum(v for h,v in b.items() if h%q==r) for r in range(q)]
          J=[sum(v for h,v in b.items() if h!=0 and h%q==r) for r in range(q)]
          assert H[0]-J[0]==L and H[1:]==J[1:]
          F=dft(H,q,den); B=dft(J,q,den)
          for j in range(q): maxima['B_identity']=max(maxima['B_identity'],near(B[j],F[j]-L/den,1e-8))
          for label,Z,packet in [('full',F,H),('off',B,J)]:
           exact_all=q*sum(v*v for v in packet)
           maxima['Parseval']=max(maxima['Parseval'],near(sum(abs(z)**2 for z in Z),exact_all/den**2,1e-10))
           counts['Parseval']+=1
          full_nz=q*sum(v*v for v in H)-sum(H)**2
          off_nz=q*sum(v*v for v in J)-sum(J)**2
          diag=(q-1)*L*L
          cross=-2*L*(q*H[0]-sum(H))
          assert off_nz==full_nz+diag+cross; counts['exact_energy_identity']+=1
          r={'P':P,'ratio':ratio,'kind':kind,'p':p,'q':q,'L':L/den,
             'Q_nonzero_off':off_nz/den**2,'Q_nonzero_full':full_nz/den**2,
             'diag_energy_term':diag/den**2,'interference_term':cross/den**2,
             'diag_amp_ratio':math.sqrt(diag/off_nz) if off_nz else None,
             'relative_L2_change':math.sqrt(diag/full_nz) if full_nz else None}
          for label,Z,H0 in [('off',B,J),('full',F,H)]:
           allE=q*sum(v*v for v in H0)/den**2
           r['M1_'+label]=max(abs(z)**2 for z in Z[1:])/allE if allE else 0.
           r['zero_share_'+label]=abs(Z[0])**2/allE if allE else 0.
          r['delta_M1']=r['M1_off']-r['M1_full']
          r['chi3']=1 if p%3==1 else -1
          r['chi5']=1 if p%5 in (1,4) else -1
          r['chi15']=r['chi3']*r['chi5']
          old=expected[(P,ratio,kind,p,q)]
          for k,v in r.items():
           if k in ('P','ratio','kind','p','q'): continue
           if v is None:
            if old[k]!='':
             discrepancies.append({'P':P,'ratio':ratio,'kind':kind,'p':p,'q':q,'metric':k,'canonical':old[k],'exact':None,'reason':'exact zero denominator; floating Fourier roundoff'})
           else: maxima['row_'+k]=max(maxima['row_'+k],near(v,float(old[k]),1e-10))
          rows.append(r)
          for j in range(q):
           spectra.append({'P':P,'ratio':ratio,'kind':kind,'p':p,'q':q,'j':j,
             'F_real':F[j].real,'F_imag':F[j].imag,'B_real':B[j].real,'B_imag':B[j].imag})
          if p==ps[0]:
           u=pow(30,-1,q)
           for j in range(q):
            AA={a:csum(v/ X*cmath.exp(-2j*math.pi*(j*u*n%q)/q) for n,v in ns if n%30==a)
                for a in (1,7,11,13,17,19,23,29)}
            TT={a:csum(v/ X*cmath.exp(2j*math.pi*(j*u*p*m%q)/q) for m,v in ms if m%30==a)
                for a in (1,7,11,13,17,19,23,29)}
            fact=csum(AA[p*a%30]*TT[a] for a in AA)
            direct=csum(v/den*cmath.exp(-2j*math.pi*j*h/q) for h,v in b.items())
            maxima['T79']=max(maxima['T79'],near(fact,F[j],1e-8))
            maxima['direct_shift_Fourier']=max(maxima['direct_shift_Fourier'],near(direct,F[j],1e-8))
            counts['T79_frequencies']+=1
    old_contrasts=list(csv.DictReader((src/'bridge_exp06_contrasts.csv').open()))
    for c in old_contrasts:
     sub=[r for r in rows if r['P']==int(c['P']) and r['ratio']==int(c['ratio']) and r['q']==int(c['q']) and r['kind']==c['kind']]
     a=[r[c['metric']] for r in sub if r[c['char']]==1 and r[c['metric']] is not None]
     b=[r[c['metric']] for r in sub if r[c['char']]==-1 and r[c['metric']] is not None]
     assert (len(a),len(b))==(int(c['nplus']),int(c['nminus']))
     v=math.fsum(a)/len(a)-math.fsum(b)/len(b)
     maxima['contrast']=max(maxima['contrast'],near(v,float(c['contrast']),1e-10)); counts['contrasts']+=1
    assert len(rows)==1824 and counts['contrasts']==576 and counts['T79_frequencies']==576
    for name,data in [('independent_rows.csv',rows),('independent_spectra.csv',spectra),('exact_sequences.csv',sequences)]:
     with (dst/name).open('w',newline='') as f:
      w=csv.DictWriter(f,fieldnames=list(data[0])); w.writeheader(); w.writerows(data)
    result={'identity_checks_status':'PASS','canonical_runner_imported':False,'counts':dict(counts),
            'secondary_zero_denominator_discrepancies':discrepancies,
            'max_scaled_errors':dict(maxima),'row_count':len(rows),'spectrum_count':len(spectra),
            'method':'trial division Mobius, exact integer tent, direct n,m enumeration, exact C/L/packet energy, independent DFT'}
    (dst/'independent_checks.json').write_text(json.dumps(result,indent=2)+'\n')
    print(json.dumps(result,indent=2))

if __name__=='__main__': main()
