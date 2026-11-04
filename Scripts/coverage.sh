#!/bin/bash
#
# Coverage gate for the generated Swift SDK (`make cover`).
#
# Runs the test suite with code coverage and passes the llvm-cov codecov JSON to
# the shared Scripts/coverage.py, which prints the line coverage of the SDK
# sources, writes coverage/coverage-{badge,summary}.json and exits non-zero when coverage
# drops below the threshold (default 80%, overridable via COVERAGE_THRESHOLD).
#
# The offline suites (GeneratedModelCoverageTests and the other unit tests)
# provide the deterministic floor; the live integration tests (gated on
# TEST_CONFIGURATION_ACCESS_TOKEN) cover the network request paths.
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repo_root"

echo "Running tests with code coverage..."
swift test --enable-code-coverage

codecov_path="$(swift test --enable-code-coverage --show-codecov-path | tail -n1)"
if [ ! -f "$codecov_path" ]; then
    echo "::error::codecov JSON not found at $codecov_path" >&2
    exit 1
fi

mkdir -p coverage
cp "$codecov_path" coverage/codecov.json

# Measure only the SDK sources: the codecov JSON totals also include the test
# target and SwiftPM-generated .build files, which would dilute the gate.
if ! python3 Scripts/coverage.py llvm-cov coverage/codecov.json --include /Sources/; then
    echo "::error::Line coverage is below the required threshold" >&2
    exit 1
fi

echo "Coverage gate passed."
