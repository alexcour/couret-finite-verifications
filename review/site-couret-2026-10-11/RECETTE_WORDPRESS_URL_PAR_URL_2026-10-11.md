# COURET — Recette WordPress URL par URL
**11 octobre 2026 — document de travail / PR #9 / PAS DE DÉPLOIEMENT**

## Ce que cet audit démontre et ne démontre pas
Cette recette examine les formulations retrouvées dans les copies publiques **indexées** et les confronte aux résultats mathématiques contrôlables. Elle **ne garantit pas** le contenu WordPress servi actuellement : selon l'URL, les copies renvoyées étaient explorées « hier », il y a quatre semaines, ou deux à trois mois. Un accès HTTP non mis en cache à WordPress et aux API `wp-json` n'a pas pu être établi dans cet environnement ; ce n'est **pas** un diagnostic de panne du serveur. **Sans capture du contenu actuel par Frédéric ou accès CMS autorisé, aucun point ne reçoit le statut « correction appliquée en production et vérifiée ».**

Statuts : **OBSERVÉ INDEXÉ**, **CORRIGÉ DANS UNE COPIE INDEXÉE**, **CORRIGÉ GITHUB**, **NON VÉRIFIABLE EN PRODUCTION**, **À VALIDER SCIENTIFIQUEMENT**. On conserve les états séparés : existence de l'erreur historique ≠ présence actuelle ; preuve mathématique ≠ constat de production ; correction du brouillon ≠ déploiement.

## Matrice de recette prioritaire

| Niveau | URL / zone | Élément retrouvé ou obstacle | État | Consigne conditionnelle à Frédéric |
|---|---|---|---|---|
| P0 | https://www.couretunification.fr/contact/ | Copie indexée il y a 4 semaines : « un unique point ouvert comme équivalent à l'hypothèse de Riemann » ; une copie plus ancienne ne reproduit pas ce bloc. | **OBSERVÉ INDEXÉ**, production actuelle inconnue. | Chercher cette phrase dans le contenu et les blocs WordPress réutilisés, surtout pied de page ; si présente, remplacer par **Bloc RH** ci-dessous. Archiver capture et texte avant/après. |
| P0 | https://www.couretunification.fr/ | Copie récupérée plus ancienne : « ‖M‖HS ≤ … ⟹ auto-adjonction unique » et « KLMN … ferme H1 ». Une copie indexée hier montre déjà le positionnement actuel et l'erratum F-001. | **COPIES D'ÂGES DIFFÉRENTS** ; H1 à contrôler sur la page active, F-001 visible dans un index récent. | Conserver identité et erratum F-001. Vérifier les blocs H1, y compris la version mobile et les morceaux chargés par le thème ; appliquer **Bloc H1** seulement si la phrase subsiste. |
| P0 | https://www.couretunification.fr/recherches/ | Copie indexée il y a 4 semaines : titre « H1 — l’auto-adjonction, fermée par une borne » marqué [D]/[P], tandis que « Borne KLMN » est [C]/[O]. | **INCOHÉRENCE DOCUMENTAIRE INDEXÉE**. | Remplacer le titre H1 par « H1 — portée et hypothèses d'auto-adjonction à vérifier », statut [O] ou [C] sur la seule conclusion concernée en attente de preuve spécifique ; conserver les résultats finis vérifiables. |
| P0 | https://www.couretunification.fr/registre-f0/ | Copie indexée le mois précédent : « Borne KLMN — H1 fermée » accompagnée de « claim > support » et manque de preuve publique. | **JUSTIFICATION PUBLIQUE MANQUANTE SIGNALÉE DANS LA SOURCE**. | Rendre cohérentes la conclusion scientifique affichée, sa pièce de preuve, l'appel à relecture et les réserves. Ne pas transformer [D] en certification par simple existence de l'item. |
| P0 | https://www.couretunification.fr/resultats-minimaux/ | La récupération de la page a échoué (cache miss), pas de contenu actuel fiable. Des captures indexées signalées dans le plan antérieur sont à contrôler sur WordPress. | **NON VÉRIFIABLE**. | Contrôler URL réelle, redirection et éventuelles occurrences RH / H1 ; ne pas déclarer « 404 » sans réponse HTTP enregistrée. |
| P0 | https://www.couretunification.fr/le-senseur/ | Copie indexée il y a 4 semaines : F-01, F-05 et **F-08 sont déjà exposés comme corrections** ; F-08 concerne la non-unicité spectrale du triplet. | **CORRIGÉ DANS COPIE INDEXÉE**. | Ne pas réécrire ni perdre ces errata ; contrôler et si nécessaire contextualiser la remarque F-04 sur HS/KLMN. Ne pas confondre F-08, F-008 dans GitHub et l'abus général de Parseval. |
| P0 | https://www.couretunification.fr/ ; https://www.couretunification.fr/le-senseur/ | F-001 : registre public GitHub corrigé ; l'accueil indexé hier affiche aussi 0,3749982 et rejette 0,378. | **CORRIGÉ GITHUB + COPIE INDEXÉE** ; exhaustivité WordPress inconnue. | Rechercher les versions anciennes de 0,378 sur toutes pages et menus ; conserver les archives datées avec bandeau d'erratum, sans réécriture rétroactive. |
| P1 | https://www.couretunification.fr/publications-et-depots/ | Impossible de récupérer la page via la consultation publique ; ni disponibilité, ni contenu, ni liens DOI ne sont établis. | **NON VÉRIFIABLE**. | Vérifier depuis navigateur connecté ou anonyme, code HTTP, canonique et liens DOI ; aucun jugement sur la disponibilité avant preuve. |
| P1 | https://www.couretunification.fr/contact/ | Une copie indexée parle encore de « dépôt en cours » pour des résultats déjà archivés et emploie des statuts de code Lean à dater. | **POSSIBLE DÉCALAGE HISTORIQUE**, pas un défaut actuel établi. | Rattacher chaque DOI et chaque état de Lean à une version/date vérifiée ; ne pas promettre que toutes les preuves compilent ou que tous les résultats sont nouveaux. |
| P1 | https://www.couretunification.fr/ | Copies indexées mentionnent un état scientifique daté du 21 août 2026 et des comptes variables de `sorry` dans les couches actives. | **RISQUE DE VERSIONNAGE**. | Afficher branche + commit + date pour chaque état, ou une qualification sans nombre si la vérification manque. |
| P0 technique | Ensemble du WordPress public | Aucun avertissement PHP identifié par une réponse HTTP actuelle ni par les journaux ; ceux-ci ne sont pas accessibles dans cet audit. | **NON VÉRIFIABLE**. | Contrôle navigateur privé, HTML brut, mobile, PHP logs autorisés et `WP_DEBUG_DISPLAY` ; corriger la cause, pas seulement masquer un message. |

