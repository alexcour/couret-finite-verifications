# SITE-SCIENCE-01 — Mandat Anti-Gravity / Codex

Date : 2026-11-13
Source : « Audit approfondi du site couretunification.fr », 20 pages, 13 novembre 2026.
Dépôt : `alexcour/couret-finite-verifications`
Branche : `codex/site-recherche-integration-20261113`
PR existante : #105

## Objet
Transformer l'audit en corrections scientifiques et éditoriales contrôlables, en poursuivant la PR #105 plutôt qu'en lançant une architecture parallèle. Travail préparatoire uniquement : pas de publication WordPress, de fusion, de divulgation supplémentaire de FCI ni de contact externe.

## Priorités
### P0 — Sécuriser la véracité et le périmètre
1. Inventorier les URL publiques mentionnant FCI ou décrivant des mécanismes de reprise. Conserver des copies datées et un rapport de différence ; soumettre le périmètre au conseil en propriété industrielle avant retrait, ajout ou nouvelle divulgation. Ne pas diffuser de détail sensible dans cette branche publique.
2. Vérifier la propagation des errata `F001_ERRATUM.md` et `ERRATUM_RH_T1T4_2026-10-13.md` sur les anciennes fiches. Préparer des corrections sans déploiement.
3. Localiser `SITE_CORRECTIONS_APPROVED_2026-10-14.md` (non trouvé à la racine de main lors du contrôle du 13 novembre) et dresser une matrice C01–C16 : source/version, URL, constat actuel, correction préparée, test, état. Ne pas présumer l'état d'une page à partir de son horodatage.
4. Préparer une liste de décisions sur l'éditeur légal, les données des formulaires, la licence, les droits sur les manuscrits ; aucune conclusion juridique automatique.

### P1 — Un seul site
5. Continuer les six fichiers de #105 (`review/site-recherche-2026-11-13/`). Valider ses chiffres, son HTML sans JavaScript, sa navigation et ses destinations avant recette WordPress.
6. Dresser la matrice des doublons : Recherches, Publications, Bernard Couret, À propos/Contact, Vérifier ; proposer URL canonique, archive datée ou redirection 301. Ne supprimer aucune archive.
7. Contrôler liens, menus, H1, métadonnées, accessibilité clavier/mobile, sitemap, licences et pages dont les contenus sont absents sans JavaScript. Les essais HTTP impossibles restent NON VÉRIFIÉS.

### P2 — Dossier scientifique unifié
8. Rédiger une note STROBO–Cayley autonome : objets (G abélien fini, S, R_S, A_S), conventions, distinction collision/translation/réflexion/isomorphisme/cospectralité et lien entre R_S et A_S².
9. Vérifier la preuve de classification des triplets figurant dans THEOREM_AND_PROOF.md d'après l'audit ; préciser domaine, exceptions éventuelles, bibliographie et priorité d'une relecture par combinatoriste. Une validation sur groupes finis ne constitue pas une preuve générale.
10. Distinguer les calculs annoncés (62 types jusqu'à 36 ; 190930 paires sans zéro) des énoncés prouvés ; confronter la littérature (dont Lev 2004 et Chen–Yan 2021). Aucune nouveauté scientifique revendiquée sans examen indépendant.

### P3 — Tests automatisés
11. Concevoir un registre d'affirmations (id, énoncé, hypothèses, statut, périmètre, référence, commit, run, empreinte, date, errata, publication autorisée).
12. Ajouter des tests de cohérence : chiffres entre pages, liens morts, statut Lean/CI, références manquantes, doublons de slugs, divulgation sensible et données privées. En cas d'échec : blocage du lot et reçu machine lisible.
13. N'autoriser les publications automatiques qu'après contrôle explicite de la confidentialité, des droits, de la fiabilité scientifique et du périmètre autorisé ; les sujets FCI restent toujours soumis à une autorisation humaine compétente.

## Sorties et critères d'acceptation
- Inventaire et matrice d'écarts datés, avec preuve URL/commit pour chaque constat.
- Rapport C01–C16 et errata, distinct des correctifs proposés.
- Note scientifique et références, avec statuts : ÉTABLI / CALCUL FINI / CONDITIONNEL / NON VÉRIFIÉ / RETIRÉ.
- Tests et reçus rattachés au HEAD exact, reproductibles en session propre.
- Livrables WordPress préparés, sans action en production.
- Bilan final : réalisé, testé, bloqué, non examiné, décision requise.
- Aucune fusion ni déploiement automatique.

## Répartition
**Anti-Gravity** : audit de l'interface et des pages WordPress, navigation, pages canoniques, recettes et accessibilité.
**Codex** : scripts de vérification, registre de preuves, cohérence numérique, dossier STROBO–Cayley et CI.
Ne pas dupliquer le travail ; coordonner via cette branche et la PR #105. Si l'agent ne lit pas les fichiers GitHub de lui-même, ce mandat ne déclenche pas son exécution.

## Limites de l'audit initial
Environ 60 URL sur ~160, cinq fiches sur 74 ; absence de vérification complète du serveur, de compilation Lean par l'auditeur, de recette mobile et de validation juridique. Conserver ces limites dans les comptes rendus.
