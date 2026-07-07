#!/bin/bash
#
# Coverage gate for the generated Swift SDK.
#
# Runs the test suite with code coverage, reads the total line coverage percent
# from the llvm-cov codecov JSON, prints it, and exits non-zero when it drops
# below the required threshold (default 80%, overridable via COVERAGE_THRESHOLD).
#
# The offline suites (GeneratedModelCoverageTests and the other unit tests)
# provide the deterministic floor; the live integration tests (gated on
# TEST_CONFIGURATION_ACCESS_TOKEN) cover the network request paths.
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repo_root"

threshold="${COVERAGE_THRESHOLD:-80}"

echo "Running tests with code coverage..."
swift test --enable-code-coverage

codecov_path="$(swift test --enable-code-coverage --show-codecov-path | tail -n1)"
if [ ! -f "$codecov_path" ]; then
    echo "::error::codecov JSON not found at $codecov_path" >&2
    exit 1
fi

# Measure only the SDK sources: the codecov JSON totals also include the test
# target and SwiftPM-generated .build files, which would dilute the gate.
if ! percent="$(python3 - "$codecov_path" <<'PY'
import json
import sys

with open(sys.argv[1], encoding="utf-8") as fh:
    data = json.load(fh)

sources = [f for f in data["data"][0]["files"] if "/Sources/" in f["filename"]]
total = sum(f["summary"]["lines"]["count"] for f in sources)
if total == 0:
    sys.exit("no Sources files in coverage data")
covered = sum(f["summary"]["lines"]["covered"] for f in sources)
print(100 * covered / total)
PY
)"; then
    echo "::error::Could not read coverage percent from $codecov_path" >&2
    exit 1
fi

echo "Total line coverage: ${percent}% (threshold: ${threshold}%)"

if awk -v p="$percent" -v t="$threshold" 'BEGIN { exit !(p < t) }'; then
    echo "::error::Line coverage ${percent}% is below the required ${threshold}%" >&2
    exit 1
fi

echo "Coverage gate passed."
