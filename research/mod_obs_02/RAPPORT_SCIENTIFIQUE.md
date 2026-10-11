# MOD-OBS-02 — Certification de propriétés sous réponses faillibles

**Programme Couret — observabilité, reconstruction et suffisance certifiante minimale**  
**11 octobre 2026 · version 0.1 · document de recherche et d'audit**  
**Statut :** énumérations finies exactes et démonstrations internes ; deux implémentations indépendantes concordantes ; originalité et relecture scientifique extérieure non établies. PR de recherche en brouillon, aucune fusion autorisée à ce stade.

## Résumé

Nous étudions une variante de MOD-OBS-01 dans laquelle le carré d'adjacence d'un graphe de Cayley cyclique est connu exactement, mais où les réponses binaires obtenues ensuite peuvent comporter au plus une erreur sur l'ensemble de l'interrogatoire. Les questions peuvent être répétées, sont payantes et peuvent dépendre des réponses précédentes. Nous demandons séparément : (i) combien coûte la reconstruction complète du support ? (ii) combien coûte la détermination correcte d'une propriété booléenne cible ? (iii) combien de travail exige la production et le contrôle du certificat de la politique de questions ?

Pour n=18 avec générateur zéro exclu, les 680 supports se répartissent en 393 fibres selon le carré d'adjacence (118 simples, 269 doubles, six quadruples). Au coût unitaire, le nombre minimax de questions supplémentaires pour reconstruire le support passe de **2** (aucune erreur admise) à **5** (au plus une erreur possible). Pour déterminer « 1 appartient-il à S ? », le pire coût passe de **1** à **3**. La propriété « n/2 appartient-il à S ? » est déjà déterminée par le carré et coûte **0** dans les deux régimes. Ces valeurs sont confirmées par deux programmes indépendants sur toutes les fibres pour n=12,18,24 dans les régimes préenregistrés.

La borne inférieure de cinq questions pour une fibre quadruple possède une preuve interne élémentaire par comptage de transcriptions binaires avec un mensonge. Une stratégie répétant deux questions coordonnées atteint cinq. Il s'agit d'une conséquence d'un modèle fini de recherche avec erreurs bornées, **pas d'une garantie applicable sans contrôle à des modèles IA ou à des instruments réels**.

## 1. Source et protocole

