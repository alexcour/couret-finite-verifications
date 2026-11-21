# Mise à jour éditoriale du 14 octobre 2026

Les corrections publiques préparées ont été approuvées pour application par l’auteur. Voir [la matrice et les textes corrigés](SITE_CORRECTIONS_APPROVED_2026-10-14.md). Les lectures HTTP directes de ce jour remplacent les seuls constats indexés de l’ancienne recette : 21 pages répondent HTTP 200, et les erreurs RH/H1/Parseval/mélange restent constatées sur les URL identifiées. Contact n’affiche plus la phrase RH signalée dans une ancienne indexation.

L’approbation concerne l’intégration éditoriale et les corrections publiques précises. Elle ne constitue ni relecture scientifique indépendante, ni priorité, ni fusion des PR de recherche #25/#30, ni release/DOI, ni diffusion de documents confidentiels. L’accès d’édition WordPress est encore nécessaire ; aucune application CMS n’est attestée. Les anciens états DRAFT/NO DEPLOY ci-dessous restent des archives décisionnelles datées et sont remplacés, pour ce seul périmètre éditorial, par la décision du 14 octobre.

---

## Archive de la recette et des contrôles antérieurs — conservée pour traçabilité

# COURET site — audit de représentativité / recette
**Date : 2026-10-11. Statut : brouillon éditorial, non déployé, sans requalification scientifique.**

## Contrat de mise à jour
- Ne jamais publier à partir du seul nom d'un dossier marqué CURRENT : vérifier le fichier primaire, le périmètre de diffusion et les autorisations.
- Conserver la marque COURET — ART · MATHÉMATIQUES · MÉMOIRE ; le nom Couret–Unification reste historique.
- Navigation : Œuvre / Recherche / Publications / Archives / Journal humain–IA / À propos.
- Ne pas effacer les archives. Afficher une rectification CURRENT datée et le chemin vers la pièce originale.
- Ne pas confondre état E (validité), N (antériorité), Q (reproductibilité et relecture), provenance, diffusion et version.
- Ne pas prétendre qu'une demande de relecture, un DOI, un CI PASS ou un commit correspondent à un aval indépendant.

## Priorité haute : vérifications avant toute réécriture
1. Inspecter et corriger les avertissements PHP de WordPress sur les pages publiques ; masquer les détails serveur aux visiteurs après correction de la cause.
2. Confronter l'emploi du mot « équivalent » pour RH aux deux implications réellement documentées.
3. PARSEVAL (distinct de F-08) : la même énergie totale n'implique pas l'identité des spectres. F-08 est déjà corrigé sur la page « Le (S)enseur » : non-unicité de T_C parmi au moins cinq triplets isospectraux. Contrôler séparément toute assertion incorrecte restée ailleurs.
4. H1 : contrôler symétrie, domaine, formes fermées et borne relative avant d'invoquer KLMN.
5. Fiche Cayley : graphe déconnecté => ne pas inférer un mélange global ; vérifier convention de boucles et compte d'arêtes.
6. F-001 : retirer les usages CURRENT du ratio 0,378 et afficher l'erratum public (environ 0,3749982 à x=10^9, limite classique 3/8).
7. Aligner la présentation de K# / K^p et les statuts historiques [D]/[P] avec la grille CURRENT.

## Pages et sources
- Accueil : https://www.couretunification.fr/
- Publications : https://www.couretunification.fr/publications-et-depots/
- Registre : https://www.couretunification.fr/registre/
- Résultats minimaux : https://www.couretunification.fr/resultats-minimaux/
- Cayley : https://github.com/alexcour/cayley-prime-translation-cospectrality
- STROBO-C3 PR8 : https://github.com/alexcour/couret-finite-verifications/pull/8
- CU-BRUIT PR4 : https://github.com/alexcour/couret-finite-verifications/pull/4
- Paquet éditorial maître (Drive, non destiné au site) : https://docs.google.com/document/d/1CLkhkmJz5YAJJzr5tOVOzyo6EWpgn7U7X9-9ob_QNfE/edit

