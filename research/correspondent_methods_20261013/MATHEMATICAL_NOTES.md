# Des parcours de recherche aux mécanismes vérifiables

Couret–Unification — approfondissement du 13 octobre 2026.

Statut : note de travail, preuves écrites internes et calculs finis exacts. Aucune revendication de priorité, de validation humaine externe, de certification Lean de ce dossier ou de densité arithmétique. Les approches locales suivent les indications d'Oleksiy Babanskyy et le cadre de Mahatab–Sampath. Les références publiques et les artefacts du programme restent distincts.

## 1. Bailleul : spécialiser le théorème existant

Bailleul–Hayani–Untrau, arXiv:2603.20093v2, §5, traitent déjà des poids réels non nuls de moyenne nulle. Le théorème 5.13 contrôle W1 sous GRH et ELI_A ; le théorème 5.17 et les lemmes 5.14–5.16 passent aux probabilités de signe. L'hypothèse quantitative sur les combinaisons de zéros est plus forte que LI. Leur théorème 3.4 offre une borne finie avec constantes explicites sur le tore. Ces résultats ne certifient pas notre densité numérique.

### Spécialisation exacte calculée ici

Sur U(30), t=8·1_{1,11,29}−3. Convention : t_hat(χ)=(1/8)Σ_a t(a)·conj(χ(a)). Écrire χ_{u,v}(a)=(-1)^{u e3(a)} i^{v e5(a)}, où 2^{e5(a)}=a mod 5 et (-1)^{e3(a)}=a mod 3.

| u | v | conducteur | t_hat | (t*)_hat |
|---|---|---|---|---|
| 0 | 0 | 1 | 0 | 1 |
| 0 | 1 | 5 | 1 | 0 |
| 0 | 2 | 5 | 3 | 4 |
| 0 | 3 | 5 | 1 | 0 |
| 1 | 0 | 3 | −1 | 0 |
| 1 | 1 | 15 | 1 | 0 |
| 1 | 2 | 15 | −1 | 0 |
| 1 | 3 | 15 | 1 | 0 |

Ici t*(a)=t(a²). Ainsi |supp(t_hat)|=7, λ(t)=9, λ(t*)=5, ||t_hat||∞=3 et k(t)^7=3^4·5^6. Le paramètre de l'article est C(t)=max(9·log(30)^2,5·log(30))=9·log(30)^2, environ 104,1133. Cette décimale est indicative ; les identités précédentes sont exactes. Le terme moyen du modèle classique est −(1/8)Σ_a t(a)·#{b∈U(30):b²=a}=−1.

Ce calcul enlève une ambiguïté de normalisation, mais ne fournit ni la constante cachée des taux asymptotiques ni une minoration des combinaisons de zéros. Une multiplication de t par une constante positive conserve la probabilité de signe et change les constantes de W1 : conserver une seule normalisation dans toute la chaîne.

### Une borne finie plutôt que la seule positivité d'un minimum

Soit γ=(γ_1,…,γ_N) un vecteur de fréquences et L=X−x0>0, en temps logarithmique. Pour un entier H≥1, définir Δ_H=min_{0<||m||∞≤H}|m·γ|. Si chaque combinaison non nulle a une minoration certifiée, le théorème 3.4 donne, pour la mesure de Haar du tore complet,

W1(ν_X,Haar) ≤ 4√(3N)/H + (2/L)·[Σ_{0<||m||∞≤H} 1/(||m||2²·|m·γ|²)]^(1/2).

En remplaçant chaque dénominateur par Δ_H et ||m||2² par 1, on obtient la majoration grossière 4√(3N)/H + 2√((2H+1)^N−1)/(L·Δ_H). Elle explique pourquoi Δ_H>0 seul ne suffit pas : sa valeur doit être assez grande au regard de L et du nombre de combinaisons. Si une relation exacte existe, le théorème vise le sous-tore fermé approprié ; la mesure de Haar du tore complet n'est plus la bonne cible.

