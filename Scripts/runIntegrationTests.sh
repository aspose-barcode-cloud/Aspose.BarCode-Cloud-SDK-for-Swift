#!/bin/bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repo_root"

# Live integration suite. These tests call the real Aspose.BarCode Cloud API and
# require credentials: set TEST_CONFIGURATION_ACCESS_TOKEN, create
# Tests/configuration.json from Tests/configuration.example.json, or set
# TEST_CONFIGURATION_CLIENT_ID and TEST_CONFIGURATION_CLIENT_SECRET.
swift test --filter AsposeBarcodeCloudIntegrationTests
