# Decision de diffusion scientifique : Zenodo avant relecture externe
Date : 11 octobre 2026
Auteur : Alexandre Couret (chercheur independant, France)

## Decision

Le depot Zenodo d'une **archive de recherche non evaluee par les pairs** est autorise
**avant** la relecture mathematique humaine independante. Le but est de rendre les
objets, leurs codes, leurs certificats et leurs contre-exemples lisibles, datables,
citables et ouverts a la critique. Le DOI identifie les octets du depot ; il ne
prouve ni exactitude, ni nouveaute, ni priorite.

Cette decision remplace uniquement les anciens blocages de Zenodo motives par
l'absence de relecture externe. Elle ne leve pas les limites des enonces, les
reservations sur les antecedents, les obligations de confidentialite et de droits,
ni les exigences distinctes pour une publication scientifique stable.

## Parcours de publication

1. Fixer une archive autonome : perimetre exact, provenance, fichiers sources,
   resultats, scripts, commandes de replay, version, commit de reference et SHA-256.
2. Verifier l'integrite et documenter sincerement les tests locaux effectues ;
   decrire ceux qui n'ont pas ete executes ou qui manquent. Aucune verification
   locale n'est deguisee en expertise independante.
3. Eliminer les donnees privees, les contenus tiers sans droits et les elements
   industriels ou brevets sensibles (FCI). Verifier la licence par categorie.
4. Deposer avec les mots **UNREVIEWED RESEARCH ARCHIVE / NOT PEER REVIEWED**,
   un resume sans revendication de priorite, les limites et antecedents connus.
5. Publier avec un DOI de VERSION reel, puis enregistrer le DOI, le commit,
   les checksums et la date effective du depot dans le registre GitHub.
6. Demander alors des relectures contradictoires, y compris des objections,
   des reproductibilites negatives et des references anterieures.
7. Conserver l'archive initiale ; corriger avec un erratum ou une nouvelle version
   liee et dater les retraits eventuels.

## Portes qui demeurent ouvertes

- E : la validite mathematique generale peut rester une proposition interne.
- Q : qualifier exactement chaque verification locale et ses limites.
- N : non auditee jusqu'a comparaison suffisante aux sources anterieures.
- R : relecture independante ouverte ; elle n'est plus un prealable a l'archive.
- v1.0.0 « stable / valide » : reste separe du statut 0.x de depot de travail.

La publication Zenodo et les procedures HAL/arXiv ne sont pas confondues.
Aucun DOI nouveau n'est suppose exister tant que le depot Zenodo n'a pas
effectivement ete publie et lu en retour sur la plateforme.

## Priorites de depots de travail

- G30 : 56 triplets, dix classes spectrales complexes, distinction 24/32.
- MOD-OBS : reconstruction et decision de proprietes sous oracles bornes ;
  conserver les modeles d'oracle distincts et les contre-exemples.
- NTK-OBS-01 / 02 : noyaux PSD fixes puis prescrits variables,
  calculs exacts et distinction nette avec l'entrainement reel.
- CU-LOG-SPEC-02 : resultat exploratoire negatif sur le seuil 5 %.
- CU-MOD-OBS-05 : mutation / fraicheur, seulement comme pilote artificiel.
- Cayley 10A6/10C3/10B1 : preprint de relecture 0.1.x possible,
  sans nouvelle revendication de priorite ; voir son propre RELEASE_GATE.

Ne pas dupliquer les archives publiques historiques :
- finite-verifications v1.0.0 : 10.5281/zenodo.22978365 ;
- HOL-01 v1.1.1 : 10.5281/zenodo.22978389 ;
- provenance humain-IA v1.1.0 : 10.5281/zenodo.23079572.

Cette note exprime une politique de diffusion ; elle ne cree ni Zenodo DOI,
ni release GitHub et n'effectue aucun depot distant par elle-meme.

Aide officielle : https://help.zenodo.org/docs/get-started/quickstart/
