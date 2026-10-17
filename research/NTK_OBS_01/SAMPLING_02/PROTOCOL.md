# NTK-OBS-01 / SAMPLING-02 — Protocole de reproduction

Date : 11 octobre 2026. Protocole fixé au moment de la constitution de cette archive, **après sélection des deux exemples**. Ce n'est **pas** une préinscription statistique ni un test sur données retenues secrètes.

## Fichiers

- `SAMPLING_AUDIT.md` : hypothèses, démonstrations, comparaison, limites.
- `verify_sampling.py` : Python 3.9+ standard library ; aucun module tiers ; arithmétique `Fraction` / `isqrt`, racines encadrées par comparaisons entières.
- `sampling_results.json` : résultats canoniques déterministes à regénérer.
- `verify.sh` : vérification et rejeu en un appel.
- `SHA256SUMS` : SHA-256 des fichiers sources et résultats, hors manifeste et archive ZIP.
- `CLAIM_BOUNDARY.md`, `REFERENCES.md`, `README.md` : interprétation, antériorité, index.

## Contrôles et hypothèses gelés

1. Modèles : `NEAR=(91/100,89/100;1,1)` ; `ORIGINAL=(9/16,1/4;1,4)`.
2. Horaires `0,h,2h,3h`, pas entiers `h=1,2,...,24`. Les 24 pas sont comparés, pas tous les horaires possibles.
3. Bruit : `|e_k|<=epsilon` indépendamment **comme contrainte par composante**, sans hypothèse probabiliste ou indépendance statistique.
4. Test propriété : trois mesures, seuil rationnel `E_rank(h)=D_h/[2*(M0+M2+2*M1)]`, puis 27 motifs de signes `{-epsilon,0,+epsilon}^3` à `epsilon=E_rank/2`, et contre-test du seuil strict au bord.
5. Certificat reconstruction : quatre mesures, théorème de perturbation de `ROBUSTNESS-01` appliqué aux nœuds `r_i=q_i^h`, puis retour `q_i=r_i^(1/h)` avec `zeta=1/100`.
6. Cibles de précision : `|q~_i-q_i|<1/100`, `|w~_i-w_i|<1/10`. Recherche exacte du plus grand epsilon admissible sur la **grille** `{N/10^12:N entier >=0}` ; une valeur `N+1` doit échouer au test suffisant.
7. Déterminants de Jacobien vérifiés par élimination rationnelle d'une matrice 4×4 et indépendamment par la formule confluente.
8. Pour le pas 1 et le meilleur pas de chaque exemple : 81 motifs de bruit `{-epsilon,0,+epsilon}^4`, récupération Prony avec intervalles rationnels extérieurs de racines carrées/h-ièmes à résolution `10^-18`.
9. Famille obstruction : `d=1/16,1/100,1/1000,1/10000`. La boucle sur `k=0..100` ne constitue PAS la preuve de la borne uniforme en tout temps (preuve analytique dans l'audit).

## Exécution locale

Dans le dossier extrait :

```sh
sh verify.sh
```

Le script contrôle les sommes, régénère les résultats et vérifie à nouveau les sommes. Un échec quelconque **HALT**. L'archive ZIP stocke les fichiers avec des horodatages internes fixes, exclut ses propres octets du manifeste et n'utilise aucune entrée réseau.

## Interprétation

L'indice « meilleur pas » signifie **maximum sur les 24 pas de ce test suffisant** pour **ces exemples** ; ce n'est ni un minimum global d'erreur ni une recommandation universelle. Le seuil de propriété est optimal seulement pour le témoin d'intervalle particulier étudié, sous toutes les perturbations admissibles du modèle fixé. `m_k=2L[k]` : un bruit `epsilon_L` sur `L` correspond à `epsilon=2*epsilon_L` ici.

## Gates

Local exact computations PASS, auditor source review OPEN, external reproduction OPEN, novelty NO CLAIM, main merge NO-GO, DOI NO-GO.
