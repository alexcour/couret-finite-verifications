# NTK-OBS-01 / SAMPLING-02 — Coût de l'observation et choix des instants

**Date :** 11 octobre 2026. **Statut :** note mathématique interne et contrôles rationnels locaux ; **aucune validation externe**. **Antériorité :** méthodes de Prony, matrices de Hankel, décimation et analyse du conditionnement déjà classiques. Aucune originalité revendiquée. Cette note prolonge, sans les remplacer, `PROOF_NOTE.md` et `ROBUSTNESS_01/ROBUSTNESS_AUDIT.md` du dossier NTK-OBS-01.

## 1. Modèle, objets et ressources

Noyau réel symétrique positif semi-défini **fixe** et itération `e[k+1]=(I-eta*K)e[k]`. Pour exactement deux modes actifs et `m_k=2L[k]`, on observe

    m_k = w1*q1^k + w2*q2^k,
    0 < q2 < q1 < 1,  w1,w2>0,
    q_i=(1-eta*lambda_i)^2.

On peut demander le scalaire `y_k=m_k+e_k` à des entiers `k>=0`, avec **bruit déterministe adversarial** `|e_k|<=epsilon` pour chaque observation. Il n'existe ici aucune hypothèse de moyenne nulle, d'indépendance des erreurs, de coût différencié par requête ou de réseau entraîné. Le temps maximal d'observation fait partie du coût : un calendrier `(0,h,2h,3h)` utilise quatre mesures mais exige un horizon `3h`. Répéter la mesure d'un même instant ne réduit pas le bruit borné contre un adversaire.

Cette observation porte sur les **nœuds discrets q**, et non automatiquement sur `lambda`. Même une reconstruction parfaite des `q` laisse l'ambiguïté `lambda <-> 2/eta-lambda`, sauf hypothèse injective préalable, telle que `0<eta*lambda<1`.

## 2. Trois mesures pour certifier une propriété ; quatre pour reconstruire

Pour le pas `h>=1`, les trois observations correspondantes à `k=0,h,2h` ont les moments exacts `M0,M1,M2`. Écrivons `r_i=q_i^h`; alors

    D_h = M0*M2 - M1^2 = w1*w2*(r1-r2)^2.

Dans la classe des mélanges de masses positives, `D_h=0` pour un seul nœud ; `D_h>0` pour au moins deux nœuds actifs. Deux mesures exactes `(m0,m_h)` ne suffisent pas à distinguer un nœud de deux : le modèle à un nœud `w=m0, r=m_h/m0` explique ces données. Au contraire, **trois mesures** peuvent certifier « au moins deux nœuds », sans reconstruire leurs positions ni leurs poids.

À partir des trois observations *bruitées* `Y0,Y1,Y2` aux temps `0,h,2h`, et d'une borne de bruit `epsilon`, le témoin **observable** est

    C_obs = (Y0-epsilon)*(Y2-epsilon) - (Y1+epsilon)^2.

Si `Y0-epsilon>0`, `Y2-epsilon>0`, `Y1+epsilon>=0` et `C_obs>0`, alors `D_h>0` pour tous les moments exacts non négatifs compatibles avec les intervalles d'erreur. C'est un certificat **de propriété**, non une reconstruction.

Pour le modèle exact fixé et **pour toute perturbation** `|e|<=epsilon`, ce témoin reste positif dès que

    0 <= epsilon < E_rank(h) := D_h / [2*(M0+M2+2*M1)].              (RANK)

**Preuve.** La perturbation la plus défavorable pour le témoin prend `Y0=M0-epsilon`, `Y2=M2-epsilon`, `Y1=M1+epsilon`; ainsi

    C_obs >= (M0-2epsilon)*(M2-2epsilon) - (M1+2epsilon)^2
          = D_h - 2epsilon*(M0+M2+2*M1)>0.

En effet `E_rank(h)<min(M0,M2)/2` puisque `D_h<=M0*M2` et `M0+M2+2*M1>=max(M0,M2)`. Pour ce témoin particulier, le bord `epsilon=E_rank(h)` est atteint par la perturbation extrême ci-dessus et ne donne plus un témoin **strictement** positif. Cela **ne démontre pas** que ce seuil est optimal parmi tous les tests possibles.

