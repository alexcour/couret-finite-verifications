# Audit 05 — Gate de revue

- **Q — contrôle fini** : `audit05.py` balaye exhaustivement 112 cas `n=5..60` (zéro autorisé/interdit), **1 009 484** triples. `verify_independent.py` recalcule 92 cas `n=5..50` avec une expansion algébrique différente. Les résultats concordent dans le domaine commun. 975 quadruples exceptionnels contrôlés séparément pour leur signature cubique.
- **E1 — propriété connexe** : preuve interne du recensement Möbius et coût ciblé `0/1` rédigée ; ne nécessite pas STROBO-C3 exhaustive ; à relire.
- **E2 — histogrammes de toutes les fibres** : démonstration interne conditionnée par la classification générale STROBO-C3 ; gate de cette classification non fermé.
- **Q2 — banque fixe** : recherche exhaustive des meilleurs ensembles de coordonnées cubiques pour `n=6,10,14,18,22,26,30` en univers NZ/Z ; certificats de couverture et tests de non-existence à coût inférieur stockés dans `INDEPENDENT_RESULTS.json`.
- **N — nouveauté** : NON ÉTABLIE ; fondations de fonctions de représentation, dénombrement et requêtes déjà étudiées dans la littérature.
- **R — relecture humaine indépendante** : NON EFFECTUÉE pour cet audit.
- **F — publication** : ne pas fusionner, ne pas étiqueter de publication stable, ne pas annoncer d'antériorité ou d'approbation externe.

## Questions de relecteur prioritaires

1. Est-il correct que `A²` décide tous les obstacles premiers impairs et que toute fibre de connexité ambiguë pour `n=2h`, `h` impair, consiste exactement en un support pair et sa demi-translation impaire ? Vérifier l'argument `mod 2`.
2. Les sommes de Möbius comptent-elles exactement les fibres (ni supports, ni paires de graphes modulo isomorphisme) lorsque zéro est autorisé ou interdit ?
3. L'interrogation `K_3(3s)` reste-t-elle bien une lecture scalaire **ciblée après** connaissance de `A²`, et non un oracle qui livre le support gratuitement ?
4. Pour `n=22`, vérifier la recherche exhaustive de couverture **dans la banque des coefficients de la première ligne de A³** (NZ : 3, Z : 4), et la symétrie qui remplace toute coordonnée impaire par une paire.
5. Valider indépendamment la classification générale STROBO-C3, le traitement de zéro et les histogrammes simples/doubles/quadruples ; ne pas accepter le scan comme preuve universelle.
6. Identifier les théorèmes antérieurs exacts, notamment sur les fonctions de représentation **ordonnées** de supports de cardinal 3 et la complexité des sondes spécifiques au Cayley.