## Recette de Frédéric (à documenter avant GO)
- Contrôler statut exact, dates et liens de chaque fiche après intégration.
- Tester HTML sans scripts, mobile, navigation clavier, moteur de recherche, sitemap, canonicals, DOI et redirections.
- Tester les liens des procédures de reproduction et les fichiers réellement accessibles.
- Contrôler chaque page modifiée en production et dater sa capture/son état.
- Obtenir l'autorisation nécessaire avant diffusion de tout contenu protégé, brevet-sensible ou privé ; exclure les matériaux techniques FCI/CONT et les corpus OBS-SEQ internes de ce périmètre public.
- Ne pas fusionner ce dossier et ne pas publier sur WordPress sans recette, validation éditoriale et revue du périmètre.

**GATE : DRAFT — NO DEPLOY.** Cette checklist ne certifie pas la résolution des constats ; elle les soumet au contrôle.


---
## ANNEXE D'AUDIT SCIENTIFIQUE — 11 OCTOBRE 2026 (INTERNE, NON PUBLIABLE TELLE QUELLE)

### Portée du constat
Audit documentaire fondé sur le projet Google Docs du 11 octobre, le guide maître du 9 octobre, le registre public GitHub `PUBLIC_FALSIFICATIONS.md`, le fichier `CLAIM_BOUNDARY.md`, les pages du site que les outils de recherche ont pu récupérer et un calcul matriciel indépendant exact. **Une page indexée ne vaut pas contrôle en temps réel de la production WordPress**. Pour chaque correction, Frédéric doit consigner : URL, horodatage, capture, texte exact avant/après, version de cache éventuelle et nom de la personne ayant validé. N'imputer aucune erreur à la version en production sans cet élément.

### Registre P0 : verdict et texte prêt à coller

**P0-01 — PHP / WordPress.** État : NON VÉRIFIABLE EN PRODUCTION. Aucun avertissement PHP n'est certifié visible actuellement par ce contrôle. Action : inspecter l'accueil, Publications, Registre, Résultats minimaux et Contact en session anonyme, vue source et capture, puis journaux serveur autorisés ; corriger la cause avant de désactiver l'affichage public des diagnostics. Réglage WordPress à vérifier par l'administrateur : `WP_DEBUG_DISPLAY=false` (ne pas exposer les erreurs aux visiteurs), avec journalisation interne contrôlée. Ne pas annoncer « PHP corrigé » sans rejeu effectif.

**P0-02 — Prétendue équivalence avec RH.** État : FORMULATION HISTORIQUEMENT OBSERVÉE sur une version indexée de la page Contact ; présence actuelle NON CERTIFIÉE. Texte public de remplacement : « Certains travaux historiques de ce programme étudient des questions reliées au contexte de l'hypothèse de Riemann. Aucun résultat présenté ici ne démontre cette hypothèse ni une équivalence nouvelle avec elle. Les implications éventuellement étudiées sont indiquées avec leurs hypothèses et leurs limites dans les documents sources. » Ne rétablir le mot « équivalent » que si un énoncé précis de type P ⇔ RH possède des démonstrations des deux sens, examinées indépendamment.

**P0-03 — Parseval, à ne pas confondre avec l'erratum historique F-08.** État : RISQUE MATHÉMATIQUE AVÉRÉ, localisation exacte sur la production NON CONFIRMÉE. Texte public de remplacement : « Pour une fonction f sur un groupe abélien fini G, l'identité de Plancherel–Parseval relie l'énergie totale à la somme des carrés des coefficients de Fourier, avec la normalisation choisie. Pour l'indicatrice d'un support S, cela ne détermine pas à lui seul le multiensemble des valeurs propres de la convolution associée. Un même cardinal de support impose la même somme des carrés des modules des coefficients, non l'égalité de tous les coefficients ou des spectres. »

Contre-vérification reproductible : sur U(30), S={1,11,29} et T={7,11,13}, tous deux de cardinal trois, les matrices de convolution symétriques ont la même somme de carrés des valeurs propres (=24), mais des spectres différents : S : 3 (multiplicité 2), 1 (4), −1 (2) ; T : 3 (1), 1 (3), −1 (3), −3 (1). Les deux matrices sont contrôlées par `review/site-couret-2026-10-11/verify_site_cayley_g30.py` avec arithmétique rationnelle exacte. Conventions : matrices 8×8 indexées par U(30), A[a,b]=1 si a b⁻¹∈support, boucles conservées.

