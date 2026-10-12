#!/usr/bin/env python3
"""Exact integer check of the archived negative Rayleigh witness for H_2310.

Uses the positive certificate's finite-model builder, but independently checks
its own frozen negative vector. Not a second independent model implementation.
"""
import hashlib
import math
from pathlib import Path
from verify_bh2310_certificate import build_model

P = Path(__file__).with_name('rayleigh_vector_2310_negatif.tsv')
HASH = 'bc8d425d255c8de5e929b4a791e5ec182d0d78f9aed6042ea4980c89e871264e'
assert hashlib.sha256(P.read_bytes()).hexdigest() == HASH, 'witness hash mismatch'
model = build_model()
rows = []
for line in P.read_text(encoding='utf8').splitlines():
    if line and not line.startswith('#'):
        fields = tuple(map(int,line.split('\t')))
        assert len(fields)==4
        rows.append(fields)
assert len(rows) == len(model.orbits) == 17520
vals=[]
for j,(oid,sz,rep,val) in enumerate(rows):
    assert oid == j and sz == model.orbit_sizes[j] and rep == model.orbits[j][0]
    vals.append(val)
assert sum(a*b for a,b in zip(vals,model.orbit_sizes)) == 0
v = [vals[o] for o in model.orbit_id]
for name in ('S','R','K'):
    perm=model.permutations[name]
    assert all(v[i]==v[perm[i]] for i in range(len(v)))
u = model.permutations['U']
num = 4*sum(v[i]*v[u[i]] for i in range(len(v)))
den = sum(x*x for x in v)
g = math.gcd(num,den)
p,q = num//g,den//g
assert (p,q) == (-723304493,208329425),(p,q)
assert p*p-12*q*q == 2355597744019549
assert p < 0 < q and p*p-12*q*q > 0
print('BH2310 NEGATIVE EXACT CHECK: PASS')
print('reduced quotient: %s/%s' % (p,q))
print('square gap: %s' %(p*p-12*q*q))
