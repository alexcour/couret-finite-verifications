#!/usr/bin/env python3
"""Unit and integration checks, no network; Python -m unittest -v."""
import itertools
import json
import math
import unittest
from pathlib import Path
import numpy as np
import spec30_210 as s

HERE=Path(__file__).parent

class TestSpectralAlgebra(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.A=s.adjacency_sym(30)
        cls.B=s.adjacency_sym(210)
        cls.P=s.spectral_projectors30(cls.A)
        cls.L,cls.Q,cls.C,cls.J=s.transfer_matrices()

    def test_spectrum30(self):
        self.assertEqual({float(round(k,8)):int(v) for k,v in zip(*np.unique(np.round(np.linalg.eigvalsh(self.A),8),return_counts=True))},
                         {-1.0:2,1.0:4,3.0:2})
        self.assertEqual({k:int(round(np.trace(p))) for k,p in self.P.items()},{3:1,1:4,-1:2})

    def test_spectrum210(self):
        vals,counts=np.unique(np.round(np.linalg.eigvalsh(self.B),8),return_counts=True)
        self.assertEqual({float(k):int(v) for k,v in zip(vals,counts)},
                         {-1.0:4,-.5:8,.5:8,1.0:8,1.5:8,2.5:8,3.0:4})

    def test_symmetric_matrices(self):
        self.assertTrue(np.array_equal(self.A.T,self.A))
        self.assertTrue(np.array_equal(self.B.T,self.B))
        self.assertTrue(np.allclose(self.A@np.ones(8),3*np.ones(8)))
        self.assertTrue(np.allclose(self.B@np.ones(48),3*np.ones(48)))

    def test_projector_identity(self):
        J8=np.ones((8,8))/8
        self.assertTrue(np.allclose(sum(self.P.values()),np.eye(8)-J8))
        for k,Pi in self.P.items():
            self.assertTrue(np.allclose(Pi@Pi,Pi))
            self.assertTrue(np.allclose(self.A@Pi,k*Pi))

    def test_quadratic_character_exact(self):
        chi5=s.spectral_character_mod5()
        self.assertTrue(np.array_equal(chi5@self.A,3*chi5))
        self.assertTrue(np.allclose(self.P[3],np.outer(chi5,chi5)/8))
        self.assertEqual(list(map(int,chi5)),[1,-1,1,-1,-1,1,-1,1])

    def test_lift_identity(self):
        self.assertTrue(np.array_equal(self.B@self.L,self.L@self.A))
        self.assertTrue(np.array_equal(self.L.T@self.L,6*np.eye(8)))
        self.assertTrue(np.allclose(self.C@self.C,self.C))
        self.assertEqual(int(round(np.trace(self.C-self.J))),7)
        self.assertTrue(np.allclose((np.eye(48)-self.C)@self.C,0))

    def test_reference_M30(self):
        ref=json.loads((HERE/'M30_reference.json').read_text())
        M=np.array([float(ref['M30'][str(a)]) for a in s.UNITS30]);m=s.centered(M)
        observed=s.energies30(M,self.A,self.P)
        self.assertAlmostEqual(observed['energy']['3'],float((s.spectral_character_mod5()@M)**2/(8*m@m)),places=13)
        self.assertAlmostEqual(sum(observed['energy'].values()),1.0,places=13)

    def test_exhaustive_permutation_controls(self):
        ref=json.loads((HERE/'M30_reference.json').read_text())
        M=np.array([float(ref['M30'][str(a)]) for a in s.UNITS30])
        diag=s.exhaustive_label_controls30(M,self.A,self.P)
        self.assertEqual(diag['permutations_exhaustive'],40320)
        self.assertEqual(diag['scores']['3']['tail_ge_count'],10368)
        self.assertAlmostEqual(diag['scores']['3']['reference_mean'],1/7,places=13)

    def test_mc_has_independent_permutations(self):
        z=np.array(list(range(48)),dtype=float)
        one=s.label_monte_carlo_210(z,self.L,samples=1000,seed=s.SEED)
        two=s.label_monte_carlo_210(z,self.L,samples=1000,seed=s.SEED)
        self.assertEqual(one,two)
        self.assertLess(abs(one['mean']-7/47),.015)

class TestPrimes(unittest.TestCase):
    def test_small_sieve_vs_trial(self):
        self.assertEqual(list(s.primes_sieve(5000)),
                         [p for p in range(5001) if s.is_prime_naive(p)])

    def test_counts_to_100k(self):
        ref=json.loads((HERE/'M30_reference.json').read_text())
        data=s.cumulative_counts((10_000,100_000))
        for t in data:
            for i,a in enumerate(s.UNITS30):
                self.assertEqual(data[t][30][i],ref['finite_cumulative_counts_30'][str(t)][str(a)])
            self.assertEqual(int(sum(data[t][30])-sum(data[t][210])),1)

    def test_posthoc_quotient_controls_equivalent_quotients(self):
        result=json.loads((HERE/'resultats_spec.json').read_text())
        qc=result['holdout']['posthoc_quotient_controls']
        for a,b in [('15','30'),('21','42'),('35','70')]:
            self.assertEqual(qc[a]['rank'],qc[b]['rank'])
            self.assertAlmostEqual(qc[a]['energy'],qc[b]['energy'],places=12)
        self.assertAlmostEqual(qc['30']['energy'],result['holdout']['coarse_fraction'],places=12)

    def test_holdout_reference_consistency(self):
        res=json.loads((HERE/'resultats_spec.json').read_text())
        self.assertEqual(res['protocol_sha256'],'829459bf323e10a9cdfded420f3dbd491be39a50350c28d2206e85cce36a97ce')
        x=res['holdout']['coarse_fraction']
        self.assertGreater(x,0)
        self.assertLess(x,1)
        self.assertTrue(res['holdout']['passes_predefined_threshold'])
        self.assertAlmostEqual(x, .042384122854008825, places=12)
        self.assertEqual(sum(res['windows']['30000000']['counts210'].values()),
                         res['windows']['30000000']['first_primes_in_units210'])

if __name__=='__main__':unittest.main()