**P0-04 — H1 et KLMN.** État : FORMULATION INSUFFISANTE DANS UNE VERSION INDEXÉE DE L'ACCUEIL ; hypothèses effectives de H1 non réexaminées ici. Remplacement : « Une estimation Hilbert–Schmidt peut fournir la bornitude d'un opérateur intégral lorsque son noyau satisfait les conditions appropriées. Elle ne suffit pas, à elle seule, à établir l'auto-adjonction d'un opérateur non borné donné ni les hypothèses du théorème KLMN. L'application de KLMN exige la définition d'une forme quadratique symétrique, dense, fermée et semi-bornée, ainsi qu'une perturbation de forme symétrique ayant une borne relative strictement inférieure à 1. Aucune conclusion d'auto-adjonction n'est revendiquée ici tant que ces vérifications ne sont pas produites pour H1. » Précision : un opérateur Hilbert–Schmidt lui-même est borné sur l'espace de Hilbert déclaré, mais sa seule propriété HS ne le rend pas auto-adjoint ; pour une somme opératorielle, les hypothèses et le théorème invoqués doivent être indiqués sans confusion.

**P0-05 — Déconnexion et mélange.** État : DÉCONNEXION EXACTEMENT REPRODUITE pour le graphe de Cayley symétrique de U(30) avec S={1,11,29} ; mention en production NON CONFIRMÉE. Le support contient 1, donc le graphe porte huit boucles si la convention les conserve ; 8 arêtes non bouclées ; deux composantes de 4 sommets : {1,11,19,29} et {7,13,17,23}. Somme des degrés (=boucles comprises)=24. Texte public : « Pour le support {1,11,29} sur U(30), le graphe de Cayley considéré n'est pas connexe. Toute convergence d'une marche aléatoire doit donc être formulée relativement à sa classe de communication, sous les hypothèses d'irréductibilité et d'apériodicité pertinentes ; aucune convergence vers une unique loi stationnaire sur les huit sommets à partir de tous les états initiaux n'est établie. Les degrés et les nombres d'arêtes dépendent de la convention explicite sur les boucles. » La matrice normalisée A/3 est aperiodique dans chaque composante grâce aux boucles ; elle admet plusieurs lois stationnaires globales. La convention sans boucles change le nombre d'arêtes, pas la déconnexion de ce cas.

**P0-06 — F-001 / 0,378.** État : CORRECTION DOCUMENTAIRE APPLIQUÉE SUR GITHUB `PUBLIC_FALSIFICATIONS.md` au 9 octobre ; au moins une version indexée de l'accueil montre également la rectification ; propagation à toutes les pages CURRENT de WordPress NON CERTIFIÉE. Texte exact : « Correction F-001 (9 octobre 2026). Parmi les 50 847 534 nombres premiers ≤10⁹, 19 067 732 appartiennent aux classes 1, 11 ou 29 modulo 30, soit 0,374998166086 environ. L'ancienne valeur observée 0,378 est erronée. La proportion asymptotique 3/8 résulte du théorème des nombres premiers dans les progressions arithmétiques et du fait que trois classes ont été choisies parmi les huit classes inversibles modulo 30 : il ne s'agit pas d'une découverte originale. » Source publique : https://github.com/alexcour/couret-finite-verifications/blob/main/PUBLIC_FALSIFICATIONS.md . Réserves : les comptages sont ceux déclarés et accompagnés de leur source C++ ; ne pas annoncer de rejeu externe indépendant du dépôt.

