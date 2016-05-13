#!/bin/sh

set -eu

function ci_build() {
    NAME=$1
    pod install
    xcodebuild -workspace "Larkspur Ferry.xcworkspace" \
               -scheme "Larkspur Ferry" \
               -destination "platform=iOS Simulator,name=${NAME}" \
               -sdk iphonesimulator \
               -configuration "Debug" \
               build
}

function ci_test() {
    NAME=$1

    pod install
    xcodebuild -workspace "Larkspur Ferry.xcworkspace" \
               -scheme "Larkspur FerryUITests" \
               -destination "platform=iOS Simulator,name=${NAME}" \
               -sdk iphonesimulator \
               -configuration "Debug" \
               test
}



ci_build "iPhone 5"
