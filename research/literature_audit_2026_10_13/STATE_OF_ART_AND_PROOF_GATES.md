# COURET–UNIFICATION — Etat de l'art contradictoire et portes de preuve (13 octobre 2026)

**Statut : NOTE DE RECHERCHE / DRAFT / NON AUDITEE EXTERIEUREMENT.**  
**Document de rapprochement bibliographique ; aucune preuve nouvelle, priorite mathematique, GRH/LI, fusion ou release revendiquees.**

## 0. Synthese decisionnelle

Cette note rectifie et approfondit la veille scientifique du 13 octobre 2026 en prenant comme point de depart les RESULTATS DEJA PRESENTS dans les dossiers Couret, plutot que de proposer de recreer des demonstrations existantes. Trois suites immediates : (A) STROBO : achever la formalisation de l'exhaustivite et auditer l'anteriorite ; (B) CU-BRUIT : calculer par intervalles la probabilite de signe du modele **apres** la borne de remplacement des queues completes ; (C) observabilite/decision : distinguer le quotient exact, la sonde adaptative et le cout de construction/verificaton d'un certificat.

La classification candidate universelle de STROBO-2TORS se trouve deja dans la PR #25. Le cas cyclique est dans la PR #8 et le cas a involution unique dans la PR #23. La classification de 56 triplets de U(30) est integree a main par la PR #4. La PR #27 a progresse au 13 octobre : le dossier ne se limite PLUS a la queue q15, mais annonce des certificats internes pour les 67 ordonnees positives q3/q5/q15 jusqu'a hauteur 25 et des majorations de remplacement de toutes les queues. La PR #28 conserve la couche source q15. Toutes les PR #8/#23/#25/#27/#28 restent des brouillons a la date de ce controle.

## 1. Registre epistemique : ce que l'on a, ce qui manque

| Bloc | Etat interne et reference | Limite non franchie |
|---|---|---|
| U(30), 56 triplets ; 5 profils etiquetes ; 13 classes biais/profil | Preuve structurelle et controles finis ; PR #4 FUSIONNEE | Originalite externe ; loi de premiers nouvelle ; treize densites distinctes |
| STROBO-C3 et STROBO-2TORS | Classification universelle candidate : fibres de taille h ou 2h, h=|G[2]|, avec exceptions liees a la 3-torsion ; PR #8/#23/#25 | Exhaustivite Lean de tous les cas, revue humaine et audit d'anteriorite |
| CU-BRUIT q15 | 37 concordances de decimales externes et certificats d'isolement/compte interne ; PR #28 | Relecture mathematique independante, GRH globale et densite |
| CU-BRUIT q3/q5 + queues completes | PR #27 (head observe le 13/10 : 1fe8961bfeedd14a5d5cb8699d3c79e4c762536a) ; 67 ordonnees et erreurs de remplacement partiel/total | Quadrature par intervalles du MODELE remplace, identification au biais premier, GRH/LI |
| CU-MOD-OBS-02 | Cout exact de banques de sondes pour certains circulants, preuve interne, dependant de STROBO pour T3 | Relecture externe ; cout en temps reel ; generalisation avec modele de preuve explicite |

Le passage d'une CI verte a un resultat "audite" est interdit. Chaque resultat doit exposer ses axiomes, le domaine fini, la base de confiance numerique, les hypothe ses analytiques et la fidelite enonce informel/Lean.

## 2. STROBO — matrice mathematique et audit d'anteriorite

### 2.1 Objet EXACT

Pour G abelien fini et S de trois elements, R_S = 1_S * 1_S dans Z[G] recense les neuf sommes ordonnees. L'egalite R_S=R_T est une egalite de carres de convolution **etiquetes**. Ne pas la confondre avec :
* l'autocorrelation 1_S * 1_{-S} et ses corr elations d'ordre superieur ;
* l'egalite du multiensemble de valeurs propres de graphes non etiquetes ;
* l'isomorphisme des graphes ;
* l'egalite de distributions de marches par un reetiquetage dependant du temps.

