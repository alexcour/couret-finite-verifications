# Cayley — addendum bibliographique ciblé : Tang–Liu–Lu 2025 et Ishikawa–Nakano–Sadahiro 2026

**État documentaire : 9 octobre 2026.** Annexe au dossier de relecture Frédéric / PR #7. Évaluation **claim-by-claim** à partir de l'article éditeur Tang–Liu–Lu et de la notice éditeur Ishikawa–Nakano–Sadahiro, confrontées au texte intégral public de la prépublication arXiv 2408.01666v5. Ne constitue **ni une revue exhaustive des antériorités, ni une certification de preuve, ni une revendication de nouveauté**. Aucun autre programme ni matériel confidentiel n'est abordé.

## Références primaires vérifiées

1. Lang Tang, Weijun Liu et Rongrong Lu, **“Non-Isomorphic Cayley Graphs of Metacyclic Groups of Order 8p with the Same Spectrum”**, *Mathematics* **13**(12), article 1903 (2025), 14 p.; publication le 6 juin 2025. DOI : https://doi.org/10.3390/math13121903 ; texte éditeur : https://www.mdpi.com/2227-7390/13/12/1903 .
2. Masao Ishikawa, Fumihiko Nakano et Taizo Sadahiro, **“Non-isomorphic Cayley Graphs with Identical Random Walk Distribution”**, *The Electronic Journal of Combinatorics* **33**(3), #P3.6 (2026), publié le 3 juillet 2026. DOI : https://doi.org/10.37236/14208 ; notice éditeur : https://www.combinatorics.org/ojs/index.php/eljc/article/view/v33i3p6 . Antériorité de diffusion : **arXiv:2408.01666, première version du 3 août 2024**; texte de travail examiné : **v5 du 6 mai 2025**, https://arxiv.org/abs/2408.01666 , https://arxiv.org/pdf/2408.01666 . Les numéros de théorèmes et pages ci-dessous renvoient à **cette v5**, et doivent être recoupés avec la mise en pages finale avant citation précise de pages de revue.

## Définition commune et frontières de comparaison

Le mot « spectre » dans 10A6, 10C3 et 10B1 désigne le **multiensemble complexe des valeurs propres de la matrice d'adjacence, avec multiplicités**, des graphes de Cayley **orientés**. Le support peut contenir l'élément neutre (boucles préservées). L'égalité spectrale est une égalité exacte des multisets, **pas** une égalité de module des valeurs propres, de lois des marches, de distance de variation totale ou de seuls moments partiels.

- **10A6 (p >= 5)** : H abélien fini engendré par kappa != kappa', G = H x C_p, T = {(kappa,0),(kappa,1),(kappa',0)}, T+ = T+(0,1). Pour cette paire prescrite, équivalence annoncée entre cospectralité, existence d'un morphisme h : H -> F_p avec h(kappa') = 1 et h(kappa) dans {1,2}, et automorphisme explicite envoyant T sur T+. Preuve auto-déclarée mais **non relue indépendamment**; originalité **non auditée**.
- **10C3 (p = 3)** : pour 3 ne divisant pas |H|, le critère spectral est beta(Gamma) = Gamma, beta(u,v) = (-v,-u), Gamma étant le groupe des paires de valeurs des caractères de H; avec 3 divisant |H| (toute puissance de 3 admise), un critère h analogue s'applique. La branche beta ne doit pas être remplacée par une implication universelle d'isomorphisme.
- **10B1** : pour k pair, 3 ne divisant pas k et mu dans U(k)[2] privé de {1}, T_mu = {(1,0),(1,1),(mu,0)} sur C_k x C_3. Assertion : mu -> Spec(T_mu) est injective **à l'intérieur de cette famille**, sans prétendre épuiser tous les digraphes cubiques du même ordre.

## Article Tang–Liu–Lu : hypothèses et théorèmes utiles

- Groupe : **M_(8p) métacyclique non abélien**, p premier impair, d'ordre 8p et de centre d'ordre 4; les caractères irréductibles du groupe servent à calculer le spectre.
- Objets : graphes de Cayley **simples non orientés, réguliers et connexes**, supports symétriques S = S^{-1} et sans neutre, dans les constructions comparées. Leur invariant est bien l'**adjacency spectrum** comme multiensemble; l'article définit **Cay-DS** à l'échelle de tous les graphes de Cayley sur le même groupe, et pas seulement d'une paire obtenue par translation du support.
- **Théorème 1** : pour p >= 5, énonce des familles de paires de graphes de Cayley sur M_(8p) **cospectraux et non isomorphes**; le texte donne le paramètre de valence 12 <= d <= 2p+13 et traite les degrés complémentaires \bar d = 8p-d-1 (avec formules de comptage combinatoire). Ne pas exporter cette plage ou son dénombrement hors de ses hypothèses.
- **Proposition 2** : M_(8p) est **Cay-DS si et seulement si p = 3** dans le cadre de l'article. **p = 3 ici est le paramètre du groupe non abélien M_24, pas le C_3 de 10C3**.
- **Techniques transférables** : calcul par représentations/caractères irréductibles, construction de supports symétriques, preuve de non-isomorphisme par invariants et automorphismes, passage au complément et contrôle des multiplicités. Ces techniques peuvent servir de contrôle *externe*, mais ne sont pas un raccourci vers la preuve cyclotomique de 10A6.
- **Verdict** : antériorité générale pertinente sur la non-détermination spectrale des graphes de Cayley; **famille différente** (non abélienne et graphes non orientés de valence >= 12 dans le théorème 1). Ni contre-exemple ni recouvrement exact identifié pour les **paires prescrites à trois arcs** 10A6/10C3 ni pour l'injectivité 10B1.

