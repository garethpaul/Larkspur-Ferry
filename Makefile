ifneq ($(origin MAKEFILE_LIST),file)
$(error MAKEFILE_LIST must not be overridden)
endif
override ROOT := $(shell path='$(subst ','"'"',$(MAKEFILE_LIST))'; path=$$(printf '%s' "$$path" | sed 's/^ //'); dirname -- "$$path")
SWIFTC ?= swiftc

.PHONY: build check lint test

lint test build: check

check:
	@if command -v "$(SWIFTC)" >/dev/null 2>&1; then \
		SWIFTC="$(SWIFTC)" "$(ROOT)/scripts/run-api-base-url-policy-tests.sh"; \
		SWIFTC="$(SWIFTC)" "$(ROOT)/scripts/run-schedule-response-policy-tests.sh"; \
		SWIFTC="$(SWIFTC)" "$(ROOT)/scripts/run-location-response-policy-tests.sh"; \
	else \
		echo "swiftc unavailable; executable response policy tests skipped"; \
	fi
	python3 "$(ROOT)/scripts/check-baseline.py"
	cd "$(ROOT)" && ./build.sh
