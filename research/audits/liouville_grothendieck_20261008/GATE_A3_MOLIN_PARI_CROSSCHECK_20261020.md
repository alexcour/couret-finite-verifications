# GATE A3 — première confrontation indépendante q=15 (20 octobre 2026)

**Décision : 27/27 valeurs transmises concordent numériquement avec les 27 valeurs locales correspondantes sous T=20 ; 10/37 candidats locaux sous T=25 restent sans donnée indépendante confrontée. GATE A3 reste HOLD pour la certification des racines et l'exhaustivité.**

## Provenance et limites de l'essai

- Source externe : courriel de Pascal Molin, reçu le **20 octobre 2026 à 10 h 03 (Paris)**. Le correspondant rapporte l'exécution de PARI/GP, avec la commande reproduite ci-dessous. **Nous n'avons pas exécuté PARI/GP dans cet audit.**
- Données : transcription fidèle des trois listes de 9 valeurs de ce message dans [q15_molin_pari_20261020.json](q15_molin_pari_20261020.json). L'original demeure dans la correspondance privée. Aucune empreinte SHA-256 des octets bruts du courriel n'a été archivée ici et ce JSON ne constitue pas une source certifiée.
- Données locales : [q15_roots_refined_20261009.json](q15_roots_refined_20261009.json) (40 chiffres de travail annoncés ; 12, 13, 12 candidats, sans preuve de complétude).
- Méthode de la confrontation : passage par des entiers décimaux de précision exacte (pas de flottants binaires) et appariement **même Conrey, même rang**, chacun strictement croissant et les 27 valeurs rapportées étant sous T=20. Seuil descriptif de concordance 1e-30 ; ce seuil ne représente **pas une borne d'erreur**.
- Résultat : 9/9 (15.2), 9/9 (15.14), 9/9 (15.8), soit **27 valeurs externes affichées sur 27**, avec |écart affiché| max global **5e-35**. Aucun désaccord de rang ou d'ordre sur ces 27 rangs.
- Le résultat reproductible machine est dans [q15_molin_decimal_comparison_20261020.json](q15_molin_decimal_comparison_20261020.json) ; le script standard-library [verify_q15_molin_decimal_20261020.py](verify_q15_molin_decimal_20261020.py) recalcule les comparaisons, effectue les contrôles d'ordre et échoue en cas de désaccord. Cet audit de chaînes décimales a été calculé ici par arithmétique entière exacte ; **aucune exécution de PARI/GP T=25 n'est rapportée**.

Commande fournie :

```gp
g=znstar(15,1);forvec(c=g.cyc,if(zncharconductor(g,c)==15,print([15,znconreyexp(g,c),lfunzeros([g,c],20)])))
```

## Concordances ligne à ligne (valeurs imprimées, non intervalles garantis)

### Conrey 15.2

| Rang | Local (40 dps, affichage) | Molin / PARI (affichage) | \u007cΔ\u007c des chaînes affichées |
|---:|---|---|---:|
| 1 | 2.73460370911883725526846548734412216 | 2.7346037091188372552684654873441221613 | 1.3e-36 |
| 2 | 5.24301049275448939295780629412083942 | 5.2430104927544893929578062941208394242 | 4.2e-36 |
| 3 | 8.41468524980489927126454193275339625 | 8.4146852498048992712645419327533962545 | 4.5e-36 |
| 4 | 10.1876027276453024410392281737734211 | 10.187602727645302441039228173773421109 | 9e-36 |
| 5 | 11.9073724765466703206668691610290188 | 11.907372476546670320666869161029018811 | 1.1e-35 |
| 6 | 13.3373958554155892403877849438430742 | 13.337395855415589240387784943843074200 | 0 |
| 7 | 15.3661395764977823147947183320934829 | 15.366139576497782314794718332093482950 | 5e-35 |
| 8 | 17.7723902492166640608502314259928581 | 17.772390249216664060850231425992858099 | 1e-36 |
| 9 | 18.9769996500882535345336185036068452 | 18.976999650088253534533618503606845190 | 1e-35 |

### Conrey 15.14

