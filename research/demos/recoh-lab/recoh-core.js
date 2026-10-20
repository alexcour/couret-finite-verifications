/* RECOH/STROBO Lab — exact finite C8 core.
 * Public review demonstrator; this is not a proof of mathematical originality.
 * MIT-compatible contribution to the host repository.
 */
(function (root, factory) {
  "use strict";
  const api = factory();
  if (typeof module !== "undefined" && module.exports) module.exports = api;
  if (root) root.RECOH_CORE = api;
})(typeof globalThis === "object" ? globalThis : this, function () {
  "use strict";
  const N = 8;

  function checkSupport(s, n = N, count = 3) {
    if (!Array.isArray(s) || s.length !== count ||
        s.some(x => !Number.isInteger(x) || x < 0 || x >= n) ||
        new Set(s).size !== count) {
      throw new Error("Le support doit contenir " + count + " résidus distincts entre 0 et " + (n - 1) + ".");
    }
    return [...s].sort((a, b) => a - b);
  }

  function convolution(s, n = N) {
    checkSupport(s, n);
    const r = Array(n).fill(0);
    for (const a of s) for (const b of s) r[(a + b) % n]++;
    return r;
  }

  function triples(n = N) {
    if (!Number.isInteger(n) || n < 3 || n > 64) throw new Error("n hors périmètre");
    const out = [];
    for (let a = 0; a < n - 2; a++)
      for (let b = a + 1; b < n - 1; b++)
        for (let c = b + 1; c < n; c++)
          out.push([a, b, c]);
    return out;
  }

  function candidates(r, n = N) {
    if (!Array.isArray(r) || r.length !== n || r.some(x => !Number.isInteger(x) || x < 0))
      throw new Error("Observation invalide");
    if (r.reduce((a, b) => a + b, 0) !== 9) return [];
    return triples(n).filter(s => {
      const candidate = convolution(s, n);
      return candidate.every((v, i) => v === r[i]);
    });
  }

  function character(s, k = 3, n = N) {
    checkSupport(s, n);
    if (!Number.isInteger(k) || k < 0 || k >= n) throw new Error("Caractère invalide");
    let re = 0, im = 0;
    for (const x of s) {
      const theta = 2 * Math.PI * k * x / n;
      re += Math.cos(theta);
      im += Math.sin(theta);
    }
    return { re, im };
  }

  function compatible(s, k, observation, tolerance, n = N) {
    if (!observation || !Number.isFinite(observation.re) || !Number.isFinite(observation.im) ||
        !Number.isFinite(tolerance) || tolerance < 0)
      throw new Error("Mesure ou tolérance invalide");
    const value = character(s, k, n);
    return Math.hypot(value.re - observation.re, value.im - observation.im) <= tolerance + 1e-12;
  }

  function translate(s, t, n = N) {
    checkSupport(s, n);
    if (!Number.isInteger(t)) throw new Error("Translation invalide");
    return s.map(x => ((x + t) % n + n) % n).sort((a, b) => a - b);
  }

  return { N, checkSupport, convolution, triples, candidates, character, compatible, translate };
});
