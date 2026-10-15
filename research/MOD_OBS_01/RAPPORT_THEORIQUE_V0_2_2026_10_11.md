# CU-MOD-OBS-01 — Observabilité et suffisance certifiante minimale

**Rapport transversal v0.2 — 11 octobre 2026 — NON AUDITÉ / PAS DE REVENDICATION D'ORIGINALITÉ**

## Résumé et objectif

Ce document consolide STROBO-C3, MOD-OBS, OBS-SEQ-04 et CU-LOG-SPEC-02. Il distingue : (A) la détermination d'objets mathématiques par des observations partielles ; (B) la détermination d'une propriété sans reconstruction complète ; (C) le coût des observations et certificats ; (D) les limites épistémiques de la recherche assistée par IA. Il est établi dans une fenêtre de contexte à partir de preuves symboliques proposées et d'archives existantes. Aucun nouveau crible, calcul exhaustif, essai génératif ou test statistique n'est exécuté ici.

## 1. Statuts des énoncés

STATUTS. E = preuve interne candidate, non vérifiée indépendamment ; Q = contrôles finis reproductibles documentés dans les archives, sans nouvel audit dans cette note ; N = antériorité non établie ; R = relecture indépendante ouverte. Le langage « théorème » dans les notes antérieures désigne parfois un énoncé démontré en interne, pas une acceptation scientifique. Les observations arithmétiques expérimentales ne sont pas transformées en théorèmes universels. La branche principale GitHub demeure inchangée ; tous les ajouts restent dans une PR en brouillon.

## 2. STROBO-C3 : problème des objets

Pour n ≥ 5, G_n = Z/nZ. Un support S possède trois éléments distincts. Le graphe de Cayley orienté associé a pour matrice A_S(x,y) = 1 si y−x appartient à S. Dans Z[X]/(X^n−1), F_S(X) = ∑_{s∈S} X^s ; l'égalité A_S² = A_T² équivaut à F_S² = F_T². Il faut préciser si 0 est autorisé. La classification candidate, discutée dans la PR #8, dit que les seules possibilités sont : identité S=T ; lorsque n est pair, demi-translation T=S+n/2 ; ou, lorsque n=6m, les collisions exceptionnelles formées, à échange des supports près, par S={a+3mε,a+m,a+4m} et T={a+3mη,a+2m,a+5m}, ε,η∈{0,1}. Pour un support de cardinal trois et n impair, l'unicité S=T suit immédiatement de la réduction modulo 2, car le doublement est bijectif.

La formule proposée pour les paires exceptionnelles non ordonnées de supports distincts non nuls est E(n)=2n−11 si 6 divise n, et E(n)=0 sinon. Elle compte des PAIRES DE SUPPORTS, pas des classes d'isomorphisme ni des graphes non isomorphes. La formule totale candidate est K(n)=0 pour n impair et, pour n pair, K(n)=(1/2)·C(n−2,3)+1_{6|n}(2n−11). Ces expressions sont à recontrôler sur le domaine et la définition des supports.

## 3. Réconciliation des univers à n=18

Lorsque 0 est autorisé : C(18,3)=816 supports. Le rapport OBS-SEQ-04 rapporte 390 fibres de taille deux et 9 fibres de taille quatre pour S→A_S² : 390×2+9×4=816 et 390×C(2,2)+9×C(4,2)=444 paires de supports à carré égal. Lorsque 0 est exclu : C(17,3)=680 supports ; la classification STROBO propose 118 fibres de taille un, 269 fibres de taille deux et 6 fibres de taille quatre : 118+2×269+4×6=680 et 269+6×C(4,2)=305 collisions. Cette dernière répartition est DÉDUITE DE LA CLASSIFICATION CANDIDATE, pas une nouvelle énumération indépendante. Les nombres 444 (OBS-SEQ) et 305 (STROBO non nul) sont donc compatibles, car ils concernent deux univers différents.

## 4. MOD-OBS : observations, fibres et reconstruction

Soit un ensemble fini non vide X, une observation O:X→Y et une propriété g:X→{0,1}. La connaissance de O(x) suffit à déterminer g(x) si et seulement si g est constante sur chaque fibre O^{-1}(y), c'est-à-dire O(x)=O(z) implique g(x)=g(z). Preuve : nécessité par indiscernabilité ; suffisance par factorisation g=ĝ∘O sur O(X). Ce critère est classique : il n'est pas proposé comme invention nouvelle. Il montre qu'une propriété peut être certifiée sans reconstruction complète de l'objet.

