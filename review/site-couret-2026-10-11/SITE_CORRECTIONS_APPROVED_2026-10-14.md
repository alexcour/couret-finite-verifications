# Couret — corrections publiques approuvées, 14 octobre 2026

**Décision éditoriale : application des corrections préparées approuvée par l’auteur le 14 octobre 2026.** L’auteur a explicitement autorisé les deux fusions le 14 octobre 2026 à 21 h 31 (Europe/Paris). Les PR éditoriales #34 et #9 sont fusionnées dans main, respectivement aux commits d137f119acf9383b06fb8de3856610970ae6bc1a et 3d2e7067e85d17db8d07968056572bd0363b9a4f. Leur application WordPress attend un accès CMS authentifié et doit être contrôlée sur les URL exactes. Cette approbation ne constitue ni relecture mathématique externe ni preuve d’originalité ; elle ne crée aucune release scientifique ou DOI et n’autorise aucun dossier confidentiel.

## État réellement constaté

Les réponses HTTPS publiques ont été relues sans session administrateur entre 20 h 02 et 20 h 04, heure de Paris. La page Recherche actuelle présente déjà STROBO et Cayley ; l’accueil y renvoie. Les passages excessifs sur RH, H1, Parseval et le mélange du graphe subsistent. La phrase RH n’a pas été retrouvée dans Contact. Les corrections déjà exactes, notamment F-001 et les cinq témoins F-08, restent conservées. Aucune correction WordPress appliquée n’est attestée par ce fichier.

## Matrice des corrections

