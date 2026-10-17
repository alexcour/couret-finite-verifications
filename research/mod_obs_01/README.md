# MOD-OBS-01 — cout des questions pour graphes de Cayley cycliques

**11 octobre 2026 | statut : audit interne + relecture contradictoire attendue | originalite non etablie**

## Objet

Comparer le nombre de questions d'appartenance requises pour reconstruire un support triple S a partir de A_S^2, selon que les questions sont (a) universelles et fixees avant lecture de A_S^2, ou (b) choisies en connaissance de A_S^2. Comparer les couts de determination de proprietes specifiques de S.

La note de preuve est `RAPPORT_SCIENTIFIQUE.md`. Les definitions, conventions et stop-rules figure dans `PROTOCOL_FREEZE.md`. Les scripts ne necessitent que Python 3.9+ et la bibliotheque standard.

## Reproduction exacte

```bash
python3 mod_obs_01.py --output results.json
python3 independent_audit.py
python3 -m unittest -v test_mod_obs_01
sh verify.sh
```

`verify.sh` valide les empreintes de l'archive, pas le fond mathematique. Reexecuter les programmes pour auditer les conclusions. Tous les nombres concernent des supports ETIQUETES et des matrices de marches sur un meme etiquetage, jamais des classes d'isomorphisme.

## Resultat borne et statut

Theoreme interne autonome : pour n pair >=6 et 0 exclu, cout minimal d'une liste fixe universelle = n/2 - 1 questions d'appartenance. La preuve ne depend pas de la classification candidate STROBO-C3. Les couts conditionnes par fibre (0,1,2) et les formules generales de comptage utilisent en revanche le theoreme candidat STROBO-C3 encore en audit. Les controles finis corroborent, mais ne sont pas une preuve de nouveaute.

## Doctrine

Aucune priorite scientifique revendiquee, aucun deploiement, aucune conclusion sur la verite generale ou la legitimite morale d'une reponse d'IA. Chaque extension exige protocole, controle externe et source primaire.