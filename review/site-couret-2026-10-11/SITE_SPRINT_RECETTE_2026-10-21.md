# Site Couret–Unification — lot de reprise et recette (21 octobre 2026)
 
**État : DOCUMENT DE TRAVAIL PRIVÉ / PR #43 DRAFT / AUCUNE PUBLICATION CMS.**
 
## Sources et borne de connaissance
- Audit externe « Audit du site couretunification.fr et des dépôts GitHub — 20 octobre 2026.docx » (environ 75 pages explorées, 19 familles de vérifications ; observation datée, sans accès WordPress).
- Dernière inspection du contenu public véritablement observée par navigateur et décrite dans [COU-12](https://linear.app/couret/issue/COU-12/harmoniser-le-portail-strobo-cayley-et-la-pr-editoriale-34) : 20/10/2026, 21:56–21:58 heure de Paris ; 16 points / 15 URL distinctes, **pas de reçu HTTP ni de capture mobile**.
- Paquets sources de corrections [P0](WORDPRESS_P0_CMS_HANDOFF_2026-10-15.md) et [P1/P2](WORDPRESS_P1_P2_CMS_HANDOFF_2026-10-15.md) déjà préparés : **ne pas les dupliquer**.
- Reçus publics datés antérieurs : [workflow #39009617951](https://github.com/alexcour/couret-finite-verifications/actions/runs/39009617951), 16/16 HTTP 200, 17/10 ; **pas une preuve de production actuelle**.
- Nouvelle lecture HTTP directe du 21/10 non obtenue dans l'environnement de coordination (DNS). Les moteurs web peuvent renvoyer d'anciennes copies : aucune absence ou présence contemporaine certifiée par ces seules copies.

## Lot A — corrections P0 sur WordPress, sans écrasement de la V3 du 19/10
| Intervention | Dernier constat documenté | Action en brouillon / critère |
|---|---|---|
| C02 accueil | Refonte du 19/10 déjà visible le 20/10 : ancienne phrase RH retirée | **Ne pas réinjecter** l'ancien modèle d'accueil ; contrôle SEO, liens, versions et preuves seulement |
| C03 Résultats minimaux | Ancienne équivalence RH et « échafaudage non compilé » | Retirer la revendication RH active, attribuer l'échafaudage à son objet précis ; rattacher les pièces exactes |
| C04 H1 Portfolio (ID 2311) | « fermée par une borne » et KLMN conclusif, badges D/P | Prévisualiser texte P0 sur forme, domaines et conditionnalité ; harmoniser titre, SEO, badges et conclusions |
| C05 Registre F0 | « H1 fermée » [D] avec claim>support | Conserver le tableau historique et afficher une note de rectification datée avant le tableau |
| C06 Recherches (ID 1774) | Carte dynamique Salient `nectar_post_grid` dépend de C04 | Vérifier propagation de titre/extrait/badges et statut après correction du Portfolio C04 |
| C07 Tableau de bord (ID 2061) | Correction locale déclarée par Frédéric mais ancien statut observé publiquement le 20/10 | Demander diff/révision du brouillon ; recontrôler après cache, ne pas déclarer livré sans prévisualisation |
| C08 Cayley / G30 Portfolio | « expanseur quasi-optimal », mélange global, 8 sommets/12 arêtes | Conserver les deux composantes, expliciter convention boucles/arêtes ; retirer les conclusions globales non justifiées |
| C09 F-08 Portfolio | Cardinal/énergie présenté comme fixant le spectre | Remplacer cette inférence ; conserver les cinq témoins et la distinction Parseval énergie / spectre |
| C10 Le (S)enseur | F-04 historique « auto-adjonction via KLMN » | Ajouter rectification datée **à F-04**, conserver F-01/F-05/F-08 |

## Lot B — cohérence des trois couches éditoriales (19 mai / 21 août / 19 octobre)
1. **Une source CURRENT explicite et visible sur chaque ancienne page** : /recherche/ ou autre destination à confirmer dans le CMS après contrôle. Anciennes pages conservées et datées, sans suppression ni redirection massive automatique.
2. **Lean et compteurs** : ne pas hardcoder 18/11/0 comme total global ; qualifier Frozen/Active et épingler dépôt/commit exact au moment de publication. La visibilité publique du dépôt `couret-unification-lean4` nécessite **une décision de confidentialité/périmètre préalable**, pas une mise en lien automatique.
3. **λ et statuts** : clarifier les objets `λ_geo`, `λ_spec`, densité 3/8 et `1/sqrt(7)`. Conserver l'erratum F-001 et l'ancienne approximation 0,378 comme **valeur réfutée**, ne pas effacer l'histoire.
4. **G30** : distinguer selon le rapport du 20/10 classes spectrales, classes de puissance spectrale et orbites d'automorphismes (valeurs 10 / 2 / 15 dans leur périmètre exact) ; ne pas fusionner ces partitions.
5. **Journal F / chiffres du site** : une légende versionnée pour F-01..F-24, F-001.. et la galerie ; rapprocher 77/74/79 items et 96 claims avant publication de totaux. Clarifier `[D]`, `[F]`, `[O]` quand présents simultanément.
6. **Héritage scientifique** : les pages P8/ζ/voie K, classification, H1 et méthodes anciennes restent accessibles comme **états datés** et renvoient au CURRENT, pas présentées comme axes actifs incompatibles.

## Lot C — navigation / lisibilité / contenu visible
- Cartographier les concurrents : `/recherche/` vs `/recherches/` vs `/recherche-actuelle/`, `/verification/` vs `/verifier/`, `/carte/` vs `/carte-territoire/`, pages Bernard, Senseur, statut, philosophie, voie K. Choisir une entrée canonique par objet **après inspection des URL et des liens entrants** ; garder archives.
- Recenser les `href="#"`, faces Objet/Méthode de la membrane, BibTeX à URL erronée (7 cas signalés), liens RECOH vers branches `feat/`, `slug à confirmer` et sections vides. Prévisualiser corrections de navigation, pas de suppressions aveugles.
- Remplacer les contenus provisoires visibles (lorem ipsum sur une fiche Senseur, « aucun document correspondant », « Pbase en construction », compteurs zéro) par avis contextualisé ou masquage ciblé **après vérification de chaque bloc**, préserver la chronologie.
- Proposer une porte d'entrée « Lire en cinq minutes » / FAQ et un glossaire commun, sans supprimer art, philosophie ou fonds Bernard ; anglais actuel = résumés, ne pas annoncer de site /en/ complet.
- Tester menu double, responsive, contrastes, ALT des scans, accessibilité du formulaire de contact. Ces éléments demandent un vrai navigateur/mobile.

## Lot D — exposition, conformité et référencement
- **FCI/avocats/brevet** : page Senseur avec « Fail-Close Inhibition », scores et démo : mettre en quarantaine éditoriale avant tout ajout public ; ne pas exposer données techniques ou preuves d'application non validées, vérifier le vocabulaire et l'origine des métriques.
- **Mentions légales** : vérifier la dénomination complète SASU CONFIANCE, siège et hébergeur auprès de leur titulaire avant rédaction/promotion publique. Préparer page de mentions légales et confidentialité/contenu de formulaire selon données réellement traitées, sans inventer ces informations.
- **Archives Bernard Couret** : vérifier les droits/ayants droit et la provenance de conservation pour les 177 scans ; relever le scan 0014 déclaré manquant sans inventer son contenu. Ne pas retirer toutes les archives sans expertise.
- **DOI/BibTeX** : aligner version 1.1.0 / 1.1.1, DOI concept vs version, dates et sept URLs BibTeX signalées ; confirmer sur Zenodo/HAL avant correction.
- **SEO** : rechercher sitemap/robots et configuration Yoast en mode authentifié, description canonique et type OG ; contrôler données de Search Console si accès, pas de déclaration d'indexation sur la seule recherche web.

## Gates non négociables et recette
1. **CMS authentifié** et révision/source réelle de la page + sauvegarde avant + horodatage + ID ; ne jamais mettre de mot de passe/jeton dans GitHub/Linear.
2. **Édition uniquement en brouillon ciblé**, pas d'outil d'injection sur un ID publié ; diff bloc par bloc, conservation des errata.
3. **Prévisualisation bureau/mobile** ; vérifier titres, labels, badges, texte exact, lien de preuve/commit, dates, SEO et absence de contenu privé.
4. **GO éditorial distinct de l'auteur, explicite et borné aux URL** avant toute publication ; aucune autorisation présumée ici.
5. Après publication autorisée : HTTP réel, captures, cache, responsive, liens, registre avant/après et retour arrière ; passage en « corrigé en production » uniquement sur réception probante.
6. [COU-12](https://linear.app/couret/issue/COU-12/harmoniser-le-portail-strobo-cayley-et-la-pr-editoriale-34) reste **In Progress** et [PR #43](https://github.com/alexcour/couret-finite-verifications/pull/43) reste **DRAFT / NO MERGE**, sans promotion de résultats scientifiques ni transmission extérieure.


## Lot A1 — premier jeu d'éditions *à prévisualiser*, le 21 octobre (non déployé)

### Rétablissement de l'accès (compte éditeur)
- Le message du 20/10 de Frédéric confirme une entrée personnalisée et un compte éditeur, mais les tentatives du 20/10 ont été refusées (« mot de passe incorrect »). **Ne pas réutiliser le mot de passe transmis dans la correspondance et ne pas le placer dans un outil de suivi.**
- Réinitialiser le mot de passe **dans le formulaire authentique du site**, ou faire générer par Frédéric une invitation/lien de réinitialisation à usage limité. Confirmer le domaine et le certificat TLS, le nom du compte, le rôle éditeur, la possibilité de prévisualiser, et le canal de récupération. Ne pas transmettre le nouveau mot de passe par email.
- Vérifier l'accès aux révisions et aux types de contenu nécessaires ; si le rôle éditeur n'a pas accès aux fiches Portfolio, Frédéric/admin crée la copie brouillon, sans extension arbitraire des permissions. Aucun nouveau POST réseau lancé par la présente documentation.
- Des jetons et clés d'autres services ont aussi transité par des échanges techniques : examiner la rotation des secrets concernés dans leurs consoles d'origine et préférer un partage chiffré/gestionnaire de secrets. Ne jamais archiver leurs valeurs dans cette PR.

### C03 — `/resultats-minimaux/` : remplacement *localisé* de l'appel RH actif
**Ancre observée le 20/10** : « Nous présentons un unique point ouvert comme équivalent à l'hypothèse de Riemann ». Le texte « échafaudage non compilé » doit être relié à l'objet/version précis, et non à tous les résultats.

**Texte de remplacement approuvé (P0, sans ajout de revendications)** :

> **Relecture ciblée**  
> Les deux branches sont examinées séparément. Pour STROBO, la relecture porte sur l’énoncé exact, les hypothèses et la correspondance entre la preuve écrite et les théorèmes Lean compilés. Pour Cayley, elle porte sur les familles annoncées, les conventions d’adjacence, la cospectralité, l’isomorphisme et les antériorités. Aucune preuve de l’hypothèse de Riemann ni équivalence nouvelle avec elle n’est revendiquée.

**Autour du remplacement** : conserver les autres questions aux contradicteurs ; relever d'abord la source du bloc, identifier l'objet exact de l'« échafaudage non compilé » avec SHA/PR, ne pas le réattribuer en l'absence de preuve. Contrôler aussi les extraits SEO et blocs répétés sur cette page. Ne pas retirer l'ancienne phrase lorsqu'elle est citée comme **archive historiquement datée**.

**Critère de recette brouillon** : en vue privée, plus aucune équivalence RH **revendiquée au présent** ; l'objet de toute preuve non compilée est précisément qualifié ; lien actif vers Recherche actuelle ; pas de changement au contenu de l'accueil V3.

### C04 — `/publications/h1/` : Portfolio H1 (ID 2311)
**Ancres observées le 20/10** : titre « H1 — l'auto-adjonction, fermée par une borne » ; « cette seule inégalité, par le critère KLMN, rend l’opérateur auto-adjoint » ; badges D/P et conclusifs.

**Titre de remplacement approuvé** : **H1 — Estimation et hypothèses d’auto-adjonction**.

**Corps de remplacement approuvé** :

> Une borne Hilbert–Schmidt, lorsqu’elle est établie pour l’opérateur considéré, fournit une borne de norme. Elle ne suffit pas à elle seule à prouver son auto-adjonction. L’application de KLMN exige une forme de base densément définie, fermée, symétrique et semi-bornée, ainsi qu’une perturbation symétrique de borne relative de forme strictement inférieure à 1. La forme, les domaines et l’identification de l’opérateur associé doivent être explicités et contrôlés. La clôture de H1 n’est pas établie par la seule estimation numérique affichée.

**À modifier dans le même brouillon** : titre, accroche, extrait WP, badges, légende, conclusion actuelle, éventuel champ Yoast, liens/résumés automatiques. Garder calculs historiques et leur date dans une section distincte « Archive / portée révisée » ; ne pas transformer rétroactivement un registre historique. Propositions SEO, à soumettre à relecture : titre « H1 — Estimation et hypothèses d’auto-adjonction » ; description « Hypothèses de forme et de domaine requises pour H1. Une borne Hilbert–Schmidt ne suffit pas à prouver l’auto-adjonction. Statut ouvert. »

**Propagation obligatoire avant GO** :
- **C06 /recherches/** : grille Salient `nectar_post_grid` alimentée par ce Portfolio ; vérifier extrait, libellé, titre et badges dans la carte rendue.
- **C07 /tableau-de-bord/** : ne pas supposer la modification locale déclarée visible sur le site ; comparer révision du contenu ID 2061, extrait et cache.
- **C05 /registre-f0/** : ajouter le rectificatif daté **au-dessus** du tableau ancien, sans effacer ce dernier.
- **C10 /le-senseur/** : le passage KLMN est **F-04**, addendum daté ; F-05 est une entrée distincte.
  
**Critère de recette brouillon** : « H1 fermée », [D]/[P] et « démonstratif » ne subsistent pas comme état courant de H1 sur C04/C05/C06/C07 ; les archives conservent leur titre historique avec un rectificatif explicite, et l'application de KLMN n'est pas présentée comme acquise.

### Reçu à produire pour chaque brouillon (pas un reçu de production)
| Champ | Relevé attendu |
|---|---|
| Objet CMS | Type (Page/Portfolio), ID, URL, révision précédente et auteur |
| Source | Texte extrait avant, bloc WPBakery ou champ Portfolio concerné |
| Diff | Ancien extrait -> nouvel extrait ; raison et document approuvé |
| Visuel | Capture avant/après bureau + mobile, URL de prévisualisation privée |
| Cohérence | Contrôle des deux variantes FR/EN s'il y a lieu, badge, SEO, cache et liens |
| Décision | PREVIEW_OK / À_CORRIGER / BLOQUÉ, nom du validateur ; **jamais PUBLIÉ sans GO spécifique** |

**Aucune page n'a été modifiée dans WordPress par ce document.**
