---
title: Location Direction Alignment
date: 2026-06-14
status: planned
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

Pending implementation.

## Verification Completed

Pending implementation and verification.
