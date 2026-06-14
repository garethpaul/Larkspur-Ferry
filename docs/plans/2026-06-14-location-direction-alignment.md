---
title: Location Direction Alignment
date: 2026-06-14
status: completed
execution: code
---

## Context

Reverse geocoding may complete after the user has manually switched the ferry
direction. The non-Larkspur branch assigns `f = "San Francisco"`, but the
Larkspur branch only changes images. That can leave the visible direction and
the subsequent `getBoats()` request using different origins.

## Requirements

- Assign the canonical schedule origin in both placemark branches before image
  updates and before `getBoats()` is called.
- Preserve the existing locality rule, image choices, fallback paths, request
  cancellation boundaries, and stale schedule callback guard.
- Add a mutation-sensitive static contract for branch assignment and ordering.
- Synchronize repository guidance and record truthful verification evidence.

## Non-Goals

- Replacing Core Location or adding a geocoder cancellation/generation system.
- Changing the ferry locality product rule or schedule API.
- Modernizing the legacy Swift or Xcode project.
- Claiming simulator, device, live geocoder, or live ferry API execution from
  Linux.

## Verification Plan

- Run Python syntax checks, all four Make gates, and the external-directory Make
  gate.
- Reject mutations that remove either canonical assignment, move assignment
  after image mutation or schedule fetch, weaken documentation, or falsify plan
  completion evidence.
- Audit the exact diff, generated artifacts, protected project/workflow files,
  whitespace, conflict markers, and changed-line credential patterns.
- Take one bounded exact-head pull-request and security-alert snapshot without
  polling.

## Work Completed

- Assigned `f = "Larkspur"` in the Larkspur placemark branch, matching the
  existing canonical San Francisco assignment.
- Enforced that both canonical direction assignments precede their image
  mutations and the shared schedule fetch.
- Added a mutation-sensitive static contract and synchronized repository
  guidance without changing the locality rule or API behavior.

## Verification Completed

- Python syntax and all four Make gates passed with the hosted-equivalent
  `SKIP_XCODE_BUILD=1` boundary; the external-directory Make gate also passed.
- Six hostile mutations were rejected across Larkspur assignment, San Francisco
  assignment, assignment ordering, image contract, documentation, and completed
  plan evidence weakening.
- Exact diff, generated-artifact, protected project/workflow, whitespace,
  conflict-marker, and changed-line credential audits passed.
- xcodebuild and the legacy CocoaPods workspace were unavailable on Linux, so no
  simulator, device, geocoder, or live ferry API behavior is claimed.
- The hosted pull-request and security-alert result is recorded against the
  exact pushed head in the external engineering tracker.
