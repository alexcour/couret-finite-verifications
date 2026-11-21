# MOD-OBS-03 (11 octobre 2026)

**Question :** lorsque le carré exact d'un graphe de Cayley cyclique triple est déjà connu, combien de sondes scalaires supplémentaires identifient son support ? Combien en faut-il pour une seule propriété (connexité forte) ?

## Reproduction (Python 3.10+, standard library)

Avant toute régénération, vérifier l'archive ZIP et `SHA256SUMS`.

```bash
sha256sum -c SHA256SUMS
python audit_mod_obs_03.py --max-n 60 --max-d 130 --out replay.json
python verify_alt.py
python - <<'PY'
import json
A=json.load(open('results.json'))
B=json.load(open('replay.json'))
assert A==B
print('PASS: exact byte-independent replay of all recorded fields')
PY
```

`audit_mod_obs_03.py` utilise les termes diagonaux et les doubles termes croisés pour construire les carrés. `verify_alt.py` utilise des produits de convolution ordonnés, sans importer le programme primaire. Tous les tests sont **internes** ; une relecture externe reste nécessaire.

## Statut

- Preuve explicite des deux coefficients cubiques : interne, non évaluée par un relecteur externe.
- 112 balayages jusqu'à n=60 : vérifications entières finies.
- 25 545 quadruplets exceptionnels jusqu'à n=780 : tests entiers bornés.
- n=18 : banque universelle 3 sondes, choix informé par la fibre 2 ; connexité forte 0 ou 1.
- Publication/antériorité : **non autorisées à ce stade**. Aucun calcul supplémentaire sur les nombres premiers.