| ID | Priorité / URL | Emplacement et bref extrait constaté | Correction retenue |
|---|---|---|---|
| C01 | P1 · https://www.couretunification.fr/ | Balise <title>, description SEO, premier écran et pied de page. Extrait : « Couret Unification - Reliefs Arithmétiques » ; « Reliefs Arithmétiques : Un programme de recherche » | Présenter « Couret — Reconstruction additive et spectrale » sur le premier écran et dans le titre SEO. Description proposée : « Reconstruction additive de supports à trois éléments et ambiguïtés spectrales de graphes de Cayley. Preuves, calculs reproductibles, limites et relectures en cours. » Réserver Couret–Unification et Reliefs arithmétiques à la provenance et aux archives datées. |
| C02 | P0 · https://www.couretunification.fr/ | Appel aux contradicteurs ; méthode Lean ; anciens axes. Extrait : « équivalent à l'hypothèse de Riemann » ; « 11 sorry » | Remplacer l’appel RH par deux questions de relecture autonomes : classification additive STROBO et ambiguïtés spectrales Cayley. Conserver les anciens axes comme historique daté. Attacher tout décompte Lean à des fichiers, un commit, une toolchain et un journal précis ; retirer le décompte générique de l’accueil. |
| C03 | P0 · https://www.couretunification.fr/resultats-minimaux/ | Appel aux contradicteurs et classification spectrale. Extrait : « équivalent à l'hypothèse de Riemann » ; « échafaudage non compilé » | Remplacer l’appel RH par le bloc de relecture STROBO/Cayley proposé ci-dessous. Nommer chaque classification : pour G30, renvoyer au paquet fini publié et à sa convention spectrale ; pour STROBO, renvoyer aux seuls modules compilés de la PR #25. Préserver les limites de chaque objet au lieu de transférer un statut de l’un à l’autre. |
| C04 | P0 · https://www.couretunification.fr/publications/h1/ | Titre, résumé, chaîne KLMN et badges. Extrait : « cette seule inégalité » ; « [P], pas [D] » | Titre proposé : « H1 — estimation et hypothèses d’auto-adjonction à vérifier ». Présenter l’application à H1 comme conditionnelle, en attente d’une preuve écrite contrôlant les hypothèses exactes. Retirer la clôture par la seule borne et harmoniser badges, résumé, légende et BibTeX. L’absence de formalisation Lean n’est pas l’unique lacune. |
| C05 | P0 · https://www.couretunification.fr/registre-f0/ | Principaux claims et compteurs. Extrait : « H1 fermée » ; « 0 » ; « Claims internes liés » | Conserver l’instantané daté, mais afficher en tête son statut d’archive et un lien vers Recherche actuelle. Ajouter une entrée de correction datée pour H1, sans réécrire silencieusement la trace de juin. Tout compteur présenté comme actuel doit être recalculé depuis les seules sources publiques autorisées. |
| C06 | P1 · https://www.couretunification.fr/recherches/ | Catalogue des recherches, six domaines et carte H1. Extrait : « H1 — l’auto-adjonction, fermée par une borne » | Ajouter une entrée prioritaire vers les deux branches actives. Présenter le catalogue à six domaines comme archive thématique, puis propager la correction H1 à son titre, son extrait et ses badges. Les anciens domaines restent consultables avec leur date. |
| C07 | P1 · https://www.couretunification.fr/tableau-de-bord/ | Tableau de bord et ligne H1. Extrait : « H1 — l'auto-adjonction, fermée par une borne » | Présenter ce tableau comme vue historique du catalogue. Créer au-dessus une vue des deux branches actives avec objet, observation, preuve disponible, version et points ouverts. Corriger la ligne H1 à la même date que sa fiche. |
| C08 | P0 · https://www.couretunification.fr/publications/cayg-tc-ramanujan-finie/ | Résultat A.2, comptage des arêtes, Ramanujan/Ihara et paragraphe de mélange répété. Extrait : « 8 sommets et 12 arêtes » ; « le graphe est un expanseur quasi-optimal » | Conserver le spectre calculé et les deux composantes. Remplacer la promesse de mélange global par une description composante par composante. Afficher 8 boucles + 8 arêtes non bouclées ; distinguer somme de ligne de l’adjacence et degré usuel avec boucles. Suspendre la qualification globale d’expanseur et les conséquences Ihara/Ramanujan jusqu’à justification pour la convention exacte. Supprimer la répétition du paragraphe excessif. |
| C09 | P0 · https://www.couretunification.fr/publications/triplet-canonique-t_c-1-11-29/ | Bloc « Le multiset spectral, identique » et conclusion de non-séparation. Extrait : « puisque le spectre entier est fixé par le cardinal » ; « Aucun invariant construit sur ces sommes » | Préserver les cinq témoins et la correction de non-unicité de T_C. Dire seulement qu’un invariant dépendant exclusivement de leur multiensemble spectral ne les sépare pas. Retirer la déduction spectre entier ← cardinal et distinguer valeurs propres, modules au carré et coefficients étiquetés. Ne pas confondre cette F-08 historique avec F-008 du registre GitHub. |
| C10 | P0 · https://www.couretunification.fr/le-senseur/ | Entrée F-05, justification de remplacement du test de Schur. Extrait : « auto-adjonction via KLMN sur M » | Ajouter une note datée : le contrôle d’une borne ne suffit pas à fermer H1 ; l’application KLMN est à justifier. Conserver les entrées F-01, F-05 et F-08 et leur historique. |
| C11 | P1 · https://www.couretunification.fr/carte/ | Vue d’ensemble et description des seuls résultats démontrés. Extrait : « tout vise un même horizon » ; « les seuls résultats démontrés » | Étiqueter cette carte comme parcours historique. Proposer une nouvelle entrée actuelle à deux branches, sans horizon global commun imposé. Décrire les résultats démontrés par énoncé et version, plutôt que par appartenance exclusive au modulo 30. |
| C12 | P1 · https://www.couretunification.fr/direction-de-recherche/ | Direction de recherche, programme d’exécution et manuscrit d’août. Extrait : « Reconstruction, provenance et reprise » ; « août 2026 » | Conserver cette page comme historique daté et placer en tête le lien vers Recherche actuelle. Ne compléter aucun développement brevet-sensible ; la proposition publique doit rester limitée aux deux branches et aux artefacts déjà autorisés. |
| C13 | P1 · https://www.couretunification.fr/les-mathematiques-du-programme/ | Carte synthétique, section P8 et positionnement final. Extrait : « La zone mathématique la plus prometteuse » | Ajouter une entrée actuelle STROBO/Cayley ; ranger le développement antérieur parmi les archives mathématiques datées. Préserver les avertissements et corrections déjà exacts. Toute implication conditionnelle vers RH garde ses hypothèses et ne devient pas une équivalence nouvelle. |
| C14 | P1 · https://www.couretunification.fr/verification/ | Choix des objets et commandes de reproduction. Extrait : « 1ER OCTOBRE 2026 » | Ajouter des parcours séparés : STROBO → PR #25, LEAN_GATE et commit scientifique avec reçus CI ; Cayley → dépôt de relecture et limites de revendication. Conserver les tags et commandes archivés. Ne pas rattacher la CI d’un ancien commit au HEAD documentaire plus récent. |
| C15 | P2 · https://www.couretunification.fr/publications-et-depots/ | Erratum F-001 et organisation des travaux. Extrait : « La limite 3/8 est une propriété classique issue du théorème de Dirichlet » | Conserver F-001, les DOI historiques et le statut Cayley. Préciser la référence de densité dans l’erratum. Si une notice STROBO actuelle est ajoutée après validation, l’identifier comme recherche en brouillon et la distinguer explicitement des certificats finis déjà déposés. |
| C16 | P2 · https://www.couretunification.fr/recherche-actuelle/ | Présentation STROBO, distinction des observations et preuve disponible. Extrait : « PR #25 en brouillon (non fusionnée) » | Définir R_S(g)=#{(s,t)∈S×S:s+t=g}, avec s=t autorisé. Ajouter l’attribution au cas à trois éléments du problème 2 de Lev (2004) et le lien public vers la frontière de preuve versionnée. Garder les réserves actuelles. Ne pas importer le portail ou ses annexes privées. |

