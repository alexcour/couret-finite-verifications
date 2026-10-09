# CU-BRUIT-01 / LIMIT-04 — Audit adversarial du comptage des zeros

Date : 2026-10-09. Registre : R-RECHERCHE. Cycle : L-WORKING. Diffusion : D-PRIVE pour le dossier Drive; branche de recherche GitHub publique possible, sans release.

## Question scientifique

Les comptes 67 (T=25) et 128 (T=40), obtenus par racines critiques et variation numerique de l'argument, sont-ils des **comptes mathematiquement certifies** ? Verdict : NON, pas avec le seul critere numerique publie dans LIMIT-03.

## Resultat nouveau sur l'instrumentation : contre-exemple exact

Soit f(z)=z^(N-1). Aux N points z_k=exp(2 pi i k/N), les echantillons sont f(z_k)=exp(-2 pi i k/N). La somme des differences principales d'argument est donc -2 pi et donne l'enroulement **-1**. Mais f possede un zero d'ordre N-1 dans le disque unite et l'enroulement exact vaut **N-1**. Le saut de phase maximal observe est seulement 2 pi/N, arbitrairement petit quand N augmente. Le defaut n'est pas remedie par l'exigence 'sauts observes < 0,925 radians'.

Exemples executes : N=9 et degre=8 => mesure -1, vrai 8, saut observe 0,698132; N=101 et degre=100 => mesure -1, vrai 100, saut 0,062210. C'est une falsification de la *suffisance du critere de mesure*, pas du nombre 67 ou 128 lui-meme.

## Proposition : critere suffisant pour certifier chaque segment

Soit f holomorphe pres d'une ligne polygonale fermee, et soient z_i et z_(i+1) deux sommets consecutifs. Supposons qu'on possede des **bornes rigoureuses** m_i>0 et M_i telles que |f(z_i)| >= m_i et |f'(z)| <= M_i sur le segment, et que M_i |z_(i+1)-z_i| < m_i.

Alors pour z sur le segment, |f(z)-f(z_i)| <= M_i |z-z_i| <= M_i longueur < m_i. L'image de tout le segment est donc contenue dans un disque qui exclut 0. La variation continue de l'argument de f sur ce segment est sa difference d'argument principale aux deux extremites. Si cette condition est satisfaite pour **tous** les segments, la somme des differences principales est exactement l'indice et compte les zeros internes avec multiplicites (ou zeros moins poles si f est meromorphe). Les bornes sur les valeurs ponctuelles, derivees et eventuels poles sont indispensables.

Pour f(z)=z^d sur le polygone inscrit dans le cercle unite a N cotes : sup |f'| <= d, |f(z_i)|=1, longueur d'un cote <= 2 pi/N < 44/(7N). La condition rationnelle sur les entiers 44*d < 7*N suffit donc. Le test passe pour (d,N)=(8,101) et (100,2048), et rejette les deux cas alias (8,9) et (100,101). Ce **certificat concerne ces polynomes**, pas les fonctions L de Dirichlet.

## Statut des controles sur L(s,chi)

LIMIT-03 conserve ses **observations numeriques** : 67 et 128; accords contour/signe; petites valeurs de residus des zeros approches. LIMIT-04 ne retire pas ces donnees. En revanche, les fichiers du lot ne fournissent pas de bornes rigoureuses de la derivee de L sur chaque segment ni d'encadrements certifies de |L| aux sommets. Le compteur LIMIT-04 refuse donc d'afficher 'certifie' pour T=25 et T=40. Cette limite est explicite dans son JSON de sortie.

## Suivi de la densite

Le proxy delta_plus ~0,28945 sous GRH+LI, et les bornes exploratoires Berry-Esseen de LIMIT-02 restent **CONDITIONNELS** a la completude des listes et aux evaluations numeriques non certifiees. Aucune conclusion sur un signal arithmetique specifique ne peut etre tiree; le RUN-01 gele et ses empreintes ne sont pas modifies.

## Vrai verrou suivant

1. Choisir une methode Turing ou argument-principe a bornes d'intervalle pour les fonctions L **de Dirichlet** des conducteurs 3, 5, 15 (ne pas substituer une routine certifiant seulement la fonction zeta de Riemann).
2. Produire m_i et M_i rigoureux pour les segments, ou un certificat Turing complet, et isoler les zeros jusqu'a T=40.
3. Passer a une quadrature d'intervalle et des encadrements de B(chi), puis seulement fixer un intervalle rigoureux pour la densite conditionnelle.
4. Conserver un test negatif tel que f(z)=z^(N-1) pour obliger le certificateur a rejeter les alias.

## Dependances / reproduction

`python3 cu_bruit_limit04_winding_gate.py` fonctionne avec la bibliotheque standard Python, sans mpmath. Les anciens essais LIMIT-02/03 utilisent mpmath, SciPy et NumPy. La bibliotheque python-flint / Arb propose de l'arithmetique par boules pour les fonctions L de Dirichlet, mais n'est pas installee dans l'environnement du calcul; son installation a ete impossible ici faute d'acces reseau. Ses routines de zero-count zeta ne sont pas automatiquement un certificat pour les sept fonctions L pertinentes.

Sources internes : Drive CU-BRUIT-01 gelé (ID 1g6VWcKMFUE0CN0OH-ZAVf6KwgwVE8LG8PQbLdFq4NUg); LIMIT-03 (ID 1p5znA4kugQesHe2_7nhg7D4swE41k5bC1cuJDRhhX-M), Github research/CU_BRUIT_01_LIMIT_03_CONTOUR_QA.md.