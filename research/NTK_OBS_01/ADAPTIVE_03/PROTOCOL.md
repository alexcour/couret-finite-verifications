# NTK-OBS-03 — Protocole reproductible gelé au moment de l'archive

Date : 2026-10-11. **Exemples construits pendant l'étude : ni préenregistrement prospectif, ni échantillon aveugle.**

## Périmètre

- Quatre modèles **connus** `A,B,C,D`, chacun exactement deux atomes `(q,w)` rationnels strictement positifs ; supports dans `(0,1)`.
- Temps de requête limités à `{0,1,2}` ; décisions strictement chronologiques.
- Observation `m_t=2L[t]`, bruit adversarial déterministe `|y_t-m_t|<=epsilon`, répétition ne diminuant pas la borne.
- Objectif : identifier sans erreur l'un des quatre modèles **pour tout** transcript admissible, ou renvoyer `NON CERTIFIÉ`.
- Coût `J=N+T_fin/4`, aucune facturation réelle ou préparation mesurée. Le code balaye aussi `c_wait ∈ {0,1/4,1,3}`.

## Exécution (Python >=3.9, stdlib seulement)

```sh
sh verify.sh
```

Le wrapper contrôle SHA-256 avant/après, régénère le JSON exact, exécute un second audit rationnel de conception indépendante. Une différence -> `HALT`, ne pas publier de prétention de vérification. Le ZIP est autosuffisant et ses entrées ont des horodatages constants.

## Contrôles obligatoires

1. Calcul exact des moments `m0,m1,m2` pour A/B/C/D et vérification des poids/nœuds.
2. Démonstration par paires que chacune des sous-familles fixes `{0,1}`, `{0,2}`, `{1,2}` est insuffisante.
3. Examen exact des intervalles de bruit, bornes comprises, via tous les événements `m_i(t) ± epsilon` et points médians des cellules de la droite réelle.
4. Programmation dynamique de coût minimax pour les politiques adaptatives avec abstention si identification impossible.
5. Certification `J_ad=5/2`, `J_fix=7/2`, propriété « masse 1/3 » à coût `1`.
6. Témoin adversarial exact `y=(1,6/13,5/16)` compatible avec A et B au seuil `epsilon=1/26`.
7. Calcul des six rayons de bruit gelés `{0,1/100,1/30,1/26-1/1000,1/26,1/20}`.
8. Vérification de 36 transcripts adversariaux sur `{−epsilon,0,+epsilon}²` ; ce balayage **ne remplace pas** la preuve pour tout bruit.
9. Égalités des coûts en fonction de quatre poids temporels `c_wait` ; comparaison moyenne uniquement sous convention uniforme explicite.
10. SHA-256 et JSON canonique exactement reproductibles, aucun appel réseau, aucune dépendance flottante.

## Limites

Les méthodes vérifient **une seule famille finie construite**, non les noyaux généraux ou les stratégies adaptatives avec observation à temps arbitraire. Le choix de coûts est illustratif. Les vérifications locales ne sont pas une validation externe. Conserver la branche en revue et ne pas fusionner vers la branche principale automatiquement.