## Textes de remplacement

Les blocs suivants sont les textes corrigés retenus pour application dans les zones correspondantes. Préserver les médias, la mise en page et les autres passages exacts de chaque page ; ne remplacer que les éléments identifiés. Les anciens cadrages deviennent des archives datées.

### Accueil — français

Couret — Reconstruction additive et spectrale
Nous étudions deux problèmes distincts : reconstruire un support à trois éléments à partir de ses sommes ordonnées, comptées avec multiplicité, et déterminer les ambiguïtés entre graphes de Cayley partageant un spectre d’adjacence. Les résultats sont accompagnés de leurs hypothèses, de leurs preuves disponibles, de leurs calculs reproductibles et de leurs limites. La relecture mathématique humaine indépendante et l’audit général d’antériorité restent ouverts.

### Accueil — anglais

Couret — Additive and Spectral Reconstruction
We study two separate problems: reconstructing a three-element subset from its ordered pairwise sums, counted with multiplicity, and determining ambiguities between Cayley graphs with the same adjacency spectrum. Results are accompanied by their assumptions, available proofs, reproducible computations and limitations. Independent expert mathematical review and a full prior-art audit remain pending.

### STROBO — français

STROBO — Reconstruction additive
Pour un groupe abélien G et un support S de cardinal trois, R_S(g) compte les couples ordonnés (s,t)∈S×S tels que s+t=g ; les répétitions s=t sont autorisées. Le problème étudié est la classification des paires S,T ayant R_S=R_T. Il concerne le cas à trois éléments du problème 2 de V. F. Lev (2004). Des résultats structurels sont formalisés dans les modules Lean 4 identifiés par la PR #25. Des calculs exhaustifs complètent ces preuves sur des domaines finis bornés. Les dénombrements complémentaires ne sont pas tous formalisés ; la PR demeure un brouillon, sans relecture humaine indépendante validante ni priorité établie.

### STROBO — anglais

STROBO — Additive reconstruction
For an abelian group G and a three-element subset S, R_S(g) counts ordered pairs (s,t)∈S×S satisfying s+t=g; equal summands are allowed. The problem is to classify pairs S,T with R_S=R_T. It concerns the three-element case of V. F. Lev’s Problem 2 (2004). Structural results are formalised in the Lean 4 modules identified in PR #25. Bounded exhaustive finite computations provide additional checks. Further counting statements are not all formalised; the PR remains a draft, with independent expert review and mathematical priority unresolved.

