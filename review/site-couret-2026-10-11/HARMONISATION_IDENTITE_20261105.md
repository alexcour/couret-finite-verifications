# Harmonisation de l’identité publique — 5 novembre 2026

## État et périmètre

Complément documentaire de la PR #43 et du suivi COU-12. Les corrections scientifiques P0 publiées le 22 octobre, enregistrées dans COU-12, ne sont pas à réappliquer. Ce lot concerne l’identité, les liens et les anciennes vitrines.

**Déjà publié dans CAUSAL-PAIR-01 :**
- [Présentation FCI bilingue](https://github.com/alexcour/CAUSAL-PAIR-01/blob/main/docs/FCI_PRESENTATION_FR_EN.md), commit `1ca27d6d55740bca2d66dc00c1a984f752a936fc`.
- Identité, sigle développé et liens ajoutés au [README](https://github.com/alexcour/CAUSAL-PAIR-01/blob/main/README.md), commit `14faf1254ed62a1c6a4285e2d01807a13e553322`.

**Prêt mais non appliqué :** profil de l’organisation InterIA ; blocs ci-dessous pour PluXml, WordPress, HAL et LinkedIn.

**Accès constatés :** lecture publique possible ; écriture du profil `couret-interia/.github` refusée par l’intégration GitHub (403). Aucun accès CMS authentifié utilisé. Aucune modification de profil HAL/LinkedIn, aucune nouvelle publication WordPress/PluXml attestée.

Le suivi COU-12 confirme une autorisation et une publication P0 le 22 octobre. Les consignes plus anciennes « aucun P0 publié » ne décrivent donc plus cet état. Pour les nouveaux blocs ci-dessous, conserver une révision et une prévisualisation avant application ; ne pas remplacer des pages entières.

## Identité et signature de référence

Alexandre Couret  
Président de la société CONFIANCE  
Porteur du programme FCI — Formal Conservative Interposition

CONFIANCE est une SASU ; « Président » est l’intitulé documenté. La fonction dans la société et la responsabilité personnelle du programme ne doivent pas être converties sans pièce en déclaration de propriété intellectuelle ou de portage contractuel.

Le 5 novembre, Alexandre demande cette signature pour toutes les correspondances préparées en son nom, sauf instruction contraire. Ne pas réécrire les courriels déjà envoyés.

## 1. PluXml — couret-interia.fr : trois remplacements ciblés

### A. Insérer après le titre Accueil, avant les thèmes historiques

```html
<section aria-label="Responsable et recherche actuelle">
  <h2>Alexandre Couret — recherche et développement</h2>
  <p><strong>Président de la société CONFIANCE</strong><br>
  Porteur du programme FCI — Formal Conservative Interposition<br>
  Rasiguères, France.</p>
  <p>Les recherches mathématiques actuelles et leurs versions sont présentées sur le site Couret.
  FCI étudie séparément les conditions de sécurité des autorisations d’exécution et des reprises après incident.
  InterIA désigne une démarche de travail avec assistance IA, sous responsabilité humaine.</p>
  <p><a href="https://www.couretunification.fr/">Recherches mathématiques actuelles</a> ·
  <a href="https://github.com/alexcour/CAUSAL-PAIR-01/blob/main/docs/FCI_PRESENTATION_FR_EN.md">Présentation publique FCI</a> ·
  <a href="https://cv.hal.science/alexandre-couret">Profil HAL</a> ·
  <a href="https://www.couretunification.fr/contact/">Contact</a></p>
</section>
```

Conserver le reste de l’historique ; présenter les anciens thèmes comme tels plutôt que de les faire passer pour des résultats actuels.

### B. Remplacer seulement le bloc « RH Analytic Framework T1–T4 »

La page publique consultée le 5 novembre le présente parmi les projets principaux sans rectification proche. Le dépôt courant annonce le retrait comme preuve depuis le 13 octobre.

```html
<h3>T1′–T4 — archive historique rectifiée</h3>
<p>L’argument T1′–T4 a été retiré comme preuve de l’hypothèse de Riemann le 13 octobre 2026.
Les anciens textes sont conservés avec leur erratum ; ils ne décrivent pas un résultat établi.
Les travaux actuels sont présentés séparément.</p>
<p><a href="https://github.com/couret-interia/rh-analytic-framework-t1t4">Archive et statut courant</a> ·
<a href="https://github.com/alexcour/couret-finite-verifications/blob/main/ERRATUM_RH_T1T4_2026-10-13.md">Erratum</a> ·
<a href="https://www.couretunification.fr/publications/">Publications et ressources actuelles</a></p>
```

Ne pas modifier les archives ni les preuves pour une opération d’identité.

### C. Remplacer la promesse « Dès publication de la première version… »

```html
<p>Les références HAL, les archives Zenodo et les dossiers de travail sont regroupés dans le
<a href="https://www.couretunification.fr/publications/">catalogue public des publications et ressources</a>.
Chaque pièce précise son état éditorial et sa version. Une archive ne constitue pas à elle seule une évaluation par les pairs.</p>
```

Dans « Qui sommes-nous ? », remplacer la formulation générale sur les collaborateurs par :
« InterIA est une démarche de recherche indépendante conduite par Alexandre Couret, avec des outils d’assistance IA. Les contributions humaines extérieures sont attribuées dans les dossiers concernés. »
Conserver les attributions existantes et ne pas extrapoler cette phrase à des articles effectivement coécrits.

## 2. WordPress — /a-propos/ : identité sans refonte

Insérer ce bloc après l’introduction et avant le tableau des rôles, dans une copie de travail vérifiée. Préserver le tableau, les liens, les modules et les sources WPBakery/Salient.

```html
<section aria-label="Identité professionnelle">
  <h2>Alexandre Couret</h2>
  <p><strong>Président de la société CONFIANCE</strong><br>
  Porteur du programme FCI — Formal Conservative Interposition<br>
  Rasiguères, France.</p>
  <p>Je conduis des recherches indépendantes sur la reconstruction additive et spectrale et la traçabilité des travaux assistés par IA.
  Je porte également FCI, un programme de recherche et développement consacré à la sécurité des autorisations d’exécution et des reprises après incident.
  Ces deux domaines disposent de dossiers et de limites propres.</p>
  <p><a href="https://github.com/alexcour/CAUSAL-PAIR-01/blob/main/docs/FCI_PRESENTATION_FR_EN.md">Comprendre FCI et examiner ses exemples publics</a> ·
  <a href="https://cv.hal.science/alexandre-couret">Profil HAL</a> ·
  <a href="https://orcid.org/0009-0000-8246-7146">ORCID</a></p>
</section>
```

Ne pas remplacer « auteur scientifique » par une attribution institutionnelle. La qualité de dirigeant et la responsabilité personnelle sont compatibles avec la recherche indépendante.

## 3. WordPress — /contact/ : signature et demande précise

Ajouter sous les coordonnées existantes :

```html
<p><strong>Alexandre Couret</strong><br>
Président de la société CONFIANCE<br>
Porteur du programme FCI — Formal Conservative Interposition<br>
Rasiguères, France.</p>
<p>Pour un échange concernant FCI :
<a href="https://github.com/alexcour/CAUSAL-PAIR-01/blob/main/docs/FCI_PRESENTATION_FR_EN.md">présentation et exemples publics</a>.
Pour les mathématiques :
<a href="https://www.couretunification.fr/publications/">publications et dossiers</a>.</p>
```

Remplacer les deux paragraphes généraux commençant par « Ce programme manque cruellement… » et « Nous ne tirons de ce silence… » par :

```html
<p>Nous recherchons des relectures ciblées, des contre-exemples et des reproductions indépendantes.
Chaque demande indique le dossier, la version, la question et la nature du retour attendu.
Les avis d’orientation, relectures, reproductions et évaluations par les pairs sont documentés séparément pour chaque travail.</p>
```

Cette formulation ne révèle aucune correspondance privée et ne transforme pas un avis reçu en validation générale. Préserver les corrections et les autres éléments de la page ; ne pas réactualiser une sollicitation ANSSI sans nouvelle source.

## 4. HAL — ajout court à la présentation

Ajouter avant le descriptif scientifique, sans modifier les notices ou les affiliations d’articles :

> Alexandre Couret est président de la société CONFIANCE et porteur du programme FCI — Formal Conservative Interposition, consacré aux conditions de sécurité des autorisations d’exécution et des reprises après incident. Ses recherches mathématiques indépendantes portent notamment sur la reconstruction additive et spectrale et la vérification formelle. Les deux domaines sont présentés dans des dossiers distincts.

Lien complémentaire : https://github.com/alexcour/CAUSAL-PAIR-01/blob/main/docs/FCI_PRESENTATION_FR_EN.md

Vérifier séparément le rattachement du document méthodologique au CV : l’absence dans une liste extraite ne démontre pas l’absence de la notice. Aucun nouveau dépôt ni nouvelle soumission HAL dans ce lot.

## 5. LinkedIn — textes préparés, compte non modifié

Profil identifié depuis l’offre de SASU CONFIANCE :
https://fr.linkedin.com/in/alexandre-couret-11025a293

Ne pas utiliser un profil homonyme. Accès complet non vérifié.

**Titre proposé :**
Président de CONFIANCE | Porteur de FCI — Formal Conservative Interposition | Recherche indépendante, vérification et reprise après incident

**Présentation proposée :**
Je suis Alexandre Couret, président de la société CONFIANCE, à Rasiguères. Je porte FCI — Formal Conservative Interposition, un programme de recherche et développement sur les conditions de sécurité des autorisations d’exécution et des reprises après incident.

Je conduis également des recherches indépendantes sur la reconstruction additive et spectrale et la traçabilité des travaux assistés par IA. Les dossiers publics donnent accès aux versions, aux exemples reproductibles et aux limites des résultats.

Je recherche des échanges ciblés : contre-exemples, références, reproductions et relectures. Les résultats de modèles bornés et les garanties générales restent distingués.

**Liens à mettre en avant :**
- https://www.couretunification.fr/a-propos/
- https://cv.hal.science/alexandre-couret
- https://github.com/alexcour/CAUSAL-PAIR-01/blob/main/docs/FCI_PRESENTATION_FR_EN.md

L’offre « Associé » est à examiner séparément : ne pas changer les conditions, le type d’emploi ou les engagements sans les avoir précisés. Ce lot ne publie aucune offre nouvelle.

## 6. Profil GitHub de l’organisation InterIA

Le texte courant de `couret-interia/.github/profile/README.md` doit être préservé. Ajouter avant « Current public reference packages » :

```markdown
## Identity and separate research programmes

**Alexandre Couret**  
**Président de la société CONFIANCE**  
**Porteur du programme FCI — Formal Conservative Interposition**

Alexandre Couret leads this independent mathematical research initiative. He also leads **FCI (Formal Conservative Interposition)**, a separate research and development programme on execution authorization and recovery after incidents.

- [Author and mathematical research](https://www.couretunification.fr/a-propos/)
- [FCI: public presentation, bounded examples and research questions](https://github.com/alexcour/CAUSAL-PAIR-01/blob/main/docs/FCI_PRESENTATION_FR_EN.md)
- [Scientific profile on HAL](https://cv.hal.science/alexandre-couret)
- [Contact](https://www.couretunification.fr/contact/)

The company role and personal programme responsibilities are stated separately. These links do not imply institutional affiliation, industrial certification or a demonstrated FCI advantage.
```

Aligner aussi le lien « Publications » sur https://www.couretunification.fr/publications/.
Base lue : blob `f0b45d1f64ef80c06edce624b4480f4e05743061`.
L’écriture a été refusée (403) : ne pas annoncer ce profil comme modifié.

## Recette et réception

| Surface | État de ce lot | Preuve / suite |
|---|---|---|
| Présentation FCI et README CAUSAL-PAIR-01 | PUBLIÉ GITHUB | Deux commits cités ; fichier relu après écriture |
| Organisation GitHub InterIA | PRÊT / ACCÈS ÉCRITURE REFUSÉ | Diff ci-dessus ; appliquer avec droit adapté puis relire |
| couret-interia.fr | TEXTE PRÊT / NON APPLIQUÉ | Connexion PluXml requise ; révision et prévisualisation |
| /a-propos/ et /contact/ | TEXTE PRÊT / NON APPLIQUÉ | Connexion WordPress requise ; copies brouillon et contrôle |
| HAL | TEXTE PRÊT / NON APPLIQUÉ | Connexion titulaire requise |
| LinkedIn | TEXTE PRÊT / NON APPLIQUÉ | Profil exact puis validation de l’enregistrement |

Après application : relever la révision et la date, contrôler les liens et le texte en lecture publique, vérifier le rendu bureau/mobile pour les pages modifiées. Un contenu indexé ancien ne prouve pas un échec de la mise à jour : distinguer page actuelle et résultat de recherche. Ne pas réclamer une amélioration de classement sans mesure.

Aucune archive supprimée ; aucun résultat scientifique promu ; aucun nouveau DOI ; aucun courriel envoyé. La présente branche reste documentaire et la PR #43 ne doit pas être fusionnée comme un déploiement CMS.
