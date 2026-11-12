# MOD-OBS-01 — protocole d'audit et d'experimentation fini
Date: 2026-10-11. Statut: comparaison exploratoire; les resultats pour n=18 ont ete observes dans les archives precedentes. Les valeurs non encore produites au gel concernent n=24,30,36.

## Domaine exact
Pour tout n >= 5: C_n = Z/nZ. X_n = {S subset of C_n \\ {0}: |S|=3}; matrice orientee A_S(x,y)=1_(y-x in S). O(S)=A_S^2, represente par le vecteur de convolution ordonnee c_S(r)=#{(a,b) in S^2:a+b=r mod n}. Les fibres sont les classes d'egalite c_S=c_T, sans quotient par isomorphisme. On distingue une variante avec zero admis, X_n^+={S subset C_n:|S|=3}.

## Mesures a calculer
1. Cardinal de X_n et distribution exacte des tailles des fibres, nombre de paires non ordonnees confondues, n=6,8,12,18,24,30,36, zero exclu, et n=18 zero admis.
2. Candidature de formule pour n multiple de 6, zero exclu: f_1=C(n-2,2)-2; f_2=1/2 C(n-2,3)-n+7; f_4=n/2-3; toutes autres tailles nulles. La formule est deduite du theoreme STROBO candidat et demande revue independante. Pour n pair non multiple de 6: f_1=C(n-2,2), f_2=1/2 C(n-2,3), pas de taille4. Impair: toutes fibres simples.
3. Modele de questions: q_x(S)=1 si x in S sinon 0, x in {1,...,n-1}. Cout unitaire. O(S) connu sans cout. Trois regimes a separer : (i) reconstruction adaptative, strategie dependante de la fibre O et des reponses; (ii) determination d'une propriete boolenne cible dans les memes conditions; (iii) suite globale fixe non adaptative de questions commune a toutes les fibres. Le cout de calcul de O et de la preuve n'est pas compte.
4. Pour n=18, prouver une borne inferieure du nombre de questions globales fixes par couverture exhaustive des paires et fournir le temoin. Comparer au pire cas conditionnel adaptatif, calcul DP minimax exact.
5. Propriete sans interrogation: P_h(S)=[h in S] pour n pair n=2h. Test de la formule P_h=c_S(0) mod 2, valable si 0 exclu. Cibles supplementaires exploratoires: appartenance a 1, generation du groupe gcd(n,S)=1, triangle oriente tr(A^3)>0, symetrie S=-S, et test d'une coupure predeterminee du domaine.
6. Recherche d'un contre-exemple aux assertions : |fibre| <=4; cout adaptatif reconstruction <=2 si 6|n, cout <=1 sinon (n pair), 0 impair. N=6,8,12,18,24,30,36.
7. Double implementation obligatoire: convolution via boucle ordonnee et convolution via transformee de histogramme d'entiers; verifier concordance des fibres et de la distribution.

## Conclusions recevables
Les sorties finies ne sont ni des preuves de formule generale, ni un audit d'originalite. Pour n=24,30,36, les controles numeriques sont de nouvelles predictions testees dans ce protocole et non des corroborations independantes d'un meme modele historique. Ne pas rapprocher directement ces couts unitaires de couts reels de certification IA.

## Limites / stop rules
Si divergence entre implementions, arret et signalement. Aucun artefact nouveau ne doit etre qualifie de resultat arbitre sans audit externe. Les parties STROBO et CU-LOG-SPEC restent versionnees separement.