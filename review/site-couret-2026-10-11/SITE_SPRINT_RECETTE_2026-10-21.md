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
