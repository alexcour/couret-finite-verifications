"""Validate the exact replay and generate a WordPress Custom HTML fragment."""
import hashlib
import html
import json
import re
from itertools import product
from pathlib import Path

ROOT = Path(__file__).resolve().parent


def render(data, registry):
    digest = hashlib.sha256((ROOT / 'verification_triplets.py').read_bytes()).hexdigest()
    if data['source_sha256'] != digest:
        raise ValueError('Le script ne correspond pas au reçu de calcul')
    if data['status'] != 'PASS_FINITE_INTERNAL_REPLAY' or data['max_order'] != 36:
        raise ValueError('Périmètre de calcul inattendu')
    conventions = {
        'support_convention': 'three distinct elements; ordered sums; diagonals included',
        'pair_convention': 'unordered pairs of distinct supports; no symmetry quotient',
        'zero_free_convention': 'zero excluded from both supports for the four counting formulae',
    }
    if any(data[key] != value for key, value in conventions.items()):
        raise ValueError('Conventions du reçu inattendues')
    totals = data['totals']
    expected_totals = {
        'group_types': 62, 'supports': 137315, 'zero_free_supports': 122962,
        'all_collisions': 236340, 'zero_free_collisions': 190930,
    }
    if registry['expected_totals'] != expected_totals:
        raise ValueError('Périmètre éditorial inattendu')
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
    revision = registry['evidence_revision']
    if not re.fullmatch(r'[0-9a-f]{40}', revision):
        raise ValueError('Révision de preuve invalide')
    evidence = ('https://github.com/alexcour/couret-finite-verifications/blob/'
                + revision + '/review/site-recherche-2026-11-13/')
    if [example['name'] for example in data['examples']] != [
        'homepage_translation', 'nontranslation_reflection'
    ]:
        raise ValueError('Liste des exemples inattendue')
    parts = ['<section aria-labelledby="cu-triplets-title">',
             '<h2 id="cu-triplets-title">Comprendre une ambiguïté exacte</h2>',
             '<p>Pour un support S de trois éléments distincts d’un groupe abélien fini, R<sub>S</sub>(z) compte les couples ordonnés (x, y) de S × S tels que x + y = z, diagonales comprises. Une collision est une paire non ordonnée de supports distincts de même empreinte, sans quotient par translation ou automorphisme.</p>']
    for example in data['examples']:
        is_translation = example['name'] == 'homepage_translation'
        name = 'Une translation' if is_translation else 'Une réflexion sans translation'
        s, t = example['S'], example['T']
        if any(len(u) != 3 or not set(u) <= set(range(6)) or len(set(u)) != 3 for u in (s, t)) or set(s) == set(t):
            raise ValueError('Supports éditoriaux invalides')
        r = example['R']
        translations = [a for a in range(6) if {(x + a) % 6 for x in s} == set(t)]
        reflections = [a for a in range(6) if {(a - x) % 6 for x in s} == set(t)]
        traces = [6 * sum(sum(triple) % 6 == 0 for triple in product(u, repeat=3)) for u in (s, t)]
        if translations != example['translations'] or traces != example['trace_cubes']:
            raise ValueError('Témoins ou traces du reçu incohérents')
        if is_translation and (translations != [3] or traces[0] == traces[1]):
            raise ValueError('Translation annoncée non vérifiée')
        if not is_translation and (translations or 0 not in reflections):
            raise ValueError('Réflexion annoncée non vérifiée')
        def footprint(u):
            return [sum((x+y) % 6 == z for x in u for y in u) for z in range(6)]
        if footprint(s) != r or footprint(t) != r or sum(r) != 9:
            raise ValueError('Exemple éditorial erroné')
        parts += ['<h3>' + name + '</h3>',
                  '<p>S = {' + ', '.join(map(str, s)) + '} et T = {' + ', '.join(map(str, t)) + '}.</p>',
                  '<table><caption>Multiplicités pour les résidus de 0 à 5</caption><thead><tr><th scope="col">Résidu</th>' + ''.join('<th scope="col">'+str(z)+'</th>' for z in range(6)) + '</tr></thead><tbody><tr><th scope="row">R de S et de T</th>' + ''.join('<td>'+str(v)+'</td>' for v in r) + '</tr></tbody></table>']
        if is_translation:
            parts.append('<p>Ici T = S + 3 et 2 × 3 = 0 modulo 6. Les graphes de Cayley ont le même carré d’adjacence, mais les traces de leurs cubes valent ' + str(traces[0]) + ' et ' + str(traces[1]) + ' : leurs spectres sont différents.</p>')
        else:
            parts.append('<p>Ici T = −S. Aucune translation ne transforme S en T. Les graphes de Cayley sont isomorphes par x ↦ −x.</p>')
    parts += ['<p>Les graphes de Cayley sont orientés, avec des arcs x → x + s pour s dans S. Pour A<sub>S</sub>(x,y) = 1<sub>S</sub>(y − x), le nombre de chemins de longueur deux est A<sub>S</sub>²(x,y) = R<sub>S</sub>(y − x). L’égalité des carrés, la cospectralité et l’isomorphisme sont trois propriétés distinctes.</p>',
              '<h3>Un recalcul sur un domaine précis</h3>',
              '<p>Dans les 62 types de groupes abéliens d’ordre au plus 36, on compte 122 962 supports et 190 930 collisions lorsque les deux supports excluent zéro. Avec zéro admis, on compte 137 315 supports et 236 340 collisions.</p>',
              '<p>Calcul exact interne assisté par IA. Ce contrôle fini ne prouve pas une classification générale et ne constitue pas une relecture humaine indépendante. Aucune compilation Lean n’a été exécutée pour ce recalcul.</p>',
              '<p>Vsevolod F. Lev, <a href="https://doi.org/10.37236/1831"><cite>Reconstructing Integer Sets From Their Representation Functions</cite></a> (2004), p. 5, formule le problème général et décrit les signes de Fourier et les translations d’ordre deux. L’antériorité de la classification des triplets reste à examiner.</p>',
              '<details><summary>Conventions et source du calcul</summary><p>Les éléments du groupe sont étiquetés. On prend une fois chaque type de groupe, par facteurs invariants. Pour les comptes sans zéro, les deux supports évitent zéro.</p><p><a href="' + html.escape(evidence + 'verification_triplets.py') + '">Script de calcul</a> · <a href="' + html.escape(evidence + 'resultats_triplets.json') + '">Reçu du calcul</a>. SHA-256 du script&nbsp;: <code style="overflow-wrap:anywhere">' + digest + '</code>.</p></details>',
              '</section>']
    return '\n'.join(parts) + '\n'


def build():
    data = json.loads((ROOT / 'resultats_triplets.json').read_text())
    registry = json.loads((ROOT / 'registry.json').read_text())
    (ROOT / 'wordpress-science.html').write_text(render(data, registry))
    print('PASS : reçu, périmètres, comptes et exemples ; fragment HTML généré')


if __name__ == '__main__':
    build()
