import unittest
from fractions import Fraction as Q
from independent_hurwitz import GroupedEvaluator, TaylorEvaluator, box,get_bound

def contains_value(z,value):
    # Exact binary floating interval endpoints compared to exact rational values.
    def f(t):
        s,m,e,_=t
        return Q(-m if s else m)*Q(2)**e
    re=[f(v) for v in z.real._mpi_]
    im=[f(v) for v in z.imag._mpi_]
    return re[0]<=Q(value.real)<=re[1] and im[0]<=Q(value.imag)<=im[1]

class AnalyticRegression(unittest.TestCase):
    def test_explicit_remainder(self):
        em,exprel=get_bound()
        self.assertLess(em+exprel,Q(1,10**14))
    def test_exact_L_at_zero_for_three_characters(self):
        ev=GroupedEvaluator(dps=40)
        for b,expected in [(1,0j),(2,2+0j),(3,0j)]:
            self.assertTrue(contains_value(ev.evaluate(box(0,0,0,0),b),expected))
    def test_analytic_formula_grouping_vs_unfused(self):
        from independent_hurwitz import Evaluator
        for b in [1,2,3]:
            x=box('-1/8','-1/8','11','11')
            one=Evaluator(dps=35).evaluate(x,b)
            two=GroupedEvaluator(dps=35).evaluate(x,b)
            def intersects(a,c):return not (a.b < c.a or c.b < a.a)
            self.assertTrue(intersects(one.real,two.real) and intersects(one.imag,two.imag))
    def test_taylor_enclosure_contains_pointwise(self):
        ev=TaylorEvaluator(dps=35)
        for b in (1,2,3):
            seg=box(Q(-1,8),Q(-1,8),Q(11),Q(89,8))
            mid=box(Q(-1,8),Q(-1,8),Q(177,16),Q(177,16))
            a=ev.tight(mid,seg,b);c=ev.evaluate(mid,b)
            def intersects(u,v):return not (u.b<v.a or v.b<u.a)
            self.assertTrue(intersects(a.real,c.real) and intersects(a.imag,c.imag))
if __name__=='__main__':unittest.main(verbosity=2)
