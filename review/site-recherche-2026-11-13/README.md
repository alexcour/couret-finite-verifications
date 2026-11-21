# Premier lot pour le site et la recherche

Ce lot fournit un bloc scientifique HTML statique, un menu proposé et les pièces du recalcul exact des triplets. Statut : préparé, non installé dans WordPress. Aucun résultat général nouveau, compilation Lean ou relecture humaine indépendante n’est revendiqué.

## Vérifier et générer

Depuis la racine du dépôt, avec Python 3.12 et sa bibliothèque standard :

```sh
cd review/site-recherche-2026-11-13
python3 verification_triplets.py --max-order 36 --output /tmp/couret-triplets.json
cmp /tmp/couret-triplets.json resultats_triplets.json
python3 -m unittest test_build.py
python3 build.py
```

Le reçu enregistre la version de Python. Si elle diffère, comparer les résultats après avoir écarté uniquement ce champ. Le script et le reçu sont liés à leur commit commun, enregistré dans evidence_revision.

Le premier script énumère les groupes et les collisions ; le second contrôle le reçu et génère wordpress-science.html. Le contrôle de cohérence du reçu ne remplace pas son recalcul.

## Intégration WordPress

1. Préserver une révision des pages concernées.
2. Insérer wordpress-science.html dans un bloc HTML personnalisé de la page STROBO. Le fragment adopte les styles du thème et ne contient pas de JavaScript. Relier la page Cayley à cette explication commune.
3. Vérifier les destinations de registry.json par réponse HTTP ET lecture du contenu avant d’activer le menu. Le registre décrit des cibles proposées. Le générateur produit uniquement le bloc scientifique HTML. Il ne génère ni n’active de menu et ne teste aucune réponse HTTP. Conserver les anciennes URL pendant ce premier lot.
4. Vérifier les tableaux, les accents, les liens et les commandes au clavier, sur mobile et sans JavaScript. Le rendu visuel dans le thème WordPress reste à tester.
5. Relire les réponses publiques après sauvegarde et conserver URL, révision, date et résultat. Un commit du dépôt n’atteste pas une mise en ligne WordPress.

## Critères de réception

- Menu commun aux pages actuelles, sans entrée vide.
- Les deux exemples restent lisibles sans JavaScript.
- Le nombre 190930 est toujours associé aux deux supports excluant zéro.
- Égalité des carrés d’adjacence, cospectralité et isomorphisme demeurent distincts.
- Retour arrière possible par restauration de la révision CMS.

## Recherche ciblée

Raccorder l’annexe A de l’audit aux énoncés Lean compilés, hypothèse par hypothèse, puis comparer la classification à la littérature. Lev (2004), page 5, donne déjà les signes de Fourier et les translations d’ordre 2 : https://doi.org/10.37236/1831 . La nouveauté reste à établir. Le recalcul ne traite pas les supports de cardinal quatre ou davantage.

## Sources

Plan Site Recherche du 13 novembre 2026 ; audit fourni par Alexandre Couret ; matrice existante : review/site-couret-2026-10-11/SITE_CORRECTIONS_APPROVED_2026-10-14.md. Les textes proposés utilisent les exemples publics et le recalcul interne. Aucun accès CMS ni déploiement n’est inclus.

## Rejeu du 18 novembre 2026

Sous Python 3.12.14, le recalcul à l’ordre 36, la comparaison octet par octet du reçu, les tests du générateur et la génération du HTML sont sortis avec le code 0. Le test sous `python3 -O` a été refusé avec le code 1, avant tout reçu. Les huit cas de mutation du reçu sont refusés.

| Pièce | SHA-256 |
| --- | --- |
| Script d’énumération | `b8341c3d1206b2a450b48fe9df56fed01da460757e62f851c49bad8881ecc2b5` |
| Reçu JSON | `9c81fdb6c1ca6d19ed78c14165e706203fb14e9cfc8b8af47cc3b64aa9bd735b` |
| Fragment généré | `7d7167e1b3838dfb06bc8b283c238ee1e271d2dac4b87888466a702756ee8b2c` |

La recette visuelle et clavier dans le thème, la vérification HTTP complète du menu et le contrôle après sauvegarde WordPress restent à effectuer.
