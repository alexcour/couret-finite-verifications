"use strict";
const assert = require("node:assert/strict");
const C = require("./recoh-core.js");

// 1. C8 exact enumeration and fixtures
assert.equal(C.triples(8).length, 56);
assert.deepEqual(C.convolution([0, 3, 5], 8), [3, 0, 1, 2, 0, 2, 1, 0]);
assert.deepEqual(C.candidates([3, 0, 1, 2, 0, 2, 1, 0], 8), [[0, 3, 5], [1, 4, 7]]);
assert.deepEqual(C.translate([0, 3, 5], 4, 8), [1, 4, 7]);
assert.equal(C.triples(8).every(s => C.candidates(C.convolution(s, 8), 8).some(t => JSON.stringify(t) === JSON.stringify(s))), true);
assert.equal(C.triples(8).every(s => C.convolution(s, 8).reduce((a, b) => a + b, 0) === 9), true);

// 2. Complex Character & Fourier Exact Square Identity
const k = 3;
const a = C.character([0, 3, 5], k, 8);
const b = C.character([1, 4, 7], k, 8);
assert.ok(Math.abs(a.re - (1 + Math.SQRT2)) < 1e-10);
assert.ok(Math.hypot(a.re - b.re, a.im - b.im) > 1);
assert.equal(C.compatible([0, 3, 5], 3, a, 0.1, 8), true);
assert.equal(C.compatible([1, 4, 7], 3, a, 0.1, 8), false);
assert.equal(C.compatible([1, 4, 7], 3, a, 5, 8), true);

// Check Fourier identity sum R(z) exp(...) == P_k(S)^2 (NOT |P_k|^2)
for (const s of C.triples(8)) {
  const r = C.convolution(s, 8);
  for (let ki = 0; ki < 8; ki++) {
    const fR = C.fourierR(r, ki, 8);
    const p = C.character(s, ki, 8);
    const p_sq = C.complexMul(p, p);
    assert.ok(Math.hypot(fR.re - p_sq.re, fR.im - p_sq.im) < 1e-9);
  }
}

// 3. 28 fibers of size 2 in C8 and chi3 distinction
const fibres = new Map();
for (const s of C.triples(8)) {
  const key = C.convolution(s, 8).join(",");
  fibres.set(key, (fibres.get(key) || 0) + 1);
}
assert.equal(fibres.size, 28);
assert.ok([...fibres.values()].every(x => x === 2));

for (const s of C.triples(8)) {
  const fiber = C.candidates(C.convolution(s, 8), 8);
  assert.equal(fiber.length, 2);
  const v = C.character(s, 3, 8);
  const surviving = fiber.filter(candidate => C.compatible(candidate, 3, v, 1e-6, 8));
  assert.deepEqual(surviving, [s], "Chi3 must separate each complete C8 fiber");
}

// 4. C4 support and boundary fixture
assert.equal(C.triples(4).length, 4);
const c4_r = C.convolution([0, 1, 2], 4);
assert.deepEqual(c4_r, [2, 2, 3, 2]);
const c4_cand = C.candidates(c4_r, 4);
assert.deepEqual(c4_cand, [[0, 1, 2], [0, 2, 3]]);
const c4_p1 = C.character([0, 1, 2], 1, 4);
assert.ok(Math.abs(c4_p1.re) < 1e-10 && Math.abs(c4_p1.im - 1) < 1e-10); // P_1 = i
const c4_sep = C.computeSeparation(c4_cand, 1, 4);
assert.ok(Math.abs(c4_sep.delta_k - 2.0) < 1e-10);

// Boundary test at epsilon = 1 and y = 0
const y_zero = { re: 0, im: 0 };
assert.equal(C.compatible([0, 1, 2], 1, y_zero, 1.0, 4), true);
assert.equal(C.compatible([0, 2, 3], 1, y_zero, 1.0, 4), true);
assert.equal(C.compatible([0, 1, 2], 1, y_zero, 0.99, 4), false);

// 5. Virtual decision engine rules
// Disagreement -> INDETERMINE
assert.equal(C.evaluateVirtualDecision([[0, 3, 5], [1, 4, 7]], 0, 8).status, "INDETERMINE");
// Present in all -> REFUSE
assert.equal(C.evaluateVirtualDecision([[0, 3, 5]], 0, 8).status, "REFUSE");
// Absent in all -> AUTORISE
assert.equal(C.evaluateVirtualDecision([[0, 3, 5]], 2, 8).status, "AUTORISE");
// Empty set NEVER authorizes -> OBSERVATIONS_INCOMPATIBLES
const dec_empty = C.evaluateVirtualDecision([], 2, 8);
assert.equal(dec_empty.status, "OBSERVATIONS_INCOMPATIBLES");
assert.equal(dec_empty.allowed, false);
assert.equal(dec_empty.blocked, true);

// 6. Export / Import Replay Engine
const exported = C.exportExperiment({
  n: 8,
  support: [0, 3, 5],
  mode: "notebook",
  measurements: [{ k: 3, y: a, epsilon: 0.1, margin: 3.828, guarantee: "SEPARATION_GARANTIE" }],
  virtualPosition: 2
});
assert.equal(exported.schema_version, "recoh-lab/1.0");
const imported = C.importExperiment(JSON.stringify(exported));
assert.equal(imported.valid, true);
assert.equal(imported.isCleanReplay, true);
assert.equal(imported.virtualDecision.status, "AUTORISE");

// Invalid imports rejection
assert.throws(() => C.importExperiment({ schema_version: "invalid" }));
assert.throws(() => C.importExperiment(JSON.stringify({ schema_version: "recoh-lab/1.0", n: 8, observation_R: [1, 2, 3] })));

console.log("RECOH C8/C4: all exact finite, numeric, decision, and export/import tests passed successfully.");
