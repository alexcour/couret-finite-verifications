# CU-LOG-SPEC-02 — Protocole fige, AVANT calcul des nouvelles fenetres

Date : 2026-10-11 (Europe/Paris). Branche documentaire precedente : PR #10 CU-LOG-SPEC-01.

## Objet

Tester si les energies de Cayley sur U(30) et U(210) contiennent une information quadratique supplementaire par rapport a la decompositon complete en caracteres de Dirichlet, en distinguant **identite algebrique**, **covariance limite conditionnelle**, **observation arithmetique finie**. Aucun resultat d'originalite revendique.

## Resultat structurel attendu (sans utiliser de nombres premiers)

Pour chaque q=30,210, les characters chi de U(q) diagonalisent toutes les convolutions du groupe, notamment A30=I+R11+R29 et A210=I+(R11+R11^-1)/2+(R29+R29^-1)/2. Le projecteur spectral est somme de projecteurs des caracteres possedant la meme valeur propre. Verifier numeriquement l'identite a precision flottante fixee (<1e-10). Ce fait est CLASSIQUE.

## Modele de reference (Rubinstein-Sarnak, SOUS GRH et hypotheses LI)

Covariance asymptotique sous mesure logarithmique du processus normalise de course des premiers : K_ab = somme_{chi non principale} W_chi chi(a) conjugue(chi(b)), ou W_chi est la somme sur les zeros non triviaux de L(s,chi*) induisant chi : somme_gamma 1/(1/4+gamma^2). Pour chi* primitive de conducteur f et parite delta, calculer W_chi par l'identite L'/L en s=1 et facteurs gamma. Utiliser mpmath avec 45 chiffres. Comparer les **rapports de traces de covariance**, et NON E[F] ni des p-valeurs des F sur des fenetres finies. La moyenne limite -C_q(a), C_q(a)=-1+nombre de racines b^2=a dans U(q), sera traitee separement. La distribution limite est en general NON gaussienne.

## Nouvel echantillon FINI non consulte avant gel

Comptages p <= 90 000 000, avec points de coupure 30M,45M,60M,75M,90M. Ancien CU-LOG-SPEC-01 ne depasse pas 30M. **Nouvelles fenetres disjointes** (30M,45M], (45M,60M], (60M,75M], (75M,90M], modules q=30,210. **Nouveaux points cumules** 45M,60M,75M,90M. Calculer pour chaque fenetre les proportions d'energie de U(210) relevee de U(30) et les repartitions spectrales q30; pour chaque point cumule les deux fractions dans l'observable normalisee du biais de Tchebychev, avec et sans correction de moyenne -C_q. Aucun seuil finement ajuste ni conclusion inferrentielle annoncee.

## Temoins et limites

1. Refaire les comptes p<=30M et comparer aux 48 classes du JSON deja archive dans CU-LOG-SPEC-01.
2. Refaire independamment les 48 comptes des quatre nouvelles fenetres par un crible a impairs seuls, sans reutiliser les resultats du premier crible.
3. Tester numeriquement que K commute avec A30, A210 et que les valeurs propres de K sont phi(q)W_chi.
4. Verifier l'identite d'energie de Cayley = somme des energies des modes χ pour tous les nouveaux vecteurs.
5. Comparer les ratios de traces et de deuxiemes moments conditionnels au comportement fini sans les confondre : la loi stationnaire en log(x) n'est PAS une loi des fenetres lineaires disjointes.
6. Ne pas utiliser les donnees de zeros CU-BRUIT-02 en attente de confrontation independante; les W sont calcules sans catalogue de zeros via L'/L(1,chi*) et doivent etre audites independamment.
7. Rapport des quatre observations sans selection, et non demonstration d'une nouvelle asymptotique.

Aucun test de significativite ne peut etre valide sans definir une loi d'echantillonnage justifiee pour la sequence deterministe des nombres premiers. Aucun seuil de decouverte ou score de nouveaute n'est preregistre.