**P1-07 — K# et K^p.** État : STATUT DOCUMENTAIRE À NORMALISER, présence actuelle par page NON EXHAUSTIVEMENT VÉRIFIÉE. Remplacement général : « Les variantes K# et K^p correspondent à des voies distinctes et à des obstructions démontrées ou calculées dans des cadres explicitement délimités. Elles ne constituent pas une démonstration de l'hypothèse de Riemann. Les difficultés de définition fonctionnelle, de trace et de recollement non résolues doivent rester visibles et ne pas être présentées comme des étapes achevées. » N'utiliser aucun qualificatif « preuve de RH » ni extrapoler d'une obstruction à toutes les voies possibles.

**P1-08 — Statuts / provenance.** État : les textes Google Docs et PR #9 distinguent déjà E, N, Q et diffusion. Bloc public prêt à coller : « Validité E : statut mathématique du résultat sous ses hypothèses ; antériorité N : statut de l'étude des travaux précédents ; contrôle Q : nature et indépendance de la reproduction et de la relecture ; diffusion D : état de publication et version accessible. Une validation automatique, un DOI, un dépôt public ou un témoin interne ne prouvent ni la nouveauté ni une relecture indépendante. » Pour Cayley 10A6/10C3/10B1 : « revue publique préparatoire 0.1.x, preuves internes, examen indépendant et audit d'antériorité ouverts, pas de release scientifique stable ». Voir https://github.com/alexcour/cayley-prime-translation-cospectrality/blob/main/CLAIM_BOUNDARY.md .

### Ajout conseillé à « Recherche actuelle » (avant validation)
« Les résultats numériques et algébriques présentés ici sont accompagnés de leurs limites. Par exemple, deux matrices de Cayley peuvent partager la même énergie de Fourier sans avoir le même spectre ; une marche sur un graphe déconnecté n'admet pas le mélange global parfois supposé. Nous corrigeons explicitement les erreurs historiques : la valeur 0,378 autrefois annoncée pour trois classes de nombres premiers modulo 30 était erronée et est retirée. Ces rectifications appartiennent pleinement au dossier scientifique. »

### Sources publiques et sources documentaires autorisées
- Registre F-001 et autres corrections : https://github.com/alexcour/couret-finite-verifications/blob/main/PUBLIC_FALSIFICATIONS.md
- Contrôle exact créé dans cette PR, sans dépendances : review/site-couret-2026-10-11/verify_site_cayley_g30.py
- Périmètre Cayley : https://github.com/alexcour/cayley-prime-translation-cospectrality/blob/main/CLAIM_BOUNDARY.md
- Source première côté documentation : https://docs.google.com/document/d/1CLkhkmJz5YAJJzr5tOVOzyo6EWpgn7U7X9-9ob_QNfE/edit (document maître, ne pas copier automatiquement sur WordPress)
- Page draft Drive : https://docs.google.com/document/d/1i8q0tRJaM7re6MegOVVYaFEAUu_Hoy3QF2vRXrxGii8/edit (brouillon, non autorisé)
- Référence classique : théorème de Plancherel–Parseval sur les groupes abéliens finis ; théorème KLMN pour les perturbations de formes quadratiques semi-bornées ; théorème des nombres premiers en progressions arithmétiques ; théorème de convergence des chaînes de Markov finies irréductibles apériodiques. Ne pas attribuer ces théorèmes classiques au programme COURET.

### Recette finale et interdits
Conserver PR #9 en brouillon, ne pas fusionner et ne pas déployer. Obtenir les captures horodatées de la production, vérifier chaque texte corrigé et les redirections, vérifier liens et statuts exacts. Ne pas copier de pièces privées, dossiers FCI/CONT-P/TRUST-LIFE/COSTGATE, de documents de brevet ou du corpus OBS-SEQ ; aucun document Drive privé ne doit être rendu public par commodité. Appliquer le guide maître du 9 octobre et demander l'avis écrit du conseil compétent avant toute communication relevant du périmètre protégé. Le 26 décembre 2026 n'est pas une autorisation de diffusion automatique.

**GATE : DRAFT — NO DEPLOY. Les erreurs mathématiques de portée générale ont été établies/corrigées dans cette annexe, pas l'état complet de production WordPress.**


---
## DEUXIÈME PASSE — CARTOGRAPHIE DES PAGES INDEXÉES — 11 OCTOBRE 2026