Pour des intervalles γ_j∈[a_j,b_j], un calcul dirigé forme l'intervalle de m·γ. La distance de cet intervalle à zéro fournit une minoration ; un intervalle contenant zéro ne certifie aucune positivité. L'examen de quelques relations ne couvre pas la boîte entière. À N=67,H=1, il existe (3^67−1)/2=46 354 731 573 948 918 542 880 962 705 293 paires {m,−m}. Ce coût interdit une prétendue vérification exhaustive naïve de la boîte.

### Le budget à écrire avant tout calcul de densité

La comparaison de la loi arithmétique à un modèle numérique doit distinguer : (i) erreur de formule explicite à horizon fini ; (ii) équidistribution de la trajectoire des basses fréquences ; (iii) queue omise ou remplacée ; (iv) erreurs sur les zéros et coefficients ; (v) quadrature ou inversion. Ces cinq erreurs portent parfois sur des métriques différentes et ne s'additionnent pas directement.

Si W1(ν,ν')≤R et ν possède une densité bornée par K, le lemme 5.15 fournit |ν(0,∞)−ν'(0,∞)|≤2√(KR). Pour g(z)=μ+Σ_j r_j Re(z_j), le transport de W1 coûte au plus ||r||2 avec la métrique produit des longueurs d'arc : c'est Cauchy–Schwarz appliqué à |g(z)−g(z')|. Une borne sur une queue gaussienne ne remplace donc pas le contrôle temporel de la trajectoire ni la borne K. La prochaine livraison pertinente est un budget renseigné avec des majorants certifiés, plutôt qu'une nouvelle estimation centrale de δ.

## 2. Babanskyy : un algorithme local réellement rejouable

Mahatab–Sampath étudient le défaut de surjectivité du CRT cyclotomique sur Z ; leur théorème 2.4 et leur lemme 2.5 explicitent sa structure tensorielle et récursive. Les facteurs de Smith décrivent le cokernel ; tester un tuple exige aussi ses coordonnées. La construction locale utilisée ici suit les indications techniques de Babanskyy. L'implémentation ci-jointe ne lui attribue ni notre code ni nos extensions de corpus.

### Relèvement et preuve interne de son critère

Dans un anneau sans 2-torsion où la division par 2 est définie dans l'algèbre rationnelle, prendre P,Q de degré inférieur à h. Le seul représentant H de degré inférieur à 2h satisfaisant H=P mod(z^h−1) et H=Q mod(z^h+1) est

H=(P+Q)/2 + z^h(P−Q)/2.

En effet, écrire H=A+z^hB. Les deux réductions donnent A+B=P et A−B=Q, donc 2A=P+Q et 2B=P−Q. Si P,Q sont à coefficients entiers, H est entier exactement lorsque leurs coefficients sont congrus modulo 2. Chaque étape doit conserver H et l'employer à l'étape suivante ; réutiliser seulement les signes perd les contraintes de divisibilité par 4,8,…

Écrire n=2^a m avec m impair et utiliser les coordonnées CRT (s mod m,s mod 2^a). Dans chaque bloc d|m, réduire les puissances de y modulo Φ_d(y). La donnée initiale est F_d(z)=Σ_{s∈S} y^(s mod m) z^(s mod 2^a). Le signe ε_{2^k d} agit sur son reste modulo Φ_{2^k}(z). Commencer au facteur z−1, puis assembler successivement avec z+1,z²+1,z⁴+1,… par la formule ci-dessus.

Justification de la portée 2-locale : sur Z_(2), z désigne le facteur cyclique de puissance de 2. Les facteurs Φ_d(y) de y^m−1 sont comaximaux car leur réduction modulo 2 est sans racines multiples. Le CRT impair est donc inversible sur Z_(2). Il suffit de contrôler chaque bloc Z_(2)[y]/Φ_d(y) ; nul besoin de choisir une factorisation supplémentaire sur une extension 2-adique. Dans sa base 1,y,…,y^(φ(d)−1), les divisions successives introduisent seulement des puissances de 2 au dénominateur. L'intégralité dans Z_(2) équivaut donc à la réussite de toutes les parités coefficientielles. C'est une preuve écrite interne de la variante implémentée, à relire ; ce dossier ne contient pas de preuve Lean.

### Comparateur global indépendant

Pour c_d(t)=Σ_{e|gcd(d,t)} e μ(d/e), former N_x=Σ_{s∈S}Σ_{d|n} ε_d c_d(x−s). L'inverse rationnelle est v_x=N_x/n. Le contrôle local en 2 est N_x=0 mod 2^a pour tout x ; le contrôle entier est N_x=0 mod n. Cette seconde route ne construit aucun bloc cyclotomique local. Une troisième route énumère les supports de même cardinalité et compare directement les sommes ordonnées.

Avec ε_1=+1, Parseval conserve Σv_x=|S| et Σv_x²=|S|. Si v_x est entier, Σv_x(v_x−1)=0 et chaque terme est positif ou nul, donc v_x∈{0,1}. L'argument vaut pour toute cardinalité. Lorsqu'une composante de Fourier est nulle, plusieurs tuples de signes peuvent représenter le même support ; le programme distingue le nombre de tuples entiers du nombre de supports distincts.

### Résultats exécutés pour S={1,5,17}

| n | tuples de signes | admissibles en 2 | tuples entiers | supports distincts |
|---|---|---|---|---|
| 24 | 128 | 8 | 4 | 4 |
| 40 | 128 | 8 | 2 | 2 |
| 48 | 512 | 8 | 2 | 2 |
| 56 | 128 | 8 | 2 | 2 |
| 72 | 2048 | 32 | 2 | 2 |
| 80 | 512 | 8 | 2 | 2 |
| 96 | 2048 | 8 | 2 | 2 |
| 120 | 32768 | 128 | 2 | 2 |

38 272 tuples, zéro désaccord entre récursion et contrôle de Ramanujan ; 622 440 triplets examinés directement ; 3 648 comparaisons supplémentaires, comprenant tous les supports et signes pour n∈{2,3,4,6,8}, puis 1 000 cas pseudo-aléatoires fixés par la graine 20261013. Ces nombres sont une couverture finie documentée.

À n=24, les quatre supports sont {1,5,17},{1,9,21},{5,13,17},{9,13,21}. Dans les sept autres cas du tableau, les seuls supports sont S et S+n/2. Le filtre 2-local ne suffit pas à l'intégralité globale : à n=72,32 survivants deviennent 2 ; à n=120,128 deviennent 2. Aucun théorème universel sur cette famille n'est déduit de cette observation.

Économie mesurée : fractions de tuples rejetés avant le contrôle global, pas accélération en secondes. Le programme de comparaison calcule intentionnellement les numérateurs pour tous les tuples afin d'auditer le filtre. Il ne mesure donc pas le gain de temps d'une version optimisée. Prochaine étape : génération incrémentale des seuls signes compatibles, puis mesure du coût complet incluant préparation des blocs et tests aux premiers impairs.

## 3. Royle et McKay : témoin lisible et contrôle canonique

Considérer A_{u,v}=1 si v−u∈S dans Z/nZ. Pour chaque arc u→v, le nombre (A^3)_{v,u} compte ses retours en trois pas. Le multiensemble de ces valeurs sur tous les arcs est préservé par isomorphisme. Il vaut n copies, pour chaque s∈S, du coefficient de 1_S*1_S*1_S en −s.

| n | S | T | valeurs par type d'arc pour S / T |
|---|---|---|---|
| 12 | {1,3,9} | {1,5,11} | {3,4,5} / {3,3,6} |
| 24 | {1,5,17} | {1,9,21} | {3,3,6} / {3,4,5} |

Dans chaque ligne, A_S²=A_T² étiqueté. Le programme calcule exactement les traces des puissances jusqu'à n puis les coefficients du polynôme caractéristique par Newton : les deux polynômes sont égaux. Pourtant les multisets de retours diffèrent, donc les graphes ne sont pas isomorphes. Pour n=12, le sous-graphe des arcs réciproques donne déjà trois cycles de longueur 4 contre un cycle de longueur 12, comme l'a suggéré Royle. Pour n=24, aucun des deux graphes n'a d'arc réciproque : le témoin de retour demeure efficace.

Cette preuve suffit pour ces deux paires, mais ne remplace pas la canonicalisation de tout un corpus. McKay–Piperno, Practical graph isomorphism II, décrivent nauty/Traces. Un contrôle ultérieur doit conserver version, options dirigées, encodage, permutation ou forme canonique et empreinte des fichiers. Aucun programme nauty n'a été exécuté dans ce dossier. La cospectralité, l'égalité de A² et l'isomorphisme restent trois relations distinctes ; une preuve pour un témoin n'est pas une classification exhaustive.

## 4. Les autres trajectoires deviennent des obligations précises

Les rapprochements ci-dessous sont notre lecture méthodologique ; ils ne prouvent ni intérêt des auteurs pour une collaboration ni applicabilité de leurs théorèmes à nos objets.

| Chercheur | Question utile pour le programme | Travail concret restant |
|---|---|---|
| Chen | Représentations additives ordonnées ou non ordonnées ? | Fixer R_S=1_S*1_S ; séparer les diagonales et la réduction modulo 2 ; comparer l'énoncé universel candidate, pas seulement ses petits exemples. |
| Cameron | Quel quotient conserve exactement la transition observable ? | Prouver η(f_e(x))=F_e(η(x)) pour chaque événement, puis préciser la classe de propriétés transportées. Une partition équitable conserve des comptes de voisins ; elle ne donne pas toute cette congruence déterministe. |
| Jouve | Une queue gaussienne autorise-t-elle une observable entière gaussienne ? | Pour une phase r cos Θ, κ4=−3r^4/8 ; pour une somme indépendante, additionner ces cumulants. Conserver les basses phases et certifier l'erreur de la seule queue. |
| Matomäki | Tous les intervalles ou presque tous ? | Écrire le quantificateur, la longueur H(X), l'ensemble exceptionnel et la norme avant toute comparaison avec une uniformité publiée. |
| Massot | Que certifie précisément une compilation ? | Épingler Lean/mathlib, compiler l'énoncé final, examiner les axiomes utilisés, distinguer les lemmes auxiliaires de l'exhaustivité générale. |
| Granville | Que reste-t-il après les facteurs locaux usuels ? | Définir résidu, normalisation, régime asymptotique, modèle nul et test ; éviter de qualifier une restriction modulaire classique de nouveau biais. |

Le calcul du cumulant cité est élémentaire : E cos²Θ=1/2, E cos⁴Θ=3/8, donc κ4=3r^4/8−3(r²/2)^2=−3r^4/8. Si les amplitudes sont de carré sommable, elles sont bornées et leurs puissances quatrièmes sont sommables. Le cumulant standardisé de la somme est alors −(3/2)·Σr_j^4/(Σr_j²)^2. Il est négatif dès qu'une amplitude est non nulle. Cela ne réfute aucune approximation avec une erreur contrôlée ; cela exclut une identité exacte avec une gaussienne pour ce modèle indépendant non dégénéré.

## 5. Platt, Martin et le choix de la prochaine porte

La question de Platt sépare l'existence de zéros, leur simplicité et la complétude avec multiplicité dans une région finie. Le rapprochement numérique d'une décimale ne donne pas la précision certifiée de sa source. La prochaine porte est un fichier original d'intervalles, son étiquetage des caractères et la portée de sa garantie de complétude. Ce dossier n'obtient pas ces données et ne rejoue aucun certificat de zéros.

Les références Devin (arXiv:1706.06394) et Akbary–Ng–Shahabi (arXiv:1306.1657) fournissent un cadre de distributions limites. Leur existence ne dispense pas de vérifier les hypothèses applicables au poids exact ni le passage à une inégalité stricte. Lin–Martin (arXiv:1908.10902) traite une course d'ordre de trois classes ; le fait que 1²=11²=29² mod 30 ne convertit pas son résultat en densité de notre somme 3-contre-5.

Priorités : (1) relire le critère local et comparer une génération incrémentale ; (2) remplir le budget d'erreurs de CU-BRUIT sans prétendre vérifier ELI_A ; (3) compléter la canonicalisation du corpus avec le certificat de retour ; (4) achever les énoncés Lean universels. Ces portes sont complémentaires ; aucune ne fonde une théorie commune aux chercheurs étudiés.

## Références publiques vérifiées et niveau de lecture

- Bailleul–Hayani–Untrau, A Wasserstein metric approach to generalized Skewes' numbers. I. Prime number races, v2, 24 avril 2026 : https://arxiv.org/html/2603.20093v2 — §§3 et 5 lus pour les bornes utilisées.
- Mahatab–Sampath, Chinese Remainder Theorem for Cyclotomic Polynomials in Z[X], Journal of Algebra 435 (2015), 223–262 : https://arxiv.org/abs/1401.7696 — texte et structure des résultats 2.4–2.5 contrôlés.
- McKay–Piperno, Practical graph isomorphism, II : https://arxiv.org/abs/1301.1493 ; documentation : https://users.cecs.anu.edu.au/~bdm/nauty/PGI/ — référence méthodologique, pas une exécution.
- Chen, On a problem of Nathanson related to minimal asymptotic bases and maximal asymptotic nonbases, septembre 2026 : https://arxiv.org/abs/2609.07361 — résumé et métadonnées ; aucun transfert de théorème.
- Bailey–Cameron–Zhou, Equitable partitions of regular graphs, and perfect sets in normal Cayley graphs : https://arxiv.org/abs/2605.17376 ; Cameron, Synchronizing groups and weakly perfect graphs: a survey : https://arxiv.org/abs/2609.12811 — résumés et définitions.
- De La Bretèche–Fiorilli–Jouve, Moments in the Chebotarev density theorem: non-Gaussian families : https://arxiv.org/abs/2301.12826 — dépôt initial 2023 ; ne pas confondre date de dépôt et parution ultérieure.
- Matomäki et al., Higher order uniformity of the primes and cancellation of the Möbius function in shorter intervals : https://arxiv.org/abs/2610.09567 — prépublication du 7 octobre 2026, résumé ; hypothèses fines non transférées.
- Massot, Teaching Mathematics Using Lean and Controlled Natural Language, ITP 2024 : https://drops.dagstuhl.de/entities/document/10.4230/LIPIcs.ITP.2024.27 — notice et résumé.
- Granville–Pappalardi, Two dimensional covering systems and possible prime producing a^m−b^n : https://arxiv.org/abs/2601.10296v2 — métadonnées et résumé ; v2 corrige une erreur de la v1.
- Devin : https://arxiv.org/abs/1706.06394 ; Akbary–Ng–Shahabi : https://arxiv.org/abs/1306.1657 — résumés, hypothèses d'application détaillées encore à relire.
- Babanskyy, programme public : https://oleksiybabanskyy.com/ — auteur indépendant, statut académique non déduit de son site ; aucune évaluation de son corpus entier.

Provenance : scripts et calculs réalisés avec assistance d'IA ; mathématiques classiques ou reconstructions contemporaines explicitement attribuées. Les correspondances personnelles et leurs coordonnées ne font pas partie de cette note publique.
