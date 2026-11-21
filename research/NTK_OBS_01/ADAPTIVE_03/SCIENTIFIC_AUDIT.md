# NTK-OBS-03 — Coût de certification, choix adaptatif des instants et bruit borné

**Date :** 11 octobre 2026. **Statut :** note de recherche interne, calculs rationnels locaux reproductibles ; relecture scientifique indépendante **OUVERTE**. **Aucune revendication d'originalité** et **aucune validation externe**.

**Filiation :** NTK-OBS-01 (observabilité des pertes pour un noyau fixe), `ROBUSTNESS_01` (perturbation de Prony), `SAMPLING_02` (choix des pas et horizon temporel). Le présent dossier étudie une **autre question** : la sélection conditionnelle des instants lorsque l'ensemble des modèles candidats est *fini et connu a priori*. Les résultats précédents sur l'identification de paramètres inconnus ne sont pas remplacés.

## 1. Modèle mathématique et coût choisi avant le calcul

Pour une réalisation `(K,e0)`, `K` réelle symétrique semi-définie positive **fixe**, avec `e[k+1]=(I-K)e[k]`, on observe `m_k=2L[k]=||e[k]||²` :

    m_k = sum_{i=1}^2 w_i q_i^k,   0<q_i<1,  w_i>0,
    q_i=(1-lambda_i)^2.

**Les quatre hypothèses sont des couples (K,e0)**, et non nécessairement quatre noyaux avec un unique vecteur initial identique. Des valeurs rationnelles `q_i,w_i` produisent des moments rationnels : on réalise chaque hypothèse par `K=diag(1-sqrt(q_1),1-sqrt(q_2))`, `e0=(sqrt(w_1),sqrt(w_2))`, avec `eta=1` et la branche `0<lambda_i<1`.

À chaque instant choisi `t in T={0,1,2}`, une requête retourne `y_t=m_t+e_t`, **bruit adversarial absolu** `|e_t|<=epsilon`. Aucun a priori probabiliste, aucune indépendance et aucune réduction garantie du bruit par répétition. La stratégie peut interroger seulement les instants en ordre chronologique strictement croissant et doit identifier le modèle **avec certitude pour tous les bruits admissibles** ; sinon, elle renvoie `NON CERTIFIÉ`.

Coût d'observation *normalisé* étudié :

    J = c_obs*N + c_wait*T_fin,   c_obs=1, c_wait=1/4,

avec `N` nombre de requêtes, `T_fin` dernier instant interrogé, début du temps à zéro, temps compté **une seule fois** et aucune valeur monétaire implicite. La politique optimise le **pire cas** parmi les modèles et bruits. Les coûts de préparation de certificats, de calcul, d'instrumentation et de stockage sont **exclus** ; leur réintroduction est explicitée en section 7. La famille de modèles et les horaires ont été construits *pour cet exemple*, sans jeu de validation caché.

## 2. Quatre mesures spectrales positives entièrement explicites

Chaque couple `(q,w)` est un nœud discret et son poids :

| Hypothèse | Premier `(q,w)` | Second `(q,w)` | `m0` | `m1` | `m2` |
|---|---|---|---:|---:|---:|
| A | `(1/4, 1/2)` | `(3/4, 1/2)` | 1 | 1/2 | 5/16 |
| B | `(3/52, 1/2)` | `(41/52, 1/2)` | 1 | 11/26 | 5/16 |
| C | `(1/20, 275/108)` | `(23/28, 49/108)` | 3 | 1/2 | 5/16 |
| D | `(1/10, 5/2)` | `(1/2, 1/2)` | 3 | 1/2 | 3/20 |

Le code établit par `Fraction` l'identité *exacte* de ces moments, vérifie pour chaque modèle deux modes distincts dans `(0,1)` et deux poids strictement positifs. La réalisation via `(K,e0)` existe analytiquement ; aucun entraînement de réseau de neurones n'a été effectué.

Trois coïncidences intentionnelles fondent le certificat inférieur :

- A/B : mêmes moments aux temps `0` et `2` ; seule `m1` les sépare, avec écart `1/13`.
- C/D : mêmes moments aux temps `0` et `1` ; seule `m2` les sépare, avec écart `13/80`.
- A/C : mêmes moments aux temps `1` et `2` ; seule `m0` les sépare, avec écart `2`.

## 3. Proposition interne A — trois requêtes fixes nécessaires et suffisantes

**Énoncé.** Pour `0<=epsilon<1/26`, tout calendrier **non adaptatif** garantissant l'identification des quatre hypothèses à partir d'un sous-ensemble prédéclaré des instants `T={0,1,2}` doit utiliser **les trois instants**. Il existe un calendrier fixe correct `(0,1,2)`.

