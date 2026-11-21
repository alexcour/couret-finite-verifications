# CU-LOG-SPEC-01 — Audit contradictoire par conducteurs (11 octobre 2026)

**Périmètre :** exploitation uniquement des 48 comptages déjà archivés dans `resultats_spec.json`; aucun nouveau nombre premier recalculé ici. La PR #10 reste en brouillon. Ce supplément ne prétend à aucune originalité.

## 1. Décomposition vérifiable, arithmétique exacte
L'espace centré de U(210) a dimension 47. Pour q|105, l'énergie du sous-espace relevé modulo q est
`E_q = (1/(48/phi(q))) sum_{r in U(q)} (sum_{a mod q=r} n_a - (48/phi(q))*N/48)^2`.
On a `||y||^2=156804` exactement; `E_15=6646`, `E_21=9198`, `E_35=46657`, d'où F_15=0.042384122854, F_21=0.058659217877, F_35=0.297549807403. F_30=F_15 sur U(210).

Par inversion sur les diviseurs, l'énergie de conducteur primitif exactement f est `w_f=E_f-sum_{d|f,d<f}w_d`:

| f | Nombre de caractères | Énergie exacte | Part de l'énergie |
|---|---:|---:|---:|
| 3 | 1 | 9025/12 | 0.004796327475 |
| 5 | 3 | 1551/2 | 0.004945664651 |
| 7 | 5 | 3423/2 | 0.010914900130 |
| 15 | 3 | 61421/12 | 0.032642130728 |
| 21 | 5 | 80813/12 | 0.042947990272 |
| 35 | 15 | 44170 | 0.281689242621 |
| 105 | 15 | 1170505/12 | 0.622063744122 |

Ces 47 caractères et leur décomposition sont classiques. Les conducteurs 35 et 105 portent 90.3753% de l'énergie **dans cet unique intervalle**.

## 2. Première covariance classique — ce qui est établi et ce qui ne l'est pas
Par la formule explicite et sous GRH/LI pour les distributions limites de « prime number races », la variance attachée à chaque caractère primitif chi de conducteur f est le poids positif `b_chi=sum_{gamma} 1/(1/4+gamma^2)` (zéros non triviaux, multiplicité comprise). Son expression analytique équivalente est
`b_chi=log(f/pi)-EulerGamma-(1+chi(-1))*log(2)+2 Re L'(1,chi)/L(1,chi)`.
L'orthogonalité diagonalise les covariances de convolution; les projecteurs U(q) sélectionnent précisément les caractères de conducteur divisant q.

Une réévaluation numérique via zêta de Hurwitz et différence finie (pas de liste de zéros non audités) donne les **ratios de traces**, PAS les moyennes des ratios et PAS la prédiction de fenêtre:
- q=15/30: 0.0342084681
- q=21: 0.0794370763
- q=35: 0.3234656145.

Le rapport `CU-LOG-SPEC-02` déjà présent sur Drive a obtenu indépendamment 0.034208468 pour q=30; l'accord confirme le calcul numérique à cette précision, sans prouver l'exactitude de la formule ni une loi probabiliste sur une fenêtre fixe.

Pour une fenêtre (alpha*x,x], alpha=1/3 dans l'expérience SPEC-01, le coefficient associé à un zéro doit prendre en compte les deux bornes: `(1-sqrt(alpha)*exp(-i gamma log(1/alpha)))/(1/2+i gamma)`. La covariance correcte comporte donc `|1-sqrt(alpha)*exp(-i gamma log(1/alpha))|^2/(1/4+gamma^2)` ET les dépendances entre caractères/échelles selon le cadre aléatoire retenu. Ne pas confondre avec le ratio de traces cumulées. Un biais de Tchebychev des caractères réels doit aussi être propagé; pour le modèle normalisé usuel de l'incrément, son coefficient est proportionnel à `-(1-sqrt(alpha))`.

