# Audit WordPress public, 16 URL — reçus d'inspection, 14 octobre 2026

**Statut : protocole d'inspection en PR brouillon, sans déploiement.**

## Sources et frontières

- PR éditoriale [#34](https://github.com/alexcour/couret-finite-verifications/pull/34) fusionnée à 21:33:58 Europe/Paris, commit `d137f119acf9383b06fb8de3856610970ae6bc1a`.
- PR éditoriale [#9](https://github.com/alexcour/couret-finite-verifications/pull/9) fusionnée à 21:34:14, commit `3d2e7067e85d17db8d07968056572bd0363b9a4f`. Le paquet [SITE_CORRECTIONS_APPROVED_2026-10-14.md](SITE_CORRECTIONS_APPROVED_2026-10-14.md) est l'autorité pour C01–C16 et les textes approuvés.
- Les observations HTTP du 14 octobre à 18:49–18:53, puis 20:02–20:04, sont **antérieures aux deux fusions** : `/recherche-actuelle/` présentait déjà l'axe STROBO–Cayley et l'accueil contenait un lien. D'autres passages RH, H1/KLMN, Parseval et mélange global demandaient une correction. Leur provenance ne peut pas être attribuée à la fusion des PR.
- Une tentative supplémentaire de connexion directe depuis l'environnement de contrôle a échoué par résolution DNS. Un contenu indexé n'est pas une preuve d'état de production après fusion. **Aucune des 16 URL n'a reçu un verdict de correction déployée et vérifiée post-fusion.**

## Protocole et données

- `WORDPRESS_PUBLIC_URLS_2026-10-14.json` énumère **16 points éditoriaux** C01–C16 (les ID C01/C02 partagent l'accueil).
- `audit_wordpress_public.py` est une sonde **HTTP GET publique uniquement**, sans cookies, identifiants, secrets, API admin ni écriture CMS. Elle enregistre une heure UTC, l'URL et le code HTTP, l'URL finale, les en-têtes de datation disponibles, une empreinte SHA-256 si le document HTML entier a été reçu (maximum 4 Mio), son titre et la présence ou l'absence d'indicateurs lexicaux. Elle ne stocke pas les pages intégrales.
- Le workflow `wordpress-public-audit.yml` s'exécute sur PR touchant la sonde, puis manuellement après intégration. Les reçus sont conservés comme artefacts pendant 14 jours. Une CI verte certifie l'exécution de la sonde, **pas** la correction éditoriale ni l'absence d'une erreur.
- L'absence d'une chaîne ne signifie rien si la page est indisponible, si le contenu est dynamique, si une version alternative existe, ou si une archive est explicitement citée. Un indicateur positif peut être un erratum historique correct (ex. l'ancienne proportion 0,378).

## Recette humaine nécessaire

Pour chaque URL C01–C16, conserver : capture (bureau et mobile), URL canonique, code HTTP, heure locale Paris, texte avant/après, preuve du changement dans l'interface WordPress, et décision `à corriger`, `déjà conforme`, `archive justifiée` ou `non vérifiable` avec justification. Vérifier les pages et leurs métadonnées SEO, notamment les assertions RH, H1/KLMN, Parseval et mélange global. Ne pas modifier F-001 ou les témoins F-08 déjà exacts.

La fusion GitHub (E) n'est ni le déploiement WordPress (D), ni la certification scientifique (S). Les PR scientifiques #25 et #30 restent sous leurs propres limites. Aucune priorité, release scientifique, dépôt DOI/HAL/arXiv, partage privé, transmission à Frédéric ou opération WordPress n'est autorisé par cette recette.

## Traçabilité

- [Portail Drive CURRENT](https://docs.google.com/document/d/1TkDff1ebuiekibXeN6H-c0VMzait_q14MC0ryduJr5s/edit)
- [Document éditorial Drive](https://docs.google.com/document/d/1i8q0tRJaM7re6MegOVVYaFEAUu_Hoy3QF2vRXrxGii8/edit)
- [Linear COU-12](https://linear.app/couret/issue/COU-12/harmoniser-le-portail-strobo-cayley-et-la-pr-editoriale-34)
