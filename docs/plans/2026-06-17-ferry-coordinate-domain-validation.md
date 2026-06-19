---
title: Reject invalid ferry coordinate domains
type: reliability
date: 2026-06-17
status: completed
execution: code
---

# Reject invalid ferry coordinate domains

## Goal

Prevent numeric but non-finite or out-of-range ferry coordinates from reaching
`CLLocation` and MapKit while preserving the existing API, refresh, response
revision, and map-publication behavior.

## Requirements

- Accept finite latitude values from -90 through 90 degrees inclusive.
- Accept finite longitude values from -180 through 180 degrees inclusive.
- Reject NaN, positive or negative infinity, and values outside either range.
- Apply the guard after locale-independent numeric parsing and before creating
  a `CLLocation`.
- Keep the coordinate-domain decision in the existing pure app-target location
  policy so it remains executable without UIKit, CoreLocation, Alamofire, or
  live ferry data.
- Add mutation-sensitive executable and static contracts for boundaries,
  non-finite values, API integration, documentation, and completed evidence.

## Key Technical Decisions

- Extend `LocationResponsePolicy.swift` rather than adding another app source.
  The file already belongs to the app target and its standalone runner, which
  avoids unrelated Xcode project changes.
- Validate parsed `Double` values directly. String parsing remains responsible
  only for syntax and locale independence; the new policy owns geographic
  domain validity.
- Preserve the current nil-result contract. Invalid coordinates complete with
  `nil`, leaving the last successfully published ferry annotation untouched.

## Implementation Units

### U1. Pure coordinate policy and executable cases

**Files:** `Larkspur Ferry/LocationResponsePolicy.swift`,
`Tests/LocationResponsePolicyTests/main.swift`

Add the finite/range predicate and cases for normal coordinates, exact
boundaries, each out-of-range direction, NaN, and both infinities.

### U2. API integration

**Files:** `Larkspur Ferry/API.swift`

Require the parsed latitude and longitude to satisfy the pure policy before
constructing `CLLocation`; otherwise complete with `nil` through the existing
guard path.

### U3. Maintained verification contract

**Files:** `scripts/check-baseline.py`, `README.md`, `SECURITY.md`, `VISION.md`,
`CHANGES.md`, and this plan

Protect the policy expression, API ordering, executable cases, repository
guidance, and truthful completed-plan evidence against isolated weakening.

## Verification Strategy

- Run the location policy harness when `swiftc` is available and the maintained
  baseline on this host regardless of toolchain availability.
- Run `make check` from the repository root and via the absolute Makefile from
  an external directory with the documented Xcode skip.
- Reject isolated mutations to finiteness, latitude bounds, longitude bounds,
  API delegation, executable edge cases, documentation, and plan completion.
- Audit the exact intended diff, Python syntax, generated artifacts, file modes,
  conflict markers, and credential-like additions before commit.

## Scope Boundaries

- Do not change ferry endpoint construction, response validation, retry or
  timeout behavior, timer cadence, response revisions, annotations, schedule
  parsing, geocoding, dependencies, deployment targets, or UI tests.
- Do not claim simulator, device, live ferry API, CoreLocation, or Xcode
  execution from Linux.

## Work Completed

- Added a pure finite/range predicate to the existing app-target location
  policy.
- Required parsed ferry coordinates to pass the predicate before `CLLocation`
  construction, preserving the existing nil-result behavior on rejection.
- Added executable boundary, out-of-range, NaN, and infinity cases and static
  contracts for the production policy, API ordering, tests, documentation, and
  completed evidence.

## Verification Completed

- A pre-completion isolated snapshot passed `make check` from its repository
  root and the absolute external-directory Make gate with
  `SKIP_XCODE_BUILD=1`.
- The finalized worktree passed all four repository-root Make gates and the
  absolute external-directory Make gate with `SKIP_XCODE_BUILD=1`.
- Eight isolated hostile mutations were rejected across both finiteness
  clauses, latitude and longitude ranges, API delegation, an executable edge
  case, changelog evidence, and plan completion.
- Python syntax and `git diff --check` passed before final repository gates.
- `swiftc`, CocoaPods, and Xcode are unavailable on this Linux host, so native
  Swift compilation, simulator/device behavior, live ferry data, CoreLocation,
  and UI test execution are not claimed.