| Rang | Local (40 dps, affichage) | Molin / PARI (affichage) | \u007cΔ\u007c des chaînes affichées |
|---:|---|---|---:|
| 1 | 3.05701820980868915287415506904708829 | 3.0570182098086891528741550690470882907 | 7e-37 |
| 2 | 5.34319209367996891782367161036914649 | 5.3431920936799689178236716103691464863 | 3.7e-36 |
| 3 | 7.26763059826680725286077767720710152 | 7.2676305982668072528607776772071015192 | 8e-37 |
| 4 | 10.1337481552283757972592006003482581 | 10.133748155228375797259200600348258080 | 2e-35 |
| 5 | 12.1596985338107708179232438174534441 | 12.159698533810770817923243817453444129 | 2.9e-35 |
| 6 | 13.4893845731553180405332225553316328 | 13.489384573155318040533222555331632793 | 7e-36 |
| 7 | 15.2404085290390331668778881598505608 | 15.240408529039033166877888159850560843 | 4.3e-35 |
| 8 | 16.6335584161855863815882344250819375 | 16.633558416185586381588234425081937543 | 4.3e-35 |
| 9 | 19.1034971852546946574430563193662774 | 19.103497185254694657443056319366277420 | 2e-35 |

### Conrey 15.8

| Rang | Local (40 dps, affichage) | Molin / PARI (affichage) | \u007cΔ\u007c des chaînes affichées |
|---:|---|---|---:|
| 1 | 4.40670023980367373719937803757298205 | 4.4067002398036737371993780375729820542 | 4.2e-36 |
| 2 | 6.59078267021547088948133257241464069 | 6.5907826702154708894813325724146406850 | 5e-36 |
| 3 | 8.2645016539034249559622725883592349 | 8.2645016539034249559622725883592349002 | 2e-37 |
| 4 | 10.3262042503149412504441259741175657 | 10.326204250314941250444125974117565734 | 3.4e-35 |
| 5 | 13.0289562739916393005292866125075241 | 13.028956273991639300529286612507524052 | 4.8e-35 |
| 6 | 14.4644611344633431787718406511262041 | 14.464461134463343178771840651126204110 | 1e-35 |
| 7 | 16.1718928849898424074159070632160022 | 16.171892884989842407415907063216002236 | 3.6e-35 |
| 8 | 17.4447642660956702334834408678860314 | 17.444764266095670233483440867886031438 | 3.8e-35 |
| 9 | 19.1378424241927806232584172227031588 | 19.137842424192780623258417222703158795 | 5e-36 |

## Ordonnées locales sous T=25 restant sans comparaison externe

| Conrey | Nombre | Ordinées locales 20 < gamma < 25 |
|---|---:|---|
| 15.2 | 3 | `20.6276317759696503061509492892928215`, `21.883973024208911650321337567140856`, `23.3384800177598776614370034132301448` |
| 15.14 | 4 | `20.662363051410306773038882163646401`, `22.1763976882137610875602048530011719`, `23.3679992386749353766036263213775203`, `24.9035011690429676759519645233408587` |
| 15.8 | 3 | `21.2846436971018487270595972736621467`, `23.1489453949247701890128702116736991`, `24.0718583151786825783290611481884112` |

Ces **10 candidats supplémentaires n'ont pas été confrontés à un output PARI T=25**, donc statut *NON COMPARÉ*, pas concordant par extrapolation. Ce rapprochement est une première source indépendante rapportée pour les 27 valeurs sous T=20. Il ne prouve pas l'absence de zéros supplémentaires, y compris sous T=20.

## Contrôle des conventions

Avec U(15) dans l'ordre (1,2,4,7,8,11,13,14), définir pour les unités
chi_(1,b)(n) = (-1)^[n mod 3 = 2] * i^(b log_2(n mod 5)), où log_2 est le logarithme discret modulo 5. Mapping déjà vérifié par le script local [verify_signed_character_conventions.py](verify_signed_character_conventions.py) et cohérent avec les Conrey 15.2, 15.14, 15.8 explicitement rapportés dans les listes de Molin :

