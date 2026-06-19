---
title: Reject stale ferry location responses
type: reliability
date: 2026-06-17
status: completed
execution: code
---

# Reject stale ferry location responses

## Goal

Prevent an older overlapping ferry-location callback from replacing a newer
map position while preserving the existing visibility, timer, annotation, and
network boundaries.

## Requirements

- Assign a monotonic revision to every location request issued by the map.
- Publish a location only when its request revision still matches the latest
  issued revision and the map remains visible.
- Invalidate outstanding revisions when disappearance begins so callbacks from
  a prior appearance fail closed.
- Keep the acceptance decision in a pure app-target policy that can execute
  without UIKit, CoreLocation, Alamofire, or live ferry data.
- Preserve the 30-second refresh timer, weak callback ownership, main-thread UI
  publication, existing annotation filtering, and nil-location behavior.
- Add mutation-sensitive static contracts for policy behavior, controller
  delegation, project membership, runner cleanup, Make wiring, and completed
  plan evidence.

## Key Technical Decisions

- Reuse the existing schedule-response policy shape: a small production Swift
  function plus a standalone executable harness when `swiftc` is available.
- Increment the location revision before each API request and again when the
  map disappears. This rejects both out-of-order overlapping responses and
  callbacks owned by a previous appearance without changing the API client.
- Keep visibility in the controller guard because it is UIKit lifecycle state;
  the pure policy owns only revision equality.

## Implementation Units

### U1. Location response policy

**Files:** `Larkspur Ferry/LocationResponsePolicy.swift`,
`Tests/LocationResponsePolicyTests/main.swift`

Add a pure revision-equality policy and executable cases for current, older,
newer, zero, and disappearance-invalidated revisions.

### U2. Map lifecycle integration

**Files:** `Larkspur Ferry/MapViewController.swift`,
`Larkspur Ferry.xcodeproj/project.pbxproj`

Issue and capture a revision for each request, invalidate it during
`viewWillDisappear`, and require both current revision and visibility before
publishing map state.

### U3. Maintained verification contract

**Files:** `Makefile`, `scripts/check-baseline.py`,
`scripts/run-location-response-policy-tests.sh`, `README.md`, `SECURITY.md`,
`VISION.md`, `CHANGES.md`, and this plan

Run the policy harness from every Make gate when `swiftc` is available, retain
truthful skips on this Linux host, and protect the source, test, project,
runner, documentation, and completed-plan evidence against weakening.

## Verification Strategy

- Run all four Make aliases from the repository root and the absolute Makefile
  gate from `/tmp` with the explicit legacy-Xcode skip.
- Exercise runner success, compiler failure, signal cleanup, and temporary
  binary cleanup without requiring Xcode or live ferry data.
- Reject isolated mutations to revision equality, controller capture and
  invalidation, project membership, executable cases, Make wiring, runner
  cleanup, documentation, and plan status.
- Audit the exact intended diff, shell and Python syntax, generated artifacts,
  file modes, conflict markers, and credential-like additions before commit.

## Scope Boundaries

- Do not change ferry API requests, retry behavior, timer cadence, map styling,
  schedule or geocode policies, CocoaPods, deployment targets, or the legacy UI
  test target.
- Do not claim simulator, device, live ferry API, CoreLocation, or Xcode
  execution from Linux.

## Work Completed

- Added a pure location-response revision policy to the app target and a
  standalone five-case executable harness.
- Assigned and captured a monotonic revision for every map-location request,
  invalidated ownership during disappearance, and required current revision
  plus visibility before map publication.
- Extended every Make alias, the maintained baseline, project metadata, and
  repository guidance with the new response-ownership contract.

## Verification Completed

- All four Make gates passed from the repository root with the unavailable
  `swiftc` and Xcode boundaries reported truthfully.
- The external absolute Makefile gate passed from `/tmp` with
  `SKIP_XCODE_BUILD=1`.
- Controlled fake-compiler probes proved successful execution, exit-7 compiler
  failure propagation, signal-143 handling, and temporary-build cleanup.
- Nine isolated hostile mutations were rejected across revision equality,
  controller delegation, disappearance invalidation, project membership,
  executable cases, runner cleanup, Make wiring, documentation, and
  completed-plan evidence.
- Shell and Python syntax, exact diff, generated-artifact, file-mode,
  conflict-marker, and changed-line credential-pattern audits passed.
- `swiftc`, CocoaPods, and Xcode are unavailable on this Linux host, so native
  Swift compilation, simulator/device behavior, live ferry data, and UI test
  execution were not claimed.
