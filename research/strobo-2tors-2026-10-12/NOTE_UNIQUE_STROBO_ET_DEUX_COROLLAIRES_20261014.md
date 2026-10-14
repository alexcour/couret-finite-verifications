# STROBO — classification des triples et deux corollaires

**NOTE SCIENTIFIQUE CANONIQUE DE TRAVAIL — 14 octobre 2026**  
**Statut : recherche, PR #25 DRAFT. Ni validation humaine indépendante, ni priorité établie, ni article publié.**

Cette note est le **seul fil narratif** envisagé pour une éventuelle rédaction scientifique. Les PR #30 (corpus Cayley et vérifications connexes), #32 (replays RECOH) et #36 (pont Fourier Lean dépendant de #25) restent des **sources techniques et historiques**, non des théorèmes fondateurs indépendants. Ne pas fusionner ni supprimer leurs historiques par simple réorganisation éditoriale. La PR #30 contient aussi des calculs Q5 étrangers au présent théorème : ne pas les absorber artificiellement.

## 1. Le résultat central : STROBO-3

Soit G un groupe abélien, S et T deux ensembles de cardinal exactement trois. On considère la fonction de représentation **étiquetée, avec les neuf couples ordonnés** :

    R_S(z) = |{ (x,y) dans S×S : x+y=z }| = (1_S * 1_S)(z).

La classification formalisée dans Strobo2TorsCore.lean dit que R_S=R_T exactement lorsque :
- **cas ordinaire** : T=S+u pour un u tel que 2u=0 ; ou
- **cas exceptionnel** : il existe a,b,d,u dans G avec 2d=0, d≠0, 2a≠2b, 2u=0, 3(b-a)∈{0,d}, et

      S={a,b,b+d},  T={a,2b-a,2b-a+d}+u.

Ces énoncés supposent l'égalité des carrés de convolution ordonnés, et non l'égalité de simples ensembles de sommes ni l'homométrie par différences. Dans le cas fini, les fibres complètes ont h ou 2h membres, où h=|G[2]|. Les dénombrements globaux et les restrictions sans zéro disposent de fichiers Lean spécifiques, avec périmètres indiqués dans la PR #25.

**Frontière de preuve au 14/10 :** l'extraction des comptes par profil X_0,...,X_3 des supports exceptionnels a été compilée sur le commit 486ccf059741645b987befd514abc62b5fb361fc (CI Lean #38634029144 et verify #38634029287 SUCCESS). La formule binomiale finale de l'histogramme ordinaire, ses cas limites et le tableau exhaustif des maxima ne sont pas déclarés certifiés tant qu'un théorème Lean portant ces conclusions n'a pas passé la CI. Ne jamais remplacer ce contrôle par un résultat Python borné.

## 2. Corollaire A : une famille de circulants orientés cospectraux

Pour tout entier m≥1, dans le groupe Z/(12m)Z, posons

    S_m={1,1+2m,1+8m},
    T_m={1,1+4m,1+10m}.

La substitution a=1, b=1+2m, d=6m, u=0 satisfait 2d=0 et 3(b-a)=d. STROBO donne donc **exactement** R_(S_m)=R_(T_m), autrement dit A_(S_m)^2=A_(T_m)^2 pour les matrices d'adjacence de Cayley dirigées (arcs x→x+s).

Tous les incréments sont impairs. En écrivant λ_S(j)=Σ_(s∈S)ζ^(js) pour ζ=exp(2πi/(12m)), on a :

    λ_S(j+6m)=-λ_S(j),  λ_T(j+6m)=-λ_T(j);
    λ_S(j)^2=λ_T(j)^2  pour tout j.

Pour chaque paire de caractères j,j+6m, les deux ensembles non ordonnés d'autovaleurs sont donc identiques : {λ_S(j),-λ_S(j)}={λ_T(j),-λ_T(j)}. Ainsi **les spectres complexes des digraphes coïncident avec multiplicités**.

**Lemme de portée plus large :** si A et B sont deux matrices d'adjacence bipartites de même ordre (même si elles ne sont pas symétriques), et A²=B², alors leurs polynômes caractéristiques sont égaux : traces impaires nulles, traces paires communes, identités de Newton. Cette implication ne requiert PAS une valence de trois. Pour k=4, le verrou n'est donc pas le lemme spectral, mais l'existence/classification de supports de cardinal quatre ayant carré commun ET une bipartition adaptée; pour revendiquer des graphes non isomorphes, il faut un certificat d'isomorphisme distinct. En général, **A²=B² sans bipartition ne suffit pas** à la cospectralité.

**Antériorité importante :** au paramètre m=2, S={1,5,17} et T={1,9,21} modulo 24. Après symétrisation S∪(-S), T∪(-T), la multiplication par 11 donne les ensembles non orientés

    {5,7,11,13,17,19} et {3,9,11,13,15,21},

qui correspondent à **Katja Mönius, Algebraic and Arithmetic Properties of Graph Spectra, exemple 3.1.20**. Il ne faut donc pas revendiquer la nouveauté de cette paire non orientée. L'intérêt éventuellement distinct serait la réduction structurale systématique du cas orienté à la classification STROBO, à confronter aux sources primaires. Voir Brown (2009), Mönius (2020), Huang–Chang (2001) ; la référence « Meng 1998 » nécessite une vérification bibliographique précise.

