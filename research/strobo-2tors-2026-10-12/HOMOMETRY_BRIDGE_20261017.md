# STROBO : des carrés ordonnés à l'homométrie

Note technique du 17 octobre 2026. Résultat classique, explicité à la suite de
l'observation de W. Riley Casper du 15 octobre. Aucun résultat de priorité
scientifique n'est revendiqué.

## 1. Les deux observables

Soit G un groupe abélien fini et S une partie de G. On conserve exactement
l'observable `Couret.STROBO2TORS.orderedSquare` de `Strobo2TorsCore.lean` :

\[
R_S(z)=\#\{(x,y)\in S^2:x+y=z\}.
\]

On introduit séparément l'autocorrélation par différences, sans normalisation :

\[
C_S(t)=\#\{(x,y)\in S^2:x-y=t\}
       =\sum_{u\in G}1_S(u+t)1_S(u).
\]

Les paires sont ordonnées et les diagonales sont incluses dans les deux cas.
En particulier, C_S(0)=|S|. Il s'agit d'égalités de fonctions **étiquetées sur
le même groupe**, et non de leurs seuls supports, spectres de valeurs ou sommes
totales. Dire que S et T sont homométriques signifie ici C_S=C_T.

Pour un triplet de points distincts S={a,b,c}, la définition existante donne
R_S=tripleSquareCoeff(a,b,c), et

\[
C_S=3\delta_0+\delta_{a-b}+\delta_{b-a}
 +\delta_{a-c}+\delta_{c-a}+\delta_{b-c}+\delta_{c-b}.
\]

Cette somme conserve les multiplicités lorsque plusieurs différences
coïncident, notamment dans la 2-torsion.

## 2. Théorème général et preuve

**Théorème.** Pour toutes parties S,T d'un groupe abélien fini G,

\[
R_S=R_T\quad\Longrightarrow\quad C_S=C_T.
\]

Aucune hypothèse de cardinalité trois, d'absence de zéro, de parité de |G|,
ou de configuration exceptionnelle n'est nécessaire.

Pour un caractère complexe χ de G, utilisons la convention non normalisée

\[
P_S(\chi)=\sum_{s\in S}\chi(s),\qquad
\mathcal Ff(\chi)=\sum_{z\in G}f(z)\chi(z).
\]

C'est la convention du code. Elle diffère de certaines conventions usuelles
par le remplacement de χ par son conjugué ; cela ne change pas l'argument.

En échangeant des sommes finies et en utilisant la multiplicativité de χ :

\[
\mathcal FR_S(\chi)
 =\sum_{x,y\in S}\chi(x+y)=P_S(\chi)^2.
\]

Puisque G est fini, χ prend ses valeurs sur le cercle unité. Ainsi
χ(−y)=\overline{χ(y)}, et

\[
\mathcal FC_S(\chi)
 =\sum_{x,y\in S}\chi(x-y)
 =P_S(\chi)\overline{P_S(\chi)}=|P_S(\chi)|^2.
\]

Si R_S=R_T, alors P_S(χ)^2=P_T(χ)^2. Dans le corps des complexes,
(P_S(χ)−P_T(χ))(P_S(χ)+P_T(χ))=0. Pour chaque χ, on a donc
P_S(χ)=P_T(χ) ou P_S(χ)=−P_T(χ), y compris lorsque ces deux nombres sont nuls.
Leurs modules sont égaux, donc les transformées de C_S et C_T sont égales.
L'injectivité de Fourier entraîne C_S=C_T.

L'injectivité est elle-même explicitée dans le module par l'identité
d'orthogonalité de mathlib :

\[
\sum_{\chi\in\widehat G}\chi(z-x)=|G|\,1_{z=x},\qquad
\sum_{\chi\in\widehat G}\mathcal Ff(\chi)\chi(-x)=|G|f(x).
\]

Le facteur |G| est non nul. Le signe ± peut dépendre du caractère ; ce n'est
pas nécessairement le caractère d'une translation. On ne choisit aucun
relèvement arbitraire de ces signes en un indicateur.

## 3. La réciproque est fausse

Dans G=Z/7Z, prenons S={0,1,2} et T={1,2,3}. Pour t parcourant 0,...,6 :

| Fonction | 0 | 1 | 2 | 3 | 4 | 5 | 6 |
|---|---:|---:|---:|---:|---:|---:|---:|
| C_S=C_T | 3 | 2 | 1 | 0 | 0 | 1 | 2 |
| R_S | 1 | 2 | 3 | 2 | 1 | 0 | 0 |
| R_T | 0 | 0 | 1 | 2 | 3 | 2 | 1 |

On a notamment R_S(0)=1 et R_T(0)=0. Le code vérifie le contre-exemple par
réduction du noyau (`decide`), sans `native_decide`.

Plus généralement, C_{S+u}(t)=C_S(t), tandis que
R_{S+u}(z)=R_S(z−2u). L'autocorrélation oublie donc davantage d'information.
La 2-torsion donne des translations qui préservent R ; elle n'identifie pas
les deux observables. La réflexion préserve aussi C. Les partenaires
exceptionnels STROBO sont des réflexions translatées : leur homométrie ne
constitue pas une construction non triviale modulo translations et réflexion.

