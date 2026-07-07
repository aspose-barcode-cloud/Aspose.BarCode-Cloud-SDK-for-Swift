#!/bin/bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repo_root"

# Offline unit tests only. The live integration suite (LiveAPITests) hits the
# real Aspose.BarCode Cloud API and is exercised separately via
# Scripts/runIntegrationTests.sh so the PR gate stays fast and deterministic.
swift test --skip LiveAPITests
