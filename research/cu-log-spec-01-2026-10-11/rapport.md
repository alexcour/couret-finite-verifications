# CU-LOG-SPEC-01 — Signature de Cayley, constantes premières et contrôle hors fenêtre modulo 210

**Date :** 11 octobre 2026  
**Statut :** vérifications algébriques exactes (dans le cadre défini), calculs finis reproductibles, test exploratoire gelé, contrôle indépendant des comptages ; **aucun résultat arithmétique nouveau établi**.  
**Dépendance :** CU-LOG-30, constantes `M(30,a)` calculées et confrontées à Languasco–Zaccagnini (2010).

## Question, et portée

Nous avons pris le triplet préexistant `T_C = {1,11,29}` comme **règle de construction indépendante** des huit constantes de Mertens `M(30,a)`. Peut-on discerner dans ces constantes, puis dans les fluctuations du comptage des nombres premiers, une information supplémentaire liée à la signature de l'opérateur de Cayley ?

**Réponse circonscrite :** le premier espace propre se ramène exactement au caractère quadratique modulo 5, et les constantes ne montrent pas de particularité notable sur le score retenu. Une faible énergie des fluctuations grossières modulo 30 dans des comptages modulo 210 persiste dans une fenêtre hors de l'exploration, mais le contrôle d'autres quotients montre que cette baisse **n'est pas propre au modulo 30**. Elle ne peut donc pas être attribuée à notre triplet `T_C`.

## 1. Identité spectrale exacte : information classique

Sur `U(30) = {1,7,11,13,17,19,23,29}`, construisons les permutations régulières de multiplication `R_g`, et posons :

`A_30 = I + R_11 + R_29`.

Comme `11² = 29² = 1 mod 30`, `A_30` est réelle symétrique. Ses valeurs propres dans `R^8` sont `3` (multiplicité 2), `1` (multiplicité 4) et `-1` (multiplicité 2). Sur l'espace `H = {x : somme_a x_a = 0}`, les multiplicités sont **3×1, 1×4, -1×2**.

Le projecteur sur l'espace propre `λ=3` de `A_30|H` vaut :

`P_3 = χ_5 χ_5^T / 8`, avec `χ_5(a) = +1` si `a mod 5` vaut `1` ou `4`, et `-1` sinon.

C'est le caractère de Dirichlet quadratique modulo 5. Pour `m_a = M(30,a)`, `x = m - moyenne(m)`, l'énergie relative dans cet espace est exactement :

`E_3 = (somme_a χ_5(a) M(30,a))² / (8 somme_a (M(30,a)-moyenne(m))²)`.

Le contraste de caractère vaut `-0.1746632146065278` à la précision affichée. Il se réécrit comme une somme pondérée par `χ_5` sur les nombres premiers et relève des caractères de Dirichlet et valeurs de fonctions L **connus dans la littérature**, pas d'une signature arithmétique découverte par ce calcul.

| Espace propre de `A_30|H` | Dimension | Part de l'énergie des `M(30,a)` |
|---|---:|---:|
| `λ=3` | 1 | 0,22262415 |
| `λ=1` | 4 | 0,35408075 |
| `λ=-1` | 2 | 0,42329510 |

**Contrôle descriptif exhaustif :** pour les `8! = 40320` permutations d'étiquettes des huit `M(30,a)`, `10368/40320 = 0,257142857` atteignent ou dépassent l'énergie de `λ=3` observée. Ce rapport est un diagnostic de permutation conditionnel ; **ce n'est pas une preuve statistique** sur les nombres premiers. La valeur observée n'apparaît pas remarquable.

## 2. Passage au module 210 : contrôle de non-circularité

Les unités de `Z/210Z` sont 48. Puisque 11 n'est plus involutif modulo 210, utilisons l'opérateur symétrisé :

`A_210 = I + (R_11 + R_11⁻¹)/2 + (R_29 + R_29⁻¹)/2`.

Le relèvement `L : R^8 → R^48` associe à une classe de `U(210)` la coordonnée de sa réduction modulo 30. Nous avons vérifié l'identité matricielle **exacte** :

`A_210 L = L A_30`.

La projection orthogonale `P_30 = L L^T / 6` a rang 8 ; après suppression de la constante globale `P_0`, sa composante non triviale a rang 7. Le complément `I-P_30` a rang 40. Ce sont deux groupes de modes ; **la composante relevée modulo 30 n'est pas une validation indépendante de la structure modulo 30**, précisément parce que l'entrelacement est une identité.

Pour un intervalle de nombres premiers `I`, soit `n_a(I)` le nombre de `p∈I` avec `p mod 210 = a`; posons `y=n-moyenne(n)`. L'observable annoncée avant la validation est :

`F_30(I) = <y,(P_30-P_0)y>/<y,y>`.

La moyenne **purement combinatoire** obtenue en permutant uniformément les 48 étiquettes d'un vecteur fixé est `7/47 ≈ 0,14893617`. Ce n'est pas la prédiction démontrée d'un modèle mathématique des écarts de nombres premiers.

## 3. Expérimentation exploratoire puis fenêtre gelée

