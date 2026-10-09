#!/usr/bin/env python3
"""AGENT-CERT-01 deterministic synthetic budgeted verification benchmark.
No LLM is queried. This is not an A.30/A.31/FCI replay.
"""
import hashlib
import json
import statistics
from collections import defaultdict
from pathlib import Path

SEED = 'AGENT-CERT-01-2026-10-09-v1'
LOSS = 30
BASE_COST = 3
SAMPLE_COST = 4
CERT_COST = 6
BUDGETS = (0, 2, 4, 6)
N_CAL = 4096
N_TEST = 2048
PANELS = {'STABLE': 15, 'IID_CONTROL': 0, 'CORRELATED_SHIFT': 60}
POLICIES = ('NO_EXTRA', 'UNIFORM', 'UNCERTAINTY', 'CERT_VALUE')


def digest(*parts):
    blob = '|'.join(map(str, (SEED,) + parts)).encode('ascii')
    return int.from_bytes(hashlib.sha256(blob).digest()[:8], 'big')


def chance(numer, denom, *parts):
    return (digest(*parts) % denom) < numer


def create_task(split, panel, index):
    token = digest('key', split, panel, index)
    n = token % 1000003
    truth = int((n * n + 11 * n + 7) % 101 < 48)
    correlated = chance(PANELS[panel], 100, 'corr', split, panel, index)
    difficulty = digest('diff', split, panel, index) % 3
    accuracy = (93, 76, 61)[difficulty]
    if correlated:
        # A shared latent error contaminates all seven votes.
        latent_correct = chance(17, 100, 'latent', split, panel, index)
        votes = [truth if latent_correct else 1 - truth] * 7
    else:
        votes = [truth if chance(accuracy, 100, 'vote', split, panel, index, j)
                 else 1 - truth for j in range(7)]
    base = int(sum(votes[:3]) >= 2)
    expanded = int(sum(votes) >= 4)
    margin = abs(2 * sum(votes[:3]) - 3)
    assert margin in (1, 3)
    return {'index': index, 'truth': truth, 'base': base,
            'expanded': expanded, 'margin': margin, 'correlated': correlated}


def calibration():
    rows = [create_task('cal', 'STABLE', i) for i in range(N_CAL)]
    groups = defaultdict(list)
    for x in rows:
        groups[x['margin']].append(x)
    risks = {}
    for margin in (1, 3):
        grp = groups[margin]
        assert len(grp) > 0
        risks[margin] = {
            'n': len(grp),
            'risk_initial': sum(x['base'] != x['truth'] for x in grp) / len(grp),
            'risk_extra_votes': sum(x['expanded'] != x['truth'] for x in grp) / len(grp)
        }
    return risks


def select(policy, margin, available, risks):
    if policy == 'NO_EXTRA':
        return 'NONE'
    if policy == 'UNIFORM':
        return 'SAMPLE' if available >= SAMPLE_COST else 'NONE'
    if policy == 'UNCERTAINTY':
        return 'SAMPLE' if margin == 1 and available >= SAMPLE_COST else 'NONE'
    if policy == 'CERT_VALUE':
        p = risks[margin]
        benefits = [('NONE', 0.0)]
        if available >= SAMPLE_COST:
            benefits.append(('SAMPLE', LOSS * (p['risk_initial'] - p['risk_extra_votes']) - SAMPLE_COST))
        if available >= CERT_COST:
            benefits.append(('CERTIFY', LOSS * p['risk_initial'] - CERT_COST))
        # Conservative tie break: no action, then sample, then certify.
        best = max(benefits, key=lambda z: z[1])
        return best[0] if best[1] > 0 else 'NONE'
    raise ValueError(policy)


