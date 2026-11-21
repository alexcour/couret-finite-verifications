# PACK FRÉDÉRIC — Mise à jour de publication ouverte et vérification externe

**État de coordination : 9 octobre 2026.** Complément opérationnel du [pack maître](README.md), qui ne remplace pas ses [errata](MANDATORY_ERRATA_AND_CHANGES.md), son [inventaire](MATHEMATICAL_OBJECTS_REGISTER.md) ni le [registre des publications](PUBLICATION_AND_ARCHIVE_REGISTER.md).

**Décision de l'auteur :** rendre accessibles tous les résultats scientifiques transmissibles, positifs, négatifs, falsifiés, non audités, avec leurs sources et leur statut ; **distribution passive** par site, GitHub et archives pérennes. **Ne pas engager de prospection individuelle**, ni annoncer de reconnaissance ou de relecture par les pairs. Inviter les spécialistes à critiquer librement les objets définis. Cette ouverture ne lève **aucun embargo PI/FCI**, droit de tiers ni protection de données personnelles.

## A. Ce qui est nouvellement accessible au public (liens vérifiés dans GitHub)

| Objet | Porte publique / matériel exact | Statut qui peut être affiché |
|---|---|---|
| Index transversal | [OPEN_REVIEW_PORTFOLIO.md](https://github.com/alexcour/couret-finite-verifications/blob/main/OPEN_REVIEW_PORTFOLIO.md) ; [issue générale #6](https://github.com/alexcour/couret-finite-verifications/issues/6) | Appel public à objections, antériorités et replays ; aucun évaluateur externe confirmé |
| Cayley 10A6/10C3/10B1 | [Manuscrit, codes, limites](https://github.com/alexcour/cayley-prime-translation-cospectrality) ; [issue ciblée #7](https://github.com/alexcour/cayley-prime-translation-cospectrality/issues/7) | PUBLIC REVIEW ; nouveauté **NON AUDITÉE** ; antériorité Meng 1998 ouverte ; CI finie ≠ preuve générale |
| G30, 56 triplets de U(30) | [Dossier de reproduction](https://github.com/alexcour/couret-finite-verifications/tree/main/research/open-reproduction/g30) ; [source Python](https://github.com/alexcour/couret-finite-verifications/blob/main/research/open-reproduction/g30/verify_g30_gate_b.py) ; [résultats JSON](https://github.com/alexcour/couret-finite-verifications/blob/main/research/open-reproduction/g30/RESULTS_G30_GATE_B_2026-10-07.json) | Vérification finie exacte, source indépendante disponible ; 10 classes spectrales complexes, 2 classes de magnitudes au carré 24/32 ; fibre de 5 triplets, **une seule classe d'isomorphisme de digraphes** |
| Barning–Hall, 2310 | [Paquet public](https://github.com/alexcour/couret-finite-verifications/tree/main/research/open-reproduction/barning-hall) ; [README](https://github.com/alexcour/couret-finite-verifications/blob/main/research/open-reproduction/barning-hall/README.md) | Deux témoins entiers figés, positif `174404/50265` et négatif `-723304493/208329425`, scripts et vérifications exactes ; publication **partielle** de PUB-03, pas le dossier 17/330 complet |
| SPEC-OBS-07/08 | [PR recherche #6](https://github.com/alexcour/cayley-prime-translation-cospectrality/pull/6) ; [code exact SPEC-OBS-08](https://github.com/alexcour/cayley-prime-translation-cospectrality/blob/research/spec-obs-01-rooted-observations/reproducibility/verify_spec_obs_08.py) ; [JSON gelé](https://github.com/alexcour/cayley-prime-translation-cospectrality/blob/research/spec-obs-01-rooted-observations/reproducibility/results/spec_obs_08_exact_summary.json) ; [issue #8](https://github.com/alexcour/cayley-prime-translation-cospectrality/issues/8) | Code présent **sur la branche du dépôt Cayley**, non sur finite-verifications ; 1068 graphes du corpus fini ; comparaison de motifs ≠ théorème de complétude universelle |
| Falsifications | [PUBLIC_FALSIFICATIONS.md](https://github.com/alexcour/couret-finite-verifications/blob/main/PUBLIC_FALSIFICATIONS.md) ; [programme indépendant F-001 C++](https://github.com/alexcour/couret-finite-verifications/blob/main/research/open-reproduction/falsifications/verify_mod30_prime_proportion.cpp) | Documenter les résultats réfutés **aussi visiblement** que les réussites ; le calcul `p<=10^9` donne 19067732/50847534 = 0,374998166…, pas « 0,378 mesuré » |

**Attention aux badges CI :** les nouveaux workflows [G30](https://github.com/alexcour/couret-finite-verifications/blob/main/.github/workflows/g30-open-reproduction.yml) et [BH2310](https://github.com/alexcour/couret-finite-verifications/blob/main/.github/workflows/barning-hall-open-reproduction.yml) ont été ajoutés ; **ne déclarer PASS sur GitHub Actions qu'après lecture de leur job réel au SHA final**. Les rapports précédents relatent des replays locaux, distincts d'une nouvelle certification par CI.

## B. Exécutions reproductibles à afficher publiquement

```bash
# G30 ; Python bibliothèque standard
cd research/open-reproduction/g30
cp RESULTS_G30_GATE_B_2026-10-07.json /tmp/g30-frozen.json
python3 verify_g30_gate_b.py
cmp /tmp/g30-frozen.json RESULTS_G30_GATE_B_2026-10-07.json

# Barning–Hall N=2310 ; Python bibliothèque standard
cd ../barning-hall
sha256sum rayleigh_vector_2310.tsv rayleigh_vector_2310_negatif.tsv
python3 verify_bh2310_certificate.py
python3 verify_bh2310_negative_archived.py

# F-001 ; C++17, crible segmenté
cd ../falsifications
g++ -std=c++17 -O2 -Wall -Wextra verify_mod30_prime_proportion.cpp -o /tmp/verify_mod30
/tmp/verify_mod30 1000000000

# SPEC-OBS ; à lancer dans un checkout de la branche Cayley research/spec-obs-01-rooted-observations
python3 reproducibility/verify_spec_obs_07.py /tmp/spec_obs_07.json
python3 reproducibility/verify_spec_obs_08.py /tmp/spec_obs_08.json
```

Pour SPEC-OBS-08, installer `networkx>=3`. **Ne pas prétendre à un replay indépendant effectué dans ce pack** sans son propre journal d'exécution. Le calcul G30 a été rejoué localement, mais le contrôle nouveau est limité au corpus et au code déclarés. Les vérificateurs BH2310 montrent des inégalités entières pour les témoins archivés, et non une théorie Ramanujan universelle.

## C. Ce qui manque encore : ne pas maquiller les dettes

1. **Barning–Hall 17 / 330 :** le rapport Drive PUB-03 fait état de certificats exacts et d'implémentations indépendantes ; les fichiers gelés correspondants ne sont **pas encore inclus** dans le paquet GitHub ci-dessus. Retrouver les octets originaux, leurs hachages et scripts de contrôle, ou reconstruire indépendamment, **avant** de dire « paquet PUB-03 complet ».
2. **Barning–Hall négatif 2310 :** le nouveau contrôleur entier utilise `build_model` du vérificateur positif ; il **ne constitue pas** une seconde reconstruction du modèle entièrement indépendante. Le vieux script de découverte négative utilise NumPy/SciPy.
3. **SPEC-OBS :** script et JSON retrouvés dans le dépôt Cayley sur une **branche de recherche** non fusionnée ; nouveau replay propre, revue d'antériorité et CI dédiée à vérifier. L'erratum SPEC-OBS-09 doit primer sur les anciennes formulations — paire D9 historiquement citée **non cospectrale**.
4. **Cayley :** priorité des théorèmes 10A6/10C3/10B1 **ouverte**, corrections de preuve et comparaisons primaire Meng/Brown/Mönius ouvertes ; un scan fini ne tranche pas ces points.
5. **CU-BRUIT, Lean, autres familles :** classer les hypothèses GRH+LI, la non-exhaustivité des zéros, les `sorry`/axiomes et la compilation par commit. Ne pas transférer un statut de validation entre modules.
6. **Publication sur le site :** aucune synchronisation vérifiée ici ; la page « publications scientifiques / independent review » reste à créer ou vérifier.
7. **DOI :** aucun **nouveau** DOI pour G30, Barning–Hall ou SPEC-OBS n'est confirmé créé au titre de ces fichiers. Ne pas doubler les trois notices déjà publiées.

## D. Instructions concrètes pour le site — diffusion purement passive

Créer une entrée permanente dans la navigation, intitulée **Publications scientifiques / Independent mathematical review**. Chaque objet doit avoir une URL indexable autonome et les liens directs vers *statement / reproducibility / data / limitations / criticism*. Une courte présentation suffit :

> **FR** — « Ces travaux en mathématiques finies et en recherche computationnelle sont librement soumis à la contradiction. Les documents comprennent des démonstrations, programmes, données et résultats réfutés. Leur diffusion n'implique ni évaluation par des pairs ni originalité établie. Toute correction, antériorité ou reproduction indépendante peut être soumise dans les issues GitHub correspondantes. »
>
> **EN** — “These finite mathematics and computational research materials are offered for independent scrutiny, including counterexamples, corrections and prior art. The archive preserves reproducibility code, data, failed hypotheses and precise scope limitations. Public availability does not imply peer review or established novelty. Researchers are welcome to post specific findings to the linked GitHub issues.”

Frédéric n'a pas à prospecter des chercheurs par mail ; les issues demeurent ouvertes et consultables. Les lecteurs doivent pouvoir vérifier **sans** demander de fichiers Drive privés.

**Référencement :** titre disciplinaire précis, résumé anglais, mots-clés, PDF à texte sélectionnable, description du corpus, licence appropriée, version/commit, `CITATION.cff`, métadonnées Zenodo cohérentes. Retirer toute clause qui imposerait une permission/notification de l'auteur **pour les éléments effectivement publiés sous licence ouverte** ; ne pas modifier les autres droits à l'aveugle.

## E. Règle Zenodo / HAL / arXiv

- **Déjà publiés :** finite-verifications v1.0.0 DOI `10.5281/zenodo.22978365` ; HOL-01 p=7 v1.1.1 DOI `10.5281/zenodo.22978389` ; humain–IA v1.1.0 DOI `10.5281/zenodo.23079572`. Réutiliser leurs liens, sans redéposer ces mêmes objets. DOI repris de leurs registres/dépôts, **sans contrôle externe des notices Zenodo effectué dans ce complément**.
- **Nouveau dépôt candidat** = unité délimitée, fichier exact, droits vérifiés, hachages, dépendances figées, instructions de replay, contrôles CI au SHA final, métadonnées d'auteur **validées** et limite scientifique lisible.
- En cas de doute : publier/compléter GitHub et son statut public, mais **ne pas fabriquer ni annoncer un DOI**.
- Cayley est en **PUBLIC REVIEW 0.1.x**, avec interdiction interne actuelle de release scientifique stable : ne pas modifier le release gate implicitement. Une mise en ligne déjà existante n'autorise pas un nouveau dépôt Zenodo sans décision distincte.
- Le guide V7 reste une **notice de pilotage interne**, pas une archive scientifique à déposer telle quelle.

## F. Protections avant exposition

Exclure FCI / brevet / second dossier PI et leurs détails techniques non autorisés ; données et courriers personnels ; corpus impliquant des tiers sans droits ; œuvres attribuées à Bernard Couret dont les droits ne sont pas éclaircis ; dépôts RH privés ; documents historiques marqués ne pas transmettre. Ne pas rendre un **dossier Drive parent entier public** pour faciliter la publication : exporter seulement un lot de sources auditées. Le fait d'être sous un Drive « CURRENT » ou un dépôt GitHub ne suffit pas à lever ces contraintes.

## G. Critère « pack prêt pour Frédéric »

Le pack est mis à jour lorsque ce complément figure sur la branche PR #7, est lié depuis le README de la PR et depuis le document maître Drive ; les URLs publiques ont été vérifiées. Cela n'implique pas : dépôt HAL/Zenodo, publication du site, envoi à Frédéric, changement de permissions Drive, revue humaine obtenue ou garantie d'exhaustivité du Drive.

**Objectif : rendre la critique possible, sans chercher une approbation personnelle.**
