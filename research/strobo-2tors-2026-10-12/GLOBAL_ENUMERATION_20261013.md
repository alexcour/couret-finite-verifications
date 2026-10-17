# STROBO — Dénombrement global des fibres avec zéro autorisé

13 octobre 2026. Démonstration rédigée en interne et compilation locale dans Lean/mathlib v4.29.1. Le commit contenant ce document doit recevoir ses propres résultats CI. Aucune validation mathématique indépendante ni revendication de nouveauté. PR #25 maintenue en DRAFT, sans fusion.

Complément ultérieur : `EXCEPTIONAL_ZERO_FREE_20261013.md` compile aussi les nombres de restrictions exceptionnelles de tailles 2h−2 et 2h, leur non-vacuité, l'injectivité de la restriction et le critère d'atteinte de 2h dans cette classe. Les histogrammes ordinaires sans zéro et l'agrégation complète restent ouverts.

## Hypothèses et objets réellement comptés

G est un groupe abélien fini, avec `AddCommGroup G`, `DecidableEq G`, `Fintype G`. Les supports sont tous les Finsets de cardinal exactement trois, y compris ceux contenant zéro. Leur invariant est le carré de convolution ordonnée ÉTIQUETÉ, défini par les neuf paires ordonnées, diagonales incluses. Il ne s'agit pas d'un carré modulo translation ou automorphisme.

Posons n=|G|, H=G[2], h=|H|, K=G[3], t=|K|. Le nouveau module `Strobo2TorsEnumeration.lean` importe les deux modules de classification et de cardinalité. Il définit :

* `exceptionalParams` : G × (H privé de zéro) × (K privé de zéro).
* `paramSupport ((a,d),v)` : {a,a+v,a+v+d}.
* `exceptionalSupports` : les supports de cardinal trois dont la fibre RÉELLE `squareFibre` a cardinal 2h.
* `exceptionalFibres` : l'image de ces supports par S ↦ `squareFibre S` ; deux supports de même fibre ne sont donc comptés qu'une fois.
* `doublingImages` : l'image effective de G par a ↦ 2a ; q est son cardinal.
* `threeSignPairs` : les paires {v,−v} avec v dans K non nul ; r₃ est leur nombre.
* `tripleSupports`, `allSquareFibres`, `ordinaryFibres` : tous les supports de cardinal trois, leurs fibres réelles distinctes, puis celles de taille h.

Mathématiquement q=|G/H|=n/h et r₃=(t−1)/2 est le nombre de sous-groupes d'ordre trois. Lean prouve ici les égalités numériques et compte les images de doublement et les paires de signes. Ce module ne construit pas un quotient `AddSubgroup`, ni un type de sous-groupes cycliques pour identifier ces objets. Cette distinction n'affecte pas les formules numériques compilées.

## Démonstration rédigée

**Normalisation sans perdre les différences d'ordre six.** Toute exception possède une représentation authentique S={a,b,b+d}, où d est non nul dans H, 2a≠2b et 3(b−a) appartient à {0,d}. Si 3(b−a)=0, prendre v=b−a. Sinon prendre v=b−a+d ; alors 3v=d+3d=0. Le changement échange les deux membres du doublet et conserve S. Dans les deux cas v est non nul : v=0 imposerait 2a=2b. Inversement tout paramètre a,d,v admissible produit un support authentique de cardinal trois et satisfait la condition exceptionnelle. La restriction v dans G[3] est donc une NORMALISATION, pas une suppression des cas où le b−a initial a ordre six.

**Unicité des paramètres bruts.** Dans un support authentique apparié, le singleton a est l'unique point dont la fibre du doublement dans S a taille un. Il est donc récupéré comme point de G. Les deux autres points déterminent leur différence d, qui ne dépend pas de leur ordre car d=−d. Si les deux choix de v possibles étaient v et v+d, tous deux annulés par trois, on aurait 3d=d=0, contradiction. Ainsi S détermine exactement un triplet (a,d,v). Cela prouve une bijection avec G × (H privé de zéro) × (K privé de zéro), et donc

\[
\#\{\text{supports exceptionnels}\}=n(h-1)(t-1).
\]

**Passage aux fibres.** La classification et le module de cardinalité donnent taille 2h pour chaque fibre exceptionnelle. Si S et T ont le même carré, leurs fibres réelles sont égales. Réciproquement la préimage d'une fibre exceptionnelle F par S ↦ `squareFibre S`, restreinte aux supports exceptionnels, est exactement F. En sommant ces préimages disjointes, avec E le nombre de fibres exceptionnelles :

\[
2hE=n(h-1)(t-1).
\]

