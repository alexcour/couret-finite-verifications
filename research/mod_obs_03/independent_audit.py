#!/usr/bin/env python3
"""Independent rational absorption-equation audit, no import of main solver."""
import json
import math
from fractions import Fraction
from pathlib import Path


def solve(M,b):
    """Exact Gauss-Jordan with rational arithmetic."""
    n=len(b)
    a=[[Fraction(x) for x in M[i]]+[Fraction(b[i])] for i in range(n)]
    for col in range(n):
        pivot=next((r for r in range(col,n) if a[r][col]!=0),None)
        if pivot is None:raise ValueError('singular system')
        a[col],a[pivot]=a[pivot],a[col]
        p=a[col][col]
        a[col]=[v/p for v in a[col]]
        for row in range(n):
            if row==col:continue
            f=a[row][col]
            a[row]=[a[row][j]-f*a[col][j] for j in range(n+1)]
    return [row[n] for row in a]


def absorbing_chain(p,r):
    """p is error probability, step +1 with probability 1-p (true bit = 1)."""
    p=Fraction(p)
    idx=list(range(-r+1,r))
    size=len(idx)
    mat=[[Fraction(int(i==j)) for j in range(size)] for i in range(size)]
    rhs_error=[Fraction(0) for _ in idx]
    rhs_duration=[Fraction(1) for _ in idx]
    lookup={s:k for k,s in enumerate(idx)}
    for k,s in enumerate(idx):
        for s2,prob in [(s-1,p),(s+1,1-p)]:
            if s2==-r:rhs_error[k]+=prob
            elif s2==r:pass
            else:mat[k][lookup[s2]]-=prob
    e=solve(mat,rhs_error)[lookup[0]]
    t=solve(mat,rhs_duration)[lookup[0]]
    return e,t


def get_r(p,required_ratio):
    p=Fraction(p); k=(1-p)/p
    accum=Fraction(1)
    result=0
    while accum<required_ratio:
        accum*=k
        result+=1
    return result


def serialize(x):return {'fraction':str(x),'decimal':float(x)}


def audit():
    delta=Fraction(1,20)
    channels={'q1':{'p':Fraction(1,10),'cost':Fraction(2)},
              'q4':{'p':Fraction(1,5),'cost':Fraction(1)}}
    report={'method':'exact Gaussian elimination for gambler-ruin absorbing chains',
            'delta':str(delta),'channels':{},'negative_controls':{}}
    recon_error=Fraction(1)
    recon_cost=Fraction(0)
    for name,c in channels.items():
        rp=get_r(c['p'],1/delta)
        rr=get_r(c['p'],2/delta)
        ep,tp=absorbing_chain(c['p'],rp)
        er,tr=absorbing_chain(c['p'],rr)
        report['channels'][name]={'property_threshold_net_votes':rp,
            'property_error':serialize(ep),'property_expected_queries':serialize(tp),
            'property_expected_cost':serialize(tp*c['cost']),
            'reconstruction_threshold_net_votes':rr,
            'reconstruction_bit_error':serialize(er),
            'reconstruction_expected_queries':serialize(tr),
            'reconstruction_expected_cost':serialize(tr*c['cost'])}
        recon_error*=(1-er)
        recon_cost+=tr*c['cost']
    report['reconstruction_error_iid']=serialize(1-recon_error)
    report['reconstruction_expected_cost_iid']=serialize(recon_cost)
    # Sensitivity: retain original thresholds but perturb the TRUE channel error rate.
    er1,_=absorbing_chain(Fraction(1,4), report['channels']['q1']['reconstruction_threshold_net_votes'])
    er4,_=absorbing_chain(Fraction(7,20),report['channels']['q4']['reconstruction_threshold_net_votes'])
    bp,_=absorbing_chain(Fraction(1,4),report['channels']['q1']['property_threshold_net_votes'])
    report['negative_controls']['iid_miscalibration_property_q1_error']=serialize(bp)
    report['negative_controls']['iid_miscalibration_reconstruction_error']=serialize(1-(1-er1)*(1-er4))
    report['negative_controls']['persistent_flip_property_q1_error']=serialize(Fraction(1,10))
    report['negative_controls']['persistent_flip_reconstruction_error']=serialize(1-Fraction(9,10)*Fraction(4,5))
    # Independently calculate KL lower bound and confirm strict inequality.
    d=float(delta)
    k=(1-2*d)*math.log((1-d)/d)
    rec_lb=sum(float(c['cost'])*k/((1-2*float(c['p']))*math.log((1-float(c['p']))/float(c['p'])))
               for c in channels.values())
    q1_ub=float(Fraction(report['channels']['q1']['property_expected_cost']['fraction']))
    report['kl_cost_lower_bound']=rec_lb
    report['property_q1_cost_upper_bound']=q1_ub
    report['strict_separation']=(rec_lb>q1_ub)
    return report

if __name__=='__main__':
    d=audit()
    p=Path(__file__).with_name('independent_audit.json')
    p.write_text(json.dumps(d,indent=2,ensure_ascii=False)+'\n',encoding='utf-8')
    print('Independent audit:',p)
    print('Reconstruction cost',d['reconstruction_expected_cost_iid'])
    print('Error probability',d['reconstruction_error_iid'])
    print('Strict separation',d['strict_separation'])