Dans le modèle où la matrice complète A_S² est déjà connue et où l'on peut interroger sans erreur q_x(S)=1_{x∈S}, la classification candidate donne le coût minimax en nombre de questions supplémentaires D(n) : zéro pour n impair ; une pour n pair non divisible par 6 ou n=6 ; deux pour n≥12 divisible par 6. Il s'agit d'un coût EN NOMBRE DE QUESTIONS, non du coût de production de A_S². L'atteinte de la borne pour une fibre de quatre candidats s'obtient par les questions d'appartenance en a et a+m ; la borne inférieure est ceil(log₂4)=2. Comme ce résultat dépend de la classification STROBO, son statut est conditionnel à son audit.

Dans un graphe de Cayley sur un groupe abélien fini, l'observation des DEUX MATRICES COMPLÈTES A² et A³ permet de reconstruire A : les caractères de Fourier diagonalisent simultanément les matrices, et chaque valeur propre λ est déterminée par (λ²,λ³), avec λ=λ³/λ² lorsque λ²≠0 et λ=0 sinon. Ce fait élémentaire ne signifie pas que deux traces scalaires suffisent.

## 5. OBS-SEQ-04 : résultat sur une banque fixée de sondes

Le rapport consolidé original du 11/10/2026 (17 pages, PDF et Word, conservés sur Drive) décrit, pour l'univers de 816 supports avec zéro autorisé, 444 paires indistinguables par le carré. Une banque FIXÉE de 22 sondes scalaires a été évaluée ; le meilleur choix d'une sonde laisse 90 paires, de deux sondes laisse 24 paires et une famille de trois couvre les 444. La minimalité de trois est relative à cette banque et à son modèle de coût unitaire. Elle ne contredit pas D(18)=2 dans le modèle différent d'appartenance à un support. Les résultats de transcription sur IT2a et ZL3b portent sur DEUX TRANSCRIPTIONS D'UN MÊME MANUSCRIT, et non deux expériences historiques indépendantes.

Limites documentées : dans l'archive expérimentale, 22 empreintes SHA-256 sur 22 concordent avec les membres couverts, mais le vérificateur embarqué échoue en raison d'une divergence de schéma du manifeste. Le protocole génératif G2 présente des défauts de traitement des frontières de folio/paragraphe et des risques de fuite de gabarit : aucune inférence sur le mécanisme historique de production n'est certifiée. Le rapport OBS-SEQ-04 a été retrouvé dans la bibliothèque ChatGPT, puis transféré sur Drive SANS modification de son contenu.

## 6. CU-LOG-SPEC-02 : résultat négatif et certificat entier

Le dossier d'expériences sur les premiers modulo 210 (PR #11, brouillon) rapporte quatre fenêtres jusqu'à 90 millions, avec fractions d'énergie F30 ≈ 1,4531 %, 10,2627 %, 16,8015 % et 4,6566 %. Les deux fenêtres centrales dépassent la borne exploratoire de 5 %. Il ne s'agit ni de la réfutation d'un théorème ni d'une preuve d'une loi arithmétique nouvelle. Le ratio analytique de traces ≈3,4208 % n'est pas une prédiction directe de ces fenêtres linéaires. Le biais de Chebyshev doit être distingué des fluctuations.

Un contrôle exact est possible dès que les 48 comptages n_a par fenêtre sont établis. Posons N=∑n_a, S₂=∑n_a² ; pour les huit regroupements modulo 30, B_j=∑_{a mod 30=j}n_a et G₂=∑B_j². Alors F30=(8G₂−N²)/(48S₂−N²), pour 48S₂−N²>0. Par calcul rationnel exact : F30>1/20 si et seulement si Q=160G₂−48S₂−19N²>0. La note d'audit interne sur les comptes archivés donne Q=-4 603 867 ; +9 286 949 ; +14 206 597 ; -470 732, dans l'ordre des quatre fenêtres. Ces entiers ont été consignés dans un audit antérieur ; ils ne sont PAS recalculés indépendamment dans ce dépôt. L'égalité de fractions et le critère de signe sont algébriques, sans modèle probabiliste. Ils ne certifient pas à eux seuls la justesse des cribles de nombres premiers.

## 7. Définition de la suffisance certifiante minimale

