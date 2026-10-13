# STROBO — Assemblage sur les supports de cardinal trois

Jalon historique d'assemblage. Les compléments ultérieurs `FIBRE_CARDINALITIES_20261013.md` et `GLOBAL_ENUMERATION_20261013.md` clôturent également les cardinalités d'orbites, les tailles h/2h, la borne 2h, la restriction par orbite h−j et les nombres globaux de fibres ordinaires/exceptionnelles avec zéro autorisé. Les obligations ci-dessous désignant ces résultats comme futurs décrivent ce jalon antérieur ; les histogrammes agrégés sans zéro et la validation indépendante restent ouverts.

13 octobre 2026. Preuve rédigée en interne ; théorèmes Lean compilés localement avec Lean/mathlib 4.29.1. Le succès CI doit être vérifié sur le commit contenant ce fichier. Aucune relecture mathématique indépendante ni revendication de nouveauté. PR #25 conservée en DRAFT, sans fusion.

## Objet exact et hypothèses

G est un groupe abélien muni d'une égalité décidable. S et T sont des Finsets de G et ont chacun cardinal trois. Aucune finitude de G, aucun profil de doublement, aucune numérotation des éléments et aucun alignement des singletons ne sont supposés.

L'invariant formalisé est le coefficient étiqueté du carré de convolution ordonnée :

R_S(z) = somme sur x dans S et y dans S de 1_{x+y=z}.

Le terme Lean `orderedSquare S z` calcule cette double somme finie à valeurs naturelles. Chaque paire ordonnée, y compris (x,x), contribue. `orderedSquare_three` démontre son égalité avec l'expansion à neuf paires utilisée par les lemmes antérieurs, sous distinction des trois éléments. Il ne s'agit ni d'une autocorrélation ni d'un spectre non étiqueté.

Écrire H={u: u+u=0} et `translateSupport S u = S.image (fun x => x+u)`.

## Énoncé exact maintenant assemblé

`orderedSquare_classification_iff` démontre :

R_S(z)=R_T(z) pour tout z de G si et seulement si l'une des alternatives suivantes existe :

1. **Ordinaire** : un u dans H tel que T=S+u.
2. **Exceptionnelle** : a,b,d,u dans G tels que
   - 2d=0 et d est non nul ;
   - 2a est différent de 2b ;
   - 2u=0 ;
   - 3(b-a)=0 ou 3(b-a)=d ;
   - S={a,b,b+d} ;
   - T={a,2b-a,2b-a+d}+u.

Ces conditions sont exactement les prédicats `OrdinaryPartner` et `ExceptionalPartner`, pas des hypothèses de profil laissées à fournir au théorème final. La cardinalité trois des deux supports reste une hypothèse essentielle. L'alternative exceptionnelle conserve les différences d'ordre six.

`exceptionalPartner_not_ordinaryPartner` démontre que les deux alternatives sont disjointes. `exceptionalPartner_not_any_translation` démontre, sous les cardinalités trois, qu'un partenaire exceptionnel ne peut être obtenu par aucune translation de G, même hors de H.

## Preuve et raccordements

1. `Finset.card_eq_three` fournit trois éléments distincts pour chaque support.
2. `card_three_doubling_shapes` examine toutes les égalités entre leurs doubles. Il produit l'un des trois profils, avec permutation et écriture du doublet {b,b+d} dérivées, sans normalisation postulée.
3. `explicit_square_eq_of_orderedSquare_eq` traduit l'égalité du véritable comptage fini en égalité des expansions déjà compilées. La distinction des éléments est dérivée de la cardinalité trois.
4. Les neuf comparaisons de profils sont traitées :

| Profil de S / profil de T | (1,1,1) | (3) | (1,2) |
|---|---|---|---|
| (1,1,1) | Translation dans H | Impossible par parité | Impossible par parité |
| (3) | Impossible par parité | Translation dans H | Impossible par support dans une seule classe de H |
| (1,2) | Impossible par parité | Impossible par support dans une seule classe de H | Translation dans H ou partenaire exceptionnel |

5. Dans la dernière case, `paired_square_classification_after_normalization` dérive l'alignement du singleton. `paired_orderedSquare_partner` inverse ensuite cette translation et reconstruit les supports, y compris les échanges des deux membres du doublet.
6. Cela donne `orderedSquare_classification_necessary`. Pour la réciproque, `orderedSquare_eq_of_ordinaryPartner` utilise l'invariance des neuf sommes sous H ; `orderedSquare_eq_of_exceptionalPartner` combine le lemme de réflexion exceptionnelle avec cette invariance. La représentation du support cible est confrontée à sa cardinalité trois avant application de l'expansion.
7. Pour exclure une translation entre partenaires exceptionnels, une translation de H serait incompatible avec les doubles du doublet, sauf si 2a=2b, interdit. Pour une translation quelconque v de G, la parité des carrés égaux impose 2(a+v)=2a, donc 2v=0. Elle se ramène au cas déjà exclu.

## Vérification et frontière

La compilation locale réussit pour le fichier entier et ses déclarations antérieures. Les contrôles `#print axioms` de la classification finale et de la non-translation exceptionnelle ne montrent que les dépendances standards `propext`, `Classical.choice`, `Quot.sound`. Aucun trou de preuve ni hypothèse de preuve personnalisée n'est introduit.

Le workflow existant compile le fichier complet dans l'environnement verrouillé et rejoue les deux vérificateurs sur 43 groupes / 252 084 supports. Cette borne expérimentale ne restreint pas le théorème Lean, qui est quantifié sur G, S et T sous les hypothèses ci-dessus. Inversement, le théorème ne transforme pas les histogrammes expérimentaux en preuves de cardinalité.

Restent à formaliser :

* cardinalités des orbites de H dans un groupe fini ;
* tailles h ou 2h des fibres et unicité/paramétrisation des fibres exceptionnelles au niveau des dénombrements ;
* formules de comptage et restrictions excluant zéro ;
* audit mathématique indépendant et état de l'art.

Le nouvel assemblage clôt l'obligation de classification des supports et de raccordement des profils. Il ne clôt ni la preuve Lean des dénombrements, ni la validation indépendante, ni une autorisation de fusion ou de publication stable.

## Reproduction

Depuis `research/strobo-2tors-2026-10-12/lean` :

```sh
lake resolve-deps
lake exe cache get
lake env lean Strobo2TorsCore.lean
```

Depuis la racine du dépôt :

```sh
python research/strobo-2tors-2026-10-12/verify_strobo_2tors.py
python research/strobo-2tors-2026-10-12/verify_remaining_profiles_20261013.py
```

Source de travail : https://github.com/alexcour/couret-finite-verifications/pull/25
