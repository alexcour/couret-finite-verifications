# CU-LOG-SPEC-02 — Covariance de fenetre (11 octobre 2026)

Statut : formule explicite classique, GRH pour interpretation par ordonnees reelles; aucun resultat original revendique. Aucun nouveau comptage de premiers.

Pour alpha=1/3 et un caractere primitif non principal chi de conducteur f|105, la somme des poids des zeros est V_chi = (2/3)(log(f/pi)-gamma_E) + delta*(log(2)/3+log(9/8)) - (log(2)/3)*Re chi(2), ou delta=0 ou 1 selon chi(-1). Ceci provient de la formule explicite de Guinand-Weil avec filtre (4/3 - 2/sqrt(3)*cos(gamma log 3))/(1/4+gamma^2) et noyau de Fourier H(u)=exp(-|u|/2)-(1/3)exp(|u|/2) si |u|<=log 3, zero sinon. Parmi les puissances premieres, seul n=2 intervient : H(log 3)=0.

Calcul direct sur les 47 caracteres et seconde somme par conducteurs/parites : trace totale 62.743969262140034; proportions pour q=15 (egal modulo 30) 0.047144227474899776, q=21 0.11257853933235426, q=35 0.3709136188824374; chi quadratique modulo 5 : 0.002486995480370163. Programmes window_covariance_classical.py et test_window_covariance_classical.py. Les trois tests passent en environnement local; le noyau est verifie par quadrature Simpson. Controle independant de l'integrale archimedienne : residu numerique 0.000217 a T=20000, compatible avec une queue inferieure a 0.0004. Aucun certificat formel ou audit externe.

ATTENTION : ratios de traces de covariance, et non esperances des ratios d'energies, probabilites d'ecarts ou p-values. GRH requise pour interpretation des sommes sur zeros comme variances; LI et la distribution logarithmique ajoutent d'autres hypotheses pour les courses de premiers. Le banc gaussien explore (300000 tirages, graine 21020261013) produit les moyennes F15=0.05642,F21=0.12192,F35=0.37635,Gchi5=0.00547, sans caractere inferentiel et SANS remplacement du protocole gelee ni du test futur. Le mode des fluctuations temporelles dans les fenetres lineaires et les biais doivent etre examines distinctement.

Les fenetres deja publiees jusqu'a 90 millions montrent deux depassements du seuil F30<0.05. La prochaine fenetre demeure strictement (100M,300M] ; ne pas calculer ses comptes avant audit du protocole, ne pas modifier horizon ni seuil apres observation. Relecture externe sollicitee, PR #10 en brouillon, aucune fusion.

Bibliographie : Rubinstein–Sarnak (1994), Granville–Martin (2006), Fiorilli–Martin, theorie classique de Guinand–Weil et fonctions L de Dirichlet.
