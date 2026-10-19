# COU-20 — audit bibliographique de la classification spectrale orientée
**Date de coupe : 19 octobre 2026 (Europe/Paris).**  
**Nature : audit documentaire interne, non évalué par un expert indépendant.**  
**Sources Lean :** commit `0ed4fea806063c0ffba52fc8b1d15681cfe5ee8e`, PR [#49](https://github.com/alexcour/couret-finite-verifications/pull/49) (OPEN/DRAFT à la consultation).  
**Rapport de certification :** [COU20_SPECTRAL_CLASSIFICATION_20261019.md](COU20_SPECTRAL_CLASSIFICATION_20261019.md).  
**Ticket :** [COU-20](https://linear.app/couret/issue/COU-20/deux-couleurs-formaliser-la-dichotomie-abelienne-candidat).

> **Verdict prudent : antériorité explicite et exacte de Brown (2009) sur une sous-famille cyclique infinie.** L'équivalence complète sur les groupes abéliens finis et le premier exposant de désaccord ne sont pas repérés textuellement dans les sources primaires consultées ; cela **n'établit ni leur nouveauté ni une priorité**. La vérification d'une éventuelle implication par les théorèmes généraux et la relecture humaine restent ouvertes.

## A. Objet, périmètre et indicateurs de preuve

Soient G abélien fini, h+h=0, h≠0, H=⟨h⟩, Q=G/H, δ=d+H d'ordre exact 3, ⟨a,d,h⟩=G, S={a,a+d,a+d+h}, T={a,a−d,a−d+h}. On considère les **matrices d'adjacence orientées rationnelles effectives, boucles autorisées** (sans symétrisation). Le théorème certifié affirme :

`χ(A_S)=χ(A_T) ↔ (⟨a,h⟩≠G ∨ |Q| pair)`.

Si ⟨a,h⟩=G et |Q| impair, le plus petit exposant k≥1 pour lequel les traces diffèrent est `k=|Q|/3`. La nécessité seule n'utilise pas la génération globale ; celle-ci est maintenue pour l'équivalence. Les 20 nouveaux théorèmes, 139 sorties axiomatiques et reçus de CI appartiennent au dossier de *certification formelle*, non à une preuve d'originalité.

**Codes dans la matrice :** DIRECT = spécialisation algébrique effectivement vérifiée ; MÉTHODE = mécanisme général ou résultat voisin dont le recouvrement précis reste à démontrer ; DISTINCT = invariant/conclusion différent ; INCERTAIN = texte intégral indisponible ou implication non vérifiée. « Non trouvé » n'est jamais « inexistant ».

## B. Résultat d'antériorité majeur — Julia Brown, 2009

**Source primaire accessible :** Julia Brown, *Isomorphic and Nonisomorphic, Isospectral Circulant Graphs*, arXiv:0904.1968v1, 13 avril 2009, [PDF](https://arxiv.org/pdf/0904.1968), **théorème 3.1, page imprimée 11** (page PDF 11 si indexée de zéro, soit la 11e page du document) et **exemple 3.1, page imprimée 12**. Il s'agit ici d'un préprint public antérieur ; ne pas le présenter sans vérification comme un article évalué.

Brown donne `n=2^r p`, `r≥2`, `p` premier impair, puis deux ensembles de connexion de cardinal p :
- `A={1+i·2^r : 0≤i≤(p−1)/2} ∪ {1+j·2^r+n/2 : 1≤j≤(p−1)/2}` ;
- `B={1−i·2^r : 0≤i≤(p−1)/2} ∪ {1−j·2^r+n/2 : 1≤j≤(p−1)/2}`.

Son théorème conclut **cospectralité et non-isomorphisme** des digraphes circulants. En spécialisant `p=3`, `G=Z/(3·2^r)Z`, `a=1`, `d=2^r`, `h=n/2=3·2^(r−1)`, on obtient **littéralement les supports COU-20**, avec leurs trois arcs par sommet :
`A={a,a+d,a+d+h}=S`, `B={a,a−d,a−d+h}=T`.

Contrôle des hypothèses : `2h=n=0`, `h≠0`, `3d=3·2^r=n=0`, `d∉H` donc `ord(d+H)=3`; `a=1` engendre G. Enfin `|Q|=n/2=3·2^(r−1)` est **pair pour r≥2**. En particulier Brown, exemple 3.1, n=12, donne A={1,5,11} et B={1,3,9}. COU-20 les reproduit avec `a=1,d=4,h=6` (et son autre paramétrisation `d=2` échange les supports).

**Portée exacte du recouvrement :** Brown anticipe la branche de cospectralité, et même le **non-isomorphisme**, pour une sous-famille infinie cyclique de quotient pair. Brown ne formule pas dans son théorème 3.1 la réciproque globale « non-génération ou parité », ni un diagnostic de premier désaccord des traces dans le cas impair. On ne doit **pas** confondre son théorème 1.1 (reconnaissance spectrale sous restrictions sur les petits facteurs premiers, inadaptée à m=3 et n pair) avec cette construction directement pertinente du théorème 3.1.

## C. Matrice d'antériorité vérifiable

| Référence antérieure | Objet et hypothèses réellement examinés | Conclusion de la source | Rapport exact à COU-20 | Niveau / limite |
|---|---|---|---|---|
| **Babai (1979)**, *Spectra of Cayley graphs*, J. Combin. Theory Ser. B **27**(2), 180–189, [DOI](https://doi.org/10.1016/0095-8956(79)90079-0) | Cayley, caractères irréductibles ; digraphes à arcs orientés/éventuellement colorés ; sommes de puissances de valeurs propres | Cadre général de calcul du spectre et des traces par les caractères | Le passage spectre ↔ caractère/traces est **classique**, non inventé par COU-20 ; pas de spécialisation iff démontrée par cette seule référence | MÉTHODE ; abstract de l'éditeur vérifié |
| **Brown (2009), th. 2.1**, [arXiv:0904.1968](https://arxiv.org/pdf/0904.1968) | Circulants orientés sur Z/n ; valeurs propres par racines de l'unité | Spectre donné par les sommes des caractères des éléments de S | Outil spectral classique réutilisable ; aucune priorité sur les transformées de Fourier | MÉTHODE ; texte primaire lu |
| **Brown (2009), th. 1.1**, même source | Condition sur la valence m et les plus petits facteurs premiers de n | Sous hypothèses, graphes circulants déterminés par leur spectre à isomorphisme près | Critère différent ; pour n pair et valence 3, m≤p_min ne s'applique pas | DISTINCT ; texte primaire lu |
| **Brown (2009), th. 3.1 et ex. 3.1**, même source | Z/(2^r p), r≥2, p premier impair ; digraphes ; supports construits, sans boucles dans la famille exposée | Famille infinie cospectrale et non isomorphe ; ex. n=12 | **DIRECT** : p=3 donne exactement les S,T de COU-20 pour a=1,d=2^r,h=n/2 ; branche quotient pair | DIRECT, **antériorité certaine** sur cette sous-famille ; texte primaire et substitution explicite |
| **Mönius (2020)**, *Constructions of isospectral circulant graphs*, *Elem. Math.* **75**(2), 45–57, [DOI](https://doi.org/10.4171/EM/404) | Constructions de circulants isospectraux | Construction de familles isospectrales | Risque sérieux de généralisation couvrant d'autres paramètres ; **l'article complet de l'éditeur est sous abonnement** | INCERTAIN quant à l'inclusion exacte de l'iff ; notice primaire vérifiée, pas d'attribution conjecturale |
| **Mönius (2021), th. 3.1.3, 3.1.5, 3.1.7 et 3.1.10**, thèse *Algebraic and Arithmetic Properties of Graph Spectra*, [texte consultable](https://www.researchgate.net/publication/350342437_Algebraic_and_Arithmetic_Properties_of_Graph_Spectra) | Circulants ; bijections spectrales, congruences modulo diviseurs, ensembles de somme de racines nulle ; th. 3.1.10 avec n multiple de 4 et ensembles impairs | **Critères suffisants** explicites de cospectralité ; ne classent pas toutes les paires | Les mécanismes de parité/fourier sont proches. **Une dérivation formelle du critère abélien iff n'a pas été établie dans cet audit** ; ne pas exclure un recouvrement supplémentaire | MÉTHODE / INCERTAIN ; texte long vérifié mais application exhaustive non certifiée |
| **Mönius (2021), ex. 3.1.13 et th. 3.1.19**, [thèse](https://www.researchgate.net/publication/350342437_Algebraic_and_Arithmetic_Properties_of_Graph_Spectra) | Ex. n=12 : U={5,7,11}, V={3,9,11} ; th. 3.1.19 : ensembles symétriques S=−S, T=−T (non orientés) | Exemple cospectral et construction différente | **IDENTIFICATION EXACTE À ISOMORPHISME SÉPARÉ** : U=7·{1,5,11} et V=11·{1,3,9} modulo 12, unités 7,11 ; c'est la paire Brown 2009. Le th. 3.1.19 ne s'applique pas directement aux supports orientés triples | DIRECT (n=12), sous l'équivalence explicite ; calcul modulaire exact |
| **Huang et Chang (2001)**, *Circulant digraphs determined by their spectra*, *Discrete Math.* **240**, 261–270, [DOI](https://doi.org/10.1016/S0012-365X(01)00198-4) | Détermination spectrale de circulants orientés | Conditions de détermination spectrale pour certaines classes | Problème apparenté mais pas d'identité au critère exact établie | INCERTAIN ; contrôle notice/abstract, texte complet non audité |
| **Mans, Pappalardi et Shparlinski (2002)**, *On the spectral Ádám property for circulant graphs*, *Discrete Math.* **254**, 309–329, [DOI](https://doi.org/10.1016/S0012-365X(01)00374-0) | Propriété spectrale d'Ádám, différentes valences | Critères pour certaines familles de circulants | Pas de conséquence exacte sur l'iff de COU-20 vérifiée | INCERTAIN ; résumé/notice |
| **Mönius (2020, 2022)**, *The algebraic degree of spectra of circulant graphs* [DOI](https://doi.org/10.1016/j.jnt.2019.08.002) ; *Splitting fields of spectra of circulant graphs* [DOI](https://doi.org/10.1016/j.jalgebra.2021.11.036) | Corps de décomposition / degrés algébriques des valeurs propres | Invariants des **corps**, parfois conditions nécessaires de cospectralité | Une égalité de corps ne signifie pas une égalité de multiensembles propres : **ne fournit pas directement l'iff** | DISTINCT, attention aux conditions nécessaires seulement |
| **Lu et Mönius (2023)**, *Algebraic degree of Cayley graphs over abelian groups and dihedral groups*, *J. Algebraic Combin.* **57**, 753–761, [DOI](https://doi.org/10.1007/s10801-022-01190-7) | **Groupes abéliens**, inclut **digraphes et boucles** explicitement dans définitions | Calcul des corps spectraux et degrés algébriques | Cadre objet très proche, mais **conclusion d'invariant plus faible**, pas de classification de deux supports triples ni diagnostic premier k | DISTINCT ; texte primaire ouvert |
| **Jin et al. (2026)**, *A classification of locally-quasiprimitive circulant digraphs*, [arXiv:2607.18783](https://arxiv.org/abs/2607.18783) | Digraphes circulants localement quasiprimitifs | Classification structurelle de cette sous-classe selon la symétrie des automorphismes | Classification structurelle, non cospectralité de deux supports ; aucune inclusion prouvée | DISTINCT ; abstract vérifié |
| **Godsil et Spiga (2025)**, *Integral normal Cayley graphs*, [DOI](https://doi.org/10.1007/s10801-025-01433-3) | Cayley normaux et **intégralité** du spectre | Caractérisation d'intégralité | Diffère de l'égalité des deux polynômes caractéristiques recherchée | DISTINCT ; abstract primaire vérifié |

**Caveat de couverture :** cette matrice n'est pas une recherche exhaustive de tous les articles, prépublications ou thèses. Certains textes d'éditeur sont restreints ; les résumés ne permettent pas de nier qu'un corollaire existe. Les résultats de 2026 sont retenus uniquement s'ils précèdent la coupe du 19 octobre.

## D. Implications mathématiques déjà accessibles et frontières

### D1. Premier désaccord : relation à l'art antérieur

La preuve de COU-20 comporte l'identité exacte pour **k=2m+1** :
`tr(A_S^k) − tr(A_T^k) = |G|·(−3)^m·(1_[kα=−δ]−1_[kα=δ])`, où α=a+H, δ=d+H.
En outre `A_S²=A_T²`, donc tous les exposants pairs ont les mêmes traces.

Si ⟨a,h⟩=G, alors α engendre Q. Pour q=|Q| impair, 3|q et q=3ℓ, ℓ impair. Les deux classes d'ordre 3 non nulles de Q sont ±ℓα ; δ est l'une d'elles. Les seuls retours positifs de kα à ±δ commencent au **plus petit k=ℓ=q/3**. Par conséquent :
- pour 1≤j<ℓ, les traces sont égales ;
- à j=ℓ, elles diffèrent avec amplitude `|G|·3^((ℓ−1)/2)`.

**Statut bibliographique :** Babai (1979) et Brown (2009, th. 2.1) fournissent déjà le principe général traces/caractères. Le calcul du premier exposant ci-dessus est une **spécialisation élémentaire de ce mécanisme et de l'identité particulière prouvée dans COU-20**. L'énoncé numérique `q/3` n'a pas été trouvé *explicitement* dans les sources lues ; sa nouveauté **n'est pas justifiée**, puisque sa déduction est courte une fois les structures identifiées.

### D2. Parité du quotient et portée « groupes abéliens »

Pour q pair, le groupe cyclique `Q/⟨δ⟩`, engendré par l'image de α sous ⟨a,d,h⟩=G, a cardinal q/3 pair ; la projection vers Z/2 fournit un caractère ε(a)=1, ε(h)=ε(d)=0. Le changement de signes par ε et le carré commun expliquent la branche de cospectralité. C'est une **méthode de caractère de parité**, pas une invention affirmée.

Pour q impair et ⟨a,h⟩=G, Q est cyclique impair et G est extension d'un groupe impair cyclique par C2 ; la décomposition d'ordre copremier donne G cyclique (non une famille arbitraire de groupes abéliens dans cette branche). Ainsi, l'obstruction non cospectrale de la réciproque se réduit structurellement à un cas cyclique ; ceci accroît la nécessité d'auditer les résultats classiques sur les circulants.

### D3. Ce que l'audit ne démontre pas

- Il **ne** déduit **pas** le critère complet de l'un des théorèmes publiés de Brown ou de Mönius, ni ne prouve que cette déduction est impossible.
- Il **ne** prouve **pas** l'originalité de la nécessité, de l'équivalence ou du diagnostic `q/3` ; il constate seulement l'absence de formule identique dans les extraits primaires contrôlés.
- Il ne transfère ni théorème orienté vers graphe simple non orienté, ni théorème sans boucle vers tous les supports avec boucles.
- Il ne confond pas preuve Lean interne, compilation CI, expérience finie, relecture humaine et recherche d'antériorité.
- Il ne donne ni date de priorité scientifique, ni priorité brevets, ni accord de publication.

## E. Vérifications indépendantes demandées — Gate C maintenu ouvert

1. **Brown :** faire relire humainement le th. 3.1, p=3, et son statut exact de publication ; annoter explicitement dans toute présentation future « sous-famille déjà dans Brown (2009) ».
2. **Mönius :** obtenir intégralement l'article *Elem. Math.* 2020 ; tester symbole par symbole ses constructions ainsi que celles des th. 3.1.3, 3.1.5, 3.1.7, 3.1.10 de la thèse 2021 sur S,T pour **tous** les types de quotient ; chercher une équivalence logique dérivée, pas seulement les exemples.
3. **Recherches complémentaires :** vérifier sources intégrales Huang–Chang (2001), Mans–Pappalardi–Shparlinski (2002), travaux sur isospectralité de circulants dirigés, partitions de caractères, équivalences de sommes de racines de l'unité ; documenter les cas couverts et les contre-exemples aux hypothèses.
4. **Premier k :** mener recherche ciblée « girth / first distinguishing closed walk / trace power » dans la littérature ; ne pas confondre l'exposant de désaccord et un degré algébrique spectral.
5. **Audit mathématique humain :** faire vérifier interprétation d'arc, multiplicité des éléments, boucles, nécessité du générateur global, bornes d'ordre 3, et énoncé Lean exact.
6. **Gouvernance :** maintenir COU-20 **In Progress**, PR #49 **OPEN/DRAFT**, sans fusion, release, publication ni revendication d'originalité. L'audit bibliographique est **partiel et approfondi**, non clôturé.

## F. Bibliographie de référence (liens primaires)

- Babai, L. (1979), *Spectra of Cayley graphs*, J. Combin. Theory Ser. B 27(2), 180–189. DOI [10.1016/0095-8956(79)90079-0](https://doi.org/10.1016/0095-8956(79)90079-0).
- Brown, J. (2009), *Isomorphic and Nonisomorphic, Isospectral Circulant Graphs*, [arXiv:0904.1968v1](https://arxiv.org/pdf/0904.1968), th. 1.1, 2.1, **3.1**, ex. **3.1**.
- Huang, Q., Chang, Y. (2001), *Circulant digraphs determined by their spectra*, Discrete Math. 240, 261–270. DOI [10.1016/S0012-365X(01)00198-4](https://doi.org/10.1016/S0012-365X(01)00198-4).
- Mans, B., Pappalardi, I., Shparlinski, I. (2002), *On the spectral Ádám property for circulant graphs*, Discrete Math. 254, 309–329. DOI [10.1016/S0012-365X(01)00374-0](https://doi.org/10.1016/S0012-365X(01)00374-0).
- Mönius, K. (2020), *Constructions of isospectral circulant graphs*, Elem. Math. 75(2), 45–57. DOI [10.4171/EM/404](https://doi.org/10.4171/EM/404), **article sous abonnement**.
- Mönius, K. (2021), *Algebraic and Arithmetic Properties of Graph Spectra*, thèse universitaire, [texte consultable](https://www.researchgate.net/publication/350342437_Algebraic_and_Arithmetic_Properties_of_Graph_Spectra), §3.1, th. 3.1.3–3.1.10, th. 3.1.19.
- Mönius, K. (2020), *The algebraic degree of spectra of circulant graphs*, J. Number Theory 208, 295–304. DOI [10.1016/j.jnt.2019.08.002](https://doi.org/10.1016/j.jnt.2019.08.002).
- Mönius, K. (2022), *Splitting fields of spectra of circulant graphs*, J. Algebra 594, 154–169. DOI [10.1016/j.jalgebra.2021.11.036](https://doi.org/10.1016/j.jalgebra.2021.11.036).
- Lu, L., Mönius, K. (2023), *Algebraic degree of Cayley graphs over abelian groups and dihedral groups*, J. Algebraic Combin. 57, 753–761. DOI [10.1007/s10801-022-01190-7](https://doi.org/10.1007/s10801-022-01190-7).
- Godsil, C., Spiga, P. (2025), *Integral normal Cayley graphs*, J. Algebraic Combin. DOI [10.1007/s10801-025-01433-3](https://doi.org/10.1007/s10801-025-01433-3).
- Jin, W. et al. (2026), *A classification of locally-quasiprimitive circulant digraphs*, [arXiv:2607.18783](https://arxiv.org/abs/2607.18783).

**Dernière règle :** le présent document est une note de recherches et de recouvrements vérifiés, **pas** une décision de Gate C, une attestation d'exhaustivité bibliographique ou une autorisation de publication.


## G. Deuxième passe documentaire et corollaire de Newton (19 octobre 2026)

### G1. Identification exacte Brown–Mönius au module 12

**Primaire Brown :** [arXiv:0904.1968v1](https://arxiv.org/pdf/0904.1968), théorème 3.1, exemple 3.1 (n=12), supports `S_B={1,5,11}`, `T_B={1,3,9}`.  
**Primaire Mönius :** [thèse Würzburg 2021](https://www.researchgate.net/publication/350342437_Algebraic_and_Arithmetic_Properties_of_Graph_Spectra), §3.1.3, **exemple 3.1.13**, supports `S_M={5,7,11}`, `T_M={3,9,11}`. La thèse mentionne que cet exemple ne provient pas directement des constructions 3.1.5, 3.1.7 ou 3.1.10 (pour les ensembles tels qu'écrits).

**Calcul intégral, sans approximation :**
- `7·S_B (mod 12) = {7,35 mod 12,77 mod 12}={5,7,11}=S_M`.
- `11·T_B (mod 12)={11,33 mod 12,99 mod 12}={3,9,11}=T_M`.
- `gcd(7,12)=gcd(11,12)=1`. Les deux multiplications sont des automorphismes du groupe cyclique, et donc des isomorphismes dirigés de Cayley individuellement.

**Conclusion :** le cas Mönius 3.1.13 est une autre présentation, après deux automorphismes indépendants, de la même paire de graphes orientés que Brown 2009. Cela corrige le statut antérieur « équivalence affine non vérifiée ». Il ne faudrait toutefois **pas** inférer que chaque famille construite par Mönius coïncide avec celle de Brown, ni que ses critères 3.1.5/3.1.7/3.1.10 sont équivalents à COU-20.

### G2. Conditions précises du théorème 3.1.10 de Mönius

La thèse §3.1.2, **théorème 3.1.10**, suppose notamment `4|n`, un ensemble d'équilibre formé de progressions disjointes à diviseur pair, tous ses éléments impairs, puis choisit `S` comme **la moitié** des éléments dans chaque progression et `T` comme le complément (ou le complément décalé de n/2), avec ajout éventuel d'un même ensemble `Z` d'éléments **pairs**. Ceci fournit une **condition suffisante** de cospectralité. La classification COU-20 porte sur d'autres hypothèses (groupe abélien général, supports triples, possibilité de boucles, condition nécessaire et suffisante) : aucune réduction exhaustive de COU-20 au théorème 3.1.10 n'est justifiée à cette coupe.

### G3. Premier coefficient différent du polynôme caractéristique

**Corollaire mathématique direct, sans nouvelle compilation Lean :** sous la branche `⟨a,h⟩=G`, `q=|G/H|` impair et `ord(d+H)=3`, écrire `k=q/3` (impair), `N=|G|=2q=6k`, et `χ(A)=X^N+Σ_{j=1}^N c_j(A)X^(N−j)`. Puisque `tr(A_S^j)=tr(A_T^j)` pour `j<k`, Newton donne `c_j(S)=c_j(T)` pour `j<k`. L'identité de Newton au rang k donne :

`k(c_k(S)−c_k(T)) = −(tr(A_S^k)−tr(A_T^k))`.

La formule de traces formalisée donne `|tr(A_S^k)−tr(A_T^k)|=|G|·3^((k−1)/2)=6k·3^((k−1)/2)`. Ainsi,

**`|c_k(S)−c_k(T)|=6·3^((k−1)/2)`**, et **k est le premier indice de coefficient différent**. C'est une conséquence élémentaire du certificat COU-20 + identités classiques de Newton ; **aucune originalité revendiquée**, et cette formulation n'a pas fait l'objet d'un nouveau certificat Lean.

| q impair | n=2q | k=q/3 | Différence des traces au rang k (choix a=1,d=q/3,h=q) | Différence des c_k |
|---:|---:|---:|---:|---:|
| 3 | 6 | 1 | −6 | +6 |
| 9 | 18 | 3 | +54 | −18 |
| 15 | 30 | 5 | −270 | +54 |
| 21 | 42 | 7 | +1134 | −162 |
| 27 | 54 | 9 | −4374 | +486 |

Pour q pairs 6 et 12, les premières traces et coefficients testés coïncident, conformément à la branche cospectrale mais **sans vérification exhaustive du polynôme de degré n**.

**Reproduction indépendante sur arithmétique entière :** [tests/cou20_prior_art_invariants_exact.py](tests/cou20_prior_art_invariants_exact.py). Ce script dénombre exactement les marches fermées avec les supports orientés en utilisant la convolution modulaire et reconstruit les coefficients par Newton ; il vérifie les cinq instances impaires, les deux premières tranches de quotients pairs et les deux automorphismes Brown–Mönius. L'exécution locale de la même logique a réussi le 19 octobre 2026. Le dépôt n'a pas à ce stade de nouveau reçu CI certifiant cette pièce ; la preuve universelle reste celle du commit Lean historique.

### G4. Antériorité structurelle plus ancienne

**Elspas et Turner (1970)**, *Graphs with circulant adjacency matrices*, *J. Combin. Theory* **9**(3), 297–307, [DOI 10.1016/S0021-9800(70)80068-0](https://doi.org/10.1016/S0021-9800(70)80068-0), travaillent explicitement sur les circulants dirigés **et** non dirigés, et des critères d'isomorphisme par multiplicateurs. Leur texte est une antériorité sur les outils structuraux, non une démonstration consultée de l'équivalence et de k=q/3. La thèse de Mönius (exemple 3.1.12) leur attribue par ailleurs une autre paire de digraphes cospectraux à n=32 (supports de six éléments).

**Babai (1979)**, [DOI 10.1016/0095-8956(79)90079-0](https://doi.org/10.1016/0095-8956(79)90079-0), obtient des expressions de traces/spectres de graphes de Cayley en caractères irréductibles, dans un cadre mentionnant les digraphes avec arcs colorés. Cette méthode suffit à rendre le **genre** d'argument traces/caractères ancien, sans attribuer à Babai la formule spéciale du COU-20.

### G5. Limites toujours actives

- L'article de Mönius en *Elemente der Mathematik* (2020) reste non consulté en intégralité (accès restreint sur la plateforme éditoriale). Sa thèse de 2021 est consultable ; cette distinction doit rester explicite.
- L'absence d'un énoncé `iff` identique ou d'un `k=q/3` imprimé dans les extraits lus n'est pas un certificat de nouveauté. Une implication par un théorème plus général reste plausible.
- La branche `q` impair et `⟨a,h⟩=G` est structurellement **cyclique** (extension d'un groupe cyclique d'ordre impair par C2), et l'antériorité sur les circulants demeure donc centrale.
- Statuts inchangés : relecture mathématique indépendante et Gate C ouverts ; PR #49 OPEN/DRAFT ; aucune fusion, release, publication ni revendication de priorité.



## H. Formalisation du premier coefficient — nouveau candidat (19 octobre 2026)

Un module **distinct** `lean/CayleyTwoColourFirstCoeff.lean` a été ajouté à la branche de la PR #49. Il importe `CayleyTwoColourClassification` sans modifier les anciens théorèmes et contient deux déclarations :

1. `abelianThree_first_charpoly_coefficient_at_quotient_third` : tous les coefficients renversés d'indice positif strictement inférieur à `k=|G/H|/3` sont égaux ; à l'indice `k`, ils diffèrent, pour le quotient impair engendré par a+H ;
2. `abelianThree_first_charpoly_coefficient_gap_at_quotient_third` : relation signée `k·(c_k(S)-c_k(T))=-(tr(A_S^k)-tr(A_T^k))`.

**Dépendances réutilisées :** témoin certifié du premier désaccord des traces ; `newton_coefficient_prefix_eq`, `newton_first_coefficient_ne_of_trace_prefix`, `newton_first_gap_of_trace_prefix` et `satisfiesMatrixNewton`. Le script `tests/verify_cou20_necessity.sh` est maintenant étendu au nouveau module ; le vérificateur d'axiomes doit en lire les nouveaux théorèmes publics.

**Important — statut exact à cette écriture :** code Lean **candidat ajouté, compilation du nouveau module et ses sorties `#print axioms` non encore vérifiées**. Les succès CI historiques au commit `0ed4fea...` ne certifient PAS les nouveaux fichiers. La formule numérique `|c_k(S)-c_k(T)|=6·3^((k−1)/2)` n'est pas intégrée à ces nouvelles déclarations Lean ; elle demeure conséquence mathématique de la formule de traces et du lien de Newton, avec tests exacts séparés. Ne pas écrire « nouveau théorème certifié » sans journal CI sur le SHA du nouveau module.

**Suite bibliographique :** contre-expertise sur Mönius, *Constructions of isospectral circulant graphs* (2020), DOI [10.4171/EM/404](https://doi.org/10.4171/EM/404), accès intégral toujours non établi ; comparer les théorèmes exacts et non le seul résumé. Vérifier séparément si l'énoncé « premier coefficient différent » figure ou se déduit des outils classiques (Newton + caractères) : aucune revendication de nouveauté.


### H1. Reçu CI observé après l'ajout du module (mise à jour du statut)

À la révision `bf11eba7399eaee3fe50ec59119d0f0438bc5a00`, le workflow [cou20-abelian-lean-candidate #39239651122](https://github.com/alexcour/couret-finite-verifications/actions/runs/39239651122), [job abelian-bridge #118017092973](https://github.com/alexcour/couret-finite-verifications/actions/runs/39239651122/job/118017092973), s'est terminé **SUCCESS**. Le journal inspecté signale : `SUCCESS: 141 axiom outputs checked; all 22 new public theorems covered; 10 certified source files unchanged`, puis `SUCCESS: complete COU-20 classification compiled and axiom audit passed.` Les déclarations `abelianThree_first_charpoly_coefficient_at_quotient_third` et `abelianThree_first_charpoly_coefficient_gap_at_quotient_third` figurent dans les sorties de contrôle axiomatique, avec seulement `propext`, `Classical.choice` et `Quot.sound`. Un artefact de compilation `cou20-spectral-classification-audit` a été archivé sur le workflow.

**Changement justifié de statut :** les deux nouveaux résultats sur le *premier indice caractéristique* et la *relation signée de Newton* sont à présent **certifiés par cette CI** au SHA cité. L'observation plus ancienne « candidat non compilé » en section H est historique et remplacée pour ce commit. La formule fermée en valeur absolue `6·3^((k−1)/2)` **n'est pas elle-même un théorème Lean de ce module**. Les succès des workflows ne prouvent ni nouveauté scientifique ni antériorité.
