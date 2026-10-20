# COURET — Programme de vérifications finies, suivi des correspondants (2026-10-13)

Version de travail / *independent finite arithmetic checks*, non relue par les correspondants.

## Contenu

- `NOTE_SCIENTIFIQUE_20261013.md` : énoncés, méthodes, hypothèses, sources, frontières de preuve.
- `verify_correspondants_20261013.py` : arithmétique exacte U(30), convolution cyclique, filtres premiers et oracle exhaustif.
- `RESULTS.json` : résultats reproductibles de l'exécution de base n=24,40.
- `EXTENDED_RESULTS.json` : six modules supplémentaires testés (n=32,48,56,60,72,80).

Exécutions :
```bash
python3 verify_correspondants_20261013.py > RESULTS.json
python3 verify_correspondants_20261013.py --extended > EXTENDED_RESULTS.json
```

**Scope notice:** finite Python arithmetic PASS ≠ Lean-compiled proof, human audit, GRH/ELI_A, or quantitative certified sign density.

Principales sources publiques :
- Bailleul, Hayani, Untrau (2026), arXiv:2603.20093v2, théorèmes 5.13 et 5.17 : https://arxiv.org/html/2603.20093v2
- Mahatab & Sampath, Journal of Algebra 435 (2015), 223–262 : https://arxiv.org/abs/1401.7696
- O. Babanskyy, programme public de reconstruction : https://github.com/aconsciousfractal/FCIG-Autocorrelation-Phase-Lattices-on-Cyclic-Groups
