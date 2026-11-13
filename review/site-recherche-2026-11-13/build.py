"""Validate the exact replay and generate a WordPress Custom HTML fragment."""
import hashlib
import html
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parent


def build():
    data = json.loads((ROOT / 'resultats_triplets.json').read_text())
    registry = json.loads((ROOT / 'registry.json').read_text())
    digest = hashlib.sha256((ROOT / 'verification_triplets.py').read_bytes()).hexdigest()
    if data['source_sha256'] != digest:
        raise ValueError('Le script ne correspond pas au reçu de calcul')
    if data['status'] != 'PASS_FINITE_INTERNAL_REPLAY' or data['max_order'] != 36:
        raise ValueError('Périmètre de calcul inattendu')
    totals = data['totals']
    classes = totals['classes']
    if sum(classes.values()) != totals['zero_free_collisions']:
        raise ValueError('Somme des classes incohérente')
    if totals['all_collisions'] < totals['zero_free_collisions']:
        raise ValueError('Périmètres avec et sans zéro incohérents')
    for key, value in registry['expected_totals'].items():
        if totals[key] != value:
            raise ValueError('Chiffre éditorial incohérent : ' + key)
    for item in registry['navigation']:
        if not item['url'].startswith('https://www.couretunification.fr/'):
            raise ValueError('Destination du menu inattendue')
    esc = html.escape
    parts = ['<section aria-labelledby="cu-triplets-title">',
             '<h2 id="cu-triplets-title">Comprendre une ambiguïté exacte</h2>',
             '<p>Dans ℤ/6ℤ, nous comptons les couples ordonnés (x, y) dont la somme vaut chaque résidu. Les couples (x, x) sont inclus.</p>']
    for example in data['examples']:
        name = 'Une translation' if example['translations'] else 'Une réflexion sans translation'
        s, t = example['S'], example['T']
        r = example['R']
        def footprint(u):
            return [sum((x+y) % 6 == z for x in u for y in u) for z in range(6)]
        if footprint(s) != r or footprint(t) != r or sum(r) != 9:
            raise ValueError('Exemple éditorial erroné')
        parts += ['<h3>' + name + '</h3>',
                  '<p>S = {' + ', '.join(map(str, s)) + '} et T = {' + ', '.join(map(str, t)) + '}.</p>',
                  '<table><caption>Multiplicités pour les résidus de 0 à 5</caption><thead><tr><th scope="col">Résidu</th>' + ''.join('<th scope="col">'+str(z)+'</th>' for z in range(6)) + '</tr></thead><tbody><tr><th scope="row">R de S et de T</th>' + ''.join('<td>'+str(v)+'</td>' for v in r) + '</tr></tbody></table>']
        if example['translations']:
            parts.append('<p>Ici T = S + 3 et 2 × 3 = 0 modulo 6. Les graphes de Cayley ont le même carré d’adjacence, mais les traces de leurs cubes valent 30 et 24 : leurs spectres sont différents.</p>')
        else:
            parts.append('<p>Ici T = −S. Aucune translation ne transforme S en T. Les graphes de Cayley sont isomorphes par x ↦ −x.</p>')
    parts += ['<h3>Un recalcul sur un domaine précis</h3>',
              '<p>' + str(totals['group_types']) + ' types de groupes abéliens d’ordre au plus 36 ; ' + str(totals['supports']) + ' supports à trois éléments ; ' + str(totals['zero_free_collisions']) + ' collisions entre supports excluant zéro. En autorisant aussi les supports contenant zéro : ' + str(totals['all_collisions']) + ' collisions.</p>',
              '<p>Calcul exact interne assisté par IA. Ce contrôle fini ne prouve pas une classification générale et ne constitue pas une relecture humaine indépendante. Aucune compilation Lean n’a été exécutée pour ce recalcul.</p>',
              '<p><a href="https://www.couretunification.fr/explorer/">Explorer les exemples</a> · <a href="https://doi.org/10.37236/1831">Lire Lev 2004</a></p>',
              '<details><summary>Conventions et source du calcul</summary><p>' + esc(data['pair_convention']) + '</p><p>SHA-256 du script : <code>' + digest + '</code>.</p></details>',
              '</section>']
    (ROOT / 'wordpress-science.html').write_text('\n'.join(parts) + '\n')
    print('PASS : reçu, périmètres, comptes et exemples ; fragment HTML généré')


if __name__ == '__main__':
    build()
