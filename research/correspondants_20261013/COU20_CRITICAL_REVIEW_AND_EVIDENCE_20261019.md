# COU-20 — Consolidation probatoire et pré-rapport critique

**État au 19 octobre 2026, heure de Paris.** Dossier privé de recherche. **Ne pas fusionner, publier ou présenter comme expertise indépendante.**

## 1. Décision de statut : preuve Lean vs nouveauté scientifique

**Formellement certifié par GitHub Actions :**

- Dépôt : `alexcour/couret-finite-verifications`.
- Branche de recherche séparée : `research/cou20-spectral-necessity-20261018`.
- Commit exact du raffinement : `a191ddfa47184d5cb70f60299d478e61a36181ff`.
- Workflow scientifique réussi : [run #39201978017](https://github.com/alexcour/couret-finite-verifications/actions/runs/39201978017), job `117897359762`, **19/10/2026**.
- Journal : `SUCCESS: 142 axiom outputs checked; all 22 new public theorems covered; 10 certified source files unchanged`.
- Théorèmes de classification : `Couret.CayleyDoublet.abelianThree_spectral_necessity` et `abelianThree_spectral_equivalence`.
- Pont général de matrices : `Couret.CharpolyTrace.trace_pow_eq_of_charpoly_eq` ; récurrence rationnelle : `Couret.CayleyNewton.satisfiesMatrixNewton`.
- Premier degré discriminant : `Couret.CayleyDoublet.abelianThree_first_reverse_coefficient_difference`, et passerelle générique `Couret.CayleyNewton.first_reverse_coefficient_gap_of_first_trace_difference`.
- Axiomes Lean observés : `propext`, `Classical.choice`, `Quot.sound` ; **aucun `sorryAx`** dans les déclarations contrôlées. Pas d'axiome expérimental supplémentaire.
- Les 10 sources historiques figées sont contrôlées par blob SHA-1 dans `tests/cou20-certified-sources.json`; leur conservation est attestée par le script d'audit qui s'est terminé avec succès.

**Ce qui n'est PAS certifié par ce certificat :** adéquation mathématique aux définitions qu'un lecteur externe pourrait préférer, nouveauté vis-à-vis de la littérature, qualité rédactionnelle d'un article, indépendance de la relecture, ni la valeur d'une éventuelle revendication de priorité.

## 2. Énoncé exact — périmètre des résultats

Soit un **groupe abélien fini** `G`, muni de `a,d,h∈G`. Poser `H=⟨h⟩`, `Q=G/H`, `δ=d+H`. Exiger :
1. `h+h=0`, **`h≠0`** ;
2. `ord(δ)=3` dans `Q` ;
3. **pour l'équivalence complète**, `⟨a,d,h⟩=G`.

On travaille sur les **supports ensemblistes** `S={a,a+d,a+d+h}` et `T={a,a-d,a-d+h}`. Les matrices `A_S,A_T` sont les matrices d'adjacence **rationnelles des graphes orientés**. Les boucles restent autorisées. En particulier, ne pas remplacer les supports par des multisets de translations, ni les matrices par celles de graphes symétrisés.

Théorème certifié :

```
charpoly(A_S)=charpoly(A_T)
    ↔ (⟨a,h⟩ ≠ G ∨ Even(|Q|)).
```

La nécessité seule est prouvée sans prémisse de génération globale `⟨a,d,h⟩=G`. Ne pas retirer cette prémisse de la suffisance.

Raffinement dans la branche `⟨a,h⟩=G` et `|Q|` impair : poser `ℓ=|Q|/3`. `ℓ` est un naturel strictement positif et impair. Les traces de `A_S^j`, `A_T^j` sont égales pour `j<ℓ`, puis différentes pour `j=ℓ`. Les coefficients **inversés** des polynômes caractéristiques ont le même premier indice de divergence. Les déclarations du fichier `CayleyTwoColourFirstCoefficient.lean` établissent l'égalité des indices précédents et la non-égalité à `ℓ`.

**Attention à une affirmation plus forte** : la formule proposée
`|c_ℓ(S)-c_ℓ(T)|=6·3^((ℓ-1)/2)` est compatible avec l'argument des traces et les tests exacts, mais ne doit pas être décrite comme un nouveau **théorème Lean de valeur absolue** à moins d'en fournir un énoncé formalisé et son certificat.

## 3. Piste de preuve indépendante pour la relecture mathématique

L'approche Lean utilise deux mécanismes complémentaires :
- **Groupe/retours** : le quotient est cyclique lorsque `⟨a,h⟩=G`. Si `|Q|=3ℓ` impair, l'ordre exact 3 de `δ` impose `ℓ\bar a=±δ`, mais aucun `j\bar a` avec `0<j<ℓ` ne peut atteindre `±δ`. Le critère exact de traces impaires produit la différence au premier degré.
- **Matrice/Jacobi** : un argument algébrique sur la dérivée du déterminant de `1-XA`, son adjugée et ses coefficients donne les identités de Newton puis `charpoly(A)=charpoly(B)⇒tr(A^k)=tr(B^k)` pour tout `k`. Pas de diagonalisation requise.

**Audit externe demandé** : refaire ces deux arguments sans lire les scripts de preuve, puis comparer l'énoncé reconstruit aux termes Lean. Cela constitue une vérification d'adéquation (la compilation ne peut pas garantir que les définitions correspondent aux objets scientifiques attendus).

## 4. Contre-exemples et tests falsifiants à préserver

- Sans `⟨a,d,h⟩=G`, la suffisance ne doit pas être extrapolée. Exemple documenté : `G=ℤ/6×ℤ/2`, `a=d=(1,0)`, `h=(3,0)`. Malgré `|Q|` pair et `⟨a,h⟩≠G`, les matrices ne sont pas cospectrales ; `tr(A_S)=0`, `tr(A_T)=12` car la seconde possède une boucle par sommet.
- Vérifier en revue les conséquences de retirer séparément : `h≠0`, `2h=0`, `ord(δ)=3`, abélianité, finitude, génération globale. Ne généraliser aucune conclusion à ces cadres sans nouvel énoncé/preuve.
- Vérifier explicitement la convention arc `x→x+s` ou `x→x-s` : l'orientation doit rester identique dans toute la comparaison.
- L'essai reproductible `tests/cou20_exhaustive_small.py` énumère **1 224 configurations** admissibles sur 16 présentations finies ; 176 branches de quotient impair discriminant, 432 de quotient pair, 616 de non-génération du couple, 20 configurations avec boucles et 10 contrôles directs SymPy. Les comptes sont ceux du **test fini**, et non d'une exhaustion de tous les groupes.
- Comparer `Finset` à `multiset` et tester les collisions de générateurs possibles après relâchement des hypothèses ; elles pourraient modifier les matrices, pas seulement les preuves.

## 5. Veille d'antériorité — repères vérifiés, MAIS couverture incomplète

| Source publique | Ce qu'elle couvre | Différence avec COU-20 |
| --- | --- | --- |
| Ducey & Jalil (2013/2014), « Integer invariants of abelian Cayley graphs », arXiv:1308.2335, LAA | Spectres et invariants associés à des graphes de Cayley **orientés** sur groupes abéliens | Ne semble pas annoncer la dichotomie exacte des deux supports triples `S,T` |
| Yang & Tang (2017), « Representation functions on finite sets with extreme symmetric differences », J. Number Theory 180, DOI:10.1016/j.jnt.2017.03.024 | Égalité de fonctions de représentations additives dans des groupes cycliques | Les sommes ordonnées contrôlent les puissances de convolution, mais la classification spectrale exacte ici n'est pas démontrée identique |
| Alaeiyan & Mirzajani (2013), « Non-normal edge-transitive directed Cayley graphs of abelian groups » | Graphes dirigés abéliens de valence au plus 3 ; **transitivité d'arêtes** | Propriété distincte de la cospectralité et de son premier coefficient discriminant |
| Li, Praeger & Xu (1998), « Isomorphisms of Finite Cayley Digraphs of Bounded Valency », JCTB 73, DOI:10.1006/jctb.1998.1820 | Isomorphismes/CI des digraphes de Cayley de petite valence | Isomorphisme ≠ cospectralité ; éventuels arguments structurels à inspecter |
| Bhattacharjee, Mandal & Bhattacharya (2026), « Spectral Algebras of Abelian Cayley Graphs », arXiv:2609.09222 | Algèbres spectrales via caractères, pour ensembles **symétriques** sans 0 dans l'énoncé consulté | Notre cas est orienté, éventuellement avec boucles : recouvrement de méthodes, non identité d'énoncé |

Sources consultées : 
- https://arxiv.org/abs/1308.2335
- https://doi.org/10.1016/j.jnt.2017.03.024
- https://link.springer.com/article/10.1186/2251-7456-7-7
- https://doi.org/10.1006/jctb.1998.1820
- https://arxiv.org/abs/2609.09222

**Conclusion provisoire** : aucune des notices et portions consultées n'a démontré l'antériorité exacte du critère COU-20 ; mais cette absence n'est **pas** la preuve de nouveauté. Faire rechercher davantage dans les classifications de graphes dirigés cospectraux de valence trois, les circulants, les revêtements, les sommes de caractères, les graphes à même carré d'adjacence et les articles citant les sources précédentes. Ne pas confondre nouveau théorème spécial, nouvelle preuve d'un résultat connu, et première formalisation Lean d'une identité classique.

## 6. Conservation probatoire, échéances

- Artefact GitHub du run `39201978017` : `cou20-spectral-classification-audit`, id `12164611365`, **présent et non expiré** lors du contrôle.
- Empreinte de l'archive GitHub déclarée : `sha256:095f878ef98028442b83355c99e2c4a4bdec63c9b95d99118c7b069868fd4dd5`.
- Échéance de conservation GitHub : **2027-01-17T04:56:23Z**. Ne pas supposer la permanence sur GitHub. Conserver une copie immuable et une empreinte distinctes en stockage privé avant expiration, avec relecture et reçu vérifiable.
- Ancien artefact du run `39171086427` : id `12152169547`, expiration `2027-01-16T22:10:44Z`.

Dossier de prépublication à établir **seulement après revue indépendante** : PDF mathématique (définitions, théorèmes, lemmes, preuves), énoncés Lean avec commits, matrice d'hypothèses, résultats exacts, sources bibliographiques, limitation de nouveauté, annexe d'évidence. **Ce document interne ne crée aucun dépôt public ni droit de priorité.**

## 7. Avis préliminaire et suites

- **Certification Lean** : acquise au commit précis indiqué pour l'équivalence et le premier coefficient divergent.
- **Correspondance sémantique** : vérification documentaire détaillée préparée, relecture indépendante requise.
- **Antériorité exacte** : non établie ni exclue ; bibliographie initiale préparée, sans jugement d'originalité.
- **Piste mathématique supplémentaire** : preuve Lean de la valeur absolue exacte du premier écart caractéristique et étude des classes d'isomorphisme dans les branches cospectrales, à traiter comme nouvelles obligations séparées.
- **Décision de publication** : aucune. La PR #49 reste ouverte/draft ; ne pas la fusionner à ce stade.
