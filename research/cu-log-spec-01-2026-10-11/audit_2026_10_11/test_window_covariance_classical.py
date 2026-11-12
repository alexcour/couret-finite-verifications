import math
import unittest
from window_covariance_classical import modes, result

class ClassicalWindowTest(unittest.TestCase):
    def test_fourier_kernel_by_quadrature(self):
        alpha=1/3;h=math.log(3)
        for gamma in (0, 1, 8.039737, 23.5, 50):
            n=8192
            step=h/n
            s=0.0
            for j in range(n+1):
                u=step*j
                value=(math.exp(-u/2)-alpha*math.exp(u/2))*math.cos(gamma*u)
                s+=(1 if j in (0,n) else (4 if j%2 else 2))*value
            integral=2*s*step/3
            spectral=(1+alpha-2*math.sqrt(alpha)*math.cos(gamma*h))/(.25+gamma*gamma)
            self.assertAlmostEqual(integral,spectral,places=11)
    def test_dimensions_and_traces(self):
        r=result()
        self.assertEqual(sum(z['dimension'] for z in r['conductors'].values()),47)
        self.assertEqual(len(modes()),47)
        self.assertAlmostEqual(r['total_trace'],62.74396926214003,places=10)
        for q,t in ((15,.04714422747489978),(21,.11257853933235427),(35,.37091361888243735)):
            self.assertAlmostEqual(r['trace_fractions'][str(q)],t,places=12)
    def test_parities_and_quad_character(self):
        row=next(m for m in modes() if m[0]==(0,2,0))
        self.assertEqual(row[1],5)
        self.assertFalse(row[2])
        self.assertTrue(row[5])
        self.assertAlmostEqual(row[3],-1,places=12)
        self.assertEqual(sum(row[5] for row in modes()),7)
if __name__=='__main__':unittest.main(verbosity=2)