### Cayley — français

Cayley — Reconstruction spectrale
Cette branche compare des familles explicites de graphes de Cayley selon leur spectre d’adjacence et leur isomorphisme, en précisant si l’adjacence est dirigée et la convention retenue. Les résultats internes et les témoins sont proposés à la relecture dans le dépôt PUBLIC REVIEW 0.1.x. Des sous-familles ont des antécédents connus ; aucune priorité générale ni certification externe n’est acquise. L’égalité des carrés de convolution étiquetés, la cospectralité des opérateurs d’adjacence et l’isomorphisme sont des questions distinctes.

### Cayley — anglais

Cayley — Spectral reconstruction
This branch compares explicit Cayley-graph families through adjacency spectra and graph isomorphism, stating whether adjacency is directed and which convention is used. Internal results and witnesses are offered for review in the PUBLIC REVIEW 0.1.x repository. Some subfamilies have known antecedents; general priority and external certification are not established. Equality of labelled convolution squares, adjacency cospectrality and graph isomorphism are distinct questions.

### Appel aux contradicteurs

Relecture ciblée
Les deux branches sont examinées séparément. Pour STROBO, la relecture porte sur l’énoncé exact, les hypothèses et la correspondance entre la preuve écrite et les théorèmes Lean compilés. Pour Cayley, elle porte sur les familles annoncées, les conventions d’adjacence, la cospectralité, l’isomorphisme et les antériorités. Aucune preuve de l’hypothèse de Riemann ni équivalence nouvelle avec elle n’est revendiquée.

### H1 — hypothèses et portée

H1 — Estimation et hypothèses d’auto-adjonction
Une borne Hilbert–Schmidt, lorsqu’elle est établie pour l’opérateur considéré, fournit une borne de norme. Elle ne suffit pas à elle seule à prouver son auto-adjonction. L’application de KLMN exige une forme de base densément définie, fermée, symétrique et semi-bornée, ainsi qu’une perturbation symétrique de borne relative de forme strictement inférieure à 1. La forme, les domaines et l’identification de l’opérateur associé doivent être explicités et contrôlés. La clôture de H1 n’est pas établie par la seule estimation numérique affichée.

### F-08 — portée exacte

F-08 — Portée de la non-unicité spectrale
Les cinq supports indiqués ont le même multiensemble de valeurs propres dans la convention d’adjacence retenue. Un invariant dépendant seulement de ce multiensemble ne les distingue donc pas. L’identité de Parseval fixe l’énergie totale, pas le spectre entier. Dans U(30), les supports {1,11,29} et {7,11,13} ont tous deux une énergie 24, mais leurs spectres respectifs sont 3 (×2), 1 (×4), −1 (×2) et 3 (×1), 1 (×3), −1 (×3), −3 (×1). Ce contrôle fini ne constitue pas une classification générale.

### G30 — composantes et convention

Graphe de Cayley de U(30) pour {1,11,29}
Pour l’adjacence comprenant l’identité, le calcul exact donne deux composantes {1,11,19,29} et {7,13,17,23}, huit boucles et huit arêtes non bouclées. Le spectre est 3 (×2), 1 (×4), −1 (×2). Le graphe total ne présente pas de mélange vers une unique loi stationnaire indépendante du point de départ. Une éventuelle convergence se décrit composante par composante. Les termes degré, Ramanujan et zêta d’Ihara requièrent une convention explicite et une justification adaptée aux boucles et à la déconnexion.

## Preuves et versions accessibles