## 3. Modèle de sensibilité (explicitement INCOMPLET)
Sur 47 modes réels normalisés, le banc d'essai gaussien utilise variance `(1+alpha)*b_chi` (terme oscillant croisé omis), biais quadratique `-(1-sqrt(alpha))`, et 300000 tirages, graine NumPy PCG64=20261011. Ce sont des choix de simulation, non une conséquence démontrée sur les comptages de premiers. Résultats: moyennes F_15=0.04301, F_21=0.08979, F_35=0.33385, intervalles simulés à 95% respectivement [0.00948,0.10845], [0.02683,0.19936], [0.14795,0.57108]. Les observations appartiennent toutes à ces bandes descriptives, mais ces bandes **ne sont PAS** des intervalles inférentiels valides pour les premiers.

## 4. Contre-exemple préexistant
Le dossier Drive **CU-LOG-SPEC-02** documente quatre fenêtres supplémentaires (30–45M], (45–60M], (60–75M], (75–90M]: F_30 respectivement 0.014531, 0.102627, 0.168015, 0.046566. La règle exploratoire F_30<0.05 ne se prolonge pas. Ne pas choisir un nouveau seuil en réponse. Les auteurs du rapport déclarent avoir vérifié les 4x48 comptes par un crible indépendant; cet audit additionnel n'a PAS réexécuté leurs deux cribles.

## 5. Test prospectif figé avant **tout nouveau calcul au-delà de 90M**
- Une seule fenêtre future: **(100000000,300000000]**, soit alpha=1/3; aucun horizon de remplacement.
- Publier les 48 comptes et leurs deux calculs indépendants, puis F_15,F_21,F_35 ainsi que G_5=|S_chi5|²/sum_chi!=1|S_chi|², avec le caractère quadratique modulo 5 préidentifié.
- Préférence de test: intégrer les zéros des fonctions L avec une convention et un contrôle externe **avant le crible**; arrêter à l'avance la hauteur T, la borne de queue et la correction du biais. Évaluer la covariance de fenêtre, pas seulement la variance b_chi.
- Si ce modèle spectral intégral n'est pas certifiable préalablement, comparer uniquement à un **substitut gaussien exploratoire**, sans appeler son rejet une réfutation de la théorie classique. Fichier `audit_2026_10_11/recompute_conductors.py --forecast`: n=300000; seed 21020261012, moyennes [0.0430320,0.0897983,0.3335259,0.0053261], seuil de distance de Mahalanobis carrée à 99% simulé **23.8682015**; matrice de covariance fournie par la sortie exécutable. Le seuil est **prospectif pour le substitut seulement**, sans p-valeur légitime sur les premiers.
- Critère discriminant prioritaire: chercher d'abord un contre-exemple (large dépassement de la bande du modèle spectral intégral), ensuite vérifier si une statistique de Cayley ajoute encore quelque chose après conditionnement sur les énergies des caractères. Toute statistique quadratique de convolution est diagonalisée par les mêmes caractères : **elle ne peut à elle seule identifier un invariant arithmétique nouveau**.
- Tracer les éventuels échecs dans la PR sans les effacer.

## 6. Bibliographie et bornes de conclusion
Rubinstein et Sarnak (1994), *Chebyshev's Bias*; Granville et Martin (2006), *Prime Number Races*; Fiorilli et Martin, *Inequities in the Shanks–Rényi Prime Number Race*; Languasco et Zaccagnini (2010), *Computing the Mertens and Meissel–Mertens Constants for Sums over Arithmetic Progressions*. Il faut auditer les hypothèses GRH/LI et les conventions de normalisation avant d'élever le modèle au rang de prédiction.

**Gates** : [exact] orthogonalité des caractères, dimensions, décomposition rationnelle; [numérique non certifié] ratios de traces; [heuristique] gaussien et intervalles; [contredit par données archivées] seuil universel 5%; [non établi] anomalie résiduelle, nouveauté, lien spécifique T_C. Aucune fusion, aucun résultat inédit revendiqué.
