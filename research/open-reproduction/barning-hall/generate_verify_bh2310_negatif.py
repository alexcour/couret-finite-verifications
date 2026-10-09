#!/usr/bin/env python3
"""Temoin de Rayleigh COTE NEGATIF a N=2310 (second temoin, complement du certificat BH2310 v1.0).
Reutilise build_model() du verificateur verify_bh2310_certificate.py (meme modele, meme indexation).
Generation : projection de la graine sin(i+1) sur l'espace propre complet de la plus petite valeur
propre de H (independant de la base ARPACK), echelle 100000, arrondi, correction entiere de la moyenne.
Verification : arithmetique entiere exacte uniquement."""
import hashlib, math, sys
import numpy as np
from scipy.sparse import coo_matrix
from scipy.sparse.linalg import eigsh
from verify_bh2310_certificate import build_model, EXPECTED_ORBIT_COUNT

SCALE = 100_000
m = build_model()
so = np.asarray(m.orbit_id); to = so[np.asarray(m.permutations["U"])]
sz = np.asarray(m.orbit_sizes, dtype=np.int64)
H = coo_matrix((4.0/np.sqrt(sz[so]*sz[to]), (so, to)), shape=(EXPECTED_ORBIT_COUNT,)*2).tocsr()
seed = np.sin(np.arange(EXPECTED_ORBIT_COUNT, dtype=float) + 1.0)
ev, V = eigsh(H, k=6, which="SA", tol=1e-13, maxiter=200000, v0=seed)
t = ev.min(); B = V[:, np.isclose(ev, t, rtol=0, atol=1e-10)]
c = B @ (B.T @ seed); c /= np.linalg.norm(c)
if c[np.flatnonzero(np.abs(c) > 1e-12)[0]] < 0: c = -c
w = np.rint(SCALE * c / np.sqrt(sz)).astype(np.int64)
s = int(sz @ w)
if s:
    assert s % 2 == 0
    w[int(np.flatnonzero(sz == 2)[0])] -= s // 2
out = "rayleigh_vector_2310_negatif.tsv"
with open(out, "w", encoding="utf-8", newline="\n") as h:
    h.write("# orbit_id\torbit_size\trepresentative_state_index\tvalue\n")
    for o, x in enumerate(w.tolist()):
        h.write(f"{o}\t{m.orbit_sizes[o]}\t{m.orbits[o][0]}\t{x}\n")
# ---- verification exacte ----
vals = [int(l.split("\t")[3]) for l in open(out) if not l.startswith("#")]
v = [vals[m.orbit_id[st]] for st in range(len(m.orbit_id))]
u = m.permutations["U"]
assert sum(sz_*x for sz_, x in zip(m.orbit_sizes, vals)) == 0
num = 4 * sum(v[i] * v[u[i]] for i in range(len(v))); den = sum(x*x for x in v)
g = math.gcd(num, den); p, q = num // g, den // g
print("R =", num/den); assert p < 0 < q and p*p - 12*q*q > 0, "echec"
print(f"multiplicite={B.shape[1]} mu_min~{t:.12f}")
print(f"v^T H v / v^T v = {num} / {den} = {p}/{q} ; p^2-12q^2 = {p*p-12*q*q} > 0 ; valeurs dans [{min(vals)},{max(vals)}]")
print("sha256 =", hashlib.sha256(open(out, "rb").read()).hexdigest())
print("CERTIFICAT NEGATIF : PASS (une valeur propre de H_2310 est < -2*sqrt(3))")
