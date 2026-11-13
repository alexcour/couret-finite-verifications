# Premier lot pour le site et la recherche

Ce lot fournit un bloc scientifique HTML statique, un menu proposé et les pièces du recalcul exact des triplets. Statut : préparé, non installé dans WordPress. Aucun résultat général nouveau, compilation Lean ou relecture humaine indépendante n’est revendiqué.

## Vérifier et générer

Avec Python 3.12, sans dépendance :

```sh
python3 verification_triplets.py --max-order 36 --output resultats_triplets.json
python3 build.py
```

Le premier script énumère les groupes et les collisions ; le second contrôle le reçu et génère wordpress-science.html. Le contrôle de cohérence du reçu ne remplace pas son recalcul.

## Intégration WordPress

1. Préserver une révision des pages concernées.
2. Insérer wordpress-science.html dans un bloc HTML personnalisé de la page STROBO. Le fragment adopte les styles du thème et ne contient pas de JavaScript. Relier la page Cayley à cette explication commune.
3. Vérifier les sept destinations de registry.json par réponse HTTP ET lecture du contenu avant d’activer le menu. Les cibles sont proposées ; aucune validité HTTP n’est attestée par le générateur. Conserver les anciennes URL pendant ce premier lot.
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
