# RECOH — Nombre optimal de sondes après observation du carré

Date : 17 octobre 2026. Suivi : [COU-26](https://linear.app/couret/issue/COU-26/recoh-cout-optimal-des-sondes-choisies-apres-le-carre-observe).

Ce lot prolonge COU-25, dont le décodeur typé à banque universelle minimale est déjà terminé. Il précise ce que coûte le fait de choisir les caractères avant de connaître le carré observé. La base du lot est le commit `afef68f3c51dda613f749e90b5c992c4734e2c92` de la branche RECOH existante.

**État validé :** compilation intégrée et contrôles CI réussis sur la source `8b5e2dbedff59b3089c65fe70aff6b596ee392d3`. Les 325 déclarations publiques RECOH, dont 29 nouvelles, utilisent seulement `propext`, `Classical.choice` et `Quot.sound`. L’archive CI a été téléchargée, son SHA-256 vérifié et son certificat recalculé depuis les traces exactes. Voir les preuves de validation en section 9.

## 1. Cadre exact et résultat

Soit un groupe abélien fini $G$, avec $|G[2]|=2^r$ et $|G[3]|=3^s$. Un support est un ensemble $S\subseteq G$ de cardinal exactement trois ; zéro est autorisé. On observe le carré de convolution ordonné et étiqueté

$$R_S(z)=\#\{(x,y)\in S^2:x+y=z\}.$$

Les contributions diagonales sont incluses. Pour un caractère complexe $\chi$, une sonde fournit le coefficient exact et étiqueté

$$P_\chi(S)=\sum_{x\in S}\chi(x).$$

La fibre complète du carré est $F_R=\{T\subseteq G:|T|=3,\ R_T=R\}$. La classification STROBO donne $|F_R|=2^r$ pour une fibre ordinaire et $|F_R|=2^{r+1}$ pour une fibre exceptionnelle.

**Théorème par fibre.** Pour chaque carré réalisable, le nombre minimal de sondes complexes qui séparent sa fibre complète est exactement

$$b(F_R)=\log_2|F_R|=\begin{cases}r&\text{fibre ordinaire},\\r+1&\text{fibre exceptionnelle}.\end{cases}$$

Le minimum porte sur toutes les banques de caractères complexes, et pas seulement sur les banques primaires construites dans le majorant. Les sondes répétées et les coefficients nuls sont couverts par le minorant.

**Théorème de sélection après le carré.** Il existe une fonction de sélection commune à tous les supports $\sigma:R\mapsto(\chi_1,\ldots,\chi_B)$ telle que l'observation

$$S\longmapsto\left(R_S,\bigl(P_{\sigma(R_S)_i}(S)\bigr)_{i=1}^B\right)$$

soit injective sur tous les supports triples. Si $|G|\geq3$, le budget minimal dans le pire cas est

$$B_{\mathrm{après}\ R}(G)=\begin{cases}0&r=0,\\r+\min(1,s)&r>0.\end{cases}$$

La sélection reçoit uniquement $R$. Elle reste identique pour tous les supports de la même fibre. L'énoncé ne présuppose donc pas la connaissance du support que les sondes doivent reconstruire. La valeur de la sélection sur un carré non réalisable est arbitraire et n'affecte pas l'injectivité sur les supports admissibles.

Si $|G|<3$, le domaine est vide et zéro sonde suffit. Cette exception est séparée dans Lean : sans elle, la formule donnerait à tort une sonde pour $G=C_2$.

## 2. Coût du choix universel

Le théorème existant donne, pour une banque fixée à l'avance, $B_{\mathrm{fixe}}=0$ lorsque $r=0$, et $B_{\mathrm{fixe}}=r+s$ sinon, sur un domaine non vide. Les deux théorèmes utilisent le même modèle de carré et de coefficients.

| Régime | Banque fixée avant $R$ | Banque choisie après $R$, pire cas | Économie |
|---|---:|---:|---:|
| $r=0$ | 0 | 0 | 0 |
| $r>0$, $s=0$ | $r$ | $r$ | 0 |
| $r>0$, $s=1$ | $r+1$ | $r+1$ | 0 |
| $r>0$, $s\geq2$ | $r+s$ | $r+1$ | $s-1$ |

Le rang ternaire mesure le nombre de directions qu'une banque universelle doit couvrir simultanément. Une fois une fibre exceptionnelle déterminée, une seule direction ternaire doit être détectée. Même lorsque le pire cas ne s'améliore pas, une fibre ordinaire ne demande que $r$ sondes.

Cette économie concerne le nombre de mesures. Le lot ne donne pas encore de garantie de temps de calcul pour choisir la banque à partir d'une représentation des données.

## 3. Pourquoi le minorant est exact

La nouvelle identité de Fourier est prouvée à partir de la définition effective du carré :

$$P_\chi(S)^2=\sum_{z\in G}R_S(z)\chi(z).$$

Elle vaut pour tout support fini, indépendamment de sa cardinalité. Sur une fibre fixée, le carré algébrique de chaque coefficient est donc connu. Sur $\mathbb C$, tous ses représentants prennent au plus deux valeurs opposées ; si le coefficient est nul, ces deux possibilités coïncident.

Une banque de $k$ sondes peut produire au plus $2^k$ vecteurs de réponses sur cette fibre. Une banque qui la sépare impose donc $|F_R|\leq2^k$. Lean formalise une injection de la fibre dans `Fin k → Bool`. Il n'est pas nécessaire de choisir une racine carrée complexe ou de supposer les coefficients non nuls.

Le minorant global après $R$ se déduit ensuite d'une fibre appropriée. En présence de 2-torsion et de 3-torsion non triviales, le majorant structurel fournit également un support exceptionnel effectif, dont la fibre comporte $2^{r+1}$ éléments. En l'absence de 3-torsion, l'orbite de translations par $G[2]$ de n'importe quel support triple suffit pour imposer $r$ mesures.

## 4. Construction qui atteint la borne

### Fibre ordinaire

La fibre ordinaire est exactement l'orbite d'un support sous les translations de $G[2]$. Les $r$ caractères 2-primaires déjà construits séparent cette torsion. Leurs coefficients sur un support de cardinal impair sont non nuls, grâce au lemme RECOH existant. L'égalité des réponses détermine alors la translation, donc le support.

### Fibre exceptionnelle

La forme normale exhibe deux orbites, représentées par les supports paramétrés avec une direction $v$ d'ordre trois non nulle et avec $-v$. Les $r$ sondes 2-primaires séparent chaque orbite. Un seul caractère 3-primaire choisi pour vérifier $\chi(v)\ne1$ distingue les deux orbites ; il est trivial sur $G[2]$, donc son coefficient est constant sur chacune d'elles.

La banque obtenue est fixe sur l'union entière des deux orbites. On ne choisit pas un caractère séparant une paire de supports après avoir identifié cette paire : le même caractère sépare les deux classes complètes.

### Une règle portant seulement sur le carré

Pour chaque $R$ réalisable, la preuve choisit un représentant, puis une banque qui sépare toute la fibre. Le choix est ensuite regroupé en une fonction de $R$. Le représentant est un outil de preuve pour construire la fonction ; il ne figure pas parmi les entrées de l'observation finale. Le théorème inverse montre qu'une règle reconstruisant tous les supports induit nécessairement une banque séparatrice sur chaque fibre. Les deux sens utilisent donc les mêmes quantificateurs.

## 5. Implantation formelle et dépendances

| Module | Déclarations publiques ajoutées | Contenu |
|---|---:|---|
| [RecohSquareFourier.lean](lean/RecohSquareFourier.lean) | 3 | Identité effective de Fourier et dichotomie des réponses |
| [RecohFibreLower.lean](lean/RecohFibreLower.lean) | 4 | Injection binaire, minorants, raccord des deux représentations de la torsion |
| [RecohFibreUpper.lean](lean/RecohFibreUpper.lean) | 8 | Séparation des orbites, caractère ternaire ciblé, majorants, existence d'une fibre exceptionnelle |
| [RecohFibreOptimal.lean](lean/RecohFibreOptimal.lean) | 14 | Budgets exacts, sélection dépendant de $R$, optimalité, domaine vide, comparaison des modèles |

Les déclarations principales sont `recoh_optimal_fibre_bank_size` et `recoh_optimal_after_square_bank_size`. L'inventaire RECOH passe de 296 à 325 déclarations publiques et le projet intégré de 69 à 73 racines Lean. La chaîne conserve Lean 4.29.1 et la révision Mathlib épinglée par le manifeste existant.

Le contrôle consolidé couvre les 325 déclarations publiques avec des traces fraîches. Les seules dépendances logiques admises par le vérificateur restent `propext`, `Classical.choice` et `Quot.sound`. Le contrôle des marqueurs de preuve incomplets reste actif. Aucun statut de validation n'est déduit du seul décompte de déclarations.

## 6. Vérifications finies reproductibles

[verify_recoh_fibre_20261017.py](verify_recoh_fibre_20261017.py) énumère volontairement les supports et les fibres de petits groupes. Les résultats déterministes sont conservés dans [recoh_fibre_results_20261017.json](recoh_fibre_results_20261017.json).

Le contrôle a réussi sur **24 présentations de groupes, 30 327 supports et 12 047 fibres**. Le compte porte sur des présentations : plusieurs d'entre elles peuvent représenter des groupes isomorphes. Les cas incluent le groupe trivial, $C_2$, la torsion purement impaire, plusieurs rangs binaires et ternaires, ainsi que les facteurs cycliques 8, 9, 16, 18, 24 et 36.

| Groupe | Supports | Fibres ordinaires | Fibres exceptionnelles | Minimum fixe | Minimum après $R$, pire cas |
|---|---:|---:|---:|---:|---:|
| $C_3$ | 1 | 1 | 0 | 0 | 0 |
| $C_4$ | 4 | 2 | 0 | 1 | 1 |
| $C_6$ | 20 | 4 | 3 | 2 | 2 |
| $C_2^2\times C_3$ | 220 | 37 | 9 | 3 | 3 |
| $C_2\times C_3^2$ | 816 | 336 | 36 | 3 | 2 |
| $C_6^2$ | 7 140 | 1 569 | 108 | 4 | 3 |
| $C_2^3\times C_3$ | 2 024 | 211 | 21 | 4 | 4 |

Sur chaque fibre, le programme vérifie l'injectivité de la banque, l'égalité $2^{\text{nombre de sondes}}=|F_R|$, la dichotomie des réponses et l'injectivité d'une règle commune indexée par le carré. Le choix ternaire est recherché parmi les caractères de la banque primaire existante.

Un second calcul sur $C_2\times C_3^2$ représente indépendamment **tous les 18 caractères complexes** dans $\mathbb Z[\zeta_6]$, avec $\zeta_6^2=\zeta_6-1$. Il vérifie les carrés des réponses, les minima locaux et toutes les banques de zéro, une et deux sondes distinctes. Les **153 banques de deux caractères** échouent globalement ; une banque de trois caractères réussit. Les répétitions ne pouvant améliorer la séparation, la recherche couvre aussi les budgets avec répétitions. Le champ des rejets de taille trois compte seulement les essais avant le premier succès, pas toutes les banques de taille trois.

Ces calculs constituent un contrôle fini complémentaire. Ils ne remplacent pas la preuve universelle et ne constituent pas une extraction du code Lean.

## 7. Reproduction

Depuis ce dossier :

```bash
python3 verify_recoh_fibre_20261017.py --check
python3 verify_recoh_axioms_20261017.py
cd lean
lake resolve-deps
lake exe cache get
lake build
lake env lean RecohConsolidated.lean > recoh-axioms.log
python3 ../verify_recoh_axioms_20261017.py --log recoh-axioms.log --source-commit "$(git rev-parse HEAD)"
```

Le workflow intégré ajoute la reproduction des fibres, conserve la compilation de tous les anciens modules et le rejeu différentiel du décodeur typé. Le rapport d'axiomes doit être relié au commit source effectivement compilé ; un simple inventaire Python ne suffit pas à le certifier.

## 8. Limites et prochains problèmes précis

**Sélection exécutable.** L'étape la plus courte consiste, sur un produit de groupes cycliques et pour une direction ternaire connue $v$, à parcourir les coordonnées et choisir la première coordonnée non nulle d'ordre divisant trois. Les lemmes de coordonnées déjà disponibles devraient permettre de prouver que le caractère associé détecte $v$ et reste trivial sur $G[2]$. Il resterait ensuite à extraire cette direction depuis le carré vérifié et à raccorder la banque au décodeur typé. Le présent lot n'annonce aucune complexité d'un tel algorithme complet.

**Arbres adaptatifs.** La dichotomie des réponses suggère un minorant identique pour un arbre de profondeur $k$, car chaque nœud possède au plus deux branches réalisables sur une fibre fixée. Ce raisonnement n'est pas encore un théorème Lean de ce lot. Un prolongement devra définir explicitement le modèle de requêtes et les transcriptions, puis prouver la borne de feuilles.

**Mesures bruitées ou incomplètes.** La preuve repose sur des égalités exactes de coefficients complexes et sur le carré complet étiqueté. Elle ne fournit pas de rayon de robustesse, de conditionnement numérique, de séparation uniforme des amplitudes ou de garantie avec données manquantes.

**Autres classes de supports.** L'identité de Fourier et le minorant informationnel ne dépendent pas de la classification des triplets. L'égalité avec le logarithme de la fibre utilise fortement les formes ordinaires et exceptionnelles de cardinal trois. Elle n'est pas revendiquée pour les supports plus grands, les multiensembles, les quotients par translation ou les restrictions excluant zéro.

**Positionnement scientifique.** Ce lot établit un prolongement précis du programme interne. Il ne revendique pas de priorité bibliographique ; celle-ci demanderait une revue de littérature séparée, avec les conventions d'observation comparées exactement.


## 9. Certificats de la source et archives vérifiées

La source scientifique est [`8b5e2dbedff59b3089c65fe70aff6b596ee392d3`](https://github.com/alexcour/couret-finite-verifications/commit/8b5e2dbedff59b3089c65fe70aff6b596ee392d3), arbre `e56a2923d81b089dfce3fe3c7128a2011f8e0c4c`. La [PR 59](https://github.com/alexcour/couret-finite-verifications/pull/59) présente ce lot au-dessus de la branche de recherche de la PR 36 et reste en brouillon pour revue.

Les contrôles directs de l’événement **push** de ce SHA exact ont réussi : [Lean et rejeu 39039158181](https://github.com/alexcour/couret-finite-verifications/actions/runs/39039158181), [job 117414933044](https://github.com/alexcour/couret-finite-verifications/actions/runs/39039158181/job/117414933044) et [Verify 39039158227](https://github.com/alexcour/couret-finite-verifications/actions/runs/39039158227). Les trois contrôles de la PR ont aussi réussi ; les références de preuve ci-dessus portent directement sur la source, sans dépendre d’un commit de fusion synthétique.

Le résultat intégré est **3 494 tâches, 73 racines Lean et 325 déclarations publiques RECOH contrôlées**, dont 29 nouvelles dans quatre modules. Lean est en version 4.29.1 ; Mathlib reste à la révision `5e932f97dd25535344f80f9dd8da3aab83df0fe6`. Le certificat recalculé depuis le journal d’axiomes CI est identique au JSON produit par la CI. Aucune dépendance non standard n’est présente.

Le rejeu du décodeur typé existant a été exécuté à nouveau : **1 454 cas, 7 693 assertions, zéro échec**. Les 283 observations comprennent 211 exécutions de chacun des deux décodeurs Lean : 155 restitutions, 50 rejets de format typé et six observations typées sans candidat. Les 72 autres observations sont rejetées par l’adaptateur. Seize cas portent sur de grandes présentations explicites. Les empreintes des sources de ce rejeu ont été comparées aux fichiers de la source courante. Ce contrôle conserve son périmètre : il concerne le décodeur antérieur à banque universelle, pas une implémentation du nouveau sélecteur existentiel.

L’[archive originale 12103885765](https://github.com/alexcour/couret-finite-verifications/actions/runs/39039158181/artifacts/12103885765) contient **91 125 octets**. Son empreinte SHA-256 vérifiée est `5cbc6b4ab5999bca7596b9a7aabb888d64dd5c6b52a2df7971268fe4f2c89d45`, identique à l’empreinte publiée par GitHub. Le rapport des fibres contenu dans cette archive est identique octet pour octet à celui de la source.

Les quatre fichiers CI sont conservés sans modification de contenu : [compilation](recoh_fibre_build_20261017.log), [traces d’axiomes](recoh_fibre_axioms_20261017.log), [certificat JSON](recoh_fibre_certificate_20261017.json), [rejeu du décodeur](recoh_fibre_decoder_replay_20261017.json). Le [manifeste de provenance](recoh_fibre_validation_manifest_20261017.json) donne leurs tailles, leurs SHA-256, la provenance de l’archive et les résultats de contrôle.

Le checkpoint qui ajoute ces archives et cette section est documentaire. Les sources Lean et les vérificateurs scientifiques restent ceux du commit `8b5e2dbe` ; les journaux ne sont pas présentés comme une compilation de la prose ajoutée ultérieurement. La vérification formelle et la clôture de COU-26 ne valent pas relecture humaine ni audit de priorité bibliographique.
