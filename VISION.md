## Larkspur Ferry Vision

This document explains the current state and direction of the project.
Project overview and developer docs: [`README.md`](README.md)

Larkspur Ferry is a Swift iOS app that displays ferry schedule and location
information, including a map view for the current ferry position.

The repository is useful as a transit app sample with Alamofire, map
annotations, schedule cells, UI tests, screenshots, and a CocoaPods workspace.
Project context lives in [`README.md`](README.md).

The goal is to keep the app useful, verifiable, and clear about its data source.

Current baseline: `make lint`, `make test`, `make build`, and `make check` run
the API base URL, schedule response, and location response Swift harnesses,
`scripts/check-baseline.py`, and the guarded `build.sh` path to verify the
production callback decisions, build script, CocoaPods metadata, Swift API
parsing, single-shot location fallbacks, project assets, generated metadata
ignores, and documentation.

The current focus is:

Priority:

- Preserve ferry schedule and map-location flows
- Keep API endpoint behavior visible and documented
- Keep the legacy transit proxy, request cadence, retained-data behavior, and
  lack of a server timestamp documented without implying official or real-time
  data
- Validate successful JSON ferry responses with a 10-second uncached request
- Treat an all-malformed schedule response as failure while preserving genuine
  empty arrays and valid rows from mixed payloads
- Keep API request construction on deterministic query parameter ordering
- Keep locale-independent coordinate parsing for ferry API latitude and longitude values
- Reject non-finite and out-of-range ferry coordinates before MapKit publication
- Keep POSIX schedule time parsing for fixed-format ferry API departure values
- Keep main-thread UI updates for schedule table and map API callbacks
- Keep revision-aware ferry-location callbacks that reject older overlapping
  responses and callbacks invalidated when the map begins disappearing before
  publishing MapKit state
- Reject a stale schedule response after the user selects a newer direction
- Execute the revision-aware schedule response guard so tap-away-and-back
  callbacks from older revisions and older same-origin schedule requests remain
  rejected
- Keep malformed API payloads and unavailable location data from crashing the app
- Keep initial direction lookup as a single-shot location flow that stops updates before empty-sample or failure fallback
- Keep location-derived direction state aligned with the canonical schedule
  origin before image and schedule publication
- Reject a stale geocoder completion after a newer manual direction change
- Keep the map refresh timer tied to the map screen lifecycle
- Keep ferry annotation refresh targeted to stale ferry pins
- Keep failed map-location refresh responses from clearing the last known ferry pin
- Keep `make lint`, `make test`, `make build`, and `make check` available as
  local verification gates
- Keep hosted validation pinned, credential-free, and read-only on macOS through
  production policy execution, project parsing, and the explicit
  `SKIP_XCODE_BUILD=1` legacy-build boundary
- Maintain screenshot, build script, and UI test context
- Avoid committing private endpoints, keys, or generated signing files
- Keep the configured ferry API base URL HTTPS-only, credential-free, and
  covered by the standalone Swift policy harness

Next priorities:

- Add further fixtures for location payload handling
- Modernize Swift, Alamofire, and project settings in a dedicated pass
- Require endpoint or refresh changes to update the transit-data source and
  freshness contract

Contribution rules:

- One PR = one focused API, map, schedule, build, or documentation change.
- Verify app behavior after map or API changes.
- Run `make lint`, `make test`, `make build`, and `make check` before pushing
  API, location, build, plist, storyboard, asset, or documentation changes.
- Keep generated signing files and local paths out of git.
- Update docs when endpoint or response shapes change.
- Preserve single-shot location lookup handling when changing the direction flow.
- Preserve map refresh timer lifecycle handling when changing the map flow.
- Preserve main-thread UI updates when changing schedule table or map callbacks.

## Security And Data

Canonical security policy and reporting:

- [`SECURITY.md`](SECURITY.md)

Transit data should be accurate and sourced. Endpoint changes should use HTTPS,
handle failures visibly, and avoid exposing private credentials.
Location should remain user-authorized, optional, and backed by schedule-loading
fallbacks when unavailable.

## What We Will Not Merge (For Now)

- Hardcoded private API credentials
- Schedule/location changes without data-source notes
- Broad Swift migration bundled with transit behavior changes
- Generated signing material or local paths

This list is a roadmap guardrail, not a permanent rule.
Strong user demand and strong technical rationale can change it.
