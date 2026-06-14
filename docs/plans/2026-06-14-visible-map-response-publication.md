# Visible Map Response Publication

status: completed

## Context

The map timer is invalidated when the screen disappears, but a location request
already in flight can still complete while the navigation stack retains the
controller. Its success callback can then recenter and mutate an off-screen map.

## Requirements

- Track whether the map screen is currently visible.
- Set visibility before starting refresh work and clear it before invalidating
  the timer during disappearance.
- Publish a successful response only after reaching the main queue and proving
  that the map is still visible.
- Preserve weak capture, successful-response-only replacement, and unrelated
  annotation behavior.
- Add mutation-sensitive static contracts and matching documentation.

## Scope Boundaries

- Do not change request timing, API payload parsing, map geometry, dependencies,
  or the existing stale schedule-response behavior.

## Verification

- Run all Make gates, the external-directory gate, syntax/metadata checks,
  isolated hostile mutations, and exact diff/secret/artifact audits.

## Work Completed

- Added explicit map visibility state around the existing timer lifecycle.
- Cleared visibility before invalidating refresh work during disappearance.
- Required visibility on the main queue before replacing annotations or
  recentering the map after a successful location response.
- Added ordering-sensitive static contracts and matching user documentation.

## Verification Completed

- all four Make gates passed; the guarded legacy build truthfully skipped
  unavailable CocoaPods/Xcode execution on Linux.
- The absolute-Makefile check from `/tmp`, Python checker compilation, build
  script shell syntax, project metadata parsing, and `git diff --check` passed.
- Six isolated hostile mutations were rejected for missing state, missing
  appear/disappear assignments, missing publication guard, mutation before the
  visibility guard, and incomplete plan evidence.
- The exact intended diff passed secret-pattern, conflict-marker,
  generated-artifact, binary, large-file, and unrelated-path audits.