Fixons des hypothèses H et l'ensemble non vide X_H des situations qui y satisfont. Pour un jeu E d'observations jugées fiables, notons V_H(E) le sous-ensemble des situations compatibles. E est SUFFISANT POUR UNE PROPRIÉTÉ P lorsque V_H(E) est non vide et inclus dans {x∈X_H:P(x)}. Cette garantie est RELATIVE à H, aux observations admissibles et à la fidélité de leur acquisition. Elle n'est pas une garantie absolue de vérité empirique. Un système de vérification et une correspondance fidèle entre l'énoncé informel et sa formalisation restent nécessaires.

Pour un ensemble fini de couples d'objets à séparer E_{O,g}={{x,z}:O(x)=O(z),g(x)≠g(z)}, chaque sonde q sépare une partie Δ_q de ces paires. Une famille non adaptative J suffit si et seulement si l'union des Δ_q pour q∈J est E_{O,g}. Avec des coûts positifs c(q), l'optimisation min_{J couvrant E_{O,g}}∑_{q∈J}c(q) est une instance de SET COVER, donc un problème déjà connu. Les politiques ADAPTATIVES relèvent d'arbres de décision et peuvent avoir un coût différent ; elles ne doivent pas être assimilées à cette couverture fixe.

Pour la certification d'une proposition P, on peut définir de manière purement conditionnelle C*(P)=inf_{(E,π) valides}[c_acquisition(E)+c_construction(π)+c_verification(π)]. Sans une classe spécifiée de certificats, un système de preuve, une fonction de coût et une notion de correction du vérificateur, cette expression n'est pas une mesure universelle de la vérité. Prouver qu'un certificat est suffisant et prouver qu'aucun moins coûteux ne l'est constituent deux obligations distinctes.

## 8. Antériorités et risques d'interprétation

Le métaraisonnement, l'apprentissage exact par requêtes, la dimension de séparation, les arbres de décision, la complexité des preuves et la vérification formelle possèdent une littérature établie. La formulation « garantie épistémique minimale » n'est pas présentée comme une invention de ces outils. L'article d'Ishikawa, Nakano et Sadahiro sur des graphes de Cayley à distributions de marches identiques, paru dans Electronic Journal of Combinatorics 33(3), P3.6 (2026), est un antécédent apparenté, non identifié ici comme équivalent au théorème STROBO sur les carrés. Toute revendication de priorité exige une recherche bibliographique primaire.

## 9. Portes de validation et prochaines actions

(E) Soumettre la preuve STROBO-C3 à un mathématicien indépendant, notamment l'exhaustivité des configurations et les conventions de support. (Q) Contrôler l'origine des dénombrements et vérifier les fichiers OBS-SEQ-04 sur un environnement vierge, en documentant la correction du vérificateur sans réécrire l'archive historique. (N) Réaliser une analyse d'antériorité centrée sur les fonctions de représentation additive et les problèmes de reconstruction. (R) Demander une relecture externe séparant rigueur algébrique, code, statistiques et interprétations. Pré-enregistrer toute nouvelle expérience de covariance temporelle AVANT consultation de nouvelles fenêtres.

## 10. Décision scientifique et liens sources

Décision : conserver un programme DOUBLE, mathématiques des objets et mathématiques des modèles d'observation, sans prétendre à une théorie générale de la vérité ni à une supériorité pratique sur les IA existantes. Le résultat négatif de CU-LOG-SPEC-02 est conservé sans correction rétroactive du seuil. Les résultats OBS-SEQ de minimalité sont toujours annoncés relativement à leur banque. Aucun merge, DOI, HAL, arXiv ou revendication de priorité n'est autorisé par ce rapport.

Sources primaires : STROBO PR #8 https://github.com/alexcour/couret-finite-verifications/pull/8 ; CU-LOG-SPEC PR #11 https://github.com/alexcour/couret-finite-verifications/pull/11 ; OBS-SEQ Drive https://drive.google.com/drive/folders/18qhTtx21WjoerDT6UsPF4vOTQNjSCFgS ; STROBO Drive https://drive.google.com/drive/folders/12VZ4WRYa1XE3i1lVX-GjBPbBRGCysNk7 . Références générales : Russell–Wefald (1991), Cook–Reckhow (1979), apprentissage exact et théorie de l'information ; toutes à confronter à la littérature primaire avant prétention d'originalité.

FIN DU RAPPORT — V0.2 / DRAFT / RELECTURE CONTRADICTOIRE OUVERTE.
