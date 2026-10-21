# Antigravity — mission WordPress C03 / C04 — COU-12
**Date :** 21 octobre 2026  
**État initial :** MODE BROUILLON UNIQUEMENT. PR GitHub #43 DRAFT. AUCUNE PUBLICATION NI MISE À JOUR DE PAGE PUBLIQUE AUTORISÉE.

Tu es l'agent Antigravity opérant **sur l'ordinateur de l'auteur**, sous sa supervision. Ta mission consiste à vérifier la session WordPress et à préparer des **copies brouillon non publiques** des corrections scientifiques C03 et C04 déjà approuvées. N'exécute aucune tâche sur un autre site, aucun cycle récurrent et aucune modification de comptes.

## 0. Références à lire avant d'agir
- Ticket : https://linear.app/couret/issue/COU-12/harmoniser-le-portail-strobo-cayley-et-la-pr-editoriale-34
- PR #43 (BRANCHE DRAFT, ne pas fusionner) : https://github.com/alexcour/couret-finite-verifications/pull/43
- Lot approuvé P0 : https://github.com/alexcour/couret-finite-verifications/blob/audit/wordpress-readonly-16url-20261014/review/site-couret-2026-10-11/WORDPRESS_P0_CMS_HANDOFF_2026-10-15.md
- Sprint daté et textes à prévisualiser : https://github.com/alexcour/couret-finite-verifications/blob/audit/wordpress-readonly-16url-20261014/review/site-couret-2026-10-11/SITE_SPRINT_RECETTE_2026-10-21.md (commit de référence `4f99fca537ec8c7164b32f76404d8b22df01c926`).
- Observations directes du 20/10 dans COU-12 : 16 contrôles / 15 URL distinctes, certains correctifs encore non servis ; ne pas confondre relevé public, source WordPress, brouillon et publication.
- Corrections de l'accueil du 19/10 **déjà observées** : ne pas écraser l'accueil.

Avant modification, identifier les versions actuellement présentes dans WordPress et rechercher si Frédéric a **déjà créé des brouillons corrigés**. S'ils existent, contrôler et compléter ces brouillons plutôt qu'en créer des doubles.

## 1. Accès / limites non négociables
1. Utiliser une **session authentifiée dans le navigateur local Antigravity**, en demandant au titulaire de se connecter dans l'interface si nécessaire ; la session du navigateur habituel peut ne pas être partagée avec Antigravity. Ne pas demander, lire, copier ou stocker le mot de passe ou les cookies de session ; ne pas rechercher de secrets dans Gmail, Git, fichiers locaux, ou stockage navigateur.
2. Si l'accès CMS est absent ou le rôle éditeur insuffisant, **STOP** et signaler précisément le verrou, sans réessai de mot de passe, élévation de privilège ni contournement. Les fiches **Portfolio** peuvent exiger le compte administrateur de Frédéric ; dans ce cas, produire seulement le diff prêt à appliquer pour cette fiche.
3. Site public : **lecture seule**. Interdit d'appuyer sur `Publier`, `Mettre à jour`, `Update`, `Publish`, `Quick Edit` ou tout déclencheur capable de modifier une page déjà publiée. Interdit d'utiliser `wp_tool.py inject` sur les ID publics, l'API REST `POST/PATCH/PUT` d'une page publiée ou un script de déploiement implicite. Ne pas changer menus, SEO global, permaliens, plugins, thèmes, utilisateurs ou réglages du site.
4. Édition permise **uniquement dans un brouillon/copie non public vérifié** : si une extension de duplication sûre est disponible, identifier l'ID source et créer une copie `draft` non indexée. Vérifier son statut *avant* la première sauvegarde ; sinon arrêter et proposer un plan manuel à Frédéric. Ne jamais convertir automatiquement un original publié en brouillon.
5. Ne rien publier, fusionner ni envoyer de courriel. Ne pas interpréter ce mandat comme un GO de production. Conserver les archives et errata (F-01, F-04, F-05, F-08, F-001, ancienne valeur `0,378` signalée comme réfutée).

## 2. Périmètre exact
**C03 — Résultats minimaux**  
URL publique, consultation seule : https://www.couretunification.fr/resultats-minimaux/

Observation historique à revérifier : un appel affirmait « Nous présentons un unique point ouvert comme équivalent à l'hypothèse de Riemann » ; « échafaudage non compilé » apparaissait sans objet/version précis.

Dans une **copie brouillon non publique**, remplacer seulement la revendication RH active par le bloc approuvé :
> **Relecture ciblée**  
> Les deux branches sont examinées séparément. Pour STROBO, la relecture porte sur l’énoncé exact, les hypothèses et la correspondance entre la preuve écrite et les théorèmes Lean compilés. Pour Cayley, elle porte sur les familles annoncées, les conventions d’adjacence, la cospectralité, l’isomorphisme et les antériorités. Aucune preuve de l’hypothèse de Riemann ni équivalence nouvelle avec elle n’est revendiquée.