La classification INTERNE candidate de la PR #25 affirme que les fibres ont cardinal h ou 2h, h=|G[2]|, avec doublement exceptionnel lorsqu'une structure de 3-torsion intervient. La preuve manuscrite et les balayages finis sont des pieces d'etude, PAS un theoreme exhaustif Lean-certifie. Le verrou documentaire le plus recent est l'achevement de l'alternative directe/croisee, de son relevement puis de l'exhaustivite des profils (voir PR #25). Ne pas reintroduire le projet initial "chercher une classification generale" comme si rien n'existait.

### 2.2 Lemme de controle deja classique

En caracteristique deux,
 (1_S * 1_S) mod 2 = somme_{s dans S} [2s].
Si G est d'ordre impair, le doublement est bijectif et R_S=R_T implique S=T pour TOUS supports finis. Si G possede de la 2-torsion, on obtient seulement la parite de l'occupation des fibres du doublement. C'est un point de depart structurel, non une revendication de nouveaute.

### 2.3 Comparaison THEOREME PAR THEOREME

**Casper–Orozco (arXiv:2503.21022v2, revision 04/07/2026)** : reconstruction d'une fonction rationnelle par autocorrelations d'ordres au plus 2r+2 si |G| impair et 3r+3 sinon, r=nombre de facteurs cycliques. Sur U(30) ~ C2 x C4, r=2 => borne generale 9. L'objet est la famille des autocorrelations, pas R_S = 1_S*1_S. Conclusion : cite obligatoirement ; AUCUNE absorption logique automatique de STROBO.

**Ishikawa–Nakano–Sadahiro (EJC 33(3), P3.6, 03/07/2026)** : graphes de Cayley non isomorphes dont les distributions de marche simple correspondent apres bijection des sommets qui peut changer a chaque temps. Le papier decompose aussi les ensembles spectraux, mais ne doit pas etre decrit comme etablissant notre meme egalite des CARRES etiquetes ni necessairement une cospectralite.

**Bhattacharjee–Mandal–Bhattacharya (arXiv:2609.09222, septembre 2026)** : alg ebre K[A] de graphes de Cayley ABELIENS A ENSEMBLE DE CONNEXION SYMETRIQUE. Pour deux matrices diagonalisables et cospectrales sur K, le polynome minimal commun rend les algebres abstraites K[A] isomorphes : cet invariant abstrait seul ne distingue pas des constructions cospectrales. Explorer plutot e tiquettes de caracteres et paires (A,observables).

### 2.4 Portes STROBO