Le protocole fixe avant analyse de la dernière fenêtre : `I*=(10 000 000,30 000 000]`, `F_30(I*) < 0,05` comme prédiction exploratoire prolongée ; 20 000 permutations pseudoaléatoires de labels (PCG64/seed 21020261011). Le protocole initial fait référence explicitement aux petites fenêtres déjà inspectées. Empreinte SHA-256 du protocole gelé :

`829459bf323e10a9cdfded420f3dbd491be39a50350c28d2206e85cce36a97ce`.

| Fenêtre de premiers `p` | Nombre dans U(210) | `F_30(I)` | Qualification |
|---|---:|---:|---|
| `(0, 10⁴]` | 1 225 | 0,021638 | Exploratoire |
| `(10⁴, 10⁵]` | 8 363 | 0,039233 | Exploratoire |
| `(10⁵, 10⁶]` | 68 906 | 0,034748 | Exploratoire |
| `(10⁶, 10⁷]` | 586 081 | 0,035189 | Exploratoire |
| **`(10⁷, 3×10⁷]`** | **1 193 280** | **0,042384** | Fenêtre hors exploration, protocole gelé |

Le seuil `F_30 < 0,05` est satisfait **sur la fenêtre fixée**. Les étiquettes mélangées aléatoirement donnent une fréquence de valeurs au plus aussi petites de `663/20000 ≈ 0,03315` (erreur de Monte-Carlo nominale ~0,00127). **Ce nombre ne doit pas être présenté comme une p-valeur inférentielle :** les classes de congruence ne sont pas échangeables selon une loi de hasard démontrée et la fenêtre est une suite arithmétique déterministe.

Les 1 193 280 nombres premiers de cette fenêtre et leurs 48 comptages ont été **recalculés intégralement** à l'aide d'un second crible segmenté fondé sur une liste de petits premiers produite par division d'essai. Les 48 valeurs sont identiques à celles du premier crible.

## 4. Témoins additionnels : baisse non spécifique au modulo 30

Après la lecture des résultats, nous avons ajouté un contrôle **post hoc**, sans modifier le protocole gelé. Pour un diviseur `q` de 210, on projette sur les fonctions dépendant seulement du résidu modulo `q` et on compare à la moyenne de permutation `(φ(q)-1)/47`.

Sur la fenêtre hors exploration :

| Quotient `q` | Rang après centrage | Énergie observée | Moyenne sous permutations de labels |
|---|---:|---:|---:|
| 15 (≡ 30 sur U(210)) | 7 | 0,042384 | 0,148936 |
| 21 (≡ 42 sur U(210)) | 11 | 0,058658 | 0,234043 |
| 35 (≡ 70 sur U(210)) | 23 | 0,297550 | 0,489362 |

**Interprétation :** plusieurs quotients plus grossiers que 210 ont une part d'énergie inférieure à leur benchmark de permutation. Le phénomène observé pour 30 n'est donc **pas spécifique** au triplet spectral, ni même au module 30. Une étude future, si elle est utile, devra contrôler les caractères de conducteurs différents, les biais de Chebyshev et la covariance théorique des écarts dans les progressions arithmétiques avant toute conclusion.

## 5. Contrôles reproductibles et verdict

- **13/13 tests** exécutés sans erreur ; spectres (y compris celui modulo 210), projecteurs et identité de relèvement vérifiés.
- Comptages cumulés modulo 30 égaux aux nombres archivés dans CU-LOG-30 aux quatre coupures ; exception exacte de `p=7` lors de la réduction depuis U(210).
- Tous les premiers `p ≤ 5000` vérifiés contre une division d'essai.
- Recalcul indépendant de la fenêtre `(10^7,3×10^7]` par crible segmenté : **48/48 classes concordantes**.
- Hypothèse exploratoire prolongée `F_30 < 0,05` satisfaite à l'unique horizon fixé ; **aucune conséquence universelle** n'en découle.

### Gate de conclusion

**[C] Résultats exacts classiques :** signature et projecteurs de `A_30`, caractère modulo 5, relèvement 30→210, identité d'entrelacement.  
**[N] Calculs finis reproduits :** scores des constantes, 40320 permutations exactes, fenêtres 210, crible segmenté indépendant.  
**[E] Observation exploratoire hors fenêtre :** faible part d'énergie dans plusieurs quotients ; non spécifique à `T_C`.  
**[NON ÉTABLI] :** lien nouveau avec la cospectralité, la stroboscopie, le bruit-horloge, une loi asymptotique nouvelle ou une singularité intrinsèque du triplet `T_C`.

### Suite raisonnable

Éviter de multiplier les modules à la recherche d'une coïncidence. Si le projet est poursuivi, définir en amont un **modèle analytique de covariance par caractères de Dirichlet et conducteurs**, et comparer les énergies corrigées à ce modèle et à des expériences préenregistrées. Une telle étape devra être examinée en bibliographie avant toute prétention d'originalité.

## Références

- A. Languasco et A. Zaccagnini, *Computing the Mertens and Meissel–Mertens Constants for Sums over Arithmetic Progressions*, Experimental Mathematics **19**(3), 279–284 (2010), https://arxiv.org/abs/0906.2132.
- Théorie classique des caractères de Dirichlet et des représentations du groupe abélien fini `U(30)` ; aucune prétention d'antériorité.
- Archive de provenance interne `CU_LOG_30_2026-10-11.zip`, contrôlée par l'empreinte du fichier d'origine dans `M30_reference.json`.