| Conrey | (a,b) | chi(1),chi(2),chi(4),chi(7),chi(8),chi(11),chi(13),chi(14) | Parité |
|---|---|---|---|
| 15.2 | (1,1) | +1, -i, -1, +i, +i, -1, -i, +1 | paire |
| 15.14 | (1,2) | +1, +1, +1, -1, +1, -1, -1, -1 | impaire, réelle |
| 15.8 | (1,3) | +1, +i, -1, -i, -i, -1, +i, +1 | paire |

Les deux caractères complexes 15.2 et 15.8 sont conjugués : L(s,bar(chi)) = conj(L(conj(s),chi)). Le signe de gamma change entre un caractère et son conjugué. **Les listes positives 15.2 et 15.8 ne sont donc ni permutées ni appariées par conjugaison dans cette confrontation** ; elles sont comparées à leurs étiquettes directes. Les nombres rapportés ne contiennent pas les zéros d'ordonnée négative ni les données sur les zéros hors droite.

## Étendre la procédure à T=25 : instruction proposée, NON EXÉCUTÉE ici

```gp
\\p 50
g=znstar(15,1);
forvec(c=g.cyc,
  if(zncharconductor(g,c)==15,
    print([15,znconreyexp(g,c),lfunzeros([g,c],25)])
  )
)
```

Pour une seconde exploration, augmenter le maillage en utilisant par exemple `lfunzeros([g,c],25,16)` et comparer les rangs avec la valeur par défaut `divz=8`, ainsi que l'intervalle `lfunzeros([g,c],[20,25],16)`. **Ces commandes sont proposées, pas lancées.** Conserver la version de PARI/GP, sa précision, son maillage, le stdout exact, la date, les choix de caractères et le hash des sorties avant de rapporter un nouveau nombre de concordances.

**Réserve documentée par PARI/GP** : `lfunzeros` utilise un algorithme qualifié de naïf dans sa documentation, *pouvant manquer des zéros* ; il suppose notamment une séparation minimale entre zéros successifs et la simplicité des zéros hors centre. [Documentation officielle de lfunzeros](https://pari.math.u-bordeaux.fr/dochtml/ref-stable/_L_minusfunctions.html). Le changement 20→25 ou l'augmentation du maillage ne peut donc pas, à lui seul, produire un certificat d'exhaustivité.

## Statuts distincts, sans promotion

| Question | Statut démontré ici |
|---|---|
| 27 comparaisons de décimales q15 sous T=20, même étiquette et même rang | **OUI : 27/27** |
| Les 37 valeurs locales sous T=25 ont été confrontées | **NON : 27/37, 10 en attente** |
| Source numérique rapportée distincte du calcul local mpmath | **OUI, via le courriel ; PARI/GP non réexécuté ici** |
| Conventions de caractères | **Cohérence : table locale exacte et étiquettes Conrey du courriel** |
| Précision mathématiquement garantie des zéros individuels | **NON** |
| Isolation rigoureuse et comptage exhaustif | **NON** |
| Validation de GRH/LI ou densité de course de nombres premiers | **NON** |

La publication Bennett–Martin–O'Bryant–Rechnitzer (2021) peut porter des garanties régionales, mais **aucun appariement ligne à ligne des 27 nombres du courriel à un certificat individuel de cet article n'a été réalisé ici**. La présence d'un résultat publié ne transfère pas automatiquement sa certification à nos décimales.

**Version des historiques** : la [PR #4](https://github.com/alexcour/couret-finite-verifications/pull/4) a été fusionnée le 12 octobre 2026 (voir la [réconciliation PR #26](https://github.com/alexcour/couret-finite-verifications/pull/26)). Les mentions « PR #4 draft / ne pas merger » dans les notes datées du 12 octobre sont des états historiques dépassés, sans changement des réserves scientifiques.

**Suite à réaliser** : obtenir un véritable jeu T=25 auprès de PARI ou d'une archive vérifiable ; refaire l'audit des conventions positives/signées ; vérifier les 10 nouvelles valeurs avec tolérances documentées ; puis séparer une éventuelle certification de localisation de la certification du nombre total de zéros. Aucune de ces opérations n'est considérée réalisée.
