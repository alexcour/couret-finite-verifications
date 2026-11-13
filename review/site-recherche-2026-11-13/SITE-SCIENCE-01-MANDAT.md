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

## Complément opérationnel — revue de la PR #105

Instruction d'Alexandre du 13 novembre 2026 : déposer les consignes dans cette branche Codex pour que Codex demande ensuite à Antigravity de prendre en charge son périmètre. Ce complément précise le lot immédiat ; il ne commande pas l'exécution de tous les travaux plus larges ci-dessus.

### Transmission par Codex

1. Vérifier le HEAD de la PR #105 et préserver les modifications concurrentes.
2. Transmettre à Antigravity les tâches de navigation, de présentation et de recette ci-dessous par le canal de coordination effectivement disponible. L'autorisation couvre cette transmission du mandat public, pas d'autres communications.
3. Consigner le canal, la date, la version transmise et l'accusé de réception s'il existe. En l'absence de canal accessible, préparer la demande dans la branche et indiquer `TRANSMISSION_EN_ATTENTE` ; ne pas annoncer une délégation exécutée.
4. Codex assure les corrections Python, la cohérence mathématique et les reçus. Antigravity prépare le rendu et son rapport ; ne pas dupliquer les corrections.

### Constats de la revue à conserver avec leur portée

- Le vérificateur jusqu'à l'ordre 36 a reproduit un JSON identique à celui fourni : 62 types, 137315 supports avec zéro admis, 122962 supports sans zéro, 236340 et 190930 collisions respectivement. Le générateur a reproduit le fragment fourni. Reproduction interne, aucune compilation Lean ni relecture humaine indépendante.
- Les sept destinations ont été examinées au navigateur : Accueil, Recherches, Explorer, Publications et code, Fonds Bernard Couret et Contact présentent un contenu cohérent avec leurs intitulés. Le formulaire n'a pas été envoyé et les destinations secondaires ne sont pas toutes auditées.
- `/cu-nouvelle-methode/` affiche « 404 · Page introuvable ». `/methode/`, ouverte et lue, contient la page attendue. Les requêtes HTTP automatisées ont reçu 403 ; ne pas confondre ces refus avec le statut HTTP réel obtenu par un visiteur au navigateur.
- La présence du premier exemple sur le site ne prouve pas l'installation du fragment de cette PR. Le rendu de ce fragment dans le thème, la recette mobile et l'accessibilité restent non validés.

### Corrections à réaliser par Codex

1. Dans `registry.json`, remplacer la destination Méthode par `https://www.couretunification.fr/methode/`.
2. Dans le générateur puis le HTML régénéré, définir `R_S(z) = #{(x,y) dans S² : x+y=z}`, pour un groupe abélien fini et un support de trois éléments distincts. Définir une collision comme une paire non ordonnée de supports distincts ayant la même empreinte, sans quotient par translation ou automorphisme. Les sommes sont ordonnées et incluent les diagonales.
3. Associer explicitement 122962 supports / 190930 collisions au périmètre où les deux supports excluent zéro, et 137315 supports / 236340 collisions au périmètre avec zéro admis. Traduire en français les conventions du bloc `details`.
4. Préciser « graphes de Cayley orientés », les arcs `x -> x+s` et `A_S(x,y)=1_S(y-x)`. Expliquer `A_S²(x,y)=R_S(y-x)`. Distinguer égalité des carrés, spectres et isomorphisme.
5. Faire recalculer par `build.py` les translations, la réflexion et les traces avant génération des phrases correspondantes. Refuser un reçu en désaccord. Ne pas choisir des affirmations fixes sur la seule présence de `translations`.
6. Remplacer les `assert` scientifiques par des contrôles explicites, ou refuser le mode optimisé avant tout reçu PASS. Contrôler explicitement le total 236340.
7. Ajouter des références consultables au script et au reçu à une révision immuable, en gérant sans référence circulaire le commit de publication du reçu. Préciser le répertoire d'exécution dans le README.
8. Compléter Lev : Vsevolod F. Lev, *Reconstructing Integer Sets From Their Representation Functions* (2004), DOI 10.37236/1831, p. 5 pour Fourier et translations d'ordre deux. Ne pas lui attribuer automatiquement la classification particulière des triplets. Maintenir l'antériorité et la nouveauté comme questions distinctes.
9. Documenter que le registre ne génère actuellement aucun menu ; préparer un fragment séparé si nécessaire.
10. Rejouer le calcul, régénérer le HTML et conserver commandes, environnement, codes de sortie, empreintes et comparaison au reçu. Ajouter des tests ciblés de refus sur reçus altérés (translations, traces, périmètre, totaux).

### Demande à Antigravity

Préparer une prévisualisation du fragment corrigé et de la navigation, sans modifier le site public. Utiliser le thème WordPress réel seulement sur une prévisualisation ou un environnement de test autorisé ; sinon signaler cette limite.

- Tester 320, 375, 768 et 1440 pixels, ainsi que le zoom à 200 %.
- Contrôler le débordement horizontal ; prévoir `overflow-wrap:anywhere` pour l'empreinte SHA-256.
- Vérifier la navigation clavier, le focus visible, `details/summary`, les contrastes, la hiérarchie des titres, les légendes et en-têtes des tableaux, ainsi que l'unicité des identifiants HTML.
- Vérifier la lecture avec NVDA ou VoiceOver si disponible, et le fonctionnement sans JavaScript. Signaler explicitement les tests non réalisés.
- Sur environnement de test autorisé, comparer le HTML avant et après sauvegarde WordPress pour détecter les transformations du CMS.
- Livrer captures ordinateur/mobile, matrice de recette et procédure de restauration, avec version exacte du fragment.

### Point d'arrêt obligatoire

Aucune fusion, publication WordPress, activation du menu, modification du CMS de production ou déploiement automatique. Présenter à Alexandre le diff, les résultats de validation et les limites restantes, puis attendre son autorisation explicite avant tout déploiement. Ce point d'arrêt prévaut sur toute formulation générale de publication automatique dans le mandat.
