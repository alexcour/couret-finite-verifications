# Transfert d'application WordPress — lot P0 (7 points)

**PR #43 : BROUILLON — paquet préparé, pas publié.** Ce document est un lot d'application manuelle ou avec un connecteur CMS authentifié. Il ne modifie aucune page WordPress et n'accorde aucune autorisation nouvelle de publication de données privées ou de résultats scientifiques.

**Sources publiques exclusivement :** corrections éditoriales approuvées et fusionnées [PR #9](https://github.com/alexcour/couret-finite-verifications/pull/9), section `SITE_CORRECTIONS_APPROVED_2026-10-14.md` (source des textes ci-dessous), présentation bilingue [PR #34](https://github.com/alexcour/couret-finite-verifications/pull/34), audit public en lecture seule [PR #43](https://github.com/alexcour/couret-finite-verifications/pull/43). Reçu de base : [workflow #38733374530](https://github.com/alexcour/couret-finite-verifications/actions/runs/38733374530), artefact `11970513363`, 15 octobre 2026 entre 12 h 16 et 12 h 17 UTC, **16 entrées HTTP 200 pour 15 URL distinctes**. Les courts extraits sont des constats à date, pas une preuve que les pages sont encore identiques après cette heure.

## Règles avant toute intervention

1. Sauvegarder une révision WordPress de chaque page; noter l'URL canonique, le type de contenu, la langue et l’heure. Éditer les blocs ciblés sans remplacer le gabarit entier.
2. Pour chaque lot : proposer les remplacements ci-dessous à la prévisualisation, vérifier les liens et la compatibilité desktop/mobile, puis obtenir l'accord de publication CMS applicable. Ne pas lancer de script d'écriture non authentifié et ne pas toucher aux annexes privées.
3. Après publication par un opérateur habilité, contrôler HTTP, titre, SEO et rendu; conserver capture avant/après et horodatage, puis classer `appliqué et vérifié` uniquement si les affirmations corrigées ne subsistent plus en tant que revendications actives.
4. Garder la séparation : GitHub fusionné ≠ WordPress publié ≠ preuve mathématique ≠ priorité. Les PR scientifiques #25/#30 et leurs successeurs conservent leurs statuts indépendants; ne pas recopier les compteurs Lean figés d'un ancien reçu comme état CURRENT.

## Carte des interventions — P0

| ID | URL exacte | Constat HTTP 15/10 | Action WordPress ciblée |
|---|---|---|---|
| C02 | https://www.couretunification.fr/ | « Nous présentons un unique point ouvert comme équivalent à l'hypothèse de Riemann » (affirmation courante). | Remplacer l'appel actif aux contradicteurs, supprimer la qualification d’équivalence RH non démontrée, décrire séparément les deux problèmes. Réviser les compteurs Lean génériques sans commit; conserver les archives datées. |
| C03 | https://www.couretunification.fr/resultats-minimaux/ | Même phrase d’équivalence RH ; « sa preuve machine est encore un échafaudage non compilé » sans artefact identifié. | Même remplacement RH ; séparer G30 de STROBO et rattacher chaque preuve à sa version exact. Ne pas annoncer une formalisation intégrale. |
| C04 | https://www.couretunification.fr/publications/h1/ | Titre « H1 — l’auto-adjonction, fermée par une borne » ; « cette seule inégalité, par le critère KLMN, rend l’opérateur auto-adjoint ». | Changer titre, résumé, badges, description SEO et conclusion ; présenter H1 comme conditionnel en attente du contrôle complet des formes/domaines. Ne jamais substituer une preuve Lean non vérifiée. |
| C05 | https://www.couretunification.fr/registre-f0/ | Tableau : « Borne KLMN — H1 fermée » accompagné du marqueur [D]. | Conserver le tableau d’origine comme instantané daté, ajouter immédiatement au-dessus un rectificatif H1 en cours de justification et lien Recherche actuelle. Ne pas réécrire rétroactivement les états historiques. |
| C08 | https://www.couretunification.fr/publications/cayg-tc-ramanujan-finie/ | « 8 sommets et 12 arêtes », « expanseur quasi-optimal », « diffusion ... exceptionnellement rapides » et deux composantes. | Supprimer les conclusions de mélange global et la qualification globale d’expanseur non justifiée, distinguer huit boucles + huit arêtes non bouclées, préciser la convention d’adjacence. Préserver les calculs spectraux bornés. |
| C09 | https://www.couretunification.fr/publications/triplet-canonique-t_c-1-11-29/ | « puisque le spectre entier est fixé par le cardinal », malgré l’erratum F-08 des cinq témoins. | Corriger l'inférence cardinal/énergie -> spectre, conserver les cinq témoins isospectraux et l’erratum daté F-08 (ne pas confondre avec F-008). |
| C10 | https://www.couretunification.fr/le-senseur/ | Dans F-04 : « Remplacé par ‖M‖_HS ≤ P(3/2)=0,8495<1 ; auto-adjonction via KLMN sur M. » | AJOUTER une note de rectification datée attachée à F-04 (pas F-05) : la borne ne ferme pas H1 et KLMN nécessite des hypothèses de formes/domaine. Ne pas supprimer ni écraser les entrées F-01, F-04, F-05 ou F-08. |

## Textes publics approuvés à appliquer (reprise exacte du paquet GitHub fusionné)

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


## Rectificatifs contextuels sans effacement des archives

**C05 — Registre F0 :**

> Rectification éditoriale du 15 octobre 2026 — L'entrée historique « Borne KLMN — H1 fermée » est conservée comme état antérieur, mais **ne constitue pas une conclusion actuellement établie**. La seule estimation Hilbert–Schmidt affichée ne démontre pas l'auto-adjonction de H1 ; la vérification de la forme de base, de la perturbation, de leur symétrie et des domaines reste nécessaire. Voir la page Recherche actuelle et la fiche H1 corrigée.

**C10 — Le (S)enseur :**

> Rectification éditoriale du 15 octobre 2026, associée à l'archive **F-04** — Le remplacement de l'ancien test de Schur par la borne Hilbert–Schmidt ne suffit pas, à lui seul, à démontrer l'auto-adjonction. Toute application de KLMN exige ses hypothèses de forme et de domaine, qui restent à contrôler. Le texte initial est conservé comme trace historique. L'entrée **F-05** concerne une correction distincte relative à Parseval/φ ; elle ne doit pas être remaniée au titre de H1.

**Propagation connexe P1 :** les cartes H1 de /recherches/ (C06) et /tableau-de-bord/ (C07) affichent encore le titre « fermée par une borne » et des badges [D]/[P]. Corriger simultanément leurs extraits actuels, ou ajouter un bandeau de rectification provisoire; sans cela le site reste contradictoire même si C04 et C05 sont corrigés. Ne pas modifier d'autres résultats à cause d'un statut H1.

**Errata déjà exacts à préserver :** F-001 (/publications-et-depots/) mentionne explicitement l'ancien chiffre 0,378 pour le démentir : ne pas supprimer cette trace. F-08 conserve au moins cinq témoins isospectraux; ne pas supprimer ces témoins. Le nom Couret–Unification peut rester comme provenance historique.

## Critères de validation et dépendance externe

| Lot | Pages | Condition pour « corrigé en production » | État de ce document |
|---|---|---|---|
| RH | C02, C03 | Plus de revendication active d'équivalence RH ; appel à relecture STROBO/Cayley présent | Préparé, **non publié** |
| H1 / KLMN | C04, C05, C10 + C06/C07 | Formes/domaines explicités comme ouverts ; badges H1 cohérents ; F-04 archivé et rectifié | Préparé, **non publié** |
| Cayley / F-08 | C08, C09 | Pas de mélange global/déduction cardinal→spectre, cinq témoins et convention du graphe conservés | Préparé, **non publié** |

**Bloquant pratique :** l'édition WordPress nécessite une connexion CMS authentifiée (non disponible dans les outils connectés de cette conversation). Aucun POST/PATCH vers WordPress, e-mail, fusion de PR ou changement de permissions n'est réalisé par ce lot. Faire la recette HTTP de contrôle après chaque application et archiver son artefact dans [Linear COU-12](https://linear.app/couret/issue/COU-12/harmoniser-le-portail-strobo-cayley-et-la-pr-editoriale-34).
