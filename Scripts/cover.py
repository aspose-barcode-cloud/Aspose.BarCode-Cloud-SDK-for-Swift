#!/usr/bin/env python3
"""Coverage gate for the generated Swift SDK (`make cover`).

Runs the test suite with code coverage, exports the profile as LCOV with
llvm-cov and passes it to the shared Scripts/coverage.py, which prints the line
coverage of the SDK sources, writes coverage/coverage-{badge,summary}.json and
exits non-zero when coverage drops below the threshold (default 80%,
overridable via COVERAGE_THRESHOLD).

The offline suites (GeneratedModelCoverageTests and the other unit tests)
provide the deterministic floor; the live integration tests (gated on
TEST_CONFIGURATION_ACCESS_TOKEN) cover the network request paths.
"""

import json
import os
import shutil
import subprocess
import sys
from typing import List, NoReturn, Optional

REPO_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
LCOV = os.path.join("coverage", "lcov.info")


def fail(message: str) -> NoReturn:
    print("::error::" + message, file=sys.stderr)
    sys.exit(1)


def products_dir() -> str:
    """Directory with the build products and the merged coverage profile.

    SwiftPM writes the profile next to its codecov JSON:
    .build/<triple>/debug/codecov/ with the native build system,
    .build/out/Products/<config>-<platform>/codecov/ with swiftbuild.
    """
    output = subprocess.run(
        ["swift", "test", "--enable-code-coverage", "--show-codecov-path"],
        check=True,
        stdout=subprocess.PIPE,
        universal_newlines=True,
    ).stdout
    codecov_path = output.strip().splitlines()[-1]
    return os.path.dirname(os.path.dirname(codecov_path))


def test_binaries(directory: str) -> List[str]:
    """Binaries that hold the test code and the SDK library they link statically.

    native build system: one AsposeBarcodeCloudPackageTests.xctest;
    swiftbuild on Linux: <TestTarget>.so per test target (run by
      <TestTarget>-test-runner, which holds no SDK code);
    macOS: .xctest bundles with the executable inside.
    """
    binaries = []
    for name in sorted(os.listdir(directory)):
        if not name.endswith((".xctest", ".so")):
            continue
        path = os.path.join(directory, name)
        if os.path.isdir(path):
            path = os.path.join(path, "Contents", "MacOS", name[: -len(".xctest")])
        if os.path.isfile(path):
            binaries.append(path)
    return binaries


def find_llvm_cov() -> Optional[str]:
    """llvm-cov from the Swift toolchain (SwiftPM uses it for the codecov JSON).

    It is often not on PATH: /usr/local/bin/swift may be a link or a
    toolchain-manager shim, so ask the compiler where its toolchain lives
    (<toolchain>/usr/lib/swift) and take <toolchain>/usr/bin/llvm-cov.
    """
    found = shutil.which("llvm-cov")
    if found:
        return found
    if shutil.which("xcrun"):
        result = subprocess.run(
            ["xcrun", "--find", "llvm-cov"], stdout=subprocess.PIPE, stderr=subprocess.DEVNULL, universal_newlines=True
        )
        if result.returncode == 0 and result.stdout.strip():
            return result.stdout.strip()
    candidates = []
    try:
        info = subprocess.run(
            ["swiftc", "-print-target-info"], check=True, stdout=subprocess.PIPE, universal_newlines=True
        ).stdout
        resource_dir = json.loads(info)["paths"]["runtimeResourcePath"]
        candidates.append(os.path.join(os.path.dirname(os.path.dirname(resource_dir)), "bin", "llvm-cov"))
    except (OSError, subprocess.CalledProcessError, ValueError, KeyError):
        pass
    swift = shutil.which("swift")
    if swift:
        candidates.append(os.path.join(os.path.dirname(os.path.realpath(swift)), "llvm-cov"))
    for candidate in candidates:
        if os.path.isfile(candidate) and os.access(candidate, os.X_OK):
            return candidate
    return None


def main() -> int:
    os.chdir(REPO_ROOT)

    print("Running tests with code coverage...", flush=True)
    subprocess.run(["swift", "test", "--enable-code-coverage"], check=True)

    directory = products_dir()
    profdata = os.path.join(directory, "codecov", "default.profdata")
    if not os.path.isfile(profdata):
        fail("coverage profile not found at {}".format(profdata))

    binaries = test_binaries(directory)
    if not binaries:
        listing = "\n".join(sorted(os.listdir(directory)))
        fail("no test binaries (*.xctest, *.so) found in {}:\n{}".format(directory, listing))
    print("Test binaries: {}".format(" ".join(binaries)))

    llvm_cov = find_llvm_cov()
    if not llvm_cov:
        fail("llvm-cov not found in the Swift toolchain")
    print("llvm-cov: {}".format(llvm_cov), flush=True)

    # llvm-cov merges the coverage of the SDK library linked into every binary.
    objects = [binaries[0]]
    for binary in binaries[1:]:
        objects += ["-object", binary]
    os.makedirs("coverage", exist_ok=True)
    with open(LCOV, "w", encoding="utf-8") as lcov:
        subprocess.run(
            [llvm_cov, "export", "-format=lcov", "-instr-profile", profdata] + objects, check=True, stdout=lcov
        )

    # Measure only the SDK sources: the profile also covers the test targets and
    # SwiftPM-generated .build files, which would dilute the gate.
    gate = subprocess.run(
        [sys.executable, os.path.join("Scripts", "coverage.py"), "lcov", LCOV, "--include", "/Sources/"]
    )
    if gate.returncode != 0:
        fail("Line coverage is below the required threshold")

    print("Coverage gate passed.")
    return 0


if __name__ == "__main__":
    try:
        sys.exit(main())
    except subprocess.CalledProcessError as error:
        fail("{} failed with exit code {}".format(" ".join(error.cmd), error.returncode))
