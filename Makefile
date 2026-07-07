.PHONY: all
all: test

.PHONY: init
init:
	swift package resolve

.PHONY: build
build:
	swift build

.PHONY: format
format:
	@command -v swiftformat >/dev/null || { \
		echo "swiftformat not found. Install options:" >&2; \
		echo "  macOS:    brew install swiftformat" >&2; \
		echo "  Linux:    install Mint, then 'mint install nicklockwood/SwiftFormat'" >&2; \
		echo "            Bootstrap Mint (Linux, no apt package):" >&2; \
		echo "              git clone --depth=1 https://github.com/yonaskolb/Mint /tmp/Mint" >&2; \
		echo "              (cd /tmp/Mint && swift build -c release)" >&2; \
		echo "              sudo install -m 0755 /tmp/Mint/.build/release/mint /usr/local/bin/mint" >&2; \
		echo "  Source:   https://github.com/nicklockwood/SwiftFormat" >&2; \
		exit 1; \
	}
	swiftformat .

.PHONY: insert-example
insert-example:
	./Scripts/insert-example.bash

.PHONY: test
test:
	./Scripts/runTests.sh

.PHONY: cover
cover:
	./Scripts/coverage.sh

.PHONY: integration-test
integration-test:
	./Scripts/runTests.sh

.PHONY: snippets-test
snippets-test:
	./Scripts/runSnippets.sh

.PHONY: example
example:
	./Scripts/runExample.sh

.PHONY: update
update:
	swift package update

.PHONY: clean
clean:
	rm -rf .build .swiftpm DerivedData Package.resolved

.PHONY: after-gen
after-gen: format insert-example