**Démonstration.** Deux centres scalaires `a,b` avec erreur absolue bornée `epsilon` sont uniformément discriminables par une requête exactement lorsque `|a-b|>2epsilon` : les intervalles fermés `[a-epsilon,a+epsilon]` et `[b-epsilon,b+epsilon]` sont alors disjoints. Pour séparer A et B, il faut l'instant 1, puisqu'aux instants 0 et 2 leurs mesures sont exactement égales. Pour séparer C et D, il faut l'instant 2. Pour séparer A et C, il faut l'instant 0. Donc tout calendrier fixe doit contenir les trois instants. Réciproquement, chacune des six paires de modèles présente sur `T` une séparation strictement supérieure à `2epsilon` lorsque `epsilon<1/26`; le calendrier complet distingue donc tous les modèles sous toutes les perturbations admissibles. `QED`.

Avec la fonction de coût choisie, `J_fix=3+2/4=7/2`. Même si un calendrier prédéclaré autorise un arrêt dès que le modèle est identifié, son **pire cas** contient encore les trois observations (notamment C ou D sous l'ordre chronologique).

## 4. Proposition interne B — politique adaptative à deux requêtes, optimale

Politique entièrement explicite (intervalles disjoints si `epsilon<1/26`) :

    Demander m0 à t=0.
    Si la mesure est compatible avec m0=1, l'ensemble courant est {A,B} :
        demander m1 à t=1 ; retourner A ou B selon l'unique compatibilité.
    Si la mesure est compatible avec m0=3, l'ensemble courant est {C,D} :
        demander m2 à t=2 ; retourner C ou D selon l'unique compatibilité.
    Si aucune observation n'est compatible avec les intervalles annoncés :
        HALT et NON CERTIFIÉ (modèle hors famille ou bruit dépassant la borne).

Pour `epsilon<1/26`, `|1-3|=2>2epsilon`, `|1/2-11/26|=1/13>2epsilon`, `|5/16-3/20|=13/80>2epsilon` ; chaque décision est donc valide même au pire bruit. Chaque trajectoire utilise **exactement deux** requêtes. Les dernières dates sont 1 sur A/B et 2 sur C/D ; le coût au pire est `J_ad=2+2/4=5/2`.

**Optimalité restreinte.** Une seule requête à n'importe lequel des trois instants laisse au moins deux modèles indiscernables. Donc aucune politique correcte n'a un coût minimax de moins de deux requêtes ; de plus, identifier C exige les instants 0 (contre A) et 2 (contre D), donc un horizon d'au moins 2 sur ce cas. Pour chaque `c_obs>0,c_wait>=0`, le minorant `2c_obs+2c_wait` est atteint exactement par la politique. `QED`.

La politique est optimale **uniquement** dans cette famille finie, cet ensemble de temps et cette fonction de coût. Elle ne donne pas une procédure universelle d'estimation des deux nœuds `q_i` et des deux poids inconnus lorsque ces quatre paramètres varient continûment.

## 5. Proposition interne C — seuil exact d'impossibilité en bruit adversarial

**Énoncé.** Avec une famille de candidats exactement `{A,B,C,D}` et des requêtes limitées à `T={0,1,2}`, l'identification sans erreur pour tous les bruits admissibles est possible si et seulement si `0<=epsilon<1/26`.

La suffisance vient de la politique précédente. Pour `epsilon>=1/26`, le même transcript

    y0=1,  y1=6/13,  y2=5/16

est compatible avec A et B. En effet A et B ont le même `m0,m2`, et `6/13` est le milieu exact de `1/2` et `11/26`, distant de chacun de `1/26`. Même une répétition illimitée des mêmes instants ne lève pas cette ambiguïté sous un adversaire autorisé à répondre toujours par ce même transcript. L'identification certaine est donc impossible. `QED`.

**Limite essentielle :** une observation à un instant `k>=3`, une autre information sur `K`, un contrôle sur la corrélation des erreurs ou une autre classe de candidats peut changer ce seuil. Il n'est pas affirmé qu'une infinité de mesures à des instants arbitraires est toujours insuffisante.

## 6. Vérification algorithmique indépendante de la preuve

Le script `verify_policy.py` calcule des politiques optimales par programmation dynamique à partir des ensembles de modèles compatibles. Pour tout ensemble courant `S` et toute date candidate `t`, les classes compatibles après un résultat réel `y` ne changent que lorsque `y` franchit l'une des bornes rationnelles `m_i(t)±epsilon`. Il suffit donc d'énumérer **toutes ces bornes et un point de chaque intervalle ouvert entre deux bornes**. Cela constitue une énumération exacte de **toutes les classes d'observation possibles** sur la droite réelle : ce n'est pas une discrétisation arbitraire des observations.

Avec `last` dernière date utilisée et `V(S,last)=0` si l'identité est déjà certifiée :

    V(S,last) = min_{t in T, t>last} [ c_obs + c_wait*(t-max(last,0))
                   + max_{S' in Outcomes(S,t,epsilon)} V(S',t) ].

Toute branche impossible a coût infini ; la politique renvoie `NON CERTIFIÉ` si aucune stratégie n'atteint un singleton pour toutes les observations. Le code énumère également tous les calendriers fixes, les six paires de modèles, des perturbations de signe/centre sur 36 transcripts, ainsi qu'une grille de six bruits rationnels incluant exactement le bord `epsilon=1/26`.

Un second script `independent_audit.py`, écrit avec une approche différente, utilise **directement le tableau rationnel** et une preuve de couverture des paires ; il ne réutilise ni la programmation dynamique ni ses routines d'intervalles. Les deux scripts s'accordent sur les certificats. Cela reste **deux vérifications locales**, et non une validation extérieure.

## 7. Coût de préparation : la conclusion change si la politique est plus chère à préparer

Le résultat `5/2` contre `7/2` compte seulement les requêtes et l'horizon. Une économie de **une requête** ne suffit pas à conclure que la politique adaptative est économiquement supérieure dans un véritable dispositif. Posons :

    J_ad=P_ad+2*c_obs+2*c_wait,
    J_fix=P_fix+3*c_obs+2*c_wait.

Il en découle sans approximation :

    J_ad<J_fix  si et seulement si  P_ad-P_fix<c_obs.

**C'est un seuil de décision conditionnel, pas une mesure de coûts réels.** Le supplément de préparation `P_ad-P_fix` n'a **pas** été mesuré ; il peut être positif, nul ou négatif suivant l'instrumentation et la politique de certification.

Si l'on adopte **par convention** une loi uniforme sur les quatre modèles, avec la possibilité d'arrêter un calendrier fixe après un singleton, les coûts moyens sont `19/8` (adaptatif) et `23/8` (fixe), soit une économie moyenne normalisée de `1/2` hors préparation. Il ne s'agit pas d'une loi empirique sur les noyaux, ni d'une garantie probabiliste.

## 8. Propriété versus reconstruction

L'unique propriété `P = « masse initiale totale = 1 ou 3 »` est certifiée à l'instant zéro par **une** mesure, pour `epsilon<1`. L'identité complète des quatre modèles nécessite au pire deux requêtes adaptatives ou trois fixes pour `epsilon<1/26`. Cela illustre dans cette famille la différence de coût entre **certifier une propriété** et **identifier un modèle**. Tous les modèles comportent deux modes actifs : ce test de masse n'est pas un test de leur nombre de modes.

## 9. Antériorité, bornes de revendication et questions ouvertes

**Classique :** calcul spectral pour noyau fixe ; mesures discrètes et problème de Prony ; distinction entre suites de requêtes adaptatives et calendriers prédéclarés ; programmation dynamique des arbres de décision ; bruit adversarial et indistinguabilité des intervalles. Voir `REFERENCES.md`, notamment Gautier–Pronzato (2000), Moshkov (2022) et Potts–Tasche / Katz–Diab–Batenkov pour les problèmes inverses d'exponentielles.

**Propositions internes auditées localement :** ce tableau de quatre modèles à poids positifs, la valeur minimax `5/2` versus `7/2`, le seuil exact `1/26` pour cette famille, les certificats de cohérence et les bornes de coût conditionnelles. Ces constructions sont élémentaires et **aucune originalité n'est revendiquée**. Ni les preuves ni le code n'ont été revus par un tiers.

**Questions ouvertes :** adaptativité avec même vecteur résiduel initial entre candidats ; familles paramétriques continues ; plusieurs modes ; instants libres au-delà de `{0,1,2}` ; sous-hypothèses `q_i` rapprochés ; certificats à intervalle de confiance versus garanties adversariales ; erreurs corrélées ; coûts de préparation et de calcul mesurés ; contrôle de dérive du noyau ; audit indépendant et comparaison exhaustive des antériorités spécialisées.

**Portes de validation :** E = arguments élémentaires et calculs exacts locaux ; Q = archive reconstruite et tests locaux ; N = aucune nouveauté revendiquée ; R = examen externe ouvert. **NE PAS** déduire une théorie générale de l'intelligence, annoncer une priorité, fusionner vers `main` ou déposer un DOI sur ce seul dossier.
