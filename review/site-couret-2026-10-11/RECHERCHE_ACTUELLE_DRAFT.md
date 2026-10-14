# COURET — Recherche actuelle
> **Texte corrigé — 14 octobre 2026 — application éditoriale approuvée par l’auteur.** L’état effectivement déployé doit être contrôlé sur WordPress. Les résultats ci-dessous ne bénéficient d’aucune validation mathématique humaine indépendante ni d’une attestation de priorité.

**COURET — Art · Mathématiques · Mémoire**  
*Voir les nombres. Éprouver les énoncés. Conserver les traces.*

## Couret — Reconstruction additive et spectrale

Né notamment des manuscrits de Bernard Couret, cet atelier-laboratoire indépendant distingue ses créations, ses archives et ses travaux mathématiques contemporains. **Le programme de recherche actuel a deux branches, STROBO et Cayley.** Elles étudient des observables différentes : la fonction *étiquetée* des sommes ordonnées d'un support de trois éléments, d'une part ; le *multiensemble non étiqueté* des valeurs propres d'un graphe de Cayley, d'autre part. Aucun « théorème d'unification » des deux n'est revendiqué.

Les assistants d'IA participent à l'exploration, aux preuves écrites, aux codes et à leur critique ; ni leur accord, ni une CI réussie ne remplacent la relecture humaine.

## 1. STROBO — Reconstruction additive de supports triples

**Énoncé / observable.** Pour un groupe abélien `G` (notation additive) et une partie `S` de trois éléments distincts, on définit, pour tout `g ∈ G` :

`R_S(g) = #{(s,t) ∈ S × S : s + t = g}`.

Les neuf sommes sont **ordonnées**, comptées avec multiplicité ; `s=t` est autorisé. La question est de classifier exactement les paires `S,T` pour lesquelles `R_S = R_T` point par point. Ce n'est ni la seule connaissance des sommes sans multiplicité, ni une autocorrélation, ni l'égalité de spectres non étiquetés.

**Résultat structurel / portée exacte.** L'équivalence formalisée distingue (a) `T=S+u` avec `2u=0`, et (b) la famille exceptionnelle, à une translation `u∈G[2]` près :
`S={a,a+v,a+v+d}`, `T={a,a+2v,a+2v+d}+u`,
où `d∈G[2], d≠0`, `v∉G[2]` et `3v∈{0,d}`. Pour les groupes finis, les fibres complètes ont taille `h` ou `2h`, avec `h=|G[2]|`. Les hypothèses et les prédicats Lean exacts font foi pour chaque variante.

**Preuves disponibles.** La classification des supports est compilée dans Lean 4 ; les modules additionnels démontrent les tailles de fibres, les comptes globaux avec zéro admis et une partie de l'énumération sans zéro. Sur le commit scientifique [`310fcaf3`](https://github.com/alexcour/couret-finite-verifications/commit/310fcaf3c65c36eaed85149d4748bf9a6454ab47), **sept modules Lean** ont compilé, avec tests finis et vérification des placeholders, au HEAD de recherche documentaire [`045afdc1`](https://github.com/alexcour/couret-finite-verifications/commit/045afdc1b2175b1f415807cd191cb46b5e86a153) ([Lean #38605249711](https://github.com/alexcour/couret-finite-verifications/actions/runs/38605249711) ; [verify #38605249705](https://github.com/alexcour/couret-finite-verifications/actions/runs/38605249705), tous deux SUCCESS). Le jalon à six modules remonte au commit scientifique `310fcaf3` ; le septième module formalise certaines propriétés des profils ordinaires, sans clore leur histogramme universel. Sous la seule hypothèse supplémentaire `h≥4`, un théorème compilé donne le nombre de fibres complètes survivant à l'exclusion des supports contenant le neutre :
`C(|G|,3)/h - (|G|/h)(h-1)(|G[3]|-1)/2`.
Ne pas étendre cet énoncé à `h<4`.

