# GitHub review checkout — MOD-OBS-03

Cette branche est un **sous-ensemble textuel directement rejouable** de l'archive scientifique complète du 11 octobre 2026.

- Depuis ce répertoire, lancer `sh verify_repo.sh` (Python 3.10+ ; bibliothèques standards uniquement pour les calculs).
- `SHA256SUMS_TEXT` correspond aux **fichiers textuels inclus dans la PR** ; le Word binaire et la liste des empreintes de l'archive complète sont disponibles sur Google Drive.
- La génération optionnelle du Word nécessite `python-docx` et le script `build_note.py` ; elle n'est pas requise pour reproduire le résultat scientifique.
- Toutes les garanties supposent la fiabilité du carré d'adjacence et la borne conditionnelle du risque de l'oracle. Le programme ne les établit pas empiriquement.
- **No-go** : ne pas fusionner ou présenter comme nouveauté avant relecture contradictoire et audit bibliographique.
