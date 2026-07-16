ifneq ($(origin MAKEFILE_LIST),file)
$(error MAKEFILE_LIST must not be overridden)
endif
override ROOT := $(shell path='$(subst ','"'"',$(MAKEFILE_LIST))'; path=$$(printf '%s' "$$path" | sed 's/^ //'); dirname -- "$$path")
SWIFTC ?= swiftc

.PHONY: build check lint test

lint test build: check

# The three policy suites are &&-chained, not `;`-chained. Make runs recipes via `sh -c`
# with no `set -e`, so a `;`-separated list inside this if-block exits with the status of
# only its LAST command: a failure in the api-base-url or schedule suite was discarded and
# the target still succeeded. Verified in isolation -- a recipe of the identical shape whose
# first two commands exit 1 and whose last exits 0 gives `make` exit 0.
check:
	@if command -v "$(SWIFTC)" >/dev/null 2>&1; then \
		SWIFTC="$(SWIFTC)" "$(ROOT)/scripts/run-api-base-url-policy-tests.sh" && \
		SWIFTC="$(SWIFTC)" "$(ROOT)/scripts/run-schedule-response-policy-tests.sh" && \
		SWIFTC="$(SWIFTC)" "$(ROOT)/scripts/run-location-response-policy-tests.sh"; \
	else \
		echo "swiftc unavailable; executable response policy tests skipped"; \
	fi
	python3 "$(ROOT)/scripts/check-baseline.py"
	cd "$(ROOT)" && ./build.sh