S1. Fig er definitions neutre autorise/interdit et compte "paires" vs "classes".
S2. Recuperer le dernier commit et le dernier etat CI de la PR #25 ; ne compter comme preuve Lean que les lemmes effectivement compiles sans sorry/admit/nouveaux axiomes.
S3. Prouver le passage universel "egalite brute des carres => appariements direct ou croise", puis relevement des directions, puis le cas de chaque profil, avant d'annoncer la borne 2h comme certifiee Lean.
S4. Confier a un lecteur humain une tentative contradictoire (cas d'ordre 6, multiplicite de 2-torsion, neutre, groupes produits).
S5. Comparer explicitement aux travaux sur fonctions de representation additive et complements homometriques, en plus de Casper–Orozco.

## 3. CU-BRUIT — dossier de certification reel

### 3.1 Ce qui est entierement fini

Dans U(30)= {1,7,11,13,17,19,23,29}, T de taille 3 et c_T=8 1_T-3 : 56 supports, cinq profils Fourier etiquetes et treize classes de (biais,profil) dans la PR #4 fusionnee. La multiplication par 19 produit 28 paires sans pour autant identifier les fonctions D_T(x).

Identite exacte avec le module 15, x >= 2 :
 D_{T,30}(x) = D_{T,15}(x) + 3 - 8*1_{17 dans T}.
La partie analytique n'est donc pas specifique au module 30, hors la correction au premier 2 et l'organisation algebrique.

### 3.2 Relecture des PRETENTIONS selon la PR #27 ACTUALISEE

La PR #27 au commit observe 1fe8961b... annonce 67 isolations numeriques internes Arb et controles de comptage de la completed-L jusqu'a T=25 : conducteurs 3 (6), 5 (8+8+8), 15 (12+13+12). La PR #28 apporte a part les correspondances decimales externes q15 et un audit interne. L'execution CI du 13/10 est annoncee reussie pour le workflow racines/queues 38350289139 et la verification generale 38350289154. Ces controles partagent certaines bases de confiance et ne constituent pas une revue humaine independente.

Sous GRH et dans le MODELE de phases uniformes independantes : les 13 classes de (biais,profil) sont annoncees comme 13 LOIS distinctes, via la separation de constantes analytiques K. Il n'en decoule pas 13 probabilites de signe distinctes. Sous les hypotheses declarees, la PR #27 annonce les ERREURS MAXIMALES dues a la substitution simultanee de toutes les queues gamma > 25 par une gaussienne de meme variance :
 Q5: 0.001714 ; Q3: 0.001998 ; Q15: 0.000915 ; C5: 0.000933 ; C15: 0.000556.
Ce sont des bornes de DISTANCE DE SEUIL entre deux modeles : ni un intervalle complet sur delta, ni une verification de GRH/LI, ni une borne sur l'ancien chiffre exploratoire 0.2894389.

### 3.3 Ant eriorites et changement de cible

**Platt (Mathematics of Computation 85, 2016, 3009–3027)** : verification GRH dans des domaines finis pour les caracteres primitifs q <= 400000, a des hauteurs largement superieures a 25 pour q=15. Nos isolations q15 ne sont PAS une percee sur la localisation des zeros deja couverte ; valoriser integration reproductible, calcul par intervalles et derivees de masse.

**Benli–Martin–Peringuey (arXiv:2510.05427, oct. 2025)** : calculs de densites conjointes pour des erreurs de Chebyshev psi(x;q,a) modulo 11, avec controle rigoureux des erreurs. Nos courses de pi(x;q,a) et poids 5/-3 ne se transferent pas sans normalisation et terme de biais.

**Bailleul–Hayani–Untrau (arXiv:2603.20093v2, avril 2026)** : distance de Wasserstein et Kronecker–Weyl quantitatif pour des courses et leurs premiers changements de signe sous hypotheses appropriees. La vitesse de convergence des courses reelles vers les lois est distincte de la quadrature certifiee d'une loi limite.

### 3.4 Trois erreurs distinctes a suivre

(i) erreur de certification des zeros/constantes et du spectre retenu ;  
(ii) erreur de substitution des queues infinies ;  
(iii) erreur d'inversion de Fourier/quadrature de la probabilite du MODELE remplace.  
Le transfert a la distribution logarithmique d'une vraie course de nombres premiers exige un QUATRIEME theoreme analytique sous les hypotheses GRH/LI correctement enoncees. Chaque composante doit fournir un intervalle/borne et sa base de confiance, avant de sommer quoi que ce soit.

Prochain livrable : un intervalle rationnel explicite [delta_lo,delta_hi] pour au moins une course T_C, **conditionnel**, avec preuve de quadrature et couplage avec la PR #27. Refuser la promotion de l'ancien 0.2894 avant ce calcul.

## 4. Observation, quotients et cout de certification

**Zhang–Chen–Imani–Lan (arXiv:2607.27132, juillet 2026)** donne un quotient stable minimal dans une classe particuliere de POMDP avec holonomie et memo ire de l'ordre des transports. Les notions de quotient stable, memoire minimale et obstruction a l'abandon de l'ordre sont donc des ANTERIORITES DIRECTES. Ne pas reclamer ces notions comme nouvelles.

**H-JEPA (Zhang et al., arXiv:2610.06805, 5 octobre 2026)** examine des representations predic tives hierarchiques pour la planification ; les gains annonces sont experimentaux, pas la preuve de minimalite d'un quotient.

La distinction mathematiquement pertinente et testable :
 (a) etat/reduction markovienne exacte ;
 (b) observabilite des proprietes au travers d'une famille de sondes ;
 (c) complexite d'une PREUVE DE SUFFISANCE relative a un systeme de preuve Pi fixe ;
 (d) cout de l'arbre decisionnel adaptatif vs banque de tests a priori.

La note interne CU-MOD-OBS-02 a DEJA une preuve candidate pour un modele de sondes d'appartenance des circulants, notamment B_fix = h-1 pour n=2h >=6 ; B_post(full) = 1 ou 2 sous classification STROBO-C3. Ces resultats sont conditionnels selon les obligations precisees dans cette note. Le "set cover" et les arbres de decision constituent une litterature classique : ne pas revendiquer leur invention.

Prochaine demonstration ciblee : fixer un modele de preuves Pi, un cout explicite de construction ET verification de certificats, puis trouver une famille infinie ou le plus petit quotient decisionnel n'est pas celui dont la suffisance est la moins couteuse a certifier. Cette proposition est une QUESTION OUVERTE INTERNE, et non un theoreme obtenu.

## 5. Lemme temporel : borne classique, pas une revendication

Soient P et Q deux matrices diagonalisables et cospectrales de dimension N sur un corps ou leur polynome minimal se scinde, et d le nombre de valeurs propres distinctes. Pour une forme lineaire h et des vecteurs v,w, les suites a_n=h(P^n v), b_n=h(Q^n w) satisfont une recurrence commune d'ordre d issue du polynome minimal. Donc les egalites a_n=b_n pour n=0,...,d-1 impliquent toutes les suivantes. Le resultat est une consequence classique des recurrences lineaires. Il n'est PAS nouveau et ne distingue pas automatiquement deux systemes si les observables sont trop pauvres.

Protocole envisage : mesurer l'horizon et le nombre minimum de sondes qui separent une famille FIXEE de collisions de Cayley, avec ou sans reetiquetage admissible. Documenter soigneusement les contraintes sur la famille de sondes et le cout de son acquisition.

## 6. Priorites et responsables des preuves

P0 / STROBO : verifier l'exhaustivite Lean de la PR #25 et lancer une relecture contradictoire humaine ; aucun merge avant la porte de preuve.
P0 / CU-BRUIT : quadrature a intervalles sur la loi a queue completement remplacee et borne totale sous hypotheses ; verifier la compatibilite de normalisation avec Benli et Rubinstein–Sarnak.
P1 / CAYLEY-OBS : protocole de distinction temporelle (matrices vs traces vs sondes), conventions de reetiquetage et replay fini.
P1 / MOD-OBS : instance non triviale avec cout de preuve fixe, deux algorithmes de certification concurrents, contre-exemples a la minimalite "taille d'etat => cout minimal".
P2 / PHILOSOPHIE : la notion de "continuite" reste un cadre d'interpretation : elle ne sera pas promue comme principe scientifique universel avant des enonces discriminants et des tests de falsification.

**Gates communs :**
- E : enonce et demonstration mathe matique complets avec hypotheses visibles ;
- Q : donnees/code reproductibles, controles negatifs et hash de provenance ;
- L : Lean compil e, zero sorry/admit/nouveaux axiomes, fidelite a l'enonce ;
- N : audit d'anteriorite et de priorite dans les textes primaires ;
- R : critique independante documentee ;
- P : autorisation explicite de fusion/release/archives externes, independante de E/Q/L.

## 7. Bibliographie primaire auditee (liens consultes le 13/10/2026)

1. Casper, W. R., Orozco, B., *Reconstructing Rational Functions on Finite Abelian Groups with Higher Autocorrelations*, arXiv:2503.21022v2 (04/07/2026). https://arxiv.org/html/2503.21022v2
2. Ishikawa, M., Nakano, F., Sadahiro, T., *Non-Isomorphic Cayley Graphs with Identical Random Walk Distribution*, Electronic Journal of Combinatorics 33(3) P3.6 (03/07/2026). https://doi.org/10.37236/14208
3. Bhattacharjee, D., Mandal, P., Bhattacharya, U., *Spectral Algebras of Abelian Cayley Graphs*, arXiv:2609.09222 (09/2026). https://arxiv.org/abs/2609.09222
4. Platt, D. J., *Numerical Computations Concerning the GRH*, Mathematics of Computation 85 (2016), DOI 10.1090/mcom/3077. https://research-information.bris.ac.uk/en/publications/numerical-computations-concerning-the-grh/
5. Benli, K., Martin, G., Peringuey, P., *Joint distributions of error terms for primes in arithmetic progressions modulo 11*, arXiv:2510.05427 (2025). https://arxiv.org/abs/2510.05427
6. Bailleul, A., Hayani, M., Untrau, T., *A Wasserstein metric approach to generalized Skewes' numbers. I. Prime number races*, arXiv:2603.20093v2 (24/04/2026). https://arxiv.org/abs/2603.20093
7. Zhang, Z., Chen, Y., Imani, M., Lan, T., *Minimal Markovization via Stable Quotients in Holonomy-Cover Decision Processes*, arXiv:2607.27132 (29/07/2026). https://arxiv.org/abs/2607.27132
8. Zhang, W., Terver, B., Rabbat, M., LeCun, Y., Balestriero, R., *H-JEPA*, arXiv:2610.06805 (05/10/2026). https://arxiv.org/abs/2610.06805
9. de Bontridder et al., *Branch-and-Bound Algorithms for the Test Cover Problem*, ESA 2002. https://doi.org/10.1007/3-540-45749-6_23

## 8. Dossiers internes consultes / separate review

- GitHub PR #4 : https://github.com/alexcour/couret-finite-verifications/pull/4
- GitHub PR #8 : https://github.com/alexcour/couret-finite-verifications/pull/8
- GitHub PR #23 : https://github.com/alexcour/couret-finite-verifications/pull/23
- GitHub PR #25 : https://github.com/alexcour/couret-finite-verifications/pull/25
- GitHub PR #27 : https://github.com/alexcour/couret-finite-verifications/pull/27
- GitHub PR #28 : https://github.com/alexcour/couret-finite-verifications/pull/28

**Publication boundary :** document de travail d'etat de l'art, sans attribution de priorite a nos formulations, sans demonstration d'une conjecture globale, sans annonce de DOI, sans diffusion de donnees industrielles privees. La bibliographie a ete controle e au niveau des pages primaires et, pour Casper–Orozco, du texte HTML ; cette note ne vaut PAS relecture complete des preuves de toutes les sources.

## Approfondissement méthodologique — 13 octobre 2026

Le [paquet de méthodes et contrôles exacts](../correspondent_methods_20261013/README.md) transforme les rapprochements bibliographiques en trois livrables :

- Récursion CRT 2-locale, suivant les indications d'Oleksiy Babanskyy et le cadre Mahatab–Sampath : concordance avec les sommes de Ramanujan sur 38 272 tuples de signes, puis 622 440 triplets examinés directement et 3 648 comparaisons supplémentaires. Huit modules, n=24,40,48,56,72,80,96,120. Le test local reste distinct de l'intégralité globale ; à n=120, 128 survivants locaux deviennent 2 supports entiers.
- Spécialisation exacte du poids de U(30) aux paramètres de Bailleul–Hayani–Untrau : λ(t)=9, λ(t*)=5, sept caractères actifs, k(t)^7=3^4·5^6. Le budget temporel, les combinaisons de fréquences, l'anti-concentration et la quadrature restent à certifier ; aucune densité nouvelle n'est fournie.
- Deux paires de Cayley orientés modulo 12 et 24 : même carré étiqueté et même polynôme caractéristique, mais multisets distincts de retours en trois pas sur les arcs. Deux certificats courts de non-isomorphisme, sans prétendue canonicalisation d'un corpus par nauty.

Les résultats JSON/CSV, les deux vérificateurs Python standard-library et un workflow de replay avec contrôle de dérive sont joints. Les preuves écrites sont internes et non formalisées en Lean dans ce paquet. Aucun statut universel STROBO, certificat de zéros, hypothèse GRH/LI, archive DOI ou revendication d'originalité n'est promu. Les correspondances personnelles ne sont pas publiées.
