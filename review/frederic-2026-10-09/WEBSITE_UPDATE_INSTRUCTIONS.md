# Website update instructions for Frederic

MISE À JOUR DU SITE COURET — CONSIGNES UNIQUES POUR FRÉDÉRIC
Version 9 octobre 2026 — Document de préparation éditoriale ; aucune mise en ligne réalisée par ce texte.

1. ORIGINE ET DOCUMENTS DE RÉFÉRENCE
Dossier directeur de l'identité du site : https://docs.google.com/document/d/1Ec1t6mB_oJQ9rw2eHF6FirFICEDUJ-iFdGOedjS-5TY/edit
Guide V6, site et méthode : https://docs.google.com/document/d/1HOGKlceSUISCndSkOcH2DOl32TjYcR_TITR1jKcE0fE/edit
Pack maître Frédéric du 9 octobre : https://docs.google.com/document/d/1mmtJn2vR_mDWstRpESjI7xxRI75TRySzf4DOdrVi-Nc/edit
Plan de correction F-001 : https://docs.google.com/document/d/14gYS00iWJ3ZXK6CsnUSZIE0sRmNYLfS7ecMuYW7atVA/edit
Ces consignes actualisent les anciennes V4, V5, V6 et V7 pour le SITE UNIQUEMENT. Les archives demeurent ; ne pas appliquer un ancien statut de publication contradictoire.

2. IDENTITÉ À CONSERVER
Marque principale : COURET — ART · MATHÉMATIQUES · MÉMOIRE.
Accroche : « Voir les nombres. Éprouver les énoncés. Conserver les traces. »
Couret–Unification demeure le nom historique du programme et du domaine ; ne pas le présenter comme une preuve d'unification générale.
InterIA est le journal et la méthode humain–IA ; Bernard Couret est la source historique, ses manuscrits séparés des résultats contemporains.
Objectif : un atelier-laboratoire indépendant qui donne accès au parcours intuition > calcul > test > preuve ou réfutation > audit > transmission.

3. ARCHITECTURE À IMPLÉMENTER
Navigation : ŒUVRE | RECHERCHE | PUBLICATIONS | ARCHIVES | JOURNAL HUMAIN–IA | À PROPOS.
ŒUVRE : mode Galerie, images réelles, textes et œuvres clairement légendés comme créations.
RECHERCHE : mode Laboratoire, énoncés, hypothèses, limites, textes de preuve, code, statut de relecture, antériorité, versions.
PUBLICATIONS : page sobre, dates, DOI réels vérifiés, GitHub, HAL si confirmé, licences et absence éventuelle de peer review.
ARCHIVES : Bernard Couret, fac-similés, textes historiques ; distinguer primaire et reconstructions ; liens vers corrections.
JOURNAL HUMAIN–IA : expérimentations, erreurs, changements de statut, interventions des modèles ; ne pas suggérer validation par consensus d'IA.
À PROPOS : origine familiale et identité « chercheur indépendant » ; ne pas se présenter comme institut universitaire.

4. ACCUEIL — TEXTE RECOMMANDÉ
COURET
ART · MATHÉMATIQUES · MÉMOIRE
Voir les nombres. Éprouver les énoncés. Conserver les traces.
« Un atelier-laboratoire indépendant où les manuscrits transmis par Bernard Couret rencontrent la création artistique, les calculs reproductibles et une recherche mathématique ouverte à la contradiction. Les œuvres, hypothèses, résultats vérifiés, erreurs et archives sont présentés séparément, avec leur état réel. »
Blocs : Œuvre phare ; 3 recherches réellement accessibles ; dernières corrections ; publications ; Bernard Couret ; journal humain–IA.
Deux CTA sobres : « Explorer la recherche » et « Consulter les publications et codes ».

5. ACTUALISATION IMPÉRATIVE DES FICHES SCIENTIFIQUES
CAYLEY : https://github.com/alexcour/cayley-prime-translation-cospectrality . Le dépôt est déjà public en PUBLIC REVIEW 0.1.x ; les théorèmes 10A6, 10C3 et 10B1 sont « démontrés selon les textes internes, en attente de relecture humaine indépendante », avec audit d'antériorité ouvert ; Meng 1998 non lu dans le dossier disponible ; Brown/Mönius couvrent des sous-familles cycliques. NE PAS afficher « nouvelle classification », « certifié » ou DOI Cayley.
G30 / finite verifications : https://github.com/alexcour/couret-finite-verifications ; calculs finis et corrections traçables, sans généralisation analytique.
HOL-01 : https://github.com/alexcour/hol01-monodromy-p7 ; certificat fini p=7, sans théorème global automatique.
Journal sur les mathématiques issues de l'IA : https://github.com/alexcour/qui-repond-mathematiques-ia ; préciser méthodologie et statut éditorial réel.
SPEC-OBS : résultats expérimentaux / finis sous audit ; l'égalité de 4-deck de deux graphes ne prouve PAS leur cospectralité. Corriger toute ancienne présentation de la paire D9 S={1,9,12} et T={1,9,13} comme cospectrale.
CU-BRUIT : hypothèses GRH + LI pour les conclusions de type Rubinstein–Sarnak ; contrôle externe des zéros incomplet, aucun théorème RH.
LEAN : expliquer qu'une CI réussie ou « zero sorry » ne garantit pas à elle seule l'absence d'axiomes supplémentaires ni la vérité des prétentions externes. STAT_TRANS ne doit jamais apparaître « autocertifié ».
Autres recherches (Connes, Grothendieck, Liouville, Navier–Stokes et RH) : afficher un statut de piste, archive ou critique selon chaque élément ; aucune découverte générale revendiquée.

