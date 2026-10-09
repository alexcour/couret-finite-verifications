"""Certificats exacts pour la refutation de H-C2 (forme locale/additive).
Probleme generalise : 4 N a = mu D a sur les orbites de Klein (N = comptes de transitions de U, D = tailles).
Sylvester : nb de mu > t  = nb de valeurs propres > 0 de (4N - tD) ; nb de mu < -t = nb < 0 de (4N + tD)."""
import numpy as np, itertools
from fractions import Fraction as F
from collections import Counter
def comp(p):
    keys=[];ix={}
    for a in range(p):
        for b in range(p):
            if (a,b)==(0,0): continue
            k=min((a,b),((-a)%p,(-b)%p))
            if k not in ix: ix[k]=len(keys); keys.append(k)
    K=lambda a,b: ix[min((a%p,b%p),((-a)%p,(-b)%p))]
    return len(keys),{nm:np.array([K(*f(a,b)) for (a,b) in keys]) for nm,f in {
        'U':lambda a,b:(a+2*b,b),'S':lambda a,b:(-b,a),'R':lambda a,b:(b,a),'K':lambda a,b:(-a,b)}.items()}
def model(P):
    C=[comp(p) for p in P]; ns=[c[0] for c in C]; M=int(np.prod(ns))
    g=np.meshgrid(*[np.arange(n) for n in ns],indexing='ij')
    G={nm:np.ravel_multi_index([C[i][1][nm][g[i]] for i in range(len(P))],ns).ravel() for nm in 'USRK'}
    oid=-np.ones(M,int); sizes=[]
    for s in range(M):
        if oid[s]<0:
            o={s,G['S'][s],G['R'][s],G['K'][s]}; 
            for x in o: oid[x]=len(sizes)
            sizes.append(len(o))
    n=len(sizes); Ncnt=Counter(zip(oid.tolist(),oid[G['U']].tolist()))
    assert all(Ncnt[(a,b)]==Ncnt[(b,a)] for (a,b) in Ncnt)
    return M,n,sizes,Ncnt,G,oid
def inertia(A):
    """(n+, n-, n0) d'une matrice symetrique rationnelle, elimination exacte avec pivots 1x1/2x2."""
    A=[row[:] for row in A]; n=len(A); pos=neg=0; idx=list(range(n))
    while idx:
        piv=next((i for i in idx if A[i][i]!=0),None)
        if piv is not None:
            d=A[piv][piv]; pos+=d>0; neg+=d<0; idx.remove(piv)
            for i in idx:
                if A[i][piv]!=0:
                    f=A[i][piv]/d
                    for j in idx: A[i][j]-=f*A[piv][j]
            continue
        pr=next(((i,j) for i in idx for j in idx if i<j and A[i][j]!=0),None)
        if pr is None: break          # reste nul
        i0,j0=pr; pos+=1; neg+=1      # bloc 2x2 [[0,b],[b,0]] : signature (1,1)
        idx.remove(i0); idx.remove(j0); b=A[i0][j0]
        for i in idx:
            ci,cj=A[i][i0],A[i][j0]
            if ci==0 and cj==0: continue
            for j in idx:
                A[i][j]-= (ci*A[j0][j]+cj*A[i0][j])/b
    return pos,neg,len(A)-pos-neg
t=F(345,100)   # 3.45 < 2*sqrt(3)=3.4641...
assert t*t<12
for P in [(3,),(5,),(7,),(11,),(3,5),(3,11),(5,11)]:
    M,n,sizes,Ncnt,_,_=model(P)
    A=[[4*Ncnt[(i,j)] - (t*sizes[i] if i==j else 0) for j in range(n)] for i in range(n)]
    B=[[4*Ncnt[(i,j)] + (t*sizes[i] if i==j else 0) for j in range(n)] for i in range(n)]
    up=inertia([[F(x) for x in r] for r in A])[0]; lo=inertia([[F(x) for x in r] for r in B])[1]
    print(f"N={2*int(np.prod(P)):4d} orbites={n:4d}  #mu>3.45 = {up} (1 = seulement mu=4)  #mu<-3.45 = {lo}  -> {'RESPECTE' if up==1 and lo==0 else '??'}")
# --- 330 : certificat de Rayleigh entier ---
import scipy.sparse as sp, scipy.sparse.linalg as sla
M,n,sizes,Ncnt,G,oid=model((3,5,11))
rows,cols,vals=zip(*[(a,b,4*c) for (a,b),c in Ncnt.items()])
N4=sp.csr_matrix((vals,(rows,cols)),shape=(n,n)).toarray(); D=np.diag(sizes).astype(float)
Dm=np.diag(1/np.sqrt(sizes)); ev,V=np.linalg.eigh(Dm@N4@Dm)
k=np.argsort(ev)[-2]; a=(Dm@V[:,k]); a=np.rint(a/np.abs(a).max()*1000).astype(int)
s=int(np.dot(sizes,a)); 
a=[int(x)*sum(sizes)-s for x in a]            # somme ponderee nulle exacte
num=sum(4*c*a[i]*a[j] for (i,j),c in Ncnt.items()); den=sum(sz*x*x for sz,x in zip(sizes,a))
print(f"N=330 : mu2 num.={ev[k]:.9f}  certificat entier: num>0 {num>0}, num^2-12 den^2>0 : {num*num-12*den*den>0}, R={num/den:.9f}, somme ponderee={int(np.dot(sizes,a))}")