Le socle algébrique est celui du dossier [STROBO-C3](https://docs.google.com/document/d/1Hr-OtURV22lnAoX-aB_CkFDCYE39DbNQFYUG4EeS_2U/edit), encore soumis à audit indépendant. MOD-OBS-01 a traité les questions parfaites, distinguant interrogation fixe universelle et interrogation conditionnée par la fibre ; son archive de revue se trouve sur [GitHub, PR #14](https://github.com/alexcour/couret-finite-verifications/pull/14).

Le fichier `PROTOCOL_FREEZE.md` a été créé et empreinté par SHA-256 **avant** les nouveaux résultats. Domaine principal n=18, contrôles n=12 et n=24 ; erreur adversariale b=0 ou b=1 ; sept cibles fixes ; deux coûts : U(x)=1, W(x)=1+(x mod 3). L'essai préenregistré ne porte pas sur des observations de nombres premiers ni sur des séquences historiques.

L'évaluation de n=18 reprend un univers déjà exploré pour b=0 ; seuls le modèle faillible, ses politiques et les coûts qui en découlent sont nouveaux dans cette campagne. Les nombres n=12 et 24 servent de contrôles finis, et non de validation d'un modèle du monde.

## 2. Objets et observations

Pour n>=5, soit X_n l'ensemble des sous-ensembles S de {1,...,n-1} ayant exactement trois éléments distincts. À S associons la matrice A_S du graphe de Cayley orienté sur Z/nZ et la fonction entière

    O(S)(t) = #{(a,b) dans S×S : a+b ≡ t (mod n)}.

O(S) décrit exactement A_S² sur un étiquetage fixe. Les fibres observationnelles V(o)={S : O(S)=o} ne sont pas quotientées par isomorphisme.

Une question autorisée est q_x(S)=1 si x appartient à S, 0 sinon, x dans {1,...,n-1}. La réponse de l'oracle peut être fausse. **Hypothèse de validité : au plus b erreurs sur l'ensemble des réponses d'un interrogatoire**, où b=0 ou 1 ; les réponses peuvent être erronées de façon adversariale et corrélée. Il n'y a ni indépendance, ni probabilité d'erreur postulée. Chaque interrogation, y compris répétée ou trompeuse, coûte c(x)>0. L'observation initiale O(S) est supposée correcte et son acquisition non facturée dans ces coûts **conditionnels**.

Deux problèmes sont distincts : la reconstruction (fonction cible T(S)=S) et la décision/certification relative à une cible P : X_n→{0,1}. Dire que « P est certifiée » signifie ici **la valeur de vérité de P est déterminée pour tous les candidats compatibles**, pas nécessairement que P est vraie ni qu'une preuve externe de P a été produite.

## 3. État épistémique et récurrence exacte

Après les réponses (x_1,a_1),...,(x_k,a_k), chaque candidat S présente un nombre de contradictions

    e_k(S) = #{j<=k : q_{x_j}(S) ≠ a_j}.

L'ensemble des situations encore admissibles est

    V_k = {S dans V(O) : e_k(S)<=b}.

Une cible est établie lorsque T est constante sur V_k non vide. Le compte e_k est exact pour chaque candidat ; il synthétise le passé parce qu'une seule borne globale b est imposée.

Pour la politique minimax à coûts additifs, notons E=(e(S))_S l'état courant, avec e(S)>b pour les candidats éliminés. Après la question x et la réponse possible a, la mise à jour est

    E^{x,a}(S) = min(b+1, e(S)+1[q_x(S)≠a]).

Le coût optimal satisfait :

    V(E)=0 si T est constante sur {S:e(S)<=b} ;
    V(E)=min_x { c(x)+max_{a réalisable}V(E^{x,a}) } autrement.

Les questions possédant une branche qui ne modifie pas l'état sont exclues : avec c(x)>0, une telle question ne peut améliorer un optimum fini dans le pire des cas. Tout autre embranchement augmente au moins un compte de contradictions ou élimine un candidat, et la programmation dynamique porte donc sur un graphe fini sans cycle de progrès nul.

Le premier code conserve un vecteur d'erreurs minimales ; le second conserve directement l'ensemble des mondes possibles `(support, erreurs consommées)` et emploie une convolution indépendante. Les deux approches n'importent pas les mêmes fonctions.

## 4. Résultats principaux, coût unitaire

### 4.1 Fibres exactes

| n | Supports sans zéro | Fibres de taille 1 | Fibres de taille 2 | Fibres de taille 4 | Total fibres |
|---:|---:|---:|---:|---:|---:|
| 12 | 165 | 43 | 55 | 3 | 101 |
| 18 | 680 | 118 | 269 | 6 | 393 |
| 24 | 1 771 | 229 | 753 | 9 | 991 |

Ces comptes sont identiques sous deux méthodes indépendantes de calcul des carrés. Ils sont des comptes de supports étiquetés, non de classes d'isomorphisme.

### 4.2 Coûts minimax, dans le pire cas sur les fibres

| Cible | n=12 b=0 | n=12 b=1 | n=18 b=0 | n=18 b=1 | n=24 b=0 | n=24 b=1 |
|---|---:|---:|---:|---:|---:|---:|
| Reconstruction complète | 2 | **5** | 2 | **5** | 2 | **5** |
| Appartenance de 1 | 1 | **3** | 1 | **3** | 1 | **3** |
| Connexité (engendre Z/nZ) | 0 | 0 | 1 | 3 | 0 | 0 |
| Marche fermée de longueur 3 | 1 | 3 | 1 | 3 | 1 | 3 |
| Symétrie S=-S | 0 | 0 | 0 | 0 | 0 | 0 |
| Majorité de pas < n/2 | 1 | 3 | 1 | 3 | 1 | 3 |
| Appartenance du demi-tour n/2 | 0 | 0 | 0 | 0 | 0 | 0 |

Le sens du zéro est rigoureux : sur chaque fibre examinée, la cible est déjà constante. Cela ne signifie pas qu'elle est vraie. Pour la présence du demi-tour n/2, une raison algébrique plus générale existe : O(S)(0) mod 2 vaut 1 si et seulement si n/2 appartient à S, puisque 0 est exclu.

### 4.3 Distribution exacte pour n=18

- **Reconstruction, b=0 :** 118 fibres demandent 0 question, 269 demandent 1 et 6 demandent 2.
- **Reconstruction, b=1 :** 118 fibres demandent 0 question, 269 demandent 3 et 6 demandent 5.
- **Appartenance de 1, b=1 :** 301 fibres demandent 0 question, 92 demandent 3.
- **Connexité, b=1 :** 337 fibres demandent 0 question, 56 demandent 3.

Les moyennes éventuelles par fibre ne doivent pas être interprétées comme des probabilités sur les supports ; aucune distribution sur les objets n'est postulée.

## 5. Théorème témoin : borne exacte de cinq questions avec une erreur

Considérons dans Z/18Z les supports

    S1={1,4,13} ; S2={1,7,16} ;
    S3={4,10,13} ; S4={7,10,16}.

Le calcul entier vérifie O(S1)=O(S2)=O(S3)=O(S4). Le carré seul ne les distingue pas.

**Proposition témoin (preuve interne dans le modèle).** Avec des questions binaires exactes sur les appartenances, mais au plus une réponse erronée sur toute la séquence, **le coût minimax unitaire de reconstruction de ce support parmi les quatre possibilités est exactement cinq**.

*Borne inférieure.* Supposons une stratégie déterministe de profondeur maximale d. On peut prolonger toutes ses branches à d réponses par des questions sans influence sur la décision. Pour un véritable objet fixé, il existe au moins d+1 suites binaires distinctes compatibles avec zéro ou un mensonge : aucune faute, ou une faute placée à chacun des d instants. Deux objets différents ne peuvent partager une même suite si l'identification finale est toujours correcte. Par conséquent 4(d+1)≤2^d. À d=4, l'inégalité exigerait 20≤16, impossible. Donc d≥5.

*Borne supérieure.* Les questions q_1 et q_4 déterminent deux bits indépendants sur la fibre : q_1 distingue {S1,S2} de {S3,S4}, q_4 distingue {S1,S3} de {S2,S4}. On interroge chacune **deux fois**. Si les deux réponses à chaque question concordent, les bits sont corrects : deux réponses identiquement fausses demanderaient deux erreurs. Si une paire de réponses est discordante, on repose une troisième fois cette question et la majorité donne le bon bit. Au plus une discordance peut avoir lieu sous l'hypothèse b≤1. Quatre ou cinq questions suffisent. La borne est atteinte.

Cette preuve n'exige pas la classification STROBO-C3 pour la **fibre témoin**, seulement la vérification de l'égalité des quatre carrés. L'extension de l'argument à toutes les fibres quadruples de tous les ordres s'appuie en revanche sur la structure de fibres candidate de STROBO-C3.

**Décider plutôt que reconstruire.** Sur la même fibre, « 1 appartient-il à S ? » est déterminé par trois répétitions de q_1 au pire, et ne peut être déterminé en deux questions avec un mensonge (deux valeurs de vérité possibles et boules de Hamming de rayon un non disjointes). La connexité, elle, est constante sur les quatre candidats : zéro question. La hiérarchie 0 / 3 / 5 persiste donc malgré l'incertitude sur les réponses.

## 6. Modèle de coûts hétérogènes

Le protocole fixe un coût abstrait W(x)=1+(x mod 3), soit 1, 2 ou 3 unités selon la question. Cela ne correspond à aucune dépense réelle, mais permet de tester si l'optimisation tient compte de ressources non uniformes.

| n=18, pire sur les 393 fibres | U b=0 | U b=1 | W b=0 | W b=1 |
|---|---:|---:|---:|---:|
| Reconstruction | 2 | **5** | 6 | **15** |
| Appartenance de 1 | 1 | **3** | 2 | **6** |
| Connexité | 1 | **3** | 3 | **9** |
| Appartenance du demi-tour | 0 | **0** | 0 | **0** |

Dans la fibre témoin, les coûts W de reconstruction sont 4 sans mensonge et 10 avec un mensonge possible, alors que le pire global vaut 6 et 15 respectivement. Les différences de coûts ne sont donc pas un simple comptage de questions ; elles résultent de l'accès spécifique aux générateurs utiles dans chaque fibre.

## 7. Coûts de construction et de vérification : comptes distincts

Le *coût d'acquisition* dans les tableaux est la somme payée pour les réponses à l'oracle, au pire des adversaires compatibles.

Le *coût de calcul de la stratégie* est différent. Le programme dynamique a évalué **2 474 états** au total pour la reconstruction n=18, U, b=1, en résolvant chaque fibre ; contre 979 pour b=0. Ces valeurs sont des comptes d'états produits par cette implémentation, pas des bornes de complexité computationnelle indépendantes de l'algorithme.

Le *coût de vérification du certificat* est encore différent : pour l'arbre témoin U, b=1, la politique comporte 20 états accessibles, et le vérificateur a exploré **20 feuilles de transcriptions réalisables** en comptabilisant 272 comparaisons de candidats dans son instrumentation. Il vérifie que toute issue possible sous b≤1 termine avec la bonne valeur cible, et que le coût maximal est cinq. Les politiques W et les politiques de propriété ont également été rejouées.

Enfin, une preuve humaine de la borne générale ou une formalisation Lean engage des coûts de traduction, de contrôle du modèle et de confiance dans l'environnement qui **ne sont pas mesurés** ici. Il serait donc incorrect de présenter 5, 2 474 ou 272 comme les termes homogènes d'un coût monétaire universel de la certification.

## 8. Reproductibilité

Le paquet de reproduction comporte deux programmes Python standard, leurs sorties JSON, 12 tests automatisés et le protocole gelé. Les deux programmes concordent pour tous les objectifs sur toutes les fibres des expériences préenregistrées : n=12 et n=24 en U b=0/1 ; n=18 en U et W b=0/1, soit **8 blocs × 7 propriétés**. Les politiques du témoin ont été rejouées contre tous les supports possibles et tous les emplacements réalisables d'une erreur. Des mutations volontaires d'une conclusion terminale et du coût maximal sont détectées comme des échecs par le vérificateur.

- `mod_obs_02.py` : calcul des fibres via paires ordonnées, DP vectorielle, extraction d'arbres, replay.
- `independent_audit.py` : convolution diagonale et paires non ordonnées, DP avec mondes `(support, erreurs consommées)`, comparaison exhaustive des histogrammes.
- `test_mod_obs_02.py` : 12 tests, dont tests négatifs du vérificateur.
- `results.json` et `independent_audit.json` : sorties observées, politiques et statistiques d'exécution.
- `SHA256SUMS` et `verify.sh` : contrôle du paquet et réexécution, sans dépendances externes.

Le contrôle par deux logiciels reste un **audit informatique interne**. Il n'est pas une relecture externe, ni une preuve que les hypothèses physiques du modèle sont satisfaites.

## 9. Statut épistémique, limites et réfutations

| Proposition | Statut au 11/10/2026 |
|---|---|
| Égalité des carrés pour les quatre supports témoins | Vérification entière exacte ; deux logiciels |
| Coûts minimax 0/1 erreur pour n=12,18,24 | Énumérations finies indépendantes concordantes |
| Minimum cinq questions pour la fibre témoin | Preuve interne élémentaire et calcul exact |
| Borne sur toutes les fibres pour n quelconque | Conditionnelle à la classification STROBO en cours de relecture |
| Coûts W(x) | Exactes dans un barème abstrait fixé par protocole |
| Oracle réel limité à une erreur | Non démontré, hypothèse de validité du modèle |
| Coût monétaire de preuves formelles indépendantes | Non mesuré |
| Originalité mathématique ou avance sur l'IA réelle | Non établie |

Un certificat ou un contre-exemple falsificateur serait notamment : une histoire de réponses d'au plus un mensonge où un arbre produit une valeur fausse ; une stratégie valide à quatre questions pour reconstruire quatre candidats sous une erreur ; ou une discordance entre deux calculs de fibres dans le même domaine. La troisième possibilité demanderait audit des programmes. Les tests exécutés n'ont rencontré aucune de ces situations.

La garantie cesse si la réponse initiale O(S) est fausse, si deux réponses supplémentaires sont erronées, si le domaine admissible X_n omet le véritable support, ou si la proposition cible est mal formalisée. La certification de la valeur d'une propriété n'autorise pas automatiquement une action touchant des personnes. La fiabilité des sources, l'autorité de décision et la responsabilité sont des problèmes supplémentaires.

## 10. Prochaines recherches contrôlées

**Axe 1 :** audit contradictoire des preuves MOD-OBS-01 et 02 et de la classification STROBO-C3, puis examen de l'antériorité dans les jeux de questions avec mensonges (Ulam–Rényi), l'apprentissage exact, les arbres de décision et la vérification de certificats.

**Axe 2 :** second protocole gelé pour b=2, sans reprendre des résultats de b=1 comme prédictions indépendantes ; comparaison des politiques adaptatives avec des batteries fixes sous les mêmes restrictions d'erreurs.

**Axe 3 :** quitter l'hypothèse d'une borne certaine sur les erreurs en formulant séparément (i) un modèle probabiliste avec niveau de risque explicite ; (ii) des observations initiales faillibles ; (iii) un budget réel de construction et de vérification d'un certificat. Il faudra éviter de transformer une probabilité élevée en garantie absolue.

**Axe 4 :** comparer la classification d'une propriété et la reconstruction complète sur des familles plus larges, mais uniquement après audit de ce premier cas.

## Conclusion

Le dossier démontre, dans un modèle fini et sous une borne d'erreur explicitement postulée, qu'une incertitude supplémentaire sur les réponses ne supprime pas l'asymétrie entre **déterminer une propriété** et **reconstruire l'objet**. À n=18, le pire coût unitaire passe de 2 à 5 pour reconstruire, de 1 à 3 pour déterminer l'appartenance de 1, et demeure zéro pour une propriété déjà portée par le carré. Le même phénomène apparaît avec des questions de prix hétérogènes, et se contrôle par deux implémentations indépendantes.

La contribution est **un banc fini exact et reproductible**, pas une théorie générale de la compréhension, une garantie absolue de vérité ou une démonstration d'originalité. L'étape décisive reste la relecture extérieure et la comparaison précise aux antériorités sur les décisions avec mensonges.

## Références et dossiers de rattachement

- STROBO-C3-01, note interne, 10 octobre 2026 : https://docs.google.com/document/d/1Hr-OtURV22lnAoX-aB_CkFDCYE39DbNQFYUG4EeS_2U/edit
- MOD-OBS-01, audit de revue : https://github.com/alexcour/couret-finite-verifications/pull/14
- CU-MOD-OBS-01, synthèse provisoire : https://docs.google.com/document/d/13eLN-VkDmBjlSYS-zqJAjXfIdgo7i8SvSMY8kOj-wgY/edit
- Cadre Ulam–Rényi et arbres de décision avec mensonges : domaine bibliographique identifié pour audit, sans revendication que nos preuves l'excèdent.
- Apprentissage exact par questions et théorie de la complexité des certificats : antériorités méthodologiques à confronter, non remplacées par le présent document.
