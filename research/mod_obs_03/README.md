# MOD-OBS-03 — Paquet scientifique de reproduction

**Date** 2026-10-11 · v0.1 · brouillon, relecture contradictoire requise.

## Objet
Cas fini n=18 de comparaison entre certification probabiliste d'une propriete et reconstruction complete sous deux oracles binaires de cout et taux d'erreur differents. Hypotheses de bruit explicites, non validees sur des donnees reelles. Voir `RAPPORT_SCIENTIFIQUE.md` et `PROTOCOL_FREEZE.md`.

## Reproduction (Python 3.10+, stdlib seulement)

    bash verify.sh

Le script controle SHA-256, lance 16 tests, regenere `results.json` et `independent_audit.json`, puis verifie une seconde fois les empreintes. Le ZIP complet inclut les sorties numeriques et la note Word.

## Contenu

- `PROTOCOL_FREEZE.md` : hypotheses et tests geles AVANT le lancement de la campagne.
- `RAPPORT_SCIENTIFIQUE.md` : enonces, preuves internes, risques, limites.
- `mod_obs_03.py` : calcul fractionnaire principal et controle de transcripts.
- `independent_audit.py` : chaines absorbantes par elimination gaussienne.
- `test_mod_obs_03.py` : 16 tests.
- `results.json`, `independent_audit.json` : sorties controlees.
- `MOD_OBS_03_NOTE_SCIENTIFIQUE_2026-10-11.docx` : note de lecture et de relecture.
- `SHA256SUMS`, `verify.sh` : verification du paquet.

## Etats des garanties

- Les nombres sont exacts SOUS le modele IID declare, et le risque est uniformement borne SOUS la borne conditionnelle de probabilite d'erreur.
- Mauvaise calibration, erreurs persistantes et observation initiale erronee detruisent potentiellement la garantie.
- Ni nouveaute bibliographique, ni preuves formelles Lean, ni relecture scientifique externe etabli(e)s.
- Ne pas fusionner de PR sans audit contradictoire ; publication stable NO-GO.
