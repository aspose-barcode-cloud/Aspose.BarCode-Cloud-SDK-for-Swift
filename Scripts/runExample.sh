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

has_access_token=false
has_client_credentials=false

if [ -n "${TEST_CONFIGURATION_ACCESS_TOKEN:-}" ]; then
    has_access_token=true
fi

if [ -n "${ASPOSE_CLIENT_ID:-}" ] && [ -n "${ASPOSE_CLIENT_SECRET:-}" ]; then
    has_client_credentials=true
fi

if [ "$has_access_token" != true ] && [ "$has_client_credentials" != true ]; then
    echo "Missing example credentials."
    echo "Create .env.integration from .env.integration.example and set either TEST_CONFIGURATION_ACCESS_TOKEN or ASPOSE_CLIENT_ID/ASPOSE_CLIENT_SECRET."
    exit 1
fi

echo "Running a live Aspose Cloud example. This consumes real API calls."
swift run GenerateAndScanExample "${1:-Aspose.BarCode Cloud Swift example}"