- STROBO : PR #25 reste un brouillon. Le commit `045afdc1b2175b1f415807cd191cb46b5e86a153` a sept modules Lean et les reçus SUCCESS [Lean #38605249711](https://github.com/alexcour/couret-finite-verifications/actions/runs/38605249711) et [verify #38605249705](https://github.com/alexcour/couret-finite-verifications/actions/runs/38605249705). La formule totale de survie sans zéro exige `|G[2]|>=4`. L’histogramme ordinaire universel taille par taille, la combinaison complètement évaluée, les paires non translatives et les maxima ne sont pas tous clos.
- Cayley : le [dépôt H×C_p](https://github.com/alexcour/cayley-prime-translation-cospectrality) garde son propre statut PUBLIC REVIEW 0.1.x. La famille orientée de la PR #30 et ses quatre reçus CI au commit `3b2cbb9ea7d1015518b6c8fb72e92fe890e8afd2` sont distincts ; le théorème concret uniforme n’est pas intégralement instancié en Lean. Aucune transposition automatique aux graphes non orientés.
- [KLMN, Quadratic Forms, théorème 6](https://nielsbenedikter.de/advmaphys2/q_form.pdf) : expliciter forme, domaine, symétrie et borne relative ; une seule norme HS ne suffit pas.
- Le [vérificateur G30 existant](verify_site_cayley_g30.py) confirme les deux composantes, les boucles, le contre-exemple à l’inférence énergie → spectre et les cinq témoins F-08. Sa validation interne ne vaut pas audit externe.

## Reçus publics avant application

Les empreintes concernent les réponses servies au contrôle, pas la base WordPress. Les captures HTML brutes demeurent des pièces de travail ; le tableau évite toute publication de données privées.

| URL | Contrôle UTC | HTTP | SHA-256 |
|---|---|---|---|
| https://www.couretunification.fr/ | 2026-10-14T18:04:03.317150+00:00 | 200 | `9db9fdeb1eb851ead585399978ad81bbb92cf2ce611ebcd05a80180a80c84882` |
| https://www.couretunification.fr/carte/ | 2026-10-14T18:03:23.624516+00:00 | 200 | `6ffbef70f10c94d293a4cfcffe25f61e151a5970fd5ebb69b65facde389e7088` |
| https://www.couretunification.fr/contact/ | 2026-10-14T18:02:40.586807+00:00 | 200 | `faa953723c51864c1c78ea157df2fb729a77d0fd92f07a8279c5f1f6f24ab5f7` |
| https://www.couretunification.fr/contradictions-et-dettes/ | 2026-10-14T18:03:31.749131+00:00 | 200 | `a62888fe08139a8373514a941a45d303f612e41504b167211e772485440dae4e` |
| https://www.couretunification.fr/direction-de-recherche/ | 2026-10-14T18:03:23.621901+00:00 | 200 | `fde85c31884057b1d72f0a56a6710ae4498556e76519dc5cdadf50bbce1c66f4` |
| https://www.couretunification.fr/le-senseur/ | 2026-10-14T18:03:31.883487+00:00 | 200 | `04224627af665471a049088d0d6b225cfae56ac35802463905eb12b647847a77` |
| https://www.couretunification.fr/les-mathematiques-du-programme/ | 2026-10-14T18:03:23.622419+00:00 | 200 | `2f2f5d33ff16cc26054084dc32bf22166c352b3e974c911faf88d0dc4b3221a7` |
| https://www.couretunification.fr/programme/ce-que-cu-ne-revendique-pas/ | 2026-10-14T18:03:31.759156+00:00 | 200 | `6b36f25cf874fa2543214c7ac2cecbef60f3b6b8ffe3133e38ababa20ccca75a` |
| https://www.couretunification.fr/publications-et-depots/ | 2026-10-14T18:02:40.467916+00:00 | 200 | `6254bbcd06277a10ea14d67ae3019c89024b293e8d86662316bfa48bd3f248c2` |
| https://www.couretunification.fr/publications/borne-klmn/ | 2026-10-14T18:02:40.730549+00:00 | 200 | `dc493a4b578bdef9c01ec30bb98293caca233ad137b58d5807156693246958a3` |
| https://www.couretunification.fr/publications/cayg-tc-ramanujan-finie/ | 2026-10-14T18:03:23.620635+00:00 | 200 | `687323c27b88a39795310e4174c832775b789c991ab0c63f853994f16a0b27b2` |
| https://www.couretunification.fr/publications/h1/ | 2026-10-14T18:02:40.653592+00:00 | 200 | `02446eba2a5112f6b2f052908c5075a8b8a98f7ab2aea7c73480fe19a52f9ed0` |
| https://www.couretunification.fr/publications/identite-v18-sinc-%c2%b7-anti-tournoiement-f6-%c2%b7-table-des-moments-%cf%84k/ | 2026-10-14T18:03:31.919504+00:00 | 200 | `96e77410b46be32189ec6c4a391c7e615fae612b85f447aef15a3405de32a664` |
| https://www.couretunification.fr/publications/triplet-canonique-t_c-1-11-29/ | 2026-10-14T18:03:23.621454+00:00 | 200 | `5811d9ae7226c41a61cd09f30c96fe26684053ca80205b74b84e3bad86415d82` |
| https://www.couretunification.fr/recherche-actuelle/ | 2026-10-14T18:02:40.432738+00:00 | 200 | `aabe0942985953b6e0adc7f67d956fe0a73db9af513bc0a3f697ae1fd3c2be54` |
| https://www.couretunification.fr/recherches/ | 2026-10-14T18:02:29.603551+00:00 | 200 | `a661c0ca06841bac50c4dad6d106f54a023214ca60bbc90b876d743278c2e392` |
| https://www.couretunification.fr/registre-f0/ | 2026-10-14T18:02:29.604284+00:00 | 200 | `904576688614850faca5454c8643d339c217872c277bdddcf04788818a30224b` |
| https://www.couretunification.fr/registre/ | 2026-10-14T18:02:29.604969+00:00 | 200 | `ce7a8653fea85588f3437a7eb5f99149afa2b7fdc523ce41b1a09d035e492f47` |
| https://www.couretunification.fr/resultats-minimaux/ | 2026-10-14T18:02:29.600754+00:00 | 200 | `6a42b4c565f5549f8a81014ca757b7357629b076d191956bf1b3a7255c049db6` |
| https://www.couretunification.fr/tableau-de-bord/ | 2026-10-14T18:02:29.599925+00:00 | 200 | `e6312907d3594513ed4dd1cf8eccb67d89be289be5fd0b0c40b20e0cdacccae4` |
| https://www.couretunification.fr/verification/ | 2026-10-14T18:02:29.601375+00:00 | 200 | `5de4f32c781d6cec9d4469de46d5bf074d200bbd3e8232287f366e28555df53d` |

## Application et contrôle

1. Lire le contenu brut de chaque page via l’accès WordPress authentifié et identifier le bloc exact ; préserver une révision avant correction.
2. Appliquer les remplacements retenus, avec aperçu des expressions mathématiques et du rendu. L’approbation de l’auteur porte sur ces corrections précises ; aucune nouvelle diffusion scientifique n’en découle.
3. Harmoniser les extraits H1 dans Catalogue, Tableau de bord, Registre F0 et Le (S)enseur. Ajouter aux vues historiques le renvoi vers les deux branches actuelles. Actualiser titre SEO, description et navigation sans changer l’identité des archives.
4. Mettre à jour les pages autorisées puis relire la réponse publique et le rendu. Enregistrer URL, révision et texte après correction. Un commit GitHub ou un bouton WordPress ne prouve pas à lui seul le contenu public servi.
5. Conserver les limites E/N/Q : aucune priorité générale, relecture indépendante ou complétude Lean non démontrée. Aucun portail privé, annexe, correspondance ou matériau brevet-sensible n’est partagé. Aucun nouvel envoi à Frédéric.

**État de production au contrôle : corrections WordPress restantes ; accès CMS non connecté.**


**Integration status:** editorial PRs #34 and #9 are merged into main after explicit author approval on 14 October 2026 at 21:31 Europe/Paris. WordPress application still requires authenticated CMS access. No WordPress deployment or independent scientific validation is claimed.
