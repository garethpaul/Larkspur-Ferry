---
title: Stale Geocode Direction Guard
date: 2026-06-15
status: completed
execution: code
---

## Context

Reverse geocoding starts from the initial location flow, but its callback can
arrive after the user manually changes ferry direction. Publishing that stale
callback overwrites the newer direction, images, and schedule request. Comparing
only the direction string is insufficient because two taps can return to the
same value before the callback arrives.

## Requirements

- Increment a monotonic revision whenever the user manually changes direction.
- Capture the revision when the initial location lookup starts, before a manual
  tap can precede the first location sample or reverse-geocoding request.
- Ignore every geocoder completion whose captured revision no longer matches,
  before publishing success or fallback behavior.
- Preserve canonical placemark direction alignment, location-update shutdown,
  and stale schedule-response rejection.
- Add mutation-sensitive static contracts and synchronized documentation.

## Non-Goals

- Replacing Core Location, changing locality rules, or changing ferry API
  behavior.
- Retaining or explicitly cancelling the geocoder.
- Modernizing the legacy Swift or Xcode project.
- Claiming simulator, device, live geocoder, or live ferry API execution from
  Linux.

## Verification Plan

- Run Python and shell syntax checks, all four Make gates, and the
  external-directory Make gate.
- Reject isolated revision state, tap increment, lookup snapshot, callback
  handoff, publication guard, ordering, documentation, and plan-evidence
  mutations.
- Audit the exact diff, generated artifacts, protected project/workflow files,
  whitespace, conflict markers, binaries, and changed-line credential patterns.
- Capture one bounded exact-head pull-request and security snapshot after push.

## Work Completed

- Added a monotonic manual-direction revision and incremented it before either
  tap branch can publish a new direction.
- Captured the revision when the initial location lookup starts and carried it
  into a weakly captured reverse-geocoding completion.
- Rejected stale completions before either fallback schedule loading or
  placemark-driven direction publication.
- Added ordering-sensitive static contracts and synchronized repository
  guidance.

## Verification Completed

- All four Make gates passed with the explicit `SKIP_XCODE_BUILD=1` boundary.
- The external-directory Make gate passed through the absolute Makefile path.
- Python compilation and POSIX shell syntax validation passed without retaining
  generated artifacts.
- Eight isolated hostile mutations covering revision state, tap increment,
  lookup snapshot, callback handoff, publication guard, ordering,
  documentation, and plan evidence were rejected.
- `git diff --check`, generated-artifact inspection, protected project/workflow
  inspection, binary review, and changed-line credential-pattern review passed.
- CocoaPods, xcodebuild, simulator, device, live geocoder, and live ferry API
  execution remain unavailable on this Linux host and are not claimed.
