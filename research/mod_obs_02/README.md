# MOD-OBS-02 — Certification sous au plus une réponse erronée

**11 octobre 2026 · rapport de recherche pour relecture · N=NON AUDITÉE**

## Question

Une observation A_S² est tenue pour fiable ; les réponses q_x(S)=[x∈S]
aux questions suivantes peuvent comporter au plus un mensonge total.
Combien de questions faut-il poser pour reconstruire le support S ou
pour déterminer seulement une propriété donnée de S ?

## Résultats finis

Deux implémentations concordent sur toutes les fibres de n=12,18,24
(au total 101, 393 et 991 fibres) pour sept cibles et les régimes
pré-enregistrés. Pour n=18 sans zéro, 680 supports / 393 fibres et
un pire coût U : reconstruction 2 (b=0) contre 5 (b=1), détermination
de « 1 appartient à S » : 1 contre 3 ; demi-tour : 0 contre 0.
Avec coûts fictifs W(x)=1+(x mod 3), reconstruction : 6 contre 15.

Une fibre témoin de quatre supports donne une preuve interne
exacte 5 questions nécessaires et suffisantes pour reconstruire
avec un mensonge. Antériorité et généralisation non établies.

## Fichiers

- `PROTOCOL_FREEZE.md` : mesures et hypothèses choisies avant les calculs.
- `RAPPORT_SCIENTIFIQUE.md` : méthodes, preuves, résultats, limites.
- `MOD_OBS_02_NOTE_SCIENTIFIQUE_2026-10-11.docx` : note de lecture et relecture.
- `mod_obs_02.py` : convolution ordonnée + minimax vectoriel + arbres.
- `independent_audit.py` : convolution non ordonnée + minimax à mondes explicites.
- `test_mod_obs_02.py` : 12 tests dont deux tests négatifs du vérificateur.
- `results.json`, `independent_audit.json` : sorties entières reproductibles.
- `SHA256SUMS`, `verify.sh` : empreintes et rejeu complet.

## Rejouer

```sh
sh verify.sh
```

Requiert Python 3.9+ (bibliothèque standard). Aucune donnée externe.
Les programmes ne vérifient pas que des instruments réels commettent
au plus une erreur, que le carré est fiable, ni la nouveauté de résultats.

**Diffusion** : archive interne, PR GitHub en brouillon.
