# Transit Data Source And Freshness

This repository is a legacy sample. Its checked-in `API.swift` sends requests
to the `FerryAPIBaseURL` value in `Larkspur Ferry/Info.plist`. The checked-in
value is `https://requestlabs.appspot.com/`, a project-specific proxy endpoint
that is not identified in this repository as an official Golden Gate Ferry
data source. The repository does not identify the proxy's upstream provider,
update process, owner, service-level expectations, or continued availability.

## Request Surfaces

- Schedule rows come from `ferry/larkspur?from=` with the selected origin set to
  either `Larkspur` or `San Francisco`. The app requests a schedule during its
  initial direction flow and after the user changes direction; it does not run
  a periodic schedule refresh.
- The map requests `ferry/location?t=1` immediately when the map appears and
  every 30 seconds while the map is visible. Polling stops when the map begins
  disappearing.

Both request paths use `reloadIgnoringLocalCacheData`, require a successful JSON
response, and use a 10-second request timeout. These client controls avoid a
local URL-cache response and bound each attempt, but they do not prove that the
proxy or its upstream data is current.

Schedule parsing accepts a genuine empty array and retains valid rows from a
mixed payload. An all-malformed schedule response is treated as request failure
so invalid provider data cannot masquerade as an empty timetable and erase
same-direction departures that were already displayed.

## Freshness Boundary

The response shape does not expose a server timestamp, feed version, source
attribution, or last-updated value. The app therefore has no freshness guarantee
for schedule rows or ferry coordinates and cannot display the age of accepted
data.

On a same-direction schedule failure, the app preserves already visible rows;
after a direction change, it clears rows owned by the previous origin. A failed
map refresh preserves the last known ferry pin. Those continuity behaviors are
not evidence that retained data remains current.

Treat all displayed information as sample output. Verify current service
information independently before travel using an authoritative transit source.
Do not use this app for operational, safety-critical, or accessibility planning.

## Maintenance Rules

- Keep `FerryAPIBaseURL` absolute, HTTPS-only, credential-free, and free of a
  query string or fragment. Invalid or missing configuration stops requests
  before Alamofire is called.
- Document any endpoint, response-shape, polling, timeout, caching, or retained
  data change in this file and `CHANGES.md`.
- Keep source attribution factual; do not present the legacy proxy as an
  official or real-time feed without verifiable evidence.
- Add fixture or policy coverage before changing how stale, failed, or
  direction-mismatched responses are published.
- Preserve the empty, mixed, and all-malformed schedule response distinctions
  in the executable schedule policy harness.
