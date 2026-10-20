import Lake
open Lake DSL
package cayleyDoublet where
require mathlib from git
  "https://github.com/leanprover-community/mathlib4.git" @ "v4.29.1"
@[default_target]
lean_lib CayleyDoublet where
  roots := #[`CayleyDoubletCore, `CayleyTwoColourFamily, `CayleyTwoColourAbelian, `CayleyTwoColourSpectral]