def run_policy(rows, policy, budget, risks):
    balance = 0
    acc = defaultdict(int)
    signatures = []
    for task in rows:
        balance += budget
        action = select(policy, task['margin'], balance, risks)
        if action == 'SAMPLE':
            balance -= SAMPLE_COST
            prediction = task['expanded']
            extra = SAMPLE_COST
        elif action == 'CERTIFY':
            balance -= CERT_COST
            # Exact certificate is only accessed after paying the certificate cost.
            prediction = task['truth']
            extra = CERT_COST
            acc['certified'] += 1
            assert prediction == task['truth']
        else:
            prediction = task['base']
            extra = 0
        assert extra in (0, 4, 6)
        assert balance >= 0
        incorrect = int(prediction != task['truth'])
        acc['wrong'] += incorrect
        acc['extra'] += extra
        acc['action_' + action] += 1
        acc['regret'] += LOSS * incorrect
        signatures.append(f"{task['index']}:{action}:{prediction}:{incorrect}:{extra}")
    n = len(rows)
    assert acc['extra'] <= n * budget
    result = {'policy': policy, 'per_task_budget': budget, 'n': n,
              'wrong': acc['wrong'], 'certified': acc['certified'],
              'extra_cost': acc['extra'], 'base_cost': n * BASE_COST,
              'total_budget_cap': n * budget, 'unused_allowance': n * budget - acc['extra'],
              'error_loss': acc['regret'],
              'total_J': n * BASE_COST + acc['extra'] + acc['regret'],
              'actions': {a: acc['action_' + a] for a in ('NONE', 'SAMPLE', 'CERTIFY')},
              'trace_sha256': hashlib.sha256(('\n'.join(signatures)+'\n').encode()).hexdigest()}
    assert sum(result['actions'].values()) == n
    return result


def main():
    dest = Path(__file__).parent
    risk = calibration()
    panels = {}
    for panel in PANELS:
        rows = [create_task('test', panel, i) for i in range(N_TEST)]
        data = [run_policy(rows, p, b, risk) for b in BUDGETS for p in POLICIES]
        for b in BUDGETS:
            obs = [r for r in data if r['per_task_budget'] == b]
            assert obs and all(r['n'] == N_TEST for r in obs)
            # No cheating: an exact certificate is the only way to flag certified.
            assert all(x['certified'] == x['actions']['CERTIFY'] for x in obs)
        panels[panel] = {'n': N_TEST, 'correlated_truth_count': sum(r['correlated'] for r in rows),
                         'rows': data}
    out = {'study': 'AGENT-CERT-01', 'seed': SEED,
           'scope': 'toy synthetic deterministic verifier, NOT an LLM or FCI A30/A31 benchmark',
           'loss': LOSS, 'base_cost': BASE_COST, 'sample_cost': SAMPLE_COST,
           'certify_cost': CERT_COST, 'budgets': list(BUDGETS),
           'calibration_n': N_CAL, 'calibration_risks': risk,
           'panels': panels}
    payload = json.dumps(out, indent=2, sort_keys=True, ensure_ascii=True) + '\n'
    (dest / 'results.json').write_text(payload, encoding='utf-8')
    summary = ['panel,budget,policy,n,wrong,certified,extra_cost,total_J,actions_none,actions_sample,actions_certify']
    for panel, p in panels.items():
        for r in p['rows']:
            summary.append(','.join(str(x) for x in [panel,r['per_task_budget'],r['policy'],r['n'],r['wrong'],r['certified'],r['extra_cost'],r['total_J'],r['actions']['NONE'],r['actions']['SAMPLE'],r['actions']['CERTIFY']]))
    (dest / 'summary.csv').write_text('\n'.join(summary) + '\n', encoding='utf-8')
    print('TEST PASS: deterministic panels, budgets and certificate accounting')
    print('calibration', json.dumps(risk, sort_keys=True))
    for panel in panels:
        print(panel, 'corr_count', panels[panel]['correlated_truth_count'])
        for b in BUDGETS:
            print(' budget', b, [(r['policy'],r['wrong'],r['total_J'],r['certified']) for r in panels[panel]['rows'] if r['per_task_budget']==b])
    print('RESULT_SHA256', hashlib.sha256(payload.encode()).hexdigest())


if __name__ == '__main__':
    main()