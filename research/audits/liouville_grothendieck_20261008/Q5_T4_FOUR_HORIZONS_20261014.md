# Q5 — quatre horizons finis, signal tronqué T=4 (14 octobre 2026)

Protocole du nouvel instrument `certify_t4_four_horizons_20261014.py` : mesurer sur les quatre fenêtres uniformes en temps logarithmique `[log(2),log(B)]`, pour B=1024, 4096, 16384, 65536, les probabilités de signe de la trajectoire arithmétique, du signal spectral à exactement deux fréquences et de la loi de Haar à deux phases déjà certifiée.

Chaque occupation temporelle est encadrée par un recouvrement adaptatif de cellules rationnelles en x, propagation d'intervalles de sinus et cosinus, borne de dérivée 4 et charge complète des cellules non résolues. Chaque occupation arithmétique est obtenue par le crible exact et la somme des durées logarithmiques de signes positifs. Les reçus préexistants de racines et de probabilité Haar sont inchangés.

Les trois quantités sont affichées séparément : `|F_B-F_[4,B]|`, `|F_[4,B]-p_4|`, `|F_B-p_4|`. Elles permettent une vérification de l'inégalité triangulaire à horizon fixe, mais **ne démontrent aucune borne uniforme en B** et ne comparent pas à la loi de phase complète `delta`. La troisième erreur `|p_4-delta|` est inconnue ici.

Les mêmes outils de fonctions élémentaires et les mêmes certificats Arb sont utilisés ; le nouveau script n'est pas une seconde validation de leurs hypothèses. Il refuse les modes de calcul tronqués, les masses non résolues excessives et toute discordance à B=65536 avec le certificat antérieur.

**Statut à l'ouverture : calcul soumis à CI, valeurs numériques non promues jusqu'à exécution réussie.** Ne pas fusionner PR #27 ni publier une densité arithmétique.