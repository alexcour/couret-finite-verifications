#!/usr/bin/env python3
"""Independent Sobol phase simulation for CU-BRUIT-02, conditional on the model.

NUMERICAL comparison with Bessel/Fourier inversion, NOT a proof of zero
completeness, GRH, LI, or a certified error interval. The q=15 zeros
remain externally unchecked. Does NOT modify CU-BRUIT-01 frozen data.
"""
import argparse
import json
import math
from pathlib import Path
import numpy as np
from scipy.special import ndtri
from scipy.stats import qmc

HERE=Path(__file__).resolve().parent
B_VALUES={'0,1':.20322143257953434,'0,2':.15655695399428649,
          '0,3':.20322143257953434,'1,0':.11322996985747234,
          '1,1':.40747843517714794,'1,2':.459364791008131,
          '1,3':.40747843517714794}

def low_zeros():
    rows=json.loads((HERE/'lmfdb_zero_comparison_20261009.json').read_text(encoding='utf-8'))['entries']
    return {r['ab']:r['positive_zero_ordinates_under_25'] for r in rows}

def run(power,replicates,chunk_power=15):
    root=low_zeros()
    assert {k:len(v) for k,v in root.items()}=={
       '0,1':8,'0,2':8,'0,3':8,'1,0':6,'1,1':12,'1,2':13,'1,3':12}
    amps=[]
    for key,zeros in root.items():
        c=3 if key=='0,2' else 1
        amps.extend(2*c/math.hypot(.5,g) for g in zeros)
    amps=np.array(amps,dtype=float)
    variance=sum((9 if k=='0,2' else 1)*v for k,v in B_VALUES.items())
    finite_var=np.sum(amps**2)/2
    tail_var=variance-finite_var
    assert len(amps)==67 and 0.7<tail_var<0.9
    means=[]
    for seed in range(replicates):
        sobol=qmc.Sobol(d=len(amps)+1,scramble=True,seed=4242+seed)
        successes=0; total=0
        for _ in range(1<<max(0,power-chunk_power)):
            u=sobol.random_base2(min(power,chunk_power)) if power<=chunk_power else sobol.random(1<<chunk_power)
            s=-1 + np.cos(2*np.pi*u[:,:-1])@amps
            s+=math.sqrt(tail_var)*ndtri(np.clip(u[:,-1],1e-15,1-1e-15))
            successes+=np.count_nonzero(s>0);total+=len(s)
        means.append(successes/total)
        print('replicate',seed+1,'n',total,'P_positive',format(means[-1],'.9f'),flush=True)
    print('VAR_TOTAL',format(variance,'.12f'))
    print('VAR_LOW',format(finite_var,'.12f'))
    print('VAR_GAUSSIAN_TAIL',format(tail_var,'.12f'))
    print('AVERAGE',format(float(np.mean(means)),'.9f'))
    print('SPREAD_SD',format(float(np.std(means,ddof=1)),'.9f'))
    print('MODEL_FOURIER_TARGET',0.2894388784)
    return {'sample_size_per_replicate':2**power,'replicates':replicates,
     'individual_probabilities':means,'mean':float(np.mean(means)),
     'spread_sd':float(np.std(means,ddof=1)),'low_variance':float(finite_var),
     'total_variance':variance,'gaussian_tail_variance':float(tail_var),
     'fourier_integral_previous_estimate':.2894388784,
     'model':'67 low roots from local/externally partly checked catalogue; higher zeros replaced by variance-matched normal',
     'status':'QMC_NUMERICAL_REPLAY_NOT_CERTIFICATION'}

if __name__=='__main__':
    p=argparse.ArgumentParser()
    p.add_argument('--power',type=int,default=17)
    p.add_argument('--replicates',type=int,default=4)
    p.add_argument('--output')
    args=p.parse_args()
    r=run(args.power,args.replicates)
    if args.output:Path(args.output).write_text(json.dumps(r,indent=2)+'\n')
