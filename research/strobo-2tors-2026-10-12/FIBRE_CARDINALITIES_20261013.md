# STROBO — Cardinalités des fibres et exclusion de zéro

13 octobre 2026. Preuves rédigées en interne et compilation locale Lean/mathlib 4.29.1. Le résultat CI du commit contenant ce document doit être lu séparément. Aucune relecture mathématique indépendante, nouveauté ou priorité revendiquée. PR #25 en DRAFT, sans fusion.

## Définitions et hypothèses exactes

G est maintenant un groupe abélien FINI, avec instances Lean `AddCommGroup G`, `DecidableEq G` et `Fintype G`. S est un Finset de cardinal exactement trois. Les coefficients du carré sont toujours les sommes étiquetées de toutes les paires ordonnées, diagonales incluses, définies par `orderedSquare`.

Le nouveau module `Strobo2TorsCardinality.lean` importe la classification compilée dans `Strobo2TorsCore.lean`. Il définit réellement les ensembles finis à compter :

* `twoTorsion` : l'ensemble H={u dans G : u+u=0} ; h est son cardinal.
* `torsionOrbit S` : l'image de H par u ↦ S+u.
* `squareFibre S` : les sous-ensembles T de G de cardinal trois dont TOUS les coefficients de carré ordonné sont égaux à ceux de S. Il s'agit d'un filtre du powerset de G, pas d'une liste de candidats postulée.
* `zeroFreeOrbit S` et `zeroFreeSquareFibre S` : les restrictions des ensembles précédents aux supports ne contenant pas zéro.

L'hypothèse de finitude porte sur G pour ces dénombrements. La classification précédente des supports reste valable sans cette hypothèse. La cardinalité trois est essentielle pour la liberté de l'action de H.

## Résultats de cardinalité compilés

| Théorème Lean | Résultat exact |
|---|---|
| `torsionOrbit_card` | Chaque orbite d'un support de cardinal trois a exactement h membres |
| `paired_squareFibre_eq` | Une fibre de profil (1,2) est l'orbite du support ; si 3(b−a) est 0 ou d, elle est l'union de cette orbite et de celle du reflet fixé R={a,2b−a,2b−a+d} |
| `paired_orbits_disjoint` | Ces deux orbites sont disjointes sous le profil authentique |
| `paired_squareFibre_card` | La fibre appariée a taille 2h si la condition exceptionnelle est vraie, et h sinon |
| `squareFibre_card_h_or_two_h` | Pour TOUT support S de cardinal trois, sa fibre de carrés a taille h ou 2h |
| `squareFibre_card_le_two_h` | Borne globale compilée : cardinal de la fibre ≤2h |
| `squareFibre_card_two_h_iff_exception` | Cardinal de la fibre =2h si et seulement s'il existe un partenaire exceptionnel au sens exact de la classification |
| `zeroFreeOrbit_card` | Exclure zéro d'une orbite laisse h−j supports, avec j=card(S∩H) |
| `zeroFreeSquareFibre_card_of_no_exception` | Même formule h−j pour une fibre sans partenaire exceptionnel |
| `paired_zeroFreeSquareFibre_card` | Dans une fibre appariée exceptionnelle, le cardinal sans zéro est (h−j_S)+(h−j_R) ; sinon il est h−j_S |

Les tailles h ou 2h et la borne 2h sont ainsi des théorèmes de cardinalité, et non plus seulement des conséquences rédigées de la classification ou des histogrammes expérimentaux. Le critère d'exception conserve les différences d'ordre six.

## Démonstration rédigée du raccordement

**Liberté et cardinal de l'orbite.** Une translation u de H fixant un triplet a nécessairement u=0, par le lemme déjà compilé sur la somme des trois éléments. Si S+u=S+v, translater les deux côtés par v donne S+(u+v)=S, puisque 2v=0. La liberté force u+v=0, puis u=v. L'application H→orbite est donc injective ; son image a cardinal h.

**Unicité du reflet fixé.** La classification finale présentait le partenaire exceptionnel par des témoins existentiels. Pour dénombrer une fibre, il faut une conclusion plus précise : tous les partenaires non ordinaires d'une représentation FIXÉE S={a,b,b+d} appartiennent à l'orbite du MÊME reflet R. `paired_partner_fixed_source` conserve cette représentation à travers l'alignement des singletons et l'inversion de la translation. Les échanges des deux membres du doublet n'ajoutent pas de nouvelle orbite.

**Validité du reflet.** Si v=b−a et 3v appartient à {0,d}, alors 6v=0. Supposer 2a=2(2b−a) donnerait 4v=0, donc 2v=0, contredisant 2a≠2b. Le reflet est ainsi un véritable triplet apparié ; son orbite a elle aussi cardinal h. Ce point est dérivé, pas ajouté comme hypothèse.

**Exhaustivité.** Les profils (1,1,1) et (3) n'admettent aucun partenaire exceptionnel. Leurs fibres sont exactement une orbite. Dans (1,2), tous les partenaires sont dans l'orbite de S, ou, sous la condition exceptionnelle, dans celle de R. La preuve antérieure de non-translation de H assure la disjonction. Le cardinal est donc h ou h+h=2h. H contient zéro, donc h>0 ; la taille 2h distingue effectivement la présence d'une exception.

**Sans zéro.** Pour u dans H, 0 appartient à S+u si et seulement si u appartient à S : x+u=0 implique x=u, puisque −u=u. Les translations interdites sont exactement S∩H. L'injectivité de l'application des translations permet de compter la restriction : h−card(S∩H). Les restrictions des deux orbites exceptionnelles restent disjointes, et leurs tailles s'additionnent. Une restriction de taille zéro est possible ; elle ne doit pas être réintroduite comme fibre non vide dans les histogrammes.

## Rejeu fini et compilation

Le build par défaut `lake build` compile désormais les deux modules via une bibliothèque Lake déclarée dans `lakefile.lean`. Le workflow rejoue les deux scripts Python, vérifie la stabilité du JSON, scanne les deux sources pour les trous de preuve et déclarations personnalisées, puis construit les deux modules dans l'environnement verrouillé.

Les huit contrôles `#print axioms` du module de cardinalité ne montrent que `propext`, `Classical.choice`, `Quot.sound`. Aucun trou de preuve ni hypothèse de preuve personnalisée n'est introduit.

Le second vérificateur conserve le corpus de 43 groupes / 252 084 supports et les 172 912 comparaisons de reconstruction. Il contrôle maintenant directement h−j pour CHAQUE orbite observée, y compris la seconde orbite de toute fibre exceptionnelle ; le nombre de contrôles est enregistré dans `orbit_restriction_checks` du JSON déterministe. Cela reste une expérimentation interne bornée, distincte de la preuve Lean et d'une validation indépendante.

Reproduction depuis `research/strobo-2tors-2026-10-12/lean` :

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

## Ce qui reste ouvert

Les nombres GLOBAUX de fibres, notamment F_{2h}=q(h−1)r₃ et F_h=C(|G|,3)/h−2q(h−1)r₃, ne sont pas encore des théorèmes Lean. Restent la paramétrisation des familles exceptionnelles par le quotient G/H, les directions non nulles de H et les sous-groupes d'ordre trois ; le dénombrement des paramètres ; les histogrammes globaux sans zéro ; les critères d'atteinte du maximum. La nouvelle formule sans zéro par deux orbites ne certifie pas, à elle seule, toutes les formules agrégées déjà rédigées.

La validation mathématique indépendante et l'audit de nouveauté restent également ouverts. Aucune fusion ni publication stable n'est autorisée par cette progression.

Source : https://github.com/alexcour/couret-finite-verifications/pull/25
