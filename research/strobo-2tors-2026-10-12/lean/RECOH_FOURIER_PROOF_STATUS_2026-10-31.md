# RECOH — état vérifié et programme Fourier (31 octobre 2026)

Suivi canonique : [Linear COU-107](https://linear.app/couret/issue/COU-107) · [PR privée #96](https://github.com/alexcour/couret-finite-verifications/pull/96).

## Résultats certifiés par CI Lean 4 / mathlib 4.29.1

| Théorème | SHA exact de branche vérifié | Journal GitHub Actions |
|---|---|---|
| `recoh_squareFibre_union_at_most_two_orbits` | `0f3c281241119633f108ac940a14ee927bcbc40c` | [run 41048645994](https://github.com/alexcour/couret-finite-verifications/actions/runs/41048645994) |
| `recoh_orbit_translation_separated` | `9c194b00dce2ab51728cc212b5122ee24fe6de7e` | [run 41074806987](https://github.com/alexcour/couret-finite-verifications/actions/runs/41074806987) |
| `recoh_two_orbits_separated` | `f96a1031efec7d58d8792eedc1b497a8093dd7c7` | [run 41086824953](https://github.com/alexcour/couret-finite-verifications/actions/runs/41086824953) |

`#print axioms` : `propext`, `Classical.choice`, `Quot.sound` ; pas de `sorryAx` pour ces trois énoncés.

## Frontière scientifique

Le raccord STROBO classe les fibres triples en au plus deux orbites de translation par la 2-torsion. Les deux lemmes de séparation utilisent des hypothèses explicites : caractères initiaux séparant la 2-torsion, covariance et non-annulation des sondes, sonde supplémentaire distinguant les représentants. Ces hypothèses ne sont PAS encore toutes construites dans la PR #96.

Le résultat `C(C₂^r × C₃^s)=r+1` (r,s≥1) **n'est pas encore formellement certifié dans cette PR**. Ne pas confondre avec les résultats et certificats historiques de COU-26 / COU-27 ; effectuer une réconciliation des énoncés exacts avant revendication.

## Obligations prioritaires

1. Énoncé Fourier sur supports finis : `S ≠ T → ∃ χ, Fχ(S) ≠ Fχ(T)`, avec les caractères effectifs et non une hypothèse de séparation.
2. Covariance de `Fχ` sous translation et non-annulation des r sondes signées sur supports triples.
3. Construction des r caractères séparant `G[2]` pour `G=C₂^r×C₃^s`, puis banque conditionnelle r+1 sur chaque fibre.
4. Borne inférieure sur une fibre exceptionnelle de cardinal 2^(r+1), puis théorème d'optimalité.
5. CI verte avec SHA exact, `#print axioms` et énoncés lisibles ; aucune fusion, release ou publication sans autorisation.

**Confidentiel — dépôt privé, PR draft.**
