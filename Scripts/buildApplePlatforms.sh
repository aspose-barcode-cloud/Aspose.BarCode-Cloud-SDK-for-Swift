#!/bin/bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repo_root"

# Compile the SDK against each Apple platform's SDK so the Swift compiler's
# availability checker enforces the deployment-target floor declared in
# Package.swift (iOS 15 / tvOS 15 / watchOS 8). Using an API newer than the
# floor without an `if #available` / `@available` guard fails the build here.
#
# Generic simulator destinations are used on purpose: they need no code signing
# and no specific simulator runtime installed, yet still apply the deployment
# target for availability checking. macOS is intentionally omitted because it is
# already compiled by `swift build` (see the `build` target); pass
# "generic/platform=macOS" as an argument to include it.
destinations=("$@")
if [ "${#destinations[@]}" -eq 0 ]; then
    destinations=(
        "generic/platform=iOS Simulator"
        "generic/platform=tvOS Simulator"
        "generic/platform=watchOS Simulator"
    )
fi

for destination in "${destinations[@]}"; do
    echo "== Building for ${destination} =="
    xcodebuild build \
        -scheme AsposeBarcodeCloud \
        -destination "${destination}" \
        CODE_SIGNING_ALLOWED=NO
done