6. F-001 — RECTIFICATION VISIBLE, PRIORITÉ HAUTE
Sur toute page où « environ 0,378 » est présenté comme mesure de la proportion de nombres premiers dans {1,11,29} modulo 30, remplacer dans le contenu CURRENT par :
« À x=10^9, la proportion recalculée vaut environ 0,3749982, proche de 3/8. L'ancienne valeur proche de 0,378 était erronée. La limite 3/8 n'est pas un nouveau résultat. »
Créer un bandeau d'erratum F-001 sur les anciennes pages conservées, avec renvoi au registre des corrections :
https://github.com/alexcour/couret-finite-verifications/blob/main/PUBLIC_FALSIFICATIONS.md
Le rapport d'audit signale qu'aucun déploiement de la correction sur couretunification.fr n'était confirmé au 9 octobre : contrôler réellement le site après intervention.
Ne pas appeler « température des premiers » le produit eulérien associé aux entiers sans facteur carré (mu²).

7. PUBLICATIONS ET MÉTADONNÉES
Afficher séparément : « dépôts / publications déjà archivées », « recherche publique en relecture », « projets / archives ».
Identifiants répertoriés à contrôler avant mise en ligne : finite-verifications v1.0.0 (Zenodo 10.5281/zenodo.22978365) ; HOL-01 v1.1.1 (10.5281/zenodo.22978389) ; Qui répond… (10.5281/zenodo.23079572, HAL hal-05773424). Vérifier URL, version, auteurs, licences, date, type de publication. Ne pas assimiler DOI à évaluation par les pairs.
Ajouter pour Cayley un encart « Open review — independent checking welcome » renvoyant au dépôt sans prétendre qu'une soumission ou un rapport de referee existe.

8. PROTECTION BREVET ET DROITS
Aucune divulgation nouvelle de la substance de FCI, CC-06, CONT-P, TRUST-LIFE ou COSTGATE. Le cabinet a fixé une restriction jusqu'au 26/12/2026 ET à son avis écrit ; la date seule ne vaut jamais feu vert. Suspendre les pages ou fichiers exposant des contenus brevet-sensibles identifiés ; conserver les preuves de versions et signaler les expositions antérieures au cabinet. Ne pas supposer que la suppression efface une divulgation passée.
Ne pas copier des dossiers Drive privés dans WordPress et ne jamais publier des répertoires entiers non contrôlés. Respecter droits tiers, consentements et informations personnelles.

9. SEO ET NAVIGATION POUR LES CHERCHEURS
Créer la page « Publications et relecture indépendante » avec liens stables vers preuves, scripts, limites et errata.
Titres disciplinaires descriptifs (« graphes de Cayley », « groupes abéliens finis », « Barning–Hall p=7 », « nombres premiers mod 30 ») plutôt que slogans généraux.
Ajouter à chaque fiche un historique daté : version, statut scientifique, audit de nouveauté, correction, lien source. Mettre les corrections CURRENT au-dessus des vieux résultats dans les moteurs et dans la navigation ; anciennes pages archivées renvoient vers les corrections.
Mettre en place un parcours anglais pour les mathématiciens externes ; pas de faux schema.org ScholarlyArticle « peer reviewed ».

10. RECETTE / CONTRÔLE APRÈS MISE EN LIGNE
Vérifier sur mobile et ordinateur, liens cassés, DOI résolus, menus, contraste, métadonnées, redirections, archives et bandeaux d'errata.
Faire une capture / un état daté de chaque page corrigée.
Ne pas déclarer le site mis à jour avant vérification de l'URL publique et de la version réellement visible.
Priorités techniques : (1) retirer contenu brevet-sensible identifié ; (2) corriger F-001 et anciens claims ; (3) corriger l'état public Cayley ; (4) rendre les publications et la relecture accessibles ; (5) intégrer identité COURET et le parcours ŒUVRE/RECHERCHE ; (6) archiver les versions anciennes.
Frédéric coordonne la mise en ligne ; les questions mathématiques reviennent à un expert, les questions brevet au cabinet.

11. MESSAGE D'ACCOMPAGNEMENT
« Voici les consignes actualisées pour le site. Elles remplacent pour les contenus CURRENT les instructions éditoriales plus anciennes. Aucun contenu FCI ne doit être mis en ligne. Merci de traiter d'abord le périmètre brevet et l'erratum sur les nombres premiers, puis la page Publications et le statut de Cayley. »
