# CU-LOG-SPEC-05 - Modèle conjoint conditionnel, 12 octobre 2026

Premier modèle mathématique conjoint de `(F15,F21,F35,Gchi5)` : phases des zéros primitifs, sept modes réels, vingt paires conjuguées, 27 blocs indépendants **sous LI jointe et non-annulation centrale**. Aucune numérisation complète de la loi jointe, aucun seuil de rejet nouveau. Aucune donnée de la fenêtre réservée `(100M,300M]` n'est consultée. PR #10 maintenue en brouillon.

La note donne les preuves conditionnelles, la propagation des queues vers les ratios, une borne de hauteur explicite issue de BMOR, des contre-exemples aux approximations, et les conditions de calibration d'un test. Les calculs du catalogue chi5 sont en double précision et **non certifiés par intervalles**. Les douze tests comprennent des contrôles exacts par fractions, des inversions Fourier indépendantes et des quadratures numériques.

## Reproduction sans réseau ni crible

Python 3.10+ ; NumPy et SciPy. Dans ce dossier :

```bash
sha256sum -c SHA256SUMS
python -m unittest -v test_joint_phase_model.py
python joint_phase_model.py > /tmp/cu_log_spec_05_reproduced.json
cmp RESULTATS_MODELE_CONJOINT_2026_10_12.json /tmp/cu_log_spec_05_reproduced.json
```

La comparaison byte-for-byte a été vérifiée dans l'environnement enregistré dans `SOURCE_PROVENANCE.json`. De très petits écarts flottants restent possibles sur d'autres versions de NumPy/SciPy ; ne pas les qualifier de désaccord arithmétique avant analyse.

`sample_modes` simule uniquement le catalogue fini qu'on lui fournit. Le script principal n'émet aucune distribution ni quantile prospectif des quatre ratios à partir du catalogue incomplet. Les ordonnées synthétiques des tests ne sont pas des zéros L. Les compléments historiques et le manifeste initial restent inchangés.

## Gates

- Identités classiques et preuves conditionnelles : exposées, proposées à la relecture.
- Calculs finis locaux : 12 nouveaux tests + 3 tests historiques de covariance passés.
- Certificat d'exhaustivité ou de racines des fonctions L : non produit.
- Test joint à niveau garanti sur la fenêtre déterministe : **non prêt**.
- Originalité, audit externe et fusion : non revendiqués/non effectués.
