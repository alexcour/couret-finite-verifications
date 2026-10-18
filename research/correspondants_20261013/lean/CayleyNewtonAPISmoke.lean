import CayleyTwoColourThirdFactor
import Mathlib.LinearAlgebra.Matrix.Charpoly.Eigs
import Mathlib.RingTheory.MvPolynomial.Symmetric.NewtonIdentities
import Mathlib.LinearAlgebra.Matrix.Charpoly.Coeff

/-!
COU-20 — pinned Mathlib Newton API smoke test, NOT a proof of
SatisfiesMatrixNewton.

The current theorem still needs a bridge:
 * trace of power A^k ↔ kth power-sum of roots of charpoly A
 * signed charpoly coefficients ↔ elementary symmetric sums of roots
 * transport NewtonIdentities.psum_eq_mul_esymm_sub_sum through these.

This is intentionally separate from the five already certified modules.
It checks the actual Mathlib declarations used in this proposed route.
It contains NO axioms, sorry, admission, or hidden premises.
-/

#check Matrix.trace_eq_sum_roots_charpoly_of_splits
#check Matrix.trace_eq_neg_charpoly_coeff
#check Matrix.charpolyRev
#check Matrix.coeff_det_one_add_X_smul_one
#check Matrix.derivative_det_one_add_X_smul
#check MvPolynomial.psum_eq_mul_esymm_sub_sum
#check MvPolynomial.mul_esymm_eq_sum
