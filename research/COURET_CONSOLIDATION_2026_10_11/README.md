# COURET — Consolidation du 11 octobre 2026

**Paquet d'audit destiné à la relecture contradictoire.** Il ne modifie pas les archives historiques ni les PR antérieures.

- `REGISTRE_CANONIQUE.md` : identifiants uniques des revendications et correspondance avec les PR et leurs commits.
- `NOTE_THEOREME_CONNEXITE.md` : énoncés, démonstration interne, contre-exemples n10/n22, limites et questions aux relecteurs.
- `AUDIT_ANTERIORITES.md` : comparaison ciblée des sources primaires Yang–Chen 2012 / Chen–Yan 2021.
- `REPLAY_ET_PORTES.md` : état de reproduction des archives existantes, différences GitHub/Drive, portes qui demeurent ouvertes.
- `verify_connectivite.py` et `test_connectivite.py` : deux stratégies de vérification (convolution de sommes ; parcours BFS et multiplication de matrices).
- `RESULTATS_CONTROLES.json` : 64 scans (n5..n36 ; zéro autorisé ou non), témoins n10/n22, contrôles exceptionnels n6d pour d≤12.
- `verify.sh`, `SHA256SUMS` : contrôle d'intégrité, tests, régénération du JSON, comparaison octet-à-octet.
- `NOTE_CONSOLIDATION_2026-10-11.docx` : synthèse éditée pour le relecteur (si présente dans l'archive complète).

**Rejouer :** `sh verify.sh` depuis ce dossier (Python 3.10+, bibliothèque standard et `sha256sum`).

**Frontières :** preuves internes soumises à relecture, exactitude numérique finie et antériorité partielle. Aucune affirmation de nouveauté ou de validation externe et aucun essai de système IA réel. Ne pas fusionner la branche de recherche sans examen contradictoire formel.
