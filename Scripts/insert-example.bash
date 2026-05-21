#!/bin/bash
set -euo pipefail

cd "$( dirname "${BASH_SOURCE[0]}" )/.."

python3 "./Scripts/insert-example.py" "README.template" > "README.md"

rm "README.template"
