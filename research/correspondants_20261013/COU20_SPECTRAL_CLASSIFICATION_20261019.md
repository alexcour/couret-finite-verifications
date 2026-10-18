# COU-20 — nécessité spectrale et classification des supports triples orientés

Date de rédaction : 19 octobre 2026, heure de Paris (18 octobre UTC).
Source d’intégration : **0ed4fea806063c0ffba52fc8b1d15681cfe5ee8e**.
PR : [#49](https://github.com/alexcour/couret-finite-verifications/pull/49).
Suivi : [COU-20](https://linear.app/couret/issue/COU-20/deux-couleurs-formaliser-la-dichotomie-abelienne-candidat).

**Statut de validation de la chaîne complète : SUCCÈS.**
Compilation locale complète, compilation GitHub du commit source exact et
cinq workflows associés à la PR réussis. Les journaux et reçus ont été
examinés : **139 sorties axiomatiques**, les **20 nouveaux théorèmes publics**
couverts, **dix sources antérieures inchangées**, aucun `sorryAx` ni axiome
supplémentaire dans les dépendances contrôlées. Voir les reçus en section 7.

## 1. Énoncé exact ajouté

Soit G un groupe abélien fini. Posons H = ⟨h⟩, Q = G/H,
S = {a, a+d, a+d+h} et T = {a, a−d, a−d+h}.
Les supports sont les Finset existants, et A_S, A_T leurs matrices
d’adjacence rationnelles **orientées, avec leurs boucles**.

Sous les hypothèses :

- h+h=0 et h≠0 ;
- la classe de d dans Q a ordre additif exactement trois ;
- la clôture additive de {a,d,h} est G ;

le nouveau théorème `abelianThree_spectral_equivalence` énonce :

χ(A_S)=χ(A_T) ⇔ (⟨a,h⟩≠G ou Even(|Q|)).

La nécessité est également donnée séparément par
`abelianThree_spectral_necessity`. Cette seule direction ne requiert
pas la génération par {a,d,h} : si ⟨a,h⟩ est propre, la conclusion
est immédiate ; sinon cette paire engendre déjà G.
La génération globale reste explicitement présente dans l’équivalence,
car elle sert au sens suffisant.

Aucune condition de symétrie, de diagonalisabilité ou d’absence de boucle
n’a été ajoutée. Cet énoncé concerne précisément les deux supports affichés ;
il ne classifie pas toutes les paires de supports arbitraires.

## 2. Témoin impair : réutilisation des preuves existantes

La PR #49 était restée au certificat de suffisance
`b9c38ecdcb78c3e24ae5e6315fe8262b2a3568b3`.
La branche expérimentale contenait déjà une étape ultérieure vérifiée :
`868648f6daaf2df18b7dbd434ebda065901f20f6`, workflow
[39167835577](https://github.com/alexcour/couret-finite-verifications/actions/runs/39167835577),
job [117794430026](https://github.com/alexcour/couret-finite-verifications/actions/runs/39167835577/job/117794430026).
Son journal comporte les **34 contrôles axiomatiques** des cinq modules
de recherche, sans `sorryAx` ni axiome hors de l’ensemble standard autorisé.
Les anciennes notes « non compilé » ne décrivaient donc plus ce commit.

Ces résultats sont réutilisés intégralement. Dans la branche
⟨a,h⟩=G avec |Q| impair, ils construisent un retour à ±d dans le quotient.
Le nouveau diagnostic
`abelianThree_first_trace_difference_at_quotient_third`
assemble leur forme canonique :

- k = |Q|/3 est un entier naturel strictement positif et impair ;
- pour tout j<k, tr(A_S^j)=tr(A_T^j) ;
- au degré k, tr(A_S^k)≠tr(A_T^k).

Il s’appuie sur les preuves de facteur trois, de retour canonique et
d’absence de retour antérieur. La formule exacte des traces impaires et
`abelianThree_odd_trace_ne_iff` ne sont pas redémontrés.

Avec α=a+H, δ=d+H et k=2n+1, la formule existante est :

tr(A_S^k)−tr(A_T^k)
= |G|(−3)^n (1_[kα=−δ]−1_[kα=δ]).

L’ordre exact trois garantit que les deux tests ne peuvent être vrais
simultanément. Le retour impair donne donc un désaccord effectif des traces.

## 3. Pont matriciel général effectivement construit

Le module `PolynomialJacobi.lean` établit la formule algébrique
de Jacobi pour une matrice M de polynômes :

(det M)' = tr(M' adj(M)).

La preuve utilise le développement du déterminant par permutations,
la dérivation des produits finis et les lemmes Mathlib sur Cramer et l’adjugée.
Elle ne suppose pas M inversible.

Le module `CayleyCharpolyTrace.lean` applique cette formule à I−XA.
Il utilise le polynôme renversé p_A(X)=det(I−XA), déjà défini dans Mathlib,
et les coefficients matriciels q_k de adj(I−XA). Il obtient :

q_0=I ;
q_(k+1)=A q_k + [X^(k+1)]p_A · I ;

p_A'(X)=−tr(A adj(I−XA)).

L’extraction des coefficients fournit une récurrence sur les traces.
Une récurrence forte prouve le théorème général :

```lean
Couret.CharpolyTrace.trace_pow_eq_of_charpoly_eq
    {R : Type*} [CommRing R]
    {i : Type*} [Fintype i] [DecidableEq i]
    (A B : Matrix i i R)
    (hp : A.charpoly = B.charpoly)
    (k : ℕ) :
    Matrix.trace (A ^ k) = Matrix.trace (B ^ k)
```

Aucune hypothèse de Jacobi ou de Newton ne subsiste dans cette signature.
La preuve n’effectue pas de division par k ; elle vaut donc sur tout
anneau commutatif, en toute caractéristique. Le type d’indices est le même
pour A et B et peut être vide.

## 4. Fermeture de l’obligation Newton déjà formulée

Le module `CayleyTwoColourMatrixNewton.lean` importe le module
Newton existant sans le modifier et ajoute trois résultats :

1. `reverseCharpolyCoeff_eq_charpolyRev` identifie sa définition
   des coefficients avec les coefficients du polynôme renversé ;
2. `satisfiesMatrixNewton` prouve que toute matrice carrée
   rationnelle satisfait exactement la récurrence `SatisfiesMatrixNewton` ;
3. `trace_pow_eq_of_charpoly_eq_via_newton` réutilise la preuve
   existante d’unicité de la récurrence avec ses hypothèses désormais établies.

La nécessité dans le module final utilise ce raccord. Les signatures
historiques conditionnelles restent intactes ; leurs obligations matricielles
disposent maintenant de preuves fournies par ce nouveau module.

Le module final ajoute aussi
`abelianThree_noncospectral_of_generated_odd_quotient`,
par contradiction directe entre le témoin impair et le pont général.

## 5. Conservation et contrôle de la chaîne de preuve

Les dix modules Lean déjà certifiés sont inchangés :

Core, Family, Abelian, Spectral, Parity, Necessity, Newton,
FirstReturn, CanonicalReturn et ThirdFactor.

Le fichier `tests/cou20-certified-sources.json` conserve leurs
identifiants de blobs Git. Le vérificateur compare chaque source à ces
empreintes avant de produire le reçu.

Les ajouts concurrents jusqu’au commit
`501affda673ca10b9a03e839569a68e9494ecdc2` sont préservés, dont le
contrôle axiomatique des 34 résultats de recherche et le test de disponibilité
des API Mathlib. Ce dernier demeure un test d’API, sans être présenté comme
une démonstration du pont.

La chaîne complète compile quinze modules, dont ce test d’API et les
quatre nouveaux modules de preuve. Elle contrôle toutes les sorties
axiomatiques observées et exige une sortie pour chacun des **20 nouveaux
théorèmes publics**. Seuls `propext`, `Classical.choice` et `Quot.sound`
sont acceptés ; une sortie absente ou un axiome supplémentaire fait échouer
le contrôle. Les sources, le journal et le manifeste des dépendances sont
reliés par des empreintes dans le reçu.

Environnement épinglé :

- Lean 4.29.1, commit f72c35b3f637c8c6571d353742168ab66cc22c00 ;
- Mathlib v4.29.1, commit 5e932f97dd25535344f80f9dd8da3aab83df0fe6 ;
- dépendances transitives consignées dans `lean/lake-manifest.json`.

Commande reproductible, avec elan/lake disponible :

```bash
bash research/correspondants_20261013/tests/verify_cou20_necessity.sh
```

## 6. Vérifications exactes complémentaires

Les programmes existants ont été rejoués avec Python et SymPy 1.14.0 :

| Contrôle | Résultat observé |
|---|---|
| Cas ciblés admissibles | 14 réussites |
| Contre-exemple sans génération globale | Retrouvé |
| Récurrences matricielles exactes | 4 cas, jusqu’aux exposants 10, 16, 22 et 22 |
| Parcours fini | 1 224 configurations dans 16 familles |
| Configurations cospectrales | 1 048 |
| Quotient impair avec premier désaccord | 176 |
| Vérifications directes supplémentaires par SymPy | 10 |
| Configurations comprenant des boucles | 20 |

Ces calculs servent de régression indépendante sur les conventions et les
exemples. Les conclusions universelles proviennent des preuves Lean.

## 7. Reçus effectifs d’intégration

Les attestations suivantes portent sur le code du commit source
`0ed4fea806063c0ffba52fc8b1d15681cfe5ee8e`. Ce rapport et l’archive des
reçus sont ajoutés ensuite, sans modification des sources Lean.

| Vérification | Révision effectivement compilée | Résultat |
|---|---|---|
| Chaîne locale complète, quinze modules | `0ed4fea806063c0ffba52fc8b1d15681cfe5ee8e` | SUCCÈS, code de sortie 0 |
| [CI directe 39171035697](https://github.com/alexcour/couret-finite-verifications/actions/runs/39171035697), [job 117803947726](https://github.com/alexcour/couret-finite-verifications/actions/runs/39171035697/job/117803947726) | `0ed4fea806063c0ffba52fc8b1d15681cfe5ee8e` | SUCCÈS |
| [CI Lean de PR 39171039890](https://github.com/alexcour/couret-finite-verifications/actions/runs/39171039890) | Fusion de test GitHub `7277ba41370f9f755dca7fa5934e8a846603e8c1` | SUCCÈS |
| [Family 39171039882](https://github.com/alexcour/couret-finite-verifications/actions/runs/39171039882) | CI associée à la PR | SUCCÈS |
| [Doublet 39171039868](https://github.com/alexcour/couret-finite-verifications/actions/runs/39171039868) | CI associée à la PR | SUCCÈS |
| [Triple-square exact 39171039937](https://github.com/alexcour/couret-finite-verifications/actions/runs/39171039937) | CI associée à la PR | SUCCÈS |
| [Verify 39171040017](https://github.com/alexcour/couret-finite-verifications/actions/runs/39171040017) | CI associée à la PR | SUCCÈS |

La fusion de test est produite automatiquement par GitHub pour son contrôle
de PR ; la PR elle-même n’est pas fusionnée. La CI directe fournit séparément
le certificat du commit source exact.

Le reçu CI est extrait de l’artefact
`cou20-spectral-classification-audit`, identifiant `12152244147`, dont
l’archive ZIP téléchargée a l’empreinte SHA-256
`2593c38ea6ef589c10f3876db8914ec45f557c21d52209dd98811b4b6b0d8613`.
Le journal Lean de cet artefact a l’empreinte
`987335fabe643d33b5f37ede7490b24f68a898fc87dabbc8b4a2ab1daad39585`,
conforme au reçu. Les empreintes des quatorze sources de preuve et du
manifeste des dépendances ont été comparées aux fichiers locaux.

Les reçus local et CI donnent la même table des axiomes et les mêmes
empreintes des sources et des dépendances. Chaque théorème final affiche
`[propext, Classical.choice, Quot.sound]`. Le contrôle historique des
34 théorèmes de recherche réussit lui aussi dans la chaîne complète.

Archives conservées avec ce rapport :

- [Reçu CI](evidence/20261019_spectral_classification/ci-receipt.json),
  [journal Lean CI](evidence/20261019_spectral_classification/ci-lean.log)
  et [journal du job direct](evidence/20261019_spectral_classification/ci-job.log).
- [Reçu local](evidence/20261019_spectral_classification/local-receipt.json)
  et [journal Lean local](evidence/20261019_spectral_classification/local-lean.log).
- [Provenance des exécutions CI](evidence/20261019_spectral_classification/verification-summary.json)
  et [reçu des régressions exactes](evidence/20261019_spectral_classification/exact-regression-receipt.json).

Le run de recherche `39170848551`, annulé avant compilation lors d’un
nouveau push concurrent sur la branche expérimentale, n’est pas utilisé
comme certificat. Les succès directs et de PR ci-dessus sont les contrôles
d’intégration effectifs.

## 8. Portée et obligations distinctes

La réciproque formelle et l’équivalence portent sur le cadre exact énoncé
en section 1. La chaîne complète importe et vérifie toutes les preuves
dans ce cadre. Les deux obligations Lean demandées — témoin impair et
passage du polynôme caractéristique aux traces — sont closes sous ces
hypothèses. Les compilations isolées initiales ne sont pas utilisées
à la place des reçus complets ci-dessus.

Restent distincts du certificat Lean :

- une relecture mathématique humaine indépendante ;
- l’audit d’antériorité et les travaux de Gate C ;
- toute extension à d’autres supports ou aux graphes simples non orientés.

La PR #49 reste **ouverte et en brouillon**. Aucune fusion dans main,
publication, release ou revendication de nouveauté scientifique n’est effectuée.

