"use strict";
const assert = require("node:assert/strict");
const S = require("./strobo-core.js");

// 1. C4 exact enumeration and partition
assert.equal(S.triples(4).length, 4);
const c4_fibers = S.fiberPartition(4);
assert.equal(c4_fibers.length, 2);
assert.ok(c4_fibers.every(f => f.candidates.length === 2));

// Fixture C4 collision
const c4_wit = S.exportCollisionWitness([0, 1, 2], [0, 2, 3], 4);
assert.equal(c4_wit.schema_version, "strobo-witness/1.0");
assert.deepEqual(c4_wit.convolution_R, [2, 2, 3, 2]);
assert.deepEqual(c4_wit.symmetric_difference, [1, 3]);
assert.equal(c4_wit.delta_cardinality, 2);
assert.equal(c4_wit.zero_free_diff, true);

// 2. C8 exact enumeration and partition
assert.equal(S.triples(8).length, 56);
const c8_fibers = S.fiberPartition(8);
assert.equal(c8_fibers.length, 28);
assert.ok(c8_fibers.every(f => f.candidates.length === 2));

// Fixture C8 collision
const c8_wit = S.exportCollisionWitness([0, 3, 5], [1, 4, 7], 8);
assert.deepEqual(c8_wit.convolution_R, [3, 0, 1, 2, 0, 2, 1, 0]);
assert.equal(c8_wit.delta_cardinality, 6);

// Verification of witness
const checkC8 = S.verifyWitness(c8_wit);
assert.equal(checkC8.valid, true);
assert.equal(checkC8.isExactCollision, true);

// Rejection of identical sets S = T
assert.throws(() => S.exportCollisionWitness([0, 3, 5], [0, 3, 5], 8));

console.log("STROBO Explorer (C4/C8): all finite checks, fiber partitions, and witness verifications passed.");
