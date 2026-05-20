'use strict';

const assert = require('assert');
const fs = require('fs');
const path = require('path');

const repoRoot = path.resolve(__dirname, '..', '..');

let passed = 0;
let failed = 0;

function test(name, fn) {
  try {
    fn();
    console.log(`  ✓ ${name}`);
    passed++;
  } catch (error) {
    console.log(`  ✗ ${name}`);
    console.log(`    Error: ${error.message}`);
    failed++;
  }
}

function load(relativePath) {
  return fs.readFileSync(path.join(repoRoot, relativePath), 'utf8').replace(/\r\n/g, '\n');
}

console.log('\n=== Testing release publish workflow ===\n');

for (const workflow of ['.github/workflows/release.yml', '.github/workflows/reusable-release.yml']) {
  const content = load(workflow);

  test(`${workflow} ignores dependency lifecycle scripts`, () => {
    assert.match(content, /npm ci --ignore-scripts/);
  });

  test(`${workflow} creates the GitHub Release`, () => {
    assert.match(content, /name: Create GitHub Release/);
  });

  test(`${workflow} does not publish to the public npm registry`, () => {
    assert.doesNotMatch(content, /npm publish/);
    assert.doesNotMatch(content, /name: Publish npm package/);
  });

  test(`${workflow} does not probe the npm registry for published versions`, () => {
    assert.doesNotMatch(content, /Check npm publish state/);
    assert.doesNotMatch(content, /npm view /);
  });

  test(`${workflow} does not request id-token (npm provenance) permissions`, () => {
    assert.doesNotMatch(content, /id-token:\s*write/);
  });

  test(`${workflow} does not reference npm registry credentials or configuration`, () => {
    assert.doesNotMatch(content, /NPM_TOKEN/);
    assert.doesNotMatch(content, /registry-url/);
  });
}

if (failed > 0) {
  console.log(`\nFailed: ${failed}`);
  process.exit(1);
}

console.log(`\nPassed: ${passed}`);