## 4. Raccord aux sources existantes

Le nouveau fichier `lean/StroboHomometry.lean` importe `RecohFourierBridge`,
qui importe `Strobo2TorsCardinality` puis `Strobo2TorsCore`.
`orderedSquare`, `tripleSquareCoeff`, `orderedSquare_three` et
`recohTripleProbe` sont réutilisés, sans modifier leurs définitions.

| Déclaration publique | Portée |
|---|---|
| `supportProbe_three` | Identification avec la sonde triple RECOH existante |
| `orderedSquare_character_transform` | Transformée du carré ordonné = carré complexe |
| `differenceAutocorrelation_character_transform` | Transformée de C = module au carré |
| `character_sums_injective` | Injectivité des sommes de caractères |
| `supportProbe_eq_or_neg_of_orderedSquare_eq` | Ambiguïté ± caractère par caractère |
| `supportProbe_norm_eq_of_orderedSquare_eq` | Égalité des modules |
| `differenceAutocorrelation_eq_of_orderedSquare_eq` | Théorème général sur les parties finies |
| `triple_homometry_of_tripleSquareCoeff_eq` | Application aux neuf coefficients STROBO |
| `recoh_reflection_homometric` | Application au témoin exceptionnel du pont RECOH |
| `homometry_does_not_imply_orderedSquare_eq` | Contre-exemple formel à la réciproque |

La preuve générale ne dépend pas de la classification des triplets. Seul le
dernier corollaire de réflexion utilise le résultat de collision déjà établi.
Les fichiers existants sont repris au commit
`afef68f3c51dda613f749e90b5c992c4734e2c92` de
`alexcour/couret-finite-verifications` (PR #36).

## 5. Certification Lean locale

Le 17 octobre 2026, `scripts/verify_homometry.sh` s'est achevé avec le code
de sortie 0 sous Lean 4.29.1 et mathlib
`5e932f97dd25535344f80f9dd8da3aab83df0fe6` (tag `v4.29.1`). Il recompile
les trois modules locaux importés et le nouveau module, puis contrôle
automatiquement les dix déclarations publiques et leurs dix sorties
`#print axioms`.

Résultat : **10/10 déclarations compilées**, avec uniquement `propext`,
`Classical.choice` et `Quot.sound`, sans `sorryAx`. Les lemmes auxiliaires
privés sont couverts par les dépendances transitives des théorèmes publics.
Le nouveau module ne produit aucun avertissement. Les avertissements de
variables inutilisées des modules existants sont conservés dans leurs journaux.

Les journaux bruts, la table `axioms.json` et les empreintes des entrées et
des sorties se trouvent dans `homometry-verification/`. Il s'agit d'une
**compilation locale** : aucun succès GitHub Actions distant n'est revendiqué
pour ces nouvelles sources. La preuve générale n'a aucune hypothèse Fourier
postulée : l'orthogonalité est importée de mathlib et l'inversion est démontrée.

Pour reproduire dans l'environnement Lean configuré du dépôt :

```bash
cd research/strobo-2tors-2026-10-12
./scripts/verify_homometry.sh
```

## 6. Antériorité et correspondance

- **Lev (2004)**, *Reconstructing integer sets from their representation
  functions*, Electronic Journal of Combinatorics 11(1), R78,
  DOI <https://doi.org/10.37236/1831>, §3, p. 5, paragraphe précédant le
  problème 2 : formulation des carrés ordonnés sur un groupe abélien fini,
  égalité des coefficients de Fourier à un signe près, translations d'ordre
  deux et unicité en ordre impair. Ce passage suffit à déduire le pont vers
  l'homométrie par les identités classiques ci-dessus ; on ne lui attribue
  pas une classification complète des triplets.
- **Casper–Orozco**, *Reconstructing Rational Functions on Finite Abelian
  Groups with Higher Autocorrelations*,
  <https://arxiv.org/abs/2503.21022v2> (4 juillet 2026), introduction et §2.1 :
  cadre des autocorrélations et de la reconstruction modulo translation.
  La correspondance de Casper du 15 octobre signale précisément l'implication
  étudiée ici ; la réponse d'Alexandre du 16 octobre l'a déjà reconnue avec
  l'antériorité de Lev. Il ne s'agit pas d'une relecture complète ni d'une
  validation de priorité. Aucun nouveau message n'est nécessaire.
- **Baake–Grimm**, *Homometric model sets and window covariograms*,
  <https://arxiv.org/abs/math/0610411>, introduction et équations (3)–(4) :
  homométrie, convolution avec le support réfléchi et module de Fourier au
  carré, dans leur cadre géométrique. Ce cadre n'est pas confondu avec
  l'observable ordonnée STROBO sur un groupe fini.
- **Yang–Tang (2017)**, J. Number Theory 180, 73–85,
  DOI <https://doi.org/10.1016/j.jnt.2017.03.024>, reste une référence à comparer
  pour la classification et les différences symétriques. Ce pont classique
  ne résout pas cette comparaison bibliographique.

La preuve mathématique de l'implication est complète. La certification Lean
doit être lue dans le journal et le reçu associés aux sources exactes. Aucun
de ces contrôles ne certifie une nouveauté scientifique ni une relecture
humaine indépendante.
