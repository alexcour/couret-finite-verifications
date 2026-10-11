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
3. F-08 : conserver les égalités spectrales précises mais ne pas déduire l'identité du spectre du seul cardinal ; contrôler le contre-exemple.
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

**P0-03 — F-08 / Parseval.** État : RISQUE MATHÉMATIQUE AVÉRÉ, localisation exacte sur la production NON CONFIRMÉE. Texte public de remplacement : « Pour une fonction f sur un groupe abélien fini G, l'identité de Plancherel–Parseval relie l'énergie totale à la somme des carrés des coefficients de Fourier, avec la normalisation choisie. Pour l'indicatrice d'un support S, cela ne détermine pas à lui seul le multiensemble des valeurs propres de la convolution associée. Un même cardinal de support impose la même somme des carrés des modules des coefficients, non l'égalité de tous les coefficients ou des spectres. »

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
