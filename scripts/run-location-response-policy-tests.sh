#!/bin/sh
set -eu

ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
SWIFTC=${SWIFTC:-swiftc}
BUILD_DIR=$(mktemp -d "${TMPDIR:-/tmp}/larkspur-location-response-tests.XXXXXX")

cleanup() {
    rm -rf -- "$BUILD_DIR"
}
trap cleanup 0
trap 'exit 129' 1
trap 'exit 130' 2
trap 'exit 143' 15

"$SWIFTC" \
    "$ROOT/Larkspur Ferry/LocationResponsePolicy.swift" \
    "$ROOT/Tests/LocationResponsePolicyTests/main.swift" \
    -o "$BUILD_DIR/location-response-policy-tests"

"$BUILD_DIR/location-response-policy-tests"
