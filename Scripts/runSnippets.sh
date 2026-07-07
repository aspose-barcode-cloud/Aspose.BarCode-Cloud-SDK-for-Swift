#!/bin/bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repo_root"

access_token="${TEST_CONFIGURATION_ACCESS_TOKEN:-}"
client_id="${TEST_CONFIGURATION_CLIENT_ID:-${ASPOSE_CLIENT_ID:-}}"
client_secret="${TEST_CONFIGURATION_CLIENT_SECRET:-${ASPOSE_CLIENT_SECRET:-}}"
swift_bin="${SWIFT_BIN:-swift}"

config_file=""
for candidate in Tests/configuration.json Tests/Configuration.json; do
    if [ -f "$candidate" ]; then
        config_file="$candidate"
        break
    fi
done

if [ -n "$config_file" ]; then
    IFS="$(printf '\t')" read -r config_access_token config_client_id config_client_secret < <(python3 - "$config_file" <<'PY'
import json
import sys

with open(sys.argv[1], encoding="utf-8") as file:
    payload = json.load(file)

print("\t".join([
    payload.get("accessToken") or payload.get("AccessToken") or "",
    payload.get("clientId") or payload.get("ClientId") or "",
    payload.get("clientSecret") or payload.get("ClientSecret") or "",
]))
PY
)

    access_token="${access_token:-$config_access_token}"
    client_id="${client_id:-$config_client_id}"
    client_secret="${client_secret:-$config_client_secret}"
fi

if [ -z "$access_token" ] && { [ -z "$client_id" ] || [ -z "$client_secret" ]; }; then
    echo "Missing snippet credentials."
    echo "Set TEST_CONFIGURATION_ACCESS_TOKEN, set TEST_CONFIGURATION_CLIENT_ID/TEST_CONFIGURATION_CLIENT_SECRET,"
    echo "or create Tests/configuration.json from Tests/configuration.example.json."
    exit 1
fi

tmp_dir="$(mktemp -d "${TMPDIR:-/tmp}/aspose-swift-snippets.XXXXXX")"
work_dir="$tmp_dir/work"
logs_dir="$tmp_dir/logs"
package_dir="$tmp_dir/package"

cleanup() {
    if [ "${KEEP_SNIPPET_LOGS:-}" = "1" ]; then
        echo "Snippet logs kept in $logs_dir"
    else
        rm -rf "$tmp_dir"
    fi
}
trap cleanup EXIT

mkdir -p "$package_dir/Sources/Runner" "$work_dir" "$logs_dir"

cat > "$package_dir/Package.swift" <<PACKAGE
// swift-tools-version:6.0
import PackageDescription

let package = Package(
    name: "AsposeBarcodeCloudSnippetRunner",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13),
    ],
    products: [
        .executable(name: "Runner", targets: ["Runner"]),
    ],
    dependencies: [
        .package(path: "$repo_root"),
    ],
    targets: [
        .executableTarget(
            name: "Runner",
            dependencies: [.product(name: "AsposeBarcodeCloud", package: "Aspose.BarCode-Cloud-SDK-for-Swift")]
        ),
    ]
)
PACKAGE

sanitize_log() {
    local log_file="$1"

    SNIPPET_ACCESS_TOKEN="$access_token" \
    SNIPPET_CLIENT_ID="$client_id" \
    SNIPPET_CLIENT_SECRET="$client_secret" \
    python3 - "$log_file" <<'PY'
import os
import sys

with open(sys.argv[1], encoding="utf-8", errors="replace") as file:
    content = file.read()

for value, label in [
    (os.environ.get("SNIPPET_ACCESS_TOKEN", ""), "<access-token>"),
    (os.environ.get("SNIPPET_CLIENT_ID", ""), "<client-id>"),
    (os.environ.get("SNIPPET_CLIENT_SECRET", ""), "<client-secret>"),
]:
    if value:
        content = content.replace(value, label)

print(content, end="")
PY
}

prepare_snippet() {
    local source_file="$1"
    local target_file="$2"

    cp "$source_file" "$target_file"

    SNIPPET_ACCESS_TOKEN="$access_token" \
    SNIPPET_CLIENT_ID="$client_id" \
    SNIPPET_CLIENT_SECRET="$client_secret" \
    SNIPPET_IS_MANUAL_FETCH="$([ "$(basename "$source_file")" = "manual_fetch_token.swift" ] && echo "1" || echo "0")" \
    python3 - "$target_file" <<'PY'
import os
import re
import sys

target_file = sys.argv[1]
access_token = os.environ.get("SNIPPET_ACCESS_TOKEN", "")
client_id = os.environ.get("SNIPPET_CLIENT_ID", "")
client_secret = os.environ.get("SNIPPET_CLIENT_SECRET", "")
is_manual_fetch = os.environ.get("SNIPPET_IS_MANUAL_FETCH") == "1"

with open(target_file, encoding="utf-8") as file:
    content = file.read()

def swift_string(value: str) -> str:
    return value.replace("\\", "\\\\").replace('"', '\\"')

if access_token and not is_manual_fetch:
    content = re.sub(
        r'AsposeBarcodeCloudClient\(\s*clientId:\s*"Client Id from https://dashboard\.aspose\.cloud/applications",\s*clientSecret:\s*"Client Secret from https://dashboard\.aspose\.cloud/applications"\s*\)',
        f'AsposeBarcodeCloudClient(accessToken: "{swift_string(access_token)}")',
        content,
    )
elif client_id and client_secret:
    content = content.replace(
        "Client Id from https://dashboard.aspose.cloud/applications",
        swift_string(client_id),
    )
    content = content.replace(
        "Client Secret from https://dashboard.aspose.cloud/applications",
        swift_string(client_secret),
    )

with open(target_file, "w", encoding="utf-8") as file:
    file.write(content)
PY
}

typecheck_snippet() {
    local snippet_file="$1"
    local log_file="$2"

    (cd "$work_dir" && "$swift_bin" build --package-path "$package_dir") > "$log_file" 2>&1
}

run_snippet() {
    local snippet_path="$1"
    local source_file="$repo_root/$snippet_path"
    local target_file="$package_dir/Sources/Runner/main.swift"
    local log_file="$logs_dir/${snippet_path//\//__}.log"

    echo "Run snippet: $snippet_path"
    prepare_snippet "$source_file" "$target_file"

    if [ -n "$access_token" ] && [ "$(basename "$source_file")" = "manual_fetch_token.swift" ]; then
        if typecheck_snippet "$target_file" "$log_file"; then
            echo "PASS $snippet_path (typecheck only: live token fetch requires client credentials)"
            return
        fi
    else
        if (cd "$work_dir" && "$swift_bin" run --package-path "$package_dir" Runner) > "$log_file" 2>&1; then
            echo "PASS $snippet_path"
            return
        fi
    fi

    echo "FAIL $snippet_path"
    sanitize_log "$log_file" | tail -80
    exit 1
}

while IFS= read -r snippet_file; do
    run_snippet "$snippet_file"
done < <(find snippets -type f -name '*.swift' | sort)
