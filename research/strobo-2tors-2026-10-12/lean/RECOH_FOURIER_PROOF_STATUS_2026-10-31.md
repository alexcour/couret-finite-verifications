# RECOH — état vérifié et programme Fourier (31 octobre 2026)

## Mise à jour du 9 novembre 2026 — état actuel

Ce document conserve ci-dessous son constat historique daté. Les mentions « absent », « non réalisé », « non vérifié » et les obligations décrivent cet état ancien, pas la tête actuelle. Les anciennes mentions « privé » / « confidentiel » sont des qualifications historiques : la copie présente est dans un dépôt public et ne contient que les références et constats techniques déjà exposés ; elles ne garantissent aucune restriction d'accès.

PR99 a été fusionnée dans la branche de recherche PR96 à `bc279e1341e28f58c23dd0df816ebebe48f083ff`. Son arbre est identique à celui de `bee966c1445c382ccd189e61adc42b8311b2f369`, certifié par [CI42523378906](https://github.com/alexcour/couret-finite-verifications/actions/runs/42523378906) : 37 modules, 23 racines, axiomes propext/Classical.choice/Quot.sound, rejet attendu du budget fixe faux et neuf dépendances verrouillées. Les douze runs post-fusion réussis sont distincts de cet audit complet antérieur.

Les modules historiques nécessaires sont intégrés ; la collision de noms est résolue par `RecohFourierCovarianceBridge`. Les commentaires historiques « not compiled » ou « obligation restante » dans les sources inchangées doivent être lus au niveau du module : la fermeture unifiée fournit désormais constructions primaires, non-annulation, bornes et raccord Fourier. Le lemme générique à deux orbites conserve ses hypothèses. Aucun théorème général de séparation de supports arbitraires n'est ajouté.

Les optimums restent distincts : banque fixe = 0 si r=0, sinon r+s ; sélection depuis le carré ordonné étiqueté complet = 0 si r=0, sinon r+min(1,s). Groupe abélien fini, supports de cardinal trois, |G[2]|=2^r, |G[3]|=3^s ; domaine non vide pour les optimums globaux. La sélection abstraite utilise le choix classique.

Les corrections de CI du 9 novembre permettent le contrôle complet sur push de la branche PR96 et de main, ainsi que sur les PR touchant la fermeture. Le checkout complet de PR est le SHA d'intégration synthétique github.sha ; celui du workflow ciblé d'orbites reste le SHA de tête. Chaque reçu doit être rattaché à son checkout exact ; la réussite de ces nouvelles exécutions n'est pas présumée par cette note.

Les 1 874 cas du sélecteur PR60 restent historiques, non rejoués. Pas de garantie générale JSON/Python–Lean, de robustesse au bruit, de complexité binaire totale, d'application FCI ni de nouveauté établie. PR96 reste en brouillon sous HOLD ; fusion vers main et publication nécessitent une autorisation distincte. RHClaimed=false ; HilbertPolyaClaimed=false ; EngineeringVerdictClaimed=false.

---

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
