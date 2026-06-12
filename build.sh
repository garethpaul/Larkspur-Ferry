#!/bin/sh

set -eu

ci_build() {
    NAME=$1
    pod install
    xcodebuild -workspace "Larkspur Ferry.xcworkspace" \
               -scheme "Larkspur Ferry" \
               -destination "platform=iOS Simulator,name=${NAME}" \
               -sdk iphonesimulator \
               -configuration "Debug" \
               build
}

ci_test() {
    NAME=$1

    pod install
    xcodebuild -workspace "Larkspur Ferry.xcworkspace" \
               -scheme "Larkspur FerryUITests" \
               -destination "platform=iOS Simulator,name=${NAME}" \
               -sdk iphonesimulator \
               -configuration "Debug" \
               test
}


if [ "${SKIP_XCODE_BUILD:-}" = "1" ]; then
    echo "SKIP_XCODE_BUILD=1; skipping legacy CocoaPods and simulator build."
    exit 0
fi

if ! command -v pod >/dev/null 2>&1 || ! command -v xcodebuild >/dev/null 2>&1; then
    echo "pod or xcodebuild unavailable; skipping Xcode build on this host."
    exit 0
fi

ci_build "iPhone 5"