## Blocs éditoriaux exacts — prêts pour prévisualisation (ne PAS publier sans GO)

### Bloc RH — suppression de l'équivalence non certifiée
> Notre programme étudie des objets mathématiques finis et examine des questions reliées à l'hypothèse de Riemann. Aucun résultat présenté ici ne constitue une démonstration de cette hypothèse ni n'établit une équivalence nouvelle avec elle. Les implications étudiées sont décrites avec leurs hypothèses, leurs preuves disponibles et leurs limites.

**Règle scientifique :** une revendication d'équivalence P ⇔ RH exige les deux démonstrations `P ⇒ RH` et `RH ⇒ P`, dans le même cadre. Les critères classiques déjà connus doivent être identifiés comme antériorités, jamais attribués au programme.

### Bloc H1 — éviter le raccourci Hilbert–Schmidt / auto-adjonction
> La propriété Hilbert–Schmidt implique la bornitude de l'opérateur concerné, mais ne suffit pas à démontrer son auto-adjonction. Pour invoquer le théorème KLMN, il faut vérifier une forme quadratique de base dense, fermée et semi-bornée, ainsi qu'une perturbation de forme symétrique de borne relative strictement inférieure à 1. Aucune conclusion d'auto-adjonction de H1 n'est acquise ici sans la vérification explicite de ces hypothèses et des domaines concernés.

**Vigilance :** le théorème de perturbation bornée symétrique d'un opérateur déjà auto-adjoint est une autre voie, à présenter séparément si elle est utilisée. Une seule borne HS numérique n'apporte pas la symétrie ni les hypothèses de domaine.

### Bloc Parseval — séparé de F-08
> Pour le groupe abélien fini U(30), et avec la transformée de Fourier non normalisée, Parseval donne, pour tout support S de trois éléments, la somme des carrés des modules des coefficients égale à 8 × 3 = 24. Cette identité ne détermine pas le spectre individuel d'une convolution. Deux supports de même cardinal peuvent avoir des spectres différents malgré une énergie totale identique.

**Contre-exemple exact :** S={1,11,29}, spectre (3×2,1×4,−1×2) ; T={7,11,13}, spectre (3×1,1×3,−1×3,−3×1) ; les deux ont somme des carrés 24. Le script de contrôle est `verify_site_cayley_g30.py` dans ce dossier GitHub.