La construction indépendante de type K×C_p (p≥5), fondée sur des relations de sommes de racines de l'unité, **n'est pas subsumée par STROBO à ce jour**. Ne pas déduire d'un mécanisme de cospectralité différent qu'il provient de l'égalité de deux carrés de convolution.

## 3. Corollaire B : sondes de Fourier après observation du carré — RECOH

Ce volet impose des hypothèses d'observation distinctes : G abélien **fini**, S support de **trois éléments** (le neutre peut appartenir à S), R_S **étiqueté connu**, puis banque **fixe, universelle** de coefficients de Fourier complexes **individuels et étiquetés** χ↦Σ_(x∈S)χ(x). Le coût initial de R_S n'est pas compté. Il ne s'agit ni d'un spectre non étiqueté, ni de sondes d'appartenance, ni de sondes adaptatives ou bruitées.

Écrivons |G[2]|=2^r et |G[3]|=3^s. L'argument mathématique interne tiré de la classification STROBO annonce, pour ce modèle **seulement** :

    B(G)=0 si r=0 ; B(G)=r+s si r≥1.

**Idée de borne supérieure :** r caractères 2-primaires qui séparent les translations de G[2] et s caractères 3-primaires qui distinguent les deux classes réfléchies d'une fibre exceptionnelle. Une somme de trois racines de l'unité d'ordre 2^k ne peut s'annuler, donc les r caractères séparent effectivement les translations. Les s caractères détectent v≠0 dans G[3].

**Idée de borne inférieure :** si les restrictions à G[2] n'ont pas rang r, une translation non nulle de G[2] reste invisible. Sinon choisir r restrictions indépendantes et d∈G[2] avec valeur -1 sur ces r caractères ; sous k<r+s sondes, moins de s autres caractères satisfont χ(d)=+1. Choisir v∈G[3]\{0} annulé par ces restrictions résiduelles. Les deux triples exceptionnels {0,v,v+d} et {0,-v,-v+d} ont alors le même R et les mêmes lectures de la banque. Le raisonnement est interne et requiert une mise en forme rigoureuse des dualités/rangs et de toutes les conditions limites.

**Frontière de validation :** la preuve générale B(G)=r+s est rédigée en interne et corroborée sur des groupes finis. Elle n'est PAS encore une certification Lean universelle. La PR #36 fournit seulement des lemmes Fourier/masques/noyaux conditionnels; la PR #32 fournit des vérifications exactes bornées. Ces artefacts restent des dépendances techniques de STROBO, pas un second résultat central indépendant.

## 4. Test falsifiable k=4

Chercher des 4-supports S,T tels que R_S=R_T, non reliés par les équivalences triviales pertinentes, puis vérifier en plus :
1. un caractère de parité commun (pour obtenir bipartition et cospectralité) ;
2. l'absence d'isomorphisme des digraphes, via un invariant vérifiable.

Le lemme biparti est valable pour k=4 : **l'existence de nouvelles paires non isomorphes** est la véritable question expérimentale. Étiqueter comme inconnue toute originalité externe.

## 5. Discipline éditoriale, correspondance et gates

Manuscrit UNIQUE : (I) théorème STROBO sur R_S, (II) corollaire Cayley, (III) corollaire RECOH avec son modèle de sondes. Les jeux de tests, PR et fichiers Lean restent citables séparément en annexes techniques, sans constituer trois dossiers de priorité.

- **Chen :** première correspondance exclusivement sur les fonctions de représentation et la classification STROBO; ne pas inclure Cayley dans ce courrier ni envoyer automatiquement un nouveau message.
- **Katja Mönius :** lectrice naturelle du corollaire circulant **après** un éventuel retour de Chen; vérifier le dossier de correspondance avant envoi, aucune sollicitation créée par cette note.
- **Antériorités :** lire et comparer énoncé par énoncé Lev 2004, Chen et suites, Brown 2009, Mönius 2020, Huang–Chang 2001, et préciser correctement Meng. L'exemple non orienté n=24 est déjà connu.
- **Gates :** pas de fusion des PR #25/#30/#32/#36, pas de déploiement, pas de DOI, pas de revendication de première preuve ou d'originalité. Une CI réussie n'est ni une relecture indépendante ni une démonstration d'antériorité négative. Les résultats FCI/CONT et les correspondances privées ne sont pas reproduits.

**Références internes :** [STROBO #25](https://github.com/alexcour/couret-finite-verifications/pull/25), [Cayley #30](https://github.com/alexcour/couret-finite-verifications/pull/30), [RECOH calcul #32](https://github.com/alexcour/couret-finite-verifications/pull/32), [RECOH Lean #36](https://github.com/alexcour/couret-finite-verifications/pull/36).

**Références extérieures :** Lev (2004), DOI 10.37236/1831 ; Brown (2009), arXiv:0904.1968 ; Mönius (2020), DOI 10.4171/EM/404 ; Huang–Chang (2001), DOI 10.1016/S0012-365X(01)00198-4 ; Mönius, thèse exemple 3.1.20, https://d-nb.info/1230324208/34 .
