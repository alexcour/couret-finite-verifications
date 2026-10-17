# Reconciliation du site public — audit différentiel du 17 octobre 2026

**Statut : constat documentaire en lecture seule / HOLD CMS / PR #43 DRAFT.** Cette note n'autorise ni mise en ligne WordPress, ni promotion scientifique, ni fusion de la PR. Elle résume des observations du texte public relevé le 17 octobre 2026 au matin (Europe/Paris) et les compare au lot éditorial P0 du 15 octobre. **Une lecture relayée n'est ni un reçu du workflow WordPress, ni une inspection des révisions du CMS.** Le reçu reproductible de référence reste celui du 15/10 : workflow [#38733374530](https://github.com/alexcour/couret-finite-verifications/actions/runs/38733374530), artefact `11970513363`.

## Matrice des corrections

| ID | Objet | Texte public observé le 17/10 | Qualification |
| --- | --- | --- | --- |
| C02 | Accueil : prétention d'équivalence RH | Phrase active non retrouvée ; formulation de non-revendication RH visible | **Semble corrigé** ; confirmer par nouveau reçu HTML/SEO |
| C03 | Résultats minimaux : même prétention RH | Phrase active non retrouvée, malgré métadonnées d'août | **Semble corrigé** ; confirmer bloc partagé, HTML/SEO et cache |
| C04 | Fiche H1 | Titre « auto-adjonction, fermée par une borne », badges D/P et implication KLMN toujours visibles | **Non conforme** |
| C05 | Registre F0 | Tableau historique « H1 fermée » sans rectificatif daté au-dessus | **Non conforme** |
| C06 | Carte H1 dans Recherches | Carte « fermée par une borne » et badges D/P subsistent | **Non conforme** ; contrôler la grille Portfolio dynamique |
| C07 | Carte H1 dans Tableau de bord | Carte « fermée » et badges D/P subsistent | **Non conforme** ; le simple changement de titre est insuffisant |
| C08 | Fiche Cayley G30 | « expanseur quasi-optimal » et mélange global subsistent malgré deux composantes | **Non conforme** |
| C09 | F-08 : Parseval et spectre | Page non relue le 17/10 (limite de lecture) ; anomalie constatée au reçu du 15/10 | **Inconnu au 17/10**, à revérifier |
| C10 | Le (S)enseur : rectification KLMN en F-04 | Page non relue le 17/10 ; anomalie constatée au reçu du 15/10 | **Inconnu au 17/10**, à revérifier |

**Ne pas simplifier en « 5 corrections non appliquées certifiées le 17/10 ».** Trois P0 demeurent positivement non conformes (C04, C05, C08), deux sont indéterminés aujourd'hui (C09, C10), deux semblent corrigés (C02, C03) ; C06 et C07 sont deux propagations H1 non conformes. La recette exacte fait foi pour tout GO.

## Contradictions de navigation hors lot P0

1. **Routage vers RH / P8 :** `/carte/` et `/les-mathematiques-du-programme/` conservent un horizon RH/P8 alors que `/recherche-actuelle/` sépare STROBO et Cayley et récuse une route RH actuelle. Ajouter une bannière d'archive et renvoyer vers l'[erratum T1′–T4 du 13/10](https://github.com/alexcour/couret-finite-verifications/blob/main/research/rh-t1t4/ERRATUM_RH_T1T4_2026-10-13.md) **après vérification du chemin exact** ; ne pas supprimer l'histoire.
2. **Porte « Vérifier » :** les compteurs historiques `0 sorry`, `11 sorry` et `14 théorèmes` ne constituent pas une preuve publique actuelle tant que leur dépôt source privé n'est pas nommé/contextualisé. Orienter `/verification/` vers les artefacts publics rejouables de [couret-finite-verifications](https://github.com/alexcour/couret-finite-verifications), avec SHA exact et commande de replay. Éviter d'inventer des compteurs à jour.
3. **STROBO :** la fiche `/recherche-actuelle/` est prudente mais chronologiquement en retard. Les certificats de la [PR #25](https://github.com/alexcour/couret-finite-verifications/pull/25) doivent être repris seulement dans leurs périmètres explicites de compilation, avec séparation humain/antériorité. Ne pas convertir un succès Lean en validation externe ou nouveauté.
4. **Archives T1′–T4 :** une archive publique encore intitulée « Proof-Article » dans le dépôt historique accessible depuis le site doit être étiquetée clairement **RETRACTED AS PROOF / ARCHIVE HISTORIQUE — ARGUMENT INVALIDÉ**, en préservant le document et en reliant l'erratum, sous les droits du propriétaire du dépôt concerné.
5. **Hygiène éditoriale :** uniformiser « 10 dépôts / 13 DOI, dont 3 DOI de concept » ; corriger le compteur 77/70 du tableau de bord ; rapprocher `/verifier/` et `/verification/` ; rectifier l'affirmation trop générale « sans native_decide » ; distinguer les archives d'août de l'état courant d'octobre ; reporter F-001 dans la Galerie des dépromotions.
6. **Fonds Bernard Couret :** maintenir la traçabilité des 177 scans, et distinguer la pièce historique prouvée de toute reconstruction mathématique contemporaine.

## Portes de recette et responsabilités

- **Avant application :** comparer les 9 contenus P0 aux textes approuvés du [lot P0](./WORDPRESS_P0_CMS_HANDOFF_2026-10-15.md) ; retrouver sources internes, révisions et sauvegardes, y compris les trois fiches Portfolio ; obtenir URL de prévisualisation et capture avant/après desktop/mobile ; contrôler les attributs et badges H1 (notamment C07), les SEO et caches.
- **Après corrections proposées, mais avant publication :** validation éditoriale explicite page par page. **HOLD tant qu'elle manque**. Préserver F-01, F-04, F-05, F-08 et F-001 ; ne pas modifier l'histoire sous couvert de correction.
- **Après publication autorisée :** lancer `WordPress 16 URL audit` de la PR #43 ; archiver son JSON horodaté, les empreintes et métadonnées ; comparer aux critères C01–C16 ; vérifier le contenu et le rendu, pas uniquement HTTP 200. Consigner le résultat dans [COU-12](https://linear.app/couret/issue/COU-12/harmoniser-le-portail-strobo-cayley-et-la-pr-editoriale-34).
- **Limites du relevé du 17/10 :** C09/C10 n'ont pas été lus, C12 sans corps, registre/journal/direction de recherche sans texte ; aucun audit visuel, mobile, SEO exhaustif ou liens morts. Les résultats ne sont pas transférables à une date ultérieure.

**Source du constat :** « Audit du site couretunification.fr — 17/10/2026 », relevé du 17 octobre 07:30–08:30 Paris, rapproché des pièces publiques de la PR #43 et de la recette du 15 octobre. Le présent fichier est une synthèse opérationnelle et non un nouveau résultat scientifique.
