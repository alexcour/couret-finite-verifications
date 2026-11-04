"""Exact rational examples/projection checks; general proofs are in the note."""
from fractions import Fraction as F
from pathlib import Path
import json

ROOT=Path(__file__).resolve().parent
UNITS=(1,7,11,13,17,19,23,29)

def dot(a,b): return sum(x*y for x,y in zip(a,b))

def main():
    raw=json.loads((ROOT/'data/C2_FULL_Q30_NUMERICAL_v1.6.json').read_text())
    c=[[F(str(raw['matrix'][str(a)][str(z)])) for z in UNITS] for a in UNITS]
    a=[[ (c[i][j]-c[j][i])/2 for j in range(8)] for i in range(8)]
    k=[[F(0) if u==v else F(15-(v-u)%30,15) for v in UNITS] for u in UNITS]
    flat=lambda x:sum(x,[])
    kk=dot(flat(k),flat(k)); theta=dot(flat(a),flat(k))/kk
    r=[[a[i][j]-theta*k[i][j] for j in range(8)] for i in range(8)]
    assert dot(flat(r),flat(k))==0
    assert all(k[i][j]==-k[j][i] and r[i][j]==-r[j][i] for i in range(8) for j in range(8))
    energy=dot(flat(a),flat(a))
    assert energy==theta*theta*kk+dot(flat(r),flat(r))
    for shift in [F(-3),F(-1,2),F(0),F(1,3),F(2)]:
        err=[aij-(theta+shift)*kij for aij,kij in zip(flat(a),flat(k))]
        assert dot(err,err)==dot(flat(r),flat(r))+shift*shift*kk
    # Exact Brier-line identity in five nonuniform synthetic eight-class rows.
    for row in range(1,6):
        p=[F(z+row,sum(range(row,row+8))) for z in range(8)]
        q=[F(8-z+row,sum(range(row+1,row+9))) for z in range(8)]
        counts=[(z+1)*(row+2) for z in range(8)]; n=sum(counts)
        empirical=[F(x,n) for x in counts]; d=[y-x for x,y in zip(p,q)]
        alignment=dot(d,[r0-p0 for r0,p0 in zip(empirical,p)])
        cost=dot(d,d)
        for alpha in [F(0),F(1,2),F(1)]:
            v=[x+alpha*dx for x,dx in zip(p,d)]
            lp=sum(counts[z]*(1-2*p[z]+dot(p,p)) for z in range(8))/n
            lv=sum(counts[z]*(1-2*v[z]+dot(v,v)) for z in range(8))/n
            assert lp-lv==2*alpha*alignment-alpha*alpha*cost
        optimum=alignment/cost
        assert 2*optimum*alignment-optimum*optimum*cost==alignment*alignment/cost
    # Brier along binary logistic probability: curvature is negative at q=1/4.
    probability=F(1,4)
    curvature=4*probability*(1-probability)**2*(3*probability-1)
    assert curvature==F(-9,64)
    print(json.dumps({'status':'PASS','role':'EXACT_CHECKS_OF_FINITE_TABLE_AND_EXAMPLES',
                      'table_theta_exact':str(theta),'table_theta_float':float(theta),
                      'geometric_energy_fraction':float(theta*theta*kk/energy),
                      'brier_logistic_counterexample_curvature':str(curvature),
                      'lean_compilation':False},indent=2))

if __name__=='__main__':main()
