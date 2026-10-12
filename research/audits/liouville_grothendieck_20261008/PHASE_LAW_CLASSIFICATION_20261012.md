# CU-BRUIT-02-C — Classes finies et lois à phases indépendantes

12 octobre 2026. Suite mathématique de la classification intégrée par la
[PR #4](https://github.com/alexcour/couret-finite-verifications/pull/4).
Preuve écrite proposée à la relecture ; originalité non établie.
Les résultats ci-dessous portent sur un **modèle probabiliste défini**.
Ils ne prouvent pas son identification avec une course de nombres premiers.

## 1. Théorème autonome : existence et invariance des phases

Soient μ réel, (rⱼ) une famille finie ou dénombrable de réels positifs ou
nuls telle que Σⱼrⱼ² < ∞, et (Θⱼ) des variables indépendantes uniformes
sur [0,2π]. Posons

\[
X=\mu+\sum_j r_j\cos\Theta_j.
\]

**Théorème A.** La somme converge dans L² ; sa moyenne est μ, sa variance
est (1/2)Σrⱼ², et sa fonction caractéristique est

\[
\varphi_X(t)=e^{i\mu t}\prod_j J_0(r_jt).
\]

Pour une écriture avec des coefficients complexes zⱼ et des phases
Uⱼ uniformes sur le cercle, Re(zⱼUⱼ) a la même loi que |zⱼ|cosΘⱼ.
Les rotations déterministes appliquées séparément aux Uⱼ conservent
leur loi jointe produit. La loi ne dépend donc pas des arguments de zⱼ.

**Preuve.** Chaque cosΘⱼ est centrée et a variance 1/2. L'indépendance
donne E|Σ_{j=M+1}^N rⱼcosΘⱼ|² = (1/2)Σ_{j=M+1}^N rⱼ², qui tend vers
zéro. La suite des sommes partielles est de Cauchy dans L² ; les
identités de moyenne et variance passent à la limite.
Pour une somme finie, l'intégration sur le cercle donne
E exp(it r cosΘ) = J₀(rt), puis l'indépendance donne le produit.
La convergence L² implique convergence L¹ et
|E exp(itX_N)−E exp(itX)| ≤ |t| E|X_N−X| ; le produit fini converge
donc vers la fonction caractéristique annoncée. Ceci démontre aussi
l'invariance des arguments, y compris dans le cas dénombrable.

## 2. Théorème de reconstruction : un critère exact d'égalité des lois

**Théorème B.** Deux modèles du théorème A ont la même loi si et
seulement si leurs moyennes sont égales et si leurs multisets
d'amplitudes **non nulles** sont égaux, avec multiplicité.
Les étiquettes des canaux et les amplitudes nulles ne sont pas identifiables.

La partie « si » résulte du produit du théorème A. Pour la réciproque,
nous donnons une preuve qui ne requiert pas de catalogue de zéros de J₀.

### 2.1 Tous les coefficients utiles de log J₀ sont non nuls

Au voisinage de zéro, J₀(0)=1 permet de définir son logarithme analytique :

\[
\log J_0(z)=-\sum_{m\ge1}c_mz^{2m}.
\]

L'équation de Bessel à l'ordre zéro est J₀''+J₀'/z+J₀=0.
Pour f=log J₀, elle devient f''+(f')²+f'/z+1=0. Comparer les
coefficients donne

\[
c_1=\frac14,\qquad
c_m=\frac1{m^2}\sum_{k=1}^{m-1}k(m-k)c_kc_{m-k}\quad(m\ge2).
\]

Par récurrence, cₘ>0 pour tout m. Les premiers sont
1/4, 1/64, 1/576 et 11/49152. L'équation et l'intégrale de Bessel sont
des identités classiques ; voir les références primaires à la section 7.

### 2.2 La loi fournit toutes les sommes de puissances

Posons λⱼ=rⱼ² et Pₘ=Σⱼλⱼᵐ. La sommabilité de λ implique que sa borne
supérieure est finie et que tous les Pₘ sont finis. Sur un disque
suffisamment petit, |rⱼt| reste dans un même disque de convergence du
logarithme. Pour sa convergence absolue, utiliser
Σⱼrⱼ^{2m} ≤ (supⱼrⱼ)^{2m−2}Σⱼrⱼ², puis la convergence de la série en m.
On peut donc permuter les sommes :

\[
\log(e^{-i\mu t}\varphi_X(t))=-\sum_{m\ge1}c_mP_mt^{2m}.
\]

La moyenne est déjà déterminée par la loi. Puisque tous les cₘ sont
non nuls, l'égalité des fonctions caractéristiques détermine chaque Pₘ.

### 2.3 Reconstruction des amplitudes avec multiplicité

Si P₁=0, toutes les amplitudes sont nulles. Sinon la sommabilité implique
qu'un maximum L=max λⱼ>0 est atteint et a multiplicité finie. En effet,
il n'existe qu'un nombre fini de λⱼ≥ε pour tout ε>0 ; appliquer cela
avec ε inférieur à la moitié de la borne supérieure.
Les inégalités Lᵐ≤Pₘ≤L^{m−1}P₁ donnent

\[
L=\lim_{m\to\infty}P_m^{1/m}.
\]

Sa multiplicité est

\[
N_L=\lim_{m\to\infty}\frac{P_m}{L^m}.
\]

Pour les termes λⱼ<L, (λⱼ/L)ᵐ tend vers zéro et est dominé pour m≥1
par λⱼ/L, dont la somme est finie. Cela justifie le second passage à
la limite. Soustraire N_LLᵐ de chaque Pₘ et recommencer.
Toute amplitude positive est atteinte après un nombre fini de ces étapes,
car il n'y a qu'un nombre fini d'amplitudes au-dessus d'elle.
On reconstruit donc le multiset complet des λⱼ, puis celui des rⱼ.
La loi détermine ainsi exactement les données annoncées. ∎

## 3. Conséquences qualitatives et limites de la variance

Si une amplitude est non nulle, X possède une loi absolument continue :
isoler un terme rcosΘ, qui a une loi arcsinus, puis le convoluer avec la
somme indépendante restante. Le modèle centré S=X−μ est symétrique.
Il donne de la masse à tout intervalle autour de zéro : pour ε>0,
choisir une somme partielle dont le reste a variance < ε²/8 ; son reste
est dans (−ε/2,ε/2) avec probabilité positive par Chebyshev. Les phases
de la partie finie peuvent toutes avoir leur cosinus assez petit pour
que cette partie soit aussi dans cet intervalle, avec probabilité
positive. Les deux événements sont indépendants.

Ainsi, pour un modèle non dégénéré,

\[
\mu>0\Rightarrow\Pr(X>0)>\tfrac12,\qquad
\mu=0\Rightarrow\Pr(X>0)=\tfrac12,\qquad
\mu<0\Rightarrow\Pr(X>0)<\tfrac12.
\]

Cette règle donne seulement le côté de 1/2, sans valeur numérique.
Elle porte sur le modèle ; son transfert aux nombres premiers exige
l'identification analytique séparée.

La variance ne détermine que P₁.

Toutes les puissances sont intégrables : la série de la fonction
génératrice d'un terme donne E exp(t rcosΘ)=I₀(tr)≤exp(t²r²/4),
puis le produit donne cette borne avec Σr² pour les sommes partielles.
Une sous-suite converge presque sûrement par convergence L² ; Fatou
transfère la borne à S pour tout t réel, assurant ses moments de tout
ordre. Ses cumulants peuvent donc être lus sur la série locale :

\[
\kappa_{2m}=(-1)^{m+1}(2m)!c_mP_m.
\]

En particulier κ₂=P₁/2 et κ₄=−3P₂/8. Pour une queue de phases contenant
au moins une amplitude non nulle, κ₄<0 ; une gaussienne de même variance
a κ₄=0. **Remplacer cette queue par une gaussienne est une approximation,
jamais une identité de lois.** Cela n'est pas un nouveau chiffrage de
l'erreur de l'approximation historique.

## 4. Application exacte aux treize classes, à modèle fixé

Fixons pour chaque caractère non principal χ un ensemble dénombrable
Γχ de paramètres positifs, avec Σ_{γ∈Γχ}(1/4+γ²)⁻¹<∞. Chaque indice
(χ,γ) porte une phase indépendante ; les paramètres et leur indexation
sont les mêmes pour tous les supports. **Ce sont des hypothèses du
modèle, pas une certification d'un catalogue de zéros de fonctions L.**
Avec aχ(T)=overline(hχ(T)), posons

\[
X_T=\mu(T)+\sum_{\chi,\gamma\in\Gamma_\chi}
\frac{2\operatorname{Re}(a_\chi(T)U_{\chi,\gamma})}
{\sqrt{1/4+\gamma^2}}.
\]

Son multiset d'amplitudes au carré est

\[
\Lambda(T)=\left\{\!\left\{
\frac{4v_\chi(T)}{1/4+\gamma^2}:
\chi\ne\chi_0,\ \gamma\in\Gamma_\chi
\right\}\!\right\}.
\]

**Corollaire C.** Dans ce modèle fixé,

\[
\mathcal L(X_T)=\mathcal L(X_S)
\iff \mu(T)=\mu(S)\ \text{et}\ \Lambda(T)=\Lambda(S).
\]

En particulier, l'égalité du biais et du profil étiqueté suffit à
l'égalité des lois. Les treize catégories finies produisent donc
**au plus treize lois**. L'égalité de Λ est une condition plus faible
que l'égalité du profil : elle oublie les étiquettes des contributions.

Si au moins un Γχ est non vide, tous nos profils ont des composantes
strictement positives, donc les lois sont non dégénérées. Dans ce
modèle, les cinq catégories de biais +3 ont une probabilité de signe
positive supérieure à 1/2 ; les huit catégories de biais −1 ou −5
ont une probabilité inférieure à 1/2. Cela ne certifie aucun δ numérique.

### 4.1 Variance et conjugaison signée

Écrivons Aχ=Σ_{γ∈Γχ}(1/4+γ²)⁻¹. Toujours dans le modèle,
Var(X_T)=2Σχvχ(T)Aχ.
Si Γχ provient des ordonnées positives d'un catalogue signé de zéros
simples, sans zéro central, où la conjugaison χ↔barχ renverse γ, alors la somme signée
correspondante est Bχ=Aχ+A_{barχ}. On a Bχ=B_{barχ} et
vχ=v_{barχ}, d'où

\[
\operatorname{Var}(X_T)=\sum_\chi v_\chi(T)B_\chi.
\]

Pour un caractère réel, Bχ=2Aχ. Pour une paire non réelle, les listes
positives peuvent différer ; il ne faut pas supposer Aχ=A_{barχ}.
La formule agrégée reste correcte après appariement signé.

Posons V₀=ΣχBχ. Les cinq variances se réduisent à :

| Profil | Variance |
|---|---|
| Q5 | V₀+8B₀,₂ |
| Q3 | V₀+8B₁,₀ |
| Q15 | V₀+8B₁,₂ |
| C5 | V₀+8B₀,₁ |
| C15 | V₀+8B₁,₁ |

**Critère suffisant D.** Si ces cinq constantes B sont deux à deux
distinctes, les treize catégories présentes donnent treize lois
distinctes : les moyennes distinguent les trois biais, et les variances
distinguent les profils à biais égal. Des intervalles certifiés disjoints
pour les cinq constantes suffiraient à vérifier cette hypothèse.
Les anciens nombres approchés ne constituent pas ces intervalles.
Si deux variances coïncident, le théorème B fournit le critère complet
par les multisets Λ, ou par toutes leurs sommes de puissances.

**Complément certifié du 12 octobre 2026 :** [cinq encadrements analytiques disjoints](CERTIFIED_SPECTRAL_CONSTANTS_20261012.md) sont maintenant obtenus par sommes périodiques, bornes de queue et arrondis dyadiques dirigés. Sous GRH, ces constantes Kχ s'identifient aux Bχ signés ; le critère D établit donc treize lois distinctes du modèle spectral à phases indépendantes. Le même complément exclut les zéros réels non triviaux de ces sept caractères via Kχ<4 et l'identité classique de Hadamard. L'identification à une course réelle et une valeur numérique de densité restent conditionnelles/non certifiées.

## 5. Contre-exemples exacts aux affirmations plus fortes

1. **Même variance ⇒ même loi : faux.** Avec des phases indépendantes,
   S=cosΘ₁+cosΘ₂ et R=√2cosΘ ont variance 1, mais leurs quatrièmes
   moments sont 9/4 et 3/2. Les lois sont différentes.
2. **Les modules suffisent sans indépendance : faux.** Avec une seule
   phase partagée, cosΘ+cosΘ=2cosΘ tandis que cosΘ−cosΘ=0.
   Les deux coefficients ont les mêmes modules ; les variances sont
   2 et 0. C'est aussi une obstruction à traiter une répétition de
   fréquence comme deux phases indépendantes sans justification.
3. **Treize catégories ⇒ toujours treize lois du modèle : faux.**
   Dans un modèle synthétique avec un terme indépendant par caractère
   et rχ²=vχ(T), les trois profils Q ont le même multiset d'amplitudes,
   et les deux profils C aussi. Pour chaque biais, ils fusionnent
   respectivement. Il reste exactement cinq lois : deux pour μ=+3,
   deux pour μ=−1 et une pour μ=−5. Les deux familles ont même variance
   15/2, mais P₂=87 pour Q et 55 pour C. Ce modèle artificiel n'est pas
   présenté comme un catalogue réel de zéros ni comme une réalisation
   des hypothèses LI pour des fonctions L.
4. **Lois différentes ⇒ probabilités de signe différentes : faux.**
   cosΘ et 2cosΘ ont des lois et variances différentes, mais donnent
   tous deux une probabilité 1/2 d'être positifs.
5. **Le modèle centré est gaussien dès que la variance est connue : faux.**
   Son κ₄ est strictement négatif si une amplitude est non nulle.
   Une approximation gaussienne peut être utile sans devenir exacte.

## 6. Passage aux courses réelles : frontière explicite

L'identification de X_T avec une loi limite de
E_T(x)=(log x/√x)D_T(x) demande un théorème analytique applicable et une
normalisation de la formule explicite. GRH, une hypothèse LI précise
sur les ordonnées indexées, le traitement des multiplicités/fréquences
communes et l'absence ou la prise en compte des zéros centraux ne sont
pas prouvés ici. Un zéro central peut modifier le terme déterministe ;
le biais fini μ(T) ne doit alors pas être pris automatiquement pour
la moyenne complète. La seule symétrie de conjugaison ne donne pas
l'indépendance des phases.

Pour les sept caractères primitifs concernés ici, l'absence de zéros centraux est désormais déduite sans GRH dans le [complément analytique certifié](CERTIFIED_SPECTRAL_CONSTANTS_20261012.md). Cette précision concerne cette famille, tandis que les avertissements précédents restent applicables à un modèle général.

Le théorème conditionnel classique de Rubinstein–Sarnak est le contexte,
pas un résultat nouveau de cette note. Le théorème C est un résultat
autonome **une fois le modèle à phases indépendantes posé** ; toute
application à une course réelle est un corollaire conditionnel de
l'identification correcte de ce modèle. Un [complément q15](Q15_TAIL_BOUNDS_20261012.md)
relie maintenant le certificat fini des 37 racines de la PR #28 aux
constantes K, puis borne le remplacement gaussien de cette queue seule.
La certification des 30 ordonnées q3/q5 et de leurs queues, la
certification de la densité historique, la relecture humaine et
l'antériorité restent ouvertes.

Plus précisément, si les mesures logarithmiques de la course réelle

\[
\nu_R=\frac1{\log(R/2)}\int_2^R\delta_{E_T(x)}\,\frac{dx}{x}
\]

convergent faiblement vers la loi non dégénérée X_T, l'absence d'atome
en zéro démontrée à la section 3 permet de passer à l'indicatrice de
(0,∞). Comme E_T et D_T ont le même signe pour x≥2 et
log(R/2)/log R→1, la densité logarithmique positive existe alors et
vaut Pr(X_T>0). C'est une implication mathématique sous l'hypothèse
de convergence indiquée ; cette convergence n'est pas établie ici.

## 7. Reproduction et références primaires

[verify_phase_law_identities.py](verify_phase_law_identities.py) vérifie
avec des fractions exactes deux calculs des coefficients de log J₀
jusqu'à l'ordre 32, les cumulants et quatrièmes moments par une voie
indépendante, la reconstruction finie par les identités de Newton,
l'agrégation conjuguée avec Aχ≠A_{barχ}, les cinq formules de variance,
les treize classes et leur collapse à cinq lois dans le modèle synthétique.
Il teste une altération du coefficient quartique et de la variance.
Il ne prouve pas par exécution les passages aux limites dénombrables
et ne certifie aucune donnée de zéros.

```bash
python research/audits/liouville_grothendieck_20261008/verify_phase_law_identities.py --check
```

Sources primaires consultées le 12 octobre 2026 :

- NIST DLMF, [10.9.1](https://dlmf.nist.gov/10.9.E1), intégrale de J₀.
- NIST DLMF, [10.2.1–10.2.2](https://dlmf.nist.gov/10.2), équation et série de Bessel.
- Rubinstein et Sarnak, *Chebyshev's Bias*, Experimental Mathematics 3(3),
  173–197 (1994), [texte original](https://www.math.ubc.ca/~gerg/teaching/592-Fall2018/papers/1994.Rubinstein.pdf).

Les preuves probabilistes sont écrites ici pour expliciter les dépendances
de notre classification ; ces références n'établissent pas leur originalité.
Sources internes : [classification finie](STRUCTURAL_TRIPLET_CLASSIFICATION_20261012.md),
[audit des conventions signées](B1_SIGNED_ZERO_ANALYTIC_AUDIT_20261012.md),
[décision d'intégration de la PR #4](INTEGRATION_DECISION_20261012.md).
Cette continuation est proposée dans une nouvelle PR de recherche ;
elle ne modifie pas le protocole gelé ou les publications archivées.
