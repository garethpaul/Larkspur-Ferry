# Larkspur Ferry Baseline Plan

status: completed

## Context

`Larkspur-Ferry` is a legacy Swift 3 iOS transit app with a CocoaPods-managed
Alamofire dependency, a ferry schedule table, a location-assisted direction
toggle, a map view for ferry position, UI tests, screenshots, and a shell build
script. This Linux host does not provide CocoaPods or Xcode, so local
verification needs a static baseline while full app builds remain a macOS/Xcode
responsibility.

## Objectives

- Keep the build script POSIX-compatible and non-failing on hosts without CocoaPods or Xcode.
- Avoid force-unwrapping malformed API schedule and location data.
- Avoid force-unwrapping user location and geocoder responses.
- Remove app debug logging from network and location failure paths.
- Fall back to schedule loading when location authorization or geocoding is unavailable.
- Remove generated `.DS_Store` metadata from the tracked asset catalog.
- Add a local `make check` baseline for Swift guardrails, plists, storyboards, assets, Podfile metadata, docs, and build-script syntax.

## Verification

- `make check`
- `python3 scripts/check-baseline.py`
- `sh -n build.sh`
- `git diff --check`
