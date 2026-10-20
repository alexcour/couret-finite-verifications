/* STROBO Explorer Core — Exact finite fiber and collision explorer for C4 and C8.
 * Couret additive reconstruction programme.
 * MIT License.
 */
(function (root, factory) {
  "use strict";
  const api = factory();
  if (typeof module !== "undefined" && module.exports) module.exports = api;
  if (root) root.STROBO_CORE = api;
})(typeof globalThis === "object" ? globalThis : this, function () {
  "use strict";

  const VERSION = "1.0.1-review";
  const SUPPORTED_ORDERS = [4, 6, 8];

  function checkSupport(s, n) {
    if (!Array.isArray(s) || s.length !== 3) {
      throw new Error("Le support doit contenir exactement 3 éléments.");
    }
    for (let i = 0; i < 3; i++) {
      const x = s[i];
      if (!Number.isInteger(x) || x < 0 || x >= n) {
        throw new Error("Élément hors du domaine Z/" + n + "Z : " + x);
      }
    }
    const set = new Set(s);
    if (set.size !== 3) {
      throw new Error("Les éléments doivent être strictement distincts.");
    }
    return [...s].sort((a, b) => a - b);
  }

  function triples(n) {
    if (!Number.isInteger(n) || n < 3 || n > 24) {
      throw new Error("Ordre n hors limites : " + n);
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

  function convolution(s, n) {
    checkSupport(s, n);
    const r = new Array(n).fill(0);
    for (let i = 0; i < 3; i++) {
      for (let j = 0; j < 3; j++) {
        r[(s[i] + s[j]) % n]++;
      }
    }
    return r;
  }

  function fiberPartition(n) {
    const all = triples(n);
    const map = new Map();
    for (let i = 0; i < all.length; i++) {
      const s = all[i];
      const r = convolution(s, n);
      const key = r.join(",");
      if (!map.has(key)) {
        map.set(key, { r: r, candidates: [] });
      }
      map.get(key).candidates.push(s);
    }
    return Array.from(map.values());
  }

  function symmetricDifference(s, t) {
    const setS = new Set(s);
    const setT = new Set(t);
    const diff = [];
    for (const x of s) {
      if (!setT.has(x)) diff.push(x);
    }
    for (const x of t) {
      if (!setS.has(x)) diff.push(x);
    }
    return diff.sort((a, b) => a - b);
  }

  function exportCollisionWitness(s, t, n) {
    const checkedS = checkSupport(s, n);
    const checkedT = checkSupport(t, n);
    if (checkedS.join(",") === checkedT.join(",")) {
      throw new Error("Les deux supports doivent être distincts (S != T).");
    }
    const rS = convolution(checkedS, n);
    const rT = convolution(checkedT, n);
    for (let i = 0; i < n; i++) {
      if (rS[i] !== rT[i]) {
        throw new Error("Collision invalide : R_S != R_T.");
      }
    }
    const diff = symmetricDifference(checkedS, checkedT);

    return {
      schema_version: "strobo-witness/1.0",
      timestamp: new Date().toISOString(),
      engine_version: VERSION,
      group: "Z/" + n + "Z",
      n: n,
      conventions: {
        tripletSize: 3,
        orderedPairs: true,
        diagonalsIncluded: true,
        sumOfR: 9
      },
      support_S: checkedS,
      support_T: checkedT,
      convolution_R: rS,
      symmetric_difference: diff,
      delta_cardinality: diff.length,
      zero_free_diff: !diff.includes(0),
      verification_status: "COLLISION_EXACTE_CONFIRMEE"
    };
  }

  function verifyWitness(witness) {
    const data = typeof witness === "string" ? JSON.parse(witness) : witness;
    if (data.schema_version !== "strobo-witness/1.0") {
      throw new Error("Schéma non reconnu : " + data.schema_version);
    }
    const n = data.n;
    triples(n); // Validate the declared finite domain before allocating arrays.
    const checkedS = checkSupport(data.support_S, n);
    const checkedT = checkSupport(data.support_T, n);
    const distinct = checkedS.join(",") !== checkedT.join(",");
    const rS = convolution(checkedS, n);
    const rT = convolution(data.support_T, n);
    const matchesStored = Array.isArray(data.convolution_R) &&
      data.convolution_R.length === n &&
      rS.every((v, i) => v === data.convolution_R[i]);
    const isExactCollision = distinct && rS.every((v, i) => v === rT[i]);
    const diff = symmetricDifference(checkedS, checkedT);
    const matchesMetadata =
      JSON.stringify(data.symmetric_difference) === JSON.stringify(diff) &&
      data.delta_cardinality === diff.length &&
      data.zero_free_diff === !diff.includes(0);
    return {
      valid: isExactCollision && matchesStored && matchesMetadata,
      recomputed_R: rS,
      isExactCollision: isExactCollision,
      recomputed_diff: diff
    };
  }

  return {
    VERSION,
    SUPPORTED_ORDERS,
    checkSupport,
    triples,
    convolution,
    fiberPartition,
    symmetricDifference,
    exportCollisionWitness,
    verifyWitness
  };
});