Vérifier séparément à quel objet et commit renvoie « échafaudage non compilé » ; le qualifier ou le signaler comme question ouverte, **sans inventer de statut Lean** ni réécrire une citation historique. Préserver structure WPBakery, liens valides, traductions ou extraits existants indépendants.

**C04 — H1 / auto-adjonction**  
URL publique, consultation seule : https://www.couretunification.fr/publications/h1/  
Fiche Portfolio historique (ID déclaré : `2311`, à confirmer dans le CMS).

Dans une **copie brouillon non publique**, préparer :
- Titre actuel : **H1 — Estimation et hypothèses d’auto-adjonction**.
- Paragraphe approuvé :
> Une borne Hilbert–Schmidt, lorsqu’elle est établie pour l’opérateur considéré, fournit une borne de norme. Elle ne suffit pas à elle seule à prouver son auto-adjonction. L’application de KLMN exige une forme de base densément définie, fermée, symétrique et semi-bornée, ainsi qu’une perturbation symétrique de borne relative de forme strictement inférieure à 1. La forme, les domaines et l’identification de l’opérateur associé doivent être explicités et contrôlés. La clôture de H1 n’est pas établie par la seule estimation numérique affichée.

Dans **ce même brouillon**, aligner accroche, conclusion active, badges, texte secondaire, extrait WordPress et SEO si accessible ; marquer H1 **OUVERT / À VÉRIFIER** et non démontré ou fermé. Conserver les calculs historiques en section datée, avec rectification immédiate de leur portée. Ne pas attribuer une preuve Lean ou validation externe inexistante.

**Dépendances — contrôle seulement avant décision sur leurs propres brouillons :**
- C05 `/registre-f0/` : registre historique conservé avec note de rectification datée au-dessus.
- C06 `/recherches/` (page ID `1774` à confirmer) : grille dynamique Salient `nectar_post_grid`, à contrôler après prévisualisation du Portfolio C04. Ne pas changer la page publiée.
- C07 `/tableau-de-bord/` (page ID `2061` à confirmer) : badges `[D]`/`[P]`, `data-stats="D P"`, « démonstratif » doivent cesser de qualifier l'état **courant** de H1 ; ne pas présumer que le correctif local déclaré par Frédéric est publié.
- C10 `/le-senseur/` : rectification historique **F-04** sur KLMN, distincte de **F-05** Parseval/φ ; aucune suppression d'archives.
- **C02 accueil : hors périmètre d'édition** (refonte du 19 octobre déjà présente).

Ne créer des copies brouillon des dépendances qu'après avoir confirmé leur état réel et les droits correspondants ; sans quoi noter simplement les modifications requises.

## 3. Contrôle et preuves
Avant toute modification du brouillon, relever : date UTC/Paris, URL canonique publique, ID/type CMS, statut original, ID et statut du brouillon, auteur/horodatage, révision et source des blocs concernés (métadonnées et sources existantes consultées en lecture seule). Sauvegarder une copie de référence **hors dépôt GitHub public**, protégée localement.

Comparer **bloc par bloc** avant/après. Ne pas remplacer des pages complètes ni supprimer les contenus historiques et textes V3 sans justification. Prévisualiser uniquement les brouillons :
- Desktop et mobile : titre, texte, math, badges, liens, WPBakery/Salient, extraits, cache éventuel et champs SEO modifiés.
- Tester que l’ancienne affirmation RH ne subsiste pas comme revendication actuelle sur C03.
- Tester que H1 n'est plus présentée comme fermée/démontrée dans le brouillon C04 ; lire les dépendances sans présumer qu'elles se sont propagées automatiquement.
- Vérifier la **non-modification** des URL publiques, notamment C02, C03 et C04, par relevé avant/après (cache possible, horodatage des observations). Ne pas traiter un HTTP 200 comme preuve de conformité.

## 4. Compte rendu attendu et règles de sortie
Produire dans la réponse Antigravity (ou dans un fichier **privé local** non poussé au dépôt public) un tableau :
`Page | Public original ID / révision | Brouillon ID / statut | Opérations réalisées | Preview contrôlée | Résultats desktop/mobile | Dépendances | Blocage | Prochaine validation`.

Terminer avec le verdict par page : `BROUILLON_PRET_A_RELIRE`, `BROUILLON_INCOMPLET`, `AUCUN_BROUILLON_ACCES_BLOQUE` ou `DEJA_CORRIGE_A_VERIFIER`, en distinguant preuve observable et déclaration de l'opérateur.

Le dépôt GitHub est **public** : NE JAMAIS y pousser identifiants, cookies, captures de back-office contenant des informations personnelles, sauvegardes WPBakery non expurgées ou liens de prévisualisation contenant un nonce. Si un résumé non sensible doit être archivé dans COU-12 ou la PR #43, ne conserver que métadonnées et statuts expurgés. **Aucun cycle automatique, aucune publication, aucune fusion, aucune diffusion externe.**

**Si une seule condition de sûreté échoue : arrêt propre, rapport de blocage, aucune tentative de contournement.**
