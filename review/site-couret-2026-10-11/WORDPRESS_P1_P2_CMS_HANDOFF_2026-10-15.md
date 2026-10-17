# Couret — lot complémentaire WordPress C01, C06–C07 et C11–C16

**Préparation éditoriale du 15 octobre 2026 — PR #43 en brouillon. Aucun déploiement CMS.**

Ce document complète le [lot P0](WORDPRESS_P0_CMS_HANDOFF_2026-10-15.md), sans le remplacer. Il contient **7 points P1 et 2 points P2** ; la référence de jugement est le [paquet C01–C16 approuvé le 14 octobre](SITE_CORRECTIONS_APPROVED_2026-10-14.md), déjà fusionné via PR #9. Les propositions ci-dessous détaillent une prévisualisation de l'application, et ne constituent pas à elles seules un nouveau GO de publication.

**Constat de base :** [audit HTTP public #38733374530](https://github.com/alexcour/couret-finite-verifications/actions/runs/38733374530), artefact `wordpress-public-readonly-receipts` n°11970513363, créé le **15 octobre 2026 à 12:16:48 UTC** (14:16:48 Paris), expiration annoncée le 29 octobre. Toutes les entrées C01–C16 renvoient HTTP 200 lors de ce contrôle ; les neuf entrées traitées ici se rapportent à neuf URL distinctes. Le relevé contient des **contextes courts** et des marqueurs, pas les pages intégrales ni les champs CMS : une absence lexicale ne prouve pas une absence de contenu, et l'affichage des mots d'une ancienne thèse n'est pas nécessairement une revendication active.

## Relevé ciblé, intention et décision préalable

| ID / priorité | URL | Observation courte vérifiée | Nature de l'action |
|---|---|---|---|
| C01 / P1 | https://www.couretunification.fr/ | Titre renvoyé : « Couret Unification - Reliefs Arithmétiques » ; nouvelle dénomination de recherche déjà visible dans le corps | **Modifier le titre actif/SEO après localisation du champ CMS** ; conserver l'ancien nom en provenance |
| C06 / P1 | https://www.couretunification.fr/recherches/ | Carte : « H1 — l’auto-adjonction, fermée par une borne », statut [D]/[P] | **Corriger la carte active H1**, en cohérence avec C04 ; historiser l'ancien catalogue |
| C07 / P1 | https://www.couretunification.fr/tableau-de-bord/ | Ligne H1 encore annoncée comme « fermée par une borne » | **Corriger la ligne active H1**, en cohérence avec C04/C06 |
| C11 / P1 | https://www.couretunification.fr/carte/ | « Tout vise un même horizon — la fonction zêta de Riemann — jamais déclaré atteint » | **Archive légitime sous réserve de datation**, ajout du renvoi CURRENT ; ne pas censurer le propos historique |
| C12 / P1 | https://www.couretunification.fr/direction-de-recherche/ | Page explicitement datée d'août 2026 ; « recherche actuelle » retrouvé seulement dans un contexte de navigation générale | **Vérifier la destination du menu**, puis ajouter en tête un renvoi éditorial explicite si absent |
| C13 / P1 | https://www.couretunification.fr/les-mathematiques-du-programme/ | Ancien jugement « P8 ... la zone mathématique la plus prometteuse » ; Cayley mentionné | **Dater la qualification P8**, préserver ce travail et renvoyer au programme CURRENT |
| C14 / P1 | https://www.couretunification.fr/verification/ | Principes Lean exacts (commit, imports, axiomes) ; les marqueurs littéraux « PR #25 » et « Cayley » ne sont pas retrouvés | **Conformité précise indéterminée** : vérifier les liens visibles, compléter seulement les parcours manquants |
| C15 / P2 | https://www.couretunification.fr/publications-et-depots/ | Erratum F-001 et « ancienne valeur 0,378 erronée » correctement visibles ; la limite 3/8 est attribuée au « théorème de Dirichlet » | **Conserver F-001**, corriger uniquement l'attribution de la densité asymptotique |
| C16 / P2 | https://www.couretunification.fr/recherche-actuelle/ | Les branches STROBO et Cayley sont distinctes ; « Lev » et `R_S` non retrouvés par la sonde | **Cadrage déjà observé** ; inspecter le corps et compléter définition, antériorité et frontière de preuve seulement si nécessaire |

## Remplacements et additifs proposés pour prévisualisation

### C01 — Accueil : nom visible et SEO

Ne pas remplacer l'ensemble de la page ni ses archives historiques. Repérer séparément le champ <title> rendu, le titre SEO configuré, la métadescription et le titre de premier écran : le reçu HTTP ne dit pas dans quel composant chacun se trouve.

- **Titre courant proposé** : `Couret — Reconstruction additive et spectrale | Programme de recherche`
- **Métadescription proposée (texte du paquet approuvé)** : « Reconstruction additive de supports à trois éléments et ambiguïtés spectrales de graphes de Cayley. Preuves, calculs reproductibles, limites et relectures en cours. »
- **Premier écran** : conserver/mettre en avant le texte bilingue approuvé dans [le paquet de référence](SITE_CORRECTIONS_APPROVED_2026-10-14.md#accueil--français) ; n'afficher aucune priorité scientifique, validation externe ou certification Lean globale.
- **Historique** : « Couret–Unification » et « Reliefs arithmétiques » restent admissibles en provenance, archives datées, liens permanents et intitulés de collections.

### C06 et C07 — Catalogue Recherches et tableau de bord

Le titre actif « H1 — l'auto-adjonction, fermée par une borne » ne doit plus être affiché comme résultat clos ou démontré. S'il est nécessaire de garder une trace historique, ajouter un bandeau ou une note immédiatement adjacente.

**Titre actif proposé :** « H1 — estimation de norme et hypothèses d'auto-adjonction à vérifier ».

**Court extrait proposé :** « Une estimation Hilbert–Schmidt n'établit pas, à elle seule, l'auto-adjonction de H1. L'application de KLMN exige une forme de base et une perturbation satisfaisant des hypothèses de domaine, de symétrie, de fermeture, de semi-bornitude et de borne relative de forme. La justification complète reste ouverte. »

**Badges** : ne pas conserver [D] pour la conclusion d'auto-adjonction. Employer une catégorie « à vérifier »/« ouvert », selon la taxonomie réellement configurée ; ne pas modifier les statuts de résultats distincts. Aligner le même jour C04, C05 et le rectificatif F-04/C10 pour éviter des messages contradictoires.

**Phrase de tête du catalogue (proposition)** : « Ce catalogue décrit des recherches et résultats historiques datés. Le programme scientifique actuellement présenté au public distingue reconstruction additive STROBO et ambiguïtés spectrales Cayley. Les anciens statuts doivent être lus à la date des pièces citées. »

### C11, C12, C13 — Pages de provenance et d'histoire

**Additif commun à adapter** (n'en créer qu'un par page, au début ou dans un bandeau) :

> « Archive de recherche : cette page documente une étape antérieure du programme et conserve ses formulations dans leur contexte historique. Pour les problèmes actifs, les versions des preuves et les limites de diffusion, consulter [Recherche actuelle](https://www.couretunification.fr/recherche-actuelle/). Aucun résultat ici n'est présenté comme preuve de l'hypothèse de Riemann. »

- **C11** : conserver la phrase d'horizon RH suivie de « jamais déclaré atteint » : elle n'est pas, dans l'extrait contrôlé, une preuve de RH ; identifier simplement la date de cette étape.
- **C12** : conserver le manuscrit v0.15-C d'août 2026 et ses limites. Ne pas prendre la présence du mot « recherche actuelle » dans le menu pour une liaison éditoriale dans le corps. Aucun complément FCI/CONT, brevet ou information privée.
- **C13** : préciser « P8, piste jugée prometteuse à la date de cet audit historique, sans validation d'une preuve RH » ; ne pas rebaptiser P8 en STROBO ni effacer les avertissements publics déjà corrects.

### C14 — Vérifier : deux chemins de reproduction distincts

Ne pas masquer la méthode existante : elle indique déjà que Lean exige énoncé exact, imports, toolchain et axiomes, et qu'une CI verte n'est pas à elle seule une preuve globale.

**Additif proposé, sous réserve de vérification des liens et des versions :**

> « Pour reproduire les résultats actuels, choisir le périmètre avant d'interpréter un reçu CI. STROBO (reconstruction additive) : [PR scientifique #25](https://github.com/alexcour/couret-finite-verifications/pull/25), avec ses modules Lean effectivement compilés, leurs imports et le commit du journal consulté. Cayley (ambiguïtés spectrales) : [PR #30](https://github.com/alexcour/couret-finite-verifications/pull/30) pour les énoncés formalises dans cette PR et [dépôt de relecture spécialisé](https://github.com/alexcour/cayley-prime-translation-cospectrality) pour les revendications et antériorités séparées. Une même preuve écrite, un test borné, une CI et un avis mathématique indépendant sont quatre informations distinctes. Aucun certificat d'un commit ancien n'est attribué à un nouveau HEAD sans vérification. »

Avant mise en production, corriger dans ce seul additif toute graphie, tout état de PR ou lien qui aurait changé. **Ne pas figer dans cette page un nombre global de modules ni attribuer aux autres PR les reçus de PR #25.**

### C15 — Publications et dépôts : correction minimale de la source théorique

Le bloc erratum F-001 fournit déjà l'ancienne valeur (en la réfutant) et la valeur corrigée. **Ne supprimer ni F-001, ni 0,378 lorsqu'il est décrit comme erroné, ni les DOI historiques.**

**Avant, constaté dans l'extrait :** « La limite 3/8 est une propriété classique issue du théorème de Dirichlet et ne constitue pas un nouveau résultat. »

**Après, proposition chirurgicale :** « La limite 3/8 est une conséquence classique du théorème des nombres premiers dans les progressions arithmétiques et ne constitue pas un nouveau résultat. Le théorème de Dirichlet garantit l'infinité des nombres premiers dans chaque classe admissible, mais ne suffit pas à établir cette proportion asymptotique. »

Vérifier que le détail numérique est resté cohérent avec [F-001](https://github.com/alexcour/couret-finite-verifications/blob/main/PUBLIC_FALSIFICATIONS.md) et que les références mathématiques affichées correspondent à la formulation finale.

### C16 — Recherche actuelle : définition et attribution sans extrapolation

Le cadrage STROBO/Cayley existe déjà : ne pas le recréer en doublon. L'absence des chaînes `Lev` et `R_S` dans la sonde ne constitue pas une preuve qu'aucun passage équivalent n'existe sous une autre notation ou dans du contenu dynamique.

**Bloc à ajouter seulement si absent après inspection du contenu CMS (FR) :**

> « Pour un groupe abélien G et un support S de trois éléments, on définit R_S(g) = #{(s,t) ∈ S×S : s+t=g}. Les couples sont ordonnés et s=t est autorisé. STROBO étudie les paires S,T telles que R_S=R_T : c'est le cas à trois éléments du problème 2 de V. F. Lev (2004, DOI 10.37236/1831). Cette égalité de carrés de convolution étiquetés ne se confond ni avec une cospectralité d'adjacence ni avec un isomorphisme de graphes. La portée de la formalisation Lean est celle des énoncés et dépendances effectivement compilés sur le commit cité ; dénombrements complémentaires et antériorités exigent leurs audits propres. »

**Complément EN si la page bilingue comporte déjà une section parallèle :**

> « For an abelian group G and a three-element subset S, let R_S(g) = #{(s,t) ∈ S×S : s+t=g}; pairs are ordered and equal summands are allowed. STROBO investigates pairs S,T with R_S=R_T, the three-element case of V. F. Lev's Problem 2 (2004, DOI 10.37236/1831). Equality of labelled convolution squares is not the same observation as adjacency cospectrality or graph isomorphism. Lean proof claims apply only to the stated theorems and dependencies compiled at the specified commit; independent mathematical review and a full prior-art audit remain pending. »

Aucune revendication d'originalité, de preuve RH, de complétude Lean ni de transfert automatique de l'additif à la branche Cayley.

## Grille de recette en sortie

Pour **chaque point**, l'opérateur conserve :
1. URL demandée, URL finale, horodatage Paris et UTC, HTTP, titre, canonique, champ WP/page/modèle/theme/SEO effectivement édité, révision avant et après.
2. **Texte littéral avant**, bloc de prévisualisation, texte littéral après, captures bureau et mobile, contrôle clavier et contraste si la mise en page change.
3. Classement argumenté parmi `déjà conforme`, `corrigé et vérifié`, `archive correctement signalée`, `encore problématique` ou `indéterminé` ; pour C11–C13, dater explicitement les archives.
4. Relecture scientifique des assertions E/N/Q/D, contrôle des liens, de la navigation publique anonyme et des caches ; preuve HTTP seule ne valide pas le fond.
5. Validation éditoriale et **autorisation de publication CMS distincte** avant toute action « Publier » ou « Mettre à jour », suivie d'un **nouveau** contrôle de la page réellement servie. Ne jamais assimiler le contrôle du 15/10 à une recette après correction.

### Critères de clôture COU-12

- [ ] Les sept P0 de [la fiche prioritaire](WORDPRESS_P0_CMS_HANDOFF_2026-10-15.md) sont servis et vérifiés après changement, avec C06/C07 harmonisés.
- [ ] C01 et C06/C07 sont cohérents dans les titres, cartes et métadonnées réellement visibles.
- [ ] C11–C13 sont présentés explicitement comme archives datées, sans effacer les pièces historiques ni introduire de données brevet-sensibles.
- [ ] Les chemins C14 reproduisent les bons états de preuve/version ; C15 conserve F-001 et attribue correctement la limite 3/8 ; C16 est contrôlé avec citation Lev et définition de l'observation.
- [ ] Toutes les URL ont reçu une recette HTTP **et** visuelle après édition, avec traces de révision et autorisations.
- [ ] Le contrôle E/N/Q/D et la validation humaine indépendante ne sont pas déclarés acquis sans preuve.

**Statut à ce stade : PACK PRÊT POUR PRÉVISUALISATION ; CMS NON MODIFIÉ ; PR #43 NON FUSIONNÉE ; COU-12 OUVERT.**