### Méthode / niveau de preuve
Sources : versions textuelles publiques accessibles via moteur d'indexation ou cache HTTP le 11 octobre 2026. Les dates de collecte déclarées par les outils vont de « hier » à environ 3 mois ; il ne s'agit **pas** d'une capture de la base WordPress à l'instant T. Le contrôle HTTP direct et les journaux serveur n'étaient pas disponibles dans cette passe. Le statut « observé » désigne donc une **version indexée**, jamais un certificat de production actuelle. Les pages liées qui renvoient une erreur de récupération restent INCONNUES, non déclarées absentes ou en panne.

### Matrice page → texte observé → action exacte

| Surface | Observation textuelle vérifiable (cache/index) | Statut de la correction | Action à réaliser après capture WordPress |
|---|---|---|---|
| [Accueil](https://www.couretunification.fr/) | L'identité « COURET — ART · MATHÉMATIQUES · MÉMOIRE » et l'erratum F-001 (0,3749982) figurent dans un résultat indexé récemment ; une autre section du même index présente encore un point ouvert comme « équivalent à l'hypothèse de Riemann » ; une version HTML plus ancienne affiche la borne HS « ⇒ auto-adjonction unique ». | **PARTIELLEMENT CORRIGÉ DANS LES VERSIONS INDEXÉES** ; RH/H1 à traiter, version exacte et date du serveur non certifiées. | Ne pas refaire l'identité ni retirer l'erratum correct. Contrôler séparément RH et H1 dans la page publiée, avec textes ci-dessous. |
| [Contact](https://www.couretunification.fr/contact/) | « Nous présentons un unique point ouvert comme équivalent à l'hypothèse de Riemann. » | **FORMULATION PROBLÉMATIQUE CONSTATÉE dans index**, diffusion actuelle non certifiée. | Retirer cette phrase, utiliser le remplacement RH ci-dessous ; ne pas laisser la même phrase dans un bloc de footer réutilisé. |
| [Résultats minimaux](https://www.couretunification.fr/resultats-minimaux/) | Le même paragraphe « équivalent à RH » apparaît dans la copie indexée. | **CONSTAT INDEXÉ**, état live non contrôlé. | Détecter s'il s'agit d'un composant commun et corriger une seule fois à la source, puis retester ces pages. |
| [Recherches](https://www.couretunification.fr/recherches/) | « H1 — l'auto-adjonction, fermée par une borne » est affiché avec [D]/[P], tandis que « Borne KLMN » est [C]/[O] ; un item « Cay(G₃₀,T_C) — Ramanujan finie » est présent. | **DIVERGENCE ÉPISTÉMIQUE OBSERVÉE dans index**, formulation mathématique à borner. | Aligner H1 et KLMN sur la preuve effectivement apportée ; pour Cayley, afficher les composantes et préciser la convention de boucles et l'usage du terme « Ramanujan ». |
| [Registre F0](https://www.couretunification.fr/registre-f0/) | La ligne « Borne KLMN — H1 fermée » est [D], mais signalée « claim > support », preuve écrite et Lean à publier. | **PREUVE PUBLIQUE MANQUANTE RECONNUE PAR LA PAGE**. | Conserver l'indicateur « claim > support » et rétrograder toute formulation de clôture non appuyée par une preuve complète contrôlable. |
| [Le (S)enseur](https://www.couretunification.fr/le-senseur/) | F-08 retire déjà l'unicité spectrale de T_C et cite cinq supports isospectraux. F-05 limite déjà l'invariant Parseval de la tour primorielle ; F-01 corrige déjà le spectre négatif. | **CORRECTIONS HISTORIQUES APPLIQUÉES dans la page indexée**. | Ne pas écraser ces errata ni redéclarer F-08 comme une faute non corrigée ; renvoyer vers eux lors d'autres corrections. |
| [La fabrique des machines](https://www.couretunification.fr/la-fabrique-des-machines/) et [Accueil](https://www.couretunification.fr/) | Une copie de l'accueil dit « couches actives : 11 sorry » ; « La fabrique » mentionne « 18 sorrys ». | **INCOHÉRENCE DE VERSIONS INDEXÉES**, valeur actuelle non auditée. | Afficher le nombre par dépôt/commit/branche ou éviter un chiffre transitoire non daté ; ne pas extrapoler « zero-sorry » à l'ensemble du projet. |
| [Publications et dépôts](https://www.couretunification.fr/publications-et-depots/) | Récupération directe de la page non aboutie dans l'outil, sans code HTTP fiable. | **IMPOSSIBLE À VÉRIFIER**. | Ouvrir dans un navigateur standard, conserver statut HTTP, redirections, liens DOI et capture. Ne pas écrire « page supprimée » ou « 404 » sans contrôle. |
| PHP/WordPress | Aucun message d'erreur PHP attribuable au site n'a été reproduit de façon fiable dans cette passe. | **NON VÉRIFIÉ**. | Contrôler sans être connecté : source HTML et rendu, journaux PHP/WP autorisés, puis preuve de correction de la cause. |

### Correction formelle de nomenclature (important)
- **F-08 sur le site** = retrait de l'affirmation que T_C serait l'unique triplet distingué par le spectre. **Ce n'est pas** la généralisation abusive de Parseval. Cinq exemples affichés sur « Le (S)enseur » ont été recalculés indépendamment sur U(30) à partir des traces d'A, A², ..., A⁸ : S={1,7,13}, {1,11,19}, {1,11,29}, {1,17,23}, {1,19,29} ; mêmes traces (8,24,56,168,488,1464,4376,13128), donc même polynôme caractéristique en dimension 8. Le calcul indépendant confirme ces cinq témoins, **pas l'exhaustivité du recensement**.
- **L'abus de Parseval** est un risque distinct : tous les supports de cardinal 3 ont le même second moment de Fourier (=24 avec les conventions du cas) mais pas nécessairement le même spectre. Le support {7,11,13} partage ce second moment avec T_C, sans en partager le spectre : traces impaires différentes.
- **F-008 dans le registre GitHub** est encore une autre entrée : une interprétation cohomologique invalidée. Ne jamais confondre F-08 (numérotation du site), F-008 (registre GitHub) et le point algébrique Parseval.

### Formulations publiques prêtes à appliquer, sans expertise mathématique de l'intégrateur
**Bloc RH (remplacer chaque occurrence en page active)** :
> « Notre programme examine des propriétés mathématiques finies et des questions historiques pouvant évoquer l'hypothèse de Riemann. Aucun énoncé présenté ici n'est établi comme équivalent à cette hypothèse, sauf présentation explicite et démonstration vérifiée des deux implications. Aucune preuve de l'hypothèse de Riemann n'est revendiquée. »

**Bloc H1 / KLMN** :
> « Une borne de norme Hilbert–Schmidt peut établir la bornitude d'un opérateur. Elle ne constitue pas, à elle seule, une preuve de l'auto-adjonction de l'opérateur H1 étudié. Deux voies doivent être distinguées : (i) pour un opérateur de base déjà auto-adjoint, une perturbation bornée symétrique relève du théorème des perturbations bornées ; (ii) pour les formes, KLMN requiert une forme de base dense, fermée et semi-bornée et une perturbation de forme symétrique de borne relative strictement inférieure à 1. L'opérateur associé à la somme de formes est alors auto-adjoint. Aucune clôture de H1 n'est affirmée sans vérifier les domaines et hypothèses exacts. »

**Bloc Cayley / Ramanujan** :
> « Le graphe de Cayley sur U(30) associé au support {1,11,29} comporte deux composantes de quatre sommets : {1,11,19,29} et {7,13,17,23}. Avec la convention d'adjacence qui conserve l'identité 1, il possède huit boucles et huit arêtes ordinaires, et son spectre est {3 (×2), 1 (×4), −1 (×2)}. Il ne constitue pas un graphe connexe ni un mélangeur global. Les propriétés spectrales doivent être interprétées composante par composante ; le qualificatif Ramanujan exige une définition explicitée et ne doit pas suggérer une expansion globale. »

**Bloc F-08 déjà rectifié** :
> « L'ancienne revendication d'unicité spectrale du triplet {1,11,29} a été retirée. Plusieurs triplets distincts sur U(30) partagent son spectre ; les témoins et l'erratum figurent dans Le (S)enseur. Cette égalité particulière de spectre ne découle pas de Parseval seul. »

### Limites documentaires et recette de clôture
- Toute citation de la production doit être appuyée par capture datée sans connexion et idéalement réponse HTTP/version de page, non par le seul cache d'un moteur.
- Garder les corrections historiquement visibles : F-001, F-01, F-05, F-08. Ne pas réécrire les archives anciennes ; afficher des errata et liens CURRENT.
- Le site doit distinguer le statut d'une preuve, l'audit d'antériorité, la vérification CI et la mise en ligne effective. Les copies de versions indexées ne permettent pas de certifier l'état au 11 octobre de toutes les URL.
- Rien dans cette annexe ne contient de matériaux réservés FCI/CONT-P/TRUST-LIFE/COSTGATE/OBS-SEQ ou d'archives Drive privées. **Aucun déploiement ni fusion n'est autorisé ; PR #9 demeure un brouillon.**

---

## MISE À JOUR ÉDITORIALE DU 14 OCTOBRE 2026 — DRAFT / NO DEPLOY

**Objet :** cette section actualise la hiérarchie scientifique et la recette éditoriale, **sans effacer** les constats datés du 11 octobre ci-dessus. Source de vérité pour les énoncés : les preuves et statuts à commits figés ; le texte proposé de la page reste un **brouillon public-facing**, pas une publication.

### Hiérarchie requise sur toute future façade Recherche
1. Titre CURRENT : « Couret — Reconstruction additive et spectrale », avec **STROBO** en première branche (supports à trois éléments, fonction étiquetée de sommes ordonnées, diagonales et multiplicités) et **Cayley** en deuxième (multiensemble spectral d'un graphe de Cayley, orienté ou non selon le cas).
2. STROBO : classification de `R_S=R_T` en deux types, translations de 2-torsion et configurations exceptionnelles ; renvoyer aux hypothèses exactes de [PR #25](https://github.com/alexcour/couret-finite-verifications/pull/25). **Six** modules compilés au commit scientifique `310fcaf3c65c36eaed85149d4748bf9a6454ab47`, Lean run `38582324811`, verify run `38582324737`. Le théorème numérique du nombre total de fibres complètes sans zéro requiert **`h=|G[2]|≥4`**. L'histogramme ordinaire universel clos, l'agrégation entièrement évaluée, tous les comptes par paires/profils et les maxima globaux ne sont pas intégralement formalisés. Demander contrôle de l'empreinte CI du HEAD réel avant validation.
3. Cayley : [famille structurée H×C_p](https://github.com/alexcour/cayley-prime-translation-cospectrality) et témoins **10A6 / 10C3 / 10B1** selon leurs hypothèses ; **PUBLIC REVIEW 0.1.x**, relecture humaine ouverte, **N = NON AUDITÉE**, recouvrements publiés déjà relevés ([frontière](https://github.com/alexcour/cayley-prime-translation-cospectrality/blob/main/CLAIM_BOUNDARY.md)). Les travaux cycliques et contrôles exacts de [PR #30](https://github.com/alexcour/couret-finite-verifications/pull/30) sont un dossier distinct DRAFT ; ne pas extrapoler cospectralité depuis une égalité des seuls carrés d'adjacence sans justification propre.
4. **HOL-01, modulo 30, vérifications finies, CU-BRUIT et journal humain–IA** : section séparée « Archives / Explorations / Méthodes », sans statut de troisième à sixième branche active. Conserver les anciens documents, liens, corrections F-001/F-08 et provenance Bernard Couret. Le nom « Couret–Unification » est historique.
5. Comparer cette proposition avec [PR #34](https://github.com/alexcour/couret-finite-verifications/pull/34) : mêmes deux branches, attribution à Lev (2004), distinction des observables, aucune priorité ni théorie générale d'unification ; **ne pas fusionner les PR** pour résoudre le recouvrement documentaire.

### Recette spéciale de confidentialité et de déploiement
- N'inclure dans les futurs textes de site que les liens vers les **dépôts publics** dont la frontière de diffusion est explicite. Le portail scientifique et les guides Drive CURRENT sont privés ; les consulter pour l'audit, **ne pas les intégrer ni recopier** sur WordPress ou dans des fichiers publics GitHub.
- Exclure la correspondance, les répertoires FCI, CONT-P, TRUST-LIFE, COSTGATE, données personnelles, archives privées et documents sous embargo ; pour tout sujet brevet-sensible, **avis écrit du cabinet et autorisation de l'auteur**, même après le 26 décembre 2026. Ne changer aucune permission Drive.
- Contrôler ce qui est **effectivement servi** sur WordPress par URL, captures horodatées et état de cache ; les anciennes pages indexées ne prouvent pas le contenu courant du site. Conserver la matrice de recette historique et enregistrer les corrections uniquement après vérification réelle.
- Vérifier toutes les étiquettes E/N/Q/D, l'anglais, les références DOI existantes, les liens, l'absence de survente, l'accessibilité mobile, les erreurs PHP si présentes, les errata et les textes RH/H1/KLMN si toujours présents.
- **GATE : PR #9 DRAFT, PR #34 DRAFT, aucune fusion, aucun WordPress, aucun dépôt stable, aucune diffusion de matériel réservé, sans revue scientifique indépendante et validation éditoriale explicite.**


## DERNIER REÇU DOCUMENTAIRE — 14 OCTOBRE 2026 — PAS DE GO
- Les deux branches CURRENT sont STROBO et Cayley ; PR #34 et le portail Drive contiennent la même séparation. La branche PR #9 constitue uniquement un projet de remplacement ; elle ne certifie pas le texte en production.
- **STROBO PR #25 HEAD 045afdc1** : sept modules Lean dans le `lakefile`, CI `strobo-2tors-lean` [38605249711](https://github.com/alexcour/couret-finite-verifications/actions/runs/38605249711) et [verify 38605249705](https://github.com/alexcour/couret-finite-verifications/actions/runs/38605249705) SUCCESS. Le septième module est relatif aux profils ordinaires ; le compte global de fibres survivantes requiert `h>=4` ; l'histogramme ordinaire clos et les maxima universels ne sont pas encore établis en Lean. Les références à cinq/six modules précédentes sont des snapshots datés.
- **Cayley PR #30 HEAD 3b2cbb9** : [two-colour Lean 38605250938](https://github.com/alexcour/couret-finite-verifications/actions/runs/38605250938), [doublet Lean 38605250885](https://github.com/alexcour/couret-finite-verifications/actions/runs/38605250885), [finite 38605250877](https://github.com/alexcour/couret-finite-verifications/actions/runs/38605250877), [verify 38605250932](https://github.com/alexcour/couret-finite-verifications/actions/runs/38605250932) SUCCESS. Preuve écrite interne pour la famille des digraphes orientés de Z/(12r), `r>=1`, mais la spécialisation complète de la famille en Lean reste à certifier ; ne pas annoncer le résultat universel comme Lean-complet, ni l'étendre automatiquement aux graphes non orientés.
- **Audit du site** : le document Drive éditorial comporte un audit HTTP daté signalant des problèmes RH/H1, spectres/Parseval et mélange global, et une actualisation partielle déjà visible. Ces constats proviennent du rapport daté et non de la validation éditoriale de cette PR. Aucune correction WordPress n'est attestée par cette branche ; contrôler les pages exactes avant modification.
- **Confidentialité et décision** : ne copier aucun dossier Drive privé, contenu sous embargo ou matériau brevet-sensible vers GitHub/WordPress. PR #9 et #34 toujours DRAFT. Pas de merge, release, dépôt, publication ou modification des accès sans approbation explicite.


**Integration status:** editorial PRs #34 and #9 were explicitly approved on 14 October 2026 at 21:31 Europe/Paris and are merged into main (d137f119 and 3d2e7067). WordPress application still requires authenticated CMS access. These merges do not establish independent scientific review or a stable research release; historical draft statuses above are dated archives.