**Limites.** Ne sont pas encore établis comme formules universelles closes dans Lean : l'histogramme ordinaire détaillé des fibres sans zéro, son agrégation numérique complète avec les fibres exceptionnelles, tous les comptes par profil/paires non translatives et le tableau général des maxima. Les calculs exhaustifs restent bornés. La compilation du septième module ne signifie pas que les comptes ordinaires par taille sont achevés. **E : preuves internes compilées dans le périmètre déclaré ; N : antériorité/priorité non établie ; Q : CI et reproductions internes, sans expertise humaine indépendante ; D : PR #25 ouverte, brouillon non fusionné.** Il s'agit du cas à trois éléments du [problème 2 de V. F. Lev (2004)](https://doi.org/10.37236/1831) ; la comparaison précise avec la littérature doit se poursuivre.

[PR #25 — énoncés, sources Lean et limites](https://github.com/alexcour/couret-finite-verifications/pull/25) · [Théorème et preuve écrite (commit scientifique figé)](https://github.com/alexcour/couret-finite-verifications/blob/310fcaf3c65c36eaed85149d4748bf9a6454ab47/research/strobo-2tors-2026-10-12/THEOREM_AND_PROOF.md) · [Gate Lean CURRENT sur la branche de recherche](https://github.com/alexcour/couret-finite-verifications/blob/research/strobo-2tors-global-classification-2026-10-12/research/strobo-2tors-2026-10-12/LEAN_GATE.md).

## 2. Cayley — Ambiguïtés spectrales de graphes

**Énoncé / observable.** Le spectre d'adjacence d'un graphe de Cayley est un multiensemble de valeurs propres. Il faut spécifier le groupe, les générateurs, l'orientation éventuelle, les boucles et la connexité. **Cospectralité n'implique pas en général isomorphisme** ; elle ne signifie pas non plus `R_S=R_T` de STROBO.

**Famille structurée examinée.** Dans le produit abélien `H × C_p` (`p` premier impair), on considère les supports prescrits
`T={(κ,0),(κ,c),(κ',0)}` et `T⁺=T+(0,c)`.
Sous les hypothèses du témoin **10A6**, pour `p≥5`, la cospectralité dans cette famille équivaut à l'existence d'un morphisme `h:H→F_p` tel que `h(κ')=1` et `h(κ)∈{1,2}`, et à l'automorphisme indiqué dans la preuve qui transporte `T` vers `T⁺`. Les témoins **10C3** (`p=3`, distinction selon la 3-torsion) et **10B1** (spécialisation cyclique) ont d'autres hypothèses, à consulter dans leurs énoncés, sans extrapolation.

**Preuves et contrôles.** Textes de démonstration internes, manuscrit, programmes de vérification exacte et reproduction publique sont disponibles dans le dépôt spécialisé. Un dossier séparé de [calculs et preuves internes cycliques (PR #30)](https://github.com/alexcour/couret-finite-verifications/pull/30) reste également en brouillon. La note à deux relations intrinsèques donne un argument écrit pour des digraphes orientés cospectraux non isomorphes pour tout entier `r≥1`, sans transférer automatiquement cette conclusion aux graphes non orientés. Des lemmes abstraits Lean ont passé la CI au commit `3b2cbb9` ; **l'instanciation universelle concrète de la famille cyclique n'est pas encore formalisée en Lean**. Certains exemples cycliques disposent d'antécédents publiés, dont Mönius ; leur redécouverte n'est pas présentée comme nouvelle.

**Limites et statuts.** **E : théorèmes défendus par des preuves internes, pas encore validés par relecture indépendante ; N : NON AUDITÉE pour la classification générale, avec recouvrements d'antériorité déjà identifiés ; Q : scripts/contrôles internes disponibles, contrôle externe ouvert ; D : dépôt public PUBLIC REVIEW 0.1.3-review, sans version scientifique stable, DOI Cayley, HAL ou arXiv.** Les énoncés ne classifient pas tous les graphes de Cayley cospectraux.

[Dépôt public Cayley et guide de relecture](https://github.com/alexcour/cayley-prime-translation-cospectrality) · [Frontière exacte des revendications](https://github.com/alexcour/cayley-prime-translation-cospectrality/blob/main/CLAIM_BOUNDARY.md).

## Archives, recherches historiques et explorations — pas d'autres branches directrices

Les sources et corrections antérieures restent accessibles, avec leur date et leur portée ; elles ne doivent plus apparaître au même niveau que les deux branches scientifiques actuelles.

- **STROBO-C3 / PR #8 :** étape cyclique préparatoire et contrôles finis, conservés dans l'historique STROBO, non troisième branche ([brouillon](https://github.com/alexcour/couret-finite-verifications/pull/8)).
- **HOL-01 :** certificat monodromique borné au cas `p=7`, sans extrapolation uniforme ([archive spécialisée](https://github.com/alexcour/hol01-monodromy-p7)).
- **Vérifications arithmétiques finies / modulo 30 :** calculs exacts, objets classiques et [erratum F-001](https://github.com/alexcour/couret-finite-verifications/blob/main/PUBLIC_FALSIFICATIONS.md) ; distincts des deux axes courants ([dépôt historique v1.0.0](https://github.com/alexcour/couret-finite-verifications)).
- **CU-BRUIT :** recherches exploratoires ou conditionnelles (notamment GRH/LI), contrôles externes incomplets, aucune résolution RH ([PR #4](https://github.com/alexcour/couret-finite-verifications/pull/4)).
- **Journal humain–IA :** documentation des méthodes, erreurs et corrections, sans confondre examen par IA et validation scientifique ([dépôt](https://github.com/alexcour/qui-repond-mathematiques-ia)).

Les archives Bernard Couret, les créations artistiques et le registre des falsifications gardent leurs espaces propres. Le nom « Couret–Unification » peut rester comme **provenance historique**, sans définir le programme CURRENT.

## Examiner une affirmation

Pour chaque résultat : **énoncé exact et hypothèses ; E** (ce qui est démontré/observé), **N** (antériorité), **Q** (reproduction et indépendance de la relecture), **D** (diffusion et version), provenance, lien vers preuve et contre-exemples. Une CI PASS, un dépôt visible ou un DOI ne prouve pas la nouveauté ni la relecture externe. Les objections partielles sont recevables avec l'identifiant du résultat et le commit.

**Navigation suggérée :** Œuvre · Recherche (STROBO / Cayley) · Publications · Archives · Journal humain–IA · À propos.

### English short introduction

**Couret — Additive and Spectral Reconstruction** is an independent programme with two separate research branches. **STROBO** classifies three-element subsets of abelian groups from their *labelled ordered pair-sum representation functions*, with structural results formally checked in Lean 4 and further zero-free counting formulas still open. **Cayley** investigates adjacency-spectrum coincidences in explicitly defined families of Cayley graphs; internal proofs and exact finite checks have not yet passed independent expert review or a full priority audit. Historical projects remain in clearly marked archives. No unification theorem, general priority, or stable research publication is claimed here.

---

**ARCHIVE DE LA DÉCISION ANTÉRIEURE — DRAFT / NO DEPLOY, AVANT L’APPROBATION DU 14 OCTOBRE.** Ce fichier contient une proposition de texte fondée sur des sources GitHub déjà publiques, non une autorisation de publication. Rien ici ne fusionne la PR #9 ou la PR #34, ne modifie la release historique v1.0.0, ne valide une preuve par expertise, ne crée de DOI, ni n'autorise la mise en ligne WordPress. Les dossiers Drive privés, pièces de correspondance et matériaux protégés restent exclus. Vérification des droits, revue scientifique et validation éditoriale restent préalables.


## Décision éditoriale courante — 14 octobre 2026

L’auteur a approuvé l’application des corrections publiques déjà préparées. Ce texte et [les remplacements par URL](SITE_CORRECTIONS_APPROVED_2026-10-14.md) peuvent être intégrés au dépôt pour corriger le cadrage éditorial. L’application WordPress exige l’accès CMS et un contrôle après mise à jour. Les PR scientifiques #25/#30 restent des brouillons ; relecture indépendante, priorité et autorisations des matériaux confidentiels restent distinctes. Aucun changement des tags ou DOI historiques.


**Integration status:** corrected content is committed and retains DRAFT status. Default-branch merge approval remains pending; WordPress application requires authenticated CMS access. No merged or deployed correction is claimed.
