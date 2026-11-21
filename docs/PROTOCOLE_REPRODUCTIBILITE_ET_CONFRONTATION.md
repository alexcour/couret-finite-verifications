# Doctrine scientifique : reproductibilite, confrontation, corrigibilite

**Adoptee pour le programme de recherche Couret - 11 octobre 2026.**
**Portee :** recherches mathematiques et computationnelles du depot, notamment STROBO-C3, SPEC-OBS, Cayley, HOL et programmes connexes. Cette doctrine de travail ne constitue ni une preuve ni une declaration de priorite scientifique.

## Principe non negociable

> Un resultat doit pouvoir etre reproduit, conteste et abandonne si une contradiction verifiee apparait.

Une affirmation convaincante ou une sortie d'IA n'est pas une demonstration. Une verification informatique finie n'etablit pas un enonce universel. Deux executions par le meme auteur ne remplacent pas une verification independante. Une correspondance avec un expert ne vaut pas evaluation par les pairs sans examen explicite de la preuve.

## Les huit obligations

1. **Enonce precise et perimetre.** Definir objets, invariants, quantificateurs, conventions (oriente/non oriente, etiquete/isomorphe, ordonne/non ordonne, avec/sans zero) et contre-exemple qui invaliderait la proposition.
2. **Traçabilite integrale.** Associer a tout calcul les sources, versions, parametres, graine aleatoire, borne, environnement, instructions exactes, donnees d'entree, resultats machine et empreintes SHA-256.
3. **Reproduction a froid.** Reexecuter depuis une extraction/checkout propre; verifier les hashes et comparer les sorties *octet par octet* si l'execution est deterministe. Signaler les ecarts et fichiers manquants, ne jamais les masquer.
4. **Code contradictoire.** Tester avec une seconde methode conceptuellement differente; documenter les dependances communes entre implementations. Les reexecutions avec un code commun ne sont pas des validations independantes.
5. **Attaques explicites.** Chercher les petites valeurs limites, les degenerescences, les cas composees, les mauvaises interpretations d'invariants, les erreurs de normalisation et les contre-exemples.
6. **Journal d'erreurs.** Conserver les executions echouees, erreurs d'assertion, corrections, valeurs avant/apres et raisons du diagnostic; ne jamais effacer une anomalie du recit.
7. **Examen externe et litterature primaire.** Demander des objections precises a des specialistes, verifier les definitions et numeros de theoremes des travaux anterieurs, distinguer leurs hypotheses de celles de nos propositions. Une reponse aimable n'est pas une approbation scientifique.
8. **Communication proportionnee.** Ne pas presenter comme prouve, original ou publie ce qui ne l'est pas. Pas de revendication d'anteriorite; pas de depot final, merge, DOI/HAL/arXiv ou communication publique definitive sans autorisation explicite et controle des verrous.

## Etats separes et auditables

- **Q (calcul et provenance) :** domaine exact documente, sources et sorties identifiables, replay interne et/ou externe precisement qualifies.
- **E (enonce / preuve) :** proposition candidate, demonstration interne, controles humains externes eventuels - aucun glissement de statut automatique.
- **N (nouveaute / anteriorite) :** comparaison critique des publications *primaires*, theorem-by-theorem, verdict laisse **inconnu** tant que l'analyse est incomplete.
- **R (relecture independante) :** invite / en cours / objections / validation explicite, avec trace de ce qui a reellement ete examine.

**Chaque projet tient son journal des verrous ouverts, des experiences refutees et des corrections. Aucun verdict dans une colonne ne vaut verdict dans les autres.**

## Ordre de travail prefere

A. Obtenir un contre-exemple eventuel avant de chercher de plus grosses simulations.
B. Formuler une preuve minimale autonome, susceptible d'etre invalidee par une objection localisee.
C. Mettre les fichiers reproductibles au meme endroit que le texte, avec instructions et sommes de controle.
D. Comparer les travaux anterieurs selon leurs invariants et hypotheses exactes.
E. Solliciter **peu de personnes, mais avec une question explicite de falsification** et un dossier court.
F. Publier la critique et la correction apres autorisation; si un resultat tombe, archiver honnetement l'echec et les enseignements.

## Application immediate : STROBO-C3-02

Question : classification **exhaustive** des ensembles triples de Z/nZ dont les fonctions de representation **ordonnee** coïncident. Dissocier cette question de la classification d'isomorphisme de graphes de Cayley. La famille d'exemples d'ordre six etait deja proche des theoremes Chen-Yan (2021) et Yang-Chen (2012); l'originalite de l'exhaustivite est inconnue.

- Verification finie : n=3..84, avec et sans zero, *164 scans et 3 954 286 entrees de supports*; 21 600 stress pairs; aucun contre-exemple detecte dans ces bornes.
- Replay local : source et resultat hashes agrees; JSON reproduit byte-for-byte le 11/10/2026. **C'est un replay interne.**
- Premiere anomalie du harnais : representation d'un compte nul absent du Counter, corrigee; detail conserve.
- Restent ouverts : audit humain independant de la preuve, vraie implementation externe independante, revue d'anteriorite exhaustive, verdict sur l'isomorphisme.
- La PR #8 reste **DRAFT**, non fusionnee ; aucune declaration de priorite ni publication stable.

**Regle de mise a jour :** tout nouveau resultat est annote [SOURCE], [CALCUL REJOUE], [DEMONSTRATION INTERNE], [VERIFICATION EXTERNE] ou [HYPOTHESE], avec un lien verifiable vers sa preuve et sa provenance. Le silence d'un relecteur ou une demande de precisions ne constitue pas une approbation.

**Version :** 1.0 - 2026-10-11. Evolutions a documenter par commits, sans reecrire retroactivement le journal des erreurs.
