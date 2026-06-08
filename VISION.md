## Larkspur Ferry Vision

Larkspur Ferry is a Swift iOS app that displays ferry schedule and location
information, including a map view for the current ferry position.

The repository is useful as a transit app sample with Alamofire, map
annotations, schedule cells, UI tests, screenshots, and a CocoaPods workspace.
Project context lives in [`README.md`](README.md).

The goal is to keep the app useful, verifiable, and clear about its data source.

The current focus is:

Priority:

- Preserve ferry schedule and map-location flows
- Keep API endpoint behavior visible and documented
- Maintain screenshot, build script, and UI test context
- Avoid committing private endpoints, keys, or generated signing files

Next priorities:

- Move API base URL into documented configuration
- Add tests or fixtures for schedule parsing and location handling
- Modernize Swift, Alamofire, and project settings in a dedicated pass
- Document current transit-data source and freshness expectations

Contribution rules:

- One PR = one focused API, map, schedule, build, or documentation change.
- Verify app behavior after map or API changes.
- Keep generated signing files and local paths out of git.
- Update docs when endpoint or response shapes change.

## Security And Data

Canonical security policy and reporting:

- [`SECURITY.md`](SECURITY.md)


Transit data should be accurate and sourced. Endpoint changes should use HTTPS,
handle failures visibly, and avoid exposing private credentials.

## What We Will Not Merge (For Now)

- Hardcoded private API credentials
- Schedule/location changes without data-source notes
- Broad Swift migration bundled with transit behavior changes
- Generated signing material or local paths

This list is a roadmap guardrail, not a permanent rule.
Strong user demand and strong technical rationale can change it.
