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

if [ -f .env.integration ]; then
    set -a
    # shellcheck disable=SC1091
    source .env.integration
    set +a
fi

echo "Running tests with code coverage..."
swift test --enable-code-coverage

codecov_path="$(swift test --enable-code-coverage --show-codecov-path | tail -n1)"
if [ ! -f "$codecov_path" ]; then
    echo "::error::codecov JSON not found at $codecov_path" >&2
    exit 1
fi

# Measure only the SDK sources: the codecov JSON totals also include the test
# target and SwiftPM-generated .build files, which would dilute the gate.
percent="$(jq -e '
    [.data[0].files[] | select(.filename | test("/Sources/"))]
    | (map(.summary.lines.count) | add) as $count
    | if ($count // 0) == 0 then error("no Sources files in coverage data")
      else 100 * (map(.summary.lines.covered) | add) / $count
      end
' "$codecov_path")"

case "$percent" in
    '' | null)
        echo "::error::Could not read coverage percent from $codecov_path" >&2
        exit 1
        ;;
esac

echo "Total line coverage: ${percent}% (threshold: ${threshold}%)"

if awk -v p="$percent" -v t="$threshold" 'BEGIN { exit !(p < t) }'; then
    echo "::error::Line coverage ${percent}% is below the required ${threshold}%" >&2
    exit 1
fi

echo "Coverage gate passed."
