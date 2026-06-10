# Map Refresh Failure Preserves Pin

status: completed

## Context

The map screen refreshes ferry location data on a timer. Removing the existing
ferry annotation before the API response succeeds can leave the map with no
ferry pin after a transient map-location refresh failure.

## Completed Scope

- Moved ferry annotation cleanup into the successful main-thread refresh path.
- Preserved the last known ferry pin when the map-location API returns no
  location.
- Kept stale ferry pin replacement targeted to `CustomPointAnnotation` values.
- Extended the static baseline and docs so failed map-location refresh handling
  remains explicit without Xcode.

## Verification

- `make lint`
- `make test`
- `make build`
- `make check`
- `git diff --check`
