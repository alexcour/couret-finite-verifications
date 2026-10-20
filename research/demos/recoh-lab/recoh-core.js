/* RECOH Lab — exact finite Cn core (C8, C4, and Cn finite demonstrator).
 * Couret additive & spectral reconstruction laboratory.
 * MIT License.
 */
(function (root, factory) {
  "use strict";
  const api = factory();
  if (typeof module !== "undefined" && module.exports) module.exports = api;
  if (root) root.RECOH_CORE = api;
})(typeof globalThis === "object" ? globalThis : this, function () {
  "use strict";

  const VERSION = "1.0.1";
  const DEFAULT_N = 8;
  const SQRT2_2 = Math.SQRT1_2; // Exact Math.sqrt(2)/2 in IEEE-754 double precision
  const NUMERIC_EPSILON_UNCERTAINTY = 1e-14; // Seuil d'incertitude machine pour double précision
  const EPSILON_BOUNDARY_TOLERANCE = NUMERIC_EPSILON_UNCERTAINTY;

  // Validation d'un support de 3 éléments distincts dans Z/nZ
  function checkSupport(s, n = DEFAULT_N, count = 3) {
    if (!Array.isArray(s) || s.length !== count) {
      throw new Error("Le support doit contenir exactement " + count + " éléments.");
    }
    for (let i = 0; i < s.length; i++) {
      const x = s[i];
      if (!Number.isInteger(x) || x < 0 || x >= n) {
        throw new Error("Chaque élément doit être un entier compris entre 0 et " + (n - 1) + ".");
      }
    }
    const set = new Set(s);
    if (set.size !== count) {
      throw new Error("Les éléments du support doivent être strictement distincts.");
    }
    return [...s].sort((a, b) => a - b);
  }

  // Énumération de tous les triplets de Z/nZ (a < b < c)
  function triples(n = DEFAULT_N) {
    if (!Number.isInteger(n) || n < 3 || n > 24) {
      throw new Error("L'ordre n du groupe cyclique doit être un entier entre 3 et 24.");
    }
    const out = [];
    for (let a = 0; a < n - 2; a++) {
      for (let b = a + 1; b < n - 1; b++) {
        for (let c = b + 1; c < n; c++) {
          out.push([a, b, c]);
        }
      }
    }
    return out;
  }

  // Convolution ordonnée R_S(z) = #{(x,y) in S^2 | x+y = z mod n}, diagonales incluses
  function convolution(s, n = DEFAULT_N) {
    checkSupport(s, n, 3);
    const r = new Array(n).fill(0);
    for (let i = 0; i < s.length; i++) {
      for (let j = 0; j < s.length; j++) {
        const sum = (s[i] + s[j]) % n;
        r[sum]++;
      }
    }
    return r;
  }

  // Énumération et filtrage exact de la fibre des triplets compatibles avec R
  function candidates(r, n = DEFAULT_N) {
    if (!Array.isArray(r) || r.length !== n) {
      throw new Error("L'observation R doit être un tableau de longueur " + n + ".");
    }
    let total = 0;
    for (let i = 0; i < n; i++) {
      const val = r[i];
      if (!Number.isInteger(val) || val < 0) {
        throw new Error("Chaque composante de R doit être un entier naturel.");
      }
      total += val;
    }
    if (total !== 9) {
      return []; // La somme doit valoir 3^2 = 9
    }
    const all = triples(n);
    return all.filter(s => {
      const r_cand = convolution(s, n);
      for (let i = 0; i < n; i++) {
        if (r_cand[i] !== r[i]) return false;
      }
      return true;
    });
  }

  // Transformée de Fourier / Caractère : P_k(S) = sum_{x in S} exp(2pi * i * k * x / n)
  // Convention d'exponentielle positive conformément au contrat scientifique.
  // Pour C4 et C8, exploitation des coordonnées algébriques exactes dans Q(i, sqrt(2))
  // afin d'éliminer les erreurs de troncature trigonométriques à la frontière.
  function character(s, k = 3, n = DEFAULT_N) {
    checkSupport(s, n, 3);
    if (!Number.isInteger(k)) throw new Error("L'indice de caractère k doit être entier.");
    const k_mod = ((k % n) + n) % n;
    let re = 0;
    let im = 0;

    if (n === 4) {
      // Racines 4-ièmes exactes dans Z[i] : 1, i, -1, -i
      for (let i = 0; i < s.length; i++) {
        const m = (k_mod * s[i]) % 4;
        if (m === 0) re += 1;
        else if (m === 1) im += 1;
        else if (m === 2) re -= 1;
        else if (m === 3) im -= 1;
      }
      return { re, im, algebraic: true };
    }

    if (n === 8) {
      // Racines 8-ièmes exactes dans Q(i, sqrt(2))
      for (let i = 0; i < s.length; i++) {
        const m = (k_mod * s[i]) % 8;
        if (m === 0) re += 1;
        else if (m === 1) { re += SQRT2_2; im += SQRT2_2; }
        else if (m === 2) im += 1;
        else if (m === 3) { re -= SQRT2_2; im += SQRT2_2; }
        else if (m === 4) re -= 1;
        else if (m === 5) { re -= SQRT2_2; im -= SQRT2_2; }
        else if (m === 6) im -= 1;
        else if (m === 7) { re += SQRT2_2; im -= SQRT2_2; }
      }
      return { re, im, algebraic: true };
    }

    // Évaluation trigonométrique générale pour n arbitraire (marquée numérique)
    for (let i = 0; i < s.length; i++) {
      const theta = (2 * Math.PI * k_mod * s[i]) / n;
      re += Math.cos(theta);
      im += Math.sin(theta);
    }
    return { re, im, algebraic: false };
  }

  // Transformée de Fourier exacte de R : sum_{z} R(z) exp(2pi * i * k * z / n)
  // Doit égaler exactement P_k(S)^2 (carré complexe, non |P_k|^2)
  function fourierR(r, k, n = DEFAULT_N) {
    if (!Array.isArray(r) || r.length !== n) throw new Error("R invalide");
    const k_mod = ((k % n) + n) % n;
    let re = 0;
    let im = 0;
    for (let z = 0; z < n; z++) {
      const theta = (2 * Math.PI * k_mod * z) / n;
      re += r[z] * Math.cos(theta);
      im += r[z] * Math.sin(theta);
    }
    return { re, im };
  }

  // Produit de deux nombres complexes (a * b)
  function complexMul(a, b) {
    return {
      re: a.re * b.re - a.im * b.im,
      im: a.re * b.im + a.im * b.re
    };
  }

  // Distance euclidienne dans C
  function complexDist(a, b) {
    return Math.hypot(a.re - b.re, a.im - b.im);
  }

  // Test de compatibilité physique stricte d'un candidat S avec une observation (k, y, epsilon)
  // AUCUN élargissement arbitraire d'epsilon (+1e-12 proscrit conformément au mandat).
  function compatible(s, k, observation, epsilon, n = DEFAULT_N) {
    if (!observation || typeof observation.re !== "number" || typeof observation.im !== "number" ||
        !Number.isFinite(observation.re) || !Number.isFinite(observation.im)) {
      throw new Error("Mesure observation invalide.");
    }
    if (typeof epsilon !== "number" || !Number.isFinite(epsilon) || epsilon < 0) {
      throw new Error("La tolérance d'erreur epsilon doit être un réel positif ou nul.");
    }
    const val = character(s, k, n);
    const dist = complexDist(val, observation);
    return dist <= epsilon;
  }

  // Qualification numérique fine aux frontières
  function qualifiedCompatibility(s, k, observation, epsilon, n = DEFAULT_N) {
    if (!observation || typeof observation.re !== "number" || typeof observation.im !== "number" ||
        !Number.isFinite(observation.re) || !Number.isFinite(observation.im) ||
        typeof epsilon !== "number" || !Number.isFinite(epsilon) || epsilon < 0) {
      throw new Error("Paramètres invalides");
    }
    const val = character(s, k, n);
    const dist = complexDist(val, observation);
    const diff = dist - epsilon;
    const isBoundaryUncertain = Math.abs(diff) <= NUMERIC_EPSILON_UNCERTAINTY;
    return {
      compatible: dist <= epsilon,
      distance: dist,
      isBoundaryUncertain: isBoundaryUncertain,
      algebraic: Boolean(val.algebraic)
    };
  }

  // Calcul de la séparation delta_k pour un ensemble de candidats dans C_n
  // delta_k = min_{S != T} |P_k(S) - P_k(T)|
  function computeSeparation(candList, k, n = DEFAULT_N) {
    if (!Array.isArray(candList) || candList.length < 2) {
      return {
        delta_k: null,
        status: "DEJA_DETERMINE",
        description: "Fibre unitaire ou vide : séparation sans objet."
      };
    }
    let minD = Infinity;
    const preds = candList.map(s => character(s, k, n));
    for (let i = 0; i < preds.length; i++) {
      for (let j = i + 1; j < preds.length; j++) {
        const d = complexDist(preds[i], preds[j]);
        if (d < minD) minD = d;
      }
    }
    return {
      delta_k: minD,
      status: minD < 1e-10 ? "INDISTINGUABLE" : "CALCULE",
      description: minD < 1e-10 ? "Prédictions identiques pour au moins deux candidats." : "Séparation calculée."
    };
  }

  // Analyse de la marge de robustesse M = delta_k - 2 * epsilon
  function analyzeMargin(delta_k, epsilon) {
    if (delta_k === null || delta_k === undefined) {
      return {
        margin: null,
        guarantee: "NON_APPLICABLE",
        label: "Déjà déterminé par R"
      };
    }
    const margin = delta_k - 2 * epsilon;
    if (margin > EPSILON_BOUNDARY_TOLERANCE) {
      return {
        margin,
        guarantee: "SEPARATION_GARANTIE",
        label: "Séparation uniforme garantie : les disques B(P_k, ε) sont disjoints."
      };
    } else {
      return {
        margin,
        guarantee: "SEPARATION_NON_GARANTIE",
        label: "Séparation uniforme non garantie : chevauchement possible."
      };
    }
  }

  // Filtrage mode cumulatif « Carnet de mesures »
  // measurements = [ { k, y: {re, im}, epsilon }, ... ]
  function filterNotebook(candList, measurements, n = DEFAULT_N) {
    if (!Array.isArray(candList)) return [];
    if (!Array.isArray(measurements) || measurements.length === 0) return [...candList];
    return candList.filter(s => {
      for (let i = 0; i < measurements.length; i++) {
        const m = measurements[i];
        if (!compatible(s, m.k, m.y, m.epsilon, n)) return false;
      }
      return true;
    });
  }

  // Moteur de décision virtuelle
  // Position p in {0, ..., n-1}
  // Règle stricte :
  // - |C| == 0 => OBSERVATIONS_INCOMPATIBLES (Dépôt bloqué; l'ensemble vide n'autorise JAMAIS)
  // - Incertitude numérique à la frontière non résolue => INCERTITUDE_NUMERIQUE (Dépôt bloqué)
  // - p absent de tous les candidats => AUTORISE
  // - p présent dans tous les candidats => REFUSE
  // - désaccord => INDETERMINE (Dépôt bloqué)
  function evaluateVirtualDecision(candList, position, n = DEFAULT_N, hasBoundaryUncertainty = false) {
    if (!Number.isInteger(position) || position < 0 || position >= n) {
      throw new Error("Position de dépôt invalide : " + position);
    }
    if (!Array.isArray(candList) || candList.length === 0) {
      return {
        status: "OBSERVATIONS_INCOMPATIBLES",
        allowed: false,
        blocked: true,
        reason: "Aucun candidat compatible : les observations sont contradictoires. Dépôt bloqué (l'ensemble vide n'autorise jamais par vacuité).",
        candidate_count: 0
      };
    }
    if (hasBoundaryUncertainty) {
      return {
        status: "INCERTITUDE_NUMERIQUE",
        allowed: false,
        blocked: true,
        reason: "Comparaison numérique non résolue à la frontière (incertitude machine). Dépôt virtuel bloqué.",
        candidate_count: candList.length
      };
    }
    let presentCount = 0;
    for (let i = 0; i < candList.length; i++) {
      if (candList[i].includes(position)) presentCount++;
    }
    if (presentCount === 0) {
      return {
        status: "AUTORISE",
        allowed: true,
        blocked: false,
        reason: "Position " + position + " libre dans TOUS les " + candList.length + " candidat(s). Dépôt virtuel autorisé.",
        candidate_count: candList.length
      };
    } else if (presentCount === candList.length) {
      return {
        status: "REFUSE",
        allowed: false,
        blocked: true,
        reason: "Position " + position + " occupée dans TOUS les " + candList.length + " candidat(s). Dépôt virtuel refusé.",
        candidate_count: candList.length
      };
    } else {
      return {
        status: "INDETERMINE",
        allowed: false,
        blocked: true,
        reason: "Désaccord entre les candidats (occupée dans " + presentCount + "/" + candList.length + "). Dépôt virtuel bloqué.",
        candidate_count: candList.length
      };
    }
  }

  // Translation t dans Z/nZ
  function translate(s, t, n = DEFAULT_N) {
    checkSupport(s, n, 3);
    if (!Number.isInteger(t)) throw new Error("Translation t invalide");
    return s.map(x => ((x + t) % n + n) % n).sort((a, b) => a - b);
  }

  // Simulateur étanche de défi aveugle (Zero Target Leakage)
  function createBlindChallenge(targetCandidate, n = DEFAULT_N) {
    const checkedTarget = checkSupport(targetCandidate, n, 3);
    const secretTarget = [...checkedTarget]; // Scope privé fermé
    const publicR = convolution(secretTarget, n);
    const publicFiber = candidates(publicR, n);

    let measurementHistory = [];
    let revealed = false;

    return {
      getObservationR() {
        return [...publicR];
      },
      getFiberCount() {
        return publicFiber.length;
      },
      // Le sélecteur ne reçoit QUE la fibre et l'historique public, jamais le secretTarget
      recommendNextMeasurement() {
        let bestK = 1;
        let maxDelta = -1;
        for (let k = 1; k < n; k++) {
          const sep = computeSeparation(publicFiber, k, n);
          if (sep.delta_k !== null && sep.delta_k > maxDelta) {
            maxDelta = sep.delta_k;
            bestK = k;
          }
        }
        return { recommendedK: bestK, expectedSeparation: maxDelta };
      },
      takeMeasurement(k) {
        if (!Number.isInteger(k) || k < 0 || k >= n) throw new Error("k invalide");
        const meas = character(secretTarget, k, n);
        measurementHistory.push({ k, y: meas });
        return { k, re: meas.re, im: meas.im };
      },
      verifyGuess(guess) {
        checkSupport(guess, n, 3);
        const guessR = convolution(guess, n);
        let matchesR = true;
        for (let i = 0; i < n; i++) {
          if (guessR[i] !== publicR[i]) {
            matchesR = false;
            break;
          }
        }
        let matchesMeasurements = true;
        for (let i = 0; i < measurementHistory.length; i++) {
          const m = measurementHistory[i];
          if (!compatible(guess, m.k, m.y, 1e-6, n)) {
            matchesMeasurements = false;
            break;
          }
        }
        return {
          matchesR,
          matchesMeasurements,
          isExactMatch: matchesR && matchesMeasurements
        };
      },
      revealSecret() {
        revealed = true;
        return {
          secret: [...secretTarget],
          fiber: publicFiber.map(x => [...x])
        };
      }
    };
  }

  // Exportation au format JSON versionné conforme au contrat scientifique
  function exportExperiment(state) {
    if (!state || !state.support || !state.n) {
      throw new Error("État invalide pour exportation");
    }
    const n = state.n;
    const s = checkSupport(state.support, n, 3);
    const r = convolution(s, n);
    const fiber = candidates(r, n);

    const measurements = (state.measurements || []).map(m => ({
      k: m.k,
      y: { re: m.y.re, im: m.y.im },
      epsilon: m.epsilon,
      margin: m.margin !== undefined ? m.margin : null,
      guarantee: m.guarantee || "NON_SPECIFIE"
    }));

    const filtered = filterNotebook(fiber, measurements, n);
    const decision = state.virtualPosition !== undefined ?
      evaluateVirtualDecision(filtered, state.virtualPosition, n) : null;

    return {
      schema_version: "recoh-lab/1.0",
      experiment_id: "exp-" + Date.now(),
      engine_version: VERSION,
      status: "finite-review-demonstrator",
      group: "Z/" + n + "Z",
      n: n,
      conventions: {
        orderedPairs: true,
        diagonalIncluded: true,
        pairSumTotal: 9,
        fourierExponential: "exp(+2*pi*i*k*x/n)",
        fourierIdentity: "sum_z R(z) exp(2*pi*i*k*z/n) == P_k(S)^2"
      },
      support: s,
      observation_R: r,
      complete_fiber: fiber,
      mode: state.mode || "single",
      measurements: measurements,
      filtered_candidates: filtered,
      virtual_decision: decision ? {
        position: state.virtualPosition,
        status: decision.status,
        allowed: decision.allowed,
        reason: decision.reason
      } : null
    };
  }

  // Importation, validation stricte et recalcul complet
  function importExperiment(jsonString) {
    let data;
    try {
      data = typeof jsonString === "string" ? JSON.parse(jsonString) : jsonString;
    } catch (e) {
      throw new Error("JSON mal formé : " + e.message);
    }
    if (!data || typeof data !== "object") throw new Error("Objet expérience invalide.");
    if (data.schema_version !== "recoh-lab/1.0") {
      throw new Error("Schéma non supporté : " + data.schema_version + " (attendu recoh-lab/1.0)");
    }
    const n = data.n;
    if (!Number.isInteger(n) || n < 3 || n > 24) {
      throw new Error("Ordre n invalide dans l'export : " + n);
    }
    const r = data.observation_R;
    if (!Array.isArray(r) || r.length !== n) {
      throw new Error("Observation R invalide pour n=" + n);
    }
    let sum = 0;
    for (let i = 0; i < n; i++) {
      if (!Number.isInteger(r[i]) || r[i] < 0) throw new Error("Composante R non entière ou négative.");
      sum += r[i];
    }
    if (sum !== 9) throw new Error("La somme de R vaut " + sum + " au lieu de 9.");

    // Recalcul indépendant de la fibre depuis R (NE PAS FAIRE CONFIANCE AUX CANDIDATS ENREGISTRÉS)
    const recomputedFiber = candidates(r, n);

    // Validation des mesures et recalcul du filtrage
    const validMeasurements = [];
    if (Array.isArray(data.measurements)) {
      for (let i = 0; i < data.measurements.length; i++) {
        const m = data.measurements[i];
        if (!Number.isInteger(m.k) || m.k < 0 || m.k >= n) throw new Error("Mesure " + i + " : k invalide");
        if (!m.y || typeof m.y.re !== "number" || typeof m.y.im !== "number" ||
            !Number.isFinite(m.y.re) || !Number.isFinite(m.y.im)) {
          throw new Error("Mesure " + i + " : y complexe invalide");
        }
        if (typeof m.epsilon !== "number" || !Number.isFinite(m.epsilon) || m.epsilon < 0) {
          throw new Error("Mesure " + i + " : epsilon invalide");
        }
        validMeasurements.push({
          k: m.k,
          y: { re: m.y.re, im: m.y.im },
          epsilon: m.epsilon
        });
      }
    }

    const recomputedFiltered = filterNotebook(recomputedFiber, validMeasurements, n);

    // Recalcul de la décision virtuelle si spécifiée (NE PAS FAIRE CONFIANCE AU STATUT STOCKÉ)
    let recomputedDecision = null;
    if (data.virtual_decision && Number.isInteger(data.virtual_decision.position)) {
      recomputedDecision = evaluateVirtualDecision(recomputedFiltered, data.virtual_decision.position, n);
    }

    // Détection de divergences par rapport aux données stockées
    const discrepancies = [];
    if (data.complete_fiber && JSON.stringify(data.complete_fiber) !== JSON.stringify(recomputedFiber)) {
      discrepancies.push("Divergence sur la fibre énumérée.");
    }
    if (data.filtered_candidates && JSON.stringify(data.filtered_candidates) !== JSON.stringify(recomputedFiltered)) {
      discrepancies.push("Divergence sur les candidats filtrés.");
    }
    if (data.virtual_decision && recomputedDecision && data.virtual_decision.status !== recomputedDecision.status) {
      discrepancies.push("Divergence sur la décision virtuelle stockée vs recalculée.");
    }

    return {
      valid: true,
      n,
      observation_R: r,
      fiber: recomputedFiber,
      measurements: validMeasurements,
      filteredCandidates: recomputedFiltered,
      virtualDecision: recomputedDecision,
      discrepancies,
      isCleanReplay: discrepancies.length === 0
    };
  }

  return {
    VERSION,
    DEFAULT_N,
    EPSILON_BOUNDARY_TOLERANCE,
    checkSupport,
    triples,
    convolution,
    candidates,
    character,
    fourierR,
    complexMul,
    complexDist,
    compatible,
    qualifiedCompatibility,
    computeSeparation,
    analyzeMargin,
    filterNotebook,
    evaluateVirtualDecision,
    translate,
    createBlindChallenge,
    exportExperiment,
    importExperiment
  };
});
