# MOD-OBS-03 — Liste des questions de relecture

Statut au 11 octobre 2026 : toutes les preuves et tous les programmes restent des productions internes, aucune revue indépendante extérieure.

## Porte E — validité des preuves

1. Vérifier l'expansion de `(X^(b+sigma*h)+X^a(1+X^h))^3` avec `X^(2h)=1` et comparer les coefficients à `3b`, `3b+d`.
2. Vérifier que les quatre supports exceptionnels sont distincts pour tout `d>=1`, et que leurs carrés concordent.
3. Vérifier qu'aucun coefficient cubique isolé ne distingue les quatre supports, et que le couple affiché les distingue.
4. Distinguer preuve sur *la famille explicite* et *classification de toutes les fibres* — cette dernière est l'obligation ouverte STROBO-C3.
5. Contrôler les conditions des bornes minimax quand le carré est supposé gratuitement acquis.

## Porte Q — reproductibilité

1. Exécuter les deux programmes depuis un checkout neuf sous Python standard.
2. Comparer les 399 fibres, les 444 paires et les minima `90/24/0` de la banque OBS-SEQ F3.
3. Comparer les 316 fibres certifiées sans sonde et les 83 nécessitant `Tr(A³)` pour la connexité forte.
4. Contrôler les cas limites `n=6`, `12`, `18`, avec et sans zéro ; contrôler les six classes de la famille à `n=12` si nécessaire.
5. Contrôler les empreintes SHA-256 avant toute modification des résultats.

## Porte N — littérature

1. Théorèmes existants sur les mêmes fonctions de représentation ordonnées dans les groupes cycliques.
2. Résultats existants sur les sondes cubiques et l'identification de circulantes à partir d'A².
3. Exact learning / decision trees avec entrée partiellement révélée et modèle d'interrogations scalaires.
4. Aucune revendication de priorité avant comparaison de théorèmes, hypothèses, coûts et univers.

## Porte R — contrôle extérieur

Demander à un lecteur externe de choisir ses propres contre-exemples et de vérifier les implications. Le second script écrit dans le même contexte ne remplace pas cette revue. Toute erreur doit être inscrite explicitement au registre ; ne pas réécrire silencieusement les archives antérieures.