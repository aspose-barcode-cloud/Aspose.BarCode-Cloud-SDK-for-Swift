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

swift test