Avec quatre mesures exactes `0,h,2h,3h`, la méthode de Prony reconstruit les deux `r_i` et les poids si `D_h>0`, puis les `q_i=r_i^(1/h)` par la racine positive unique. Dans le modèle générique à deux poids inconnus et deux nœuds inconnus, trois mesures exactes restent insuffisantes (contre-exemple rationnel dans `NTK_OBS_01/PROOF_NOTE.md`). Donc le minimum générique exact pour la **reconstruction complète** est quatre, indépendamment de `h`.

## 3. Décimation : formule exacte du jacobien et compromis horizon/amplitude

Sur quatre mesures `m_{jh}`, `j=0,1,2,3`, considérons le jacobien par rapport à `(w1,w2,q1,q2)` :

    J[j,:] = (q1^(jh), q2^(jh), jh*w1*q1^(jh-1), jh*w2*q2^(jh-1)),

avec dérivées nulles lorsque `j=0`. Sa formule **exacte** est

    |det J_h| = w1*w2*h^2*q1^(h-1)*q2^(h-1)*(q1^h-q2^h)^4.      (J)

Elle découle de la matrice de Vandermonde confluente associée à `r_i=q_i^h` et de la règle de chaîne. Le programme vérifie l'identité sur les deux exemples et les 24 pas par un déterminant rationnel **indépendamment évalué**. Lorsque les nœuds se rapprochent autour de `q`, le jacobien est approximativement proportionnel à `h^6*q^[6(h-1)]*(q1-q2)^4` : un certain espacement aide, mais les mesures tardives finissent par s'éteindre lorsque `q<1`.

**Attention :** un grand déterminant de jacobien n'est **pas** un certificat de minimax optimal ni la plus petite erreur garantie en norme infinie. L'étude numérique ci-dessous classe plutôt des **inégalités de stabilité suffisantes** dûment certifiées, et non une information de Fisher ou un risque statistique (aucun modèle aléatoire ici).

## 4. Certificat Prony sous bruit pour quatre temps `0,h,2h,3h`

Reprenons explicitement le théorème de perturbation de `ROBUSTNESS-01` avec `r_i=q_i^h`, `d_r=r1-r2`, `W=w1+w2`, `S1=r1+r2`, `S2=r1*r2`, `D_h=w1*w2*d_r^2`, `H_h=[[M0,M1],[M1,M2]]`, et

    a_h = D_h/(M0+M2),
    rho_h = (2+2*(S1+S2))*epsilon/(a_h-2*epsilon),
    gamma_h = (2*S1+4)*rho_h + rho_h^2,
    R_h = (rho_h+gamma_h/d_r)/2,
    B_h = (2*epsilon+W*R_h)/(d_r-2*R_h).

Sous les hypothèses simultanées

    2*epsilon < a_h,
    gamma_h < d_r^2,
    R_h < min(r2,1-r1,d_r/2),
    B_h < min(w1,w2),

la reconstruction de Prony brute sur les **quatre mesures bruitées** produit deux nœuds distincts `r~_i` dans `(0,1)`, des poids positifs et

    |r~_i-r_i|<=R_h,  |w~_i-w_i|<=B_h.

Pour revenir à `q_i`, fixons `0<zeta<q2`. Supposons de plus

    R_h < q2^h-(q2-zeta)^h.

Alors chaque `q~_i=(r~_i)^(1/h)>q2-zeta`, et la factorisation `q^h-u^h=(q-u)*sum(q^(h-1-j)u^j)` donne une borne **purement rationnelle** :

    |q~_i-q_i| <= Q_h := R_h/[h*(q2-zeta)^(h-1)].                 (Q)

Cette borne est volontairement conservative. Elle ne donne des garanties sur `lambda` que si l'on ajoute la branche injective et, le cas échéant, sa marge aux frontières. Aucune estimation d'erreur optimale n'est affirmée.

## 5. Protocole de comparaison exactement défini

Deux exemples **choisis pour l'analyse, non issus d'un tirage aléatoire** :