## Article Ishikawa–Nakano–Sadahiro : théorèmes et distinction cruciale

- Groupes de permutations **S_n ou A_n**, non abéliens dans les constructions non triviales; supports de **trois** éléments, graphes de Cayley **orientés** (la définition n'impose pas S = S^{-1}, ni la connexité). Les supports sont produits par la combinatoire de taquins / *sliding block puzzles* sur des graphes theta.
- Dans **arXiv v5, théorème 2**, les **revêtements doubles canoniques** Cay(G x C_2, S_1 x {1}) et Cay(G x C_2, S_2 x {1}) sont isomorphes dans les cas étudiés. Cela ne dit pas que les graphes d'origine sont isomorphes.
- Dans **arXiv v5, théorème 3 et corollaire 1**, les lois de marche à t pas coïncident après application d'une **bijection des sommets qui dépend de la parité de t**; les distances en variation totale coïncident. **Ne pas remplacer la famille de bijections temporelles par une seule conjugaison des matrices de transition**.
- Dans **arXiv v5, théorèmes 6 et 7**, la relation des polynômes caractéristiques via revêtements/zêtas sépare une **moitié commune du spectre** et une **moitié opposée en signe**; les graphes construits sont non isomorphes. Les auteurs précisent que les paires de leur construction **ne sont pas isospectrales**.
- **Témoin explicite S_3** (introduction v5) : S_1={sigma,sigma^{-1},tau}; S_2={tau,tau sigma,id}. Les polynômes caractéristiques sont respectivement (x-3)(x-1)x^2(x+2)^2 et (x-3)(x-2)^2 x^2(x+1). Ils sont **différents** bien que les lois de marche soient appariables à chaque pas.
- **Techniques transférables** : revêtement double, bijections de chemins indexées par le temps, zêtas de graphes et facteurs d'Artin, factorisation du polynôme caractéristique. Pertinents pour **tester l'insuffisance d'un invariant de marche** ou construire des contrôles négatifs; **pas** une preuve de cospectralité.
- **Verdict** : antériorité de diffusion **août 2024** d'un phénomène différent; elle **ne couvre pas 10A6/10C3/10B1 à ce stade**. Attention : l'expression « même distribution de marche » ne saurait être résumée « même spectre ».

## Matrice des décisions

| Énoncé examiné | Tang–Liu–Lu (2025) | Ishikawa–Nakano–Sadahiro (2024/2026) | Verdict |
| --- | --- | --- | --- |
| 10A6 : critère h et équivalence cospectralité/isomorphisme de T vs T+ sur H abélien, p>=5 | Groupes non abéliens, graphes non orientés de plus grande valence; construction non directement couverte | Supports triples mais groupes non abéliens et spectres en général distincts; pas de translation T+ ni de h | **Aucune antériorité exacte établie; N non auditée; relecture de preuve requise** |
| 10C3 : critère beta si 3∤|H|, h si 3 divise | p=3 signifie autre groupe (M_24), non le même énoncé | Pas de beta(Gamma), ni h sur H abélien | **Aucune antériorité exacte établie; N non auditée** |
| 10B1 : injectivité mu -> spectre dans sous-famille cyclique p=3 | Aucune paramétrisation mu par involutions de U(k) | Pas d'injectivité de mu -> Spec(T_mu) | **Aucune antériorité exacte établie; N non auditée** |

**Ce qui reste antérieur établi ailleurs** : Brown et Mönius recouvrent certaines sous-familles cycliques; ce document ne les réévalue pas. **Ce qui reste ouvert** : pages primaires de J. Meng (1998), confrontation complète Huang–Chang, représentations équivalentes des graphes sous d'autres coordonnées, revue humaine indépendante des arguments cyclotomiques et du cas p=3. L'absence de recouvrement dans les deux articles examinés **n'établit pas la nouveauté**.

## Consigne éditoriale et jalons

1. Ajouter ces deux références dans la bibliographie de la future note, avec DOI et arXiv 2408.01666 pour la chronologie; citer leur **théorème précis**, pas seulement le titre/résumé.
2. Signaler séparément la différence « graphes non abéliens non orientés » et la différence « même marche mais spectres différents ».
3. Vérifier à l'édition EJC finale la numérotation du texte arXiv v5, les conventions des graphes et les éventuelles corrections entre versions.
4. Pour 10A6, 10C3 et 10B1, conserver **E : revendication de preuve interne non validée indépendamment ; N : NON AUDITÉE**; aucune priorité, première classification, release stable ou soumission présentée comme autorisée.
5. Garder le présent addendum dans la **PR #7 en brouillon**; aucun contenu d'autres chantiers, données privées ou manuscrit inédit ne doit être ajouté à cette pièce publique.
