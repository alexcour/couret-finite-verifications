# COURET–OAI–BRIDGE–01 — T94–T97 : obstruction cyclotomique au contrôle uniforme générique

**Branche de recherche. Identités classiques et contre-exemples algébriques exacts. Pas de revendication de nouveauté, de résultat RH, de borne nouvelle du grand crible ou de progrès vers T89 sans hypothèses arithmétiques.**

## T94 [D, classique] — vecteurs entiers de spectre nul

Pour les fréquences réduites non nulles \(\mathcal F_Q^*=\{a/q:2\le q\le Q,(q,30)=1,(a,q)=1\}\), poser \(M_Q=|\mathcal F_Q^*|\) et \(C_Q(z)=\prod_{2\le q\le Q,(q,30)=1}\Phi_q(z)\), un polynôme entier unitaire de degré \(M_Q\).

Si \(N>M_Q\), le polynôme \(B(z)=z C_Q(z)\) pour \(N=M_Q+1\), ou \(B(z)=z C_Q(z)(1+z^{N-M_Q-1})\) si \(N>M_Q+1\), définit un vecteur entier non nul \(b_h\), supporté sur les shifts positifs de 1 à N (avec coefficients extrêmes non nuls). Toutes les racines primitives correspondant à \(\mathcal F_Q^*\) sont des racines de B. Donc \(S_b(\alpha)=0\) pour toutes ces fréquences et \(D_Q(b)=0\) exactement. Dans le cas N>M_Q+1, la multiplication par (1+z^k) préserve l'annulation ; la construction couvre également les cas de recouvrement des coefficients.

## T95 [D, élémentaire] — obstruction du rang de Gram

\(G_{h,k}=K_Q(h-k)\) est Gram réelle symétrique positive, \(\mathrm{tr}\,G=N M_Q\) et \(\mathrm{rank}\,G\le M_Q\). Ainsi si \(N>M_Q\), G a une direction propre nulle, et une direction réelle positive avec quotient \(D_Q\ge N/M_Q\). Pour \(Q^2\le N\), \(M_Q\le Q(Q-1)/2<N/2\) : il existe donc des suites avec D=0 et d'autres avec D>2. Ces conclusions portent uniquement sur les suites arbitraires, pas sur les coefficients Möbius.

## T96 [D, exemple entier] — Q=7, N=49

\(M_7=6\), \(K_7(d)=6\) si 7 divise d, et -1 sinon. Le vecteur \(b_h=K_7(h)\), \(1\le h\le49\), a \(E=6N\), forme quadratique \(6N^2\), et \(D=N/6=49/6\) exactement. Le vecteur cyclotomique de T94 a simultanément D=0 dans la même géométrie.

## T97 [M] — portée pour T89

Une borne universelle \(\sup_{b\ne0}|D_Q(b)-1|\to0\) dans le régime \(Q^2\asymp N\) est impossible. Le grand crible borne l'énergie totale mais n'impose pas son équidistribution autour de la référence aléatoire. Il faut une hypothèse arithmétique exploitable sur les vecteurs produits par Möbius, et une uniformité contrôlée en p,Q,X. Le verrou T89 demeure **OUVERT**. La construction cyclotomique n'est pas un contre-exemple de Möbius.

## Réplication exacte

Protocole pré-calcul : `research/experiments/BRIDGE_EXP08_CYCLOTOMIC_PROTOCOL.md` commit `53daeb6c8ccacb451b684e0c19629f549a2c63e9`. Vérification sur Q=7,11,13,17,23,29,49 avec N=Q² : degrés, racines par divisibilité exacte dans Z[z], coefficients extrêmes non nuls et forme de Gram entière = 0. Les sept cas PASS. Contrôle positif Q=7 : D=49/6 PASS. Implémentation Python/SymPy ; code SHA256 `35ecc18103dd10a5b3fbf983dc881d36fe833febe179dc747a1a5fbe2122749a`; JSON SHA256 `69dcb795d67df0ed8ccb2f411c7ed48e929c93a05b0384ed04772446b0fb71c5`. La première assertion du comparateur positif était mal écrite dans une tentative locale ; elle a été corrigée AVANT l'exécution réussie, sans modifier les paramètres.

Aucun gain asymptotique, aucune nouvelle estimation de Möbius, aucun résultat RH.