* **NEAR** : `q1=91/100`, `q2=89/100`, `w1=w2=1`, donc deux modes très proches et lents. Exemple réalisable avec `eta=1`, `K=diag(1-sqrt(91/100),1-sqrt(89/100))`, `e0=(1,1)`, matrice positive semi-définie à entrées algébriques.
* **ORIGINAL** : `q1=9/16`, `q2=1/4`, `w1=1`, `w2=4`, soit l'exemple exact déjà documenté dans NTK-OBS-01.

Le programme parcourt **uniquement la grille finie prédéfinie pour ce rapport** `h=1..24` (les modèles ont été choisis avant ce classement ; ce n'est pas un test de validation aveugle). Tous les calculs se font avec `fractions.Fraction`. Pour chaque `h` : (a) seuil rationnel `(RANK)` ; (b) recherche binaire exacte du plus grand `epsilon=N*10^-12` passant **toutes** les conditions précédentes, plus les cibles strictes `Q_h<1/100`, `B_h<1/10` et `zeta=1/100`. C'est le **meilleur seuil discret pour ce certificat et cette grille**, non le meilleur estimateur mathématique. La propriété monotone en `epsilon` découle des formules (tous les termes positifs augmentent avec `epsilon` tant que les dénominateurs restent positifs).

| Modèle | Pas h | Horizon 3h | E_rank(h), env. | Bruit admissible e_max pour certifier q<0,01 et poids<0,1 |
|---|---:|---:|---:|---:|
| NEAR | 1 | 3 | 0,000027700063 | 0,000000000073 |
| NEAR | 4 | 12 | 0,000309827319 | 0,000000010016 |
| NEAR | 8 | 24 | 0,000714752717 | 0,000000055353 |
| **NEAR** | **12** | **36** | **0,000862307002** | **0,000000079261** |
| NEAR | 16 | 48 | 0,000774918584 | 0,000000061853 |
| ORIGINAL | 1 | 3 | 0,022471910112 | 0,000011351305 |
| ORIGINAL | 2 | 6 | 0,020634668685 | 0,000008760208 |
| ORIGINAL | 12 | 36 | 0,000000402508 | 0 à la résolution 10^-12 |

Les valeurs décimales du tableau sont **tronquées**, non des égalités ; les fractions exactes et toutes les 48 lignes sont dans `sampling_results.json`. Les colonnes de tolérance ne doivent pas être interprétées comme des probabilités, un gain empirique universel ou une grandeur intrinsèque de la tâche.

**Constat interne borné :** pour NEAR, le meilleur pas parmi `1..24` pour les deux indicateurs est `h=12`; le seuil suffisant d'erreur de reconstruction à 4 mesures passe de `73/10^12` (`h=1`) à `79261/10^12` (`h=12`), soit un rapport exactement `79261/73`, supérieur à 1000. Mais l'horizon passe de 3 à 36. Pour ORIGINAL, `h=1` est meilleur sur la grille étudiée. Il n'existe donc pas de valeur universellement optimale de `h` issue de ces exemples. La méthode de décimation et ses avantages selon les régimes ont des antériorités établies (voir REFERENCES.md).

Le script teste également, pour `h=1` et le meilleur `h` de chaque modèle, les 81 perturbations `{-epsilon,0,+epsilon}^4` avec des **encadrements rationnels extérieurs** des racines carrées et h-ièmes (grille `10^-18`) et des poids. Ce diagnostic fini contrôle l'implémentation, tandis que les inégalités ci-dessus certifient **tous** les vecteurs d'erreur autorisés.

## 6. Contre-exemple valable pour tous les instants et toute stratégie adaptative

Fixons `a=1/2`, `0<d<=1/16`, poids égaux `1/2,1/2`, et deux modèles à **deux nœuds chacun** :

    A_d : nodes (a+d,a-d),
    B_d : nodes (a+2d,a-2d).

Les ensembles ordonnés de nœuds sont distants de `d` en norme maximale. Pourtant, pour **tout entier k>=0**,

    |m_k(B_d)-m_k(A_d)| <= (15/2)*d^2.                         (NO-GO)

**Preuve analytique sans troncature.** Pour `f(x)=x^k`, `k=0,1`, la différence est nulle. Pour `k>=2` et `x` dans `[3/8,5/8]`, on a

    0 <= f''(x)=k(k-1)*x^(k-2)
                 <= k(k-1)*(5/8)^(k-2) <= 625/128 < 5.

La suite `k(k-1)*(5/8)^(k-2)` est maximale à `k=5` : pour `k>=5`, son rapport consécutif est `[(k+1)/(k-1)]*(5/8)<=15/16<1`; les petites valeurs se vérifient directement. Avec `g(t)=[f(a+t)+f(a-t)]/2`, on a `0<=g'(t)<=5t` pour `t∈[0,2d]`, donc

    0<=g(2d)-g(d)<= integral_d^(2d) 5t dt=(15/2)*d^2.

Ainsi l'observation médiane `Y_k=(m_k(A_d)+m_k(B_d))/2` est compatible avec **les deux modèles, simultanément à tous les temps**, dès que `epsilon>=(15/4)*d^2`. Pour n'importe quelle procédure, y compris celle qui choisit adaptativement le prochain `k` après lecture des valeurs précédentes, un adversaire peut renvoyer le même `Y_k` : impossible de distinguer les deux modèles, même avec un nombre arbitraire de mesures. L'erreur maximale d'un estimateur des deux nœuds est alors `>=d/2` sur au moins l'un des deux modèles (inégalité triangulaire).

La boucle `k=0..100` de `verify_sampling.py` ne sert qu'à contrôler le calcul du contre-exemple ; la preuve précédente est valable **pour tous les entiers**. Ce résultat exclut une garantie de reconstruction uniforme à précision plus fine que `d/2` pour une famille de problèmes arbitrairement proches, à bruit absolu d'ordre `d^2`. Il ne prouve aucune borne minimax globale optimale sur la classe générale.

## 7. Réponse à la question du budget et pistes ouvertes

* **Nombre d'évaluations, sans bruit** : deux ne suffisent pas pour identifier l'existence de deux modes ; trois peuvent certifier cette propriété ; quatre reconstruisent génériquement deux nœuds et leurs poids.
* **Sous bruit borné** : trois suffisent seulement à certifier `D_h>0` lorsque le témoin observable est positif ; quatre permettent la reconstruction précise sous les hypothèses et seuils du §4. Sept évaluations distinctes, par exemple l'union des calendriers `(0,1,2,3)` et `(0,12,24,36)`, donnent deux sous-problèmes de Prony disponibles : l'ensemble des modèles compatibles avec les sept mesures est inclus dans chacun des ensembles compatibles à quatre mesures. **Cette inclusion ne prouve pas un gain numérique strict** ; elle ne nécessite aucune indépendance du bruit.
* **Coût de l'horizon** : quatre évaluations `h=12` nécessitent un temps maximal 36, pas 3 ; le gain sur un bruit absolu fixé dépend du profil de décroissance. En bruit relatif, hétéroscédastique ou temporellement corrélé, le classement pourrait changer.
* **Limite absolue** : sans séparation minimale et bornes sur le bruit et les poids, même toutes les mesures aux temps entiers ne donnent pas de précision uniforme. Les stratégies adaptatives ne contournent pas l'obstruction (NO-GO) dans ce modèle.

**Questions réellement ouvertes dans ce dossier :** (i) choix d'instants arbitraires et non équidistants minimisant une erreur certifiée pour une classe a priori donnée ; (ii) budget conjoint nombre de mesures / horizon / précision de mesure ; (iii) reconstruction par faisabilité surdéterminée et encadrements exacts pour `>4` mesures ; (iv) borne minimax optimale et référence détaillée aux résultats connus ; (v) passage à 3 modes ou plus, bruit structuré, noyaux évolutifs. Pas de résultat inédit sur une intelligence artificielle ou sur la prédiction hors échantillon.

## 8. Statut et porte de relecture

* **E** : preuves élémentaires et comparaisons rationnelles internes documentées ; contrôles locaux PASS.
* **Q** : archive déterministe, empreintes SHA-256 et replay local PASS ; exécution externe sur clone propre NON CONFIRMÉE.
* **N** : **aucune originalité** ni priorité revendiquée ; antériorité scientifique à poursuivre.
* **R** : relecture mathématique indépendante **OUVERTE**.

**NO-GO** : fusion `main`, revendication de nouveauté, DOI/publication comme théorème original, extrapolation aux réseaux non linéaires, recommandation industrielle sans audit externe.