### Bloc Cayley — convention non négociable
> Le graphe de Cayley sur U(30) correspondant à S={1,11,29}, avec la convention A[a,b]=1 si a·b⁻¹ appartient à S, comporte huit sommets et deux composantes connexes de quatre sommets. Comme 1 appartient à S, la matrice comprend huit boucles et huit arêtes non bouclées. La matrice normalisée A/3 ne définit pas de mélange global vers une unique loi indépendante de l'état initial ; la convergence doit se lire à l'intérieur des composantes.

L'utilisation du qualificatif « Ramanujan » n'est autorisée qu'avec une définition mathématique adaptée explicitement au cas déconnecté, sans suggérer une expansion globale.

### Bloc F-001 — conserver, pas « recouvrir »
> Erratum F-001 (9 octobre 2026). Parmi les 50 847 534 nombres premiers au plus égaux à 10⁹, 19 067 732 appartiennent aux classes 1, 11 ou 29 modulo 30, soit environ 0,374998166. L'ancienne valeur 0,378 était erronée. La proportion asymptotique 3/8 est un résultat classique du théorème des nombres premiers dans les progressions arithmétiques.

Ces effectifs sont ceux documentés dans le registre public et son programme C++17 ; cet audit ne certifie pas un rejeu indépendant du crible à 10⁹.

### Bloc F-08 — déjà corrigé dans la version indexée
> L'ancienne présentation du triplet {1,11,29} comme spectralement unique a été retirée : au moins cinq supports explicites de U(30) sont isospectraux. Cette observation n'est pas une conséquence de Parseval à elle seule. Les contre-exemples et la correction historique sont conservés dans Le (S)enseur.

## Sources mathématiques et documentaires à garder derrière les formulations
- KLMN (formes fermées, symétriques, borne de forme < 1) : Gerald Teschl, *Mathematical Methods in Quantum Mechanics*, théorème 6.24, et Reed–Simon, *Methods of Modern Mathematical Physics*, II, théorème X.17. https://www.mat.univie.ac.at/~gerald/ftp/book-schroe/schroe.pdf
- Parseval et Fourier des groupes abéliens finis : toute présentation universitaire de la transformée de Fourier et de l'orthogonalité des caractères ; **avec normalisation explicitée**. Ici on donne en plus un contrôle entier indépendant plutôt qu'une extrapolation.
- Convergence des chaînes de Markov finies irréductibles et apériodiques : Levin–Peres–Wilmer, *Markov Chains and Mixing Times*, chapitre sur les classes de communication et la convergence ; exposé de synthèse https://direct.mit.edu/neco/article/35/11/1713/117578/A-Tutorial-on-the-Spectral-Theory-of-Markov-Chains
- Premiers en progressions : théorème des nombres premiers dans les progressions arithmétiques ; exemple de formalisation et corollaires https://alexkontorovich.github.io/PrimeNumberTheoremAnd/blueprint/corollaries-chapter.html
- F-001, chiffres exacts et commande de recompte : https://github.com/alexcour/couret-finite-verifications/blob/main/PUBLIC_FALSIFICATIONS.md
- Périmètre Cayley 10A6 / 10C3 / 10B1, antériorité non auditée : https://github.com/alexcour/cayley-prime-translation-cospectrality/blob/main/CLAIM_BOUNDARY.md
- Expérience algébrique exacte dans la PR #9 : `review/site-couret-2026-10-11/verify_site_cayley_g30.py`.

## Protocole de vérification de production pour Frédéric
1. Accéder à chacune des URL en navigation privée, sans identifiant administrateur ; relever **date et heure en Europe/Paris**, navigateur, statut HTTP, adresse après redirection, titre, canonique, contenu visible et source HTML. Faire une capture de l'ancien contenu avant toute correction.
2. Identifier si la phrase à corriger vient d'une page, d'un modèle de thème, d'un widget, d'un pied de page ou d'un cache. Conserver une référence exacte de cette zone WordPress.
3. Travailler uniquement en **brouillon/prévisualisation**, sans action « Publier », « Mettre à jour » sur une page active, ni écrasement des archives. Appliquer seulement les blocs correspondant à une occurrence effectivement constatée.
4. Vérifier manuellement les expressions mathématiques, la symétrie/convention de boucles, les DOI, le lien code/commit, la provenance, les anciens statuts [D]/[P] et la navigation mobile/clavier.
5. Faire relire les affirmations par un mathématicien compétent, et vérifier séparément que le texte ne divulgue ni matière protégée ni corpus privé. La signature scientifique et l'autorisation de publication appartiennent à l'auteur et aux conseils pertinents, non au webmestre.
6. **GO distinct et explicite**, page par page, après validation. Puis seulement publier et revérifier URL publique et cache CDN, sans supposer qu'un écran WordPress « mis à jour » constitue une preuve de production.

