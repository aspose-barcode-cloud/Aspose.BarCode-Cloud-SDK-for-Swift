#!/bin/bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repo_root"

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
    echo "Missing example credentials."
    echo "Create Tests/configuration.json from Tests/configuration.example.json,"
    echo "or export TEST_CONFIGURATION_ACCESS_TOKEN,"
    echo "or export TEST_CONFIGURATION_CLIENT_ID and TEST_CONFIGURATION_CLIENT_SECRET."
    exit 1
fi

echo "Running Aspose Cloud example."
swift run GenerateAndScanExample "${1:-Aspose.BarCode Cloud Swift example}"
