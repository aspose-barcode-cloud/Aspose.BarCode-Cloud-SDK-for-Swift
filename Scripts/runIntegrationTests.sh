#!/bin/bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repo_root"

if [ -f .env.integration ]; then
    set -a
    # shellcheck disable=SC1091
    source .env.integration
    set +a
fi

export ASPOSE_RUN_INTEGRATION_TESTS="${ASPOSE_RUN_INTEGRATION_TESTS:-true}"

has_access_token=false
has_client_credentials=false

if [ -n "${TEST_CONFIGURATION_ACCESS_TOKEN:-}" ]; then
    has_access_token=true
fi

if [ -n "${TEST_CONFIGURATION_CLIENT_ID:-}" ] && [ -n "${TEST_CONFIGURATION_CLIENT_SECRET:-}" ]; then
    has_client_credentials=true
fi

if [ -n "${ASPOSE_CLIENT_ID:-}" ] && [ -n "${ASPOSE_CLIENT_SECRET:-}" ]; then
    has_client_credentials=true
fi

if [ -f Tests/configuration.json ]; then
    has_client_credentials=true
fi

if [ "$has_access_token" != true ] && [ "$has_client_credentials" != true ]; then
    echo "Missing integration credentials."
    echo "Create Tests/configuration.json from Tests/configuration.example.json,"
    echo "or create .env.integration from .env.integration.example and set TEST_CONFIGURATION_ACCESS_TOKEN"
    echo "or TEST_CONFIGURATION_CLIENT_ID/TEST_CONFIGURATION_CLIENT_SECRET."
    exit 1
fi

echo "Running live Aspose Cloud integration tests."
swift test --filter AsposeBarcodeCloudTests/testGenerateSmokeWhenIntegrationEnvironmentIsEnabled
swift test --filter AsposeBarcodeCloudTests/testGenerateScanAndRecognizeBase64SmokeWhenIntegrationEnvironmentIsEnabled
