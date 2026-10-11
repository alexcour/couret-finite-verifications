# Registre canonique des affirmations — Programme COURET

**Version 0.1 du 11 octobre 2026 · index de suivi (ne modifie aucune archive historique).**

Ce fichier désambiguïse les numéros historiques MOD-OBS en préservant chaque **PR, chemin et commit** d'origine. `E` qualifie le niveau de preuve (interne/expérimental), `Q` la reproductibilité, `N` la nouveauté bibliographique, `R` la relecture externe. Les quatre axes sont indépendants. « Reproductible » n'est **pas** synonyme de « original » ou « relu ».

| ID canonique | Alias historiques | Revendication délimitée | Source immuable consultée | Gate actuel |
|---|---|---|---|---|
| **CU-STROBO-CLS-01** | STROBO-C3-01 | Classification candidate de toutes paires triples à même A², nul exclu ou admis selon énoncé | [PR #8](https://github.com/alexcour/couret-finite-verifications/pull/8), HEAD `3cd6ae6ea39cc16540bea4f8547101d69c70d188` | E interne candidate ; Q balayages ; N ouverte ; R ouverte |
| **CU-STROBO-EX6-01** | construction « exceptionnelle » | Motif d'ordre six et plongements en 6d | [Chen–Yan 2021, th. 1.2](https://doi.org/10.1017/S0004972720000945) ; [PR #8](https://github.com/alexcour/couret-finite-verifications/pull/8) | Antériorité directe : pas de priorité à revendiquer |
| **CU-STROBO-ISO-01** | audit nauty et arcs | 106 paires isomorphes / 444 non isomorphes parmi 550 paires étudiées | [PR #8](https://github.com/alexcour/couret-finite-verifications/pull/8) | Q interne ; pas de classification générale établie |
| **CU-MODOBS-FIX-01** | MOD-OBS-01 (questions fixes avant A²) | Coût universel `n/2−1` pour n pair≥6, questions d'appartenance, nul exclu | [PR #14](https://github.com/alexcour/couret-finite-verifications/pull/14), HEAD `184c4f66f93d32835539cbbe7882439d976d5de7` | Preuve interne ; ZIP rejoué ; N/R ouvertes |
| **CU-MODOBS-ADV-02** | MOD-OBS-02 / bruit adversarial | Reconstruction de fibre sous 0 ou 1 erreur globale ; n18 coût 2→5 | [PR #16](https://github.com/alexcour/couret-finite-verifications/pull/16), HEAD `f8e2cd898507d1a610fd2aef35caf492b7ce123c` | Q interne et ZIP rejoué ; R ouverte |
| **CU-MODOBS-CUB-03** | MOD-OBS-03 (MAJUSCULE dans PR #15) | Sondes cubiques, effets de la trace, décision locale de connexité n18 | [PR #15](https://github.com/alexcour/couret-finite-verifications/pull/15), HEAD `b92d90caa39854df6096f76c14aabeed4dc050ea` | Résultat fini ; extrapolation trace universelle réfutée n22 |
| **CU-MODOBS-CONN-04** | `MOD_OBS_03/AUDIT_04` | A² décide la forte connexité si n impair ou si 4 divise n ; contre-exemple n22 hors régime | [PR #15 — audit 04](https://github.com/alexcour/couret-finite-verifications/blob/research/mod-obs-03-2026-10-11/research/MOD_OBS_03/AUDIT_04/PROOF_AUDIT.md) | Preuve interne + nouveau replay n5..36 ; N/R ouvertes |
| **CU-MODOBS-ADV-04** | CU-MOD-OBS-04 (PR #13, noms préexistants) | Recherche avec e erreurs, 0/1/2/3 mensonges, nonadaptatif vs adaptatif et fraîcheur de l'état | [PR #13](https://github.com/alexcour/couret-finite-verifications/pull/13), HEAD `04159b86e08a990c11c4cb77dd6ee8d19dfafcad` | Contrôles internes ; audit externe ouvert ; périmètre distinct de CONN-04 |
| **CU-MODOBS-PROB-03** | MOD-OBS-03, *lowercase* dans PR #17 | Risque nominal 5 %, canaux hétérogènes, KL, fragilité à corrélation | [PR #17](https://github.com/alexcour/couret-finite-verifications/pull/17), HEAD `bc9c54d524c535943bc53ec94c692825b229fd06` | Modèle conditionnel ; ZIP rejoué ; pas de validation de sources réelles |
| **CU-LOGSPEC-02** | CU-LOG-SPEC-02 | Deux fenêtres dépassent seuil exploratoire 5 %, donc règle générale non maintenue | [PR #11](https://github.com/alexcour/couret-finite-verifications/pull/11) | Résultat négatif expérimental ; pas de théorème arithmétique |
| **CU-BRUIT-GATE** | CU-BRUIT-02 | Zéros q15 non rapprochés indépendamment ; modèle probabiliste conditionnel | [PR #4](https://github.com/alexcour/couret-finite-verifications/pull/4) | 37/67 zéros externes à certifier |
| **CU-OBSSEQ-04** | OBS-SEQ-04 | Corpus symbolique : comparaison de générateurs et observables | Dossier Drive OBS-SEQ, archive historique | Manifeste à corriger et provenance à fermer, sans altérer historique |

### Conventions et règles de version

1. **ID canonique = objet de preuve précis**, jamais seulement le numéro de la campagne. Conserver les noms historiques comme alias visibles dans le registre ; ne renommer aucun chemin existant.
2. Épingler **branche + HEAD ou fichier SHA**, sources Drive, protocole et paramètres. Une PR peut avancer ; chaque résultat publié doit renvoyer à un commit figé.
3. Ne pas fusionner `CU-MODOBS-CONN-04` et `CU-MODOBS-ADV-04` : ils traitent des propositions distinctes malgré le suffixe historique « 04 ».
4. Ne pas fusionner `CU-MODOBS-CUB-03` et `CU-MODOBS-PROB-03` : même alias « 03 » mais observations et modèles probabilistes différents.
5. Les conventions « zéro autorisé », « zéro exclu », « forte connexité », « identité étiquetée », « isomorphisme » et « trace/coefficients/matrice » doivent figurer sur chaque résultat chiffré.
6. La réponse « N=NON AUDITÉE » demeure tant que la comparaison théorème-à-théorème aux publications primaires n'est pas fermée. Aucun de ces statuts n'est automatiquement modifié par le présent index.
