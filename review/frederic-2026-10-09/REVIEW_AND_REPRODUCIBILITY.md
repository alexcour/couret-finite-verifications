# Procédure de relecture indépendante pour Frédéric

## Ordre efficace
1. Lire les errata avant toute interprétation.
2. Examiner un résultat à la fois : énoncé exact, hypothèses, objet, version, degré de certification E, antériorité N, qualité Q, diffusion D.
3. Télécharger le commit ou la release liée, relever SHA/tag, Python/Lean et dépendances, exécuter les vérificateurs ; conserver stdout, stderr, code de sortie, temps et éventuel hash.
4. Pour Cayley SPEC-OBS, vérifier à partir d'un deuxième code indépendant les classes de spectra, les permutations VF2 et les histogrammes de motifs. Différencier supports distincts, orbites et classes d'isomorphisme.
5. Consulter les contre-exemples historiques et les travaux Brown, Mönius, Godsil, Weisfeiler–Leman, reconstruction k-deck, Rubinstein–Sarnak avant de conclure à la nouveauté.
6. Pour HOL-01 vérifier indépendamment 24, 1176, fibres 49, groupes 686. Pour 10A6/10C3/10B1 relire la preuve et les effets de conventions, sans extrapoler les jeux de tests.
7. Pour F-001 ne pas confondre proportions de classes premières, statistique de rigidité Δ3, et channel μ² (produit Euler ζ(2)).
8. Pour Lean inspecter #print axioms, le fichier exact compilé, les sorry textuels et tactiques, version mathlib et commit CI.
9. Rapporter chaque objection indépendamment, sans exiger d'accord sur tout le programme.

## Questions concrètes au rapporteur
- Un contre-exemple satisfait-il exactement les hypothèses ?
- L'algorithme compte-t-il supports ou classes non isomorphes ?
- Un résultat a-t-il un antécédent strict ou seulement partiel ?
- Le document CURRENT incorpore-t-il les corrections F-001, F-002... et SPEC-OBS-09 ?
- Quel est le plus petit énoncé autonome et intéressant pouvant être rendu public sans risque de surinterprétation ?
- Quels résultats devraient rester des notes, logiciels ou datasets et non des articles ?

## Ce que le pack n'est pas
Pas d'approbation demandée, pas de preuve de RH, pas d'unification, pas de certification d'exhaustivité de Drive, pas d'accès à FCI brevet/PI ni aux dépôts privés.

## Contacts et retours
Les objections peuvent être déposées sur les dépôts GitHub publics (issue ou PR) ou communiquées directement à l'auteur. Ne pas publier de références aux dépôts privés ou liens Drive restreints dans les issues publiques.
