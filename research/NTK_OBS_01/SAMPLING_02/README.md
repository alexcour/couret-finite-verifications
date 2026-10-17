# SAMPLING-02 — NTK-OBS-01

**11 octobre 2026 — prolongement interne après ROBUSTNESS-01.** Reconstruction de deux modes positifs d'un noyau FIXE à partir d'observations de perte avec bruit absolu borné. Aucun résultat nouveau ni validation externe revendiqué.

## Résultats (à portée bornée)

* Trois mesures peuvent **certifier la présence** d'au moins deux modes via une borne inférieure positive du déterminant de Hankel ; quatre sont génériquement nécessaires pour reconstruire **deux nœuds et deux poids** en données exactes.
* Sur les 24 espacements équidistants étudiés, le meilleur espacement **pour le certificat de cette archive** est h=12 dans l'exemple proche (0,91, 0,89), mais h=1 pour l'exemple original (9/16,1/4). Même nombre de mesures, horizon de temps différent.
* Un contre-exemple à deux modes positifs chaque fois impose une erreur d'au moins d/2 si le bruit atteint 15d²/4 : il est impossible de garantir une précision uniforme quel que soit le nombre d'observations, même adaptatives, **sans séparation ni niveau de bruit adéquats**.

Voir [SAMPLING_AUDIT.md](SAMPLING_AUDIT.md) pour les preuves et les tableaux ; [PROTOCOL.md](PROTOCOL.md) pour la procédure ; [CLAIM_BOUNDARY.md](CLAIM_BOUNDARY.md) pour les limites et [REFERENCES.md](REFERENCES.md) pour l'antériorité.

## Reproduction

`sh verify.sh` — Python 3.9+ et `sha256sum`, sans dépendance Python extérieure. Le JSON contient les fractions exactes et les 48 lignes de comparaison. Vérifier `SHA256SUMS`. Tests et certificats **locaux uniquement** ; pas d'évaluation indépendante. N'affecte pas le répertoire NTK-OBS-01 existant.
