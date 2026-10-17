# COURET — contrôle des archives scientifiques pré-relecture (11 octobre 2026)

**STATUT : AUDIT DOCUMENTAIRE / PR BROUILLON. AUCUN DOI NOUVEAU, AUCUNE RELEASE, AUCUN DÉPÔT ZENODO.**

## Décision générale
Une archive de recherche **UNREVIEWED RESEARCH ARCHIVE / NOT PEER REVIEWED** peut être publiée pour susciter la contradiction **avant** examen par des pairs. L'absence de relecture externe n'est donc pas, en soi, un blocage général. Toutefois, chaque archive doit être autonome et figée (code, données, résultats, SHA-256, dépendances, auteurs, licences, antériorités, limites, confidentialité). Les interdictions documentaires particulières **ne sont pas levées automatiquement**. Le DOI date des octets et ne démontre ni exactitude théorique, ni nouveauté, ni priorité.

## Reproduction et état des sept candidats

Les sept candidats nettoyés ont été extraits puis contrôlés via `bash REPRODUCE.sh` ; **7/7 replays locaux PASS** (une relecture informatique interne, pas une expertise humaine indépendante).

| Objet | Source GitHub | Contrôle | Gate d'archivage |
| --- | --- | --- | --- |
| G30 | PR #2 et dossier G30 de main | Python exact, 56 supports, 10 classes ; Lean conforme au blob CI du 08/10 | Revue finale des droits et métadonnées |
| MOD-OBS-02 | PR #16 | 12 tests ; deux JSON comparés après recalcul | Contrôle des droits, données et version |
| STROBO/MOD-OBS consolidation | PR #18 | 6 tests, 64 domaines, contre-exemple n=22 retenu | Audits des limites et antériorités |
| CU-MOD-OBS-05 | PR #21 | 6 tests phase 1 + 10 tests phase 2 | Licences et cohérence des deux phases |
| NTK-OBS-01 | PR #19 | 5 tests + robustesse intégrée | **Gate individuel DOI non levé** |
| NTK-OBS-02 | PR #20 | 8 tests ; résultats exacts | **Interdiction explicite Zenodo non levée** |
| CU-LOG-SPEC-02 | PR #11 | Recalcul jusqu'à 90 M ; contrôle 4 × 48 comptes | **Gate individuel relecture avant publication à amender** |

Le résultat numérique négatif CU-LOG-SPEC-02 est conservé : le seuil exploratoire de 5 % ne se maintient pas sur deux fenêtres. Ne pas confondre le modèle logarithmique avec les fenêtres linéaires ni présenter une p-value.

## Intégrité des ZIP candidats (conservés hors de ce dépôt)

- G30 : `bdf9cca17f7f4afd103106acde0cf95b4d3c02e191b8010a2b2d3c9a20a7f55e`
- MOD-OBS-02 : `57163e465e78274574e5f27f4bed6c768652ecdb4b1318b6615a619779801a23`
- Consolidation : `923c6cf49a1f3cc7818422213d790bbf89ece6e36c59ad5a7f39713e512ec975`
- CU-MOD-OBS-05 : `280ceeac3a35c77ffd22ff4f90c95954c050a0dffb051b17853837892d1d2743`
- NTK-OBS-01 : `7e4cb31a5823a5159ea551f344e839ba08ef7aa34e8c3d52b6c2d78d745e936f`
- NTK-OBS-02 : `0060e31422b49355f4328a46d98eb4e7ccbd3720bec5c39507548e407df327a2`
- CU-LOG-SPEC-02 : `7e016962fa5ad685b0d2d9e2a4d6cb9ee9b2091abc1647e46e9b8c8af20aad56`

Les fichiers historiques originaux restent conservés séparément dans l'espace privé. Deux références de documents Google *privés* ont été expurgées du paquet public candidat MOD-OBS-02 et les deux documents Word historiques non essentiels ont été exclus. Les détails privés ne sont pas reproduits ici.

## Conditions de levée des gates
1. Ne pas modifier ni réétiqueter les trois archives Zenodo historiques et leurs tags.
2. Auteur : contrôler expressément le périmètre des droits (MIT pour le code original GitHub ; licence des notes, tableaux et contenus tiers à décider), vérifier l'absence de contenu confidentiel.
3. Pour #11 et #19, remplacer la condition de relecture **avant dépôt d'une archive non évaluée** par une condition de complétude/reproductibilité, sans lever les conditions de fusion et de version scientifique stable.
4. Pour #20, **décision explicite et distincte** obligatoire avant toute publication Zenodo ; le gate particulier est maintenu en l'état.
5. Demander ensuite des relectures indépendantes avec objections, calculs négatifs et antériorités ; les résultats contestés sont à conserver par erratum/version liée.
6. Après publication effective seulement, enregistrer le vrai DOI, le commit, la date et le SHA-256 effectivement déposé.

**Cette note n'autorise aucune publication ; elle enregistre une vérification technique et un circuit de décision.** Les fichiers ZIP de préparation ne sont pas ajoutés au dépôt GitHub public.