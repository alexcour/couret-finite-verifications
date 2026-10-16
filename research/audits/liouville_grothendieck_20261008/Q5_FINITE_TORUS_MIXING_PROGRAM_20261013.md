# CU-BRUIT Q5 — feuille de route rigoureuse pour le mélange fini (13 octobre 2026)

**Étude mathématique, aucun taux de convergence sur les 67 fréquences n'est encore certifié.** Ce dossier sépare expressément les trois objets : occupation arithmétique `F_B`, occupation temporelle tronquée `F_[T,X]`, loi de Haar tronquée `p_T`, et loi complète `delta`.

## Décomposition qu'il faut fermer

```
|F_B-delta| <= |F_B-F_[T,X]| + |F_[T,X]-p_T| + |p_T-delta|.
```

A `B=65536, T=25`, l'instrument exact de comparaison finie borne `|F_B-F_[T,X]| <= 0.108726`, et `F_B in [0.167988,0.167989]` tandis que `F_[T,X] in [0.276064,0.276715]`. Ces bornes ne fournissent pas la deuxième ou la troisième erreur. La borne de substitution gaussienne de `0.000173887` s'applique **à la queue remplacée par une gaussienne**, et ne contrôle pas la suppression de la queue brute.

## Une borne de Fourier élémentaire à horizon fini

Pour une liste fixe de fréquences réelles `gamma_1,...,gamma_d` et `Y` uniforme sur `[A,B]` de longueur `L=B-A>0`, posons `theta(y)=(gamma_j y mod 2pi)_j`. Pour un **polynôme trigonométrique fini** `P(theta)=sum_(k in K) c_k exp(i k·theta)` avec K fini et `0 in K` :

```
|E_Y P(theta(Y)) - E_Haar P|
 <= sum_(k in K, k != 0) |c_k| min(1, 2/(L |k·gamma|)).
```

Preuve directe : pour `omega=k·gamma` non nul, `(1/L) int_A^B exp(i omega y)dy=(exp(i omega B)-exp(i omega A))/(i omega L)`, de module au plus `min(1,2/(L|omega|))`. L'intégrale de Haar d'un caractère non trivial est nulle. La majoration suit par inégalité triangulaire. Si `omega=0`, on ne peut PAS diviser par `|omega|` : il faut considérer la contribution comme au plus `|c_k|` et étudier le tore adhérent réel plutôt que Haar sur `T^d`.

Pour appliquer cette identité à l'indicatrice discontinu `1_[E_T>0]`, il faut encore un **polynôme majorant/minorant effectif**, ou un lissage avec erreurs positives de part et d'autre du seuil, et une borne d'anti-concentration sur la bonne loi. Sans ces contrôles, la formule ne démontre aucune borne de mélange de signe.

## Ordre exact des prochains verrous

1. Commencer par `T=4` : deux fréquences réellement présentes ; le certificat finit `Delta(4,64)>0.011839` porte sur 16 640 modes contrôlés. Construire un polynôme lissé de degré <=64 et afficher la somme exacte des coefficients, l'erreur de lissage et le reste de distribution sous la même mesure ; ne pas extrapoler la borne au-delà du jeu de modes certifié.
2. Pour `T=25`, sélectionner seulement un ensemble fini K de modes dont les écarts `|k·gamma|` sont strictement isolés par des intervalles signés rationnels. Rendre un `UNKNOWN` dès qu'un mode atteint zéro ou sort du budget. Le catalogue de 67 racines ne certifie pas une indépendance linéaire globale.
3. Isoler `|p_T-delta|` par couplage des queues réelles de phases et anti-concentration. Une substitution par gaussienne n'est pas une borne de la queue **supprimée**.
4. Rendre un tableau par horizon `B,T` avec ses trois erreurs et la somme **seulement si** les trois sont valides pour exactement la même définition des poids, du temps et du signe.

## Niveau de preuve et confidentialité

Le lemme de Fourier pour polynôme fini est élémentaire et démontré dans ce document. L'application au signe Q5 à horizon fini, la convergence effective à 67 fréquences, GRH, LI/ELI et le passage à la densité arithmétique **ne sont pas établis ici**. Ce dossier ne contient aucune notion ni terminologie de l'architecture FCI. Pas de fusion de la PR #27, pas de release, pas de revendication d'antériorité.

Références internes : [quantitative specialization](WASSERSTEIN_SPECIALIZATION_20261013.md), [finite sign transport](FINITE_SIGN_TRANSPORT_20261013.md), [second-path Bessel audit](Q5_BESSEL_SECOND_PATH_AUDIT_20261013.md).
