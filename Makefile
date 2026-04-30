.PHONY: all
all: test

.PHONY: init
init:
	swift package resolve

.PHONY: build
build:
	swift build

.PHONY: test
test:
	./Scripts/runTests.sh

.PHONY: integration-test
integration-test:
	./Scripts/runIntegrationTests.sh

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
after-gen: build test