**Facteurs q et r₃.** Chaque préimage du doublement est une translation de H : 2x=2a si et seulement si x−a appartient à H. Elle a h éléments, d'où n=hq. Pour v dans K non nul, v≠−v, puisque 2v=3v=0 impliquerait v=0. Les paires {v,−v} partitionnent K privé de zéro en blocs de deux, d'où t−1=2r₃. En substituant et en annulant le facteur positif 2h :

\[
\boxed{E=q(h-1)r_3=\frac{n}{h}(h-1)\frac{t-1}{2}.}
\]

**Fibres ordinaires.** Toutes les fibres ont taille h ou 2h, et h>0 distingue les deux classes. La préimage de toute fibre par l'application S ↦ `squareFibre S` est cette fibre. Le nombre total de supports est C(n,3). Si O est le nombre de fibres ordinaires, la partition donne C(n,3)=h(O+2E), donc

\[
\boxed{O=\frac{\binom n3}{h}-2q(h-1)r_3.}
\]

Dans Lean les divisions et soustractions sont naturelles. Les identités pondérées prouvent la divisibilité exacte et que la soustraction ne tronque aucune quantité négative. Les cas n<3, h=1 ou t=1 sont inclus sans hypothèse supplémentaire.

## Résultats compilés et limites

| Déclaration Lean | Résultat exact |
|---|---|
| `exceptional_difference_normalization` | Passage de 3(b−a) dans {0,d} à un v non nul annulé par trois, support conservé |
| `paramSupport_parameters_unique` | Égalité de deux supports admissibles implique égalité de a, d et v |
| `exceptionalSupports_eq_params_image` | Tous les supports exceptionnels réels, et eux seuls, sont paramétrés |
| `exceptionalSupports_card` | Cardinal des supports exceptionnels =n(h−1)(t−1) |
| `exceptionalFibres_preimage` | Préimage d'une fibre exceptionnelle réelle = cette fibre |
| `exceptionalFibres_weighted_card` | 2hE=n(h−1)(t−1) |
| `group_card_eq_h_mul_doublingImages` | n=hq pour q cardinal de l'image réelle du doublement |
| `threeTorsion_nonzero_card_eq_two_pairs` | t−1=2r₃ pour les paires de signes réelles |
| `exceptionalFibres_card_product`, `exceptionalFibres_card_numeric` | E=q(h−1)r₃ et sa formule en n,h,t |
| `tripleSupports_weighted_card` | C(n,3)=h(O+2E) |
| `ordinaryFibres_card`, `ordinaryFibres_card_numeric` | O=C(n,3)/h−2E et sa formule en n,h,t |

Le build local des trois modules réussit. Les dix nouveaux contrôles `#print axioms` affichent seulement `propext`, `Classical.choice`, `Quot.sound`. Aucun trou de preuve ni hypothèse personnalisée de preuve n'est ajouté. La CI scanne maintenant les trois sources et construit la bibliothèque Lake contenant les trois modules.

## Expérimentation finie reproductible

Les deux vérificateurs passent toujours sur 43 groupes et 252 084 supports. Le second conserve 172 912 comparaisons de reconstruction et 42 648 restrictions directes h−j par orbite. Il énumère maintenant séparément les paramètres bruts (a,d,v), sans utiliser les formules pour construire les fibres, puis confronte leur image aux regroupements obtenus par calcul direct des neuf sommes ordonnées.

Sur l'ensemble du corpus, les 8 664 paramètres produisent 8 664 supports distincts et exactement les 708 fibres exceptionnelles observées ; toutes leurs préimages coïncident avec les membres effectivement calculés des fibres. Le JSON déterministe enregistre `exceptional_parameters` et `parametrized_exceptional_fibres`. Les cas d'ordre six et les contre-exemples précédents restent conservés. Cette comparaison constitue une expérimentation interne bornée, pas une validation mathématique indépendante.

Depuis `research/strobo-2tors-2026-10-12/lean` :

```sh
lake resolve-deps
lake exe cache get
lake build
```

Depuis la racine du dépôt :

```sh
python research/strobo-2tors-2026-10-12/verify_strobo_2tors.py
python research/strobo-2tors-2026-10-12/verify_remaining_profiles_20261013.py
```

## Obligations restantes

Le complément ultérieur `EXCEPTIONAL_ZERO_FREE_20261013.md` compile la contribution exceptionnelle à l'histogramme sans zéro et son critère d'atteinte de 2h. Les histogrammes ordinaires sans zéro, leur agrégation avec cette contribution, le tableau complet des maxima et les comptes séparés par profil/paires restent à formaliser. La présente formule globale compte tous les supports avec zéro autorisé.

La relecture mathématique indépendante, l'audit des définitions et de la littérature restent ouverts. La compilation et les vérificateurs internes ne remplacent pas cette relecture. Aucune fusion ni publication stable.

Source : https://github.com/alexcour/couret-finite-verifications/pull/25
