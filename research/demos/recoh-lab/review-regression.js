"use strict";
const assert = require("node:assert/strict");
const path = require("node:path");
const root = process.env.RECOH_REVIEW_ROOT || __dirname;
const C = require(path.join(root, "recoh-core.js"));
const S = require(path.join(root, "../strobo-explorer/strobo-core.js"));
const results = [];
function test(name, fn) {
  try { fn(); results.push({ name, status: "PASS" }); }
  catch (e) { results.push({ name, status: "FAIL", message: e.message }); }
}
function subsets(n) {
  const out = [];
  for (let mask = 0; mask < 2 ** n; mask++) {
    const t = Array.from({length:n}, (_,i)=>i).filter(i=>mask & (1 << i));
    if (t.length === 3) out.push(t);
  }
  return out;
}
function oracle(t,n) {
  const f = Array(n).fill(0); t.forEach(x=>f[x]=1);
  return f.map((_,z)=>f.reduce((a,v,x)=>a+v*f[(z-x+n)%n],0));
}
const canonical = xs => xs.map(x=>JSON.stringify(x)).sort();
function sample(overrides={}) {
  return C.exportExperiment({n:8,support:[0,3,5],mode:"single",
    measurements:[{k:3,y:C.character([0,3,5],3,8),epsilon:.1}],
    virtualPosition:0,...overrides});
}
test("60 supports: independent integer convolution and complete fiber oracle",()=>{
  for(const n of [4,8]) for(const t of subsets(n)){
    const r=oracle(t,n);
    assert.deepEqual(C.convolution(t,n),r);
    assert.deepEqual(canonical(C.candidates(r,n)),
      canonical(subsets(n).filter(u=>JSON.stringify(oracle(u,n))===JSON.stringify(r))));
  }
});
test("60 blind challenges: even character cannot certify unique reconstruction",()=>{
  for(const n of [4,8]) for(const target of subsets(n)){
    const g=C.createBlindChallenge(target,n);
    g.takeMeasurement(2);
    const alternative=C.candidates(oracle(target,n),n).find(t=>JSON.stringify(t)!==JSON.stringify(target));
    const result=g.verifyGuess(alternative);
    assert.equal(result.matchesR,true);
    assert.equal(result.matchesMeasurements,true);
    assert.equal(result.isExactMatch,false);
    assert.equal(result.isUniqueMatch,false);
    assert.equal(result.compatibleCount,2);
  }
});
test("60 blind challenges: recommended measurement isolates the simulated support",()=>{
  for(const n of [4,8]) for(const target of subsets(n)){
    const g=C.createBlindChallenge(target,n);
    g.takeMeasurement(g.recommendNextMeasurement().recommendedK);
    assert.equal(g.verifyGuess(target).isUniqueMatch,true);
    assert.equal(g.verifyGuess(target).compatibleCount,1);
  }
});
test("malformed or missing measurement arrays are rejected",()=>{
  for(const bad of [undefined,null,{},3,"",true]){
    const x=sample(); x.measurements=bad;
    assert.throws(()=>C.importExperiment(x));
  }
});
test("mode and measurement count must agree",()=>{
  const x=sample(); x.mode="unknown";assert.throws(()=>C.importExperiment(x));
  x.mode="single";x.measurements=[];assert.throws(()=>C.importExperiment(x));
});
test("tampered allowed flag is reported while decision is recomputed",()=>{
  const x=sample();x.virtual_decision.allowed=true;
  const r=C.importExperiment(x);
  assert.equal(r.virtualDecision.allowed,false);
  assert.equal(r.isCleanReplay,false);
});
test("replay preserves nonzero decision position and notebook mode",()=>{
  const x=sample({mode:"notebook",measurements:[],virtualPosition:2});
  const r=C.importExperiment(x);
  assert.equal(r.mode,"notebook");assert.equal(r.virtualDecision.position,2);
  assert.deepEqual(r.measurements,[]);assert.equal(r.isCleanReplay,true);
});
test("wrong conventions, group, support and malformed decisions are rejected",()=>{
  for(const mutate of [
    x=>x.conventions.diagonalIncluded=false,
    x=>x.group="Z/4Z",
    x=>x.support=[0,1,2],
    x=>x.virtual_decision={position:"2"},
    x=>x.measurements=[null]
  ]){const x=sample();mutate(x);assert.throws(()=>C.importExperiment(x));}
});
test("different engine version is not called a clean identical replay",()=>{
  const x=sample();x.engine_version="unavailable-old-build";
  assert.equal(C.importExperiment(x).isCleanReplay,false);
});
test("empty fiber is incompatible, not already reconstructed",()=>{
  assert.equal(C.computeSeparation([],1,8).status,"OBSERVATIONS_INCOMPATIBLES");
  assert.equal(C.evaluateVirtualDecision([],2,8).allowed,false);
});
test("witness verifier rejects identical supports",()=>{
  const x=S.exportCollisionWitness([0,1,2],[0,2,3],4);x.support_T=[0,1,2];
  assert.equal(S.verifyWitness(x).valid,false);
});
test("witness verifier rejects altered metadata and extra R entries",()=>{
  for(const mutate of [
    x=>x.symmetric_difference=[0],
    x=>x.delta_cardinality=99,
    x=>x.zero_free_diff=false,
    x=>x.convolution_R.push(0)
  ]){const x=S.exportCollisionWitness([0,1,2],[0,2,3],4);mutate(x);
    assert.equal(S.verifyWitness(x).valid,false);}
});
test("valid C4 and C8 witnesses remain valid",()=>{
  for(const [n,a,b] of [[4,[0,1,2],[0,2,3]],[8,[0,3,5],[1,4,7]]])
    assert.equal(S.verifyWitness(S.exportCollisionWitness(a,b,n)).valid,true);
});
console.log(JSON.stringify({scope:"source-only; not a browser or WordPress test",
  checks:results.length,passed:results.filter(x=>x.status==="PASS").length,
  failed:results.filter(x=>x.status==="FAIL").length,results},null,2));
if(results.some(x=>x.status==="FAIL"))process.exitCode=1;