### Registre de preuve à remplir pour chaque page (non renseigné en l'absence d'accès CMS)
| URL | Date/heure (Paris) | HTTP/redirection | Extrait actuel exact | Source WP (page / modèle) | Capture avant | Texte proposé | Révision scientifique | Autorisation | Capture après |
|---|---|---|---|---|---|---|---|---|---|
| Accueil | À renseigner | À renseigner | À renseigner | À renseigner | À fournir | Bloc H1 si présent | En attente | NON | Non applicable |
| Contact | À renseigner | À renseigner | À renseigner | À renseigner | À fournir | Bloc RH si présent | En attente | NON | Non applicable |
| Recherches | À renseigner | À renseigner | À renseigner | À renseigner | À fournir | Bloc H1 si présent | En attente | NON | Non applicable |
| Registre F0 | À renseigner | À renseigner | À renseigner | À renseigner | À fournir | Bloc H1 si présent | En attente | NON | Non applicable |
| Le (S)enseur | À renseigner | À renseigner | À renseigner | À renseigner | À fournir | Conserver F-08 | En attente | NON | Non applicable |
| Publications et dépôts | À renseigner | À renseigner | À renseigner | À renseigner | À fournir | Vérifier liens | En attente | NON | Non applicable |

**Confidentialité et PI.** Le présent fichier ne reproduit aucun matériau technique FCI/CONT-P/TRUST-LIFE/COSTGATE, aucune archive OBS-SEQ et aucune donnée privée. Ne rien extraire automatiquement des documents Drive réservés vers la branche GitHub ou WordPress. Respecter le document maître du 9 octobre et obtenir l'autorisation juridique écrite requise pour le périmètre brevet-sensible. Aucune date calendaire ne vaut permission automatique.

**ÉTAT FINAL : RECETTE DOCUMENTAIRE PRÊTE ; RECETTE DE PRODUCTION NON EFFECTUÉE ; VALIDATION ET DÉPLOIEMENT NON AUTORISÉS.**


---

## AVENANT DE RECETTE — 14 OCTOBRE 2026 (NON DÉPLOYÉ)

La proposition de page [RECHERCHE_ACTUELLE_DRAFT.md](RECHERCHE_ACTUELLE_DRAFT.md) remplace la hiérarchie de six recherches contemporaines du 11 octobre par **deux branches CURRENT : STROBO et Cayley**. Ce changement ne modifie pas les constats historiques de cette recette et n'atteste pas la présence des anciennes formulations sur le site publié.

**Points à contrôler sur les URL réelles et captures horodatées avant tout GO :**
- La page « Recherche » et les blocs d'accueil placent STROBO puis Cayley comme deux entrées principales. Les intitulés « HOL », « CU-BRUIT », « vérifications finies », « journal humain–IA » relèvent d'une section historique/exploratoire/méthodologique séparée, sans suppression d'archives ni lien cassé.
- STROBO : R_S compte les paires **ordonnées**, avec diagonales et multiplicités ; six modules compilés au **commit 310fcaf3** de PR #25 et non cinq comme dans le statut antérieur ; distinguer la condition h≥4 pour la formule numérique des fibres complètes sans zéro des problèmes d'histogramme ordinaire encore ouverts.
- Cayley : ne pas confondre spectre, égalité des carrés des matrices, non-isomorphisme et graphes simples/orientés ; recouvrements connus, état **PUBLIC REVIEW 0.1.x** et antériorité **NON AUDITÉE**.
- Lien de cohérence externe : [PR #34](https://github.com/alexcour/couret-finite-verifications/pull/34), toujours DRAFT ; les deux PR sont complémentaires, ni fusionnées ni déployées.
- Réviser l'anglais, les notations et statuts E/N/Q/D, comparer le contenu WordPress effectivement servi au texte draft, puis préserver un état avant/après avec URL, date, éditeur, validation mathématique et accord juridique/éditorial.

**Aucune correction en production certifiée. Aucun GO.** Le guide de protection du 9 octobre demeure obligatoire ; ne jamais intégrer des fichiers privés Drive ou des matériaux brevet-sensibles dans les pages ou dépôts publics. 
